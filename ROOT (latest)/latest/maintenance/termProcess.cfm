<cfif IsDefined('url.term')>
	<cfset URLterm = trim(urldecode(url.term))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT term 
            FROM #target_icterm# 
			WHERE term=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.term)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.term)# already exist!');
				window.open('/latest/maintenance/term.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createTerm" datasource="#dts#">
					INSERT INTO #target_icterm# (term,desp,sign,days,validity,leadtime,remarks)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.term)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                        <cfif IsDefined('form.sign')>
                        	'P'
                        <cfelse>
                        	'' 
                        </cfif>,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#val(trim(form.days))#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.validity)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.leadTime)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remarks)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.term)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/term.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.term)# has been created successfully!');
				window.open('/latest/maintenance/termProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateTerm" datasource="#dts#">
				UPDATE #target_icterm# 
				SET
					term=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.term#">,
					desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,    
					<cfif IsDefined('form.sign')>
						sign='P'
					<cfelse>
						sign='' 
					</cfif>,
                    days = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(trim(form.days))#">,
                    validity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.validity)#">,
                    leadtime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.leadTime)#">,
                    remarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remarks)#">
				WHERE term = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.term)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.term)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/term.cfm?action=update&term=#form.term#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.term)# successfully!');
			window.open('/latest/maintenance/termProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteTerm" datasource="#dts#">
				DELETE FROM #target_icterm# 
				WHERE term=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLterm#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLterm#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/termProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLterm# successfully!');
			window.open('/latest/maintenance/termProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printTerm" datasource="#dts#">
			SELECT term,desp
			FROM #target_icterm# 
			ORDER BY term;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Term Listing</title>
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
			<h1 class="text">Term Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>TERM</th>
					<th>DESCRIPTION</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printTerm">
				<tr>
					<td>#term#</td>
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
			window.open('/latest/maintenance/termProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/termProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>