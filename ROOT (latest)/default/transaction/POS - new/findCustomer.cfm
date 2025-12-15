
<cfoutput>
<cfset tran = url.type >
<cfif tran eq "rc" or tran eq "pr" or tran eq "po">
<cfset url.dbtype = target_apvend>
<cfset nametype = "Supp">
<cfelse>
<cfset url.dbtype = target_arcust>
<cfset nametype = "Cust">
</cfif>
	<cfquery name="getcustsupp" datasource="#dts#">
   		select custno as xcustno,name from #url.dbtype# <cfif isdefined('url.custno')>WHERE custno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.custno#%"></cfif> limit 15
	</cfquery>
    <font style="text-transform:uppercase">#nametype# NO.</font>&nbsp;<input type="text" name="custno1" size="8" id="custno1" onfocus="clearTimeout(t1);clearTimeout(t11);" <!--- onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax.cfm?type=#url.type#&dbtype=#url.dbtype#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);" ---> onkeyup="if(event.keyCode==9 || event.keyCode==13){document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax.cfm?type=#url.type#&dbtype=#url.dbtype#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);if(event.keyCode==13){document.getElementById('custname2').focus();}} else if (event.keyCode==40){document.getElementById('b1').focus()} " <cfif isdefined('url.custno')>value="#url.custno#"</cfif>  />
    &nbsp;LEFT NAME:&nbsp;
    <input type="text" name="custname2" id="custname2" onfocus="clearTimeout(t1);clearTimeout(t11);" <!--- onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax.cfm?type=#url.type#&amp;dbtype=#url.dbtype#&amp;custno='+document.getElementById('custno1').value+'&amp;custname='+document.getElementById('custname1').value+'&amp;leftcustname='+document.getElementById('custname2').value);" ---> onkeyup="if(event.keyCode==9 || event.keyCode==13){document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax.cfm?type=#url.type#&dbtype=#url.dbtype#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);if(event.keyCode==13){document.getElementById('custname1').focus();}} else if (event.keyCode==40){document.getElementById('b1').focus()}" size="12" />
    &nbsp;MID NAME:&nbsp;<input type="text" name="custname1" id="custname1" onfocus="clearTimeout(t1);clearTimeout(t11);" <!--- onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax.cfm?type=#url.type#&dbtype=#url.dbtype#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);" ---> size="12" onkeyup="if(event.keyCode==9 || event.keyCode==13){document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax.cfm?type=#url.type#&dbtype=#url.dbtype#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);if(event.keyCode==13){document.getElementById('Searchbtn').focus();}}  else if (event.keyCode==40){document.getElementById('b1').focus()}" />&nbsp;&nbsp;
<input type="button" name="Searchbtn" id="Searchbtn" value="Go" onclick="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxField'),'findCustomerAjax.cfm?type=#url.type#&dbtype=#url.dbtype#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value+'&leftcustname='+document.getElementById('custname2').value);" >
    <div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....    </div>
    </div>
    <div id="ajaxField" name="ajaxField">
    <table width="480px">
    <tr>
    <th width="100px"><font style="text-transform:uppercase">#url.type# NO</font></th>
    <th width="400px">NAME</th>
   <cfif lcase(hcomid) neq "acht_i"> <th width="80px">ACTION</th></cfif>
    </tr>
    <cfloop query="getcustsupp" >
    <tr id="t#getcustsupp.currentrow#" onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';" <cfif lcase(hcomid) eq "acht_i">onClick="document.getElementById('custno').value = '#getcustsupp.xcustno#';updateDetails('#getcustsupp.xcustno#');ColdFusion.Window.hide('findCustomer');"</cfif>>
    <td>#getcustsupp.xcustno#</td>
    <td>#getcustsupp.name#</td>
    <cfif lcase(hcomid) neq "acht_i">
    <td><input name="b#getcustsupp.currentrow#" id="b#getcustsupp.currentrow#" type="button" style="background:none; border:none; cursor:pointer;" onClick="document.getElementById('custno').value = '#getcustsupp.xcustno#';updateDetails('#getcustsupp.xcustno#');document.getElementById('wos_date').focus();ColdFusion.Window.hide('findCustomer');" value="SELECT" onfocus="document.getElementById('t#getcustsupp.currentrow#').bgColor='##CCCCCC'" onblur="document.getElementById('t#getcustsupp.currentrow#').bgColor='##FFFFFF'" onkeyup="<cfif getcustsupp.currentrow neq getcustsupp.recordcount>if(event.keyCode==40){document.getElementById('b#val(getcustsupp.currentrow)+1#').focus()}</cfif> <cfif getcustsupp.currentrow neq 1>if(event.keyCode==38){document.getElementById('b#val(getcustsupp.currentrow)-1#').focus()}<cfelse>if(event.keyCode==38){document.getElementById('custno1').focus()}</cfif> "></td></cfif>
    </tr>
    </cfloop>
    </table>
    </div>
    </cfoutput>
