
	<cfquery name="getitemno" datasource="#dts#">
   		select driverno,name,remarks from driver WHERE driverno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.itemno#%"> and name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custname#%"> and remarks like <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.leftcustname#%"> order by driverno limit 500
	</cfquery>
	<cfoutput>  
    <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">Member No</font></th>
    <th width="300px">Name</th>
    <th width="100px">Ic No</th>
    <th width="80px">ACTION</th>
    </tr>
    <cfloop query="getitemno" >
    
    <tr>
    <td>#getitemno.driverno#</td>
    <td>#getitemno.name#</td>
    <td>#getitemno.remarks#</td>
    <td><a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="selectlist('#getitemno.driverno#','member#url.fromto#');ColdFusion.Window.hide('findmember');" >SELECT</a></td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>