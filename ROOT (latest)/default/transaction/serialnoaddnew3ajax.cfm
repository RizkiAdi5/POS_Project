
<cfoutput>
    <cfset refno = URLDecode(url.refno)>
    <cfset type = URLDecode(url.type)>
    <cfset trancode = URLDecode(url.trancode)>
    <cfset custno = URLDecode(url.custno)>
    <cfset period = URLDecode(url.period)>
    <cfset qty = URLDecode(url.qty)>

    <cfset itemno = URLDecode(url.itemno)>
    <cfset serialnofr = URLDecode(url.serialnofr)>
    <cfset serialnoto = URLDecode(url.serialnoto)>
    
    <cfset agenno = URLDecode(url.agenno)>
    <cfset location = URLDecode(url.location)>
    <cfset currrate = URLDecode(url.currrate)>
    <cfset xsign = -1>
    <cfset price = URLDecode(url.price)>
	<cfset itemno = URLDecode(url.itemno)>

    
    <cfset steploop = 1>
	<cfset count=0>
    
    <cfif lcase(hcomid) eq "asaiki_i" and type eq 'SAM'> 
    <cfquery datasource="#dts#" name="getSerial">
    select * from (
		Select serialno,sum(sign) as sign
		from iserial 
		where itemno='#itemno#'
        and serialno between "#serialnofr#" and "#serialnoto#"
        <cfif location neq "">
        and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#location#">
		</cfif>
        group by serialno
		order by serialno) as a
        where a.sign=1
	</cfquery>
    <cfelse>
    <cfquery datasource="#dts#" name="getSerial">
    select * from (
		Select serialno,sum(sign) as sign
		from iserial 
		where itemno='#itemno#'
        and serialno between "#serialnofr#" and "#serialnoto#"
        <cfif location neq "">
        and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#location#">
		</cfif>
        and type<>'SAM'
        group by serialno
		order by serialno) as a
        where a.sign=1
	</cfquery>
    </cfif>
    
    <cfloop query="getserial">
    
	<cftry>
    		<cfif type eq 'SAM' and dts eq "asaiki_i">
            
            <cfquery name="getlastctgno" datasource="#dts#">
        	select rem49 from artran where type='#type#' and refno='#refno#'
            </cfquery>
            <cfif getlastctgno.rem49 eq ''>
            <cfset lastctgno=0>
            <cfelse>
            <cfset lastctgno=val(getlastctgno.rem49)>
            </cfif>
            
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
				#date#,'#itemno#','#getserial.serialno#','#agenno#','#location#', 
				'#currrate#','#xsign#','#price#','#numberformat(lastctgno,'000')#')
			</cfquery>
            
            <cfquery name="getlastctgno" datasource="#dts#">
				select ctgno from iserial where type='#type#' and refno='#refno#' order by ctgno desc
			</cfquery>
            
        	<cfquery name="updateremark49" datasource="#dts#">
				update artran set rem49='#getlastctgno.ctgno#' where type='#type#' and refno='#refno#'
			</cfquery>
            
            <cfelse>
            
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserial (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price) 
				values ('#type#','#refno#','#trancode#','#custno#','#period#',
				#date#,'#itemno#','#getserial.serialno#','#agenno#','#location#', 
				'#currrate#','#xsign#','#price#')
			</cfquery>
            
            </cfif>
			<cfset status="Successfully insert Serial No. #getserial.serialno#.">

		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (insert) : #cfcatch.message# (#HcomID#-#HUserID#) #cfcatch.Detail#---#getserial.serialno# ">
			<cfset status="Failed to insert Serial No. #serialnofr# to #serialnoto#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch>
	</cftry>
   <cfset count=count+1>
    <cfif count gte qty>
    <cfbreak> 
    </cfif>
    </cfloop>
</cfoutput>