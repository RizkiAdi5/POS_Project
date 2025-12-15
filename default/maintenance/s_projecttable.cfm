<cfquery datasource="#dts#" name="getgeneral">
	Select lPROJECT as layer from gsetup
</cfquery>
<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

	<!--- <cfset typeNo=#url.type# & "No"> 
	<cfset link = #url.type# &".cfm"> --->
	
	<!--- <cfif isdefined("URL.Type")> --->
		
<h1><cfoutput>#getgeneral.layer# Selection Page</cfoutput></h1>
		
<cfoutput>
	<h4>
		<cfif getpin2.h1H10 eq 'T'><a href="Projecttable2.cfm?type=Create">Creating a #getgeneral.layer#</a> </cfif>
		<cfif getpin2.h1H20 eq 'T'>|| <a href="Projecttable.cfm?">List all #getgeneral.layer#</a> </cfif>
		<cfif getpin2.h1H30 eq 'T'>|| <a href="s_Projecttable.cfm?type=project">Search For #getgeneral.layer#</a></cfif>||<a href="p_project.cfm">#getgeneral.layer# Listing report</a>
	</h4>
</cfoutput>
		
		<cfoutput>
		<form action="s_Projecttable.cfm" method="post"></cfoutput>
			<cfoutput>
			<h1>Search By :
			
			<select name="searchType">
				<option value="source">#getgeneral.layer#</option>
				<option value="project">Description</option>
			</select>
      Search for #getgeneral.layer# : 
      <input type="text" name="searchStr" value=""> </h1>
			</cfoutput>
		</form>
		
		<cfif isdefined("url.process")>
				<cfoutput><h1>#form.status#</h1><hr></cfoutput>
		</cfif>
	
		<cfquery datasource='#dts#' name="type">
			Select * from project where porj = "P" order by source, project, porj
		</cfquery>
		
		<cfif isdefined("form.searchStr")>
			<cfquery datasource='#dts#' name="exactResult">
				Select * from project where #form.searchType# = '#form.searchStr#' and porj = "P" order by #form.searchType#
			</cfquery>
			
			<cfquery datasource='#dts#' name="similarResult">
				Select * from project where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> and porj = "P" order by #form.searchType#
			</cfquery>
			
			<h2>Exact Result</h2>
			<cfif exactResult.recordCount neq 0>
			
    <table align="center" class="data" width="600px">
      <tr> 
        <th><cfoutput>#getgeneral.layer#</cfoutput></th>
        <th>Description</th>
<!---         <th>P or J</th> --->
        <cfif getpin2.h1H11 eq 'T'><th>Action</th></cfif>
      </tr>
      <cfoutput query="exactResult"> 
        <tr> 
          <td>#exactResult.source#</a></td>
          <td>#exactResult.project#</td>
<!---           <td>#exactResult.porj#</td> --->
          <cfif getpin2.h1H11 eq 'T'><td width="10%" nowrap> 
            <div align="center"><a href="Projecttable2.cfm?type=Delete&source=#URLEncodedFormat(exactResult.source)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              <a href="Projecttable2.cfm?type=Edit&source=#URLEncodedFormat(exactResult.source)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
        </tr>
      </cfoutput> 
    </table>
			<cfelse>
				<h3>No Exact Records were found.</h3>
			</cfif>
			
			<h2>Similar Result</h2>
			<cfif similarResult.recordCount neq 0>
			
    <table align="center" class="data" width="600px">
      <tr> 
        <th><cfoutput>#getgeneral.layer#</cfoutput></th>
        <th>Description</th>
<!---         <th>P or J</th> --->
        <cfif getpin2.h1H11 eq 'T'><th>Action</th></cfif>
      </tr>
      <cfoutput query="similarResult"> 
        <tr> 
          <td>#similarResult.source#</a></td>
          <td>#similarResult.project#</td>
 <!---          <td>#similarResult.porj#</td> --->
          <cfif getpin2.h1H11 eq 'T'><td width="10%" nowrap> 
            <div align="center"><a href="Projecttable2.cfm?type=Delete&source=#URLEncodedFormat(similarResult.source)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              <a href="Projecttable2.cfm?type=Edit&source=#URLEncodedFormat(similarResult.source)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
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
		<cfoutput>20 Newest #getgeneral.layer# :</cfoutput></legend>
		<br>
		<cfif #type.recordCount# neq 0>
		
  <table align="center" class="data" width="600px">
    <tr> 
      <th width="40">No</th>
      <th width="60"><cfoutput>#getgeneral.layer#</cfoutput></th>
      <th>Description</th>
<!---       <th width="45">P or J</th> --->
      <cfif getpin2.h1H11 eq 'T'><th width="70">Action</th></cfif>
    </tr>
    <cfoutput query="type" maxrows="20"> 
      <tr> 
        <td>#i#</td>
        <td>#type.source#</a></td>
        <td>#type.project#</td>
<!---         <td>#type.porj#</td> --->
        <cfif getpin2.h1H11 eq 'T'><td width="10%" nowrap> 
          <div align="center"><a href="Projecttable2.cfm?type=Delete&source=#URLEncodedFormat(type.source)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
            <a href="Projecttable2.cfm?type=Edit&source=#URLEncodedFormat(type.source)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
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
