
<cfset ptype = url.type >

	<cfquery name="getcustsupp1" datasource="#dts#">
   		select custno as xcustno,name,agent from #url.dbtype# WHERE custno like <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.custno#%"> and name like <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.custname#%"> and agent like <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.leftcustname#%"> order by custno limit 500
	</cfquery>
	<cfoutput>  
    <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">#url.type# NO</font></th>
    <th width="300px">NAME</th>
    <th width="300px">Agent No</th>
    <cfif lcase(hcomid) neq "acht_i"><th width="80px">ACTION</th></cfif>
    </tr>
    <cfloop query="getcustsupp1" >
    
    <tr id="t#getcustsupp1.currentrow#" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';" <cfif lcase(hcomid) eq "acht_i">onClick="document.getElementById('custno').value = '#getcustsupp1.xcustno#';getcustomer();ColdFusion.Window.hide('findCustomer');"</cfif>>
    <td>#getcustsupp1.xcustno#</td>
    <td>#getcustsupp1.name#</td>
    <td>#getcustsupp1.agent#</td>
    <cfif lcase(hcomid) neq "acht_i">
    <td><input name="b#getcustsupp1.currentrow#" id="b#getcustsupp1.currentrow#" type="button" style="background:none; border:none; cursor:pointer;" onClick="document.getElementById('custno').value = '#getcustsupp1.xcustno#';getcustomer();document.getElementById('wos_date').focus();ColdFusion.Window.hide('findCustomer');" value="SELECT" onfocus="document.getElementById('t#getcustsupp1.currentrow#').bgColor='##CCCCCC'" onblur="document.getElementById('t#getcustsupp1.currentrow#').bgColor='##FFFFFF'" onkeyup="<cfif getcustsupp1.currentrow neq getcustsupp1.recordcount>if(event.keyCode==40){document.getElementById('b#val(getcustsupp1.currentrow)+1#').focus()}</cfif> <cfif getcustsupp1.currentrow neq 1>if(event.keyCode==38){document.getElementById('b#val(getcustsupp1.currentrow)-1#').focus()}<cfelse>if(event.keyCode==38){document.getElementById('custno1').focus()}</cfif> " />
    </td></cfif>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>