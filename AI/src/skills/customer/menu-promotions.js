'use strict';

const db = require('../../db');
const { limit } = require('../../util/dates');
const { getCompanyCurrency, roundMoney, withCurrency } = require('../../util/currency');

const icitemColumnCache = new Map();

async function getIcitemColumns(dts) {
  if (icitemColumnCache.has(dts)) return icitemColumnCache.get(dts);
  const cols = { hasPromoPrice: false };
  try {
    const rows = await db.runQuery(dts, `
      SELECT COLUMN_NAME
      FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'icitem'
    `);
    const names = new Set(rows.map((r) => String(r.COLUMN_NAME || '').toLowerCase()));
    cols.hasPromoPrice = names.has('promo_price');
  } catch (_) {
    /* use defaults */
  }
  icitemColumnCache.set(dts, cols);
  return cols;
}

function truthyFlag(v) {
  return v === 'T' || v === 't' || v === 1 || v === true;
}

function mapPromoRow(r, currency) {
  const price = parseFloat(r.price) || 0;
  const promo = parseFloat(r.promo_price) || 0;
  const savings = price > promo ? roundMoney(price - promo, currency) : 0;
  const discountPct = price > 0 && promo > 0 && promo < price
    ? Math.round(((price - promo) / price) * 100)
    : 0;
  return {
    name: String(r.display_name || '').trim(),
    category: String(r.category || '').trim(),
    promo_price: roundMoney(promo, currency),
    was_price: roundMoney(price, currency),
    savings,
    discount_pct: discountPct,
    halal: truthyFlag(r.is_halal),
    vegetarian: truthyFlag(r.is_vegetarian),
    spicy: truthyFlag(r.is_spicy),
    description: String(r.description || '').trim().slice(0, 200),
  };
}

module.exports = {
  name: 'menu_promotions',
  description:
    'List menu items currently on promotion / sale / discounted price. ' +
    'Use when the guest asks about promotions, deals, specials, promo prices, or what is on sale.',
  params: {
    category: 'optional string — filter by category name',
    keyword: 'optional string — search in dish name or description',
    limit: 'integer 1..30, default 15',
  },
  cacheTtlSec: 120,
  followups: [
    { label: 'All promos', question: 'What items are on promotion right now?' },
    { label: 'Budget picks', question: 'What affordable dishes do you recommend?' },
    { label: 'Popular dishes', question: 'What are the most popular dishes right now?' },
    { label: 'Halal menu', question: 'What halal dishes do you recommend?' },
  ],
  async run({ dts, params }) {
    const currency = await getCompanyCurrency(dts);
    const cols = await getIcitemColumns(dts);
    const n = limit(params, 15);

    if (!cols.hasPromoPrice) {
      return withCurrency(dts, {
        empty: true,
        items: [],
        count: 0,
        note: 'Promotional pricing is not configured on this menu.',
      });
    }

    const clauses = [
      "is_avail = 'T'",
      'COALESCE(promo_price, 0) > 0',
      'COALESCE(promo_price, 0) < COALESCE(PRICE, 0)',
    ];
    const binds = [];

    if (params.category && String(params.category).trim()) {
      clauses.push('TRIM(CATEGORY) = ?');
      binds.push(String(params.category).trim());
    }
    if (params.keyword && String(params.keyword).trim()) {
      const kw = '%' + String(params.keyword).trim().slice(0, 80) + '%';
      clauses.push('(DESP LIKE ? OR COALESCE(`comment`, \'\') LIKE ?)');
      binds.push(kw, kw);
    }

    binds.push(n);

    const rows = await db.runQuery(dts, `
      SELECT ITEMNO AS item_code, DESP AS display_name, CATEGORY AS category,
             PRICE AS price, COALESCE(promo_price, 0) AS promo_price,
             is_halal, is_veg AS is_vegetarian, is_spicy,
             COALESCE(\`comment\`, '') AS description
      FROM icitem
      WHERE ${clauses.join(' AND ')}
      ORDER BY (COALESCE(PRICE, 0) - COALESCE(promo_price, 0)) / NULLIF(COALESCE(PRICE, 0), 0) DESC,
               sort_ord ASC, DESP ASC
      LIMIT ?
    `, binds);

    const items = rows.map((r) => mapPromoRow(r, currency));

    return withCurrency(dts, {
      filter: {
        category: params.category || null,
        keyword: params.keyword || null,
      },
      count: items.length,
      items,
      empty: items.length === 0,
      note: items.length === 0 ? 'No items are currently on promotion.' : null,
    });
  },
};
