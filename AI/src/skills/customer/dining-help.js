'use strict';

const TOPICS = {
  ordering: {
    title: 'How to order',
    points: [
      'Browse the menu, tap + to add items to your cart, then tap Place Order.',
      'You can add more rounds ("Order More") until your bill is paid.',
      'Special instructions can be added per item before placing the order.',
    ],
  },
  payment: {
    title: 'Payment',
    points: [
      'When you are ready, open Pay Bill from the menu or order status page.',
      'Online payment (QRIS / e-wallet) is available where enabled; cash can be paid at the counter.',
      'After online payment succeeds, the order is marked paid and you cannot add more items.',
    ],
  },
  loyalty: {
    title: 'Loyalty points',
    points: [
      'Sign in with your account (not guest) to earn loyalty points on eligible orders.',
      'Points are typically awarded when your bill is paid — check your profile for balance.',
      'Guest orders do not earn points; create or log in to an account to collect rewards.',
    ],
  },
  status: {
    title: 'Order tracking',
    points: [
      'After placing an order, use Order Status to see kitchen progress per item.',
      'Statuses usually move from Pending → Preparing → Ready; refresh updates automatically.',
      'Ask me "where is my order?" anytime and I will check your current table order.',
    ],
  },
  general: {
    title: 'Dining at this restaurant',
    points: [
      'You are ordering from your table via QR — no need to download an app.',
      'For allergies or urgent requests, please inform staff at the counter.',
      'Need menu ideas? Ask for halal, vegetarian, spicy, or popular recommendations.',
    ],
  },
};

module.exports = {
  name: 'dining_help',
  description: 'General guest help: how to order, pay, loyalty points, track order status. No admin/business data.',
  params: { topic: 'optional: ordering | payment | loyalty | status | general — default general' },
  cacheTtlSec: 3600,
  followups: [
    { label: 'How to order', question: 'How do I place an order from the menu?' },
    { label: 'Pay bill', question: 'How do I pay my bill?' },
    { label: 'Track order', question: 'Where is my order right now?' },
    { label: 'Popular food', question: 'What are the most popular dishes?' },
  ],
  async run({ params, context }) {
    const raw = String((params && params.topic) || 'general').toLowerCase().trim();
    const topic = TOPICS[raw] ? raw : 'general';
    const block = TOPICS[topic];
    return {
      empty: false,
      topic,
      title: block.title,
      points: block.points,
      guest_name: context && context.customer_name ? String(context.customer_name).trim() : '',
      is_guest: !!(context && context.is_guest),
      table_number: context && context.table_number ? String(context.table_number) : '',
    };
  },
};
