<cfcomponent>
	<cffunction name="getmonthcust">
		<cfargument name="dts" required="yes">
		<cfargument name="lastaccyear" required="yes">
		<cfargument name="agentfrom" required="yes">
		<cfargument name="agentto" required="yes">
        <cfargument name="teamfrom" required="yes">
		<cfargument name="teamto" required="yes">
		<cfargument name="areafrom" required="yes">
		<cfargument name="areato" required="yes">
		<cfargument name="include" required="yes">
		<cfargument name="include0" required="yes">
		<cfargument name="target_arcust" required="yes">
        <cfargument name="period" required="yes">
		
		<cfswitch expression="#arguments.include#">
			<cfcase value="yes">
				<cfset msg1 = 'and (type="INV" or type="CS" or type="DN")'>
				<cfset msg2 = 'and type="CN"'>
			</cfcase>
			<cfdefaultcase>
				<cfset msg1 = 'and (type="INV" or type="CS")'>
				<cfset msg2 = 'and type=""'>
			</cfdefaultcase>
		</cfswitch>		
		
		<cfif arguments.agentfrom neq "" and arguments.agentto neq "">
			<cfset critirial1 = 'and agenno between "#arguments.agentfrom#" and "#arguments.agentto#"'>
		<cfelse>
			<cfset critirial1 = "">
		</cfif>
		<cfif arguments.areafrom neq "" and arguments.areato neq "">
			<cfset critirial2 = 'and area between "#arguments.areafrom#" and "#arguments.areato#"'>
		<cfelse>
			<cfset critirial2 = "">
		</cfif>
		
		<cfquery name="getcust" datasource="#arguments.dts#">
			select a.custno as custno,a.name,a.agent,
			ifnull(b.sump1,0) as sump1,
			(ifnull(b.sump1,0)) as total 
			from #arguments.target_arcust# as a 
			<!--- Period 01 --->
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='#arguments.period#' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif> #critirial2# group by custno),0)
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='#arguments.period#' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
			and agenno between '#arguments.agentfrom#' and '#arguments.agentto#' 
			</cfif> and wos_date > #arguments.lastaccyear# #msg2# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif> #critirial2# group by custno),0)) as sump1 from #arguments.target_arcust# as a 
			) as b on a.custno=b.custno 
			
			where
			<cfswitch expression="#arguments.include0#">
				<cfcase value="yes">a.custno=a.custno</cfcase>
				<cfdefaultcase>(ifnull(b.sump1,0)) >0</cfdefaultcase>
			</cfswitch>
<!--- 			<cfif arguments.agentfrom neq "" and arguments.agentto neq "">
			and a.agent between '#arguments.agentfrom#' and '#arguments.agentto#' 
			</cfif> --->
			<cfif arguments.areafrom neq "" and arguments.areato neq "">
			and a.area between '#arguments.areafrom#' and '#arguments.areato#' 
			</cfif>
			group by a.custno order by a.custno
		</cfquery>
		<cfreturn getcust>
	</cffunction>
</cfcomponent>	