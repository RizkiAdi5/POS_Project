'use strict';

function clampInt(n, min, max, fallback) {
  const x = parseInt(n, 10);
  if (!Number.isFinite(x)) return fallback;
  return Math.max(min, Math.min(max, x));
}

// Returns a sensible "days" window for trend questions.
function days(params, fallback) {
  return clampInt(params && params.days, 1, 90, fallback);
}

// Returns a sensible "limit" for top-N queries.
function limit(params, fallback) {
  return clampInt(params && params.limit, 1, 50, fallback);
}

module.exports = { days, limit, clampInt };
