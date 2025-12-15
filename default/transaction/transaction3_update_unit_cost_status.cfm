<cfif not isdefined("form.status")>
	<cfif isdefined("form.updunitcost")>
		<cfquery name = "update_unit_cost_status" datasource = "#dts#">
			update gsetup2 set 
			update_unit_cost='#form.updunitcost#';
		</cfquery>
	<cfelse>
		<cfquery name = "update_unit_cost_status" datasource = "#dts#">
			update gsetup2 set 
			update_unit_cost='F';
		</cfquery>
	</cfif>
</cfif>