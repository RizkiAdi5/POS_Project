<cfsetting showdebugoutput="no">
<cfif url.tran eq "rc" or url.tran eq "pr" or url.tran eq "po">
      		<cfquery name="getcuststatus" datasource="#dts#">
        		Select status from #target_apvend# where custno = "#url.custno#"
      		</cfquery>
    	<cfelse>
      		<cfquery name="getcuststatus" datasource="#dts#">
        		Select status from #target_arcust# where custno = "#url.custno#"
      		</cfquery>
    	</cfif>

<cfif getcuststatus.status eq 'B'>

<font size="+1" color="#FF0000"><strong><cfoutput>This Customer/Supplier is Bad Status</cfoutput></strong></font>

</cfif>

<cfif url.tran eq "inv" and lcase(hcomid) eq "rpi270505_i">

<cfquery name="rpicustomeroutstanding" datasource="#dts#">
	select ifnull(sum(cs_pm_debt),0) as outstandingamt from artran where type in ('INV','CS') and (void="" or void is null) and custno = "#url.custno#"
</cfquery>
<cfoutput>
<input type="hidden" name="rpioutstandingamt" id="rpioutstandingamt" value="#rpicustomeroutstanding.outstandingamt#" />
</cfoutput>
</cfif>