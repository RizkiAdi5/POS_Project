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
			ifnull(h.sump7,0) as sump7,ifnull(i.sump8,0) as sump8,ifnull(j.sump9,0) as sump9,ifnull(k.sump10,0) as sump10,ifnull(l.sump11,0) as sump11,ifnull(m.sump12,0) as sump12,
			ifnull(n.sump13,0) as sump13,ifnull(o.sump14,0) as sump14,ifnull(p.sump15,0) as sump15,ifnull(q.sump16,0) as sump16,ifnull(r.sump17,0) as sump17,ifnull(s.sump18,0) as sump18,
			(ifnull(b.sump1,0)+ifnull(c.sump2,0)+ifnull(d.sump3,0)+ifnull(e.sump4,0)+ifnull(f.sump5,0)+ifnull(g.sump6,0)+
			ifnull(h.sump7,0)+ifnull(i.sump8,0)+ifnull(j.sump9,0)+ifnull(k.sump10,0)+ifnull(l.sump11,0)+ifnull(m.sump12,0)+
			ifnull(n.sump13,0)+ifnull(o.sump14,0)+ifnull(p.sump15,0)+ifnull(q.sump16,0)+ifnull(r.sump17,0)+ifnull(s.sump18,0)) as total 
			from artran as a 
			<!--- Period 01 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='01' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump1 
				from artran as a 
				where a.fperiod='01' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as b on a.van=b.van 
			<!--- Period 02 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='02' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump2 
				from artran as a 
				where a.fperiod='02' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as c on a.van=c.van 
			<!--- Period 03 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='03' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump3 
				from artran as a 
				where a.fperiod='03' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as d on a.van=d.van 
			<!--- Period 04 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='04' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump4 
				from artran as a 
				where a.fperiod='04' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as e on a.van=e.van 
			<!--- Period 05 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='05' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump5 
				from artran as a 
				where a.fperiod='05' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as f on a.van=f.van
			<!--- Period 06 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='06' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump6 
				from artran as a 
				where a.fperiod='06' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as g on a.van=g.van
			<!--- Period 07 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='07' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump7 
				from artran as a 
				where a.fperiod='07' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as h on a.van=h.van 
			<!--- Period 08 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='08' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump8 
				from artran as a 
				where a.fperiod='08' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as i on a.van=i.van 
			<!--- Period 09 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='09' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump9 
				from artran as a 
				where a.fperiod='09' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as j on a.van=j.van 
			<!--- Period 10 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='10' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump10 
				from artran as a 
				where a.fperiod='10' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as k on a.van=k.van 
			<!--- Period 11 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='11' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump11 
				from artran as a 
				where a.fperiod='11' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as l on a.van=l.van
			<!--- Period 12 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='12' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump12 
				from artran as a 
				where a.fperiod='12' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as m on a.van=m.van
			<!--- Period 13 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='13' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump13 
				from artran as a 
				where a.fperiod='13' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as n on a.van=n.van 
			<!--- Period 14 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='14' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump14 
				from artran as a 
				where a.fperiod='14' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as o on a.van=o.van 
			<!--- Period 15 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='15' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump15 
				from artran as a 
				where a.fperiod='15' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as p on a.van=p.van 
			<!--- Period 16 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='16' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump16 
				from artran as a 
				where a.fperiod='16' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as q on a.van=q.van 
			<!--- Period 17 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='17' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump17 
				from artran as a 
				where a.fperiod='17' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as r on a.van=r.van
			<!--- Period 18 --->
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='18' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump18
				from artran as a 
				where a.fperiod='18' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as s on a.van=s.van
			
			where a.van=a.van #critirial11#
			group by a.van order by a.van
		</cfquery>
		<cfreturn getuser>
	</cffunction>
</cfcomponent>	