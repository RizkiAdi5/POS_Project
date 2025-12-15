<html>
<head>
<title>Recommended Price Selection Page - Item / Customer</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<h1>Recommended Price Selection Page - Item / Customer</h1>

<cfoutput>
  	<h4>
		<a href="custitemprice2.cfm?type=create">Create a Recommended Price</a> ||
    	<a href="custitemprice.cfm">List All Recommended Price</a> ||
		<a href="scustitemprice.cfm">Search Recommended Price</a> ||
		<a href="../icitem_setting.cfm">More Setting</a>
  	</h4>
</cfoutput>

<form action="scustitemprice.cfm" method="post">
	<h1>Search By :
	<select name="searchType">
		<option value="itemno">Item No</option>
		<option value="xdesp">Description</option>
	</select>
	Search for Recommended Price:
	<input type="text" name="searchStr" value="">
	</h1>
</form>

<cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1><hr></cfoutput>
</cfif>

<cfquery datasource='#dts#' name="type">
	Select a.*,b.desp as xdesp,b.nonstkitem from Icl3p2 a, icitem b where a.itemno = b.itemno group by a.itemno order by a.itemno
</cfquery>

<cfif isdefined("form.searchStr")>
	<cfquery dbtype="query" name="exactResult">
		Select * from TYPE where #form.searchType# = '#form.searchStr#' order by itemno
	</cfquery>

	<cfquery dbtype="query" name="similarResult">
		Select * from TYPE where #form.searchType# LIKE '#form.searchStr#' order by itemno
	</cfquery>

	<h2>Exact Result</h2>

	<cfif exactResult.recordCount neq 0>
		<table align="center" class="data" width="60%">
			<tr>
				<th>Item No</th>
				<th>Desciption</th>
				<th>Status</th>
				<th>Action</th>
			</tr>
			<cfoutput query="exactResult">
				<tr>
					<td>#exactResult.itemno#</td>
					<td>#exactResult.xdesp#</td>
					<td align="center">#exactResult.nonstkitem#</td>
					<td align="center">
					<a href="../icitem/custitemprice2.cfm?type=Delete&itemno=#URLEncodedFormat(exactResult.itemno)#&status=#exactResult.nonstkitem#">Delete</a>
					<a href="../icitem/custitemprice3.cfm?type=Edit&itemno=#URLEncodedFormat(exactResult.itemno)#&status=#exactResult.nonstkitem#">Edit</a>
					</td>
				</tr>
			</cfoutput>
		</table>
	<cfelse>
		<h3>No Exact Records were found.</h3>
	</cfif>

	<h2>Similar Result</h2>

	<cfif similarResult.recordCount neq 0>
		<table align="center" class="data" width="60%">
			<tr>
				<th>Item No</th>
				<th>Desciption</th>
				<th>Status</th>
				<th>Action</th>
			</tr>
			<cfoutput query="similarResult">
				<tr>
					<td>#similarResult.itemno#</td>
					<td>#similarResult.xdesp#</td>
					<td align="center">#similarResult.nonstkitem#</td>
					<td align="center">
					<a href="../icitem/custitemprice2.cfm?type=Delete&itemno=#URLEncodedFormat(similarResult.itemno)#&status=#similarResult.nonstkitem#">Delete</a>
					<a href="../icitem/custitemprice3.cfm?type=Edit&itemno=#URLEncodedFormat(similarResult.itemno)#&status=#similarResult.nonstkitem#">Edit</a>
					</td>
				</tr>
			</cfoutput>
		</table>
	<cfelse>
		<h3>No Similar Records were found.</h3>
	</cfif>
</cfif>

<cfparam name="i" default="1" type="numeric">

<hr><fieldset>
<legend style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 12px;font-style: italic;line-height: normal;font-weight: bold;text-transform: capitalize;color: #0066FF;">
	20 Newest Recommended Price:
</legend><br>

<cfif type.recordCount neq 0>
	<table align="center" class="data" width="60%">
		<tr>
			<th>Item No</th>
		   	<th>Desciption</th>
			<th>Status</th>
			<th>Action</th>
		</tr>
		<cfoutput query="type" maxrows="20">
			<tr>
				<td>#type.itemno#</td>
				<td>#type.xdesp#</td>
				<td align="center">#type.nonstkitem#</td>
				<td align="center">
				<a href="../icitem/custitemprice2.cfm?type=Delete&itemno=#URLEncodedFormat(type.itemno)#&status=#type.nonstkitem#">Delete</a>
				<a href="../icitem/custitemprice3.cfm?type=Edit&itemno=#URLEncodedFormat(type.itemno)#&status=#type.nonstkitem#">Edit</a></td>
			</tr>
			<cfset i = incrementvalue(i)>
		</cfoutput>
	</table>
<cfelse>
	<h3>No Records were found.</h3>
</cfif>

<br>
</fieldset>
</body>
</html>