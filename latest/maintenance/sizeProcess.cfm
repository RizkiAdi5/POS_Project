<cfif IsDefined('url.sizeid')>
	<cfset URLsizeid = trim(urldecode(url.sizeid))>
</cfif>
<cfif IsDefined('url.menuID')>
	<cfset URLmenuID = url.menuID>
</cfif>
<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT sizeid 
            FROM icsizeid
			WHERE sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.size)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.size)# already exist!');
				window.open('/latest/maintenance/size.cfm?action=create&menuID=#URLmenuID#','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createSize" datasource="#dts#">
					INSERT INTO icsizeid (sizeid,desp <cfloop index="i" from="1" to="30">,size#i#</cfloop> )
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.size)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">
                        <cfloop index="i" from="1" to="30">
                       		<cfset sizevalue = evaluate('form.size#i#')>	
                        		,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(sizevalue)#">
                        </cfloop>
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.size)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/size.cfm?action=create&menuID=#URLmenuID#','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.size)# has been created successfully!');
				window.open('/latest/maintenance/sizeProfile.cfm?menuID=#URLmenuID#','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateSize" datasource="#dts#">
				UPDATE icsizeid
				SET
					sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.size#">,
					desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
					<cfloop index="i" from="1" to="30">
               			<cfset sizevalue = evaluate('form.size#i#')>	
                        	,size#i#=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(sizevalue)#">
                    </cfloop>
				WHERE sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.size)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.size)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/size.cfm?action=update&menuID=#URLmenuID#&size=#form.size#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.size)# successfully!');
			window.open('/latest/maintenance/sizeProfile.cfm?menuID=#URLmenuID#','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteBrand" datasource="#dts#">
				DELETE FROM icsizeid
				WHERE sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLsizeid#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLsizeid#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/sizeProfile.cfm?menuID=#URLmenuID#','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLsizeid# successfully!');
			window.open('/latest/maintenance/sizeProfile.cfm?menuID=#URLmenuID#','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printSize" datasource="#dts#">
			SELECT sizeid,desp
			FROM icsizeid
			ORDER BY sizeid;
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
                        <th>SIZE</th>
                        <th>DESCRIPTION</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="printSize">
                    <tr>
                        <td>#sizeid#</td>
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
			window.open('/latest/maintenance/sizeProfile.cfm?menuID=#URLmenuID#','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/sizeProfile.cfm?menuID=#URLmenuID#','_self');
	</script>
</cfif>
</cfoutput>