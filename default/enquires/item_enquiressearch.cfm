<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>Item Balance Enquires</title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<cfquery datasource="#dts#" name="getitem">
	select itemno, desp from icitem
</cfquery>

<body>
<h1 align="left">Item<cfoutput> Selection Page</cfoutput> </h1>

<div align="left">
<form action="item_enquiressearch.cfm" method="post" target="_self">
<cfoutput>
			<h1>Search By :
			
			<select name="searchType">
				<option value="itemno">Item No</option>
				<option value="mitemno">Product Code</option>
				<option value="desp" <cfif lcase(hcomid) eq "mhca_i">selected</cfif>>Description</option>
				<option value="category">Category</option>
				<option value="wos_group">Group</option>
				<option value="brand">Brand</option>
			</select>
        Search for Icitem : <input type="text" name="searchStr" value=""> </h1>
			</cfoutput>
</form>

		<cfquery datasource='#dts#' name="type">
			Select * from Icitem order by itemno, desp
		</cfquery>
		
		<cfif isdefined("form.searchStr")>
			<cfquery datasource='#dts#' name="exactResult">
				Select * from icitem where #form.searchType# = '#form.searchStr#' <cfif form.searchType eq "desp"> or despa = '#form.searchStr#'</cfif>
			</cfquery>
			
			<cfquery datasource='#dts#' name="similarResult">
				Select * from icitem where #form.searchType# LIKE '%#form.searchStr#%' <cfif form.searchType eq "desp"> or despa LIKE '%#form.searchStr#%'</cfif>
			</cfquery>
			
			<h2>Exact Result</h2>
			<cfif #exactResult.recordCount# neq 0>
			<table align="center" class="data" width="550px">					
					
					<tr>
						
						<th>Item No</th>
						<th>Description</th>
						<th>Brand</th>
						<th>Category</th>
						<th>Group</th>
						<th>Price</th>
						<th>Action</th>
					</tr>
					<cfoutput query="exactResult" maxrows="10">
					<tr>
						<td>#exactResult.itemno#</a></td>
						<td>#exactResult.desp#<br>#exactResult.despa#</td>
						<td>#exactResult.brand#</td>
						<td>#exactResult.category#</td>
						<td>#exactResult.wos_group#</td>
						<td>#exactResult.price#</td>
						<td>
							<a href="item_enquires.cfm?itemno1=#exactResult.itemno#">Select</a>
						</td>
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
						
						<th>Item No</th>
						<th>Description</th>
						<th>Brand</th>
						<th>Category</th>
						<th>Group</th>
						<th>Price</th>
						<th>Action</th>
					</tr>
					<cfoutput query="similarResult" >
					<tr>
						<td>#similarResult.itemno#</a></td>
						<td>#similarResult.desp#<br>#similarResult.despa#</td>
						<td>#similarResult.brand#</td>
						<td>#similarResult.category#</td>
						<td>#similarResult.wos_group#</td>
						<td>#similarResult.price#</td>
						<td>
							<a href="item_enquires.cfm?itemno1=#similarResult.itemno#">Select</a>
						</td>
					</tr>
					</cfoutput>
			</table>
			<cfelse>
				<h3>No Similar Records were found.</h3>
			</cfif>
		</cfif>
		
		<cfparam name="i" default="1" type="numeric">
		<hr>
		
		<fieldset><legend style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 12px;
		font-style: italic;line-height: normal;font-weight: bold;text-transform: capitalize;color: #0066FF;">
		<cfoutput>20 Newest Icitem:</cfoutput></legend><br>
		<cfif #type.recordCount# neq 0>
		<table align="center" class="data" width="600px">					
				
				<tr>
						<th>No.</th>
						<th>Item No</th>
						<th>Description</th>
						<th>Brand</th>
						<th>Category</th>
						<th>Group</th>
						<th>Price</th>
						<th>Action</th>
				</tr>
				<cfoutput query="type" maxrows="20">
				<tr>
						
						<td>#i#</td>
						<td>#type.itemno#</a></td>
						<td>#type.desp#<br>#type.despa#</td>
						<td>#type.brand#</td>
						<td>#type.category#</td>
						<td>#type.wos_group#</td>
						<td>#type.price#</td>
						<td>
							<a href="item_enquires.cfm?itemno1=#type.itemno#">Select</a>			
						</td>
				</tr>
				<cfset i = incrementvalue(#i#)>
				</cfoutput>
		</table>
		<cfelse>
			<h3>No Records were found.</h3>
		</cfif>
</body>
</html>
