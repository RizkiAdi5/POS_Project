<cfif IsDefined('url.wos_group')>
	<cfset URLwos_group = trim(urldecode(url.wos_group))>
</cfif>
<cfif IsDefined('url.menuID')>
	<cfset URLmenuID = url.menuID>
</cfif>
<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT wos_group 
            FROM icgroup
			WHERE wos_group=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.group)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.group)# already exist!');
				window.open('/latest/maintenance/group.cfm?action=create&menuID=#URLmenuID#','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createGroup" datasource="#dts#">
					INSERT INTO icgroup (wos_group,desp <cfloop index="i" from="1" to="15"> <cfif i eq 1>,category<cfelse>,category#i#</cfif></cfloop>,salec,salecsc,salecnc,purc,purprc,meter_read)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.group)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                        <cfloop index="i" from="1" to="15">   			
							<cfif i eq 1>
                                <cfset categoryValue = evaluate('form.category')>
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(categoryValue)#">,
                            <cfelse>
                                <cfset categoryValue = evaluate('form.category#i#')>
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(categoryValue)#">,
                            </cfif>
                        </cfloop> 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.creditSales)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cashSales)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.salesReturn)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchase)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchaseReturn)#">,
                        <cfif IsDefined('form.meterReading')> 
                    		'T'
                    	<cfelse>
                    		'F'
                    	</cfif>                   
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.group)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/group.cfm?action=create&menuID=#URLmenuID#','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.group)# has been created successfully!');
				window.open('/latest/maintenance/groupProfile.cfm?menuID=#URLmenuID#','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateGroup" datasource="#dts#">
				UPDATE icgroup
				SET
					wos_group=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.group#">,
					desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
                        <cfloop index="i" from="1" to="15">
                        	<cfif i eq 1>
                                category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.category#">
                            <cfelse> 
                       			
                        		,category#i# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.category#i#')#">
							</cfif>
                        </cfloop>
                        
                    ,salec=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.creditSales)#">,
                    salecsc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cashSales)#">,
                    salecnc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.salesReturn)#">,
                    purc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchase)#">,
                    purprc=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.purchaseReturn)#">,
                   
                    <cfif IsDefined('form.meterReading')>  
                    	meter_read='T'
                    <cfelse>
                    	meter_read='F'
                    </cfif>  
                      
				WHERE wos_group=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.group)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.group)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/group.cfm?action=update&menuID=#URLmenuID#&wos_group=#form.group#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.group)# successfully!');
			window.open('/latest/maintenance/groupProfile.cfm?menuID=#URLmenuID#','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteGroup" datasource="#dts#">
				DELETE FROM icgroup
				WHERE wos_group=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLwos_group#">;
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLwos_group#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/groupProfile.cfm?menuID=#URLmenuID#','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLwos_group# successfully!');
			window.open('/latest/maintenance/groupProfile.cfm?menuID=#URLmenuID#','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printGroup" datasource="#dts#">
			SELECT wos_group,desp
			FROM icgroup
			ORDER BY wos_group;
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
                        <th>GROUP</th>
                        <th>DESCRIPTION</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="printGroup">
                    <tr>
                        <td>#wos_group#</td>
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
			window.open('/latest/maintenance/groupProfile.cfm?menuID=#URLmenuID#','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/groupProfile.cfm?menuID=#URLmenuID#','_self');
	</script>
</cfif>
</cfoutput>