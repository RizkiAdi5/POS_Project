# 📊 DATABASE UPGRADE - POS SYSTEM dengan Customer App Integration

## 🎯 Overview / Ringkasan

Upgrade database ini menambahkan **8 tabel baru** dan **update 3 tabel existing** untuk mendukung fitur:
- ✅ Customer ordering via QR code
- ✅ Digital menu untuk aplikasi mobile
- ✅ Kitchen display system
- ✅ Payment gateway integration (QRIS, online payment)
- ✅ Loyalty points tracking
- ✅ Delivery platform integration (GrabFood, Foodpanda, dll)
- ✅ Daily sales reporting

---

## 📋 DAFTAR PERUBAHAN

### A. UPDATE TABEL EXISTING (3 Tables)

#### 1. **`arcust`** - Customer Master Table
**Fungsi:** Menambahkan fitur app authentication dan merge data member

```sql
ALTER TABLE arcust
    -- App authentication fields
    ADD COLUMN password_hash VARCHAR(255) COMMENT 'Password untuk login app',
    ADD COLUMN is_app_user TINYINT(1) DEFAULT 0 COMMENT 'User terdaftar di app',
    ADD COLUMN is_guest TINYINT(1) DEFAULT 0 COMMENT 'Guest user',
    ADD COLUMN last_app_login DATETIME COMMENT 'Terakhir login di app',
    ADD COLUMN device_token VARCHAR(255) COMMENT 'Token untuk push notification',
    ADD COLUMN total_app_orders INT DEFAULT 0 COMMENT 'Total order dari app',
    ADD COLUMN last_order_date DATE COMMENT 'Tanggal order terakhir',
    
    -- Member fields (digabung dari tabel member)
    ADD COLUMN is_member TINYINT(1) DEFAULT 0 COMMENT 'Member loyalty program',
    ADD COLUMN memberno VARCHAR(10) COMMENT 'Nomor member',
    ADD COLUMN member_discount DECIMAL(8,5) DEFAULT 0 COMMENT 'Diskon member %',
    ADD COLUMN member_since DATE COMMENT 'Tanggal join member',
    ADD COLUMN member_remark1 VARCHAR(200) COMMENT 'Catatan member 1',
    ADD COLUMN member_remark2 VARCHAR(200) COMMENT 'Catatan member 2',
    ADD COLUMN member_remark3 VARCHAR(200) COMMENT 'Catatan member 3',
    ADD COLUMN member_remark4 VARCHAR(200) COMMENT 'Catatan member 4',
    ADD COLUMN member_remark5 VARCHAR(200) COMMENT 'Catatan member 5',
    
    -- Indexes
    ADD INDEX idx_phone (PHONE),
    ADD INDEX idx_email (E_MAIL),
    ADD INDEX idx_app_user (is_app_user),
    ADD INDEX idx_is_member (is_member),
    ADD INDEX idx_memberno (memberno);
```

**Field Penting:**
| Field | Type | Keterangan |
|-------|------|------------|
| `password_hash` | VARCHAR(255) | Password terenkripsi untuk login app |
| `is_app_user` | TINYINT(1) | 1 = user terdaftar di app, 0 = belum |
| `is_member` | TINYINT(1) | 1 = member loyalty, 0 = regular customer |
| `POINT_BF` | DECIMAL(19,2) | **Sudah ada** - Saldo loyalty points |

---

#### 2. **`currartran`** - Current Transaction Header
**Fungsi:** Link transaksi POS dengan order dari app

```sql
ALTER TABLE currartran
    ADD COLUMN app_order_id INT COMMENT 'Link ke tabel app_orders',
    ADD COLUMN order_source VARCHAR(20) COMMENT 'qr_code, waiter, delivery_platform',
    ADD INDEX idx_app_order (app_order_id);
```

**Field Penting:**
| Field | Type | Keterangan |
|-------|------|------------|
| `app_order_id` | INT | Link ke `app_orders.order_id` |
| `order_source` | VARCHAR(20) | Sumber order: qr_code, waiter, delivery_platform |

---

#### 3. **`icitem`** - Item Master Table
**Fungsi:** Enable item untuk ditampilkan di customer app

```sql
ALTER TABLE icitem
    ADD COLUMN show_in_app TINYINT(1) DEFAULT 1 COMMENT 'Tampilkan di app customer',
    ADD COLUMN app_image_url VARCHAR(500) COMMENT 'URL gambar untuk app',
    ADD COLUMN is_recommended TINYINT(1) DEFAULT 0 COMMENT 'Item rekomendasi',
    ADD INDEX idx_show_app (show_in_app);
```

**Field Penting:**
| Field | Type | Keterangan |
|-------|------|------------|
| `show_in_app` | TINYINT(1) | 1 = tampil di app, 0 = hide |
| `app_image_url` | VARCHAR(500) | URL foto item untuk digital menu |

---

## 🆕 TABEL BARU (8 New Tables)

### 1. **`app_orders`** - Order Management
**Fungsi:** Menyimpan semua order dari customer app (dine-in QR, takeaway, delivery)

```sql
CREATE TABLE app_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    refno VARCHAR(20),  -- Link ke currartran setelah cashier confirm
    
    custno VARCHAR(12) NOT NULL,  -- Link ke arcust
    table_number VARCHAR(20),
    
    order_type VARCHAR(20) DEFAULT 'dine_in',  -- dine_in, takeaway, delivery
    order_source VARCHAR(30) DEFAULT 'qr_code',  -- qr_code, waiter, delivery_platform
    status VARCHAR(20) DEFAULT 'pending',  -- pending, confirmed, preparing, ready, completed, cancelled
    
    subtotal DECIMAL(10,2) DEFAULT 0,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    service_charge DECIMAL(10,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    delivery_fee DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) DEFAULT 0,
    
    customer_notes TEXT,
    kitchen_notes TEXT,
    
    -- Delivery info (jika order_type = 'delivery')
    delivery_platform VARCHAR(50),  -- GrabFood, Foodpanda, ShopeeFood
    delivery_address TEXT,
    delivery_phone VARCHAR(20),
    delivery_customer_name VARCHAR(100),
    platform_order_id VARCHAR(100),
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    confirmed_at DATETIME,
    ready_at DATETIME,
    completed_at DATETIME,
    
    waiter_id VARCHAR(10),
    cashier_id VARCHAR(10),
    
    INDEX idx_custno (custno),
    INDEX idx_status (status),
    INDEX idx_order_type (order_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Status Flow:**
```
pending → confirmed → preparing → ready → completed
                                      ↓
                                  cancelled
```

---

### 2. **`app_order_items`** - Order Line Items
**Fungsi:** Detail item dalam setiap order

```sql
CREATE TABLE app_order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    
    item_code VARCHAR(60) NOT NULL,  -- Link ke icitem.ITEMNO
    item_name VARCHAR(100),
    quantity INT DEFAULT 1,
    unit_price DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    
    special_instructions TEXT,  -- "No onions", "Extra spicy"
    status VARCHAR(20) DEFAULT 'pending',  -- pending, preparing, ready, served
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    prepared_at DATETIME,
    
    INDEX idx_order (order_id),
    INDEX idx_item_code (item_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Relationship:**
```
app_orders (1) ──────< (many) app_order_items
```

---

### 3. **`app_tables`** - Table Management & QR Codes
**Fungsi:** Management meja restaurant dan QR code untuk order

```sql
CREATE TABLE app_tables (
    table_id INT AUTO_INCREMENT PRIMARY KEY,
    table_number VARCHAR(20) UNIQUE NOT NULL,
    table_name VARCHAR(50),
    
    seats INT DEFAULT 4,
    location VARCHAR(50),  -- indoor, outdoor, vip
    floor_number INT DEFAULT 1,
    
    qr_token VARCHAR(191) UNIQUE,  -- Token unik di QR code
    qr_image_url VARCHAR(500),  -- Path ke file QR code
    qr_generated_at DATETIME,
    
    status VARCHAR(20) DEFAULT 'available',  -- available, occupied, reserved, cleaning
    current_order_id INT,
    occupied_since DATETIME,
    
    is_active TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_status (status),
    INDEX idx_qr_token (qr_token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**QR Code Flow:**
```
Customer scan QR → app_tables.qr_token → Open menu → Create app_orders
```

---

### 4. **`app_menu`** - Digital Menu untuk Customer App
**Fungsi:** Menu yang ditampilkan di customer app (bisa beda dengan POS)

```sql
CREATE TABLE app_menu (
    menu_id INT AUTO_INCREMENT PRIMARY KEY,
    item_code VARCHAR(60) NOT NULL,  -- Link ke icitem.ITEMNO
    
    display_name VARCHAR(100),
    description TEXT,
    category VARCHAR(50),  -- Appetizers, Main Course, Drinks
    sub_category VARCHAR(50),
    image_url VARCHAR(500),
    display_order INT DEFAULT 0,
    
    price DECIMAL(17,7),
    original_price DECIMAL(17,7),
    
    is_available TINYINT(1) DEFAULT 1,
    is_featured TINYINT(1) DEFAULT 0,
    available_for_dine_in TINYINT(1) DEFAULT 1,
    available_for_takeaway TINYINT(1) DEFAULT 1,
    available_for_delivery TINYINT(1) DEFAULT 1,
    
    is_vegetarian TINYINT(1) DEFAULT 0,
    is_halal TINYINT(1) DEFAULT 0,
    is_spicy TINYINT(1) DEFAULT 0,
    spice_level INT DEFAULT 0,
    allergens VARCHAR(200),
    calories INT,
    
    prep_time INT,  -- menit
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_item_code (item_code),
    INDEX idx_category (category),
    INDEX idx_available (is_available)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Kenapa Perlu Tabel Terpisah?**
- ✅ Menu app bisa beda dengan POS (harga, availability)
- ✅ Gambar dan description lebih detail untuk app
- ✅ Bisa hide/show item tanpa affect POS

---

### 5. **`app_payments`** - Payment Transactions
**Fungsi:** Record semua pembayaran (cash, card, QRIS, online, points)

```sql
CREATE TABLE app_payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    
    payment_method VARCHAR(30) DEFAULT 'cash',  -- cash, card, qris, online, points, tng, boost
    amount DECIMAL(10,2),
    
    gateway_transaction_id VARCHAR(100),  -- Transaction ID dari payment gateway
    gateway_name VARCHAR(50),  -- xendit, midtrans, ipay88
    gateway_response TEXT,
    
    status VARCHAR(20) DEFAULT 'pending',  -- pending, processing, success, failed, refunded
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    paid_at DATETIME,
    
    card_last4 VARCHAR(4),
    card_type VARCHAR(20),
    bank_name VARCHAR(50),
    failure_reason TEXT,
    refund_amount DECIMAL(10,2),
    refunded_at DATETIME,
    
    INDEX idx_order (order_id),
    INDEX idx_status (status),
    INDEX idx_payment_method (payment_method)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Payment Flow:**
```
Customer checkout → Create app_payments (pending)
                 → Call payment gateway API
                 → Update status (success/failed)
                 → Update app_orders.status = completed
```

---

### 6. **`points_transactions`** - Loyalty Points History
**Fungsi:** Log semua transaksi loyalty points (earn, redeem, expire)

```sql
CREATE TABLE points_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    custno VARCHAR(12) NOT NULL,  -- Link ke arcust
    
    type VARCHAR(20) DEFAULT 'earned',  -- earned, redeemed, expired, adjusted, bonus
    points INT,  -- positive = earned, negative = redeemed
    balance_before INT,
    balance_after INT,
    
    order_id INT,  -- Link ke app_orders
    refno VARCHAR(20),  -- Link ke currartran
    description VARCHAR(255),
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(10),
    expires_at DATE,
    
    INDEX idx_custno (custno),
    INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Points Flow:**
```
Order completed → Calculate points (1 point per RM10)
               → Insert points_transactions (type=earned)
               → Update arcust.POINT_BF = POINT_BF + points

Customer redeem → Insert points_transactions (type=redeemed, points=-100)
               → Update arcust.POINT_BF = POINT_BF - 100
```

---

### 7. **`kitchen_display`** - Kitchen Order Display System
**Fungsi:** Display order ke kitchen staff untuk preparation

```sql
CREATE TABLE kitchen_display (
    kitchen_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    
    order_number VARCHAR(50),
    table_number VARCHAR(20),
    item_name VARCHAR(100),
    quantity INT,
    special_instructions TEXT,
    
    station VARCHAR(50),  -- grill, fryer, drinks, wok
    priority VARCHAR(20) DEFAULT 'normal',  -- normal, high, urgent
    status VARCHAR(20) DEFAULT 'new',  -- new, acknowledged, cooking, ready, served
    
    received_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    acknowledged_at DATETIME,
    started_at DATETIME,
    completed_at DATETIME,
    target_time DATETIME,
    
    assigned_to VARCHAR(50),
    prepared_by VARCHAR(50),
    
    INDEX idx_status (status),
    INDEX idx_station (station)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Kitchen Flow:**
```
Customer order → Insert kitchen_display (status=new)
Kitchen staff acknowledge → Update status=acknowledged
Start cooking → Update status=cooking, started_at=NOW()
Complete → Update status=ready, completed_at=NOW()
Waiter serve → Update status=served
```

---

### 8. **`daily_summary`** - Daily Sales Reports
**Fungsi:** Summary penjualan harian untuk dashboard admin

```sql
CREATE TABLE daily_summary (
    summary_id INT AUTO_INCREMENT PRIMARY KEY,
    business_date DATE UNIQUE NOT NULL,
    
    -- Order counts
    total_orders INT DEFAULT 0,
    dine_in_orders INT DEFAULT 0,
    takeaway_orders INT DEFAULT 0,
    delivery_orders INT DEFAULT 0,
    cancelled_orders INT DEFAULT 0,
    
    qr_orders INT DEFAULT 0,
    waiter_orders INT DEFAULT 0,
    platform_orders INT DEFAULT 0,
    
    -- Revenue
    gross_revenue DECIMAL(12,2) DEFAULT 0,
    tax_amount DECIMAL(12,2) DEFAULT 0,
    service_charge DECIMAL(12,2) DEFAULT 0,
    discount_amount DECIMAL(12,2) DEFAULT 0,
    net_revenue DECIMAL(12,2) DEFAULT 0,
    
    -- Payment breakdown
    cash_sales DECIMAL(12,2) DEFAULT 0,
    card_sales DECIMAL(12,2) DEFAULT 0,
    online_sales DECIMAL(12,2) DEFAULT 0,
    ewallet_sales DECIMAL(12,2) DEFAULT 0,
    points_redemption DECIMAL(12,2) DEFAULT 0,
    
    -- Performance
    average_order_value DECIMAL(10,2) DEFAULT 0,
    total_customers INT DEFAULT 0,
    new_customers INT DEFAULT 0,
    returning_customers INT DEFAULT 0,
    
    points_earned INT DEFAULT 0,
    points_redeemed INT DEFAULT 0,
    
    average_prep_time INT,
    orders_on_time INT DEFAULT 0,
    orders_delayed INT DEFAULT 0,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_date (business_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Update Summary:**
```sql
-- Run daily (scheduled job)
INSERT INTO daily_summary (business_date, total_orders, gross_revenue, ...)
SELECT 
    CURDATE(),
    COUNT(*),
    SUM(total_amount),
    ...
FROM app_orders
WHERE DATE(created_at) = CURDATE();
```

---

## 🔗 RELASI ANTAR TABEL

```
┌─────────────┐
│   arcust    │ (Customer Master)
└──────┬──────┘
       │
       │ custno
       │
       ├──────────> app_orders ──────> app_order_items
       │                 │
       │                 ├──────> app_payments
       │                 │
       │                 └──────> kitchen_display
       │
       └──────────> points_transactions

┌─────────────┐
│   icitem    │ (Item Master)
└──────┬──────┘
       │
       │ ITEMNO
       │
       ├──────────> app_menu (digital menu)
       │
       └──────────> app_order_items.item_code

┌─────────────┐
│  app_tables │ (QR Code)
└──────┬──────┘
       │
       └──────────> app_orders.table_number

┌─────────────┐
│ currartran  │ (POS Transaction)
└──────┬──────┘
       │
       └──────────> app_orders.refno (after cashier confirm)
```

---

## 📝 CARA INSTALASI

### Step 1: Backup Database
```bash
mysqldump -u root -p database_name > backup_before_upgrade.sql
```

### Step 2: Update Existing Tables
```sql
-- Jalankan ALTER TABLE untuk arcust
ALTER TABLE arcust ADD COLUMN password_hash VARCHAR(255) ...;

-- Jalankan ALTER TABLE untuk currartran
ALTER TABLE currartran ADD COLUMN app_order_id INT ...;

-- Jalankan ALTER TABLE untuk icitem
ALTER TABLE icitem ADD COLUMN show_in_app TINYINT(1) DEFAULT 1 ...;
```

### Step 3: Create New Tables
```sql
-- Jalankan CREATE TABLE untuk 8 tabel baru
CREATE TABLE app_orders (...);
CREATE TABLE app_order_items (...);
CREATE TABLE app_tables (...);
CREATE TABLE app_menu (...);
CREATE TABLE app_payments (...);
CREATE TABLE points_transactions (...);
CREATE TABLE kitchen_display (...);
CREATE TABLE daily_summary (...);
```

### Step 4: Migrate Member Data (Optional)
```sql
-- Pindahkan data dari tabel member ke arcust
UPDATE arcust a
INNER JOIN member m ON a.CUSTNO = m.CUSTOMERNO
SET 
    a.is_member = 1,
    a.memberno = m.memberno,
    a.member_discount = m.disp1,
    a.member_since = m.created_on;
```

### Step 5: Verify
```sql
-- Check tables
SHOW TABLES LIKE 'app_%';

-- Check arcust new columns
DESCRIBE arcust;

-- Test insert
INSERT INTO app_orders (order_number, custno, order_type, total_amount)
VALUES ('TEST-001', 'C001', 'dine_in', 100.00);
```

---

## ⚠️ PENTING - CATATAN

### 1. **MyISAM vs InnoDB**
- ❌ Tabel lama (`arcust`, `icitem`) menggunakan **MyISAM** (tidak support foreign keys)
- ✅ Tabel baru menggunakan **InnoDB** (modern, support transactions)
- 📌 **Tidak ada foreign key constraints** - aplikasi harus handle referential integrity

### 2. **VARCHAR Instead of ENUM**
- ✅ Semua field status/type menggunakan **VARCHAR**
- ✅ Validasi dilakukan di **application layer**
- ✅ Mudah tambah options baru tanpa `ALTER TABLE`

### 3. **Character Set**
- Semua tabel baru: `utf8mb4` (support emoji, full unicode)
- Index limit: 767 bytes = 191 characters untuk utf8mb4

### 4. **Data Integrity**
Karena tidak ada foreign key, aplikasi harus:
- ✅ Validate custno exists in arcust before insert app_orders
- ✅ Validate item_code exists in icitem before insert app_order_items
- ✅ Handle orphaned records if parent deleted

---

## 🎯 USE CASES

### Use Case 1: QR Code Dine-In Order
```sql
-- 1. Customer scan QR code di meja T05
SELECT * FROM app_tables WHERE table_number = 'T05';

-- 2. Customer browse menu
SELECT * FROM app_menu WHERE is_available = 1 ORDER BY category, display_order;

-- 3. Customer place order
INSERT INTO app_orders (order_number, custno, table_number, order_type, status)
VALUES ('ORD-001', 'C001', 'T05', 'dine_in', 'pending');

-- 4. Insert order items
INSERT INTO app_order_items (order_id, item_code, item_name, quantity, unit_price, subtotal)
VALUES 
    (1, 'ITEM001', 'Nasi Goreng', 2, 15.00, 30.00),
    (1, 'ITEM002', 'Teh Ais', 2, 3.00, 6.00);

-- 5. Send to kitchen
INSERT INTO kitchen_display (order_id, item_id, order_number, table_number, item_name, quantity, status)
SELECT order_id, item_id, order_number, table_number, item_name, quantity, 'new'
FROM app_orders o
JOIN app_order_items i ON o.order_id = i.order_id
WHERE o.order_id = 1;

-- 6. Kitchen complete
UPDATE kitchen_display SET status = 'ready', completed_at = NOW() WHERE order_id = 1;

-- 7. Customer pay (cashier confirm)
INSERT INTO currartran (REFNO, CUSTNO, TRAN_DATE, NET_BIL, app_order_id, order_source)
VALUES ('CS000123', 'C001', NOW(), 36.00, 1, 'qr_code');

UPDATE app_orders SET refno = 'CS000123', status = 'completed' WHERE order_id = 1;

-- 8. Earn points (RM36 = 3 points)
INSERT INTO points_transactions (custno, type, points, balance_after, order_id, description)
VALUES ('C001', 'earned', 3, 103, 1, 'Order ORD-001');

UPDATE arcust SET POINT_BF = POINT_BF + 3 WHERE CUSTNO = 'C001';
```

### Use Case 2: Delivery Platform Order
```sql
-- 1. Receive order from GrabFood webhook
INSERT INTO app_orders (
    order_number, custno, order_type, order_source,
    delivery_platform, platform_order_id,
    delivery_address, delivery_phone, delivery_customer_name,
    subtotal, delivery_fee, total_amount, status
) VALUES (
    'GRAB-001', 'GUEST001', 'delivery', 'delivery_platform',
    'GrabFood', 'GF-20260113-12345',
    '123 Main St, KL', '0123456789', 'John Doe',
    100.00, 8.00, 108.00, 'confirmed'
);

-- 2. Insert items
INSERT INTO app_order_items ...

-- 3. Send to kitchen
INSERT INTO kitchen_display ...

-- 4. Kitchen ready
UPDATE kitchen_display SET status = 'ready' WHERE order_id = 2;
UPDATE app_orders SET status = 'ready', ready_at = NOW() WHERE order_id = 2;

-- 5. Rider picked up
UPDATE app_orders SET status = 'completed', completed_at = NOW() WHERE order_id = 2;
```

---

## 📊 QUERY EXAMPLES

### Get Today's Orders
```sql
SELECT 
    order_number,
    custno,
    table_number,
    order_type,
    status,
    total_amount,
    created_at
FROM app_orders
WHERE DATE(created_at) = CURDATE()
ORDER BY created_at DESC;
```

### Customer Order History
```sql
SELECT 
    o.order_number,
    o.order_type,
    o.total_amount,
    o.status,
    o.created_at,
    GROUP_CONCAT(i.item_name, ' x', i.quantity SEPARATOR ', ') as items
FROM app_orders o
LEFT JOIN app_order_items i ON o.order_id = i.order_id
WHERE o.custno = 'C001'
GROUP BY o.order_id
ORDER BY o.created_at DESC;
```

### Kitchen Display - Pending Orders
```sql
SELECT 
    k.kitchen_id,
    k.order_number,
    k.table_number,
    k.item_name,
    k.quantity,
    k.special_instructions,
    k.station,
    k.priority,
    TIMESTAMPDIFF(MINUTE, k.received_at, NOW()) as wait_time
FROM kitchen_display k
WHERE k.status IN ('new', 'acknowledged', 'cooking')
ORDER BY k.priority DESC, k.received_at ASC;
```

### Daily Sales Report
```sql
SELECT 
    business_date,
    total_orders,
    gross_revenue,
    net_revenue,
    average_order_value,
    total_customers
FROM daily_summary
WHERE business_date BETWEEN '2026-01-01' AND '2026-01-31'
ORDER BY business_date;
```

### Top Selling Items
```sql
SELECT 
    i.item_code,
    i.item_name,
    COUNT(*) as order_count,
    SUM(i.quantity) as total_quantity,
    SUM(i.subtotal) as total_revenue
FROM app_order_items i
JOIN app_orders o ON i.order_id = o.order_id
WHERE DATE(o.created_at) = CURDATE()
    AND o.status = 'completed'
GROUP BY i.item_code, i.item_name
ORDER BY total_revenue DESC
LIMIT 10;
```

---

## 🚀 NEXT STEPS

Setelah database upgrade:

1. ✅ **Generate QR Codes untuk meja**
   - Script untuk generate QR code per table
   - Save `qr_token` dan `qr_image_url` ke `app_tables`

2. ✅ **Sync Menu POS ke App Menu**
   - Script untuk copy `icitem` → `app_menu`
   - Upload gambar menu items

3. ✅ **Setup Payment Gateway**
   - Xendit / Midtrans / iPay88 integration
   - Webhook handler untuk payment confirmation

4. ✅ **Kitchen Display Application**
   - Real-time update dari `kitchen_display` table
   - Auto-refresh setiap 5 detik

5. ✅ **Daily Summary Scheduler**
   - Cron job untuk generate `daily_summary`
   - Run setiap midnight: `0 0 * * *`

---

## 📞 SUPPORT

Jika ada masalah atau pertanyaan:
- 📧 Email: support@yourcompany.com
- 📱 WhatsApp: +60123456789
- 💬 Telegram: @yoursupport

---

**Version:** 1.0  
**Last Updated:** January 13, 2026  
**Database Engine:** MySQL 5.7+ / MariaDB 10.2+

