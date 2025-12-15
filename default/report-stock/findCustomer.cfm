
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
    <font style="text-transform:uppercase">#UCASE(nametype)# NO.</font>&nbsp;<input type="text" name="custno1" size="8" id="custno1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax.cfm?type=#url.type#&nametype=#nametype#&fromto=#url.fromto#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value+'&displaytype='+document.getElementById('displaytype').value);" <cfif isdefined('url.custno')>value="#url.custno#"</cfif>  />&nbsp;MID NAME:&nbsp;<input type="text" name="custname1" id="custname1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax.cfm?type=#url.type#&nametype=#nametype#&fromto=#url.fromto#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value+'&displaytype='+document.getElementById('displaytype').value);" size="12" />&nbsp;LEFT NAME:&nbsp;<input type="text" name="custname2" id="custname2" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax.cfm?type=#url.type#&nametype=#nametype#&fromto=#url.fromto#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value+'&displaytype='+document.getElementById('displaytype').value);" size="12" />
    <br />
    <select name="displaytype" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax.cfm?type=#url.type#&nametype=#nametype#&fromto=#url.fromto#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value+'&displaytype='+document.getElementById('displaytype').value);">
    <option value="name">Debitor No - Name</option>
    <option value="name2">Debitor No - Name - Name 2</option>
    <option value="name3">Debitor No - Name -  Area - Agent</option>
    <option value="name4">Debitor No - Name - Address</option>
    </select>
    &nbsp;&nbsp;<input type="button" name="Searchbtn" value="Go" >
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
    <td><a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="selectlist('#getcustsupp.xcustno#','#nametype##url.fromto#');ColdFusion.Window.hide('findCustomer');"><u>SELECT</u></a></td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>