-- ============================================================================
-- DATABASE UPGRADE SCRIPT
-- POS System dengan Customer App Integration
-- Version: 1.0
-- Date: 2026-01-13
-- ============================================================================

-- BACKUP DATABASE DULU SEBELUM JALANKAN SCRIPT INI!
-- mysqldump -u root -p database_name > backup_before_upgrade.sql

-- ============================================================================
-- PART 1: UPDATE EXISTING TABLES (3 Tables)
-- ============================================================================

-- 1. UPDATE arcust - Add app authentication & merge member data
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

SELECT '✅ Table arcust updated successfully' AS status;

-- 2. UPDATE currartran - Link to app orders
ALTER TABLE currartran
    ADD COLUMN app_order_id INT COMMENT 'Link ke tabel app_orders',
    ADD COLUMN order_source VARCHAR(20) COMMENT 'qr_code, waiter, delivery_platform',
    ADD INDEX idx_app_order (app_order_id);

SELECT '✅ Table currartran updated successfully' AS status;

-- 3. UPDATE icitem - Enable app menu display
ALTER TABLE icitem
    ADD COLUMN show_in_app TINYINT(1) DEFAULT 1 COMMENT 'Tampilkan di app customer',
    ADD COLUMN app_image_url VARCHAR(500) COMMENT 'URL gambar untuk app',
    ADD COLUMN is_recommended TINYINT(1) DEFAULT 0 COMMENT 'Item rekomendasi',
    ADD INDEX idx_show_app (show_in_app);

SELECT '✅ Table icitem updated successfully' AS status;

-- ============================================================================
-- PART 2: CREATE NEW TABLES (8 Tables)
-- ============================================================================

-- TABLE 1: app_orders
DROP TABLE IF EXISTS app_orders;
CREATE TABLE app_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    refno VARCHAR(20),
    
    -- Customer
    custno VARCHAR(12) NOT NULL,
    table_number VARCHAR(20),
    
    -- Order classification (FLEXIBLE - validate in app)
    order_type VARCHAR(20) DEFAULT 'dine_in',  -- dine_in, takeaway, delivery
    order_source VARCHAR(30) DEFAULT 'qr_code',  -- qr_code, waiter, delivery_platform, phone, walk_in
    
    -- Status (FLEXIBLE - validate in app)
    status VARCHAR(20) DEFAULT 'pending',  -- pending, confirmed, preparing, ready, completed, cancelled
    
    -- Financial
    subtotal DECIMAL(10,2) DEFAULT 0,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    service_charge DECIMAL(10,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    delivery_fee DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) DEFAULT 0,
    
    -- Notes
    customer_notes TEXT,
    kitchen_notes TEXT,
    
    -- Delivery info (only if order_type = 'delivery')
    delivery_platform VARCHAR(50),  -- GrabFood, Foodpanda, ShopeeFood, etc
    delivery_address TEXT,
    delivery_phone VARCHAR(20),
    delivery_customer_name VARCHAR(100),
    platform_order_id VARCHAR(100),
    
    -- Timestamps
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    confirmed_at DATETIME,
    ready_at DATETIME,
    completed_at DATETIME,
    
    -- Staff
    waiter_id VARCHAR(10),
    cashier_id VARCHAR(10),
    
    -- Indexes (NO FOREIGN KEYS - MyISAM compatibility)
    INDEX idx_custno (custno),
    INDEX idx_status (status),
    INDEX idx_order_type (order_type),
    INDEX idx_order_source (order_source),
    INDEX idx_order_number (order_number),
    INDEX idx_created (created_at),
    INDEX idx_table (table_number),
    INDEX idx_delivery_platform (delivery_platform)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 
COMMENT='All orders: dine-in, takeaway, and delivery';

SELECT '✅ Table app_orders created successfully' AS status;

-- TABLE 2: app_order_items
DROP TABLE IF EXISTS app_order_items;
CREATE TABLE app_order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    
    -- Item details
    item_code VARCHAR(60) NOT NULL,
    item_name VARCHAR(100),
    quantity INT DEFAULT 1,
    unit_price DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    
    -- Customization
    special_instructions TEXT,
    
    -- Status (FLEXIBLE)
    status VARCHAR(20) DEFAULT 'pending',  -- pending, preparing, ready, served, cancelled
    
    -- Timing
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    prepared_at DATETIME,
    
    -- Indexes
    INDEX idx_order (order_id),
    INDEX idx_item_code (item_code),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
COMMENT='Order line items';

SELECT '✅ Table app_order_items created successfully' AS status;

-- TABLE 3: app_tables
DROP TABLE IF EXISTS app_tables;
CREATE TABLE app_tables (
    table_id INT AUTO_INCREMENT PRIMARY KEY,
    table_number VARCHAR(20) UNIQUE NOT NULL,
    table_name VARCHAR(50),
    
    -- Capacity
    seats INT DEFAULT 4,
    location VARCHAR(50),  -- indoor, outdoor, patio, vip, balcony
    floor_number INT DEFAULT 1,
    
    -- QR Code
    qr_token VARCHAR(191) UNIQUE,  -- 191 chars for utf8mb4 index limit
    qr_image_url VARCHAR(500),
    qr_generated_at DATETIME,
    
    -- Status (FLEXIBLE)
    status VARCHAR(20) DEFAULT 'available',  -- available, occupied, reserved, cleaning, maintenance
    current_order_id INT,
    occupied_since DATETIME,
    
    -- Management
    is_active TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_status (status),
    INDEX idx_qr_token (qr_token),
    INDEX idx_number (table_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
COMMENT='Restaurant tables with QR codes';

SELECT '✅ Table app_tables created successfully' AS status;

-- TABLE 4: app_menu
DROP TABLE IF EXISTS app_menu;
CREATE TABLE app_menu (
    menu_id INT AUTO_INCREMENT PRIMARY KEY,
    item_code VARCHAR(60) NOT NULL,
    
    -- Display
    display_name VARCHAR(100),
    description TEXT,
    category VARCHAR(50),  -- Appetizers, Main Course, Drinks, Desserts, etc
    sub_category VARCHAR(50),
    image_url VARCHAR(500),
    display_order INT DEFAULT 0,
    
    -- Pricing
    price DECIMAL(17,7),
    original_price DECIMAL(17,7),
    
    -- Availability flags
    is_available TINYINT(1) DEFAULT 1,
    is_featured TINYINT(1) DEFAULT 0,
    available_for_dine_in TINYINT(1) DEFAULT 1,
    available_for_takeaway TINYINT(1) DEFAULT 1,
    available_for_delivery TINYINT(1) DEFAULT 1,
    
    -- Dietary info
    is_vegetarian TINYINT(1) DEFAULT 0,
    is_halal TINYINT(1) DEFAULT 0,
    is_spicy TINYINT(1) DEFAULT 0,
    spice_level INT DEFAULT 0,  -- 0-5
    allergens VARCHAR(200),  -- nuts, dairy, gluten, shellfish
    calories INT,
    
    -- Preparation
    prep_time INT,  -- minutes
    
    -- Timestamps
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_item_code (item_code),
    INDEX idx_category (category),
    INDEX idx_available (is_available),
    INDEX idx_featured (is_featured)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
COMMENT='Digital menu for customer app';

SELECT '✅ Table app_menu created successfully' AS status;

-- TABLE 5: app_payments
DROP TABLE IF EXISTS app_payments;
CREATE TABLE app_payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    
    -- Payment method (FLEXIBLE)
    payment_method VARCHAR(30) DEFAULT 'cash',  -- cash, card, qris, online, points, ewallet, bank_transfer, tng, boost
    amount DECIMAL(10,2),
    
    -- Gateway details
    gateway_transaction_id VARCHAR(100),
    gateway_name VARCHAR(50),  -- xendit, midtrans, stripe, ipay88, razer
    gateway_response TEXT,
    
    -- Status (FLEXIBLE)
    status VARCHAR(20) DEFAULT 'pending',  -- pending, processing, success, failed, refunded, cancelled
    
    -- Timestamps
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    paid_at DATETIME,
    
    -- Additional info
    card_last4 VARCHAR(4),
    card_type VARCHAR(20),  -- Visa, Mastercard, Amex
    bank_name VARCHAR(50),
    failure_reason TEXT,
    refund_amount DECIMAL(10,2),
    refunded_at DATETIME,
    
    INDEX idx_order (order_id),
    INDEX idx_status (status),
    INDEX idx_payment_method (payment_method),
    INDEX idx_gateway_txn (gateway_transaction_id),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
COMMENT='Payment transaction records';

SELECT '✅ Table app_payments created successfully' AS status;

-- TABLE 6: points_transactions
DROP TABLE IF EXISTS points_transactions;
CREATE TABLE points_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    custno VARCHAR(12) NOT NULL,
    
    -- Transaction type (FLEXIBLE)
    type VARCHAR(20) DEFAULT 'earned',  -- earned, redeemed, expired, adjusted, bonus, refunded, promotional
    points INT,
    balance_before INT,
    balance_after INT,
    
    -- Reference
    order_id INT,
    refno VARCHAR(20),
    description VARCHAR(255),
    
    -- Tracking
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(10),
    expires_at DATE,
    
    INDEX idx_custno (custno),
    INDEX idx_type (type),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
COMMENT='Loyalty points transaction log';

SELECT '✅ Table points_transactions created successfully' AS status;

-- TABLE 7: kitchen_display
DROP TABLE IF EXISTS kitchen_display;
CREATE TABLE kitchen_display (
    kitchen_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    
    -- Display info
    order_number VARCHAR(50),
    table_number VARCHAR(20),
    item_name VARCHAR(100),
    quantity INT,
    special_instructions TEXT,
    
    -- Kitchen management (FLEXIBLE)
    station VARCHAR(50),  -- grill, fryer, salad, drinks, wok, pastry, sushi, etc
    priority VARCHAR(20) DEFAULT 'normal',  -- normal, high, urgent, vip
    
    -- Status (FLEXIBLE)
    status VARCHAR(20) DEFAULT 'new',  -- new, acknowledged, cooking, ready, served, cancelled
    
    -- Timing
    received_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    acknowledged_at DATETIME,
    started_at DATETIME,
    completed_at DATETIME,
    target_time DATETIME,
    
    -- Staff
    assigned_to VARCHAR(50),
    prepared_by VARCHAR(50),
    
    INDEX idx_order (order_id),
    INDEX idx_item (item_id),
    INDEX idx_status (status),
    INDEX idx_priority (priority),
    INDEX idx_station (station),
    INDEX idx_received (received_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
COMMENT='Kitchen display system';

SELECT '✅ Table kitchen_display created successfully' AS status;

-- TABLE 8: daily_summary
DROP TABLE IF EXISTS daily_summary;
CREATE TABLE daily_summary (
    summary_id INT AUTO_INCREMENT PRIMARY KEY,
    business_date DATE UNIQUE NOT NULL,
    
    -- Order counts
    total_orders INT DEFAULT 0,
    dine_in_orders INT DEFAULT 0,
    takeaway_orders INT DEFAULT 0,
    delivery_orders INT DEFAULT 0,
    cancelled_orders INT DEFAULT 0,
    
    -- Order source
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
    
    -- Loyalty
    points_earned INT DEFAULT 0,
    points_redeemed INT DEFAULT 0,
    
    -- Kitchen
    average_prep_time INT,
    orders_on_time INT DEFAULT 0,
    orders_delayed INT DEFAULT 0,
    
    -- Timestamps
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_date (business_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
COMMENT='Daily sales summary for dashboard';

SELECT '✅ Table daily_summary created successfully' AS status;

-- ============================================================================
-- PART 3: MIGRATE MEMBER DATA (OPTIONAL)
-- Run this only if you want to migrate existing member data to arcust
-- ============================================================================

-- Uncomment and run if you have existing member table
/*
UPDATE arcust a
INNER JOIN member m ON a.CUSTNO = m.CUSTOMERNO
SET 
    a.is_member = 1,
    a.memberno = m.memberno,
    a.member_discount = m.disp1,
    a.member_since = m.created_on,
    a.member_remark1 = m.remark1,
    a.member_remark2 = m.remark2,
    a.member_remark3 = m.remark3,
    a.member_remark4 = m.remark4,
    a.member_remark5 = m.remark5;

SELECT '✅ Member data migrated successfully' AS status;

-- Verify migration
SELECT 
    CUSTNO,
    NAME,
    is_member,
    memberno,
    member_discount,
    POINT_BF as loyalty_points
FROM arcust
WHERE is_member = 1
LIMIT 10;
*/

-- ============================================================================
-- PART 4: VERIFICATION
-- ============================================================================

-- Check new tables created
SELECT 
    TABLE_NAME, 
    ENGINE, 
    TABLE_ROWS, 
    CREATE_TIME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME LIKE 'app_%'
ORDER BY TABLE_NAME;

-- Check arcust new columns
SHOW COLUMNS FROM arcust LIKE '%app%';
SHOW COLUMNS FROM arcust LIKE '%member%';

-- Check currartran new columns
SHOW COLUMNS FROM currartran WHERE Field IN ('app_order_id', 'order_source');

-- Check icitem new columns
SHOW COLUMNS FROM icitem WHERE Field IN ('show_in_app', 'app_image_url', 'is_recommended');

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

SELECT '
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ✅ DATABASE UPGRADE COMPLETED SUCCESSFULLY!               ║
║                                                              ║
║   Updated Tables: 3                                          ║
║   New Tables: 8                                              ║
║   Total Changes: 11                                          ║
║                                                              ║
║   Next Steps:                                                ║
║   1. Verify all tables created                               ║
║   2. Setup QR codes for tables                               ║
║   3. Sync menu from icitem to app_menu                       ║
║   4. Configure payment gateway                               ║
║   5. Test customer app integration                           ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
' AS '🎉 SUCCESS';

