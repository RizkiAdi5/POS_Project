<html>
<head>
	<title>Maintenance Counter</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>


<body>
<cfoutput>
	<cfswitch expression="#url.type#">
		<cfcase value="Edit,Delete" delimiters=",">
			<cfquery name="getcounter" datasource="#dts#">
				select * from counter where counterid = '#url.counter#'
			</cfquery>
		</cfcase>
	</cfswitch>

	<cfswitch expression="#url.type#">
		<cfcase value="Edit">
			<cfset mode="Edit">
			<cfset title="Edit Counter">
			<cfset button="Edit">
		</cfcase>
		<cfcase value="Delete">
			<cfset mode="Delete">
			<cfset title="Delete Counter">
			<cfset button="Delete">
		</cfcase>
		<cfcase value="Create">
			<cfset mode="Create">
			<cfset title="Create Counter">
			<cfset button="Create">
		</cfcase>
	</cfswitch>

	<h1>#title#</h1>

		<h4>
<a href="countertable2.cfm?type=Create">Create New Counter</a>
|| <a href="countertable.cfm">List All Counter</a>
|| <a href="s_countertable.cfm?type=counter">Search For Counter</a>
	</h4>

	<cfform name="counterform" action="countertableprocess.cfm" method="post">
    	<input type="hidden" name="mode" value="#mode#">

		<h1 align="center">Counter File Maintenance</h1>

		<table align="center" class="data" width="500">
      		<tr>
        		<td width="100">Counter :</td>
        		<td>
				<cfif mode eq "Delete" or mode eq "Edit">
            		<cfinput type="text" size="12" name="counter" value="#getcounter.counterid#" readonly>
            	<cfelse>
            		<cfinput type="text" size="12" name="counter" required="yes" maxlength="8">
          		</cfif>
				</td>
      		</tr>
      		<tr>
        		<td>Description:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="40" name="desp" required="no" value="#getcounter.counterdesp#" maxlength="40">
					<cfelse>
						<cfinput type="text" size="40" name="desp" required="no" maxlength="40">
					</cfif>
				</td>
      		</tr>
          
            <tr>
        		<td>Bond User:</td>
                <cfquery name="getuser" datasource="main">
                SELECT "Choose an User" as userid
                union all
                select * from(
                select userid from users where userbranch = "#hcomid#" order by userid) as a
                </cfquery>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfselect name="bonduser" id="bonduser" query="getuser" value="userid" display="userid" selected="#getcounter.bonduser#"></cfselect>
					<cfelse>
						<cfselect name="bonduser" id="bonduser" query="getuser" value="userid" display="userid"></cfselect>
					</cfif>
				</td>
      		</tr>
      		<tr>
        		<td></td>
        		<td align="right"><cfinput name="submit" type="submit" value="  #button#  "></td>
      		</tr>
		</table>
	</cfform>
</body>
</cfoutput>
</html>