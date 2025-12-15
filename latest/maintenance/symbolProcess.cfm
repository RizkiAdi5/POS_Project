<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "update">
		<cftry>
			<cfquery name="updateCategory" datasource="#dts#">
				UPDATE symbol
				SET
					<cfloop index="i" from="1" to="20">
                    	<cfset symbolValue = evaluate('symbol#i#')> 
                   		symbol#i#=<cfqueryparam cfsqltype="cf_sql_varchar" value="#tobase64(symbolValue)#"> <cfif i NEQ 20>,</cfif>
                    </cfloop>
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update Symbol!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/symbol.cfm?action=update','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated Symbol successfully!');
			window.open('/latest/body/bodymenu.cfm?id=142','_self');
		</script>
	</cfif> 
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/symbol.cfm','_self');
	</script>
</cfif>
</cfoutput>