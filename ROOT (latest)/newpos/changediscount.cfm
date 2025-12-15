<!---<cfquery name="changediscountquery" datasource="#dts#">
SELECT brem4 FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
and trancode = <
cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">
</cfquery>--->

 <link rel="stylesheet" type="text/css" href="table.css" />

<cfset uuid=urldecode(uuid)>

<cfquery name="changediscountquery" datasource="#dts#">
SELECT qty_bil,price_bil,amt_bil,disamt_bil,dispec1,dispec2,dispec3 FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">
</cfquery>
<cfset btname = #btnname# />
<cfoutput>
<table>
<center>
<table class="table-style-three">
<thead>
	<tr>
		<th colspan="2" style="text-align:center;"><h3>Change Discount</h3></th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><strong><div style="vertical-align:bottom">Discount:</div></td>
		<td>
      <input type="hidden" id="changehighlight" name="changehighlight" value="1" />
<input type="text" size="4" style="font: large bolder;" name="disp1" id="disp1" value="#changediscountquery.dispec1#" 
onKeyUp="getDiscount('#changediscountquery.amt_bil#');" 
validate="float" validateat="onsubmit"/>%
<input type="text" size="4" style="font: large bolder;" name="disp2" id="disp2" value="#changediscountquery.dispec2#" validate="float" onKeyUp="getDiscount('#changediscountquery.amt_bil#');"  validateat="onsubmit"/>%

<input type="text" size="4" style="font: large bolder;" name="disp3" id="disp3" value="#changediscountquery.dispec3#" validate="float" onKeyUp="getDiscount('#changediscountquery.amt_bil#');"  validateat="onsubmit"/>%
<input type="text"  style="font: large bolder;" name="disamt_bil1" id="disamt_bil1" value="#disamt_bil#" onkeyup="updatediscount2(event,'#uuid#','#trancode#',document.getElementById('disamt_bil1').value);" onmouseout="doSomethingWithSelectedText();"/>
        </td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="button" name="sub_btn" id="sub_btn" value="Update" onclick="updatediscount('#uuid#','#trancode#',document.getElementById('disamt_bil1').value,document.getElementById('disp1').value,document.getElementById('disp2').value,document.getElementById('disp3').value);" /></td>
	</tr>
    <tr>
		<td colspan="3">
<cfinclude template="button.cfm"> 
</td>
	</tr>
	</tbody>
</table>
</cfoutput>
