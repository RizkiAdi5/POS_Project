<html>
<head>
<title>Item Number History</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery datasource="#dts#" name="getitem">
	select itemno, desp from icitem
</cfquery>

<body>
<h1>Customer Item Number</h1>
<p><br><br>This Page Will Allow User Provide Different Item.No To Specific Customer.<br></p>

<cfoutput>
	<h4>
	<a href="itemhistory.cfm">View by Item No</a> ||
	<a href="itemhistory2.cfm?">View by Customer No</a> ||
	<a href="../s_icitem.cfm?type=icitem">Back to Item Maintenance</a>
	</h4>

	<cfform action="itemhistory2.cfm" method="post" target="_self" name="form">
		<cfif isdefined("url.itemno1")>
			<cfinput type="text" name="itemno" value="#url.itemno1#">
		<cfelse>
			<select name="itemno">
				<cfoutput query="getitem">
    			<option value="#itemno#">#itemno# - #desp#</option>
    			</cfoutput>
			</select>
		</cfif>

		<input type="submit" name="Submit1" value="Submit">
		<a href="item_enquiressearch.cfm?">SEARCH</a>
	</cfform>
</cfoutput>

</body>
</html>