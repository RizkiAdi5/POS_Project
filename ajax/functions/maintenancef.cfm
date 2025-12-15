<cfinclude template="../core/cfajax.cfm">

<cffunction name="getcolorsize">
	<cfargument name="colorno" required="yes" type="string">
	<cfset object = CreateObject("Component","cfobject")>

	<cfquery name="getcolorsize" datasource="#dts#">
		select * from iccolor2 
		where colorno='#arguments.colorno#'
		order by colorid2
	</cfquery>
	
	<cfset object.colorlist = valuelist(getcolorsize.colorid2)>
	<cfset object.sizelist = "">
	
	<cfset sizelist = "">
	<cfloop query="getcolorsize">
		<cfloop from="1" to="20" index="x">
			<cfset thissize = Evaluate("getcolorsize.size#x#")>
			<cfif thissize neq "" and ListContainsNoCase(sizelist, thissize) eq 0>
				<cfif sizelist eq "">
					<cfset sizelist = thissize>
				<cfelse>
					<cfset sizelist = sizelist&','&thissize>
				</cfif>
			</cfif>
		</cfloop>
	</cfloop>
	<cfset object.sizelist = sizelist>
	<cfreturn object>
</cffunction>

<cffunction name="updateqtybf">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="fieldvalue" required="yes" type="string">
	<cfset object = CreateObject("Component","cfobject")>

	<cfquery name="update" datasource="#dts#">
		update icitem
		set qtybf = '#arguments.fieldvalue#'
		where itemno = '#arguments.itemno#'
	</cfquery>
	
	<cfset object.itemno = arguments.itemno>
	<cfreturn object>
</cffunction>

<cffunction name="getItemDesp">
	<cfargument name="itemno" required="yes" type="string">
	<cfset object = CreateObject("Component","cfobject")>
	
	<cfset arguments.itemno = URLDecode(arguments.itemno)>

	<cfquery name="getdesp" datasource="#dts#">
		select desp from icitem
		where itemno = '#arguments.itemno#'
	</cfquery>
	
	<cfset object.itemdesp = getdesp.desp>
	<cfreturn object>
</cffunction>

<cffunction name="updateLotNo">
	<cfargument name="input_type" required="yes" type="string">
	<cfargument name="fieldvalue" required="yes" type="string">
	<cfset object = CreateObject("Component","cfobject")>

	<cfif arguments.input_type eq "txtbox">
		<cfquery name="update" datasource="#dts#">
			update gsetup
			set LOTNO = '#arguments.fieldvalue#'
		</cfquery>
	<cfelse>
		<cfquery name="getlotrun" datasource="#dts#">
			select lotnorun from gsetup
		</cfquery>
		<cfif getlotrun.lotnorun eq "1">
			<cfset nextcode = "0">
		<cfelse>
			<cfset nextcode = "1">
		</cfif>
		<cfquery name="update" datasource="#dts#">
			update gsetup
			set lotnorun = '#nextcode#'
		</cfquery>
	</cfif>
	
	<cfset object.input_type = arguments.input_type>
	<cfreturn object>
</cffunction>

<cffunction name="updateField">
	<cfargument name="input_type" required="yes" type="string">
	<cfargument name="fieldname" required="yes" type="string">
	<cfargument name="fieldvalue" required="yes" type="string">
	<cfset object = CreateObject("Component","cfobject")>

	<cfif arguments.input_type eq "txtbox">
		<cfquery name="update" datasource="#dts#">
			update gsetup
			set #arguments.fieldname# = '#arguments.fieldvalue#'
		</cfquery>
	<cfelse>
		<cfquery name="getvalue" datasource="#dts#">
			select #arguments.fieldname# from gsetup
		</cfquery>
		<cfif getvalue["#arguments.fieldname#"][1] eq "1">
			<cfset nextcode = "0">
		<cfelse>
			<cfset nextcode = "1">
		</cfif>
		<cfquery name="update" datasource="#dts#">
			update gsetup
			set #arguments.fieldname# = '#nextcode#'
		</cfquery>
	</cfif>
	
	<cfset object.fieldname = arguments.fieldname>
	<cfreturn object>
</cffunction>

<cffunction name="deleteLotNumber">
	<cfargument name="lotnumber" required="yes" type="string"> 
	
	<cftry>
		<cfquery name="deleteobbatch" datasource="#dts#">
			delete from obbatch
			where batchcode='#arguments.lotnumber#'
		</cfquery>
		
		<cfquery name="deletelobthob" datasource="#dts#">
			delete from lobthob
			where batchcode='#arguments.lotnumber#'
		</cfquery>
		
		<cfquery name="deleteLotNumber" datasource="#dts#">
			delete from lotnumber
			where lotnumber='#arguments.lotnumber#'
		</cfquery>
		<cfset status="Lot Number #arguments.lotnumber# Deleted.">
		
		<cfcatch type="database">
			<cflog file="ajax_maintenancef" text="Error msg (delete): #cfcatch.message# (#HcomID#-#HUserID#)">
			<cfset status="Failed to delete Lot Number #arguments.lotnumber#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch> 
	</cftry>
	
	<cfreturn status>
</cffunction>

<cffunction name="addBillformat">
	<cfargument name="tran" required="yes" type="string"> 
	<cfargument name="displayname" required="yes" type="string">
	<cfargument name="filename" required="yes" type="string">
	<cfargument name="doption" required="yes" type="string">
	
	<cfset arguments.displayname = URLDecode(arguments.displayname)>
	<cfset arguments.filename = URLDecode(arguments.filename)>
	
	<cftry>
		<cfquery name="getmax" datasource="#dts#">
			select max(counter) as maxcount from customized_format
			where type = '#arguments.tran#'
		</cfquery>
		<cfset nextcounter=val(getmax.maxcount)+1>
		
		<cfquery name="insert" datasource="#dts#">
			insert into customized_format
			(type,display_name,file_name,counter,d_option)
			values
			(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.displayname#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#">,#nextcounter#,'#val(arguments.doption)#')
		</cfquery>
		<cfset status="">
		<cfcatch type="database">
			<cflog file="ajax_maintenancef" text="Error msg (Insert): #cfcatch.message# (#HcomID#-#HUserID#)">
			<cfset status="Failed to Insert Bill Format #arguments.tran#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch> 
	</cftry>
	
	<cfreturn status>
</cffunction>

<cffunction name="editBillformat">
	<cfargument name="tran" required="yes" type="string"> 
	<cfargument name="displayname" required="yes" type="string">
	<cfargument name="filename" required="yes" type="string">
	<cfargument name="counter" required="yes" type="string">
	<cfargument name="doption" required="yes" type="string">
	
	<cfset arguments.displayname = URLDecode(arguments.displayname)>
	<cfset arguments.filename = URLDecode(arguments.filename)>
	
	<cftry>
		<cfquery name="edit" datasource="#dts#">
			update customized_format
			set display_name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.displayname#">,
			file_name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#">,
			d_option='#val(arguments.doption)#'
			where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
			and counter='#arguments.counter#'
		</cfquery>
		<cfset status="">
		<cfcatch type="database">
			<cflog file="ajax_maintenancef" text="Error msg (Update): #cfcatch.message# (#HcomID#-#HUserID#)">
			<cfset status="Failed to Update Bill Format #arguments.tran#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch> 
	</cftry>
	
	<cfreturn status>
</cffunction>

<cffunction name="deleteBillformat">
	<cfargument name="tran" required="yes" type="string"> 
	<cfargument name="displayname" required="yes" type="string">
	<cfargument name="filename" required="yes" type="string">
	<cfargument name="counter" required="yes" type="string">
	
	<cftry>
		<cfquery name="edit" datasource="#dts#">
			delete from customized_format
			where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
			and counter=#arguments.counter#
		</cfquery>
		<cfset status="">
		<cfcatch type="database">
			<cflog file="ajax_maintenancef" text="Error msg (Delete): #cfcatch.message# (#HcomID#-#HUserID#)">
			<cfset status="Failed to Delete Bill Format #arguments.tran#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch> 
	</cftry>
	
	<cfreturn status>
</cffunction>

<cffunction name="getCustSuppDesp">
	<cfargument name="custno" required="yes" type="string">
	<cfargument name="ctype" required="yes" type="string">
	
	<cfset object = CreateObject("Component","cfobject")>
	
	<cfif arguments.ctype eq "Customer">
		<cfset ptype=target_arcust>
	<cfelse>
		<cfset ptype=target_apvend>
	</cfif>
	<cfquery name="getname" datasource="#dts#">
		select name,name2 from #ptype#
		where custno = '#arguments.custno#'
	</cfquery>
	
	<cfset object.custname = getname.name>
	<cfset object.custname2 = getname.name2>
	<cfreturn object>
</cffunction>

<cffunction name="getcurrency">
	<cfargument name="currcode" required="yes" type="string">
	
	<cfset object = CreateObject("Component","cfobject")>
	
	<cfquery name="getcurr" datasource="main">
		select Currency,currency1,currency2 from currency
		where currcode = '#arguments.currcode#'
	</cfquery>
	
	<cfset object.currency = getcurr.Currency>
	<cfset object.currency1 = getcurr.currency1>
	<cfset object.currency2 = getcurr.currency2>
	<cfreturn object>
</cffunction>