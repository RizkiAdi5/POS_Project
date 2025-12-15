<cfif IsDefined('url.location') and IsDefined('url.itemno') >
	<cfset URLlocation = trim(urldecode(url.location))>
    <cfset URLitemno = trim(urldecode(url.itemno))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "update">
		<cftry>
			<cfquery name="updateCategory" datasource="#dts#">
				UPDATE locqdbf
				SET
					locqfield = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.qtyBF#">,
					lminimum = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.minimum#">,
                    lreorder = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reorder#">

				WHERE location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.location)#">
                AND itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.itemNo)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.itemNo)# at #trim(form.location)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/openingQuantity.cfm?action=update&location=#form.location#&itemNo=#form.itemNo#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.itemNo)# at #trim(form.location)# successfully!');
			window.open('/latest/maintenance/openingQuantityProfile.cfm','_self');
		</script>
	</cfif>	
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/openingQuantityProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>