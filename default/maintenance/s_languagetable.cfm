
<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

	<!--- <cfset typeNo=#url.type# & "No"> 
	<cfset link = #url.type# &".cfm"> --->
	
	<!--- <cfif isdefined("URL.Type")> --->
		
<h1><cfoutput>language Selection Page</cfoutput></h1>
		
<cfoutput>
  <h4><cfif getpin2.h1H10 eq 'T'><a href="languagetable2.cfm?type=Create">Creating a Language</a> </cfif><cfif getpin2.h1H20 eq 'T'>|| <a href="languagetable.cfm?">List 
    all Language</a> </cfif><cfif getpin2.h1H30 eq 'T'>|| <a href="s_languagetable.cfm?type=language">Search For Language</a>|| <a href="p_language.cfm">Language Listing Report</a></cfif></h4>
</cfoutput>
		
		<cfoutput>
		<form action="s_languagetable.cfm" method="post"></cfoutput>
			<cfoutput>
			<h1>Search By :
			
			<select name="searchType">
				<option value="langno">Language</option>
				<option value="english">Description</option>
			</select>
      Search for Language : 
      <input type="text" name="searchStr" value=""> </h1>
			</cfoutput>
		</form>
		
		<cfif isdefined("url.process")>
				<cfoutput><h1>#form.status#</h1><hr></cfoutput>
		</cfif>
	
		<cfquery datasource='#dts#' name="type">
			Select * from iclanguage order by langno
		</cfquery>
		
		<cfif isdefined("form.searchStr")>
			<cfquery datasource='#dts#' name="exactResult">
				Select * from iclanguage where #form.searchType# = '#form.searchStr#' order by #form.searchType#
			</cfquery>
			
			<cfquery datasource='#dts#' name="similarResult">
				Select * from iclanguage where #form.searchType# LIKE '#form.searchStr#' order by #form.searchType#
			</cfquery>
			
			<h2>Exact Result</h2>
			<cfif #exactResult.recordCount# neq 0>
			
    <table align="center" class="data" width="600px">
      <tr> 
        <th><cfoutput>Language</cfoutput></th>
        <th>English</th>
         <th>Chinese</th>
        <cfif getpin2.h1H11 eq 'T'><th>Action</th></cfif>
      </tr>
      <cfoutput query="exactResult"> 
        <tr> 
          <td>#exactResult.langno#</td>
          <td>#exactResult.english#</td>
          <td>#exactResult.chinese#</td>
          <cfif getpin2.h1H11 eq 'T'><td width="10%" nowrap> 
            <div align="center"><a href="languagetable2.cfm?type=Delete&langno=#exactResult.langno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              <a href="languagetable2.cfm?type=Edit&langno=#exactResult.langno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
        </tr>
      </cfoutput> 
    </table>
			<cfelse>
				<h3>No Exact Records were found.</h3>
			</cfif>
			
			<h2>Similar Result</h2>
			<cfif #similarResult.recordCount# neq 0>
			
    <table align="center" class="data" width="600px">
      <tr> 
        <th><cfoutput>Language</cfoutput></th>
        <th>English</th>
         <th>Chinese</th>
        <cfif getpin2.h1H11 eq 'T'><th>Action</th></cfif>
      </tr>
      <cfoutput query="similarResult"> 
        <tr> 
          <td>#exactResult.langno#</td>
          <td>#exactResult.english#</td>
          <td>#exactResult.chinese#</td>
          <cfif getpin2.h1H11 eq 'T'><td width="10%" nowrap> 
            <div align="center"><a href="languagetable2.cfm?type=Delete&langno=#similarResult.langno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              <a href="languagetable2.cfm?type=Edit&langno=#similarResult.langno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
        </tr>
      </cfoutput> 
    </table>
			<cfelse>
				<h3>No Similar Records were found.</h3>
			</cfif>
		</cfif>
		
		<cfparam name="i" default="1" type="numeric">
		<hr>
		
		<fieldset>
		<legend style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 12px;
		font-style: italic;line-height: normal;font-weight: bold;text-transform: capitalize;color: #0066FF;"> 
		<cfoutput>20 Newest language :</cfoutput></legend>
		<br>
		<cfif #type.recordCount# neq 0>
		
  <table align="center" class="data" width="600px">
    <tr> 
      <th width="40">No</th>
      <th width="60"><cfoutput>Language</cfoutput></th>
      <th>English</th>
         <th>Chinese</th>
      <cfif getpin2.h1H11 eq 'T'><th width="70">Action</th></cfif>
    </tr>
    <cfoutput query="type" maxrows="20"> 
      <tr> 
        <td>#i#</td>
        <td>#langno#</a></td>
          <td>#english#</td>
          <td>#chinese#</td>
        <cfif getpin2.h1H11 eq 'T'><td width="10%" nowrap> 
          <div align="center"><a href="languagetable2.cfm?type=Delete&langno=#type.langno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
            <a href="languagetable2.cfm?type=Edit&langno=#type.langno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
      </tr>
      <cfset i = incrementvalue(#i#)>
    </cfoutput> 
  </table>
		<cfelse>
			<h3>No Records were found.</h3>
		</cfif>
		<br>
		</fieldset>
	<!--- <cfelse>
		<h1>URL Error. Please Click On The Correct Link.</h1>
	</cfif> --->	

</body>
</html>
