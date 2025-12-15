<cfsetting showdebugoutput="no">

<cfoutput>
	<cfquery name="checknric" datasource="#dts#">
   	select custno from #target_arcust# where arrem5='#url.NRIC#' and custno!='#url.custno#'	
	</cfquery>
    </cfoutput>
    <cfif checknric.recordcount neq 0>
    <input type="hidden" name="nric" id="nric" value="1" />
    <cfelse>
    <input type="hidden" name="nric" id="nric" value="" />
    </cfif>
	