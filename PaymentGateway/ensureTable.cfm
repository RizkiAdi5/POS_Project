<!--- Creates pg_payment_profile if missing (MySQL / MariaDB tenant DB). --->
<cfif NOT IsDefined("dts") OR NOT Len(Trim(dts))>
	<cfthrow message="Payment Gateway: datasource (dts) is not set.">
</cfif>

<cfset pgTableExists = false>

<cftry>
	<cfquery datasource="#dts#" name="pgProbe">
		SELECT profile_id FROM pg_payment_profile LIMIT 1
	</cfquery>
	<cfset pgTableExists = true>
	<cfcatch type="any">
		<cfset pgTableExists = false>
	</cfcatch>
</cftry>

<cfif NOT pgTableExists>
	<cfquery datasource="#dts#">
		CREATE TABLE IF NOT EXISTS pg_payment_profile (
			profile_id INT AUTO_INCREMENT PRIMARY KEY,
			business_email VARCHAR(255) NOT NULL DEFAULT '',
			business_name VARCHAR(255) NOT NULL DEFAULT '',
			business_description VARCHAR(500) DEFAULT NULL,
			country_code CHAR(2) NOT NULL DEFAULT 'ID',
			account_type VARCHAR(20) NOT NULL DEFAULT 'MANAGED',
			xendit_account_id VARCHAR(64) DEFAULT NULL,
			xendit_status VARCHAR(40) DEFAULT NULL,
			xendit_type VARCHAR(20) DEFAULT NULL,
			xendit_synced_at DATETIME DEFAULT NULL,
			payout_channel_code VARCHAR(40) DEFAULT NULL,
			payout_channel_name VARCHAR(120) DEFAULT NULL,
			payout_account_number VARCHAR(40) DEFAULT NULL,
			payout_account_holder VARCHAR(120) DEFAULT NULL,
			enable_qris CHAR(1) NOT NULL DEFAULT 'Y',
			enable_ewallet CHAR(1) NOT NULL DEFAULT 'Y',
			enable_va CHAR(1) NOT NULL DEFAULT 'Y',
			enable_card CHAR(1) NOT NULL DEFAULT 'N',
			is_active CHAR(1) NOT NULL DEFAULT 'Y',
			notes TEXT,
			created_at DATETIME DEFAULT NULL,
			updated_at DATETIME DEFAULT NULL,
			created_by VARCHAR(50) DEFAULT NULL,
			updated_by VARCHAR(50) DEFAULT NULL
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
	</cfquery>
</cfif>

<!--- Backward-compatible schema upgrade for payment profile API fields. --->
<cfquery name="qCols" datasource="#dts#">
	SELECT COLUMN_NAME
	FROM information_schema.COLUMNS
	WHERE TABLE_SCHEMA = DATABASE()
	  AND TABLE_NAME = 'pg_payment_profile'
</cfquery>

<cfset pgCols = "," & LCase(ValueList(qCols.COLUMN_NAME)) & ",">

<cfif NOT FindNoCase(",xendit_callback_token,", pgCols)>
	<cfquery datasource="#dts#">
		ALTER TABLE pg_payment_profile
		ADD COLUMN xendit_callback_token VARCHAR(120) DEFAULT NULL AFTER xendit_account_id
	</cfquery>
</cfif>

<cfif NOT FindNoCase(",payment_active,", pgCols)>
	<cfquery datasource="#dts#">
		ALTER TABLE pg_payment_profile
		ADD COLUMN payment_active TINYINT(1) NOT NULL DEFAULT 0 AFTER is_active
	</cfquery>
</cfif>

<cfif NOT FindNoCase(",payment_methods_enabled,", pgCols)>
	<cfquery datasource="#dts#">
		ALTER TABLE pg_payment_profile
		ADD COLUMN payment_methods_enabled TEXT DEFAULT NULL AFTER payment_active
	</cfquery>
</cfif>

<cfif NOT FindNoCase(",va_banks_enabled,", pgCols)>
	<cfquery datasource="#dts#">
		ALTER TABLE pg_payment_profile
		ADD COLUMN va_banks_enabled TEXT DEFAULT NULL AFTER payment_methods_enabled
	</cfquery>
</cfif>

<!--- Older installs may miss audit timestamps used by API UPDATE/INSERT flows. --->
<cfif NOT FindNoCase(",created_at,", pgCols)>
	<cfquery datasource="#dts#">
		ALTER TABLE pg_payment_profile
		ADD COLUMN created_at DATETIME DEFAULT NULL AFTER notes
	</cfquery>
</cfif>

<cfif NOT FindNoCase(",updated_at,", pgCols)>
	<cfquery datasource="#dts#">
		ALTER TABLE pg_payment_profile
		ADD COLUMN updated_at DATETIME DEFAULT NULL AFTER created_at
	</cfquery>
</cfif>

<!--- Payment transaction ledger for Xendit integration. --->
<cfquery datasource="#dts#">
	CREATE TABLE IF NOT EXISTS payment_transactions (
		id BIGINT AUTO_INCREMENT PRIMARY KEY,
		order_id VARCHAR(64) NOT NULL,
		reference_id VARCHAR(120) NOT NULL,
		xendit_payment_id VARCHAR(120) DEFAULT NULL,
		customer_id VARCHAR(64) DEFAULT NULL,
		amount DECIMAL(18,2) NOT NULL DEFAULT 0,
		currency VARCHAR(10) NOT NULL DEFAULT 'IDR',
		payment_method VARCHAR(30) NOT NULL,
		payment_channel VARCHAR(60) NOT NULL,
		status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
		payment_details LONGTEXT,
		paid_at DATETIME DEFAULT NULL,
		expired_at DATETIME DEFAULT NULL,
		webhook_received_at DATETIME DEFAULT NULL,
		created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
		updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		UNIQUE KEY uk_payment_transactions_reference_id (reference_id),
		KEY idx_payment_transactions_order_id (order_id),
		KEY idx_payment_transactions_xendit_payment_id (xendit_payment_id),
		KEY idx_payment_transactions_status (status)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
</cfquery>

<cfquery name="qTxCols" datasource="#dts#">
	SELECT COLUMN_NAME
	FROM information_schema.COLUMNS
	WHERE TABLE_SCHEMA = DATABASE()
	  AND TABLE_NAME = 'payment_transactions'
</cfquery>
<cfset txCols = "," & LCase(ValueList(qTxCols.COLUMN_NAME)) & ",">

<cfif NOT FindNoCase(",customer_id,", txCols)>
	<cfquery datasource="#dts#">ALTER TABLE payment_transactions ADD COLUMN customer_id VARCHAR(64) DEFAULT NULL AFTER xendit_payment_id</cfquery>
</cfif>
<cfif NOT FindNoCase(",payment_details,", txCols)>
	<cfquery datasource="#dts#">ALTER TABLE payment_transactions ADD COLUMN payment_details LONGTEXT AFTER status</cfquery>
</cfif>
<cfif NOT FindNoCase(",webhook_received_at,", txCols)>
	<cfquery datasource="#dts#">ALTER TABLE payment_transactions ADD COLUMN webhook_received_at DATETIME DEFAULT NULL AFTER expired_at</cfquery>
</cfif>
