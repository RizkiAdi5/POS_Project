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
		if(document.form.title_id.value=='')
		{
			alert("Your Title ID cannot be blank.");
			document.form.title_id.focus();
			return false;
		}
		return true;
	}
</script>

<cfoutput> 
  <cfif #url.type# eq "Edit">
    <cfquery datasource='#dts#' name="gettitle">
    Select * from title where title_id='#url.title_id#' 
    </cfquery>
    <cfset title_id=#gettitle.title_id#>
    <cfset desp=#gettitle.desp#>
    <cfset mode="Edit">
    <cfset title="Edit Title">
    <cfset button="Edit">
  </cfif>
  <cfif #url.type# eq "Delete">
    <cfquery datasource='#dts#' name="gettitle">
    Select * from title where title_id='#url.title_id#' 
    </cfquery>
	<cfset title_id=#gettitle.title_id#>
    <cfset desp=#gettitle.desp#>
    <cfset mode="Delete">
    <cfset title="Delete Title">
    <cfset button="Delete">
  </cfif>
  <cfif #url.type# eq "Create">
    <cfset title_id="">
    <cfset desp="">
    <cfset details="">
    <cfset mode="Create">
    <cfset title="Create Title">
    <cfset button="Create">
  </cfif>
  <h1>#title#</h1>
  <h4>
	<cfif getpin2.h1N10 eq 'T'><a href="titletable2.cfm?type=Create">Creating a New Title</a></cfif>
	<cfif getpin2.h1N20 eq 'T'>|| <a href="titletable.cfm">List All Title</a></cfif>
	<cfif getpin2.h1N30 eq 'T'>|| <a href="s_titletable.cfm">Search For Title</a></cfif>
  </h4>
</cfoutput>
<cfform name="form" action="titletableprocess.cfm" method="post" onsubmit="return validate()">
<cfoutput>
	<input type="hidden" name="mode" value="#mode#">
</cfoutput> 
<h1 align="center">Title Maintenance</h1>
<table align="center" class="data" width="50%">
	<cfoutput> 
	<tr> 
        <td width="10%">Code :</td>
        <td width="90%"> 
			<cfif mode eq "Delete" or mode eq "Edit">
            	<input type="text" size="30" name="title_id" value="#url.title_id#" readonly>
            <cfelse>
				<input type="text" size="20" name="title_id" value="#title_id#" maxlength="20">
          	</cfif> 
		</td>
	</tr>
    <tr> 
		<td>Description:</td>
        <td><input type="text" size="60" name="desp" value="#desp#" maxlength="<cfif lcase(hcomid) eq "kingston_i">400<cfelse>100</cfif>"></td>
    </tr>
    <tr> 
        <td></td>
        <td align="right">
			<input name="submit" type="submit" value="  #button#  ">
        </td>
	</tr>
	</cfoutput>  
</table>
</cfform>
</body>
</html>
