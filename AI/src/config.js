'use strict';

require('dotenv').config({ path: require('path').join(__dirname, '..', '.env') });

function req(name) {
  const v = process.env[name];
  if (!v || !String(v).trim()) {
    throw new Error(`Missing required env var: ${name}`);
  }
  return String(v).trim();
}

function opt(name, fallback) {
  const v = process.env[name];
  return v == null || String(v).trim() === '' ? fallback : String(v).trim();
}

const allowedDts = opt('ALLOWED_DTS', '')
  .split(',')
  .map((s) => s.trim())
  .filter(Boolean);

if (allowedDts.length === 0) {
  throw new Error('ALLOWED_DTS must list at least one branch database (e.g. pos_i).');
}

module.exports = {
  deepseek: {
    apiKey: req('DEEPSEEK_API_KEY'),
    baseUrl: opt('DEEPSEEK_BASE_URL', 'https://api.deepseek.com'),
    model: opt('DEEPSEEK_MODEL', 'deepseek-chat'),
  },
  db: {
    host: opt('DB_HOST', '127.0.0.1'),
    port: parseInt(opt('DB_PORT', '3306'), 10),
    user: req('DB_USER'),
    password: opt('DB_PASS', ''),
    allowedDts,
    queryTimeoutMs: parseInt(opt('QUERY_TIMEOUT_MS', '5000'), 10),
    rowLimit: parseInt(opt('ROW_LIMIT', '5000'), 10),
  },
  http: {
    host: opt('HOST', '127.0.0.1'),
    port: parseInt(opt('PORT', '8088'), 10),
    sharedSecret: req('AI_SHARED_SECRET'),
  },
  logging: {
    dir: opt('LOG_DIR', './logs'),
  },
  cache: {
    ttlSeconds: parseInt(opt('CACHE_TTL_SECONDS', '120'), 10),
  },
  restaurant: {
    name: opt('RESTAURANT_NAME', ''),
    hours: opt('RESTAURANT_HOURS', 'Monday–Sunday: 10:00 AM – 10:00 PM'),
    address: opt('RESTAURANT_ADDRESS', ''),
    phone: opt('RESTAURANT_PHONE', ''),
    notes: opt('RESTAURANT_NOTES', ''),
    timezone: opt('RESTAURANT_TIMEZONE', 'Asia/Kuala_Lumpur'),
  },
};
