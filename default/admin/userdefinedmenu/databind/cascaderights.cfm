<cfsilent>
	<cfsetting showdebugoutput="false">
	<cfheader name="Content-Type" value="text/plain; charset=utf-8">
	<cfset ok = 0>
	<cfset nUp = 0>
	<cfset err = "">
	<cfparam name="form.groupid" default="">
	<cfparam name="form.menu_id" default="">
	<cfparam name="form.value" default="">

	<cftry>
		<cfset gid = trim(form.groupid)>
		<cfset mid = trim(toString(form.menu_id))>
		<cfset val = uCase(left(trim(form.value), 1))>
		<cfif val neq "T" AND val neq "F">
			<cfset err = "Invalid value.">
			<cfthrow type="app" message="bad">
		</cfif>

		<cfif isDefined("husergrpid") AND husergrpid neq "super" AND gid eq "Admin">
			<cfset err = "Cannot change Administrator group.">
			<cfthrow type="app" message="forbidden">
		</cfif>

		<cfif NOT len(gid) OR NOT len(mid)>
			<cfset err = "Missing group or menu.">
			<cfthrow type="app" message="bad">
		</cfif>

		<cfquery name="chkGroup" datasource="#dts#">
			SELECT level FROM userpin2
			WHERE level = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gid#">
		</cfquery>
		<cfif chkGroup.recordcount EQ 0>
			<cfset err = "Unknown group.">
			<cfthrow type="app" message="bad">
		</cfif>

		<cfquery name="qAll" datasource="#dts#">
			SELECT menu_id, menu_parent_id, userpin_id
			FROM main.menunew2
			WHERE menu_id > 9999
		</cfquery>

		<cfset kidsByParent = StructNew()>
		<cfset pinById = StructNew()>
		<cfloop query="qAll">
			<cfset cid = trim(toString(qAll.menu_id))>
			<cfset pid = trim(toString(qAll.menu_parent_id))>
			<cfif NOT structKeyExists(kidsByParent, pid)>
				<cfset kidsByParent[pid] = "">
			</cfif>
			<cfset kidsByParent[pid] = listAppend(kidsByParent[pid], cid)>
			<cfset pinById[cid] = trim(toString(qAll.userpin_id))>
		</cfloop>

		<cfset stack = arrayNew(1)>
		<cfset arrayAppend(stack, mid)>
		<cfset subtreeIds = arrayNew(1)>
		<cfloop condition="arrayLen(stack) GT 0">
			<cfset cur = stack[1]>
			<cfset arrayDeleteAt(stack, 1)>
			<cfset arrayAppend(subtreeIds, cur)>
			<cfif structKeyExists(kidsByParent, cur)>
				<cfloop list="#kidsByParent[cur]#" index="ch">
					<cfif len(trim(ch))>
						<cfset arrayAppend(stack, trim(ch))>
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>

		<cfquery name="getRowRights" datasource="#dts#">
			SELECT * FROM userpin2
			WHERE level = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gid#">
		</cfquery>
		<cfif getRowRights.recordcount EQ 0>
			<cfset err = "No rights row.">
			<cfthrow type="app" message="bad">
		</cfif>
		<cfset colList = getRowRights.columnList>

		<cfset pinColsDone = StructNew()>

		<cftransaction>
			<cfset nSub = arrayLen(subtreeIds)>
			<cfloop from="1" to="#nSub#" index="ix">
				<cfset oneId = trim(toString(subtreeIds[ix]))>
				<cfif NOT structKeyExists(pinById, oneId)>
					<cfcontinue>
				</cfif>
				<cfset rawPin = pinById[oneId]>
				<cfif NOT len(rawPin)>
					<cfcontinue>
				</cfif>
				<cfset pinCol = "H" & reReplace(lCase(rawPin), "^h", "", "one")>
				<cfset actualCol = "">
				<cfloop list="#colList#" index="cni">
					<cfif compareNoCase(cni, pinCol) EQ 0 OR compareNoCase(cni, rawPin) EQ 0>
						<cfset actualCol = cni>
						<cfbreak>
					</cfif>
				</cfloop>
				<cfif NOT len(actualCol)>
					<cfcontinue>
				</cfif>
				<cfif structKeyExists(pinColsDone, actualCol)>
					<cfcontinue>
				</cfif>
				<cfset pinColsDone[actualCol] = true>
				<cfquery datasource="#dts#">
					UPDATE userpin2 SET `#actualCol#` = <cfqueryparam cfsqltype="cf_sql_char" value="#val#" maxlength="1">
					WHERE level = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gid#">
				</cfquery>
				<cfset nUp = nUp + 1>
			</cfloop>
		</cftransaction>

		<cfset ok = 1>
		<cfcatch>
			<cfif NOT len(err)>
				<cfset err = "Cascade failed.">
			</cfif>
		</cfcatch>
	</cftry>
</cfsilent><cfoutput>#ok#|#nUp#|#err#</cfoutput>
