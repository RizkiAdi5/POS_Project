# 🚀 QUICK REFERENCE - POS Database Upgrade

## 📊 TABLE SUMMARY

### Existing Tables (Updated)
| Table | Purpose | Changes |
|-------|---------|---------|
| `arcust` | Customer Master | +17 columns (app auth + member data) |
| `currartran` | Transaction Header | +2 columns (link to app) |
| `icitem` | Item Master | +3 columns (app display) |

### New Tables (8 Tables)
| Table | Purpose | Key Fields |
|-------|---------|-----------|
| `app_orders` | Order management | order_id, order_number, custno, status, total_amount |
| `app_order_items` | Order details | item_id, order_id, item_code, quantity, subtotal |
| `app_tables` | Table & QR codes | table_id, table_number, qr_token, status |
| `app_menu` | Digital menu | menu_id, item_code, category, price, is_available |
| `app_payments` | Payment records | payment_id, order_id, payment_method, status |
| `points_transactions` | Points history | transaction_id, custno, type, points, balance_after |
| `kitchen_display` | Kitchen orders | kitchen_id, order_id, item_id, station, status |
| `daily_summary` | Daily reports | summary_id, business_date, total_orders, net_revenue |

---

## 🔑 IMPORTANT FIELD SIZES

**Customer & Transaction:**
- `custno` = `VARCHAR(12)` (matches arcust.CUSTNO)
- `refno` = `VARCHAR(20)` (matches currartran.REFNO)

**Items:**
- `item_code` = `VARCHAR(60)` (matches icitem.ITEMNO)

**QR Code:**
- `qr_token` = `VARCHAR(191)` (utf8mb4 index limit)

---

## 📝 COMMON QUERIES

### 1. Create New Order (QR Dine-In)
```sql
-- Insert order
INSERT INTO app_orders (order_number, custno, table_number, order_type, order_source, total_amount, status)
VALUES ('ORD-001', 'C001', 'T05', 'dine_in', 'qr_code', 50.00, 'pending');

SET @order_id = LAST_INSERT_ID();

-- Insert items
INSERT INTO app_order_items (order_id, item_code, item_name, quantity, unit_price, subtotal)
VALUES 
    (@order_id, 'ITEM001', 'Nasi Goreng', 2, 15.00, 30.00),
    (@order_id, 'ITEM002', 'Teh Ais', 2, 10.00, 20.00);

-- Send to kitchen
INSERT INTO kitchen_display (order_id, item_id, order_number, table_number, item_name, quantity, status)
SELECT @order_id, item_id, 'ORD-001', 'T05', item_name, quantity, 'new'
FROM app_order_items WHERE order_id = @order_id;
```

### 2. Update Order Status
```sql
-- Confirm order
UPDATE app_orders SET status = 'confirmed', confirmed_at = NOW() WHERE order_id = 1;

-- Kitchen preparing
UPDATE kitchen_display SET status = 'cooking', started_at = NOW() WHERE order_id = 1;

-- Ready to serve
UPDATE kitchen_display SET status = 'ready', completed_at = NOW() WHERE order_id = 1;
UPDATE app_orders SET status = 'ready', ready_at = NOW() WHERE order_id = 1;

-- Complete order
UPDATE app_orders SET status = 'completed', completed_at = NOW() WHERE order_id = 1;
```

### 3. Process Payment
```sql
-- Record payment
INSERT INTO app_payments (order_id, payment_method, amount, status)
VALUES (1, 'qris', 50.00, 'pending');

-- Payment success
UPDATE app_payments SET status = 'success', paid_at = NOW() WHERE order_id = 1;

-- Link to POS transaction
INSERT INTO currartran (REFNO, CUSTNO, TRAN_DATE, NET_BIL, app_order_id, order_source)
VALUES ('CS000001', 'C001', NOW(), 50.00, 1, 'qr_code');

UPDATE app_orders SET refno = 'CS000001', status = 'completed' WHERE order_id = 1;
```

### 4. Award Loyalty Points
```sql
-- Calculate points (RM50 = 5 points)
SET @points = FLOOR(50.00 / 10);
SET @custno = 'C001';

-- Get current balance
SELECT @current_balance := POINT_BF FROM arcust WHERE CUSTNO = @custno;

-- Record transaction
INSERT INTO points_transactions (custno, type, points, balance_before, balance_after, order_id, description)
VALUES (@custno, 'earned', @points, @current_balance, @current_balance + @points, 1, 'Order ORD-001');

-- Update balance
UPDATE arcust SET POINT_BF = POINT_BF + @points WHERE CUSTNO = @custno;
```

### 5. Redeem Points
```sql
-- Redeem 100 points
SET @redeem_points = 100;
SET @custno = 'C001';

-- Check balance
SELECT @current_balance := POINT_BF FROM arcust WHERE CUSTNO = @custno;

-- If enough points
IF @current_balance >= @redeem_points THEN
    -- Record redemption
    INSERT INTO points_transactions (custno, type, points, balance_before, balance_after, order_id, description)
    VALUES (@custno, 'redeemed', -@redeem_points, @current_balance, @current_balance - @redeem_points, 2, 'Redeemed for discount');
    
    -- Update balance
    UPDATE arcust SET POINT_BF = POINT_BF - @redeem_points WHERE CUSTNO = @custno;
END IF;
```

### 6. Get Today's Orders
```sql
SELECT 
    o.order_number,
    o.custno,
    a.NAME as customer_name,
    o.table_number,
    o.order_type,
    o.status,
    o.total_amount,
    COUNT(i.item_id) as total_items,
    o.created_at
FROM app_orders o
LEFT JOIN arcust a ON o.custno = a.CUSTNO
LEFT JOIN app_order_items i ON o.order_id = i.order_id
WHERE DATE(o.created_at) = CURDATE()
GROUP BY o.order_id
ORDER BY o.created_at DESC;
```

### 7. Kitchen Display - Active Orders
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
    k.status,
    TIMESTAMPDIFF(MINUTE, k.received_at, NOW()) as wait_minutes
FROM kitchen_display k
WHERE k.status IN ('new', 'acknowledged', 'cooking')
ORDER BY 
    FIELD(k.priority, 'urgent', 'high', 'normal'),
    k.received_at ASC;
```

### 8. Customer Order History
```sql
SELECT 
    o.order_number,
    o.order_type,
    o.total_amount,
    o.status,
    o.created_at,
    GROUP_CONCAT(
        CONCAT(i.item_name, ' x', i.quantity) 
        SEPARATOR ', '
    ) as items
FROM app_orders o
LEFT JOIN app_order_items i ON o.order_id = i.order_id
WHERE o.custno = 'C001'
    AND o.status = 'completed'
GROUP BY o.order_id
ORDER BY o.created_at DESC
LIMIT 20;
```

### 9. Top Selling Items Today
```sql
SELECT 
    i.item_code,
    i.item_name,
    COUNT(DISTINCT o.order_id) as order_count,
    SUM(i.quantity) as total_quantity,
    SUM(i.subtotal) as total_revenue
FROM app_order_items i
INNER JOIN app_orders o ON i.order_id = o.order_id
WHERE DATE(o.created_at) = CURDATE()
    AND o.status = 'completed'
GROUP BY i.item_code, i.item_name
ORDER BY total_revenue DESC
LIMIT 10;
```

### 10. Generate Daily Summary
```sql
INSERT INTO daily_summary (
    business_date,
    total_orders,
    dine_in_orders,
    takeaway_orders,
    delivery_orders,
    cancelled_orders,
    qr_orders,
    waiter_orders,
    platform_orders,
    gross_revenue,
    tax_amount,
    service_charge,
    discount_amount,
    net_revenue,
    average_order_value,
    total_customers
)
SELECT 
    CURDATE(),
    COUNT(*),
    SUM(CASE WHEN order_type = 'dine_in' THEN 1 ELSE 0 END),
    SUM(CASE WHEN order_type = 'takeaway' THEN 1 ELSE 0 END),
    SUM(CASE WHEN order_type = 'delivery' THEN 1 ELSE 0 END),
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END),
    SUM(CASE WHEN order_source = 'qr_code' THEN 1 ELSE 0 END),
    SUM(CASE WHEN order_source = 'waiter' THEN 1 ELSE 0 END),
    SUM(CASE WHEN order_source = 'delivery_platform' THEN 1 ELSE 0 END),
    SUM(subtotal),
    SUM(tax_amount),
    SUM(service_charge),
    SUM(discount_amount),
    SUM(total_amount),
    AVG(total_amount),
    COUNT(DISTINCT custno)
FROM app_orders
WHERE DATE(created_at) = CURDATE()
    AND status = 'completed';
```

---

## 🎨 STATUS VALUES

### Order Status (`app_orders.status`)
- `pending` - Just created, waiting confirmation
- `confirmed` - Confirmed, sent to kitchen
- `preparing` - Kitchen is preparing
- `ready` - Ready to serve
- `completed` - Order completed & paid
- `cancelled` - Order cancelled

### Kitchen Status (`kitchen_display.status`)
- `new` - New order received
- `acknowledged` - Chef acknowledged
- `cooking` - Currently cooking
- `ready` - Food ready
- `served` - Served to customer

### Payment Status (`app_payments.status`)
- `pending` - Payment initiated
- `processing` - Gateway processing
- `success` - Payment successful
- `failed` - Payment failed
- `refunded` - Payment refunded
- `cancelled` - Payment cancelled

### Table Status (`app_tables.status`)
- `available` - Empty, ready
- `occupied` - Customer seated
- `reserved` - Reserved
- `cleaning` - Being cleaned
- `maintenance` - Under maintenance

---

## 🔄 ORDER FLOW

```
1. QR Code Order:
   Customer scan QR → app_tables.qr_token
                   ↓
   Browse menu → app_menu (is_available = 1)
                   ↓
   Place order → INSERT app_orders (status=pending)
                   ↓
   Add items → INSERT app_order_items
                   ↓
   Confirm → UPDATE app_orders (status=confirmed)
                   ↓
   Send to kitchen → INSERT kitchen_display (status=new)
                   ↓
   Kitchen prepare → UPDATE kitchen_display (status=cooking)
                   ↓
   Ready → UPDATE kitchen_display (status=ready)
        → UPDATE app_orders (status=ready)
                   ↓
   Payment → INSERT app_payments
          → INSERT currartran (POS sync)
                   ↓
   Complete → UPDATE app_orders (status=completed)
           → INSERT points_transactions (earn points)
           → UPDATE arcust.POINT_BF
```

---

## ⚠️ IMPORTANT NOTES

### 1. No Foreign Keys
Tables `arcust` and `icitem` use **MyISAM** engine (no FK support).
Application must validate:
- `custno` exists in `arcust` before insert
- `item_code` exists in `icitem` before insert

### 2. VARCHAR Instead of ENUM
All status fields use **VARCHAR** for flexibility.
Define constants in your application code.

### 3. Character Set
New tables use **utf8mb4** (supports emoji).
Max indexed field length = **191 characters**

### 4. Decimal Precision
- Money fields: `DECIMAL(10,2)` - RM999,999.99
- Price fields: `DECIMAL(17,7)` - matches `icitem.PRICE`
- Points: `DECIMAL(19,2)` - matches `arcust.POINT_BF`

---

## 📞 USEFUL CHECKS

### Check Table Status
```sql
-- All app tables
SHOW TABLE STATUS LIKE 'app_%';

-- Check indexes
SHOW INDEX FROM app_orders;

-- Check table size
SELECT 
    TABLE_NAME,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME LIKE 'app_%';
```

### Check Data Integrity
```sql
-- Orders without customer
SELECT order_id, custno FROM app_orders 
WHERE custno NOT IN (SELECT CUSTNO FROM arcust);

-- Order items without valid item code
SELECT item_id, item_code FROM app_order_items
WHERE item_code NOT IN (SELECT ITEMNO FROM icitem);

-- Orders without items
SELECT o.order_id, o.order_number
FROM app_orders o
LEFT JOIN app_order_items i ON o.order_id = i.order_id
WHERE i.item_id IS NULL;
```

---

## 🛠️ MAINTENANCE

### Clean Old Data
```sql
-- Archive completed orders older than 1 year
-- (Create archive table first)
INSERT INTO app_orders_archive
SELECT * FROM app_orders
WHERE status = 'completed'
    AND created_at < DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- Delete from main table
DELETE FROM app_orders
WHERE status = 'completed'
    AND created_at < DATE_SUB(NOW(), INTERVAL 1 YEAR);
```

### Rebuild Indexes
```sql
-- If queries getting slow
OPTIMIZE TABLE app_orders;
OPTIMIZE TABLE app_order_items;
OPTIMIZE TABLE kitchen_display;
```

### Reset Test Data
```sql
-- WARNING: This deletes all data!
TRUNCATE TABLE kitchen_display;
TRUNCATE TABLE app_payments;
TRUNCATE TABLE app_order_items;
TRUNCATE TABLE app_orders;
TRUNCATE TABLE points_transactions;
TRUNCATE TABLE daily_summary;
```

---

**Version:** 1.0  
**Last Updated:** 2026-01-13

