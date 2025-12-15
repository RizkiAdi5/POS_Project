<cfoutput>
<cfset ptype = url.type >

	<cfquery name="getcustsupp" datasource="#dts#">
   		select refno,name from artran where type='#ptype#' limit 15
	</cfquery>
    <font style="text-transform:uppercase">#url.type# NO.</font>&nbsp;<input type="text" name="custno1" id="custno1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findRefnoAjax.cfm?type=#url.type#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value);"  />&nbsp;&nbsp;NAME:&nbsp;
    <input type="text" name="custname1" id="custname1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findRefnoAjax.cfm?type=#url.type#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value);" />&nbsp;&nbsp;<input type="button" name="Searchbtn" value="Go" >
    <div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....
    </div>
    </div>
    <div id="ajaxField" name="ajaxField">
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