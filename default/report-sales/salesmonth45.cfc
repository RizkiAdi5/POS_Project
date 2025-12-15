<cfcomponent>
	<cffunction name="getmonthgroup">
		<cfargument name="dts" required="yes">
		<cfargument name="lastaccyear" required="yes">
		<cfargument name="label" required="yes">
		<cfargument name="catefrom" required="yes">
		<cfargument name="cateto" required="yes">
		<cfargument name="groupfrom" required="yes">
		<cfargument name="groupto" required="yes">
		<cfargument name="itemfrom" required="yes">
		<cfargument name="itemto" required="yes">
		<cfargument name="agentfrom" required="yes">
		<cfargument name="agentto" required="yes">
		<cfargument name="areafrom" required="yes">
		<cfargument name="areato" required="yes">
		<cfargument name="include" required="yes">
        <cfargument name="periodfrom" required="yes">
		<cfargument name="periodto" required="yes">
		
		<cfswitch expression="#arguments.label#">
			<cfcase value="salesvalue">
				<cfset arg = "amt">
			</cfcase>
			<cfdefaultcase>
				<cfset arg = "qty">
			</cfdefaultcase>
		</cfswitch>
		
		<cfswitch expression="#arguments.include#">
			<cfcase value="yes">
				<cfset msg1 = 'and ictran.type in ("INV","CS","DN")'>
				<cfset msg2 = 'and ictran.type="CN"'>
			</cfcase>
			<cfdefaultcase>
				<cfset msg1 = 'and ictran.type in ("INV","CS")'>
				<cfset msg2 = 'and ictran.type=""'>
			</cfdefaultcase>
		</cfswitch>		
		
		<cfif arguments.catefrom neq "" and arguments.cateto neq "">
			<cfset critirial1 = 'and icitem.category between "#arguments.catefrom#" and "#arguments.cateto#"'>
			<cfset critirial11 = 'and a.category between "#arguments.catefrom#" and "#arguments.cateto#"'>
		<cfelse>
			<cfset critirial1 = "">
			<cfset critirial11 = "">
		</cfif>
		<cfif arguments.groupfrom neq "" and arguments.groupto neq "">
			<cfset critirial2 = 'and icitem.wos_group between "#arguments.groupfrom#" and "#arguments.groupto#"'>
			<cfset critirial22 = 'and a.wos_group between "#arguments.groupfrom#" and "#arguments.groupto#"'>
		<cfelse>
			<cfset critirial2 = "">
			<cfset critirial22 = "">
		</cfif>
		<!--- REMARK ON 190908 --->
		<!--- <cfif arguments.itemfrom neq "" and arguments.itemto neq "">
			<cfset critirial3 = 'and icitem.itemno between "#arguments.itemfrom#" and "#arguments.itemto#"'>
			<cfset critirial33 = 'and a.itemno between "#arguments.itemfrom#" and "#arguments.itemto#"'>
		<cfelse>
			<cfset critirial3 = "">
			<cfset critirial33 = "">
		</cfif> --->
		<cfif arguments.agentfrom neq "" and arguments.agentto neq "">
			<cfset critirial4 = 'and ictran.agenno between "#arguments.agentfrom#" and "#arguments.agentto#"'>
		<cfelse>
			<cfset critirial4 = "">
		</cfif>
		<cfif arguments.areafrom neq "" and arguments.areato neq "">
			<cfset critirial5 = 'and ictran.area between "#arguments.areafrom#" and "#arguments.areato#"'>
		<cfelse>
			<cfset critirial5 = "">
		</cfif>
		
		<cfquery name="getgroup" datasource="#arguments.dts#">
			select a.wos_group,(select desp from icgroup where wos_group=a.wos_group) as desp
			<cfif periodfrom  lte 1 and periodto gte 1 >,ifnull(b.sump1,0) as sump1</cfif><cfif periodfrom  lte 2 and periodto gte 2 >,ifnull(c.sump2,0) as sump2</cfif><cfif periodfrom  lte 3 and periodto gte 3 >,ifnull(d.sump3,0) as sump3</cfif><cfif periodfrom  lte 4 and periodto gte 4 >,ifnull(e.sump4,0) as sump4</cfif><cfif periodfrom  lte 5 and periodto gte 5 >,ifnull(f.sump5,0) as sump5</cfif><cfif periodfrom  lte 6 and periodto gte 6 >,ifnull(g.sump6,0) as sump6</cfif><cfif periodfrom  lte 7 and periodto gte 7 >,
			ifnull(h.sump7,0) as sump7</cfif><cfif periodfrom  lte 8 and periodto gte 8 >,ifnull(i.sump8,0) as sump8</cfif><cfif periodfrom  lte 9 and periodto gte 9 >,ifnull(j.sump9,0) as sump9</cfif><cfif periodfrom  lte 10 and periodto gte 10 >,ifnull(k.sump10,0) as sump10</cfif><cfif periodfrom  lte 11 and periodto gte 11 >,ifnull(l.sump11,0) as sump11</cfif><cfif periodfrom  lte 12 and periodto gte 12 >,ifnull(m.sump12,0) as sump12</cfif><cfif periodfrom  lte 13 and periodto gte 13 >,
			 ifnull(n.sump13,0) as sump13</cfif><cfif periodfrom  lte 14 and periodto gte 14 >,ifnull(o.sump14,0) as sump14</cfif><cfif periodfrom  lte 15 and periodto gte 15 >,ifnull(p.sump15,0) as sump15</cfif><cfif periodfrom  lte 16 and periodto gte 16 >,ifnull(q.sump16,0) as sump16</cfif><cfif periodfrom  lte 17 and periodto gte 17 >,ifnull(r.sump17,0) as sump17</cfif><cfif periodfrom  lte 18 and periodto gte 18 >,ifnull(s.sump18,0) as sump18</cfif>, 
			(0<cfif periodfrom  lte 1 and periodto gte 1 >+ifnull(b.sump1,0)</cfif><cfif periodfrom  lte 2 and periodto gte 2 >+ifnull(c.sump2,0)</cfif><cfif periodfrom  lte 3 and periodto gte 3 >+ifnull(d.sump3,0)</cfif><cfif periodfrom  lte 4 and periodto gte 4 >+ifnull(e.sump4,0)</cfif><cfif periodfrom  lte 5 and periodto gte 5 >+ifnull(f.sump5,0)</cfif><cfif periodfrom  lte 6 and periodto gte 6 >+ifnull(g.sump6,0)</cfif><cfif periodfrom  lte 7 and periodto gte 7 >+
			ifnull(h.sump7,0)</cfif><cfif periodfrom  lte 8 and periodto gte 8 >+ifnull(i.sump8,0)</cfif><cfif periodfrom  lte 9 and periodto gte 9 >+ifnull(j.sump9,0)</cfif><cfif periodfrom  lte 10 and periodto gte 10 >+ifnull(k.sump10,0)</cfif><cfif periodfrom  lte 11 and periodto gte 11 >+ifnull(l.sump11,0)</cfif><cfif periodfrom  lte 12 and periodto gte 12 >+ifnull(m.sump12,0)</cfif><cfif periodfrom  lte 13 and periodto gte 13 >+
			ifnull(n.sump13,0)</cfif><cfif periodfrom  lte 14 and periodto gte 14 >+ifnull(o.sump14,0)</cfif><cfif periodfrom  lte 15 and periodto gte 15 >+ifnull(p.sump15,0)</cfif><cfif periodfrom  lte 16 and periodto gte 16 >+ifnull(q.sump16,0)</cfif><cfif periodfrom  lte 17 and periodto gte 17 >+ifnull(r.sump17,0)</cfif><cfif periodfrom  lte 18 and periodto gte 18 >+ifnull(s.sump18,0)</cfif>) as total 
			from icitem as a 
			<!--- Period 01 --->
            <cfif periodfrom  lte 1 and periodto gte 1 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='01' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='01' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump1 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as b on a.wos_group=b.wos_group 
            </cfif>
			<!--- Period 02 --->
            <cfif periodfrom  lte 2 and periodto gte 2 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='02' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='02' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump2 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as c on a.wos_group=c.wos_group 
            </cfif>
			<!--- Period 03 --->
            <cfif periodfrom  lte 3 and periodto gte 3 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='03' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='03' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump3 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as d on a.wos_group=d.wos_group 
            </cfif>
			<!--- Period 04 --->
            <cfif periodfrom  lte 4 and periodto gte 4 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='04' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='04' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump4 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as e on a.wos_group=e.wos_group 
            </cfif>
			<!--- Period 05 --->
            <cfif periodfrom  lte 5 and periodto gte 5 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='05' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='05' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump5 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as f on a.wos_group=f.wos_group
            </cfif>
			<!--- Period 06 --->
            <cfif periodfrom  lte 6 and periodto gte 6 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='06' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='06' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump6 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as g on a.wos_group=g.wos_group
            </cfif>
			<!--- Period 07 --->
            <cfif periodfrom  lte 7 and periodto gte 7 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='07' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='07' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump7 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as h on a.wos_group=h.wos_group 
            </cfif>
			<!--- Period 08 --->
            <cfif periodfrom  lte 8 and periodto gte 8 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='08' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='08' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump8 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as i on a.wos_group=i.wos_group 
            </cfif>
			<!--- Period 09 --->
            <cfif periodfrom  lte 9 and periodto gte 9 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='09' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='09' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump9 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as j on a.wos_group=j.wos_group 
            </cfif>
			<!--- Period 10 --->
            <cfif periodfrom  lte 10 and periodto gte 10 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='10' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='10' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump10 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as k on a.wos_group=k.wos_group 
            </cfif>
			<!--- Period 11 --->
            <cfif periodfrom  lte 11 and periodto gte 11 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='11' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='11' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump11 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as l on a.wos_group=l.wos_group
            </cfif>
			<!--- Period 12 --->
            <cfif periodfrom  lte 12 and periodto gte 12 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='12' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='12' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump12 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as m on a.wos_group=m.wos_group
            </cfif>
			<!--- Period 13 --->
            <cfif periodfrom  lte 13 and periodto gte 13 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='13' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='13' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump13 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as n on a.wos_group=n.wos_group 
            </cfif>
			<!--- Period 14 --->
            <cfif periodfrom  lte 14 and periodto gte 14 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='14' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='14' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump14 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as o on a.wos_group=o.wos_group 
            </cfif>
			<!--- Period 15 --->
            <cfif periodfrom  lte 15 and periodto gte 15 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='15' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='15' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump15 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as p on a.wos_group=p.wos_group 
            </cfif>
			<!--- Period 16 --->
            <cfif periodfrom  lte 16 and periodto gte 16 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='16' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='16' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump16 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as q on a.wos_group=q.wos_group 
            </cfif>
			<!--- Period 17 --->
            <cfif periodfrom  lte 17 and periodto gte 17 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='17' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='17' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump17 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as r on a.wos_group=r.wos_group
            </cfif>
			<!--- Period 18 --->
            <cfif periodfrom  lte 18 and periodto gte 18 >
			left join 
			(
				select a.wos_group,ifnull((
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='18' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg1# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0) - 
				ifnull((select sum(ictran.#arg#) from ictran,icitem where ictran.fperiod='18' and ictran.itemno=icitem.itemno and icitem.wos_group=a.wos_group #msg2# #critirial1# #critirial2# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and icitem.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				#critirial4# #critirial5# group by icitem.wos_group),0)
				),0) as sump18 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as s on a.wos_group=s.wos_group 
            </cfif>
			
			where a.wos_group=a.wos_group #critirial11# #critirial22#
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by a.wos_group order by a.wos_group
		</cfquery>
		<cfreturn getgroup>
	</cffunction>
</cfcomponent>	