<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>	
<!--- ADD ON 15-07-2009 --->
<cfquery name="getGsetup" datasource="#dts#">
  Select lLOCATION from GSetup
</cfquery>

<h1><cfoutput>#getGsetup.lLOCATION#</cfoutput> Selection Page</h1>
		
<cfoutput>
	<h4>
		<cfif getpin2.h1D10 eq 'T'><a href="locationtable2.cfm?type=Create">Creating a New #getGsetup.lLOCATION#</a> </cfif>
		<cfif getpin2.h1D30 eq 'T'>|| <a href="s_locationtable.cfm?type=Icitem">Search For #getGsetup.lLOCATION#</a></cfif>
	</h4>
</cfoutput>	

<form action="s_locationtable.cfm" method="post">
	<cfoutput>
		<h1>Search By :
		<select name="searchType">
			<option value="location">#getGsetup.lLOCATION#</option>
			<!--- <option value="phone">#URL.Type# Tel</option> --->
		</select>
	    Search for #getGsetup.lLOCATION# : <input type="text" name="searchStr" value=""> </h1>
	</cfoutput>
</form>

<cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1><hr></cfoutput>
</cfif>
	
<cfquery datasource='#dts#' name="type">
	Select * from iclocation order by location, desp, addr1, addr2, addr3, addr4, outlet, custno
</cfquery>
		
<cfif isdefined("form.searchStr")>
	<cfquery datasource='#dts#' name="exactResult">
		Select * from iclocation where #form.searchType# = '#form.searchStr#' order by location, desp, addr1, addr2, addr3, addr4, outlet, custno
	</cfquery>
			
	<cfquery datasource='#dts#' name="similarResult">
		Select * from iclocation where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by location, desp, addr1, addr2, addr3, addr4, outlet, custno
	</cfquery>
			
	<h2>Exact Result</h2>
	<cfif exactResult.recordCount neq 0>
		<table align="center" class="data" width="600px">
			<tr>	
				<th><cfoutput>#getGsetup.lLOCATION#</cfoutput></th>
				<th>Description</th>
				<th>Consignment Outlet</th>
				<th>Customer No</th>
				<th>Address</th>
				<cfif getpin2.h1D11 eq 'T'><th>Action</th></cfif>
			</tr>
			<cfoutput query="exactResult">
				<tr>
					<td>#exactResult.location#</a></td>
					<td>#exactResult.desp#</td>
					<td>#exactResult.outlet#</td>
					<td>#exactResult.custno#</td>
					<td>#exactResult.addr1#<br>#exactResult.addr2#<br>#exactResult.addr3#<br>#exactResult.addr4#</td>
					<cfif getpin2.h1D11 eq 'T'>
          				<td width="10%" nowrap> 
            			<div align="center"><a href="locationtable2.cfm?type=Delete&location=#urlencodedformat(exactResult.location)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="locationtable2.cfm?type=Edit&location=#urlencodedformat(exactResult.location)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
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
				<th><cfoutput>#getGsetup.lLOCATION#</cfoutput></th>
				<th>Description</th>
				<th>Consignment Outlet</th>
				<th>Customer No</th>
				<th>Address</th>
				<cfif getpin2.h1D11 eq 'T'><th>Action</th></cfif>
			</tr>
			<cfoutput query="similarResult">
				<tr>
					<td>#similarResult.location#</a></td>
					<td>#similarResult.desp#</td>
					<td>#similarResult.outlet#</td>
					<td>#similarResult.custno#</td>
					<td>#similarResult.addr1#<br>#similarResult.addr2#<br>#similarResult.addr3#<br>#similarResult.addr4#</td>
					<cfif getpin2.h1D11 eq 'T'>
          				<td width="10%" nowrap> 
            			<div align="center"><a href="locationtable2.cfm?type=Delete&location=#urlencodedformat(similarResult.location)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="locationtable2.cfm?type=Edit&location=#urlencodedformat(similarResult.location)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
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
	
<fieldset><legend style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 12px;font-style: italic;line-height: normal;font-weight: bold;text-transform: capitalize;color: #0066FF;">
	<cfoutput>20 Newest #getGsetup.lLOCATION#:</cfoutput></legend><br>
	<cfif type.recordCount neq 0>
		<table align="center" class="data" width="600px">
			<tr>
				<th>No.</th>
				<th><cfoutput>#getGsetup.lLOCATION#</cfoutput></th>
				<th>Description</th>
				<th>Consignment Outlet</th>
				<th>Customer No</th>
				<th>Address</th>
				<cfif getpin2.h1D11 eq 'T'><th>Action</th></cfif>
			</tr>
			<cfoutput query="type" maxrows="20">
				<tr>
					<td>#i#</td>
					<td>#type.location#</a></td>
					<td>#type.desp#</td>
					<td>#type.outlet#</td>
					<td>#type.custno#</td>
					<td>#type.addr1#<br>#type.addr2#<br>#type.addr3#<br>#type.addr4#</td>
					<cfif getpin2.h1D11 eq 'T'>
        				<td width="10%" nowrap>
						<div align="center"><a href="locationtable2.cfm?type=Delete&location=#urlencodedformat(type.location)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="locationtable2.cfm?type=Edit&location=#urlencodedformat(type.location)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
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
	<!--- <cfelse>
		<h1>URL Error. Please Click On The Correct Link.</h1>
	</cfif> --->	
</body>
</html>
