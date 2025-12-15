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
        <cfargument name="alown" required="yes">
        <cfargument name="huserid" required="yes">
        <cfargument name="Huserloc" required="yes">
		<cfargument name="include" required="yes">
		<cfargument name="include0" required="yes">
		<cfargument name="target_arcust" required="yes">
		
        <cfquery name="getgeneral" datasource="#dts#">
		select compro,lastaccyear,agentlistuserid from gsetup
		</cfquery>
        
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
			ifnull(b.sump1,0) as sump1,ifnull(c.sump2,0) as sump2,ifnull(d.sump3,0) as sump3,ifnull(e.sump4,0) as sump4,ifnull(f.sump5,0) as sump5,ifnull(g.sump6,0) as sump6,
			(ifnull(b.sump1,0)+ifnull(c.sump2,0)+ifnull(d.sump3,0)+ifnull(e.sump4,0)+ifnull(f.sump5,0)+ifnull(g.sump6,0)) as total 
			from #arguments.target_arcust# as a 
			<!--- Period 13 --->
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='13' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='13' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
			and agenno between '#arguments.agentfrom#' and '#arguments.agentto#' 
			</cfif> and wos_date > #arguments.lastaccyear# #msg2# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)) as sump1 from #arguments.target_arcust# as a 
			) as b on a.custno=b.custno 
			<!--- Period 14 --->
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='14' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='14' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
			and agenno between '#arguments.agentfrom#' and '#arguments.agentto#' 
			</cfif> and wos_date > #arguments.lastaccyear# #msg2# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)) as sump2 from #arguments.target_arcust# as a 
			) as c on a.custno=c.custno 
			<!--- Period 15 --->
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='15' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='15' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
			and agenno between '#arguments.agentfrom#' and '#arguments.agentto#' 
			</cfif> and wos_date > #arguments.lastaccyear# #msg2# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)) as sump3 from #arguments.target_arcust# as a
			) as d on a.custno=d.custno 
			<!--- Period 16 --->
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='16' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='16' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
			and agenno between '#arguments.agentfrom#' and '#arguments.agentto#' 
			</cfif> and wos_date > #arguments.lastaccyear# #msg2# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)) as sump4 from #arguments.target_arcust# as a
			) as e on a.custno=e.custno 
			<!--- Period 17 --->
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='17' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='17' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
			and agenno between '#arguments.agentfrom#' and '#arguments.agentto#' 
			</cfif> and wos_date > #arguments.lastaccyear# #msg2# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)) as sump5 from #arguments.target_arcust# as a
			) as f on a.custno=f.custno
			<!--- Period 18 --->
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='18' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='18' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
			and agenno between '#arguments.agentfrom#' and '#arguments.agentto#' 
			</cfif> and wos_date > #arguments.lastaccyear# #msg2# #critirial1#
            <cfif arguments.teamfrom neq "" and arguments.teamto neq "">
			and agenno in(select agent from icagent where team >= '#arguments.teamfrom#' and team <= '#arguments.teamto#')
			</cfif>
            <cfif alown eq 1>
						<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
						<cfelse>
           				and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
						</cfif>
						<cfelse>
						<cfif Huserloc neq "All_loc">
						and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
						</cfif>
						</cfif>
             #critirial2# group by custno),0)) as sump6 from #arguments.target_arcust# as a
			) as g on a.custno=g.custno
			
			where
			<cfswitch expression="#arguments.include0#">
				<cfcase value="yes">a.custno=a.custno</cfcase>
				<cfdefaultcase>(ifnull(b.sump1,0)+ifnull(c.sump2,0)+ifnull(d.sump3,0)+ifnull(e.sump4,0)+ifnull(f.sump5,0)+ifnull(g.sump6,0)) >0</cfdefaultcase>
			</cfswitch>
		<!--- 	<cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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