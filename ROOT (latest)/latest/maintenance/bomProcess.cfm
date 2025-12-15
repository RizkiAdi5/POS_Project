<cfif IsDefined('url.itemno')>
	<cfset URLbom = trim(urldecode(url.itemno))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT itemno
            FROM billmat
			WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.item)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.item)# already exist!');
				window.open('/latest/maintenance/bom.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createBom" datasource="#dts#">
					INSERT INTO billmat (itemno,bomno)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.item)#">,        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.bom)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.item)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/bom.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.item)# has been created successfully!');
				window.open('/latest/maintenance/bomProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<!---<cftry> --->
			<cfquery name="updateBom" datasource="#dts#">
				UPDATE billmat
				SET
                    itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.item)#">,
                    bomno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.bom)#">
				WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.item)#">
			</cfquery>
        <!---    
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.item)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/bom.cfm?action=update&itemno=#form.item#','_self');
			</script>
		</cfcatch>
		</cftry>--->
		<script type="text/javascript">
			alert('Updated #trim(form.item)# successfully!');
			window.open('/latest/maintenance/bomProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteCode" datasource="#dts#">
				DELETE FROM billmat
				WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLbom#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLbom#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/bomProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLbom# successfully!');
			window.open('/latest/maintenance/bomProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printBom" datasource="#dts#">
			SELECT itemno,bomno
			FROM billmat
			ORDER BY itemno;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Location Listing</title>
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
			<h1 class="text">B.O.M Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>ITEM NO</th>
					<th>B.O.M NO</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printBom">
				<tr>
					<td>#itemno#</td>
					<td>#bomno#</td>
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
			window.open('/latest/maintenance/bomProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/bomProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>