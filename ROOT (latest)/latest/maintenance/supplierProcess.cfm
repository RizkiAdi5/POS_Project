<cfif IsDefined('url.custno')>
	<cfset URLcustno = trim(urldecode(url.custno))>
</cfif>
<cfif IsDefined('url.menuID')>
	<cfset URLmenuID = url.menuID>
</cfif>
<cfif hlinkams eq "Y">
	<cfset dts1 = replace(dts,"_i","_a","all")>
</cfif>

<cfif IsDefined('form.gst_act_date')>
	<cfif form.gst_act_date neq "">
   		<cfset ngst_act_date=dateformat(createdate(right(form.gst_act_date,4),mid(form.gst_act_date,4,2),left(form.gst_act_date,2)),'yyyy-mm-dd')>
    <cfelse>
    	<cfset ngst_act_date="0000-00-00">
    </cfif>
</cfif>

<cfif IsDefined('form.gst_app_datefrom')>
	<cfif form.gst_app_datefrom neq "">
    	<cfset ngst_app_datefrom=dateformat(createdate(right(form.gst_app_datefrom,4),mid(form.gst_app_datefrom,4,2),left(form.gst_app_datefrom,2)),'yyyy-mm-dd')>
    <cfelse>
    	<cfset ngst_app_datefrom="0000-00-00">
    </cfif>
</cfif>

<cfif IsDefined('form.gst_app_dateto')>
	<cfif form.gst_app_dateto neq "">
    	<cfset ngst_app_dateto=dateformat(createdate(right(form.gst_app_dateto,4),mid(form.gst_app_dateto,4,2),left(form.gst_app_dateto,2)),'yyyy-mm-dd')>
    <cfelse>
    	<cfset ngst_app_dateto="0000-00-00">
    </cfif>
</cfif>


<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
			<cftry>
				<cfquery name="createSupplier" datasource="#dts#">
					INSERT INTO #target_apvend# (custno,name,name2,comuen,agent,groupto,status,
                    							 add1,add2,add3,add4,country,postalcode,attn,phone,phonea,fax,e_mail,
                                                 daddr1,daddr2,daddr3,daddr4,d_country,d_postalcode,dattn,dphone,contact,dfax,web_site,
                                                 ngst_cust,gstno,taxcode,salec,salecnc,currcode,currency,currency1,term,crlimit,invlimit,
                                                 dispec_cat,dispec1,dispec2,dispec3,
                                                 business,area,end_user,date,arrem1,arrem2,arrem3,arrem4,gst_act_date,gstappno,gst_app_datefrom,gst_app_dateto,gst_valid_period)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.custno)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name2)#">,                       
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.comuen)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.agent)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.groupTo)#">,
                        <cfif IsDefined("form.status")>
                        	'T'
                        <cfelse>
                        	'F'
                        </cfif>
                        
                        ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add1)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add3)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add4)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.country)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.postalCode)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.attn)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.phone)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.hp)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fax)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.email)#">,
                        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add1)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add3)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add4)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_country)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_postalCode)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_attn)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_phone)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_hp)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_fax)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_email)#">,
                        
                        <cfif IsDefined("form.buttonYES")>
                        	'T'
                        <cfelse>
                        	'F'
                        </cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.gstno)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.taxCode)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.salec)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.salecnc)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currcode)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currency)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currency1)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.term)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.creditLimit)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.invoiceLimit)#">,
                        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.discPercentageCategory)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.discPercentageLvl_1)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.discPercentageLvl_2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.discPercentageLvl_3)#">,
                        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.business)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.area)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.driver)#">,     
                        <cfif IsDate(form.createdDate)>
                        	"#dateformat(createdate(right(form.createdDate,4),mid(form.createdDate,4,2),left(form.createdDate,2)),'yyyy-mm-dd')#"
                        <cfelse>
                        	NOW()
                        </cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remark1)#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remark2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remark3)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remark4)#"> ,
                        "#ngst_act_date#",
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.gstappno)#">,
                        "#ngst_app_datefrom#",
                        "#ngst_app_dateto#",
                        "#val(gst_valid_period)#"                      
					)
				</cfquery>
                <cfif hlinkams eq "Y">
                    <cfset acctype = 'G'>
                    <cfset id = 2>
                    <cfquery name="checkgldata" datasource="#dts1#">
                        SELECT accno 
                        FROM gldata 
                        WHERE accno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.custno)#">
                    </cfquery>
                    <cfif checkgldata.recordcount EQ 0>
                    	<cfquery name="checkgldata" datasource="#dts1#">
                            INSERT INTO gldata (accno,desp,acctype,id,currcode,groupto)
                            VALUES 
                                (
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.custno)#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,
                                    '#acctype#',
                                    '#id#',
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currcode)#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.groupto)#">  
                                )
                    	</cfquery>
                    </cfif>
                </cfif>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.custno)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/target.cfm?target=Supplier&action=create&menuID=#URLmenuID#','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.custno)# has been created successfully!');
				window.open('/latest/maintenance/custSuppProfile.cfm?target=Supplier&menuID=#URLmenuID#','_self');
			</script>
            
	<cfelseif url.action EQ "update">
		<cftry>
			<cfquery name="updateSupplier" datasource="#dts#">
				UPDATE #target_apvend#
				SET
                		custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.custno)#">,
						name= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,
						name2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name2)#">,                       
                        comuen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.comuen)#">,
                        agent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.agent)#">,
                        groupto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.groupTo)#">,
                        
						<cfif IsDefined("form.status")>
                        	status = 'T'
                        <cfelse>
                        	status = 'F'
                        </cfif>,    
                        
                        add1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add1)#">,
                        add2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add2)#">,
                        add3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add3)#">,
                        add4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add4)#">,
                        country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.country)#">,
                        postalcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.postalCode)#">,
                        attn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.attn)#">,
                        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.phone)#">,
                        phonea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.hp)#">,
                        fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fax)#">,
                        e_mail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.email)#">,
                        
                        daddr1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add1)#">,
                        daddr2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add2)#">,
                        daddr3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add3)#">,
                        daddr4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add4)#">,
                        d_country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_country)#">,
                        d_postalcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_postalCode)#">,
                        dattn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_attn)#">,
                        dphone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_phone)#">,
                        contact = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_hp)#">,
                        dfax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_fax)#">,
                        web_site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_email)#">,
                        
                        <cfif IsDefined("form.buttonYES")>
                        	ngst_cust = 'T'
                        <cfelse>
                        	ngst_cust = 'F'
                        </cfif>, 
                        
                        gstno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.gstno)#">,
                        taxcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.taxCode)#">,
                        salec = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.salec)#">, 
                        salecnc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.salecnc)#">,
                        currcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currcode)#">, 
                        currency = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currency)#">, 
                        currency1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currency1)#">,
                        term = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.term)#">,
                        crlimit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.creditLimit)#">, 
                        invlimit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.invoiceLimit)#">,
                        
      					dispec_cat = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.discPercentageCategory)#">,
                        dispec1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.discPercentageLvl_1)#">,
                        dispec2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.discPercentageLvl_2)#">,
                        dispec3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.discPercentageLvl_3)#">, 
                        
                        business = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.business)#">, 
                        area = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.area)#">, 
                        end_user = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.driver)#">, 
                        arrem1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remark1)#">, 
                        arrem2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remark2)#">,
                        arrem3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remark3)#">,
                        arrem4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.remark4)#">,
                        gst_act_date = "#ngst_act_date#",
                        gstappno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.gstappno)#">,
                        gst_app_datefrom = "#ngst_app_datefrom#",
                        gst_app_dateto = "#ngst_app_dateto#",
                        gst_valid_period="#val(gst_valid_period)#"  
       
				WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.custno)#">;
			</cfquery>
            
<!---            <cfquery name="edited_APVEND" datasource="#dts#">
				INSERT IGNORE INTO edited_apvend( 
                		`EDI_ID`,`CUSTNO`,`NAME`,`NAME2`,`ADD1`,`ADD2`,`ADD3`,`ADD4`,`ATTN`,
                        `DADDR1`,`DADDR2`,`DADDR3`,`DADDR4`,`DATTN`,`CONTACT`,`PHONE`,`PHONEA`,`DPHONE`,`FAX`,`DFAX`,`E_MAIL`,`WEB_SITE`,
                        `BANKACCNO`,`AREA`,`AGENT`,`BUSINESS`,`TERM`,`CRLIMIT`,
                        `CURRCODE`,`CURRENCY`,`CURRENCY1`,`CURRENCY2`,`POINT_BF`,`AUTOPAY`,`LC_EX`,`CT_GROUP`,`TEMP`,`TARGET`,                        `MOD_DEL`,`ARREM1`,`ARREM2`,`ARREM3`,`ARREM4`,`GROUPTO`,`STATUS`,`CUST_TYPE`,`ACCSTATUS`,`DATE`,`INVLIMIT`,`TERMEXCEED`,
                        `CHANNEL`,`SALEC`,`SALECNC`,`TERM_IN_M`,`CR_AP_REF`,`CR_AP_DATE`,`COLLATERAL`,`GUARANTOR`,
                        `DISPEC_CAT`,`DISPEC1`,`DISPEC2`,`DISPEC3`,`COMMPERC`,`OUTSTAND`,`NGST_CUST`,
                        `PERSONIC1`,`POSITION1`,`DEPT1`,`CONTACT1`,`SITENAME`,`SITEADD1`,`SITEADD2`,`EDITED`,`ACC_CODE`,`PROV_DISC`,
                        `comuen`,`CREATED_BY`,`UPDATED_BY`,`CREATED_ON`,`UPDATED_ON`,`gstno`,`country`,`postalcode`,
                        `D_COUNTRY`,`D_POSTALCODE`,`END_USER`,`DELETED_BY`,`DELETED_ON` ) 
                                                  
				SELECT 	a.EDI_ID,a.CUSTNO,a.NAME,a.NAME2,a.ADD1,a.ADD2,a.ADD3,a.ADD4,a.ATTN,a.DADDR1,a.DADDR2,a.DADDR3,a.DADDR4,
                		a.DATTN,a.CONTACT,a.PHONE,a.PHONEA,a.DPHONE,a.FAX,a.DFAX,a.E_MAIL,a.WEB_SITE,a.BANKACCNO,a.AREA,a.AGENT,a.BUSINESS,
        	        	a.TERM,a.CRLIMIT,a.CURRCODE,a.CURRENCY,a.CURRENCY1,a.CURRENCY2,a.POINT_BF,a.AUTOPAY,a.LC_EX,a.CT_GROUP,a.TEMP,a.TARGET,   
                        a.MOD_DEL,a.ARREM1,a.ARREM2,a.ARREM3,a.ARREM4,a.GROUPTO,a.STATUS,a.CUST_TYPE,a.ACCSTATUS,a.DATE,a.INVLIMIT,a.TERMEXCEED,
                        a.CHANNEL,a.SALEC,a.SALECNC,a.TERM_IN_M,a.CR_AP_REF,a.CR_AP_DATE,a.COLLATERAL,a.GUARANTOR,
                        a.DISPEC_CAT,a.DISPEC1,a.DISPEC2,a.DISPEC3,a.COMMPERC,a.OUTSTAND,a.NGST_CUST,
                        a.PERSONIC1,a.POSITION1,a.DEPT1,a.CONTACT1,a.SITENAME,a.SITEADD1,a.SITEADD2,a.EDITED,
                		a.ACC_CODE,a.PROV_DISC,a.comuen,a.CREATED_BY,a.UPDATED_BY,a.CREATED_ON,a.UPDATED_ON,a.gstno,a.country,a.postalcode,
                		a.D_COUNTRY,a.D_POSTALCODE,a.END_USER,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(huserid)#">,NOW()
				FROM #target_apvend# AS a
				WHERE a.custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.custno)#">
			</cfquery>--->
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to update #trim(form.custno)#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/target.cfm?target=Supplier&action=update&menuID=#URLmenuID#&custno=#form.custno#','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.custno)# successfully!');
			window.open('/latest/maintenance/custSuppProfile.cfm?target=Supplier&menuID=#URLmenuID#','_self');
		</script>	
	<cfelseif url.action EQ "delete">
    	<cftry>
        	<cfquery name="checkTransactionExist" datasource="#dts#">
				SELECT custno 
				FROM artran 
				WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcustno#">
				LIMIT 1;
			</cfquery>
            <cfif checkTransactionExist.recordcount EQ 0>
				<cfif hlinkams EQ "Y">
                    <cfquery name="checkAMSExist" datasource="#dts1#">
                   		SELECT accno
                        FROM glpost 
                        WHERE accno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcustno#">
                        LIMIT 1;
                    </cfquery>
                </cfif>
            </cfif>
            <cfif checkTransactionExist.recordcount EQ 1>
                <script type="text/javascript">
					window.open('/latest/maintenance/custSuppProfile.cfm?target=Supplier&custno=#URLcustno#&menuID=#URLmenuID#&message=usedInTransaction','_self');
				</script>
                <cfabort>
			</cfif>
        	<cfcatch type="any">
            	<script type="text/javascript">
					alert('Failed to delete #URLcustno#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/target.cfm?target=Supplier&action=delete&menuID=#URLmenuID#&custno=#URLcustno#','_self');
				</script>
            </cfcatch>
        </cftry>
		<cftry>
        	<cfquery name="auditTrail_Deleted" datasource="#dts#">
				INSERT INTO deleted_arcust( `EDI_ID`,`CUSTNO`,`NAME`,`NAME2`,`ADD1`,`ADD2`,`ADD3`,`ADD4`,`ATTN`,`DADDR1`,`DADDR2`,`DADDR3`,`DADDR4`,
											`DATTN`,`CONTACT`,`PHONE`,`PHONEA`,`DPHONE`,`FAX`,`DFAX`,`E_MAIL`,`WEB_SITE`,`BANKACCNO`,`AREA`,`AGENT`,`BUSINESS`,
											`TERM`,`CRLIMIT`,`CURRCODE`,`CURRENCY`,`CURRENCY1`,`CURRENCY2`,`POINT_BF`,`AUTOPAY`,`LC_EX`,`CT_GROUP`,`TEMP`,`TARGET`,
											`MOD_DEL`,`ARREM1`,`ARREM2`,`ARREM3`,`ARREM4`,`GROUPTO`,`STATUS`,`CUST_TYPE`,`ACCSTATUS`,`DATE`,`INVLIMIT`,`TERMEXCEED`,
											`CHANNEL`,`SALEC`,`SALECNC`,`TERM_IN_M`,`CR_AP_REF`,`CR_AP_DATE`,`COLLATERAL`,`GUARANTOR`,`DISPEC_CAT`,`DISPEC1`,`DISPEC2`,
											`DISPEC3`,`COMMPERC`,`OUTSTAND`,`NGST_CUST`,`PERSONIC1`,`POSITION1`,`DEPT1`,`CONTACT1`,`SITENAME`,`SITEADD1`,`SITEADD2`,`EDITED`,
											`ACC_CODE`,`PROV_DISC`,`comuen`,`CREATED_BY`,`UPDATED_BY`,`CREATED_ON`,`UPDATED_ON`,`gstno`,`country`,`postalcode`,
											`D_COUNTRY`,`D_POSTALCODE`,`END_USER`,`DELETED_BY`,`DELETED_ON`) 
				SELECT
                		a.EDI_ID,a.CUSTNO,a.NAME,a.NAME2,a.ADD1,a.ADD2,a.ADD3,a.ADD4,a.ATTN,a.DADDR1,a.DADDR2,a.DADDR3,a.DADDR4,
                		a.DATTN,a.CONTACT,a.PHONE,a.PHONEA,a.DPHONE,a.FAX,a.DFAX,a.E_MAIL,a.WEB_SITE,a.BANKACCNO,a.AREA,a.AGENT,a.BUSINESS,
                		a.TERM,a.CRLIMIT,a.CURRCODE,a.CURRENCY,a.CURRENCY1,a.CURRENCY2,a.POINT_BF,a.AUTOPAY,a.LC_EX,a.CT_GROUP,a.TEMP,a.TARGET,
                		a.MOD_DEL,a.ARREM1,a.ARREM2,a.ARREM3,a.ARREM4,a.GROUPTO,a.STATUS,a.CUST_TYPE,a.ACCSTATUS,a.DATE,a.INVLIMIT,a.TERMEXCEED,
                		a.CHANNEL,a.SALEC,a.SALECNC,a.TERM_IN_M,a.CR_AP_REF,a.CR_AP_DATE,a.COLLATERAL,a.GUARANTOR,a.DISPEC_CAT,a.DISPEC1,a.DISPEC2,
                		a.DISPEC3,a.COMMPERC,a.OUTSTAND,a.NGST_CUST,a.PERSONIC1,a.POSITION1,a.DEPT1,a.CONTACT1,a.SITENAME,a.SITEADD1,a.SITEADD2,a.EDITED,
                		a.ACC_CODE,a.PROV_DISC,a.comuen,a.CREATED_BY,a.UPDATED_BY,a.CREATED_ON,a.UPDATED_ON,a.gstno,a.country,a.postalcode,a.D_COUNTRY,a.D_POSTALCODE,
                		a.END_USER,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(huserid)#">,NOW()
				FROM #target_arcust# AS a
				WHERE a.custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcustno#">
			</cfquery>
			<cfquery name="deleteSupplier" datasource="#dts#">
				DELETE FROM #target_apvend#
				WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(URLcustno)#">
			</cfquery>
            <cfif hlinkams EQ "Y">
				<cfquery name="deleteCustomer_GLDATA" datasource="#dts1#">
					DELETE FROM gldata 
                    WHERE accno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcustno#">
				</cfquery>
			</cfif>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLcustno#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/target.cfm?target=Supplier&action=delete&menuID=#URLmenuID#&custno=#URLcustno#','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLcustno# successfully!');
			window.open('/latest/maintenance/custSuppProfile.cfm?target=Supplier&menuID=#URLmenuID#','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printSupplier" datasource="#dts#">
			SELECT custno,name,name2
			FROM #target_apvend#
			ORDER BY custno;
		</cfquery>
        <cfoutput>		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <title>#url.pageTitle# Listing</title>
            <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
            <!--[if lt IE 9]>
                <script type="text/javascript" src="/latest/js/html5shiv/html5shiv.js"></script>
                <script type="text/javascript" src="/latest/js/respond/respond.min.js"></script>
            <![endif]-->
            <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
		</head>
		<body>
		<div class="container">
            <div class="page-header">
                <h1 class="text">#url.pageTitle# Listing</h1>
                <p class="lead">Company: #getGsetup.compro#</p>
            </div>
            
            <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>SUPPLIER</th>
                        <th>NAME</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="printSupplier">
                    <tr>
                        <td>#custno#</td>
                        <td>#name# #name2#</td>
                    </tr>
                    </cfloop>
                </tbody>
            </table>
            </div>
            <div class="panel-footer">
                <p>Printed at #DateFormat(NOW(),'dd-mm-yyyy')#, #TimeFormat(NOW(),'HH:MM:SS')#</p>
            </div>
		</div>		
		</body>
		</html>
        </cfoutput>
	<cfelse>
		<script type="text/javascript">
			window.open('','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('','_self');
	</script>
</cfif>
</cfoutput>