<cfcomponent>
	<cffunction name="getDbDate" returntype="string">
		<cfargument name="inputDate" required="yes">
		
		<cfset dd = dateformat(inputDate, 'DD')>

		<cfif dd greater than '12'>
			<cfset date = dateformat(inputDate,"YYYYMMDD")>
		<cfelse>
			<cfset date = dateformat(inputDate,"YYYYDDMM")>
		</cfif>
		
 		<cfreturn date>
	</cffunction>
	
	<cffunction name="getDbDate2" returntype="string">
		<cfargument name="inputDate" required="yes">
		
		<cfset dd = dateformat(inputDate, 'DD')>

		<cfif dd greater than '12'>
			<cfset date = dateformat(inputDate,"YYYY-MM-DD")>
		<cfelse>
			<cfset date = dateformat(inputDate,"YYYY-DD-MM")>
		</cfif>
		
 		<cfreturn date>
	</cffunction>
	
	<cffunction name="getAppDateByPeriod" output="true" returntype="string">
		<cfargument name="inputPeriod" required="yes">
		<cfargument name="dts" required="yes">
		
		<cfquery name="getgeneral" datasource="#dts#">
			select lastaccyear from gsetup
		</cfquery>
		
		<cfset clsyear=year(getgeneral.lastaccyear)>	
		<cfset clsmonth=month(getgeneral.lastaccyear)>

		<cfset newmonth=clsmonth+inputPeriod>	
		
		<cfif newmonth gt 12 and inputPeriod lte 12>
			<cfset newmonth=newmonth-12>
			<cfset newyear=clsyear+1>
		<cfelseif newmonth gt 24>
			<cfset newmonth=newmonth-24>
			<cfset newyear=clsyear+2>
		<cfelseif newmonth gt 12>
			<cfset newmonth=newmonth-12>
			<cfset newyear=clsyear+1>
		<cfelse>
			<cfset newyear=clsyear>
		</cfif>
		<cfset newdate = CreateDate(newyear, newmonth, newmonth)>
		<cfreturn newdate>
	</cffunction>

	<cffunction name="getFormatedDate" returntype="string">
		<cfargument name="inputDate" required="yes">

		<cfif inputDate neq "">
			<cfset date = dateformat(inputDate,"yyyy-mm-dd")>
		<cfelse>
			<cfset date ="0000-00-00">
		</cfif>
		
 		<cfreturn date>
	</cffunction>
    
    <cffunction name="getFormatedDateTime" returntype="string">
		<cfargument name="inputDate" required="yes">

		<cfif inputDate neq "">
			<cfset date = dateformat(inputDate,"yyyy-mm-dd hh:mm:ss")>
		<cfelse>
			<cfset date ="0000-00-00 00:00:00">
		</cfif>
		
 		<cfreturn date>
	</cffunction>
</cfcomponent>	