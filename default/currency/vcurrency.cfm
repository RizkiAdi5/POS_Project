<html>
<head>
<title>View Currency</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfquery datasource='#dts#' name="showall">
	select * 
	from #target_currency#
</cfquery>

<h2>Currency Maintenance Screen</h2>
<br>

<h4>
	<a href="createCurrency.cfm?type=Create"> Create New Currency</a> || 
	<a href="vCurrency.cfm">List all Currency</a>  
</h4>

<cfif showall.recordcount gt 0>
	<table align="center" class="data" width="650px">
		<tr>
			<th>Currency Code</th>
			<th>Currency</th>
			<th>Currency Word</th>
			<th>Maintain Rate</th>
		</tr>
		<cfoutput query="showall">
			<tr>
				<td>#showall.currcode#</td>
				<td>#showall.currency#</td>
				<td>#showall.currency1#</td>
				<td align="center"><a href="createCurrency.cfm?type=Edit&currcode=#showall.currcode#">Edit Currency</a></td>
			</tr>
		</cfoutput>
	</table>
<cfelse>
	<h3>No Record Found!</h3>
</cfif>

</body>
</html>