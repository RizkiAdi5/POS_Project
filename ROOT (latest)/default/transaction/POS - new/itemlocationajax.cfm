<cfsetting showdebugoutput="no">
  <cfquery datasource="#dts#" name="getlocation">
	select 
	location,
	desp 
	from iclocation 
    where 0=0
    <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i") and (HUserGrpID neq 'Cust Svr' and HUserGrpID neq 'Van Sales')>
    <cfelse>
    <cfif Huserloc neq "All_loc">
	and location='#Huserloc#'
	</cfif>
    </cfif>
	order by location;
</cfquery>
  <cfif url.type eq "TR">
  
<cfoutput>
</cfoutput>
<cfelse>
<cfoutput>
<cfquery name="getddllocation" datasource="#dts#">
SELECT ddllocation FROM gsetup
</cfquery>
Location &nbsp;&nbsp;&nbsp;&nbsp;<select name="locationfr" id="locationfr">
<cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i") and (HUserGrpID neq 'Cust Svr' and HUserGrpID neq 'Van Sales')>
<option value="">Select a location</option>
<cfelse>
<cfif Huserloc eq "All_loc"><option value="">Select a location</option></cfif>
</cfif>
<cfloop query="getlocation">
<cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i") and (HUserGrpID neq 'Cust Svr' and HUserGrpID neq 'Van Sales')>
<option value="#getlocation.location#"<cfif Huserloc eq getlocation.location> Selected</cfif>>#getlocation.location# - #getlocation.desp#</option>
<cfelse>
<option value="#getlocation.location#"<cfif getddllocation.ddllocation eq getlocation.location> Selected</cfif>>#getlocation.location# - #getlocation.desp#</option>
</cfif>
</cfloop>
</select>
<input type="hidden" id="locationto" name="locationto" value="" />
</cfoutput>
</cfif>