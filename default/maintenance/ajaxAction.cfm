<cfsetting showdebugoutput="no">
<cfif url.dfunction eq "checkSimilarCustomer">
	<cfif trim(url.name) neq "">
		<cfquery name="getCust" datasource="#dts#">
		    select custno,name from #target_arcust# where (name like "%#url.name#%" or name2 like "%#url.name#%")
		</cfquery>
		
		<cfoutput>
			<cfif getCust.recordcount neq 0>
				Similar Customer Name(s)
			</cfif>
			<cfloop query="getCust">
				<br />#getCust.custno# - #getCust.name#
			</cfloop>
			<cfif getCust.recordcount eq 0>
				<font color="##FF0000">No Similar Customer Name Found.</font>
			</cfif>
		</cfoutput>
	</cfif>
<cfelseif url.dfunction eq "checkSimilarSupplier">
	<cfif trim(url.name) neq "">
		<cfquery name="getSupp" datasource="#dts#">
		    select custno,name from #target_apvend# where (name like "%#url.name#%" or name2 like "%#url.name#%")
		</cfquery>
		
		<cfoutput>
			<cfif getSupp.recordcount neq 0>
				Similar Supplier Name(s)
			</cfif>
			<cfloop query="getSupp">
				<br />#getSupp.custno# - #getSupp.name#
			</cfloop>
			<cfif getSupp.recordcount eq 0>
				<font color="##FF0000">No Similar Supplier Name Found.</font>
			</cfif>
		</cfoutput>
	</cfif>
</cfif>