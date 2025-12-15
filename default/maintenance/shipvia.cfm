<html>
<head>
<title>Ship Via Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">

	function validate()
	{
		if(document.CustomerForm.shipvia.value=='') <!--- QCH if(document.UNITtable2Form.UNIT.value=='') --->
		{
			alert("Your Ship Via cannot be blank.");
			document.CustomerForm.shipvia.focus();
			return false;
		}
		return true;
	}
	
</script>

<body>
			
<cfoutput>
<cfif #url.type# eq "Edit">
	<cfquery datasource='#dts#' name="getitem">
		Select * from shipvia where shipvia='#url.shipvia#'
	</cfquery>
	<cfset shipvia=#getitem.shipvia#>
	<cfset desp=#getitem.desp#>
	
	<cfset mode="Edit">
	<cfset title="Edit Ship Via">
	<cfset button="Edit">	
</cfif>
		
<cfif #url.type# eq "Delete">
	<cfquery datasource='#dts#' name="getitem">
		Select * from shipvia where shipvia='#url.shipvia#'
	</cfquery>
	<cfset shipvia=#getitem.shipvia#>
	<cfset desp=#getitem.desp#>
	
	<cfset mode="Delete">
	<cfset title="Delete Ship Via">
	<cfset button="Delete">			
</cfif>
		
		
<cfif #url.type# eq "Create">   

	<cfset shipvia="">
	<cfset desp="">
	
	<cfset mode="Create">
	<cfset title="Create Ship Via">
	<cfset button="Create">

</cfif>

<h1>#title#</h1>
		
<h4><cfif getpin2.h1A10 eq 'T'><a href="shipvia.cfm?type=Create">Create a Ship Via</a> </cfif><cfif getpin2.h1A20 eq 'T'>|| <a href="shipviaV.cfm?">List 
all Ship Via</a> </cfif><cfif getpin2.h1A30 eq 'T'>|| <a href="shipviaS.cfm">Search For Ship Via</a></cfif></h4>
</cfoutput>

<cfform name="CustomerForm" action="shipviaprocess.cfm" method="post" onsubmit="return validate()">
	<cfoutput><input type="hidden" name="mode" value="#mode#"></cfoutput>					
	
  	<h1 align="center">Ship Via Maintenance</h1>
  	
  	<table align="center" class="data" width="500">
    <cfoutput> 
      <tr> 
        <td width="20%">Ship Via :</td>
        <td> <cfif mode eq "Delete" or mode eq "Edit">
            <!--- <h2>#url.shipvia#</h2> --->
            <input type="text" size="35" name="shipvia" value="#url.shipvia#" readonly>
            <cfelse>
            <input type="text" size="35" name="shipvia" value="#shipvia#" maxlength="35">
          </cfif> </td>
      </tr>
      <tr> 
        <td>Description :</td>
        <td><input type="text" size="45" name="desp" value="#desp#" maxlength="45"></td>
      </tr>
      <tr> 
        <td></td>
        <td>&nbsp;</td>
      </tr>
    </cfoutput> 
	
      <tr> 
        <td></td>
        <td align="right"><cfoutput> 
            <input name="submit" type="submit" value="  #button#  ">
          </cfoutput></td>
      </tr>
   
  	</table>
</cfform>
			
</body>
</html>
