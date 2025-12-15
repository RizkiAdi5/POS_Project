<cfcomponent>
	<cffunction name="getIncreament" returntype="string">
		<cfargument name="input" required="yes">
		<cfargument name="inc_value" required="no" default="1">
		
		<cfif not isnumeric(input)>
			<cfinvoke method="leftString" returnvariable="nextno" argumentcollection="#arguments#"/>
		<cfelse>
			<cfinvoke method="positiveInteger" returnvariable="nextno" argumentcollection="#arguments#"/>
		</cfif>
 		<cfreturn nextno>
	</cffunction>
	
	<cffunction name="leftString" returntype="string">
		<cfargument name="input" required="yes">
		<cfargument name="inc_value" required="no" default="1">

		<cfset cnt = 0>
		<cfset yes = 0>
		<cfset refnocnt = len(input)>
		
		<cfloop condition = "cnt lte refnocnt and yes eq 0">
			<cfset cnt = cnt + 1>
			
			<cfif isnumeric(mid(input,cnt,1)) and mid(input,cnt,1) eq '-' >
				<cfset yes = 1>			
			</cfif>
		</cfloop>
		
		<cfset temp = left(input,cnt-1)>
		<cfset temp2 = RemoveChars(input,1,cnt-1)>
		
		<cfinvoke method="positiveInteger" returnvariable="temp2" input="#temp2#"/>
		
		<cfset nextno = temp&temp2>
		
		<cfreturn nextno>
	</cffunction>
	
	<cffunction name="positiveInteger" returntype="string">
		<cfargument name="input" required="yes">
		<cfargument name="inc_value" required="no" default="1">
		
		<cfset refnocnt = len(input)>
		<cfset nextno = input+inc_value>
		
		<cfif (refnocnt - len(nextno)) neq 0>
			<cfset cnt = (refnocnt - len(nextno))>
			
			<cfloop from="1" to="#cnt#" index="i">
				<cfset nextno = "0" & nextno>
			</cfloop>
		</cfif>
		
		<cfreturn nextno>
	</cffunction>
</cfcomponent>