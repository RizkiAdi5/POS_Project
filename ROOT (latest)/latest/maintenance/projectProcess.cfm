<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "512,100,506,65,101">
<cfinclude template="/latest/words.cfm">

<cfif IsDefined('url.source')>
	<cfset URLsource = trim(urldecode(url.source))>
</cfif>
<cfif IsDefined('url.menuID')>
	<cfset URLmenuID = url.menuID>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT source
            FROM #target_project#
			WHERE source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.source)#">
            AND porj = 'P';
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.source)# already exist!');
				window.open('/latest/maintenance/project.cfm?action=create&menuID=#URLmenuID#','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createProject" datasource="#dts#">
					INSERT INTO #target_project# (porj,source,project<cfloop index="i" from="1" to="5">,remark#i#</cfloop>,
                    							  creditsales,cashsales,salesreturn,purchase,purchasereturn,completed)
					VALUES
					(
                    	'P',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.source)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.project)#">,
                        <cfloop index="i" from="1" to="5">
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.remark#i#')#">,
                        </cfloop>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.creditSales)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cashSales)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.salesReturn)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchase)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchaseReturn)#">,
                        <cfif IsDefined('form.completed')>
                        	'Y'
                        <cfelse>
                        	'N'
                        </cfif>
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.source)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/project.cfm?action=create&menuID=#URLmenuID#','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.source)# has been created successfully!');
				window.open('/latest/maintenance/projectProfile.cfm?menuID=#URLmenuID#','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">

		<cftry>
			<cfquery name="updateProject" datasource="#dts#">
				UPDATE #target_project#
				SET
                	porj = 'P',
					source = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
					project = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.project)#">,
                    <cfloop index="i" from="1" to="5">
                    	<cfset remarkValue = evaluate('form.remark#i#')>
                    	remark#i# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#remarkValue#">,
                    </cfloop>
                    creditsales = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.creditSales)#">,
                    cashsales = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cashSales)#">,
                    salesreturn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.salesReturn)#">,
                    purchase = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchase)#">,
                    purchasereturn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchaseReturn)#">,
                    <cfif IsDefined('form.completed')>
                    	completed = 'Y'
                    <cfelse>
                        completed = 'N'
                    </cfif>
				WHERE source = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.source)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.source)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/project.cfm?action=update&source=#form.source#&menuID=#URLmenuID#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.source)# successfully!');
			window.open('/latest/maintenance/projectProfile.cfm?&menuID=#URLmenuID#','_self');
		</script>
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteProject" datasource="#dts#">
				DELETE FROM #target_project#
				WHERE source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLsource#">
                AND porj = 'P';
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLsource#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/projectProfile.cfm&menuID=#URLmenuID#','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLsource# successfully!');
			window.open('/latest/maintenance/projectProfile.cfm?&menuID=#URLmenuID#','_self');
		</script>
	<cfelseif url.action EQ "print">

		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro
            FROM gsetup;
		</cfquery>

		<cfquery name="printProject" datasource="#dts#">
			SELECT source,project
			FROM #target_project#
            WHERE porj = 'P'
			ORDER BY source;
		</cfquery>

		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Project Listing</title>
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
			<h1 class="text">Project Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>

		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>#UCase(words[506])#</th>
					<th>#UCase(words[65])#</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printProject">
				<tr>
					<td>#source#</td>
					<td>#project#</td>
				</tr>
				</cfloop>
			</tbody>
		</table>
		</div>
		<div class="panel-footer">
		<p>#words[101]# #DateFormat(Now(),'dd-mm-yyyy')#, #TimeFormat(Now(),'HH:MM:SS')#</p>
		</div>
		</div>

		</body>
		</html>
	<cfelse>
		<script type="text/javascript">
			window.open('/latest/maintenance/projectProfile.cfm?&menuID=#URLmenuID#','_self');
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/projectProfile.cfm?&menuID=#URLmenuID#','_self');
	</script>
</cfif>
</cfoutput>