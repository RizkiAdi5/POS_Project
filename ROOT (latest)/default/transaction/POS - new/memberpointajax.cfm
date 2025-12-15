<cfsetting showdebugoutput="no">
<cfquery name="getgsetup" datasource="#dts#">
SELECT * FROM gsetup
</cfquery>
<cfoutput>
<cfif getgsetup.memberpoint eq 'Y'>
<cftry>
<cfquery name="getpoints" datasource="#dtssync#">
select ifnull(pointsbf+points-pointsredeem,0) as points from driver where driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.member#">
</cfquery>

Accumulated Point : #numberformat(getpoints.points,'.__')#
<cfcatch>
Accumulated Point : Unable To Get Points
</cfcatch></cftry>
</cfif>
</cfoutput>