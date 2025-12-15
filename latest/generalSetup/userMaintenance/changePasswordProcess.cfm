<cfoutput>
    <cfquery name="checkOldPassword" datasource="#dts#">
        SELECT * 
        FROM main.users
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">
        AND userpwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HASH(form.oldPassword)#">
        AND userbranch = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">;
    </cfquery>
    
    <cfif checkOldPassword.recordcount NEQ 1>
        <script type="text/javascript">
            alert('Old password is incorrect!');
            window.open('/latest/generalSetup/userMaintenance/changePassword.cfm','_self');
        </script>
    <cfelse>
        <cftry>
            <cfquery name="updatePassword" datasource="#dts#">
                UPDATE main.users
                SET
                    userpwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HASH(form.newPassword)#">
                WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">
                AND userpwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HASH(form.oldPassword)#">
                AND userbranch = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">;
            </cfquery>

            <cfquery name="insertPasswordHistory" datasource="#dts#">
              	INSERT INTO main.passwordHistory (userID,oldPassword,companyID,updatedOn,updatedBy)
				VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#HASH(form.oldPassword)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#dts#">,
                         NOW(),
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#">
					)
            </cfquery>

        <cfcatch type="any">
            <script type="text/javascript">
                alert('Failed to update the password!\nError Message: #cfcatch.message#');
                window.open('/latest/generalSetup/userMaintenance/changePassword.cfm?userid=#getauthuser()#','_self');
            </script>
        </cfcatch>
        </cftry>
		<script type="text/javascript">
			<cfif IsDefined('url.fromMainPage')>
				alert('Updated password successfully! Please relogin');
				window.open('/logout.cfm','_self');
			<cfelse>
				alert('Updated password successfully!');
            	window.open('/latest/body/bodymenu.cfm?id=60200','_self');
			</cfif>
        </script>	
    </cfif>
</cfoutput>