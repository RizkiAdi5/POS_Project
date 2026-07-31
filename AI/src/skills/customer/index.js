'use strict';

const menuCatalog = require('./menu-catalog');
const menuRecommend = require('./menu-recommend');
const menuPopular = require('./menu-popular');
const menuPromotions = require('./menu-promotions');
const myOrder = require('./my-order');
const diningHelp = require('./dining-help');
const restaurantHours = require('./restaurant-hours');

const ALL = [menuCatalog, menuRecommend, menuPopular, menuPromotions, myOrder, diningHelp, restaurantHours];

const byName = new Map();
for (const s of ALL) {
  if (!s || !s.name || typeof s.run !== 'function') {
    throw new Error(`Invalid customer skill: ${JSON.stringify(s)}`);
  }
  if (byName.has(s.name)) throw new Error(`Duplicate customer skill: ${s.name}`);
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
