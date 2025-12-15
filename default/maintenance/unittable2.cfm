<html>
<head>
<title>Unit of Measurement Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">

	function validate()
	{
		if(document.CustomerForm.UNIT.value=='') <!--- QCH if(document.UNITtable2Form.UNIT.value=='') --->
		{
			alert("Your Unit of Measurement's No. cannot be blank.");
			document.CustomerForm.UNIT.focus();
			return false;
		}
		return true;
	}
	
</script>

<body>
			
<cfoutput>
<cfif #url.type# eq "Edit">
	<cfquery datasource='#dts#' name="getitem">
		Select * from UNIT where UNIT='#url.UNIT#'
	</cfquery>
	<cfset UNIT=#getitem.UNIT#>
	<cfset desp=#getitem.desp#>
	
	<cfset mode="Edit">
	<cfset title="Edit Unit of Measurement">
	<cfset button="Edit">
			
	
</cfif>
<cfif #url.type# eq "Delete">
	<cfquery datasource='#dts#' name="getitem">
		Select * from UNIT where UNIT='#url.UNIT#'
	</cfquery>
	<cfset UNIT=#getitem.UNIT#>
	<cfset desp=#getitem.desp#>
	
	<cfset mode="Delete">
	<cfset title="Delete Unit of Measurement">
	<cfset button="Delete">
			
	
</cfif>
			
			
<cfif #url.type# eq "Create">   

	<cfset UNIT="">
	<cfset desp="">
	
	<cfset mode="Create">
	<cfset title="Create Unit of Measurement">
	<cfset button="Create">

</cfif>

<h1>#title#</h1>
			
<h4><cfif getpin2.h1A10 eq 'T'><a href="UNITtable2.cfm?type=Create">Creating a Unit of Measurement</a> </cfif><cfif getpin2.h1A20 eq 'T'>|| <a href="UNITtable.cfm?">List 
    all Unit of Measurement</a> </cfif><cfif getpin2.h1A30 eq 'T'>|| <a href="s_UNITtable.cfm?type=UNIT">Search For Unit of Measurement</a></cfif></h4>
</cfoutput>

<cfform name="CustomerForm" action="UNITprocess.cfm" method="post" onsubmit="return validate()">
	<cfoutput><input type="hidden" name="mode" value="#mode#"></cfoutput>
					
	
  	<h1 align="center">Unit of Measurement Maintenance</h1>
  	
  	<table align="center" class="data" width="500">
    <cfoutput> 
      <tr> 
        <td width="20%">Unit of Measurement :</td>
        <td> <cfif mode eq "Delete" or mode eq "Edit">
            <!--- <h2>#url.UNIT#</h2> --->
            <input type="text" size="10" name="UNIT" value="#URL.UNIT#" readonly>
            <cfelse>
            <input type="text" size="10" name="UNIT" value="#UNIT#" maxlength="15">
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
    </cfoutput> 
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
