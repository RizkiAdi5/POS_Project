
<cfoutput>
    <cfset refno = URLDecode(url.refno)>
    <cfset type = URLDecode(url.type)>
    <cfset trancode = URLDecode(url.trancode)>
    <cfset custno = URLDecode(url.custno)>
    <cfset period = URLDecode(url.period)>
    <cfset qty = URLDecode(url.qty)>
    <cfset seriallen = URLDecode(url.seriallen)>
    <cfset itemno = URLDecode(url.itemno)>
    <cfset serialnofr = URLDecode(url.serialnofr)>
    <cfset serialnoto = URLDecode(url.serialnoto)>
    <cfset prefix = URLDecode(url.prefix)>
    <cfset endfix = URLDecode(url.endfix)>
    <cfset agenno = URLDecode(url.agenno)>
    <cfset location = URLDecode(url.location)>
    <cfset currrate = URLDecode(url.currrate)>
    <cfset sign = URLDecode(url.sign)>
    <cfset price = URLDecode(url.price)>
	<cfset itemno = URLDecode(url.itemno)>

    <cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#seriallen#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>
    
    <cfset steploop = 1>
	<cfif serialnofr gt serialnoto>
	<cfset steploop = -1>
	</cfif>
    
    <cfquery name="getremainingserialno2" datasource="#dts#">
        select * from iserial where type='#type#' and refno='#refno#' and trancode='#trancode#' and itemno='#itemno#'
    </cfquery>
    
	<cfset count=getremainingserialno2.recordcount>
    
    <cfif count lt qty>
    
	<cfif len(serialnofr) gt 5>
    <cfset serialleftlength=len(serialnofr)-5>
    <cfelse>
    <cfset serialleftlength=0>
    </cfif>
    
    <cfloop from="#right(serialnofr,5)#" to="#right(serialnoto,5)#" step="#steploop#" index="i">
	<cfif len(serialnofr) gt 5>
	<cfset serialnum = prefix&left(serialnofr,serialleftlength)&i&endfix>
	<cfelse>
    <cfset serialnum = prefix&i&endfix>
    </cfif>
    <cftry>
		 <cfquery name="serialExist" datasource="#dts#">
			select serialno from iserial where itemno='#itemno#' and sign='#sign#' and serialno='#trim(serialnum)#' and location='#location#'
		</cfquery>
		<cfif serialExist.recordcount eq 0> 
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserial (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price) 
				values ('#type#','#refno#','#trancode#','#custno#','#period#',
				#date#,'#itemno#','#trim(serialnum)#','#agenno#','#location#', 
				'#currrate#','#sign#','#price#')
			</cfquery>

		 <cfelse>
		<h3>This Serial Already Exist.#chr(10)#Please try again.</h3>
		</cfif> 
		<cfcatch type="database">
		<h3>Error adding Serial No</h3>
		</cfcatch>
	</cftry>
    <cfset count=count+1>
    <cfif count gte qty>
    <cfbreak>
    </cfif>
    </cfloop>
    </cfif>
</cfoutput>