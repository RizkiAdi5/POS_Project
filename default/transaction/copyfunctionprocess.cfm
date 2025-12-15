<cfset deli = "`">
	
    <cfquery name="getgsetup2" datasource="#dts#">
					select * from gsetup
					</cfquery>
    
<cfif not isdefined("url.status")>
	<!--- <cfinvoke component="cfc.period" method="getCurrentPeriod" dts="#dts#" inputDate="#form.f_cdate#" returnvariable="readperiod"/> --->
    <cfset f_cdate1 = dateformat(now(),'yyyy/mm/dd')>
    <cfset ndate = dateformat(now(),'yyyy-mm-dd')>
	<cfinvoke component="cfc.period" method="getCurrentPeriod" dts="#dts#" inputDate="#dateformat(ndate,'yyyy-mm-dd')#" returnvariable="readperiod"/>
	<cfset form.f_period = readperiod>
	
	<cffunction name="updateQinQout" output="false">
		<cfargument name="qty" required="yes">
		<cfargument name="itemno" required="yes">
		<cfargument name="type" required="yes">
		<cfargument name="period" default="#form.f_period#" required="no">
		
		<cftry>
			<cfif arguments.type eq "TR">
				<cfquery name="UpdateIcitem" datasource="#dts#">
					update icitem set QIN#(arguments.period+10)#=(QIN#(arguments.period+10)#+#arguments.qty#),
					QOUT#(arguments.period+10)#=(QOUT#(arguments.period+10)#+#arguments.qty#) 
					where itemno='#arguments.itemno#'
				</cfquery>
			<cfelseif arguments.type neq "SO" and arguments.type neq "PO" and arguments.type neq "QUO">
				<cfif arguments.type eq "OAI" or arguments.type eq "RC" or arguments.type eq "DN">
					<cfset qname='QIN'&(arguments.period+10)>
				<cfelse>
					<cfset qname='QOUT'&(arguments.period+10)>
				</cfif>
			
				<cfquery name="UpdateIcitem" datasource="#dts#">
					update icitem set #qname#=(#qname#+#arguments.qty#) where itemno='#arguments.itemno#'
				</cfquery>
			</cfif>
			<cfcatch type="any">
			
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="updateGSetupF">
		<!---cfargument name="gcode2" required="yes"--->
		<cfargument name="gtype" required="yes">
		<cfargument name="gcount" required="yes">
		<cfargument name="nexttranno" required="yes">
		<cfargument name="actualtranno" required="yes">
        <cfargument name="custno" required="yes">
		<cfset nt=arguments.nexttranno>
		<cfset actualnt=arguments.actualtranno>
		<cfset isExist=1>
        <cfquery name="checkcustrefno" datasource="#dts#">
                select * from #target_arcust#
                </cfquery>

		
		<cfloop condition="isExist eq 1">
			<!---cfquery datasource="#dts#" name="checkExist">
				Select #arguments.gcode2# as billno from gsetup where #arguments.gcode2#='#nt#'
			</cfquery--->
			<!--- <cfquery datasource="main" name="checkExist">
				Select lastUsedNo as billno 
				from refnoset 
				where lastUsedNo ='#nt#'
				and userDept = '#dts#'
				and type = '#arguments.gtype#'
				and counter = '#arguments.gcount#'
			</cfquery> --->
			<!--- <cfquery datasource="#dts#" name="checkExist">
				Select lastUsedNo as billno 
				from refnoset 
				where lastUsedNo ='#nt#'
				and type = '#arguments.gtype#'
				and counter = '#arguments.gcount#'
			</cfquery> --->
			<cfquery datasource="#dts#" name="checkExist">
				Select refno as billno 
				from artran 
				where refno ='#nt#'
				and type = '#arguments.gtype#'
			</cfquery>
			<cfif checkExist.recordcount neq 0>
				<cfset isExist=1>
				<!--- <cfinvoke component="cfc.incrementValue" method="getIncreament" input="#nt#" returnvariable="nt"/> --->
				<!--- <cfinvoke component="cfc.refno" method="processNum" oldNum="#nt#" returnvariable="nt" /> --->
                <!--- by customer refno---->
                
            <cfif getgsetup2.prefixbycustquo eq 'Y' and arguments.gtype eq 'QUO' and checkcustrefno.arrem2 neq ''>
            <cfquery name="updategsetup" datasource="#dts#">
			update #target_arcust# set arrem2=UPPER('#actualnt#') where custno ='#arguments.custno#'
  			</cfquery>
            <cfquery name="getGsetup" datasource="#dts#">
			Select arrem2 as tranno
						from #target_arcust#
						where custno='#arguments.custno#'
  			</cfquery>
            <cfinvoke component="cfc.refno" method="processNum" oldNum="#getGsetup.tranno#" returnvariable="newnextNum" />
		        	<cfset actualnt = newnextNum>
		            <cfset nt = listgetat(arguments.custno,2,'/')&'-'&actualnt>
            
             <cfelseif getgsetup2.prefixbycustso eq 'Y' and arguments.gtype eq 'SO' and checkcustrefno.arrem3 neq ''>
            <cfquery name="updategsetup" datasource="#dts#">
			update #target_arcust# set arrem3=UPPER('#actualnt#') where custno ='#arguments.custno#'
  			</cfquery>
             <cfquery name="getGsetup" datasource="#dts#">
			Select arrem3 as tranno
						from #target_arcust#
						where custno='#arguments.custno#'
  			</cfquery>
            <cfinvoke component="cfc.refno" method="processNum" oldNum="#getGsetup.tranno#" returnvariable="newnextNum" />
		        	<cfset actualnt = newnextNum>
		            <cfset nt = listgetat(arguments.custno,2,'/')&'-'&actualnt>
            
            <cfelseif getgsetup2.prefixbycustinv eq 'Y' and arguments.gtype eq 'INV' and checkcustrefno.arrem4 neq ''>
            <cfquery name="updategsetup" datasource="#dts#">
			update #target_arcust# set arrem4=UPPER('#actualnt#') where custno ='#arguments.custno#'
  			</cfquery>
            <cfquery name="getGsetup" datasource="#dts#">
			Select arrem4 as tranno
						from #target_arcust#
						where custno='#arguments.custno#'
  			</cfquery>
					<cfinvoke component="cfc.refno" method="processNum" oldNum="#getGsetup.tranno#" returnvariable="newnextNum" />
		        	<cfset actualnt = newnextNum>
		            <cfset nt = listgetat(arguments.custno,2,'/')&'-'&actualnt>
                <!--- end by customer---->
                
                <cfelse>
				<cfif actualnt neq "">
                
					<cfquery name="updategsetup" datasource="#dts#">
						update refnoset 
						set lastUsedNo=<cfif actualnt neq "">'#actualnt#'<cfelse>'#nt#'</cfif>
						where type = '#arguments.gtype#'
						and counter = '#arguments.gcount#'
					</cfquery>
					<cfquery datasource="#dts#" name="getGsetup">
						Select lastUsedNo as tranno,refnoused as arun,refnocode,refnocode2,presuffixuse 
						from refnoset 
						where type = '#arguments.gtype#'
						and counter = '#arguments.gcount#'
					</cfquery>
					<cfinvoke component="cfc.refno" method="processNum" oldNum="#getGsetup.tranno#" returnvariable="newnextNum" />
		        	<cfset actualnt = newnextNum>
		            <cfif (getGsetup.refnocode2 neq "" or getGsetup.refnocode neq "") and getGsetup.presuffixuse eq "1">
						<cfset nt = getGsetup.refnocode&actualnt&getGsetup.refnocode2>
		            <cfelse>
		            	<cfset nt = actualnt>
					</cfif>
				<cfelse>
					<cfinvoke component="cfc.refno" method="processNum" oldNum="#nt#" returnvariable="nt" />
				</cfif>
                </cfif>
			<cfelse>
				<cfset isExist=0>
				<!---cfquery name="updategsetup" datasource="#dts#">
					update gsetup set #arguments.gcode2#='#nt#'
				</cfquery--->
				<!--- <cfquery name="updategsetup" datasource="main">
					update refnoset 
					set lastUsedNo='#nt#'
					where userDept = '#dts#'
					and type = '#arguments.gtype#'
					and counter = '#arguments.gcount#'
				</cfquery> --->
				<!--- <cfquery name="updategsetup" datasource="#dts#">
					update refnoset 
					set lastUsedNo='#nt#'
					where type = '#arguments.gtype#'
					and counter = '#arguments.gcount#'
				</cfquery> --->
                <cfquery name="checkcustrefno" datasource="#dts#">
                select * from #target_arcust#
                </cfquery>
                <cfif getgsetup2.prefixbycustquo eq 'Y' and arguments.gtype eq 'QUO' and checkcustrefno.arrem2 neq ''>
            <cfquery name="updategsetup" datasource="#dts#">
			update #target_arcust# set arrem2=UPPER('#actualnt#') where custno ='#arguments.custno#'
  			</cfquery>

             <cfelseif getgsetup2.prefixbycustso eq 'Y' and arguments.gtype eq 'SO' and checkcustrefno.arrem3 neq ''>
            <cfquery name="updategsetup" datasource="#dts#">
			update #target_arcust# set arrem3=UPPER('#actualnt#') where custno ='#arguments.custno#'
  			</cfquery>
            
            <cfelseif getgsetup2.prefixbycustinv eq 'Y' and arguments.gtype eq 'INV' and checkcustrefno.arrem4 neq ''>
            <cfquery name="updategsetup" datasource="#dts#">
			update #target_arcust# set arrem4=UPPER('#actualnt#') where custno ='#arguments.custno#'
  			</cfquery>
           	<cfelse>
				<cfquery name="updategsetup" datasource="#dts#">
					update refnoset 
					set lastUsedNo=<cfif actualnt neq "">'#actualnt#'<cfelse>'#nt#'</cfif>
					where type = '#arguments.gtype#'
					and counter = '#arguments.gcount#'
				</cfquery>
                </cfif>
			</cfif>
		</cfloop>1
		<cfreturn nt>
	</cffunction>
	
	<cffunction name="updateArtran" output="false">
		<cfargument name="custno" default="">
		<cfargument name="custName" default="">
		<cfargument name="newRefno" required="yes">
		<cfargument name="newDate" required="yes">
		<cfargument name="newType" required="yes">
		<cfargument name="fromType" required="yes"> 
		<cfargument name="resultSet" required="yes" type="query">
		
		<cfquery datasource="#dts#" name="insertartran">
			Insert into artran (type,refno,refno2,custno,
			fperiod,wos_date,agenno,currrate,gross_bil,disc1_bil,
			disc2_bil,disc3_bil,disc_bil,net_bil,tax1_bil,tax2_bil,
			tax3_bil,tax_bil,grand_bil,debit_bil,credit_bil,invgross,
			disp1,disp2,disp3,discount1,discount2,discount3,
			discount,net,tax1,tax2,tax3,tax,taxp1,
			taxp2,taxp3,grand,debitamt,creditamt,note,term,
			van,pono,dono,rem0,rem1,
			rem2,rem3,rem4,rem5,rem6,
			rem7,rem8,rem9,rem10,rem11,rem12,frem0,
			frem1,frem2,frem3,frem4,frem5,frem6,frem7,
			frem8,frem9,comm0,comm1,comm2,comm3,comm4,generated,toinv,
			exported,exported1,exported2,exported3,
			name,phonea,trdatetime,userid,currcode,
			trancode,desp,despa,area,source,job,mc1_bil,
			mc2_bil,m_charge1,m_charge2,cs_pm_cash,cs_pm_cheq,cs_pm_crcd,
			cs_pm_crc2,cs_pm_dbcd,cs_pm_vouc,deposit,cs_pm_debt,cs_pm_wht,
			checkno,impstage,billcost,billsale,paiddate,
			paidamt,refno3,age,iscash,del_by,pla_dodate,
			act_dodate,urgency,currrate2,staxacc,supp1,
			supp2,order_cl,last_year,posted,printed,lokstatus,void,pono2,dono2,csgtrans,taxincl,
			tableno,cashier,member,counter,tourgroup,time,
			xtrcost,xtrcost2,point,bperiod,vperiod,
			bdate,rem13,rem14,mc3_bil,mc4_bil,
			mc5_bil,mc6_bil,mc7_bil,m_charge3,m_charge4,m_charge5,
			m_charge6,m_charge7,special_account_code,created_by,created_on,updated_by,updated_on)
			
			values('#arguments.newType#','#arguments.newRefno#','#resultSet.refno2#',<cfif arguments.custno eq "">'#resultSet.custno#'<cfelse>'#arguments.custno#'</cfif>,
			'#form.f_period#','#arguments.newDate#','#resultSet.agenno#','#resultSet.currrate#','#resultSet.gross_bil#','#resultSet.disc1_bil#',
			'#resultSet.disc2_bil#','#resultSet.disc3_bil#','#resultSet.disc_bil#','#resultSet.net_bil#','#resultSet.tax1_bil#','#resultSet.tax2_bil#',
			'#resultSet.tax3_bil#','#resultSet.tax_bil#','#resultSet.grand_bil#','#resultSet.debit_bil#','#resultSet.credit_bil#','#resultSet.invgross#',
			'#resultSet.disp1#','#resultSet.disp2#','#resultSet.disp3#','#resultSet.discount1#','#resultSet.discount2#','#resultSet.discount3#',
			'#resultSet.discount#','#resultSet.net#','#resultSet.tax1#','#resultSet.tax2#','#resultSet.tax3#','#resultSet.tax#','#resultSet.taxp1#',
			'#resultSet.taxp2#','#resultSet.taxp3#','#resultSet.grand#','#resultSet.debitamt#','#resultSet.creditamt#','#resultSet.note#','#resultSet.term#',
			'#resultSet.van#','#resultSet.pono#','#resultSet.dono#','#resultSet.rem0#',<cfif arguments.fromType eq "TR" and arguments.newType neq "TR">'',
			'#resultSet.rem2#'<cfelse>'#resultSet.rem1#','#resultSet.rem2#'</cfif>,'#resultSet.rem3#','#resultSet.rem4#','#resultSet.rem5#','#resultSet.rem6#',
			'#resultSet.rem7#','#resultSet.rem8#',
			<!--- '#iif(isdate(resultSet.rem9),DE(lsdateformat(resultSet.rem9,"yyyy-mm-dd")),DE(resultSet.rem9))#', --->
			<cfif lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i">
				'#resultSet.rem9#'
			<cfelse>
				<cfif isdate(resultSet.rem9) eq "Yes">#lsdateformat(resultSet.rem9,"yyyy-mm-dd")#<cfelse>'#resultSet.rem9#'</cfif>
			</cfif>,
			'#resultSet.rem10#',
			<!--- '#iif(isdate(resultSet.rem11),DE(lsdateformat(resultSet.rem11,"yyyy-mm-dd")),DE(resultSet.rem11))#', --->
			<cfif lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i">
				'#resultSet.rem11#'
			<cfelse>
				<cfif isdate(resultSet.rem11) eq "Yes">#lsdateformat(resultSet.rem11,"yyyy-mm-dd")#<cfelse>'#resultSet.rem11#'</cfif>
			</cfif>,
			'#resultSet.rem12#','#resultSet.frem0#',
			'#resultSet.frem1#','#resultSet.frem2#','#resultSet.frem3#','#resultSet.frem4#','#resultSet.frem5#','#resultSet.frem6#','#resultSet.frem7#',
			'#resultSet.frem8#','#resultSet.frem9#','#resultSet.comm0#','#resultSet.comm1#','#resultSet.comm2#','#resultSet.comm3#','#resultSet.comm4#','','',
			'#resultSet.exported#','<cfif resultSet.exported1 eq "">0000-00-00<cfelse>#lsdateformat(resultSet.exported1,"yyyy-mm-dd")#</cfif>','#resultSet.exported2#','<cfif resultSet.exported3 eq "">0000-00-00<cfelse>#lsdateformat(resultSet.exported3,"yyyy-mm-dd")#</cfif>',
			<cfif arguments.custno eq "">'#resultSet.name#'<cfelse>'#arguments.custName#'</cfif>,'#resultSet.phonea#',
			now(),'#huserid#','#resultSet.currcode#',
			'#resultSet.trancode#','#resultSet.desp#','#resultSet.despa#','#resultSet.area#','#resultSet.source#','#resultSet.job#','#resultSet.mc1_bil#',
			'#resultSet.mc2_bil#','#resultSet.m_charge1#','#resultSet.m_charge2#','#resultSet.cs_pm_cash#','#resultSet.cs_pm_cheq#','#resultSet.cs_pm_crcd#',
			'#resultSet.cs_pm_crc2#','#resultSet.cs_pm_dbcd#','#resultSet.cs_pm_vouc#','#resultSet.deposit#','#resultSet.cs_pm_debt#','#resultSet.cs_pm_wht#',
			'#resultSet.checkno#','#resultSet.impstage#','#resultSet.billcost#','#resultSet.billsale#','<cfif resultSet.paiddate eq "">0000-00-00<cfelse>#lsdateformat(resultSet.paiddate,"yyyy-mm-dd")#</cfif>',
			'#resultSet.paidamt#','#resultSet.refno3#','#resultSet.age#','#resultSet.iscash#','','<cfif resultSet.pla_dodate eq "">0000-00-00<cfelse>#lsdateformat(resultSet.pla_dodate,"yyyy-mm-dd")#</cfif>',
			'<cfif resultSet.act_dodate eq "">0000-00-00<cfelse>#lsdateformat(resultSet.act_dodate,"yyyy-mm-dd")#</cfif>','#resultSet.urgency#','#resultSet.currrate2#','#resultSet.staxacc#','#resultSet.supp1#',
			'#resultSet.supp2#','','#resultSet.last_year#','','#resultSet.printed#','#resultSet.lokstatus#','#resultSet.void#','','','#resultSet.csgtrans#','',
			'#resultSet.tableno#','#resultSet.cashier#','#resultSet.member#','#resultSet.counter#','#resultSet.tourgroup#','#resultSet.time#',
			'#resultSet.xtrcost#','#resultSet.xtrcost2#','#resultSet.point#','#resultSet.bperiod#','#resultSet.vperiod#',
			'<cfif resultSet.bdate eq "">0000-00-00<cfelse>#lsdateformat(resultSet.bdate,"yyyy-mm-dd")#</cfif>','#resultSet.rem13#','#resultSet.rem14#','#resultSet.mc3_bil#','#resultSet.mc4_bil#',
			'#resultSet.mc5_bil#','#resultSet.mc6_bil#','#resultSet.mc7_bil#','#resultSet.m_charge3#','#resultSet.m_charge4#','#resultSet.m_charge5#',
			'#resultSet.m_charge6#','#resultSet.m_charge7#','#resultSet.special_account_code#','#HUserID#',#now()#,'#HUserID#',#now()#)
		</cfquery>
	</cffunction>
	
	<cffunction name="updateIctran" output="false">
		<cfargument name="custno" default="">
		<cfargument name="custName" default="">
		<cfargument name="newRefno" required="yes">
		<cfargument name="newDate" required="yes">
		<cfargument name="resultSet" required="yes" type="query">
		
		<cfquery name="insertictran" datasource="#dts#">
			Insert into ictran (type,refno,refno2,trancode,custno,
			fperiod,wos_date,currrate,itemcount,itemno,
			desp,despa,agenno,location,qty_bil,price_bil,
			unit_bil,amt1_bil,dispec1,dispec2,dispec3,disamt_bil,
			amt_bil,taxpec1,taxpec2,taxpec3,taxamt_bil,qty,
			price,unit,amt1,disamt,amt,taxamt,dono,brem1,
			brem2,brem3,brem4,grade,name,
			generated,toinv,exported,exported1,exported2,
			exported3,sono,userid,wos_group,category,trdatetime,bomno,
			comment,linecode,source,job,sign,impstage,
			factor1,factor2,dodate,sodate,packing,note1,note2,gltradac,
			updcost,gst_item,totalup,withsn,pur_price,qty1,
			qty2,qty3,qty4,qty5,qty6,qty7,qty_ret,
			tempfigi,sercost,m_charge1,m_charge2,adtcost1,adtcost2,
			it_cos,av_cost,batchcode,expdate,point,
			inv_disc,inv_tax,supp,edi_cou1,writeoff,toship,shipped,del_by,van,
			ud_qty,brk_to,sv_part,last_year,void,mc1_bil,
			mc2_bil,damt,oldbill,area,shelf,temp,temp1,
			body,totalgroup,mark,type_seq,promoter,tableno,
			member,tourgroup,time,defective,m_charge3,m_charge4,
			m_charge5,m_charge6,m_charge7,mc3_bil,mc4_bil,mc5_bil,
			mc6_bil,mc7_bil,note_a)
			
			values('#iif(form.ft eq "TR",DE(resultSet.type),DE(form.ft))#','#arguments.newRefno#','#resultSet.refno2#','#resultSet.trancode#',<cfif arguments.custno eq "">'#resultSet.custno#'
			<cfelse>'#arguments.custno#'</cfif>,'#form.f_period#','#arguments.newDate#','#resultSet.currrate#','#resultSet.itemcount#','#resultSet.itemno#',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#resultSet.desp#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#resultSet.despa#">,
			'#resultSet.agenno#','#resultSet.location#','#resultSet.qty_bil#','#resultSet.price_bil#',
			'#resultSet.unit_bil#','#resultSet.amt1_bil#','#resultSet.dispec1#','#resultSet.dispec2#','#resultSet.dispec3#','#resultSet.disamt_bil#',
			'#resultSet.amt_bil#','#resultSet.taxpec1#','#resultSet.taxpec2#','#resultSet.taxpec3#','#resultSet.taxamt_bil#','#resultSet.qty#',
			'#resultSet.price#','#resultSet.unit#','#resultSet.amt1#','#resultSet.disamt#','#resultSet.amt#','#resultSet.taxamt#','','#resultSet.brem1#',
			'#resultSet.brem2#','#resultSet.brem3#','#resultSet.brem4#','#resultSet.grade#',<cfif arguments.custno eq "">'#resultSet.name#'
			<cfelse>'#arguments.custName#'</cfif>,'','','#resultSet.exported#','<cfif resultSet.exported1 eq "">0000-00-00<cfelse>#lsdateformat(resultSet.exported1,"yyyy-mm-dd")#</cfif>','#resultSet.exported2#',
			'<cfif resultSet.exported3 eq "">0000-00-00<cfelse>#lsdateformat(resultSet.exported3,"yyyy-mm-dd")#</cfif>','','#huserid#','#resultSet.wos_group#','#resultSet.category#',now(),'#resultSet.bomno#',
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(resultSet.comment)#">,'#resultSet.linecode#','#resultSet.source#','#resultSet.job#','#resultSet.sign#','#resultSet.impstage#',
			'#resultSet.factor1#','#resultSet.factor2#','0000-00-00','0000-00-00','#resultSet.packing#','#resultSet.note1#','#resultSet.note2#','#resultSet.gltradac#',
			'#resultSet.updcost#','#resultSet.gst_item#','#resultSet.totalup#','#resultSet.withsn#','#resultSet.pur_price#','#resultSet.qty1#',
			'#resultSet.qty2#','#resultSet.qty3#','#resultSet.qty4#','#resultSet.qty5#','#resultSet.qty6#','#resultSet.qty7#','#resultSet.qty_ret#',
			'#resultSet.tempfigi#','#resultSet.sercost#','#resultSet.m_charge1#','#resultSet.m_charge2#','#resultSet.adtcost1#','#resultSet.adtcost2#',
			'#resultSet.it_cos#','#resultSet.av_cost#','#resultSet.batchcode#','<cfif resultSet.expdate eq "">0000-00-00<cfelse>#lsdateformat(resultSet.expdate,"yyyy-mm-dd")#</cfif>','#resultSet.point#',
			'#resultSet.inv_disc#','#resultSet.inv_tax#','#resultSet.supp#','#resultSet.edi_cou1#','#resultSet.writeoff#','0.00000','0.00000','','#resultSet.van#',
			'#resultSet.ud_qty#','#resultSet.brk_to#','#resultSet.sv_part#','#resultSet.last_year#','#resultSet.void#','#resultSet.mc1_bil#',
			'#resultSet.mc2_bil#','#resultSet.damt#','#resultSet.oldbill#','#resultSet.area#','#resultSet.shelf#','#resultSet.temp#','#resultSet.temp1#',
			'#resultSet.body#','#resultSet.totalgroup#','#resultSet.mark#','#resultSet.type_seq#','#resultSet.promoter#','#resultSet.tableno#',
			'#resultSet.member#','#resultSet.tourgroup#','#resultSet.time#','#resultSet.defective#','#resultSet.m_charge3#','#resultSet.m_charge4#',
			'#resultSet.m_charge5#','#resultSet.m_charge6#','#resultSet.m_charge7#','#resultSet.mc3_bil#','#resultSet.mc4_bil#','#resultSet.mc5_bil#',
			'#resultSet.mc6_bil#','#resultSet.mc7_bil#','#resultSet.note_a#')
		</cfquery>	
	</cffunction>
	
	<cffunction name="updateAddress" output="false">
		<cfargument name="refno" required="yes">
		<cfargument name="type" required="yes">
		<cfargument name="custno" required="yes">
		
		<cfquery name="update_artran" datasource="#dts#">
			Update artran, 
			<cfif arguments.type eq "RC" or arguments.type eq "PO" or arguments.type eq "PR">#target_apvend#<cfelse>#target_arcust#</cfif> as getCust
			set rem0='Profile', rem2=getCust.attn,rem4=getCust.phone, 
			frem2=getCust.add1, frem3=getCust.add2,
			frem4=getCust.add3, frem5=getCust.add4, rem13='', 
			frem0=getCust.name, frem1=getCust.name2, frem6=getCust.fax, artran.phonea=getCust.phonea
			<cfif arguments.type eq 'PO' or arguments.type eq 'SO' or arguments.type eq 'DO' or arguments.type eq 'INV'>
			, rem1='Profile', rem3=getCust.dattn , rem12=getCust.dphone
			, rem14='', frem7=getCust.name, frem8=getCust.name2
			, comm0=getCust.daddr1, comm1=getCust.daddr2, comm2=getCust.daddr3
			, comm3=getCust.daddr4, comm4=getCust.dfax
			</cfif>
			where refno='#arguments.refno#' and type='#arguments.type#' and artran.custno=getCust.custno
		</cfquery>
	</cffunction>
	
    <!--- Add On 061008, For Graded Item --->
    <cffunction name="updateIgrade" output="false">
		<cfargument name="custno" default="">
		<cfargument name="newRefno" required="yes">
		<cfargument name="newDate" required="yes">
		<cfargument name="resultSet" required="yes" type="query">
        
        <cfquery name="insertigrade" datasource="#dts#">
            insert into igrade
            (type,refno,trancode,itemno,wos_date,fperiod,sign,del_by,location,void,generated,custno,exported,factor1,factor2,
            <cfloop from="11" to="160" index="k">
                <cfif k neq 160>
                    GRD#k#,
                <cfelse>
                    GRD#k#
                </cfif>
            </cfloop>)
            values
            ('#iif(form.ft eq "TR",DE(resultSet.type),DE(form.ft))#','#arguments.newRefno#','#resultSet.trancode#',
            '#resultSet.itemno#','#arguments.newDate#','#form.f_period#',
            <cfif form.ft neq "TR">
				<cfif form.ft eq "RC" or form.ft eq "PO" or form.ft eq "CN" or form.ft eq "OAI">'1'<cfelse>'-1'</cfif>
			<cfelse>
				<cfif resultSet.type eq "TRIN">'1'<cfelse>'-1'</cfif>
			</cfif>,
            '','#resultSet.location#','','',
            <cfif arguments.custno eq "">'#resultSet.custno#'<cfelse>'#arguments.custno#'</cfif>,'','#resultSet.factor1#','#resultSet.factor2#',
            <cfloop from="11" to="160" index="k">
                <cfif k neq 160>
                    #Evaluate("resultSet.GRD#k#")#,
                <cfelse>
                    #Evaluate("resultSet.GRD#k#")#
                </cfif>
            </cfloop>)
        </cfquery>
        
        <cfif form.ft neq "SO" and form.ft neq "PO" and form.ft neq "QUO" and form.ft neq "SAM">
			<cfif form.ft neq "TR">
				<cfquery name="updateitemgrd" datasource="#dts#">
                    update itemgrd
                    set
                    <cfloop from="11" to="160" index="k">
                        <cfif k neq 160>
                            bgrd#k# = bgrd#k#<cfif form.ft eq "OAI" or form.ft eq "RC" or form.ft eq "CN">+<cfelse>-</cfif>
                            <cfif val(resultSet.factor2) neq 0>
                                (#Evaluate("resultSet.GRD#k#")# * #resultSet.factor1# / #resultSet.factor2#)
                            <cfelse>
                                0
                            </cfif>,
                        <cfelse>
                            bgrd#k# = bgrd#k#<cfif form.ft eq "OAI" or form.ft eq "RC" or form.ft eq "CN">+<cfelse>-</cfif>
                            <cfif val(resultSet.factor2) neq 0>
                                (#Evaluate("resultSet.GRD#k#")# * #resultSet.factor1# / #resultSet.factor2#)
                            <cfelse>
                                0
                            </cfif>
                        </cfif>
                    </cfloop>
                    where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#resultSet.itemno#">
                </cfquery>
            
                <cfquery name="updatelogrdob" datasource="#dts#">
                    update logrdob
                    set
                    <cfloop from="11" to="160" index="k">
                        <cfif k neq 160>
                           bgrd#k# = bgrd#k#<cfif form.ft eq "OAI" or form.ft eq "RC" or form.ft eq "CN">+<cfelse>-</cfif>
                            <cfif val(resultSet.factor2) neq 0>
                                (#Evaluate("resultSet.GRD#k#")# * #resultSet.factor1# / #resultSet.factor2#)
                            <cfelse>
                                0
                            </cfif>,
                        <cfelse>
                            bgrd#k# = bgrd#k#<cfif form.ft eq "OAI" or form.ft eq "RC" or form.ft eq "CN">+<cfelse>-</cfif>
                            <cfif val(resultSet.factor2) neq 0>
                                (#Evaluate("resultSet.GRD#k#")# * #resultSet.factor1# / #resultSet.factor2#)
                            <cfelse>
                                0
                            </cfif>
                        </cfif>
                    </cfloop>
                    where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#resultSet.itemno#">
                    and location = <cfqueryparam cfsqltype="cf_sql_char" value="#resultSet.location#">
                </cfquery>
			<cfelse>
                <cfquery name="updatelogrdob" datasource="#dts#">
                    update logrdob
                    set
                    <cfloop from="11" to="160" index="k">
                        <cfif k neq 160>
                           bgrd#k# = bgrd#k#<cfif resultSet.type eq "TRIN">+<cfelse>-</cfif>
                            <cfif val(resultSet.factor2) neq 0>
                                (#Evaluate("resultSet.GRD#k#")# * #resultSet.factor1# / #resultSet.factor2#)
                            <cfelse>
                                0
                            </cfif>,
                        <cfelse>
                            bgrd#k# = bgrd#k#<cfif resultSet.type eq "TRIN">+<cfelse>-</cfif>
                            <cfif val(resultSet.factor2) neq 0>
                                (#Evaluate("resultSet.GRD#k#")# * #resultSet.factor1# / #resultSet.factor2#)
                            <cfelse>
                                0
                            </cfif>
                        </cfif>
                    </cfloop>
                    where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#resultSet.itemno#">
                    and location = <cfqueryparam cfsqltype="cf_sql_char" value="#resultSet.location#">
                </cfquery>
			</cfif>
		</cfif>
    </cffunction>
    
	<cfset myArray = ArrayNew(1)>
	<cfset nexttranno=form.ft_refnofrom>
	<cfset actualrefno=form.ft_actualrefno>
    
	<cftry>
		<!--- <cfinvoke component="cfc.incrementValue" method="getIncreament" input="#nexttranno#" returnvariable="validate"/> --->
		<cfif trim(actualrefno) neq "">
			<cfset checkingrefno=actualrefno>
		<cfelse>
			<cfset checkingrefno=nexttranno>
		</cfif>
		<cfinvoke component="cfc.refno" method="processNum" oldNum="#checkingrefno#" returnvariable="validate" />
		<cfcatch type="any">
			<cflocation url="copy.cfm?errorMessage=Invalid Ref.no.Please try again." addtoken="no">
		</cfcatch>
	</cftry>
			
	<cfif form.ft eq "INV">
		<cfset gcode=form.ft>
	<cfelse>
		<cfset gcode="#LCase(form.ft)#no">
	</cfif>
	<cfset doctype = form.ft>
	<cfset refnocount = form.counter>
	<cfinvoke component="CFC.Date" method="getDbDate" inputDate="#dateformat(now(),'dd/mm/yyyy')#" returnvariable="wosDate"/>
	
	<cfquery name="getartran" datasource="#dts#">
		select * from artran where type='#form.ff_type#' and refno='#form.ff_refnofrom#'
		group by refno order by refno
	</cfquery>
	
    <cfif form.ft_refnofrom neq ''>
	<cfif getartran.recordcount gt 0>
		<!--- Empty Cust/Suppl --->
			<cfoutput query="getartran">
				<!---cfinvoke method="updateGSetupF" gcode2="#gcode#" nexttranno="#nexttranno#" returnvariable="nexttranno"/--->
				<cfif getartran.currentrow gt 1 and actualrefno neq "">
					<cfquery name="getLastUsed" datasource="#dts#">
						select lastUsedNo from refnoset 
						where type = '#doctype#'
						and counter = '#refnocount#'
					</cfquery>
                    
					<cfset actualrefno=getLastUsed.lastUsedNo>
                    
                    <!--- ---->
                    	<cfquery name="getcustprefixno" datasource="#dts#">
  						select * from #target_arcust# where custno='#getartran.custno#'
    					</cfquery>
                    
                    <cfif getgsetup2.prefixbycustquo eq 'Y' and form.ft eq 'QUO' and getcustprefixno.arrem2 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem2 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem2>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem2>
					</cfif>
            
          		  <cfif getgsetup2.prefixbycustso eq 'Y' and form.ft eq 'SO' and getcustprefixno.arrem3 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem3 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem3>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem3>
					</cfif>
            
           		 <cfif getgsetup2.prefixbycustinv eq 'Y' and form.ft eq 'INV' and getcustprefixno.arrem4 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem4 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem4>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem4>
					</cfif>
                    <!--- ---->
				</cfif>
                <cfquery name="getcustprefixno" datasource="#dts#">
  						select * from #target_arcust# where custno='#getartran.custno#'
    					</cfquery>
                    
                    <cfif getgsetup2.prefixbycustquo eq 'Y' and form.ft eq 'QUO' and getcustprefixno.arrem2 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem2 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem2>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem2>
					</cfif>
            
          		  <cfif getgsetup2.prefixbycustso eq 'Y' and form.ft eq 'SO' and getcustprefixno.arrem3 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem3 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem3>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem3>
					</cfif>
            
           		 <cfif getgsetup2.prefixbycustinv eq 'Y' and form.ft eq 'INV' and getcustprefixno.arrem4 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem4 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem4>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem4>
					</cfif>
                
				<cfinvoke method="updateGSetupF" gtype="#doctype#" gcount="#refnocount#" nexttranno="#nexttranno#" actualtranno="#actualrefno#" custno='#getartran.custno#' returnvariable="nexttranno"/>
				<cfinvoke method="updateArtran" newRefno="#nexttranno#" newDate="#wosDate#" fromType="#form.ff_type#" newType="#form.ft#" resultSet="#getartran#"/>
				
				<cfif getartran.type eq "TR">
					<cfif form.ft eq "TR">
						<cfquery name="getictran" datasource="#dts#">
							select * from ictran where (type='TROU' or type='TRIN') and refno='#getartran.refno#' order by itemcount
						</cfquery>
                        <!--- Add On 061008, For Graded Item --->
                        <cfquery name="getigrade" datasource="#dts#">
                            select * from igrade where (type='TROU' or type='TRIN') and refno='#getartran.refno#' order by trancode
                        </cfquery>
					<cfelse>
						<cfquery name="getictran" datasource="#dts#">
							select * from ictran where type='TROU' and refno='#getartran.refno#' order by itemcount
						</cfquery>
                        <!--- Add On 061008, For Graded Item --->
                        <cfquery name="getigrade" datasource="#dts#">
                            select * from igrade where type='TROU' and refno='#getartran.refno#' order by trancode
                        </cfquery>
					</cfif>
					
					<cfloop query="getictran">
						<cfinvoke method="updateIctran" newRefno="#nexttranno#" newDate="#wosDate#" resultSet="#getictran#"/>
						<cfinvoke method="updateQinQout" itemno="#itemno#" qty="#qty#" type="#form.ft#"/>
					</cfloop>
                    
                    <!--- Add On 061008, For Graded Item --->
					<cfif getigrade.recordcount neq 0>
						<cfloop query="getigrade">
                            <cfinvoke method="updateIgrade" newRefno="#nexttranno#" newDate="#wosDate#" resultSet="#getigrade#"/>
                        </cfloop>
					</cfif>
				<cfelse>
					<cfquery name="getictran" datasource="#dts#">
						select * from ictran where type='#getartran.type#' and refno='#getartran.refno#' order by itemcount
					</cfquery>
                    <!--- Add On 061008, For Graded Item --->
                    <cfquery name="getigrade" datasource="#dts#">
						select * from igrade where type='#getartran.type#' and refno='#getartran.refno#' order by trancode
					</cfquery>
					<cfif form.ft neq "TR">
						<cfloop query="getictran">
							<cfinvoke method="updateIctran" newRefno="#nexttranno#" newDate="#wosDate#" resultSet="#getictran#"/>
							<cfinvoke method="updateQinQout" itemno="#itemno#" qty="#qty#" type="#form.ft#"/>
						</cfloop>
                        
                        <!--- Add On 061008, For Graded Item --->
						<cfif getigrade.recordcount neq 0>
							<cfloop query="getigrade">
                            	<cfinvoke method="updateIgrade" newRefno="#nexttranno#" newDate="#wosDate#" resultSet="#getigrade#"/>
                            </cfloop>
						</cfif>
					</cfif>
				</cfif>
				<cfset ArrayAppend(myArray,"#ff_type#   #refno#  #custno#  ->  #ft#  #nexttranno#  #custno#")>
			</cfoutput>
            
		<cfset status = "Successfully Copy.">
	<cfelse><!--- getartran.recordcount eq 0 --->
		<cfset status = "Sorry. No record found.">
	</cfif>
    <cfelse>
    <cfset status = "Ref No Cannot be blank">
    </cfif>

	<cfset myList = ArrayToList(myArray,deli)>
	<cflocation url="copyfunctionprocess.cfm?status=#status#&myList=#myList#" addtoken="no">
<cfelse>
<html>
<head>
	<title></title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfoutput>
	<center><h3>#url.status#</h3></center>
	<br><br>
	<form action="" method="post">
	<table>
		<cfloop from="1" to="#listLen(url.myList,deli)#" index="i">
		<tr><td>#listgetat(url.myList,i,deli)#</td></tr>
		</cfloop>
	</table>
	<br><br>
	<div align="center"><input type="button" value="Close" onClick="window.close();window.opener.location.reload();"></div>
	</form>
</cfoutput>
</body>
</html>
</cfif>
<cfabort>