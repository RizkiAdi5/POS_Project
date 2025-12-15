<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2128, 2125, 23, 2129, 440, 2130, 6, 10, 965, 11, 184">
<cfinclude template="/latest/words.cfm">

<cfoutput>
<cfquery name="getmembercust" datasource="#dts#">
select custno from #target_arcust#
</cfquery>
<h1>#words[2128]#</h1>
<table>
<tr>
<th>#words[2125]#</th>
<td>:</td>
<td>
<input type="text" name="searchmemberid" id="searchmemberid" value="" size="55" />
</td>
</tr>
<tr>
<th>#words[23]#</th>
<td>:</td>
<td>
<input type="text" name="searchmembername" id="searchmembername" value="" size="55"/>
</td>
</tr>
<tr>
<th>#words[2129]#</th>
<td>:</td>
<td>
<input type="text" name="searchmemberattn" id="searchmemberattn" value="" size="55" />
</td>
</tr>
<tr>
<th>#words[440]#</th>
<td>:</td>
<td>
<input type="text" name="searchmembertel" id="searchmembertel" value="" size="55" />
</td>
</tr>
<tr>
<th>#words[2130]#</th>
<td>:</td>
<td>

<select name="searchmembercust" id="searchmembercust">
<option value="">#words[184]#</option>
<cfloop query="getmembercust">
<option value="#getmembercust.custno#">#getmembercust.custno#</option>
</cfloop>
</select>

</td>
</tr>
<tr>
<th>#words[6]#</th>
<td>:</td>
<td>
<input type="text" name="searchmemberadd" id="searchmemberadd" value="" size="55"/>
</td>
</tr>
<tr>
<td colspan="3" align="center">
<input type="button" name="search_btn" id="search_btn" value="#words[11]#" onclick="ajaxFunction(document.getElementById('searchmemberajax'),'searchmemberajax.cfm?driverno='+escape(document.getElementById('searchmemberid').value)+'&name='+escape(document.getElementById('searchmembername').value)+'&contact='+escape(document.getElementById('searchmembertel').value)+'&attn='+escape(document.getElementById('searchmemberattn').value)+'&custno='+escape(document.getElementById('searchmembercust').value)+'&address='+escape(document.getElementById('searchmemberadd').value)+'&main=#url.main#');"  />
</td>
</tr>
</table>
<div id="searchmemberajax">
<table>
<tr>
<th width="100px">#words[2125]#</th>
<th width="150px">#words[23]#</th>
<th width="100px">#words[2129]#</th>
<th width="100px">#words[2130]#</th>
<th width="100px">#words[440]#</th>
<th width="300px">#words[6]#</th>
<th width="100px">#words[10]#</th>
</tr>
<cfquery name="getlist" datasource="#dts#">
SELECT driverno,name,contact,add1,add2,add3,attn,customerno FROM driver order by driverno limit 10
</cfquery>
<cfloop query="getlist">
<tr>
<td>#getlist.driverno#</td>
<td>#getlist.name#</td>
<td>#getlist.attn#</td>
<td>#getlist.customerno#</td>
<td>#getlist.contact#</td>
<td>
#getlist.add1# #getlist.add2# #getlist.add3#
</td>
<td align="right">
<cfif url.main eq "in">
<a style="cursor:pointer" onclick="fillsearch('#URLENCODEDFORMAT(getlist.driverno)#','#URLENCODEDFORMAT(getlist.name)#','#URLENCODEDFORMAT(getlist.contact)#','#URLENCODEDFORMAT(getlist.add1)#','#URLENCODEDFORMAT(getlist.add2)#','#URLENCODEDFORMAT(getlist.add3)#');
ColdFusion.Window.hide('searchmember');">#words[965]#</a>
<cfelse>
<a style="cursor:pointer" onclick="selectlist('#getlist.driverno#','driver');
ColdFusion.Window.hide('searchmember');">#words[965]#</a>
</cfif>
</td>
</tr>
</cfloop>
</table>
</div>
</cfoutput>