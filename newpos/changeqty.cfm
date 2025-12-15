<link rel="stylesheet" type="text/css" href="table.css" />

<cfset uuid=urldecode(uuid)>
<cfquery name="changeqtyquery" datasource="#dts#">
SELECT qty_bil FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">
</cfquery>

<cfset btname = #btnname# />
<cfoutput>

<center>
<table class="table-style-three">
<thead>
	<tr>
		<th colspan="2" style="text-align:center;"><h3>Change Qty</h3></th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><strong><div style="vertical-align:bottom">Qty:</div></td>
		<td>
      <input type="hidden" id="changehighlight" name="changehighlight" value="1" />
<input type="text" style="font: large bolder;" name="qty_bil1" id="qty_bil1" value="#qty_bil#" onkeyup="updateqty2(event,'#uuid#','#trancode#',document.getElementById('qty_bil1').value);" onmouseout="doSomethingWithSelectedText();"/>
        </td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="button" name="sub_btn" id="sub_btn" value="Update" onclick="updateqty('#uuid#','#trancode#',document.getElementById('qty_bil1').value);" /></td>
	</tr>
    <tr>
		<td colspan="3">
<cfinclude template="button.cfm"> 
</td>
	</tr>
	</tbody>
</table>
</center>

</cfoutput>
