<html>
<head>
<title>Inventory Balance Check</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<h1 align="center">Inventory Balance Check</h1>
Click on the following to select reports.
<br><br>
<table width="75%" border="0" class="data" align="center">
  	<tr> 
		<cfif getpin2.h3110 eq "T">
			<td>
				<a href="../enquires/item_enquires.cfm"><img name="Cash Sales" src="../../images/reportlogo.gif">Stock Balance</a>
			</td>
		</cfif>
		<cfif getpin2.h3120 eq "T">
			<td>
				<a href="../enquires/relitembalance.cfm"><img name="Cash Sales" src="../../images/reportlogo.gif">Related Item Balance</a>
			</td>
		</cfif>
        <cfif getpin2.h3130 eq "T">
			<td>
				<a href="../enquires/locationitem_enquires.cfm"><img name="Cash Sales" src="../../images/reportlogo.gif">Location Stock Balance</a>
			</td>
		</cfif>
  	</tr>
</table>
</body>
</html>
