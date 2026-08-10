'use strict';

const { queryMenu } = require('./menu-utils');
const { limit } = require('../../util/dates');

module.exports = {
  name: 'menu_recommend',
  description:
    'Recommend or steer guests away from dishes. USE THIS for price limits, allergen-safe options, dietary filters, ' +
    'AND for "what do you recommend" / "what should I avoid" / "what is least popular / not recommended" questions. ' +
    'For vague "cheap/affordable/budget" with NO number: omit max_price (returns cheapest first). ' +
    'For explicit caps set max_price in company currency (e.g. IDR 50000, MYR 20 — never invent 20 for IDR). ' +
    'Also for allergen-safe options (exclude nuts/dairy/gluten/shellfish) AND the opposite — finding dishes that DO ' +
    'contain a given allergen (e.g. "do you have anything with nuts", "what contains dairy"). ' +
    'Set sort="popularity_high" for best-selling picks, or sort="popularity_low" for "not recommended" / ' +
    '"least ordered" / "what should I skip" questions — ranks by real order history, low to high. ' +
    'Set sort="price_desc" for "most expensive" / "priciest" / "highest price" questions. ' +
    'Returns items with prices in branch currency.',
  params: {
    max_price: 'optional number — only when guest states an explicit max price in company currency (alias: max_price_rm). Omit for vague affordable/cheap.',
    min_price: 'optional number — minimum price (alias: min_price_rm)',
    exclude_allergens: 'optional string or list — allergens the guest wants to AVOID, e.g. "nuts", "dairy, gluten". Use when they ask what is safe to eat.',
    contains_allergens: 'optional string or list — allergens the guest is asking WHICH dishes contain, e.g. "nuts". Use when they ask "do you have anything with X" / "what has X in it" — the opposite of exclude_allergens.',
    category: 'optional string — must exactly match one of MENU_CATEGORIES from the router prompt (e.g. "Main", "Drinks"). Omit if the guest\'s wording does not clearly match a real category.',
    keyword: 'optional string or array of strings — search terms, matched against dish name/description/category (any term may match). For a food TYPE rather than one dish (e.g. "bread", "seafood"), pass an array including a few concrete related words (e.g. ["bread","pastry","croissant","baguette"]) since this is a plain substring match with no built-in synonyms. Fix obvious typos before searching.',
    halal_only: 'optional boolean, tri-state: true = only halal, false = only NON-halal (e.g. "what is not halal"), omit = no filter.',
    vegetarian_only: 'optional boolean, tri-state: true = only vegetarian, false = only non-vegetarian, omit = no filter.',
    spicy_only: 'optional boolean, tri-state: true = only spicy, false = only non-spicy/mild, omit = no filter.',
    sort: 'optional: "price" (default, cheapest first) | "price_desc" (most expensive first) | "popularity_high" (best-selling first) | "popularity_low" (least-ordered first, i.e. "not recommended")',
    days: 'optional integer 1..90, default 30 — order-history window used when sort is popularity_high/popularity_low',
    limit: 'integer, always capped at 5 regardless of what is requested',
  },
  cacheTtlSec: 90,
  followups: [
    { label: 'Budget picks', question: 'What affordable dishes do you recommend?' },
    { label: 'No nuts', question: 'I am allergic to nuts — what can I eat?' },
    { label: 'Contains nuts', question: 'Do you have any food that contains nuts?' },
    { label: 'Halal picks', question: 'What halal dishes do you recommend?' },
  ],
  async run({ dts, params }) {
    const MAX_RESULTS = 5;
    const p = { ...params, limit: Math.min(limit(params, MAX_RESULTS), MAX_RESULTS) };
    const result = await queryMenu({ dts, params: p, defaultLimit: MAX_RESULTS });

    const sort = result.filter.sort;
    const recommendationType = sort === 'popularity_low'
      ? 'not_recommended'
      : sort === 'popularity_high'
        ? 'best_selling'
        : sort === 'price_desc'
          ? 'most_expensive'
          : 'filtered_menu';

    return {
      ...result,
      recommendation_type: result.filter.contains_allergens.length ? 'contains_allergen' : recommendationType,
      price_cap: result.filter.max_price,
      allergens_excluded: result.filter.exclude_allergens,
      allergens_matched: result.filter.contains_allergens,
    };
  },
};
