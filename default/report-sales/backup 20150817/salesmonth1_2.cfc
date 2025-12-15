<cfcomponent>
	<cffunction name = "getmonthitem">
		<cfargument name = "dts" 			required = "yes" type = "any">
		<cfargument name = "lastaccyear"	required = "yes" type = "any">
		<cfargument name = "form" 			required = "yes" type = "struct">
		
		<cfparam name="form.include" default="">
		<cfparam name="form.include0" default="">

		<cfswitch expression="#form.label#">
			<cfcase value="salesqty">
				<cfset msg1 = "qty">
			</cfcase>
			<cfcase value="salesqtyvalue">
				<cfset msg1 = "qty">
				<cfset msg2 = "amt">
			</cfcase>
			<cfdefaultcase>
				<cfset msg1 = "amt">
			</cfdefaultcase>
		</cfswitch>
		
		<cfswitch expression="#form.include#">
			<cfcase value="yes">
				<cfset msg3 = '(type="INV" or type="CS" or type="DN")'>
				<cfset msg4 = '(type="CN")'>
				<cfset msg5 = 'and (type="INV" or type="CS" or type="DN" or type="CN")'>
			</cfcase>
			<cfdefaultcase>
				<cfset msg3 = '(type="INV" or type="CS")'>
				<cfset msg4 = '(type="")'>
				<cfset msg5 = 'and (type="INV" or type="CS")'>
			</cfdefaultcase>
		</cfswitch>
		
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			<cfset critirial1 = 'and a.itemno between "#PreserveSingleQuotes(form.itemfrom)#" and "#PreserveSingleQuotes(form.itemto)#"'>
		<cfelse>
			<cfset critirial1 = "">
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			<cfset critirial2 = 'and a.category between "#form.catefrom#" and "#form.cateto#"'>
		<cfelse>
			<cfset critirial2 = "">
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
			<cfset critirial3 = 'and a.wos_group between "#form.groupfrom#" and "#form.groupto#"'>
		<cfelse>
			<cfset critirial3 = "">
		</cfif>
		<cfif form.periodfrom neq "" and form.periodto neq "">
			<cfset critirial4 = 'and a.fperiod+0 between #val(form.periodfrom)# and #val(form.periodto)#'>
		<cfelse>
			<cfset critirial4 = "">
		</cfif>
		<cfif trim(form.agentfrom) neq "" and trim(form.agentto) neq "">
			<cfset critirial5 = 'and a.agenno between "#form.agentfrom#" and "#form.agentto#"'>
		<cfelse>
			<cfset critirial5 = "">
		</cfif>
		<cfif trim(form.areafrom) neq "" and trim(form.areato) neq "">
			<cfset critirial6 = 'and a.area between "#form.areafrom#" and "#form.areato#"'>
		<cfelse>
			<cfset critirial6 = "">
		</cfif>
		
		<cfquery name="getitem" datasource="#arguments.dts#">
			select a.itemno,b.fperiod,a.desp,a.unit,(ifnull(b.sum1,0)-ifnull(b.sum2,0)) as sump
			<cfif form.label eq "salesqtyvalue">
				,(ifnull(b.sum11,0)-ifnull(b.sum22,0)) as sump2
			</cfif>

			from icitem a
	
			left join(
				select sum(if(#msg3#,#msg1#,0)) as sum1,sum(if(#msg4#,#msg1#,0)) as sum2,
				<cfif form.label eq "salesqtyvalue">
					sum(if(#msg3#,#msg2#,0)) as sum11,sum(if(#msg4#,#msg2#,0)) as sum22,
				</cfif>
				a.itemno,a.fperiod 
				from ictran a
				where (a.void = '' or a.void is null) and (linecode='' or linecode is null) and a.wos_date > #arguments.lastaccyear#
				#msg5# #critirial1# #critirial2# #critirial3# #critirial4# #critirial5# #critirial6# 
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and a.agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				group by a.itemno,a.fperiod
				)as b on a.itemno=b.itemno
	
			where 
			<cfif form.include0 eq "yes">
				0=0
			<cfelse>
				b.fperiod is not null
			</cfif>
			#critirial1# #critirial2# #critirial3#
			group by a.itemno,b.fperiod
			order by a.itemno,b.fperiod
		</cfquery>
		<cfreturn getitem>
	</cffunction>
</cfcomponent>