<html>
<head>
<title><cfif hcomid eq "pnp_i">Stock Card Details<cfelse>Stock Card Report</cfif></title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear from gsetup
</cfquery>

<cfquery name="getprevlastaccyear" datasource="#dts#">
	select LastAccDate,ThisAccDate FROM icitem_last_year group by LastAccDate,ThisAccDate order by LastAccDate desc
</cfquery>


<body>
<h1 align="center">
<cfif hcomid eq "pnp_i">View Stock Card Details<cfelse>View Stock Card Report</cfif>
</h1>
<form name="itemform" action="DOstockcard.cfm" method="post">
<table border="0" align="center" width="65%" class="data">
	<tr>
      	<th width="20%">Transaction Range</th>
      	<td width="*">&nbsp;
			<cfoutput>
			<select name="lastaccdaterange">
          		<option value="">#dateformat(getgeneral.lastaccyear,"dd/mm/yyy")# - #dateformat(now(),"dd/mm/yyy")#</option>
          		<cfloop query="getprevlastaccyear">
            	<option value="#getprevlastaccyear.LastAccDate#">#dateformat(getprevlastaccyear.LastAccDate,"dd/mm/yyy")# - #dateformat(getprevlastaccyear.ThisAccDate,"dd/mm/yyy")#</option>
          		</cfloop>
			</select>
			</cfoutput>
			&nbsp;&nbsp;<input type="submit" value="Submit">
		</td>
    </tr>
</table>
</form>
</body>
</html>