<html>
<head>
<title>View <cfif lcase(hcomid) eq "mhca_i">Marketer<cfelse>Location</cfif></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<script language='JavaScript'>
	function validate()
	{
		if(document.CustomerForm.location.value=='') 
		{
			if(document.CustomerForm.com_id.value == 'mhca_i'){
				var title2= "Marketer";
			}else{
				var title2= "Location";
			}
			//alert("Your Location cannot be blank.");
			alert("Your "+title2+" cannot be blank.");
			document.CustomerForm.location.focus();
			return false;
		}
		return true;
	}
</script>

<!--- ADD ON 15-07-2009 --->
<cfquery name="getGsetup" datasource="#dts#">
  Select lLOCATION from GSetup
</cfquery>	

<cfquery name="getcust" datasource="#dts#">
	select custno,name from #target_arcust# where status<>'B' order by custno;
</cfquery>

<body onLoad="<cfif url.type neq "Edit">document.CustomerForm.location.focus()<cfelse>document.CustomerForm.desp.focus()</cfif>">

<cfoutput>
	<cfif url.type eq "Edit">
		<cfif isdefined("CFGRIDKEY")>
			<cfset thislocation=CFGRIDKEY>
		<cfelse>
			<cfset thislocation=url.location>
		</cfif>
	
		<cfquery datasource='#dts#' name="getitem">
			Select * from iclocation where location='#thislocation#'
		</cfquery>
		
		<cfset LOCATION=getitem.location>
		<cfset desp=getitem.desp>
		<cfset ADDR1=getitem.addr1>
		<cfset ADDR2=getitem.addr2>
		<cfset ADDR3=getitem.addr3>
		<cfset ADDR4=getitem.addr4>
		<cfset OUTLET=getitem.outlet>
		<cfset customerno=getitem.custno>
		<cfset mode="Edit">
		<cfset title="Edit #getGsetup.lLOCATION#">
		<cfset button="Edit">
		
		<!--- Add On 071008, Add Currency To Location --->
		<cfif lcase(HcomID) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
			<cfset currcode1 = getitem.currcode>
			<cfset foreign = getitem.foreignloc>
		</cfif>					
	</cfif>
	
	<cfif url.type eq "Delete">
		<cfif isdefined("CFGRIDKEY")>
			<cfset thislocation=CFGRIDKEY>
		<cfelse>
			<cfset thislocation=url.location>
		</cfif>
		<cfquery datasource='#dts#' name="getitem">
			Select * from iclocation where location='#thislocation#'
		</cfquery>
		
		<cfset LOCATION=getitem.location>
		<cfset desp=getitem.desp>
		<cfset ADDR1=getitem.addr1>
		<cfset ADDR2=getitem.addr2>
		<cfset ADDR3=getitem.addr3>
		<cfset ADDR4=getitem.addr4>
		<cfset OUTLET=getitem.outlet>
		<cfset customerno=getitem.custno>
		<cfset mode="Delete">
		<cfset title="Delete #getGsetup.lLOCATION#">
		<cfset button="Delete">	
		
		<!--- Add On 071008, Add Currency To Location --->
		<cfif lcase(HcomID) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
			<cfset currcode1 = getitem.currcode>
			<cfset foreign = getitem.foreignloc>
		</cfif>	
	</cfif>	
	
	<cfif url.type eq "Create">
		<cfset LOCATION="">
		<cfset desp="">
		<cfset ADDR1="">
		<cfset ADDR2="">
		<cfset ADDR3="">
		<cfset ADDR4="">
		<cfset OUTLET="">
		<cfset customerno="">			
		<cfset mode="Create">
		<cfset title="Create #getGsetup.lLOCATION#">
		<cfset button="Create">	
		<!--- Add On 071008, Add Currency To Location --->
		<cfif lcase(HcomID) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
			<cfquery datasource="#dts#" name="getcurrcode">
				select 
				a.bcurr,b.currency,b.currrate
				from gsetup as a,#target_currency# as b 
				where b.currcode = a.bcurr
			</cfquery>
	
			<cfif getcurrcode.recordcount neq 0>
				<cfset currcode1 = getcurrcode.bcurr>
			<cfelse>
				<h3>Please maintain your currency table first. (Default Currency Code is "<cfoutput>#getcurrcode.bcurr#</cfoutput>")</h3>					
				<cfabort>
			</cfif>
			<cfset foreign = 0>
		</cfif>
	</cfif>
	
	<h1>#title#</h1>
	<h4>
	<cfif getpin2.h1D10 eq 'T'><a href="locationtable2.cfm?type=Create">Creating a New #getGsetup.lLOCATION#</a></cfif>
	<cfif getpin2.h1D30 eq 'T'>|| <a href="s_locationtable.cfm?type=Icitem">Search For #getGsetup.lLOCATION#</a></cfif>
	</h4>


<cfform name="CustomerForm" action="locationtableprocess.cfm" method="post" onsubmit="return validate()">
    <input type="hidden" name="mode" value="#mode#">
	<input type='hidden' name='com_id' value='#lcase(HcomID)#'>
  	
	<h1 align="center">#getGsetup.lLOCATION# File Maintenance</h1>
  	
	<table align="center" class="data" width="800">
		<tr> 
        	<td width="200">#getGsetup.lLOCATION# :</td>
        	<td>
			<cfif mode eq "Delete" or mode eq "Edit">
            	<input type="text" size="40" name="location" value="#location#" readonly>
            <cfelse>
            	<input type="text" size="40" name="location" value="#location#" maxlength="24">
          	</cfif>
			</td>
		</tr>
      	<tr> 
        	<td>Description:</td>
        	<td><input type="text" size="40" name="desp" value="#desp#" maxlength="<cfif lcase(HcomID) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">80<cfelse>40</cfif>"></td>
      	</tr>
		<tr> 
        	<td>Consignment Outlet:</td>
        	<td><input type="text" size="2" name="OUTLET" value="#OUTLET#" maxlength="1">(Y/N)</td>
      	</tr>
        <tr>
        <td>Generate Item Into Location Openning</td>
        <td>
        <input type="checkbox" name="generateitem" id="generateitem" value="generate" />
        </td>
        </tr>
      	<tr> 
        	<td height="24">Customer No:</td>
        	<td><select name="custno">
					<option value="">Choose a customer</option>
					<cfloop query="getcust">
					<option value="#getcust.custno#"<cfif getcust.custno eq customerno>selected</cfif>>#getcust.custno# - #name#</option>
					</cfloop>
				</select>
			</td>
      	</tr>
      	<tr> 
        	<td>Address:</td>
        	<td><input name="ADDR1" type="text" value="#ADDR1#" size="40" maxlength="40"> </td>
      	</tr>
      	<tr> 
        	<td>&nbsp;</td>
        	<td><input name="ADDR2" type="text" value="#ADDR2#" size="40" maxlength="40"></td>
      	</tr>
      	<tr> 
        	<td>&nbsp;</td>
        	<td><input name="ADDR3" type="text" value="#ADDR3#" size="40" maxlength="40"></td>
      	</tr>
      	<tr> 
        	<td nowrap>&nbsp;</td>
        	<td><input name="ADDR4" type="text" value="#ADDR4#" size="40" maxlength="40"></td>
      	</tr>
		<cfif lcase(HcomID) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
			<cfquery name="showall" datasource="#dts#">
				select * from #target_currency#
			</cfquery>
			<tr> 
        		<td>Currency Code:</td>
        		<td>
					<select name="currcode">							
					<cfloop query="showall"> 
						<option value="#showall.CurrCode#" <cfif showall.currcode eq '#currcode1#'>selected</cfif>>#showall.currcode# - #showall.Currency#</option>
					</cfloop> 
					</select>
				</td>
      		</tr>
			<tr> 
        		<td>Foreign #getGsetup.lLOCATION# #foreign#:</td>
        		<td>
					<input type="checkbox" name="foreignloc" id="foreignloc" <cfif foreign neq 0>checked</cfif>>
				</td>
      		</tr>
		</cfif>
      	<tr> 
        	<td></td>
        	<td align="right"><input name="submit" type="submit" value="  #button#  "></td>
      	</tr>	
  	</table>
</cfform>
</cfoutput>
</body>
</html>