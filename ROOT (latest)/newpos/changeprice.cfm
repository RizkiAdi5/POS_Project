<link rel="stylesheet" type="text/css" href="table.css" />

<cfset uuid=urldecode(uuid)>
<cfquery name="getprice" datasource="#dts#">
SELECT price_bil,itemno FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">
</cfquery>

<cfquery name="getminimumprice" datasource="#dts#">
SELECT price2,ucost FROM icitem where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getprice.itemno#">
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
select gpricemin from gsetup
</cfquery>

<cfquery name="getdealermenu" datasource="#dts#">
select selling_below_cost from dealer_menu
</cfquery>
<cfset btname = #btnname# />

<cfoutput>
<center>
<table class="table-style-three">
<thead>
	<tr>
		<th colspan="2" style="text-align:center;"><h3>Change Price</h3></th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><strong><div style="vertical-align:bottom">Price:</div></td>
		<td>
       <cfif getgsetup.gpricemin eq '1'>
<input type="hidden" name="minimumprice2" id="minimumprice2" value="#numberformat(val(getminimumprice.price2),'.__')#"/>
<cfelse>
<input type="hidden" name="minimumprice2" id="minimumprice2" value="0"/>
</cfif>

<cfif getdealermenu.selling_below_cost eq 'Y'>
<input type="hidden" name="sellingbelowcost" id="sellingbelowcost" value="#numberformat(val(getminimumprice.ucost),'.__')#"/>
<cfelse>
<input type="hidden" name="sellingbelowcost" id="sellingbelowcost" value="0"/>
</cfif>

<input type="hidden" id="changepriceuuid" name="changepriceuuid" value="#uuid#" />
<input type="hidden" id="changepricetrancode" name="changepricetrancode" value="#trancode#" />

<input type="hidden" id="changehighlight" name="changehighlight" value="1" />

<input style="font: large bolder;" type="text" name="price_bil1" id="price_bil1" value="#price_bil#" onkeyup="updateprice2(event,'#uuid#','#trancode#',document.getElementById('price_bil1').value);" onmouseout="doSomethingWithSelectedText();"/>
        </td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="button" name="sub_btn" id="sub_btn" value="Update" onclick="updateprice('#uuid#','#trancode#',document.getElementById('price_bil1').value);" /></td>
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
