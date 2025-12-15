<cfif form.mode neq "Delete">
	<cfquery name="get_dealer_menu_info" datasource="#dts#">
		select 
		(
			select 
			selling_below_cost 
			from dealer_menu
		) as selling_below_cost,
		(
			select
			ucost 
			from icitem 
			where itemno='#jsstringformat(preservesinglequotes(itemno))#'
		) as ucost;
	</cfquery>
	
	<cfset item_cost = val(get_dealer_menu_info.ucost)>

	<cfif get_dealer_menu_info.selling_below_cost eq "Y" and item_cost neq 0 and price lt item_cost>
		<script language="javascript" type="text/javascript">
			<cfoutput>
			alert("Unit Price Must Be Above #numberformat(item_cost,'0.00')# !");
			</cfoutput>
			history.back();
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>