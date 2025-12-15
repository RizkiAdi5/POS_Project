<cfsetting showdebugoutput="yes">
<cfset name = "">
<cfset add1 = "">
<cfset add2 = "">
<cfset add3 = "">
<cfset add4 = "">
<cfset country = "">
<cfset postalcode = "">
<cfset daddr1 = "">
<cfset daddr2 = "">
<cfset daddr3 = "">
<cfset daddr4 = "">
<cfset phone = "">
<cfset email = "">
<cfset website = "">
<cfif isdefined('url.id') and hcomid eq "asiasoft_i">
<cfquery name="getlead" datasource="asiasoft_c">
select leadname,add1,add2,add3,add4,country,postalcode,daddr1,daddr2,daddr3,daddr4,d_country,d_postalcode,phone,email,website from lead
where id = "#url.id#"
</cfquery>
<cfset name = getlead.leadname>
<cfset add1 = getlead.add1>
<cfset add2 = getlead.add2>
<cfset add3 = getlead.add3>
<cfset add4 = getlead.add4>
<cfset country = getlead.country>
<cfset postalcode = getlead.postalcode>
<cfset daddr1 = getlead.daddr1>
<cfset daddr2 = getlead.daddr2>
<cfset daddr3 = getlead.daddr3>
<cfset daddr4 = getlead.daddr4>
<cfset phone = getlead.phone>
<cfset email = getlead.email>
<cfset website = getlead.website>
</cfif>

<cfquery name="getgsetup" datasource="#dts#">
  select * from gsetup
</cfquery>
<cfset currcode1 = getgsetup.bcurr>

<cfquery name="showall" datasource="#dts#">
	select 
	* 
	from #target_currency#;
</cfquery>

<cfquery name="getterm" datasource="#dts#">
  select * from #target_icterm# order by term
</cfquery>

<cfquery name="getbusiness" datasource="#dts#">
  select * from business order by business
</cfquery>

<cfquery name="getagent" datasource="#dts#">
  select agent from #target_icagent#
</cfquery>

<cfquery name="getarea" datasource="#dts#">
  select * from #target_icarea#
</cfquery>

	<cfquery datasource="#dts#" name="getcurrcode">
		select 
		a.bcurr,
		b.currency,
		b.currency1 
		from gsetup as a,#target_currency# as b 
		where b.currcode = a.bcurr;
	</cfquery>
    
   <cfquery name="getrefno" datasource="#dts#">
	SELECT * FROM refnoset WHERE type = "supp"
</cfquery>

<cfif getrefno.refnoused eq 1>
<cfif getrefno.lastusedno eq "">
<cfset oldlastusedno = 0>
<cfelse>
<cfset oldlastusedno = getrefno.lastusedno>
</cfif>

<cftry>
<cfinvoke component="cfc.refno" method="processNum" oldNum="#oldlastusedno#" returnvariable="newnextNum" />
<cfcatch type="any">
<cfset newnextNum = oldlastusedno>
<cfoutput>
<script type="text/javascript">
alert("Autogenerate Supplier number fail, please check the last used no whether the entry is correct");
</script>
</cfoutput>
</cfcatch>
</cftry>

<cfif getgsetup.custSuppno eq "1">
<cfset nextcustno = getrefno.refnocode&"/"&newnextNum>
<cfelse>
<cfset nextcustno = getrefno.refnocode&newnextNum>
</cfif>
</cfif>

<cfform name="CreateSupplier" id="CreateSupplier" method="post" action="/default/maintenance/shellvehicles/CreateSupplierAjaxProcess.cfm"> 
<cfif isdefined('url.id') and hcomid eq "asiasoft_i">
<cfoutput>
<input type="hidden" name="leadid" id="leadid" value="#url.id#" />
</cfoutput>
</cfif>
<cfif isdefined('url.main')>
<cfoutput>
<input type="hidden" name="mainid" id="mainid" value="#url.main#" />
</cfoutput>
</cfif>



<table width="1000px" style="font-size:-2">
<tr>
<th width="200px"><div align="left">Supplier No.</div></th>
<td>

<cfset inputvalue1=left(getgsetup.dfsuppcode,4)>
<cfset inputvalue2 = "">
<cfif getrefno.refnoused eq 1>
<cfset inputvalue1 = "#getrefno.refnocode#">
<cfset inputvalue2 = "#newnextNum#">
<cfset nextsuppno = "#getrefno.refnocode#"&"#newnextNum#">
</cfif>

<cfif getgsetup.custSuppno eq "1">
<cfoutput>
<cfinput type="text" size="4" name="s_prefix" id="s_prefix" maxlength="4"  value="#inputvalue1#" validateat="onblur" onvalidate="test_prefix"  onChange="javascript:this.value=this.value.toUpperCase();" message="-Please enter a value greater than or equal to #getgsetup.creditorfr# and less than or equal to #getgsetup.creditorfr# in to Supplier No prefix field" required="yes" tabindex="1"> 
/
<cfinput type="text" size="3" name="s_suffix" id="s_suffix" value="#inputvalue2#" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();" onvalidate="test_suffix" validateat="onblur" tabindex="2" required="yes" message="-Please enter at least 3 characters in the Supplier No Suffixfield. and can not be 000" onKeyUp="ajaxFunction(document.getElementById('ajaxField'),'/default/maintenance/supplierAjax.cfm?prefix='+document.getElementById('s_prefix').value+'&suffix='+document.getElementById('s_suffix').value);" onBlur="ajaxFunction(document.getElementById('ajaxField'),'/default/maintenance/supplierAjax.cfm?prefix='+document.getElementById('s_prefix').value+'&suffix='+document.getElementById('s_suffix').value);checksuppno();" ><input type="hidden" name="nexsuppno" id="nexsuppno" value="#getgsetup.custSuppNo#" ></cfoutput>
<div id="ajaxField" name="ajaxField">
</div>

<cfelse>
<cfoutput>
<cfif getrefno.refnoused eq 1>
<input type="text" size="15" name="custno" value="#nextsuppno#" maxlength="8" <cfif lcase(hcomid) eq "ltm_i">onkeyup="ajaxFunction(document.getElementById('getlastsuppajax'),'/default/maintenance/shellvehicles/getlastsuppajax.cfm?custno='+document.CreateSupplier.custno.value);" </cfif>>
<cfelse>
<input type="text" size="15" name="custno" value="" maxlength="8" <cfif lcase(hcomid) eq "ltm_i">onkeyup="ajaxFunction(document.getElementById('getlastcustajax'),'/default/maintenance/shellvehicles/getlastcustajax.cfm?custno='+document.CreateSupplier.custno.value);"</cfif>>
</cfif>
<input type="hidden" name="nexcustno" id="nexsuppno" value="#getgsetup.custSuppNo#" >

</cfoutput>
</cfif>
<cfoutput><input type="hidden" name="custsuppdropdown" value="#getGsetup.suppcustdropdown#" /></cfoutput>
<cfif lcase(hcomid) eq "ltm_i">
<div id="getlastsuppajax">
<cfoutput>
<br />
<b><u>Last 5 Record</u></b>
<cfquery name="getlast5" datasource="#dts#">
select custno from #target_apvend# order by created_on desc limit 5
</cfquery>
<cfloop query="getlast5">
<br />#getlast5.custno#
</cfloop>
</cfoutput>
</div>
</cfif>
</td>
</tr>
<tr>
<cfoutput>
<tr>
<th align="left"><div align="left">Created Date</div></th>
              <td><cfinput type="text" name="date" id="date" size="30" value="#dateformat(now(),'dd/mm/yyyy')# #timeformat(now(),'hh:mm:ss tt')#" ></td>
</tr>
</cfoutput>
<th align="left"><div align="left">Name / Company Name *</div></th>
<td width="400px"><cfinput type="text" name="name" id="name" required="yes" size="50" tabindex="3" message="-Supplier name is required" maxlength="40" value="#name#"></td>

</tr>
<tr>
<th></th>
<td><cfinput type="text" name="name2" id="name2" size="50"  tabindex="4" maxlength="40"></td>
</tr>
</table>
            <table width="1000px">
            <tr>
            <th width="190px" align="left"><div align="left">Address</div></th>
            <td width="400px"><cfinput type="text" name="add1" id="add1" size="50" onBlur="JavaScript: document.getElementById('Dadd1').value=document.getElementById('add1').value" tabindex="5" maxlength="35" value="#add1#"></td>
            
            </tr>
            <tr>
            <th>&nbsp;</th>
            <td><cfinput type="text" name="add2" id="add2" size="50" onBlur="JavaScript: document.getElementById('Dadd2').value=document.getElementById('add2').value" tabindex="6" maxlength="35" value="#add2#"></td>
           
            </tr>
               <tr>
            <th>&nbsp;</th>
            <td><cfinput type="text" name="add3" id="add3" size="50" onBlur="JavaScript: document.getElementById('Dadd3').value=document.getElementById('add3').value" tabindex="7" maxlength="35" value="#add3#"></td>
            
            </tr>
               <tr>
            <th>&nbsp;</th>
            <td><cfinput type="text" name="add4" id="add4" size="50" onBlur="JavaScript: document.getElementById('Dadd4').value=document.getElementById('add4').value" tabindex="8" maxlength="35" value="#add4#"></td>
           
            </tr>
               <tr>
            <th align="left"><div align="left">Attention*</div></th>
            <td><select name="arrem3" id="arrem3" onchange="selectlist(this.value,'arrem2')">
    			<option value="Mr">Mr</option>
    			<option value="Mrs">Mrs</option>
    			<option value="Ms">Ms</option>
    			</select>
    <cfinput type="text" name="attn" id="attn" size="50" onBlur="JavaScript: document.getElementById('Dattn').value=document.getElementById('attn').value" tabindex="9" maxlength="35" required="yes" message="-Attention is required"></td>
            
            </tr>
            <tr>
            <td colspan="5"><hr /></td>
            </tr>
            <tr>
            <th align="left"><div align="left">Postal Code</div></th>
            <td><cfinput type="text" name="postalcode" id="postalcode" size="30" value="#postalcode#" ></td>

            
            </tr>
            <tr>
            <th align="left"><div align="left">Email Address</div></th>
            <td><cfinput type="text" name="e_mail" id="e_mail" size="50" value="#email#" ></td>

           
            </tr>
            <tr>
            <th align="left"><div align="left">Web Site</div></th>
            <td><cfinput type="text" name="web_site" id="web_site" size="50"  value="#website#"></td>
           
            </tr>
            <tr>
              <th align="left"><div align="left">Contact No*</div></th>
              <td><cfinput type="text" name="phone" id="phone" size="20" /></td>
             
            </tr>
            <tr>
              <th align="left"><div align="left">Hp</div></th>
              <td><cfinput type="text" name="phonea" id="phonea" size="20" /></td>
             
            </tr>
            <tr>
              <th align="left"><div align="left">Fax/Telex</div></th>
              <td><cfinput type="text" name="Fax" id="Fax" size="20" /></td>
              
            </tr>
            <tr style="display:none">
            <cfoutput>
              <th align="left"><div align="left"></div></th>
              <td><cfinput type="hidden" name="contact" id="contact" size="20" /></td>
             
            </cfoutput>            </tr>
            <tr>
              <th align="left"><div align="left">Member ID</div></th>
      <td colspan="2"><cfinput type="text" name="arrem1" id="arrem1" size="50" ></td>
             
            </tr>
            <tr>
              
      		<th align="left"><div align="left">Gender</div></th>
      <td colspan="2"><select name="arrem2" id="arrem2">
      <option value="male">Male</option>
      <option value="female">Female</option>
      <option value="corporate">Corporate</option>
      </select>
      </td>
           
            </tr>
            
            <tr <cfif lcase(hcomid) neq "ltm_i">style="none"</cfif>>
              <th align="left">Agent</th>
              <td>
              <cfselect name="agent" id="agent" >
              <option value="">Choose an agent</option>
              <cfoutput query="getagent">
              <option value="#getagent.agent#">#getagent.agent#</option>
			  </cfoutput>
              </cfselect></td>
              <td></td>
            </tr>
            
            </table>

<cfinput name="SubmitButton" id="SubmitButton" type="submit" value="Submit"/>
</cfform>	
