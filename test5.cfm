<cfquery name="getchinese" datasource="main">
SELECT * FROM words;
</cfquery>


<cfloop query="getchinese">
	<cfquery name="updateChinese" datasource="main">
				UPDATE words3
				SET
					indo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getchinese.indo#">
				WHERE english = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getchinese.english#">;
			</cfquery>
</cfloop>
<cfoutput>
	<script type='text/javascript'>
		alert("Done!!");
	</script>
</cfoutput>
