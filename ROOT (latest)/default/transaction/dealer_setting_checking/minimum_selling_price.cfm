<cfif form.mode neq "Delete">
	<cfquery name="get_dealer_menu_info" datasource="#dts#">
		select 
		(
			select 
			minimum_selling_price 
			from dealer_menu
		) as minimum_selling_price,
		(
			select
			price 
			from icitem 
			where itemno='#jsstringformat(preservesinglequotes(itemno))#'
		) as price;
	</cfquery>
	
	<cfset item_price = val(get_dealer_menu_info.price)>

	<cfif get_dealer_menu_info.minimum_selling_price eq "Y" and item_price neq 0 and price lt item_price>
		<script language="javascript" type="text/javascript">
			<cfoutput>
			alert("Minimum Unit Price Must Be Above #numberformat(item_price,'0.00')# !");
			</cfoutput>
			history.back();
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>