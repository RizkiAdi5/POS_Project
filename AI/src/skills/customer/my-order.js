'use strict';

const db = require('../../db');
const { getCompanyCurrency, roundMoney, withCurrency } = require('../../util/currency');

module.exports = {
  name: 'my_order_status',
  description: 'Status of the guest\'s current table order — items, kitchen progress, total, payment. Uses the guest session order_id from context.',
  params: {},
  cacheTtlSec: 30,
  followups: [
    { label: 'Popular dishes', question: 'What are the most popular dishes right now?' },
    { label: 'Halal menu', question: 'What halal dishes do you recommend?' },
    { label: 'How to pay', question: 'How do I pay my bill?' },
    { label: 'Loyalty points', question: 'How do loyalty points work?' },
  ],
  async run({ dts, context }) {
    const currency = await getCompanyCurrency(dts);
    const orderId = parseInt(context && context.order_id, 10) || 0;
    if (orderId <= 0) {
      return withCurrency(dts, {
        empty: true,
        reason: 'no_active_order',
        message: 'Guest has not placed an order on this table session yet.',
      });
    }

    const orders = await db.runQuery(dts, `
      SELECT order_id, order_number, status, subtotal, tax_amount, total_amount, created_at
      FROM app_orders
      WHERE order_id = ?
      LIMIT 1
    `, [orderId]);
    if (!orders.length) {
      return withCurrency(dts, { empty: true, reason: 'order_not_found' });
    }
    const o = orders[0];

    const items = await db.runQuery(dts, `
      SELECT COALESCE(item_name, item_code) AS item_name,
             quantity, unit_price, subtotal,
             status AS kitchen_status,
             COALESCE(special_instructions, '') AS note
      FROM app_order_items
      WHERE order_id = ?
      ORDER BY item_id ASC
    `, [orderId]);

    const payments = await db.runQuery(dts, `
      SELECT payment_method, status, amount, paid_at
      FROM app_payments
      WHERE order_id = ?
      ORDER BY payment_id DESC
      LIMIT 1
    `, [orderId]);

    const pay = payments[0] || null;
    const tableNumber = context && context.table_number ? String(context.table_number) : '';

    return withCurrency(dts, {
      empty: false,
      order_number: String(o.order_number || '').trim(),
      order_status: String(o.status || '').trim(),
      table_number: tableNumber,
      subtotal: roundMoney(o.subtotal, currency),
      tax: roundMoney(o.tax_amount, currency),
      total: roundMoney(o.total_amount, currency),
      item_count: items.length,
      items: items.map((i) => ({
        name: String(i.item_name || '').trim(),
        qty: parseInt(i.quantity, 10) || 0,
        line_total: roundMoney(i.subtotal, currency),
        kitchen_status: String(i.kitchen_status || 'Pending').trim(),
        note: String(i.note || '').trim().slice(0, 120),
      })),
      payment: pay ? {
        method: String(pay.payment_method || '').trim(),
        status: String(pay.status || '').trim(),
        amount: roundMoney(pay.amount, currency),
      } : null,
    });
  },
};
