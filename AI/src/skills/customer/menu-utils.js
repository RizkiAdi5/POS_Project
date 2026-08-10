'use strict';

const db = require('../../db');
const { limit, days: clampDays } = require('../../util/dates');
const { getCompanyCurrency, roundMoney, withCurrency } = require('../../util/currency');

const columnCache = new Map();

async function getMenuColumns(dts) {
  if (columnCache.has(dts)) return columnCache.get(dts);
  const cols = {
    hasAllergens: false,
    hasPromoPrice: false,
  };
  try {
    const rows = await db.runQuery(dts, `
      SELECT COLUMN_NAME
      FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'icitem'
    `);
    const names = new Set(rows.map((r) => String(r.COLUMN_NAME || '').toLowerCase()));
    cols.hasAllergens = names.has('allergens');
    cols.hasPromoPrice = names.has('promo_price');
  } catch (_) {
    /* use defaults */
  }
  columnCache.set(dts, cols);
  return cols;
}

function truthyFlag(v) {
  return v === 'T' || v === 't' || v === 1 || v === true;
}

const categoryCache = new Map();

/** Distinct e-menu category names for this branch, used to steer the router's category param onto a real value. */
async function getAvailableCategories(dts) {
  if (categoryCache.has(dts)) return categoryCache.get(dts);
  let categories = [];
  try {
    const rows = await db.runQuery(dts, `
      SELECT DISTINCT TRIM(CATEGORY) AS category
      FROM icitem
      WHERE is_avail = 'T' AND CATEGORY IS NOT NULL AND TRIM(CATEGORY) <> ''
      ORDER BY category
    `);
    categories = rows.map((r) => String(r.category || '').trim()).filter(Boolean);
  } catch (_) {
    /* use empty list */
  }
  categoryCache.set(dts, categories);
  return categories;
}

/**
 * Tri-state dietary flag: true = only matching items, false = only NON-matching
 * items (explicit negation, e.g. "not halal"), null/undefined = no filter.
 */
function triState(v) {
  if (v === true || v === 'true' || v === 1 || v === '1') return true;
  if (v === false || v === 'false' || v === 0 || v === '0') return false;
  return null;
}

function effectivePriceExpr() {
  return `(
    CASE
      WHEN COALESCE(promo_price, 0) > 0 AND COALESCE(promo_price, 0) < COALESCE(PRICE, 0)
      THEN COALESCE(promo_price, 0)
      ELSE COALESCE(PRICE, 0)
    END
  )`;
}

function parsePriceParam(params, keys, currency) {
  const keyList = Array.isArray(keys) ? keys : [keys];
  for (const key of keyList) {
    if (params && params[key] != null && params[key] !== '') {
      const x = parseFloat(params[key]);
      if (Number.isFinite(x) && x >= 0) {
        return roundMoney(x, currency);
      }
    }
  }
  return null;
}

/**
 * Guard against router inventing MYR-style caps (e.g. 20) for zero-decimal currencies (IDR).
 * Rp 20 is never a real restaurant budget — treat as "show cheapest" instead.
 */
function sanitizeMaxPrice(maxPrice, currency) {
  if (maxPrice == null) return { maxPrice: null, ignored: false };
  const decimals = currency && Number.isFinite(currency.decimals) ? currency.decimals : 2;
  if (decimals === 0 && maxPrice > 0 && maxPrice < 1000) {
    return { maxPrice: null, ignored: true, ignored_value: maxPrice };
  }
  return { maxPrice, ignored: false };
}

/**
 * Splits a keyword ask into individual search terms so "bread or pastry" /
 * "bread, pastry" matches EITHER word instead of being LIKE'd as one literal
 * phrase that appears nowhere in the menu text. Accepts a string or an array
 * (the router is encouraged to send an array of expanded terms directly).
 */
function parseKeywordTerms(raw) {
  if (!raw) return [];
  const items = Array.isArray(raw)
    ? raw
    : String(raw).split(/\s*(?:,|\/|;|\bor\b|\band\b)\s*/i);
  return items
    .map((s) => String(s).trim())
    .filter(Boolean)
    .slice(0, 6);
}

function parseAllergenList(raw) {
  if (!raw) return [];
  if (Array.isArray(raw)) {
    return raw.map((s) => String(s).trim().toLowerCase()).filter(Boolean);
  }
  return String(raw)
    .toLowerCase()
    .split(/[,;|/]+/)
    .map((s) => s.trim())
    .filter(Boolean);
}

const ALLERGEN_ALIASES = {
  nut: ['nut', 'nuts', 'peanut', 'peanuts', 'tree nut', 'almond', 'walnut'],
  dairy: ['dairy', 'milk', 'lactose', 'cheese', 'cream'],
  gluten: ['gluten', 'wheat', 'barley', 'rye'],
  egg: ['egg', 'eggs'],
  soy: ['soy', 'soya'],
  shellfish: ['shellfish', 'prawn', 'prawns', 'shrimp', 'crab', 'lobster', 'seafood'],
  fish: ['fish', 'ikan'],
  sesame: ['sesame'],
};

function expandAllergenTokens(tokens) {
  const out = new Set();
  tokens.forEach((t) => {
    out.add(t);
    Object.keys(ALLERGEN_ALIASES).forEach((key) => {
      const aliases = ALLERGEN_ALIASES[key];
      if (aliases.some((a) => t.includes(a) || a.includes(t))) {
        aliases.forEach((a) => out.add(a));
      }
    });
  });
  return [...out];
}

function normalizeSort(raw) {
  const v = String(raw || '').toLowerCase().trim();
  if (['popularity_high', 'popular', 'best_selling', 'most_ordered'].includes(v)) return 'popularity_high';
  if (['popularity_low', 'least_popular', 'not_recommended', 'low_demand', 'rarely_ordered'].includes(v)) return 'popularity_low';
  if (['price_desc', 'price_high', 'most_expensive', 'expensive', 'priciest', 'highest_price'].includes(v)) return 'price_desc';
  return 'price_asc';
}

/**
 * Order counts per item over a trailing window, keyed both by item_code and
 * lowercased item name — icitem/app_order_items linkage is inconsistent across
 * branches so callers should try item_code first and fall back to name.
 */
async function getOrderCounts(dts, days) {
  const rows = await db.runQuery(dts, `
    SELECT i.item_code AS item_code, i.item_name AS item_name, COUNT(*) AS times_ordered
    FROM app_order_items i
    INNER JOIN app_orders o ON o.order_id = i.order_id
    WHERE o.status NOT IN ('cancelled')
      AND o.created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)
    GROUP BY i.item_code, i.item_name
  `, [days]);
  const byCode = new Map();
  const byName = new Map();
  rows.forEach((r) => {
    const count = parseInt(r.times_ordered, 10) || 0;
    if (r.item_code != null && String(r.item_code).trim()) byCode.set(String(r.item_code).trim(), count);
    if (r.item_name != null && String(r.item_name).trim()) byName.set(String(r.item_name).trim().toLowerCase(), count);
  });
  return { byCode, byName };
}

function lookupOrderCount(counts, itemCode, itemName) {
  const code = itemCode != null ? String(itemCode).trim() : '';
  if (code && counts.byCode.has(code)) return counts.byCode.get(code);
  const name = String(itemName || '').trim().toLowerCase();
  if (name && counts.byName.has(name)) return counts.byName.get(name);
  return 0;
}

function mapMenuRow(r, currency) {
  const price = parseFloat(r.price) || 0;
  const promo = parseFloat(r.promo_price) || 0;
  const effective = promo > 0 && promo < price ? promo : price;
  const item = {
    name: String(r.display_name || '').trim(),
    category: String(r.category || '').trim(),
    price: roundMoney(effective, currency),
    was_price: promo > 0 && promo < price ? roundMoney(price, currency) : null,
    halal: truthyFlag(r.is_halal),
    vegetarian: truthyFlag(r.is_vegetarian),
    spicy: truthyFlag(r.is_spicy),
    featured: truthyFlag(r.is_featured),
    prep_minutes: parseInt(r.prep_time, 10) || 0,
    description: String(r.description || '').trim().slice(0, 200),
  };
  if (r.allergens != null && String(r.allergens).trim()) {
    item.allergens = String(r.allergens).trim();
  }
  return item;
}

async function queryMenu({ dts, params, defaultLimit }) {
  const currency = await getCompanyCurrency(dts);
  const cols = await getMenuColumns(dts);
  const n = limit(params, defaultLimit || 12);
  const clauses = ["is_avail = 'T'"];
  const binds = [];

  if (params.category && String(params.category).trim()) {
    clauses.push('LOWER(TRIM(CATEGORY)) = LOWER(?)');
    binds.push(String(params.category).trim());
  }
  const halalState = triState(params.halal_only);
  if (halalState === true) clauses.push("is_halal = 'T'");
  else if (halalState === false) clauses.push("COALESCE(is_halal, '') <> 'T'");

  const vegState = triState(params.vegetarian_only);
  if (vegState === true) clauses.push("is_veg = 'T'");
  else if (vegState === false) clauses.push("COALESCE(is_veg, '') <> 'T'");

  const spicyState = triState(params.spicy_only);
  if (spicyState === true) clauses.push("is_spicy = 'T'");
  else if (spicyState === false) clauses.push("COALESCE(is_spicy, '') <> 'T'");

  if (params.featured_only === true || params.featured_only === 'true' || params.featured_only === 1) {
    clauses.push("is_feat = 'T'");
  }
  const keywordTerms = parseKeywordTerms(params.keyword);
  if (keywordTerms.length) {
    const orParts = [];
    keywordTerms.forEach((term) => {
      const clean = term.slice(0, 80).replace(/[%_]/g, '');
      const kw = '%' + clean + '%';
      orParts.push('DESP LIKE ?', 'COALESCE(`comment`,\'\') LIKE ?', 'CATEGORY LIKE ?');
      binds.push(kw, kw, kw);
      // SOUNDEX catches common misspellings (e.g. "bred" -> same code as "bread")
      // that a plain LIKE substring match would miss.
      if (clean.length >= 3) {
        orParts.push('SOUNDEX(DESP) = SOUNDEX(?)');
        binds.push(clean);
      }
    });
    clauses.push(`(${orParts.join(' OR ')})`);
  }

  const rawMaxPrice = parsePriceParam(params, ['max_price', 'max_price_rm'], currency);
  const { maxPrice, ignored: maxPriceIgnored, ignored_value: ignoredMaxPrice } = sanitizeMaxPrice(rawMaxPrice, currency);
  const minPrice = parsePriceParam(params, ['min_price', 'min_price_rm'], currency);
  if (maxPrice != null) {
    if (cols.hasPromoPrice) {
      clauses.push(`${effectivePriceExpr()} <= ?`);
    } else {
      clauses.push('COALESCE(PRICE, 0) <= ?');
    }
    binds.push(maxPrice);
  }
  if (minPrice != null) {
    if (cols.hasPromoPrice) {
      clauses.push(`${effectivePriceExpr()} >= ?`);
    } else {
      clauses.push('COALESCE(PRICE, 0) >= ?');
    }
    binds.push(minPrice);
  }

  const excludeAllergens = expandAllergenTokens(parseAllergenList(params.exclude_allergens));
  if (excludeAllergens.length && cols.hasAllergens) {
    excludeAllergens.forEach((token) => {
      const pat = '%' + token.replace(/[%_]/g, '') + '%';
      clauses.push(`(
        allergens IS NULL OR TRIM(allergens) = ''
        OR LOWER(allergens) NOT LIKE ?
      )`);
      binds.push(pat);
    });
  }

  // Positive lookup — guest is asking which dishes DO contain an allergen
  // (e.g. "what has nuts in it"), the opposite intent of exclude_allergens.
  const containsAllergens = expandAllergenTokens(
    parseAllergenList(params.contains_allergens || params.include_allergens)
  );
  if (containsAllergens.length && cols.hasAllergens) {
    const orParts = containsAllergens.map(() => 'LOWER(allergens) LIKE ?');
    clauses.push(`(${orParts.join(' OR ')})`);
    containsAllergens.forEach((token) => {
      binds.push('%' + token.replace(/[%_]/g, '') + '%');
    });
  } else if (containsAllergens.length && !cols.hasAllergens) {
    // No allergen data on this menu — force an empty result rather than
    // silently returning unrelated items that look like a safety answer.
    clauses.push('1 = 0');
  }

  const sortMode = normalizeSort(params.sort);
  const days = clampDays(params, 30);
  const isPopularitySort = sortMode === 'popularity_high' || sortMode === 'popularity_low';
  // Popularity sorting happens in JS after fetching a wider candidate set,
  // since it depends on order-history counts the SQL ORDER BY can't see.
  // Price sorting (either direction) is done directly in SQL below.
  const fetchCap = isPopularitySort ? Math.max(n, 200) : n;
  binds.push(fetchCap);

  const promoSelect = cols.hasPromoPrice ? 'COALESCE(promo_price, 0) AS promo_price,' : '0 AS promo_price,';
  const allergenSelect = cols.hasAllergens ? 'COALESCE(allergens, \'\') AS allergens,' : '\'\' AS allergens,';
  const priceDir = sortMode === 'price_desc' ? 'DESC' : 'ASC';

  const rows = await db.runQuery(dts, `
    SELECT ITEMNO AS item_code, DESP AS display_name, CATEGORY AS category, sub_cat AS sub_category,
           PRICE AS price, ${promoSelect}
           is_halal, is_veg AS is_vegetarian, is_spicy, is_feat AS is_featured,
           ${allergenSelect}
           COALESCE(\`comment\`, '') AS description,
           COALESCE(prep_time, 0) AS prep_time
    FROM icitem
    WHERE ${clauses.join(' AND ')}
    ORDER BY ${cols.hasPromoPrice ? effectivePriceExpr() : 'COALESCE(PRICE, 0)'} ${priceDir}, sort_ord ASC, DESP ASC
    LIMIT ?
  `, binds);

  let items = rows.map((r) => mapMenuRow(r, currency));

  if (isPopularitySort) {
    const counts = await getOrderCounts(dts, days);
    items = items.map((it, idx) => ({
      ...it,
      times_ordered: lookupOrderCount(counts, rows[idx].item_code, rows[idx].display_name),
    }));
    items.sort((a, b) => (sortMode === 'popularity_low' ? a.times_ordered - b.times_ordered : b.times_ordered - a.times_ordered));
    items = items.slice(0, n);
  }

  const notes = [];
  if (excludeAllergens.length && !cols.hasAllergens) {
    notes.push('Allergen column not available on menu; only dietary flags (halal/vegetarian) were applied.');
  }
  if (containsAllergens.length && !cols.hasAllergens) {
    notes.push('Allergen data is not recorded on this menu, so I cannot confirm which dishes contain it — please check with staff.');
  }
  if (maxPriceIgnored) {
    notes.push(
      `Price cap ${ignoredMaxPrice} is unrealistically low for ${currency.code || 'this currency'}; showing lowest-priced dishes instead.`
    );
  }
  if (sortMode === 'popularity_low') {
    notes.push(`Ranked by fewest orders in the last ${days} days — includes items that may simply be new or niche, not necessarily poor quality.`);
  }

  return withCurrency(dts, {
    filter: {
      category: params.category || null,
      keyword: params.keyword || null,
      keyword_terms: keywordTerms,
      max_price: maxPrice,
      min_price: minPrice,
      exclude_allergens: excludeAllergens,
      contains_allergens: containsAllergens,
      halal_only: halalState,
      vegetarian_only: vegState,
      spicy_only: spicyState,
      featured_only: !!params.featured_only,
      budget_mode: !!maxPriceIgnored,
      sort: sortMode,
      window_days: isPopularitySort ? days : null,
    },
    count: items.length,
    items,
    empty: items.length === 0,
    note: notes.length ? notes.join(' ') : null,
  });
}

module.exports = {
  getMenuColumns,
  getAvailableCategories,
  queryMenu,
  parsePriceParam,
  sanitizeMaxPrice,
  parseAllergenList,
  parseKeywordTerms,
  expandAllergenTokens,
  mapMenuRow,
  normalizeSort,
  getOrderCounts,
  lookupOrderCount,
};
