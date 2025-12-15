<cfinclude template="../core/cfajax.cfm">

<cffunction name="lastNumlookup">
	<cfargument name="type" required="yes" type="string">
	<cfargument name="counter" required="yes" type="string">
	<cfset object = CreateObject("Component","cfobject")>
	<!---cfparam name="dbType" type="string" default="null">
	
	<cfif Find("invno",arguments.type) eq 0>
		<cfset dbType="#LCase(arguments.type)#no">
	<cfelse>
		<cfset dbType=arguments.type>
	</cfif>
	
	<cfquery name="getLastBillno" datasource="#dts#">
		select #dbType# as bNum
		from gsetup;
	</cfquery--->
	
	 <!--- <cfquery name="getLastBillno" datasource="main">
		select lastUsedNo as bNum
		from refnoset
        where userDept = '#dts#'
        and type = '#arguments.type#'
        and counter = '#arguments.counter#'
	</cfquery> --->
	
	<cfquery name="getLastBillno" datasource="#dts#">
		select lastUsedNo as bNum,refnocode,refnocode2,presuffixuse
		from refnoset
        where type = '#arguments.type#'
        and counter = '#arguments.counter#'
	</cfquery>
	
	<cfif getLastBillno.bNum eq "">
		<cfset object.lastNum="EMPTY">
		<cfset object.actualno="">
	<cfelse>
		<cftry>
		<cfif lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "chemline_i">
			<cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastBillno.bNum#" returnvariable="cfc_nextno" />
			<cfset object.actualno=cfc_nextno>
		<cfelse>
			<!--- <cfinvoke component="cfc.incrementValue" method="getIncreament" returnvariable="cfc_nextno">
				<cfinvokeargument name="input" value="#getlastBillno.bNum#">
			</cfinvoke> --->
			<cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastBillno.bNum#" returnvariable="newnextNum" />
        	<cfset actual_nexttranno = newnextNum>
            <cfif (getlastBillno.refnocode2 neq "" or getlastBillno.refnocode neq "") and getlastBillno.presuffixuse eq "1">
				<cfset cfc_nextno = getlastBillno.refnocode&actual_nexttranno&getlastBillno.refnocode2>
            <cfelse>
            	<cfset cfc_nextno = actual_nexttranno>
			</cfif>
			<cfset object.actualno=actual_nexttranno>
		</cfif>
		<cfset object.lastNum=cfc_nextno>
		<cfcatch type="any">
			<cftry>
				<cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastBillno.bNum#" returnvariable="cfc_nextno" />
				<cfset object.lastNum=cfc_nextno>
				<cfset object.actualno=cfc_nextno>
			<cfcatch type="any">
				<cfset object.lastNum="ERROR">
				<cflog file="ajax_copyf" text="Error msg : #cfcatch.message# (#HcomID#-#HUserID#)">
			</cfcatch>
			</cftry>
			<!--- <cfset object.lastNum="ERROR">
			<cflog file="ajax_copyf" text="Error msg : #cfcatch.message# (#HcomID#-#HUserID#)"> --->
		</cfcatch>
		</cftry>
	</cfif>

	<cfreturn object>
</cffunction>

<cffunction name="refnolookup" hint="type='keyvalue' jsreturn='array'">
	<cfargument name="inputRefno" required="yes" type="string">
	<cfargument name="inputInvno" required="yes" type="string">
	<cfargument name="inputStatus" required="yes" type="string">
	
	<cfif arguments.inputRefno neq "INV">
		<cfif arguments.inputRefno neq "RC" and arguments.inputRefno neq "PR" and arguments.inputRefno neq "PO">
			<cfquery name="getRefno" datasource="#dts#">
			SELECT refno,concat(refno,' - ',a.custno,' - ',if((c.name='' or c.name is null),'',c.name)) as rtext 
			FROM artran a left join #target_arcust# c on a.custno=c.custno
			where a.type='#arguments.inputRefno#' order by refno
			</cfquery>
		<cfelse>
			<cfquery name="getRefno" datasource="#dts#">
			SELECT refno,concat(refno,' - ',a.custno,' - ',if((s.name='' or s.name is null),'',s.name)) as rtext 
			FROM artran a left join #target_apvend# s on a.custno=s.custno
			where a.type='#arguments.inputRefno#' order by refno
			</cfquery>
		</cfif>
	<cfelse>
		<!--- <cfif arguments.inputStatus neq 1>
			<cfquery name="getInvPrefix" datasource="#dts#">
				SELECT #arguments.inputInvno# as db FROM gsetup g;
			</cfquery>
	
			<cfquery name="getRefno" datasource="#dts#">
				SELECT refno,concat(refno,' - ',a.custno,' - ',if((c.name='' or c.name is null),'',c.name)) as rtext 
				FROM artran a left join #target_arcust# c on a.custno=c.custno 
				where type='#arguments.inputRefno#' and refno like '#left(getInvPrefix.db,3)#%' 
				order by refno
			</cfquery>
		<cfelse> --->
			<cfquery name="getRefno" datasource="#dts#">
			SELECT refno,concat(refno,' - ',a.custno,' - ',if((c.name='' or c.name is null),'',c.name)) as rtext 
			FROM artran a left join #target_arcust# c on a.custno=c.custno
			where a.type='#arguments.inputRefno#' <cfif dts eq "winbells_i">and fperiod <> "99"</cfif> order by refno
			</cfquery>
		<!--- </cfif> --->
	</cfif>
	
	<cfset model = ArrayNew(1)>
	<cfset ArrayAppend(model,"--,Please choose one")>
	
	<cfloop query="getRefno">
		<cfset ArrayAppend(model,"#refno#,#rtext#")>
	</cfloop>
	
	<cfreturn model>
</cffunction>

<cffunction name="customerlookup" hint="type='keyvalue' jsreturn='array'">
	<cfargument name="type" required="no" type="string">
	
	<cfif arguments.type eq "CUST">
		<cfquery name="getCust" datasource="#dts#">
		SELECT custno,concat(custno,' - ',if((name='' or name is null),'',name),' ',if((name2='' or name2 is null),'',name2)) as ctext
		FROM #target_arcust# order by custno
		</cfquery>
	<cfelseif arguments.type eq "SUPP">
		<cfquery name="getCust" datasource="#dts#">
		Select custno,concat(custno, ' - ', if((name='' or name is null),'',name),' ',if((name2='' or name2 is null),'',name2)) as ctext
		from #target_apvend# order by custno
		</cfquery>
	</cfif>

	<cfset model = ArrayNew(1)>
	<cfset ArrayAppend(model,"-,Please choose one")>
	
	<cfloop query="getCust">
		<cfset ArrayAppend(model,"#custno#,#ctext#")>
	</cfloop>
	
	<cfreturn model>
</cffunction>

<cffunction name="arunlookup">
	<cfargument name="type" required="yes" type="string">
	<!---cfargument name="oneInv" required="yes" type="string"--->
	<cfargument name="counter" required="yes" type="string">
	<cfset object = CreateObject("Component","cfobject")>
	<!---cfset dbType="">
	
	<cfif arguments.type eq "INV" and arguments.oneInv neq "1">
		<cfset dbType=replace(arguments.oneInv,"no","ARUN")>
	<cfelse>
		<cfset dbType="#LCase(arguments.type)#arun">
	</cfif>
	
	<cfquery name="getARunStatus" datasource="#dts#">
		select #dbType# as arun
		from gsetup;
	</cfquery--->
	
	<!--- <cfquery name="getARunStatus" datasource="main">
		select refnoused as arun
		from refnoset
        where userDept = '#dts#'
        and type = '#arguments.type#'
        and counter = '#arguments.counter#'
	</cfquery> --->
	
	<cfquery name="getARunStatus" datasource="#dts#">
		select refnoused as arun
		from refnoset
        where type = '#arguments.type#'
        and counter = '#arguments.counter#'
	</cfquery>
	
	<cfif getARunStatus.recordcount eq 0>
		<cfset object.arunStatus="EMPTY">
	<cfelse>
		<cfset object.arunStatus=getARunStatus.arun>
	</cfif>
	<cfset object.type=arguments.type>
	<!---cfset object.oneInv=arguments.oneInv--->
	<cfset object.counter=arguments.counter>
	<cfreturn object>
</cffunction>

<cffunction name="checkRefnolookup">
	<cfargument name="type" required="yes" type="string">
	<cfargument name="userInput" required="yes" type="string">
	<cfargument name="id" required="yes" type="string">
	<cfset object = CreateObject("Component","cfobject")>

	<cfquery name="checkArtran" datasource="#dts#">
		select type from artran where type='#arguments.type#' and refno='#arguments.userInput#' limit 1
	</cfquery>
	
	<cfif checkArtran.recordcount eq 0>
		<cfset object.exist="no">
	<cfelse>
		<cfset object.exist="yes">
	</cfif>
	<cfset object.id=arguments.id>
	<cfreturn object>
</cffunction>
<!--- FOR FLOPRINTS's job_status_maintenance.cfm --->
<cffunction name="floprints_so_refno" hint="type='keyvalue' jsreturn='array'">
	<cfargument name="input_value" required="no" type="string">
	
	<cfquery name="getresult" datasource="#dts#">
		select a.refno,a.info 
		from 
		(
			select refno,concat(refno,' - ',date_format(wos_date,'%d-%m-%Y')) as info 
			from artran 
			where type='SO' and custno='#jsstringformat(arguments.input_value)#' and order_cl='' 
			union 
			select '' as refno,(' - ') as info
		) as a 
		order by a.refno;
	</cfquery>
	
	<cfset result = arraynew(1)>
	<cfset result = listtoarray(valuelist(getresult.info,","),",")>
	
	<cfreturn result>
</cffunction>

<cffunction name="floprints_cleared_so_refno" hint="type='keyvalue' jsreturn='array'">
	<cfargument name="input_value" required="no" type="string">
	
	<cfquery name="getresult" datasource="#dts#">
		select a.refno,a.info 
		from 
		(
			select refno,concat(refno,' - ',date_format(wos_date,'%d-%m-%Y')) as info 
			from artran 
			where type='SO' and custno='#jsstringformat(arguments.input_value)#' and order_cl='Y' 
			union 
			select '' as refno,(' - ') as info
		) as a 
		order by a.refno;
	</cfquery>
	
	<cfset result = arraynew(1)>
	<cfset result = listtoarray(valuelist(getresult.info,","),",")>
	
	<cfreturn result>
</cffunction>
<!--- END FOR FLOPRINTS's job_status_maintenance.cfm --->

<cffunction name="refnosetlookup" hint="type='keyvalue' jsreturn='array'">
	<cfargument name="typeoneset" required="no" type="string">
    <cfargument name="type" required="no" type="string">
	
	<cfif arguments.typeoneset neq "1">
		<!--- <cfquery name="getrefnoset" datasource="main">
			SELECT counter,concat('Set ',counter,' - ',if((lastUsedNo='' or lastUsedNo is null),'',lastUsedNo)) as ctext
			FROM refnoset 
            WHERE type = '#arguments.type#'
            and userDept = '#dts#'
            and lastUsedNo !=''
            order by counter
		</cfquery> --->
		
		<cfquery name="getrefnoset" datasource="#dts#">
			SELECT counter,concat('Set ',counter,' - ',if((lastUsedNo='' or lastUsedNo is null),'',lastUsedNo)) as ctext
			FROM refnoset 
            WHERE type = '#arguments.type#'
            and lastUsedNo !=''
            order by counter
		</cfquery>
	</cfif>

	<cfset model = ArrayNew(1)>
    <!---cfset ArrayAppend(model,"-,Please choose one")--->
   
	<cfloop query="getrefnoset">
		<cfset ArrayAppend(model,"#counter#,#ctext#")>
	</cfloop>
	
	<cfreturn model>
</cffunction>