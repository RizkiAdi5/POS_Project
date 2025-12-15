<cfsetting showdebugoutput="no">

<cfset desp=URLDecode(url.itemdesp)>
<cfset despa=URLDecode(url.itemdespa)>
<cfoutput>
<cfquery name="updateitemdesp" datasource="#dts#">
update ictrantemp set desp='#desp#',despa='#despa#' where trancode='#listfirst(url.trancode)#' and uuid='#url.uuid#'
</cfquery>

</cfoutput>