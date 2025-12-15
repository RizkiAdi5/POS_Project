<cfif husergrpid NEQ 'super'>
	<cfif IsDefined('url.comid') AND IsDefined('url.hcomid')>
		<cfif UCASE(trim(url.comid)) NEQ UCASE(trim(hcomid))>
            <cfabort>
        </cfif>
    </cfif>
</cfif>

<cfif IsDefined('url.companyID')>
	<cfset companyID = trim(urldecode(url.companyID))>
</cfif>

<cfif IsDefined('url.comid')>
	<cfset companyID = trim(urldecode(url.comid))>
</cfif>

<cfif IsDefined('url.userID')>
	<cfset huserid = trim(urldecode(url.userID))>
</cfif>

<cfquery name="getTotalUserCount" datasource="main">
	SELECT COUNT(userid) AS totalUserCount 
    FROM users 
    WHERE userbranch = "#dts#" 
    AND usergrpid != "super" 
    GROUP BY userbranch;  
</cfquery>

<cfquery name="getUserLimit" datasource="main">
	SELECT usercount AS userLimit
    FROM useraccountlimit 
    WHERE companyid = "#dts#";
</cfquery>

<cfset pageTitle="User Administration -- #UCASE(replace(companyID,'_i',''))#">
<cfset targetTitle="User">
<cfset targetTable="">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/latest/css/dataTables/dataTables_bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="/latest/css/maintenance/profile.css" />
    <!--[if lt IE 9]>
        <script type="text/javascript" src="/latest/js/html5shiv/html5shiv.js"></script>
        <script type="text/javascript" src="/latest/js/respond/respond.min.js"></script>
    <![endif]-->
 
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
    <script type="text/javascript" src="/latest/js/dataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="/latest/js/dataTables/dataTables_bootstrap.js"></script>

    <cfoutput>
    <script type="text/javascript">
        var dts='#dts#';
        var targetTitle='#targetTitle#';
		var targetTable='#companyID#';
		var userGroup='#husergrpid#';
		var userID='#huserid#';
    </script>
    </cfoutput>
    <script type="text/javascript" src="/latest/js/generalSetup/userMaintenance/userAdministration2.js"></script>

</head>

<body>
<cfoutput>
<div class="container">
	<div class="page-header">
		<h2>
			#pageTitle#
			<span class="glyphicon glyphicon-question-sign btn-link"></span>
			<span class="glyphicon glyphicon-facetime-video btn-link"></span>
            
            <div class="pull-right">
            	<cfset condition1 = val(getTotalUserCount.totalUserCount) LT val(getUserLimit.userLimit)>
                <cfset condition2 = HusergrpID EQ "admin">
                <cfset condition3 = HusergrpID EQ "super">
                
<!---				<cfif (condition1 AND condition2) OR condition3>--->
                    <button type="button" class="btn btn-default" onclick="window.open('/latest/generalSetup/userMaintenance/user.cfm?action=create&companyID=#companyID#','_self');">
                        <span class="glyphicon glyphicon-plus"></span> Add #targetTitle#
                    </button>
                <!---</cfif>--->
			</div>
		</h2>
	</div>
	<div class="container">
		<table class="table table-bordered table-hover" id="resultTable" style="table-layout:fixed">
			<thead>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</div>
</cfoutput>
</body>
</html>