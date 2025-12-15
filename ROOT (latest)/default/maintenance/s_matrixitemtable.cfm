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
	<cfif getpin2.h1M10 eq 'T'><a href="matrixitemtable2.cfm?type=Create">Creating a New Matrix Item</a> </cfif>
	<cfif getpin2.h1M20 eq 'T'>|| <a href="matrixitemtable.cfm">List all Matrix Item</a> </cfif>
	<cfif getpin2.h1M30 eq 'T'>|| <a href="s_matrixitemtable.cfm?type=Icitem">Search For Matrix Item</a> </cfif>
  </h4>
</cfoutput>
		
<cfoutput>
<form action="s_matrixitemtable.cfm" method="post"></cfoutput>
	<cfoutput>
	<h1>Search By :
	
	<select name="searchType">
		<option value="mitemno">Matrix Item No.</option>
		<option value="desp">Description</option>
        <option value="colorno">Color No.</option>
        <option value="category">Category</option>
        <option value="wos_group">Group</option>
	</select>
	Search for Matrix Item : 
	<input type="text" name="searchStr" value=""> 
	</h1>
	</cfoutput>
</form>

<cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1><hr></cfoutput>
</cfif>

<cfquery datasource='#dts#' name="type">
	Select * from icmitem order by mitemno,desp
</cfquery>

<cfif isdefined("form.searchStr")>
	<cfquery datasource='#dts#' name="exactResult">
		Select * from icmitem where #form.searchType# = '#form.searchStr#' order by mitemno,desp
	</cfquery>
	
	<cfquery datasource='#dts#' name="similarResult">
		Select * from icmitem where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by mitemno,desp
	</cfquery>
	
	<h2>Exact Result</h2>
	<cfif #exactResult.recordCount# neq 0>
	
		<table align="center" class="data" width="600px">
		  <tr> 
			<th>Matrix Item No.</th>
			<th>Description</th>
			<th>Color No.</th>
            <th>Category</th>
            <th>Group</th>
			<cfif getpin2.h1M11 eq 'T'><th>Action</th></cfif>
		  </tr>
		  <cfoutput query="exactResult"> 
			<tr> 
			  	<td>#exactResult.mitemno#</td>
			 	<td>#exactResult.desp#</td>
			  	<td>#exactResult.colorno#</td>
                <td>#exactResult.category#</td>
                <td>#exactResult.wos_group#</td>
			  	<cfif getpin2.h1M11 eq 'T'>
				<td width="20%" nowrap><div align="center"><a href="matrixitemtable2.cfm?type=Delete&mitemno=#exactResult.mitemno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="matrixitemtable2.cfm?type=Edit&mitemno=#exactResult.mitemno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
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
        <th>Matrix Item No.</th>
		<th>Description</th>
        <th>Description</th>
        <th>Category</th>
        <th>Group</th>
		<cfif getpin2.h1L11 eq 'T'><th>Action</th></cfif>
      </tr>
      <cfoutput query="similarResult"> 
        <tr> 
          	<td>#similarResult.mitemno#</td>
			<td>#similarResult.desp#</td>
          	<td>#similarResult.colorno#</td>
            <td>#similarResult.category#</td>
			<td>#similarResult.wos_group#</td>
          	<cfif getpin2.h1M11 eq 'T'>
				<td width="20%" nowrap><div align="center"><a href="matrixitemtable2.cfm?type=Delete&mitemno=#similarResult.mitemno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              	<a href="matrixitemtable2.cfm?type=Edit&mitemno=#similarResult.mitemno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
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
		<cfoutput>20 Newest Matrix Item:</cfoutput></legend>
		<br>
		<cfif #type.recordCount# neq 0>
  		<cfelse>
			<h3>No Records were found.</h3>
		</cfif>
		<br>
		
<table align="center" class="data" width="600px">
  <tr> 
    <th>No</th>
    <th>Matrix Item No.</th>
	<th>Description</th>  
    <th>Color No.</th>
    <th>Category</th>
    <th>Group</th>
    <cfif getpin2.h1M11 eq 'T'><th>Action</th></cfif>
  </tr>
  <cfoutput query="type" maxrows="20"> 
    <tr> 
      	<td>#i#</td>
      	<td>#type.mitemno#</td>
		<td>#type.desp#</td>
      	<td>#type.colorno#</td>
        <td>#type.category#</td>
        <td>#type.wos_group#</td>
      	<cfif getpin2.h1M11 eq 'T'>
			<td width="20%" nowrap><div align="center"><a href="matrixitemtable2.cfm?type=Delete&mitemno=#type.mitemno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
          		<a href="matrixitemtable2.cfm?type=Edit&mitemno=#type.mitemno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
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
