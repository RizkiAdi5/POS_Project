<cfsilent>
	<cfsetting showdebugoutput="false">
	<cfheader name="Content-Type" value="text/plain; charset=utf-8">
	<cfset ok = 0>
	<cfset err = "">
	<cfparam name="form.groupid" default="">
	<cfparam name="form.pincode" default="">
	<cfparam name="form.value" default="">

	<cftry>
		<cfset gid = trim(form.groupid)>
		<cfset pcode = trim(form.pincode)>
		<cfset val = uCase(left(trim(form.value), 1))>
		<cfif val neq "T" AND val neq "F">
			<cfset err = "Invalid value.">
			<cfthrow type="app" message="bad">
		</cfif>
		<cfif isDefined("husergrpid") AND husergrpid neq "super" AND gid eq "Admin">
			<cfset err = "Cannot change Administrator group.">
			<cfthrow type="app" message="forbidden">
		</cfif>
		<cfif NOT len(gid) OR NOT len(pcode)>
			<cfset err = "Missing data.">
			<cfthrow type="app" message="bad">
		</cfif>
		<cfif reFindNoCase("^H[A-Za-z0-9]+$", pcode) EQ 0>
			<cfset err = "Invalid permission key.">
			<cfthrow type="app" message="bad">
		</cfif>

		<cfquery name="getRowRights" datasource="#dts#">
			SELECT * FROM userpin2
			WHERE level = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gid#">
		</cfquery>
		<cfif getRowRights.recordcount EQ 0>
			<cfset err = "No rights row.">
			<cfthrow type="app" message="bad">
		</cfif>
		<cfset actualCol = "">
		<cfloop list="#getRowRights.columnList#" index="cni">
			<cfif compareNoCase(cni, pcode) EQ 0>
				<cfset actualCol = cni>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfif NOT len(actualCol) OR compareNoCase(actualCol, "level") EQ 0>
			<cfset err = "Unknown permission column.">
			<cfthrow type="app" message="bad">
		</cfif>

		<cfquery datasource="#dts#">
			UPDATE userpin2 SET `#actualCol#` = <cfqueryparam cfsqltype="cf_sql_char" value="#val#" maxlength="1">
			WHERE level = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gid#">
		</cfquery>
		<cfset ok = 1>
		<cfcatch>
			<cfif NOT len(err)>
				<cfset err = "Update failed.">
			</cfif>
		</cfcatch>
	</cftry>
</cfsilent><cfoutput>#ok#|#err#</cfoutput>
