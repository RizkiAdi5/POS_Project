<cfsetting showdebugoutput="no">
<cfoutput>
	<cfset itemno = URLDecode(url.itemno)>
    <cfset refno = URLDecode(url.refno)>
    <cfset type = URLDecode(url.type)>
    <cfset trancode = URLDecode(url.trancode)>
    <cfset custno = URLDecode(url.custno)>
    <cfset period = URLDecode(url.period)>
    <cfset qty = URLDecode(url.qty)>
    <cfset agenno = URLDecode(url.agenno)>
    <cfset location = URLDecode(url.location)>
    <cfset currrate = URLDecode(url.currrate)>
    <cfset sign = URLDecode(url.sign)>
    <cfset price = URLDecode(url.price)>
    <cfset serialno = URLDecode(url.serialno)>
	<cfset date = URLDecode(url.date)>
	
    <cfif url.proces eq 'Create'>
    
    <cfif sign eq '1'>
	<cftry>
		 <cfquery name="serialExist" datasource="#dts#">
			select sum(sign) as sign from iserial where itemno='#itemno#' and serialno='#serialno#' and (void is null or void='') and type <>"SAM"
		</cfquery>
		<cfif val(serialExist.sign) eq 0> 
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserial (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price) 
				values ('#type#','#refno#','#trancode#','#custno#','#period#',
				#date#,'#itemno#','#serialno#','#agenno#','#location#', 
				'#currrate#','#sign#','#price#')
			</cfquery>
			<h3>Serial No Added</h3>
		 <cfelse>
			<h3>Serial No Already Exist</h3>
		</cfif> 
		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (insert) : #cfcatch.message# (#HcomID#-#HUserID#)">
			<cfset status="Failed to insert Serial No. #serialno#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch>
	</cftry>
    <cfelse>
    <cftry>
    	<!---ASAIKI SAM --->
        <cfif type eq 'SAM' and dts eq "asaiki_i">
        <!---
        <cfquery name="getlastctgno" datasource="#dts#">
        	select rem49 from artran where type='#type#' and refno='#refno#'
        </cfquery>--->
        <cfquery name="getlastctgno" datasource="#dts#">
        select ifnull(max(ctgno),0) as rem49 from iserial where type='#type#' and refno='#refno#'
        </cfquery>
        <cfif getlastctgno.rem49 eq ''>
        <cfset lastctgno=0>
        <cfelse>
        <cfset lastctgno=val(getlastctgno.rem49)>
        </cfif>
        
        <cfquery name="serialExist" datasource="#dts#">
			select sum(sign) as sign from iserial where itemno='#itemno#' and serialno='#serialno#' and location='#location#' and (void is null or void='')
		</cfquery>
		<cfif serialExist.sign gt 0> 
        
        <cfset ctgnocheck = 0>
		<cfset lastctgno1 = lastctgno>
        <cfloop condition="ctgnocheck eq 0">
        <cfset lastctgno=lastctgno1+1>
        <cfquery name="checkctgnoexist" datasource="#dts#">
        	select serialno from iserial where type='#type#' and refno='#refno#' and ctgno='#numberformat(lastctgno,'000')#'
        </cfquery>
        <cfif checkctgnoexist.recordcount eq 0>
        <cfset ctgnocheck = 1>
        <cfelse>
        <cfset lastctgno1 = lastctgno>
		</cfif>
        </cfloop>
        
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserial (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price,CTGNO) 
				values ('#type#','#refno#','#trancode#','#custno#','#period#',
				#date#,'#itemno#','#serialno#','#agenno#','#location#', 
				'#currrate#','#sign#','#price#','#numberformat(lastctgno,'000')#')
			</cfquery>
			<h3>Serial No Added</h3>
		 <cfelse>
			<h3>Serial No Already Exist</h3>
		</cfif> 
        
        	<cfquery name="getlastctgno" datasource="#dts#">
				select ctgno from iserial where type='#type#' and refno='#refno#' order by ctgno desc
			</cfquery>
            
        	<cfquery name="updateremark49" datasource="#dts#">
				update artran set rem49='#getlastctgno.ctgno#' where type='#type#' and refno='#refno#'
			</cfquery>
        
        <cfelse>
        <!---Normal Out --->
		<cfquery name="serialExist" datasource="#dts#">
			select sum(sign) as sign from iserial where itemno='#itemno#' and serialno='#serialno#' and location='#location#' and (void is null or void='') and type<>'SAM'
		</cfquery>
		<cfif serialExist.sign gt 0> 
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserial (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price) 
				values ('#type#','#refno#','#trancode#','#custno#','#period#',
				#date#,'#itemno#','#serialno#','#agenno#','#location#', 
				'#currrate#','#sign#','#price#')
			</cfquery>
			<h3>Serial No Added</h3>
		 <cfelse>
			<h3>Serial No Already Exist</h3>
		</cfif> 
        </cfif>
		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (insert) : #cfcatch.message# (#HcomID#-#HUserID#)">
			<cfset status="Failed to insert Serial No. #serialno#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch>
	</cftry>
    </cfif>
    
    <!---Delete Serial No---->
    <cfelseif url.proces eq 'Delete'>
    <cfset isAllow=true>
    
    <cftry>
		<cfif sign eq 1>
			<cfquery name="checkExist" datasource="#dts#">
				select sum(sign) as sign from iserial where itemno='#itemno#' and location='#location#' and serialno='#serialno#' and (void is null or void='')  and type<>'SAM'
			</cfquery>
			<cfif checkExist.sign lt 1><cfset isAllow=false></cfif>
		</cfif>
		<cfif isAllow>
			<cfquery name="deleteserial" datasource="#dts#">
				delete from iserial where type='#type#' and itemno='#itemno#'
				and serialno='#serialno#' and refno='#refno#' and trancode='#trancode#'
			</cfquery>

		</cfif>
		<cfcatch type="database">
        <h3>Serial No Delete Fail</h3>
		</cfcatch>
	</cftry>
    </cfif>
    
</cfoutput>