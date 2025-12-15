<cfsetting showdebugoutput="no">
<cfquery name="getpass" datasource="#dts#">
select password from cashier where cashierid='#url.cashierid#'
</cfquery>
 <cfoutput>
 <input type="hidden" name="hidcashierpassword" id="hidcashierpassword" value="#getpass.password#">
 </cfoutput>