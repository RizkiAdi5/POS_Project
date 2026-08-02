<cfprocessingdirective pageencoding="UTF-8">
<cfif isDefined('url.kitchenID')>
    <cfset URLkitchenID = trim(urldecode(url.kitchenID))>
</cfif>

<cfoutput>
<cfif isDefined("url.action")>

    <cfif url.action EQ "create">
        <cfquery name="checkExist" datasource="#dts#">
            SELECT kitchenID FROM kitchen
            WHERE kitchenID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.kitchenID)#">
        </cfquery>
        <cfif checkExist.recordcount>
            <script type="text/javascript">
                alert('Kitchen ID "#trim(form.kitchenID)#" already exists!');
                window.open('/latest/maintenance/kitchen.cfm?action=create','_self');
            </script>
        <cfelse>
            <cftry>
                <cfquery name="createKitchen" datasource="#dts#">
                    INSERT INTO kitchen (kitchenID, name, password)
                    VALUES (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.kitchenID)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.password)#">
                    )
                </cfquery>
                <cfcatch type="any">
                    <script type="text/javascript">
                        alert('Failed to create "#trim(form.kitchenID)#"!\nError: #cfcatch.message#');
                        window.open('/latest/maintenance/kitchen.cfm?action=create','_self');
                    </script>
                </cfcatch>
            </cftry>
            <script type="text/javascript">
                alert('"#trim(form.kitchenID)#" created successfully!');
                window.open('/latest/maintenance/kitchenProfile.cfm','_self');
            </script>
        </cfif>

    <cfelseif url.action EQ "update">
        <cftry>
            <cfquery name="updateKitchen" datasource="#dts#">
                UPDATE kitchen
                SET name     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,
                    password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.password)#">
                WHERE kitchenID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.kitchenID)#">
            </cfquery>
            <cfcatch type="any">
                <script type="text/javascript">
                    alert('Failed to update "#trim(form.kitchenID)#"!\nError: #cfcatch.message#');
                    window.open('/latest/maintenance/kitchenProfile.cfm','_self');
                </script>
            </cfcatch>
        </cftry>
        <script type="text/javascript">
            alert('"#trim(form.kitchenID)#" updated successfully!');
            window.open('/latest/maintenance/kitchenProfile.cfm','_self');
        </script>

    <cfelseif url.action EQ "delete">
        <cftry>
            <cfquery name="deleteKitchen" datasource="#dts#">
                DELETE FROM kitchen
                WHERE kitchenID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLkitchenID#">
            </cfquery>
            <cfcatch type="any">
                <script type="text/javascript">
                    alert('Failed to delete "#URLkitchenID#"!\nError: #cfcatch.message#');
                    window.open('/latest/maintenance/kitchenProfile.cfm','_self');
                </script>
            </cfcatch>
        </cftry>
        <script type="text/javascript">
            alert('"#URLkitchenID#" deleted successfully!');
            window.open('/latest/maintenance/kitchenProfile.cfm','_self');
        </script>

    <cfelseif url.action EQ "print">
        <cfquery name="getGsetup" datasource="#dts#">
            SELECT compro FROM gsetup
        </cfquery>
        <cfquery name="printKitchen" datasource="#dts#">
            SELECT kitchenID, name FROM kitchen ORDER BY kitchenID
        </cfquery>

        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Kitchen Staff Listing</title>
        <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
        </head>
        <body>
        <div class="container">
            <div class="page-header">
                <h1>Kitchen Staff Listing</h1>
                <p class="lead">Company: #getGsetup.compro#</p>
            </div>
            <table class="table table-hover">
                <thead>
                    <tr><th>KITCHEN ID</th><th>NAME</th></tr>
                </thead>
                <tbody>
                    <cfloop query="printKitchen">
                    <tr><td>#kitchenID#</td><td>#name#</td></tr>
                    </cfloop>
                </tbody>
            </table>
            <p>Printed at #DateFormat(Now(),'dd-mm-yyyy')#, #TimeFormat(Now(),'HH:MM:SS')#</p>
        </div>
        </body>
        </html>

    <cfelse>
        <script type="text/javascript">window.open('/latest/maintenance/kitchenProfile.cfm','_self');</script>
    </cfif>

<cfelse>
    <script type="text/javascript">window.open('/latest/maintenance/kitchenProfile.cfm','_self');</script>
</cfif>
</cfoutput>
