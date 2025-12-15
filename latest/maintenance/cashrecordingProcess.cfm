<cfif IsDefined('url.ID')>
	<cfset URLID = trim(urldecode(url.ID))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="insert" datasource="#dts#">
        INSERT INTO dailycounter
        (
        counterid,
        openning,
        wos_date,
        created_on,
        created_by,
        type,desp
        )
        VALUES
        (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.counter#">,
        <cfqueryparam cfsqltype="cf_sql_double" value="#numberformat(val(form.amount),'.__')#"> ,
        "#dateformat(createdate(right(form.wos_date,4),mid(form.wos_date,4,2),left(form.wos_date,2)),'YYYY-MM-DD')#",
        now(),
        "#huserid#",
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
        )
        </cfquery>
        <script type="text/javascript">
			alert('Create successfully!');
			window.open('/latest/maintenance/cashrecordingProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "update">
   		
        <cfquery name="checkexist" datasource="#dts#">
        select * from dailycounter where id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.openingid#"> 
        </cfquery>
        
        <cfif checkexist.recordcount neq 0>
        
        <cfquery name="update" datasource="#dts#">
        update dailycounter set 
        openning=<cfqueryparam cfsqltype="cf_sql_double" value="#numberformat(val(form.amount),'.__')#"> ,
        updated_on=now(),
        updated_by="#huserid#",
        type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.type#">,
        desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
        
        where id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.openingid#"> 
        
        </cfquery>
        <script type="text/javascript">
			alert('Updated #trim(form.openingid)# successfully!');
			window.open('/latest/maintenance/cashrecordingProfile.cfm','_self');
		</script>	
        <cfelse>
        <script type="text/javascript">
				alert('Failed to update #trim(form.openingid)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/category.cfm?action=update&openingid=#form.openingid#','_self');
			</script>
        </cfif>

	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="insert" datasource="#dts#">
            	delete from dailycounter where id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLID#"> 
            </cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLID#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/cashrecordingProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLID# successfully!');
			window.open('/latest/maintenance/cashrecordingProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printCashier" datasource="#dts#">
			SELECT openingid,name
			FROM cashier
			ORDER BY openingid;
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
					<td>#openingid#</td>
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
			window.open('/latest/maintenance/cashrecordingProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/cashrecordingProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>