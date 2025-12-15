<cfif IsDefined('url.driverno')>
	<cfset URLdriverno = trim(urldecode(url.driverno))>
</cfif>

<cfoutput>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT driverno 
            FROM driver
			WHERE driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.driverNo)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.driverNo)# already exist!');
				window.open('/latest/maintenance/driver.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createDriver" datasource="#dts#">
					INSERT INTO driver (driverno,name,name2,attn,customerno,
                    					add1,add2,add3,dept,contact,phone,phonea,e_mail,fax,
                    					dadd1,dadd2,dadd3,dattn,dcontact,remarks,commission1,discontinuedriver,photo)
					VALUES
					(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.driverNo)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.attention)#">,
                        <cfif IsDefined('form.customerNo')> 
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.customerNo#">,
                        <cfelse>
                        	' ',
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add1)#">,   
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add3)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.department)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.contact)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.phone)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.hp)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.email)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fax)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add1)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add3)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_attn)#">,    
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_contact)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remark)#">,
                        <cfif trim(form.commission) neq "">   
                        	<cfqueryparam cfsqltype="cf_sql_double" value="#trim(form.commission)#">,                  
                        <cfelse>	
                        	'0.00',
                        </cfif>
                        <cfif IsDefined('form.discontinueDriver')>   
                        	'Y',                      
                        <cfelse>	
                        	'N',
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.photo_available)#">
                        )
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.driverNo)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/driver.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.driverno)# has been created successfully!');
				window.open('/latest/maintenance/driverProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateDriver" datasource="#dts#">
				UPDATE driver
				SET
					driverno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.driverNo#">,
                    name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,
                    name2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name2)#">,
                    attn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.attention)#">,
                    customerno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.customerNo)#">,
                    add1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add1)#">,
                    add2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add2)#">,
                    add3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add3)#">,
                    dept = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.department)#">,
                    contact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.contact)#">,
                    phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.phone)#">,
                    phonea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.hp)#">,
                    e_mail= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.email)#">,
                    fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fax)#">,
                    dadd1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add1)#">,
                    dadd2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add2)#">,
                    dadd3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add3)#">,
                    dattn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_attn)#">,
                    dcontact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_contact)#">,
                    remarks = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remark)#">,
                    commission1 = <cfqueryparam cfsqltype="cf_sql_double" value="#trim(form.commission)#">,
                    
                    <cfif IsDefined('form.discontinueDriver') >   
                        	discontinuedriver = 'Y'
                        <cfelse>	
                        	discontinuedriver = 'N'
                        </cfif>,
                    photo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.photo_available)#">        
				WHERE driverno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.driverNo)#">
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.driverNo)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/driver.cfm?action=update&driverno=#form.driverno#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.driverNo)# successfully!');
			window.open('/latest/maintenance/driverProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteDriver" datasource="#dts#">
				DELETE FROM driver
				WHERE driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLdriverno#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLdriverno#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/driverProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLdriverno# successfully!');
			window.open('/latest/maintenance/driverProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printDriver" datasource="#dts#">
			SELECT driverno,customerno,remarks
			FROM driver
			ORDER BY driverno;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Customer Service Listing</title>
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
			<h1 class="text">Customer Service Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>CUSTOMER SERVICE NO.</th>
					<th>CUSTOMER NO.</th>
                    <th>REMARKS</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printDriver">
				<tr>
					<td>#driverno#</td>
                    <td>#customerno#</td>
					<td>#remarks#</td>
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
			window.open('/latest/maintenance/driverProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/driverProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>