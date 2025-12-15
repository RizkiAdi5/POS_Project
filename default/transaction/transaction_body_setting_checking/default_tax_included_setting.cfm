<cfquery name="check_default_quantity_setting" datasource="#dts#">
	select 
	default_tax_included 
	from others_transaction_setting;
</cfquery>

<cfif check_default_quantity_setting.default_tax_included eq "Y">
	<cfset form.taxincl = "T">
<cfelse>
	<cfset form.taxincl = "">
</cfif>