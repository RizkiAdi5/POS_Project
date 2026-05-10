'use strict';

const config = require('./config');

const ALLOWED_ROLES = new Set(['super', 'suser']);

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

function checkDts(dts) {
  if (typeof dts !== 'string') return false;
  return config.db.allowedDts.includes(dts);
}

function checkRole(role) {
  return ALLOWED_ROLES.has(String(role || '').toLowerCase());
}

function authMiddleware(req, res, next) {
  if (!checkSharedSecret(req)) {
    return res.status(401).json({ error: 'bad_secret' });
  }
  next();
}

module.exports = { authMiddleware, checkDts, checkRole };
