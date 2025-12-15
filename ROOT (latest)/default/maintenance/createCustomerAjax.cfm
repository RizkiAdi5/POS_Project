<cfsetting showdebugoutput="no">
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
  select agent from icagent
</cfquery>

<cfquery name="getarea" datasource="#dts#">
  select * from icarea
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
	SELECT * FROM refnoset WHERE type = "cust"
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
alert("Autogenerate customer number fail, please check the last used no whether the entry is correct");

	function displayrate()
	{
		if(document.getElementById('currcode').value !=""){
			<cfoutput query ="showall">
			if(document.getElementById('currcode').value == "#showall.currcode#")
			{
				document.getElementById('currency').value = "#showall.currency#";
				document.getElementById('currency1').value = "#showall.currency1#";
			}
			</cfoutput>
		}else{
			document.getElementById('currency').value = "";
			document.getElementById('currency1').value = "";
		}
	}
	function chgtx() {
		document.getElementById('GSTNO').disabled = document.getElementById('ngst_cust').checked;
	}

	function checkcustno()
	{
		var custnoStatus = document.getElementById('cust_noApproval').value;

		if (custnoStatus == 1)
		{
		document.CreateCustomer.SubmitButton.disabled = false;
		}
		else
		{
		document.CreateCustomer.SubmitButton.disabled = true;
		}
	}

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


<cfform name="CreateCustomer" id="CreateCustomer" method="post" action="/default/maintenance/createCustomerAjaxProcess.cfm">
<table width="1000px" style="font-size:-2">
<tr>
<th width="200px" align="left">Customer No.</th>
<td>

<cfset inputvalue1=left(getgsetup.dfcustcode,4)>
<cfset inputvalue2 = "">
<cfif getrefno.refnoused eq 1>
<cfset inputvalue1 = "#getrefno.refnocode#">
<cfset inputvalue2 = "#newnextNum#">
<cfset nextcustno = "#getrefno.refnocode#"&"#newnextNum#">
</cfif>

<cfif getgsetup.custSuppno eq "1">
<cfoutput>
<cfinput type="text" size="4" name="s_prefix" id="s_prefix" maxlength="4"  value="#inputvalue1#" onvalidate="test_prefix"  onChange="javascript:this.value=this.value.toUpperCase();" message="-Please enter a value greater than or equal to #getgsetup.debtorfr# and less than or equal to #getgsetup.debtorto# in to Customer No prefix field" required="yes" tabindex="1">
/
<cfinput type="text" size="3" name="s_suffix" id="s_suffix" value="#inputvalue2#" maxlength="3" onChange="javascript:this.value=this.value.toUpperCase();" onvalidate="test_suffix"   tabindex="2" required="yes" message="-Please enter at least 3 characters in the Customer No Suffixfield. and can not be 000" onKeyUp="ajaxFunction(document.getElementById('ajaxField'),'/default/maintenance/customerAjax.cfm?prefix='+document.getElementById('s_prefix').value+'&suffix='+document.getElementById('s_suffix').value);" onBlur="ajaxFunction(document.getElementById('ajaxField'),'/default/maintenance/customerAjax.cfm?prefix='+document.getElementById('s_prefix').value+'&suffix='+document.getElementById('s_suffix').value);checkcustno();" ><input type="hidden" name="nexcustno" id="nexcustno" value="#getgsetup.custSuppNo#" ></cfoutput>
<div id="ajaxField" name="ajaxField">
</div>

<cfelse>
<cfoutput>
<input type="text" size="15" name="custno" value="<cfif getrefno.refnoused eq 1>#nextcustno#</cfif>" maxlength="8"><input type="hidden" name="nexcustno" id="nexcustno" value="#getgsetup.custSuppNo#" >
</cfoutput>
</cfif>
<cfoutput><input type="hidden" name="custsuppdropdown" value="#getGsetup.suppcustdropdown#" /></cfoutput>
<cfoutput>
<br />
<b><u>Last 5 Record</u></b>
<cfquery name="getlast5" datasource="#dts#">
select custno from #target_arcust# order by created_on desc limit 5
</cfquery>
<cfloop query="getlast5">
<br />#getlast5.custno#
</cfloop>
</cfoutput>
</td>
<th align="right">
UEN
</th>
<td>
<cfinput type="text" name="comuen" id="comuen" maxlength="11" >
</td>
</tr>
<tr>
<th align="left">Name</th>
<td width="400px"><cfinput type="text" name="name" id="name" required="yes" size="50" tabindex="3" message="-Customer name is required" maxlength="40"></td>
<th align="right">GST No.</th>
<td ><cfinput type="text" name="GSTNO" id="GSTNO" disabled="disabled" />&nbsp;&nbsp;<cfinput type="checkbox" name="ngst_cust" id="ngst_cust" value="T" checked="yes" onChange="chgtx()" > Non GST Customer</td>
</tr>
<tr>
<th></th>
<td><cfinput type="text" name="name2" id="name2" size="50"  tabindex="4" maxlength="40"></td>

<td width="70px" align="right"><cfinput type="checkbox" name="OIC" id="OIC" checked="yes"></td>
<td width="330px">Open Item Customer
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfinput type="checkbox" name="badStatus" id="badStatus" checked="no"> Bad Status
</td>
</tr>
</table>
<cflayout type="tab"  tabHeight="300" >
<cflayoutarea name="Details" title="Details">
            <table width="1000px" height>
            <tr>
            <th width="190px" align="left">Invoice / Delivery To</th>
            <td width="400px"><cfinput type="text" name="add1" id="add1" size="50" onBlur="JavaScript: document.getElementById('Dadd1').value=document.getElementById('add1').value" tabindex="5" maxlength="35"></td>
            <td width="30px">&nbsp;</td>
            <td colspan="2" ><cfinput type="text" name="Dadd1" id="Dadd1" size="50" tabindex="10" maxlength="35"></td>
            </tr>
            <tr>
            <th>&nbsp;</th>
            <td><cfinput type="text" name="add2" id="add2" size="50" onBlur="JavaScript: document.getElementById('Dadd2').value=document.getElementById('add2').value" tabindex="6" maxlength="35"></td>
            <td>&nbsp;</td>
            <td colspan="2"><cfinput type="text" name="Dadd2" id="Dadd2" size="50" tabindex="11" maxlength="35"></td>
            </tr>
               <tr>
            <th>&nbsp;</th>
            <td><cfinput type="text" name="add3" id="add3" size="50" onBlur="JavaScript: document.getElementById('Dadd3').value=document.getElementById('add3').value" tabindex="7" maxlength="35"></td>
            <td>&nbsp;</td>
            <td colspan="2"><cfinput type="text" name="Dadd3" id="Dadd3" size="50" tabindex="12" maxlength="35"></td>
            </tr>
               <tr>
            <th>&nbsp;</th>
            <td><cfinput type="text" name="add4" id="add4" size="50" onBlur="JavaScript: document.getElementById('Dadd4').value=document.getElementById('add4').value" tabindex="8" maxlength="35"></td>
            <td>&nbsp;</td>
            <td colspan="2"><cfinput type="text" name="Dadd4" id="Dadd4" size="50" tabindex="13" maxlength="35"></td>
            </tr>
               <tr>
            <th align="left">Attention</th>
            <td><cfinput type="text" name="attn" id="attn" size="50" onBlur="JavaScript: document.getElementById('Dattn').value=document.getElementById('attn').value" tabindex="9" maxlength="35"></td>
            <td>&nbsp;</td>
            <td colspan="2"><cfinput type="text" name="Dattn" id="Dattn" size="50" tabindex="15" maxlength="35"></td>
            </tr>
            <tr>
            <td colspan="5"><hr /></td>
            </tr>
            <tr>
            <th align="left">Postal Code</th>
            <td><cfinput type="text" name="postalcode" id="postalcode" size="30" ></td>
            <td>&nbsp;</td>
            <th width="120px" align="left">Country</th>
            <td width="280px">
            <cfinput type="text" name="country" id="country" size="30" ></td>
            </tr>
            <tr>
            <th align="left">Email Address</th>
            <td><cfinput type="text" name="e_mail" id="e_mail" size="50" ></td>
            <td>&nbsp;</td>
            <th width="120px" align="left">Terms</th>
            <td width="280px">
            <cfselect name="term" id="term">
            <option value="">Choose a Terms</option>
            <cfoutput query="getterm">
            <option value="#getterm.term#">#getterm.term#</option>
			</cfoutput>            </cfselect>            </td>
            </tr>
            <tr>
            <th align="left">Web Site</th>
            <td><cfinput type="text" name="web_site" id="web_site" size="50" ></td>
            <td>&nbsp;</td>
            <th>Credit Limit</th>
            <td><cfinput type="text" name="crlimit" id="crlimit" size="20" value="0.00" ></td>
            </tr>
            <tr>
              <th align="left">Phone No.(1)</th>
              <td><cfinput type="text" name="phone" id="phone" size="20" /></td>
              <td>&nbsp;</td>
              <th>Target</th>
              <td><cfinput type="text" name="target" id="target" size="20" value="0.00" /></td>
            </tr>
            <tr>
              <th align="left">Phone No.(2)</th>
              <td><cfinput type="text" name="phonea" id="phonea" size="20" /></td>
              <td>&nbsp;</td>
              <th>Invoice Limit</th>
              <td><cfinput type="text" name="invLimit" id="invLimit" size="20" value="0.00" /></td>
            </tr>
            <tr>
              <th align="left">Fax/Telex</th>
              <td><cfinput type="text" name="Fax" id="Fax" size="20" /></td>
              <td>&nbsp;</td>
              <th>Group To</th>
              <td><cfoutput><cfinput type="text" name="groupto" id="groupto" size="20" value="#getgsetup.debtorfr#/000"  /></cfoutput></td>
            </tr>
            <tr>
            <cfoutput>
              <th align="left">Contact</th>
              <td><cfinput type="text" name="contact" id="contact" size="20" /></td>
              <td>&nbsp;</td>
              <th>Created Date</th>
              <td><cfinput type="text" name="date" id="date" size="30" value="#dateformat(now(),'dd/mm/yyyy')# #timeformat(now(),'hh:mm:ss tt')#" ></td>
            </cfoutput>            </tr>
            <tr>
              <th align="left">Business</th>
              <td>
              <cfselect name="business" id="business" >
              <option value="">Choose a Business</option>
              <cfoutput query="getbusiness">
              <option value="#getbusiness.business#">#getbusiness.Desp#</option>
			  </cfoutput>              </cfselect></td>
              <td>&nbsp;</td>
              <th>Currency Code</th>
              <td><select name="currcode" id="currcode" onChange="javascript:displayrate()">
				<option value="">Choose a Currency</option>
				<cfoutput query="showall">
					<option value="#showall.CurrCode#" <cfif showall.currcode eq '#currcode1#'>selected</cfif>>#showall.currcode# - #showall.Currency#</option>
				</cfoutput>
			</select></td>
            </tr>
            <tr>
              <th align="left">Area</th>
              <td>
              <cfselect name="area" id="area">
              <option value="">Choose an area</option>
              <cfoutput query="getarea" >
              <option value="#getarea.Area#" >#getarea.desp#</option>
              </cfoutput>
              </cfselect></td>
              <td></td>
              <th>Currency</th>
			  <td><cfoutput><input type="text" size="40" name="currency" id="currency" value="#getcurrcode.currency#" maxlength="10"></cfoutput></td>

            </tr>
            <tr>
              <th align="left">Agent</th>
              <td>
              <cfselect name="agent" id="agent" >
              <option value="">Choose an agent</option>
              <cfoutput query="getagent">
              <option value="#getagent.agent#">#getagent.agent#</option>
			  </cfoutput>
              </cfselect></td>
              <td></td>
              <th>Currency Dollar</th>
			  <td><cfoutput><input type="text" size="40" name="currency1" id="currency1" value="#getcurrcode.currency1#" maxlength="17"></cfoutput></td>
            </tr>
            </table>
</cflayoutarea>
<cflayoutarea name="moreinfo" title="More Info">
    <table width="1000px">
    <!--- <tr>
      <th width="200px" align="left">Gst No.</th>
    <td width="150px"><input type="text" name="GSTNO" id="GSTNO"  /> </td>
    <td width="250px"><cfinput type="checkbox" name="ngst_cust" id="ngst_cust" value="T" checked="yes" > Non GST Customer</td>
    <td width="30px">&nbsp;</td>
    <td width="150px" align="left">&nbsp;</td>
    <td width="220px">&nbsp;</td>
    </tr> --->
    <tr >
      <th align="left">Customer Type</th>
      <td><cfinput type="text" name="cust_type" id="cust_type" size="3" maxlength="3"></td>
      <td><cfinput type="checkbox" name="account_status" id="account_status" value="T" checked="yes" > Account Status Active</td>
      <td>&nbsp;</td>
      <th align="left">Customer Group</th>
      <td><cfinput type="text" name="ct_Group" id="ct_Group" maxlength="8" size="8"></td>
    <tr>
      <th align="left">Remark 1</th>
      <td colspan="2"><cfinput type="text" name="arrem1" id="arrem1" size="50" ></td>
      <td>&nbsp;</td>
      <th align="left">Term In Month</th>
      <td><cfinput type="text" name="termInMonth" id="termInMonth" size="3" maxlength="2" value="0"></td>
      </tr>
    <tr>
      <th align="left">Remark 2</th>
      <td colspan="2"><cfinput type="text" name="arrem2" id="arrem2" size="50" ></td>
      <td>&nbsp;</td>
      <th align="left">Channel</th>
      <td><cfinput type="text" name="channel" id="channel" size="40" ></td>
    </tr>
    <tr>
      <th align="left">Remark 3</th>
      <td colspan="2"><cfinput type="text" name="arrem3" id="arrem3" size="50" ></td>
      <td>&nbsp;</td>
      <th align="left">Class Code</th>
      <td><cfinput type="text" name="classCode" id="classCode" size="50" ></td>
    </tr>
    <tr>
      <th align="left">Remark 4</th>
      <td colspan="2"><cfinput type="text" name="arrem4" id="arrem4" size="50" ></td>
      <td>&nbsp;</td>
      <th align="left">Site Name</th>
      <td><cfinput type="text" name="siteName" id="siteName" size="50" ></td>
    </tr>
    <tr>
      <th align="left">Bank Account No</th>
      <td colspan="2"><cfinput type="text" name="bankAccno" id="bankAccno" size="50" ></td>
      <td>&nbsp;</td>
      <th align="left">Site Address 1</th>
      <td><cfinput type="text" name="siteAdd1" id="siteAdd1" size="50" ></td>
    </tr>
    <tr>
      <th align="left">Mode of Delivery</th>
      <td colspan="2"><cfinput name="mod_Del" id="mod_Del" size="3" maxlength="2" > (ML/CR/RT/AR)</td>
      <td>&nbsp;</td>
      <th align="left">Site Address 2</th>
      <td><cfinput type="text" name="siteAdd2" id="siteAdd2" size="50" ></td>
    </tr>
    <tr>
      <th align="left">Team Exceed (Y/N)</th>
      <td colspan="2"><cfinput type="checkbox" name="termExceed" id="termExceed" ></td>
      <td>&nbsp;</td>
      <th align="left">Provision Discount</th>
      <td><cfinput type="text" name="proDis" id="proDis" size="7" validate="float"   value="0.00" ></td>
    </tr>
    <tr>
      <th align="left">Credit Sales Code</th>
      <td colspan="2"><cfinput type="text" name="salec" id="salec" size="10" maxlength="8" ></td>
      <td>&nbsp;</td>
      <th align="left">Invoice Discount</th>
      <td><cfinput type="text" name="invDis" id="invDis" size="7" validate="float"   value="0.00" /></td>
    </tr>
    <tr>
      <th align="left">Sales Return Code</th>
      <td colspan="2"><cfinput type="text" name="salecnc" id="salecnc" size="10" maxlength="8" ></td>
      <td>&nbsp;</td>
      <td align="left" rowspan="5" >
      <cfinput type="radio" name="lc_ex" value="0" checked="yes" > Local Customer <br />
       <cfinput type="radio" name="lc_ex" value="1" > Export Customer      </td>
       <td rowspan="5">Discount % Category<br/>
              <input type="radio" name="dispec_cat" id="dispec_cat" value="A"  /> Category A <br />
              <input type="radio" name="dispec_cat" id="dispec_cat" value="B"  /> Category B <br />
              <input type="radio" name="dispec_cat" id="dispec_cat" value="C"  /> Category C <br />
              <input type="radio" name="dispec_cat" id="dispec_cat" value="" checked="checked"  /> None <br /></td>
    </tr>
       <tr>
      <th align="left">Credit Approval Ref</th>
      <td colspan="2"><cfinput type="text" name="creApproRef" id="creApproRef" size="40"></td>
      <td>&nbsp;</td>
      </tr>
      <tr>
      <th align="left">Credit Approval Date</th>
      <td colspan="2"><cfinput name="creApproDate" id="creApproDate" type="text" value=""> <img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(creApproDate);"></td>
      <td>&nbsp;</td>
      </tr>

      <tr>
      <th align="left">Collateral</th>
      <td colspan="2"><cfinput type="text" name="collateral" id="collateral" size="40"></td>
      <td>&nbsp;</td>
      </tr>

      <tr>
      <th align="left">Guarantor</th>
      <td colspan="2"><cfinput type="text" name="guarantor" id="guarantor" size="40"></td>
      <td>&nbsp;</td>
      </tr>
    </table>
</cflayoutarea>
</cflayout>

<cfinput name="SubmitButton" id="SubmitButton" type="submit" value="Submit"/>
</cfform>

