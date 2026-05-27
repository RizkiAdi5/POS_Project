'use strict';

const { queryMenu } = require('./menu-utils');

module.exports = {
  name: 'menu_search',
  description:
    'Browse or search the menu by category, keyword, or dietary flags (halal, vegetarian, spicy). ' +
    'For price limits or allergen avoidance, use menu_recommend instead.',
  params: {
    category: 'optional string — exact category name',
    keyword: 'optional string — search in name/description',
    halal_only: 'optional boolean',
    vegetarian_only: 'optional boolean',
    spicy_only: 'optional boolean',
    featured_only: 'optional boolean',
    max_price: 'optional number — max item price in company currency',
    min_price: 'optional number — min item price',
    exclude_allergens: 'optional string — allergens to avoid',
    limit: 'integer 1..30, default 12',
  },
  cacheTtlSec: 120,
  followups: [
    { label: 'Budget dishes', question: 'What affordable dishes are on the menu?' },
    { label: 'No dairy', question: 'I cannot eat dairy — what dishes are safe for me?' },
    { label: 'Halal picks', question: 'What halal dishes do you recommend?' },
    { label: 'Popular dishes', question: 'What are the most popular dishes right now?' },
  ],
  async run({ dts, params }) {
    return queryMenu({ dts, params, defaultLimit: 12 });
  },
};
