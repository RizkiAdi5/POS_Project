<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

		
<h1><cfoutput>Ship Via Selection Page</cfoutput></h1>
		
<cfoutput>
  <h4><cfif getpin2.h1A10 eq 'T'><a href="shipvia.cfm?type=Create">Create a Ship Via</a> </cfif><cfif getpin2.h1A20 eq 'T'>|| <a href="shipviaV.cfm?">List 
    all Ship Via</a> </cfif><cfif getpin2.h1A30 eq 'T'>|| <a href="shipviaS.cfm">Search For Ship Via</a></cfif></h4>
</cfoutput>
		
		<cfoutput>
		<form action="shipviaS.cfm" method="post"></cfoutput>
			<cfoutput>
			<h1>Search By :
			
			<select name="searchType">
				<option value="shipvia">Ship Via</option>
				<!--- <option value="phone">#URL.Type# Tel</option> --->
			</select>
      Search for Ship Via : 
      <input type="text" name="searchStr" value=""> </h1>
			</cfoutput>
		</form>
		
		<cfif isdefined("url.process")>
				<cfoutput><h1>#form.status#</h1><hr></cfoutput>
		</cfif>
	
		<cfquery datasource='#dts#' name="type">
			Select * from shipvia order by shipvia
		</cfquery>
		
		<cfif isdefined("form.searchStr")>
			<cfquery datasource='#dts#' name="exactResult">
				Select * from shipvia where #form.searchType# = '#form.searchStr#' order by shipvia
			</cfquery>
			
			<cfquery datasource='#dts#' name="similarResult">
				Select * from shipvia where #form.searchType# LIKE '#form.searchStr#' order by shipvia
			</cfquery>
			
			<h2>Exact Result</h2>
			<cfif #exactResult.recordCount# neq 0>
			<table align="center" class="data" width="600px">					
        			<tr> 
        				<th>Ship Via</th>
						<th>Description</th>
						<cfif getpin2.h1A11 eq 'T'><th>Action</th></cfif>
					</tr>
					<cfoutput query="exactResult">
					<tr>
						<td>#exactResult.ShipVia#</a></td>
						<td>#exactResult.desp#</td>
						<cfif getpin2.h1A11 eq 'T'>
          				<td width="10%" nowrap> 
            			<div align="center"><a href="ShipVia.cfm?type=Delete&shipvia=#exactResult.shipvia#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="shipvia.cfm?type=Edit&shipvia=#exactResult.shipvia#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
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
        				<th>Ship Via</th>
						<th>Description</th>
						<cfif getpin2.h1A11 eq 'T'><th>Action</th></cfif>
					</tr>
					<cfoutput query="similarResult">
					<tr>
						<td>#similarResult.shipvia#</a></td>
						<td>#similarResult.desp#</td>
						<cfif getpin2.h1A11 eq 'T'>
          				<td width="10%" nowrap> 
            			<div align="center"><a href="shipvia.cfm?type=Delete&shipvia=#similarResult.shipvia#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="shipvia.cfm?type=Edit&shipvia=#similarResult.shipvia#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
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
		<cfoutput>20 Newest Ship Via :</cfoutput></legend>
		<br>
		<cfif #type.recordCount# neq 0>
		<table align="center" class="data" width="600px">					
				
				<tr>
						
      					<th>No.</th>						
      					<th>Ship Via</th>
						<th>Description</th>
						<cfif getpin2.h1A11 eq 'T'><th>Action</th></cfif>
				</tr>
				<cfoutput query="type" maxrows="20">
				<tr>
						
						<td>#i#</td>
						<td>#type.shipvia#</a></td>
						<td>#type.desp#<br></td>
						<cfif getpin2.h1A11 eq 'T'>
        				<td width="10%" nowrap> 
          				<div align="center"><a href="shipvia.cfm?type=Delete&shipvia=#type.shipvia#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="shipvia.cfm?type=Edit&shipvia=#type.shipvia#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td></cfif>
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
