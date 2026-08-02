'use strict';

const mysql = require('mysql2/promise');
const config = require('./config');

const pools = new Map();

// 'main' holds cross-tenant shared config (see CLAUDE.md) — including the users table
// that lists every real, active branch (userBranch/userDept). It's the same source of
// truth CF's own login already trusts, so we use it here instead of a static allowlist
// that would need a manual .env edit + restart every time a new tenant is onboarded.
let mainPool = null;
function getMainPool() {
  if (!mainPool) {
    mainPool = mysql.createPool({
      host: config.db.host,
      port: config.db.port,
      user: config.db.user,
      password: config.db.password,
      database: 'main',
      connectionLimit: 4,
      waitForConnections: true,
      enableKeepAlive: true,
      multipleStatements: false,
      dateStrings: true,
    });
  }
  return mainPool;
}

const tenantCache = new Map(); // dts -> { valid: bool, checkedAt: number }
const TENANT_CACHE_TTL_MS = 60 * 1000;

async function isKnownTenant(dts) {
  // Cheap shape check first — dts ends up as a literal MySQL database name (see below),
  // so reject anything that isn't a plain identifier before it ever reaches a query.
  if (typeof dts !== 'string' || !/^[a-zA-Z0-9_]+$/.test(dts)) return false;
  const cached = tenantCache.get(dts);
  if (cached && Date.now() - cached.checkedAt < TENANT_CACHE_TTL_MS) {
    return cached.valid;
  }
  let valid = false;
  try {
    const pool = getMainPool();
    const [rows] = await pool.query(
      "SELECT 1 FROM users WHERE (userBranch = ? OR userDept = ?) AND status = '1' LIMIT 1",
      [dts, dts]
    );
    valid = Array.isArray(rows) && rows.length > 0;
  } catch (_) {
    valid = false;
  }
  tenantCache.set(dts, { valid, checkedAt: Date.now() });
  return valid;
}

async function getPool(dts) {
  if (!(await isKnownTenant(dts))) {
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
  const pool = await getPool(dts);
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
  const pool = await getPool(dts);
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
  if (mainPool) {
    try { await mainPool.end(); } catch (_) {}
    mainPool = null;
  }
}

module.exports = { runQuery, runWrite, ping, shutdown, isKnownTenant };
