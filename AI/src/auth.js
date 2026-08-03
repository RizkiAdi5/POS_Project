'use strict';

const config = require('./config');
const db = require('./db');

const ADMIN_ROLES = new Set(['super', 'admin']);
const CUSTOMER_ROLES = new Set(['customer']);

function timingSafeEqual(a, b) {
  if (typeof a !== 'string' || typeof b !== 'string') return false;
  if (a.length !== b.length) return false;
  let mismatch = 0;
  for (let i = 0; i < a.length; i++) {
    mismatch |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }
  return mismatch === 0;
}

function checkSharedSecret(req) {
  const got = req.get('x-ai-secret') || '';
  return timingSafeEqual(got, config.http.sharedSecret);
}

// Validated against main.users (the same source CF's own login trusts) instead of a
// static allowlist, so a new tenant works immediately without touching .env or restarting.
async function checkDts(dts) {
  return db.isKnownTenant(dts);
}

function checkAdminRole(role) {
  return ADMIN_ROLES.has(String(role || '').toLowerCase());
}

function checkCustomerRole(role) {
  return CUSTOMER_ROLES.has(String(role || '').toLowerCase());
}

/** @deprecated use checkAdminRole */
function checkRole(role) {
  return checkAdminRole(role);
}

function authMiddleware(req, res, next) {
  if (!checkSharedSecret(req)) {
    return res.status(401).json({ error: 'bad_secret' });
  }
  next();
}

module.exports = {
  authMiddleware,
  checkDts,
  checkRole,
  checkAdminRole,
  checkCustomerRole,
};
