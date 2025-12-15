<cfcomponent>
	<cffunction name="getmonthitem">
		<cfargument name="dts" required="yes">
		<cfargument name="lastaccyear" required="yes">
		<cfargument name="catefrom" required="yes">
		<cfargument name="cateto" required="yes">
		<cfargument name="itemfrom" required="yes">
		<cfargument name="itemto" required="yes">
		<cfargument name="agentfrom" required="yes">
		<cfargument name="agentto" required="yes">
        <cfargument name="teamfrom" required="yes">
		<cfargument name="teamto" required="yes">
		<cfargument name="areafrom" required="yes">
		<cfargument name="areato" required="yes">
		<cfargument name="groupfrom" required="yes">
		<cfargument name="groupto" required="yes">
		<cfargument name="label" required="yes">
        <cfargument name="alown" required="yes">
        <cfargument name="huserid" required="yes">
        <cfargument name="Huserloc" required="yes">
		<cfargument name="include" required="yes">
		<cfargument name="include0" required="yes">
		
        <cfquery name="getgeneral" datasource="#dts#">
		select compro,lastaccyear,agentlistuserid from gsetup
		</cfquery>
        
		<cfswitch expression="#arguments.label#">
			<cfcase value="salesqty">
				<cfset msg1 = "sum(qty)">
			</cfcase>
			<cfdefaultcase>
				<cfset msg1 = "sum(amt)">
			</cfdefaultcase>
		</cfswitch>
		
		<cfswitch expression="#arguments.include#">
			<cfcase value="yes">
				<cfset msg3 = 'and (type="INV" or type="CS" or type="DN")'>
				<cfset msg4 = 'and type="CN"'>
			</cfcase>
			<cfdefaultcase>
				<cfset msg3 = 'and (type="INV" or type="CS")'>
				<cfset msg4 = 'and type=""'>
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
		<cfif arguments.catefrom neq "" and arguments.cateto neq "">
			<cfset critirial3 = 'and category between "#arguments.catefrom#" and "#arguments.cateto#"'>
		<cfelse>
			<cfset critirial3 = "">
		</cfif>
		<cfif arguments.groupfrom neq "" and arguments.groupto neq "">
			<cfset critirial4 = 'and wos_group between "#arguments.groupfrom#" and "#arguments.groupto#"'>
		<cfelse>
			<cfset critirial4 = "">
		</cfif>
		<!--- REMARK ON 190908 --->
		<!--- <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
			<cfset critirial5 = 'and itemno between "#arguments.itemfrom#" and "#arguments.itemto#"'>
		<cfelse>
			<cfset critirial5 = "">
		</cfif> --->
		
		<cfquery name="getitem" datasource="#arguments.dts#">
			select a.itemno,a.desp,ifnull(b.sump1,0) as sump1,ifnull(c.sump2,0) as sump2,ifnull(d.sump3,0) as sump3,ifnull(e.sump4,0) as sump4,ifnull(f.sump5,0) as sump5,ifnull(g.sump6,0) as sump6,
			(ifnull(b.sump1,0)+ifnull(c.sump2,0)+ifnull(d.sump3,0)+ifnull(e.sump4,0)+ifnull(f.sump5,0)+ifnull(g.sump6,0)) as total 
			from icitem as a 
			<!--- Period 07 --->
			left join 
			(select a.itemno,(ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='07' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg3# #critirial1#
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
             #critirial2# #critirial3# #critirial4#  
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)
			-ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='07' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg4# #critirial1#
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
             #critirial2# #critirial3# #critirial4#  
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)) as sump1 from icitem as a 
			) as b on a.itemno=b.itemno 
			<!--- Period 08 --->
			left join 
			(select a.itemno,(ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='08' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg3# #critirial1#
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
             #critirial2# #critirial3# #critirial4#  
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)
			-ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='08' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg4# #critirial1#
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
             #critirial2# #critirial3# #critirial4#  
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)) as sump2 from icitem as a 
			) as c on a.itemno=c.itemno 
			<!--- Period 09 --->
			left join 
			(select a.itemno,(ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='09' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg3# #critirial1#
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
             #critirial2# #critirial3# #critirial4#  
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)
			-ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='09' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg4# #critirial1#
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
             #critirial2# #critirial3# #critirial4#  
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)) as sump3 from icitem as a
			) as d on a.itemno=d.itemno 
			<!--- Period 10 --->
			left join 
			(select a.itemno,(ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='10' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg3# #critirial1#
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
             #critirial2# #critirial3# #critirial4#  
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)
			-ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='10' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg4# #critirial1#
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
             #critirial2# #critirial3# #critirial4#  
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)) as sump4 from icitem as a
			) as e on a.itemno=e.itemno 
			<!--- Period 11 --->
			left join 
			(select a.itemno,(ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='11' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg3# #critirial1#
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
             #critirial2# #critirial3# #critirial4#  
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)
			-ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='11' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg4# #critirial1#
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
             #critirial2# #critirial3# #critirial4#  
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)) as sump5 from icitem as a
			) as f on a.itemno=f.itemno
			<!--- Period 12 --->
			left join 
			(select a.itemno,(ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='12' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg3# #critirial1#
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
             #critirial2# #critirial3# #critirial4#  
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)
			-ifnull((select #msg1# from ictran where itemno=a.itemno and fperiod='12' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg4# #critirial1#
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
             #critirial2# #critirial3# #critirial4# 
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by itemno),0)) as sump6 from icitem as a
			) as g on a.itemno=g.itemno
			
			where
			<cfswitch expression="#arguments.include0#">
				<cfcase value="yes">a.itemno=a.itemno</cfcase>
				<cfdefaultcase>(ifnull(b.sump1,0)+ifnull(c.sump2,0)+ifnull(d.sump3,0)+ifnull(e.sump4,0)+ifnull(f.sump5,0)+ifnull(g.sump6,0)) >0</cfdefaultcase>
			</cfswitch>
			<cfif arguments.catefrom neq "" and arguments.cateto neq "">
			and a.category between '#arguments.catefrom#' and '#arguments.cateto#' 
			</cfif>
			<cfif arguments.groupfrom neq "" and arguments.groupto neq "">
			and a.wos_group between '#arguments.groupfrom#' and '#arguments.groupto#' 
			</cfif>
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
			and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by a.itemno order by a.itemno
		</cfquery>
		<cfreturn getitem>
	</cffunction>
</cfcomponent>	