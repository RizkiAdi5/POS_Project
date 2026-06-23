#!/usr/bin/env node
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { z } from 'zod';

const SECRET_KEY = process.env.XENDIT_SECRET_KEY || '';
if (!SECRET_KEY) {
  process.stderr.write('XENDIT_SECRET_KEY env var is required\n');
  process.exit(1);
}

const BASE_URL = 'https://api.xendit.co';

function authHeader() {
  return 'Basic ' + Buffer.from(`${SECRET_KEY}:`).toString('base64');
}

async function xendit(path, options = {}) {
  const res = await fetch(`${BASE_URL}${path}`, {
    ...options,
    headers: {
      'Authorization': authHeader(),
      'Content-Type': 'application/json',
      ...(options.headers || {})
    }
  });
  const text = await res.text();
  let data;
  try { data = JSON.parse(text); } catch { data = text; }
  if (!res.ok) throw new Error(`Xendit ${res.status}: ${JSON.stringify(data)}`);
  return data;
}

const server = new McpServer({ name: 'xendit', version: '1.0.0' });

server.tool(
  'xendit_list_invoices',
  'List recent Xendit invoices. Optionally filter by status (PENDING, PAID, SETTLED, EXPIRED).',
  {
    limit:  z.number().min(1).max(50).default(10).describe('How many to return'),
    status: z.enum(['PENDING','PAID','SETTLED','EXPIRED']).optional().describe('Filter by status')
  },
  async ({ limit, status }) => {
    let qs = `limit=${limit}`;
    if (status) qs += `&status=${status}`;
    const data = await xendit(`/v2/invoices?${qs}`);
    return { content: [{ type: 'text', text: JSON.stringify(data, null, 2) }] };
  }
);

server.tool(
  'xendit_get_invoice',
  'Get a single Xendit invoice by its invoice ID (e.g. inv_xxx).',
  { invoice_id: z.string().describe('Xendit invoice ID') },
  async ({ invoice_id }) => {
    const data = await xendit(`/v2/invoices/${encodeURIComponent(invoice_id)}`);
    return { content: [{ type: 'text', text: JSON.stringify(data, null, 2) }] };
  }
);

server.tool(
  'xendit_find_by_order',
  'Find a Xendit invoice by order number (external_id, e.g. ORD-12345).',
  { order_number: z.string().describe('Order number used as external_id when invoice was created') },
  async ({ order_number }) => {
    const data = await xendit(`/v2/invoices?external_id=${encodeURIComponent(order_number)}`);
    return { content: [{ type: 'text', text: JSON.stringify(data, null, 2) }] };
  }
);

server.tool(
  'xendit_expire_invoice',
  'Expire a pending invoice. Useful in sandbox testing to reset and retry a payment.',
  { invoice_id: z.string().describe('Xendit invoice ID to expire') },
  async ({ invoice_id }) => {
    const data = await xendit(`/invoices/${encodeURIComponent(invoice_id)}/expire!`, { method: 'POST' });
    return { content: [{ type: 'text', text: JSON.stringify(data, null, 2) }] };
  }
);

server.tool(
  'xendit_list_payments',
  'List recent payment requests (charges/disbursements overview).',
  { limit: z.number().min(1).max(50).default(10).describe('How many to return') },
  async ({ limit }) => {
    const data = await xendit(`/payment_requests?limit=${limit}`);
    return { content: [{ type: 'text', text: JSON.stringify(data, null, 2) }] };
  }
);

const transport = new StdioServerTransport();
await server.connect(transport);
