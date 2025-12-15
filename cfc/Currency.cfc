<cfcomponent>
	<cffunction name="getRateByPeriod" returntype="numeric">
		<cfargument name="dts" required="yes">
		<cfargument name="inputPeriod" required="yes">
		<cfargument name="inputCurrCode" required="no" default="SGD">
		<cfargument name="target_currency" required="yes">
		
		<cfquery name="currency" datasource="#dts#">
			select * 
			from #arguments.target_currency# 
			where currCode='#inputCurrCode#'
		</cfquery>

		<cfif inputPeriod eq 01>
			<cfset rates2 = currency.CurrP1>
		</cfif>
		<cfif inputPeriod eq 02>
			<cfset rates2 = currency.CurrP2>
		</cfif>
		<cfif inputPeriod eq 03>
			<cfset rates2 = currency.CurrP3>
		</cfif>
		<cfif inputPeriod eq 04>
			<cfset rates2 = currency.CurrP4>
		</cfif>
		<cfif inputPeriod eq 05>
			<cfset rates2 = currency.CurrP5>
		</cfif>
		<cfif inputPeriod eq 06>
			<cfset rates2 = currency.CurrP6>
		</cfif>
		<cfif inputPeriod eq 07>
			<cfset rates2 = currency.CurrP7>
		</cfif>
		<cfif inputPeriod eq 08>
			<cfset rates2 = currency.CurrP8>
		</cfif>
		<cfif inputPeriod eq 09>
			<cfset rates2 = currency.CurrP9>
		</cfif>
		<cfif inputPeriod eq 10>
			<cfset rates2 = currency.CurrP10>
		</cfif>
		<cfif inputPeriod eq 11>
			<cfset rates2 = currency.CurrP11>
		</cfif>
		<cfif inputPeriod eq 12>
			<cfset rates2 = currency.CurrP12>
		</cfif>
		<cfif inputPeriod eq 13>
			<cfset rates2 = currency.CurrP13>
		</cfif>
		<cfif inputPeriod eq 14>
			<cfset rates2 = currency.CurrP14>
		</cfif>
		<cfif inputPeriod eq 15>
			<cfset rates2 = currency.CurrP15>
		</cfif>
		<cfif inputPeriod eq 16>
			<cfset rates2 = currency.CurrP16>
		</cfif>
		<cfif inputPeriod eq 17>
			<cfset rates2 = currency.CurrP17>
		</cfif>
		<cfif inputPeriod eq 18>
			<cfset rates2 = currency.CurrP18>
		</cfif>
		
		<cfreturn rates2>
	</cffunction>
</cfcomponent>