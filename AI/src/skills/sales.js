'use strict';

const db = require('../db');
const { days } = require('../util/dates');

const todaySales = {
  name: 'today_sales',
  description: 'Total e-menu sales today: order count and amount, plus split by status.',
  params: {},
  cacheTtlSec: 60,
  followups: [
    { label: 'Compare with last week', question: 'How does this week compare to last week in revenue, order count, and average basket?' },
    { label: 'Sales trend (7 days)', question: 'Show me e-menu sales day-by-day for the last 7 days and tell me which day drove the most revenue.' },
    { label: 'Peak hours', question: 'Which hours of the day drive the most orders in the last 14 days?' },
    { label: 'Top items today', question: 'Which menu items earned the most revenue today and how concentrated is the top of the list?' },
  ],
  async run({ dts }) {
    const totals = await db.runQuery(dts, `
      SELECT COUNT(*) AS order_count,
             COALESCE(SUM(total_amount), 0) AS amount_total,
             COALESCE(AVG(total_amount), 0) AS avg_basket
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND DATE(created_at) = CURDATE()
    `);
    const byStatus = await db.runQuery(dts, `
      SELECT status, COUNT(*) AS order_count, COALESCE(SUM(total_amount),0) AS amount_total
      FROM app_orders
      WHERE DATE(created_at) = CURDATE()
      GROUP BY status
      ORDER BY amount_total DESC
    `);
    return {
      date: new Date().toISOString().slice(0, 10),
      totals: totals[0] || { order_count: 0, amount_total: 0, avg_basket: 0 },
      by_status: byStatus,
      empty: !totals[0] || Number(totals[0].order_count) === 0,
    };
  },
};

const salesTrendDays = {
  name: 'sales_trend_days',
  description: 'Daily e-menu sales for the last N days (1..90). Use for "last week", "last 7 days", "trend".',
  params: { days: 'integer 1..90, default 7' },
  cacheTtlSec: 120,
  followups: [
    { label: 'Compare weeks', question: 'How does this week compare to last week in revenue and order count, and what drove the change?' },
    { label: 'Compare months', question: 'How does this month so far compare to the same period last month?' },
    { label: 'Peak hours', question: 'Which hours of the day drive the most orders in the last 14 days?' },
    { label: 'Weekend vs weekday', question: 'How does weekend revenue per day compare to weekday revenue per day?' },
  ],
  async run({ dts, params }) {
    const n = days(params, 7);
    const rows = await db.runQuery(dts, `
      SELECT DATE(created_at) AS day,
             COUNT(*) AS order_count,
             COALESCE(SUM(total_amount), 0) AS amount_total
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY DATE(created_at)
      ORDER BY DATE(created_at) ASC
    `, [n]);
    const totalAmount = rows.reduce((a, r) => a + Number(r.amount_total || 0), 0);
    const totalOrders = rows.reduce((a, r) => a + Number(r.order_count || 0), 0);
    return {
      window_days: n,
      daily: rows,
      total_orders: totalOrders,
      total_amount: totalAmount,
      avg_orders_per_day: rows.length ? totalOrders / rows.length : 0,
      empty: rows.length === 0,
    };
  },
};

const compareWeeks = {
  name: 'compare_weeks',
  description: 'Compare this week vs last week: total e-menu sales, order count, and percent change.',
  params: {},
  cacheTtlSec: 120,
  followups: [
    { label: 'Compare months', question: 'How does this month so far compare to the same period last month?' },
    { label: 'Sales trend (14 days)', question: 'Show me daily e-menu sales for the last 14 days and tell me which days drove the most revenue.' },
    { label: 'Top items this week', question: 'Which 10 menu items earned the most revenue in the last 7 days?' },
    { label: 'Cancellations last 7 days', question: 'How many orders were cancelled in the last 7 days, what is the lost revenue, and which items appear most often in cancelled orders?' },
  ],
  async run({ dts }) {
    const rows = await db.runQuery(dts, `
      SELECT
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
                  AND created_at <  CURDATE() + INTERVAL 1 DAY
            THEN total_amount ELSE 0 END) AS this_week_amount,
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
                  AND created_at <  CURDATE() + INTERVAL 1 DAY
            THEN 1 ELSE 0 END) AS this_week_orders,
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL 14 DAY)
                  AND created_at <  DATE_SUB(CURDATE(), INTERVAL 7 DAY)
            THEN total_amount ELSE 0 END) AS last_week_amount,
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL 14 DAY)
                  AND created_at <  DATE_SUB(CURDATE(), INTERVAL 7 DAY)
            THEN 1 ELSE 0 END) AS last_week_orders
      FROM app_orders
      WHERE status NOT IN ('cancelled')
    `);
    const r = rows[0] || {};
    const tw = Number(r.this_week_amount || 0);
    const lw = Number(r.last_week_amount || 0);
    const pct = lw > 0 ? ((tw - lw) / lw) * 100 : null;
    return {
      this_week: { amount: tw, orders: Number(r.this_week_orders || 0) },
      last_week: { amount: lw, orders: Number(r.last_week_orders || 0) },
      amount_change_pct: pct == null ? null : Math.round(pct * 100) / 100,
      empty: tw === 0 && lw === 0,
    };
  },
};

// NEW: month-to-date vs same period last month
const monthToDate = {
  name: 'month_to_date',
  description: 'Month-to-date e-menu performance vs same period last month: revenue, orders, percent change.',
  params: {},
  cacheTtlSec: 180,
  followups: [
    { label: 'Top items this month', question: 'Which 10 menu items are bringing the most revenue this month and how concentrated is the mix?' },
    { label: 'Slow movers', question: 'Which menu items are bringing the least revenue this month and might be candidates to remove or promote?' },
    { label: 'Sales trend (30 days)', question: 'Show me daily e-menu sales for the last 30 days and tell me which weeks drove the most revenue.' },
    { label: 'Compare weeks', question: 'How does this week compare to last week in revenue, order count, and average basket?' },
  ],
  async run({ dts }) {
    const rows = await db.runQuery(dts, `
      SELECT
        SUM(CASE
          WHEN created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
           AND created_at <  CURDATE() + INTERVAL 1 DAY
          THEN total_amount ELSE 0 END) AS mtd_amount,
        SUM(CASE
          WHEN created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
           AND created_at <  CURDATE() + INTERVAL 1 DAY
          THEN 1 ELSE 0 END) AS mtd_orders,
        SUM(CASE
          WHEN created_at >= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
           AND created_at <  DATE_SUB(CURDATE(), INTERVAL 1 MONTH) + INTERVAL 1 DAY
          THEN total_amount ELSE 0 END) AS lm_same_amount,
        SUM(CASE
          WHEN created_at >= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
           AND created_at <  DATE_SUB(CURDATE(), INTERVAL 1 MONTH) + INTERVAL 1 DAY
          THEN 1 ELSE 0 END) AS lm_same_orders
      FROM app_orders
      WHERE status NOT IN ('cancelled')
    `);
    const r = rows[0] || {};
    const mtd = Number(r.mtd_amount || 0);
    const lm  = Number(r.lm_same_amount || 0);
    const pct = lm > 0 ? ((mtd - lm) / lm) * 100 : null;
    return {
      this_month_to_date: { amount: mtd, orders: Number(r.mtd_orders || 0) },
      last_month_same_period: { amount: lm, orders: Number(r.lm_same_orders || 0) },
      amount_change_pct: pct == null ? null : Math.round(pct * 100) / 100,
      empty: mtd === 0 && lm === 0,
    };
  },
};

// NEW: revenue grouped by weekday
const revenueByWeekday = {
  name: 'revenue_by_weekday',
  description: 'Total e-menu revenue and order count grouped by day of week (Monday..Sunday) for the last D days.',
  params: { days: 'integer 7..180, default 30' },
  cacheTtlSec: 300,
  followups: [
    { label: 'Peak hours', question: 'Which hours of the day drive the most orders in the last 14 days?' },
    { label: 'Weekend vs weekday', question: 'How does weekend revenue per day compare to weekday revenue per day in the last 30 days?' },
    { label: 'Sales trend (30 days)', question: 'Show me daily e-menu sales for the last 30 days and tell me which weeks drove the most revenue.' },
    { label: 'Top items this month', question: 'Which 10 menu items are bringing the most revenue this month?' },
  ],
  async run({ dts, params }) {
    const d = Math.max(7, Math.min(180, parseInt((params && params.days) || 30, 10) || 30));
    const rows = await db.runQuery(dts, `
      SELECT DAYOFWEEK(created_at) AS dow_num,
             DAYNAME(created_at)   AS dow_name,
             COUNT(*)              AS order_count,
             COALESCE(SUM(total_amount),0) AS amount_total
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY DAYOFWEEK(created_at), DAYNAME(created_at)
      ORDER BY DAYOFWEEK(created_at)
    `, [d]);
    return { window_days: d, by_weekday: rows, empty: rows.length === 0 };
  },
};

// NEW: weekend vs weekday split
const weekendVsWeekday = {
  name: 'weekend_vs_weekday',
  description: 'Weekend (Sat/Sun) vs weekday (Mon..Fri) e-menu performance for the last D days.',
  params: { days: 'integer 7..180, default 30' },
  cacheTtlSec: 300,
  followups: [
    { label: 'Sales by weekday', question: 'Which weekday drives the most revenue and orders in the last 30 days?' },
    { label: 'Peak hours', question: 'Which hours of the day drive the most orders in the last 14 days?' },
    { label: 'Top items this month', question: 'Which 10 menu items are bringing the most revenue this month?' },
    { label: 'Compare weeks', question: 'How does this week compare to last week in revenue and order count?' },
  ],
  async run({ dts, params }) {
    const d = Math.max(7, Math.min(180, parseInt((params && params.days) || 30, 10) || 30));
    const rows = await db.runQuery(dts, `
      SELECT
        CASE WHEN DAYOFWEEK(created_at) IN (1,7) THEN 'weekend' ELSE 'weekday' END AS bucket,
        COUNT(*) AS order_count,
        COALESCE(SUM(total_amount),0) AS amount_total,
        COUNT(DISTINCT DATE(created_at)) AS day_count
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY CASE WHEN DAYOFWEEK(created_at) IN (1,7) THEN 'weekend' ELSE 'weekday' END
    `, [d]);
    const out = { window_days: d, buckets: {}, empty: rows.length === 0 };
    for (const r of rows) {
      out.buckets[r.bucket] = {
        order_count: Number(r.order_count || 0),
        amount_total: Number(r.amount_total || 0),
        day_count: Number(r.day_count || 0),
        amount_per_day: Number(r.day_count) ? Number(r.amount_total) / Number(r.day_count) : 0,
      };
    }
    return out;
  },
};

module.exports = [todaySales, salesTrendDays, compareWeeks, monthToDate, revenueByWeekday, weekendVsWeekday];
