<cfif IsDefined('url.packcode')>
	<cfset URLpackageCode = trim(urldecode(url.packcode))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT * 
            FROM package
			WHERE packcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.packcode)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.packcode)# already exist!');
				window.open('/latest/maintenance/package.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createPackage" datasource="#dts#">
					INSERT INTO package (packcode,packdesp,grossamt)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.packcode)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(val(form.grossamt))#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.packcode)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/package.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.packcode)# has been created successfully!');
				window.open('/latest/maintenance/packageProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updatePackage" datasource="#dts#">
				UPDATE package
				SET
					packcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.packcode)#">,
					desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                    grossamt=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(val(form.grossamt))#">
				WHERE packcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.packcode)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.packcode)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/package.cfm?action=update&packcode=#form.packcode#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.packcode)# successfully!');
			window.open('/latest/maintenance/packageProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deletePackage" datasource="#dts#">
				DELETE FROM package
				WHERE packcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLpackageCode#">
			</cfquery>
            <cfquery name="deletePackdet" datasource='#dts#' >
				DELETE FROM packdet
                WHERE packcode='#form.packcode#'
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLpackageCode#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/packageProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLpackageCode# successfully!');
			window.open('/latest/maintenance/packageProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printPackage" datasource="#dts#">
			SELECT *
			FROM package
			ORDER BY packcode;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Package Listing</title>
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
			<h1 class="text">Package Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>PACKAGE</th>
					<th>DESCRIPTION</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printPackage">
				<tr>
					<td>#packcode#</td>
					<td>#packdesp#</td>
				</tr>
				</cfloop>
			</tbody>
		</table>
		</div>
		<div class="panel-footer">
		<p>Printed at #DateFormat(Now(),'DD-MM-YYYY')#, #TimeFormat(Now(),'HH:MM:SS')#</p>
		</div>
		</div>		
		
		</body>
		</html>
	<cfelse>
		<script type="text/javascript">
			window.open('/latest/maintenance/packageProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/packageProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>