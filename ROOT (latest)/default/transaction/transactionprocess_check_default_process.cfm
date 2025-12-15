<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>
<form name="done" action="../transaction/transaction3.cfm?complete=complete" method="post">
	<cfoutput>				
	<input type="hidden" name="tran" value="#listfirst(tran)#">
	<input type="hidden" name="currrate" value="#listfirst(currrate)#">
	<input type="hidden" name="agenno" value="#listfirst(agenno)#">
	<input type="hidden" name="refno3" value="#listfirst(refno3)#">
	<input type="hidden" name="status" value="#listfirst(status)#">
	<input type="hidden" name="type" value="#listfirst(mode)#">
	<input type="hidden" name="hmode" value="#listfirst(hmode)#">				
	<input type="hidden" name="nexttranno" value="#listfirst(nexttranno)#">
	<input type="hidden" name="custno" value="#listfirst(form.custno)#">
	<input type="hidden" name="readperiod" value="#listfirst(form.readperiod)#">
	<input type="hidden" name="nDateCreate" value="#listfirst(nDateCreate)#">				
	<input type="hidden" name="invoicedate" value="#listfirst(form.invoicedate)#">
	<cfif checkcustom.customcompany eq "Y">
		<input type="hidden" name="remark5" value="#listfirst(form.hremark5)#">	<!--- PERMIT NUMBER, ADD ON 24-03-2009 --->
		<input type="hidden" name="remark6" value="#listfirst(form.hremark6)#">
	</cfif>
    <cfif isdefined("form.updunitcost")>
		<input type='hidden' name='updunitcost' value='#form.updunitcost#'>
	</cfif>
	</cfoutput>
</form>

<script>
	done.submit();
</script>

<cfabort>