'use strict';

const db = require('../db');
const { days, limit } = require('../util/dates');

const topItemsMonth = {
  name: 'top_items_month',
  description: 'Top N e-menu items by line revenue for the current calendar month.',
  params: { limit: 'integer 1..50, default 10' },
  cacheTtlSec: 180,
  followups: [
    { label: 'Slow movers', question: 'Which menu items are bringing the least revenue this month and might be candidates to remove or promote?' },
    { label: 'Top items last 7 days', question: 'Which 10 menu items earned the most revenue in the last 7 days, and how does that compare to the month?' },
    { label: 'Month to date', question: 'How does this month so far compare to the same period last month?' },
    { label: 'Compare weeks', question: 'How does this week compare to last week in revenue, order count, and average basket?' },
  ],
  async run({ dts, params }) {
    const n = limit(params, 10);
    const rows = await db.runQuery(dts, `
      SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)')) AS dish_label,
             SUM(i.subtotal) AS line_revenue,
             COUNT(*) AS line_count
      FROM app_order_items i
      INNER JOIN app_orders o ON o.order_id = i.order_id
      WHERE o.status NOT IN ('cancelled')
        AND o.created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
        AND o.created_at <  DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
      GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)'))
      ORDER BY line_revenue DESC
      LIMIT ?
    `, [n]);
    return { period: 'current_month', limit: n, items: rows, empty: rows.length === 0 };
  },
};

const topItemsLastDays = {
  name: 'top_items_last_days',
  description: 'Top N e-menu items by line revenue for the last D days. Use for "last week / last 30 days".',
  params: { days: 'integer 1..90, default 7', limit: 'integer 1..50, default 10' },
  cacheTtlSec: 180,
  followups: [
    { label: 'Top items this month', question: 'Which 10 menu items are bringing the most revenue this month?' },
    { label: 'Slow movers', question: 'Which menu items are bringing the least revenue this month?' },
    { label: 'Sales trend (7 days)', question: 'Show me daily e-menu sales for the last 7 days and which day drove the most revenue.' },
    { label: 'Cancellations', question: 'How many orders were cancelled in the last 7 days, what is the lost revenue, and which items appear most often in cancelled orders?' },
  ],
  async run({ dts, params }) {
    const d = days(params, 7);
    const n = limit(params, 10);
    const rows = await db.runQuery(dts, `
      SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)')) AS dish_label,
             SUM(i.subtotal) AS line_revenue,
             COUNT(*) AS line_count
      FROM app_order_items i
      INNER JOIN app_orders o ON o.order_id = i.order_id
      WHERE o.status NOT IN ('cancelled')
        AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)'))
      ORDER BY line_revenue DESC
      LIMIT ?
    `, [d, n]);
    return { window_days: d, limit: n, items: rows, empty: rows.length === 0 };
  },
};

const slowMoversMonth = {
  name: 'slow_movers_month',
  description: 'Bottom N e-menu items by line revenue for the current calendar month (only items that were ordered at least once).',
  params: { limit: 'integer 1..50, default 10' },
  cacheTtlSec: 180,
  followups: [
    { label: 'Top items this month', question: 'Which 10 menu items are bringing the most revenue this month?' },
    { label: 'Cancellations', question: 'How many orders were cancelled in the last 7 days and which items appear most often in cancelled orders?' },
    { label: 'Sales trend (30 days)', question: 'Show me daily e-menu sales for the last 30 days and which weeks drove the most revenue.' },
    { label: 'Month to date', question: 'How does this month so far compare to the same period last month?' },
  ],
  async run({ dts, params }) {
    const n = limit(params, 10);
    const rows = await db.runQuery(dts, `
      SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)')) AS dish_label,
             SUM(i.subtotal) AS line_revenue,
             COUNT(*) AS line_count
      FROM app_order_items i
      INNER JOIN app_orders o ON o.order_id = i.order_id
      WHERE o.status NOT IN ('cancelled')
        AND o.created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
        AND o.created_at <  DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
      GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)'))
      ORDER BY line_revenue ASC
      LIMIT ?
    `, [n]);
    return { period: 'current_month', limit: n, items: rows, empty: rows.length === 0 };
  },
};

module.exports = [topItemsMonth, topItemsLastDays, slowMoversMonth];
