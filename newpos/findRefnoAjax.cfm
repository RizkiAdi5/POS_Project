 <link rel="stylesheet" type="text/css" href="../newpos/table.css" />

<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1087, 1303, 2064, 10, 965">
<cfinclude template="/latest/words.cfm">

<cfquery name="getcustsupp" datasource="#dts#">
   		select refno,name,van,rem41 from artran WHERE type ='#url.type#' and refno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custno#%"> and van like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custname#%"> order by refno limit 20
	</cfquery>
	<cfoutput>  
<center>
<table class="table-style-three">
	<tbody>
	<tr>
		<th><font style="text-transform:uppercase">#words[1087]# #type#</font></th>
		<th>#words[1303]#</th>
		<th>#words[2064]#</th>
		<th>#words[10]#</th>		
	</tr>
	<cfloop query="getcustsupp" >
	<tr>
		<td>#getcustsupp.refno#</td>
		<td>#getcustsupp.van#</td>
		<td>#getcustsupp.rem41#</td>
		<td><a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="exchangereceipt('#getcustsupp.refno#');"><u>#words[965]#</u></a></td>
	</tr>
	</cfloop>
	</tbody>
</table>
</center>
    </cfoutput>