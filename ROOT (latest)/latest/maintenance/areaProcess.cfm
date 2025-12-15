<cfif IsDefined('url.area')>
	<cfset URLarea = trim(urldecode(url.area))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource='#dts#'>
            SELECT area 
            FROM #target_icarea# 
            WHERE area=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.area)#">;
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.area)# already exist!');
				window.open('/latest/maintenance/area.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createArea" datasource="#dts#">
					INSERT INTO #target_icarea# (area,desp)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.area)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.area)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/area.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.area)# has been created successfully!');
				window.open('/latest/maintenance/areaProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateArea" datasource="#dts#">
				UPDATE #target_icarea#
				SET
					area=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.area#">,
					desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
				WHERE area=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.area)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.area)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/area.cfm?action=update&area=#form.area#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.area)# successfully!');
			window.open('/latest/maintenance/areaProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteCategory" datasource="#dts#">
				DELETE FROM #target_icarea#
				WHERE area=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLarea#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLarea#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/areaProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLarea# successfully!');
			window.open('/latest/maintenance/areaProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printArea" datasource="#dts#">
			SELECT area,desp
			FROM #target_icarea#
			ORDER BY area;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Area Listing</title>
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
			<h1 class="text">Area Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>AREA</th>
					<th>DESCRIPTION</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printArea">
				<tr>
					<td>#area#</td>
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
			window.open('/latest/maintenance/areaProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/areaProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>