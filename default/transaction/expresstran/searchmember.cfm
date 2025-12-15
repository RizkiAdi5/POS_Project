<cfoutput>
<h1>Search Member</h1>
<table>
<tr>
<th>Member ID</th>
<td>:</td>
<td>
<input type="text" name="searchmemberid" id="searchmemberid" value="" size="55" onKeyUp="nextIndex(event,'searchmembername','searchmembername');" />
</td>
</tr>
<tr>
<th>Name</th>
<td>:</td>
<td>
<input type="text" name="searchmembername" id="searchmembername" value="" size="55" onKeyUp="nextIndex(event,'searchmembername','searchmembertel');"/>
</td>
</tr>
<tr>
<th>Tel</th>
<td>:</td>
<td>
<input type="text" name="searchmembertel" id="searchmembertel" value="" size="55" onKeyUp="nextIndex(event,'searchmembername','searchmemberadd');" />
</td>
</tr>
<tr>
<th>Address</th>
<td>:</td>
<td>
<input type="text" name="searchmemberadd" id="searchmemberadd" value="" size="55" onKeyUp="nextIndex(event,'searchmembername','search_btn');"/>
</td>
</tr>
<tr>
<td colspan="3" align="center">
<input type="button" name="search_btn" id="search_btn" value="Search" onclick="ajaxFunction(document.getElementById('searchmemberajax'),'searchmemberajax.cfm?driverno='+escape(document.getElementById('searchmemberid').value)+'&name='+escape(document.getElementById('searchmembername').value)+'&contact='+escape(document.getElementById('searchmembertel').value)+'&address='+escape(document.getElementById('searchmemberadd').value)+'&main=#url.main#');"  />
</td>
</tr>
</table>
<div id="searchmemberajax">
<table>
<tr>
<th width="100px">Member ID</th>
<th width="150px">Name</th>
<th width="100px">Tel</th>
<th width="300px">Address</th>
<th width="100px">Action</th>
</tr>
<cfquery name="getlist" datasource="#dts#">
SELECT driverno,name,contact,add1,add2,add3 FROM driver order by driverno limit 10
</cfquery>
<cfloop query="getlist">
<tr>
<td>#getlist.driverno#</td>
<td>#getlist.name#</td>
<td>#getlist.contact#</td>
<td>
#getlist.add1# #getlist.add2# #getlist.add3#
</td>
<td align="right">
<cfif url.main eq "in">
<a style="cursor:pointer" onclick="fillsearch('#URLENCODEDFORMAT(getlist.driverno)#','#URLENCODEDFORMAT(getlist.name)#','#URLENCODEDFORMAT(getlist.contact)#','#URLENCODEDFORMAT(getlist.add1)#','#URLENCODEDFORMAT(getlist.add2)#','#URLENCODEDFORMAT(getlist.add3)#');getmember();
ColdFusion.Window.hide('searchmember');">Select</a>
<cfelse>
<a style="cursor:pointer" onclick="selectlist('#getlist.driverno#','driver');getmember();
ColdFusion.Window.hide('searchmember');">Select</a>
</cfif>
</td>
</tr>
</cfloop>
</table>
</div>
</cfoutput>