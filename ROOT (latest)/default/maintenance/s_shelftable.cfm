<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<cfquery datasource='#dts#' name="getgeneral">
	Select lmodel as layer from gsetup
</cfquery>
<body>

	<!--- <cfset typeNo=#url.type# & "No"> 
	<cfset link = #url.type# &".cfm"> --->
	
	<!--- <cfif isdefined("URL.Type")> --->
		
<h1><cfoutput>#getgeneral.layer# Selection Page</cfoutput></h1>
		
<cfoutput>
  <h4><cfif getpin2.h1910 eq 'T'><a href="shelftable2.cfm?type=Create">Creating a #getgeneral.layer#</a> </cfif><cfif getpin2.h1920 eq 'T'>|| <a href="shelftable.cfm?">List 
    all #getgeneral.layer#</a> </cfif><cfif getpin2.h1930 eq 'T'>|| <a href="s_shelftable.cfm?type=icshelf">Search For #getgeneral.layer#</a></cfif></h4>
</cfoutput>
		
		<cfoutput>
		<form action="s_shelftable.cfm" method="post"></cfoutput>
			<cfoutput>
			<h1>Search By :
			
			<select name="searchType">
				<option value="shelf">#getgeneral.layer#</option>
				<!--- <option value="phone">#URL.Type# Tel</option> --->
			</select>
      Search for #getgeneral.layer# : 
      <input type="text" name="searchStr" value=""> </h1>
			</cfoutput>
		</form>
		
		<cfif isdefined("url.process")>
				<cfoutput><h1>#form.status#</h1><hr></cfoutput>
		</cfif>
	
		<cfquery datasource='#dts#' name="type">
			Select * from icshelf order by shelf, desp
		</cfquery>
		
		<cfif isdefined("form.searchStr")>
			<cfquery datasource='#dts#' name="exactResult">
				Select * from icshelf where #form.searchType# = '#form.searchStr#' order by shelf, desp
			</cfquery>
			
			<cfquery datasource='#dts#' name="similarResult">
				Select * from icshelf where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by shelf, desp
			</cfquery>
			
			<h2>Exact Result</h2>
			<cfif #exactResult.recordCount# neq 0>
			<table align="center" class="data" width="600px">					
					
					
      				<tr> 
       					<cfoutput><th>#getgeneral.layer#</th></cfoutput>
						<th>Description</th>
						<cfif getpin2.h1911 eq 'T'><th>Action</th></cfif>
					</tr>
					<cfoutput query="exactResult">
					<tr>
						<td>#exactResult.shelf#</a></td>
						<td>#exactResult.desp#</td>
						<cfif getpin2.h1911 eq 'T'>
          				<td width="10%" nowrap> 
            			<div align="center"><a href="shelftable2.cfm?type=Delete&shelf=#exactResult.shelf#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="shelftable2.cfm?type=Edit&shelf=#exactResult.shelf#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
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
        				<cfoutput><th>#getgeneral.layer#</th></cfoutput>
						<th>Description</th>
						<cfif getpin2.h1911 eq 'T'><th>Action</th></cfif>
						
					</tr>
					<cfoutput query="similarResult">
					<tr>
						<td>#similarResult.shelf#</a></td>
						<td>#similarResult.desp#</td>
						<cfif getpin2.h1911 eq 'T'>
          				<td width="10%" nowrap> 
           				<div align="center"><a href="shelftable2.cfm?type=Delete&shelf=#similarResult.shelf#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="shelftable2.cfm?type=Edit&shelf=#similarResult.shelf#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
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
						
      				<th>No.</th>
						
      					<cfoutput><th>#getgeneral.layer#</th></cfoutput>
						<th>Description</th>
						<cfif getpin2.h1911 eq 'T'><th>Action</th></cfif>
				</tr>
				<cfoutput query="type" maxrows="20">
				<tr>
						
						<td>#i#</td>
						<td>#type.shelf#</a></td>
						<td>#type.desp#<br></td>
						<cfif getpin2.h1911 eq 'T'>
        				<td width="10%" nowrap>
						<div align="center"><a href="shelftable2.cfm?type=Delete&shelf=#type.shelf#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="shelftable2.cfm?type=Edit&shelf=#type.shelf#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
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
