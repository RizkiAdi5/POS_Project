<cfif isdefined('url.action') and isdefined('url.filename')>
<cffile action="delete" file="#HRootPath#\download\#dts#\bill\#type#\#url.refno#\#URLDECODE(url.filename)#">
</cfif>
<cfif isdefined('url.refno') and isdefined('url.type')>
<cfset refno = urldecode(url.refno)>
<cfset type = url.type>
<cfdirectory action="list" directory="#HRootPath#\download\#dts#\bill\#type#\#url.refno#" name="file_list">
</cfif>
<cfoutput>
<table>
<tr >
<th width="320px">File Name</th>
<th width="60px">Size</th>
<th width="150px">Date Modified</th>
<th width="60px">Action</th>
</tr>
<cfloop query="file_list">
<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
<td><a href="downloadfile.cfm?refno=#url.refno#&type=#url.type#&filename=#URLENCODEDFORMAT(file_list.name)#" target="_blank">#file_list.name#</a></td>
<td>#numberformat(file_list.size/1000,'0')# KB</td>
<td>#dateformat(file_list.dateLastModified,'YYYY-MM-DD')# #timeformat(file_list.dateLastModified,'HH:MM:SS')#</td>
<td><a style="cursor:pointer" onClick="if(confirm('Are you sure you want to delete #file_list.name#?')){ajaxFunction(document.getElementById('uploadfilelist'),'uploadfilelist.cfm?action=delete&refno=#url.refno#&type=#url.type#&filename=#URLENCODEDFORMAT(file_list.name)#');}">Delete</a></td>
</tr>
</cfloop>
</table>
</cfoutput>