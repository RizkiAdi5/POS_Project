<cfif IsDefined('url.model')>
	<cfset URLmodel = trim(urldecode(url.model))>
</cfif>
<cfif IsDefined('url.menuID')>
	<cfset URLmenuID = url.menuID>
</cfif>
<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT model 
            FROM vehimodel
			WHERE model=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.model)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.model)# already exist!');
				window.open('/latest/maintenance/model.cfm?action=create&menuID=#URLmenuID#','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createModel" datasource="#dts#">
					INSERT INTO vehimodel (model,desp)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.model)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.model)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/model.cfm?action=create&menuID=#URLmenuID#','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.model)# has been created successfully!');
				window.open('/latest/maintenance/modelProfile.cfm?menuID=#URLmenuID#','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateModel" datasource="#dts#">
				UPDATE vehimodel
				SET
					model=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.model#">,
					desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
				WHERE model=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.model)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.model)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/model.cfm?action=update&model=#form.model#&menuID=#URLmenuID#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.model)# successfully!');
			window.open('/latest/maintenance/modelProfile.cfm?menuID=#URLmenuID#','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteModel" datasource="#dts#">
				DELETE FROM vehimodel
				WHERE model=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLmodel#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLmodel#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/modelProfile.cfm?menuID=#URLmenuID#','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLmodel# successfully!');
			window.open('/latest/maintenance/modelProfile.cfm?menuID=#URLmenuID#','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printModel" datasource="#dts#">
			SELECT model,desp
			FROM vehimodel
			ORDER BY model;
		</cfquery>
        <cfoutput>		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>#url.pageTitle# Listing</title>
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
                <h1 class="text">#url.pageTitle# Listing</h1>
                <p class="lead">Company: #getGsetup.compro#</p>
            </div>
            <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>MODEL</th>
                        <th>DESCRIPTION</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="printModel">
                    <tr>
                        <td>#model#</td>
                        <td>#desp#</td>
                    </tr>
                    </cfloop>
                </tbody>
            </table>
            </div>
            <div class="panel-footer">
                <p>Printed at #DateFormat(NOW(),'dd-mm-yyyy')#, #TimeFormat(NOW(),'HH:MM:SS')#</p>
            </div>
		</div>		
		</body>
		</html>
        </cfoutput>
	<cfelse>
		<script type="text/javascript">
			window.open('/latest/maintenance/modelProfile.cfm?menuID=#URLmenuID#','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/modelProfile.cfm?menuID=#URLmenuID#','_self');
	</script>
</cfif>
</cfoutput>