<cfoutput>
<cfset nametype = url.type>

	<cfquery name="getlocation" datasource="#dts#">
   		select attentionno as xattentionno,name,phone,phonea,fax,c_email from attention where customerno='#url.custno#' limit 15
	</cfquery>
    <font style="text-transform:uppercase">Attention NO.</font>&nbsp;<input type="text" name="location1" size="8" id="location1" value="" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findattentionAjax.cfm?custno=#url.custno#&nametype=#nametype#&location='+document.getElementById('location1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);" <cfif isdefined('url.custno')>value="#url.custno#"</cfif>  />&nbsp;MID Name:&nbsp;<input type="text" name="custname1" id="custname1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findattentionAjax.cfm?custno=#url.custno#nametype=#nametype#&location='+document.getElementById('location1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);" size="12" />&nbsp;LEFT Name:&nbsp;<input type="text" name="custname2" id="custname2" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findattentionAjax.cfm?custno=#url.custno#nametype=#nametype#&location='+document.getElementById('location1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);" size="12" />&nbsp;&nbsp;<input type="button" name="Searchbtn" value="Go" >
    <div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....
    </div>
    </div>
    <div id="ajaxField" name="ajaxField">
    <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">#UCASE(nametype)# NO</font></th>
    <th width="400px">Name</th>
    <th width="80px">ACTION</th>
    </tr>
    <cfloop query="getlocation" >
    <tr>
    <td>#getlocation.xattentionno#</td>
    <td>#getlocation.NAME#</td>
    <td><a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="document.getElementById('b_attn').value='#getlocation.xattentionno#';document.getElementById('b_phone').value='#getlocation.phone#';document.getElementById('b_phone2').value='#getlocation.phonea#';document.getElementById('b_fax').value='#getlocation.fax#';document.getElementById('b_email').value='#getlocation.c_email#';ColdFusion.Window.hide('findattention');"><u>SELECT</u></a></td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>