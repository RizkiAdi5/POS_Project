<cfcomponent>
	<cffunction name="getmonthuser">
		<cfargument name="dts" required="yes">
		<cfargument name="lastaccyear" required="yes">
		<cfargument name="userfrom" required="yes">
		<cfargument name="userto" required="yes">
		
		<cfif arguments.userfrom neq "" and arguments.userto neq "">
			<cfset critirial1 = 'and van between "#arguments.userfrom#" and "#arguments.userto#"'>
			<cfset critirial11 = 'and a.van between "#arguments.userfrom#" and "#arguments.userto#"'>
		<cfelse>
			<cfset critirial1 = "">
			<cfset critirial11 = "">
		</cfif>
		
		<cfquery name="getuser" datasource="#arguments.dts#">
			select a.van,(select name from driver where driverno=a.van) as desp,
			ifnull(b.sump1,0) as sump1,ifnull(c.sump2,0) as sump2,ifnull(d.sump3,0) as sump3,ifnull(e.sump4,0) as sump4,ifnull(f.sump5,0) as sump5,ifnull(g.sump6,0) as sump6,
			(ifnull(b.sump1,0)+ifnull(c.sump2,0)+ifnull(d.sump3,0)+ifnull(e.sump4,0)+ifnull(f.sump5,0)+ifnull(g.sump6,0)) as total 
			from artran as a 
			<!--- Period 07 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='07' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump1 
				from artran as a 
				where a.fperiod='07' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as b on a.van=b.van 
			<!--- Period 08 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='08' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump2 
				from artran as a 
				where a.fperiod='08' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as c on a.van=c.van 
			<!--- Period 09 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='09' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump3 
				from artran as a 
				where a.fperiod='09' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as d on a.van=d.van 
			<!--- Period 10 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='10' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump4 
				from artran as a 
				where a.fperiod='10' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as e on a.van=e.van 
			<!--- Period 11 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='11' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump5 
				from artran as a 
				where a.fperiod='11' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as f on a.van=f.van
			<!--- Period 12 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='12' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump6 
				from artran as a 
				where a.fperiod='12' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as g on a.van=g.van
			
			where a.van=a.van #critirial11#
			group by a.van order by a.van
		</cfquery>
		<cfreturn getuser>
	</cffunction>
</cfcomponent>	