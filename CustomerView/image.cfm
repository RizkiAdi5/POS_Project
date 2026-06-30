<cfprocessingdirective pageencoding="UTF-8">
<cfinclude template="../application.cfm">
<cfsetting showdebugoutput="false">
<cfparam name="url.id" default="">
<cfif NOT len(trim(url.id)) OR NOT isDefined("dts") OR NOT len(trim(dts))>
    <cfheader statuscode="404" statustext="Not Found"><cfabort>
</cfif>
<cfquery name="qImg" datasource="#dts#">
    SELECT img_type AS image_type, img_bytes AS image_bytes FROM icitem
    WHERE ITEMNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.id)#">
    AND is_avail = 'T'
</cfquery>
<cfif qImg.recordCount neq 1 OR NOT isBinary(qImg.image_bytes) OR len(qImg.image_bytes) lte 0>
    <cfheader statuscode="404" statustext="Not Found"><cfabort>
</cfif>
<cfset mimeOut = trim(toString(qImg.image_type))>
<cfif NOT len(mimeOut)><cfset mimeOut = "application/octet-stream"></cfif>
<cfheader name="Content-Type" value="#mimeOut#">
<cfheader name="Cache-Control" value="public, max-age=600">
<cfcontent variable="#qImg.image_bytes#" reset="true">
