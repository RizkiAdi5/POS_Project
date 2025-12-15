
<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "58, 274, 65, 227, 1096, 592, 1097, 10, 805, 2073, 492">
<cfinclude template="/latest/words.cfm">

<cfquery name="getunitlisttemp" datasource="#dts#">
select itemno,unit,unit2,unit3,unit4,unit5,unit6 from icitem 
</cfquery>

<cfquery name="getunit" datasource="#dts#">
SELECT * FROM unit
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
SELECT * FROM gsetup
</cfquery>

<cfsetting showdebugoutput="no">
<cfset uuid = url.uuid>
<cfoutput>

<table width="100%" border="1">
<tr>
<td width="2%" style="height:24">#words[58]#</td>
<td width="15%">#words[274]#</th>
<td width="20%">#words[65]#</th>

<td width="10%">#words[227]#</td>
<td width="10%">#words[492]#</td>
<td width="8%">#words[1096]#</td>
<td width="8%">#words[592]#</td>
<td width="8%">#words[1097]#</td>
<td width="10%" align="center">#words[10]#</td>
</tr>
<cfquery name="getictrantemp" datasource="#dts#">
SELECT * FROM ictrantemp WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#"> order by trancode desc
</cfquery>
<cfloop query="getictrantemp">

<cfquery name="getitemunitlist" dbtype="query">
SELECT * FROM getunitlisttemp WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getictrantemp.itemno#">
</cfquery>
<cfif getgsetup.displayownunit EQ 'Y'>
<cfset itemunitlist="">
<cfif getitemunitlist.unit neq "">
<cfset itemunitlist=getitemunitlist.unit>
</cfif>
<cfloop from="2" to="6" index="zz">
<cfif evaluate('getitemunitlist.unit#zz#') neq "" and listcontains(itemunitlist,evaluate('getitemunitlist.unit#zz#'),',')  eq 0>
<cfif itemunitlist eq "">
<cfset itemunitlist=evaluate('getitemunitlist.unit#zz#')>
<cfelse>
<cfset itemunitlist=itemunitlist&","&evaluate('getitemunitlist.unit#zz#')>
</cfif>
</cfif>
</cfloop>
</cfif>

<tr <cfif getictrantemp.note1 eq 'Y'>style="background-color:##FF0" onMouseOut="javascript:this.style.backgroundColor='FF0';" onMouseOver="javascript:this.style.backgroundColor='99FF00';"<cfelseif getictrantemp.note1 eq 'P'>style="background-color:##FF9BCD" onMouseOut="javascript:this.style.backgroundColor='##FF9BCD';" onMouseOver="javascript:this.style.backgroundColor='99FF00';"<cfelse><cfif (getictrantemp.currentrow mod 2) eq 0>style="background-color:##33FFFF"</cfif> onMouseOut="javascript:this.style.backgroundColor='<cfif (getictrantemp.currentrow mod 2) eq 0>33FFFF</cfif>';" onMouseOver="javascript:this.style.backgroundColor='99FF00';"</cfif>>
<td nowrap><font style="font-size:14px">#getictrantemp.currentrow#</font></td>
<td nowrap><font style="font-size:14px">#getictrantemp.itemno#</font><cfif wserialno eq "T">&nbsp;&nbsp;<input type="button" name="addserial" id="addserial" value="S" onClick="PopupCenter('serial.cfm?tran=#type#&nexttranno=#refno#&itemno=#URLEncodedFormat(itemno)#&itemcount=#trancode#&uuid=#uuid#&qty=#qty#&custno=#custno#&price=#price#&location=#URLEncodedFormat(location)#','Add Serial','400','500');"></cfif></td>
<td nowrap><font style="font-size:14px"><a onmouseover="JavaScript:this.style.cursor='hand'" onClick="document.getElementById('itemdesptrancode').value='#getictrantemp.trancode#';ColdFusion.Window.show('itemdesp');">#getictrantemp.desp# #getictrantemp.despa#</a></font></td>
<td nowrap align="right"><font style="font-size:14px">
<a style="cursor:pointer" onClick="document.getElementById('hidtrancode').value='=0&trancode=#getictrantemp.trancode#&uuid='+document.getElementById('uuid').value;ColdFusion.Window.show('changeqty');getfocus5();">#numberformat(val(getictrantemp.qty_bil),',.__')#</a></font>
</td>
<td nowrap align="left">
<select name="unitlist#getictrantemp.trancode#" id="unitlist#getictrantemp.trancode#" onChange="updaterow('#getictrantemp.trancode#');">
<option value="">Choose a unit</option>
<cfif getgsetup.displayownunit EQ 'Y'>
<cfloop list="#itemunitlist#" index="aa">
<option value="#aa#" <cfif getictrantemp.unit_bil eq aa>selected</cfif>>#aa#</option>
</cfloop>
<cfelse>
<cfloop query="getunit">
<option value="#getunit.unit#" <cfif getictrantemp.unit_bil eq getunit.unit>selected</cfif>>#getunit.unit#</option>
</cfloop>
</cfif>
</select>
</td>

<td nowrap align="right"><font style="font-size:14px"><cfif getpin2.h2F00 eq "T"><a style="cursor:pointer" onClick="document.getElementById('hidtrancode').value='=0&trancode=#getictrantemp.trancode#&uuid='+document.getElementById('uuid').value;ColdFusion.Window.show('changeprice');getfocus4();">#numberformat(val(getictrantemp.price_bil),',.__')#</a><cfelse>#numberformat(val(getictrantemp.price_bil),',.__')#</cfif></font></td>

<td nowrap align="right"><font style="font-size:14px">
<a style="cursor:pointer" onClick="document.getElementById('hidtrancode').value='=0&trancode=#getictrantemp.trancode#&uuid='+document.getElementById('uuid').value;ColdFusion.Window.show('changediscount');getfocus6();"><cfif getictrantemp.disamt_bil eq ''>-<cfelse>#getictrantemp.disamt_bil#</cfif></a></font>
</td>
<td nowrap align="right"><font style="font-size:14px"><a style="cursor:pointer" onClick="document.getElementById('hidtrancode').value='=0&trancode=#getictrantemp.trancode#&uuid='+document.getElementById('uuid').value;ColdFusion.Window.show('changeamt');">#numberformat(val(getictrantemp.amt_bil),',.__')#</a></font></td>
<td nowrap align="center"><input type="button" name="deletebtn#getictrantemp.trancode#" id="deletebtn#getictrantemp.trancode#" onClick="if(confirm('#words[2073]#')){deleterow('#getictrantemp.trancode#')}" value="#words[805]#"/>&nbsp;<img id="updatebtn#getictrantemp.trancode#" name="updatebtn#getictrantemp.trancode#" src="/images/tick.gif" width="15" height="15" style="cursor:pointer; display:none;"><!--- &nbsp;&nbsp;<input type="button" name="Updatebtn#getictrantemp.trancode#" id="updatebtn#getictrantemp.trancode#" onClick="updaterow('#getictrantemp.trancode#')" value="UPDATE" style="display:none"/> ---></td>
</tr>
</cfloop>
</table>
</cfoutput>
