<cfsetting showdebugoutput="no">
<cfquery name="getissueno" datasource="#dts#">
   		select * from artran where type='ISS'
	</cfquery>
	<cfoutput>  
    <cfif url.custno eq 'ASSM/999'>
    Issue No   
    <select name="issueno">
    <option value="">Choose a issue No</option>
    <cfloop query="getissueno" >
    <option value="ISS #getissueno.refno#">#getissueno.refno#</option>
    </cfloop>
    </select>
    <cfelse>
    </cfif>
    </cfoutput>