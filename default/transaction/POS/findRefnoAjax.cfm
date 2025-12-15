<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1087, 1303, 2064, 10, 965">
<cfinclude template="/latest/words.cfm">

<cfquery name="getcustsupp" datasource="#dts#">
   		select refno,name,van,rem41 from artran WHERE type ='#url.type#' and refno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custno#%"> and van like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custname#%"> order by refno limit 20
	</cfquery>
	<cfoutput>  
   
       <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">#words[1087]# #url.type#</font></th>
    <th width="300px">#words[1303]#</th>
    <th width="80px">#words[2064]#</th>
    <th width="80px">#words[10]#</th>
    </tr>
    <cfloop query="getcustsupp" >
    <tr>
    <td>#getcustsupp.refno#</td>
    <td>#getcustsupp.van#</td>
    <td>#getcustsupp.rem41#</td>
    <td>
    <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="javascript:ColdFusion.Window.hide('findRefno');exchangereceipt('#getcustsupp.refno#');"><u>#words[965]#</u></a>
   
</td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>