<cfif IsDefined('url.colorNo')>
	<cfset URLcolorNo = trim(urldecode(url.colorNo))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT colorno 
            FROM iccolor2
			WHERE colorno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.colorNo)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.colorNo)# already exist!');
				window.open('/latest/maintenance/colorSize.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createColorSize" datasource="#dts#">
					INSERT INTO iccolor2 (colorno,colorid2,desp <cfloop index="i" from="1" to="20">,size#i#</cfloop> )
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.colorNo)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.colorID)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">
                        <cfloop index="i" from="1" to="20">
                       		<cfset sizeValue = evaluate('form.size#i#')>	
                        		,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(sizeValue)#">
                        </cfloop>
					)
				</cfquery>
                
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.colorNo)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/colorSize.cfm?action=create','_self');
					</script>
				</cfcatch>
				
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.colorNo)# has been created successfully!');
				window.open('/latest/maintenance/colorSizeProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateColorSize" datasource="#dts#">
				UPDATE iccolor2
				SET
                	colorno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.colorNo#">,
					colorid2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.colorID#">,
					desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
					<cfloop index="i" from="1" to="20">
               			<cfset sizeValue = evaluate('form.size#i#')>	
                        	,size#i#=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(sizeValue)#">
                    </cfloop>
				WHERE colorno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.colorNo)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.colorNo)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/colorSize.cfm?action=update&colorNo=#form.colorNo#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.colorNo)# successfully!');
			window.open('/latest/maintenance/colorSizeProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteBrand" datasource="#dts#">
				DELETE FROM iccolor2
				WHERE colorno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcolorNo#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLcolorNo#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/sizeProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLcolorNo# successfully!');
			window.open('/latest/maintenance/colorSizeProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printColorSize" datasource="#dts#">
			SELECT colorno,colorid2,desp
			FROM iccolor2
			ORDER BY colorno;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Size Listing</title>
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
			<h1 class="text">ColorSize Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>COLOR NUMBER</th>
                    <th>COLOR ID</th>
					<th>DESCRIPTION</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printColorSize">
				<tr>
					<td>#colorno#</td>
                    <td>#colorid2#</td>
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
			window.open('/latest/maintenance/colorSizeProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/colorSizeProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>