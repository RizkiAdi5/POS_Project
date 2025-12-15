<cfcomponent>
	<cffunction name="calculate_fixed_cost">
		<cfargument name="dts" required="yes">
		<cfargument name="itemfrom" required="yes">
		<cfargument name="itemto" required="yes">
				
		<!--- Update_Fixed_Cost --->
		<cfquery name="update_fixed_cost" datasource="#arguments.dts#">
			update ictran,
			(select itemno,ucost from icitem 
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
			where itemno between '#arguments.itemfrom#' and '#arguments.itemto#'
			</cfif>) as cost 
			set ictran.it_cos=(ictran.qty*cost.ucost) 
			where ictran.itemno=cost.itemno and (ictran.toinv='' or ictran.toinv is null) and (ictran.void = '' or ictran.void is null) and (ictran.type='DO' or ictran.type='ISS' or ictran.type='INV' or ictran.type='CS' or ictran.type='DN' or ictran.type='CN')
			;
		</cfquery>
		
		<cfreturn 0>
	</cffunction>
</cfcomponent>	