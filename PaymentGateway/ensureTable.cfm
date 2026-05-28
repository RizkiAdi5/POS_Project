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
