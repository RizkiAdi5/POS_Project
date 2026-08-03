'use strict';

const db = require('../../db');
const { limit } = require('../../util/dates');
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
    clauses.push('TRIM(CATEGORY) = ?');
    binds.push(String(params.category).trim());
  }
  if (params.halal_only === true || params.halal_only === 'true' || params.halal_only === 1) {
    clauses.push("is_halal = 'T'");
  }
  if (params.vegetarian_only === true || params.vegetarian_only === 'true' || params.vegetarian_only === 1) {
    clauses.push("is_veg = 'T'");
  }
  if (params.spicy_only === true || params.spicy_only === 'true' || params.spicy_only === 1) {
    clauses.push("is_spicy = 'T'");
  }
  if (params.featured_only === true || params.featured_only === 'true' || params.featured_only === 1) {
    clauses.push("is_feat = 'T'");
  }
  if (params.keyword && String(params.keyword).trim()) {
    const kw = '%' + String(params.keyword).trim().slice(0, 80) + '%';
    clauses.push('(DESP LIKE ? OR COALESCE(`comment`,\'\') LIKE ? OR CATEGORY LIKE ?)');
    binds.push(kw, kw, kw);
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

  binds.push(n);

  const promoSelect = cols.hasPromoPrice ? 'COALESCE(promo_price, 0) AS promo_price,' : '0 AS promo_price,';
  const allergenSelect = cols.hasAllergens ? 'COALESCE(allergens, \'\') AS allergens,' : '\'\' AS allergens,';

  const rows = await db.runQuery(dts, `
    SELECT ITEMNO AS item_code, DESP AS display_name, CATEGORY AS category, sub_cat AS sub_category,
           PRICE AS price, ${promoSelect}
           is_halal, is_veg AS is_vegetarian, is_spicy, is_feat AS is_featured,
           ${allergenSelect}
           COALESCE(\`comment\`, '') AS description,
           COALESCE(prep_time, 0) AS prep_time
    FROM icitem
    WHERE ${clauses.join(' AND ')}
    ORDER BY ${cols.hasPromoPrice ? effectivePriceExpr() : 'COALESCE(PRICE, 0)'} ASC, sort_ord ASC, DESP ASC
    LIMIT ?
  `, binds);

  const items = rows.map((r) => mapMenuRow(r, currency));

  const notes = [];
  if (excludeAllergens.length && !cols.hasAllergens) {
    notes.push('Allergen column not available on menu; only dietary flags (halal/vegetarian) were applied.');
  }
  if (maxPriceIgnored) {
    notes.push(
      `Price cap ${ignoredMaxPrice} is unrealistically low for ${currency.code || 'this currency'}; showing lowest-priced dishes instead.`
    );
  }

  return withCurrency(dts, {
    filter: {
      category: params.category || null,
      keyword: params.keyword || null,
      max_price: maxPrice,
      min_price: minPrice,
      exclude_allergens: excludeAllergens,
      halal_only: !!params.halal_only,
      vegetarian_only: !!params.vegetarian_only,
      spicy_only: !!params.spicy_only,
      featured_only: !!params.featured_only,
      budget_mode: !!maxPriceIgnored,
    },
    count: items.length,
    items,
    empty: items.length === 0,
    note: notes.length ? notes.join(' ') : null,
  });
}

module.exports = {
  getMenuColumns,
  queryMenu,
  parsePriceParam,
  sanitizeMaxPrice,
  parseAllergenList,
  expandAllergenTokens,
  mapMenuRow,
};
