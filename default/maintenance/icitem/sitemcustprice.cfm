<html>
<head>
<title>Recommended Price Selection Page - Item / Customer</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<h1>Recommended Price Selection Page - Customer / Item</h1>

<cfoutput>
  	<h4>
		<a href="itemcustprice2.cfm?type=create">Create a Recommended Price</a> ||
    	<a href="itemcustprice.cfm">List All Recommended Price</a> ||
		<a href="sitemcustprice.cfm">Search Recommended Price</a> ||
		<a href="../icitem_setting.cfm">More Setting</a>
  	</h4>
</cfoutput>

<form action="sitemcustprice.cfm" method="post">
	<cfoutput>
	<h1>Search By :
	<select name="searchType">
		<option value="custno">Customer No</option>
		<option value="xname">Customer Name</option>
	</select>
    Search for Recommended Price:
    <input type="text" name="searchStr" value="">
	</h1>
	</cfoutput>
</form>

<cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1><hr></cfoutput>
</cfif>

<cfquery datasource='#dts#' name="type">
	Select a.*, b.name as xname, b.currcode,b.status from Icl3p2 a, #target_arcust# b where a.custno = b.custno group by a.custno order by a.custno
</cfquery>

<cfif isdefined("form.searchStr")>
	<cfquery dbtype="query" name="exactResult">
		Select * from TYPE where #form.searchType# = '#form.searchStr#' order by custno
	</cfquery>

	<cfquery dbtype="query" name="similarResult">
		Select * from TYPE where #form.searchType# LIKE '#form.searchStr#' order by custno
	</cfquery>

	<h2>Exact Result</h2>

	<cfif exactResult.recordCount neq 0>
		<table align="center" class="data" width="65%" cellpadding="2" cellspacing="0">
			<tr>
				<th>Customer No</th>
				<th>Name</th>
				<th>Currency</th>
				<th>Status</th>
				<th>Action</th>
			</tr>

			<cfoutput query="exactResult">
				<tr>
					<td>#exactResult.custno#</td>
					<td>#exactResult.xname#</td>
					<td>#exactResult.currcode#</td>
					<td align="center">#exactResult.status#</td>
					<td><div align="center">
					<a href="../icitem/itemcustprice2.cfm?type=Delete&custno=#URLEncodedFormat(exactResult.custno)#&status=#exactResult.status#">Delete</a>&nbsp;
					<a href="../icitem/itemcustprice3.cfm?type=Edit&custno=#URLEncodedFormat(exactResult.custno)#&status=#exactResult.status#">Edit</a></div>
					</td>
				</tr>
			</cfoutput>
		</table>
	<cfelse>
		<h3>No Exact Records were found.</h3>
	</cfif>

	<h2>Similar Result</h2>

	<cfif similarResult.recordCount neq 0>
		<table align="center" class="data" width="65%" cellpadding="2" cellspacing="0">
			<tr>
				<th>Customer No</th>
				<th>Name</th>
				<th>Currency</th>
				<th>Status</th>
				<th>Action</th>
			</tr>

			<cfoutput query="similarResult">
				<tr>
					<td>#similarResult.custno#</td>
					<td>#similarResult.xname#</td>
					<td>#similarResult.currcode#</td>
					<td align="center">#similarResult.status#</td>
					<td><div align="center">
					<a href="../icitem/itemcustprice2.cfm?type=Delete&custno=#URLEncodedFormat(similarResult.custno)#&status=#similarResult.status#">Delete</a>&nbsp;
					<a href="../icitem/itemcustprice3.cfm?type=Edit&custno=#URLEncodedFormat(similarResult.custno)#&status=#similarResult.status#">Edit</a></div>
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
	<table align="center" class="data" width="65%" cellpadding="2" cellspacing="0">
		<tr>
			<th>Customer No</th>
			<th>Name</th>
			<th>Currency</th>
			<th>Status</th>
			<th>Action</th>
		</tr>

		<cfoutput query="type" maxrows="20">
			<tr>
				<td>#type.custno#</td>
				<td>#type.xname#</td>
				<td>#type.currcode#</td>
				<td align="center">#type.status#</td>
        		<td nowrap><div align="center">
				<a href="../icitem/itemcustprice2.cfm?type=Delete&custno=#URLEncodedFormat(type.custno)#&status=#type.status#">Delete</a>&nbsp;
       			<a href="../icitem/itemcustprice3.cfm?type=Edit&custno=#URLEncodedFormat(type.custno)#&status=#type.status#">Edit</a></div>
			</td>
			</tr>
			<cfset i = incrementvalue(i)>
		</cfoutput>
	</table>
<cfelse>
	<h3>No Records were found.</h3>
</cfif>

<br></fieldset>
</body>
</html>