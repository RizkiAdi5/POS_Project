<cfsetting showdebugoutput="no">

<cfquery name="gettax" datasource="#dts#">
	SELECT entryno,code,desp,rate1,tax_type,corr_accno 
	FROM #target_taxtable#
	ORDER BY entryNO
</cfquery>

<table width="80%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
	<tr>
		<th "30%">Action</th>
		<th width="10%">Tax Code</th>
		<th>Description</th>
		<th width="10%">Rate</th>
		<th width="10%">Tax Type</th>
		<th width="10%">Corr Accno</th>
	</tr>
	<cfoutput query="gettax">
		<tr>
		<td><a href="taxedit.cfm?taxentry=#gettax.entryno#" target="W_tax"><img height="18px" width="18px" src="../../../images/PNG-48/Modify.png" alt="Edit" border="0">Edit</a>
			<a onclick="confirmDelete('#code#');"><img height="18px" width="18px" src="../../../images/PNG-48/Delete.png" alt="Delete" border="0">Delete</a></td>
			<td>#code#</td>
			<td>#desp#</td>
			<td>#rate1#</td>
			<td>#tax_type#</td>
			<td>#corr_accno#</td>
		</tr>
	</cfoutput>
</table>