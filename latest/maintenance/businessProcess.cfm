<cfif IsDefined('url.business')>
	<cfset URLbusiness = trim(urldecode(url.business))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT business 
            FROM business
			WHERE business=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.business)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.business)# already exist!');
				window.open('/latest/maintenance/business.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createBusiness" datasource="#dts#">
					INSERT INTO business (business,desp,pricelvl)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.business)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.priceLevel)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.business)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/business.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.business)# has been created successfully!');
				window.open('/latest/maintenance/businessProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateBusiness" datasource="#dts#">
				UPDATE business
				SET
					business = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.business#">,
					desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
                    pricelvl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.priceLevel)#">
				WHERE business = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.business)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.business)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/business.cfm?action=update&business=#form.business#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.business)# successfully!');
			window.open('/latest/maintenance/businessProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteBusiness" datasource="#dts#">
				DELETE FROM business
				WHERE business=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLbusiness#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLbusiness#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/businessProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLbusiness# successfully!');
			window.open('/latest/maintenance/businessProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printBusiness" datasource="#dts#">
			SELECT business,desp
			FROM business
			ORDER BY business;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <title>Business Listing</title>
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
                    <h1 class="text">Business Listing</h1>
                    <p class="lead">Company: #getGsetup.compro#</p>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>BUSINESS</th>
                                <th>DESCRIPTION</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop query="printBusiness">
                                <tr>
                                    <td>#business#</td>
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
			window.open('/latest/maintenance/businessProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/businessProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>