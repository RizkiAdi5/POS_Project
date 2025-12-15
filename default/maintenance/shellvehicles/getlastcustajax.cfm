<cfsetting showdebugoutput="no">

<cfquery name="getlastcust" datasource="#dts#">
select * from #target_arcust# where custno like '#url.custno#%' order by custno desc limit 5
</cfquery>

<cfoutput>
<br />
<b><u>Last 5 Record</u></b>

<cfloop query="getlastcust">
<br />#getlastcust.custno#
</cfloop>

</cfoutput>
