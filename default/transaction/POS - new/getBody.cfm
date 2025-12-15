<cfsetting showdebugoutput="no">
<cfset uuid = url.uuid>
<cfoutput>

<table width="100%">
<tr>
<th width="2%" style="height:24">No</th>
<th width="15%">Item Code</th>

<th width="20%">Description</th>
<th width="10%">Quantity</th>
<th width="8%">Price</th>
<th width="8%">Discount</th>
<th width="8%">After Disc Price</th>
<th width="8%">Amount</th>
<th width="10%">Action</th>
</tr>
<cfquery name="getictrantemp" datasource="#dts#">
SELECT * FROM ictrantemp WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#"> order by trancode desc
</cfquery>
<cfloop query="getictrantemp">
<tr <cfif getictrantemp.note1 eq 'Y'>style="background-color:##FF0" onMouseOut="javascript:this.style.backgroundColor='FF0';" onMouseOver="javascript:this.style.backgroundColor='99FF00';"<cfelseif getictrantemp.note1 eq 'P'>style="background-color:##FF9BCD" onMouseOut="javascript:this.style.backgroundColor='##FF9BCD';" onMouseOver="javascript:this.style.backgroundColor='99FF00';"<cfelse><cfif (getictrantemp.currentrow mod 2) eq 0>style="background-color:##33FFFF"</cfif> onMouseOut="javascript:this.style.backgroundColor='<cfif (getictrantemp.currentrow mod 2) eq 0>33FFFF</cfif>';" onMouseOver="javascript:this.style.backgroundColor='99FF00';"</cfif>>
<td nowrap><font style="font-size:14px">#getictrantemp.currentrow#</font></td>
<td nowrap><font style="font-size:14px">#getictrantemp.itemno#</font></td>

<td nowrap><font style="font-size:14px"><a onmouseover="JavaScript:this.style.cursor='hand'" onClick="document.getElementById('itemdesptrancode').value='#getictrantemp.trancode#';ColdFusion.Window.show('itemdesp');">#getictrantemp.desp#</a></font></td>
<td nowrap align="right"><font style="font-size:14px">
<a style="cursor:pointer" onClick="document.getElementById('hidtrancode').value='=0&trancode=#getictrantemp.trancode#&uuid='+document.getElementById('uuid').value;ColdFusion.Window.show('changeqty');getfocus5();">#numberformat(val(getictrantemp.qty_bil),',.__')#</a></font>
</td>
<td nowrap align="right"><font style="font-size:14px"><cfif getpin2.h2F00 eq "T"><a style="cursor:pointer" onClick="document.getElementById('hidtrancode').value='=0&trancode=#getictrantemp.trancode#&uuid='+document.getElementById('uuid').value;ColdFusion.Window.show('changeprice');getfocus4();">#numberformat(val(getictrantemp.price_bil),',.__')#</a><cfelse>#numberformat(val(getictrantemp.price_bil),',.__')#</cfif></font></td>
<td nowrap align="right"><font style="font-size:14px">
<a style="cursor:pointer" onClick="document.getElementById('hidtrancode').value='=0&trancode=#getictrantemp.trancode#&uuid='+document.getElementById('uuid').value;ColdFusion.Window.show('changediscount');getfocus6();"><cfif getictrantemp.brem4 eq ''>-<cfelse>#getictrantemp.brem4#</cfif></a></font>
</td>
<td nowrap align="right"><font style="font-size:14px"><cfif qty_bil eq 0>#numberformat(val(getictrantemp.amt_bil),',.__')#<cfelse>#numberformat(val(getictrantemp.amt_bil/getictrantemp.qty_bil),',.__')#</cfif></font></td>
<td nowrap align="right"><font style="font-size:14px"><a style="cursor:pointer" onClick="document.getElementById('hidtrancode').value='=0&trancode=#getictrantemp.trancode#&uuid='+document.getElementById('uuid').value;ColdFusion.Window.show('changeamt');">#numberformat(val(getictrantemp.amt_bil),',.__')#</a></font></td>
<td nowrap><input type="button" name="deletebtn#getictrantemp.trancode#" id="deletebtn#getictrantemp.trancode#" onClick="if(confirm('Are You Sure You Want To Delete?')){deleterow('#getictrantemp.trancode#')}" value="DELETE"/>&nbsp;<img id="updatebtn#getictrantemp.trancode#" name="updatebtn#getictrantemp.trancode#" src="/images/tick.gif" width="15" height="15" style="cursor:pointer; display:none;"><!--- &nbsp;&nbsp;<input type="button" name="Updatebtn#getictrantemp.trancode#" id="updatebtn#getictrantemp.trancode#" onClick="updaterow('#getictrantemp.trancode#')" value="UPDATE" style="display:none"/> ---></td>
</tr>
</cfloop>
</table>
</cfoutput>
