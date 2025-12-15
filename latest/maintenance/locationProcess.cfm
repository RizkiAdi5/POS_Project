<cfif IsDefined('url.location')>
	<cfset URLlocation = trim(urldecode(url.location))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT location 
            FROM iclocation
			WHERE location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.location)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.location)# already exist!');
				window.open('/latest/maintenance/location.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createCode" datasource="#dts#">
					INSERT INTO iclocation (location,desp,outlet,custno,addr1,addr2,addr3,addr4)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.location)#">,        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.consignmentOutlet)#">,    
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.customerNo)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add1)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add3)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add4)#">
					)
				</cfquery>
                <cfif IsDefined('form.generateitem')>
                    <cfquery name="insertlocation" datasource="#dts#">
                    	INSERT IGNORE INTO LOCQDBF (itemno,location,desp) 
                        SELECT itemno,"#trim(form.location)#","#trim(form.desp)#" AS location 
                        FROM icitem 
                        ORDER BY itemno;
                    </cfquery>
				</cfif>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.location)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/location.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.location)# has been created successfully!');
				window.open('/latest/maintenance/locationProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateCode" datasource="#dts#">
				UPDATE iclocation
				SET
                    location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.location)#">,
                    desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">, 
                    outlet = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.consignmentOutlet)#">,      
                    custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.customerNo)#">,
                    addr1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add1)#">,
                    addr2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add2)#">,
                    addr3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add3)#">,
                    addr4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add4)#">,  
                    <cfif IsDefined('form.discontinueLocation')>
                    	noactivelocation = 'Y'
					<cfelse>
                    	noactivelocation = ''
                    </cfif>
				WHERE location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.location)#">
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.location)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/location.cfm?action=update&location=#form.location#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.location)# successfully!');
			window.open('/latest/maintenance/locationProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
        <cfquery name="checkICTRAN" datasource='#dts#'>
            SELECT location 
            FROM ictran 
            WHERE location='#URLlocation#';
        </cfquery>
        <cfif checkICTRAN.recordcount NEQ 0>
            <script type="text/javascript">
                alert('This #URLlocation# has been used in transaction. Deleting is not allowed!');
                window.open('/latest/maintenance/locationProfile.cfm','_self');
            </script>
        <cfelse>
            <cftry>
                <cfquery name="deleteCode" datasource="#dts#">
                    DELETE FROM iclocation
                    WHERE location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLlocation#">
                </cfquery>
            <cfcatch type="any">   
                <script type="text/javascript">
                    alert('Failed to delete #URLlocation#!\nError Message: #cfcatch.message#');
                    window.open('/latest/maintenance/locationProfile.cfm','_self');
                </script>
            </cfcatch>
            </cftry>
        </cfif>
		<script type="text/javascript">
			alert('Deleted #URLlocation# successfully!');
			window.open('/latest/maintenance/locationProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printLocation" datasource="#dts#">
			SELECT location,desp
			FROM iclocation
			ORDER BY location;
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
			<h1 class="text">Location Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>LOCATION</th>
					<th>DESPCRIPTION</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printLocation">
				<tr>
					<td>#location#</td>
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
			window.open('/latest/maintenance/locationProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/locationProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>