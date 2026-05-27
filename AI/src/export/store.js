'use strict';

const crypto = require('crypto');

/** @type {Map<string, object>} */
const tokens = new Map();
const TTL_MS = 20 * 60 * 1000;

function prune() {
  const now = Date.now();
  for (const [k, v] of tokens) {
    if (now - v.created > TTL_MS) tokens.delete(k);
  }
}

function createToken(entry) {
  prune();
  const token = crypto.randomBytes(24).toString('hex');
  tokens.set(token, { ...entry, created: Date.now() });
  return token;
}

function getToken(token) {
  prune();
  const entry = tokens.get(token);
  if (!entry) return null;
  if (Date.now() - entry.created > TTL_MS) {
    tokens.delete(token);
    return null;
  }
  return entry;
}

function consumeToken(token) {
  const entry = getToken(token);
  if (!entry) return null;
  return entry;
}

module.exports = { createToken, getToken, consumeToken, TTL_MS };
