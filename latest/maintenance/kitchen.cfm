<cfprocessingdirective pageencoding="UTF-8">
<cfif isDefined('url.kitchenID')>
    <cfset URLkitchenID = trim(urldecode(url.kitchenID))>
</cfif>

<cfif isDefined("url.action")>
    <cfif url.action EQ "create">
        <cfset pageTitle="Add Kitchen Staff">
        <cfset pageAction="Save">
        <cfset kitchenID = "">
        <cfset name = "">
        <cfset password = "">
    <cfelseif url.action EQ "update">
        <cfset pageTitle="Edit Kitchen Staff">
        <cfset pageAction="Update">
        <cfquery name="getKitchen" datasource='#dts#'>
            SELECT * FROM kitchen
            WHERE kitchenID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLkitchenID#">
        </cfquery>
        <cfset kitchenID = getKitchen.kitchenID>
        <cfset name = getKitchen.name>
        <cfset password = getKitchen.password>
    <cfelseif url.action EQ "delete">
        <cfset pageTitle="Delete Kitchen Staff">
        <cfset pageAction="Delete">
        <cfquery name="getKitchen" datasource='#dts#'>
            SELECT * FROM kitchen
            WHERE kitchenID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLkitchenID#">
        </cfquery>
        <cfset kitchenID = getKitchen.kitchenID>
        <cfset name = getKitchen.name>
        <cfset password = getKitchen.password>
    </cfif>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
</head>

<body class="container">
<cfoutput>
    <form class="formContainer form2Button"
          action="/latest/maintenance/kitchenProcess.cfm?action=#url.action#"
          method="post"
          onsubmit="document.getElementById('kitchenID').disabled=false">
        <div>#pageTitle#</div>
        <div>
            <table>
                <tr>
                    <th><label for="kitchenID">Kitchen ID</label></th>
                    <td>
                        <input type="text" id="kitchenID" name="kitchenID" required="required" maxlength="25"
                            <cfif isDefined("url.action") AND url.action NEQ "create">value="#URLkitchenID#" disabled="true"</cfif> />
                    </td>
                </tr>
                <tr>
                    <th><label for="name">Name</label></th>
                    <td>
                        <input type="text" id="name" name="name" value="#name#" />
                    </td>
                </tr>
                <tr>
                    <th><label for="password">Password</label></th>
                    <td>
                        <input type="password" id="password" name="password" value="#password#" />
                    </td>
                </tr>
            </table>
        </div>
        <div>
            <input type="submit" value="#pageAction#" />
            <input type="button" value="Cancel" onclick="window.location='/latest/maintenance/kitchenProfile.cfm'" />
        </div>
    </form>
</cfoutput>
</body>
</html>
