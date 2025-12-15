<html>
<head>
<title>Customer Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery datasource='#dts#' name="getgeneral">
	Select lcategory as layer from gsetup
</cfquery>

<script language="JavaScript">

	function validate()
	{
		<cfoutput>
		if(document.CustomerForm.cate.value=='') <!--- QCH if(document.categorytable2Form.cate.value=='') --->
		{
			alert("Your #getgeneral.layer#'s No. cannot be blank.");
			document.CustomerForm.cate.focus();
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
					Select * from iccate where cate='#url.cate#'
				</cfquery>
				<cfset cate=#getitem.cate#>
				<cfset desp=#getitem.desp#>
				
				<cfset mode="Edit">
				<cfset title="Edit Item">
				<cfset button="Edit">
						
				
			</cfif>
			<cfif #url.type# eq "Delete">
				<cfquery datasource='#dts#' name="getitem">
					Select * from iccate where cate='#url.cate#'
				</cfquery>
				<cfset cate=#getitem.cate#>
				<cfset desp=#getitem.desp#>
				
				<cfset mode="Delete">
				<cfset title="Delete Item">
				<cfset button="Delete">
						
				
			</cfif>
			
			
  <cfif #url.type# eq "Create">   
    
    			<cfset cate="">
				<cfset desp="">
				
				<cfset mode="Create">
				<cfset title="Create Item">
				<cfset button="Create">
			
			</cfif>

			<h1>#title#</h1>
			
  <h4><cfif getpin2.h1410 eq 'T'><a href="categorytable2.cfm?type=Create"> Creating a New #getgeneral.layer#</a> 
    </cfif><cfif getpin2.h1420 eq 'T'>|| <a href="categorytable.cfm">List all #getgeneral.layer#</a> </cfif><cfif getpin2.h1430 eq 'T'>|| <a href="s_categorytable.cfm?type=iccate">Search 
    For #getgeneral.layer#</a></cfif></h4>
</cfoutput>

<cfform name="CustomerForm" action="categoryprocess.cfm" method="post" onsubmit="return validate()">
	<cfoutput><input type="hidden" name="mode" value="#mode#">
					
	
  <h1 align="center">#getgeneral.layer# File Maintenance</h1></cfoutput>
  	
  <table align="center" class="data" width="500">
    <cfoutput> 
      <tr> 
        <td width="80" nowrap>#getgeneral.layer# :</td>
        <td width="420"> 
		<cfif mode eq "Delete" or mode eq "Edit">
            <!--- <h2>#url.cate#</h2> --->
        	<input type="text" size="24" name="cate" value="#url.cate#" readonly>
       	<cfelse>
            <input type="text" size="24" name="cate" value="#cate#" maxlength="24">
        </cfif> </td>
      </tr>
      <tr> 
        <td>Description :</td>
        <td>
			<cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">
				<input type="text" size="80" name="desp" value="#desp#" maxlength="150">
			<cfelse>
				<input type="text" size="40" name="desp" value="#desp#" maxlength="40">
			</cfif>
		</td>
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
