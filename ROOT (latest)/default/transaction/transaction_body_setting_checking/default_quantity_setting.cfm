document.form1.qty.focus();

<cfif type1 eq "Add">
	<cfif lcase(HcomID) eq "pnp_i">
		<cfquery name="check_default_quantity_setting" datasource="#dts#">
			select 
			default_qty
			from others_transaction_setting;
		</cfquery>
	<cfelse>
		<cfquery name="check_default_quantity_setting" datasource="#dts#">
			select 
			default_qty
			from gsetup;
		</cfquery>
	</cfif>
		
	<cfoutput>
	document.form1.qty.value=#val(check_default_quantity_setting.default_qty)#;
	</cfoutput>
</cfif>

