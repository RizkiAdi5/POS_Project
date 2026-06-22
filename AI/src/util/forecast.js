'use strict';

const DAY_NAMES = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

function round(n, decimals = 0) {
  const f = 10 ** decimals;
  return Math.round(Number(n || 0) * f) / f;
}

function pctChange(current, previous) {
  const c = Number(current || 0);
  const p = Number(previous || 0);
  if (p === 0) return null;
  return round(((c - p) / p) * 100, 1);
}

/** Upcoming Mon–Sun after the current calendar week. */
function getNextWeekDays(fromDate = new Date()) {
  const today = new Date(fromDate);
  today.setHours(0, 0, 0, 0);
  const jsDow = today.getDay();
  const daysUntilNextMonday = jsDow === 0 ? 1 : (8 - jsDow);
  const start = new Date(today);
  start.setDate(today.getDate() + daysUntilNextMonday);

  const days = [];
  for (let i = 0; i < 7; i += 1) {
    const d = new Date(start);
    d.setDate(start.getDate() + i);
    days.push({
      date: d.toISOString().slice(0, 10),
      dow_mysql: d.getDay() + 1,
      day_name: DAY_NAMES[d.getDay()],
    });
  }
  return { start_date: days[0].date, end_date: days[6].date, days };
}

function confidenceLevel({ sampleDays, totalOrders }) {
  const days = Number(sampleDays || 0);
  const orders = Number(totalOrders || 0);
  if (days >= 28 && orders >= 100) return 'high';
  if (days >= 14 && orders >= 30) return 'medium';
  return 'low';
}

function clampHistoryDays(params, fallback = 28) {
  const n = parseInt(params && params.history_days, 10);
  if (!Number.isFinite(n)) return fallback;
  return Math.max(14, Math.min(90, n));
}

function clampHistoryWeeks(params, fallback = 4) {
  const n = parseInt(params && params.history_weeks, 10);
  if (!Number.isFinite(n)) return fallback;
  return Math.max(2, Math.min(8, n));
}

/** Build a lookup: `${dow}:${hour}` -> { avg_orders, avg_amount, sample_days } */
function buildHourlyDowMap(rows) {
  const map = new Map();
  for (const r of rows) {
    const key = `${r.dow}:${r.hour_of_day}`;
    const sampleDays = Math.max(1, Number(r.distinct_days || 0));
    map.set(key, {
      dow: Number(r.dow),
      hour_of_day: Number(r.hour_of_day),
      avg_orders: Number(r.total_orders || 0) / sampleDays,
      avg_amount: Number(r.total_amount || 0) / sampleDays,
      sample_days: sampleDays,
    });
  }
  return map;
}

/** Build a lookup: dow_mysql -> { avg_orders, avg_amount, sample_days } */
function buildDowMap(rows) {
  const map = new Map();
  for (const r of rows) {
    const sampleDays = Math.max(1, Number(r.distinct_days || 0));
    map.set(Number(r.dow), {
      dow: Number(r.dow),
      day_name: r.day_name || DAY_NAMES[(Number(r.dow) + 6) % 7],
      avg_orders: Number(r.total_orders || 0) / sampleDays,
      avg_amount: Number(r.total_amount || 0) / sampleDays,
      sample_days: sampleDays,
    });
  }
  return map;
}

module.exports = {
  DAY_NAMES,
  round,
  pctChange,
  getNextWeekDays,
  confidenceLevel,
  clampHistoryDays,
  clampHistoryWeeks,
  buildHourlyDowMap,
  buildDowMap,
};
