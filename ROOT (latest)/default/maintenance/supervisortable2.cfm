<html>
<head>
<title>Supervisor</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">
	function validate()
	{
		if(document.form1.Supervisor.value=='')
		{
			alert("Your Supervisor ID cannot be blank.");
			document.form1.Supervisorid.focus();
			return false;
		}
		return true;
	}
	
</script>
<body>
			
<cfif url.type eq "Edit">
	<cfquery datasource='#dts#' name="getitem">
		Select * from Supervisor where Supervisorid='#url.Supervisor#'
	</cfquery>
	<cfset Supervisorid=getitem.Supervisorid>
	<cfset name=getitem.name>
    <cfset password=getitem.password>
	<cfif lcase(HComID) eq "ugateway_i">
		<cfset rangeForDisc=val(getitem.rangeForDisc)>
		<cfset dispec=val(getitem.dispec)>
	</cfif>
				
	<cfset mode="Edit">
	<cfset title="Edit Brand">
	<cfset button="Edit">
</cfif>

<cfif url.type eq "Delete">
	<cfquery datasource='#dts#' name="getitem">
		Select * from Supervisor where Supervisorid='#url.Supervisor#'
	</cfquery>
	<cfset casheirid=getitem.Supervisorid>
	<cfset name=getitem.name>
	<cfset password=getitem.password>
	<cfif lcase(HComID) eq "ugateway_i">
		<cfset rangeForDisc=val(getitem.rangeForDisc)>
		<cfset dispec=val(getitem.dispec)>
	</cfif>
				
	<cfset mode="Delete">
	<cfset title="Delete Brand">
	<cfset button="Delete">
</cfif>
			
<cfif url.type eq "Create">   
    <cfset Supervisor="">
	<cfset name="">
    <cfset password="">
	<cfif lcase(HComID) eq "ugateway_i">
		<cfset rangeForDisc=0>
		<cfset dispec=0>
	</cfif>
				
	<cfset mode="Create">
	<cfset title="Create Brand">
	<cfset button="Create">
</cfif>

<cfoutput>
	<h1>#title#</h1>
	<h4>
		<cfif getpin2.h1P10 eq 'T'><a href="Supervisortable2.cfm?type=Create">Creating a New Supervisor</a> </cfif>
		<cfif getpin2.h1P20 eq 'T'>|| <a href="Supervisortable.cfm">List all Supervisor</a> </cfif>
		<cfif getpin2.h1P30 eq 'T'>|| <a href="s_Supervisortable.cfm?type=brand">Search For Supervisor</a></cfif>
        <cfif getpin2.h1630 eq 'T'>|| <a href="p_Supervisor.cfm">Supervisor Listing</a>
        </cfif>
	</h4>
</cfoutput>

<cfform name="form1" action="Supervisorprocess.cfm" method="post" onsubmit="return validate()">
	<cfoutput><input type="hidden" name="mode" value="#mode#"></cfoutput>
  	<h1 align="center">Supervisor File Maintenance</h1>
  	
  	
  	<table align="center" class="data" width="500">
    <cfoutput> 
		<tr> 
        	<td width="80" nowrap>Supervisor ID:</td>
        	<td width="420"> 
			<cfif mode eq "Delete" or mode eq "Edit">
        		<input type="text" size="40" name="Supervisorid" id="Supervisorid" value="#url.Supervisor#" readonly>
       		<cfelse>
            	<cfinput type="text" size="40" name="Supervisor" id="Supervisor" value="#Supervisor#" maxlength="40" required="yes">
        	</cfif> 
			</td>
      	</tr>
		<tr> 
        	<td>Name :</td>
        	<td>
				<input type="text" size="40" name="name" id="name" value="#name#" maxlength="100">
			</td>
      	</tr>
        <tr> 
	        	<td>Password :</td>
	        	<td><cfinput type="password" size="40" name="password" id="password" value="#password#" maxlength="100" required="yes"></td>
	      	</tr>
		<cfif lcase(HComID) eq "ugateway_i">
			
			
		</cfif>
      	<tr> 
       		<td></td>
        	<td>&nbsp;</td>
      	</tr>
      	<tr> 
        	<td></td>
        	<td align="right"><input name="submit" type="submit" value="  #button#  "></td>
      	</tr>
    </cfoutput> 
  	</table>
</cfform>
			
</body>
</html>
