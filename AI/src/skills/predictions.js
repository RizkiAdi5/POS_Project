'use strict';

const db = require('../db');
const { limit } = require('../util/dates');
const {
  round,
  pctChange,
  getNextWeekDays,
  confidenceLevel,
  clampHistoryDays,
  clampHistoryWeeks,
  buildHourlyDowMap,
  buildDowMap,
} = require('../util/forecast');

const PREDICTION_FOLLOWUPS = [
  { label: 'Peak hours next week', question: 'What peak ordering hours should we expect next week and when should we add staff?' },
  { label: 'Next week sales', question: 'What e-menu revenue and order count should we expect next week?' },
  { label: 'Busiest days', question: 'Which days next week are likely to be busiest for e-menu orders?' },
  { label: 'Menu demand', question: 'Which menu items are likely to be top sellers next week?' },
];

const predictPeakHours = {
  name: 'predict_peak_hours',
  description:
    'Forecast peak e-menu ordering hours for next week from historical hour-by-weekday patterns. Use for "predict peak hour", "next week busy hours", "when will we be busiest", "staffing forecast".',
  params: { history_days: 'integer 14..90, default 28' },
  cacheTtlSec: 300,
  followups: PREDICTION_FOLLOWUPS,
  async run({ dts, params }) {
    const historyDays = clampHistoryDays(params, 28);
    const nextWeek = getNextWeekDays();
    const rows = await db.runQuery(dts, `
      SELECT DAYOFWEEK(created_at) AS dow,
             HOUR(created_at) AS hour_of_day,
             COUNT(*) AS total_orders,
             COALESCE(SUM(total_amount), 0) AS total_amount,
             COUNT(DISTINCT DATE(created_at)) AS distinct_days
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY DAYOFWEEK(created_at), HOUR(created_at)
    `, [historyDays]);

    const hourlyMap = buildHourlyDowMap(rows);
    const totalSampleOrders = rows.reduce((a, r) => a + Number(r.total_orders || 0), 0);
    const maxSampleDays = rows.reduce((m, r) => Math.max(m, Number(r.distinct_days || 0)), 0);
    const confidence = confidenceLevel({ sampleDays: maxSampleDays, totalOrders: totalSampleOrders });

    const dailyPeakForecast = nextWeek.days.map((day) => {
      const hours = [];
      for (let hour = 0; hour < 24; hour += 1) {
        const cell = hourlyMap.get(`${day.dow_mysql}:${hour}`);
        if (!cell || cell.avg_orders <= 0) continue;
        hours.push({
          hour_of_day: hour,
          hour_label: `${String(hour).padStart(2, '0')}:00`,
          predicted_orders: round(cell.avg_orders, 1),
          predicted_amount: round(cell.avg_amount, 0),
        });
      }
      hours.sort((a, b) => b.predicted_orders - a.predicted_orders);
      const top = hours.slice(0, 3);
      const dayTotalOrders = hours.reduce((a, h) => a + h.predicted_orders, 0);
      for (const h of top) {
        h.share_of_day_pct = dayTotalOrders > 0
          ? round((h.predicted_orders / dayTotalOrders) * 100, 1)
          : null;
      }
      return {
        date: day.date,
        day_name: day.day_name,
        predicted_daily_orders: round(dayTotalOrders, 1),
        predicted_daily_amount: round(hours.reduce((a, h) => a + h.predicted_amount, 0), 0),
        peak_hours: top,
      };
    });

    const overall = [];
    for (const day of dailyPeakForecast) {
      for (const h of day.peak_hours) {
        overall.push({
          date: day.date,
          day_name: day.day_name,
          hour_of_day: h.hour_of_day,
          hour_label: h.hour_label,
          predicted_orders: h.predicted_orders,
          predicted_amount: h.predicted_amount,
        });
      }
    }
    overall.sort((a, b) => b.predicted_orders - a.predicted_orders);

    return {
      is_prediction: true,
      prediction_type: 'peak_hours',
      methodology:
        'Average orders and revenue per hour for each weekday over the history window, applied to next week calendar dates.',
      confidence,
      history_days: historyDays,
      next_week: { start_date: nextWeek.start_date, end_date: nextWeek.end_date },
      daily_peak_forecast: dailyPeakForecast,
      overall_top_peak_slots: overall.slice(0, 5),
      empty: rows.length === 0,
    };
  },
};

const predictNextWeekSales = {
  name: 'predict_next_week_sales',
  description:
    'Forecast next week total e-menu revenue and order count using recent weekly trends and same-weekday daily averages.',
  params: { history_weeks: 'integer 2..8, default 4' },
  cacheTtlSec: 300,
  followups: PREDICTION_FOLLOWUPS,
  async run({ dts, params }) {
    const historyWeeks = clampHistoryWeeks(params, 4);
    const historyDays = historyWeeks * 7;
    const nextWeek = getNextWeekDays();

    const weeklyRows = await db.runQuery(dts, `
      SELECT YEARWEEK(created_at, 1) AS year_week,
             COUNT(*) AS order_count,
             COALESCE(SUM(total_amount), 0) AS amount_total
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY YEARWEEK(created_at, 1)
      ORDER BY year_week DESC
      LIMIT ?
    `, [historyDays + 7, historyWeeks + 1]);

    const dowRows = await db.runQuery(dts, `
      SELECT DAYOFWEEK(created_at) AS dow,
             DAYNAME(created_at) AS day_name,
             COUNT(*) AS total_orders,
             COALESCE(SUM(total_amount), 0) AS total_amount,
             COUNT(DISTINCT DATE(created_at)) AS distinct_days
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY DAYOFWEEK(created_at), DAYNAME(created_at)
    `, [historyDays]);

    const dowMap = buildDowMap(dowRows);
    const dailyForecast = nextWeek.days.map((day) => {
      const cell = dowMap.get(day.dow_mysql) || { avg_orders: 0, avg_amount: 0, sample_days: 0 };
      return {
        date: day.date,
        day_name: day.day_name,
        predicted_orders: round(cell.avg_orders, 1),
        predicted_amount: round(cell.avg_amount, 0),
      };
    });

    let baselineOrders = dailyForecast.reduce((a, d) => a + d.predicted_orders, 0);
    let baselineAmount = dailyForecast.reduce((a, d) => a + d.predicted_amount, 0);

    let trendPct = null;
    if (weeklyRows.length >= 2) {
      const recent = Number(weeklyRows[0].amount_total || 0);
      const prior = Number(weeklyRows[1].amount_total || 0);
      trendPct = pctChange(recent, prior);
      if (trendPct != null) {
        const damped = trendPct * 0.5;
        const factor = 1 + damped / 100;
        baselineAmount = round(baselineAmount * factor, 0);
        baselineOrders = round(baselineOrders * factor, 1);
        for (const d of dailyForecast) {
          d.predicted_amount = round(d.predicted_amount * factor, 0);
          d.predicted_orders = round(d.predicted_orders * factor, 1);
        }
      }
    }

    const totalSampleOrders = dowRows.reduce((a, r) => a + Number(r.total_orders || 0), 0);
    const maxSampleDays = dowRows.reduce((m, r) => Math.max(m, Number(r.distinct_days || 0)), 0);
    const confidence = confidenceLevel({ sampleDays: maxSampleDays, totalOrders: totalSampleOrders });

    const recentWeeks = weeklyRows.slice(0, historyWeeks).map((r) => ({
      year_week: r.year_week,
      orders: Number(r.order_count || 0),
      amount: Number(r.amount_total || 0),
    }));

    return {
      is_prediction: true,
      prediction_type: 'next_week_sales',
      methodology:
        'Sum of same-weekday daily averages for next week, adjusted by 50% of the most recent week-over-week revenue trend.',
      confidence,
      history_weeks: historyWeeks,
      recent_weekly_actuals: recentWeeks,
      recent_week_over_week_amount_pct: trendPct,
      next_week: {
        start_date: nextWeek.start_date,
        end_date: nextWeek.end_date,
        predicted_orders: round(baselineOrders, 1),
        predicted_amount: round(baselineAmount, 0),
      },
      daily_forecast: dailyForecast,
      empty: dowRows.length === 0,
    };
  },
};

const predictBusyDays = {
  name: 'predict_busy_days',
  description:
    'Forecast which days next week will have the highest e-menu order volume and revenue based on weekday patterns.',
  params: { history_days: 'integer 14..90, default 35' },
  cacheTtlSec: 300,
  followups: PREDICTION_FOLLOWUPS,
  async run({ dts, params }) {
    const historyDays = clampHistoryDays(params, 35);
    const nextWeek = getNextWeekDays();
    const dowRows = await db.runQuery(dts, `
      SELECT DAYOFWEEK(created_at) AS dow,
             DAYNAME(created_at) AS day_name,
             COUNT(*) AS total_orders,
             COALESCE(SUM(total_amount), 0) AS total_amount,
             COUNT(DISTINCT DATE(created_at)) AS distinct_days
      FROM app_orders
      WHERE status NOT IN ('cancelled')
        AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY DAYOFWEEK(created_at), DAYNAME(created_at)
      ORDER BY total_orders DESC
    `, [historyDays]);

    const dowMap = buildDowMap(dowRows);
    const ranked = nextWeek.days.map((day) => {
      const cell = dowMap.get(day.dow_mysql) || { avg_orders: 0, avg_amount: 0, sample_days: 0 };
      return {
        date: day.date,
        day_name: day.day_name,
        predicted_orders: round(cell.avg_orders, 1),
        predicted_amount: round(cell.avg_amount, 0),
        historical_sample_days: cell.sample_days || 0,
      };
    });
    ranked.sort((a, b) => b.predicted_orders - a.predicted_orders);

    const weekTotalOrders = ranked.reduce((a, d) => a + d.predicted_orders, 0);
    for (const d of ranked) {
      d.share_of_week_pct = weekTotalOrders > 0
        ? round((d.predicted_orders / weekTotalOrders) * 100, 1)
        : null;
    }

    const totalSampleOrders = dowRows.reduce((a, r) => a + Number(r.total_orders || 0), 0);
    const maxSampleDays = dowRows.reduce((m, r) => Math.max(m, Number(r.distinct_days || 0)), 0);
    const confidence = confidenceLevel({ sampleDays: maxSampleDays, totalOrders: totalSampleOrders });

    return {
      is_prediction: true,
      prediction_type: 'busy_days',
      methodology:
        'Rank next week calendar days by the historical average daily orders for matching weekdays.',
      confidence,
      history_days: historyDays,
      next_week: { start_date: nextWeek.start_date, end_date: nextWeek.end_date },
      ranked_days: ranked,
      busiest_day: ranked[0] || null,
      quietest_day: ranked[ranked.length - 1] || null,
      empty: dowRows.length === 0,
    };
  },
};

const predictTopItems = {
  name: 'predict_top_items',
  description:
    'Forecast which menu items are likely to lead next week based on recent revenue momentum and run-rate.',
  params: { limit: 'integer 5..20, default 10', history_days: 'integer 14..60, default 28' },
  cacheTtlSec: 300,
  followups: PREDICTION_FOLLOWUPS,
  async run({ dts, params }) {
    const n = Math.max(5, Math.min(20, limit(params, 10)));
    const historyDays = clampHistoryDays(params, 28);
    const recentDays = Math.min(7, historyDays);
    const priorDays = Math.min(7, historyDays - recentDays);

    const recentRows = await db.runQuery(dts, `
      SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)')) AS dish_label,
             SUM(i.subtotal) AS line_revenue,
             COUNT(*) AS line_count
      FROM app_order_items i
      INNER JOIN app_orders o ON o.order_id = i.order_id
      WHERE o.status NOT IN ('cancelled')
        AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)'))
    `, [recentDays]);

    let priorRows = [];
    if (priorDays > 0) {
      priorRows = await db.runQuery(dts, `
        SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)')) AS dish_label,
               SUM(i.subtotal) AS line_revenue,
               COUNT(*) AS line_count
        FROM app_order_items i
        INNER JOIN app_orders o ON o.order_id = i.order_id
        WHERE o.status NOT IN ('cancelled')
          AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
          AND o.created_at <  DATE_SUB(CURDATE(), INTERVAL ? DAY)
        GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)'))
      `, [recentDays + priorDays, recentDays]);
    }

    const priorMap = new Map(priorRows.map((r) => [r.dish_label, Number(r.line_revenue || 0)]));
    const recentTotal = recentRows.reduce((a, r) => a + Number(r.line_revenue || 0), 0);

    const scored = recentRows.map((r) => {
      const recentRev = Number(r.line_revenue || 0);
      const priorRev = priorMap.get(r.dish_label) || 0;
      const momentumPct = pctChange(recentRev, priorRev);
      const dailyRunRate = recentRev / Math.max(1, recentDays);
      const projectedWeekRevenue = round(dailyRunRate * 7 * (momentumPct != null && momentumPct > 0 ? 1 + momentumPct / 200 : 1), 0);
      return {
        dish_label: r.dish_label,
        recent_revenue: round(recentRev, 0),
        recent_line_count: Number(r.line_count || 0),
        prior_revenue: round(priorRev, 0),
        momentum_pct: momentumPct,
        projected_next_week_revenue: projectedWeekRevenue,
        recent_share_pct: recentTotal > 0 ? round((recentRev / recentTotal) * 100, 1) : null,
      };
    });

    scored.sort((a, b) => b.projected_next_week_revenue - a.projected_next_week_revenue);
    const top = scored.slice(0, n);
    const projectedTotal = top.reduce((a, r) => a + r.projected_next_week_revenue, 0);

    const totalLines = recentRows.reduce((a, r) => a + Number(r.line_count || 0), 0);
    const confidence = confidenceLevel({
      sampleDays: recentDays + priorDays,
      totalOrders: totalLines,
    });

    return {
      is_prediction: true,
      prediction_type: 'top_items',
      methodology:
        'Project each item next-week revenue from its recent daily run-rate, with a mild uplift when 7-day momentum is positive.',
      confidence,
      recent_window_days: recentDays,
      prior_window_days: priorDays,
      projected_top_items: top,
      projected_top_items_total_revenue: projectedTotal,
      empty: recentRows.length === 0,
    };
  },
};

const predictCancellationRisk = {
  name: 'predict_cancellation_risk',
  description:
    'Forecast cancellation risk next week based on recent cancellation rate trends and items most often cancelled.',
  params: { history_days: 'integer 14..60, default 28' },
  cacheTtlSec: 300,
  followups: PREDICTION_FOLLOWUPS,
  async run({ dts, params }) {
    const historyDays = clampHistoryDays(params, 28);
    const half = Math.floor(historyDays / 2);

    const totals = await db.runQuery(dts, `
      SELECT
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY) THEN 1 ELSE 0 END) AS recent_total,
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
                  AND status = 'cancelled' THEN 1 ELSE 0 END) AS recent_cancelled,
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
                  AND created_at <  DATE_SUB(CURDATE(), INTERVAL ? DAY) THEN 1 ELSE 0 END) AS prior_total,
        SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
                  AND created_at <  DATE_SUB(CURDATE(), INTERVAL ? DAY)
                  AND status = 'cancelled' THEN 1 ELSE 0 END) AS prior_cancelled
      FROM app_orders
    `, [half, half, historyDays, half, historyDays, half, half]);

    const t = totals[0] || {};
    const recentTotal = Number(t.recent_total || 0);
    const priorTotal = Number(t.prior_total || 0);
    const recentRate = recentTotal > 0 ? (Number(t.recent_cancelled || 0) / recentTotal) * 100 : 0;
    const priorRate = priorTotal > 0 ? (Number(t.prior_cancelled || 0) / priorTotal) * 100 : 0;
    const rateTrend = pctChange(recentRate, priorRate);

    const nextWeekSales = await predictNextWeekSales.run({ dts, params: { history_weeks: 4 } });
    const projectedOrders = Number(nextWeekSales.next_week && nextWeekSales.next_week.predicted_orders) || 0;
    const projectedCancelRate = round(recentRate * (rateTrend != null && rateTrend > 0 ? 1 + rateTrend / 200 : 1), 2);
    const projectedCancellations = round(projectedOrders * (projectedCancelRate / 100), 1);

    const riskyItems = await db.runQuery(dts, `
      SELECT TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)')) AS dish_label,
             COUNT(*) AS cancelled_lines,
             COALESCE(SUM(i.subtotal), 0) AS amount_in_cancelled
      FROM app_order_items i
      INNER JOIN app_orders o ON o.order_id = i.order_id
      WHERE o.status = 'cancelled'
        AND o.created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
      GROUP BY TRIM(COALESCE(NULLIF(i.item_name,''), NULLIF(i.item_code,''), '(unnamed)'))
      ORDER BY cancelled_lines DESC
      LIMIT 5
    `, [historyDays]);

    const confidence = confidenceLevel({
      sampleDays: historyDays,
      totalOrders: recentTotal + priorTotal,
    });

    return {
      is_prediction: true,
      prediction_type: 'cancellation_risk',
      methodology:
        'Apply the recent cancellation rate (with mild trend adjustment) to the projected next-week order forecast.',
      confidence,
      history_days: historyDays,
      recent_cancellation_rate_pct: round(recentRate, 2),
      prior_cancellation_rate_pct: round(priorRate, 2),
      rate_trend_pct: rateTrend,
      projected_next_week_cancellations: projectedCancellations,
      projected_next_week_cancel_rate_pct: projectedCancelRate,
      projected_next_week_orders: projectedOrders,
      high_risk_items: riskyItems,
      empty: recentTotal === 0 && priorTotal === 0,
    };
  },
};

module.exports = [
  predictPeakHours,
  predictNextWeekSales,
  predictBusyDays,
  predictTopItems,
  predictCancellationRisk,
];
