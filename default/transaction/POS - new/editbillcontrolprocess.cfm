<cfif form.approvetype eq 'supervisor'>
<!---
<cfquery name="getAdminPass" datasource="main">
SELECT userID from users Where userid="#form.supervisorid#" and userDept = "#dts#" and userPwd = "#hash(form.passwordString)#"
</cfquery>
--->
<cfif lcase(hcomid) eq 'tcds_i'>
<cfquery name="getAdminPass" datasource="main">
SELECT * from users Where userid in ('HERRYTCDS','REBECCATCDS') and userpwd = "#hash(form.passwordString)#"
</cfquery>
<cfelse>
<cfquery name="getAdminPass" datasource="#dts#">
SELECT supervisorid from supervisor Where supervisorid="#form.supervisorid#" and password = "#form.passwordString#"
</cfquery>
</cfif>
<cfif getAdminPass.recordcount neq 0>
<cfquery datasource='#dts#' name="getartran">
	select * from artran where refno='#refno#' and type = "#tran#"
</cfquery>

<cfquery datasource='#dts#' name="updateremark">
	update artran set rem11="#form.reason#" where refno='#refno#' and type = "#tran#"
</cfquery>

<cfoutput>
<script type="text/javascript">

window.open("/default/transaction/transaction1.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(getartran.custno)#&first=0");
window.close();

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
<script type="text/javascript">

window.open("/default/transaction/transaction1.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(getartran.custno)#&first=0");
window.close();

</script>
</cfoutput>
<cfelse>

<h4>Wrong Password</h4>
<cfform action="editbillcontrol.cfm?tran=#tran#&refno=#refno#&type=#url.type#" method="post" name="wrongpass" id="wrongpass">
<input type="submit" name="submit_btn" value="Retry"  />
</cfform>
</cfif>




</cfif>


