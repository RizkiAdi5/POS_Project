<cfset c1 = url.c>
<cfquery name="gettax" datasource="main">
	select * from taxcode where code = '#c1#'
</cfquery>
<input name="taxtype2" type="text" value="<cfoutput>#gettax.type2#</cfoutput>" maxlength="12" readonly>
<cfsetting showdebugoutput="no">