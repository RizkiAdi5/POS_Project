<cfif IsDefined('url.agent')>
	<cfset URLagent = trim(urldecode(url.agent))>
</cfif>

<cfoutput>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT agent 
            FROM #target_icagent#
			WHERE agent=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.agent)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.agent)# already exist!');
				window.open('/latest/maintenance/agent.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createCategory" datasource="#dts#">
					INSERT INTO #target_icagent# (agent,desp,commsion1,hp,agentID,photo,agentlist,team,email,designation)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.agent)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.commision))#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.contact)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.agentID)#">,
                        <cfif IsDefined('form.picture_available')> 
                   			photo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.picture_available)#">,
                    	</cfif>  
                        <cfif IsDefined('form.agentlist')> 
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agentlist#">
                        <cfelse>
                        	""
                        </cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.teamValue)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.email)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.designation)#">    
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.agent)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/agent.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.agent)# has been created successfully!');
				window.open('/latest/maintenance/agentProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateCategory" datasource="#dts#">
				UPDATE #target_icagent#
				SET
					agent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
                    desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                    commsion1 = <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.commision))#">,
                    hp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.contact)#">,
                    agentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.agentID)#">,
                    team = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.teamValue)#">,
                    <cfif IsDefined('form.agentlist')> 
                        agentlist = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agentlist#">,
                    <cfelse>
                        agentlist = '',
                    </cfif>
                    <cfif IsDefined('form.picture_available')> 
                   		photo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.picture_available)#">,
                    </cfif>    
                    <cfif IsDefined("form.discontinueAgent")>
                    	discontinueagent = 'Y',
                    <cfelse>
                      	discontinueagent = 'N',
                    </cfif>
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.email)#">
                    WHERE agent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.agent)#">
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.agent)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/agent.cfm?action=update&agent=#form.agent#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.agent)# successfully!');
			window.open('/latest/maintenance/agentProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteAgent" datasource="#dts#">
				DELETE FROM #target_icagent#
				WHERE agent=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLagent#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLagent#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/agentProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLagent# successfully!');
			window.open('/latest/maintenance/agentProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printAgent" datasource="#dts#">
			SELECT agent,desp
			FROM #target_icagent#
			ORDER BY agent;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Agent Listing</title>
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
			<h1 class="text">Agent Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>AGENT</th>
					<th>DESCRIPTION</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printAgent">
				<tr>
					<td>#agent#</td>
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
			window.open('/latest/maintenance/agentProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/agentProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>