<cfif IsDefined('url.source')>
	<cfset URLsource = trim(urldecode(url.source))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT source 
            FROM #target_project#
			WHERE source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.source)#">
            AND porj = 'J';
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.source)# already exist!');
				window.open('/latest/maintenance/job.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createJob" datasource="#dts#">
					INSERT INTO #target_project# (porj,source,project)
					VALUES
					(	
                    	'J',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.source)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.project)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.source)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/job.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.source)# has been created successfully!');
				window.open('/latest/maintenance/jobProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateJob" datasource="#dts#">
				UPDATE #target_project#
				SET
                	porj='J',
					source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
					project=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.project#">
				WHERE source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.source)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.source)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/job.cfm?action=update&source=#form.source#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.source)# successfully!');
			window.open('/latest/maintenance/jobProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteCategory" datasource="#dts#">
				DELETE FROM #target_project#
				WHERE source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLsource#">
                AND porj='J';
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLsource#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/jobProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLsource# successfully!');
			window.open('/latest/maintenance/jobProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printJob" datasource="#dts#">
			SELECT source,project
			FROM #target_project#
            WHERE porj = 'J'
			ORDER BY source;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Job Listing</title>
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
			<h1 class="text">Job Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>JOB</th>
					<th>DESCRIPTION</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printJob">
				<tr>
					<td>#source#</td>
					<td>#project#</td>
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
			window.open('/latest/maintenance/jobProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/jobProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>