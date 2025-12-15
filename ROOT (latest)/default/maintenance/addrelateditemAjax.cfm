<cfquery name="checkexist" datasource="#dts#">
	select * from relitem
	where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#url.itemno#">
	and relitemno=<cfqueryparam cfsqltype="cf_sql_char" value="#url.relitemno#">
</cfquery>
<cfif checkexist.recordcount eq 0>
	<cfif url.action eq "addRelitem">
		<cfquery name="insert" datasource="#dts#">
			insert into relitem
			(itemno,relitemno,created_by)
			values
			(<cfqueryparam cfsqltype="cf_sql_char" value="#url.itemno#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#url.relitemno#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">)
		</cfquery>
	</cfif>
</cfif>
<cfif url.action eq "deleteRelitem">
	<cfquery name="delete" datasource="#dts#">
		delete from relitem
		where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#url.itemno#">
		and relitemno=<cfqueryparam cfsqltype="cf_sql_char" value="#url.relitemno#">
	</cfquery>
</cfif>
<cfquery name="getRelItem2" datasource="#dts#">
	select a.itemno, a.relitemno,b.desp,b.despa from relitem a,icitem b
	where a.relitemno=b.itemno 
	and a.itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#url.itemno#"> 
</cfquery>
<table width="700" align="center" class="data">
	<tr>
		<th width="150">Related Item No.</th>
		<th width="250">Description</th>
		<th width="250">2nd Description</th>
		<th width="50">Action</th>
	</tr>
	<cfoutput query="getRelItem2">
		<tr>
			<td>#getRelItem2.relitemno#</td>
			<td>#getRelItem2.desp#</td>
			<td>#getRelItem2.despa#</td>
			<td><img src="/images/userdefinedmenu/idelete.gif" alt="Remove" onClick="removeRelitem('#URLEncodedFormat(getRelItem2.itemno)#','#URLEncodedFormat(getRelItem2.relitemno)#');" style="cursor: hand;"></td>
		</tr>
	</cfoutput>
</table>