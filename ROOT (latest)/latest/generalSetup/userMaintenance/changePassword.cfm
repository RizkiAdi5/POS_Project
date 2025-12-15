<cfoutput>
<cfquery name="getUserID" datasource="main">
	SELECT *
    FROM users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getauthuser())#">;
</cfquery>

<cfquery name="getPasswordControls" datasource="main">
	SELECT *
    FROM passwordControls;
</cfquery>
<cfset passwordRepeatHistory = val(getPasswordControls.repeatPassword)>

<cfquery name="getLastChange" datasource="main">
	SELECT *
    FROM passwordHistory
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getauthuser())#">
    ORDER BY updatedOn DESC
    LIMIT 1;
</cfquery>

<cfquery name="getPasswordList" datasource="main">
	SELECT *
    FROM passwordHistory
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getauthuser())#">
    ORDER BY updatedOn DESC
    LIMIT #passwordRepeatHistory#;
</cfquery>

<cfset pageTitle = "Change Password">
<cfset userID = getUserID.userid>
<cfset userEmail = getUserID.useremail>
<cfset lastChanged = getLastChange.updatedOn>
<cfset lastChangedDate = DateFormat(getLastChange.updatedOn,"DD/MM/YYYY")>
<cfset lastChangedTime = TimeFormat(getLastChange.updatedOn,"HH:MM")>
<cfset currentTime = TimeFormat(NOW(),"HH:MM")>
<cfset minPasswordAge = val(getPasswordControls.minPasswordAgeHours *3600)>
<cfset minPasswordLength = getPasswordControls.minPasswordLength>
<cfset passwordList = valuelist(getPasswordList.oldpassword)>
<cfset formAction = "">

<cfif IsDefined('url.fromMainPage')>
	<cfset formAction = "?fromMainPage=1">
</cfif>

<!---
<cfif IsDate(lastChanged)>
	<cfif DateDiff("s",lastChanged,NOW()) LTE minPasswordAge> 
		 <script type="text/javascript">
			 alert("You can only change your password after #val(minPasswordAge/3600)# hours! \n\nLast Changed Date: #lastChangedDate# \nLast Changed Time: #lastChangedTime#");
			 window.open('/latest/body/bodymenu.cfm?id=60200','_self');
		 </script>
		<cfabort>
	</cfif>       
</cfif>
---->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
    <script type="text/javascript" src="/scripts/prototypenew.js" ></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->

    
    <script type="text/javascript"> 
    
        function confirmPassword(){
        
            var password = document.getElementById("newPassword").value;
            var confirmPassword = document.getElementById("newPassword2").value;
            
            if(password != confirmPassword) {
                alert("New Password doesn't match with New Password Repeat !");
				
				return false;	
            }
			else{
				return true;
			}
        }
        
        function validateStrength(){
			
            var symbols = "^[a-zA-Z!”$%&’()*\+,\/;\[\\\]\^_`{|}~]+$";
            var regularExpression = /((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[symbols]).{#minPasswordLength#,20})/
            var password = document.getElementById("newPassword").value;
            
            if (document.changePasswordForm.newPassword.value.search(regularExpression)==-1) {
                alert("New password must use (at least) the following: \n1. One digit [0-9] \n2. One lowercase character \n3. One uppercase characters \n4. One special character \n5.  Length at least #minPasswordLength# characters and maximum of 20 ! \n6. E.g tEst12345$");
			
				return false;	
            }	
			else{
				return true;		
			}
			
        }

        function validatePasswordHistory(){
			
			var urlissbatch = 'gethashajax.cfm?password='+escape(encodeURI(document.getElementById("newPassword").value));
			
			new Ajax.Request(urlissbatch,{
				method:'get',
				onSuccess: function(getdetailback){
				document.getElementById('passwordAjaxfield').innerHTML = getdetailback.responseText;
				},
				onFailure: function(){ 
				alert('error'); },		
				onComplete: function(transport){
			 
					var oldList = "#passwordList#"			
					var userInput = document.getElementById("hashedpassword").value;

					if (oldList.indexOf(userInput)>0){
						alert("Please do not use any of the last 5 passwords!");						
					}
				}
			})
		}
    </script>
   
</head>

<body class="container">
<cfoutput>
    <form class="formContainer form2Button" name="changePasswordForm" id="changePasswordForm" action="/latest/generalSetup/userMaintenance/changePasswordProcess.cfm#formAction#" method="post" onSubmit="document.getElementById('userID').disabled=false;<!--- return validateStrength(); --->return confirmPassword();">
    
        <div>#pageTitle#</div>
        <div>
            <table>
                <tr>
                    <th><label for="userID">User ID</label></th>
                    <td>
                        <input type="text" id="userID" name="userID" value="#userid#" disabled="true" />
                    </td>
                </tr>
                <tr>
                    <th><label for="email">Email Address</label></th>
                    <td>
                        <input type="text" id="email" name="email"  value="#userEmail#" disabled="true" />
                    </td>
                </tr>
                <tr>
                    <th><label for="oldPassword">Old Password</label></th>
                    <td>
                        <input type="password" id="oldPassword" name="oldPassword" required placeholder="Current Password" autocomplete="off"/>
                    </td>
                </tr>
                <!--- <tr>
                    <td colspan= "100%">
                    	<div style="margin-left:70px; border:2px solid ##CCCCCC; width:auto; color:##666679; background-color:##CCCCCC">
                            New password must use the following: 
                            <br />1. One digit [0-9] 
                            <br />2. One lowercase character 
                            <br />3. One uppercase characters
                            <br />4. One special character 
                            <br />5. Length at least #minPasswordLength# characters and maximum of 20
                            <br />6. Must have at least one different lower and upper case character
                        </div>
                    </td>	
                </tr> --->
                <tr>
                    <th><label for="newPassword">New Password</label></th>
                    <td>
                        <input type="password" id="newPassword" name="newPassword" required onBlur="validatePasswordHistory();" placeholder="E.g: aBcdE123@" autocomplete="off"/>        
                        <div id="passwordAjaxfield"></div>           
                    </td>
                </tr> 
                <tr>
                    <th><label for="newPassword2">New Password Repeat</label></th>
                    <td>
                        <input type="password" id="newPassword2" name="newPassword2" required onBlur="confirmPassword()" placeholder="E.g: aBcdE123@" autocomplete="off"/>                   
                    </td>
                </tr> 
            </table>
        </div>
        <div>
            <input type="submit" value="Change Password" />
            <cfif NOT IsDefined('url.fromMainPage')>
            	<input type="button" value="Cancel" onClick="window.location='/latest/body/bodymenu.cfm?id=60200'" />
            </cfif>
        </div>
    </form>
</cfoutput>
</body>
</html>
</cfoutput>

  