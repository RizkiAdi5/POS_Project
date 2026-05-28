<!---
    /PaymentGateway/paymentProcess.cfm — Start Xendit payment or cashier request.
--->
<cfinclude template="/application.cfm">
<cfinclude template="/latest/customer/inc_emenu_order.cfm">
<cfinclude template="/latest/customer/inc_emenu_currency.cfm">
<cfinclude template="/latest/customer/inc_xendit_pay.cfm">

<cfif NOT len(trim(SESSION.emenu_table_id)) OR val(SESSION.emenu_order_id) lte 0>
    <cflocation url="/latest/customer/qr_error.cfm" addtoken="false">
</cfif>
<cfif CGI.REQUEST_METHOD neq "POST" OR NOT structKeyExists(FORM, "pay_action")>
    <cflocation url="/PaymentGateway/payment.cfm" addtoken="false">
</cfif>

<cfset orderId = val(SESSION.emenu_order_id)>
<cfset payAction = lCase(trim(FORM.pay_action))>
<cfset ewalletMobile = structKeyExists(FORM, "ewallet_mobile") ? trim(FORM.ewallet_mobile) : "">
<cfset ewalletMobileDigits = "">
<cfset selectedVaBank = structKeyExists(FORM, "va_bank") ? UCase(Trim(FORM.va_bank)) : "">

<cfquery name="qOrd" datasource="#dts#">
    SELECT order_id, order_number, status, total_amount, custno
    FROM   app_orders
    WHERE  order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
      AND  table_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(SESSION.emenu_table_id)#">
    LIMIT  1
</cfquery>

<cfif qOrd.recordCount eq 0>
    <cflocation url="/PaymentGateway/payment.cfm?err=order_not_found" addtoken="false">
</cfif>
<cfif emenuOrderIsPaid(dts, orderId, qOrd.status)>
    <cflocation url="/latest/customer/order_status.cfm?msg=already_paid" addtoken="false">
</cfif>

<cfset totals = emenuRecalculateOrderTotals(dts, orderId)>
<cfset payAmount = val(totals.total_amount)>
<cfif payAmount lte 0><cfset payAmount = val(qOrd.total_amount)></cfif>

<cftry>
    <cfif payAction eq "cashier">
        <cfquery name="qCashPending" datasource="#dts#">
            SELECT payment_id
            FROM app_payments
            WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
              AND payment_method = <cfqueryparam cfsqltype="cf_sql_varchar" value="cash">
              AND status IN ('pending','processing')
            ORDER BY payment_id DESC
            LIMIT 1
        </cfquery>
        <cfif qCashPending.recordCount eq 0>
            <cfquery datasource="#dts#">
                INSERT INTO app_payments (order_id, payment_method, amount, status)
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="cash">,
                    <cfqueryparam cfsqltype="cf_sql_decimal" value="#payAmount#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="pending">
                )
            </cfquery>
        </cfif>
        <cflocation url="/PaymentGateway/payment_done.cfm?method=cashier" addtoken="false">
    </cfif>

    <cfset pgProf = emenuPgProfile(dts)>
    <cfif NOT REQUEST.xendit.isActive>
        <cflocation url="/PaymentGateway/payment.cfm?err=xendit_not_ready" addtoken="false">
    </cfif>

    <cfset payMethod = payAction>
    <cfif NOT listFindNoCase("qris,ewallet,va,card", payMethod)>
        <cflocation url="/PaymentGateway/payment.cfm?err=invalid_action" addtoken="false">
</cfif>
    <cfif payMethod eq "qris" AND pgProf.enable_qris NEQ "Y"><cflocation url="/PaymentGateway/payment.cfm?err=invalid_action" addtoken="false"></cfif>
    <cfif payMethod eq "ewallet" AND pgProf.enable_ewallet NEQ "Y"><cflocation url="/PaymentGateway/payment.cfm?err=invalid_action" addtoken="false"></cfif>
    <cfif payMethod eq "va" AND pgProf.enable_va NEQ "Y"><cflocation url="/PaymentGateway/payment.cfm?err=invalid_action" addtoken="false"></cfif>
    <cfif payMethod eq "card" AND pgProf.enable_card NEQ "Y"><cflocation url="/PaymentGateway/payment.cfm?err=invalid_action" addtoken="false"></cfif>

    <cfset ewChannel = structKeyExists(FORM, "ewallet_channel") ? trim(FORM.ewallet_channel) : "">
    <cfif payMethod eq "ewallet" AND NOT len(ewChannel)>
        <cflocation url="/PaymentGateway/payment.cfm?err=invalid_action" addtoken="false">
    </cfif>
    <cfif payMethod eq "ewallet">
        <cfset ewalletMobileDigits = ReReplace(ewalletMobile, "[^0-9]", "", "all")>
    </cfif>
    <cfif payMethod eq "ewallet" AND uCase(ewChannel) eq "OVO" AND NOT len(ewalletMobile)>
        <cfif structKeyExists(SESSION, "emenu_phone") AND len(trim(SESSION.emenu_phone))>
            <cfset ewalletMobile = trim(SESSION.emenu_phone)>
        <cfelseif len(trim(qOrd.custno))>
            <cftry>
                <cfquery name="qCustPhone" datasource="#dts#">
                    SELECT IFNULL(PHONE, '') AS phone
                    FROM arcust
                    WHERE custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(qOrd.custno)#">
                    LIMIT 1
                </cfquery>
                <cfif qCustPhone.recordCount AND len(trim(qCustPhone.phone))>
                    <cfset ewalletMobile = trim(qCustPhone.phone)>
                </cfif>
                <cfcatch type="any"></cfcatch>
            </cftry>
        </cfif>
    </cfif>
    <cfif payMethod eq "ewallet" AND uCase(ewChannel) eq "OVO">
        <cfset ewalletMobileDigits = ReReplace(ewalletMobile, "[^0-9]", "", "all")>
        <cfif NOT len(ewalletMobileDigits)>
            <cflocation url="/PaymentGateway/payment.cfm?err=ovo_mobile_required" addtoken="false">
        </cfif>
        <cfif Left(ewalletMobileDigits, 1) EQ "0">
            <cfset ewalletMobileDigits = "62" & Mid(ewalletMobileDigits, 2, Len(ewalletMobileDigits) - 1)>
        <cfelseif Left(ewalletMobileDigits, 2) NEQ "62">
            <cfset ewalletMobileDigits = "62" & ewalletMobileDigits>
        </cfif>
        <cfif Len(ewalletMobileDigits) LT 10 OR Len(ewalletMobileDigits) GT 16>
            <cflocation url="/PaymentGateway/payment.cfm?err=ovo_mobile_invalid" addtoken="false">
        </cfif>
        <cfset ewalletMobile = ewalletMobileDigits>
    </cfif>

    <cfset baseUrl = emenuPayBaseUrl()>
    <cfset returnUrl = baseUrl & "/PaymentGateway/paymentReturn.cfm">
    <cfset custName = len(trim(SESSION.emenu_name)) ? trim(SESSION.emenu_name) : "Guest">
    <cfset currency = uCase(trim(toString(REQUEST.emenu_currency_code)))>
    <cfif currency eq "ID" OR currency eq "RP"><cfset currency = "IDR"></cfif>
    <cfif NOT len(currency)><cfset currency = pgCountryCurrency(pgProf.country_code, "IDR")></cfif>
    <cfset vaBank = "">
    <cfif payMethod eq "va">
        <cfset vaBanks = pgSafeJsonArray(pgProf.va_banks_enabled)>
        <cfset vaAllowed = "">
        <cfset vaRaw = "">
        <cfloop from="1" to="#ArrayLen(vaBanks)#" index="i">
            <cfset vaItem = UCase(Trim(ToString(vaBanks[i])))>
            <cfif ListFindNoCase("BRI,BNI,MANDIRI,PERMATA", vaItem) AND NOT ListFindNoCase(vaAllowed, vaItem)>
                <cfset vaAllowed = ListAppend(vaAllowed, vaItem)>
            </cfif>
        </cfloop>
        <cfif Len(selectedVaBank) AND ListFindNoCase(vaAllowed, selectedVaBank)>
            <cfset vaRaw = selectedVaBank>
        <cfelseif ListLen(vaAllowed) GT 0>
            <cfset vaRaw = ListFirst(vaAllowed)>
        <cfelseif len(trim(pgProf.payout_channel_code))>
            <cfset vaRaw = UCase(Trim(ToString(pgProf.payout_channel_code)))>
        <cfelse>
            <cfset vaRaw = "BRI">
        </cfif>
        <cfif NOT ListFindNoCase("BRI,BNI,MANDIRI,PERMATA", vaRaw)>
            <cfset vaRaw = "BRI">
        </cfif>
        <cfset vaBank = pgVaBankCode(vaRaw)>
    </cfif>
    <cfset forUserId = "">
    <cfif len(trim(pgProf.xendit_account_id))>
        <cfset forUserId = trim(pgProf.xendit_account_id)>
    </cfif>

    <cfquery datasource="#dts#" result="insPay">
        INSERT INTO app_payments (order_id, payment_method, amount, status, gateway_name)
        VALUES (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#payMethod#">,
            <cfqueryparam cfsqltype="cf_sql_decimal" value="#payAmount#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="pending">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="xendit">
        )
    </cfquery>
    <cfset paymentId = 0>
    <cfif structKeyExists(insPay, "generatedKey") AND val(insPay.generatedKey)><cfset paymentId = val(insPay.generatedKey)>
    <cfelseif structKeyExists(insPay, "GENERATEDKEY") AND val(insPay.GENERATEDKEY)><cfset paymentId = val(insPay.GENERATEDKEY)>
    </cfif>
    <cfif paymentId lte 0>
        <cfquery name="qLastPay" datasource="#dts#">
            SELECT MAX(payment_id) AS pid FROM app_payments
            WHERE order_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderId#">
        </cfquery>
        <cfset paymentId = val(qLastPay.pid)>
    </cfif>
    <cfset refId = "emenu-" & orderId & "-" & paymentId>

    <cfset xPay = pgCreatePaymentRequest(
        forUserId,
        payAmount,
        currency,
        pgCurrencyToCountry(currency),
        payMethod,
        refId,
        returnUrl,
        returnUrl & "?failed=1",
        custName,
        ewChannel,
        ewalletMobile,
        vaBank
    )>
    <cfset payRespData = xPay.data>
    <cfset payRespActions = xPay.actions>

    <cfif NOT xPay.ok>
        <cfset SESSION.emenu_pay_error = left(trim(xPay.message), 250)>
        <cfquery datasource="#dts#">
            UPDATE app_payments SET status = <cfqueryparam value="failed" cfsqltype="cf_sql_varchar">,
                failure_reason = <cfqueryparam value="#left(xPay.message, 500)#" cfsqltype="cf_sql_varchar">
            WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentId#">
        </cfquery>
        <cflocation url="/PaymentGateway/payment.cfm?err=xendit_failed" addtoken="false">
    </cfif>

    <!--- Some channels return actionable fields only after a follow-up read --->
    <cfif NOT len(payRespActions.redirectUrl) AND NOT len(payRespActions.deeplink) AND NOT len(payRespActions.qrString) AND NOT len(payRespActions.vaNumber) AND len(xPay.paymentRequestId)>
        <cfset xPayCheck = pgGetPaymentRequest(forUserId, xPay.paymentRequestId)>
        <cfif xPayCheck.ok AND isStruct(xPayCheck.data)>
            <cfset payRespData = xPayCheck.data>
            <cfset payRespActions = pgParsePayActions(payRespData)>
        </cfif>
    </cfif>

    <cfquery datasource="#dts#">
        UPDATE app_payments SET
            status = <cfqueryparam cfsqltype="cf_sql_varchar" value="processing">,
            gateway_transaction_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xPay.paymentRequestId#" null="#NOT len(xPay.paymentRequestId)#">,
            gateway_response = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#serializeJSON(payRespData)#">
        WHERE payment_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentId#">
    </cfquery>

    <cfset SESSION.emenu_payment_id = paymentId>
    <cfset SESSION.emenu_pay_method = payMethod>

    <cfif len(payRespActions.redirectUrl) OR len(payRespActions.deeplink)>
        <cfset jumpUrl = len(payRespActions.redirectUrl) ? payRespActions.redirectUrl : payRespActions.deeplink>
        <cflocation url="#jumpUrl#" addtoken="false">
    </cfif>

    <cflocation url="/PaymentGateway/paymentCheckout.cfm?payment_id=#paymentId#" addtoken="false">

    <cfcatch type="any">
        <cfset SESSION.emenu_pay_error = left(trim(cfcatch.message & " " & toString(cfcatch.detail)), 250)>
        <cflocation url="/PaymentGateway/payment.cfm?err=payment_failed" addtoken="false">
    </cfcatch>
</cftry>
