<cfquery name="getitemlist" datasource="#dts#">
select * from packdet where packcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.packcode)#">
</cfquery>
<cfoutput>
<table>
<tr>
<th align="left">ITEM NO</th>
<th align="left">DESP</th>
<th align="right">QTY</th>
<th align="right">PRICE</th>
</tr>
<cfloop query="getitemlist">
<tr>
<td>#getitemlist.itemno#</td>
<td>#getitemlist.desp#</td>
<td align="right">#val(getitemlist.qty_bil)#</td>
<td align="right">#numberformat(getitemlist.price_bil,'.__')#</td>
</tr>
</cfloop>
</table>
</cfoutput>