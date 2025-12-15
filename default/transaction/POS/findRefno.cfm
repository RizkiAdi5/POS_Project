<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "68, 1303, 1087, 2064, 10,1276, 965">
<cfinclude template="/latest/words.cfm">
<cfoutput>
<script type="text/javascript" src="/scripts/ajax.js"></script>
<cfset ptype = url.type >

	<cfquery name="getcustsupp" datasource="#dts#">
   		select refno,name,van,rem41 from artran where type='#ptype#' limit 15
	</cfquery>
    <font style="text-transform:uppercase">#url.type# #words[68]#</font>&nbsp;<input type="text" name="custno1" id="custno1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFieldTrade'),'findRefnoAjax.cfm?type=#url.type#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value);"  />&nbsp;&nbsp;#words[1303]#:&nbsp;
    <input type="text" name="custname1" id="custname1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFieldTrade'),'findRefnoAjax.cfm?type=#url.type#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value);" />&nbsp;&nbsp;
    <input type="button" name="Searchbtn" value="#words[1276]#" >
    <div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....
    </div>
    </div>
    
    <div id="ajaxFieldTrade">
    <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">#words[1087]# #url.type#</font></th>
    <th width="300px">#words[1303]#</th>
    <th width="80px">#words[2064]#</th>
    <th width="80px">#words[10]#</th>
    </tr>
    <cfloop query="getcustsupp" >
    <tr>
    <td>#getcustsupp.refno#</td>
    <td>#getcustsupp.van#</td>
    <td>#getcustsupp.rem41#</td>
    <td>

    <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="javascript:ColdFusion.Window.hide('findRefno');exchangereceipt('#getcustsupp.refno#');"><u>#words[965]#</u></a>
   
   

    </td>
    </tr>
    </cfloop>
    
    </table>
    </div>
    </cfoutput>