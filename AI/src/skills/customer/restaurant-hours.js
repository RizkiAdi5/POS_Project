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

function formatClock(raw) {
  const s = String(raw || '').trim();
  if (!s) return '';
  // Accept HH:MM or HH:MM:SS from <input type="time"> / MySQL TIME
  const m = s.match(/^(\d{1,2}):(\d{2})/);
  if (!m) return s;
  let h = parseInt(m[1], 10);
  const min = m[2];
  if (!Number.isFinite(h) || h < 0 || h > 23) return s;
  const ampm = h >= 12 ? 'PM' : 'AM';
  const h12 = h % 12 === 0 ? 12 : h % 12;
  return `${h12}:${min} ${ampm}`;
}

function buildHoursText(openFrom, openTo) {
  const from = formatClock(openFrom);
  const to = formatClock(openTo);
  if (from && to) return `Daily: ${from} – ${to}`;
  if (from) return `Opens daily from ${from}`;
  if (to) return `Open daily until ${to}`;
  return '';
}

async function loadGsetup(dts) {
  // Prefer query with hour columns; fall back if they do not exist yet.
  // Note: this branch gsetup uses compro* (Company Profile), not legacy desp/add1.
  try {
    const rows = await db.runQuery(dts, `
      SELECT COMPANYID, compro, compro2, compro3, compro4, compro5, compro6, compro7,
             open_from, open_to
      FROM gsetup
      LIMIT 1
    `);
    return rows[0] || null;
  } catch (_) {
    try {
      const rows = await db.runQuery(dts, `
        SELECT COMPANYID, compro, compro2, compro3, compro4, compro5, compro6, compro7
        FROM gsetup
        LIMIT 1
      `);
      return rows[0] || null;
    } catch (__) {
      return null;
    }
  }
}

module.exports = {
  name: 'restaurant_hours',
  description:
    'Restaurant opening hours, closing time, address, phone, and general venue info. ' +
    'Use when guests ask when you open/close, operating hours, location, or contact.',
  params: {
    topic: 'optional: hours | location | contact | general — default hours',
  },
  cacheTtlSec: 30,
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
    let gsetupHours = '';
    let openFrom = '';
    let openTo = '';
    let source = 'config';

    const g = await loadGsetup(dts);
    if (g) {
      companyName = String(g.compro || g.COMPANYID || '').trim();
      const comproAddr = [g.compro2, g.compro3, g.compro4, g.compro5, g.compro6, g.compro7]
        .map((x) => String(x || '').trim())
        .filter(Boolean);
      companyAddress = comproAddr.join(', ');

      openFrom = String(g.open_from || '').trim();
      openTo = String(g.open_to || '').trim();
      gsetupHours = buildHoursText(openFrom, openTo);
    }

    const name = (dbSettings && dbSettings.restaurant_name)
      ? String(dbSettings.restaurant_name).trim()
      : (r.name || companyName || 'Restaurant');

    // Priority: Company Profile (gsetup) → app_emenu_settings → AI/.env default
    let hours = '';
    if (gsetupHours) {
      hours = gsetupHours;
      source = 'gsetup';
    } else if (dbSettings && String(dbSettings.opening_hours || '').trim()) {
      hours = String(dbSettings.opening_hours).trim();
      source = 'database';
    } else {
      hours = r.hours || 'Please ask staff for today\'s opening hours.';
      source = 'config';
    }

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
      open_from: openFrom || null,
      open_to: openTo || null,
      address,
      phone,
      extra_notes: notes,
      local_hint: localHint,
      source,
    });
  },
};
