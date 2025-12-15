 <link rel="stylesheet" type="text/css" href="../newpos/table.css" />

<cfset uuid=urldecode(uuid)>
<cfquery name="getamt" datasource="#dts#">
SELECT amt_bil FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">
</cfquery>
<cfset btname = #btnname# />
<cfoutput>

<center>
<table class="table-style-three">
<thead>
	<tr>
		<th colspan="2" style="text-align:center;"><h3>Change Amount</h3></th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><strong><div style="vertical-align:bottom">Amount:</div></td>
		<td>
       <input type="hidden" id="changehighlight" name="changehighlight" value="1" />
<input style="font: large bolder;" type="text" name="amt_bil1" id="amt_bil1" value="#numberformat(val(getamt.amt_bil),'.__')#" onmouseout="doSomethingWithSelectedText();" />
        </td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="button" name="sub_btn" id="sub_btn" value="Update" onclick="updateamt('#uuid#','#trancode#',document.getElementById('amt_bil1').value);" /></td>
	</tr>
    <tr>
		<td colspan="3">
<cfinclude template="/newpos/button.cfm"> 
</td>
	</tr>
	</tbody>
</table>
</center>

</cfoutput>
