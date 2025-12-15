<cfquery name="checkictrantotalitem" datasource="#dts#">
select count(trancode) as totalcount from ictran where type='#form.tran#' and refno='#form.refno#'
</cfquery>

<cfloop from="1" to="#val(checkictrantotalitem.totalcount)#" index="i">

<cfset itemno = evaluate("form.itemno#i#")>
<cfset qty = evaluate("form.actualqty#i#")>
<cfset trancode = evaluate("form.trancode#i#")>

<cfquery name="insertictran" datasource="#dts#">
	update ictran set qty='#qty#',qty_bil='#qty#' where itemno='#itemno#' and trancode='#trancode#' and type='#form.tran#' and refno='#form.refno#'
</cfquery>

</cfloop>

<cfquery name="getdecimal" datasource="#dts#">
SELECT Decl_Uprice,Decl_Discount FROM gsetup2
</cfquery>

<cfquery name="recalculateictran" datasource="#dts#">
Update ictran set amt_bil = round(round(price_bil * qty_bil,#getdecimal.Decl_Uprice#)-disamt_bil,2) where type='#form.tran#' and refno='#form.refno#'
</cfquery>

<cfquery name="updateamt" datasource="#dts#">
UPDATE ictran SET amt = amt_bil * currrate,void='' where type='#form.tran#' and refno='#form.refno#'
</cfquery>

<cfif form.tran eq 'DO' or (form.rem49 neq '' and form.rem49 neq 'checked')>
<cfquery name="updateartran" datasource="#dts#">
update artran set rem48='checked',void='' where type='#form.tran#' and refno='#form.refno#'
</cfquery>
<cfelse>
<cfquery name="updateartran" datasource="#dts#">
update artran set rem49='checked',void='' where type='#form.tran#' and refno='#form.refno#'
</cfquery>
</cfif>

<script type="text/javascript">
    alert('Checking Completed');
	location.href="transaction.cfm?tran=RC"
</script>