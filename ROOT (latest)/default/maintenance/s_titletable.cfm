<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>
		
<h1>Matrix Item Selection Page</h1>
		
<cfoutput>
  <h4>
	<cfif getpin2.h1N10 eq 'T'><a href="titletable2.cfm?type=Create">Creating a New Title</a> </cfif>
	<cfif getpin2.h1N20 eq 'T'>|| <a href="titletable.cfm">List All Title</a> </cfif>
	<cfif getpin2.h1N30 eq 'T'>|| <a href="s_titletable.cfm">Search For Title</a> </cfif>
  </h4>
</cfoutput>
		
<cfoutput>
<form action="s_titletable.cfm" method="post"></cfoutput>
	<cfoutput>
	<h1>Search By :
	
	<select name="searchType">
		<option value="title_id">Title ID</option>
		<option value="desp">Description</option>
	</select>
	Search for Title : 
	<input type="text" name="searchStr" value=""> 
	</h1>
	</cfoutput>
</form>

<cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1><hr></cfoutput>
</cfif>

<cfquery datasource='#dts#' name="type">
	Select * from title order by title_id
</cfquery>

<cfif isdefined("form.searchStr")>
	<cfquery datasource='#dts#' name="exactResult">
		Select * from title where #form.searchType# = '#form.searchStr#' order by title_id
	</cfquery>
	
	<cfquery datasource='#dts#' name="similarResult">
		Select * from title where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by title_id
	</cfquery>
	
	<h2>Exact Result</h2>
	<cfif #exactResult.recordCount# neq 0>
	
		<table align="center" class="data" width="600px">
		  <tr> 
			<th>Title ID</th>
			<th>Description</th>
			<cfif getpin2.h1N11 eq 'T'><th>Action</th></cfif>
		  </tr>
		  <cfoutput query="exactResult"> 
			<tr> 
			  	<td>#exactResult.title_id#</td>
			 	<td>#exactResult.desp#</td>
			  	<cfif getpin2.h1N11 eq 'T'>
				<td width="20%" nowrap><div align="center"><a href="titletable2.cfm?type=Delete&title_id=#exactResult.title_id#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="titletable2.cfm?type=Edit&title_id=#exactResult.title_id#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
				</td>
				</cfif>
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
        <th>Title ID</th>
			<th>Description</th>
		<cfif getpin2.h1N11 eq 'T'><th>Action</th></cfif>
      </tr>
      <cfoutput query="similarResult"> 
        <tr> 
          	<td>#similarResult.title_id#</td>
			<td>#similarResult.desp#</td>
          	<cfif getpin2.h1N11 eq 'T'>
				<td width="20%" nowrap><div align="center"><a href="titletable2.cfm?type=Delete&title_id=#similarResult.title_id#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              	<a href="titletable2.cfm?type=Edit&title_id=#similarResult.title_id#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
				</td>
			</cfif>
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
		<cfoutput>20 Newest Title:</cfoutput></legend>
		<br>
		<cfif #type.recordCount# neq 0>
  		<cfelse>
			<h3>No Records were found.</h3>
		</cfif>
		<br>
		
<table align="center" class="data" width="600px">
  <tr> 
    <th>No</th>
    <th>Title ID</th>
	<th>Description</th>
    <cfif getpin2.h1N11 eq 'T'><th>Action</th></cfif>
  </tr>
  <cfoutput query="type" maxrows="20"> 
    <tr> 
      	<td>#i#</td>
      	<td>#type.title_id#</td>
		<td>#type.desp#</td>
      	<cfif getpin2.h1N11 eq 'T'>
			<td width="20%" nowrap><div align="center"><a href="titletable2.cfm?type=Delete&title_id=#type.title_id#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
          		<a href="titletable2.cfm?type=Edit&title_id=#type.title_id#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
			</td>
		</cfif>
    </tr>
    <cfset i = incrementvalue(#i#)>
  </cfoutput> 
</table>
<br>
</fieldset>
</body>
</html>
