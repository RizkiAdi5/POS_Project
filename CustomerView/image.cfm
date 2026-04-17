<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../application.cfm">
<cfsetting showdebugoutput="false">
<cfparam name="url.id" default="0">
<cfif NOT isNumeric(url.id) OR val(url.id) lte 0 OR NOT isDefined("dts") OR NOT len(trim(dts))>
    <cfheader statuscode="404" statustext="Not Found"><cfabort>
</cfif>
<cfquery name="qImg" datasource="#dts#">
    SELECT image_type, image_bytes FROM app_menu WHERE menu_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#">
    AND is_available = <cfqueryparam cfsqltype="cf_sql_tinyint" value="1">
</cfquery>
<cfif qImg.recordCount neq 1 OR NOT isBinary(qImg.image_bytes) OR len(qImg.image_bytes) lte 0>
    <cfheader statuscode="404" statustext="Not Found"><cfabort>
</cfif>
<cfset mimeOut = trim(toString(qImg.image_type))>
<cfif NOT len(mimeOut)><cfset mimeOut = "application/octet-stream"></cfif>
<cfheader name="Content-Type" value="#mimeOut#">
<cfheader name="Cache-Control" value="public, max-age=600">
<cfcontent variable="#qImg.image_bytes#" reset="true">
