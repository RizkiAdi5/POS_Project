<cfquery name="updateUserLevel" datasource="#dts#">
    UPDATE main.users
    SET userGrpID = '#newUserLvl#'
    WHERE userID = '#userID#';
</cfquery>

