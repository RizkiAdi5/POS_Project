<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Tax Maintenance</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../../stylesheet/stylesheet.css">
	
<script type='text/javascript' src='/ajax/core/engine.js'></script>
<script type='text/javascript' src='/ajax/core/util.js'></script>
<script type='text/javascript' src='/ajax/core/settings.js'></script>
<script type='text/javascript' src='/scripts/ajax.js'></script>
	
</head>

<SCRIPT LANGUAGE="JavaScript">
function confirmDelete(taxcode)
{
    var agree=confirm("Are you sure you wish to delete this entry?");
    if(agree){
    	DWREngine._execute(_tranflocation, null, 'deleteTax', taxcode, showInfo);
    }
} 

function showInfo(taxObject){
	if(taxObject.MESSAGE !=''){
		alert(taxObject.MESSAGE);
	}
	else{
		var ajaxurl = 'getTaxAjax.cfm';
		ajaxFunction(document.getElementById('ajaxField'),ajaxurl);
	}
}
</script>

<!--- <cfif isdefined("url.taxcode")>
	<cfif hlinkams eq "Y">
		<cfquery name="deletetax" datasource="#replace(dts,'_i','_a','all')#">
			DELETE FROM taxtable
			WHERE code = '#url.taxcode#'
		</cfquery>
	<cfelse>
		<cfquery name="deletetax" datasource="#dts#">
			DELETE FROM taxtable
			WHERE code = '#url.taxcode#'
		</cfquery>
	</cfif>
</cfif> --->

<!--- bk: 21/10/2010 start --->
<cfif isdefined("form.submit")>
	<cfif isdefined("form.gsttax")>
    
    <cfif hlinkams eq "Y">
	<cfloop index="codeid" list="#form.gsttax#">
		<cfquery name="checkTaxCode" datasource="#replace(dts,'_i','_a','all')#">
			select code from taxtable where code='#codeid#'
		</cfquery>
		<cfif checkTaxCode.recordcount eq 0>
			<cfquery name="insertTaxCode" datasource="#replace(dts,'_i','_a','all')#">
				insert into taxtable(
				code,
				desp,
				rate1,
				corr_accno,
				tax_type,
				tax_type2
				)values(
				'#codeid#',
				'#form["desp"&codeid]#',
				'#form["rate"&codeid]#',
				'#form["corr_accno"&codeid]#',
				'#form["type"&codeid]#',
				'#form["type2"&codeid]#'
				)
			</cfquery>
		</cfif>
	</cfloop>
    
    <cfelse>
    
    <cfloop index="codeid" list="#form.gsttax#">
		<cfquery name="checkTaxCode" datasource="#dts#">
			select code from taxtable where code='#codeid#'
		</cfquery>
		<cfif checkTaxCode.recordcount eq 0>
			<cfquery name="insertTaxCode" datasource="#dts#">
				insert into taxtable(
				code,
				desp,
				rate1,
				corr_accno,
				tax_type,
				tax_type2
				)values(
				'#codeid#',
				'#form["desp"&codeid]#',
				'#form["rate"&codeid]#',
				'#form["corr_accno"&codeid]#',
				'#form["type"&codeid]#',
				'#form["type2"&codeid]#'
				)
			</cfquery>
		</cfif>
	</cfloop>
    </cfif>
    
	</cfif>
</cfif>
<!--- bk: 21/10/2010 end --->

<cfquery name="gettax" datasource="#dts#">
	SELECT entryno,code,desp,rate1,tax_type,corr_accno 
	FROM #target_taxtable#
	ORDER BY entryNO
</cfquery>
<cfset code = gettax.code>
<cfset desp = gettax.desp>
<cfset rate1 = gettax.rate1>
<cfset tax_type = gettax.tax_type>
<cfset corr_accno = gettax.corr_accno>

<body>
<h1 align="center">TAX MAINTENANCE</h1>
<div id="ajaxField" name="ajaxField">
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
</div>
<table width="70%" align="center">
	<tr><td>&nbsp;</td></tr>
	<form name="newtax" action="taxnew.cfm" method="post" target="W_tax">
		<tr>
			<td colspan="5" align="center"><input type="submit" name="New" value="New Tax">
            <input type="button" name="AutoGenerate" value="Generate Tax Code"
					onclick="document.newtax.action='taxauto.cfm';document.newtax.target='_self'; submit();"></td>
		</tr>
	</form>
</table>
</body>
</html>
