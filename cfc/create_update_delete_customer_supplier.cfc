<cfcomponent>
	<cfparam name="form.status" default="">
	
	<cffunction name="amend_customer_supplier" returntype="any">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="hlinkams" required="yes" type="any">
		<cfargument name="huserid" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		
		<cfif hlinkams eq "Y">
			<cfset arguments.dts1 = replace(arguments.dts1,"_i","_a","all")>
		</cfif>
		
		<cfswitch expression="#form.mode#">
			<cfcase value="create">
				<cfinvoke component="cfc.create_update_delete_customer_supplier" method="create_customer_supplier" returnvariable="status1">
					<cfinvokeargument name="dts" value="#arguments.dts#">
					<cfinvokeargument name="dts1" value="#arguments.dts1#">
					<cfinvokeargument name="huserid" value="#arguments.huserid#">
					<cfinvokeargument name="form" value="#arguments.form#">
					<cfinvokeargument name="hlinkams" value="#arguments.hlinkams#">
				</cfinvoke>
			</cfcase>
			<cfcase value="edit">
				<cfinvoke component="cfc.create_update_delete_customer_supplier" method="edit_customer_supplier" returnvariable="status1">
					<cfinvokeargument name="dts" value="#arguments.dts#">
					<cfinvokeargument name="dts1" value="#arguments.dts1#">
					<cfinvokeargument name="huserid" value="#arguments.huserid#">
					<cfinvokeargument name="form" value="#arguments.form#">
					<cfinvokeargument name="hlinkams" value="#arguments.hlinkams#">
				</cfinvoke>
			</cfcase>
			<cfcase value="delete">
				<cfinvoke component="cfc.create_update_delete_customer_supplier" method="delete_customer_supplier" returnvariable="status1">
					<cfinvokeargument name="dts" value="#arguments.dts#">
					<cfinvokeargument name="dts1" value="#arguments.dts1#">
					<cfinvokeargument name="huserid" value="#arguments.huserid#">
					<cfinvokeargument name="form" value="#arguments.form#">
					<cfinvokeargument name="hlinkams" value="#arguments.hlinkams#">
				</cfinvoke>
			</cfcase>
		</cfswitch>
		<cfreturn status1>
	</cffunction>
	
	<cffunction name="create_customer_supplier" returntype="any">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="huserid" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		
		<cftry>
			<cfquery name="checkCustomerExist" datasource="#dts1#">
				select custno 
				from #form.target_table# 
				where custno='#jsstringformat(form.custno)#' 
				limit 1
			</cfquery>
  	
			<cfif checkCustomerExist.recordcount eq 1>
				<h3 align="center"><font color="FF0000">Error, This <cfoutput>#form.custno#</cfoutput> Number has been created already.</font></h3>
				<cfabort>
			</cfif>
			
			<cfquery name="insert_currency" datasource="#arguments.dts1#">
				insert into #form.target_table# 
				(	edi_id,
					custno,
					name,
					name2,
					add1,
					add2,
					add3,
					add4,
					attn,
					daddr1,
					daddr2,
					daddr3,
					daddr4,
					dattn,
					contact,
					phone,
					phonea,
					fax,
					dphone,
					dfax,
					e_mail,
					web_site,
					bankaccno,
					area,
					agent,
					business,
					term,
					crlimit,
					currcode,
					currency,
					currency1,
					currency2,
					point_bf,
					autopay,
					lc_ex,
					ct_group,
					temp,
					target,
					mod_del,
					arrem1,
					arrem2,
					arrem3,
					arrem4,
					groupto,
					status,
					cust_type,
					accstatus,
					date,
					invlimit,
					termexceed,
					channel,
					salec,
					salecnc,
					term_in_m,
					cr_ap_ref,
					cr_ap_date,
					collateral,
					guarantor,
					dispec_cat,
					dispec1,
					dispec2,
					dispec3,
					commperc,
					outstand,
					ngst_cust,
                    taxincl_cust,
					personic1,
					position1,
					dept1,
					contact1,
					sitename,
					siteadd1,
					siteadd2,
					edited,
					acc_code,
					prov_disc,
					created_by,
					updated_by,
					created_on,
					updated_on,gstno,country,postalcode,d_country,d_postalcode,comuen,END_USER
				) 
				values 
				(
					'',
					'#jsstringformat(form.custno)#',
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.name#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.name2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add3#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add4#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.attn#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.daddr1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.daddr2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.daddr3#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.daddr4#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dattn#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contact#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phonea#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dphone#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dfax#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.e_mail#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.web_site#">,
					'',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.area#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.business#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.term#">,
					'#val(form.crlimit)#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currcode#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currency#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currency1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currency2#">,
					'0',
					<cfif isdefined("form.autopay")>'O'<cfelse>'B'</cfif>,
					'0',
					'',
					'0',
					'0',
					'',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem3#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem4#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.groupto#">,
					'#form.status#',
					'',
					'',
                	<cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#form.date#" returnvariable="form.date"/>
					'#form.date#',
					'#val(form.invlimit)#',
					'',
					'',
					'',
					'',
					'0',
					'',
					'0000-00-00',
					'',
					'',
					'',
					'#val(form.dispec1)#',
					'#val(form.dispec2)#',
					'#val(form.dispec3)#',
					'0',
					'0',
					<cfif isdefined("form.ngst_cust")>'T'<cfelse>'F'</cfif>,
                    <cfif isdefined("form.taxincl_cust")>'T'<cfelse>'F'</cfif>,
					'',
					'',
					'',
					'',
					'',
					'',
					'',
					'',
					'',
					'0',					
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.huserid#">,
					'',
					now(),
					'0000-00-00 00:00:00',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gstno#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.country#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.postalcode#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_country#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_postalcode#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comuen#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.enduser#">
				);
			</cfquery>
			
			<cfif arguments.hlinkams eq "Y">
				<cfset form.accno = form.custno>
				<cfset form.desp = form.name>
				<cfset form.id = iif(form.target_table eq "arcust",DE("1"),DE("2"))>
				<cfset form.acctype = iif(form.target_table eq "arcust",DE("F"),DE("G"))>
                <cfset form.groupto = form.groupto>
				
				<cfinsert datasource="#arguments.dts1#" tablename="gldata" formfields="accno,desp,acctype,id,currcode,groupto">
			</cfif>
			
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
		
		<cfset status1 = "The #form.custno# Had Been Successfully Created !">
		
		<cfreturn status1>
	</cffunction>
	
	<cffunction name="edit_customer_supplier" returntype="any">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		
		<cftry>
			<cfquery name="update_currency" datasource="#arguments.dts1#">
				update #form.target_table# set 
				edi_id=edi_id,
				custno=custno,
				name=<cfqueryparam cfsqltype="cf_sql_char" value="#form.name#">,
				name2=<cfqueryparam cfsqltype="cf_sql_char" value="#form.name2#">,
				add1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">,
				add2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">,
				add3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add3#">,
				add4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add4#">,
				attn=<cfqueryparam cfsqltype="cf_sql_char" value="#form.attn#">,
				daddr1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.daddr1#">,
				daddr2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.daddr2#">,
				daddr3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.daddr3#">,
				daddr4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.daddr4#">,
				dattn=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dattn#">,
				contact=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contact#">,
				phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
				phonea=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phonea#">,
				fax=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">,
				dphone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dphone#">,
				dfax=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dfax#">,
				e_mail=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.e_mail#">,
				web_site=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.web_site#">,
				bankaccno=bankaccno,
				area=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.area#">,
				agent=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
				business=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.business#">,
				term=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.term#">,
				crlimit='#val(form.crlimit)#',
				currcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currcode#">,
				currency=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currency#">,
				currency1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currency1#">,
				currency2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currency2#">,
				point_bf=point_bf,
				autopay=<cfif isdefined("form.autopay")>'O'<cfelse>'B'</cfif>,
				lc_ex=lc_ex,
				ct_group=ct_group,
				temp=temp,
				target=target,
				mod_del=mod_del,
				arrem1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem1#">,
				arrem2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem2#">,
				arrem3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem3#">,
				arrem4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem4#">,
				groupto=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.groupto#">,
				status='#form.status#',
				cust_type=cust_type,
				accstatus=accstatus,
                <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#form.date#" returnvariable="form.date"/>
				date='#form.date#',
				invlimit='#val(form.invlimit)#',
				termexceed=termexceed,
				channel=channel,
				salec=salec,
				salecnc=salecnc,
				term_in_m=term_in_m,
				cr_ap_ref=cr_ap_ref,
				cr_ap_date=cr_ap_date,
				collateral=collateral,
				guarantor=guarantor,
				dispec_cat=dispec_cat,
				dispec1='#val(form.dispec1)#',
				dispec2='#val(form.dispec2)#',
				dispec3='#val(form.dispec3)#',
				commperc=commperc,
				outstand=outstand,
				ngst_cust=<cfif isdefined("form.ngst_cust")>'T'<cfelse>'F'</cfif>,
                taxincl_cust=<cfif isdefined("form.taxincl_cust")>'T'<cfelse>'F'</cfif>,
				personic1=personic1,
				position1=position1,
				dept1=dept1,
				contact1=contact1,
				sitename=sitename,
				siteadd1=siteadd1,
				siteadd2=siteadd2,
				edited=edited,
				acc_code=acc_code,
				prov_disc=prov_disc,
				created_by=created_by,
				updated_by=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.huserid#">,
				created_on=created_on,
				updated_on=now(),
				gstno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gstno#">,
				country=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.country#">,
				postalcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.postalcode#">,
				d_country=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_country#">,
				d_postalcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_postalcode#">,
				comuen=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comuen#">,
                END_USER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.enduser#">
				where custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#">;
			</cfquery>
			
			<cfif arguments.hlinkams eq "Y">
				<cfquery name="" datasource="#arguments.dts1#">
					update gldata set 
					desp=<cfqueryparam cfsqltype="cf_sql_char" value="#form.name#">,
                    groupto = <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupto#">,
                    currcode =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currcode#">
					where accno='#jsstringformat(form.custno)#';
				</cfquery>
			</cfif>
			
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
		
		<cfset status1 = "The #form.custno# Had Been Successfully Edited !">
		
		<cfreturn status1>
	</cffunction>
	
	<cffunction name="delete_customer_supplier" returntype="any">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="huserid" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">

		<cftry>
			<cfquery name="checktranexist" datasource="#arguments.dts#">
					select custno 
					from artran 
					where custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#">
					limit 1
			</cfquery>
            <cfif checktranexist.recordcount eq 0>
            <cfif arguments.hlinkams eq "Y">
            <cfquery name="checktranexist" datasource="#arguments.dts#">
					select accno
					from #arguments.dts1#.glpost 
					where accno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#">
					limit 1
            </cfquery>
			</cfif></cfif>
            
				
			<cfif checktranexist.recordcount eq 1>
				<h3>You have created transaction for this customer/supplier. You are not allowed to delete this customer/supplier.</h3>					
				<cfabort>
			</cfif>
			
			<cfquery name="insert_to_audit_trail" datasource="#arguments.dts#">
				insert into deleted_#form.target_table# 
				(`EDI_ID`,`CUSTNO`,`NAME`,`NAME2`,`ADD1`,`ADD2`,`ADD3`,`ADD4`,`ATTN`,`DADDR1`,`DADDR2`,`DADDR3`,`DADDR4`,
				`DATTN`,`CONTACT`,`PHONE`,`PHONEA`,`DPHONE`,`FAX`,`DFAX`,`E_MAIL`,`WEB_SITE`,`BANKACCNO`,`AREA`,`AGENT`,`BUSINESS`,
				`TERM`,`CRLIMIT`,`CURRCODE`,`CURRENCY`,`CURRENCY1`,`CURRENCY2`,`POINT_BF`,`AUTOPAY`,`LC_EX`,`CT_GROUP`,`TEMP`,`TARGET`,
				`MOD_DEL`,`ARREM1`,`ARREM2`,`ARREM3`,`ARREM4`,`GROUPTO`,`STATUS`,`CUST_TYPE`,`ACCSTATUS`,`DATE`,`INVLIMIT`,`TERMEXCEED`,
				`CHANNEL`,`SALEC`,`SALECNC`,`TERM_IN_M`,`CR_AP_REF`,`CR_AP_DATE`,`COLLATERAL`,`GUARANTOR`,`DISPEC_CAT`,`DISPEC1`,`DISPEC2`,
				`DISPEC3`,`COMMPERC`,`OUTSTAND`,`NGST_CUST`,`PERSONIC1`,`POSITION1`,`DEPT1`,`CONTACT1`,`SITENAME`,`SITEADD1`,`SITEADD2`,`EDITED`,
				`ACC_CODE`,`PROV_DISC`,`comuen`,`CREATED_BY`,`UPDATED_BY`,`CREATED_ON`,`UPDATED_ON`,`gstno`,`country`,`postalcode`,
				`D_COUNTRY`,`D_POSTALCODE`,`END_USER`,`DELETED_BY`,`DELETED_ON`) 
				select
                a.EDI_ID,a.CUSTNO,a.NAME,a.NAME2,a.ADD1,a.ADD2,a.ADD3,a.ADD4,a.ATTN,a.DADDR1,a.DADDR2,a.DADDR3,a.DADDR4,a.DATTN,a.CONTACT,a.PHONE,a.PHONEA,a.DPHONE,a.FAX,a.DFAX,a.E_MAIL,a.WEB_SITE,a.BANKACCNO,a.AREA,a.AGENT,a.BUSINESS,a.TERM,a.CRLIMIT,a.CURRCODE,a.CURRENCY,a.CURRENCY1,a.CURRENCY2,a.POINT_BF,a.AUTOPAY,a.LC_EX,a.CT_GROUP,a.TEMP,a.TARGET,a.MOD_DEL,a.ARREM1,a.ARREM2,a.ARREM3,a.ARREM4,a.GROUPTO,a.STATUS,a.CUST_TYPE,a.ACCSTATUS,a.DATE,a.INVLIMIT,a.TERMEXCEED,a.CHANNEL,a.SALEC,a.SALECNC,a.TERM_IN_M,a.CR_AP_REF,a.CR_AP_DATE,a.COLLATERAL,a.GUARANTOR,a.DISPEC_CAT,a.DISPEC1,a.DISPEC2,a.DISPEC3,a.COMMPERC,a.OUTSTAND,a.NGST_CUST,a.PERSONIC1,a.POSITION1,a.DEPT1,a.CONTACT1,a.SITENAME,a.SITEADD1,a.SITEADD2,a.EDITED,a.ACC_CODE,a.PROV_DISC,a.comuen,a.CREATED_BY,a.UPDATED_BY,a.CREATED_ON,a.UPDATED_ON,a.gstno,a.country,a.postalcode,a.D_COUNTRY,a.D_POSTALCODE,a.END_USER,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.huserid#">,now()
				from <cfif arguments.hlinkams eq "Y">#arguments.dts1#.</cfif>#form.target_table# as a
				where a.custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#">
			</cfquery>
				
			<cfquery name="delete_customer_supplier_arcust" datasource="#arguments.dts1#">
				delete from #form.target_table# where custno='#jsstringformat(form.custno)#'
			</cfquery>
			
			<cfif arguments.hlinkams eq "Y">
				<cfquery name="delete_customer_supplier_gldata" datasource="#arguments.dts1#">
					delete from gldata where accno='#jsstringformat(form.custno)#'
				</cfquery>
			</cfif>

			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
		
		<cfset status1 = "The #form.custno# Had Been Successfully Deleted !">
		
		<cfreturn status1>
	</cffunction>
</cfcomponent>