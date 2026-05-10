'use strict';

const db = require('../db');

// Mirrors the four panels on /latest/body/overview.cfm + the info board.
async function run({ dts }) {
  const out = { dts, generated_at: new Date().toISOString() };

  // 1. Last 5 month sales (artran) — same query as overview chart type1
  try {
    out.last_5_month_sales = await db.runQuery(dts, `
      SELECT custno, name, SUM(grand) AS sumgrand, fperiod
      FROM artran
      WHERE (type = 'INV' OR type = 'DN' OR type = 'CS')
        AND void = ''
        AND fperiod <> '99'
        AND custno <> ''
      GROUP BY fperiod
      ORDER BY fperiod DESC
      LIMIT 5
    `);
  } catch (e) {
    out.last_5_month_sales_error = e.message;
  }

  // 2. Top 5 customers (artran) — overview chart type2
  try {
    out.top_5_customers = await db.runQuery(dts, `
      SELECT custno, name, SUM(grand) AS sumgrand
      FROM artran
      WHERE (type = 'INV' OR type = 'DN' OR type = 'CS')
        AND void = ''
        AND fperiod <> '99'
        AND custno <> ''
      GROUP BY custno, name
      ORDER BY sumgrand DESC
      LIMIT 5
    `);
  } catch (e) {
    out.top_5_customers_error = e.message;
  }

  // 3. E-Menu daily sales this calendar month — overview chart type3
  try {
    out.emenu_month_daily = await db.runQuery(dts, `
      SELECT DAY(o.created_at) AS day_num,
             SUM(o.total_amount) AS day_total,
             COUNT(*) AS order_count
      FROM app_orders o
      WHERE o.status NOT IN ('cancelled')
        AND o.created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
        AND o.created_at <  DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
      GROUP BY DAY(o.created_at), DATE(o.created_at)
      ORDER BY DATE(o.created_at) ASC
    `);
  } catch (e) {
    out.emenu_month_daily_error = e.message;
  }

  // 4. Top 5 e-menu items this month — overview chart type4
  try {
    out.emenu_top_items_month = await db.runQuery(dts, `
      SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)')) AS dish_label,
             SUM(i.subtotal) AS line_revenue
      FROM app_order_items i
      INNER JOIN app_orders o ON o.order_id = i.order_id
      WHERE o.status NOT IN ('cancelled')
        AND o.created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
        AND o.created_at <  DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
      GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)'))
      ORDER BY line_revenue DESC
      LIMIT 5
    `);
  } catch (e) {
    out.emenu_top_items_month_error = e.message;
  }

  return out;
}

module.exports = {
  name: 'overview_snapshot',
  description: 'High-level dashboard snapshot mirroring the admin Overview page: monthly sales, top customers, this month e-menu daily sales, top e-menu items this month.',
  params: {},
  cacheTtlSec: 120,
  followups: [
    { label: 'Sales today', question: 'How is e-menu performing today by orders, revenue, and basket size?' },
    { label: 'Top items this month', question: 'Which 10 menu items are bringing the most revenue this month and how concentrated is the mix?' },
    { label: 'Compare weeks', question: 'How does this week compare to last week in revenue and order count, and what drove the change?' },
    { label: 'Peak hours', question: 'Which hours of the day drive the most orders in the last 14 days and how big is the gap between peak and off-peak?' },
  ],
  run,
};
