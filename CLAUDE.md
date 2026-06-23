# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

A restaurant Point-of-Sale (POS) system with an e-menu layer. Customers scan a QR code at their table, browse the menu, place orders, and pay — all from a mobile browser. Staff manage tables and orders via a Waiter Dashboard. Admins get an AI Business Analyst chatbot.

The stack is:
- **ColdFusion (Railo/Lucee)** — all `.cfm` / `.cfc` files, served from `C:\inetpub\wwwroot\POS\POS_Project\`
- **MySQL** — primary database, schema `pos_i` (per-branch databases, called `dts`). Shared config in schema `main`.
- **Node.js (Express)** — AI sidecar in `AI/`, listens on `127.0.0.1:8088`

## Running the AI sidecar

```
cd AI
npm install        # first time only
npm start          # production
npm run dev        # dev with auto-reload (node --watch)
```

Health check: `curl http://127.0.0.1:8088/health`

The sidecar requires an `AI/.env` file (copy from `.env.example`). Required vars: `DEEPSEEK_API_KEY`, `DB_USER`, `DB_PASS`, `ALLOWED_DTS`, `AI_SHARED_SECRET`.

## Branch structure

| Branch | Purpose |
|---|---|
| `main` | Stable base |
| `hanson-customer-update` | Customer UX overhaul + waiter fixes (current active branch) |

Xendit payment integration is complete on `hanson-customer-update` — payment, webhook, and full batch payout withdrawal system are committed.

## Architecture

### ColdFusion layer (`latest/`)

Every request includes `application.cfm` (in project root) which sets the `dts` datasource variable (branch database name). The e-menu customer flow is entirely under `latest/customer/`:

| File | Role |
|---|---|
| `qr.cfm` | Entry point — validates `?t={qr_token}`, sets `SESSION.emenu_table_id`, auto-sets guest session |
| `login.cfm` + `loginProcess.cfm` | Email/password login, sign-up, face recognition login (opt-in from menu) |
| `menu.cfm` | Browse menu, build cart. Top-right Login button for guests |
| `orderProcess.cfm` | POST — appends cart items to `app_orders` / `app_order_items` |
| `order_confirm.cfm` | Order confirmation view |
| `order_status.cfm` | Live order tracking |
| `payment.cfm` + `paymentProcess.cfm` | Payment UI — Xendit online or pay-at-cashier |
| `xenditWebhook.cfm` | Receives Xendit payment callbacks, marks order paid |
| `my_orders.cfm` | Customer order history |
| `inc_emenu_order.cfm` | **Shared include** — helper functions used by both customer and waiter pages |
| `inc_emenu_currency.cfm` | Currency symbol / decimal config from `REQUEST` scope — **must be included on every customer page that displays prices** |

**Deleted pages (no longer in flow):** `account_choice.cfm`, `welcome.cfm` — removed as part of guest-by-default redesign.

### Customer QR flow (updated)

```
Scan QR → qr.cfm → auto-set guest session → menu.cfm (direct)
                                                  ↓
                                         [Login button top-right]
                                                  ↓
                                            login.cfm → menu.cfm
```

Previously required choosing guest/login before seeing the menu. Now guests land directly on the menu and login is opt-in.

Key session variables set during the QR flow:
- `SESSION.emenu_table_id` — FK to `app_tables.table_id`
- `SESSION.emenu_table_number` / `SESSION.emenu_table_name`
- `SESSION.emenu_loggedin` / `SESSION.emenu_custno` / `SESSION.emenu_name`
- `SESSION.emenu_is_guest` — always `"Yes"` after QR scan unless already logged in
- `SESSION.emenu_order_id` — active `app_orders.order_id`

The Waiter Dashboard lives in `latest/Waiter/WaiterDashboard.cfm` (sets `dashboardMode=true`, then includes `Tables.cfm` as its implementation).

The AI admin UI is at `latest/ai/analyst.cfm`; requests go via `latest/ai/aiproxy.cfm` (server-side cfhttp to the Node sidecar, adds shared secret). The customer AI widget uses `latest/ai/customer.cfm` → `latest/ai/customerproxy.cfm`.

### Node AI sidecar (`AI/src/`)

Three-step pipeline per question:
1. **Router** (`router.js` / `router-customer.js`) — one DeepSeek LLM call, picks a skill name and extracts params
2. **Skill** (`skills/*.js`, `skills/customer/*.js`) — runs a *fixed* parameterized SQL query, returns structured facts. The LLM never writes SQL.
3. **Summarizer** (`summarizer.js` / `summarizer-customer.js`) — second DeepSeek call, turns facts JSON into markdown bullets

Skills are auto-registered by `skills/index.js` and `skills/customer/index.js`. To add a skill: create `src/skills/my_skill.js` exporting `{ name, description, params, cacheTtlSec, followups, run }`, add it to the index array, restart the service.

Admin skills: sales, overview, orders, tables, menu  
Customer skills: menu-catalog, menu-popular, menu-recommend, dining-help, my-order, restaurant-hours

### Database

Schema: `pos_i` (multi-branch: `dts` variable = database name passed per-request)  
Schema: `main` — shared config tables, not branch-specific. Query via `main.table_name` using the `dts` datasource (cross-schema).

**App tables (InnoDB, new):** `app_orders`, `app_order_items`, `app_tables`, `app_menu`, `app_payments`, `points_transactions`, `kitchen_display`, `daily_summary`

**`app_payments` columns of note:** `gateway_name`, `gateway_invoice_id`, `gateway_invoice_url` — used for Xendit. Run this migration if not yet applied:
```sql
ALTER TABLE app_payments
  ADD COLUMN gateway_invoice_id  VARCHAR(100) NULL AFTER gateway_name,
  ADD COLUMN gateway_invoice_url TEXT         NULL AFTER gateway_invoice_id;
```

**`main.master_api`** — payment gateway credentials. Columns: `id`, `api_name`, `provider`, `is_active`, `webhook_token`, `secret_key`, `public_key`. Xendit row has `provider='Xendit'`, `is_active='Y'`.

**Legacy POS tables (MyISAM, no FK enforcement):** `arcust` (customers), `icitem` (items), `iccate` (categories), `currartran` (active bills), `artran` (posted sales), `cashier`, `counter`

Critical naming corrections vs. old docs:
- `currartran` (not `curarttran`/`curartran`)
- `points_transactions` (not `points_transaction`)
- `daily_summary` (not `daily_sales_summary`)

Because legacy tables use MyISAM, referential integrity must be enforced in application code. Always validate `custno` exists in `arcust` and `item_code` exists in `icitem` before inserts.

`app_orders.refno` links to `artran.REFNO` after a bill is posted to POS. `currartran.app_order_id` bridges back to `app_orders.order_id` while the bill is still open.

## Xendit payment integration

### Customer payment flow
`payment.cfm` → `paymentProcess.cfm` → Node `/xendit/invoice` → customer redirected to Xendit hosted page → Xendit POSTs to `xenditWebhook.cfm` → order marked paid + pending disbursement row inserted.

`external_id` in Xendit invoices is `"{dts}__{orderNumber}"` so the webhook can route to the correct branch DB.

Webhook URL to configure in Xendit dashboard: `https://yourdomain.com/latest/customer/xenditWebhook.cfm`

The `webhook_token` in `main.master_api` is used to verify every incoming webhook request (`x-callback-token` header).

### Batch payout / withdrawal flow

All online payment revenue lands in Netiquette's Xendit balance first. Clients withdraw manually:

```
xenditWebhook.cfm → INSERT main.disbursements (status=pending)
                              ↓
           PaymentGateway/withdrawal.cfm  ← client initiates
                              ↓
         PaymentGateway/withdrawalProcess.cfm
           → SUM pending disbursements
           → INSERT main.disbursement_batches
           → POST http://127.0.0.1:8088/xendit/disburse-batch
           → UPDATE disbursements SET status='disbursed'
```

**Admin pages (`PaymentGateway/`):**
| File | Role |
|---|---|
| `paymentProfile.cfm` | Xendit credentials (super only) + multi-account bank management |
| `paymentProfileProcess.cfm` | Actions: `save_gateway`, `add_account`, `edit_account`, `delete_account`, `set_default`, `toggle_active` |
| `withdrawal.cfm` | Client payout page — balance, pending orders, bank selector, history |
| `withdrawalProcess.cfm` | Batch withdrawal — calls Node sidecar, marks disbursements done |

**Node endpoints (`AI/src/server.js`):**
- `POST /xendit/invoice` — creates Xendit invoice for customer payment
- `POST /xendit/disburse-batch` — single Xendit disbursement transfer for a withdrawal batch

**`main` schema tables for disbursement:**

| Table | Purpose |
|---|---|
| `main.master_api` | Xendit API credentials (`provider='Xendit'`) |
| `main.client_payment_accounts` | Client bank accounts. Columns: `dts`, `bank_code`, `account_number`, `account_name`, `platform_fee_pct`, `absorb_gateway_fee`, `is_default`, `is_active`. Unique key on `(dts, account_number)` |
| `main.disbursements` | Per-order pending balance. Columns: `dts`, `order_id`, `gross_amount`, `platform_fee`, `xendit_fee`, `disburse_amount`, `batch_id`, `status` (`pending`→`disbursed`) |
| `main.disbursement_batches` | Per-withdrawal record. Columns: `dts`, `account_id`, `total_gross`, `total_platform_fee`, `xendit_fee`, `total_disburse`, `xendit_disburse_id`, `status`, `requested_at`, `completed_at`, `notes` |

Xendit disbursement fee is Rp 5,000 flat per transfer. `absorb_gateway_fee=1` means client pays it (deducted from `total_disburse`); `0` means operator absorbs it.

Menu entry for withdrawal: `main.menunew2` row `MENU_ID='20719'`, `MENU_PARENT_ID='20600'`, `USERPIN_ID='h61300'`.

## Security note for the AI sidecar

`AI/` sits inside the webapp root. Tomcat must have a `<security-constraint>` in `WEB-INF/web.xml` blocking HTTP access to `/AI/*` to prevent `.env` and source files from being publicly downloadable. After any change to `web.xml`, restart Tomcat and verify:

```
curl -I http://your-server/AI/.env          # must return 403
curl -I http://your-server/AI/src/server.js # must return 403
```

## ColdFusion conventions

- All SQL queries use `<cfqueryparam>` — never interpolate variables directly into query strings.
- `dts` is the datasource name (branch database). It is resolved at request time and available as a local variable in most pages.
- Helper functions shared between customer and waiter pages live in `latest/customer/inc_emenu_order.cfm` (included by both).
- `inc_emenu_currency.cfm` must be included on every customer page that displays prices. It sets `REQUEST.emenu_currency_symbol`, `REQUEST.emenu_currency_decimals`. Use format mask `"9,990"` for zero-decimal currencies (IDR/VND/JPY/KRW) and `"9,990.00"` otherwise.
- Face recognition model weights are loaded from `/latest/customer/models/` (self-hosted) to avoid CDN dependencies for the model binary files, but `face-api.js` itself is loaded from jsDelivr CDN.
