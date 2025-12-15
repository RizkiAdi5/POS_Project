<cfoutput>

<cfquery name="getdummycust" datasource="#dts#">
   		select dummycust from gsetup
</cfquery>

<cfset crmdts=replace(dts,'_i','_c','all')>
	<cfquery name="getlead" datasource="#crmdts#">
   		select * from lead WHERE 0=0 
        order by id
		limit 15
	</cfquery>
    
  <font style="text-transform:uppercase">Account NO.</font>&nbsp;<input type="text" name="custno1" <cfif lcase(HcomID) neq "taftc_i" >size="8"<cfelse></cfif> id="custno1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findleadAjax.cfm?custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);"/>
    <cfif lcase(HcomID) neq "taftc_i" >
      &nbsp;LEFT NAME:&nbsp;
    </cfif>
    <input <cfif lcase(HcomID) neq "taftc_i" >type="text"<cfelse>type="hidden"</cfif> name="custname2" id="custname2" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findleadAjax.cfm?custno='+document.getElementById('custno1').value+'&amp;custname='+document.getElementById('custname1').value+'&amp;leftcustname='+document.getElementById('custname2').value);" size="12" />
    &nbsp;<cfif lcase(HcomID) neq "taftc_i" >MID</cfif> NAME:&nbsp;<input type="text" name="custname1" id="custname1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findleadAjax.cfm?custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);" <cfif lcase(HcomID) neq "taftc_i" >size="12"</cfif> /><cfif lcase(HcomID) neq "taftc_i" ></cfif>&nbsp;&nbsp;
    <br />
  <input type="button" name="Searchbtn" value="Go" >
    <div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....    </div>
    </div>
    <div id="ajaxField" name="ajaxField">
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
    <td><a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="document.getElementById('custno').value='#getlead.accountno#';document.getElementById('leadno').value='#getlead.id#';document.getElementById('b_name').value='#getlead.leadname#';document.getElementById('d_name').value='#getlead.leadname#';document.getElementById('b_add1').value='#getlead.add1#';document.getElementById('b_add2').value='#getlead.add2#';document.getElementById('b_add3').value='#getlead.add3#';document.getElementById('b_add4').value='#getlead.add4#';document.getElementById('d_add1').value='#getlead.daddr1#';document.getElementById('d_add2').value='#getlead.daddr2#';document.getElementById('d_add3').value='#getlead.daddr3#';document.getElementById('d_add4').value='#getlead.daddr4#';ColdFusion.Window.hide('findlead');"><u>SELECT</u></a></td>
    </tr>
    </cfloop>
    </table>
    </div>
    </cfoutput>