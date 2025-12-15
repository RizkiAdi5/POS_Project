<html>
<head>
<title>Customer Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery datasource='#dts#' name="getgeneral">
	Select lrating as layer from gsetup
</cfquery>

<script language="JavaScript">

	function validate()
	{	<cfoutput>
		if(document.CustomerForm.costcode.value=='') <!--- QCH if(document.costcodetable2Form.costcode.value=='') --->
		{
			alert("Your #getgeneral.layer#'s No. cannot be blank.");
			document.CustomerForm.costcode.focus();
			return false;
		}
		</cfoutput>
		return true;
	}
	
</script>

<body>
			
		<cfoutput>
			<cfif #url.type# eq "Edit">
				<cfquery datasource='#dts#' name="getitem">
					Select * from iccostcode where costcode='#url.costcode#'
				</cfquery>
				<cfset costcode=#getitem.costcode#>
				<cfset desp=#getitem.desp#>
				
				<cfset mode="Edit">
				<cfset title="Edit Item">
				<cfset button="Edit">
						
				
			</cfif>
			<cfif #url.type# eq "Delete">
				<cfquery datasource='#dts#' name="getitem">
					Select * from iccostcode where costcode='#url.costcode#'
				</cfquery>
				<cfset costcode=#getitem.costcode#>
				<cfset desp=#getitem.desp#>
				
				<cfset mode="Delete">
				<cfset title="Delete Item">
				<cfset button="Delete">
						
				
			</cfif>
			
			
  <cfif #url.type# eq "Create">   
    
    			<cfset costcode="">
				<cfset desp="">
				
				<cfset mode="Create">
				<cfset title="Create Item">
				<cfset button="Create">
			
			</cfif>

			<h1>#title#</h1>
			
  <h4><cfif getpin2.h1710 eq 'T'><a href="costcodetable2.cfm?type=Create">Creating a New #getgeneral.layer#</a> </cfif><cfif getpin2.h1720 eq 'T'>|| <a href="costcodetable.cfm">List 
    all #getgeneral.layer#</a> </cfif><cfif getpin2.h1730 eq 'T'>|| <a href="s_costcodetable.cfm?type=Iccostcode">Search For #getgeneral.layer#</a></cfif></h4>
</cfoutput>

<cfform name="CustomerForm" action="costcodeprocess.cfm" method="post" onsubmit="return validate()">
	<cfoutput><input type="hidden" name="mode" value="#mode#">
					
	
  <h1 align="center">#getgeneral.layer# Maintenance</h1></cfoutput>
  	
  <table align="center" class="data" width="500">
    <cfoutput> 
      <tr> 
        <td width="80">#getgeneral.layer# :</td>
        <td width="420"> <cfif mode eq "Delete" or mode eq "Edit">
            <!--- <h2>#url.costcode#</h2> --->
            <input type="text" size="20" name="costcode" value="#url.costcode#" readonly>
            <cfelse>
            <input type="text" size="20" name="costcode" value="#costcode#" maxlength="8">
          </cfif> </td>
      </tr>
      <tr> 
        <td>Description :</td>
        <td><input type="text" size="40" name="desp" value="#desp#" maxlength="40"></td>
      </tr>
      <tr> 
        <td></td>
        <td>&nbsp;</td>
      </tr>
    </cfoutput> <!--- QCH <CFOUTPUT> </CFOUTPUT> <CFOUTPUT> </CFOUTPUT> <CFOUTPUT> </CFOUTPUT> 
    <CFOUTPUT> </CFOUTPUT> <cfoutput> </cfoutput> <cfoutput> </cfoutput> <cfoutput> 
    </cfoutput> <cfoutput> </cfoutput> <cfoutput> </cfoutput> ---> 
	<cfoutput> 
      <tr> 
        <td></td>
        <td align="right"><cfoutput> 
            <input name="submit" type="submit" value="  #button#  ">
          </cfoutput></td>
      </tr>
    </cfoutput> 
  </table>
</cfform>
			
</body>
</html>
