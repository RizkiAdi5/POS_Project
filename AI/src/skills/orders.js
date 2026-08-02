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

// Today's orders with line-item detail (order #, items, revenue)
const todayOrdersDetail = {
  name: 'today_orders_detail',
  description: 'Today\'s e-menu orders listed by order number/ID with each line item, quantity, unit price, and line revenue; includes item summary and status totals. Use when the user asks for today\'s order list, order breakdown, items ordered today, per-order detail, or revenue by order/item for today.',
  params: {},
  cacheTtlSec: 60,
  followups: [
    { label: 'Sales totals today', question: 'How is e-menu performing today by orders, revenue, and basket size?' },
    { label: 'Download Excel', question: 'Download today\'s orders and line items as an Excel file.' },
    { label: 'Compare weeks', question: 'How does this week compare to last week in revenue and order count?' },
    { label: 'Peak hours', question: 'Which hours of the day drive the most orders in the last 14 days?' },
  ],
  async run({ dts }) {
    const date = new Date().toISOString().slice(0, 10);

    const totals = await db.runQuery(dts, `
      SELECT COUNT(*) AS order_count,
             COALESCE(SUM(total_amount), 0) AS amount_total,
             COALESCE(AVG(total_amount), 0) AS avg_basket
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND DATE(created_at) = CURDATE()
    `);

    const byStatus = await db.runQuery(dts, `
      SELECT status, COUNT(*) AS order_count, COALESCE(SUM(total_amount), 0) AS amount_total
      FROM app_orders
      WHERE DATE(created_at) = CURDATE()
      GROUP BY status
      ORDER BY amount_total DESC
    `);

    const orders = await db.runQuery(dts, `
      SELECT o.order_id, o.order_number, t.table_number, o.status, o.order_type,
             o.subtotal, o.tax_amount, o.total_amount,
             DATE_FORMAT(o.created_at, '%Y-%m-%d %H:%i') AS ordered_at
      FROM app_orders o
      LEFT JOIN app_tables t ON t.table_id = o.table_id
      WHERE DATE(o.created_at) = CURDATE()
      ORDER BY o.created_at ASC
    `);

    const lineItems = await db.runQuery(dts, `
      SELECT o.order_id, o.order_number, o.status AS order_status,
             i.item_id, i.item_code,
             TRIM(COALESCE(NULLIF(i.item_name, ''), NULLIF(i.item_code, ''), '(unnamed)')) AS item_name,
             i.quantity, i.unit_price, i.subtotal, i.status AS line_status
      FROM app_order_items i
      INNER JOIN app_orders o ON o.order_id = i.order_id
      WHERE DATE(o.created_at) = CURDATE()
      ORDER BY o.created_at ASC, i.item_id ASC
    `);

    const itemsSummary = await db.runQuery(dts, `
      SELECT TRIM(COALESCE(NULLIF(i.item_name, ''), NULLIF(i.item_code, ''), '(unnamed)')) AS dish_label,
             SUM(i.quantity) AS quantity_sold,
             COALESCE(SUM(i.subtotal), 0) AS line_revenue,
             COUNT(DISTINCT o.order_id) AS order_count
      FROM app_order_items i
      INNER JOIN app_orders o ON o.order_id = i.order_id
      WHERE DATE(o.created_at) = CURDATE()
        AND o.status NOT IN ('cancelled')
      GROUP BY TRIM(COALESCE(NULLIF(i.item_name, ''), NULLIF(i.item_code, ''), '(unnamed)'))
      ORDER BY line_revenue DESC
    `);

    const itemsByOrder = new Map();
    for (const row of lineItems) {
      const oid = row.order_id;
      if (!itemsByOrder.has(oid)) itemsByOrder.set(oid, []);
      itemsByOrder.get(oid).push({
        item_id: row.item_id,
        item_code: row.item_code,
        item_name: row.item_name,
        quantity: Number(row.quantity || 0),
        unit_price: Number(row.unit_price || 0),
        subtotal: Number(row.subtotal || 0),
        line_status: row.line_status,
      });
    }

    const ordersWithItems = orders.map((o) => ({
      order_id: o.order_id,
      order_number: o.order_number,
      table_number: o.table_number || '',
      status: o.status,
      order_type: o.order_type,
      subtotal: Number(o.subtotal || 0),
      tax_amount: Number(o.tax_amount || 0),
      total_amount: Number(o.total_amount || 0),
      ordered_at: o.ordered_at,
      items: itemsByOrder.get(o.order_id) || [],
    }));

    const orderCount = orders.length;
    const lineCount = lineItems.length;

    return {
      date,
      totals: totals[0] || { order_count: 0, amount_total: 0, avg_basket: 0 },
      by_status: byStatus,
      orders: ordersWithItems,
      order_items: lineItems.map((r) => ({
        order_id: r.order_id,
        order_number: r.order_number,
        order_status: r.order_status,
        item_id: r.item_id,
        item_code: r.item_code,
        item_name: r.item_name,
        quantity: Number(r.quantity || 0),
        unit_price: Number(r.unit_price || 0),
        subtotal: Number(r.subtotal || 0),
        line_status: r.line_status,
      })),
      items_summary: itemsSummary.map((r) => ({
        dish_label: r.dish_label,
        quantity_sold: Number(r.quantity_sold || 0),
        line_revenue: Number(r.line_revenue || 0),
        order_count: Number(r.order_count || 0),
      })),
      counts: {
        total_orders: orderCount,
        total_line_items: lineCount,
      },
      empty: orderCount === 0,
    };
  },
};

module.exports = [cancellationsRecent, peakHours, basketStats, ordersByStatus, todayOrdersDetail];
