<cfoutput>

<cfquery name="getGsetup" datasource="#dts#">
  Select * from GSetup
</cfquery>

<cftry>
<cfset newdob=createdate(right(url.dob,4),mid(url.dob,4,2),left(url.dob,2))>
<cfcatch>
<cfset newdob=form.dob>
</cfcatch>
</cftry>

<cfif getGsetup.memberpoint eq 'Y'>
    
    <cftry>
    <cfquery name="geteu" datasource="#dtssync#">
	SELECT driverno FROM driver where driverno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberid)#">
	</cfquery>
    <cfcatch><h3>No Internet connection</h3><cfabort></cfcatch></cftry>
    <cfelse>

<cfquery name="geteu" datasource="#dts#">
SELECT driverno FROM driver where driverno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberid)#">
</cfquery>

</cfif>

<cfif geteu.recordcount neq 0>
<cfabort showerror="Member Id Existed">
<cfelse>
<cfquery name="insert" datasource="#dts#">
Insert into Driver (driverno,name,contact,add1,add2,add3,dob,pricelevel)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberid)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.membername)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.membertel)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberadd1)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberadd2)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberadd3)#">,
<cfif dob eq ''>'0000-00-00'<cfelse>'#dateformat(newdob,'yyyy-mm-dd')#'</cfif>,
<cfif getGsetup.df_mem_price neq ''>'#getGsetup.df_mem_price#'<cfelse>'1'</cfif>
)
</cfquery>

<cfif getGsetup.memberpoint eq 'Y'>
<cfquery name="insert" datasource="#dtssync#">
Insert into Driver (driverno,name,contact,add1,add2,add3,dob,pricelevel)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberid)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.membername)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.membertel)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberadd1)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberadd2)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.memberadd3)#">,
<cfif dob eq ''>'0000-00-00'<cfelse>'#dateformat(newdob,'yyyy-mm-dd')#'</cfif>,
<cfif getGsetup.df_mem_price neq ''>'#getGsetup.df_mem_price#'<cfelse>'1'</cfif>
)
</cfquery>
</cfif>

</cfif>
</cfoutput>