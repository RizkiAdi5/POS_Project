<html>
<head>
	<title>Maintenance Team</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getGsetup" datasource="#dts#">
  Select lTEAM from GSetup
</cfquery>

<body>
<cfoutput>
	<cfswitch expression="#url.type#">
		<cfcase value="Edit,Delete" delimiters=",">
			<cfquery name="getteam" datasource="#dts#">
				select * from icteam where team = '#url.team#'
			</cfquery>
		</cfcase>
	</cfswitch>

	<cfswitch expression="#url.type#">
		<cfcase value="Edit">
			<cfset mode="Edit">
			<cfset title="Edit"&getGsetup.lTeam>
			<cfset button="Edit">
		</cfcase>
		<cfcase value="Delete">
			<cfset mode="Delete">
			<cfset title="Delete"&getGsetup.lTeam>
			<cfset button="Delete">
		</cfcase>
		<cfcase value="Create">
			<cfset mode="Create">
			<cfset title="Create"&getGsetup.lTeam>
			<cfset button="Create">
		</cfcase>
	</cfswitch>

	<h1>#title#</h1>
	<h4>
	<cfif getpin2.h1D10 eq 'T'><a href="teamtable2.cfm?type=Create">Creating a New #getGsetup.lTeam#</a> </cfif>
	<cfif getpin2.h1D20 eq 'T'>|| <a href="teamtable.cfm">List All #getGsetup.lTeam#</a> </cfif>
	<cfif getpin2.h1D30 eq 'T'>|| <a href="s_teamtable.cfm?type=icteam">Search For #getGsetup.lTeam#</a></cfif></h4>

	<cfform name="teamform" action="teamtableprocess.cfm" method="post">
    	<input type="hidden" name="mode" value="#mode#">

		<h1 align="center">#getGsetup.lTeam# File Maintenance</h1>

		<table align="center" class="data" width="500">
      		<tr>
        		<td width="100">#getGsetup.lTeam# :</td>
        		<td>
				<cfif mode eq "Delete" or mode eq "Edit">
            		<cfinput type="text" size="12" name="team" value="#getteam.team#" readonly>
            	<cfelse>
            		<cfinput type="text" size="12" name="team" required="yes" maxlength="12">
          		</cfif>
				</td>
      		</tr>
      		<tr>
        		<td>Description:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="40" name="desp" required="no" value="#getteam.desp#" maxlength="40">
					<cfelse>
						<cfinput type="text" size="40" name="desp" required="no" maxlength="40">
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