'use strict';

const overview = require('./overview');
const sales = require('./sales');
const menu = require('./menu');
const orders = require('./orders');
const tables = require('./tables');
const predictions = require('./predictions');
const proactive = require('./proactive');

const ALL = [
  overview,
  ...sales,
  ...menu,
  ...orders,
  ...tables,
  ...predictions,
  ...proactive,
];

const byName = new Map();
for (const s of ALL) {
  if (!s || !s.name || typeof s.run !== 'function') {
    throw new Error(`Invalid skill registration: ${JSON.stringify(s)}`);
  }
  if (byName.has(s.name)) {
    throw new Error(`Duplicate skill name: ${s.name}`);
  }
  byName.set(s.name, s);
}

function listForRouter() {
  return ALL.map((s) => ({
    name: s.name,
    description: s.description,
    params: s.params || {},
  }));
}

function get(name) {
  return byName.get(name);
}

module.exports = { ALL, listForRouter, get };
