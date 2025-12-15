
<cfquery name="getGsetup" datasource="#dts#">
	SELECT compro,period,lastaccyear 
    FROM gsetup;
</cfquery>

<cfquery name="getModuleControl" datasource="#dts#">
	SELECT malaysiagst
    FROM modulecontrol;
</cfquery>

<cfquery name="getUsers" datasource="main">
	SELECT userid,usergrpid
    FROM users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getauthuser())#">;
</cfquery>

<cfquery name="getMasterUser" datasource="main">
    SELECT userID
    FROM masterUser
</cfquery>

<cfloop query="getMasterUser">
    <cfset masterUserList = ValueList(getMasterUser.userID,",")>
</cfloop>

<cfquery name="getUserLevel" datasource="#dts#">
    SELECT level 
    FROM userpin2 
    ORDER BY level;
</cfquery> 
            
<cfset userLevel = getUsers.usergrpid>
<cfset userID = getauthuser()>        


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>Inventory Management System</title>
    <link rel="stylesheet" href="/latest/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
    <link rel="stylesheet" href="/latest/css/pnotify/jquery.pnotify.default.css" />
    <link rel="stylesheet" href="/latest/css/header/header.css" />
    <cfoutput>
		<style>
            body {
                margin: 0;
            }
            ##container {
                height: 62px;
                margin: 0;
                border-bottom: 6px solid ##f0606d;
            }
            .company{
                background-image: url(/billformat/#dts#/companyLogo.jpg);
            }
        </style>
        <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="/latest/js/pnotify/jquery.pnotify.min.js"></script>
        <script type="text/javascript" src="/latest/js/header/header.js"></script>
        <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
        
        <cfif ListFind(masterUserList,HuserID)>
			<script type="text/javascript">
                function changeUserLevel(userID,newUserLvl){
                  
					ajaxFunction(document.getElementById('newUserLevel'),"updateNewUserLevel.cfm?userID=" + userID + "&newUserLvl=" + newUserLvl);
                }
				
				function refreshPage(){
					window.top.location = "/index.cfm";
				}
				
				<!---function Frame() {
					if (FrameStat == "Show") {
						FrameSize = "218px,*";
						FrameStat = "Hide";
					}
					else {
						FrameSize = "0,*";
						FrameStat = "Show";
					}
					parent.frameset1.cols = FrameSize;
				}
				onLoad=FrameStat="Hide";--->

            </script>
        </cfif>
    </cfoutput>
</head>
<body>
<cfoutput>
<div id="container">
    <div>	
        <div class="lastLoginInfo">
            <strong>Company ID:</strong> #listgetat(dts,'1','_')# &nbsp;&nbsp;&nbsp;
            <strong>User ID:</strong> #getUsers.userid# &nbsp;&nbsp;&nbsp;
            <cftry>
            	<strong>Login On:</strong> #DayOfWeekAsString(DayOfWeek(Session.loginTime))#,  #DateFormat(Session.loginTime, "dd-mm-yyyy")#, #TimeFormat(Session.loginTime, "HH:MM:SS")# &nbsp;&nbsp;&nbsp;
            <cfcatch>
            	 
            </cfcatch>
            </cftry>     
            <strong>IP Address:</strong> #cgi.REMOTE_ADDR# &nbsp;&nbsp;&nbsp;
            <strong>Account Year:</strong> #DateFormat(DateAdd('d',1,getGsetup.lastaccyear),'DD-MM-YYYY')# to #DateFormat(DateAdd('m',getGsetup.period,getGsetup.lastaccyear),'DD-MM-YYYY')#
        </div>
        <div class="menu">
            <div class="item">
                <a class="link logout" title="Logout" href="/latest/logout/logout.cfm" onclick="return confirm('Are you sure you want to log out?')" target="_parent"></a>
            </div>
            <div class="item expandable">
                <a class="link company" title="Click to change Company Logo" href="/latest/body/uploadLogo.cfm" target="mainFrame"></a>
                <div class="item_content">
                    <span class="company_name" title="#getGsetup.compro#">#getGsetup.compro#</span><br />
                    <span class="company_id" title="Company ID: #listgetat(dts,'1','_')#">Company ID: #listgetat(dts,'1','_')#</span>
                </div>
            </div>
            <div class="item">
                <a class="link contact" title="Contact" href="/latest/body/contact.cfm" target="mainFrame"></a>
            </div>
            <div class="item">
                <a class="link support" title="Help & Support" href="/latest/body/support.cfm" target="mainFrame"></a>
            </div>
            <div class="item">
                <a class="link home" title="Overview" href="/latest/body/overview.cfm" target="mainFrame"></a>
            </div>
            <cfif ListFind(masterUserList,HuserID)>
                <div class="changeUserLevel">
                	<select class="form-control input-sm" id="newUserLevel" name="newUserLevel" onchange="changeUserLevel('#userID#',this.value);refreshPage();">
                        <cfloop query="getUserLevel">
                            <option value="#getUserLevel.level#" <cfif getUserLevel.level EQ userLevel>selected</cfif>>#getUserLevel.level#</option>
                        </cfloop>
                    </select>   
                </div>
            </cfif>
            <cfif getModuleControl.malaysiagst EQ "1">
				<script language="javascript" type="text/javascript">
                    var left = (screen.width/2)-(800/2);
                    var top = (screen.height/2)-(600/2);
                    var targetWin = window.open ('/latest/overdueDOReport.cfm', 'Overdue DO', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=800, height=600, top='+top+', left='+left);
                </script>
            </cfif>
        </div>
    </div>
</div>
</cfoutput>
</body>
</html>