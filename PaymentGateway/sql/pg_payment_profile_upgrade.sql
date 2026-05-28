-- Payment Gateway Profile schema upgrade
-- Safe to run multiple times (MySQL 8+ / MariaDB with IF NOT EXISTS support).

ALTER TABLE pg_payment_profile
    ADD COLUMN IF NOT EXISTS xendit_callback_token VARCHAR(120) NULL AFTER xendit_account_id,
    ADD COLUMN IF NOT EXISTS payment_active TINYINT(1) NOT NULL DEFAULT 0 AFTER is_active,
    ADD COLUMN IF NOT EXISTS payment_methods_enabled TEXT NULL AFTER payment_active,
    ADD COLUMN IF NOT EXISTS va_banks_enabled TEXT NULL AFTER payment_methods_enabled,
    ADD COLUMN IF NOT EXISTS created_at DATETIME NULL AFTER notes,
    ADD COLUMN IF NOT EXISTS updated_at DATETIME NULL AFTER created_at;

CREATE TABLE IF NOT EXISTS payment_transactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(64) NOT NULL,
    reference_id VARCHAR(120) NOT NULL,
    xendit_payment_id VARCHAR(120) NULL,
    customer_id VARCHAR(64) NULL,
    amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    currency VARCHAR(10) NOT NULL DEFAULT 'IDR',
    payment_method VARCHAR(30) NOT NULL,
    payment_channel VARCHAR(60) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    payment_details LONGTEXT NULL,
    paid_at DATETIME NULL,
    expired_at DATETIME NULL,
    webhook_received_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_payment_transactions_reference_id (reference_id),
    KEY idx_payment_transactions_order_id (order_id),
    KEY idx_payment_transactions_xendit_payment_id (xendit_payment_id),
    KEY idx_payment_transactions_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
