<cfcomponent>
	<cffunction name="getmonthuser">
		<cfargument name="dts" required="yes">
		<cfargument name="lastaccyear" required="yes">
		<cfargument name="userfrom" required="yes">
		<cfargument name="userto" required="yes">
        <cfargument name="periodfrom" required="yes">
		<cfargument name="periodto" required="yes">
		
		<cfif arguments.userfrom neq "" and arguments.userto neq "">
			<cfset critirial1 = 'and van between "#arguments.userfrom#" and "#arguments.userto#"'>
			<cfset critirial11 = 'and a.van between "#arguments.userfrom#" and "#arguments.userto#"'>
		<cfelse>
			<cfset critirial1 = "">
			<cfset critirial11 = "">
		</cfif>
		
		<cfquery name="getuser" datasource="#arguments.dts#">
			select a.van,(select name from driver where driverno=a.van) as desp
			<cfif periodfrom  lte 1 and periodto gte 1 >,ifnull(b.sump1,0) as sump1</cfif><cfif periodfrom  lte 2 and periodto gte 2 >,ifnull(c.sump2,0) as sump2</cfif><cfif periodfrom  lte 3 and periodto gte 3 >,ifnull(d.sump3,0) as sump3</cfif><cfif periodfrom  lte 4 and periodto gte 4 >,ifnull(e.sump4,0) as sump4</cfif><cfif periodfrom  lte 5 and periodto gte 5 >,ifnull(f.sump5,0) as sump5</cfif><cfif periodfrom  lte 6 and periodto gte 6 >,ifnull(g.sump6,0) as sump6</cfif><cfif periodfrom  lte 7 and periodto gte 7 >,
			ifnull(h.sump7,0) as sump7</cfif><cfif periodfrom  lte 8 and periodto gte 8 >,ifnull(i.sump8,0) as sump8</cfif><cfif periodfrom  lte 9 and periodto gte 9 >,ifnull(j.sump9,0) as sump9</cfif><cfif periodfrom  lte 10 and periodto gte 10 >,ifnull(k.sump10,0) as sump10</cfif><cfif periodfrom  lte 11 and periodto gte 11 >,ifnull(l.sump11,0) as sump11</cfif><cfif periodfrom  lte 12 and periodto gte 12 >,ifnull(m.sump12,0) as sump12</cfif><cfif periodfrom  lte 13 and periodto gte 13 >,
			ifnull(n.sump13,0) as sump13</cfif><cfif periodfrom  lte 14 and periodto gte 14 >,ifnull(o.sump14,0) as sump14</cfif><cfif periodfrom  lte 15 and periodto gte 15 >,ifnull(p.sump15,0) as sump15</cfif><cfif periodfrom  lte 16 and periodto gte 16 >,ifnull(q.sump16,0) as sump16</cfif><cfif periodfrom  lte 17 and periodto gte 17 >,ifnull(r.sump17,0) as sump17</cfif><cfif periodfrom  lte 18 and periodto gte 18 >,ifnull(s.sump18,0) as sump18</cfif>,
			(0<cfif periodfrom  lte 1 and periodto gte 1 >+ifnull(b.sump1,0)</cfif><cfif periodfrom  lte 2 and periodto gte 2 >+ifnull(c.sump2,0)</cfif><cfif periodfrom  lte 3 and periodto gte 3 >+ifnull(d.sump3,0)</cfif><cfif periodfrom  lte 4 and periodto gte 4 >+ifnull(e.sump4,0)</cfif><cfif periodfrom  lte 5 and periodto gte 5 >+ifnull(f.sump5,0)</cfif><cfif periodfrom  lte 6 and periodto gte 6 >+ifnull(g.sump6,0)</cfif><cfif periodfrom  lte 7 and periodto gte 7 >+
			ifnull(h.sump7,0)</cfif><cfif periodfrom  lte 8 and periodto gte 8 >+ifnull(i.sump8,0)</cfif><cfif periodfrom  lte 9 and periodto gte 9 >+ifnull(j.sump9,0)</cfif><cfif periodfrom  lte 10 and periodto gte 10 >+ifnull(k.sump10,0)</cfif><cfif periodfrom  lte 11 and periodto gte 11 >+ifnull(l.sump11,0)</cfif><cfif periodfrom  lte 12 and periodto gte 12 >+ifnull(m.sump12,0)</cfif><cfif periodfrom  lte 13 and periodto gte 13 >+
			ifnull(n.sump13,0)</cfif><cfif periodfrom  lte 14 and periodto gte 14 >+ifnull(o.sump14,0)</cfif><cfif periodfrom  lte 15 and periodto gte 15 >+ifnull(p.sump15,0)</cfif><cfif periodfrom  lte 16 and periodto gte 16 >+ifnull(q.sump16,0)</cfif><cfif periodfrom  lte 17 and periodto gte 17 >+ifnull(r.sump17,0)</cfif><cfif periodfrom  lte 18 and periodto gte 18 >+ifnull(s.sump18,0)</cfif>) as total 
			from artran as a 
			<!--- Period 01 --->
            <cfif periodfrom  lte 1 and periodto gte 1 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='01' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump1 
				from artran as a 
				where a.fperiod='01' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as b on a.van=b.van 
            </cfif>
			<!--- Period 02 --->
            <cfif periodfrom  lte 2 and periodto gte 2 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='02' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump2 
				from artran as a 
				where a.fperiod='02' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as c on a.van=c.van 
            </cfif>
			<!--- Period 03 --->
            <cfif periodfrom  lte 3 and periodto gte 3 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='03' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump3 
				from artran as a 
				where a.fperiod='03' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as d on a.van=d.van 
            </cfif>
			<!--- Period 04 --->
            <cfif periodfrom  lte 4 and periodto gte 4 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='04' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump4 
				from artran as a 
				where a.fperiod='04' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as e on a.van=e.van 
            </cfif>
			<!--- Period 05 --->
            <cfif periodfrom  lte 5 and periodto gte 5 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='05' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump5 
				from artran as a 
				where a.fperiod='05' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as f on a.van=f.van
            </cfif>
			<!--- Period 06 --->
            <cfif periodfrom  lte 6 and periodto gte 6 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='06' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump6 
				from artran as a 
				where a.fperiod='06' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as g on a.van=g.van
            </cfif>
			<!--- Period 07 --->
            <cfif periodfrom  lte 7 and periodto gte 7 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='07' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump7 
				from artran as a 
				where a.fperiod='07' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as h on a.van=h.van 
            </cfif>
			<!--- Period 08 --->
            <cfif periodfrom  lte 8 and periodto gte 8 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='08' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump8 
				from artran as a 
				where a.fperiod='08' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as i on a.van=i.van 
            </cfif>
			<!--- Period 09 --->
            <cfif periodfrom  lte 9 and periodto gte 9 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='09' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump9 
				from artran as a 
				where a.fperiod='09' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as j on a.van=j.van 
            </cfif>
			<!--- Period 10 --->
            <cfif periodfrom  lte 10 and periodto gte 10 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='10' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump10 
				from artran as a 
				where a.fperiod='10' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as k on a.van=k.van 
            </cfif>
			<!--- Period 11 --->
            <cfif periodfrom  lte 11 and periodto gte 11 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='11' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump11 
				from artran as a 
				where a.fperiod='11' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as l on a.van=l.van
            </cfif>
			<!--- Period 12 --->
            <cfif periodfrom  lte 12 and periodto gte 12 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='12' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump12 
				from artran as a 
				where a.fperiod='12' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as m on a.van=m.van
            </cfif>
			<!--- Period 13 --->
            <cfif periodfrom  lte 13 and periodto gte 13 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='13' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump13 
				from artran as a 
				where a.fperiod='13' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as n on a.van=n.van 
            </cfif>
			<!--- Period 14 --->
            <cfif periodfrom  lte 14 and periodto gte 14 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='14' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump14 
				from artran as a 
				where a.fperiod='14' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as o on a.van=o.van 
            </cfif>
			<!--- Period 15 --->
            <cfif periodfrom  lte 15 and periodto gte 15 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='15' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump15 
				from artran as a 
				where a.fperiod='15' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as p on a.van=p.van 
            </cfif>
			<!--- Period 16 --->
            <cfif periodfrom  lte 16 and periodto gte 16 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='16' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump16 
				from artran as a 
				where a.fperiod='16' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as q on a.van=q.van 
            </cfif>
			<!--- Period 17 --->
            <cfif periodfrom  lte 17 and periodto gte 17 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='17' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump17 
				from artran as a 
				where a.fperiod='17' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as r on a.van=r.van
            </cfif>
			<!--- Period 18 --->
            <cfif periodfrom  lte 18 and periodto gte 18 >
			left join 
			(
				select a.van,(ifnull((select sum(net) from artran where van=a.van and fperiod='18' and (void = '' or void is null) and wos_date > #arguments.lastaccyear# and type in ('INV','CS','DN') #critirial1# group by van),0)) as sump18
				from artran as a 
				where a.fperiod='18' and (a.void = '' or a.void is null) and a.wos_date > #arguments.lastaccyear#  and a.type in ('INV','CS','DN') #critirial11# 
				group by a.van order by a.van
			) as s on a.van=s.van
            </cfif>
			
			where a.van=a.van #critirial11#
			group by a.van order by a.van
		</cfquery>
		<cfreturn getuser>
	</cffunction>
</cfcomponent>	