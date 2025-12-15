<html>
<head>
<title>Print Label</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="javascript">
function checkbox(n){
	document.getElementById("envelope").disabled=true;
	document.getElementById("perpage").disabled=true;
	if(document.getElementById(n).checked){
		document.getElementById(n).disabled=false;
	}else{
		document.getElementById("envelope").disabled=false;
		document.getElementById("perpage").disabled=false;
	}
}
</script>
</head>

<body>

<cfquery name="getgeneral" datasource="#dts#">
select agentlistuserid from gsetup
</cfquery>

<cfset target_table = iif(url.type eq "customer",DE(target_arcust),DE(target_apvend))>

<cfif isdefined("form.submit")>
	<cfquery name="getresult" datasource="#dts#">
		select custno as customerno,<cfif isdefined("form.code")>('1')<cfelse>('0')</cfif> as printcustomerno,
		name,name2,add1,add2,add3,add4,postalcode,country,<cfif isdefined("form.address")>'1'<cfelse>'0'</cfif> as printaddress,
		attn,<cfif isdefined("form.attention")>('1')<cfelse>('0')</cfif> as printattn,<cfif isdefined("form.postalcode")>('1')<cfelse>('0')</cfif> as printpostalcode,<cfif isdefined("form.country")>('1')<cfelse>('0')</cfif> as printcountry
		from #target_table# where custno <>''
		<cfif form.customernofrom neq "" and form.customernoto neq "">
		and custno between '#form.customernofrom#' and '#form.customernoto#'
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
		and area between '#form.areafrom#' and '#form.areato#'
		</cfif>
		<cfif form.agentfrom neq "" and form.agentto neq "">
		and agent between '#form.agentfrom#' and '#form.agentto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and date between '#form.datefrom#' and '#form.dateto#'
		</cfif>
		order by custno
	</cfquery>
	
	<cfswitch expression='#isdefined("form.envelope")#'>
		<cfcase value="YES">
        <cfif lcase(HcomID) eq "winbells_i">
			<cfreport template="PrintLabelEnvelope2.cfr" format="PDF" query="getresult" report="PrintLabelEnvelope2.cfr">
	  			<cfreportparam name='dts' value='#dts#'>
    		</cfreport>
            <cfelseif lcase(HcomID) eq "hfi_i">
             <cfreport template="PrintLabelEnvelope3.cfr" format="PDF" query="getresult" report="PrintLabelEnvelope3.cfr">
	  			<cfreportparam name='dts' value='#dts#'>
    		</cfreport>
            <cfelse>

            <cfreport template="PrintLabelEnvelope.cfr" format="PDF" query="getresult" report="PrintLabelEnvelope.cfr">
	  			<cfreportparam name='dts' value='#dts#'>
    		</cfreport>
            </cfif>
		</cfcase>
		<cfcase value="NO">
			<cfif isdefined("form.perpage")>
				<cfreport template="PrintLabelA4_perpage.cfr" format="PDF" query="getresult" report="PrintLabelA4_perpage.cfr">
	  				<cfreportparam name='dts' value='#dts#'>
    			</cfreport>
			<cfelse>
            	<cfif lcase(HcomID) eq "winbells_i">
				<cfreport template="PrintLabelA42.cfr" format="PDF" query="getresult" report="PrintLabelA42.cfr">
	  				<cfreportparam name='dts' value='#dts#'>
    			</cfreport>
                <cfelseif lcase(HcomID) eq "hfi_i">
                <cfreport template="PrintLabelA43.cfr" format="PDF" query="getresult" report="PrintLabelA43.cfr">
	  				<cfreportparam name='dts' value='#dts#'>
    			</cfreport>
                <cfelseif lcase(HcomID) eq "sinlian_i">
                <cfreport template="PrintLabelA44.cfr" format="PDF" query="getresult" report="PrintLabelA44.cfr">
	  				<cfreportparam name='dts' value='#dts#'>
    			</cfreport>
                <cfelse>
                <cfreport template="PrintLabelA4.cfr" format="PDF" query="getresult" report="PrintLabelA4.cfr">
	  				<cfreportparam name='dts' value='#dts#'>
    			</cfreport>
                </cfif>
			</cfif>
		</cfcase>
	</cfswitch>
<cfelse>
	<!--- Add On 13-01-2010 --->
	<cfquery name="getdealer_menu" datasource="#dts#">
		select custSuppSortBy,productSortBy from dealer_menu limit 1
	</cfquery>
	
	<!--- <cfquery name="getcustomerno" datasource="#dts#">
		select custno,name from #target_table# order by custno
	</cfquery> --->
	<cfquery name="getcustomerno" datasource="#dts#">
		select custno,name from #target_table# where 0=0
        <cfif url.type eq "Customer" and getpin2.h1t00 eq 'T'>
<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agent)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
                    </cfif>
         order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
	</cfquery>

	<cfquery name="getarea" datasource="#dts#">
		select area,desp from icarea order by area
	</cfquery>

	<cfoutput>
	<h2 align="center">Print #url.type# Labels</h2>

	<cfform name="printlabel" action="printlabel.cfm?type=#url.type#" method="post" target="_blank">
	<table width="75%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
		<tr>
			<th>Label Format</th>
			<td><input type="checkbox" name="code" value="yes" checked>With Code No<br/>
				<input type="checkbox" name="attention" value="yes">With Attention<br/>
				<input type="checkbox" name="address" value="yes">With Address<br/>
                <input type="checkbox" name="postalcode" value="yes">With Postal Code<br/>
                <input type="checkbox" name="country" value="yes">With Country<br/>
				<input type="checkbox" name="envelope" value="yes" onClick="checkbox(this.name)">Envelope<br/>
				<input type="checkbox" name="perpage" value="yes" onClick="checkbox(this.name)">1/page<br/>
			</td>
		</tr>
		<tr>
        	<td colspan="4"><hr></td>
    	</tr>
		<tr>
			<th>#url.type# From</th>
			<td><select name="customernofrom">
					<option value="">Choose an #url.type#</option>
					<cfloop query="getcustomerno">
						<option value="#custno#">#custno# - #name#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<th>#url.type# To</th>
			<td><select name="customernoto">
					<option value="">Choose an #url.type#</option>
					<cfloop query="getcustomerno">
						<option value="#custno#">#custno# - #name#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
        	<td colspan="4"><hr></td>
    	</tr>
		<tr>
    	    <th>Area From</th>
        	<td><select name="areafrom">
					<option value="">Choose an Area</option>
					<cfloop query="getarea">
						<option value="#area#">#area# - #desp#</option>
					</cfloop>
				</select>
			</td>
    	</tr>
    	<tr>
        	<th>Area To</th>
        	<td><select name="areato">
					<option value="">Choose an Area</option>
					<cfloop query="getarea">
						<option value="#area#">#area# - #desp#</option>
					</cfloop>
				</select>
			</td>
    	</tr>
    	<tr>
        	<td colspan="4"><hr></td>
   	 	</tr>
		<tr>
    		<th>Agent From</th>
        	<td><select name="agentfrom">
				<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super'>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agent = '#HUserID#'
					</cfquery>
					<option value="#getagent.agent#">#getagent.agent#-#getagent.desp#</option>
				<cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent order by agent
					</cfquery>
					<option value="">Choose an Agent</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
				</cfif>
				</select>
			</td>
    	</tr>
    	<tr>
        	<th>Agent To</th>
        	<td><select name="agentto">
				<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super'>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent where agent = '#HUserID#'
					</cfquery>
					<option value="#getagent.agent#">#getagent.agent#-#getagent.desp#</option>
				<cfelse>
					<cfquery name="getagent" datasource="#dts#">
						select agent,desp from icagent order by agent
					</cfquery>
					<option value="">Choose an Agent</option>
					<cfloop query="getagent">
					<option value="#getagent.agent#">#getagent.agent# - #getagent.desp#</option>
					</cfloop>
				</cfif>
				</select>
			</td>
    	</tr>

		<tr>
        	<td colspan="4"><hr></td>
    	</tr>
		<tr>
			<th>Date From</th>
			<td><cfinput type="text" name="datefrom" validate="eurodate" message="Invalid Input" maxlength="10" size="10" mask="99/99/9999"> (DD/MM/YYYY)</td>
		</tr>
		<tr>
			<th>Date To</th>
			<td><cfinput type="text" name="dateto" validate="eurodate" message="Invalid Input" maxlength="10" size="10" mask="99/99/9999"> (DD/MM/YYYY)</td>
		</tr>
		<tr>
			<td colspan="2" align="right"><input type="submit" name="Submit" value="Submit"></td>
		</tr>
	</table>
	</cfform>
	</cfoutput>
</cfif>

</body>
</html>