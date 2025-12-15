<cfquery name = "check_update_unit_cost" datasource = "#dts#">
	select 
	update_unit_cost 
	from gsetup2;
</cfquery>

<cfoutput>
	<cfif isdefined("form.type") and form.type eq "Create">
		<input type="checkbox" name="updunitcost" value="T" #iif(check_update_unit_cost.update_unit_cost eq "T",DE("checked"),DE(""))#> Update Unit Cost 
	<cfelse>
		<input type="hidden" name="updunitcost" value="#check_update_unit_cost.update_unit_cost#">
	</cfif>
</cfoutput>