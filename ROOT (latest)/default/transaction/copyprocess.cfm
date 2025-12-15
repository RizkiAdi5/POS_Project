<cfset deli = "`">
	
    <cfquery name="getgsetup2" datasource="#dts#">
					select * from gsetup
					</cfquery>
    
<cfif not isdefined("url.status")>
	<!--- <cfinvoke component="cfc.period" method="getCurrentPeriod" dts="#dts#" inputDate="#form.f_cdate#" returnvariable="readperiod"/> --->
    <cfset f_cdate1 = createDate(ListGetAt(form.f_cdate,3,"/"),ListGetAt(form.f_cdate,2,"/"),ListGetAt(form.f_cdate,1,"/"))>
    <cfset ndate = createdate(right(form.f_cdate,4),mid(form.f_cdate,4,2),left(form.f_cdate,2))>
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
			
			values('#iif(form.ft_type eq "TR",DE(resultSet.type),DE(form.ft_type))#','#arguments.newRefno#','#resultSet.refno2#','#resultSet.trancode#',<cfif arguments.custno eq "">'#resultSet.custno#'
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
            ('#iif(form.ft_type eq "TR",DE(resultSet.type),DE(form.ft_type))#','#arguments.newRefno#','#resultSet.trancode#',
            '#resultSet.itemno#','#arguments.newDate#','#form.f_period#',
            <cfif form.ft_type neq "TR">
				<cfif form.ft_type eq "RC" or form.ft_type eq "PO" or form.ft_type eq "CN" or form.ft_type eq "OAI">'1'<cfelse>'-1'</cfif>
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
        
        <cfif form.ft_type neq "SO" and form.ft_type neq "PO" and form.ft_type neq "QUO" and form.ft_type neq "SAM">
			<cfif form.ft_type neq "TR">
				<cfquery name="updateitemgrd" datasource="#dts#">
                    update itemgrd
                    set
                    <cfloop from="11" to="160" index="k">
                        <cfif k neq 160>
                            bgrd#k# = bgrd#k#<cfif form.ft_type eq "OAI" or form.ft_type eq "RC" or form.ft_type eq "CN">+<cfelse>-</cfif>
                            <cfif val(resultSet.factor2) neq 0>
                                (#Evaluate("resultSet.GRD#k#")# * #resultSet.factor1# / #resultSet.factor2#)
                            <cfelse>
                                0
                            </cfif>,
                        <cfelse>
                            bgrd#k# = bgrd#k#<cfif form.ft_type eq "OAI" or form.ft_type eq "RC" or form.ft_type eq "CN">+<cfelse>-</cfif>
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
                           bgrd#k# = bgrd#k#<cfif form.ft_type eq "OAI" or form.ft_type eq "RC" or form.ft_type eq "CN">+<cfelse>-</cfif>
                            <cfif val(resultSet.factor2) neq 0>
                                (#Evaluate("resultSet.GRD#k#")# * #resultSet.factor1# / #resultSet.factor2#)
                            <cfelse>
                                0
                            </cfif>,
                        <cfelse>
                            bgrd#k# = bgrd#k#<cfif form.ft_type eq "OAI" or form.ft_type eq "RC" or form.ft_type eq "CN">+<cfelse>-</cfif>
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
			
	<cfif form.ft_type eq "INV">
		<cfset gcode=form.ft_type>
	<cfelse>
		<cfset gcode="#LCase(form.ft_type)#no">
	</cfif>
	<cfset doctype = form.ft_type>
	<cfset refnocount = form.counter>
	<cfinvoke component="CFC.Date" method="getDbDate" inputDate="#form.f_cdate#" returnvariable="wosDate"/>
	
	<cfquery name="getartran" datasource="#dts#">
		select * from artran where type='#form.ff_type#' and refno>='#form.ff_refnofrom#' and refno<='#form.ff_refnoto#' 
		group by refno order by refno
	</cfquery>

	<cfif getartran.recordcount gt 0>
		<cfif not isdefined("form.ft_nofrom") and not isdefined("form.ft_noto")><!--- Empty Cust/Suppl --->
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
                    
                    <cfif getgsetup2.prefixbycustquo eq 'Y' and form.ft_type eq 'QUO' and getcustprefixno.arrem2 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem2 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem2>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem2>
					</cfif>
            
          		  <cfif getgsetup2.prefixbycustso eq 'Y' and form.ft_type eq 'SO' and getcustprefixno.arrem3 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem3 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem3>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem3>
					</cfif>
            
           		 <cfif getgsetup2.prefixbycustinv eq 'Y' and form.ft_type eq 'INV' and getcustprefixno.arrem4 neq "">
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
                    
                    <cfif getgsetup2.prefixbycustquo eq 'Y' and form.ft_type eq 'QUO' and getcustprefixno.arrem2 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem2 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem2>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem2>
					</cfif>
            
          		  <cfif getgsetup2.prefixbycustso eq 'Y' and form.ft_type eq 'SO' and getcustprefixno.arrem3 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem3 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem3>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem3>
					</cfif>
            
           		 <cfif getgsetup2.prefixbycustinv eq 'Y' and form.ft_type eq 'INV' and getcustprefixno.arrem4 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem4 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem4>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem4>
					</cfif>
                
				<cfinvoke method="updateGSetupF" gtype="#doctype#" gcount="#refnocount#" nexttranno="#nexttranno#" actualtranno="#actualrefno#" custno='#getartran.custno#' returnvariable="nexttranno"/>
				<cfinvoke method="updateArtran" newRefno="#nexttranno#" newDate="#wosDate#" fromType="#form.ff_type#" newType="#form.ft_type#" resultSet="#getartran#"/>
				
				<cfif getartran.type eq "TR">
					<cfif form.ft_type eq "TR">
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
						<cfinvoke method="updateQinQout" itemno="#itemno#" qty="#qty#" type="#form.ft_type#"/>
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
					<cfif form.ft_type neq "TR">
						<cfloop query="getictran">
							<cfinvoke method="updateIctran" newRefno="#nexttranno#" newDate="#wosDate#" resultSet="#getictran#"/>
							<cfinvoke method="updateQinQout" itemno="#itemno#" qty="#qty#" type="#form.ft_type#"/>
						</cfloop>
                        
                        <!--- Add On 061008, For Graded Item --->
						<cfif getigrade.recordcount neq 0>
							<cfloop query="getigrade">
                            	<cfinvoke method="updateIgrade" newRefno="#nexttranno#" newDate="#wosDate#" resultSet="#getigrade#"/>
                            </cfloop>
						</cfif>
					</cfif>
				</cfif>
				<cfset ArrayAppend(myArray,"#ff_type#   #refno#  #custno#  ->  #ft_type#  #nexttranno#  #custno#")>
			</cfoutput>
		<cfelse><!--- More than 1 cust --->
			<cfquery name="get_cust" datasource="#dts#">
				SELECT custno,name FROM
				<cfif ft_type eq "RC" or ft_type eq "PO" or ft_type eq "PR">#target_apvend#<cfelse>#target_arcust#</cfif>
				where custno>='#ft_nofrom#' and custno<='#ft_noto#' 
			</cfquery>

			<cfloop query="get_cust">
				<cfset var_custno=get_cust.custno>
				<cfset var_custName=get_cust.name>
				
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
                    
                    <cfif getgsetup2.prefixbycustquo eq 'Y' and form.ft_type eq 'QUO' and getcustprefixno.arrem2 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem2 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem2>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem2>
					</cfif>
            
          		  <cfif getgsetup2.prefixbycustso eq 'Y' and form.ft_type eq 'SO' and getcustprefixno.arrem3 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem3 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem3>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem3>
					</cfif>
            
           		 <cfif getgsetup2.prefixbycustinv eq 'Y' and form.ft_type eq 'INV' and getcustprefixno.arrem4 neq "">
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
                    
                    <cfif getgsetup2.prefixbycustquo eq 'Y' and form.ft_type eq 'QUO' and getcustprefixno.arrem2 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem2 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem2>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem2>
					</cfif>
            
          		  <cfif getgsetup2.prefixbycustso eq 'Y' and form.ft_type eq 'SO' and getcustprefixno.arrem3 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem3 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem3>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem3>
					</cfif>
            
           		 <cfif getgsetup2.prefixbycustinv eq 'Y' and form.ft_type eq 'INV' and getcustprefixno.arrem4 neq "">
  					<cfquery name="getcustrefno" datasource="#dts#">
					select arrem4 from #target_arcust# where custno ='#getartran.custno#'
  					</cfquery>
					<cfset actualrefno=getcustrefno.arrem4>
                    <cfset nexttranno=listgetat(getcustprefixno.custno,2,'/')&'-'&getcustprefixno.arrem4>
					</cfif>
                    
					<cfinvoke method="updateGSetupF" gtype="#doctype#" gcount="#refnocount#" nexttranno="#nexttranno#" actualtranno="#actualrefno#" custno='#getartran.custno#' returnvariable="nexttranno"/>
					
					<cfinvoke method="updateArtran" custno="#var_custno#" custName="#var_custName#" newRefno="#nexttranno#" newDate="#wosDate#" 
					  fromType="#form.ff_type#" newType="#form.ft_type#" resultSet="#getartran#"/>
					<cfinvoke method="updateAddress" refno="#nexttranno#" type="#form.ft_type#" custno="#var_custno#"/>
					
					<cfif getartran.type eq "TR">
						<cfif form.ft_type eq "TR">
							<cfquery name="getictran" datasource="#dts#">
								select * from ictran where (type='TRIN' or type='TROU') and refno='#getartran.refno#' order by itemcount
							</cfquery>
                            <!--- Add On 061008, For Graded Item --->
                            <cfquery name="getigrade" datasource="#dts#">
                                select * from igrade where (type='TRIN' or type='TROU') and refno='#getartran.refno#' order by trancode
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
							<cfinvoke method="updateIctran" custno="#var_custno#" custName="#var_custName#" newRefno="#nexttranno#" newDate="#wosDate#" resultSet="#getictran#"/>
							<cfinvoke method="updateQinQout" itemno="#itemno#" qty="#qty#" type="#form.ft_type#"/>
						</cfloop>
                        
                        <!--- Add On 061008, For Graded Item --->
						<cfif getigrade.recordcount neq 0>
                            <cfloop query="getigrade">
                                <cfinvoke method="updateIgrade" custno="#var_custno#" newRefno="#nexttranno#" newDate="#wosDate#" resultSet="#getigrade#"/>
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
						<cfif form.ft_type neq "TR">
							<cfloop query="getictran">
								<cfinvoke method="updateIctran" custno="#var_custno#" custName="#var_custName#" newRefno="#nexttranno#" newDate="#wosDate#" resultSet="#getictran#"/>
								<cfinvoke method="updateQinQout" itemno="#itemno#" qty="#qty#" type="#form.ft_type#"/>
							</cfloop>
                            
                            <!--- Add On 061008, For Graded Item --->
							<cfif getigrade.recordcount neq 0>
                                <cfloop query="getigrade">
                                    <cfinvoke method="updateIgrade" custno="#var_custno#" newRefno="#nexttranno#" newDate="#wosDate#" resultSet="#getigrade#"/>
                                </cfloop>
                            </cfif>
						</cfif>
					</cfif>
					<cfset ArrayAppend(myArray,"#ff_type#   #getartran.refno#  #getartran.custno#  ->  #ft_type#  #nexttranno#  #var_custno#")>
				</cfoutput>
			</cfloop>
		</cfif>
		<cfset status = "Successfully Copy.">
	<cfelse><!--- getartran.recordcount eq 0 --->
		<cfset status = "Sorry. No record found.">
	</cfif>

	<cfset myList = ArrayToList(myArray,deli)>
	<cflocation url="copyprocess.cfm?status=#status#&myList=#myList#" addtoken="no">
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
	<form action="copy.cfm" method="post">
	<table>
		<cfloop from="1" to="#listLen(url.myList,deli)#" index="i">
		<tr><td>#listgetat(url.myList,i,deli)#</td></tr>
		</cfloop>
	</table>
	<br><br>
	<div align="center"><input type="submit" name="submit" value="Continue"></div>
	</form>
</cfoutput>
</body>
</html>
</cfif>
<cfabort>
<!---
<cfif isdefined("getfrom") and copy eq 'copy'>
	<cfif getfrom eq "" or getto eq "">
		<h3>Please select Ref No.</h3>		
    	<a href="javascript:history.back()"><font size="2"><strong><font face="Arial, Helvetica, sans-serif">Back</font></strong></font></a> 
        <cfabort>   
  	</cfif>
</cfif>
--->
<!---
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfparam name="submit" default="">
<cfparam name="copy" default="">
<cfparam name="typefrom" default="">
<cfparam name="typeto" default="">

<body>
<cfif isdefined("getfrom") and copy eq 'copy'>
	<cfif getfrom eq "" or getto eq "">
		<h3>Please select Ref No.</h3>		
    	<a href="javascript:history.back()"><font size="2"><strong><font face="Arial, Helvetica, sans-serif">Back</font></strong></font></a> 
        <cfabort>   
  	</cfif>
</cfif>
<cfif copy eq 'copy'> 
	<cfif xdate neq "">
		<cfset dd=dateformat('#form.xdate#', "DD")>
		
		<cfif dd greater than '12'>
			<cfset nDateCreate=dateformat('#form.xdate#',"YYYYMMDD")>
		<cfelse>
			<cfset nDateCreate=dateformat('#form.xdate#',"YYYYDDMM")>
		</cfif>
	</cfif>
	<cfquery datasource="#dts#" name="getGeneralInfo">
	Select * from GSetup
	</cfquery>
	
	<cfset lastaccyear = #dateformat(getGeneralInfo.lastaccyear, "dd/mm/yyyy")#>
	<cfset period = '#getGeneralInfo.period#'>
	<cfset currentdate = #dateformat(form.xdate,"dd/mm/yyyy")#>
	
	<cfset tmpYear = year(currentdate)>
	<cfset clsyear = year(lastaccyear)>
	
	<cfset tmpmonth = month(currentdate)>
	<cfset clsmonth = month(lastaccyear)>
	
	<cfset intperiod = (tmpyear - clsyear) * 12 + tmpmonth - clsmonth>
	<cfif intperiod gt 18 or intperiod lt 0>
		<cfset readperiod = 18>
	<cfelse>
		<cfset readperiod = #numberformat(intperiod,"00")#>
	</cfif>
	<cfset currperiod = "CurrP"&#readperiod#>
	
	
	<cfquery name="getartran" datasource="#dts#">
		select * from artran where type = '#typefrom#' and refno >= '#getfrom#' and refno <= '#getto#' group by refno order by refno
	</cfquery>
	
	<cfquery name="getcust" datasource="#dts#">
		select customerno, name,currcode from #ptype# where customerno = '#form.custfrom#'
	</cfquery>
	
	<cfif getartran.recordcount gt 0>
		<cfif typeto eq 'RC'>
			<cfset gcode = "rcno">
		<cfelseif typeto eq 'PR'>
			<cfset gcode = "prno">	
		<cfelseif typeto eq 'DO'>
			<cfset gcode = "dono">
		<cfelseif typeto eq 'INV'>
			<cfset gcode = "invno">
		<cfelseif typeto eq 'CN'>
			<cfset gcode = "cnno">
		<cfelseif typeto eq 'CS'>
			<cfset gcode = "csno">
		<cfelseif typeto eq 'DN'>
			<cfset gcode = "dnno">
		<cfelseif typeto eq 'ISS'>
			<cfset gcode = "issno">
		<cfelseif typeto eq 'PO'>
			<cfset gcode = "pono">
		<cfelseif typeto eq 'SO'>
			<cfset gcode = "sono">
		<cfelseif typeto eq 'QUO'>
			<cfset gcode = "quono">
		<cfelseif typeto eq 'SCR'>
			<cfset gcode = "scrno">	
		</cfif>
		
		
		<cfset nexttranno = #getfrom2#>
		
		<!--- <cfoutput>#nexttranno#</cfoutput> --->
		<cfloop query="getartran">
			<!--- <cfset oldperiod = "CurrP"&#fperiod#> --->
			<!--- <cfquery name="getcurrcode" datasource="#dts#">
	  			select currcode from currencyrate where #oldperiod# = '#getartran.currrate#'
			</cfquery>
			<cfif getcurrcode.recordcount gt 0> --->
				<cfset xcurrcode = getcust.currcode>
			<!--- <cfelse>
				<cfset xcurrcode = 'SGD'>
			</cfif> --->
			
			<cfquery name="getrate" datasource="#dts#">
	  			select #readperiod# as newrate from currencyrate where currcode = '#xcurrcode#'
			</cfquery>
			
			<cfset newrate = getrate.newrate>			
			
			<cfquery name="getictran" datasource="#dts#">
				select * from ictran where type = '#typefrom#' and refno = '#refno#' order by itemcount
			</cfquery>
			
			<cfquery name="updategsetup" datasource="#dts#">
				update gsetup set #gcode# = '#nexttranno#'
			</cfquery>
			
			
			<cfquery datasource="#dts#" name="insertartran">
				Insert into artran (type,refno,refno2,custno,fperiod,wos_date,agenno,currrate,gross_bil,disc1_bil,disc2_bil,disc3_bil,disc_bil,
				net_bil,tax1_bil,tax2_bil,tax3_bil,tax_bil,grand_bil,debit_bil,credit_bil,invgross,disp1,disp2,disp3,discount1,discount2,discount3,
				discount,net,tax1,tax2,tax3,tax,taxp1,taxp2,taxp3,grand,debitamt,creditamt,note,term,van,
				pono,dono,rem0,rem1,rem2,rem3,rem4,rem5,rem6,rem7,rem8,rem9,rem10,rem11,rem12,frem0,frem1,frem2,frem3,
				frem4,frem5,frem6,frem7,frem8,frem9,comm0,comm1,comm2,comm3,comm4,generated,toinv,
				exported,exported1,exported2,exported3,name,trdatetime,userid,currcode)
				
				values('#typeto#','#nexttranno#','#refno2#','#getcust.customerno#','#readperiod#',#ndatecreate#,'#agenno#','#newrate#','#gross_bil#',
				'#disc1_bil#','#disc2_bil#','#disc3_bil#','#disc_bil#','#net_bil#','#tax1_bil#','#tax2_bil#','#tax3_bil#','#tax_bil#',
				'#grand_bil#','#debit_bil#','#credit_bil#','#invgross#','#disp1#','#disp2#','#disp3#','#discount1#','#discount2#','#discount3#',
				'#discount#','#net#','#tax1#','#tax2#','#tax3#','#tax#','#taxp1#','#taxp2#','#taxp3#','#grand#','#debitamt#','#creditamt#','#note#','#term#','#van#',
				'','','#rem0#','#rem1#','#rem2#','#rem3#','#rem4#','#rem5#','#rem6#','#rem7#','#rem8#','#rem9#','#rem10#','#rem11#','#rem12#','#frem0#',
				'#frem1#','#frem2#','#frem3#','#frem4#','#frem5#','#frem6#','#frem7#','#frem8#','#frem9#','#comm0#','#comm1#','#comm2#','#comm3#','#comm4#','','',
				'','','','','#getcust.name#',#ndatecreate#,'#huserid#','#currcode#')
			</cfquery>
			<cfoutput query="getictran">
				<!--- <cfset xcomment = #tostring(getictran.comment)#> --->		
				<cfquery name="insertictran" datasource="#dts#">
					Insert into ictran (type,refno,refno2,trancode,custno,fperiod,wos_date,currrate,itemcount,itemno,desp,despa,agenno,
					location,qty_bil,price_bil,unit_bil,amt1_bil,dispec1,dispec2,dispec3,disamt_bil,amt_bil,taxpec1,taxpec2,taxpec3,
					taxamt_bil,qty,price,unit,amt1,disamt,amt,taxamt,dono,brem1,brem2,brem3,brem4,grade,name,generated,toinv,exported,
					exported1,exported2,exported3,sono,userid,wos_group,category,trdatetime,bomno,comment)
					values('#typeto#','#nexttranno#','#refno2#','#trancode#','#getcust.customerno#','#readperiod#',#ndatecreate#,'#newrate#','#itemcount#',
					'#itemno#','#desp#','#despa#','#agenno#','#location#','#qty_bil#','#price_bil#','#unit_bil#','#amt1_bil#','#dispec1#',
					'#dispec2#','#dispec3#','#disamt_bil#','#amt_bil#','#taxpec1#','#taxpec2#','#taxpec3#',
					'#taxamt_bil#','#qty#','#price#','#unit#','#amt1#','#disamt#','#amt#','#taxamt#','','#brem1#',
					'#brem2#','#brem3#','#brem4#','#grade#','#getcust.name#','','','','',
					'','','','#huserid#','#wos_group#','#category#',#ndatecreate#,'#bomno#',
					
					<cfset CommentLen = #len(tostring(comment))#>
					<cfset xComment = #tostring(comment)#>
					<cfset SingleQ = ''>
					<cfset DoubleQ = ''>
					
					<cfloop index = "Count" from = "1" to = "#CommentLen#">
					  <cfif mid(#xComment#,#Count#,1) eq "'">
						<cfset SingleQ = 'Y'>
					  <cfelseif mid(#xComment#,#Count#,1) eq '"'>
						<cfset DoubleQ = 'Y'>
					  </cfif>
					</cfloop>					
					
					<cfif SingleQ eq 'Y' and DoubleQ eq ''>
					  <!--- Found ' in the comment --->
					  "#xcomment#")
					<cfelseif SingleQ eq '' and DoubleQ eq 'Y'>
					  <!--- Found " in the comment --->
					  '#xcomment#')
					<cfelseif SingleQ eq '' and DoubleQ eq ''>					 
					  '#xcomment#')					
					<cfelse>
					  <h3>Error. You cannot key in both ' and " in the comment.</h3>
					  <cfabort>
					</cfif>					
				</cfquery>			
			</cfoutput>
			<!--- <cfset nexttranno = nexttranno +1> --->
			<!--- <cfset refnocnt = len(#nexttranno#)>	
			<cfset cnt = 0>
			<cfset yes = 0>
			<cfloop condition = "cnt lte refnocnt and yes eq 0">
				<cfset cnt = cnt + 1>			
				<cfif isnumeric(mid(#nexttranno#,#cnt#,1))>				
					<cfset yes = 1>			
				</cfif>								
			</cfloop>
			
			<cfset nolen = refnocnt - cnt + 1>
			<cfset nextno = right(nexttranno,#nolen#) + 1>
			
			<cfif nolen eq 1>
				<cfset zero = "0">
			<cfelseif nolen eq 2>
				<cfset zero = "00">
			<cfelseif nolen eq 3>
				<cfset zero = "000">
			<cfelseif nolen eq 4>
				<cfset zero = "0000">
			<cfelseif nolen eq 5>
				<cfset zero = "00000">
			<cfelseif nolen eq 6>
				<cfset zero = "000000">
			<cfelseif nolen eq 7>
				<cfset zero = "0000000">
			<cfelseif nolen eq 8>
				<cfset zero = "00000000">
			</cfif>
			<cfif cnt gt 1>
				<cfset nexttranno = left(#nexttranno#,#cnt#-1)&#numberformat(nextno,#zero#)#>
				<cfif len(nexttranno) gt 8>
					<cfset nexttranno = '99999999'>
				</cfif>
			<cfelse>
				<cfset nexttranno = #numberformat(nextno,#zero#)#> 
				<cfif len(nexttranno) gt 8>
					<cfset nexttranno = '99999999'>
				</cfif>
			</cfif> --->
			<cfset refnocnt = len(#nexttranno#)>	
			<cfset cnt = 0>
			<cfset yes = 0>
			<cfloop condition = "cnt lte refnocnt and yes eq 0">
				<cfset cnt = cnt + 1>			
				<cfif isnumeric(mid(#nexttranno#,#cnt#,1))>				
					<cfset yes = 1>			
				</cfif>								
			</cfloop>
			
			<cfset nolen = refnocnt - cnt + 1>
			<cfset nextno = right(nexttranno,#nolen#) + 1>
			
			<cfset nocnt = 1>
			<cfset zero = "">
			<cfloop condition = "nocnt lte nolen">
				<cfset zero = zero & "0">
				<cfset nocnt = nocnt + 1>	
			</cfloop>
					
			<cfif typeto eq 'SO' or typeto eq 'PO' or typeto eq 'QUO'>
				<cfset limit = 24>
			<cfelse>
				<cfset limit = 8>
			</cfif>
			<cfif cnt gt 1>
				<cfset nexttranno = left(#nexttranno#,#cnt#-1)&#numberformat(nextno,#zero#)#>
				<cfif len(nexttranno) gt limit>
					<cfset nexttranno = '99999999'>
				</cfif>
			<cfelse>
				<cfset nexttranno = #numberformat(nextno,#zero#)#> 
				<cfif len(nexttranno) gt limit>
					<cfset nexttranno = '99999999'>
				</cfif>
			</cfif>
		</cfloop>
		
		
		<h2>You have copied the bills successfully.</h2>
	<cfelse>
		<h3>Sorry. No record found.</h3>
		<cfabort>
	</cfif>
</cfif>


<h1 align="center">Copy Bills</h1>
<cfform action="" method="post">
<table width="70%" border="0" cellspacing="0" cellpadding="0" class="data" align="center">
<!--- <cfif getgeneral.multiple eq '1'>
  <tr> 
    <th colspan="4">Multiple Transaction</th>
  </tr>
	<tr> 
      <th>Transaction Code</th>
      <td colspan="3"><input type="text" name="mtran" size="10"> (e.g. ATS)</td>
    </tr>
</cfif> --->
  <tr> 
    <th colspan="4">TYPE</th>
  </tr>
  <tr> 
    <th width="30%">FROM</th>
    <td width="20%"></td> 
    <th>TO</th>
    <td></td>
  </tr>
  <tr> 
    <th>Receive</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="RC"<cfif typefrom eq 'rc'>checked</cfif>>
      </div></td>
    <th>Receive</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="RC"<cfif typeto eq 'rc'>checked</cfif>>
      </div></td>
  </tr>
  <tr> 
    <th>Purchase Return</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="PR"<cfif typefrom eq 'pr'>checked</cfif>>
      </div></td>
    <th>Purchase Return</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="PR"<cfif typeto eq 'pr'>checked</cfif>>
      </div></td>
  </tr>
  <tr> 
    <th>Delivery Order</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="DO"<cfif typefrom eq 'do'>checked</cfif>>
      </div></td>
    <th>Delivery Order</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="DO"<cfif typeto eq 'do'>checked</cfif>>
      </div></td>
  </tr>
  <tr> 
    <th>Invoice</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="INV"<cfif typefrom eq 'inv'>checked</cfif>>
      </div></td>
    <th>Invoice</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="INV"<cfif typeto eq 'inv'>checked</cfif>>
      </div></td>
  </tr>
  <tr> 
    <th>Credit Note</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="CN"<cfif typefrom eq 'cn'>checked</cfif>>
      </div></td>
    <th>Credit Note</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="CN"<cfif typeto eq 'cn'>checked</cfif>>
      </div></td>
  </tr>
  <tr> 
    <th>Cash Sales</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="CS"<cfif typefrom eq 'cs'>checked</cfif>>
      </div></td>
    <th>Cash Sales</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="CS"<cfif typeto eq 'cs'>checked</cfif>>
      </div></td>
  </tr>
  <tr> 
    <th>Debit Note</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="DN"<cfif typefrom eq 'dn'>checked</cfif>>
      </div></td>
    <th>Debit Note</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="DN"<cfif typeto eq 'dn'>checked</cfif>>
      </div></td>
  </tr>
  <tr> 
    <th>Issue</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="ISS"<cfif typefrom eq 'iss'>checked</cfif>>
      </div></td>
    <th>Issue</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="ISS"<cfif typeto eq 'iss'>checked</cfif>>
      </div></td>
  </tr>
  <tr> 
    <th>Purchase Order</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="PO"<cfif typefrom eq 'po'>checked</cfif>>
      </div></td>
    <th>Purchase Order</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="PO"<cfif typeto eq 'po'>checked</cfif>>
      </div></td>
  </tr>
  <tr> 
    <th>Sales Order</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="SO"<cfif typefrom eq 'so'>checked</cfif>>
      </div></td>
    <th>Sales Order</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="SO"<cfif typeto eq 'so'>checked</cfif>>
      </div></td>
  </tr>
  <tr> 
    <th>Quotation</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="QUO"<cfif typefrom eq 'quo'>checked</cfif>>
      </div></td>
    <th>Quotation</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="QUO"<cfif typeto eq 'quo'>checked</cfif>>
      </div></td>
  </tr>
  <!--- <tr> 
    <th>SCR</th>
    <td><div align="center"> 
        <input type="radio" name="typefrom" value="SCR"<cfif typefrom eq 'scr'>checked</cfif>>
      </div></td>
    <th>SCR</th>
    <td><div align="center"> 
        <input type="radio" name="typeto" value="SCR"<cfif typeto eq 'scr'>checked</cfif>>
      </div></td>
  </tr> --->
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="center"><input type="submit" name="Submit" value="Submit"></td>
  </tr>
  <cfif submit eq 'submit'>  
	<cfif typeto eq 'RC'>
		<cfset gcode = "rcno">
	<cfelseif typeto eq 'PR'>
		<cfset gcode = "prno">	
	<cfelseif typeto eq 'DO'>
		<cfset gcode = "dono">
	<cfelseif typeto eq 'INV'>
		<cfset gcode = "invno">
	<cfelseif typeto eq 'CN'>
		<cfset gcode = "cnno">
	<cfelseif typeto eq 'CS'>
		<cfset gcode = "csno">
	<cfelseif typeto eq 'DN'>
		<cfset gcode = "dnno">
	<cfelseif typeto eq 'ISS'>
		<cfset gcode = "issno">
	<cfelseif typeto eq 'PO'>
		<cfset gcode = "pono">
	<cfelseif typeto eq 'SO'>
		<cfset gcode = "sono">
	<cfelseif typeto eq 'QUO'>
		<cfset gcode = "quono">
	<cfelseif typeto eq 'SCR'>
		<cfset gcode = "scrno">	
	</cfif>

	<cfquery name="getgeneral" datasource="#dts#">
		select #gcode# as tranno from gsetup
	</cfquery>
	<!--- <cfset nexttranno = getgeneral.result +1> --->
	<!--- <cfset refnocnt = len(#getgeneral.result#)>	
	<cfset cnt = 0>
	<cfset yes = 0>
	<cfloop condition = "cnt lte refnocnt and yes eq 0">
		<cfset cnt = cnt + 1>			
		<cfif isnumeric(mid(#getgeneral.result#,#cnt#,1))>				
			<cfset yes = 1>			
		</cfif>								
	</cfloop>
	
	<cfset nolen = refnocnt - cnt + 1>
	<cfset nextno = right(getgeneral.result,#nolen#) + 1>
	
	<cfif nolen eq 1>
		<cfset zero = "0">
	<cfelseif nolen eq 2>
		<cfset zero = "00">
	<cfelseif nolen eq 3>
		<cfset zero = "000">
	<cfelseif nolen eq 4>
		<cfset zero = "0000">
	<cfelseif nolen eq 5>
		<cfset zero = "00000">
	<cfelseif nolen eq 6>
		<cfset zero = "000000">
	<cfelseif nolen eq 7>
		<cfset zero = "0000000">
	<cfelseif nolen eq 8>
		<cfset zero = "00000000">
	</cfif>
	<cfif cnt gt 1>
		<cfset nexttranno = left(#getgeneral.result#,#cnt#-1)&#numberformat(nextno,#zero#)#>
		<cfif len(nexttranno) gt 8>
			<cfset nexttranno = '99999999'>
		</cfif>
	<cfelse>
		<cfset nexttranno = #numberformat(nextno,#zero#)#> 
		<cfif len(nexttranno) gt 8>
			<cfset nexttranno = '99999999'>
		</cfif>
	</cfif> --->
	<cfset refnocnt = len(#getGeneral.tranno#)>	
	<cfset cnt = 0>
	<cfset yes = 0>
	<cfloop condition = "cnt lte refnocnt and yes eq 0">
		<cfset cnt = cnt + 1>			
		<cfif isnumeric(mid(#getGeneral.tranno#,#cnt#,1))>				
			<cfset yes = 1>			
		</cfif>								
	</cfloop>
	
	<cfset nolen = refnocnt - cnt + 1>
	<cfset nextno = right(getGeneral.tranno,#nolen#) + 1>
	
	<cfset nocnt = 1>
	<cfset zero = "">
	<cfloop condition = "nocnt lte nolen">
		<cfset zero = zero & "0">
		<cfset nocnt = nocnt + 1>	
	</cfloop>
			
	<cfif typeto eq 'SO' or typeto eq 'PO' or typeto eq 'QUO'>
		<cfset limit = 24>
	<cfelse>
		<cfset limit = 8>
	</cfif>
	<cfif cnt gt 1>
		<cfset nexttranno = left(#getGeneral.tranno#,#cnt#-1)&#numberformat(nextno,#zero#)#>
		<cfif len(nexttranno) gt limit>
			<cfset nexttranno = '99999999'>
		</cfif>
	<cfelse>
		<cfset nexttranno = #numberformat(nextno,#zero#)#> 
		<cfif len(nexttranno) gt limit>
			<cfset nexttranno = '99999999'>
		</cfif>
	</cfif>
	
  	<cfquery name="gettran" datasource="#dts#">
		select refno from artran where type = '#form.typefrom#' order by refno
	</cfquery>
	<cfquery name="gettran2" datasource="#dts#">
		select refno from artran where type = '#form.typeto#' order by refno
	</cfquery>

    <cfoutput>
	 
      <tr> 
        <th colspan="4">From #form.typefrom#</th>
      </tr>
    </cfoutput> 
    <tr> 
      <th>Ref No. From</th>
      <td colspan="3"><select name="getfrom">
	  		<option value="">Choose a refno</option>
			<cfoutput query="gettran">
	  			<option value="#refno#">#refno#</option>
			</cfoutput>
          </select>
	  </td>
    </tr>
    <tr> 
      <th>Ref No. To</th>
      <td colspan="3"><select name="getto">
	  		<option value="">Choose a refno</option>
			<cfoutput query="gettran">
	  			<option value="#refno#">#refno#</option>
			</cfoutput>
          </select></td>
    </tr>
	<cfoutput>
    <tr> 
      <th colspan="4">To #form.typeto#</th>
    </tr>
	</cfoutput>
	
	 <tr> 
      <th>Ref No. From</th>
      <td colspan="3"><cfoutput><input name="getfrom2" type="text" value="#nexttranno#"></cfoutput>
	  <!--- <select name="getfrom2">
            <option value="">Choose a refno</option>
            <cfoutput query="gettran2"> 
              <option value="#refno#">#refno#</option>
            </cfoutput> </select> ---></td>
    </tr>
    <!--- <tr> 
      <th>Ref No. To</th>
      <td colspan="3"><select name="getto2">
            <option value="">Choose a refno</option>
            <cfoutput query="gettran2"> 
              <option value="#refno#">#refno#</option>
            </cfoutput> </select></td>
    </tr> --->
	<tr> 
      <th colspan="4">Cust No </th>
    </tr>
	<cfif form.typeto eq 'PR' or form.typeto eq 'PO' or form.typeto eq 'RC'>
		<cfset ptype = 'Supplier'>		
	<cfelse>
		<cfset ptype = 'Customer'>		
	</cfif>
	<cfquery name="getcust" datasource="#dts#">
		select customerno from #ptype# order by customerno
	</cfquery>
	<tr> 
      <th>Cust No.</th>
      <td colspan="3"><select name="custfrom">
	  <option value="">Choose a Customer</option>
	  <cfoutput query="getcust">
	  <option value="#customerno#">#customerno#</option>
	  </cfoutput>
          </select></td>
    </tr>
    <!--- <tr> 
      <th>Cust No. To</th>
      <td colspan="3"><select name="custto">
	  <option value="">Choose a Customer</option>
	  <cfoutput query="getcust">
	  <option value="#customerno#">#customerno#</option>
	  </cfoutput>
          </select></td>
    </tr> --->
	<tr> 
      <th colspan="4">Date</th>
    </tr>
	<tr> 
      <th>Date</th>
      <td colspan="3"><cfinput type="text" name="xdate" size="10" value="#dateformat(now(),"dd/mm/yyyy")#" validate="eurodate"> (DD/MM/YYYY)
      </td>
    </tr>
	<!---<tr> 
      <th colspan="4">Period</th>
    </tr>
	 <tr> 
      <th>Period</th>
      <td colspan="3"><input type="text" name="period" size="10">
      </td>
    </tr>   --->
	<cfoutput><input type="hidden" name="ptype" value="#ptype#"></cfoutput>
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="center"><input type="submit" name="COPY" value="COPY">
	<!--- <cfoutput><input type="hidden" name="typeto" value="#typeto#"></cfoutput> ---></td>
  </tr>
  </cfif>
</table>
  <br>
</cfform>
</body>
</html>
--->