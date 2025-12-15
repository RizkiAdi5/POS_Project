<cfif husergrpid NEQ 'super'>
	<cfif IsDefined('url.comid') AND IsDefined('url.hcomid')>
		<cfif LCASE(trim(url.comid)) NEQ LCASE(trim(hcomid))>
            <cfabort>
        </cfif>
    </cfif>
</cfif>

<cfif IsDefined('url.userID')>
	<cfset URLuserID = trim(urldecode(url.userID))>
</cfif>

<cfif IsDefined('url.companyID')>
	<cfset URLcompanyID = trim(urldecode(url.companyID))>
</cfif>

<cfquery name="getUserLevel" datasource="#dts#">
	SELECT level
    FROM userpin2
	<cfif husergrpid NEQ "super">
		WHERE level != 'super'
	</cfif>
	ORDER BY level;
</cfquery>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create User">
		<cfset pageAction="Create">
        <!---Panel 1 --->
		<cfset userID = "">
        <cfset userName = "">
        <cfset userPassword = "">
        <cfset userLevel = "">
        <cfset userPhone = "">
        <cfset userEmail = "">
        <!---Panel 2 --->
        <cfset userCountry = "">
        <cfset location = "">
        <cfset group = "">
        <cfset project = "">
        <cfset job = "">

	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update User">
		<cfset pageAction="Update">
        <cfquery name="getUser" datasource='main'>
            SELECT userbranch,userid,username,userpwd,usergrpid,userphone,useremail,usercty,location,itemgroup,project,job
            FROM users
            WHERE userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLuserID#">;
		</cfquery>

        <!---Panel 1 --->
        <cfset userBranch = getUser.userBranch>
		<cfset userID = getUser.userid>
        <cfset userName = getUser.username>
        <cfset userPassword = ''>
        <cfset userLevel = getUser.usergrpid>
        <cfset userPhone = getUser.userphone>
        <cfset userEmail = getUser.useremail>
        <!---Panel 2 --->
        <cfset userCountry = getUser.usercty>
        <cfset location = getUser.location>
        <cfset group = getUser.itemgroup>
        <cfset project = getUser.project>
        <cfset job = getUser.job>
	</cfif>

</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title><cfoutput>pageTitle</cfoutput></title>
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap-timepicker/bootstrap-timepicker.min.css">
    <link rel="stylesheet" type="text/css" href="/latest/css/maintenance/target.css">
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <!--[if lt IE 9]>
        <script type="text/javascript" src="/latest/js/html5shiv/html5shiv.js"></script>
        <script type="text/javascript" src="/latest/js/respond/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
	<cfinclude template="/latest/filter/filterLocation.cfm">
	<cfinclude template="/latest/filter/filterGroup.cfm">
	<cfinclude template="/latest/filter/filterProject.cfm">
    <cfinclude template="/latest/filter/filterJob.cfm">
    <script type="text/javascript">
		function confirmPassword(){

            var password = document.getElementById("userPassword").value;
            var confirmPassword = document.getElementById("userPassword2").value;

            if(password != confirmPassword) {
                alert("New Password doesn't match with New Password Repeat !");

				return false;
            }
			else{
				return true;
			}
        }
	</script>
</head>

<body class="container">
<cfoutput>
    <form class="form-horizontal" role="form" action="/latest/generalSetup/userMaintenance/userProcess.cfm?action=#url.action#&companyID=#url.companyID#" method="post" onsubmit="document.getElementById('userID').disabled=false";>
        <div class="page-header">
            <h3>#pageTitle#</h3>
        </div>
            <div class="panel-group">
                <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" href="##panel1Collapse">
                        <h4 class="panel-title accordion-toggle">User Information</h4>
                    </div>
                    <div id="panel1Collapse" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label for="userID" class="col-sm-4 control-label">User ID</label>
                                        <div class="col-sm-8">
                                        	<input type="text" id="userID" name="userID" class="form-control input-sm" required="required" maxlength="50" <cfif IsDefined("url.action") AND url.action NEQ "create"> value="#userID#" disabled="true"</cfif>/>
                                        </div>
                                    </div>
                                     <div class="form-group">
                                        <label for="userName" class="col-sm-4 control-label">Username</label>
                                        <div class="col-sm-8">
                                        	<input type="text" id="userName" name="userName" class="form-control input-sm" required="required" maxlength="50" value="#userName#"/>
                                        </div>
                                    </div>
                                    <cfif husergrpid EQ 'admin' OR husergrpid EQ 'super'>
                                        <div class="form-group">
                                            <label for="password" class="col-sm-4 control-label">Password</label>
                                            <div class="col-sm-8">
                                                <input type="password" id="userPassword" name="userPassword" class="form-control input-sm" required="required" maxlength="32" value="#userPassword#" autocomplete="off"/>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="password" class="col-sm-4 control-label">Password Repeat</label>
                                            <div class="col-sm-8">
                                                <input type="password" id="userPassword2" name="userPassword2" class="form-control input-sm" required="required" onBlur="confirmPassword()" autocomplete="off"/>
                                            </div>
                                        </div>
                                    </cfif>
                                    <div class="form-group">
                                        <label for="userLevel" class="col-sm-4 control-label">User Level</label>
                                        <div class="col-sm-8">
                                        	<select class="form-control input-sm" id="userLevel" name="userLevel">
                                                <option value="">Choose a Level</option>
                                                <cfloop query="getUserLevel">
                                                    <option value="#getUserLevel.level#" <cfif getUserLevel.level EQ userLevel>selected</cfif>>#getUserLevel.level#</option>
                                                </cfloop>
											</select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="uesrPhone" class="col-sm-4 control-label">Phone</label>
                                        <div class="col-sm-8">
                                        	<input type="text" id="userPhone" name="userPhone" class="form-control input-sm" value="#userPhone#"/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="userEmail" class="col-sm-4 control-label">Email</label>
                                        <div class="col-sm-8">
                                        	<input type="text" id="userEmail" name="userEmail" class="form-control input-sm" value="#userEmail#"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" href="##panel2Collapse">
                        <h4 class="panel-title accordion-toggle">Detailed Information</h4>
                    </div>
                    <div id="panel2Collapse" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label for="country" class="col-sm-4 control-label">Country</label>
                                        <div class="col-sm-8">
                                        	<input type="text" id="userCountry" name="userCountry" class="form-control input-sm" value="#userCountry#"/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="location" class="col-sm-4 control-label">Location</label>
                                        <div class="col-sm-8">
                                        	<input type="hidden" id="location" name="location" class="locationFilter" value="#location#" />
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label for="group" class="col-sm-4 control-label">Group</label>
                                        <div class="col-sm-8">
                                        	<input type="hidden" id="group" name="group" class="groupFilter" value="#group#"/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="project" class="col-sm-4 control-label">Project</label>
                                        <div class="col-sm-8">
                                        	<input type="hidden" id="project" name="project" class="projectFilter" value="#project#"/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="job" class="col-sm-4 control-label">Job</label>
                                        <div class="col-sm-8">
                                        	<input type="hidden" id="job" name="job" class="jobFilter" value="#job#"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <div class="pull-right">
                <input type="submit" value="#pageAction#" class="btn btn-primary"/>
                <input type="button" value="Cancel" onclick="window.location='/latest/generalSetup/userMaintenance/userAdministration.cfm'" class="btn btn-default" />
            </div>
    </form>
</cfoutput>
</body>
</html>