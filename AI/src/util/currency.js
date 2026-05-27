'use strict';

const db = require('../db');

/** ISO codes typically shown without decimal places */
const ZERO_DECIMAL_CODES = new Set(['IDR', 'VND', 'JPY', 'KRW']);

const cache = new Map();

async function getCompanyCurrency(dts) {
  if (cache.has(dts)) return cache.get(dts);

  let out = {
    code: 'MYR',
    symbol: 'RM',
    name: 'Malaysian Ringgit',
    decimals: 2,
  };

  try {
    const rows = await db.runQuery(dts, `
      SELECT TRIM(g.bCurr) AS code,
             TRIM(c.currency) AS symbol,
             TRIM(c.Currency1) AS name
      FROM gsetup g
      LEFT JOIN currency c ON TRIM(c.currcode) = TRIM(g.bCurr)
      LIMIT 1
    `);
    if (rows.length && rows[0].code) {
      let code = String(rows[0].code).trim().toUpperCase();
      /* Legacy / typo: company profile sometimes stores "ID" instead of ISO IDR */
      if (code === 'ID' || code === 'RP') code = 'IDR';
      const symbol = String(rows[0].symbol || code).trim();
      out = {
        code,
        symbol,
        name: String(rows[0].name || code).trim(),
        decimals: ZERO_DECIMAL_CODES.has(code) ? 0 : 2,
      };
    }
  } catch (_) {
    /* keep default */
  }

  cache.set(dts, out);
  return out;
}

function roundMoney(amount, currency) {
  const decimals = currency && Number.isFinite(currency.decimals) ? currency.decimals : 2;
  const factor = Math.pow(10, decimals);
  return Math.round((parseFloat(amount) || 0) * factor) / factor;
}

function formatMoney(amount, currency) {
  const c = currency || { symbol: 'RM', decimals: 2 };
  const v = roundMoney(amount, c);
  const formatted = v.toLocaleString('en-US', {
    minimumFractionDigits: c.decimals,
    maximumFractionDigits: c.decimals,
  });
  return `${c.symbol} ${formatted}`;
}

/** Attach company currency block to skill FACTS (from gsetup + currency tables). */
async function withCurrency(dts, facts) {
  const currency = await getCompanyCurrency(dts);
  return { ...(facts || {}), currency };
}

module.exports = {
  getCompanyCurrency,
  roundMoney,
  formatMoney,
  withCurrency,
  ZERO_DECIMAL_CODES,
};
