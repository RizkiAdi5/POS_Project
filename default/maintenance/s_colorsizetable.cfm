<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>
		
<h1>Color - Size Selection Page</h1>
		
<cfoutput>
  <h4>
	<cfif getpin2.h1L10 eq 'T'><a href="colorsizetable2.cfm?type=Create">Creating a New Color - Size</a> </cfif>
	<cfif getpin2.h1L20 eq 'T'>|| <a href="colorsizetable.cfm">List all Color - Size</a> </cfif>
	<cfif getpin2.h1L30 eq 'T'>|| <a href="s_colorsizetable.cfm?type=Icitem">Search For Color - Size</a> </cfif>
  </h4>
</cfoutput>
		
<cfoutput>
<form action="s_colorsizetable.cfm" method="post"></cfoutput>
	<cfoutput>
	<h1>Search By :
	
	<select name="searchType">
		<option value="colorno">Color No.</option>
		<option value="colorid2">Color ID</option>
	</select>
	Search for Color - Size : 
	<input type="text" name="searchStr" value=""> 
	</h1>
	</cfoutput>
</form>

<cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1><hr></cfoutput>
</cfif>

<cfquery datasource='#dts#' name="type">
	Select * from iccolor2 order by colorno,colorid2
</cfquery>

<cfif isdefined("form.searchStr")>
	<cfquery datasource='#dts#' name="exactResult">
		Select * from iccolor2 where #form.searchType# = '#form.searchStr#' order by colorno,colorid2
	</cfquery>
	
	<cfquery datasource='#dts#' name="similarResult">
		Select * from iccolor2 where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by colorno,colorid2
	</cfquery>
	
	<h2>Exact Result</h2>
	<cfif #exactResult.recordCount# neq 0>
	
		<table align="center" class="data" width="600px">
		  <tr> 
			<th>Color No.</th>
			<th>Color ID</th>
			<th>Description</th>
			<cfif getpin2.h1L11 eq 'T'><th>Action</th></cfif>
		  </tr>
		  <cfoutput query="exactResult"> 
			<tr> 
			  	<td>#exactResult.colorno#</td>
			 	<td>#exactResult.colorid2#</td>
			  	<td>#exactResult.desp#</td>
			  	<cfif getpin2.h1L11 eq 'T'>
				<td width="20%" nowrap><div align="center"><a href="colorsizetable2.cfm?type=Delete&colorid2=#exactResult.colorid2#&colorno=#exactResult.colorno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="colorsizetable2.cfm?type=Edit&colorid2=#exactResult.colorid2#&colorno=#exactResult.colorno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
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
        <th>Color No.</th>
		<th>Color ID</th>
        <th>Description</th>
		<cfif getpin2.h1L11 eq 'T'><th>Action</th></cfif>
      </tr>
      <cfoutput query="similarResult"> 
        <tr> 
          	<td>#similarResult.colorno#</a></td>
			<td>#similarResult.colorid2#</a></td>
          	<td>#similarResult.desp#</td>
          	<cfif getpin2.h1L11 eq 'T'>
				<td width="20%" nowrap><div align="center"><a href="colorsizetable2.cfm?type=Delete&colorid2=#similarResult.colorid2#&colorno=#similarResult.colorno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              	<a href="colorsizetable2.cfm?type=Edit&colorid2=#similarResult.colorid2#&colorno=#similarResult.colorno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
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
		<cfoutput>20 Newest Color - Size :</cfoutput></legend>
		<br>
		<cfif #type.recordCount# neq 0>
  		<cfelse>
			<h3>No Records were found.</h3>
		</cfif>
		<br>
		
<table align="center" class="data" width="600px">
  <tr> 
    <th>No</th>
    <th>Color No.</th>
	<th>Color ID</th>  
    <th>Description</th>
    <cfif getpin2.h1L11 eq 'T'><th>Action</th></cfif>
  </tr>
  <cfoutput query="type" maxrows="20"> 
    <tr> 
      	<td>#i#</td>
      	<td>#type.colorno#</td>
		<td>#type.colorid2#</td>
      	<td>#type.desp#</td>
      	<cfif getpin2.h1L11 eq 'T'>
			<td width="20%" nowrap><div align="center"><a href="colorsizetable2.cfm?type=Delete&colorid2=#type.colorid2#&colorno=#type.colorno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
          		<a href="colorsizetable2.cfm?type=Edit&colorid2=#type.colorid2#&colorno=#type.colorno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
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
