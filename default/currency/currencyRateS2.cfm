<cfparam name="status" default="">

<cfquery datasource='#dts#' name="checkCurrExist">
	select * 
	from #target_currency# 
	where currcode='#form.currcode#'
</cfquery>

<cfif checkCurrExist.recordcount eq 0>
	<!--- DO NOT allow delete of currency as it will affect crucial transactions involved later.--->
	<cfif form.mode eq "Create">
		<cfinvoke component="cfc.create_update_delete_currency" method="amend_currency">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="hlinkams" value="#hlinkams#">
			<cfinvokeargument name="mode" value="#mode#">
			<cfinvokeargument name="form" value="#form#">
		</cfinvoke>
		<cfset status="The currency rates for #form.currcode# had been successfully saved. ">
	</cfif>
<cfelseif checkCurrExist.recordcount EQ 1>
	<cfif form.mode eq "Edit">
		<cfinvoke component="cfc.create_update_delete_currency" method="amend_currency">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="hlinkams" value="#hlinkams#">
			<cfinvokeargument name="mode" value="#mode#">
			<cfinvokeargument name="form" value="#form#">
		</cfinvoke>
		<cfset status="The currency rates for #form.currcode# had been successfully saved. ">
	</cfif>
<cfelse>		
	<cfset status="Sorry, the currency, #form.currcode# was ALREADY removed from the system. Process unsuccessful.">
</cfif>

<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->
<form name="done" action="vcurrency.cfm?" method="post">
	<input name="status" value="<cfoutput>#status#</cfoutput>" type="hidden">
</form>

<script>
	done.submit();
</script>