'use strict';

const config = require('../config');

const store = new Map();

function now() { return Date.now(); }

function get(key) {
  const hit = store.get(key);
  if (!hit) return null;
  if (hit.expires < now()) {
    store.delete(key);
    return null;
  }
  return hit.value;
}

function set(key, value, ttlSeconds) {
  const ttl = (ttlSeconds || config.cache.ttlSeconds) * 1000;
  store.set(key, { value, expires: now() + ttl });
}

function makeKey(parts) {
  return parts.map((p) => (typeof p === 'object' ? JSON.stringify(p) : String(p))).join('|');
}

module.exports = { get, set, makeKey };
