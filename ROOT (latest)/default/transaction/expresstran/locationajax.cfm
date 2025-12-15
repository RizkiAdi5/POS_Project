<cfsetting showdebugoutput="no">
  <cfquery name="getlocation" datasource="#dts#">
  select location,desp from iclocation
	order by location
  </cfquery>
  <cfif url.type eq "TR">
  
<cfoutput>
<cfquery name="getddllocation" datasource="#dts#">
SELECT ddllocation FROM gsetup
</cfquery>
Location From &nbsp;&nbsp;&nbsp;&nbsp;<select name="locationfr" id="locationfr">
<cfloop query="getlocation">
<option value="#getlocation.location#"<cfif getddllocation.ddllocation eq getlocation.location> Selected</cfif>>#getlocation.location# - #getlocation.desp#</option>
</cfloop>
</select>
<br />
Location To &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="locationto" id="locationto">
<cfloop query="getlocation">
<option value="#location#">#location# - #desp#</option>
</cfloop>
</select>
</cfoutput>
<cfelse>
<cfoutput>

</cfoutput>
</cfif>