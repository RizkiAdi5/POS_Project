
<cfquery name="getcustsupp" datasource="#dts#">
   		select refno,name from artran WHERE type ='#url.type#' and refno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custno#%"> and name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custname#%"> order by refno limit 20
	</cfquery>
	<cfoutput>  
   
       <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">REF NO #url.type#</font></th>
    <th width="300px">CUSTOMER NAME</th>
    <th width="80px">ACTION</th>
    </tr>
    <cfloop query="getcustsupp" >
    <tr>
    <td>#getcustsupp.refno#</td>
    <td>#getcustsupp.name#</td>
    <td>
    <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="javascript:ColdFusion.Window.hide('findRefno');selectlist('#getcustsupp.refno#','rcno');"><u>SELECT</u></a>
   
</td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>