<cfinclude template="../core/cfajax.cfm">

<cffunction name="itemlookup" hint="type='keyvalue' jsreturn='array' delimiter='||'">
	<cfargument name="letter" required="no" type="string">
	<cfargument name="searchtype" required="yes" type="string">
	
	<cfif arguments.letter eq "">
		<cfset model = ArrayNew(1)>
		<cfset ArrayAppend(model,"-1||Please use the filter.")>
	<cfelse>
		<cfquery name="getItem" datasource="#dts#">
			SELECT itemno,desp FROM icitem
			where #arguments.searchtype# like '#arguments.letter#%' and nonstkitem<>'T' 
            <cfif Hitemgroup neq ''>
            and wos_group='#Hitemgroup#'
            </cfif>
			order by itemno
		</cfquery>
		
		<cfset model = ArrayNew(1)>
		<cfset ArrayAppend(model,"-1||Choose an item")>
		
		<cfloop query="getItem">
			<cfset ArrayAppend(model,"#itemno#||#itemno# - #desp#")>
		</cfloop>
	</cfif>
	<cfreturn model>
</cffunction>

<cffunction name="getSerialnoTableList">
	<cfargument name="type" required="yes" type="string"> 
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="numeric">
	<cfargument name="location" required="yes" type="string">
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
	
    <cfif dts eq 'asaiki_i'>
    
    <cfquery name="getRecord" datasource="#dts#">
		Select '' as crow,ctgno,serialno,'' as act from iserial 
		where type='#arguments.type#' and refno='#arguments.refno#' and itemno='#arguments.itemno#' and 
		trancode='#arguments.trancode#' and location='#arguments.location#'
		order by serialno
	</cfquery>
	<cfloop query="getRecord">
		<cfset temp=querysetcell(getRecord,"crow","#getRecord.ctgno#",getRecord.ctgno)>
		<cfset temp=querysetcell(getRecord,"act","<a onmouseover=""JavaScript:this.style.cursor='hand'"" onClick=""deleteSerialno('#getRecord.serialno#')"">
			<img height='18px' width='18px' src='../../images/delete.ICO' alt='Delete' border='0'>Delete</a>",getRecord.currentrow)>
	</cfloop>
    
    <cfelse>
    
	<cfquery name="getRecord" datasource="#dts#">
		Select '' as crow,serialno,'' as act from iserial 
		where type='#arguments.type#' and refno='#arguments.refno#' and itemno='#arguments.itemno#' and 
		trancode='#arguments.trancode#' and location='#arguments.location#'
		order by serialno
	</cfquery>
	<cfloop query="getRecord">
		<cfset temp=querysetcell(getRecord,"crow","#getRecord.currentrow#",getRecord.currentrow)>
		<cfset temp=querysetcell(getRecord,"act","<a onmouseover=""JavaScript:this.style.cursor='hand'"" onClick=""deleteSerialno('#getRecord.serialno#')"">
			<img height='18px' width='18px' src='../../images/delete.ICO' alt='Delete' border='0'>Delete</a>",getRecord.currentrow)>
	</cfloop>
    
    </cfif>
	<cfreturn getRecord>
</cffunction>

<cffunction name="addedserialnolookup" hint="type='keyvalue' jsreturn='array'">
	<cfargument name="itemno" required="yes" type="string">
	<cfset model = ArrayNew(1)>
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
	
	<cfquery datasource="#dts#" name="getSerial">
		Select serialno 
		from iserial 
		where itemno='#arguments.itemno#' and sign=1
        and (void is null or void='')
		order by serialno
	</cfquery>
	<cfif getSerial.recordcount gt 0>
		<cfset ArrayAppend(model,"-,--- Added Serial No. As below. ---")>
		<cfloop query="getSerial">
			<cfset ArrayAppend(model,"#serialno#,#serialno#")>
		</cfloop>
	<cfelse>
		<cfset ArrayAppend(model,"-,--- You have empty Serial No. ---")>
	</cfif>
	<cfreturn model>
</cffunction>

<cffunction name="serialnolookup" hint="type='keyvalue' jsreturn='array'">
	<cfargument name="type" type="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="location" required="yes" type="string">
    
	<cfset model = ArrayNew(1)>
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
	
	<!--- <cfquery datasource="#dts#" name="getSerial">
		Select count(type) as cnt,serialno 
		from iserial 
		where itemno='#arguments.itemno#' and location='#arguments.location#'
		group by serialno
		having cnt=1
	</cfquery> --->
	
	<cfquery datasource="#dts#" name="getSerial">
		select a.serialno,ifnull((ifnull(b.cntin,0) - ifnull(c.cntout,0)),0) as balance
		from iserial a
		
		left join
		(Select count(serialno) as cntin,serialno
		from iserial
		where itemno='#arguments.itemno#' and location='#arguments.location#'
		and sign='1'
        and (void is null or void='')
		group by serialno) as b on (a.serialno=b.serialno)
		
		left join (
		select count(serialno) as cntout,serialno
		from iserial
		where itemno='#arguments.itemno#' and location='#arguments.location#' 
        <cfif isdefined('type')>
    	<cfif type neq 'SAM'>
        and type<>'SAM'
        </cfif>
    	<cfelse>
        and type<>'SAM'
        </cfif>
		and sign='-1'
        and (void is null or void='')
		group by serialno
		)as c on (a.serialno=c.serialno)
		
		where ifnull((ifnull(b.cntin,0) - ifnull(c.cntout,0)),0) > 0
		group by a.serialno
	</cfquery>
	
	<cfif getSerial.recordcount gt 0>
		<!--- <cfset ArrayAppend(model,"-,--- Please select one of #getSerial.recordcount# Serial No. below. ---")> --->
		<cfset ArrayAppend(model,"{no},--- Please select one of #getSerial.recordcount# Serial No. below. ---")>
		<cfloop query="getSerial">
			<cfset ArrayAppend(model,"#serialno#,#serialno#")>
		</cfloop>
	<cfelse>
		<cfset ArrayAppend(model,"-,--- You have empty Serial No. ---")>
	</cfif>
	<cfreturn model>
</cffunction>

<cffunction name="exceptlookup">
	<cfargument name="type" required="yes" type="string"> 
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="numeric">
	<cfargument name="qty" required="yes" type="numeric">
	<cfargument name="location" required="yes" type="string">
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
	
	<cfquery datasource="#dts#" name="serialtotal">
		Select (#arguments.qty#-count(itemno)) as itemcnt 
		from iserial 
		where type='#arguments.type#' and refno='#arguments.refno#' and itemno='#arguments.itemno#' and trancode='#arguments.trancode#' 
		and location='#arguments.location#'
		group by itemno
	</cfquery>
	
	<cfif serialtotal.recordcount eq 0>
		<cfset status=arguments.qty>
	<cfelse>
		<cfif serialtotal.itemcnt gt 0>
			<cfset status=serialtotal.itemcnt>
		<cfelse>
			<cfset status=0>
		</cfif>
	</cfif>
	<cfreturn status>
</cffunction>

<cffunction name="addNewSerialno">
	<cfargument name="type" required="yes" type="string"> 
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="numeric">
	<cfargument name="custno" required="yes" type="string">
	<cfargument name="period" required="yes" type="string">
	<cfargument name="date" required="yes" type="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="serialno" required="yes" type="string">
	<cfargument name="agenno" required="yes" type="string">
	<cfargument name="location" required="yes" type="string">
	<cfargument name="currrate" required="yes" type="string">
	<cfargument name="sign" required="yes" type="string">
	<cfargument name="price" required="yes" type="string">
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
    <cfif sign eq '1'>
	<cftry>
		 <cfquery name="serialExist" datasource="#dts#">
			select sum(sign) as sign from iserial where itemno='#arguments.itemno#' and serialno='#arguments.serialno#' and (void is null or void='')
		</cfquery>
		<cfif val(serialExist.sign) eq 0> 
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserial (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price) 
				values ('#arguments.type#','#arguments.refno#','#arguments.trancode#','#arguments.custno#','#arguments.period#',
				#arguments.date#,'#arguments.itemno#','#arguments.serialno#','#arguments.agenno#','#arguments.location#', 
				'#arguments.currrate#','#arguments.sign#','#arguments.price#')
			</cfquery>
			<cfset status="Successfully insert Serial No. #arguments.serialno#.">
		 <cfelse>
			<cfset status="This Serial Already Exist.#chr(10)#Please try again.">
		</cfif> 
		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (insert) : #cfcatch.message# (#HcomID#-#HUserID#)">
			<cfset status="Failed to insert Serial No. #arguments.serialno#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch>
	</cftry>
    <cfelse>
    <cftry>
    	<!---ASAIKI SAM --->
        <cfif type eq 'SAM' and dts eq "asaiki_i">
        
        <cfquery name="getlastctgno" datasource="#dts#">
        	select rem49 from artran where type='#arguments.type#' and refno='#arguments.refno#'
        </cfquery>
        <cfif getlastctgno.rem49 eq ''>
        <cfset lastctgno=0>
        <cfelse>
        <cfset lastctgno=val(getlastctgno.rem49)>
        </cfif>
        
        <cfquery name="serialExist" datasource="#dts#">
			select sum(sign) as sign from iserial where itemno='#arguments.itemno#' and serialno='#arguments.serialno#' and location='#arguments.location#' and (void is null or void='')
		</cfquery>
		<cfif serialExist.sign gt 0> 
        
        <cfset ctgnocheck = 0>
		<cfset lastctgno1 = lastctgno>
        <cfloop condition="ctgnocheck eq 0">
        <cfset lastctgno=lastctgno1+1>
        <cfquery name="checkctgnoexist" datasource="#dts#">
        	select serialno from iserial where type='#arguments.type#' and refno='#arguments.refno#' and ctgno='#numberformat(lastctgno,'000')#'
        </cfquery>
        <cfif checkctgnoexist.recordcount eq 0>
        <cfset ctgnocheck = 1>
        <cfelse>
        <cfset lastctgno1 = lastctgno>
		</cfif>
        </cfloop>
        
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserial (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price,CTGNO) 
				values ('#arguments.type#','#arguments.refno#','#arguments.trancode#','#arguments.custno#','#arguments.period#',
				#arguments.date#,'#arguments.itemno#','#arguments.serialno#','#arguments.agenno#','#arguments.location#', 
				'#arguments.currrate#','#arguments.sign#','#arguments.price#','#numberformat(lastctgno,'000')#')
			</cfquery>
			<cfset status="Successfully insert Serial No. #arguments.serialno#.">
		 <cfelse>
			<cfset status="This Serial Already Exist.#chr(10)#Please try again.">
		</cfif> 
        
        <cfelse>
        <!---Normal Out --->
		<cfquery name="serialExist" datasource="#dts#">
			select sum(sign) as sign from iserial where itemno='#arguments.itemno#' and serialno='#arguments.serialno#' and location='#arguments.location#' and (void is null or void='') and type<>'SAM'
		</cfquery>
		<cfif serialExist.sign gt 0> 
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserial (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price) 
				values ('#arguments.type#','#arguments.refno#','#arguments.trancode#','#arguments.custno#','#arguments.period#',
				#arguments.date#,'#arguments.itemno#','#arguments.serialno#','#arguments.agenno#','#arguments.location#', 
				'#arguments.currrate#','#arguments.sign#','#arguments.price#')
			</cfquery>
			<cfset status="Successfully insert Serial No. #arguments.serialno#.">
		 <cfelse>
			<cfset status="This Serial Already Exist.#chr(10)#Please try again.">
		</cfif> 
        </cfif>
		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (insert) : #cfcatch.message# (#HcomID#-#HUserID#)">
			<cfset status="Failed to insert Serial No. #arguments.serialno#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch>
	</cftry>
    </cfif>
	<cfreturn status>
</cffunction>

<cffunction name="addNewSerialno2">
	<cfargument name="type" required="yes" type="string"> 
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="numeric">
	<cfargument name="custno" required="yes" type="string">
	<cfargument name="period" required="yes" type="string">
	<cfargument name="date" required="yes" type="string">
    <cfargument name="qty" required="yes" type="numeric">
    <cfargument name="seriallen" required="yes" type="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="serialnofr" required="yes" type="string">
    <cfargument name="serialnoto" required="yes" type="string">
    <cfargument name="prefix" required="yes" type="string">
    <cfargument name="endfix" required="yes" type="string">
	<cfargument name="agenno" required="yes" type="string">
	<cfargument name="location" required="yes" type="string">
	<cfargument name="currrate" required="yes" type="string">
	<cfargument name="sign" required="yes" type="string">
	<cfargument name="price" required="yes" type="string">
    
	<cfset arguments.itemno = URLDecode(arguments.itemno)>

		

    
    <cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#arguments.seriallen#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>
    
    <cfset steploop = 1>
	<cfif arguments.serialnofr gt arguments.serialnoto>
	<cfset steploop = -1>
	</cfif>
	<cfset count=0>
    <cfloop from="#arguments.serialnofr#" to="#arguments.serialnoto#" step="#steploop#" index="i">
	<cfset serialnum = arguments.prefix&numberformat(i,stDecl_UPrice)&arguments.endfix>
    
	<cftry>
		 <cfquery name="serialExist" datasource="#dts#">
			select serialno from iserial where itemno='#arguments.itemno#' and sign='#sign#' and serialno='#i#' and location='#arguments.location#'
		</cfquery>
		<cfif serialExist.recordcount eq 0> 
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserial (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price) 
				values ('#arguments.type#','#arguments.refno#','#arguments.trancode#','#arguments.custno#','#arguments.period#',
				#arguments.date#,'#arguments.itemno#','#serialnum#','#arguments.agenno#','#arguments.location#', 
				'#arguments.currrate#','#arguments.sign#','#arguments.price#')
			</cfquery>
			<cfset status="Successfully insert Serial No. #serialnum#.">
		 <cfelse>
			<cfset status="This Serial Already Exist.#chr(10)#Please try again.">
		</cfif> 
		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (insert) : #cfcatch.message# (#HcomID#-#HUserID#)">
			<cfset status="Failed to insert Serial No. #serialnum#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch>
	</cftry>
    <cfset count=count+1>
    <cfif count gte arguments.qty>
    <cfbreak>
    </cfif>
    </cfloop>
    
	<cfreturn status>
</cffunction>

<cffunction name="addNewSerialno3">
	<cfargument name="type" required="yes" type="string"> 
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="numeric">
	<cfargument name="custno" required="yes" type="string">
	<cfargument name="period" required="yes" type="string">
	<cfargument name="date" required="yes" type="string">
    <cfargument name="newqty" required="yes" type="numeric">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="serialnofr" required="yes" type="string">
    <cfargument name="serialnoto" required="yes" type="string">
	<cfargument name="agenno" required="yes" type="string">
	<cfargument name="location" required="yes" type="string">
	<cfargument name="currrate" required="yes" type="string">
	<cfargument name="sign" required="yes" type="string">
	<cfargument name="price" required="yes" type="string">
    
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
    
    <cfset steploop = 1>
	<cfset count=0>
    
    <cfif type eq 'SAM'>
    <cfquery datasource="#dts#" name="getSerial">
    select * from (
		Select serialno,sum(sign) as sign
		from iserial 
		where itemno='#arguments.itemno#'
        and serialno between "#arguments.serialnofr#" and "#arguments.serialnoto#"
        <cfif arguments.location neq "">
        and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.location#">
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
		where itemno='#arguments.itemno#'
        and serialno between "#arguments.serialnofr#" and "#arguments.serialnoto#"
        <cfif arguments.location neq "">
        and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.location#">
		</cfif>
        and type<>'SAM'
        group by serialno
		order by serialno) as a
        where a.sign=1
	</cfquery>
    </cfif>
    
    <cfloop query="getserial">
    
	<cftry>
			<cfquery name="insertserial" datasource="#dts#">
				insert into iserial (type,refno,trancode,custno,fperiod,wos_date,itemno,serialno,agenno,location,currrate,sign,price) 
				values ('#arguments.type#','#arguments.refno#','#arguments.trancode#','#arguments.custno#','#arguments.period#',
				#arguments.date#,'#arguments.itemno#','#getserial.serialno#','#arguments.agenno#','#arguments.location#', 
				'#arguments.currrate#','#arguments.sign#','#arguments.price#')
			</cfquery>
			<cfset status="Successfully insert Serial No. #getserial.serialno#.">

		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (insert) : #cfcatch.message# (#HcomID#-#HUserID#) #cfcatch.Detail#---#getserial.serialno# ">
			<cfset status="Failed to insert Serial No. #serialnofr# to #serialnoto#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch>
	</cftry>
   <cfset count=count+1>
    <cfif count gte arguments.newqty>
    <cfbreak> 
    </cfif>
    </cfloop>
    
	<cfreturn status>
</cffunction>

<cffunction name="deleteSerialno">
	<cfargument name="type" required="yes" type="string"> 
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="numeric">
	<cfargument name="itemno" required="yes" type="string">
    <cfargument name="location" required="yes" type="string">
	<cfargument name="serialno" required="yes" type="string">
	<cfargument name="sign" required="yes" type="string">
	<cfset isAllow=true>
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
	
	<cftry>
		<cfif sign eq 1>
			<cfquery name="checkExist" datasource="#dts#">
				select sum(sign) as sign from iserial where itemno='#arguments.itemno#' and location='#arguments.location#' and serialno='#arguments.serialno#' and (void is null or void='')
			</cfquery>
			<cfif checkExist.sign lt 1><cfset isAllow=false><cfset status="This Serial No. #arguments.serialno# is in used."></cfif>
		</cfif>
		<cfif isAllow>
			<cfquery name="deleteserial" datasource="#dts#">
				delete from iserial where type='#arguments.type#' and itemno='#arguments.itemno#'
				and serialno='#arguments.serialno#' and refno='#arguments.refno#' and trancode='#arguments.trancode#'
			</cfquery>
			<cfset status="Successfully delete Serial No. #arguments.serialno#.">
		</cfif>
		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (delete): #cfcatch.message# (#HcomID#-#HUserID#)">
			<cfset status="Failed to delete Serial No. #arguments.serialno#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch>
	</cftry>
	<cfreturn status>
</cffunction>

<cffunction name="addNewItem">
	<cfargument name="type" required="yes" type="string"> 
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="desp" required="yes" type="string">
	<cfargument name="despa" required="yes" type="string">
	<cfargument name="comment" required="yes" type="string">
	<cfargument name="remark1" required="yes" type="string">
	<cfargument name="remark2" required="yes" type="string">
	<cfargument name="remark3" required="yes" type="string">
	<cfargument name="remark4" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="string">
	<cfargument name="unit" required="yes" type="string">
	<cfargument name="qty" required="yes" type="string">
	<cfargument name="price" required="yes" type="string">
	<cfset amt1_bil=val(arguments.qty)*val(arguments.price)>
	
	<cftry>
		<cfquery name="getArtran" datasource="#dts#">
			select custno,fperiod,wos_date,currrate,agenno
			from collectionnote_artran where type='#arguments.type#' and refno='#arguments.refno#'
		</cfquery>
		<cfquery name="insertRecord" datasource="#dts#">
			Insert into collectionnote_ictran (type,refno,trancode,custno,fperiod,wos_date,currrate,
			itemcount,itemno,desp,despa,
			agenno,qty_bil,price_bil,unit_bil,amt1_bil,dispec1,dispec2,dispec3,disamt_bil,
			amt2_bil,taxp,tax_bil,amt3_bil,qty,price,unit,
			amt1,disamt,amt2,tax,amt3,
			brem1,brem2,brem3,brem4,
			userid,trdatetime,comment)
		
			values ('#arguments.type#','#arguments.refno#','#arguments.trancode#','#getArtran.custno#','#getArtran.fperiod#',#getArtran.wos_date#,'#getArtran.currrate#', 
			'#arguments.trancode#','#arguments.itemno#','#URLDecode(arguments.desp)#','#URLDecode(arguments.despa)#',
			'#getArtran.agenno#','#arguments.qty#','#arguments.price#','#URLDecode(arguments.unit)#','#variables.amt1_bil#','0','0','0','0',
			'#variables.amt1_bil#','0','0','#variables.amt1_bil#','#arguments.qty#','#val(arguments.price)*getArtran.currrate#','#URLDecode(arguments.unit)#',
			'#variables.amt1_bil*getArtran.currrate#','0','#variables.amt1_bil*getArtran.currrate#','0','#variables.amt1_bil*getArtran.currrate#',
			'#URLDecode(arguments.remark1)#','#URLDecode(arguments.remark2)#','#URLDecode(arguments.remark3)#','#URLDecode(arguments.remark4)#',
			'#huserid#',#now()#,'#URLDecode(arguments.comment)#')				
		</cfquery>
		<cfset status="Successfully insert Item No. #arguments.itemno#.">
		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (insert item) : #cfcatch.Detail# (#HcomID#-#HUserID#)">
			<cfset status="Failed to insert Item No. #arguments.itemno#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch>
	</cftry>
	<cfreturn status>
</cffunction>

<cffunction name="editItem">
	<cfargument name="type" required="yes" type="string"> 
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="desp" required="yes" type="string">
	<cfargument name="despa" required="yes" type="string">
	<cfargument name="comment" required="yes" type="string">
	<cfargument name="remark1" required="yes" type="string">
	<cfargument name="remark2" required="yes" type="string">
	<cfargument name="remark3" required="yes" type="string">
	<cfargument name="remark4" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="string">
	<cfargument name="unit" required="yes" type="string">
	<cfargument name="qty" required="yes" type="string">
	<cfargument name="price" required="yes" type="string">
	<cfset amt1_bil=val(arguments.qty)*val(arguments.price)>

	<cftry>
		<cfquery name="updateRecord" datasource="#dts#">
			Update collectionnote_ictran 
			set desp='#URLDecode(arguments.desp)#',
			despa='#URLDecode(arguments.despa)#',
			qty_bil='#arguments.qty#',
			price_bil='#arguments.price#',
			unit_bil='#URLDecode(arguments.unit)#',
			amt1_bil='#variables.amt1_bil#',
			amt2_bil='#variables.amt1_bil#',
			amt3_bil='#variables.amt1_bil#',
			qty='#arguments.qty#',
			price=#val(arguments.price)#*currrate,
			unit='#URLDecode(arguments.unit)#',
			amt1=#variables.amt1_bil#*currrate,
			amt2=#variables.amt1_bil#*currrate,
			amt3=#variables.amt1_bil#*currrate,
			brem1='#URLDecode(arguments.remark1)#',
			brem2='#URLDecode(arguments.remark2)#',
			brem3='#URLDecode(arguments.remark3)#',
			brem4='#URLDecode(arguments.remark4)#',
			userid='#huserid#',
			trdatetime=#now()#,
			comment='#URLDecode(arguments.comment)#'
			where type='#arguments.type#' and refno='#arguments.refno#'	and itemcount='#arguments.trancode#'
		</cfquery>
		<cfset status="Successfully update (No.#arguments.trancode#) Item No. #arguments.itemno#.">
		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (update item) : #cfcatch.Detail# (#HcomID#-#HUserID#)">
			<cfset status="Failed to update (No.#arguments.trancode#) Item No. #arguments.itemno#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch>
	</cftry>
	<cfreturn status>
</cffunction>

<cffunction name="deleteItem">
	<cfargument name="type" required="yes" type="string"> 
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="string">
	<cftry>
		<cfquery name="deleteItem" datasource="#dts#">
			delete from collectionnote_ictran where type='#arguments.type#' and refno='#arguments.refno#' and itemcount='#arguments.trancode#'
		</cfquery>
		<cfquery name="updateIctran" datasource="#dts#">
			update collectionnote_ictran
			set itemcount=itemcount-1, trancode=trancode-1
			where refno='#arguments.refno#' and type='#arguments.type#' and itemcount>#arguments.trancode#
		</cfquery>
		<cfset status="Successfully delete (No.#arguments.trancode#) Ref.No. #arguments.refno#.">
		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (delete item) : #cfcatch.Detail# (#HcomID#-#HUserID#)">
			<cfset status="Failed to delete (No.#arguments.trancode#) Ref.No. #arguments.refno#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch>
	</cftry>
	<cfreturn status>
</cffunction>

<cffunction name="getItemTableList">
	<cfargument name="type" required="yes" type="string"> 
	<cfargument name="refno" required="yes" type="string">
	
	<cfquery name="getRecord" datasource="#dts#">
		select itemcount as crow,itemno as itmc,desp as d,qty as q,FORMAT(price_bil,2) as p,FORMAT(currrate,2) as c,FORMAT(amt3_bil,2) as a,'' as act
		from collectionnote_ictran where refno='#arguments.refno#' and type='#arguments.type#' order by itemcount
	</cfquery>
	<cfloop query="getRecord">
		<cfset temp=querysetcell(getRecord,"act","
			<a href='##' onClick=""editLink('#getRecord.crow#','#getRecord.itmc#')"">
			<img height='18px' width='18px' src='../../images/edit.ICO' alt='Edit' border='0'>Edit</a>&nbsp;
			<a href='##' onClick=""deleteLink('#getRecord.crow#')"">
			<img height='18px' width='18px' src='../../images/delete.ICO' alt='Delete' border='0'>Delete</a>
			",getRecord.currentrow)>
	</cfloop>
	<cfreturn getRecord>
</cffunction>

<cffunction name="getbalqty">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="string">
    <cfargument name="type" required="yes" type="string">
    <cfargument name="refno" required="yes" type="string">
	<cfargument name="location" required="no" type="string">
	<cfset object = CreateObject("Component","cfobject")>
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
	
	<cfif arguments.location neq "">
		<cfquery name="getlocitembal" datasource="#dts#">
			select LOCQFIELD as locqtybf from locqdbf
			where itemno = '#arguments.itemno#' 
			and location = '#arguments.location#'
		</cfquery>
		<cfif getlocitembal.recordcount neq 0>
			<cfset itembal = val(getlocitembal.locqtybf)>
		<cfelse>
			<cfset itembal = 0>
		</cfif>
		
	<cfelse>
		<cfquery name="getitembal" datasource="#dts#">
			select qtybf from icitem
			where itemno = '#arguments.itemno#'
		</cfquery>
		<cfif getitembal.recordcount neq 0>
			<cfset itembal = val(getitembal.qtybf)>
        <cfelse>
        	<cfset itembal = 0>
		</cfif>
	</cfif>
	
	<cfquery name="getin" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type in ('RC','CN','OAI','TRIN') 
		and itemno='#arguments.itemno#'
		and (linecode <> 'SV' or linecode is null)
		<cfif arguments.location neq "">
			and location = '#arguments.location#' 
		</cfif> 
		and fperiod <> '99' 
		and (void='' or void is null);
	</cfquery>

	<cfif getin.sumqty neq "">
		<cfset inqty = getin.sumqty>
	<cfelse>
		<cfset inqty = 0>
	</cfif>

	<cfquery name="getout" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type in ('INV','DN','PR','CS','ISS','OAR','TROU') 
		and itemno='#arguments.itemno#'
		and (linecode <> 'SV' or linecode is null)
		<cfif arguments.location neq "">
			and location = '#arguments.location#' 
		</cfif>  
		and fperiod <> '99' 
		and (void='' or void is null);
	</cfquery>

	<cfif getout.sumqty neq "">
		<cfset outqty = getout.sumqty>
	<cfelse>
		<cfset outqty = 0>
	</cfif>

	<cfquery name="getdo" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type='DO' 
		and (toinv='' or toinv is null) 
		and itemno='#arguments.itemno#' 
		and (linecode <> 'SV' or linecode is null)
		<cfif arguments.location neq "">
			and location = '#arguments.location#' 
		</cfif> 
		and fperiod <> '99' 
		and (void='' or void is null);
	</cfquery>

	<cfif getdo.sumqty neq "">
		<cfset DOqty = getdo.sumqty>
	<cfelse>
		<cfset DOqty = 0>
	</cfif>
    
   <cfquery name="getthisbill" datasource="#dts#">
		select qty
		from ictran 
		where type='#arguments.type#' 
        and refno='#arguments.refno#'
        and trancode='#arguments.trancode#'
		and (toinv='' or toinv is null) 
		and itemno='#arguments.itemno#' 
		and (linecode <> 'SV' or linecode is null)
		<cfif arguments.location neq "">
			and location = '#arguments.location#' 
		</cfif> 
		and fperiod <> '99' 
		and (void='' or void is null);
	</cfquery>
	
	<cfif lcase(hcomid) eq "remo_i">
		<cfquery name="getso" datasource="#dts#">
			select 
			ifnull(sum(qty),0) as sumqty 
			from ictran 
			where type='SO' 
			and itemno='#arguments.itemno#' 
			and (linecode <> 'SV' or linecode is null)
			and fperiod <> '99' 
			<cfif arguments.location neq "">
				and location = '#arguments.location#' 
			</cfif> 
			and (void='' or void is null) 
			and (toinv='' or toinv is null);
		</cfquery>
		
		<cfset object.balonhand = itembal + inqty - outqty - doqty - getso.sumqty>
	<cfelseif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
		<cfquery name="getpo" datasource="#dts#">
			select 
			ifnull(sum(qty),0) as sumqty 
			from ictran 
			where type='PO' 
			and itemno='#arguments.itemno#' 
			and (linecode <> 'SV' or linecode is null)
			and fperiod <> '99' 
			<cfif arguments.location neq "">
				and location = '#arguments.location#' 
			</cfif> 
			and (void='' or void is null) 
			and (toinv='' or toinv is null)
		</cfquery>
		
		<cfset object.balonhand = itembal + inqty - outqty - doqty + getpo.sumqty>
	<cfelse>
    	<cfif arguments.type eq 'RC' or arguments.type eq 'CN' or arguments.type eq 'PO' or arguments.type eq 'QUO' or arguments.type eq 'SO' or arguments.type eq 'SAM' or arguments.type eq 'ISS'>
        <cfset object.balonhand = itembal + inqty - outqty - doqty>
        <cfelse>
        <cfset object.balonhand = itembal + inqty - outqty - doqty + val(getthisbill.qty)>
        </cfif>
	</cfif>
	
	<cfreturn object>
</cffunction>


<cffunction name="getavailqty">
	<cfargument name="itemno" required="yes" type="string">
    <cfargument name="trancode" required="yes" type="string">
    <cfargument name="type" required="yes" type="string">
    <cfargument name="refno" required="yes" type="string">
    
	<cfargument name="location" required="no" type="string">
	<cfset object = CreateObject("Component","cfobject")>
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
	
	<cfif arguments.location neq "">
		<cfquery name="getlocitembal" datasource="#dts#">
			select LOCQFIELD as locqtybf from locqdbf
			where itemno = '#arguments.itemno#' 
			and location = '#arguments.location#'
		</cfquery>
		<cfif getlocitembal.recordcount neq 0>
			<cfset itembal = val(getlocitembal.locqtybf)>
		<cfelse>
			<cfset itembal = 0>
		</cfif>
		
	<cfelse>
		<cfquery name="getitembal" datasource="#dts#">
			select qtybf from icitem
			where itemno = '#arguments.itemno#'
		</cfquery>
		<cfif getitembal.recordcount neq 0>
			<cfset itembal = val(getitembal.qtybf)>
        <cfelse>
        	<cfset itembal = 0>
		</cfif>
	</cfif>
	
	<cfquery name="getin" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type in ('RC','CN','OAI','TRIN') 
		and itemno='#arguments.itemno#'
		and (linecode <> 'SV' or linecode is null)
		<cfif arguments.location neq "">
			and location = '#arguments.location#' 
		</cfif> 
		and fperiod <> '99' 
		and (void='' or void is null);
	</cfquery>

	<cfif getin.sumqty neq "">
		<cfset inqty = getin.sumqty>
	<cfelse>
		<cfset inqty = 0>
	</cfif>

	<cfquery name="getout" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type in ('INV','DN','PR','CS','ISS','OAR','TROU') 
		and itemno='#arguments.itemno#'
		and (linecode <> 'SV' or linecode is null)
		<cfif arguments.location neq "">
			and location = '#arguments.location#' 
		</cfif>  
		and fperiod <> '99' 
		and (void='' or void is null);
	</cfquery>

	<cfif getout.sumqty neq "">
		<cfset outqty = getout.sumqty>
	<cfelse>
		<cfset outqty = 0>
	</cfif>

	<cfquery name="getdo" datasource="#dts#">
		select 
		sum(qty)as sumqty 
		from ictran 
		where type='DO' 
		and (toinv='' or toinv is null) 
		and itemno='#arguments.itemno#' 
		and (linecode <> 'SV' or linecode is null)
		<cfif arguments.location neq "">
			and location = '#arguments.location#' 
		</cfif> 
		and fperiod <> '99' 
		and (void='' or void is null);
	</cfquery>

	<cfif getdo.sumqty neq "">
		<cfset DOqty = getdo.sumqty>
	<cfelse>
		<cfset DOqty = 0>
	</cfif>
	
    <cfquery name="getthisbill" datasource="#dts#">
		select qty
		from ictran 
		where type='#arguments.type#' 
        and refno='#arguments.refno#'
        and trancode='#arguments.trancode#'
		and (toinv='' or toinv is null) 
		and itemno='#arguments.itemno#' 
		and (linecode <> 'SV' or linecode is null)
		<cfif arguments.location neq "">
			and location = '#arguments.location#' 
		</cfif> 
		and fperiod <> '99' 
		and (void='' or void is null);
	</cfquery>
    
		<cfquery name="getso" datasource="#dts#">
			select 
			(ifnull(sum(qty),0) - ifnull(sum(writeoff),0) - ifnull(sum(shipped),0)) as sumqty 
			from ictran 
			where type='SO' 
			and itemno='#arguments.itemno#' 
			and (linecode <> 'SV' or linecode is null)
			and fperiod <> '99' 
			<cfif arguments.location neq "">
				and location = '#arguments.location#' 
			</cfif> 
			and (void='' or void is null) 
			and (toinv='' or toinv is null);
		</cfquery>
		
		<cfset object.availonhand = itembal + inqty - outqty - doqty - val(getso.sumqty) + val(getthisbill.qty)>
	
	<cfreturn object>
</cffunction>


<cffunction name="generateserialno">
	<cfargument name="startserialno" required="yes" type="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="location" required="yes" type="string">
	<cfargument name="wos_date" required="yes" type="string">
	<cfargument name="qty" required="yes" type="numeric">
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
	
	<cfif arguments.wos_date neq "">
		<cfset date1 = createDate(ListGetAt(arguments.wos_date,3,"/"),ListGetAt(arguments.wos_date,2,"/"),ListGetAt(arguments.wos_date,1,"/"))>
	</cfif>
	<cfset status = "">
	<cfset counter = 0>
	<cfloop condition="counter lt arguments.qty">
		<cfquery name="getinfo" datasource="#dts#">
			select * from iserial
	    	where itemno = '#arguments.itemno#'
			and serialno='#arguments.startserialno#'
			limit 1
		</cfquery>
		<cfif getinfo.recordcount neq 0>
			<!--- Remark on 131108 --->
			<!--- <cfset serialnocnt = len(arguments.startserialno)>
			<cfset cnt = 0>
			<cfset yes = 0>

			<cfloop condition = "cnt lte serialnocnt and yes eq 0">
				<cfset cnt = cnt + 1>
				<cfif isnumeric(mid(arguments.startserialno,cnt,1))>
					<cfset yes = 1>
				</cfif>
			</cfloop>

			<cfset nolen = serialnocnt - cnt + 1>
	
			<cftry>
				<cfset nextno = right(arguments.startserialno,nolen) + 1>
				<cfcatch type="any">
					<cfset c = len(listlast(arguments.startserialno,"/"))>
					<cfset v = "0">
					<cfloop from="2" to="#c#" index="a">
						<cfset v = v&"0">
					</cfloop>
					<cfset a = numberformat(right(arguments.startserialno,4) + 1,v)>
					<cfset nextno = listfirst(arguments.startserialno,"/")&"/"&a>
				</cfcatch>
			</cftry>

			<cfset nocnt = 1>
			<cfset zero = "">

			<cfloop condition = "nocnt lte nolen">
				<cfset zero = zero & "0">
				<cfset nocnt = nocnt + 1>
			</cfloop>
			<cfif cnt gt 1>
				<cfset nextserialno = left(arguments.startserialno,cnt-1)&numberformat(nextno,zero)>
			
			<cfelse>
				<cftry>
					<cfset nextserialno = numberformat(nextno,zero)>
					<cfcatch type="any">
					<cfset nextserialno = nextno>
					</cfcatch>
				</cftry>
			</cfif>
			<cfset arguments.startserialno = nextserialno> --->
			<!--- Add on 131108 --->
			<cfset nextno="">
			<cfset onLen=len(arguments.startserialno)>
			<cfset nf="">
			
			<cfloop from="1" to="#onLen#" index="i">
				<cfif Not isValid("regex", right(arguments.startserialno,i), "^{0,1}[0-9]+[\d]*")>
					<cfset nextno=i-1>
					<cfbreak>
				<cfelse>
					<cfset nf=nf&"0">	<!--- NumberFormat --->
				</cfif>
			</cfloop>
			
			<cfif len(nf) eq len(arguments.startserialno)>
				<cfset nextno = NumberFormat(arguments.startserialno+1,nf)>
			<cfelse>
				<cfif nextno neq 0>
					<cfset nextno=left(arguments.startserialno,(onLen-nextno))&NumberFormat(right(arguments.startserialno,nextno)+1,nf)>
				</cfif>
			</cfif>
			<cfset arguments.startserialno = nextno>
		<cfelse>
			<cfquery name="insert" datasource="#dts#">
				insert into iserial
				(type,refno,trancode,itemno,<cfif wos_date neq "">wos_date,</cfif>serialno,location,sign)
				values
				('ADD','000000',1,'#arguments.itemno#',<cfif arguments.wos_date neq "">#date1#,</cfif>'#arguments.startserialno#','#arguments.location#','1')
			</cfquery>
			
			<!--- Remark on 131108 --->
			<!--- <cfset serialnocnt = len(arguments.startserialno)>
			<cfset cnt = 0>
			<cfset yes = 0>

			<cfloop condition = "cnt lte serialnocnt and yes eq 0">
				<cfset cnt = cnt + 1>
				<cfif isnumeric(mid(arguments.startserialno,cnt,1))>
					<cfset yes = 1>
				</cfif>
			</cfloop>

			<cfset nolen = serialnocnt - cnt + 1>
	
			<cftry>
				<cfset nextno = right(arguments.startserialno,nolen) + 1>
				<cfcatch type="any">
					<cfset c = len(listlast(arguments.startserialno,"/"))>
					<cfset v = "0">
					<cfloop from="2" to="#c#" index="a">
						<cfset v = v&"0">
					</cfloop>
					<cfset a = numberformat(right(arguments.startserialno,4) + 1,v)>
					<cfset nextno = listfirst(arguments.startserialno,"/")&"/"&a>
				</cfcatch>
			</cftry>

			<cfset nocnt = 1>
			<cfset zero = "">

			<cfloop condition = "nocnt lte nolen">
				<cfset zero = zero & "0">
				<cfset nocnt = nocnt + 1>
			</cfloop>
			<cfif cnt gt 1>
				<cfset nextserialno = left(arguments.startserialno,cnt-1)&numberformat(nextno,zero)>
			
			<cfelse>
				<cftry>
					<cfset nextserialno = numberformat(nextno,zero)>
					<cfcatch type="any">
					<cfset nextserialno = nextno>
					</cfcatch>
				</cftry>
			</cfif>
			<cfset arguments.startserialno = nextserialno> --->
			
			<!--- Add on 131108 --->
			<cfset nextno="">
			<cfset onLen=len(arguments.startserialno)>
			<cfset nf="">
			
			<cfloop from="1" to="#onLen#" index="i">
				<cfif Not isValid("regex", right(arguments.startserialno,i), "^{0,1}[0-9]+[\d]*")>
					<cfset nextno=i-1>
					<cfbreak>
				<cfelse>
					<cfset nf=nf&"0">	<!--- NumberFormat --->
				</cfif>
			</cfloop>
			
			<cfif len(nf) eq len(arguments.startserialno)>
				<cfset nextno = NumberFormat(arguments.startserialno+1,nf)>
			<cfelse>
				<cfif nextno neq 0>
					<cfset nextno=left(arguments.startserialno,(onLen-nextno))&NumberFormat(right(arguments.startserialno,nextno)+1,nf)>
				</cfif>
			</cfif>
			<cfset arguments.startserialno = nextno>
			<cfset counter = counter + 1>
		</cfif>
	</cfloop>
	<cfreturn status>
</cffunction>

<cffunction name="getprice">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="location" required="yes" type="string">
	<cfargument name="type" required="yes" type="string">
	<cfargument name="refno3" required="yes" type="string">
	<cfargument name="currrate" required="yes" type="string">
	<cfargument name="bcurr" required="yes" type="string">
	<cfargument name="custno" required="yes" type="string">
	<cfargument name="readperiod" required="yes" type="string">
	
	<cfset object = CreateObject("Component","cfobject")>
	<cfset arguments.itemno = URLDecode(arguments.itemno)>

	<cfquery name="getitembal" datasource="#dts#">
		select * from icitem 
		where itemno='#arguments.itemno#'
	</cfquery>
	
	<cfif arguments.location neq "">
		<cfquery name="getforeign" datasource="#dts#">
			select FOREIGNLOC,CURRCODE from iclocation where location = '#arguments.location#'
		</cfquery>
		<cfif val(getforeign.FOREIGNLOC) neq 0>
			<cfif arguments.type eq "RC" or arguments.type eq "PO" or arguments.type eq "PR">
				<cfquery name="getrecommendprice" datasource="#dts#">
					select * from icl3p 
					where itemno='#arguments.itemno#' 
					and custno='#arguments.custno#'
				</cfquery>

				<cfif getrecommendprice.recordcount gt 0>
					<cfset object.price = getrecommendprice.price>
				<cfelse>
					<cfif val(arguments.currrate) neq 0>
						<cfset object.price = getitembal.ucost/val(arguments.currrate)>
					<cfelse>
						<cfset object.price = getitembal.ucost>
					</cfif>
				</cfif>
			<cfelse>
				<!-- Get The Foreign Location Currency Rate --->
				<cfquery name="currency" datasource="#dts#">
  					select * from #target_currency# 
					where currcode='#getforeign.currcode#'
				</cfquery>
				<cfif val(arguments.readperiod) gt 18 or val(arguments.readperiod) lte 0>
					<cfset rate2 = currency.currrate>
				<cfelse>
					<cfset counter = val(arguments.readperiod)>
					<cfset rate2 = Evaluate("currency.currp#counter#")>
				</cfif>
				
				<cfset price = Evaluate("getitembal.remark#getforeign.FOREIGNLOC#")>
				<cfif price eq "">
					<cfset object.price = 0>
				<cfelse>
					<cfif val(arguments.currrate) neq 0>
						<cfset object.price = (val(price) * val(rate2)) /val(arguments.currrate)>
					<cfelse>
						<cfset object.price = val(price)>
					</cfif>
				</cfif>
			</cfif>
		<cfelse>
			<cfif arguments.type eq "RC" or arguments.type eq "PO" or arguments.type eq "PR">
				<cfquery name="getrecommendprice" datasource="#dts#">
					select * from icl3p 
					where itemno='#arguments.itemno#' 
					and custno='#arguments.custno#'
				</cfquery>

				<cfif getrecommendprice.recordcount gt 0>
					<cfset object.price = getrecommendprice.price>
				<cfelse>
					<cfif val(arguments.currrate) neq 0>
						<cfset object.price = getitembal.ucost/val(arguments.currrate)>
					<cfelse>
						<cfset object.price = getitembal.ucost>
					</cfif>
				</cfif>
			<cfelse>
				<cfquery name="getrecommendprice" datasource="#dts#">
					select * from icl3p2 
					where itemno='#arguments.itemno#' 
					and custno='#arguments.custno#'
				</cfquery>

				<cfif getrecommendprice.recordcount gt 0>
					<cfset object.price = getrecommendprice.price>
				<cfelse>
					<cfif arguments.bcurr neq arguments.refno3>
						<cfif val(arguments.currrate) neq 0>
							<cfset object.price = getitembal.price / val(arguments.currrate)>
						<cfelse>
							<cfset object.price = getitembal.price>
						</cfif>
					<cfelse>
						<cfset object.price = getitembal.price>
					</cfif>
				</cfif>
			</cfif>
			
		</cfif>
	<cfelse>
		<cfif arguments.type eq "RC" or arguments.type eq "PO" or arguments.type eq "PR">
			<cfquery name="getrecommendprice" datasource="#dts#">
				select * from icl3p 
				where itemno='#arguments.itemno#' 
				and custno='#arguments.custno#'
			</cfquery>

			<cfif getrecommendprice.recordcount gt 0>
				<cfset object.price = getrecommendprice.price>
			<cfelse>
				<cfif val(arguments.currrate) neq 0>
					<cfset object.price = getitembal.ucost/val(arguments.currrate)>
				<cfelse>
					<cfset object.price = getitembal.ucost>
				</cfif>
			</cfif>
		<cfelse>
			<cfquery name="getrecommendprice" datasource="#dts#">
				select * from icl3p2 
				where itemno='#arguments.itemno#' 
				and custno='#arguments.custno#'
			</cfquery>

			<cfif getrecommendprice.recordcount gt 0>
				<cfset object.price = getrecommendprice.price>
			<cfelse>
				<cfif arguments.bcurr neq arguments.refno3>
					<cfif val(arguments.currrate) neq 0>
						<cfset object.price = getitembal.price / val(arguments.currrate)>
					<cfelse>
						<cfset object.price = getitembal.price>
					</cfif>
				<cfelse>
					<cfset object.price = getitembal.price>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	
	<cfreturn object>
</cffunction>

<cffunction name="getCustSuppDetails">
	<cfargument name="tablename" required="yes" type="string">
	<cfargument name="columnvalue" required="yes" type="string">
	<cfargument name="tran" required="yes" type="string">
	<cfset object = CreateObject("Component","cfobject")>
	
    <cfif arguments.tran eq 'SAM'>
    <cfquery name="getInfo" datasource="#dts#">
		select custno,name,name2,add1,add2,add3,add4,ngst_cust,taxcode,attn,phone,fax,term,agent,contact,currcode,phonea,e_mail,taxincl_cust,country,postalcode,daddr1,daddr2,daddr3,daddr4,dattn,dphone,dfax,d_country,d_postalcode,end_user,dispec1,dispec2,dispec3 from #target_apvend#
		where custno = '#arguments.columnvalue#'
        union all
        select custno,name,name2,add1,add2,add3,add4,ngst_cust,taxcode,attn,phone,fax,term,agent,contact,currcode,phonea,e_mail,taxincl_cust,country,postalcode,daddr1,daddr2,daddr3,daddr4,dattn,dphone,dfax,d_country,d_postalcode,end_user,dispec1,dispec2,dispec3 from #target_arcust#
		where custno = '#arguments.columnvalue#'
	</cfquery>
    <cfelse>
	<cfquery name="getInfo" datasource="#dts#">
		select * from #arguments.tablename#
		where custno = '#arguments.columnvalue#'
	</cfquery>
    </cfif>
	
	<cfif getInfo.recordcount neq 0>
		<cfset object.b_name = getInfo.name>
		<cfset object.b_name2 = getInfo.name2>
		<cfset object.b_add1 = getInfo.add1>
		<cfset object.b_add2 = getInfo.add2>
		<cfset object.b_add3 = getInfo.add3>
		<cfset object.b_add4 = getInfo.add4>
		<cfset object.b_add5 = "">
		<cfset object.b_attn = getInfo.attn>
		<cfset object.b_phone = getInfo.phone>
        <cfset object.ngst_cust = getInfo.ngst_cust>
		<cfset object.taxcode = getInfo.taxcode>
		<cfset object.b_fax = getInfo.fax>
		<cfset object.term = getInfo.term>
		<cfset object.agent = getInfo.agent>
        <cfset object.dispec1 = getInfo.dispec1>
        <cfset object.dispec2 = getInfo.dispec2>
        <cfset object.dispec3 = getInfo.dispec3>
		<cfset object.currcode = getInfo.currcode>
		<cfset object.b_phone2 = getInfo.phonea>
        <cfset object.b_email = getInfo.e_mail>
		<cfset object.taxincluded = getInfo.taxincl_cust>
		<cfif getInfo.country neq "" and getInfo.postalcode neq "">
			<cfset add5=getInfo.country&" "&getInfo.postalcode>
			<cfif getInfo.add1 eq "">
				<cfset object.b_add1 = add5>
			<cfelseif getInfo.add2 eq "">
				<cfset object.b_add2 = add5>
			<cfelseif getInfo.add3 eq "">
				<cfset object.b_add3 = add5>
			<cfelseif getInfo.add4 eq "">
				<cfset object.b_add4 = add5>
			<cfelse>
				<cfset object.b_add5 = add5>
			</cfif>
		</cfif>
		
		<cfif arguments.tran eq 'PO' or arguments.tran eq 'SO' or arguments.tran eq 'DO' or arguments.tran eq 'INV' or arguments.tran eq 'SAM' or arguments.tran eq 'CT'>
			<cfset object.DCode = "Profile">
			<cfset object.d_name = getInfo.name>
			<cfset object.d_name2 = getInfo.name2>
			<cfset object.d_add1 = getInfo.daddr1>
			<cfset object.d_add2 = getInfo.daddr2>
			<cfset object.d_add3 = getInfo.daddr3>
			<cfset object.d_add4 = getInfo.daddr4>
			<cfset object.d_add5 = "">
			<cfset object.d_attn = getInfo.dattn>
			<cfset object.d_phone = getInfo.dphone>
			<cfset object.d_fax = getInfo.dfax>
            <cfset object.contact = getInfo.contact>
		</cfif>
		
		<cfif getInfo.d_country neq "" and getInfo.d_postalcode neq "">
			<cfset dadd5=getInfo.d_country&" "&getInfo.d_postalcode>
			<cfif getInfo.daddr1 eq "">
				<cfset object.d_add1 = dadd5>
			<cfelseif getInfo.daddr2 eq "">
				<cfset object.d_add2 = dadd5>
			<cfelseif getInfo.daddr3 eq "">
				<cfset object.d_add3 = dadd5>
			<cfelseif getInfo.daddr4 eq "">
				<cfset object.d_add4 = dadd5>
			<cfelse>
				<cfset object.d_add5 = dadd5>
			</cfif>
		</cfif>
		
		<cfset object.agent=getInfo.agent>
		<cfset object.term=getInfo.term>
		<cfset object.end_user=getInfo.end_user>
		<cfset object.currcode=getInfo.currcode>
	<cfelse>
		<cfset object.name = "">
		<cfset object.name2 = "">
		<cfset object.b_add1 = "">
		<cfset object.b_add2 = "">
		<cfset object.b_add3 = "">
		<cfset object.b_add4 = "">
        <cfset object.ngst_cust = "">
		<cfset object.taxcode = "">
		<cfset object.b_attn = "">
		<cfset object.b_phone = "">
		<cfset object.b_fax = "">
		<cfset object.term = "">
		<cfset object.agent = "">
        <cfset object.dispec1 = '0'>
        <cfset object.dispec2 = '0'>
        <cfset object.dispec3 = '0'>
		<cfset object.currcode = "">
		<cfset object.b_phone2 = "">
        <cfset object.b_email = "">
        <cfset object.taxincluded = "">
		
		<cfif arguments.tran eq 'PO' or arguments.tran eq 'SO' or arguments.tran eq 'DO' or arguments.tran eq 'INV' or arguments.tran eq 'CT' or arguments.tran eq 'SAM'>
			<cfset object.DCode = "Profile">
			<cfset object.d_name = "">
			<cfset object.d_name2 = "">
			<cfset object.d_add1 = "">
			<cfset object.d_add2 = "">
			<cfset object.d_add3 = "">
			<cfset object.d_add4 = "">
			<cfset object.d_attn = "">
			<cfset object.d_phone = "">
			<cfset object.d_fax = "">
            <cfset object.contact = "">
		</cfif>
		
		<cfset object.agent= "">
		<cfset object.term= "">
		<cfset object.end_user= "">
		<cfset object.currcode= "">
	</cfif>
	<cfset object.tran = arguments.tran>
    
    <cfquery name="getcurrrate" datasource="#dts#">
    SELECT currrate FROM #target_currency# where currcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#object.currcode#" >
    </cfquery>
    
    <cfif getcurrrate.currrate neq "">
    <cfset object.currrate = getcurrrate.currrate>
    <cfelse>
    <cfset object.currrate = 1>
	</cfif>
	
	<cfreturn object>
</cffunction>

<cffunction name="productlookup" hint="type='keyvalue' jsreturn='array'">
	<cfargument name="inputtext" required="yes" type="string">
	
	<!--- Add On 12-01-2010 --->
	<cfquery name="getdealer_menu" datasource="#dts#">
		select custSuppSortBy,productSortBy,transactionSortBy from dealer_menu limit 1
	</cfquery>
	
	<cfif arguments.inputtext neq "">
		<cfquery name="getItem" datasource="#dts#">
			SELECT itemno,desp FROM icitem
			where itemno like '#arguments.inputtext#%' and (nonstkitem<>'T' or nonstkitem is null)
            <cfif Hitemgroup neq ''>
            and wos_group='#Hitemgroup#'
            </cfif>
			order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="getItem" datasource="#dts#">
			SELECT itemno,desp FROM icitem
			where (nonstkitem<>'T' or nonstkitem is null) 
            <cfif Hitemgroup neq ''>
            and wos_group='#Hitemgroup#'
            </cfif>
			order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
		</cfquery>
	</cfif>
	
	<cfset model = ArrayNew(1)>
	<cfif getItem.recordcount eq 0 or arguments.inputtext eq "">
		<cfset ArrayAppend(model,"-1,Choose an Item")>
	</cfif>
	
	<cfloop query="getItem">
		<cfset ArrayAppend(model,"#itemno#,#itemno# - #desp#")>
	</cfloop>
	
	<cfreturn model>
</cffunction>

<cffunction name="getBatchDetails">
	<cfargument name="location" required="yes" type="string">
	<cfargument name="batchcode" required="yes" type="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="tran" required="yes" type="string">
	<cfset object = CreateObject("Component","cfobject")>
    
    <cfquery name="checkcustom" datasource="#dts#">
    	select customcompany from dealer_menu
    </cfquery>
	
	<cfif trim(arguments.location) neq "">
		<cfquery name="getInfo" datasource="#dts#">
			<cfif lcase(hcomid) eq "remo_i">
				select a.location,a.batchcode,a.itemno,
				a.rc_type,a.rc_refno,((a.bth_qob+a.bth_qin)-a.bth_qut-ifnull(b.soqty,0)) as batch_balance,
				a.expdate as exp_date 
				from lobthob as a 
				left join 
				(
					select 
					batchcode,
					itemno,
					location, 
					sum(qty) as soqty 
					from ictran 
					where type='SO' 
					and itemno= '#arguments.itemno#' 
					and location= '#arguments.location#'
					and batchcode = '#arguments.batchcode#'
					and (qty-shipped)<>0 
					and fperiod<>'99' 
					and (void='' or void is null) 
					group by location,batchcode
					order by location,batchcode
				) as b on a.itemno=b.itemno and a.batchcode=b.batchcode and a.location=b.location
				where a.location= '#arguments.location#'
				and a.itemno= '#arguments.itemno#'
				and a.batchcode = '#arguments.batchcode#'
			<cfelse>
				select 
				batchcode,rc_type,rc_refno,
				((bth_qob+bth_qin)-bth_qut) as batch_balance,
				expdate as exp_date<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif> 
				from lobthob 
				where location= '#arguments.location#'
				and itemno= '#arguments.itemno#' 
				and batchcode = '#arguments.batchcode#'
			</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="getInfo" datasource="#dts#">
			select 
			batchcode,
			rc_type,
			rc_refno,
			((bth_qob+bth_qin)-bth_qut) as batch_balance,
			exp_date<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif> 
			from obbatch 
			where itemno= '#arguments.itemno#'
			and batchcode = '#arguments.batchcode#'
		</cfquery>
	</cfif>
	
	
	<cfif getInfo.recordcount neq 0>
		<cfif getInfo.Exp_date neq "">
			<cfset object.expdate = dateformat(getInfo.Exp_date,"dd-mm-yyyy")>
		<cfelse>
			<cfset object.expdate = getInfo.Exp_date>
		</cfif>
		
		
		<cfif arguments.tran neq 'RC'>
			<cfset object.batchqty = val(getInfo.batch_balance)>
		</cfif>
		
		<cfif checkcustom.customcompany eq "Y">
			<cfset object.permit_no = getInfo.permit_no>
			<cfset object.permit_no2 = getInfo.permit_no2>
		</cfif>
	<cfelse>
		<cfset object.expdate = "">
		
		<cfif arguments.tran neq 'RC'>
			<cfset object.batchqty = "0">
		</cfif>
		
		<cfif checkcustom.customcompany eq "Y">
			<cfset object.permit_no = "">
			<cfset object.permit_no2 = "">
		</cfif>
	</cfif>
	<cfset object.tran = arguments.tran>
	
	<cfreturn object>
</cffunction>

<cffunction name="getJobOrderDetails">
	<cfargument name="joborderno" required="yes" type="string">
	<cfset object = CreateObject("Component","cfobject")>
	
	<cfquery name="getInfo" datasource="#dts#">
		select * from printing_job_order
		where serial = '#arguments.joborderno#'
	</cfquery>
	
	<cfif getInfo.recordcount neq 0>
		<cfset object.itemno = getInfo.itemno>
		<cfset object.ordered_quantity = getInfo.ordered_quantity>
		<cfset object.ordered_size = getInfo.ordered_size>
		<cfset object.ordered_color = getInfo.ordered_color>
		<cfset object.folded_size = getInfo.folded_size>
		<cfset object.number = getInfo.number>
		<cfset object.number_in_color = getInfo.number_in_color>
		<cfset object.estimated_cost = getInfo.estimated_cost>
		<cfset object.total_cost = getInfo.total_cost>
		<cfset object.margin = getInfo.margin>
		<cfset object.selling_cost = getInfo.selling_cost>
		<cfset object.unit_price = getInfo.unit_price>
		<cfset object.quoted_price = getInfo.quoted_price>
		<cfset object.quoted_selling = getInfo.quoted_selling>
		<cfset object.decided_estimated_cost = getInfo.decided_estimated_cost>
		<cfset object.sum_estimated_cost1 = getInfo.sum_estimated_cost1>
		<cfset object.sum_estimated_cost2 = getInfo.sum_estimated_cost2>
        
       	<cfloop from="1" to="10" index="i">     	
			<cfset "object.paper#i#"=getInfo["paper#i#"][getInfo.currentrow]>
			<cfset "object.size#i#"=getInfo["size#i#"][getInfo.currentrow]>
			<cfset "object.open_size#i#"=getInfo["open_size#i#"][getInfo.currentrow]>
			<cfset "object.paper_status#i#"=getInfo["paper_status#i#"][getInfo.currentrow]>
			<cfset "object.qty#i#"=getInfo["qty#i#"][getInfo.currentrow]>
			<cfset "object.signature#i#"=getInfo["signature#i#"][getInfo.currentrow]>
			<cfset "object.paper_color#i#"=getInfo["paper_color#i#"][getInfo.currentrow]>
			<cfset "object.paper_price#i#"=getInfo["paper_price#i#"][getInfo.currentrow]>
			<cfset "object.paper_work_sheeta#i#"=getInfo["paper_work_sheeta#i#"][getInfo.currentrow]>
			<cfset "object.paper_estimated_costa#i#"=getInfo["paper_estimated_costa#i#"][getInfo.currentrow]>
			<cfset "object.paper_work_sheetb#i#"=getInfo["paper_work_sheetb#i#"][getInfo.currentrow]>
			<cfset "object.paper_estimated_costb#i#"=getInfo["paper_estimated_costb#i#"][getInfo.currentrow]>
			<cfset "object.paper_remark#i#"=getInfo["paper_remark#i#"][getInfo.currentrow]>
		</cfloop>
		
		<cfquery name="getCost" datasource="#dts#">
			select * from printing_cost_calculation
			where serial = '#arguments.joborderno#'
			order by step_no
		</cfquery>
		
		<cfif getCost.recordcount neq 0>
			<cfset costlist=valuelist(getCost.step_no)>
			<cfloop query="getCost">
				<cfset xstep=getCost.step_no>
				<cfset "object.supplier#xstep#" = getCost.SUPPLIER>
				<cfset "object.process_code#xstep#" = getCost.PROCESS_CODE>
				<cfset "object.work_sheet#xstep#" = getCost.WORK_SHEET>
				<cfset "object.estimated_cost1#xstep#" = getCost.ESTIMATED_COST1>
				<cfset "object.work_sheetb#xstep#" = getCost.WORK_SHEETB>
				<cfset "object.estimated_cost2#xstep#" = getCost.ESTIMATED_COST2>
				<cfset "object.remark#xstep#" = getCost.PROCESS_REMARK>
				<cfset "object.vendor_work_sheet#xstep#" = getCost.VENDOR_WORK_SHEET>
				<cfset "object.estimated_vendor_cost1#xstep#" = getCost.ESTIMATED_VENDOR_COST1>
				<cfset "object.vendor_work_sheetb#xstep#" = getCost.VENDOR_WORK_SHEETB>
				<cfset "object.estimated_vendor_cost2#xstep#" = getCost.ESTIMATED_VENDOR_COST2>
				<cfset "object.vendor_remark#xstep#" = getCost.VENDOR_PROCESS_REMARK>
			</cfloop>
			<cfloop from="1" to="40" index="a">
				<cfif ListFindNoCase(costlist, a , ",") eq 0>
					<cfset "object.supplier#a#" = "">
					<cfset "object.process_code#a#" = "">
					<cfset "object.work_sheet#a#" = "">
					<cfset "object.estimated_cost1#a#" = "">
					<cfset "object.work_sheetb#a#" = "">
					<cfset "object.estimated_cost2#a#" = "">
					<cfset "object.remark#a#" = "">
					<cfset "object.vendor_work_sheet#a#" = "">
					<cfset "object.estimated_vendor_cost1#a#" = "">
					<cfset "object.vendor_work_sheetb#a#" = "">
					<cfset "object.estimated_vendor_cost2#a#" = "">
					<cfset "object.vendor_remark#a#" = "">
				</cfif>
			</cfloop>
		</cfif>
	<cfelse>
		<cfset object.itemno = "">
		<cfset object.ordered_quantity = "">
		<cfset object.ordered_size = "">
		<cfset object.ordered_color = "">
		<cfset object.folded_size = "">
		<cfset object.number = "">
		<cfset object.number_in_color = "">
			<cfloop from="1" to="10" index="i">     	
			<cfset "object.paper#i#"="">
			<cfset "object.size#i#"="">
			<cfset "object.open_size#i#"="">
			<cfset "object.paper_status#i#"="">
			<cfset "object.qty#i#"="">
			<cfset "object.signature#i#"="">
			<cfset "object.paper_color#i#"="">
			<cfset "object.paper_price#i#"="">
			<cfset "object.paper_work_sheeta#i#"="">
			<cfset "object.paper_estimated_costa#i#"="">
			<cfset "object.paper_work_sheetb#i#"="">
			<cfset "object.paper_estimated_costb#i#"="">
			<cfset "object.paper_remark#i#"="">
		</cfloop>
		<cfloop from="1" to="40" index="a">
			<cfset "object.supplier#a#" = "">
			<cfset "object.process_code#a#" = "">
			<cfset "object.work_sheet#a#" = "">
			<cfset "object.estimated_cost1#a#" = "">
			<cfset "object.work_sheetb#a#" = "">
			<cfset "object.estimated_cost2#a#" = "">
			<cfset "object.remark#a#" = "">
			<cfset "object.vendor_work_sheet#a#" = "">
			<cfset "object.estimated_vendor_cost1#a#" = "">
			<cfset "object.vendor_work_sheetb#a#" = "">
			<cfset "object.estimated_vendor_cost2#a#" = "">
			<cfset "object.vendor_remark#a#" = "">
		</cfloop>
	</cfif>
	
	<cfreturn object>
</cffunction>

<cffunction name="getTitleDesp">
	<cfargument name="titleid" required="yes" type="string">
		
	<cfset object = CreateObject("Component","cfobject")>
	<cfset arguments.titleid = URLDecode(arguments.titleid)>
	
	<cfif arguments.titleid neq "">
		<cfquery name="gettitle" datasource="#dts#">
			select desp from title where title_id='#arguments.titleid#'
		</cfquery>
		<cfset object.titledesp = gettitle.desp>
	<cfelse>
		<cfset object.titledesp = "">
	</cfif>
	
	<cfreturn object>
</cffunction>

<cffunction name="checkLotNumberExist">
	<cfargument name="batchcode" required="yes" type="string">
	<cfargument name="obatchcode" required="yes" type="string">
		
	<cfset object = CreateObject("Component","cfobject")>
	
	<cfif arguments.batchcode neq "">
		<cfquery name="check" datasource="#dts#">
			select * from lotnumber  
			where LotNumber <> '#arguments.obatchcode#'
			and LotNumber = '#arguments.batchcode#'
		</cfquery>
		<cfif check.recordcount gt 0>
			<cfset object.existence = "yes">
		<cfelse>
			<cfset object.existence = "no">
		</cfif>
	<cfelse>
		<cfset object.existence = "no">
	</cfif>
	
	<cfreturn object>
</cffunction>

<cffunction name="checkpassword">
	<cfargument name="password" required="yes" type="string">
	
	<cfif arguments.password neq "">
		<cfquery name="check" datasource="#dts#">
			select password 
			from dealer_menu
			where password = '#arguments.password#'
		</cfquery>
		<cfif check.recordcount gt 0>
			<cfset msg = "">
		<cfelse>
			<cfset msg = "Wrong Password !">
		</cfif>
	<cfelse>
		<cfset msg = "Please Enter Security Code !">
	</cfif>
	
	<cfreturn msg>
</cffunction>

<cffunction name="supplierlookup" hint="type='keyvalue' jsreturn='array'">
	<cfargument name="inputtext" required="yes" type="string">
	<cfargument name="option" required="yes" type="string">
	
	<!--- Add On 11-01-2010 --->
	<cfquery name="getdealer_menu" datasource="#dts#">
		select custSuppSortBy,productSortBy,transactionSortBy from dealer_menu limit 1
	</cfquery>
	
	<cfif arguments.inputtext neq "">
		<!--- <cfquery name="getsupp" datasource="#dts#">
	    	select custno,name from <cfif arguments.option eq "Supplier">#target_apvend#<cfelse>#target_arcust#</cfif> 
			where name like '#arguments.inputtext#%'
	            
	        union
	            
	       	select custno,name from <cfif arguments.option eq "Supplier">#target_apvend#<cfelse>#target_arcust#</cfif> 
			where custno like '#arguments.inputtext#%'
	            
			ORDER BY <cfif lcase(HcomID) eq "iel_i" or lcase(HcomID) eq "ielm_i">custno,name<cfelse>name,custno</cfif>
			<cfif lcase(HcomID) eq "englishcorner_i">LIMIT 20</cfif>
		</cfquery> --->
		<cfquery name="getsupp" datasource="#dts#">
	    	select custno,name from <cfif arguments.option eq "Supplier">#target_apvend#<cfelse>#target_arcust#</cfif> 
			where name like '#arguments.inputtext#%'
	            
	        union
	            
	       	select custno,name from <cfif arguments.option eq "Supplier">#target_apvend#<cfelse>#target_arcust#</cfif> 
			where custno like '#arguments.inputtext#%'
	            
			ORDER BY <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno,name</cfif>
			<cfif lcase(HcomID) eq "englishcorner_i">LIMIT 20</cfif>
		</cfquery>
	<cfelse>
		<!--- <cfquery name="getsupp" datasource="#dts#">
    		select custno,name from <cfif arguments.option eq "Supplier">#target_apvend#<cfelse>#target_arcust#</cfif>
			ORDER BY <cfif lcase(HcomID) eq "iel_i" or lcase(HcomID) eq "ielm_i">custno,name<cfelse>name,custno</cfif>
			<cfif lcase(HcomID) eq "englishcorner_i">LIMIT 20</cfif>
		</cfquery> --->
		<cfquery name="getsupp" datasource="#dts#">
    		select custno,name from <cfif arguments.option eq "Supplier">#target_apvend#<cfelse>#target_arcust#</cfif>
			ORDER BY <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno,name</cfif>
			<cfif lcase(HcomID) eq "englishcorner_i">LIMIT 20</cfif>
		</cfquery>
	</cfif>
	<cfset model = ArrayNew(1)>
	<cfif getsupp.recordcount eq 0 or arguments.inputtext eq "">
		<cfset ArrayAppend(model," ,Choose a #arguments.option#")>
	</cfif>
	
	<cfloop query="getsupp">
		<cfif lcase(HcomID) eq "glenn_i" or lcase(HcomID) eq "glenndemo_i">
			<cfset ArrayAppend(model,"#custno#,#name# - #custno#")>
		<cfelse>
			<cfset ArrayAppend(model,"#custno#,#custno# - #name#")>
		</cfif>
	</cfloop>
	
	<cfreturn model>
</cffunction>



<cffunction name="vehiclelookup" hint="type='keyvalue' jsreturn='array'">
	<cfargument name="inputtext" required="yes" type="string">
	
	<cfif arguments.inputtext neq "">
		
		<cfquery name="getvehicle" datasource="#dts#">
	    	select entryno
			from vehicles
			where entryno like '%#arguments.inputtext#%'
		</cfquery>
	<cfelse>
		<cfquery name="getvehicle" datasource="#dts#">
    		select entryno
			from vehicles
		</cfquery>
	</cfif>
    
	<cfset model = ArrayNew(1)>
	<cfif getvehicle.recordcount eq 0 or arguments.inputtext eq "">
		<cfset ArrayAppend(model," ,Choose a Vehicle")>
	</cfif>
	
	<cfloop query="getvehicle">
			<cfset ArrayAppend(model,"#entryno#,#entryno#")>
	</cfloop>
	
	<cfreturn model>
</cffunction>

<cffunction name="getComment">
	<cfargument name="commentcode" required="yes" type="string">
		
	<cfset object = CreateObject("Component","cfobject")>
	<cfset arguments.commentcode = URLDecode(arguments.commentcode)>
	
	<cfif arguments.commentcode neq "">
		<cfquery name="getComment" datasource="#dts#">
			select details from comments where code='#arguments.commentcode#'
		</cfquery>
		<cfset object.commentdetails = tostring(getComment.details)>
	<cfelse>
		<cfset object.commentdetails = "">
	</cfif>
	
	<cfreturn object>
</cffunction>

<cffunction name="updatetax">
	<cfargument name="tran" required="yes" type="string">
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="taxincl" required="yes" type="string">
	
	<cfset object = CreateObject("Component","cfobject")>
	
	<cfquery name="updatebodytax" datasource="#dts#">
		update ictran
		set taxamt_bil=
		<cfif arguments.taxincl eq "T">
			round((taxpec1/(100+taxpec1)*amt_bil),2)
		<cfelse>
			round((taxpec1/(100)*amt_bil),2)
		</cfif>,
		taxamt=
		<cfif arguments.taxincl eq "T">
			round((taxpec1/(100+taxpec1)*amt),2)
		<cfelse>
			round((taxpec1/(100)*amt),2)
		</cfif>
		where type='#arguments.tran#' and refno='#arguments.refno#'
	</cfquery>
	
	<cfquery name="gettax" datasource="#dts#">
		select sum(taxamt_bil) as ttaxamt_bil,sum(taxamt) as ttaxamt
		from ictran
		where type='#arguments.tran#' and refno='#arguments.refno#'
	</cfquery>
	
	<cfset object.ttaxamt_bil = val(gettax.ttaxamt_bil)>
	<cfset object.ttaxamt = val(gettax.ttaxamt)>
	
	<cfreturn object>
</cffunction>

<cffunction name="deleteiclink">
	<cfargument name="tran" required="yes" type="string">
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="string">
	<cfargument name="frtran" required="yes" type="string">
	<cfargument name="frrefno" required="yes" type="string">
	<cfargument name="frtrancode" required="yes" type="string">
	<cfargument name="itemqty" required="yes" type="string">
	<cfargument name="currentrow" required="yes" type="string">
	
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
	<cfset object = CreateObject("Component","cfobject")>
	
	<cfquery name="delete" datasource="#dts#">
		delete from iclink 
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#">
		and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#">
		and trancode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.trancode#">
	</cfquery>
	
	<cfquery name="recoverartran" datasource="#dts#">
		update artran set toinv = '', order_cl = '', exported = '', exported1 = '0000-00-00' 
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frtran#"> 
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frrefno#">
	</cfquery>
	
	<cfquery name="getship" datasource="#dts#">
		select shipped from ictran 
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frtran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frrefno#"> 
		and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#"> 
		and trancode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frtrancode#">
	</cfquery>
	
	<cfset itemqty=arguments.itemqty>
	<cfif getship.recordcount gt 0>
		<cfset oldshipped = getship.shipped>

		<cfif arguments.tran eq "PO"><!--- SO to PO no minus shipped --->
			<cfset newshipped = oldshipped>
		<cfelse>
			<cfset newshipped = oldshipped - itemqty>
		</cfif>

		<cfquery name="recoverictran" datasource='#dts#'>
			update ictran set toinv = '', exported = '', exported1 = '0000-00-00', shipped = '#newshipped#' 
			where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frtran#">
			and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frrefno#"> 
			and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#"> 
			and trancode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frtrancode#">
		</cfquery>
						
		<cfquery name="recoverigrade" datasource="#dts#">
			update igrade set exported = '',generated='' 
			where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frtran#">
			and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frrefno#"> 
			and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#"> 
			and trancode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.frtrancode#">
		</cfquery>
	</cfif>
	
	<cfset object.tran = arguments.tran>
	<cfset object.refno = arguments.refno>
	<cfset object.drow = arguments.currentrow>
	<cfset object.trancode = arguments.trancode>
	
	<cfreturn object>
</cffunction>

<cffunction name="generateQuoRev">
	<cfargument name="tran" required="yes" type="string">
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="revStyle" required="yes" type="string">
	
	<cfset object = CreateObject("Component","cfobject")>
	<cfset object.error="">
	
	<cfquery name="getartran" datasource="#dts#">
		select * from artran 
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#"> 
	</cfquery>
	
	<cfquery name="getictran" datasource="#dts#">
		select * from ictran 
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#"> 
	</cfquery>
	
	<cfquery name="getiserial" datasource="#dts#">
		select * from iserial 
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#"> 
	</cfquery>
	
	<cfquery name="getigrade" datasource="#dts#">
		select * from igrade 
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#"> 
	</cfquery>
	
	<cfif getartran.old_refno eq "">
		<cfset thisrefno=arguments.refno>
	<cfelse>
		<cfset thisrefno=getartran.old_refno>
	</cfif>
	<cfset newRev=getartran.Revision+1>
	<cfset newrefno=thisrefno&arguments.revStyle&newRev>
	<cfset thisdate=CreateDate(year(now()),month(now()),day(now()))>
	
	<cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">
		<cfif getartran.rem9 neq "">
			<cfset getartran.rem9=lsdateformat(getartran.rem9,"yyyy-mm-dd")>
		<cfelse>
			<cfset getartran.rem9='0000-00-00'>
		</cfif>
		<cfif getartran.rem11 neq "">
            <cfset getartran.rem11=lsdateformat(getartran.rem11,"yyyy-mm-dd")>
		<cfelse>
			<cfset getartran.rem11='0000-00-00'>
		</cfif>
	</cfif>
	<cfif getartran.trdatetime neq "" and getartran.trdatetime neq "0000-00-00 00:00:00">
		<cfset thistrdatetime=CreateDateTime(year(getartran.trdatetime),month(getartran.trdatetime),day(getartran.trdatetime),hour(getartran.trdatetime),minute(getartran.trdatetime),second(getartran.trdatetime))>
	</cfif>
	
	<cftry>
		<cfquery name="insertartran" datasource="#dts#">
			INSERT INTO `artran` 
			(`TYPE`,`REFNO`,`REFNO2`,`OLD_REFNO`,`REVISION`,`TRANCODE`,`CUSTNO`,`FPERIOD`,`WOS_DATE`,
			`DESP`,`DESPA`,`AGENNO`,`AREA`,`SOURCE`,`JOB`,`CURRRATE`,`GROSS_BIL`,`DISC1_BIL`,
			`DISC2_BIL`,`DISC3_BIL`,`DISC_BIL`,`NET_BIL`,`TAX1_BIL`,`TAX2_BIL`,`TAX3_BIL`,`TAX_BIL`,`GRAND_BIL`,
			`DEBIT_BIL`,`CREDIT_BIL`,`INVGROSS`,`DISP1`,`DISP2`,`DISP3`,`DISCOUNT1`,`DISCOUNT2`,`DISCOUNT3`,
			`DISCOUNT`,`NET`,`TAX1`,`TAX2`,`TAX3`,`TAX`,`TAXP1`,`TAXP2`,`TAXP3`,
			`GRAND`,`DEBITAMT`,`CREDITAMT`,`MC1_BIL`,`MC2_BIL`,`M_CHARGE1`,`M_CHARGE2`,`CS_PM_CASH`,`CS_PM_CHEQ`,
			`CS_PM_CRCD`,`CS_PM_CRC2`,<cfif isdefined("getartran.cs_pm_tt")>`CS_PM_TT`,</cfif>`CS_PM_DBCD`,`CS_PM_VOUC`,`DEPOSIT`,`CS_PM_DEBT`,`CS_PM_WHT`,`CHECKNO`,
			`IMPSTAGE`,`BILLCOST`,`BILLSALE`,`PAIDDATE`,`PAIDAMT`,`REFNO3`,`AGE`,`NOTE`,`TERM`,
			`ISCASH`,`VAN`,`DEL_BY`,`PLA_DODATE`,`ACT_DODATE`,`URGENCY`,`CURRRATE2`,`STAXACC`,`SUPP1`,
			`SUPP2`,`PONO`,`DONO`,`REM0`,`REM1`,`REM2`,`REM3`,`REM4`,`REM5`,
			`REM6`,`REM7`,`REM8`,`REM9`,`REM10`,`REM11`,`REM12`,`FREM0`,`FREM1`,
			`FREM2`,`FREM3`,`FREM4`,`FREM5`,`FREM6`,`FREM7`,`FREM8`,`FREM9`,`COMM1`,
			`COMM2`,`COMM3`,`COMM4`,`ID`,`GENERATED`,`TOINV`,`ORDER_CL`,`EXPORTED`,`EXPORTED1`,
			`EXPORTED2`,`EXPORTED3`,`LAST_YEAR`,`POSTED`,`PRINTED`,`LOKSTATUS`,`VOID`,`NAME`,`PHONEA`,
			`PONO2`,`DONO2`,`CSGTRANS`,`TAXINCL`,`TABLENO`,`CASHIER`,`MEMBER`,`COUNTER`,`TOURGROUP`,
			`TRDATETIME`,`TIME`,`XTRCOST`,`XTRCOST2`,`POINT`,`USERID`,`BPERIOD`,`VPERIOD`,`BDATE`,
			`CURRCODE`,`COMM0`,`REM13`,`REM14`,`MC3_BIL`,`MC4_BIL`,`MC5_BIL`,`MC6_BIL`,`MC7_BIL`,
			`M_CHARGE3`,`M_CHARGE4`,`M_CHARGE5`,`M_CHARGE6`,`M_CHARGE7`,`SPECIAL_ACCOUNT_CODE`,`CREATED_BY`,`UPDATED_BY`,`CREATED_ON`,
			`UPDATED_ON`,`IRAS_POSTED`,`termscondition`,`permitno`,`rem30`,`rem31`,`rem32`,`rem33`,`rem34`,`rem35`,`rem36`,`rem37`,`rem38`,`rem39`,`rem40`,`rem41`,`rem42`,`rem43`,`rem44`,`rem45`,`rem46`,`rem47`,`rem48`,`rem49`) 
			VALUES 
			('#arguments.tran#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#newrefno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.refno2#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#thisrefno#">,'#newRev#','#getartran.trancode#',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.custno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.fperiod#">,#thisdate#,
			
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.desp#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.despa#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.agenno#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.area#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.source#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.job#">,
			'#val(getartran.currrate)#','#val(getartran.gross_bil)#','#val(getartran.disc1_bil)#',
			
			'#val(getartran.disc2_bil)#','#val(getartran.disc3_bil)#','#val(getartran.disc_bil)#','#val(getartran.net_bil)#','#val(getartran.tax1_bil)#',
			'#val(getartran.tax2_bil)#','#val(getartran.tax3_bil)#','#val(getartran.tax_bil)#','#val(getartran.grand_bil)#',
			
			'#val(getartran.debit_bil)#','#val(getartran.credit_bil)#','#val(getartran.invgross)#','#val(getartran.disp1)#','#val(getartran.disp2)#',
			'#val(getartran.disp3)#','#val(getartran.discount1)#','#val(getartran.discount2)#','#val(getartran.discount3)#',
			
			'#val(getartran.discount)#','#val(getartran.net)#','#val(getartran.tax1)#','#val(getartran.tax2)#','#val(getartran.tax3)#',
			'#val(getartran.tax)#','#val(getartran.taxp1)#','#val(getartran.taxp2)#','#val(getartran.taxp3)#',
			
			'#val(getartran.grand)#','#val(getartran.debitamt)#','#val(getartran.creditamt)#','#val(getartran.mc1_bil)#','#val(getartran.mc2_bil)#',
			'#val(getartran.m_charge1)#','#val(getartran.m_charge2)#','#val(getartran.cs_pm_cash)#','#val(getartran.cs_pm_cheq)#',
			
			'#val(getartran.cs_pm_crcd)#','#val(getartran.cs_pm_crc2)#',
			<cfif isdefined("getartran.cs_pm_tt")>'#val(getartran.cs_pm_tt)#',</cfif>
			'#val(getartran.cs_pm_dbcd)#',
			'#val(getartran.cs_pm_vouc)#','#val(getartran.deposit)#','#val(getartran.cs_pm_debt)#','#val(getartran.cs_pm_wht)#',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.checkno#">,
			
			'#getartran.impstage#','#val(getartran.billcost)#','#val(getartran.billsale)#',
			'<cfif getartran.paiddate eq "">0000-00-00<cfelse>#lsdateformat(getartran.paiddate,"yyyy-mm-dd")#</cfif>',
			'#val(getartran.paidamt)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.refno3#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.age#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.note#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.term#">,
			
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.iscash#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.van#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.del_by#">,
			'<cfif getartran.pla_dodate eq "">0000-00-00<cfelse>#lsdateformat(getartran.pla_dodate,"yyyy-mm-dd")#</cfif>',
			'<cfif getartran.act_dodate eq "">0000-00-00<cfelse>#lsdateformat(getartran.act_dodate,"yyyy-mm-dd")#</cfif>','#getartran.urgency#',
			'#val(getartran.currrate2)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.staxacc#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.supp1#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.supp2#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.pono#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.dono#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem0#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem1#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem2#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem3#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem4#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem5#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem6#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem7#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem8#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem9#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem10#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem11#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem12#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.frem0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.frem1#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.frem2#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.frem3#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.frem4#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.frem5#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.frem6#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.frem7#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.frem8#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.frem9#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.comm1#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.comm2#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.comm3#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.comm4#">,'#getartran.id#','#getartran.generated#',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.toinv#">,'#getartran.order_cl#',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.exported#">,
			'<cfif getartran.exported1 eq "">0000-00-00<cfelse>#lsdateformat(getartran.exported1,"yyyy-mm-dd")#</cfif>',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.exported2#">,
			'<cfif getartran.exported3 eq "">0000-00-00<cfelse>#lsdateformat(getartran.exported3,"yyyy-mm-dd")#</cfif>',
			'#getartran.last_year#','#getartran.posted#','#getartran.printed#','#getartran.lokstatus#','#getartran.void#',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.name#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.phonea#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.pono2#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.dono2#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.csgtrans#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getartran.taxincl#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.tableno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.cashier#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.member#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.counter#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.tourgroup#">,
			<cfif getartran.trdatetime neq "" and getartran.trdatetime neq "0000-00-00 00:00:00">#thistrdatetime#<cfelse>'0000-00-00 00:00:00'</cfif>,
			'#getartran.time#','#val(getartran.xtrcost)#','#val(getartran.xtrcost2)#','#val(getartran.point)#',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.bperiod#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.vperiod#">,
			'<cfif getartran.bdate eq "">0000-00-00<cfelse>#lsdateformat(getartran.bdate,"yyyy-mm-dd")#</cfif>',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.currcode#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.comm0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem13#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem14#">,
			'#val(getartran.mc3_bil)#','#val(getartran.mc4_bil)#','#val(getartran.mc5_bil)#','#val(getartran.mc6_bil)#','#val(getartran.mc7_bil)#',
			'#val(getartran.m_charge3)#','#val(getartran.m_charge4)#','#val(getartran.m_charge5)#','#val(getartran.m_charge6)#','#val(getartran.m_charge7)#',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.special_account_code#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,now(),now(),'#getartran.iras_posted#','#getartran.termscondition#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.permitno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem30#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem31#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem32#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem33#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem34#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem35#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem36#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem37#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem38#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem39#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem40#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem41#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem42#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem43#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem44#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem45#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem46#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem47#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem48#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.rem49#">)
		</cfquery>
	<cfcatch type="any">
		<cfset object.error=cfcatch.Message>
	</cfcatch>
	</cftry>
	
	<cfloop query="getictran">
		<cftry>
			<cfquery name="insertictran" datasource="#dts#">
				INSERT INTO `ictran` 
				(`TYPE`,`REFNO`,`REFNO2`,`TRANCODE`,`CUSTNO`,`FPERIOD`,`WOS_DATE`,`CURRRATE`,`ITEMCOUNT`,
				`LINECODE`,`ITEMNO`,`DESP`,`DESPA`,`AGENNO`,`LOCATION`,`SOURCE`,`JOB`,`SIGN`,
				`QTY_BIL`,`PRICE_BIL`,`UNIT_BIL`,`AMT1_BIL`,`DISPEC1`,`DISPEC2`,`DISPEC3`,`DISAMT_BIL`,`AMT_BIL`,
				`TAXPEC1`,`TAXPEC2`,`TAXPEC3`,`TAXAMT_BIL`,`NOTE_A`,`IMPSTAGE`,`QTY`,`PRICE`,`UNIT`,
				`AMT1`,`DISAMT`,`AMT`,`TAXAMT`,`FACTOR1`,`FACTOR2`,`DONO`,`DODATE`,`SODATE`,
				`BREM1`,`BREM2`,`BREM3`,`BREM4`,`PACKING`,`NOTE1`,`NOTE2`,`GLTRADAC`,`UPDCOST`,
				`GST_ITEM`,`TOTALUP`,`WITHSN`,`NODISPLAY`,`GRADE`,`PUR_PRICE`,`QTY1`,`QTY2`,`QTY3`,
				`QTY4`,`QTY5`,`QTY6`,`QTY7`,`QTY_RET`,`TEMPFIGI`,`SERCOST`,`M_CHARGE1`,`M_CHARGE2`,
				`ADTCOST1`,`ADTCOST2`,`IT_COS`,`AV_COST`,`BATCHCODE`,`EXPDATE`,`POINT`,`INV_DISC`,`INV_TAX`,
				`SUPP`,`EDI_COU1`,`WRITEOFF`,`TOSHIP`,`SHIPPED`,`NAME`,`DEL_BY`,`VAN`,`GENERATED`,
				`UD_QTY`,`TOINV`,`EXPORTED`,`EXPORTED1`,`EXPORTED2`,`EXPORTED3`,`BRK_TO`,`SV_PART`,`LAST_YEAR`,
				`VOID`,`SONO`,`MC1_BIL`,`MC2_BIL`,`USERID`,`DAMT`,`OLDBILL`,`WOS_GROUP`,`CATEGORY`,
				`AREA`,`SHELF`,`TEMP`,`TEMP1`,`BODY`,`TOTALGROUP`,`MARK`,`TYPE_SEQ`,`PROMOTER`,
				`TABLENO`,`MEMBER`,`TOURGROUP`,`TRDATETIME`,`TIME`,`BOMNO`,`COMMENT`,`DEFECTIVE`,`M_CHARGE3`,
				`M_CHARGE4`,`M_CHARGE5`,`M_CHARGE6`,`M_CHARGE7`,`MC3_BIL`,`MC4_BIL`,`MC5_BIL`,`MC6_BIL`,`MC7_BIL`,
				`taxincl`<cfif isdefined("getictran.loc_currrate")>,`LOC_CURRRATE`,`LOC_CURRCODE`</cfif>,`TITLE_ID`,`TITLE_DESP`,`PHOTO`) 
				VALUES 
	 			('#arguments.tran#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#newrefno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.refno2#">,
				#getictran.trancode#,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.custno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.fperiod#">,
				#thisdate#,'#val(getictran.currrate)#',#getictran.itemcount#,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.linecode#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.itemno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.desp#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.despa#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.agenno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.location#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.source#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.job#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.sign#">,
				
				'#val(getictran.qty_bil)#','#val(getictran.price_bil)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.unit_bil#">,
				'#val(getictran.amt1_bil)#','#val(getictran.dispec1)#','#val(getictran.dispec2)#','#val(getictran.dispec3)#','#val(getictran.disamt_bil)#','#val(getictran.amt_bil)#',
				
				'#val(getictran.taxpec1)#','#val(getictran.taxpec2)#','#val(getictran.taxpec3)#','#val(getictran.taxamt_bil)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.note_a#">,
				'#getictran.impstage#','#val(getictran.qty)#','#val(getictran.price)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.unit#">,
				
				'#val(getictran.amt1)#','#val(getictran.disamt)#','#val(getictran.amt)#','#val(getictran.taxamt)#','#val(getictran.factor1)#','#val(getictran.factor2)#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.dono#">,
				'<cfif getictran.dodate eq "">0000-00-00<cfelse>#lsdateformat(getictran.dodate,"yyyy-mm-dd")#</cfif>',
				'<cfif getictran.sodate eq "">0000-00-00<cfelse>#lsdateformat(getictran.sodate,"yyyy-mm-dd")#</cfif>',
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.brem1#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.brem2#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.brem3#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.brem4#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.packing#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.note1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.note2#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.gltradac#">,'#getictran.updcost#',
				
				'#getictran.gst_item#','#getictran.totalup#','#getictran.withsn#','#getictran.nodisplay#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.grade#">,'#val(getictran.pur_price)#','#val(getictran.qty1)#',
				'#val(getictran.qty2)#','#val(getictran.qty3)#',
				
				'#val(getictran.qty4)#','#val(getictran.qty5)#','#val(getictran.qty6)#','#val(getictran.qty7)#',
				'#val(getictran.qty_ret)#','#val(getictran.tempfigi)#','#val(getictran.sercost)#','#val(getictran.m_charge1)#','#val(getictran.m_charge2)#',
				
				'#val(getictran.adtcost1)#','#val(getictran.adtcost2)#','#val(getictran.it_cos)#','#val(getictran.av_cost)#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.batchcode#">,
				'<cfif getictran.expdate eq "">0000-00-00<cfelse>#lsdateformat(getictran.expdate,"yyyy-mm-dd")#</cfif>',
				'#val(getictran.point)#','#val(getictran.inv_disc)#','#val(getictran.inv_tax)#',
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.supp#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.edi_cou1#">,
				'#val(getictran.writeoff)#','#val(getictran.toship)#','#val(getictran.shipped)#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.name#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.del_by#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.van#">,'#getictran.generated#',
				
				'#getictran.ud_qty#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.toinv#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.exported#">,
				'<cfif getictran.exported1 eq "">0000-00-00<cfelse>#lsdateformat(getictran.exported1,"yyyy-mm-dd")#</cfif>',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.exported2#">,
				'<cfif getictran.exported3 eq "">0000-00-00<cfelse>#lsdateformat(getictran.exported3,"yyyy-mm-dd")#</cfif>',
				'#getictran.brk_to#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.sv_part#">,'#getictran.last_year#',
				
				'#getictran.void#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.sono#">,
				'#val(getictran.mc1_bil)#','#val(getictran.mc2_bil)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserID#">,
				'#val(getictran.damt)#','#getictran.oldbill#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.wos_group#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.category#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.area#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.shelf#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.temp#">,'#val(getictran.temp1)#','#getictran.body#','#getictran.totalgroup#',
				'#getictran.mark#','#getictran.type_seq#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.promoter#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.tableno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.member#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.tourgroup#">,
				<cfif getictran.trdatetime neq "" and getictran.trdatetime neq "0000-00-00 00:00:00">#thistrdatetime#<cfelse>'0000-00-00 00:00:00'</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.time#">,'#getictran.bomno#',
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getictran.comment)#">,'#getictran.defective#','#val(getictran.m_charge3)#',
				
				'#val(getictran.m_charge4)#','#val(getictran.m_charge5)#','#val(getictran.m_charge6)#','#val(getictran.m_charge7)#',
				'#val(getictran.mc3_bil)#','#val(getictran.mc4_bil)#','#val(getictran.mc5_bil)#','#val(getictran.mc6_bil)#','#val(getictran.mc7_bil)#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.taxincl#">
				<cfif isdefined("getictran.loc_currrate")>
					,'#val(getictran.loc_currrate)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.loc_currcode#">
				</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.title_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.title_desp#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getictran.photo#">)
			</cfquery>
		<cfcatch type="any">
			<cfset object.error=cfcatch.Detail>
		</cfcatch>
		</cftry>
	</cfloop>
	
	<cfloop query="getiserial">
		<cftry>
			<cfquery name="insertiserial" datasource="#dts#">
				INSERT INTO `iserial` 
				(`TYPE`,`REFNO`,`REFNO2`,`TRANCODE`,`CUSTNO`,`FPERIOD`,`WOS_DATE`,`DEL_BY`,`ITEMNO`,
				`DESP`,`DESPA`,`SERIALNO`,`SEQ`,`AGENNO`,`LOCATION`,`SOURCE`,`JOB`,`CURRRATE`,
				`SIGN`,`VOID`,`PRICE`,`EXPORTED`,`GENERATED`) 
				VALUES 
	 			('#arguments.tran#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#newrefno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.refno2#">,
				#getiserial.trancode#,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.custno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.fperiod#">,
				#thisdate#,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.del_by#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.itemno#">,
		
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.desp#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.despa#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.serialno#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.seq#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.agenno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.location#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.source#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getiserial.job#">,'#val(getiserial.currrate)#',
				
				'#getiserial.sign#','#getiserial.void#','#val(getiserial.price)#','#getiserial.exported#','#getiserial.generated#')
			</cfquery>
		<cfcatch type="any">
			<cfset object.error=cfcatch.Message>
		</cfcatch>
		</cftry>
	</cfloop>
	
	<cfloop query="getigrade">
		<cftry>
			<cfquery name="insertigrade" datasource="#dts#">
				INSERT INTO `igrade` 
				(`TYPE`,`REFNO`,`TRANCODE`,`ITEMNO`,`WOS_DATE`,`FPERIOD`,`SIGN`,`DEL_BY`,`LOCATION`,
				`VOID`,`GENERATED`,`CUSTNO`,`EXPORTED`,`FACTOR1`,`FACTOR2`
				<cfloop from="11" to="160" index="a">
					,GRD#a#
				</cfloop>) 
				VALUES 
	 			('#arguments.tran#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#newrefno#">,'#val(getigrade.trancode)#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getigrade.itemno#">,#thisdate#,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getigrade.fperiod#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getigrade.sign#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#getigrade.del_by#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getigrade.location#">,'#getigrade.void#','#getigrade.generated#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getigrade.custno#">,'#getigrade.exported#','#val(getigrade.factor1)#','#val(getigrade.factor2)#'
	
				<cfloop from="11" to="160" index="a">
					,#getigrade["GRD#a#"][getigrade.currentrow]#
				</cfloop>			
				)
			</cfquery>
		<cfcatch type="any">
			<cfset object.error="IGRADE: "&cfcatch.Message>
		</cfcatch>
		</cftry>
	</cfloop>
	
	<cfif lcase(HcomID) eq "avent_i" or lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "winbells_i" or lcase(HcomID) eq "iel_i" or 
		lcase(HcomID) eq "zeadine_i" or lcase(HcomID) eq "zeadine09_i" or lcase(HcomID) eq "chemline_i" or 
		lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i" or lcase(HcomID) eq "probulk_i">
		
		<cfquery datasource='#dts#' name="getartran_remark">
			select * from artran_remark 
			where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
			and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#"> 
		</cfquery>
		
		<cfif getartran_remark.recordcount neq 0>
			<cfquery datasource='#dts#' name='insertartran_remark'>
				Insert into artran_remark
				(TYPE,REFNO,REMARK1,REMARK2,REMARK3,REMARK4,REMARK5,REMARK6,REMARK7,REMARK8,REMARK9,REMARK10
				<cfif lcase(HcomID) eq "winbells_i">,REMARK11,REMARK12,REMARK13,REMARK14,REMARK15,REMARK16,REMARK17</cfif>)
				values
				('#arguments.tran#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#newrefno#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark1)#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark2)#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark3)#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark4)#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark5)#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark6)#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark7)#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark8)#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark9)#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark10)#">
				<cfif lcase(HcomID) eq "winbells_i">
					,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark11)#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark12)#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark13)#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark14)#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark15)#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark16)#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(getartran_remark.remark17)#">
				</cfif>)
			</cfquery>
		</cfif>
	</cfif>
	
	<cfquery datasource="#dts#" name="insert">
		insert into artranat 
		(TYPE,REFNO,CUSTNO,FPERIOD,WOS_DATE,DESP,DESPA,
		<cfswitch expression="#arguments.tran#">
			<cfcase value="RC,CN,OAI" delimiters=",">
				CREDITAMT
			</cfcase>
			<cfdefaultcase>
				DEBITAMT
			</cfdefaultcase>
		</cfswitch>,
		TRDATETIME,USERID,REMARK,CREATED_BY,UPDATED_BY,CREATED_ON,UPDATED_ON)
		values
		('#arguments.tran#','#arguments.refno#','#getartran.custno#','#getartran.fperiod#',#thisdate#,'#getartran.desp#','#getartran.despa#',
		<cfswitch expression="#tran#">
			<cfcase value="RC,CN,OAI" delimiters=",">
				'#getartran.CREDITAMT#'
			</cfcase>
			<cfdefaultcase>
			'#getartran.DEBITAMT#'
			</cfdefaultcase>
		</cfswitch>,
		<cfif getartran.trdatetime neq "" and getartran.trdatetime neq "0000-00-00 00:00:00">#thistrdatetime#<cfelse>'0000-00-00 00:00:00'</cfif>,
		'#getartran.userid#','Voided','#getartran.created_by#','#Huserid#',
		<cfif getartran.created_on neq "">#createdatetime(year(getartran.created_on),month(getartran.created_on),day(getartran.created_on),hour(getartran.created_on),minute(getartran.created_on),second(getartran.created_on))#<cfelse>'0000-00-00 00:00:00'</cfif>,
		#now()#)
	</cfquery>
	
    <cfquery datasource='#dts#' name='getgsetupvoid'>
    select disablevoid from gsetup
    </cfquery>
    
    <cfif getgsetupvoid.disablevoid neq 'Y'>
	<cfquery datasource='#dts#' name='voidartran'>
		Update artran 
		set void='Y'
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#"> 
	</cfquery>
	
	<cfquery datasource='#dts#' name='updateictran'>
		Update ictran 
		set void='Y'
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#"> 
	</cfquery>
	
	<cfquery datasource='#dts#' name='updateserial'>
		Update iserial 
		set void='Y'
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#"> 
	</cfquery>
	
	<cfquery name="updateigrade" datasource="#dts#">
		Update igrade
		set void='Y'
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#"> 
	</cfquery>
	</cfif>
	<cfset object.tran = arguments.tran>
	<cfset object.refno = newrefno>
	
	<cfreturn object>
</cffunction>

<cffunction name="calculateAmt">
	<cfargument name="tran" required="yes" type="string">
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="percent" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="string">
	
	<cfset object = CreateObject("Component","cfobject")>
	
	<cfquery name="getartran_remark" datasource="#dts#">
		select REMARK7 from artran_remark
		where type='#arguments.tran#' and refno='#arguments.refno#'
	</cfquery>
	<cfset totalbil = val(tostring(getartran_remark.remark7))>
	<cfset percent = val(arguments.percent)>
	
	<cfset itemAmt=percent/100*totalbil>
	
	<cfquery name="getsum" datasource="#dts#">
		SELECT sum(brem1+0) as percent,sum(amt1_bil) as sumamt FROM ictran 
		where type='#arguments.tran#' and refno='#arguments.refno#'
		and trancode <> '#val(arguments.trancode)#'
	</cfquery>
	<cfset totalpercent=val(getsum.percent)+val(arguments.percent)>
	<cfif totalpercent eq 100>
		<cfset itemAmt=totalbil-val(getsum.sumamt)>
	</cfif>
	
	<cfset itemAmt=numberformat(itemAmt,".__")>
	<cfset object.itemAmt = val(itemAmt)>
	
	<cfreturn object>
</cffunction>

<cffunction name="updateCurrP">
	<cfargument name="currcode" required="yes" type="string">
	<cfargument name="invdate" required="yes" type="string">
	
	<cfset object = CreateObject("Component","cfobject")>
	
	<cfquery name="getGsetup" datasource="#dts#">
		Select g.* from GSetup g
	</cfquery>
	
	<cfset lastaccyear = dateformat(getGsetup.lastaccyear, 'dd/mm/yyyy')>
	<cfset period=getGsetup.period>
	<cfset currentdate = dateformat(arguments.invdate,'dd/mm/yyyy')>

	<cfset tmpYear = year(currentdate)>
	<cfset clsyear = year(lastaccyear)>

	<cfset tmpmonth = month(currentdate)>
	<cfset clsmonth = month(lastaccyear)>

	<cfset intperiod = (tmpyear - clsyear) * 12 + tmpmonth - clsmonth>

	<cfif intperiod gt 18 or intperiod lte 0>
		<cfset readperiod = 99>
	<cfelse>
		<cfset readperiod = numberformat(intperiod,"00")>
	</cfif>
	
	<cfquery name="getCurrency" datasource="#dts#">
	  	select * from #target_currency# where currcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.currcode#">
	</cfquery>
	
	<cfif readperiod eq "99">
		<cfset object.currrate=val(getCurrency.currrate)>
	<cfelse>
		<cfset object.currrate=val(getCurrency["CurrP#val(readperiod)#"][1])>
	</cfif>
	
	<cfreturn object>
</cffunction>

<cffunction name="updateDataDetails">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="linecode" required="yes" type="string">
	<cfargument name="location" required="yes" type="string">
	<cfargument name="currrate" required="yes" type="string">
	<cfargument name="custno" required="yes" type="string">
	<cfargument name="tran" required="yes" type="string">
	<cfargument name="stDecl_UPrice" required="yes" type="string">
	<cfargument name="stDecl_Discount" required="yes" type="string">
	
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
	
	<cfset object = CreateObject("Component","cfobject")>
	
	<cfif arguments.linecode eq "SV">	<!--- If this is service --->
		<cfquery name="getData" datasource="#dts#">
			Select desp,despa,'' as category,'' as wos_group,'' as packing,'' as supp,'' as shelf,'0' as price,'0' as ucost,
			'' as unit, '1' as factor1, '1' as factor2,'' as graded
			<cfloop from="1" to="30" index="i">
				,'' as remark#i#
			</cfloop> 
			from icservi
			where servi=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#">
		</cfquery>
		<cfset price=0>
	  	<cfset dispec1=0>
	  	<cfset dispec2=0>
	  	<cfset dispec3=0>
	  	<cfset onhand=0>
	<cfelse>	<!--- If this is item --->
		<cfquery name="getData" datasource="#dts#">
			Select desp,despa,category,wos_group,packing,supp,shelf,price,ucost,unit,'1' as factor1, '1' as factor2,graded,qtybf
			<cfloop from="1" to="30" index="i">
				,remark#i#
			</cfloop> 
			from icitem
			where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#">
		</cfquery>
		
		<!--- Calculate balance on hand --->
		<cfinvoke method="getOnhand" argumentcollection="#arguments#" returnvariable="onhand" />
		<!--- Calculate balance on hand --->
		
		<!--- Check cost/price --->
		<cfif arguments.tran eq "RC" or arguments.tran eq "PO" or arguments.tran eq "PR">
			<cfquery name="getrecommendprice" datasource="#dts#">
				select * from icl3p 
				where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#"> 
				and custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.custno#"> 
			</cfquery>
			<cfif getrecommendprice.recordcount gt 0>
				<cfset price = val(getrecommendprice.price)>
				<cfset dispec1 = val(getrecommendprice.dispec)>
				<cfset dispec2 = val(getrecommendprice.dispec2)>
				<cfset dispec3 = val(getrecommendprice.dispec3)>
			<cfelse>
				<cfif val(arguments.currrate) neq 0>
					<cfset price = val(getData.ucost)/val(arguments.currrate)>
				<cfelse>
					<cfset price = val(getData.ucost)>
				</cfif>

				<cfset dispec1 = 0>
				<cfset dispec2 = 0>
				<cfset dispec3 = 0>
			</cfif>
		<cfelse>
			<cfquery name="getrecommendprice" datasource="#dts#">
				select * from icl3p2 
				where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#">
				and custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.custno#">
			</cfquery>
			<cfif getrecommendprice.recordcount gt 0>
				<cfset price = val(getrecommendprice.price)>
				<cfset dispec1 = val(getrecommendprice.dispec)>
				<cfset dispec2 = val(getrecommendprice.dispec2)>
				<cfset dispec3 = val(getrecommendprice.dispec3)>
			<cfelse>
				<cfif val(arguments.currrate) neq 0>
					<cfset price = val(getData.price)/val(arguments.currrate)>
				<cfelse>
					<cfset price = val(getData.price)>
				</cfif>

				<cfset dispec1 = 0>
				<cfset dispec2 = 0>
				<cfset dispec3 = 0>
			</cfif>
		</cfif>
		<!--- Check cost/price --->
	</cfif>
	
	<cfif getData.recordcount neq 0>
		<cfset object.desp=getData.desp>
		<cfset object.despa=getData.despa>
		<cfset object.category=getData.category>
		<cfset object.wos_group=getData.wos_group>
		<cfset object.packing=getData.packing>
		<cfset object.supp=getData.supp>
		<cfset object.shelf=getData.shelf>
		<cfset object.unit=getData.unit>
		<cfset object.factor1=getData.factor1>
		<cfset object.factor2=getData.factor2>
		<cfset object.graded=getData.graded>
		<cfloop from="1" to="30" index="i">
			<cfset "object.remark#i#"=getData["remark#i#"][1]>
		</cfloop>
		<cfset object.onhand=onhand>
	<cfelse>
		<cfset object.desp="">
		<cfset object.despa="">
		<cfset object.category="">
		<cfset object.wos_group="">
		<cfset object.packing="">
		<cfset object.supp="">
		<cfset object.shelf="">
		<cfset object.unit="">
		<cfset object.factor1="1">
		<cfset object.factor2="1">
		<cfset object.graded="">
		<cfloop from="1" to="30" index="i">
			<cfset "object.remark#i#"="">
		</cfloop>
		<cfset object.onhand="0">
	</cfif>
	
	<cfset object.price = numberformat(price,arguments.stDecl_UPrice)>
	<cfset object.dispec1 = dispec1>
	<cfset object.dispec2 = dispec2>
	<cfset object.dispec3 = dispec3>
	
	<cfreturn object>
</cffunction>

<cffunction name="getOnhand" returntype="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="location" required="yes" type="string">
	
	<cfset onhand=0>
	
	<cfif arguments.location neq "">
		<cfquery name="getbal" datasource="#dts#">
			select LOCQFIELD as locqtybf from locqdbf
			where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#">
			and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.location#">
		</cfquery>
		<cfset qty_bf = val(getbal.locqtybf)>
	<cfelse>
		<cfquery name="getbal" datasource="#dts#">
			Select qtybf from icitem
			where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#">
		</cfquery>
		<cfset qty_bf = val(getbal.qtybf)>
	</cfif>
		
	<cfquery name="getin" datasource="#dts#">
		select sum(qty)as sumqty 
		from ictran 
		where type in ('RC','CN','OAI','TRIN') 
		and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#">
		and (linecode <> 'SV' or linecode is null)
		<cfif arguments.location neq "">
			and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.location#">
		</cfif> 
		and fperiod <> '99' 
		and (void='' or void is null)
	</cfquery>
	<cfset inqty = val(getin.sumqty)>
	
	<cfquery name="getout" datasource="#dts#">
		select sum(qty)as sumqty 
		from ictran 
		where type in ('INV','DN','PR','CS','ISS','OAR','TROU') 
		and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#">
		and (linecode <> 'SV' or linecode is null)
		<cfif arguments.location neq "">
			and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.location#">
		</cfif>  
		and fperiod <> '99' 
		and (void='' or void is null)
	</cfquery>
	<cfset outqty = val(getout.sumqty)>
	
	<cfquery name="getdo" datasource="#dts#">
		select sum(qty)as sumqty 
		from ictran 
		where type='DO' 
		and toinv='' 
		and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#">
		and (linecode <> 'SV' or linecode is null)
		<cfif arguments.location neq "">
			and location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.location#"> 
		</cfif> 
		and fperiod <> '99' 
		and (void='' or void is null)
	</cfquery>
	<cfset doqty = val(getdo.sumqty)>
		
	<cfset onhand = qty_bf + inqty - outqty - doqty>
	
	<cfreturn onhand>
</cffunction>

<cffunction name="calculateFooter">
	<cfargument name="tran" required="yes" type="string">
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="stDecl_Discount" required="yes" type="string">
	<cfargument name="totaldisc1" required="yes" type="string">
	<cfargument name="totaldisc2" required="yes" type="string">
	<cfargument name="totaldisc3" required="yes" type="string">
	<cfargument name="totalamtdisc" required="yes" type="string">
	<cfargument name="selecttax" required="yes" type="string">
	<cfargument name="pTax" required="yes" type="string">
	<cfargument name="totalamttax" required="yes" type="string">
	
	<cfset object = CreateObject("Component","cfobject")>
	<cfset object.error="">
	<cfset object.subtotal="0.00">
	<cfset object.discamt="0.00">
	<cfset object.net="0.00">
	<cfset object.taxamt="0.00">
	<cfset object.grand="0.00">
	
	<cfquery name="getartran" datasource='#dts#'>
		select * from artran where refno = '#arguments.refno#' and type = '#arguments.tran#'
	</cfquery>
	
	<cfquery name="getictran2" datasource='#dts#'>
		select sum(amt_bil) as subtotal from ictran where refno = '#arguments.refno#' and type = '#arguments.tran#'
	</cfquery>
	
	<cftry>
		<cfset currrate=val(getartran.currrate)>
		<cfset xdisp1 = val(arguments.totaldisc1)>
		<cfset xdisp2 = val(arguments.totaldisc2)>
		<cfset xdisp3 = val(arguments.totaldisc3)>
		<cfset xdisc_bil = val(arguments.totalamtdisc)>
		<cfset xtaxp1=val(arguments.pTax)>
		<cfset xtax_bil = val(arguments.totalamttax)>
		<cfset xgross_bil=val(getictran2.subtotal)>
		
		<cfif (xdisp1 neq 0 or xdisp2 neq 0 or xdisp3 neq 0) and xdisc_bil neq 0>
			<cfset disc1_bil = xgross_bil * xdisp1 / 100>
			<cfset disc1_bil = numberformat(disc1_bil,arguments.stDecl_Discount)>
		  	<cfset xnet_bil = xgross_bil - val(disc1_bil)>
			<cfset disc2_bil = xnet_bil * xdisp2 / 100>
			<cfset disc2_bil = numberformat(disc2_bil,arguments.stDecl_Discount)>
		  	<cfset xnet_bil = xnet_bil - val(disc2_bil)>
			<cfset disc3_bil = xnet_bil * xdisp3 / 100>
			<cfset disc3_bil = numberformat(disc3_bil,arguments.stDecl_Discount)>
		  	<cfset xnet_bil = xnet_bil - val(disc3_bil)>
			<cfset disc_bil = val(disc1_bil) + val(disc2_bil) + val(disc3_bil)>
		<cfelseif (xdisp1 eq 0 and xdisp2 eq 0 and xdisp3 eq 0) and xdisc_bil neq 0>	
		  	<cfset disc1_bil = 0>
		  	<cfset disc2_bil = 0>
		  	<cfset disc3_bil = 0>
		  	<cfset disc_bil = xdisc_bil>
		  	<cfset xnet_bil = xgross_bil - disc_bil>
		<cfelse>
		  	<cfset disc1_bil = xgross_bil * xdisp1 / 100>	
		  	<cfset xnet_bil = xgross_bil - disc1_bil>
			<cfset disc2_bil = xnet_bil * xdisp2 / 100>
		  	<cfset xnet_bil = xnet_bil - disc2_bil>
			<cfset disc3_bil = xnet_bil * xdisp3 / 100>
		  	<cfset xnet_bil = xnet_bil - disc3_bil>
		  	<cfset disc_bil = disc1_bil + disc2_bil + disc3_bil>
		</cfif>
		
		<cfif xtaxp1 eq 0 and xtax_bil neq 0>
			<cfset tax1_bil =numberformat((xtax_bil),".__")>
		<cfelse>
			<cfset tax1_bil =numberformat((xnet_bil*xtaxp1/100),".__")>
		</cfif>
		<cfset tax_bil = tax1_bil>
		
		<cfset xgrand_bil=xnet_bil+tax_bil>
		
		<cfset xinvgross = xgross_bil*currrate>
		<cfset xdiscount1 = disc1_bil*currrate>
		<cfset xdiscount2 = disc2_bil*currrate>
		<cfset xdiscount3 = disc3_bil*currrate>
		<cfset xdiscount = disc_bil*currrate>
		<cfset xnet = xnet_bil*currrate>
		<cfset xtax = tax1_bil*currrate>
		<cfset xgrand = xgrand_bil*currrate>
		
		<cfquery name="updataratran" datasource="#dts#">
			update artran 
			set gross_bil='#xgross_bil#',
			disp1='#val(xdisp1)#',
			disp2='#val(xdisp2)#',
			disp3='#val(xdisp3)#',
			disc1_bil='#disc1_bil#',
			disc2_bil='#disc2_bil#',
			disc3_bil='#disc3_bil#',
			disc_bil='#disc_bil#',
			taxp1='#xtaxp1#',
			note='#arguments.selecttax#',
			tax1_bil='#tax1_bil#',
			tax_bil='#tax_bil#',
			net_bil='#xnet_bil#',
			grand_bil='#xgrand_bil#', 
		  	invgross='#xinvgross#',
		  	discount1='#xdiscount1#', 
		  	discount2='#xdiscount2#', 
		  	discount3='#xdiscount3#', 
		  	discount='#xdiscount#',
		  	tax='#xtax#',
		  	net='#xnet#',  
			grand='#xgrand#'
			where refno = '#arguments.refno#' and type = '#arguments.tran#'
		</cfquery>
		
		<cfset object.subtotal=numberformat(val(getictran2.subtotal),".__")>
		<cfset object.discamt=disc_bil>
		<cfset object.net=val(xnet_bil)>
		<cfset object.taxamt=tax_bil>
		<cfset object.grand=xgrand_bil>
	<cfcatch type="any">
		<cfset object.error=cfcatch.Message>
	</cfcatch>
	</cftry>
	
	<cfreturn object>
</cffunction>

<cffunction name="updateProduct">
	<cfargument name="tran" required="yes" type="string">
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="itemno" required="yes" type="string">
	<cfargument name="trancode" required="yes" type="string">
	<cfargument name="stDecl_UPrice" required="yes" type="string">
	<cfargument name="stDecl_Discount" required="yes" type="string">
	
	<cfset arguments.itemno = URLDecode(arguments.itemno)>
	
	<cfset object = CreateObject("Component","cfobject")>
	
	<cfquery name="getData" datasource="#dts#">
		Select desp,despa,comment,brem1,brem2,brem3,brem4,location,
		unit_bil,unit,factor1,factor2,category,wos_group,packing,supp,shelf,source,job,
		qty_bil,price_bil,amt1_bil,amt_bil,dispec1,dispec2,dispec3,disamt_bil,note_a,taxpec1,taxamt_bil,qty
		from ictran
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#">
		and itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemno#">
		and trancode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.trancode#">
	</cfquery>
	
	<cfif getData.recordcount neq 0>
		<cfset object.desp=getData.desp>
		<cfset object.despa=getData.despa>
		<cfset object.category=getData.category>
		<cfset object.wos_group=getData.wos_group>
		<cfset object.packing=getData.packing>
		<cfset object.supp=getData.supp>
		<cfset object.shelf=getData.shelf>
		<cfset object.unit_bil=getData.unit_bil>
		<cfset object.unit=getData.unit>
		<cfset object.factor1=val(getData.factor1)>
		<cfset object.factor2=val(getData.factor2)>
		<cfset object.qty=val(getData.qty_bil)>
		<cfset object.price = numberformat(getData.price_bil,arguments.stDecl_UPrice)>
		<cfset object.amt = numberformat(getData.amt1_bil,".__")>
		<cfset object.taxamt = numberformat(getData.taxamt_bil,".__")>
		<cfset object.discamt = numberformat(getData.disamt_bil,".__")>
		<cfset object.dispec1=val(getData.dispec1)>
		<cfset object.dispec2=val(getData.dispec2)>
		<cfset object.dispec3=val(getData.dispec3)>
		<cfset object.note_a=getData.note_a>
		<cfset object.taxpec1=val(getData.taxpec1)>
		<cfset object.brem1=getData.brem1>
		<cfset object.brem2=getData.brem2>
		<cfset object.brem3=getData.brem3>
		<cfset object.brem4=getData.brem4>
		<cfset object.comment=tostring(getData.comment)>
		<cfset object.location=getData.location>
		<cfset object.totalamt=val(getData.amt_bil)+val(getData.taxamt_bil)>
		<cfset object.oldqty=val(getData.qty)>
	<cfelse>
		<cfset object.desp="">
		<cfset object.despa="">
		<cfset object.category="">
		<cfset object.wos_group="">
		<cfset object.packing="">
		<cfset object.supp="">
		<cfset object.shelf="">
		<cfset object.unit_bil="">
		<cfset object.unit="">
		<cfset object.factor1="1">
		<cfset object.factor2="1">
		<cfset object.qty="0">
		<cfset object.price = "0.00">
		<cfset object.amt = "0.00">
		<cfset object.taxamt = "0.00">
		<cfset object.discamt = "0.00">
		<cfset object.dispec1="0">
		<cfset object.dispec2="0">
		<cfset object.dispec3="0">
		<cfset object.note_a="">
		<cfset object.taxpec1="0">
		<cfset object.brem1="">
		<cfset object.brem2="">
		<cfset object.brem3="">
		<cfset object.brem4="">
		<cfset object.comment="">
		<cfset object.location="">
		<cfset object.totalamt="0.00">
		<cfset object.oldqty="0">
	</cfif>
	
	<cfreturn object>
</cffunction>
<cffunction name="deleteTax">
	<cfargument name="taxcode" required="yes" type="string">
	
	<cfset object = CreateObject("Component","cfobject")>
	<cfset message="">
	
	<cfif hlinkams eq "Y">
		<cftry>
			<cfquery name="deletetax" datasource="#replace(dts,'_i','_a','all')#">
				DELETE FROM taxtable
				WHERE code = '#arguments.taxcode#'
			</cfquery>
		<cfcatch type="any">
			<cfset message=cfcatch.Message>
		</cfcatch>
		</cftry>
	<cfelse>
		<cftry>
			<cfquery name="deletetax" datasource="#dts#">
				DELETE FROM taxtable
				WHERE code = '#arguments.taxcode#'
			</cfquery>
		<cfcatch type="any">
			<cfset message=cfcatch.Message>
		</cfcatch>
		</cftry>
	</cfif>
	
	<cfset object.message = message>
	
	<cfreturn object>
</cffunction>

<cffunction name="updateProject">
	<cfargument name="projbybill" required="yes" type="string"> 
	<cfargument name="tran" required="yes" type="string">
	<cfargument name="refno" required="yes" type="string">
	<cfargument name="itemcount" required="yes" type="string">
	<cfargument name="source" required="yes" type="string">
	<cfargument name="job" required="yes" type="string">
	<cfargument name="gltradac" required="yes" type="string">
	
	<cfset object = CreateObject("Component","cfobject")>
	<cfset arguments.refno = URLDecode(arguments.refno)>
	
	<cftry>
		<cfif arguments.projbybill eq "Y">
			<cfquery name="update" datasource="#dts#">
				update artran
				set source='#arguments.source#',
				job='#arguments.job#'
				where type='#arguments.tran#'
				and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#">
			</cfquery>
			
			<cfquery name="update" datasource="#dts#">
				update ictran
				set source='#arguments.source#',
				job='#arguments.job#'
				where type='#arguments.tran#'
				and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#">
			</cfquery>
		<cfelse>
			<cfquery name="update" datasource="#dts#">
				update ictran
				set source='#arguments.source#',
				job='#arguments.job#',
				gltradac='#arguments.gltradac#'
				where type='#arguments.tran#'
				and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#">
				and itemcount='#arguments.itemcount#'
			</cfquery>
		</cfif>
		<cfset status="">
		<cfcatch type="database">
			<cflog file="ajax_tranf" text="Error msg (Update): #cfcatch.message# (#HcomID#-#HUserID#)">
			<cfset status="Failed to Update #arguments.tran# #arguments.refno#.#chr(10)#Error message: #cfcatch.queryError##chr(10)#Please check with Administrator.">
		</cfcatch> 
	</cftry>
	
	<cfset object.refno=arguments.refno>
	<cfset object.itemcount=arguments.itemcount>
	<cfset object.status=status>
	<cfreturn object>
</cffunction>

<cffunction name="assignDiscByBrand">
	<cfargument name="tran" required="yes" type="string">
	<cfargument name="refno" required="yes" type="string">
	
	<cfset object = CreateObject("Component","cfobject")>
	<cfset message="">
	
	<cftry>
		<cfquery name="getictran" datasource="#dts#">
			select b.brand,c.rangeForDisc,c.DISPEC,sum(a.amt1) as totalamt1
			from ictran a,icitem b, brand c
			where a.type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
			and a.refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#">
			and (a.linecode <> 'SV' or a.linecode is null)
			and a.itemno=b.itemno
			and b.brand=c.brand
			group by b.brand
		</cfquery>
	<cfcatch type="any">
		<cfset message=cfcatch.Message>
	</cfcatch>
	</cftry>
	
	<cfloop query="getictran">
		<cfset xbrand=getictran.brand>
		<cfset xdispec=val(getictran.DISPEC)>
		<cfif (val(getictran.totalamt1) GTE val(getictran.rangeForDisc)) and val(getictran.rangeForDisc) NEQ 0>
			<cftry>
				<cfquery name="updateictran" datasource="#dts#">
					update ictran a, icitem b
					set a.dispec1='#val(xdispec)#',
					a.disamt_bil=(a.amt1_bil*#val(xdispec)#/100),
					a.amt_bil=(a.amt1_bil-(a.amt1_bil*#val(xdispec)#/100)),
					a.taxamt_bil=((a.taxpec1/100)*(a.amt1_bil-(a.amt1_bil*#val(xdispec)#/100))),
					a.disamt=(a.amt1_bil*#val(xdispec)#/100)*a.currrate,
					a.amt=(a.amt1_bil-(a.amt1_bil*#val(xdispec)#/100))*a.currrate,
					a.taxamt=((a.taxpec1/100)*(a.amt1_bil-(a.amt1_bil*#val(xdispec)#/100)))*a.currrate
					where a.type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tran#">
					and a.refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.refno#">
					and a.itemno=b.itemno
					and b.brand=<cfqueryparam cfsqltype="cf_sql_varchar" value="#xbrand#">
				</cfquery>
			<cfcatch type="any">
				<cfset message=cfcatch.Message>
			</cfcatch>
			</cftry>
		</cfif>
	</cfloop>
	<cfset object.message = message>
	<cfreturn object>
</cffunction>