<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>
		
<h1><cfoutput>Brand Selection Page</cfoutput></h1>
		
<cfoutput>
	<h4>
		<cfif getpin2.h1P10 eq 'T'><a href="brandtable2.cfm?type=Create">Creating a New Brand</a> </cfif>
		<cfif getpin2.h1P20 eq 'T'>|| <a href="brandtable.cfm">List all Brand</a> </cfif>
		<cfif getpin2.h1P30 eq 'T'>|| <a href="s_brandtable.cfm?type=brand">Search For Brand</a></cfif>
	</h4>
</cfoutput>
		
<cfoutput>
	<form action="s_brandtable.cfm" method="post"></cfoutput>
	<cfoutput>
		<h1>Search By :
		<select name="searchType">
			<option value="brand">Brand</option>
		</select>
        Search for Brand : <input type="text" name="searchStr" value=""> </h1>
	</cfoutput>
	</form>
		
	<cfif isdefined("url.process")>
		<cfoutput><h1>#form.status#</h1><hr></cfoutput>
	</cfif>
	
	<cfquery datasource='#dts#' name="type">
		Select * from brand order by brand, desp
	</cfquery>
		
	<cfif isdefined("form.searchStr")>
		<cfquery datasource='#dts#' name="exactResult">
			Select * from brand where #form.searchType# = '#form.searchStr#' order by brand, desp
		</cfquery>
			
		<cfquery datasource='#dts#' name="similarResult">
			Select * from brand where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by brand, desp
		</cfquery>
			
		<h2>Exact Result</h2>
		<cfif exactResult.recordCount neq 0>
			<table align="center" class="data" width="600px">				
	     		<tr> 
	        		<cfoutput><th>Brand</th></cfoutput>
					<th>Description</th>
					<cfif getpin2.h1P11 eq 'T'><th>Action</th></cfif>				
				</tr>
				<cfoutput query="exactResult">
					<tr>
						<td>#exactResult.brand#</a></td>
						<td>#exactResult.desp#</td>						
	          			<cfif getpin2.h1P11 eq 'T'>
		          			<td width="10%" nowrap><div align="center">
			          			<a href="brandtable2.cfm?type=Delete&brand=#URLEncodedFormat(exactResult.brand)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>
			          			&nbsp;<a href="brandtable2.cfm?type=Edit&brand=#URLEncodedFormat(exactResult.brand)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
							</div></td>
						</cfif>
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
	        		<cfoutput><th>Brand</th></cfoutput>
					<th>Description</th>
					<cfif getpin2.h1P11 eq 'T'><th>Action</th></cfif>
				</tr>
				<cfoutput query="similarResult">
					<tr>
						<td>#similarResult.brand#</a></td>
						<td>#similarResult.desp#</td>						
	          			<cfif getpin2.h1P11 eq 'T'>
		          			<td width="10%" nowrap> 
	            				<div align="center"><a href="brandtable2.cfm?type=Delete&brand=#URLEncodedFormat(similarResult.brand)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>
	            				&nbsp;<a href="brandtable2.cfm?type=Edit&brand=#URLEncodedFormat(similarResult.brand)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
								</div>
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
		<cfoutput>20 Newest Brand :</cfoutput>
	</legend>
	<br>
		<cfif type.recordCount neq 0>
			<table align="center" class="data" width="600px">	
				<tr>
					<th>No.</th>
	      			<cfoutput><th>Brand</th></cfoutput>
					<th>Description</th>
					<cfif getpin2.h1P11 eq 'T'><th>Action</th></cfif>
				</tr>
				<cfoutput query="type" maxrows="20">
					<tr>	
						<td>#i#</td>
						<td>#type.brand#</a></td>
						<td>#type.desp#<br></td>						
		       			<cfif getpin2.h1P11 eq 'T'>
			       			<td width="10%" nowrap>
				       			<div align="center"><a href="brandtable2.cfm?type=Delete&brand=#URLEncodedFormat(type.brand)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>
				       			&nbsp;<a href="brandtable2.cfm?type=Edit&brand=#URLEncodedFormat(type.brand)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
								</div>
							</td>
						</cfif>
					</tr>
					<cfset i = incrementvalue(#i#)>
				</cfoutput>
			</table>
		<cfelse>
			<h3>No Records were found.</h3>
		</cfif>
		<br>
	</fieldset>
</body>
</html>
