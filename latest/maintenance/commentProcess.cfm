<cfif IsDefined('url.code')>
	<cfset URLcomment = trim(urldecode(url.code))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT code 
            FROM comments
			WHERE code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.comment)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.comment)# already exist!');
				window.open('/latest/maintenance/comment.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createComment" datasource="#dts#">
					INSERT INTO comments (code,desp,details)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.comment)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.detail)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.comment)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/comment.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.comment)# has been created successfully!');
				window.open('/latest/maintenance/commentProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateComment" datasource="#dts#">
				UPDATE comments
				SET
					code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comment#">,
					desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
                    details = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.detail)#">
				WHERE code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.comment)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.comment)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/comment.cfm?action=update&code=#form.comment#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.comment)# successfully!');
			window.open('/latest/maintenance/commentProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteComment" datasource="#dts#">
				DELETE FROM comments
				WHERE code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcomment#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLcomment#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/commentProfile.cfm','_self');
				</script>
			</cfcatch> 
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLcomment# successfully!');
			window.open('/latest/maintenance/commentProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printComment" datasource="#dts#">
			SELECT code,desp
			FROM comments
			ORDER BY code;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <title>Comment Listing</title>
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
                <h1 class="text">Comment Listing</h1>
                <p class="lead">Company: #getGsetup.compro#</p>
            </div>
            
            <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>COMMENT</th>
                        <th>DESCRIPTION</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="printComment">
                    <tr>
                        <td>#code#</td>
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
			window.open('/latest/maintenance/commentProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/commentProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>