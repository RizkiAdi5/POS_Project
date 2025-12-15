<cfif IsDefined('url.code')>
	<cfset URLcode = trim(urldecode(url.code))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT code 
            FROM collect_address
			WHERE code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.code)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.code)# already exist!');
				window.open('/latest/maintenance/collectAddress.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createCode" datasource="#dts#">
					INSERT INTO collect_address (code,name,custno,add1,add2,add3,add4,country,postalcode,attn,phone,fax)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.code)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,      
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.customerNo)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add1)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add3)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add4)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.country)#">,         
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.postalCode)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.attention)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.telephone)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fax)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.code)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/collectAddress.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.code)# has been created successfully!');
				window.open('/latest/maintenance/collectAddressProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateCode" datasource="#dts#">
				UPDATE collect_address
				SET
                    code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.code)#">,
                    name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,      
                    custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.customerNo)#">,
                    add1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add1)#">,
                    add2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add2)#">,
                    add3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add3)#">,
                    add4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add4)#">,
                    country=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.country)#">,         
                    postalcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.postalCode)#">,
                    attn=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.attention)#">,
                    phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.telephone)#">,
                    fax=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fax)#">       
				WHERE code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.code)#">
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.code)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/collectAddress.cfm?action=update&code=#form.code#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.code)# successfully!');
			window.open('/latest/maintenance/collectAddressProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteCode" datasource="#dts#">
				DELETE FROM collect_address
				WHERE code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcode#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLcode#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/collectAddressProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLcode# successfully!');
			window.open('/latest/maintenance/collectAddressProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printCollectAddress" datasource="#dts#">
			SELECT code,name,custno
			FROM address
			ORDER BY code;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Collection Address Listing</title>
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
			<h1 class="text">Collection Address Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>CODE</th>
					<th>NAME</th>
                    <th>CUSTOMER NO</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printCollectAddress">
				<tr>
					<td>#code#</td>
					<td>#name#</td>
                    <td>#custno#</td>
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
			window.open('/latest/maintenance/collectAddressProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/collectAddressProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>