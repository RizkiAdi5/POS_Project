<!---
    /latest/customer/face_remove.cfm
    Clears the stored face_token for the logged-in customer.
--->
<cfinclude template="../../application.cfm">

<cfif SESSION.emenu_loggedin neq "Yes" OR NOT len(trim(SESSION.emenu_custno))>
    <cflocation url="/latest/customer/menu.cfm" addtoken="false">
</cfif>

<cftry>
    <cfquery datasource="#dts#">
        UPDATE arcust
        SET    face_token = NULL
        WHERE  CUSTNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.emenu_custno#">
    </cfquery>
    <cfcatch type="any"></cfcatch>
</cftry>

<cflocation url="/latest/customer/profile.cfm" addtoken="false">
