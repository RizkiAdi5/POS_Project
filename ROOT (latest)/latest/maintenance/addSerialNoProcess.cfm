<cfif IsDefined('url.itemno')>
	<cfset URLitemno = trim(urldecode(url.itemno))>
</cfif>
<cfif IsDefined('url.location')>
	<cfset URLlocation = trim(urldecode(url.location))>
</cfif>
<cfif IsDefined('url.serialno')>
	<cfset URLserialno = trim(urldecode(url.serialno))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<!---
        <cfquery name="checkExist" datasource="#dts#">
			SELECT * 
            FROM iserial
			WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemno#">
            AND serialno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.serialNo#">;
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim()# already exist!');
				window.open('/latest/maintenance/category.cfm?action=create','_self');
			</script>
		<cfelse> --->
			<cftry>
				<cfquery name="createSerialNo" datasource="#dts#">
					INSERT INTO iserial (type,trancode,itemno,wos_date,serialno,location,sign,refno)
					VALUES
                    <cfloop index="i" from="0" to="#form.quantity-1#">
						 <cfif i NEQ 0>
                            ,
                         </cfif>
                        (
                            'ADD',
                            '1',
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemno#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(form.date,'YYYY-MM-DD')#">,
                                <cfset serialValue= evaluate('form.serialNo#i#')>
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(serialValue)#">,	
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.location)#">,
                            '1',
                            ''
                        )
                    </cfloop>
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create Serial Number(s)!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/addSerialNo.cfm?action=create&itemno=#URLitemno#','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('Serial Number(s) has been created successfully!');
				window.open('/latest/maintenance/editSerialNoOpeningQty.cfm','_self');
			</script>
		<!---</cfif>--->
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateSerialNo" datasource="#dts#">
				UPDATE iserial
				SET  
                    location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.location#">,
                    wos_date = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(form.date,'YYYY-MM-DD')#">,
                    serialno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.serialNo)#">
				WHERE type = 'ADD'
                AND itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemno#">
                AND location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLlocation#">
                AND serialno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLserialno#">;   
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.serialNo)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/addSerialNo.cfm?action=update&itemno=#URLitemno#&serialno=#URLserialno#&location=#URLlocation#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.serialNo)# successfully!');
			window.open('/latest/maintenance/editSerialNoOpeningQty.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteSerialNo" datasource="#dts#">
				DELETE FROM iserial
				WHERE type = 'ADD'
                AND itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemno#">
                AND location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLlocation#">
                AND serialno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLserialno#">; 
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLserialno#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/editSerialNoOpeningQty.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLserialno# successfully!');
			window.open('/latest/maintenance/editSerialNoOpeningQty.cfm','_self');
		</script>	
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printSerialNo" datasource="#dts#">
			SELECT *
			FROM iserial
			ORDER BY serialno;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <title>Serial No Listing</title>
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
                    <h1 class="text">Serial No Listing</h1>
                    <p class="lead">Company: #getGsetup.compro#</p>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>SERIAL NO</th>
                                <th>LOCATION</th>
                                <th>DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop query="printSerialNo">
                            <tr>
                                <td>#serialno#</td>
                                <td>#location#</td>
                                <td>#date#</td>
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
			window.open('/latest/maintenance/editSerialNoOpeningQty.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/editSerialNoOpeningQty.cfm','_self');
	</script>
</cfif>
</cfoutput>