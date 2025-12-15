<cfparam name="status" default="">
<!--- ADD ON 15-07-2009 --->
<cfquery name="getGsetup" datasource="#dts#">
  Select lAGENT from GSetup
</cfquery>
<cfif form.mode eq "Create">
	<cfquery name="checkagentExist" datasource="#dts#">
 		select 
		agent 
		from icagent where agent='#form.agent#';
	</cfquery>
	
	<cfif checkagentExist.recordcount gt 0>
		<h3>
			<cfoutput><font color="FF0000">Error, This #getGsetup.lAGENT# has been created already.</font></cfoutput>
		</h3>
		<cfabort>
	</cfif>

	<cfinsert datasource="#dts#" tablename="icagent" formfields="agent,desp,commsion1,hp,agentID,agentlist,team">
	
    <cfquery name="insertpicture" datasource="#dts#">
    update icagent set photo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.picture_available#"> where agent='#form.agent#'
    </cfquery>
    
    <cfif isdefined('form.discontinueagent')>
    <cfquery name="insertdiscountinueagent" datasource="#dts#">
    update icagent set discontinueagent='Y' where agent='#form.agent#'
    </cfquery>
    </cfif>
    
	<cfset status="The #getGsetup.lAGENT#, #form.agent# had been successfully created.">
<cfelse>
	<cfquery datasource="#dts#" name="checkitemExist">
		select 
		agent 
		from icagent 
		where agent='#form.agent#';
	</cfquery>
	
	<cfif checkitemExist.recordcount gt 0>
		<cfif form.mode eq "Delete">
			<cfquery name="checktranexist" datasource="#dts#">
				select 
				agenno 
				from artran 
				where agenno='#form.agent#';
			</cfquery>
			
			<cfif checktranexist.recordcount gt 0>
				<h3>You have created transaction for this agent. You are not allowed to delete this agent.</h3>					
				<cfabort>
			</cfif>
			
			<cfquery datasource="#dts#" name="deleteitem">
				delete from icagent 
				where agent='#form.agent#';
			</cfquery>
			
			<cfset status="The #getGsetup.lAGENT#, #form.agent# had been successfully deleted.">
		</cfif>
		
		<cfif form.mode eq "Edit">
			<cfif lcase(HcomID) eq "avt_i" or lcase(HcomID) eq "net_i" or lcase(HcomID) eq "netm_i" or lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
				<cfquery name="update" datasource="#dts#">
					Update icagent
					Set desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
					commsion1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.commsion1#">,
					hp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hp#">,
                    team=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.team#">,
                    photo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.picture_available#">
                    <cfif isdefined('form.discontinueagent')>
                    ,discontinueagent='Y'
                    </cfif>
					Where agent=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">
				</cfquery>
			<cfelse>
				<cfquery name="update" datasource="#dts#">
					Update icagent
					Set desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
					commsion1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.commsion1#">,
					hp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hp#">,
                    team=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.team#">,
                    agentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agentID#">,
                    photo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.picture_available#">
                    ,
                    agentlist =<cfif isdefined('form.agentlist')> <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agentlist#">
                    <cfelse>
                    ""
                    </cfif>
                    <cfif isdefined('form.discontinueagent')>
                    ,discontinueagent='Y'
                    </cfif>
					Where agent=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">
				</cfquery>
			</cfif>
			<cfset status="The #getGsetup.lAGENT#, #form.agent# had been successfully edited.">
		</cfif>
	<cfelse>
		<cfset status="Sorry, the #getGsetup.lAGENT#, #form.agent# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>

<form name="done" action="s_agenttable.cfm?type=icagent&process=done" method="post">
	<input name="status" value="<cfoutput>#status#</cfoutput>" type="hidden">
</form>

<script>
	done.submit();
</script>