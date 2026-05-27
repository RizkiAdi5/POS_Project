<!---
    Company base currency for customer e-menu (same source as companyProfile.cfm: gsetup.bCurr + currency table).
    Sets REQUEST.emenu_currency_* for templates and SESSION for AJAX/AI proxy.
--->
<cfif NOT isDefined("REQUEST.emenu_currency_code")>
    <cfset REQUEST.emenu_currency_code = "MYR">
    <cfset REQUEST.emenu_currency_symbol = "RM">
    <cfset REQUEST.emenu_currency_name = "">
    <cfset REQUEST.emenu_currency_decimals = 2>
    <cftry>
        <cfquery name="qEmenuCurrency" datasource="#dts#">
            SELECT TRIM(g.bCurr) AS currcode,
                   TRIM(c.currency) AS curr_symbol,
                   TRIM(c.Currency1) AS curr_name
            FROM gsetup g
            LEFT JOIN currency c ON TRIM(c.currcode) = TRIM(g.bCurr)
            LIMIT 1
        </cfquery>
        <cfif qEmenuCurrency.recordCount AND len(trim(qEmenuCurrency.currcode))>
            <cfset _curCode = uCase(trim(qEmenuCurrency.currcode))>
            <cfif _curCode eq "ID" OR _curCode eq "RP"><cfset _curCode = "IDR"></cfif>
            <cfset REQUEST.emenu_currency_code = _curCode>
            <cfset REQUEST.emenu_currency_symbol = len(trim(qEmenuCurrency.curr_symbol)) ? trim(qEmenuCurrency.curr_symbol) : REQUEST.emenu_currency_code>
            <cfset REQUEST.emenu_currency_name = trim(qEmenuCurrency.curr_name)>
            <cfif listFindNoCase("IDR,VND,JPY,KRW", REQUEST.emenu_currency_code)>
                <cfset REQUEST.emenu_currency_decimals = 0>
            <cfelse>
                <cfset REQUEST.emenu_currency_decimals = 2>
            </cfif>
        </cfif>
        <cfcatch type="any"></cfcatch>
    </cftry>
    <cfset SESSION.emenu_currency_code = REQUEST.emenu_currency_code>
    <cfset SESSION.emenu_currency_symbol = REQUEST.emenu_currency_symbol>
    <cfset SESSION.emenu_currency_decimals = REQUEST.emenu_currency_decimals>
</cfif>
