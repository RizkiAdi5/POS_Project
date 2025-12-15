<cfif IsDefined('url.team')>
	<cfset URLteam = trim(urldecode(url.team))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT team 
            FROM icteam
			WHERE team=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.team)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.team)# already exist!');
				window.open('/latest/maintenance/team.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createTeam" datasource="#dts#">
					INSERT INTO icteam (team,desp)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.team)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.team)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/team.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.team)# has been created successfully!');
				window.open('/latest/maintenance/teamProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateTeam" datasource="#dts#">
				UPDATE icteam
				SET
					team=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.team#">,
					desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
				WHERE team=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.team)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.team)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/team.cfm?action=update&team=#form.team#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.team)# successfully!');
			window.open('/latest/maintenance/teamProfile.cfm','_self');
		</script>
        
        
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteTeam" datasource="#dts#">
				DELETE FROM icteam
				WHERE team=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLteam#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLteam#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/teamProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLteam# successfully!');
			window.open('/latest/maintenance/teamProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printteam" datasource="#dts#">
			SELECT team,desp
			FROM icteam
			ORDER BY team;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Team Listing</title>
		<link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
		<!--[if lt IE 9]>
			<script type="text/javascript" src="/latest/js/html5shiv/html5shiv.js"></script>
			<script type="text/javascript" src="/latest/js/respond/respond.min.js"></script>
		<![endif]-->
		<script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
		</head>
		<body>
		
		<div class="container">
		<div class="page-header">
			<h1 class="text">Team Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>TEAM</th>
					<th>DESCRIPTION</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printteam">
				<tr>
					<td>#team#</td>
					<td>#desp#</td>
				</tr>
				</cfloop>
			</tbody>
		</table>
		</div>
		<div class="panel-footer">
		<p>Printed at #DateFormat(Now(),'dd-mm-yyyy')#, #TimeFormat(Now(),'HH:MM:SS')#</p>
		</div>
		</div>		
		
		</body>
		</html>
	<cfelse>
		<script type="text/javascript">
			window.open('/latest/maintenance/teamProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/teamProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>