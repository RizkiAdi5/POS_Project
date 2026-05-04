# Data Dictionary — E-Menu POS System
**Schema:** `pos_i`  
**Last updated:** 2026-04-26  
**Status:** Verified against live DB + decisions made in planning session

> Legend  
> ✅ Verified from live DB query  
> 📄 From original PDF (not yet queried for exact columns)  
> ➕ Column to be added via ALTER TABLE (not yet in DB)  
> ⚠️ PDF name was wrong — real name shown here  

---

## Table Name Corrections (PDF vs Reality)

| PDF / Old Name | Real Table Name in `pos_i` | Status |
|----------------|---------------------------|--------|
| `curarttran` / `curartran` | **`currartran`** | ✅ Verified |
| `points_transaction` | **`points_transactions`** | ✅ Verified |
| `daily_sales_summary` | **`daily_summary`** | ✅ Verified |
| `kitchen_display` | `kitchen_display` | ✅ Same |

---

## Category 1 — E-Menu & Ordering Tables

### 1. `app_menu` (InnoDB) 📄
Digital storefront. Each row mirrors one POS item (`icitem`) made visible on the app.

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `menu_id` | INT | PK | NO | AUTO | Unique menu item ID |
| 2 | `item_code` | VARCHAR(15) | FK | YES | NULL | Links to `icitem.ITEMNO` |
| 3 | `display_name` | VARCHAR(100) | — | YES | NULL | Name shown to customer |
| 4 | `category` | VARCHAR(50) | — | YES | NULL | Category label |
| 5 | `price` | DECIMAL(10,2) | — | YES | NULL | Selling price |
| 6 | `promo_price` | DECIMAL(10,2) | — | YES | NULL | Promotional price if active |
| 7 | `image_url` | VARCHAR(255) | — | YES | NULL | Path to food photo |
| 8 | `is_available` | tinyint(1) | — | YES | 1 | 1 = available, 0 = out of stock |
x`
---

### 2. `app_orders` (InnoDB) 📄
Central hub for every e-menu order.

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `order_id` | INT | PK | NO | AUTO | Unique order ID |
| 2 | `order_number` | VARCHAR(50) | — | YES | NULL | Human-readable receipt number |
| 3 | `refno` | VARCHAR(20) | FK | YES | NULL | Links to `artran.REFNO` (posted POS sale) |
| 4 | `custno` | VARCHAR(12) | FK | YES | NULL | Links to `arcust.CUSTNO` |
| 5 | `table_number` | VARCHAR(20) | FK | YES | NULL | Links to `app_tables.table_number` |
| 6 | `order_type` | VARCHAR(20) | — | YES | NULL | `dine` / `takeaway` |
| 7 | `status` | VARCHAR(30) | — | YES | NULL | `in progress` / `ready` / `paid` |
| 8 | `total_amount` | DECIMAL(10,2) | — | YES | NULL | Total billing amount |
| 9 | `promo_id` | INT | FK | YES | NULL | Links to `promotion.promoID` |
| 10 | `voucher_id` | INT | FK | YES | NULL | Links to `voucher.voucherID` |
| 11 | `waiter_id` | VARCHAR(10) | FK | YES | NULL | Links to `cashier.cashierid` |
| 12 | `cashier_id` | VARCHAR(10) | FK | YES | NULL | Links to `cashier.cashierid` |
| 13 | `created_at` | DATETIME | — | YES | NULL | Order creation timestamp |

---

### 3. `app_order_items` (InnoDB) 📄
Line items inside an order cart.

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `item_id` | INT | PK | NO | AUTO | Unique line item ID |
| 2 | `order_id` | INT | FK | YES | NULL | Links to `app_orders.order_id` |
| 3 | `item_code` | VARCHAR(15) | FK | YES | NULL | Links to `icitem.ITEMNO` |
| 4 | `quantity` | INT | — | YES | NULL | Quantity ordered |
| 5 | `unit_price` | DECIMAL(10,2) | — | YES | NULL | Price per unit at order time |
| 6 | `subtotal` | DECIMAL(10,2) | — | YES | NULL | qty × unit_price |
| 7 | `special_request` | TEXT | — | YES | NULL | Customer notes / modifications |
| 8 | `kitchen_status` | VARCHAR(30) | — | YES | NULL | `Pending` / `In Progress` / `Ready` |

---

### 4. `app_payments` (InnoDB) 📄
Payment records from gateway or cash.

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `payment_id` | INT | PK | NO | AUTO | Unique payment ID |
| 2 | `order_id` | INT | FK | YES | NULL | Links to `app_orders.order_id` |
| 3 | `payment_method` | VARCHAR(30) | — | YES | NULL | `QRIS` / `Cash` / `Credit Card` |
| 4 | `amount` | DECIMAL(10,2) | — | YES | NULL | Total amount paid |
| 5 | `status` | VARCHAR(30) | — | YES | NULL | `Success` / `Failed` / `Pending` |
| 6 | `transaction_id` | VARCHAR(100) | — | YES | NULL | Gateway reference (e.g. Midtrans) |
| 7 | `points_used` | DECIMAL(10,2) | — | YES | NULL | Loyalty points applied to bill |
| 8 | `paid_at` | DATETIME | — | YES | NULL | Payment completion timestamp |

---

### 5. `app_tables` (InnoDB) ✅ Verified
Physical restaurant tables. QR codes are tied here.

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `table_id` | int(11) | PK | NO | AUTO | Unique table ID |
| 2 | `table_number` | varchar(20) | UNI | NO | — | Physical table label (e.g. "T-05") |
| 3 | `table_name` | varchar(50) | — | YES | NULL | Friendly display name |
| 4 | `seats` | int(11) | — | YES | 4 | Seating capacity |
| 5 | `location` | varchar(50) | — | YES | NULL | Area description (e.g. "Window Side") |
| 6 | `floor_number` | int(11) | — | YES | 1 | Floor level |
| 7 | `qr_token` | varchar(191) | UNI | YES | NULL | Unique token embedded in QR URL |
| 8 | `qr_image_url` | varchar(500) | — | YES | NULL | Path to generated QR image file |
| 9 | `qr_generated_at` | datetime | — | YES | NULL | When token was last generated |
| 10 | `status` | varchar(20) | MUL | YES | available | `available` / `occupied` / `reserved` |
| 11 | `current_order_id` | int(11) | — | YES | NULL | Active order on this table (⚠️ PDF said `current_custno` — incorrect) |
| 12 | `occupied_since` | datetime | — | YES | NULL | When table became occupied |
| 13 | `is_active` | tinyint(1) | — | YES | 1 | Soft delete / in-use flag |
| 14 | `created_at` | datetime | — | YES | CURRENT_TIMESTAMP | Row creation time |

> **QR Flow:** Scan QR → URL contains `?t={qr_token}` → CF looks up `app_tables` by `qr_token` → sets table context in session.

---

## Category 2 — App Features & Operational Tables

### 6. `kitchen_display` (InnoDB) ✅ Exists, 0 rows 📄
KDS ticket queue for kitchen staff.

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `display_id` | INT | PK | NO | AUTO | Unique KDS ticket ID |
| 2 | `order_id` | INT | FK | YES | NULL | Links to `app_orders.order_id` |
| 3 | `item_id` | INT | FK | YES | NULL | Links to `app_order_items.item_id` |
| 4 | `item_code` | VARCHAR(15) | FK | YES | NULL | Links to `icitem.ITEMNO` |
| 5 | `table_number` | VARCHAR(20) | — | YES | NULL | Destination table |
| 6 | `quantity` | INT | — | YES | NULL | Portions to prepare |
| 7 | `status` | VARCHAR(30) | — | YES | NULL | `Pending` / `In Progress` / `Ready` |
| 8 | `station` | VARCHAR(50) | — | YES | NULL | `Hot Kitchen` / `Bar` / `Cold Kitchen` |

---

### 7. `points_transactions` (InnoDB) ✅ Exists, 0 rows ⚠️ PDF said `points_transaction`
Loyalty points ledger.

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `transaction_id` | INT | PK | NO | AUTO | Unique ledger entry ID |
| 2 | `custno` | VARCHAR(12) | FK | YES | NULL | Links to `arcust.CUSTNO` |
| 3 | `order_number` | VARCHAR(50) | FK | YES | NULL | Links to `app_orders.order_number` |
| 4 | `type` | VARCHAR(20) | — | YES | NULL | `Earned` / `Redeemed` |
| 5 | `points` | INT | — | YES | NULL | Points added or deducted |
| 6 | `balance_after` | INT | — | YES | NULL | Running balance after this entry |
| 7 | `created_at` | DATETIME | — | YES | NULL | Allocation timestamp |

---

### 8. `order_feedback` 📄
Customer ratings and reviews.

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `feedback_id` | INT | PK | NO | AUTO | Unique review ID |
| 2 | `order_id` | INT | FK | YES | NULL | Links to `app_orders.order_id` |
| 3 | `custno` | VARCHAR(12) | FK | YES | NULL | Links to `arcust.CUSTNO` |
| 4 | `rating` | INT | — | YES | NULL | 1–5 stars |
| 5 | `comment` | TEXT | — | YES | NULL | Written review |
| 6 | `created_at` | DATETIME | — | YES | NULL | Submission timestamp |

---

### 9. `daily_summary` (InnoDB) ✅ Exists ⚠️ PDF said `daily_sales_summary`
Aggregated daily performance data for dashboards.

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `summary_id` | INT | PK | NO | AUTO | Unique summary ID |
| 2 | `sales_date` | DATE | — | YES | NULL | Date of summarized records |
| 3 | `total_orders` | INT | — | YES | NULL | Orders completed that day |
| 4 | `total_sales` | DECIMAL(10,2) | — | YES | NULL | Gross revenue |
| 5 | `total_customers` | INT | — | YES | NULL | Unique customers served |
| 6 | `cash_payments` | DECIMAL(12,2) | — | YES | NULL | Cash revenue |
| 7 | `qris_payments` | DECIMAL(12,2) | — | YES | NULL | Digital payment revenue |
| 8 | `created_at` | DATETIME | — | YES | NULL | Summary generation timestamp |

---

### 10. `settings` 📄
Global system configuration key-value store.

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `setting_id` | INT | PK | NO | AUTO | Unique config ID |
| 2 | `setting_key` | VARCHAR(100) | — | NO | — | Variable name (e.g. `TaxRate`) |
| 3 | `setting_value` | TEXT | — | YES | NULL | The value |
| 4 | `setting_type` | VARCHAR(20) | — | YES | NULL | `string` / `boolean` / `decimal` |

---

### 11. `notifications` 📄
System alerts and promo messages sent to customers.

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `notification_id` | INT | PK | NO | AUTO | Unique alert ID |
| 2 | `custno` | VARCHAR(12) | FK | YES | NULL | Recipient — links to `arcust.CUSTNO` |
| 3 | `type` | VARCHAR(30) | — | YES | NULL | `Promo` / `System Alert` / `Order Update` |
| 4 | `title` | VARCHAR(255) | — | YES | NULL | Message text |
| 5 | `is_read` | tinyint(1) | — | YES | 0 | 1 = read, 0 = unread |
| 6 | `created_at` | DATETIME | — | YES | NULL | Alert sent timestamp |

---

### 12. `voucher` (MyISAM) ✅ Exists, 0 rows 📄

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `voucherID` | INT | PK | NO | AUTO | Unique voucher ID |
| 2 | `voucherNo` | VARCHAR(45) | — | YES | NULL | Public code (e.g. `DISC50`) |
| 3 | `type` | VARCHAR(45) | — | YES | NULL | `Cash` / `Percentage` |
| 4 | `value` | DOUBLE | — | YES | NULL | Discount amount or % |
| 5 | `dateExpiry` | DATETIME | — | YES | NULL | Expiry date |
| 6 | `status` | VARCHAR(45) | — | YES | NULL | `Active` / `Used` |

---

### 13. `promotion` (MyISAM) ✅ Exists, 0 rows 📄

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 1 | `promoID` | INT | PK | NO | AUTO | Unique promo ID |
| 2 | `type` | VARCHAR(45) | — | YES | NULL | e.g. `Buy 1 Get 1` |
| 3 | `periodfrom` | DATETIME | — | YES | NULL | Promo start |
| 4 | `periodto` | DATETIME | — | YES | NULL | Promo end |
| 5 | `priceamt` | VARCHAR(45) | — | YES | NULL | Special promotional price |
| 6 | `status` | VARCHAR(45) | — | YES | NULL | `Active` / `Inactive` |

---

## Category 3 — Legacy POS Tables

### 14. `arcust` (MyISAM) ✅ Columns verified (123 legacy + 7 new to add)
Master customer profile. Legacy POS table extended for e-menu.

**Key columns for e-menu (out of 123 total):**

| # | Column | Type | Key | Nullable | Default | Description |
|---|--------|------|-----|----------|---------|-------------|
| 2 | `CUSTNO` | varchar(12) | PK | NO | — | Unique customer ID |
| 3 | `NAME` | varchar(40) | — | YES | NULL | Full name |
| 16 | `PHONE` | varchar(25) | — | YES | NULL | Contact phone |
| 21 | `E_MAIL` | varchar(100) | — | YES | NULL | Email address |
| 33 | `POINT_BF` | decimal(19,2) | — | NO | 0.00 | Legacy loyalty points balance |
| 46 | `STATUS` | char(1) | — | YES | NULL | Account status |

**New columns — to be added via ALTER TABLE ➕**

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| `is_app_user` | tinyint(1) | NO | 0 | E-Menu registered user flag |
| `is_member` | tinyint(1) | NO | 0 | Active loyalty member flag |
| `member_tier` | varchar(50) | YES | NULL | `Gold` / `Silver` / `Bronze` |
| `app_password` | varchar(255) | YES | NULL | SHA-256 hashed password |
| `device_token` | varchar(255) | YES | NULL | Push notification token |
| `face_token` | longtext | YES | NULL | face-api.js descriptor (128-float JSON array) |
| `app_created_at` | datetime | YES | NULL | App registration timestamp |

> **ALTER TABLE** (run once to apply):
> ```sql
> ALTER TABLE pos_i.arcust
>   ADD COLUMN is_app_user    tinyint(1)   NOT NULL DEFAULT 0,
>   ADD COLUMN is_member      tinyint(1)   NOT NULL DEFAULT 0,
>   ADD COLUMN member_tier    varchar(50)  NULL DEFAULT NULL,
>   ADD COLUMN app_password   varchar(255) NULL DEFAULT NULL,
>   ADD COLUMN device_token   varchar(255) NULL DEFAULT NULL,
>   ADD COLUMN face_token     longtext     NULL DEFAULT NULL,
>   ADD COLUMN app_created_at datetime     NULL DEFAULT NULL;
> ```

---

### 15. `icitem` (MyISAM) ✅ Exists 📄
Legacy POS item master. Source of truth for menu items.

| # | Column | Type | Key | Description |
|---|--------|------|-----|-------------|
| 1 | `ITEMNO` | VARCHAR(15) | PK | Unique item code |
| 2 | `CATE` | VARCHAR(50) | FK | Links to `iccate.CATE` |
| 3 | `DESCRIP` | VARCHAR(60) | — | Item name/description |
| 4 | `SPRICE` | DECIMAL(12,2) | — | Standard selling price |
| 5 | `STATUS` | VARCHAR(2) | — | Legacy availability flag |
| 6 | `show_in_app` | tinyint(1) | — | 1 = sync to `app_menu` |

---

### 16. `iccate` (MyISAM) ✅ Exists 📄
Item category master.

| # | Column | Type | Key | Description |
|---|--------|------|-----|-------------|
| 1 | `CATE` | VARCHAR(50) | PK | Unique category code |
| 2 | `DESP` | VARCHAR(40) | — | Category name (e.g. `Beverages`) |

---

### 17. `artran` (MyISAM) ✅ Exists, 0 rows 📄
Historical posted sales ledger.

| # | Column | Type | Key | Description |
|---|--------|------|-----|-------------|
| 1 | `REFNO` | VARCHAR(50) | PK | Unique receipt number |
| 2 | `TYPE` | VARCHAR(4) | — | Transaction type code |
| 3 | `CUSTNO` | VARCHAR(12) | FK | Links to `arcust.CUSTNO` |
| 4 | `TRAN_DATE` | DATE | — | Transaction date |
| 5 | `NET_BIL` | DECIMAL(12,2) | — | Net bill amount |

---

### 18. `currartran` (MyISAM) ✅ Exists ⚠️ PDF said `curarttran` / `curartran`
Active / open bill currently in progress at POS.

| # | Column | Type | Key | Description |
|---|--------|------|-----|-------------|
| 1 | `REFNO` | VARCHAR(20) | PK | Active transaction receipt number |
| 2 | `CUSTNO` | VARCHAR(12) | FK | Links to `arcust.CUSTNO` |
| 3 | `TRAN_DATE` | DATE | — | Date active transaction started |
| 4 | `NET_BIL` | DECIMAL(12,2) | — | Current net bill amount |
| 5 | `TAX` | DECIMAL(12,2) | — | Calculated tax |
| 6 | `DISCOUNT` | DECIMAL(12,2) | — | Total applied discount |
| 7 | `POINT` | INT | — | Points earned/used on this transaction |
| 8 | `cashierid` | VARCHAR(100) | FK | Links to `cashier.cashierid` |
| 9 | `COUNTER` | VARCHAR(10) | FK | Links to `counter.counterid` |
| 10 | `app_order_id` | INT | FK | Bridge link back to `app_orders.order_id` |

---

### 19. `cashier` (MyISAM) ✅ Exists 📄
Staff directory.

| # | Column | Type | Key | Description |
|---|--------|------|-----|-------------|
| 1 | `cashierid` | VARCHAR(100) | PK | Unique staff ID |
| 2 | `name` | VARCHAR(100) | — | Full name |

---

### 20. `counter` (MyISAM) ✅ Exists 📄
POS terminals.

| # | Column | Type | Key | Description |
|---|--------|------|-----|-------------|
| 1 | `id` | INT | PK | Internal ID |
| 2 | `counterid` | VARCHAR(450) | — | Terminal string ID |
| 3 | `counterdesp` | VARCHAR(450) | — | Terminal description/location |

---

### 21. `member` (MyISAM) ✅ Exists 📄
Legacy membership records.

| # | Column | Type | Key | Description |
|---|--------|------|-----|-------------|
| 1 | `memberno` | VARCHAR(10) | PK | Legacy membership ID |
| 2 | `CUSTOMERNO` | VARCHAR(8) | FK | Links to `arcust.CUSTNO` |
| 3 | `NAME` | VARCHAR(40) | — | Member name |
| 4 | `phone` | VARCHAR(20) | — | Contact number |
| 5 | `disp1` | INT | — | Internal display flag |

---

### 22. `menu` (MyISAM) ✅ Exists, 110 rows 📄
Legacy POS screen layout config (not the customer-facing menu).

| # | Column | Type | Key | Description |
|---|--------|------|-----|-------------|
| 1 | `MENU_ID` | INT | PK | Legacy menu layout ID |
| 2 | `MENU_NAME` | VARCHAR(45) | — | Layout name |
| 3 | `MENU_CATEGORY` | VARCHAR(45) | — | High-level category |
| 4 | `MENU_STATUS` | char(1) | — | `A` = Active, `I` = Inactive |
| 5 | `MENU_LEVEL` | VARCHAR(45) | — | Hierarchy level |
| 6 | `MENU_PARENT_LEVEL` | VARCHAR(45) | — | Parent node |

---

## Relationships at a Glance

```
arcust.CUSTNO ──────────────────┬── app_orders.custno
                                ├── points_transactions.custno
                                ├── order_feedback.custno
                                ├── notifications.custno
                                └── currartran.CUSTNO

app_tables.table_number ────────── app_orders.table_number
app_tables.current_order_id ────── app_orders.order_id  (active order)

app_orders.order_id ────────────┬── app_order_items.order_id
                                ├── app_payments.order_id
                                ├── kitchen_display.order_id
                                └── order_feedback.order_id

icitem.ITEMNO ──────────────────┬── app_menu.item_code
                                ├── app_order_items.item_code
                                └── kitchen_display.item_code

iccate.CATE ─────────────────────── icitem.CATE

app_orders.refno ───────────────── artran.REFNO  (after bill posted)
currartran.app_order_id ─────────── app_orders.order_id  (while open)

cashier.cashierid ──────────────┬── app_orders.waiter_id
                                ├── app_orders.cashier_id
                                └── currartran.cashierid

promotion.promoID ──────────────── app_orders.promo_id
voucher.voucherID ──────────────── app_orders.voucher_id
```

---

## Customer Journey Flow (E-Menu)

```
Scan QR
  └── app_tables (qr_token) → validate token → set SESSION.emenu_table_id

Customer Login / Register
  └── arcust (E_MAIL + app_password)  ← email+password login
  └── arcust (face_token)             ← face recognition login
  └── arcust (is_app_user = 1)        ← confirm registered

Browse Menu
  └── app_menu (is_available = 1)
  └── iccate (categories)

Add to Cart → Place Order
  └── INSERT app_orders
  └── INSERT app_order_items
  └── INSERT kitchen_display (KDS tickets)

Payment
  └── INSERT app_payments
  └── UPDATE app_orders.status = 'paid'
  └── UPDATE app_tables.status = 'available'
  └── INSERT points_transactions (if loyalty member)
  └── INSERT currartran / artran (POS sync)

Feedback
  └── INSERT order_feedback
```

---

*For any column marked 📄 that has not been verified via live query, run:*
```sql
DESCRIBE pos_i.<table_name>;
```
*before implementing CF queries against it.*
