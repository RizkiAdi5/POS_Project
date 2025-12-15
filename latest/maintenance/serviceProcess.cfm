<cfif IsDefined('url.servi')>
	<cfset URLservice = trim(urldecode(url.servi))>
</cfif>
<cfif IsDefined('url.menuID')>
	<cfset URLmenuID = url.menuID>
</cfif>
<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT servi 
            FROM icservi
			WHERE servi=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.service#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('#trim(form.service)# already exist!');
				window.open('/latest/maintenance/service.cfm?action=create?menuID=#URLmenuID#','_self');
			</script>
		<cfelse>
			<!--- <cftry> --->
				<cfquery name="createService" datasource="#dts#">
					INSERT INTO icservi (servi,desp,despa,salec,salecsc,salecnc,purc,purprc,sercost,serprice)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.service)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.despa)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.creditSales)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cashSales)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.salesReturn)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchase)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchaseReturn)#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.serviceCost))#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.servicePrice))#">
					)
				</cfquery>
				<!--- <cfcatch type="any">
					<script type="text/javascript">
						alert('Fail to create #trim(form.service)#.\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/service.cfm?action=create?menuID=#URLmenuID#','_self');
					</script>
				</cfcatch>
			</cftry> --->
			<script type="text/javascript">
				alert('Created new #trim(form.service)# successfully!');
				window.open('/latest/maintenance/serviceProfile.cfm?menuID=#URLmenuID#','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
		<cftry>
			<cfquery name="updateService" datasource="#dts#">
				UPDATE icservi
				SET
               		servi=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.service)#">,
					desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
					despa=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.despa)#">,
                    salec=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.creditSales)#">,
                    salecsc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cashSales)#">,
                    salecnc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.salesReturn)#">,
                    purc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchase)#">,
                    purprc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchaseReturn)#">,
                    sercost=<cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.serviceCost))#">,
                    serprice=<cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.servicePrice))#">
				WHERE servi=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.service)#">
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Fail to update #trim(form.service)#.\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/service.cfm?action=update&menuID=#URLmenuID#&servi=#form.service#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.service)# successfully!');
			window.open('/latest/maintenance/serviceProfile.cfm?menuID=#URLmenuID#','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteService" datasource="#dts#">
				DELETE FROM icservi
				WHERE servi=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.servi#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Fail to delete #URLservice#.\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/serviceProfile.cfm?menuID=#URLmenuID#&servi=#URLservice#','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLservice# successfully!');
			window.open('/latest/maintenance/serviceProfile.cfm?menuID=#URLmenuID#','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printService" datasource="#dts#">
			SELECT servi,desp
			FROM icservi
			ORDER BY servi;
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
            </div
            ><div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>SERVICE</th>
                        <th>DESCRIPTION</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="printService">
                    <tr>
                        <td>#servi#</td>
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
			window.open('/latest/maintenance/serviceProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/serviceProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>