<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery datasource='#dts#' name="getgeneral">
	Select lmodel as layer from gsetup
</cfquery>

<script language="JavaScript">

	function validate()
	{	<cfoutput>
		if(document.CustomerForm.shelf.value=='') <!--- QCH if(document.shelftable2Form.shelf.value=='') --->
		{
			alert("Your #getgeneral.layer#'s No. cannot be blank.");
			document.CustomerForm.shelf.focus();
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
					Select * from icshelf where shelf='#url.shelf#'
				</cfquery>
				<cfset shelf=#getitem.shelf#>
				<cfset desp=#getitem.desp#>
				
				<cfset mode="Edit">
				<cfset title="Edit Item">
				<cfset button="Edit">
						
				
			</cfif>
			<cfif #url.type# eq "Delete">
				<cfquery datasource='#dts#' name="getitem">
					Select * from icshelf where shelf='#url.shelf#'
				</cfquery>
				<cfset shelf=#getitem.shelf#>
				<cfset desp=#getitem.desp#>
				
				<cfset mode="Delete">
				<cfset title="Delete Item">
				<cfset button="Delete">
						
				
			</cfif>
			
			
  <cfif #url.type# eq "Create">   
    
    			<cfset shelf="">
				<cfset desp="">
				
				<cfset mode="Create">
				<cfset title="Create Item">
				<cfset button="Create">
			
			</cfif>

			<h1>#title#</h1>
			
  <h4><cfif getpin2.h1910 eq 'T'><a href="shelftable2.cfm?type=Create">Creating a #getgeneral.layer#</a> </cfif><cfif getpin2.h1920 eq 'T'>|| <a href="shelftable.cfm?">List 
    all #getgeneral.layer#</a> </cfif><cfif getpin2.h1930 eq 'T'>|| <a href="s_shelftable.cfm?type=icshelf">Search For #getgeneral.layer#</a></cfif></h4>
</cfoutput>

<cfform name="CustomerForm" action="shelfprocess.cfm" method="post" onsubmit="return validate()">
	<cfoutput><input type="hidden" name="mode" value="#mode#">
					
	
  <h1 align="center">#getgeneral.layer# Maintenance</h1></cfoutput>
  	
  <table align="center" class="data" width="450">
    <cfoutput> 
      <tr> 
        <td width="20%" nowrap>#getgeneral.layer# :</td>
        <td> <cfif mode eq "Delete" or mode eq "Edit">
            <!--- <h2>#url.shelf#</h2> --->
            <input type="text" size="20" name="shelf" value="#url.shelf#" readonly>
            <cfelse>
            <input type="text" size="20" name="shelf" value="#shelf#" maxlength="10">
          </cfif> </td>
      </tr>
      <tr> 
        <td>Description :</td>
        <td><input type="text" size="60" name="desp" value="#desp#" maxlength="40"></td>
      </tr>
      <tr> 
        <td></td>
        <td>&nbsp;</td>
      </tr>
    </cfoutput> <!--- QCH <CFOUTPUT> </CFOUTPUT> <CFOUTPUT> </CFOUTPUT> <CFOUTPUT> </CFOUTPUT> 
    <CFOUTPUT> </CFOUTPUT> <cfoutput> </cfoutput> <cfoutput> </cfoutput> <cfoutput> 
    </cfoutput> <cfoutput> </cfoutput> <cfoutput> </cfoutput> ---> 
	
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
