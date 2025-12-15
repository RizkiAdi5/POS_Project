<html>
<head>
	<title>Driver Page</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">

	function validate()
	{
		if(document.DriverForm.DriverNo.value=='')
		{
			alert("Your Driver's No. cannot be blank.");
			document.DriverForm.DriverNo.focus();
			return false;
		}
		else if(document.DriverForm.attn.value=='')
		{
			alert("Your Driver's Company Name cannot be blank.");
			document.DriverForm.attn.focus();
			return false;
		}
		else if(document.DriverForm.add1.value=='')
		{
			alert("Your Driver's Address cannot be blank.");
			document.DriverForm.add1.focus();
			return false;			
		}
		
		return true;
	}
	
</script>
<body>	
	
<cfquery name="getGsetup" datasource="#dts#">
  Select * from GSetup
</cfquery>	
						
<cfif url.type eq "Edit">
	<cfquery datasource='#dts#' name="getPersonnel">
		Select * from Driver where DriverNo='#url.DriverNo#'
	</cfquery>
				
	<cfif getPersonnel.recordcount gt 0>
		<cfset DriverNo=getPersonnel.DriverNo>
		<cfset name=getPersonnel.name>
		<cfset name2=getPersonnel.name2>
		<cfset attn=getPersonnel.attn>
		<cfset xcustomerno=getPersonnel.customerno>						
		<cfset add1=getPersonnel.add1>
		<cfset add2=getPersonnel.add2>
		<cfset add3=getPersonnel.add3>
		<cfset dept=getPersonnel.dept>						
		<cfset contact=getPersonnel.contact>						
		<cfset fax=getPersonnel.fax>	
        <cfif lcase(hcomid) eq "ovas_i">
			<cfset phone=getPersonnel.phone>
			<cfset phonea=getPersonnel.phonea>
		</cfif>								
						
		<cfset mode="Edit">
		<cfset title="Edit #getGsetup.lDRIVER#">
		<cfset button="Edit">			
	<cfelse>
		<cfset status="Sorry, the #getGsetup.lDRIVER#, #url.DriverNo# was ALREADY removed from the system. Process unsuccessful.">
		<form name="done" action="vdriver.cfm?process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
		<script>
			done.submit();
		</script>
	</cfif>			
<cfelseif url.type eq "Create">
	<cfset DriverNo="">
	<cfset name="">
	<cfset name2="">
	<cfset phone="">
	<cfset icno="">						
	<cfset add1="">
	<cfset add2="">
	<cfset add3="">
	<cfset dob="">						
	<cfset contact="">						
	<cfset fax="">	
			
	<cfset mode="Create">
	<cfset title="Create #getGsetup.lDRIVER#">
	<cfset button="Create">
<cfelseif url.type eq "Delete">
	<cfquery datasource='#dts#' name="getPersonnel">
		Select * from Driver where DriverNo='#url.DriverNo#'
	</cfquery>
				
	<cfif getPersonnel.recordcount gt 0>
		<cfset DriverNo=getPersonnel.DriverNo>
		<cfset name=getPersonnel.name>
		<cfset name2=getPersonnel.name2>
		<cfset phone=getPersonnel.attn>
		<cfset icno=getPersonnel.customerno>						
		<cfset add1=getPersonnel.add1>
		<cfset add2=getPersonnel.add2>
		<cfset add3=getPersonnel.add3>
		<cfset dob=getPersonnel.dept>						
		<cfset contact=getPersonnel.contact>						
		<cfset fax=getPersonnel.fax>	
						
		<cfset mode="Delete">
		<cfset title="Delete #getGsetup.lDRIVER#">
		<cfset button="Delete">
	<cfelse>
		<cfset status="Sorry, the #getGsetup.lDRIVER#, #url.DriverNo# was ALREADY removed from the system. Process unsuccessful. Please refresh your webpage.">
		<form name="done" action="vdriver.cfm?process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
		<script>
			done.submit();
		</script>
	</cfif>				
</cfif>
			

<cfif husergrpid eq "Muser"><a href="../home2.cfm"><u>Home</u></a></cfif>
<cfoutput>
<h1>#title#</h1>
	<cfif lcase(hcomid) eq "ovas_i">
		<cfif lcase(Huserloc) eq "malaysia">
			<cfquery name="getLastUsedNo" datasource="#dts#">
				select driverno from driver
				where driverno <> '300C/999'
				and	driverno like '300M/%'
				order by driverno desc limit 1
			</cfquery>
			<strong><br>Last Used #getGsetup.lDRIVER# No. : </strong><font color="##FF0000"><strong><cfif getLastUsedNo.recordcount neq 0>#getLastUsedNo.driverno#<cfelse>300M/000</cfif></strong></font>
		<cfelse>
			<cfquery name="getLastUsedNo" datasource="#dts#">
				select a.driverno,SUBSTR(a.driverno,1,4) 
				from (select driverno from driver
						where driverno <> '300C/999'
						and	driverno not like '300M/%'
						order by driverno desc) as a
				group by SUBSTR(a.driverno,1,4)
			</cfquery>
			<cfloop query="getLastUsedNo">
				<strong>Last Used #getGsetup.lDRIVER# No. #getLastUsedNo.currentrow#: </strong><font color="##FF0000"><strong>#getLastUsedNo.driverno#</strong></font>&nbsp&nbsp;&nbsp&nbsp;
			</cfloop>
		</cfif>			
	</cfif>
			
<form name="DriverForm" action="DriverProcess.cfm" method="post" onsubmit="return validate()">
	<input type="hidden" name="mode" value="#mode#">
	<!--- <cfquery name="getcust" datasource="#dts#">
		select custno,name from #target_arcust# where status<>'B' order by custno
	</cfquery> --->
	<cfif lcase(HcomID) eq "iel_i" or lcase(HcomID) eq "ielm_i">
		<cfquery name="getcust" datasource="#dts#">
			select custno,name from #target_apvend# where status<>'B' order by custno
		</cfquery>
	<cfelse>
		<cfquery name="getcust" datasource="#dts#">
			select custno,name from #target_arcust# where status<>'B' order by custno
		</cfquery>
	</cfif>
					
  	<table align="center" class="data" width="550px">
    <tr> 
      	<td>#getGsetup.lDRIVER# No :</td>
      	<td> 
			<cfif mode eq "Delete" or mode eq "Edit">
	          	<h2>#url.DriverNo#</h2>
	          	<input type="hidden" name="DriverNo" value="#DriverNo#">
          	<cfelse>
          		<input type="text" size="40" name="DriverNo" value="" maxlength="8">
        	</cfif> 
		</td>
    </tr>
	<tr> 
      	<td>Name :</td>
      	<td><input type="text" size="40" name="Name"  value="#name#" maxlength="40"></td>
    </tr>
	<tr> 
      	<td></td>
      	<td><input type="text" size="40" name="Name2"  value="#name2#" maxlength="40"></td>
    </tr>
    <tr> 
      	<td>Address :</td>
      	<td><input type="text" size="40" name="Add1" value="#Add1#" maxlength="40"></td>
    </tr>
    <tr> 
      	<td></td>
      	<td><input type="text" size="40" name="Add2"  value="#Add2#" maxlength="40"></td>
    </tr>
	<tr> 
      	<td></td>
      	<td><input type="text" size="40" name="Add3"  value="#Add3#" maxlength="40"></td>
    </tr>
    <tr> 
        <td>Phone :</td>
        <td><input type="text" size="40" name="phone"  value="#phone#" maxlength="25"></td>
    </tr>
    <tr> 
      	<td>Contact :</td>
      	<td><input type="text" size="40" name="contact"  value="#contact#" maxlength="20"></td>
    </tr>	
    <tr> 
      	<td>IC No :</td>
      	<td><input type="text" size="40" name="icno"  value="#icno#" maxlength="20"></td>
    </tr>	
    <tr> 
      	<td>DOB :</td>
      	<td><input type="text" size="40" name="dob"  value="#dob#" maxlength="20"></td>
    </tr>	
	<tr> 
      	<td>Fax :</td>
      	<td><input type="text" size="40" name="fax"  value="#fax#" maxlength="20"></td>
    </tr>
  	<tr> 
		<td></td>
		<td align="right"><input type="submit" value="  #button#  "></td>
 	</tr>
    </cfoutput> 
  	</table>
</form>			
</body>
</html>
