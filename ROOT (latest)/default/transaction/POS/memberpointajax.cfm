<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2112, 2115">
<cfinclude template="/latest/words.cfm">

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

#words[2112]# : #numberformat(getpoints.points,'.__')#
<cfcatch>
#words[2112]# : #words[2115]#
</cfcatch></cftry>
</cfif>
</cfoutput>