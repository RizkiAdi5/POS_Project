<cfcomponent>
	<cffunction name="posting_to_ams_method">
		<cfargument name="dts" required="yes">
		<cfargument name="dts1" required="yes">
		<cfargument name="target_arcust" required="yes">
		<cfargument name="target_apvend" required="yes">
		<cfargument name="form" required="yes" type="struct">
		
		<cfinvoke component="cfc.link_ams_info" method="getamslinkinfo" returnvariable="getlinkresult"></cfinvoke>
		
		<cftry>
			<cfif form.date_from neq "" and form.date_to neq "">
				<cfset date1 = createDate(ListGetAt(form.date_from,3,"-"),ListGetAt(form.date_from,2,"-"),ListGetAt(form.date_from,1,"-"))>
				<cfset date2 = createDate(ListGetAt(form.date_to,3,"-"),ListGetAt(form.date_to,2,"-"),ListGetAt(form.date_to,1,"-"))>
			</cfif>
            
            <cfquery name="getgsetting" datasource="#arguments.dts#">
            SELECT postingRCRefno FROM gsetup
            </cfquery>
			
			<cfquery name="getdata_from_glpost91_glpost" datasource="#arguments.dts#">
				select 
				entry,acc_code,accno,fperiod,date,batchno,tranno,vouc_seq,vouc_seq2,
				ttype,
                <cfif getgsetting.postingRCRefno eq "Y">if(acc_code = "RC",if(refno != "",refno,reference),reference) as </cfif>reference,<cfif getgsetting.postingRCRefno eq "Y">if(acc_code="RC",reference,refno) as </cfif>refno,desp,despa,despb,despc,despd,despe,
				taxpec,debitamt,creditamt,fcamt,debit_fc,credit_fc,exc_rate,
				araptype,age,source,job,job2,subjob,job_value,job_value2,posted,
				exported,exported1,exported2,exported3,rem1,rem2,rem3,rem4,rem5,rpt_row,agent,
				stran,taxpur,paymode,trdatetime,corr_acc,accno2,accno3,
				date2,userid,tcurrcode,tcurramt,fperiod,bdate,bperiod,
				(if(ifnull(debitamt,0)=0,if(ifnull(creditamt,0)=0,0,creditamt),ifnull(debitamt,0))) as lastbal,b.custno as custno,c.suppno as suppno
				from glpost91 as a
                left join (SELECT custno FROM #arguments.target_arcust#) as b on a.accno = b.custno
				left join (SELECT custno as suppno FROM #arguments.target_apvend#) as c on a.accno = c.suppno
				where fperiod='#form.period#'
                and (debitamt > 0 or creditamt > 0)
                and processed <> "P"
				<cfif form.transaction_type neq "ALL">
				and acc_code='#form.transaction_type#' 
				</cfif>
				<cfif form.date_from neq "" and form.date_to neq "">
					and date between #date1# and #date2#
				</cfif>
				order by entry
			</cfquery>
			<cfquery name="getmaxtran" datasource="#arguments.dts1#">
						select max(tranno) as maxtran from glpost
						where batchno='#getdata_from_glpost91_glpost.batchno#'
						and fperiod <> '99'
					</cfquery>
					<cfif getmaxtran.recordcount neq 0>
						<cfset maxtranno=val(getmaxtran.maxtran) + 1>
					<cfelse>
						<cfset maxtranno=1>
					</cfif>
                    
			<cfloop query="getdata_from_glpost91_glpost">
				<CFSET SetLocale("English (UK)")> 
				<cfset currentdatetime = '#lsdateformat(now(), "YYYY-MM-DD")# #timeformat(now(), "HH:MM:SS")#'>
				<cfset variables.newUUID=createUUID()>
				 			
				<!--- <cfquery name="checkexist" datasource="#arguments.dts1#">
					select * from glpost
					where batchno='#getdata_from_glpost91_glpost.batchno#'
					and accno='#getdata_from_glpost91_glpost.accno#'
					and debitamt='#getdata_from_glpost91_glpost.debitamt#'
					and creditamt='#getdata_from_glpost91_glpost.creditamt#'
					and reference='#getdata_from_glpost91_glpost.reference#'
					and rem4='#getdata_from_glpost91_glpost.rem4#'
				</cfquery> --->
				
				<!--- <cfif checkexist.recordcount eq 0> --->
					
					<cfquery name="insert" datasource="#arguments.dts1#">
						insert into glpost 
						(acc_code,accno,fperiod,date,batchno,tranno,vouc_seq,vouc_seq_2,
						ttype,reference,refno,desp,despa,despb,despc,despd,despe,taxpec,
						debitamt,creditamt,fcamt,debit_fc,credit_fc,exc_rate,araptype,
						age,source,job,job2,subjob,job_value,job2_value,posted,
						exported,exported1,exported2,exported3,
						rem1,rem2,rem3,rem4,rem5,rpt_row,agent,stran,taxpur,
						paymode,trdatetime,corr_acc,accno2,accno3,date2,userid,
						tcurrcode,tcurramt,bperiod,bdate,vperiod,created_by,created_on,uuid
						)
						values
						('#getdata_from_glpost91_glpost.acc_code#','#getdata_from_glpost91_glpost.accno#','#getdata_from_glpost91_glpost.fperiod#',
						#getdata_from_glpost91_glpost.date#,'#getdata_from_glpost91_glpost.batchno#','#maxtranno#','#getdata_from_glpost91_glpost.vouc_seq#',
						'#val(getdata_from_glpost91_glpost.vouc_seq2)#','#getdata_from_glpost91_glpost.ttype#',
						'#getdata_from_glpost91_glpost.reference#','#getdata_from_glpost91_glpost.refno#','#getdata_from_glpost91_glpost.desp#','#getdata_from_glpost91_glpost.despa#',
						'#getdata_from_glpost91_glpost.despb#','#getdata_from_glpost91_glpost.despc#','#getdata_from_glpost91_glpost.despd#',
						'#getdata_from_glpost91_glpost.despe#','#getdata_from_glpost91_glpost.taxpec#','#getdata_from_glpost91_glpost.debitamt#',
						'#getdata_from_glpost91_glpost.creditamt#','#getdata_from_glpost91_glpost.fcamt#','#getdata_from_glpost91_glpost.debit_fc#',
						'#getdata_from_glpost91_glpost.credit_fc#','#getdata_from_glpost91_glpost.exc_rate#','#getdata_from_glpost91_glpost.araptype#',
						'#getdata_from_glpost91_glpost.age#','#getdata_from_glpost91_glpost.source#','#getdata_from_glpost91_glpost.job#','#getdata_from_glpost91_glpost.job2#',
						'#getdata_from_glpost91_glpost.subjob#','#getdata_from_glpost91_glpost.job_value#','#getdata_from_glpost91_glpost.job_value2#',
						'#getdata_from_glpost91_glpost.posted#','#getdata_from_glpost91_glpost.exported#','#getdata_from_glpost91_glpost.exported1#',
						'#getdata_from_glpost91_glpost.exported2#','#getdata_from_glpost91_glpost.exported3#','#getdata_from_glpost91_glpost.rem1#',
						'#getdata_from_glpost91_glpost.rem2#','#getdata_from_glpost91_glpost.rem3#','#getdata_from_glpost91_glpost.rem4#',
						'0','#getdata_from_glpost91_glpost.rpt_row#','#getdata_from_glpost91_glpost.agent#',
						'#getdata_from_glpost91_glpost.stran#','#getdata_from_glpost91_glpost.taxpur#','#getdata_from_glpost91_glpost.paymode#',
						'#currentdatetime#','#getdata_from_glpost91_glpost.corr_acc#','#getdata_from_glpost91_glpost.accno2#',
						'#getdata_from_glpost91_glpost.accno3#',
						<cfif getdata_from_glpost91_glpost.date2 neq "">'#getdata_from_glpost91_glpost.date2#'<cfelse>'0000-00-00'</cfif>,
						'#getdata_from_glpost91_glpost.userid#',
						'#getdata_from_glpost91_glpost.tcurrcode#','#getdata_from_glpost91_glpost.tcurramt#','#getdata_from_glpost91_glpost.fperiod#',
						<cfif getdata_from_glpost91_glpost.bdate neq "">#getdata_from_glpost91_glpost.bdate#<cfelse>'0000-00-00'</cfif>,'#getdata_from_glpost91_glpost.bperiod#','#getdata_from_glpost91_glpost.userid#',#now()#,'#variables.newUUID#')
					</cfquery>
					
<!--- 					<cfquery name="getarcust" datasource="#arguments.dts1#">
						select custno from #arguments.target_arcust#
						where custno='#getdata_from_glpost91_glpost.accno#'
					</cfquery> --->
					<cfif getdata_from_glpost91_glpost.custno neq "">
						<cfquery datasource="#arguments.dts1#" name="getentry">
							SELECT entry 
							FROM glpost where uuid='#variables.newUUID#' 
							and accno = '#getdata_from_glpost91_glpost.accno#' 
							and tranno='#maxtranno#'
							and reference='#getdata_from_glpost91_glpost.reference#'
							and debitamt='#getdata_from_glpost91_glpost.debitamt#'
							and creditamt='#getdata_from_glpost91_glpost.creditamt#'
						</cfquery>
						<cfquery name="insert" datasource="#arguments.dts1#">
							insert into arpost 
							(
								entry,accno,date,araptype,reference,refno,
								debitamt,creditamt,
								desp,despa,despb,despc,despd,
								fcamt,debit_lc,credit_lc,exc_rate,
								age,posted,
								rem1,rem2,rem4,
								source,job,agent,
								stran,fperiod,
								batchno,tranno,lastbal,created_by,created_on,
								refext,paidamt,paystatus,fullpay
							)
							values
							('#getentry.entry#','#getdata_from_glpost91_glpost.accno#',#getdata_from_glpost91_glpost.date#,'#getdata_from_glpost91_glpost.araptype#',
							'#getdata_from_glpost91_glpost.reference#','#getdata_from_glpost91_glpost.refno#','#getdata_from_glpost91_glpost.debitamt#',
							'#getdata_from_glpost91_glpost.creditamt#',
							'#getdata_from_glpost91_glpost.desp#','#getdata_from_glpost91_glpost.despa#',
							'#getdata_from_glpost91_glpost.despb#','#getdata_from_glpost91_glpost.despc#','#getdata_from_glpost91_glpost.despd#',
							'#getdata_from_glpost91_glpost.fcamt#','#getdata_from_glpost91_glpost.debit_fc#','#getdata_from_glpost91_glpost.credit_fc#',
							'#getdata_from_glpost91_glpost.exc_rate#','#getdata_from_glpost91_glpost.age#','#getdata_from_glpost91_glpost.posted#',
							'#getdata_from_glpost91_glpost.rem1#','#getdata_from_glpost91_glpost.rem2#','#getdata_from_glpost91_glpost.rem4#',
							'#getdata_from_glpost91_glpost.source#','#getdata_from_glpost91_glpost.job#','#getdata_from_glpost91_glpost.agent#',
							'#getdata_from_glpost91_glpost.stran#','#getdata_from_glpost91_glpost.fperiod#',
							'#getdata_from_glpost91_glpost.batchno#','#maxtranno#','#getdata_from_glpost91_glpost.lastbal#',
							'#getdata_from_glpost91_glpost.userid#',#now()#,
							'','0.00','','F')
						</cfquery>
                        
                        <cfif getdata_from_glpost91_glpost.fcamt neq 0>
                        <cfset newfcamt = getdata_from_glpost91_glpost.fcamt>
                        
						<cfif newfcamt lt 0>
                        <cfset fcdebitamt = 0>
                        <cfset fccreditamt = abs(newfcamt)> 
						<cfelse>
                        <cfset fcdebitamt = abs(newfcamt)> 
                        <cfset fccreditamt = 0> 
						</cfif>
                        
                        <cfquery name="insert" datasource="#arguments.dts1#">
							insert into arpost 
							(
								entry,accno,date,araptype,reference,refno,
								debitamt,creditamt,
								desp,despa,despb,despc,despd,
								fcamt,debit_lc,credit_lc,exc_rate,
								age,posted,
								rem1,rem2,rem4,
								source,job,agent,
								stran,fperiod,
								batchno,tranno,lastbal,created_by,created_on,
								refext,paidamt,paystatus,fullpay,accext
							)
							values
							('#getentry.entry#','#getdata_from_glpost91_glpost.accno#',#getdata_from_glpost91_glpost.date#,'#getdata_from_glpost91_glpost.araptype#',
							'#getdata_from_glpost91_glpost.reference#','#getdata_from_glpost91_glpost.refno#','#fcdebitamt#',
							'#fccreditamt#',
							'#getdata_from_glpost91_glpost.desp#','#getdata_from_glpost91_glpost.despa#',
							'#getdata_from_glpost91_glpost.despb#','#getdata_from_glpost91_glpost.despc#','#getdata_from_glpost91_glpost.despd#',
							'#getdata_from_glpost91_glpost.fcamt#','#getdata_from_glpost91_glpost.debitamt#','#getdata_from_glpost91_glpost.creditamt#',
							'#getdata_from_glpost91_glpost.exc_rate#','#getdata_from_glpost91_glpost.age#','#getdata_from_glpost91_glpost.posted#',
							'#getdata_from_glpost91_glpost.rem1#','#getdata_from_glpost91_glpost.rem2#','#getdata_from_glpost91_glpost.rem4#',
							'#getdata_from_glpost91_glpost.source#','#getdata_from_glpost91_glpost.job#','#getdata_from_glpost91_glpost.agent#',
							'#getdata_from_glpost91_glpost.stran#','#getdata_from_glpost91_glpost.fperiod#',
							'#getdata_from_glpost91_glpost.batchno#','#maxtranno#','#getdata_from_glpost91_glpost.fcamt#',
							'#getdata_from_glpost91_glpost.userid#',#now()#,
							'','0.00','','F','F')
						</cfquery>
						</cfif>
					</cfif>
					<!--- <cfquery name="getapvend" datasource="#arguments.dts1#">
						select custno from #arguments.target_apvend#
						where custno='#getdata_from_glpost91_glpost.accno#'
					</cfquery> --->
					<cfif getdata_from_glpost91_glpost.suppno neq "">
						<cfquery datasource="#arguments.dts1#" name="getentry">
							SELECT entry 
							FROM glpost where uuid='#variables.newUUID#' 
							and accno = '#getdata_from_glpost91_glpost.accno#' 
							and tranno='#maxtranno#'
							and reference='#getdata_from_glpost91_glpost.reference#'
							and debitamt='#getdata_from_glpost91_glpost.debitamt#'
							and creditamt='#getdata_from_glpost91_glpost.creditamt#'
						</cfquery>
						<cfquery name="insert" datasource="#arguments.dts1#">
							insert into appost 
							(
								entry,accno,date,araptype,reference,
								refno,debitamt,creditamt,
								desp,despa,despb,despc,despd,
								fcamt,debit_lc,credit_lc,
								exc_rate,age,posted,
								rem1,rem2,rem4,
								source,job,agent,
								stran,fperiod,
								batchno,tranno,lastbal,created_by,created_on,
								refext,paidamt,paystatus,fullpay
							)
							values
							('#getentry.entry#','#getdata_from_glpost91_glpost.accno#',#getdata_from_glpost91_glpost.date#,'#getdata_from_glpost91_glpost.araptype#',
							'#getdata_from_glpost91_glpost.reference#','#getdata_from_glpost91_glpost.refno#','#getdata_from_glpost91_glpost.debitamt#',
							'#getdata_from_glpost91_glpost.creditamt#',
							'#getdata_from_glpost91_glpost.desp#','#getdata_from_glpost91_glpost.despa#',
							'#getdata_from_glpost91_glpost.despb#','#getdata_from_glpost91_glpost.despc#','#getdata_from_glpost91_glpost.despd#',
							'#getdata_from_glpost91_glpost.fcamt#','#getdata_from_glpost91_glpost.debit_fc#','#getdata_from_glpost91_glpost.credit_fc#',
							'#getdata_from_glpost91_glpost.exc_rate#','#getdata_from_glpost91_glpost.age#','#getdata_from_glpost91_glpost.posted#',
							'#getdata_from_glpost91_glpost.rem1#','#getdata_from_glpost91_glpost.rem2#','#getdata_from_glpost91_glpost.rem4#',
							'#getdata_from_glpost91_glpost.source#','#getdata_from_glpost91_glpost.job#','#getdata_from_glpost91_glpost.agent#',
							'#getdata_from_glpost91_glpost.stran#','#getdata_from_glpost91_glpost.fperiod#',
							'#getdata_from_glpost91_glpost.batchno#','#maxtranno#','#getdata_from_glpost91_glpost.lastbal#',
							'#getdata_from_glpost91_glpost.userid#',#now()#,
							'','0.00','','F')
						</cfquery>
                        
                        <cfif getdata_from_glpost91_glpost.fcamt neq 0>
                        <cfset newfcamt = getdata_from_glpost91_glpost.fcamt>
                        
						<cfif newfcamt lt 0>
                        <cfset fcdebitamt = 0>
                        <cfset fccreditamt = abs(newfcamt)> 
						<cfelse>
                        <cfset fcdebitamt = abs(newfcamt)> 
                        <cfset fccreditamt = 0> 
						</cfif>
                        
                        <cfquery name="insert" datasource="#arguments.dts1#">
							insert into appost 
							(
								entry,accno,date,araptype,reference,
								refno,debitamt,creditamt,
								desp,despa,despb,despc,despd,
								fcamt,debit_lc,credit_lc,
								exc_rate,age,posted,
								rem1,rem2,rem4,
								source,job,agent,
								stran,fperiod,
								batchno,tranno,lastbal,created_by,created_on,
								refext,paidamt,paystatus,fullpay,accext
							)
							values
							('#getentry.entry#','#getdata_from_glpost91_glpost.accno#',#getdata_from_glpost91_glpost.date#,'#getdata_from_glpost91_glpost.araptype#',
							'#getdata_from_glpost91_glpost.reference#','#getdata_from_glpost91_glpost.refno#','#fcdebitamt#',
							'#fccreditamt#',
							'#getdata_from_glpost91_glpost.desp#','#getdata_from_glpost91_glpost.despa#',
							'#getdata_from_glpost91_glpost.despb#','#getdata_from_glpost91_glpost.despc#','#getdata_from_glpost91_glpost.despd#',
							'#getdata_from_glpost91_glpost.fcamt#','#getdata_from_glpost91_glpost.debitamt#','#getdata_from_glpost91_glpost.creditamt#',
							'#getdata_from_glpost91_glpost.exc_rate#','#getdata_from_glpost91_glpost.age#','#getdata_from_glpost91_glpost.posted#',
							'#getdata_from_glpost91_glpost.rem1#','#getdata_from_glpost91_glpost.rem2#','#getdata_from_glpost91_glpost.rem4#',
							'#getdata_from_glpost91_glpost.source#','#getdata_from_glpost91_glpost.job#','#getdata_from_glpost91_glpost.agent#',
							'#getdata_from_glpost91_glpost.stran#','#getdata_from_glpost91_glpost.fperiod#',
							'#getdata_from_glpost91_glpost.batchno#','#maxtranno#','#getdata_from_glpost91_glpost.fcamt#',
							'#getdata_from_glpost91_glpost.userid#',#now()#,
							'','0.00','','F','F')
						</cfquery>
						</cfif>
                        
					</cfif>
				<!--- </cfif> --->
				<cfquery name="updateprocessed" datasource="#dts#">
                UPDATE glpost91 SET processed = "P" WHERE entry = "#getdata_from_glpost91_glpost.entry#"
                </cfquery>
                <cfset maxtranno = val(maxtranno) + 1 >
			</cfloop> 
			<cfset import_period = form.period + 10>
			
			<cfquery name="update" datasource="#arguments.dts1#">
				update gldata as a,
				(
					select accno,(sum(debitamt)-sum(creditamt)) as balance 
					from glpost 
					where fperiod="#form.period#" 
					group by accno,fperiod 
					order by accno,fperiod
				) as b 
				set 
				a.p#import_period#=b.balance where a.accno=b.accno
			</cfquery>
			
			<cfquery name="update" datasource="#arguments.dts1#">
				update 
				glbatch as a,
				(
					select 
					a.recno,
					b.totaltran,
					b.totaldebit,
					b.totalcredit
					
					from glbatch as a
					
					left join
					(
	  					select 
						batchno,
						count(batchno) as totaltran,
						sum(debitamt) as totaldebit,
						sum(creditamt) as totalcredit
						
	  					from glpost
	  					WHERE fperiod <> "99"
						group by batchno
	  					order by batchno
					) as b on a.recno=b.batchno
				) as b 
				
				set 
				
				a.debittt=b.totaldebit,
				a.credittt=b.totalcredit,
				a.notran=b.totaltran 
				
				where a.recno=b.recno
			</cfquery>
			
		<cfcatch>
			<h2 align="center">Close Error - info below</h2>
			<cfdump var="#cfcatch#">
			<cfabort>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="update_glpost91">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="target_arcust" required="yes" type="any">
		<cfargument name="target_apvend" required="yes" type="any">
		<cfargument name="userid" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		
		<cftry>
			<cfif form.date_from neq "" and form.date_to neq "">
				<cfset date1 = createDate(ListGetAt(form.date_from,3,"-"),ListGetAt(form.date_from,2,"-"),ListGetAt(form.date_from,1,"-"))>
				<cfset date2 = createDate(ListGetAt(form.date_to,3,"-"),ListGetAt(form.date_to,2,"-"),ListGetAt(form.date_to,1,"-"))>
			</cfif>
			
			<!---<cfquery name="getglpost" datasource="#arguments.dts#">
				select entry from glpost91
				where fperiod='#form.period#' 
				<cfif form.transaction_type neq "ALL">
					and acc_code='#form.transaction_type#' 
				</cfif>
				<cfif form.date_from neq "" and form.date_to neq "">
					and date between #date1# and #date2#
				</cfif>
				order by entry
			</cfquery>
			
			 <cfset j=0>
			<cfloop query="getglpost">
				<cfset j=j+1> --->
				<cfquery name="update_glpost91" datasource="#arguments.dts#">
					update glpost91 
					set 
					batchno='#form.batch_no#',
					vouc_seq='#form.batch_no#',
					vouc_seq2='#form.batch_no#',
					
					ttype=(if((accno in (select custno from #arguments.target_arcust#)) or (accno in (select custno from #arguments.target_apvend#) or (accno=(select cashaccount from gsetup))),
					(case acc_code 
						when 'CN' then 'RC' 
						when 'CS' then 'GD' 
						when 'DN' then 'RD' 
						when 'INV' then 'RD' 
						when 'PR' then 'PD' 
						when 'RC' then 'PC' 
					end),
					(case  
						when acc_code='CN' and rem4<>'' then 'GD' 
						when acc_code='CN' and rem4='' then 'GC' 
						when acc_code='CS' and rem4<>'' then 'GC' 
						when acc_code='CS' and rem4='' then 'GD' 
						when acc_code='DN' and rem4<>'' then 'GC' 
						when acc_code='DN' and rem4='' then 'GD' 
						when acc_code='INV' and rem4<>'' then 'GC' 
						when acc_code='INV' and rem4='' then 'GD' 
						when acc_code='PR' and rem4<>'' then 'GC' 
						when acc_code='PR' and rem4='' then 'GD' 
						when acc_code='RC' and rem4<>'' then 'GD' 
						when acc_code='RC' and rem4='' then 'GC' 
					end))),
					
					araptype=(if((accno in (select custno from #arguments.target_arcust#)) or (accno in (select custno from #arguments.target_apvend#) or (accno=(select cashaccount from gsetup))),
					(case acc_code 
						when 'CN' then 'C' 
						when 'CS' then 'H' 
						when 'DN' then 'D' 
						when 'INV' then 'I' 
						when 'PR' then 'D' 
						when 'RC' then 'I' 
					end),
					'Z')),			
					
					posted=(if((accno in (select custno from #arguments.target_arcust#)) or (accno in (select custno from #arguments.target_apvend#) or (accno=(select cashaccount from gsetup))),'P','')),
					userid='#arguments.userid#',
					bperiod=fperiod,
					bdate=date,
					vperiod=fperiod
				</cfquery>
			<!--- </cfloop> --->
			<!--- <cfquery name="update_glpost91" datasource="#arguments.dts#">
				update glpost91 
				set 
				batchno='#form.batch_no#',
				tranno=entry,
				vouc_seq='#form.batch_no#',
				vouc_seq2='#form.batch_no#',
				
				ttype=(if((accno in (select custno from #arguments.target_arcust#)) or (accno in (select custno from #arguments.target_apvend#) or (accno=(select cashaccount from gsetup))),
				(case acc_code 
					when 'CN' then 'RC' 
					when 'CS' then 'GD' 
					when 'DN' then 'RD' 
					when 'INV' then 'RD' 
					when 'PR' then 'PD' 
					when 'RC' then 'PC' 
				end),
				(case  
					when acc_code='CN' and rem4<>'' then 'GD' 
					when acc_code='CN' and rem4='' then 'GC' 
					when acc_code='CS' and rem4<>'' then 'GC' 
					when acc_code='CS' and rem4='' then 'GD' 
					when acc_code='DN' and rem4<>'' then 'GC' 
					when acc_code='DN' and rem4='' then 'GD' 
					when acc_code='INV' and rem4<>'' then 'GC' 
					when acc_code='INV' and rem4='' then 'GD' 
					when acc_code='PR' and rem4<>'' then 'GC' 
					when acc_code='PR' and rem4='' then 'GD' 
					when acc_code='RC' and rem4<>'' then 'GD' 
					when acc_code='RC' and rem4='' then 'GC' 
				end))),
				
				araptype=(if((accno in (select custno from #arguments.target_arcust#)) or (accno in (select custno from #arguments.target_apvend#) or (accno=(select cashaccount from gsetup))),
				(case acc_code 
					when 'CN' then 'C' 
					when 'CS' then 'V' 
					when 'DN' then 'D' 
					when 'INV' then 'I' 
					when 'PR' then 'D' 
					when 'RC' then 'I' 
				end),
				'Z')),			
				
				posted=(if((accno in (select custno from #arguments.target_arcust#)) or (accno in (select custno from #arguments.target_apvend#) or (accno=(select cashaccount from gsetup))),'P','')),
				userid='#arguments.userid#',
				bperiod=fperiod,
				bdate=date,
				vperiod=fperiod
							 
				where fperiod='#form.period#' 
				<cfif form.transaction_type neq "ALL">
				and acc_code='#form.transaction_type#' 
				</cfif>
				<cfif form.date_from neq "" and form.date_to neq "">
				and cast(concat_ws('-',substring(date,7,4),substring(date,4,2),substring(date,1,2)) as date) between '#dateformat(form.date_from,"yyyy-mm-dd")#' and '#dateformat(form.date_to,"yyyy-mm-dd")#'
				</cfif>
			</cfquery> --->
			
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="delete_posted_glpost91">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		
		<cftry>
			<cfif form.date_from neq "" and form.date_to neq "">
				<cfset date1 = createDate(ListGetAt(form.date_from,3,"-"),ListGetAt(form.date_from,2,"-"),ListGetAt(form.date_from,1,"-"))>
				<cfset date2 = createDate(ListGetAt(form.date_to,3,"-"),ListGetAt(form.date_to,2,"-"),ListGetAt(form.date_to,1,"-"))>
			</cfif>
			<cfquery name="delete_posted_transaction" datasource="#arguments.dts#">
				delete from glpost91 
				where fperiod='#form.period#' 
				<cfif form.transaction_type neq "ALL">
				and acc_code='#form.transaction_type#' 
				</cfif>
				<cfif form.date_from neq "" and form.date_to neq "">
					and date between #date1# and #date2#
				</cfif>
			</cfquery>
			
			<cfquery name="delete_posted_transaction" datasource="#arguments.dts#">
				delete from glpost9
				where fperiod='#form.period#' 
				<cfif form.transaction_type neq "ALL">
				and acc_code='#form.transaction_type#' 
				</cfif>
				<cfif form.date_from neq "" and form.date_to neq "">
					and date between #date1# and #date2#
				</cfif>
			</cfquery>
		
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="unpost_glpost91" returntype="String">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="type" required="yes" type="any">
		<cfargument name="all_refno3" required="yes" type="any">
		
		<cfset billpaid="">
		<cftry>
			<cfswitch expression="#arguments.type#">
				<cfcase value="RC,PR" delimiters=",">
					<cfset table = "appost">
					<cfset paytable = "appay">
					<cfset custsupptable = "apvend">
				</cfcase>
				<cfdefaultcase>
					<cfset table = "arpost">
					<cfset paytable = "arpay">
					<cfset custsupptable = "arcust">
				</cfdefaultcase>
			</cfswitch>
			
			<cfquery name="getbillpaid" datasource="#arguments.dts1#">
            select * from 
            (
            select <cfif arguments.type eq "CN">refno as</cfif> billno,<cfif arguments.type eq "CN">refno_postid as </cfif>billno_postid 
            from #paytable# 
            where 
            <cfif arguments.type eq "CN">refno<cfelse>billno</cfif> in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno3#">)
            ) as aa 
            left join
            (
            select * from 
            (
            SELECT reference as reference1,entry as entrya,post_id from #table# 
            where 
            reference in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno3#">)
            ) as a
            left join
            (
            select reference as reference2,entry,acc_code 
            from glpost 
            where reference in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno3#">)) as b on
            a.entrya = b.entry
            ) as bb
            on aa.billno_postid = bb.post_id
            where bb.acc_code = "#arguments.type#"
            group by aa.billno,bb.acc_code
			</cfquery>
            
			<cfset billpaid=valuelist(getbillpaid.billno)>
			
			<cfquery name="delete" datasource="#arguments.dts1#">
				delete from #table#	
				where entry in (
					select gl.entry from glpost gl,#custsupptable# as c
					where gl.accno=c.custno
					and gl.acc_code='#arguments.type#' 
					and gl.reference in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno3#">)
					and gl.reference not in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#billpaid#">)
				)
			</cfquery>
			
			<cfquery name="deleteglpost" datasource="#arguments.dts1#">
				delete from glpost
				where acc_code='#arguments.type#' 
				and reference in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno3#">)
				and reference not in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#billpaid#">)
			</cfquery>
			
			<!--- <cfquery name="delete" datasource="#arguments.dts1#">
				delete from #table#	
				where reference in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno3#">)
				and reference not in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#billpaid#">)
			</cfquery> --->
			
			<cfquery name="updategldata" datasource="#arguments.dts1#">
				update 
				gldata,
				(select a.accno,b.balance1,c.balance2,d.balance3,e.balance4,f.balance5,
				g.balance6,h.balance7,i.balance8,j.balance9,k.balance10,l.balance11,
				m.balance12,n.balance13,o.balance14,p.balance15,q.balance16,r.balance17,s.balance18 
				
					from gldata as a 
						
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance1 
						
						from glpost 
						
						where fperiod='1' 
						
						group by accno 
						order by accno
					) as b on a.accno=b.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance2 
						
						from glpost 
						
						where fperiod='2' 
						
						group by accno 
						order by accno
					) as c on a.accno=c.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance3 
						
						from glpost 
						
						where fperiod='3' 
						
						group by accno 
						order by accno
					) as d on a.accno=d.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance4 
						
						from glpost 
						
						where fperiod='4' 
						
						group by accno 
						order by accno
					) as e on a.accno=e.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance5 
						
						from glpost 
						
						where fperiod='5' 
						
						group by accno 
						order by accno
					) as f on a.accno=f.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance6 
						
						from glpost 
						
						where fperiod='6' 
						
						group by accno 
						order by accno
					) as g on a.accno=g.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance7 
						
						from glpost 
						
						where fperiod='7' 
						
						group by accno 
						order by accno
					) as h on a.accno=h.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance8 
						
						from glpost 
						
						where fperiod='8' 
						
						group by accno 
						order by accno
					) as i on a.accno=i.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance9 
						
						from glpost 
						
						where fperiod='9' 
						
						group by accno 
						order by accno
					) as j on a.accno=j.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance10 
						
						from glpost 
						
						where fperiod='10' 
						
						group by accno 
						order by accno
					) as k on a.accno=k.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance11 
						
						from glpost 
						
						where fperiod='11' 
						
						group by accno 
						order by accno
					) as l on a.accno=l.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance12 
						
						from glpost 
						
						where fperiod='12' 
						
						group by accno 
						order by accno
					) as m on a.accno=m.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance13 
						
						from glpost 
						
						where fperiod='13' 
						
						group by accno 
						order by accno
					) as n on a.accno=n.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance14 
						
						from glpost 
						
						where fperiod='14' 
						
						group by accno 
						order by accno
					) as o on a.accno=o.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance15 
						
						from glpost 
						
						where fperiod='15' 
						
						group by accno 
						order by accno
					) as p on a.accno=p.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance16 
						
						from glpost 
						
						where fperiod='16' 
						
						group by accno 
						order by accno
					) as q on a.accno=q.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance17 
						
						from glpost 
						
						where fperiod='17' 
						
						group by accno 
						order by accno
					) as r on a.accno=r.accno 
					
					left join 
					(
						select 
						accno,
						(sum(ifnull(debitamt,0))-sum(ifnull(creditamt,0))) as balance18 
						
						from glpost 
						
						where fperiod='18' 
						
						group by accno 
						order by accno
					) as s on a.accno=s.accno 
					
					order by a.accno
					
				) as gldata_balance 
			
				set 
				
				gldata.p11=gldata_balance.balance1,
				gldata.p12=gldata_balance.balance2,
				gldata.p13=gldata_balance.balance3,
				gldata.p14=gldata_balance.balance4,
				gldata.p15=gldata_balance.balance5,
				gldata.p16=gldata_balance.balance6,
				gldata.p17=gldata_balance.balance7,
				gldata.p18=gldata_balance.balance8,
				gldata.p19=gldata_balance.balance9,
				gldata.p20=gldata_balance.balance10,
				gldata.p21=gldata_balance.balance11,
				gldata.p22=gldata_balance.balance12,
				gldata.p23=gldata_balance.balance13,
				gldata.p24=gldata_balance.balance14,
				gldata.p25=gldata_balance.balance15,
				gldata.p26=gldata_balance.balance16,
				gldata.p27=gldata_balance.balance17,
				gldata.p28=gldata_balance.balance18 
				
				where gldata.accno=gldata_balance.accno
			</cfquery>
			
			<cfquery name="updateglbatch" datasource="#arguments.dts1#">
				update 
				glbatch as a,
				(
					select a.recno,b.totaltran,b.totaldebit,b.totalcredit 
					
					from glbatch as a 
					
					left join
					(
	  					select 
						batchno,
						count(batchno) as totaltran,
						sum(debitamt) as totaldebit,
						sum(creditamt) as totalcredit
	  					
						from glpost
	  					WHERE fperiod <> "99"
						group by batchno
	  					order by batchno
					) as b on a.recno=b.batchno
				) as b 
				
				set 
				
				a.debittt=b.totaldebit,
				a.credittt=b.totalcredit,
				a.notran=b.totaltran 
				
				where a.recno=b.recno
			</cfquery>
			
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
		<cfreturn billpaid>
	</cffunction>

	<cffunction name="iras_posting">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		
		<cftry>
			<cfif form.date_from neq "" and form.date_to neq "">
				<cfset date1 = createDate(ListGetAt(form.date_from,3,"-"),ListGetAt(form.date_from,2,"-"),ListGetAt(form.date_from,1,"-"))>
				<cfset date2 = createDate(ListGetAt(form.date_to,3,"-"),ListGetAt(form.date_to,2,"-"),ListGetAt(form.date_to,1,"-"))>
			</cfif>
			<cfquery name="get_posted_transaction" datasource="#arguments.dts#">
				select acc_code,reference from glpost91 
				where fperiod='#form.period#' 
				<cfif form.transaction_type neq "ALL">
					and acc_code='#form.transaction_type#' 
				</cfif>
				<cfif form.date_from neq "" and form.date_to neq "">
					and date between #date1# and #date2#
				</cfif>
				group by acc_code,reference
			</cfquery>
			
			<cfloop query="get_posted_transaction">
				<cfquery name="update" datasource="#arguments.dts#">
		    		update artran set IRAS_POSTED='P' WHERE refno='#get_posted_transaction.reference#' and type='#get_posted_transaction.acc_code#'
		    	</cfquery>
		    	
		    	<cfquery name="delete" datasource="#arguments.dts1#">
		        	delete from artran WHERE refno='#get_posted_transaction.reference#' and type='#get_posted_transaction.acc_code#'
		        </cfquery>
	            <cfquery name="delete2" datasource="#arguments.dts1#">
		        	delete from ictran WHERE refno='#get_posted_transaction.reference#' and type='#get_posted_transaction.acc_code#'
		        </cfquery>
		        
		        <cfquery name="select" datasource="#arguments.dts#">
		 			select TYPE,REFNO,REFNO2,TRANCODE,CUSTNO,FPERIOD,WOS_DATE,DESP,DESPA,AGENNO,AREA,SOURCE,JOB,
		 			CURRRATE,GROSS_BIL,DISC1_BIL,DISC2_BIL,DISC3_BIL,DISC_BIL,NET_BIL,TAX1_BIL,TAX2_BIL,TAX3_BIL,TAX_BIL,
		 			GRAND_BIL,DEBIT_BIL,CREDIT_BIL,INVGROSS,DISP1,DISP2,DISP3,DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT,NET,
		 			TAX1,TAX2,TAX3,TAX,TAXP1,TAXP2,TAXP3,GRAND,DEBITAMT,CREDITAMT,MC1_BIL,MC2_BIL,M_CHARGE1,M_CHARGE2,
		 			CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,DEPOSIT,CS_PM_DEBT,CS_PM_WHT,CHECKNO,
		 			IMPSTAGE,BILLCOST,BILLSALE,PAIDDATE,PAIDAMT,REFNO3,AGE,NOTE,TERM,ISCASH,VAN,DEL_BY,PLA_DODATE,ACT_DODATE,URGENCY,
		 			CURRRATE2,STAXACC,SUPP1,SUPP2,PONO,DONO,REM0,REM1,REM2,REM3,REM4,REM5,REM6,REM7,REM8,REM9,REM10,REM11,REM12,
		 			FREM0,FREM1,FREM2,FREM3,FREM4,FREM5,FREM6,FREM7,FREM8,FREM9,COMM1,COMM2,COMM3,COMM4,ID,GENERATED,TOINV,ORDER_CL,
		 			EXPORTED,EXPORTED1,EXPORTED2,EXPORTED3,LAST_YEAR,POSTED,PRINTED,LOKSTATUS,VOID,NAME,PONO2,DONO2,CSGTRANS,
		 			TAXINCL,TABLENO,CASHIER,MEMBER,COUNTER,TOURGROUP,TRDATETIME,TIME,XTRCOST,XTRCOST2,POINT,USERID,BPERIOD,VPERIOD,
		 			BDATE,CURRCODE,COMM0,REM13,REM14,MC3_BIL,MC4_BIL,MC5_BIL,MC6_BIL,MC7_BIL,M_CHARGE3,M_CHARGE4,M_CHARGE5,M_CHARGE6,M_CHARGE7,
		 			SPECIAL_ACCOUNT_CODE,CREATED_BY,UPDATED_BY,CREATED_ON,UPDATED_ON,IRAS_POSTED 
		 			from artran 
		 			WHERE refno='#get_posted_transaction.reference#' and type='#get_posted_transaction.acc_code#'
				</cfquery>
				
				<cfquery name="select_ictran" datasource="#arguments.dts#">
		 			select TYPE,REFNO,REFNO2,TRANCODE,CUSTNO,FPERIOD,WOS_DATE,CURRRATE,ITEMCOUNT,LINECODE,ITEMNO,DESP,DESPA,AGENNO,LOCATION,SOURCE,JOB,SIGN,QTY_BIL,PRICE_BIL,UNIT_BIL,AMT1_BIL,DISPEC1,DISPEC2,DISPEC3,DISAMT_BIL,AMT_BIL,TAXPEC1,TAXPEC2,TAXPEC3,TAXAMT_BIL,IMPSTAGE,QTY,PRICE,UNIT,AMT1,DISAMT,AMT,TAXAMT,FACTOR1,FACTOR2,DONO,DODATE,SODATE,BREM1,BREM2,BREM3,BREM4,PACKING,NOTE1,NOTE2,GLTRADAC,UPDCOST,GST_ITEM,TOTALUP,WITHSN,NODISPLAY,GRADE,PUR_PRICE,QTY1,QTY2,QTY3,QTY4,QTY5,QTY6,QTY7,QTY_RET,TEMPFIGI,SERCOST,M_CHARGE1,M_CHARGE2,ADTCOST1,ADTCOST2,IT_COS,AV_COST,BATCHCODE,EXPDATE,POINT,INV_DISC,INV_TAX,SUPP,EDI_COU1,WRITEOFF,TOSHIP,SHIPPED,NAME,DEL_BY,VAN,GENERATED,UD_QTY,TOINV,EXPORTED,EXPORTED1,EXPORTED2,EXPORTED3,BRK_TO,SV_PART,LAST_YEAR,VOID,SONO,MC1_BIL,MC2_BIL,USERID,DAMT,OLDBILL,WOS_GROUP,CATEGORY,AREA,SHELF,TEMP,TEMP1,BODY,TOTALGROUP,MARK,TYPE_SEQ,PROMOTER,TABLENO,MEMBER,TOURGROUP,TRDATETIME,TIME,BOMNO,DEFECTIVE,M_CHARGE3,M_CHARGE4,M_CHARGE5,M_CHARGE6,M_CHARGE7,MC3_BIL,MC4_BIL,MC5_BIL,MC6_BIL,MC7_BIL,TITLE_ID,TITLE_DESP,NOTE_A,TAXINCL
	            	from ictran
	               	WHERE refno='#get_posted_transaction.reference#' and type='#get_posted_transaction.acc_code#'
				</cfquery>
				
		   		<cfif select.recordcount neq 0>
	            	<cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select.PAIDDATE#" returnvariable="select.PAIDDATE"/>  
	                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select.WOS_DATE#" returnvariable="select.WOS_DATE"/>  
	                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select.PLA_DODATE#" returnvariable="select.PLA_DODATE"/>  
	                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select.ACT_DODATE#" returnvariable="select.ACT_DODATE"/>  
	                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select.EXPORTED1#" returnvariable="select.EXPORTED1"/>  
	                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select.EXPORTED3#" returnvariable="select.EXPORTED3"/>  
	                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select.BDATE#" returnvariable="select.BDATE"/>
	                <cfinvoke component="cfc.date" method="getFormatedDateTime" inputDate="#select.CREATED_ON#" returnvariable="select.CREATED_ON"/>
	                <cfinvoke component="cfc.date" method="getFormatedDateTime" inputDate="#select.UPDATED_ON#" returnvariable="select.UPDATED_ON"/>    
	                
		   			<cfquery name="insertData" datasource="#arguments.dts1#">
		    			INSERT INTO artran 
		    			(TYPE,REFNO,REFNO2,TRANCODE,CUSTNO,FPERIOD,WOS_DATE,DESP,DESPA,AGENNO,AREA,SOURCE,JOB,
		    			CURRRATE,GROSS_BIL,DISC1_BIL,DISC2_BIL,DISC3_BIL,DISC_BIL,NET_BIL,TAX1_BIL,TAX2_BIL,TAX3_BIL,TAX_BIL,
		    			GRAND_BIL,DEBIT_BIL,CREDIT_BIL,INVGROSS,DISP1,DISP2,DISP3,DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT,NET,
		    			TAX1,TAX2,TAX3,TAX,TAXP1,TAXP2,TAXP3,GRAND,DEBITAMT,CREDITAMT,MC1_BIL,MC2_BIL,M_CHARGE1,M_CHARGE2,
		    			CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,DEPOSIT,CS_PM_DEBT,CS_PM_WHT,CHECKNO,
		    			IMPSTAGE,BILLCOST,BILLSALE,PAIDDATE,PAIDAMT,REFNO3,AGE,NOTE,TERM,ISCASH,VAN,DEL_BY,PLA_DODATE,ACT_DODATE,URGENCY,
		    			CURRRATE2,STAXACC,SUPP1,SUPP2,PONO,DONO,REM0,REM1,REM2,REM3,REM4,REM5,REM6,REM7,REM8,REM9,REM10,REM11,REM12,
		    			FREM0,FREM1,FREM2,FREM3,FREM4,FREM5,FREM6,FREM7,FREM8,FREM9,COMM1,COMM2,COMM3,COMM4,ID,GENERATED,TOINV,ORDER_CL,
		    			EXPORTED,EXPORTED1,EXPORTED2,EXPORTED3,LAST_YEAR,POSTED,PRINTED,LOKSTATUS,VOID,NAME,PONO2,DONO2,CSGTRANS,
		    			TAXINCL,TABLENO,CASHIER,MEMBER,COUNTER,TOURGROUP,TRDATETIME,TIME,XTRCOST,XTRCOST2,POINT,USERID,BPERIOD,VPERIOD,
		    			BDATE,CURRCODE,COMM0,REM13,REM14,MC3_BIL,MC4_BIL,MC5_BIL,MC6_BIL,MC7_BIL,M_CHARGE3,M_CHARGE4,M_CHARGE5,M_CHARGE6,M_CHARGE7,
		    			SPECIAL_ACCOUNT_CODE,CREATED_BY,UPDATED_BY,CREATED_ON,UPDATED_ON,IRAS_POSTED) 
		    			values 
		    			('#select.TYPE#','#select.REFNO#','#select.REFNO2#','#select.TRANCODE#','#select.CUSTNO#','#select.FPERIOD#','#select.WOS_DATE#',
		    			'#select.DESP#','#select.DESPA#','#select.AGENNO#','#select.AREA#','#select.SOURCE#','#select.JOB#','#val(select.CURRRATE)#',
		    			'#val(select.GROSS_BIL)#','#val(select.DISC1_BIL)#','#val(select.DISC2_BIL)#','#val(select.DISC3_BIL)#','#val(select.DISC_BIL)#',
		    			'#val(select.NET_BIL)#','#val(select.TAX1_BIL)#','#val(select.TAX2_BIL)#','#val(select.TAX3_BIL)#','#val(select.TAX_BIL)#',
		    			'#val(select.GRAND_BIL)#','#val(select.DEBIT_BIL)#','#val(select.CREDIT_BIL)#','#val(select.INVGROSS)#','#val(select.DISP1)#',
		    			'#val(select.DISP2)#','#val(select.DISP3)#','#val(select.DISCOUNT1)#','#val(select.DISCOUNT2)#','#val(select.DISCOUNT3)#','#val(select.DISCOUNT)#',
		    			'#val(select.NET)#','#val(select.TAX1)#','#val(select.TAX2)#','#val(select.TAX3)#','#val(select.TAX)#','#val(select.TAXP1)#','#val(select.TAXP2)#',
		    			'#val(select.TAXP3)#','#val(select.GRAND)#','#val(select.DEBITAMT)#','#val(select.CREDITAMT)#','#val(select.MC1_BIL)#','#val(select.MC2_BIL)#',
		    			'#val(select.M_CHARGE1)#','#val(select.M_CHARGE2)#','#val(select.CS_PM_CASH)#','#val(select.CS_PM_CHEQ)#','#val(select.CS_PM_CRCD)#',
		    			'#val(select.CS_PM_CRC2)#','#val(select.CS_PM_DBCD)#','#val(select.CS_PM_VOUC)#','#val(select.DEPOSIT)#','#val(select.CS_PM_DEBT)#',
		    			'#val(select.CS_PM_WHT)#','#val(select.CHECKNO)#','#select.IMPSTAGE#','#val(select.BILLCOST)#','#val(select.BILLSALE)#','#select.PAIDDATE#',
		    			'#val(select.PAIDAMT)#','#select.REFNO3#','#select.AGE#','#select.NOTE#','#select.TERM#','#select.ISCASH#','#select.VAN#','#select.DEL_BY#',
		    			'#select.PLA_DODATE#','#select.ACT_DODATE#','#select.URGENCY#','#val(select.CURRRATE2)#',
		    			'#select.STAXACC#','#select.SUPP1#','#select.SUPP2#','#select.PONO#','#select.DONO#','#select.REM0#','#select.REM1#','#select.REM2#',
		    			'#select.REM3#','#select.REM4#','#select.REM5#','#select.REM6#','#select.REM7#','#select.REM8#','#select.REM9#','#select.REM10#','#select.REM11#',
		    			'#select.REM12#','#select.FREM0#','#select.FREM1#','#select.FREM2#','#select.FREM3#','#select.FREM4#','#select.FREM5#','#select.FREM6#','#select.FREM7#',
		    			'#select.FREM8#','#select.FREM9#','#select.COMM1#','#select.COMM2#','#select.COMM3#','#select.COMM4#','#select.ID#','#select.GENERATED#','#select.TOINV#',
		    			'#select.ORDER_CL#','#select.EXPORTED#','#select.EXPORTED1#','#select.EXPORTED2#','#select.EXPORTED3#','#select.LAST_YEAR#','#select.POSTED#',
		    			'#select.PRINTED#','#select.LOKSTATUS#','#select.VOID#','#select.NAME#','#select.PONO2#','#select.DONO2#','#select.CSGTRANS#','#select.TAXINCL#',
		    			'#select.TABLENO#','#select.CASHIER#','#select.MEMBER#','#select.COUNTER#','#select.TOURGROUP#','0000-00-00 00:00:00',
		    			'#select.TIME#','#val(select.XTRCOST)#','#val(select.XTRCOST2)#','#val(select.POINT)#','#select.USERID#','#select.BPERIOD#',
		    			'#select.VPERIOD#','#select.BDATE#','#select.CURRCODE#','#select.COMM0#','#select.REM13#','#select.REM14#','#val(select.MC3_BIL)#',
		    			'#val(select.MC4_BIL)#','#val(select.MC5_BIL)#','#val(select.MC6_BIL)#','#val(select.MC7_BIL)#','#val(select.M_CHARGE3)#','#val(select.M_CHARGE4)#',
		    			'#val(select.M_CHARGE5)#','#val(select.M_CHARGE6)#','#val(select.M_CHARGE7)#','#select.SPECIAL_ACCOUNT_CODE#','#select.CREATED_BY#','#select.UPDATED_BY#',
		    			'#select.CREATED_ON#','#select.UPDATED_ON#','#select.IRAS_POSTED#')	
					</cfquery> 
		   		</cfif>
            
	            <cfif select_ictran.recordcount neq 0>
					<cfloop query="select_ictran">
	               		<cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select_ictran.WOS_DATE#" returnvariable="select_ictran.WOS_DATE"/>  
	                	<cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select_ictran.DODATE#" returnvariable="select_ictran.DODATE"/>  
		                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select_ictran.SODATE#" returnvariable="select_ictran.SODATE"/> 
		                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select_ictran.EXPDATE#" returnvariable="select_ictran.EXPDATE"/>  
		                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select_ictran.EXPORTED1#" returnvariable="select_ictran.EXPORTED1"/>  
		                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select_ictran.EXPORTED3#" returnvariable="select_ictran.EXPORTED3"/>  
		                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#select_ictran.TRDATETIME#" returnvariable="select_ictran.TRDATETIME"/>
		
		                <cfquery name="insertData" datasource="#arguments.dts1#">
		                	INSERT INTO `ictran` (`TYPE`,`REFNO`,`REFNO2`,`TRANCODE`,`CUSTNO`,`FPERIOD`,`WOS_DATE`,`CURRRATE`,`ITEMCOUNT`,`LINECODE`,`ITEMNO`,`DESP`,`DESPA`,`AGENNO`,`LOCATION`,`SOURCE`,`JOB`,`SIGN`,`QTY_BIL`,`PRICE_BIL`,`UNIT_BIL`,`AMT1_BIL`,`DISPEC1`,`DISPEC2`,`DISPEC3`,`DISAMT_BIL`,`AMT_BIL`,`TAXPEC1`,`TAXPEC2`,`TAXPEC3`,`TAXAMT_BIL`,`IMPSTAGE`,`QTY`,`PRICE`,`UNIT`,`AMT1`,`DISAMT`,`AMT`,`TAXAMT`,`FACTOR1`,`FACTOR2`,`DONO`,`DODATE`,`SODATE`,`BREM1`,`BREM2`,`BREM3`,`BREM4`,`PACKING`,`NOTE1`,`NOTE2`,`GLTRADAC`,`UPDCOST`,`GST_ITEM`,`TOTALUP`,`WITHSN`,`NODISPLAY`,`GRADE`,`PUR_PRICE`,`QTY1`,`QTY2`,`QTY3`,`QTY4`,`QTY5`,`QTY6`,`QTY7`,`QTY_RET`,`TEMPFIGI`,`SERCOST`,`M_CHARGE1`,`M_CHARGE2`,`ADTCOST1`,`ADTCOST2`,`IT_COS`,`AV_COST`,`BATCHCODE`,`EXPDATE`,`POINT`,`INV_DISC`,`INV_TAX`,`SUPP`,`EDI_COU1`,`WRITEOFF`,`TOSHIP`,`SHIPPED`,`NAME`,`DEL_BY`,`VAN`,`GENERATED`,`UD_QTY`,`TOINV`,`EXPORTED`,`EXPORTED1`,`EXPORTED2`,`EXPORTED3`,`BRK_TO`,`SV_PART`,`LAST_YEAR`,`VOID`,`SONO`,`MC1_BIL`,`MC2_BIL`,`USERID`,`DAMT`,`OLDBILL`,`WOS_GROUP`,`CATEGORY`,`AREA`,`SHELF`,`TEMP`,`TEMP1`,`BODY`,`TOTALGROUP`,`MARK`,`TYPE_SEQ`,`PROMOTER`,`TABLENO`,`MEMBER`,`TOURGROUP`,`TRDATETIME`,`TIME`,`BOMNO`,`DEFECTIVE`,`M_CHARGE3`,`M_CHARGE4`,`M_CHARGE5`,`M_CHARGE6`,`M_CHARGE7`,`MC3_BIL`,`MC4_BIL`,`MC5_BIL`,`MC6_BIL`,`MC7_BIL`,`TITLE_ID`,`TITLE_DESP`,`NOTE_A`,`TAXINCL`) VALUES 
		                    ('#select_ictran.TYPE#','#select_ictran.REFNO#','#select_ictran.REFNO2#','#select_ictran.TRANCODE#','#select_ictran.CUSTNO#','#select_ictran.FPERIOD#','#select_ictran.WOS_DATE#','#select_ictran.CURRRATE#','#select_ictran.ITEMCOUNT#','#select_ictran.LINECODE#','#select_ictran.ITEMNO#','#select_ictran.DESP#','#select_ictran.DESPA#','#select_ictran.AGENNO#','#select_ictran.LOCATION#','#select_ictran.SOURCE#','#select_ictran.JOB#','#select_ictran.SIGN#','#select_ictran.QTY_BIL#','#select_ictran.PRICE_BIL#','#select_ictran.UNIT_BIL#','#select_ictran.AMT1_BIL#','#val(select_ictran.DISPEC1)#','#val(select_ictran.DISPEC2)#','#val(select_ictran.DISPEC3)#','#val(select_ictran.DISAMT_BIL)#','#select_ictran.AMT_BIL#','#select_ictran.TAXPEC1#','#select_ictran.TAXPEC2#','#select_ictran.TAXPEC3#','#select_ictran.TAXAMT_BIL#','#select_ictran.IMPSTAGE#','#select_ictran.QTY#','#select_ictran.PRICE#','#select_ictran.UNIT#','#select_ictran.AMT1#','#select_ictran.DISAMT#','#select_ictran.AMT#','#select_ictran.TAXAMT#','#select_ictran.FACTOR1#','#select_ictran.FACTOR2#','#select_ictran.DONO#','#select_ictran.DODATE#','#select_ictran.SODATE#','#select_ictran.BREM1#','#select_ictran.BREM2#','#select_ictran.BREM3#','#select_ictran.BREM4#','#select_ictran.PACKING#','#select_ictran.NOTE1#','#select_ictran.NOTE2#','#select_ictran.GLTRADAC#','#select_ictran.UPDCOST#',
							'#select_ictran.GST_ITEM#','#select_ictran.TOTALUP#','#select_ictran.WITHSN#','#select_ictran.NODISPLAY#','#select_ictran.GRADE#','#select_ictran.PUR_PRICE#','#select_ictran.QTY1#','#select_ictran.QTY2#','#select_ictran.QTY3#','#select_ictran.QTY4#','#select_ictran.QTY5#','#select_ictran.QTY6#','#select_ictran.QTY7#','#select_ictran.QTY_RET#','#select_ictran.TEMPFIGI#','#select_ictran.SERCOST#','#select_ictran.M_CHARGE1#','#select_ictran.M_CHARGE2#','#select_ictran.ADTCOST1#','#select_ictran.ADTCOST2#','#select_ictran.IT_COS#','#select_ictran.AV_COST#','#select_ictran.BATCHCODE#','#select_ictran.EXPDATE#','#select_ictran.POINT#','#select_ictran.INV_DISC#','#select_ictran.INV_TAX#','#select_ictran.SUPP#','#select_ictran.EDI_COU1#','#select_ictran.WRITEOFF#','#select_ictran.TOSHIP#','#select_ictran.SHIPPED#','#select_ictran.NAME#','#select_ictran.DEL_BY#','#select_ictran.VAN#','#select_ictran.GENERATED#','#select_ictran.UD_QTY#','#select_ictran.TOINV#','#select_ictran.EXPORTED#','#select_ictran.EXPORTED1#','#select_ictran.EXPORTED2#','#select_ictran.EXPORTED3#','#select_ictran.BRK_TO#','#select_ictran.SV_PART#','#select_ictran.LAST_YEAR#','#select_ictran.VOID#','#select_ictran.SONO#','#select_ictran.MC1_BIL#','#select_ictran.MC2_BIL#','#select_ictran.USERID#','#select_ictran.DAMT#','#select_ictran.OLDBILL#','#select_ictran.WOS_GROUP#',
							'#select_ictran.CATEGORY#','#select_ictran.AREA#','#select_ictran.SHELF#','#select_ictran.TEMP#','#select_ictran.TEMP1#','#select_ictran.BODY#','#select_ictran.TOTALGROUP#','#select_ictran.MARK#','#select_ictran.TYPE_SEQ#','#select_ictran.PROMOTER#','#select_ictran.TABLENO#','#select_ictran.MEMBER#','#select_ictran.TOURGROUP#','#select_ictran.TRDATETIME#','#select_ictran.TIME#','#select_ictran.BOMNO#','#select_ictran.DEFECTIVE#','#select_ictran.M_CHARGE3#','#select_ictran.M_CHARGE4#','#select_ictran.M_CHARGE5#','#select_ictran.M_CHARGE6#','#select_ictran.M_CHARGE7#','#select_ictran.MC3_BIL#','#select_ictran.MC4_BIL#','#select_ictran.MC5_BIL#','#select_ictran.MC6_BIL#','#select_ictran.MC7_BIL#','#select_ictran.TITLE_ID#','#select_ictran.TITLE_DESP#','#select_ictran.NOTE_A#','#select_ictran.TAXINCL#')
		               	</cfquery>
					</cfloop>
	            </cfif>
			</cfloop>
		
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
                <cfquery name="insertlog" datasource="#arguments.dts#">
                INSERT INTO postlog (action,billtype,actiondata,user,timeaccess)
                VALUES
                ("Import-ERROR","","#cfcatch.Detail#","",now())
                </cfquery>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="unpost_iras">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="type" required="yes" type="any">
		<cfargument name="all_refno3" required="yes" type="any">
		<cfargument name="all_refno4" required="yes" type="any">
		
		<cftry>
			<cfquery name="deleteartran" datasource="#arguments.dts1#">
				delete from artran
				where type='#arguments.type#' 
				and refno in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno3#">)
				and refno not in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno4#">)
			</cfquery>
			
			<cfquery name="deleteictran" datasource="#arguments.dts1#">
				delete from ictran
				where type='#arguments.type#' 
				and refno in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno3#">)
				and refno not in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno4#">)
			</cfquery>
			
			<cfquery name="updateartran" datasource="#arguments.dts#">
				update artran set IRAS_POSTED='' 
				WHERE type='#arguments.type#' 
				and refno in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno3#">)
				and refno not in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" separator="," value="#arguments.all_refno4#">)
			</cfquery>
			
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>