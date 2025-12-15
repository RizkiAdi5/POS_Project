<cfquery name="getUserID" datasource="main">
	SELECT *
    FROM users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getauthuser())#">;
</cfquery>

<cfquery name="getPasswordControls" datasource="main">
	SELECT *
    FROM passwordControls;
</cfquery>

<cfquery name="getLastLogin" datasource="main">
	SELECT *
    FROM users
    WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getauthuser())#">
    ORDER BY lastLogin DESC
    LIMIT 1;
</cfquery>

<cfset lastLoginDate = DateFormat(getLastLogin.lastLogin,"DD/MM/YYYY")>
<cfset currentTime = DateFormat(NOW(),"DD/MM/YYYY")>
<cfset disableAccountDays = getPasswordControls.disableAccountDays>
<cfset startReminderDisable = val(disableAccountDays)-7>
<cfset disableAfter = val(disableAccountDays)+1>


<cfif IsDate(lastLoginDate)>
	<cfif DateDiff("d",currentTime,lastLoginDate) GTE (#startReminderDisable#) AND DateDiff("d",currentTime,lastLoginDate) LTE (#startReminderDisable#) > 
        <cfif getUserID.userEmail NEQ ""> 
            <cftry>
            	<cfset remainingDays = DateDiff("d",currentTime,lastLoginDate) GTE (#startReminderDisable#)>
                 <cfmail from="noreply@mynetiquette.com" to="#getUserID.userEmail#" subject="IMS -- Inactive Account">
                    Dear Valued Customer,
                    
                    This is an automated message that is sent to notify you that your IMS account has been inactive for #remainingDays# days. For security purpose(s), this account will be disabled after the #disableAccountDays#th day being inactive.
                    
                    Please login to avoid it from being disabled.
                            
                    Thank you.
                    IMS Team 
                </cfmail>
            <cfcatch>
            </cfcatch>
            </cftry>
        </cfif>
    <cfelseif DateDiff("d",currentTime,lastLoginDate) GTE (#disableAfter#) >    
        <cfquery name="setUserPassword" datasource="main">
            UPDATE users
            SET userPwd = '', accountStatus = 'N'        
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(getauthuser())#">;
        </cfquery>
		<cfif getUserID.userEmail NEQ ""> 
            <cftry>
                <cfmail from="noreply@mynetiquette.com" to="#getUserID.userEmail#" subject="IMS -- Inactive Account">
                    Dear Valued Customer,
                    
                    This is an automated message that is sent to notify you that your IMS account has been disabled after being inactive for #disableAccountDays# days. Please contact our support team to assist you.
                            
                    Thank you.
                    IMS Team 
                </cfmail>
            <cfcatch>
            </cfcatch>
            </cftry>
    	</cfif>        
    </cfif>       
</cfif>