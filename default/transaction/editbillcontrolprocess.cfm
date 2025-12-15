<cfif form.approvetype eq 'supervisor'>

<!---<cfquery name="getAdminPass" datasource="main">
SELECT userID from users Where userid="#form.supervisorid#" and userDept = "#dts#" and userPwd = "#form.passwordString#"
</cfquery>---><!---
<cfif lcase(hcomid) eq 'tcds_i'>
<cfquery name="getAdminPass" datasource="main">
SELECT * from users Where userid in ('HERRYTCDS','REBECCATCDS','ultralung') and userpwd = "#hash(form.passwordString)#"
</cfquery>
<cfelse>--->
<cfquery name="getAdminPass" datasource="#dts#">
SELECT supervisorid from supervisor Where supervisorid="#form.supervisorid#" and password = "#form.passwordString#"
</cfquery><!---
</cfif>--->
<cfif getAdminPass.recordcount neq 0>
<cfquery datasource='#dts#' name="getartran">
	select * from artran where refno='#refno#' and type = "#tran#"
</cfquery>

<cfquery datasource='#dts#' name="updateremark">
	update artran set rem11="#form.reason#" where refno='#refno#' and type = "#tran#"
</cfquery>

<cfoutput>

<cfif url.type eq "delete">
<form name="deletebill" id="deletebill" method="post" action="transaction3.cfm">
<input type="hidden" name="type" id="type" value="Delete" />
<input type="hidden" name="NDATECREATE" id="NDATECREATE" value="#dateformat(getartran.wos_date,'dd/mm/yyyy')#" />
<input type="hidden" name="INVOICEDATE" id="INVOICEDATE" value="#dateformat(getartran.wos_date,'dd/mm/yyyy')#" />
<input type="hidden" name="HMODE" id="HMODE" value="Delete" />
<input type="hidden" name="CURRRATE" id="CURRRATE" value="#getartran.currrate#" />
<input type="hidden" name="AGENNO" id="AGENNO" value="#getartran.AGENNO#" />
<input type="hidden" name="refno3" id="refno3" value="" />
<input type="hidden" name="READPERIOD" id="READPERIOD" value="#getartran.fperiod#" />
<input type="hidden" name="currefno" id="currefno" value="#refno#" />
<input type="hidden" name="NEXTTRANNO" id="NEXTTRANNO" value="#refno#" />
<input type="hidden" name="tran" id="tran" value="#tran#" />
<input type="hidden" name="custno" id="custno" value="#getartran.custno#" />
<input type="hidden" name="remark12" id="remark12" value="#getartran.rem12#" />
</form>
</cfif>

<script type="text/javascript">
<cfif url.type eq "delete">
deletebill.submit();

<cfelse>

window.opener.location.href ="/default/transaction/transaction1.cfm?tran=#tran#&ttype=#url.type#&refno=#refno#&custno=#URLEncodedFormat(getartran.custno)#&first=0";
window.close();
</cfif>
</script>

</cfoutput>
<cfelse>

<h4>Wrong Password</h4>
<cfform action="editbillcontrol.cfm?tran=#tran#&refno=#refno#&type=#url.type#" method="post" name="wrongpass" id="wrongpass">
<input type="submit" name="submit_btn" value="Retry"  />
</cfform>
</cfif>

<cfelseif form.approvetype eq 'Cashier'>

<cfquery name="getAdminPass" datasource="#dts#">
SELECT cashierid from cashier Where cashierid="#form.cashierid1#" and password = "#form.passwordString1#"
</cfquery>

<cfquery name="getAdminPass2" datasource="#dts#">
SELECT cashierid from cashier Where cashierid="#form.cashierid2#" and password = "#form.passwordString2#"
</cfquery>

<cfif getAdminPass.recordcount neq 0 and getAdminPass2.recordcount neq 0 and form.cashierid1 neq form.cashierid2>
<cfquery datasource='#dts#' name="getartran">
	select * from artran where refno='#refno#' and type = "#tran#"
</cfquery>

<cfquery datasource='#dts#' name="updateremark">
	update artran set rem11="#form.reason#" where refno='#refno#' and type = "#tran#"
</cfquery>

<cfoutput>
<cfif url.type eq "delete">
<form name="deletebill" id="deletebill" method="post" action="transaction3.cfm">
<input type="hidden" name="type" id="type" value="Delete" />
<input type="hidden" name="NDATECREATE" id="NDATECREATE" value="#dateformat(getartran.wos_date,'dd/mm/yyyy')#" />
<input type="hidden" name="INVOICEDATE" id="INVOICEDATE" value="#dateformat(getartran.wos_date,'dd/mm/yyyy')#" />
<input type="hidden" name="CURRRATE" id="CURRRATE" value="#getartran.currrate#" />
<input type="hidden" name="HMODE" id="HMODE" value="Delete" />
<input type="hidden" name="AGENNO" id="AGENNO" value="#getartran.AGENNO#" />
<input type="hidden" name="refno3" id="refno3" value="" />
<input type="hidden" name="currefno" id="currefno" value="#refno#" />
<input type="hidden" name="READPERIOD" id="READPERIOD" value="#getartran.fperiod#" />
<input type="hidden" name="NEXTTRANNO" id="NEXTTRANNO" value="#refno#" />
<input type="hidden" name="tran" id="tran" value="#tran#" />
<input type="hidden" name="custno" id="custno" value="#getartran.custno#" />
<input type="hidden" name="remark12" id="remark12" value="#getartran.rem12#" />
</form>
</cfif>

<script type="text/javascript">
<cfif url.type eq "delete">
deletebill.submit();
window.close();
window.opener.refreshpage();

<cfelse>
window.opener.location.href("/default/transaction/transaction1.cfm?tran=#tran#&ttype=#url.type#&refno=#refno#&custno=#URLEncodedFormat(getartran.custno)#&first=0");
window.close();
</cfif>
</script>

</cfoutput>
<cfelse>

<h4>Wrong Password</h4>
<cfform action="editbillcontrol.cfm?tran=#tran#&refno=#refno#&type=#url.type#" method="post" name="wrongpass" id="wrongpass">
<input type="submit" name="submit_btn" value="Retry"  />
</cfform>
</cfif>




</cfif>


