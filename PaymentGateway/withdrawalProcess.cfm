<!---
    /PaymentGateway/withdrawalProcess.cfm
    Processes a batch withdrawal request:
    1. Validate selected bank account belongs to this dts
    2. Sum all pending disbursements
    3. Deduct Xendit fee if client absorbs it
    4. Create disbursement_batches row
    5. Call Node.js /xendit/disburse-batch
    6. Update batch + mark disbursements as disbursed
--->

<cfif CGI.REQUEST_METHOD neq "POST">
    <cflocation url="withdrawal.cfm" addtoken="false">
</cfif>

<cfset accountId = val(isDefined("FORM.account_id") ? FORM.account_id : 0)>
<cfif accountId lte 0>
    <cflocation url="withdrawal.cfm?err=#URLEncodedFormat("No bank account selected.")#" addtoken="false">
</cfif>

<cftry>

    <!--- 1. Validate account belongs to this dts --->
    <cfquery name="qAcct" datasource="#dts#">
        SELECT id, bank_code, account_number, account_name,
               absorb_gateway_fee, platform_fee_pct
        FROM   main.client_payment_accounts
        WHERE  id        = <cfqueryparam cfsqltype="cf_sql_integer" value="#accountId#">
          AND  dts       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
          AND  is_active = 1
        LIMIT  1
    </cfquery>
    <cfif qAcct.recordCount eq 0>
        <cflocation url="withdrawal.cfm?err=#URLEncodedFormat("Invalid or inactive bank account.")#" addtoken="false">
    </cfif>

    <!--- 2. Sum all pending disbursements for this dts (lock rows) --->
    <cfquery name="qSum" datasource="#dts#">
        SELECT COUNT(*)                       AS pending_count,
               COALESCE(SUM(gross_amount),    0) AS total_gross,
               COALESCE(SUM(platform_fee),    0) AS total_platform_fee,
               COALESCE(SUM(disburse_amount), 0) AS available_balance
        FROM   main.disbursements
        WHERE  dts    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
          AND  status = 'pending'
    </cfquery>

    <cfset availableBalance = val(qSum.available_balance)>
    <cfif availableBalance lte 0>
        <cflocation url="withdrawal.cfm?err=#URLEncodedFormat("No pending balance to withdraw.")#" addtoken="false">
    </cfif>

    <!--- 3. Xendit disbursement fee: Rp 5,000 flat if client absorbs it --->
    <cfset XENDIT_DISBURSE_FEE = 5000>
    <cfset xenditFee     = (val(qAcct.absorb_gateway_fee) ? XENDIT_DISBURSE_FEE : 0)>
    <cfset totalDisburse = availableBalance - xenditFee>
    <cfif totalDisburse lte 0>
        <cflocation url="withdrawal.cfm?err=#URLEncodedFormat("Balance too low to cover disbursement fee.")#" addtoken="false">
    </cfif>

    <!--- 4. Create batch record (status=pending until Xendit confirms) --->
    <cfquery datasource="#dts#">
        INSERT INTO main.disbursement_batches
            (dts, account_id, total_gross, total_platform_fee,
             xendit_fee, total_disburse, status, requested_at)
        VALUES (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#accountId#">,
            <cfqueryparam cfsqltype="cf_sql_decimal" value="#val(qSum.total_gross)#"         scale="2">,
            <cfqueryparam cfsqltype="cf_sql_decimal" value="#val(qSum.total_platform_fee)#"  scale="2">,
            <cfqueryparam cfsqltype="cf_sql_decimal" value="#xenditFee#"                     scale="2">,
            <cfqueryparam cfsqltype="cf_sql_decimal" value="#totalDisburse#"                 scale="2">,
            'pending',
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        )
    </cfquery>
    <cfquery name="qBatchId" datasource="#dts#">
        SELECT LAST_INSERT_ID() AS batch_id
    </cfquery>
    <cfset batchId = val(qBatchId.batch_id)>

    <!--- 5. Call Node.js sidecar to execute Xendit disbursement --->
    <cfset AI_SHARED_SECRET = "cleRkQqi7ogrKX5mAn6xr8LXmz9MobDlzcnKAYYHYCIqDnBy2c5bfuWRyrXDTcVw">
    <cfset nodePayload = structNew()>
    <cfset nodePayload.dts            = dts>
    <cfset nodePayload.batch_id       = batchId>
    <cfset nodePayload.amount         = totalDisburse>
    <cfset nodePayload.bank_code      = trim(qAcct.bank_code)>
    <cfset nodePayload.account_number = trim(qAcct.account_number)>
    <cfset nodePayload.account_name   = trim(qAcct.account_name)>

    <cfhttp url="http://127.0.0.1:8088/xendit/disburse-batch" method="POST"
            result="nodeResp" timeout="45">
        <cfhttpparam type="header" name="Content-Type" value="application/json">
        <cfhttpparam type="header" name="x-ai-secret"  value="#AI_SHARED_SECRET#">
        <cfhttpparam type="body"   value="#serializeJSON(nodePayload)#">
    </cfhttp>

    <cfset nodeData   = deserializeJSON(nodeResp.fileContent)>
    <cfset xenditOk   = (nodeResp.statusCode eq "200 OK" AND structKeyExists(nodeData, "ok") AND nodeData.ok eq true)>
    <cfset xenditId   = (xenditOk AND structKeyExists(nodeData, "xendit_disburse_id") ? trim(nodeData.xendit_disburse_id) : "")>
    <cfset xenditStat = (xenditOk ? trim(nodeData.status) : "failed")>

    <!--- 6a. Update batch record with Xendit result --->
    <cfquery datasource="#dts#">
        UPDATE main.disbursement_batches
        SET    xendit_disburse_id = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#xenditId#">,
               status             = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#xenditStat#">,
               completed_at       = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
               notes              = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#(xenditOk ? '' : left(nodeResp.fileContent, 500))#">
        WHERE  id = <cfqueryparam cfsqltype="cf_sql_integer" value="#batchId#">
    </cfquery>

    <!--- 6b. Mark all pending disbursements as disbursed / failed --->
    <cfif xenditOk>
        <cfquery datasource="#dts#">
            UPDATE main.disbursements
            SET    status   = 'disbursed',
                   batch_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#batchId#">
            WHERE  dts    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">
              AND  status = 'pending'
        </cfquery>
        <cflocation url="withdrawal.cfm?msg=#URLEncodedFormat("Withdrawal submitted successfully. Xendit ID: " & xenditId)#" addtoken="false">
    <cfelse>
        <cfset errDetail = (structKeyExists(nodeData, "error") ? trim(nodeData.error) : "Xendit error")>
        <cflog file="payment_gateway" type="error"
               text="disburse-batch failed for dts=#dts# batch=#batchId#: #nodeResp.fileContent#">
        <cflocation url="withdrawal.cfm?err=#URLEncodedFormat("Withdrawal failed: " & errDetail & ". Contact support with batch ID " & batchId)#" addtoken="false">
    </cfif>

<cfcatch type="any">
    <cflog file="payment_gateway" type="error"
           text="withdrawalProcess error (dts=#dts#): #cfcatch.message# | #cfcatch.detail#">
    <cflocation url="withdrawal.cfm?err=#URLEncodedFormat(cfcatch.message)#" addtoken="false">
</cfcatch>
</cftry>
