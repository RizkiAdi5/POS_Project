'use strict';

const db = require('../db');
const { days } = require('../util/dates');

const cancellationsRecent = {
  name: 'cancellations_recent',
  description: 'Cancelled e-menu orders in the last D days: count, amount lost, and top-cancelled items.',
  params: { days: 'integer 1..90, default 7' },
  cacheTtlSec: 120,
  followups: [
    { label: 'Order status today', question: 'How are todays orders split by status (pending, confirmed, completed, cancelled) and what is the total revenue per status?' },
    { label: 'Sales trend (7 days)', question: 'Show me daily e-menu sales for the last 7 days and which day drove the most revenue.' },
    { label: 'Compare weeks', question: 'How does this week compare to last week in revenue, order count, and average basket?' },
    { label: 'Top items this month', question: 'Which 10 menu items are bringing the most revenue this month?' },
  ],
  async run({ dts, params }) {
    const d = days(params, 7);
    const totals = await db.runQuery(dts, `
      SELECT COUNT(*) AS cancelled_count,
             COALESCE(SUM(total_amount), 0) AS amount_lost
      FROM app_orders
      WHERE status = 'cancelled'
        AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
    `, [d]);
    const items = await db.runQuery(dts, `
      SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)')) AS dish_label,
             COUNT(*) AS lines_in_cancelled,
             COALESCE(SUM(i.subtotal), 0) AS amount_in_cancelled
      FROM app_order_items i
      INNER JOIN app_orders o ON o.order_id = i.order_id
      WHERE o.status = 'cancelled'
        AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)'))
      ORDER BY lines_in_cancelled DESC
      LIMIT 10
    `, [d]);
    return {
      window_days: d,
      totals: totals[0] || { cancelled_count: 0, amount_lost: 0 },
      top_items_in_cancelled_orders: items,
      empty: !totals[0] || Number(totals[0].cancelled_count) === 0,
    };
  },
};

const peakHours = {
  name: 'peak_hours',
  description: 'E-menu order volume and revenue by hour of day for the last D days. Identifies peak service hours.',
  params: { days: 'integer 1..90, default 14' },
  cacheTtlSec: 300,
  followups: [
    { label: 'Sales by weekday', question: 'Which weekday drives the most revenue and orders in the last 30 days?' },
    { label: 'Weekend vs weekday', question: 'How does weekend revenue per day compare to weekday revenue per day in the last 30 days?' },
    { label: 'Tables status', question: 'What is the current status of all tables — how many available, occupied, and reserved, and total seat capacity?' },
    { label: 'Sales today', question: 'How is e-menu performing today by orders, revenue, and basket size?' },
  ],
  async run({ dts, params }) {
    const d = days(params, 14);
    const rows = await db.runQuery(dts, `
      SELECT HOUR(created_at) AS hour_of_day,
             COUNT(*) AS order_count,
             COALESCE(SUM(total_amount), 0) AS amount_total
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY HOUR(created_at)
      ORDER BY hour_of_day ASC
    `, [d]);
    const top = [...rows].sort((a, b) => Number(b.order_count) - Number(a.order_count)).slice(0, 3);
    return { window_days: d, by_hour: rows, top_3_hours: top, empty: rows.length === 0 };
  },
};

const basketStats = {
  name: 'basket_stats',
  description: 'Average and distribution of basket size (company base currency per order) over the last D days.',
  params: { days: 'integer 1..90, default 30' },
  cacheTtlSec: 300,
  followups: [
    { label: 'Top items this month', question: 'Which 10 menu items are bringing the most revenue this month?' },
    { label: 'Sales trend (30 days)', question: 'Show me daily e-menu sales for the last 30 days and which weeks drove the most revenue.' },
    { label: 'Compare months', question: 'How does this month so far compare to the same period last month?' },
    { label: 'Cancellations', question: 'How many orders were cancelled in the last 7 days and what is the lost revenue?' },
  ],
  async run({ dts, params }) {
    const d = days(params, 30);
    const rows = await db.runQuery(dts, `
      SELECT COUNT(*) AS order_count,
             COALESCE(AVG(total_amount), 0) AS avg_basket,
             COALESCE(MIN(total_amount), 0) AS min_basket,
             COALESCE(MAX(total_amount), 0) AS max_basket,
             COALESCE(SUM(total_amount), 0) AS amount_total
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
    `, [d]);
    return { window_days: d, stats: rows[0] || {}, empty: !rows[0] || Number(rows[0].order_count) === 0 };
  },
};

// NEW: order status breakdown
const ordersByStatus = {
  name: 'orders_by_status',
  description: 'Distribution of e-menu orders by status (pending, confirmed, completed, cancelled, etc.) for the last D days.',
  params: { days: 'integer 1..90, default 7' },
  cacheTtlSec: 60,
  followups: [
    { label: 'Cancellations', question: 'How many orders were cancelled in the last 7 days, what is the lost revenue, and which items appear most often in cancelled orders?' },
    { label: 'Sales today', question: 'How is e-menu performing today by orders, revenue, and basket size?' },
    { label: 'Sales trend (7 days)', question: 'Show me daily e-menu sales for the last 7 days and which day drove the most revenue.' },
    { label: 'Tables status', question: 'What is the current status of all tables — available, occupied, reserved, and seat capacity?' },
  ],
  async run({ dts, params }) {
    const d = days(params, 7);
    const rows = await db.runQuery(dts, `
      SELECT COALESCE(NULLIF(status,''),'(unknown)') AS status,
             COUNT(*) AS order_count,
             COALESCE(SUM(total_amount), 0) AS amount_total
      FROM app_orders
      WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY status
      ORDER BY order_count DESC
    `, [d]);
    const total = rows.reduce((a, r) => a + Number(r.order_count || 0), 0);
    return { window_days: d, total_orders: total, by_status: rows, empty: total === 0 };
  },
};

module.exports = [cancellationsRecent, peakHours, basketStats, ordersByStatus];
