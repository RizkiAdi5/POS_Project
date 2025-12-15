<cfif IsDefined('url.identifierno')>
	<cfset URLidentifierno = trim(urldecode(url.identifierno))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT identifierno 
            FROM identifier
			WHERE identifierno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.identifier)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.identifier)# already exist!');
				window.open('/latest/maintenance/identifier.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createIdentifier" datasource="#dts#">
					INSERT INTO identifier (identifierno,desp)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.identifier)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.identifier)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/identifier.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.identifier)# has been created successfully!');
				window.open('/latest/maintenance/identifierProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateIdentifier" datasource="#dts#">
				UPDATE identifier
				SET
					identifierno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.identifier#">,
					desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
				WHERE identifierno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.identifier)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.identifier)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/identifier.cfm?action=update&identifierno=#form.identifier#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.identifier)# successfully!');
			window.open('/latest/maintenance/identifierProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteIdentifier" datasource="#dts#">
				DELETE FROM identifier
				WHERE identifierno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLidentifierno#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLidentifierno#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/identifierProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLidentifierno# successfully!');
			window.open('/latest/maintenance/identifierProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printIdentifier" datasource="#dts#">
			SELECT identifierno,desp
			FROM identifier
			ORDER BY identifierno;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Identifier Listing</title>
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
			<h1 class="text">Identifier Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>IDENTIFIER</th>
					<th>DESCRIPTION</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printIdentifier">
				<tr>
					<td>#identifierno#</td>
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
			window.open('/latest/maintenance/identifierProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/identifierProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>