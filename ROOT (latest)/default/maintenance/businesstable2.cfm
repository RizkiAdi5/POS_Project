<html>
<head>
<title>Business Page</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<script language="JavaScript">
	function validate()
	{
		if(document.CustomerForm.business.value=='') 
		{
			alert("Your Business cannot be blank.");
			document.CustomerForm.business.focus();
			return false;
		}
		return true;
	}
</script>			

<cfif url.type eq "Edit">
	<cfquery datasource='#dts#' name="getitem">
		Select * from business where business='#url.business#'
	</cfquery>
		
	<cfset business=getitem.business>
	<cfset desp=getitem.desp>
    <cfset pricelvl = getitem.pricelvl>
	<cfset mode="Edit">
	<cfset title="Edit Business">
	<cfset button="Edit">		
</cfif>
	
<cfif url.type eq "Delete">
	<cfquery datasource='#dts#' name="getitem">
		Select * from business where business='#url.business#'
	</cfquery>
		
	<cfset business=getitem.business>
	<cfset desp=getitem.desp>
    <cfset pricelvl = getitem.pricelvl>
	<cfset mode="Delete">
	<cfset title="Delete Business">
	<cfset button="Delete">		
</cfif>
			
<cfif url.type eq "Create">    
	<cfset business="">
	<cfset desp="">
    <cfset pricelvl = "1">
	<cfset mode="Create">
	<cfset title="Create Business">
	<cfset button="Create">	
</cfif>

<cfoutput>
	<h1>#title#</h1>
	<h4>
	<a href="businesstable2.cfm?type=Create">Creating a New Business</a> || 
	<a href="businesstable.cfm">List All Business</a> || 
	<a href="s_businesstable.cfm?type=business">Search For Business</a>
	</h4>
</cfoutput> 

<cfform name="CustomerForm" action="businesstableprocess.cfm" method="post" onsubmit="return validate()">
  	<cfoutput>
  		<input type="hidden" name="mode" value="#mode#">
  	</cfoutput> 
  	
	<h1 align="center">Business File Maintenance</h1>
  	<table align="center" class="data" width="450">
    <cfoutput>
		<tr> 
        	<td>Business :</td>
        	<td>
			<cfif mode eq "Delete" or mode eq "Edit">
            	<input type="text" size="20" name="business" value="#url.business#" readonly>
            <cfelse>
            	<input type="text" size="20" name="business" value="#business#" maxlength="20">
          	</cfif>
			</td>
      	</tr>
      	<tr> 
        	<td>Description:</td>
        	<td><input type="text" size="40" name="desp" value="#desp#" maxlength="40"></td>
      	</tr>
        <tr> 
        	<td>Price Level:</td>
        	<td>
            <select name="pricelvl" id="pricelvl">
            <cfloop list="1,2,3,4" index="i">
            <option value="#i#" <cfif pricelvl eq i>Selected</cfif>>#i#</option>
            </cfloop>
            </select>
            </td>
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