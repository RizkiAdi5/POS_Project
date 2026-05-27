'use strict';

const ExcelJS = require('exceljs');
const db = require('../db');

function num(v) {
  const n = parseFloat(v);
  return Number.isFinite(n) ? n : 0;
}

function sheetName(base, idx) {
  const s = String(base || 'Data').replace(/[\\/*?:\[\]]/g, ' ').slice(0, 28);
  return idx > 0 ? `${s.slice(0, 25)}_${idx}` : s;
}

function addTableSheet(wb, name, columns, rows) {
  const ws = wb.addWorksheet(sheetName(name));
  ws.columns = columns.map((c) => ({
    header: c.header,
    key: c.key,
    width: c.width || 16,
  }));
  const headerRow = ws.getRow(1);
  headerRow.font = { bold: true };
  headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE8EEF4' } };
  rows.forEach((r) => ws.addRow(r));
  ws.autoFilter = { from: 'A1', to: { row: 1, column: columns.length } };
  return ws;
}

function addSummarySheet(wb, title, pairs) {
  const ws = wb.addWorksheet('Summary');
  ws.getCell('A1').value = title;
  ws.getCell('A1').font = { bold: true, size: 14 };
  let row = 3;
  pairs.forEach(([label, value]) => {
    ws.getCell(`A${row}`).value = label;
    ws.getCell(`A${row}`).font = { bold: true };
    ws.getCell(`B${row}`).value = value;
    row += 1;
  });
  ws.getColumn(1).width = 28;
  ws.getColumn(2).width = 22;
}

async function fetchMonthDaily(dts) {
  return db.runQuery(dts, `
    SELECT DATE(created_at) AS order_date,
           COUNT(*) AS order_count,
           COALESCE(SUM(total_amount), 0) AS amount_total,
           COALESCE(AVG(total_amount), 0) AS avg_basket
    FROM app_orders
    WHERE status NOT IN ('cancelled')
      AND created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
      AND created_at < DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
    GROUP BY DATE(created_at)
    ORDER BY DATE(created_at) ASC
  `);
}

async function fetchMonthOrders(dts, limit) {
  return db.runQuery(dts, `
    SELECT order_number, DATE(created_at) AS order_date,
           status, subtotal, tax_amount, total_amount, order_type
    FROM app_orders
    WHERE status NOT IN ('cancelled')
      AND created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
      AND created_at < DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
    ORDER BY created_at DESC
    LIMIT ?
  `, [limit]);
}

async function enrichFacts(dts, skill, params, facts) {
  const extra = {};
  if (skill === 'month_to_date' || skill === 'overview_snapshot' || skill === 'top_items_month') {
    extra.daily_this_month = await fetchMonthDaily(dts);
    extra.orders_this_month = await fetchMonthOrders(dts, 500);
  }
  if (skill === 'sales_trend_days' && params.days) {
    /* facts already has daily */
  }
  return { ...facts, _export_extra: extra };
}

function buildFromFacts(skill, facts, meta) {
  const wb = new ExcelJS.Workbook();
  wb.creator = 'POS AI Business Analyst';
  wb.created = new Date();
  const extra = facts._export_extra || {};

  const infoPairs = [
    ['Report', meta.title || skill],
    ['Branch (dts)', meta.dts || ''],
    ['Question', meta.question || ''],
    ['Generated', new Date().toISOString()],
    ['Skill', skill],
  ];
  const cur = facts.currency;
  if (cur && (cur.code || cur.symbol)) {
    const label = [String(cur.symbol || '').trim(), String(cur.code || '').trim()].filter(Boolean).join(' ');
    infoPairs.splice(1, 0, ['Currency', label || cur.code || cur.symbol]);
  }
  addSummarySheet(wb, meta.title || 'AI Analyst Export', infoPairs);

  switch (skill) {
    case 'today_sales': {
      const t = facts.totals || {};
      addTableSheet(wb, 'Today Totals', [
        { header: 'Metric', key: 'metric', width: 22 },
        { header: 'Value', key: 'value', width: 18 },
      ], [
        { metric: 'Order count', value: num(t.order_count) },
        { metric: 'Revenue total', value: num(t.amount_total) },
        { metric: 'Average basket', value: num(t.avg_basket) },
        { metric: 'Date', value: facts.date || '' },
      ]);
      if (Array.isArray(facts.by_status) && facts.by_status.length) {
        addTableSheet(wb, 'By Status', [
          { header: 'Status', key: 'status', width: 16 },
          { header: 'Orders', key: 'order_count', width: 12 },
          { header: 'Amount', key: 'amount_total', width: 14 },
        ], facts.by_status.map((r) => ({
          status: r.status,
          order_count: num(r.order_count),
          amount_total: num(r.amount_total),
        })));
      }
      break;
    }
    case 'sales_trend_days': {
      addTableSheet(wb, 'Daily Sales', [
        { header: 'Date', key: 'day', width: 14 },
        { header: 'Orders', key: 'order_count', width: 12 },
        { header: 'Revenue', key: 'amount_total', width: 14 },
      ], (facts.daily || []).map((r) => ({
        day: r.day,
        order_count: num(r.order_count),
        amount_total: num(r.amount_total),
      })));
      addTableSheet(wb, 'Window Summary', [
        { header: 'Metric', key: 'metric', width: 22 },
        { header: 'Value', key: 'value', width: 16 },
      ], [
        { metric: 'Window (days)', value: facts.window_days },
        { metric: 'Total orders', value: facts.total_orders },
        { metric: 'Total revenue', value: facts.total_amount },
        { metric: 'Avg orders/day', value: Math.round((facts.avg_orders_per_day || 0) * 100) / 100 },
      ]);
      break;
    }
    case 'compare_weeks': {
      addTableSheet(wb, 'Week Comparison', [
        { header: 'Period', key: 'period', width: 16 },
        { header: 'Revenue', key: 'amount', width: 14 },
        { header: 'Orders', key: 'orders', width: 12 },
      ], [
        { period: 'This week', amount: num(facts.this_week && facts.this_week.amount), orders: num(facts.this_week && facts.this_week.orders) },
        { period: 'Last week', amount: num(facts.last_week && facts.last_week.amount), orders: num(facts.last_week && facts.last_week.orders) },
        { period: 'Change %', amount: facts.amount_change_pct != null ? facts.amount_change_pct : 'N/A', orders: '' },
      ]);
      break;
    }
    case 'month_to_date': {
      const mtd = facts.this_month_to_date || {};
      const lm = facts.last_month_same_period || {};
      addTableSheet(wb, 'MTD Comparison', [
        { header: 'Period', key: 'period', width: 22 },
        { header: 'Revenue', key: 'amount', width: 14 },
        { header: 'Orders', key: 'orders', width: 12 },
      ], [
        { period: 'This month (to date)', amount: num(mtd.amount), orders: num(mtd.orders) },
        { period: 'Last month (same period)', amount: num(lm.amount), orders: num(lm.orders) },
        { period: 'Change %', amount: facts.amount_change_pct != null ? facts.amount_change_pct : 'N/A', orders: '' },
      ]);
      if (extra.daily_this_month && extra.daily_this_month.length) {
        addTableSheet(wb, 'Daily This Month', [
          { header: 'Date', key: 'order_date', width: 14 },
          { header: 'Orders', key: 'order_count', width: 12 },
          { header: 'Revenue', key: 'amount_total', width: 14 },
          { header: 'Avg basket', key: 'avg_basket', width: 14 },
        ], extra.daily_this_month.map((r) => ({
          order_date: r.order_date,
          order_count: num(r.order_count),
          amount_total: num(r.amount_total),
          avg_basket: num(r.avg_basket),
        })));
      }
      if (extra.orders_this_month && extra.orders_this_month.length) {
        addTableSheet(wb, 'Orders This Month', [
          { header: 'Order #', key: 'order_number', width: 18 },
          { header: 'Date', key: 'order_date', width: 14 },
          { header: 'Status', key: 'status', width: 12 },
          { header: 'Subtotal', key: 'subtotal', width: 12 },
          { header: 'Tax', key: 'tax_amount', width: 10 },
          { header: 'Total', key: 'total_amount', width: 12 },
          { header: 'Type', key: 'order_type', width: 12 },
        ], extra.orders_this_month.map((r) => ({
          order_number: r.order_number,
          order_date: r.order_date,
          status: r.status,
          subtotal: num(r.subtotal),
          tax_amount: num(r.tax_amount),
          total_amount: num(r.total_amount),
          order_type: r.order_type,
        })));
      }
      break;
    }
    case 'revenue_by_weekday': {
      addTableSheet(wb, 'By Weekday', [
        { header: 'Day', key: 'dow_name', width: 14 },
        { header: 'Orders', key: 'order_count', width: 12 },
        { header: 'Revenue', key: 'amount_total', width: 14 },
      ], (facts.by_weekday || []).map((r) => ({
        dow_name: r.dow_name,
        order_count: num(r.order_count),
        amount_total: num(r.amount_total),
      })));
      break;
    }
    case 'weekend_vs_weekday': {
      const rows = [];
      if (facts.buckets) {
        Object.keys(facts.buckets).forEach((k) => {
          const b = facts.buckets[k];
          rows.push({
            bucket: k,
            order_count: num(b.order_count),
            amount_total: num(b.amount_total),
            day_count: num(b.day_count),
            amount_per_day: Math.round(num(b.amount_per_day) * 100) / 100,
          });
        });
      }
      addTableSheet(wb, 'Weekend vs Weekday', [
        { header: 'Bucket', key: 'bucket', width: 14 },
        { header: 'Orders', key: 'order_count', width: 12 },
        { header: 'Revenue', key: 'amount_total', width: 14 },
        { header: 'Days', key: 'day_count', width: 10 },
        { header: 'Revenue/day', key: 'amount_per_day', width: 14 },
      ], rows);
      break;
    }
    case 'overview_snapshot': {
      if (facts.last_5_month_sales && facts.last_5_month_sales.length) {
        addTableSheet(wb, 'Monthly Sales AR', [
          { header: 'Period', key: 'fperiod', width: 12 },
          { header: 'Customer', key: 'name', width: 24 },
          { header: 'Revenue', key: 'sumgrand', width: 14 },
        ], facts.last_5_month_sales.map((r) => ({
          fperiod: r.fperiod,
          name: r.name,
          sumgrand: num(r.sumgrand),
        })));
      }
      if (facts.top_5_customers && facts.top_5_customers.length) {
        addTableSheet(wb, 'Top Customers', [
          { header: 'Customer', key: 'name', width: 24 },
          { header: 'Revenue', key: 'sumgrand', width: 14 },
        ], facts.top_5_customers.map((r) => ({
          name: r.name,
          sumgrand: num(r.sumgrand),
        })));
      }
      if (facts.emenu_month_daily && facts.emenu_month_daily.length) {
        addTableSheet(wb, 'E-Menu Daily', [
          { header: 'Day', key: 'day_num', width: 10 },
          { header: 'Revenue', key: 'day_total', width: 14 },
          { header: 'Orders', key: 'order_count', width: 12 },
        ], facts.emenu_month_daily.map((r) => ({
          day_num: r.day_num,
          day_total: num(r.day_total),
          order_count: num(r.order_count),
        })));
      }
      if (facts.emenu_top_items_month && facts.emenu_top_items_month.length) {
        addTableSheet(wb, 'Top Items Month', [
          { header: 'Item', key: 'dish_label', width: 28 },
          { header: 'Revenue', key: 'line_revenue', width: 14 },
        ], facts.emenu_top_items_month.map((r) => ({
          dish_label: r.dish_label,
          line_revenue: num(r.line_revenue),
        })));
      }
      if (extra.orders_this_month && extra.orders_this_month.length) {
        addTableSheet(wb, 'Orders This Month', [
          { header: 'Order #', key: 'order_number', width: 18 },
          { header: 'Date', key: 'order_date', width: 14 },
          { header: 'Status', key: 'status', width: 12 },
          { header: 'Total', key: 'total_amount', width: 12 },
        ], extra.orders_this_month.map((r) => ({
          order_number: r.order_number,
          order_date: r.order_date,
          status: r.status,
          total_amount: num(r.total_amount),
        })));
      }
      break;
    }
    case 'top_items_month':
    case 'top_items_last_days':
    case 'slow_movers_month': {
      const items = facts.items || [];
      addTableSheet(wb, 'Menu Items', [
        { header: 'Item', key: 'dish_label', width: 28 },
        { header: 'Revenue', key: 'line_revenue', width: 14 },
        { header: 'Line count', key: 'line_count', width: 12 },
      ], items.map((r) => ({
        dish_label: r.dish_label,
        line_revenue: num(r.line_revenue),
        line_count: num(r.line_count),
      })));
      break;
    }
    case 'peak_hours': {
      addTableSheet(wb, 'By Hour', [
        { header: 'Hour', key: 'hour_of_day', width: 10 },
        { header: 'Orders', key: 'order_count', width: 12 },
        { header: 'Revenue', key: 'amount_total', width: 14 },
      ], (facts.by_hour || []).map((r) => ({
        hour_of_day: r.hour_of_day,
        order_count: num(r.order_count),
        amount_total: num(r.amount_total),
      })));
      break;
    }
    case 'cancellations_recent': {
      const t = facts.totals || {};
      addTableSheet(wb, 'Cancellations', [
        { header: 'Metric', key: 'metric', width: 22 },
        { header: 'Value', key: 'value', width: 14 },
      ], [
        { metric: 'Window (days)', value: facts.window_days },
        { metric: 'Cancelled orders', value: num(t.cancelled_count) },
        { metric: 'Amount lost', value: num(t.amount_lost) },
      ]);
      if (facts.top_items_in_cancelled_orders && facts.top_items_in_cancelled_orders.length) {
        addTableSheet(wb, 'Top Cancelled Items', [
          { header: 'Item', key: 'dish_label', width: 28 },
          { header: 'Lines', key: 'lines_in_cancelled', width: 12 },
          { header: 'Amount', key: 'amount_in_cancelled', width: 14 },
        ], facts.top_items_in_cancelled_orders.map((r) => ({
          dish_label: r.dish_label,
          lines_in_cancelled: num(r.lines_in_cancelled),
          amount_in_cancelled: num(r.amount_in_cancelled),
        })));
      }
      break;
    }
    case 'basket_stats': {
      const s = facts.stats || {};
      addTableSheet(wb, 'Basket Stats', [
        { header: 'Metric', key: 'metric', width: 22 },
        { header: 'Value', key: 'value', width: 14 },
      ], [
        { metric: 'Window (days)', value: facts.window_days },
        { metric: 'Orders', value: num(s.order_count) },
        { metric: 'Avg basket', value: num(s.avg_basket) },
        { metric: 'Min basket', value: num(s.min_basket) },
        { metric: 'Max basket', value: num(s.max_basket) },
        { metric: 'Total revenue', value: num(s.amount_total) },
      ]);
      break;
    }
    case 'tables_status_now': {
      const c = facts.counts || {};
      const s = facts.seats || {};
      addTableSheet(wb, 'Tables Now', [
        { header: 'Status', key: 'status', width: 14 },
        { header: 'Tables', key: 'table_count', width: 12 },
        { header: 'Seats', key: 'seat_count', width: 12 },
      ], [
        { status: 'Available', table_count: num(c.available), seat_count: num(s.available) },
        { status: 'Occupied', table_count: num(c.occupied), seat_count: num(s.occupied) },
        { status: 'Reserved', table_count: num(c.reserved), seat_count: num(s.reserved) },
        { status: 'Total', table_count: num(facts.total_tables), seat_count: num(s.available) + num(s.occupied) + num(s.reserved) },
      ]);
      break;
    }
    case 'orders_by_status': {
      addTableSheet(wb, 'Orders by Status', [
        { header: 'Status', key: 'status', width: 16 },
        { header: 'Orders', key: 'order_count', width: 12 },
        { header: 'Revenue', key: 'amount_total', width: 14 },
      ], (facts.by_status || []).map((r) => ({
        status: r.status,
        order_count: num(r.order_count),
        amount_total: num(r.amount_total),
      })));
      addTableSheet(wb, 'Window', [
        { header: 'Metric', key: 'metric', width: 22 },
        { header: 'Value', key: 'value', width: 14 },
      ], [
        { metric: 'Window (days)', value: facts.window_days },
        { metric: 'Total orders', value: facts.total_orders },
      ]);
      break;
    }
    default: {
      /* Generic: first array in facts as detail */
      const arrays = Object.keys(facts).filter((k) => Array.isArray(facts[k]) && facts[k].length && k !== '_export_extra');
      if (arrays.length) {
        const key = arrays[0];
        const rows = facts[key];
        const cols = Object.keys(rows[0] || {}).map((c) => ({
          header: c,
          key: c,
          width: 16,
        }));
        addTableSheet(wb, key, cols, rows);
      }
    }
  }

  return wb;
}

function exportFilename(skill, dts) {
  const date = new Date().toISOString().slice(0, 10);
  const safeSkill = String(skill).replace(/[^a-z0-9_]/gi, '_');
  const safeDts = String(dts).replace(/[^a-z0-9_]/gi, '_');
  return `AI_Analyst_${safeSkill}_${safeDts}_${date}.xlsx`;
}

function exportTitle(skill) {
  const titles = {
    today_sales: 'E-Menu Sales Today',
    sales_trend_days: 'E-Menu Sales Trend',
    compare_weeks: 'Week vs Week Sales',
    month_to_date: 'Month-to-Date Sales',
    revenue_by_weekday: 'Revenue by Weekday',
    weekend_vs_weekday: 'Weekend vs Weekday Sales',
    overview_snapshot: 'Business Overview',
    top_items_month: 'Top Menu Items (Month)',
    peak_hours: 'Peak Hours',
    cancellations_recent: 'Cancellations Report',
    basket_stats: 'Basket Statistics',
  };
  return titles[skill] || `Report: ${skill}`;
}

const EXPORTABLE_SKILLS = new Set([
  'today_sales', 'sales_trend_days', 'compare_weeks', 'month_to_date',
  'revenue_by_weekday', 'weekend_vs_weekday', 'overview_snapshot',
  'top_items_month', 'top_items_last_days', 'slow_movers_month',
  'peak_hours', 'cancellations_recent', 'basket_stats', 'tables_status_now',
  'orders_by_status',
]);

function isExportable(skill) {
  return skill && skill !== 'none' && EXPORTABLE_SKILLS.has(skill);
}

async function buildExcelBuffer(dts, skill, params, facts, meta) {
  const enriched = await enrichFacts(dts, skill, params, facts);
  const wb = buildFromFacts(skill, enriched, meta);
  return wb.xlsx.writeBuffer();
}

module.exports = {
  isExportable,
  buildExcelBuffer,
  exportFilename,
  exportTitle,
  EXPORTABLE_SKILLS,
};
