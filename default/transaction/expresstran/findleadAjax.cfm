<cfset crmdts=replace(dts,'_i','_c','all')>

<cfquery name="getdummycust" datasource="#dts#">
   		select dummycust from gsetup
</cfquery>
	<cfquery name="getlead" datasource="#crmdts#">
   		select * from lead 
        WHERE accountno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custno#%"> and leadname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custname#%"> and leadname like <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.leftcustname#%">
        order by id
		limit 15
	</cfquery>
   		
	<cfoutput>  
    <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">Lead ID</font></th>
    <th width="100px"><font style="text-transform:uppercase">Lead Name</font></th>
    <th width="100px"><font style="text-transform:uppercase">Account No</font></th>
    <th width="200px">LEAD STATUS</th>
    <th width="80px">ACTION</th>
    </tr>
    <cfloop query="getlead" >
    
    <tr>
    <td>#getlead.id#</td>
    <td>#getlead.leadname#</td>
    <td>#getlead.accountno#</td>
    <td>#getlead.leadstatus#</td>
    <cfif getlead.accountno eq ''>
    <cfset getlead.accountno='#getdummycust.dummycust#'>
    </cfif>
    <td><a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="document.getElementById('custno').value='#getlead.accountno#';document.getElementById('leadno').value='#getlead.id#';document.getElementById('b_name').value='#getlead.leadname#';document.getElementById('d_name').value='#getlead.leadname#';document.getElementById('b_add1').value='#getlead.add1#';document.getElementById('b_add2').value='#getlead.add2#';document.getElementById('b_add3').value='#getlead.add3#';document.getElementById('b_add4').value='#getlead.add4#';document.getElementById('d_add1').value='#getlead.daddr1#';document.getElementById('d_add2').value='#getlead.daddr2#';document.getElementById('d_add3').value='#getlead.daddr3#';document.getElementById('d_add4').value='#getlead.daddr4#';ColdFusion.Window.hide('findlead');">SELECT</a></td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>