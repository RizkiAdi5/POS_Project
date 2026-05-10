<cfprocessingdirective pageencoding="UTF-8">
<cfsetting showdebugoutput="false">
<cfparam name="url.id" default="0">
<cfif NOT isNumeric(url.id) OR val(url.id) lte 0 OR NOT isDefined("dts") OR NOT len(trim(dts))>
    <cfheader statuscode="404" statustext="Not Found"><cfabort>
</cfif>
<cfquery name="qImg" datasource="#dts#">
    SELECT image_type, image_bytes FROM app_menu WHERE menu_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#">
</cfquery>
<cfif qImg.recordCount neq 1>
    <cfheader statuscode="404" statustext="Not Found"><cfabort>
</cfif>
<cfset ib = qImg.image_bytes>
<cfif isNull(ib)>
    <cfheader statuscode="404" statustext="Not Found"><cfabort>
</cfif>
<cfset byteLen = 0>
<cftry>
    <cfset byteLen = len(ib)>
    <cfcatch type="any"><cfset byteLen = 0></cfcatch>
</cftry>
<cfif val(byteLen) lte 0>
    <cfheader statuscode="404" statustext="Not Found"><cfabort>
</cfif>
<cfset mimeOut = trim(toString(qImg.image_type))>
<cfif NOT len(mimeOut)><cfset mimeOut = "application/octet-stream"></cfif>
<cfheader name="Content-Type" value="#mimeOut#">
<cfheader name="Cache-Control" value="private, max-age=0, must-revalidate">
<cfcontent variable="#ib#" reset="true">
