<cfcomponent>
	<cffunction name="getCurrentPeriod" returntype="string">
		<cfargument name="dts" required="yes">
		<cfargument name="inputDate" required="yes" default="#now()#">
		<cfargument name="inputDate2" required="yes" default="#now()#">
		<cfargument name="inputPeriod" required="yes" default="18">
				
		<cfset lastaccyear = lsdateformat(inputDate2, 'mm/dd/yyyy')>
		<cfset period = inputPeriod>
		<cfset currentdate = lsdateformat(inputDate,'mm/dd/yyyy')>
		
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