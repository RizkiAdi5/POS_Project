<cfcomponent>
	<cffunction name = "get_group">
		<cfargument name = "dts" 			required = "yes" type = "any">
		<cfargument name = "lastaccyear"	required = "yes" type = "any">
		<cfargument name = "form" 			required = "yes" type = "struct">
		<cfargument name = "location"		required = "yes" type = "any">
		
		<cfif form.datefrom neq "" and form.dateto neq "">
			<cfset date1 = createDate(ListGetAt(form.datefrom,3,"/"),ListGetAt(form.datefrom,2,"/"),ListGetAt(form.datefrom,1,"/"))>
			<cfset date2 = createDate(ListGetAt(form.dateto,3,"/"),ListGetAt(form.dateto,2,"/"),ListGetAt(form.dateto,1,"/"))>
		</cfif>
		
		<cfquery name="getgroup" datasource="#dts#">
        select '' as wos_group,'' as group_desp
        union all
        select wos_group,desp as group_desp from icgroup
        <!---
			select 
			a.wos_group,
			b.group_desp 
			from  
			(
				select wos_group from ictran
				where (void = '' or void is null)
				and fperiod <> '99'
				<cfif trim(arguments.location) neq "ZZZZZZZZZZ">
					and location = '#arguments.location#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between #date1# and #date2#
				<cfelse>
					and wos_date > #arguments.lastaccyear#
				</cfif>
				<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
					and custno between '#form.suppfrom#' and '#form.suppto#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.locationfrom neq "" and form.locationto neq "">
					and location between '#form.locationfrom#' and '#form.locationto#'
				</cfif>
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				<cfif trim(form.Catefrom) neq "" and trim(form.Cateto) neq "">
					and category between '#form.Catefrom#' and '#form.Cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
					and wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
				group by wos_group
				
				union
				
				select b.wos_group from locqdbf a,icitem b
				where a.itemno=b.itemno
				
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and b.itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				<cfif trim(form.Catefrom) neq "" and trim(form.Cateto) neq "">
					and b.category between '#form.Catefrom#' and '#form.Cateto#'
				</cfif>
				<cfif form.groupfrom neq "" and form.groupto neq "">
					and b.wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
				<cfif form.locationfrom neq "" and form.locationto neq "">
					and a.location between '#form.locationfrom#' and '#form.locationto#'
				</cfif>
				<cfif trim(arguments.location) neq "ZZZZZZZZZZ">
					and a.location = '#arguments.location#'
				</cfif>
				group by b.wos_group
			)as a 
			
			left join 
			(
				select 
				wos_group,
				desp as group_desp 
				from icgroup 
				<cfif form.groupfrom neq "" and form.groupto neq "">
					where wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
				order by wos_group
			) as b on a.wos_group=b.wos_group
			
			order by a.wos_group--->
		</cfquery>
		
		<cfreturn getgroup>
	</cffunction>
	
	<cffunction name = "get_location">
		<cfargument name = "dts" 			required = "yes" type = "any">
		<cfargument name = "lastaccyear"	required = "yes" type = "any">
		<cfargument name = "form" 			required = "yes" type = "struct">
		
		<cfif form.datefrom neq "" and form.dateto neq "">
			<cfset date1 = createDate(ListGetAt(form.datefrom,3,"/"),ListGetAt(form.datefrom,2,"/"),ListGetAt(form.datefrom,1,"/"))>
			<cfset date2 = createDate(ListGetAt(form.dateto,3,"/"),ListGetAt(form.dateto,2,"/"),ListGetAt(form.dateto,1,"/"))>
		</cfif>
		
		<cfquery name="getlocation" datasource="#dts#">
			select 
			a.location,
			b.location_desp 
			from 
 			(
				select location from ictran
				where (void = '' or void is null)
				and fperiod <> '99'
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between #date1# and #date2#
				<cfelse>
					and wos_date > #arguments.lastaccyear#
				</cfif>
				<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
					and custno between '#form.suppfrom#' and '#form.suppto#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.locationfrom neq "" and form.locationto neq "">
					and location between '#form.locationfrom#' and '#form.locationto#'
				</cfif>
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between '#form.productfrom#' and '#form.productto#'
				</cfif>
				<cfif trim(form.Catefrom) neq "" and trim(form.Cateto) neq "">
					and category between '#form.Catefrom#' and '#form.Cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
					and wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
				group by location
				
				union
				
				select location from locqdbf
				group by location
			)as a 
			
			left join 
			(
				select 
				location,
				desp as location_desp 
				from iclocation 
				<cfif form.locationfrom neq "" and form.locationto neq "">
					where location between '#form.locationfrom#' and '#form.locationto#'
				</cfif>
				
				order by location
			) as b on a.location=b.location
            <cfif form.locationfrom neq "" and form.locationto neq "">
				where a.location between '#form.locationfrom#' and '#form.locationto#'
               </cfif>
               order by a.location
		</cfquery>
		<cfreturn getlocation>
	</cffunction>
</cfcomponent>