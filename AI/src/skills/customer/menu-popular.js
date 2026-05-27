'use strict';

const db = require('../../db');
const { limit } = require('../../util/dates');
const { getCompanyCurrency, roundMoney, withCurrency } = require('../../util/currency');

module.exports = {
  name: 'menu_popular',
  description: 'Guest-safe popular dishes — based on recent guest orders (counts only, no business revenue totals).',
  params: { limit: 'integer 1..15, default 8', days: 'integer 1..60, default 30' },
  cacheTtlSec: 180,
  followups: [
    { label: 'Halal popular', question: 'What halal dishes are popular?' },
    { label: 'Budget picks', question: 'What affordable dishes do you recommend?' },
    { label: 'Full menu', question: 'Show me featured items on the menu.' },
    { label: 'Vegetarian', question: 'Show me vegetarian options.' },
  ],
  async run({ dts, params }) {
    const currency = await getCompanyCurrency(dts);
    const n = limit(params, 8);
    const days = Math.min(60, Math.max(1, parseInt(params.days, 10) || 30));

    const rows = await db.runQuery(dts, `
      SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(item)')) AS dish_name,
             COUNT(*) AS times_ordered,
             MAX(m.price) AS list_price,
             MAX(m.is_halal) AS is_halal,
             MAX(m.is_vegetarian) AS is_vegetarian,
             MAX(m.is_spicy) AS is_spicy
      FROM app_order_items i
      INNER JOIN app_orders o ON o.order_id = i.order_id
      LEFT JOIN app_menu m ON m.item_code = i.item_code OR m.display_name = i.item_name
      WHERE o.status NOT IN ('cancelled')
        AND o.created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)
      GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(item)'))
      ORDER BY times_ordered DESC
      LIMIT ?
    `, [days, n]);

    const items = rows.map((r, idx) => ({
      rank: idx + 1,
      name: String(r.dish_name || '').trim(),
      times_ordered: parseInt(r.times_ordered, 10) || 0,
      price: r.list_price != null ? roundMoney(r.list_price, currency) : null,
      halal: !!r.is_halal,
      vegetarian: !!r.is_vegetarian,
      spicy: !!r.is_spicy,
    }));

    return withCurrency(dts, { window_days: days, items, empty: items.length === 0 });
  },
};
