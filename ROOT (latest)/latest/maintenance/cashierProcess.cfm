<cfif IsDefined('url.cashierID')>
	<cfset URLcashierID = trim(urldecode(url.cashierID))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT cashierID 
            FROM cashier
			WHERE cashierID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cashierID)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.cashierID)# already exist!');
				window.open('/latest/maintenance/category.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createCashier" datasource="#dts#">
					INSERT INTO cashier (cashierID,name,password)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cashierID)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.password)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.cashierID)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/category.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.cashierID)# has been created successfully!');
				window.open('/latest/maintenance/cashierProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateCashier" datasource="#dts#">
				UPDATE cashier
				SET
					cashierID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cashierID)#">,
					name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,
                    password=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.password)#">
				WHERE cashierID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.cashierID)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.cashierID)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/category.cfm?action=update&cashierID=#form.cashierID#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.cashierID)# successfully!');
			window.open('/latest/maintenance/cashierProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteCashier" datasource="#dts#">
				DELETE FROM cashier
				WHERE cashierID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcashierID#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLcashierID#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/cashierProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLcashierID# successfully!');
			window.open('/latest/maintenance/cashierProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printCashier" datasource="#dts#">
			SELECT cashierID,name
			FROM cashier
			ORDER BY cashierID;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Cashier Listing</title>
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
			<h1 class="text">Cashier Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>CASHIER</th>
					<th>DESCRIPTION</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printCashier">
				<tr>
					<td>#cashierID#</td>
					<td>#name#</td>
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
			window.open('/latest/maintenance/cashierProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/cashierProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>