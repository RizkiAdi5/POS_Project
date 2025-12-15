<cfif IsDefined('url.languageID')>
	<cfset URLlanguage = trim(urldecode(url.languageID))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="main">
			SELECT id
            FROM words
			WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.language)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.language)# already exist!');
				window.open('/latest/generalSetup/language/language.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createLanguage" datasource="main">
					INSERT INTO words (id,english,sim_ch,indo,malay)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.language)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.english)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.sim_ch)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indo)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.malay)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.language)#!\nError Message: #cfcatch.message#');
						window.open('/latest/generalSetup/language/language.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.language)# has been created successfully!');
				window.open('/latest/generalSetup/language/index.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
		<cftry>
   			<cfquery name="updateLanguage" datasource="main">
				UPDATE words
				SET
					id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.language)#">,
					english = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.english#">,
                    sim_ch = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sim_ch#">,
                    indo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.indo#">,
                    malay = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.malay#">
				WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.language)#">;

			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.language)# !\nError Message: #cfcatch.message#');
				window.open('/latest/generalSetup/language/language.cfm?action=update&languageID=#trim(form.language)#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.language)# successfully!');
			window.open('/latest/generalSetup/language/index.cfm','_self');
		</script>
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteLanguage" datasource="main">
				DELETE FROM words
				WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLlanguage#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLlanguage#!\nError Message: #cfcatch.message#');
					window.open('/latest/generalSetup/language/index.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLlanguage# successfully!');
			window.open('/latest/generalSetup/language/index.cfm','_self');
		</script>

	<cfelse>
		<script type="text/javascript">
			window.open('/latest/generalSetup/language/index.cfm','_self');
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/generalSetup/language/index.cfm','_self');
	</script>
</cfif>
</cfoutput>