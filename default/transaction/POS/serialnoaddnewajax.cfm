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
    <cfset uuid = URLDecode(url.uuid)>
	
    <cfif url.proces eq 'Create'>
    
    <cfif sign eq '1'>
	<cftry>
		 <cfquery name="serialExist" datasource="#dts#">
			select sum(sign) as sign from iserial where itemno='#itemno#' and serialno='#serialno#' and (void is null or void='') and type <>"SAM"
		</cfquery>
		<cfif val(serialExist.sign) eq 0> 
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserialtemp (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price,uuid) 
				values ('#type#','#refno#','#trancode#','#custno#','#period#',
				#date#,'#itemno#','#serialno#','#agenno#','#location#', 
				'#currrate#','#sign#','#price#','#uuid#')
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
        <!---Normal Out --->
		<cfquery name="serialExist" datasource="#dts#">
			select sum(sign) as sign from iserial where itemno='#itemno#' and serialno='#serialno#' and location='#location#' and (void is null or void='') and type<>'SAM'
		</cfquery>
		<cfif serialExist.sign gt 0> 
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserialtemp (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price,uuid) 
				values ('#type#','#refno#','#trancode#','#custno#','#period#',
				#date#,'#itemno#','#serialno#','#agenno#','#location#', 
				'#currrate#','#sign#','#price#','#uuid#')
			</cfquery>
			<h3>Serial No Added</h3>
		 <cfelse>
			<h3>Serial No Already Exist</h3>
		</cfif> 
		
    </cfif>
    
    <!---Delete Serial No---->
    <cfelseif url.proces eq 'Delete'>
    <cfset isAllow=true>
    
    <cftry>
		
			<cfquery name="deleteserial" datasource="#dts#">
				delete from iserialtemp where type='#type#' and itemno='#itemno#'
				and serialno='#serialno#' and refno='#refno#' and trancode='#trancode#' and uuid="#uuid#"
			</cfquery>

		<cfcatch type="database">
        <h3>Serial No Delete Fail</h3>
		</cfcatch>
	</cftry>
    </cfif>
    
</cfoutput>