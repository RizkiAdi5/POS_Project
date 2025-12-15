	<cfquery name="getLastBillno" datasource="#dts#">
		select lastUsedNo as bNum,refnocode,refnocode2,presuffixuse
		from refnoset
        where type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
        and counter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#count#">
	</cfquery>

	<cfif getLastBillno.bNum eq "">
		<cfset lastNum="EMPTY">
		<cfset actualno="">
	<cfelse>
		<cftry>
		<cfif lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "chemline_i">
			<cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastBillno.bNum#" returnvariable="cfc_nextno" />
			<cfset actualno=cfc_nextno>
		<cfelse>
			<cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastBillno.bNum#" returnvariable="newnextNum" />
        	<cfset actual_nexttranno = newnextNum>
            <cfif (getlastBillno.refnocode2 neq "" or getlastBillno.refnocode neq "") and getlastBillno.presuffixuse eq "1">
				<cfset cfc_nextno = getlastBillno.refnocode&actual_nexttranno&getlastBillno.refnocode2>
            <cfelse>
            	<cfset cfc_nextno = actual_nexttranno>
			</cfif>
			<cfset actualno=actual_nexttranno>
		</cfif>
		<cfset lastNum=cfc_nextno>
		<cfcatch type="any">
			<cftry>
				<cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastBillno.bNum#" returnvariable="cfc_nextno" />
				<cfset lastNum=cfc_nextno>
				<cfset actualno=cfc_nextno>
			<cfcatch type="any">
				<cfset lastNum="ERROR">
				<cflog file="ajax_copyf" text="Error msg : #cfcatch.message# (#HcomID#-#HUserID#)">
			</cfcatch>
			</cftry>
		</cfcatch>
		</cftry>
	</cfif>


<cfoutput>
	<input type="text" name="ft_refnofrom" id="ft_refnofrom" value="#lastNum#"><input id="ft_actualrefno" type="hidden" name="ft_actualrefno" value="#actualno#">
</cfoutput>