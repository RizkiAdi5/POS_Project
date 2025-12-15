
<cfif isdefined("url.debug")><cfabort></cfif>


<cfif url.BillName eq "receipt_non_editable">
<cfif lcase(hcomid) eq "wangseng_i">
<cflocation url="/default/transaction/POS/processprintA4.cfm?tran=#url.tran#&nexttranno=#url.nexttranno#">
<cfelse>
    <cfform name="form1" id="form1" action="/default/transaction/POS/processprint.cfm?reprint=1" method="post">
    <cfinput type="hidden" name="type" id="type" value="#url.tran#">
    <cfinput type="hidden" name="refno" id="refno" value="#url.nexttranno#">
    </cfform>
    
   <script type="text/javascript">
    form1.submit();
    </script>
    <cfabort>
</cfif>
</cfif>


<cfif url.BillName eq "receiptRC_non_editable">

    <cfform name="form1" id="form1" action="/default/transaction/POS/processprintRC.cfm?reprint=1" method="post">
    <cfinput type="hidden" name="type" id="type" value="#url.tran#">
    <cfinput type="hidden" name="refno" id="refno" value="#url.nexttranno#">
    </cfform>
    
   <script type="text/javascript">
    form1.submit();
    </script>
	<cfabort>
</cfif>


<cffunction name="findCurrentSetInv" output="true">
	<cfargument name="input" type="query" required="yes">
	<cfargument name="refno" type="string" required="yes">
	<cfset prefixRefno=left(arguments.refno,3)>
	<cfif left(input.invno,3) eq prefixRefno>
		<cfreturn 1>
	<cfelseif left(input.invno_2,3) eq prefixRefno>
		<cfreturn 2>
	<cfelseif left(input.invno_3,3) eq prefixRefno>
		<cfreturn 3>
	<cfelseif left(input.invno_4,3) eq prefixRefno>
		<cfreturn 4>
	<cfelseif left(input.invno_5,3) eq prefixRefno>
		<cfreturn 5>
	<cfelse>
		<cfreturn 6>
	</cfif> 
</cffunction>
<noscript>
	Javascript has been disabled or not supported in this browser.<br>Please enable Javascript supported before continue.
</noscript>
<cfset trancode="#lcase(tran)#no">
<cfset prefix="#lcase(tran)#code">
<cfset suffix="#lcase(tran)#no2">

<cfquery name="getGSetup" datasource="#dts#">
  	select invoneset,#prefix# as prefix,#trancode#,#suffix# as suffix,
	<cfif tran eq "INV"><cfloop from="2" to="6" index="i">#prefix#_#i#,#trancode#_#i#,#suffix#_#i#,</cfloop></cfif>
	compro,compro2,compro3,compro4,compro5,compro6,compro7,gstno,comuen from gsetup 
</cfquery>

<cfquery name="getGSetup2" datasource='#dts#'>
  	Select concat('.',repeat('_',Decl_Uprice)) as Decl_Uprice,concat('.',repeat('_',Decl_Discount)) as Decl_Discount from gsetup2
</cfquery>

<cfset tran_prefix=getGSetup.prefix>
<cfset tran_suffix=getGSetup.suffix>
<cfset fname=billname&".cfr">

<cfswitch expression="#tran#">
	<cfcase value="RC"><cfset ptype=target_apvend></cfcase>
	<cfcase value="PR"><cfset ptype=target_apvend></cfcase>
	<cfcase value="INV"><cfset ptype=target_arcust></cfcase>
	<cfcase value="DO"><cfset ptype=target_arcust></cfcase>
	<cfcase value="CS"><cfset ptype=target_arcust></cfcase>
	<cfcase value="CN"><cfset ptype=target_arcust></cfcase>
	<cfcase value="DN"><cfset ptype=target_arcust></cfcase>
	<cfcase value="QUO"><cfset ptype=target_arcust></cfcase>
	<cfcase value="PO"><cfset ptype=target_apvend></cfcase>
	<cfcase value="SO"><cfset ptype=target_arcust></cfcase>
	<cfcase value="SAM"><cfset ptype=target_arcust></cfcase>
</cfswitch>

<cfquery name="ClearICBil_M" datasource="#dts#">
  	truncate r_IcBil_M
</cfquery>

<cfquery name="ClearICBil_S" datasource="#dts#">
  	truncate r_IcBil_S
</cfquery>

<cfquery datasource='#dts#' name="getHeaderInfo">
	select a.type,a.refno,a.desp,a.despa,a.term,
	a.source,a.job,a.pono,a.dono,a.currcode,a.note,	
	a.deposit,a.cs_pm_debt,a.created_by,  
	
	a.rem0,a.rem1,a.rem2,a.rem3,a.rem4,a.rem5,a.rem6,a.rem7,a.rem8,a.rem9,a.rem10,a.rem11,a.rem12,a.rem13,a.rem14,
	a.frem0,a.frem1,a.frem2,a.frem3,a.frem4,a.frem5,a.frem6,a.frem7,a.frem8,a.frem9,
	a.comm0,a.comm1,a.comm2,a.comm3,a.comm4,
	a.mc1_bil,a.mc2_bil,a.mc3_bil,a.mc4_bil,a.mc5_bil,a.mc6_bil,a.mc7_bil,
	
	a.fperiod,a.custno,a.wos_date,a.currrate,
	a.agenno,a.name,a.van,
	
	a.gross_bil, 
	a.disp1, a.disp2, a.disp3, a.disc1_bil, a.disc2_bil, a.disc3_bil, a.disc_bil, 
	a.taxp1,a.tax_bil,a.tax1_bil,a.tax2_bil,a.tax3_bil, a.net_bil, a.grand_bil,

	ag.desp as agen_desp,curr.currency
	
	from artran a 
	left join icagent ag on a.agenno=ag.agent
	left join #target_currency# curr on a.currcode = curr.currcode
		
	where a.type = '#tran#' and <cfif isdefined('url.nexttranno')> a.refno='#url.nexttranno#' <cfelse> a.refno in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sono#" list="yes">)</cfif>
</cfquery>
<cfif isdefined('url.nexttranno')> 

<cfelse>
<cfquery name="updatePrinted" datasource="#dts#">
Update artran SET printed = "Y" where refno in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sono#" list="yes">) and type =<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tran#" >
</cfquery>
</cfif>
<cfset j = 1>
<cfset k = 0>

<cfloop query="getHeaderInfo">
	<cfif getHeaderInfo.rem0 neq "">
		<cfif getHeaderInfo.rem0 eq "Profile">
			<cfif tran eq 'PR' or tran eq 'PO' or tran eq 'RC'>
				<cfquery datasource='#dts#' name="getCustAdd">
					select name,name2,add1,add2,add3,add4,attn,phone,fax,e_mail,web_site,contact,END_USER,COUNTRY,POSTALCODE from #target_apvend# where custno = '#getheaderInfo.custno#' 
				</cfquery>
			<cfelse>
				<cfquery datasource='#dts#' name="getCustAdd">
					select name,name2,add1,add2,add3,add4,attn,phone,fax,e_mail,web_site,contact,END_USER,COUNTRY,POSTALCODE from #target_arcust# where custno = '#getheaderInfo.custno#' 
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery datasource='#dts#' name="getCustAdd">
				select a.name,'' as name2,a.add1,a.add2,a.add3,a.add4,a.attn,a.phone,a.fax,a.COUNTRY,a.POSTALCODE,b.e_mail,b.web_site,b.contact,b.END_USER
				from address a, #ptype# b where a.code = '#getheaderInfo.rem0#' and a.custno=b.custno
			</cfquery>
		</cfif>
		<cfif getCustAdd.country neq "" and getCustAdd.postalcode neq "">
			<cfset add5=getCustAdd.country&" "&getCustAdd.postalcode>
			<cfif getCustAdd.add1 eq "">
				<cfset getCustAdd.add1 = add5>
			<cfelseif getCustAdd.add2 eq "">
				<cfset getCustAdd.add2 = add5>
			<cfelseif getCustAdd.add3 eq "">
				<cfset getCustAdd.add3 = add5>
			<cfelseif getCustAdd.add4 eq "">
				<cfset getCustAdd.add4 = add5>
			<cfelse>
				<cfset getCustAdd.add5 = add5>
			</cfif>
		</cfif>
	<cfelse>
		<cfset getCustAdd.name=getHeaderInfo.frem0>
		<cfset getCustAdd.name2=getHeaderInfo.frem1>
		<cfset getCustAdd.add1=getHeaderInfo.frem2>
		<cfset getCustAdd.add2=getHeaderInfo.frem3>
		<cfset getCustAdd.add3=getHeaderInfo.frem4>
		<cfset getCustAdd.add4=getHeaderInfo.frem5>
		<cfset getCustAdd.attn=getHeaderInfo.rem2>
		<cfset getCustAdd.phone=getHeaderInfo.rem4>
		<cfset getCustAdd.fax=getHeaderInfo.frem6>
		<cfset getCustAdd.e_mail="">
		<cfset getCustAdd.web_site="">
		<cfset getCustAdd.contact="">
	</cfif>
	
	<cfif getHeaderInfo.rem1 neq "">
		<cfif getHeaderInfo.rem1 eq "Profile">
			<cfif tran eq 'PR' or tran eq 'PO' or tran eq 'RC'>
				<cfquery datasource='#dts#' name="getDeliveryAdd">
					select name,name2,daddr1 as add1,daddr2 as add2,daddr3 as add3,daddr4 as add4,dattn as attn,dphone as phone,dfax as fax,e_mail,contact,D_COUNTRY as COUNTRY,D_POSTALCODE as POSTALCODE from #target_apvend# where custno = '#getheaderInfo.custno#'
				</cfquery>
			<cfelse>
				<cfquery datasource='#dts#' name="getDeliveryAdd">
					select name,name2,daddr1 as add1,daddr2 as add2,daddr3 as add3,daddr4 as add4,dattn as attn,dphone as phone,dfax as fax,e_mail,contact,D_COUNTRY as COUNTRY,D_POSTALCODE as POSTALCODE from #target_arcust# where custno = '#getheaderInfo.custno#' 
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery datasource='#dts#' name="getDeliveryAdd">
				select a.name,'' as name2,a.add1,a.add2,a.add3,a.add4,a.attn,a.phone,a.fax,a.COUNTRY,a.POSTALCODE,b.e_mail,b.contact 
				from address a			
				left join #ptype# as b on a.custno=b.custno
				where a.code = '#getheaderInfo.rem1#'
			</cfquery>
		</cfif>
		<cfif getDeliveryAdd.country neq "" and getDeliveryAdd.postalcode neq "">
			<cfset add5=getDeliveryAdd.country&" "&getDeliveryAdd.postalcode>
			<cfif getDeliveryAdd.add1 eq "">
				<cfset getDeliveryAdd.add1 = add5>
			<cfelseif getDeliveryAdd.add2 eq "">
				<cfset getDeliveryAdd.add2 = add5>
			<cfelseif getDeliveryAdd.add3 eq "">
				<cfset getDeliveryAdd.add3 = add5>
			<cfelseif getDeliveryAdd.add4 eq "">
				<cfset getDeliveryAdd.add4 = add5>
			<cfelse>
				<cfset getDeliveryAdd.add5 = add5>
			</cfif>
		</cfif>
	<cfelse>
		<cfset getDeliveryAdd.name=getHeaderInfo.frem7>
		<cfset getDeliveryAdd.name2=getHeaderInfo.frem8>
		<cfset getDeliveryAdd.add1=getHeaderInfo.comm0>
		<cfset getDeliveryAdd.add2=getHeaderInfo.comm1>
		<cfset getDeliveryAdd.add3=getHeaderInfo.comm2>
		<cfset getDeliveryAdd.add4=getHeaderInfo.comm3>
		<cfset getDeliveryAdd.attn=getHeaderInfo.rem3>
		<cfset getDeliveryAdd.phone=getHeaderInfo.rem12>
		<cfset getDeliveryAdd.fax=getHeaderInfo.comm4>
		<cfset getDeliveryAdd.e_mail="">
		<cfset getDeliveryAdd.contact="">
	</cfif>
	
	<cfif k neq 0>
		<cfquery name="update" datasource="#dts#">
			update r_icbil_s
			set counter_2 = #k#
			where No = #j-1#
		</cfquery>
	</cfif>
	<cfset k = k+1>
	<cfset xdisp1 = 0>
	<cfset xdisp2 = 0>
	<cfset xdisp3 = 0>
	<cfset xtaxp1 = 0>
	 
	<cfif getheaderinfo.taxp1 neq "">
	  	<cfset xtaxp1 = getheaderinfo.taxp1>
	</cfif>
	 
	<cfif getheaderinfo.disp1 neq "">
	  	<cfset xdisp1 = getheaderinfo.disp1>
	</cfif>
	
	<cfif getheaderinfo.disp2 neq "">
	  	<cfset xdisp2 = getheaderinfo.disp2>
	</cfif>
	
	<cfif getheaderinfo.disp3 neq "">
	  	<cfset xdisp3 = getheaderinfo.disp3>
	</cfif>
	
	<cfif getheaderinfo.disc1_bil neq 0>
	  	<cfset thisdisamt_bil = getheaderinfo.disc1_bil + getheaderinfo.disc2_bil + getheaderinfo.disc3_bil>
	<cfelse>
	  	<cfset thisdisamt_bil = getheaderinfo.disc_bil>
	</cfif>
	
	<cfset thistaxbil = getheaderinfo.tax1_bil + getheaderinfo.tax2_bil + getheaderinfo.tax3_bil>
	<!--- HEADER: REM12 => R_ICBIL_M: D_TEL; HEDAER: cs_pm_debt => R_ICBIL_M: REM12 --->
	<!--- HEADER: REM3 => R_ICBIL_M: D_ATTN; HEDAER: currency => R_ICBIL_M: REM3 --->
	<cfquery name="InsertICBil_M" datasource="#dts#">
	  	Insert into r_icbil_m (B_Name, B_Name2, B_Add1, B_Add2, B_Add3, B_Add4, B_Attn, B_Tel, B_Fax,
	  	D_Name, D_Add1, D_Add2, D_Add3, D_Add4, D_Attn, D_Tel, D_Fax, Custno, Refno,PONO,DONO,
	  	Date, Terms, Agent, Rem1, Rem2, Rem3, Rem4, 
	  	Rem5, Rem6, Rem7, Rem8, Rem9, Rem10, Rem11, Rem12, Total, Disp1, Disp2, Disp3, Disamt_bil, 
	  	Net_bil, Taxp1, Taxamt_bil, CurrCode, CurrRate, Gross_bil, Deposit,AGENTDESP)
			
	  	values 
		(<cfqueryparam cfsqltype="cf_sql_char" value="#getCustAdd.name#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getCustAdd.name2#">,
		<cfqueryparam cfsqltype="cf_sql_char" value="#getCustAdd.add1#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getCustAdd.add2#">,
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#getCustAdd.add3#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getCustAdd.add4#">,
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#getCustAdd.attn#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getCustAdd.phone#">,
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#getCustAdd.fax#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getDeliveryAdd.name#">,
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#getDeliveryAdd.add1#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getDeliveryAdd.add2#">,
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#getDeliveryAdd.add3#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getDeliveryAdd.add4#">,
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#getDeliveryAdd.attn#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getDeliveryAdd.phone#">,
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#getDeliveryAdd.fax#">, 
	  	'#jsstringformat(getheaderinfo.custno)#','#jsstringformat(getheaderinfo.refno)#','#jsstringformat(getheaderinfo.pono)#','#jsstringformat(getheaderinfo.dono)#','#jsstringformat(dateformat(getheaderinfo.wos_date,"yyyy-mm-dd"))#',
		<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.term#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.agenno#">,
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.rem1#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.rem2#">,
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.currency#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.rem4#">,
		<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.rem5#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.rem6#">,
		<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.rem7#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.rem8#">,
		<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.rem9#">,<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.rem10#">,
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.rem11#">,'#val(getheaderinfo.cs_pm_debt)#','#val(getheaderinfo.grand_bil)#','#val(getheaderinfo.disp1)#', 
	  	'#val(getheaderinfo.disp2)#','#val(getheaderinfo.disp3)#','#val(thisdisamt_bil)#',
		'#val(getheaderinfo.net_bil)#','#val(xtaxp1)#','#val(getheaderinfo.tax_bil)#','#jsstringformat(getheaderinfo.currcode)#', 
	  	'#val(getheaderinfo.currrate)#','#val(getheaderinfo.gross_bil)#','#val(getheaderinfo.deposit)#',
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#getheaderinfo.agen_desp#">)
	</cfquery>
	
    <cfif billname eq 'polypet_ICBIL_sam' or billname eq 'polypet_ICBIL_DO'>
    <cfquery name="getbodyinfo" datasource="#dts#">
		select
		type,refno,itemno,desp,despa,comment,unit_bil,location,
		brem1,brem2,brem3,brem4,gltradac,wos_group,category,
		packing,trancode,title_desp,
		
		price_bil,qty_bil,amt1_bil,
		dispec1,dispec2,dispec3,disamt_bil,
		taxpec1,taxamt_bil,amt_bil
		
		from ictran 
		where type = '#getHeaderInfo.type#'
		and	refno = '#getHeaderInfo.refno#'
        and brem1='Delivery'
		order by trancode
	</cfquery>
    <cfelse>
	<cfquery name="getbodyinfo" datasource="#dts#">
		select
		type,refno,itemno,desp,despa,comment,unit_bil,location,
		brem1,brem2,brem3,brem4,gltradac,wos_group,category,
		packing,trancode,title_desp,
		
		price_bil,qty_bil,amt1_bil,
		dispec1,dispec2,dispec3,disamt_bil,
		taxpec1,taxamt_bil,amt_bil
		
		from ictran 
		where type = '#getHeaderInfo.type#'
		and	refno = '#getHeaderInfo.refno#'
		order by trancode
	</cfquery>
    </cfif>
	
	<cfloop query="getbodyinfo">
		
		<cfquery name="getserial" datasource="#dts#">
	    	select * from iserial where refno = '#getbodyinfo.refno#' and type = '#getbodyinfo.type#' 
	    	and itemno = '#getbodyinfo.itemno#' and trancode = '#getbodyinfo.trancode#'
	  	</cfquery>
	  	
	  	<cfif getserial.recordcount gt 0>
	    	<cfset mylist1 = valuelist(getserial.SERIALNO)>
	  	<cfelse>
	    	<cfset mylist1 = ''>
	  	</cfif>
	  	
	  	<cfset iteminfo = arraynew(1)>
        <cfif getbodyinfo.title_desp neq ''>
        <cfset iteminfo[1] = getbodyinfo.title_desp>
        <cfset iteminfo[2] = getbodyinfo.desp>
		<cfset iteminfo[3] = getbodyinfo.despa>
		<cfset iteminfo[4] = replace(tostring(getbodyinfo.comment),chr(10)," ","all")>
        
		<cfset info=''>
        <cfelse>
		<cfset iteminfo[1] = getbodyinfo.desp>
		<cfset iteminfo[2] = getbodyinfo.despa>
		<cfset iteminfo[3] = replace(tostring(getbodyinfo.comment),chr(10)," ","all")>
        <cfset iteminfo[4] = ''>
		<cfset info=''>
        </cfif>
	        
			<cfloop index="a" from="1" to="4">
				<cfif iteminfo[a] neq "" and iteminfo[a] neq "XCOST">
					<cfif a neq 4>
						<cfset info = info&iteminfo[a]&chr(10)>
					<cfelse>
						<cfset info = info&iteminfo[a]>
					</cfif>
				</cfif>
			</cfloop>
		
		
		<cfif info neq "">
			<cfset str = ListGetAt(info,1,chr(13)&chr(10))>
		<cfelse>
			<cfset str ="">
		</cfif>
		<cfset recordcnt = ListLen(info,chr(13)&chr(10))>
		
        <cfif getbodyinfo.title_desp neq ''>
        <cfquery name="InsertICBil_S" datasource='#dts#'>
			Insert into r_icbil_s (SRefno, No, ItemNo, Desp, SN_No, Unit, Qty, Price, Amt,dispec1,dispec2,brem1,brem2)
			values ('#jsstringformat(getbodyinfo.refno)#','#j#','#jsstringformat(getbodyinfo.itemno)#','#jsstringformat(str)#','#mylist1#',
			'#jsstringformat(getbodyinfo.unit_bil)#','#jsstringformat(getbodyinfo.qty_bil)#','#jsstringformat(getbodyinfo.price_bil)#','#jsstringformat(getbodyinfo.amt_bil)#',
			'#jsstringformat(getbodyinfo.disamt_bil)#','#jsstringformat(getbodyinfo.taxamt_bil)#','#jsstringformat(getbodyinfo.brem1)#','#jsstringformat(getbodyinfo.brem2)#')
		</cfquery>
        <cfelse>
		<cfquery name="InsertICBil_S" datasource='#dts#'>
			Insert into r_icbil_s (SRefno, No, ItemNo, Desp, SN_No, Unit, Qty, Price, Amt,dispec1,dispec2, counter_1,brem1,brem2)
			values ('#jsstringformat(getbodyinfo.refno)#','#j#','#jsstringformat(getbodyinfo.itemno)#','#jsstringformat(str)#','#mylist1#',
			'#jsstringformat(getbodyinfo.unit_bil)#','#jsstringformat(getbodyinfo.qty_bil)#','#jsstringformat(getbodyinfo.price_bil)#','#jsstringformat(getbodyinfo.amt_bil)#',
			'#jsstringformat(getbodyinfo.disamt_bil)#','#jsstringformat(getbodyinfo.taxamt_bil)#','#jsstringformat(getbodyinfo.currentrow)#','#jsstringformat(getbodyinfo.brem1)#','#jsstringformat(getbodyinfo.brem2)#')
		</cfquery>
        </cfif>
		
		<cfset j = j + 1>
		
		<cfif recordcnt gt 1>
			<cfloop from="2" to="#recordcnt#" index="i">
				<cfset str = ListGetAt(info,i,chr(13)&chr(10))>
	            <cfset str1 = Replace(Left(str,1)," ","")>
				
				<cfset count = Len(str) - 1>
				<cfif count lte 0>
					<cfset count = 1>
				</cfif>
				<cfset str2 = Right(str,count)>
				<cfset str = str1 & str2>
				
				<cfif trim(str) neq "">
                <cfif getbodyinfo.title_desp neq '' and i eq 2>
                <cfquery name="InsertICBil_S" datasource='#dts#'>
		 				Insert into r_icbil_s (SRefno, No, ItemNo, Desp, SN_No, Unit, Qty, Price, Amt,dispec1,dispec2, counter_1,brem1,brem2)
			values ('#jsstringformat(getbodyinfo.refno)#','#j#','#jsstringformat(getbodyinfo.itemno)#','#jsstringformat(str)#','#mylist1#',
			'#jsstringformat(getbodyinfo.unit_bil)#','#jsstringformat(getbodyinfo.qty_bil)#','#jsstringformat(getbodyinfo.price_bil)#','#jsstringformat(getbodyinfo.amt_bil)#',
			'#jsstringformat(getbodyinfo.disamt_bil)#','#jsstringformat(getbodyinfo.taxamt_bil)#','#jsstringformat(getbodyinfo.currentrow)#','#jsstringformat(getbodyinfo.brem1)#','#jsstringformat(getbodyinfo.brem2)#')
		  			</cfquery>
                <cfelse>
					<cfquery name="InsertICBil_S" datasource='#dts#'>
		 				Insert into r_icbil_s (SRefno, No, Desp)
						values ('#jsstringformat(getbodyinfo.refno)#','#j#','#jsstringformat(str)#')
		  			</cfquery>
                </cfif>
					<cfset j = j + 1>
				</cfif>
			</cfloop>
		</cfif>	
	</cfloop>
</cfloop>
<cfquery name="update" datasource="#dts#">
	update r_icbil_s
	set counter_2 = #k#
	where No = #j-1#
</cfquery>

<cfquery name="MyQuery" datasource="#dts#">
  	select    r_icbil_m.*, r_icbil_s.*, CAST(r_icbil_s.comment AS BINARY) AS Cmd
  	from      r_icbil_m, r_icbil_s 
  	where     r_icbil_m.Refno = r_icbil_s.SRefno 
	order by r_icbil_s.no
</cfquery>

<cfquery name="getenduser" datasource="#dts#">
  	select * from driver where driverno='#getheaderinfo.van#'
</cfquery>

<!--- <cfreport template="#fname#" format="PDF" query="MyQuery" report="#fname#"><!--- or "FlashPaper" or "Excel" or "RTF" --->
	<cfreportparam name="decimalPlace_general" value="#getGSetup2.Decl_Uprice#">
	<cfreportparam name="decimalPlace_discount" value="#getGSetup2.Decl_Discount#">
	<cfreportparam name="custSupp" value="#ptype#">
	<cfreportparam name="prefix" value="#tran_prefix#">
	<cfreportparam name="suffix" value="#tran_suffix#">
	<cfreportparam name="dts" value="#dts#">
	<cfreportparam name="amsLink" value="#IIF(Hlinkams eq 'Y',DE('yes'),DE('no'))#">
	<cfreportparam name="compro" value="#getGSetup.compro#">
	<cfreportparam name="compro2" value="#getGSetup.compro2#">
	<cfreportparam name="compro3" value="#getGSetup.compro3#">
	<cfreportparam name="compro4" value="#getGSetup.compro4#">
	<cfreportparam name="compro5" value="#getGSetup.compro5#">
	<cfreportparam name="compro6" value="#getGSetup.compro6#">
	<cfreportparam name="compro7" value="#getGSetup.compro7#">
    <cfreportparam name="comuen" value="#getGSetup.comuen#">
    <cfreportparam name="gstno" value="#getGSetup.gstno#">
    <cfreportparam name="jobno" value="#getheaderinfo.job#">
    <cfreportparam name="driver" value="#getheaderinfo.van#">
    <cfreportparam name="created_by" value="#getheaderinfo.created_by#">
    <cfreportparam name="name" value="#getenduser.name#">
    <cfreportparam name="name2" value="#getenduser.name2#">
    <cfreportparam name="add1" value="#getenduser.add1#">
    <cfreportparam name="add2" value="#getenduser.add2#">
    <cfreportparam name="add3" value="#getenduser.add3#">
    <cfreportparam name="contact" value="#getenduser.contact#">
    <cfreportparam name="fax" value="#getenduser.fax#">
    <cfreportparam name="attn" value="#getenduser.attn#">
    <cfreportparam name="userid" value="#huserid#">
</cfreport> --->