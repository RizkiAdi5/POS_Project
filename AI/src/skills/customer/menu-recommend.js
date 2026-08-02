'use strict';

const { queryMenu } = require('./menu-utils');
const { limit } = require('../../util/dates');

module.exports = {
  name: 'menu_recommend',
  description:
    'Recommend dishes for guests. USE THIS for price limits, allergen-safe options, or dietary filters. ' +
    'For vague "cheap/affordable/budget" with NO number: omit max_price (returns cheapest first). ' +
    'For explicit caps set max_price in company currency (e.g. IDR 50000, MYR 20 — never invent 20 for IDR). ' +
    'Also for allergen-safe options (exclude nuts/dairy/gluten/shellfish). Returns items with prices in branch currency.',
  params: {
    max_price: 'optional number — only when guest states an explicit max price in company currency (alias: max_price_rm). Omit for vague affordable/cheap.',
    min_price: 'optional number — minimum price (alias: min_price_rm)',
    exclude_allergens: 'optional string or list — allergens to avoid, e.g. "nuts", "dairy, gluten"',
    category: 'optional string — category name',
    keyword: 'optional string — search term',
    halal_only: 'optional boolean',
    vegetarian_only: 'optional boolean',
    spicy_only: 'optional boolean',
    limit: 'integer 1..30, default 15',
  },
  cacheTtlSec: 90,
  followups: [
    { label: 'Budget picks', question: 'What affordable dishes do you recommend?' },
    { label: 'No nuts', question: 'I am allergic to nuts — what can I eat?' },
    { label: 'Halal picks', question: 'What halal dishes do you recommend?' },
    { label: 'Popular', question: 'What are the most popular dishes right now?' },
  ],
  async run({ dts, params }) {
    const p = { ...params, limit: limit(params, 15) };
    const result = await queryMenu({ dts, params: p, defaultLimit: 15 });

    return {
      ...result,
      recommendation_type: 'filtered_menu',
      price_cap: result.filter.max_price,
      allergens_excluded: result.filter.exclude_allergens,
    };
  },
};
