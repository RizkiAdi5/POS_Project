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
			select a.wos_group,(select desp from icgroup where wos_group=a.wos_group) as desp,
			ifnull(b.sump1,0) as sump1,ifnull(c.sump2,0) as sump2,ifnull(d.sump3,0) as sump3,ifnull(e.sump4,0) as sump4,ifnull(f.sump5,0) as sump5,ifnull(g.sump6,0) as sump6,
			(ifnull(b.sump1,0)+ifnull(c.sump2,0)+ifnull(d.sump3,0)+ifnull(e.sump4,0)+ifnull(f.sump5,0)+ifnull(g.sump6,0)) as total 
			from icitem as a 
			<!--- Period 13 --->
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
				),0) as sump1 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as b on a.wos_group=b.wos_group 
			<!--- Period 14--->
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
				),0) as sump2 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as c on a.wos_group=c.wos_group 
			<!--- Period 15 --->
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
				),0) as sump3 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as d on a.wos_group=d.wos_group 
			<!--- Period 16 --->
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
				),0) as sump4 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as e on a.wos_group=e.wos_group 
			<!--- Period 17 --->
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
				),0) as sump5 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as f on a.wos_group=f.wos_group
			<!--- Period 18 --->
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
				),0) as sump6 
				from (select a.wos_group from icitem as a where a.wos_group=a.wos_group #critirial11# #critirial22# 
				<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
					and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
				</cfif>
				group by a.wos_group order by a.wos_group) as a 
			) as g on a.wos_group=g.wos_group
			
			where a.wos_group=a.wos_group #critirial11# #critirial22#
			<cfif arguments.itemfrom neq "" and arguments.itemto neq "">
				and a.itemno between '#arguments.itemfrom#' and '#arguments.itemto#' 
			</cfif>
			group by a.wos_group order by a.wos_group
		</cfquery>
		<cfreturn getgroup>
	</cffunction>
</cfcomponent>	