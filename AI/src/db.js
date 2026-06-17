'use strict';

const mysql = require('mysql2/promise');
const config = require('./config');

const pools = new Map();

function getPool(dts) {
  if (!config.db.allowedDts.includes(dts)) {
    throw new Error(`dts not allowed: ${dts}`);
  }
  let pool = pools.get(dts);
  if (!pool) {
    pool = mysql.createPool({
      host: config.db.host,
      port: config.db.port,
      user: config.db.user,
      password: config.db.password,
      database: dts,
      connectionLimit: 4,
      waitForConnections: true,
      enableKeepAlive: true,
      // mysql2 will only allow a single statement per query call by default.
      multipleStatements: false,
      dateStrings: true,
    });
    pools.set(dts, pool);
  }
  return pool;
}

// Some older MySQL/MariaDB versions don't know SESSION TRANSACTION READ ONLY
// (added 5.6.5) or MAX_EXECUTION_TIME (added 5.7.4). They're hardening only;
// mysql2 enforces a per-query timeout regardless. So we try once per pool and
// remember whether the server supports them.
const featureCache = new Map(); // dts -> { readOnly: bool, maxExec: bool, probed: bool }

async function probeFeatures(conn, dts) {
  let cached = featureCache.get(dts);
  if (cached && cached.probed) return cached;
  const flags = { readOnly: false, maxExec: false, probed: true };
  try { await conn.query('SET SESSION TRANSACTION READ ONLY'); flags.readOnly = true; }
  catch (_) {}
  try {
    await conn.query('SET SESSION MAX_EXECUTION_TIME=' + config.db.queryTimeoutMs);
    flags.maxExec = true;
  } catch (_) {}
  featureCache.set(dts, flags);
  return flags;
}

async function runQuery(dts, sql, params = []) {
  const pool = getPool(dts);
  const conn = await pool.getConnection();
  let flags = featureCache.get(dts);
  try {
    if (!flags || !flags.probed) {
      flags = await probeFeatures(conn, dts);
    } else {
      if (flags.readOnly) {
        try { await conn.query('SET SESSION TRANSACTION READ ONLY'); } catch (_) {}
      }
      if (flags.maxExec) {
        try { await conn.query('SET SESSION MAX_EXECUTION_TIME=' + config.db.queryTimeoutMs); } catch (_) {}
      }
    }
    const [rows] = await conn.query({ sql, timeout: config.db.queryTimeoutMs }, params);
    if (Array.isArray(rows) && rows.length > config.db.rowLimit) {
      return rows.slice(0, config.db.rowLimit);
    }
    return rows;
  } finally {
    if (flags && flags.readOnly) {
      try { await conn.query('SET SESSION TRANSACTION READ WRITE'); } catch (_) {}
    }
    conn.release();
  }
}

async function runWrite(dts, sql, params = []) {
  const pool = getPool(dts);
  const conn = await pool.getConnection();
  try {
    const [result] = await conn.query({ sql, timeout: config.db.queryTimeoutMs }, params);
    return result;
  } finally {
    conn.release();
  }
}

async function ping(dts) {
  const rows = await runQuery(dts, 'SELECT 1 AS ok');
  return Array.isArray(rows) && rows[0] && rows[0].ok === 1;
}

async function shutdown() {
  for (const [, pool] of pools) {
    try { await pool.end(); } catch (_) {}
  }
  pools.clear();
}

module.exports = { runQuery, runWrite, ping, shutdown };
