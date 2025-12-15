<cfcomponent>
	<cffunction name="getCurrentPeriod" returntype="string">
		<cfargument name="dts" required="yes">
		<cfargument name="inputDate" required="yes" default="#now()#">
        
		<cfquery name="get_gsetup" datasource="#dts#">
			select lastaccyear,period from gsetup
		</cfquery>
		
		<cfset lastaccyear = dateformat(get_gsetup.lastaccyear, 'YYYY-MM-DD')>
		<cfset period = get_gsetup.period>
		<cfset currentdate = dateformat(inputDate,'YYYY-MM-DD')>
		
		<cfset tmpYear = year(currentdate)>
		<cfset clsyear = year(lastaccyear)>

		<cfset tmpmonth = month(currentdate)>
		<cfset clsmonth = month(lastaccyear)>

		<cfset intperiod = (tmpyear-clsyear)*12+tmpmonth-clsmonth>

		<cfif intperiod gt 18 or intperiod lte 0>
			<cfset readperiod=99>
		<cfelse>
			<cfset readperiod = numberformat(intperiod,"00")>
		</cfif>
		
 		<cfreturn readperiod>
	</cffunction>
</cfcomponent>	