<html>
<head>
</head>
<cfquery name="MyQuery" datasource="#dts#">
	select itemno,desp,despa,price,unit,sizeid,despa,category,barcode,aitemno,1 as qty,remark20 from icitem
	<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		where itemno between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemfrom#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemto#">
	</cfif>
	
	order by itemno
</cfquery>

<cfset itemnolist= valuelist(MyQuery.itemno)>

<body>
<cfoutput>
<form name="gamemartzbarcode" action="printbarcode.cfm" method="post">
<table width="100%">
<tr>
<td colspan="100%"><hr /></td>
</tr>
<tr>
<th>Item No</th>
<th>Item Description</th>
<th>Qty</th>
</tr>
<tr>
<td colspan="100%"><hr /></td>
</tr>
<cfloop query="MyQuery">
<tr>
<td>#itemno#</td>
<td>#desp#</td>
<td align="center"><input type="text" name="a#MyQuery.currentrow#" id="a#MyQuery.currentrow#" value="0" size="4" /></td>
</tr>
</cfloop>
<tr>
<td colspan="100%"><hr /></td>
</tr>
<tr>
<td colspan="100%" align="center"><input type="submit" name="submit" id="submit" value="Submit" /></td>
</tr>
<input type="hidden" name="rcno" id="rcno" value="#form.rcno#">
<input type="hidden" name="itemfrom" id="itemfrom" value="#form.itemfrom#">
<input type="hidden" name="itemto" id="itemto" value="#form.itemto#">
<input type="hidden" name="noofcopy" id="noofcopy" size="10" value="#form.noofcopy#">
<div style="visibility:hidden">
<input type="checkbox" name="hdwide" id="hdwide" value="1" <cfif isdefined('form.hdwide')>checked</cfif>>
<input type="checkbox" name="barcode" id="barcode" value="1" <cfif isdefined('form.barcode')>checked</cfif>>
<input type="checkbox" name="format2" id="format2" value="1" <cfif isdefined('form.format2')>checked</cfif>>
<input type="checkbox" name="format3" id="format3" value="1" <cfif isdefined('form.format3')>checked</cfif>>
<input type="checkbox" name="format4" id="format4" value="1" <cfif isdefined('form.format4')>checked</cfif>>
<input type="checkbox" name="format5" id="format5" value="1" <cfif isdefined('form.format5')>checked</cfif>>
<input type="checkbox" name="format6" id="format6" value="1" <cfif isdefined('form.format6')>checked</cfif>>
</div>
<input type="hidden" name="spacing" id="spacing" value="#form.spacing#" >
<input type="hidden" name="topspacing" id="topspacing" value="#form.topspacing#" >
<input type="hidden" name="leftspacing" id="leftspacing" value="#form.leftspacing#" >
<input type="hidden" name="fontsize" id="fontsize" value="#form.fontsize#" >
<input type="hidden" name="barcodewidth" id="barcodewidth" value="#form.barcodewidth#" >
<input type="hidden" name="allitemlist" id="allitemlist" value="#itemnolist#" />
</table>

</form>
</cfoutput>
</body>
</html>