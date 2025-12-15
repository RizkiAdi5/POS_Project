<html>
<head>
<title><cfoutput>Language</cfoutput> Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">

function limitText(field,maxlimit){
	if (field.value.length > maxlimit) // if too long...trim it!
		field.value = field.value.substring(0, maxlimit);
		// otherwise, update 'characters left' counter
}
	
</script>

<body>
<cfoutput>
	<cfif url.type eq "Edit">
		<cfquery datasource='#dts#' name="getitem">
			Select * from icLanguage where langno='#url.langno#'
		</cfquery>
		
		<cfset langno=getitem.langno>
		<cfset english=getitem.english>
        <cfset chinese=getitem.chinese>
        

		<cfset mode="Edit">
		<!--- <cfset title="Edit Item"> --->
		<cfset title="Edit Language">
		<cfset button="Edit">
	
	<cfelseif url.type eq "Delete">
		<cfquery datasource='#dts#' name="getitem">
			Select * from icLanguage where langno='#url.langno#' 
		</cfquery>
		
		<cfset langno=getitem.langno>
		<cfset english=getitem.english>
        <cfset chinese=getitem.chinese>
		
		<cfset mode="Delete">
		<!--- <cfset title="Delete Item"> --->
		<cfset title="Delete Language">
		<cfset button="Delete">
	
	<cfelseif url.type eq "Create">
		<cfset langno=''>
		<cfset english=''>
        <cfset chinese=''>
		
		<cfset mode="Create">
		<!--- <cfset title="Create Item"> --->
		<cfset title="Create Language">
		<cfset button="Create">
	</cfif>

  <h1>#title#</h1>
			
	<h4>
		<cfif getpin2.h1H10 eq 'T'><a href="Languagetable2.cfm?type=Create">Creating a Language</a> </cfif>
		<cfif getpin2.h1H20 eq 'T'>|| <a href="Languagetable.cfm?">List all Language</a> </cfif>
		<cfif getpin2.h1H30 eq 'T'>|| <a href="s_Languagetable.cfm?type=Language">Search For Language</a></cfif>||<a href="p_Language.cfm">Language Listing report</a>
	</h4>
</cfoutput> 

<cfform name="LanguageForm" action="Languagetableprocess.cfm" method="post" >
  <cfoutput> 
    <input type="hidden" name="mode" value="#mode#">
  </cfoutput> 
  <h1 align="center"><cfoutput>Language</cfoutput> File Maintenance</h1>
  <table align="center" class="data" width="400">
    <cfoutput> 


 <cfif mode eq "Delete" or mode eq "Edit">
            <!--- <h2>#url.langno#</h2> --->
            <input type="hidden" size="10" name="langno" value="#url.langno#" readonly>
            <cfelse>
            <input type="hidden" size="20" name="langno" value="#langno#" readonly>
          </cfif> 

      <tr> 
        <td>English :</td>
        <td colspan="4">
			
				<input type="text" size="40" name="english" value="#english#" maxlength="40">
		</td>
        
      </tr>
       <tr> 
        <td>Chinese :</td>
        <td colspan="4">
			
				<input type="text" size="40" name="chinese" value="#chinese#" maxlength="40">
		</td>
        
      </tr>
    </cfoutput> 
    <tr> 
      <td height="23"></td>
      <td colspan="4" align="right"><cfoutput> 
          <input name="submit" type="submit" value="  #button#  ">
        </cfoutput></td>
    </tr>
  </table>
</cfform>

</body>
</html>
