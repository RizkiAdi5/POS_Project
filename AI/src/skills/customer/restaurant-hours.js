'use strict';

const db = require('../../db');
const config = require('../../config');
const { withCurrency } = require('../../util/currency');

const settingsTableCache = new Map();

async function tableExists(dts, tableName) {
  const key = dts + ':' + tableName;
  if (settingsTableCache.has(key)) return settingsTableCache.get(key);
  let exists = false;
  try {
    const rows = await db.runQuery(dts, `
      SELECT COUNT(*) AS cnt
      FROM information_schema.TABLES
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = ?
    `, [tableName]);
    exists = rows.length > 0 && parseInt(rows[0].cnt, 10) > 0;
  } catch (_) {
    exists = false;
  }
  settingsTableCache.set(key, exists);
  return exists;
}

module.exports = {
  name: 'restaurant_hours',
  description:
    'Restaurant opening hours, closing time, address, phone, and general venue info. ' +
    'Use when guests ask when you open/close, operating hours, location, or contact.',
  params: {
    topic: 'optional: hours | location | contact | general — default hours',
  },
  cacheTtlSec: 600,
  followups: [
    { label: 'Menu help', question: 'What are the most popular dishes right now?' },
    { label: 'How to order', question: 'How do I place an order from the menu?' },
    { label: 'Pay bill', question: 'How do I pay my bill?' },
    { label: 'Halal menu', question: 'What halal dishes do you recommend?' },
  ],
  async run({ dts, params }) {
    const topic = String((params && params.topic) || 'hours').toLowerCase().trim();
    const r = config.restaurant || {};

    let dbSettings = null;
    if (await tableExists(dts, 'app_emenu_settings')) {
      try {
        const rows = await db.runQuery(dts, `
          SELECT restaurant_name, opening_hours, address, phone, extra_notes
          FROM app_emenu_settings
          LIMIT 1
        `);
        if (rows.length) dbSettings = rows[0];
      } catch (_) {
        /* table may exist with different columns */
      }
    }

    let companyName = '';
    let companyAddress = '';
    try {
      const gs = await db.runQuery(dts, `
        SELECT COMPANYID, desp, add1, add2, add3, tel
        FROM gsetup
        LIMIT 1
      `);
      if (gs.length) {
        companyName = String(gs[0].desp || gs[0].COMPANYID || '').trim();
        companyAddress = [gs[0].add1, gs[0].add2, gs[0].add3]
          .map((x) => String(x || '').trim())
          .filter(Boolean)
          .join(', ');
      }
    } catch (_) {
      /* gsetup optional */
    }

    const name = (dbSettings && dbSettings.restaurant_name)
      ? String(dbSettings.restaurant_name).trim()
      : (r.name || companyName || 'Restaurant');

    const hours = (dbSettings && dbSettings.opening_hours)
      ? String(dbSettings.opening_hours).trim()
      : (r.hours || 'Please ask staff for today\'s opening hours.');

    const address = (dbSettings && dbSettings.address)
      ? String(dbSettings.address).trim()
      : (r.address || companyAddress || '');

    const phone = (dbSettings && dbSettings.phone)
      ? String(dbSettings.phone).trim()
      : (r.phone || '');

    const notes = (dbSettings && dbSettings.extra_notes)
      ? String(dbSettings.extra_notes).trim()
      : (r.notes || '');

    const now = new Date();
    const localHint = {
      server_date: now.toISOString().slice(0, 10),
      server_time_utc: now.toISOString().slice(11, 19),
      timezone_note: r.timezone || 'Local kitchen hours may differ — see opening_hours text.',
    };

    return withCurrency(dts, {
      empty: false,
      topic,
      restaurant_name: name,
      opening_hours: hours,
      address,
      phone,
      extra_notes: notes,
      local_hint: localHint,
      source: dbSettings ? 'database' : 'config',
    });
  },
};
