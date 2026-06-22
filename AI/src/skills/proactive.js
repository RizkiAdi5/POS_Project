'use strict';

const db = require('../db');
const sales = require('./sales');
const orders = require('./orders');
const predictions = require('./predictions');

function findSkill(arr, name) {
  return arr.find((s) => s.name === name);
}

function round(n, d) {
  const f = Math.pow(10, d);
  return Math.round((Number(n) || 0) * f) / f;
}

function pctChange(current, prior) {
  const c = Number(current) || 0;
  const p = Number(prior) || 0;
  if (p === 0) return null;
  return round(((c - p) / p) * 100, 1);
}

const dailyBriefing = {
  name: 'daily_briefing',
  description:
    'Proactive morning briefing: yesterday vs typical weekday, today so far, week vs last week, month-to-date vs last month. Use for "daily briefing", "morning report", "what should I know today".',
  params: {},
  cacheTtlSec: 300,
  followups: [
    { label: 'Weekly executive brief', question: 'Give me a full weekly executive brief with forecast and action items.' },
    { label: 'Anomalies', question: 'Are there any unusual patterns or alerts I should know about right now?' },
    { label: 'Next week forecast', question: 'What e-menu revenue and order count should we expect next week?' },
    { label: 'Peak hours next week', question: 'What peak ordering hours should we expect next week and when should we add staff?' },
  ],
  async run({ dts }) {
    const todaySkill = findSkill(sales, 'today_sales');
    const weekSkill = findSkill(sales, 'compare_weeks');
    const mtdSkill = findSkill(sales, 'month_to_date');

    const [today, weeks, mtd, yesterdayRow, weekdayBaseline] = await Promise.all([
      todaySkill.run({ dts, params: {} }),
      weekSkill.run({ dts, params: {} }),
      mtdSkill.run({ dts, params: {} }),
      db.runQuery(dts, `
        SELECT COUNT(*) AS order_count,
               COALESCE(SUM(total_amount), 0) AS amount_total,
               COALESCE(AVG(total_amount), 0) AS avg_basket
        FROM app_orders
        WHERE status NOT IN ('cancelled')
          AND DATE(created_at) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
      `),
      db.runQuery(dts, `
        SELECT AVG(day_tot.amount_total) AS avg_amount,
               AVG(day_tot.order_count) AS avg_orders
        FROM (
          SELECT DATE(created_at) AS d,
                 SUM(total_amount) AS amount_total,
                 COUNT(*) AS order_count
          FROM app_orders
          WHERE status NOT IN ('cancelled')
            AND created_at >= DATE_SUB(CURDATE(), INTERVAL 28 DAY)
            AND created_at < CURDATE()
            AND DAYOFWEEK(created_at) = DAYOFWEEK(DATE_SUB(CURDATE(), INTERVAL 1 DAY))
          GROUP BY DATE(created_at)
        ) day_tot
      `),
    ]);

    const y = yesterdayRow[0] || { order_count: 0, amount_total: 0, avg_basket: 0 };
    const baseline = weekdayBaseline[0] || { avg_amount: 0, avg_orders: 0 };
    const yAmt = Number(y.amount_total || 0);
    const baseAmt = Number(baseline.avg_amount || 0);

    return {
      is_briefing: true,
      generated_at: new Date().toISOString(),
      today,
      yesterday: {
        date: new Date(Date.now() - 86400000).toISOString().slice(0, 10),
        order_count: Number(y.order_count || 0),
        amount_total: yAmt,
        avg_basket: round(y.avg_basket, 2),
        vs_same_weekday_avg_pct: pctChange(yAmt, baseAmt),
        same_weekday_avg_amount: round(baseAmt, 0),
        same_weekday_avg_orders: round(baseline.avg_orders, 1),
      },
      week_comparison: weeks,
      month_to_date: mtd,
      empty: today.empty && yAmt === 0 && weeks.empty && mtd.empty,
    };
  },
};

const detectAnomalies = {
  name: 'detect_anomalies',
  description:
    'Detect unusual patterns: revenue drops, cancellation spikes, menu concentration risk, week-over-week declines. Use for "anomalies", "alerts", "anything unusual", "red flags".',
  params: {},
  cacheTtlSec: 180,
  followups: [
    { label: 'Daily briefing', question: 'Give me my daily business briefing — yesterday, today, and week vs last week.' },
    { label: 'Cancellations', question: 'How many orders were cancelled in the last 7 days, what is the lost revenue, and which items appear most often in cancelled orders?' },
    { label: 'Compare weeks', question: 'How does this week compare to last week in revenue, order count, and average basket?' },
    { label: 'Top items', question: 'Which 10 menu items are bringing the most revenue this month and how concentrated is the mix?' },
  ],
  async run({ dts }) {
    const alerts = [];

    const weekSkill = findSkill(sales, 'compare_weeks');
    const weeks = await weekSkill.run({ dts, params: {} });
    if (weeks.amount_change_pct != null && weeks.amount_change_pct <= -25) {
      alerts.push({
        id: 'week_revenue_drop',
        severity: weeks.amount_change_pct <= -40 ? 'high' : 'medium',
        type: 'revenue',
        title: 'This week revenue is down sharply vs last week',
        detail: `Revenue change ${weeks.amount_change_pct}% (${weeks.this_week.orders} orders this week vs ${weeks.last_week.orders} last week).`,
        metric: { change_pct: weeks.amount_change_pct, this_week_amount: weeks.this_week.amount, last_week_amount: weeks.last_week.amount },
      });
    } else if (weeks.amount_change_pct != null && weeks.amount_change_pct >= 35) {
      alerts.push({
        id: 'week_revenue_spike',
        severity: 'medium',
        type: 'revenue',
        title: 'This week revenue is unusually high vs last week',
        detail: `Revenue up ${weeks.amount_change_pct}% week-over-week.`,
        metric: { change_pct: weeks.amount_change_pct },
      });
    }

    const yRows = await db.runQuery(dts, `
      SELECT COALESCE(SUM(total_amount), 0) AS amount_total
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND DATE(created_at) = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
    `);
    const baselineRows = await db.runQuery(dts, `
      SELECT AVG(day_tot.amount_total) AS avg_amount
      FROM (
        SELECT DATE(created_at) AS d, SUM(total_amount) AS amount_total
        FROM app_orders
        WHERE status NOT IN ('cancelled')
          AND created_at >= DATE_SUB(CURDATE(), INTERVAL 28 DAY)
          AND created_at < CURDATE()
          AND DAYOFWEEK(created_at) = DAYOFWEEK(DATE_SUB(CURDATE(), INTERVAL 1 DAY))
        GROUP BY DATE(created_at)
      ) day_tot
    `);
    const yAmt = Number((yRows[0] && yRows[0].amount_total) || 0);
    const baseAmt = Number((baselineRows[0] && baselineRows[0].avg_amount) || 0);
    const yPct = pctChange(yAmt, baseAmt);
    if (baseAmt > 0 && yPct != null && yPct <= -20) {
      alerts.push({
        id: 'yesterday_weekday_drop',
        severity: yPct <= -35 ? 'high' : 'medium',
        type: 'revenue',
        title: 'Yesterday was weaker than a typical same-weekday',
        detail: `Yesterday revenue vs 4-week same-weekday average: ${yPct}%.`,
        metric: { change_pct: yPct, yesterday_amount: yAmt, baseline_amount: round(baseAmt, 0) },
      });
    }

    const cancelRows = await db.runQuery(dts, `
      SELECT
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 ELSE 0 END) AS recent_total,
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND status = 'cancelled' THEN 1 ELSE 0 END) AS recent_cancelled,
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL 14 DAY)
                  AND created_at < DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 ELSE 0 END) AS prior_total,
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL 14 DAY)
                  AND created_at < DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND status = 'cancelled' THEN 1 ELSE 0 END) AS prior_cancelled
      FROM app_orders
    `);
    const cr = cancelRows[0] || {};
    const recentTotal = Number(cr.recent_total || 0);
    const priorTotal = Number(cr.prior_total || 0);
    const recentRate = recentTotal > 0 ? (Number(cr.recent_cancelled || 0) / recentTotal) * 100 : 0;
    const priorRate = priorTotal > 0 ? (Number(cr.prior_cancelled || 0) / priorTotal) * 100 : 0;
    const rateChange = pctChange(recentRate, priorRate);
    if (recentTotal >= 10 && priorTotal >= 10 && rateChange != null && rateChange >= 50 && recentRate >= 5) {
      alerts.push({
        id: 'cancellation_spike',
        severity: rateChange >= 100 ? 'high' : 'medium',
        type: 'operations',
        title: 'Cancellation rate has risen vs the prior week',
        detail: `Last 7 days: ${round(recentRate, 1)}% cancelled (prior 7 days: ${round(priorRate, 1)}%, change ${rateChange}%).`,
        metric: { recent_rate_pct: round(recentRate, 1), prior_rate_pct: round(priorRate, 1), change_pct: rateChange },
      });
    }

    const topItemRows = await db.runQuery(dts, `
      SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)')) AS dish_label,
             SUM(i.subtotal) AS line_revenue
      FROM app_order_items i
      INNER JOIN app_orders o ON o.order_id = i.order_id
      WHERE o.status NOT IN ('cancelled')
        AND o.created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
      GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)'))
      ORDER BY line_revenue DESC
      LIMIT 5
    `);
    const monthTotal = topItemRows.reduce((a, r) => a + Number(r.line_revenue || 0), 0);
    if (topItemRows.length && monthTotal > 0) {
      const topShare = (Number(topItemRows[0].line_revenue || 0) / monthTotal) * 100;
      if (topShare >= 40) {
        alerts.push({
          id: 'menu_concentration',
          severity: topShare >= 55 ? 'high' : 'medium',
          type: 'menu',
          title: 'Revenue is heavily concentrated on one menu item',
          detail: `"${topItemRows[0].dish_label}" drives ${round(topShare, 1)}% of top-item revenue this month.`,
          metric: { top_item: topItemRows[0].dish_label, share_pct: round(topShare, 1) },
        });
      }
    }

    const mtdSkill = findSkill(sales, 'month_to_date');
    const mtd = await mtdSkill.run({ dts, params: {} });
    if (mtd.amount_change_pct != null && mtd.amount_change_pct <= -30) {
      alerts.push({
        id: 'mtd_revenue_drop',
        severity: 'high',
        type: 'revenue',
        title: 'Month-to-date is well below the same period last month',
        detail: `MTD revenue change vs last month same period: ${mtd.amount_change_pct}%.`,
        metric: { change_pct: mtd.amount_change_pct },
      });
    }

    const severityRank = { high: 0, medium: 1, low: 2 };
    alerts.sort((a, b) => severityRank[a.severity] - severityRank[b.severity]);

    return {
      is_anomaly_report: true,
      generated_at: new Date().toISOString(),
      alert_count: alerts.length,
      alerts,
      empty: alerts.length === 0,
    };
  },
};

const weeklyExecutiveBrief = {
  name: 'weekly_executive_brief',
  description:
    'Full weekly executive summary combining week comparison, month-to-date, next-week forecast, cancellations, and projected top items. Use for "executive brief", "weekly summary", "owner report", "full business review".',
  params: {},
  cacheTtlSec: 300,
  followups: [
    { label: 'Daily briefing', question: 'Give me my daily business briefing for today.' },
    { label: 'Peak hours next week', question: 'What peak ordering hours should we expect next week and when should we add staff?' },
    { label: 'Cancellation risk', question: 'What cancellation risk should we expect next week and which items are most at risk?' },
    { label: 'Anomalies', question: 'Are there any unusual patterns or alerts I should know about?' },
  ],
  async run({ dts }) {
    const weekSkill = findSkill(sales, 'compare_weeks');
    const mtdSkill = findSkill(sales, 'month_to_date');
    const cancelSkill = findSkill(orders, 'cancellations_recent');
    const predictSales = findSkill(predictions, 'predict_next_week_sales');
    const predictItems = findSkill(predictions, 'predict_top_items');
    const predictPeak = findSkill(predictions, 'predict_peak_hours');

    const [weeks, mtd, cancellations, nextWeek, topItems, peakHours, anomalies] = await Promise.all([
      weekSkill.run({ dts, params: {} }),
      mtdSkill.run({ dts, params: {} }),
      cancelSkill.run({ dts, params: { days: 7 } }),
      predictSales.run({ dts, params: { history_weeks: 4 } }),
      predictItems.run({ dts, params: { limit: 5, history_days: 28 } }),
      predictPeak.run({ dts, params: { history_days: 28 } }),
      detectAnomalies.run({ dts, params: {} }),
    ]);

    return {
      is_executive_brief: true,
      generated_at: new Date().toISOString(),
      week_comparison: weeks,
      month_to_date: mtd,
      cancellations_last_7_days: cancellations,
      next_week_forecast: nextWeek,
      projected_top_items: topItems,
      predicted_peak_hours: {
        confidence: peakHours.confidence,
        overall_top_peak_slots: peakHours.overall_top_peak_slots,
        next_week: peakHours.next_week,
      },
      active_alerts: anomalies.alerts,
      alert_count: anomalies.alert_count,
      empty: weeks.empty && mtd.empty && cancellations.empty && nextWeek.empty,
    };
  },
};

const CHART_META = {
  type1: { chart_title: 'Last 5 Month Sales', source: 'artran POS invoices' },
  type2: { chart_title: 'Top 5 Customers', source: 'artran customer totals' },
  type3: { chart_title: 'E-Menu Sales This Month (by day)', source: 'app_orders daily totals' },
  type4: { chart_title: 'Top 5 E-Menu Items This Month', source: 'app_order_items line revenue' },
};

const explainChart = {
  name: 'explain_chart',
  description:
    'Explain an overview dashboard chart. Params chart_type: type1 (last 5 month sales), type2 (top customers), type3 (e-menu daily this month), type4 (top e-menu items). Use when admin asks to explain a chart on the overview page.',
  params: { chart_type: 'type1|type2|type3|type4' },
  cacheTtlSec: 300,
  followups: [
    { label: 'Daily briefing', question: 'Give me my daily business briefing for today.' },
    { label: 'Executive brief', question: 'Give me a full weekly executive brief with forecast and action items.' },
    { label: 'Compare weeks', question: 'How does this week compare to last week in revenue, order count, and average basket?' },
    { label: 'Next week forecast', question: 'What e-menu revenue and order count should we expect next week?' },
  ],
  async run({ dts, params }) {
    const chartType = String((params && params.chart_type) || 'type1').toLowerCase();
    const meta = CHART_META[chartType] || CHART_META.type1;
    const out = {
      is_chart_explanation: true,
      chart_type: chartType,
      chart_title: meta.chart_title,
      data_source: meta.source,
      generated_at: new Date().toISOString(),
    };

    if (chartType === 'type1') {
      try {
        out.rows = await db.runQuery(dts, `
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
        if (out.rows.length >= 2) {
          const newest = Number(out.rows[0].sumgrand || 0);
          const prior = Number(out.rows[1].sumgrand || 0);
          out.latest_vs_prior_pct = pctChange(newest, prior);
        }
      } catch (e) {
        out.error = e.message;
      }
    } else if (chartType === 'type2') {
      try {
        out.rows = await db.runQuery(dts, `
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
        const total = out.rows.reduce((a, r) => a + Number(r.sumgrand || 0), 0);
        if (out.rows.length && total > 0) {
          out.top_customer_share_pct = round((Number(out.rows[0].sumgrand || 0) / total) * 100, 1);
          out.top_5_total = total;
        }
      } catch (e) {
        out.error = e.message;
      }
    } else if (chartType === 'type3') {
      try {
        out.rows = await db.runQuery(dts, `
          SELECT DAY(o.created_at) AS day_num,
                 DATE(o.created_at) AS day_date,
                 SUM(o.total_amount) AS day_total,
                 COUNT(*) AS order_count
          FROM app_orders o
          WHERE o.status NOT IN ('cancelled')
            AND o.created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
            AND o.created_at < DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
          GROUP BY DAY(o.created_at), DATE(o.created_at)
          ORDER BY DATE(o.created_at) ASC
        `);
        if (out.rows.length) {
          const best = [...out.rows].sort((a, b) => Number(b.day_total) - Number(a.day_total))[0];
          out.best_day = { day_num: best.day_num, day_total: Number(best.day_total), order_count: Number(best.order_count) };
          out.mtd_total = out.rows.reduce((a, r) => a + Number(r.day_total || 0), 0);
          out.mtd_orders = out.rows.reduce((a, r) => a + Number(r.order_count || 0), 0);
        }
      } catch (e) {
        out.error = e.message;
      }
    } else if (chartType === 'type4') {
      try {
        out.rows = await db.runQuery(dts, `
          SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)')) AS dish_label,
                 SUM(i.subtotal) AS line_revenue,
                 COUNT(*) AS line_count
          FROM app_order_items i
          INNER JOIN app_orders o ON o.order_id = i.order_id
          WHERE o.status NOT IN ('cancelled')
            AND o.created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
            AND o.created_at < DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
          GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)'))
          ORDER BY line_revenue DESC
          LIMIT 5
        `);
        const total = out.rows.reduce((a, r) => a + Number(r.line_revenue || 0), 0);
        if (out.rows.length && total > 0) {
          out.top_item_share_pct = round((Number(out.rows[0].line_revenue || 0) / total) * 100, 1);
          out.top_5_revenue = total;
        }
      } catch (e) {
        out.error = e.message;
      }
    }

    out.empty = !out.rows || out.rows.length === 0;
    return out;
  },
};

module.exports = [dailyBriefing, detectAnomalies, weeklyExecutiveBrief, explainChart];
