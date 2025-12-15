<cfoutput>
<script type="text/javascript" src="/scripts/ajax.js"></script>
<cfset ptype = url.type >

	<cfquery name="getcustsupp" datasource="#dts#">
   		select refno,name,van,rem41 from artran where type='#ptype#' limit 15
	</cfquery>
    <font style="text-transform:uppercase">#url.type# NO.</font>&nbsp;<input type="text" name="custno1" id="custno1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFieldTrade'),'findRefnoAjax.cfm?type=#url.type#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value);"  />&nbsp;&nbsp;Member:&nbsp;
    <input type="text" name="custname1" id="custname1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFieldTrade'),'findRefnoAjax.cfm?type=#url.type#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value);" />&nbsp;&nbsp;
    <input type="button" name="Searchbtn" value="Go" >
    <div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....
    </div>
    </div>
    
    <div id="ajaxFieldTrade">
    <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">REF NO #url.type#</font></th>
    <th width="300px">MEMBER</th>
    <th width="80px">EXCHANGE RECEIPT NO</th>
    <th width="80px">ACTION</th>
    </tr>
    <cfloop query="getcustsupp" >
    <tr>
    <td>#getcustsupp.refno#</td>
    <td>#getcustsupp.van#</td>
    <td>#getcustsupp.rem41#</td>
    <td>

    <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="javascript:ColdFusion.Window.hide('findRefno');exchangereceipt('#getcustsupp.refno#');"><u>SELECT</u></a>
   
   

    </td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>