<html>
<head>
<title>Customer Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>

<script language='JavaScript'>
	function validate()
	{
		if(document.CustomerForm.code.value=='')
		{
			alert("Your Code cannot be blank.");
			document.CustomerForm.code.focus();
			return false;
		}
		return true;
	}
</script>

<cfoutput> 
  <cfif #url.type# eq "Edit">
    <cfquery datasource='#dts#' name="getitem">
    Select * from comments where code='#url.code#' 
    </cfquery>
    <cfset code=#getitem.code#>
    <cfset desp=#getitem.desp#>
    <cfset details=ToString(#getitem.details#)>
    <cfset mode="Edit">
    <cfset title="Edit Item">
    <cfset button="Edit">
  </cfif>
  <cfif #url.type# eq "Delete">
    <cfquery datasource='#dts#' name="getitem">
    Select * from comments where code='#url.code#' 
    </cfquery>
	<cfset code=#getitem.code#>
    <cfset desp=#getitem.desp#>
    <cfset details=ToString(#getitem.details#)>
    <cfset mode="Delete">
    <cfset title="Delete Item">
    <cfset button="Delete">
  </cfif>
  <cfif #url.type# eq "Create">
    <cfset code="">
    <cfset desp="">
    <cfset details="">
    <cfset mode="Create">
    <cfset title="Create Item">
    <cfset button="Create">
  </cfif>
  <h1>#title#</h1>
  <h4><cfif getpin2.h1E10 eq 'T'><a href="commenttable2.cfm?type=Create">Creating a New Comment</a> </cfif><cfif getpin2.h1E20 eq 'T'>|| <a href="commenttable.cfm?">List all Comment</a> </cfif><cfif getpin2.h1E30 eq 'T'>|| <a href="s_commenttable.cfm?type=comments">Search For Comment</a></cfif></h4>
</cfoutput>
<cfform name="CustomerForm" action="commenttableprocess.cfm" method="post" onsubmit="return validate()">
  <cfoutput>
    <input type="hidden" name="mode" value="#mode#">
  </cfoutput> 
  <h1 align="center">Comment Maintenance</h1>
  <table align="center" class="data" width="80%">
    <cfoutput> 
      <tr> 
        <td width="10%">Code :</td>
        <td width="90%"> <cfif mode eq "Delete" or mode eq "Edit">
            <!--- <h2>#url.code#</h2> --->
            <input type="text" size="30" name="code" value="#url.code#" readonly>
            <cfelse>
            <input type="text" size="30" name="code" value="#code#" maxlength="20">
          </cfif> </td>
      </tr>
      <tr> 
        <td>Description:</td>
        <td><input type="text" size="50" name="desp" value="#desp#" maxlength="100"></td>
      </tr>
      <tr> 
        <td>Details:</td>
        <td><textarea name="details" cols="90" rows="10">#details#</textarea></td>
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
