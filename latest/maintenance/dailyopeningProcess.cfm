<cfif IsDefined('url.dailyopeningID')>
	<cfset URLcounter = trim(urldecode(url.dailyopeningID))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">   
		<cfquery name="checkExist" datasource="#dts#">
			SELECT counterid 
            FROM dailycounter
			WHERE counterid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.counter)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.counter)# already exist!');
				window.open('/latest/maintenance/dailyopening.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
            <cfset ndate=createdate(right(form.wos_date,4),mid(form.wos_date,4,2),left(form.wos_date,2))>
				<cfquery name="createCounter" datasource="#dts#">
					INSERT INTO dailycounter (counterid,desp,wos_date,type,openning)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.counter)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#dateformat(ndate,'yyyy-mm-dd')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.type)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.amount)#">  
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.counter)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/counter.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.counter)# has been created successfully!');
				window.open('/latest/maintenance/dailyopeningProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		<cfset ndate=createdate(right(form.wos_date,4),mid(form.wos_date,4,2),left(form.wos_date,2))>
		<cftry>
   			<cfquery name="updateCounter" datasource="#dts#">
				UPDATE dailycounter
				SET
					counterid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.counter)#">,
					desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
                    wos_date = "#dateformat(ndate,'yyyy-mm-dd')#",
                    type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#">,
                    openning = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.amount#">
				WHERE counterid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.counter)#">;

			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.counter)# !\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/dailyopening.cfm?action=update&counterid=#trim(form.counter)#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.counter)# successfully!');
			window.open('/latest/maintenance/dailyopeningProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteCounter" datasource="#dts#">
				DELETE FROM dailycounter
				WHERE counterid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcounter#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLcounter#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/dailyopeningProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLcounter# successfully!');
			window.open('/latest/maintenance/dailyopeningProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printCounter" datasource="#dts#">
			SELECT counterid,desp,wos_date,type,openning
			FROM dailycounter
			ORDER BY counterid;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Daily Opening Listing</title>
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
			<h1 class="text">Daily Opening Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>COUNTER</th>
					<th>DESCRIPTION</th>
                    <th>DATE</th>
                    <th>TYPE</th>
                    <th>AMOUNT</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printCounter">
				<tr>
					<td>#counterid#</td>
					<td>#desp#</td>
                    <td>#dateformat(wos_date,'DD/MM/YYYY')#</td>
                    <td>#type#</td>
                    <td>#openning#</td>
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
			window.open('/latest/maintenance/dailyopeningProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/dailyopeningProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>