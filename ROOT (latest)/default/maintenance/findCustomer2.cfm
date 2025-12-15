
<cfoutput>
<cfset tran = url.type >
<cfif tran eq target_apvend>
<cfset nametype = "supp">
<cfelse>
<cfset nametype = "cust">
</cfif>
	<cfquery name="getcustsupp" datasource="#dts#">
   		select custno as xcustno,name from #tran# limit 15
	</cfquery>
    <font style="text-transform:uppercase">
    Agent:&nbsp;<input type="text" name="custname2" id="custname2" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax2.cfm?type=#url.type#&nametype=#nametype#&fromto=#url.fromto#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);" size="12" />
    &nbsp;#UCASE(nametype)# NAME:&nbsp;<input type="text" name="custname1" id="custname1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax2.cfm?type=#url.type#&nametype=#nametype#&fromto=#url.fromto#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);" size="12" />
    &nbsp;#UCASE(nametype)# NO.</font>&nbsp;<input type="text" name="custno1" size="8" id="custno1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax2.cfm?type=#url.type#&nametype=#nametype#&fromto=#url.fromto#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);" <cfif isdefined('url.custno')>value="#url.custno#"</cfif>  />&nbsp;&nbsp;<input type="button" name="Searchbtn" value="Go" >
    <div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....
    </div>
    </div>
    <div id="ajaxField" name="ajaxField">
    <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">#UCASE(nametype)# NO</font></th>
    <th width="400px">NAME</th>
    <th width="80px">ACTION</th>
    </tr>
    <cfloop query="getcustsupp" >
    <tr>
    <td>#getcustsupp.xcustno#</td>
    <td>#getcustsupp.name#</td>
    <td><a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="selectlist('#getcustsupp.xcustno#','Cust#url.fromto#');ColdFusion.Window.hide('findCustomer');"><u>SELECT</u></a></td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>