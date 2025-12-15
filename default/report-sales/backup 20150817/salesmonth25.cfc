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
        <cfargument name="periodfrom" required="yes">
		<cfargument name="periodto" required="yes">
		
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
			select a.custno as custno,a.name,a.agent
			<cfif periodfrom  lte 1 and periodto gte 1 >,ifnull(b.sump1,0) as sump1</cfif><cfif periodfrom  lte 2 and periodto gte 2 >,ifnull(c.sump2,0) as sump2</cfif><cfif periodfrom  lte 3 and periodto gte 3 >,ifnull(d.sump3,0) as sump3</cfif><cfif periodfrom  lte 4 and periodto gte 4 >,ifnull(e.sump4,0) as sump4</cfif><cfif periodfrom  lte 5 and periodto gte 5 >,ifnull(f.sump5,0) as sump5</cfif><cfif periodfrom  lte 6 and periodto gte 6 >,ifnull(g.sump6,0) as sump6</cfif><cfif periodfrom  lte 7 and periodto gte 7 >,
			ifnull(h.sump7,0) as sump7</cfif><cfif periodfrom  lte 8 and periodto gte 8 >,ifnull(i.sump8,0) as sump8</cfif><cfif periodfrom  lte 9 and periodto gte 9 >,ifnull(j.sump9,0) as sump9</cfif><cfif periodfrom  lte 10 and periodto gte 10 >,ifnull(k.sump10,0) as sump10</cfif><cfif periodfrom  lte 11 and periodto gte 11 >,ifnull(l.sump11,0) as sump11</cfif><cfif periodfrom  lte 12 and periodto gte 12 >,ifnull(m.sump12,0) as sump12</cfif><cfif periodfrom  lte 13 and periodto gte 13 >,
			ifnull(n.sump13,0) as sump13</cfif><cfif periodfrom  lte 14 and periodto gte 14 >,ifnull(o.sump14,0) as sump14</cfif><cfif periodfrom  lte 15 and periodto gte 15 >,ifnull(p.sump15,0) as sump15</cfif><cfif periodfrom  lte 16 and periodto gte 16 >,ifnull(q.sump16,0) as sump16</cfif><cfif periodfrom  lte 17 and periodto gte 17 >,ifnull(r.sump17,0) as sump17</cfif><cfif periodfrom  lte 18 and periodto gte 18 >,ifnull(s.sump18,0) as sump18</cfif>,
			(0<cfif periodfrom  lte 1 and periodto gte 1 >+ifnull(b.sump1,0)</cfif><cfif periodfrom  lte 2 and periodto gte 2 >+ifnull(c.sump2,0)</cfif><cfif periodfrom  lte 3 and periodto gte 3 >+ifnull(d.sump3,0)</cfif><cfif periodfrom  lte 4 and periodto gte 4 >+ifnull(e.sump4,0)</cfif><cfif periodfrom  lte 5 and periodto gte 5 >+ifnull(f.sump5,0)</cfif><cfif periodfrom  lte 6 and periodto gte 6 >+ifnull(g.sump6,0)</cfif><cfif periodfrom  lte 7 and periodto gte 7 >+
			ifnull(h.sump7,0)</cfif><cfif periodfrom  lte 8 and periodto gte 8 >+ifnull(i.sump8,0)</cfif><cfif periodfrom  lte 9 and periodto gte 9 >+ifnull(j.sump9,0)</cfif><cfif periodfrom  lte 10 and periodto gte 10 >+ifnull(k.sump10,0)</cfif><cfif periodfrom  lte 11 and periodto gte 11 >+ifnull(l.sump11,0)</cfif><cfif periodfrom  lte 12 and periodto gte 12 >+ifnull(m.sump12,0)</cfif><cfif periodfrom  lte 13 and periodto gte 13 >+
			ifnull(n.sump13,0)</cfif><cfif periodfrom  lte 14 and periodto gte 14 >+ifnull(o.sump14,0)</cfif><cfif periodfrom  lte 15 and periodto gte 15 >+ifnull(p.sump15,0)</cfif><cfif periodfrom  lte 16 and periodto gte 16 >+ifnull(q.sump16,0)</cfif><cfif periodfrom  lte 17 and periodto gte 17 >+ifnull(r.sump17,0)</cfif><cfif periodfrom  lte 18 and periodto gte 18 >+ifnull(s.sump18,0)</cfif>) as total 
			from #arguments.target_arcust# as a 
			<!--- Period 01 --->
            <cfif periodfrom  lte 1 and periodto gte 1 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='01' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='01' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
            </cfif>
			<!--- Period 02 --->
            <cfif periodfrom  lte 2 and periodto gte 2 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='02' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='02' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
            </cfif>
			<!--- Period 03 --->
            <cfif periodfrom  lte 3 and periodto gte 3 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='03' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='03' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
            </cfif>
			<!--- Period 04 --->
            <cfif periodfrom  lte 4 and periodto gte 4 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='04' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='04' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
            </cfif>
			<!--- Period 05 --->
            <cfif periodfrom  lte 5 and periodto gte 5 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='05' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='05' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
            </cfif>
			<!--- Period 06 --->
            <cfif periodfrom  lte 6 and periodto gte 6 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='06' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='06' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
            </cfif>
			<!--- Period 07 --->
            <cfif periodfrom  lte 7 and periodto gte 7 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='07' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='07' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
             #critirial2# group by custno),0)) as sump7 from #arguments.target_arcust# as a 
			) as h on a.custno=h.custno 
            </cfif>
			<!--- Period 08 --->
            <cfif periodfrom  lte 8 and periodto gte 8 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='08' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='08' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
             #critirial2# group by custno),0)) as sump8 from #arguments.target_arcust# as a 
			) as i on a.custno=i.custno 
            </cfif>
			<!--- Period 09 --->
            <cfif periodfrom  lte 9 and periodto gte 9 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='09' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='09' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
             #critirial2# group by custno),0)) as sump9 from #arguments.target_arcust# as a
			) as j on a.custno=j.custno 
            </cfif>
			<!--- Period 10 --->
            <cfif periodfrom  lte 10 and periodto gte 10 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='10' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='10' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
             #critirial2# group by custno),0)) as sump10 from #arguments.target_arcust# as a
			) as k on a.custno=k.custno 
            </cfif>
			<!--- Period 11 --->
            <cfif periodfrom  lte 11 and periodto gte 11 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='11' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='11' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
             #critirial2# group by custno),0)) as sump11 from #arguments.target_arcust# as a
			) as l on a.custno=l.custno
            </cfif>
			<!--- Period 12 --->
            <cfif periodfrom  lte 12 and periodto gte 12 >
			left join 
			(select a.custno,(ifnull((select sum(net) from artran where custno=a.custno and fperiod='12' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# #msg1# #critirial1#
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
			-ifnull((select sum(net) from artran where custno=a.custno and fperiod='12' and (void = '' or void is null) <cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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
             #critirial2# group by custno),0)) as sump12 from #arguments.target_arcust# as a
			) as m on a.custno=m.custno
            </cfif>
			<!--- Period 13 --->
            <cfif periodfrom  lte 13 and periodto gte 13 >
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
             #critirial2# group by custno),0)) as sump13 from #arguments.target_arcust# as a 
			) as n on a.custno=n.custno 
            </cfif>
			<!--- Period 14 --->
            <cfif periodfrom  lte 14 and periodto gte 14 >
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
             #critirial2# group by custno),0)) as sump14 from #arguments.target_arcust# as a 
			) as o on a.custno=o.custno 
            </cfif>
			<!--- Period 15 --->
            <cfif periodfrom  lte 15 and periodto gte 15 >
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
             #critirial2# group by custno),0)) as sump15 from #arguments.target_arcust# as a
			) as p on a.custno=p.custno 
            </cfif>
			<!--- Period 16 --->
            <cfif periodfrom  lte 16 and periodto gte 16 >
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
             #critirial2# group by custno),0)) as sump16 from #arguments.target_arcust# as a
			) as q on a.custno=q.custno 
            </cfif>
			<!--- Period 17 --->
            <cfif periodfrom  lte 17 and periodto gte 17 >
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
             #critirial2# group by custno),0)) as sump17 from #arguments.target_arcust# as a
			) as r on a.custno=r.custno
            </cfif>
			<!--- Period 18 --->
            <cfif periodfrom  lte 18 and periodto gte 18 >
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
             #critirial2# group by custno),0)) as sump18 from #arguments.target_arcust# as a
			) as s on a.custno=s.custno
            </cfif>
			
			where
			<cfswitch expression="#arguments.include0#">
				<cfcase value="yes">a.custno=a.custno</cfcase>
				<cfdefaultcase>
					(0<cfif periodfrom  lte 1 and periodto gte 1 >+ifnull(b.sump1,0)</cfif><cfif periodfrom  lte 2 and periodto gte 2 >+ifnull(c.sump2,0)</cfif><cfif periodfrom  lte 3 and periodto gte 3 >+ifnull(d.sump3,0)</cfif><cfif periodfrom  lte 4 and periodto gte 4 >+ifnull(e.sump4,0)</cfif><cfif periodfrom  lte 5 and periodto gte 5 >+ifnull(f.sump5,0)</cfif><cfif periodfrom  lte 6 and periodto gte 6 >+ifnull(g.sump6,0)</cfif><cfif periodfrom  lte 7 and periodto gte 7 >+
					ifnull(h.sump7,0)</cfif><cfif periodfrom  lte 8 and periodto gte 8 >+ifnull(i.sump8,0)</cfif><cfif periodfrom  lte 9 and periodto gte 9 >+ifnull(j.sump9,0)</cfif><cfif periodfrom  lte 10 and periodto gte 10 >+ifnull(k.sump10,0)</cfif><cfif periodfrom  lte 11 and periodto gte 11 >+ifnull(l.sump11,0)</cfif><cfif periodfrom  lte 12 and periodto gte 12 >+ifnull(m.sump12,0)</cfif><cfif periodfrom  lte 13 and periodto gte 13 >+
					ifnull(n.sump13,0)</cfif><cfif periodfrom  lte 14 and periodto gte 14 >+ifnull(o.sump14,0)</cfif><cfif periodfrom  lte 15 and periodto gte 15 >+ifnull(p.sump15,0)</cfif><cfif periodfrom  lte 16 and periodto gte 16 >+ifnull(q.sump16,0)</cfif><cfif periodfrom  lte 17 and periodto gte 17 >+ifnull(r.sump17,0)</cfif><cfif periodfrom  lte 18 and periodto gte 18 >+ifnull(s.sump18,0)</cfif>) >0
				</cfdefaultcase>
			</cfswitch>
	<!--- 		<cfif arguments.agentfrom neq "" and arguments.agentto neq "">
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