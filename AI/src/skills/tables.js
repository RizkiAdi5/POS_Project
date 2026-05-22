'use strict';

const db = require('../db');

const tablesStatusNow = {
  name: 'tables_status_now',
  description: 'Current state of dining tables: total, available, occupied, reserved, and seat capacity.',
  params: {},
  cacheTtlSec: 30,
  followups: [
    { label: 'Peak hours', question: 'Which hours of the day drive the most orders in the last 14 days?' },
    { label: 'Sales today', question: 'How is e-menu performing today by orders, revenue, and basket size?' },
    { label: 'Order status today', question: 'How are todays orders split by status (pending, confirmed, completed, cancelled)?' },
  ],
  async run({ dts }) {
    const rows = await db.runQuery(dts, `
      SELECT status, COUNT(*) AS row_count, COALESCE(SUM(seats), 0) AS seat_total
      FROM app_tables
      GROUP BY status
    `);
    const norm = (s) => {
      const x = String(s || '').toLowerCase().trim();
      if (['available', 'free', 'open'].includes(x)) return 'available';
      if (['reserved', 'booked'].includes(x)) return 'reserved';
      return 'occupied';
    };
    const buckets = { available: 0, occupied: 0, reserved: 0 };
    const seats = { available: 0, occupied: 0, reserved: 0 };
    for (const r of rows) {
      const k = norm(r.status);
      buckets[k] += Number(r.row_count || 0);
      seats[k] += Number(r.seat_total || 0);
    }
    const total = buckets.available + buckets.occupied + buckets.reserved;
    return {
      total_tables: total,
      counts: buckets,
      seats,
      empty: total === 0,
    };
  },
};

module.exports = [tablesStatusNow];
