<cfquery datasource="#dts#" name="getcust">
	select name,van,wos_date,rem5
	from artran 
	where type='#tran#' 
	and refno='#nexttranno#'
</cfquery>

<cfquery datasource="#dts#" name="gettime">
	select * from ictran 
	where type='#tran#' 
	and refno='#nexttranno#' 
	and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
	limit 1
</cfquery>

<cfif tran eq "RC" or tran eq "OAI" or tran eq "CN">
	<cfset obtype= "bth_qin">
<cfelse>
	<cfset obtype= "bth_qut">
</cfif>

<cfset xtime = right(gettime.trdatetime,10)>
<cfset xtime2 = left(xtime,8)>		
<cfset nowdatetime = dateformat(getcust.wos_date,"yyyy-mm-dd") & " " & xtime2>

<cfif isdefined('form.asvoucher')>
<cfquery name="getictran" datasource="#dts#">
SELECT voucherno FROM ictran where type='#tran#' 
        and refno='#nexttranno#' 
        and itemno='#form.itemno#' 
        and itemcount='#itemcount#';
</cfquery>

<cfif getictran.voucherno neq "">
<cfif form.voucherno eq "">
        <cfquery name="getlastvoucherno" datasource="#dts#">
        select max(voucherno) as voucherno from voucher WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#">
        </cfquery>
        <cfif getlastvoucherno.voucherno neq "">
        <cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastvoucherno.voucherno#" returnvariable="newvoucherno" />
        <cfset form.voucherno = newvoucherno>
        <cfelse>
        <cfset form.voucherno = right(form.custno,3)&"000001">
        </cfif>
    <cfelse>
        <cfquery name="checkexistvoucherno" datasource="#dts#">
        SELECT voucherno FROM voucher where voucherno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucherno#"> and voucherid <> "#getictran.voucherno#"
        </cfquery>
        <cfif checkexistvoucherno.recordcount neq 0>
            <cfquery name="getlastvoucherno" datasource="#dts#">
            select max(voucherno) as voucherno from voucher WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#">
            </cfquery>
				<cfif getlastvoucherno.voucherno neq "">
                <cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastvoucherno.voucherno#" returnvariable="newvoucherno" />
                <cfset form.voucherno = newvoucherno>
                <cfelse>
                <cfset form.voucherno = right(getartran.custno,3)&"000001">
                </cfif>
		</cfif>
	</cfif>
  <cfquery name="updatevoucher" datasource="#dts#">
    UPDATE voucher
    SET
    voucherno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucherno#">,
    custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#">,
    value = '#val(amt1_bil)#',
    updated_by = '#huserid#',
    updated_on = now()
    WHERE voucherid = "#getictran.voucherno#"
    </cfquery>
    <cfset form.voucherno = getictran.voucherno>
    
    <cfelse>
    <cfif form.voucherno eq "">
        <cfquery name="getlastvoucherno" datasource="#dts#">
        select max(voucherno) as voucherno from voucher WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#">
        </cfquery>
        <cfif getlastvoucherno.voucherno neq "">
        <cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastvoucherno.voucherno#" returnvariable="newvoucherno" />
        <cfset form.voucherno = newvoucherno>
        <cfelse>
        <cfset form.voucherno = right(form.custno,3)&"000001">
        </cfif>
    <cfelse>
        <cfquery name="checkexistvoucherno" datasource="#dts#">
        SELECT voucherno FROM voucher where voucherno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucherno#">
        </cfquery>
        <cfif checkexistvoucherno.recordcount neq 0>
            <cfquery name="getlastvoucherno" datasource="#dts#">
            select max(voucherno) as voucherno from voucher WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#">
            </cfquery>
				<cfif getlastvoucherno.voucherno neq "">
                <cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastvoucherno.voucherno#" returnvariable="newvoucherno" />
                <cfset form.voucherno = newvoucherno>
                <cfelse>
                <cfset form.voucherno = right(getartran.custno,3)&"000001">
                </cfif>
		</cfif>
    
	</cfif>
    
    <cfquery name="insertvoucher" datasource="#dts#">
    insert into voucher (voucherno,type,value,desp,created_by,created_on,custno)
values
(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucherno#">,'Value','#val(amt_bil)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,'#HUserID#',now(),<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#" >)
    </cfquery>
    <cfquery name="getID" datasource="#dts#">
			Select LAST_INSERT_ID() as en;
	</cfquery>
    <cfset form.voucherno = getID.en>
    <cfset form.asvoucher = "Y">
	</cfif>
    
	
	<cfelseif isdefined('form.asvoucher') eq false and getGeneralInfo.asvoucher eq "Y">
    
    <cfquery name="getictran" datasource="#dts#">
    SELECT voucherno FROM ictran where type='#tran#' 
            and refno='#nexttranno#' 
            and itemno='#form.itemno#' 
            and itemcount='#itemcount#';
    </cfquery>
    <cfquery name="deletevoucher" datasource="#dts#">
    delete from voucher where voucherid = "#getictran.voucherno#"
    </cfquery>
    <cfset form.asvoucher = "N">
    <cfset form.voucherno = "">
</cfif>

<cfloop from="1" to="#ArrayLen(locationArray)#" index="i">
	<cfquery name="checkexist" datasource="#dts#">
		select * from ictran
		where type='#tran#' 
		and refno='#nexttranno#' 
		and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
		and location = '#locationArray[i]#'
	</cfquery>
	
	<cfset enterbatchcode = batchArray[i]>
	<cfset oldbatchcode = oldbatchArray[i]>
	<cfset adtcost1 = mc1bilArray[i]>
	<cfset adtcost2 = mc2bilArray[i]>
	<cfset mc1bil = mc1bilArray[i]>
	<cfset mc2bil = mc2bilArray[i]>
    <cfset milcert = milcertArray[i]>
    <cfset importpermit = importpermitArray[i]>
	<cfif trim(sodateArray[i]) neq "">
		<cfset sodate = createDate(ListGetAt(sodateArray[i],3,"-"),ListGetAt(sodateArray[i],2,"-"),ListGetAt(sodateArray[i],1,"-"))>
	<cfelse>
		<cfset sodate = "">
	</cfif>
	<cfif trim(dodateArray[i]) neq "">
		<cfset dodate = createDate(ListGetAt(dodateArray[i],3,"-"),ListGetAt(dodateArray[i],2,"-"),ListGetAt(dodateArray[i],1,"-"))>
	<cfelse>
		<cfset dodate = "">
	</cfif>	
	<cfif trim(expdateArray[i]) neq "">
		<cfset expdate = createDate(ListGetAt(expdateArray[i],3,"-"),ListGetAt(expdateArray[i],2,"-"),ListGetAt(expdateArray[i],1,"-"))>
	<cfelse>
		<cfset expdate = "">
	</cfif>
    <cfif trim(manudateArray[i]) neq "">
		<cfset manudate = createDate(ListGetAt(manudateArray[i],3,"-"),ListGetAt(manudateArray[i],2,"-"),ListGetAt(manudateArray[i],1,"-"))>
	<cfelse>
		<cfset manudate = "">
	</cfif>
	<cfset defective = defectiveArray[i]>
	
	<cfset amt1_bil = val(qtyArray[i]) * val(form.price)>
	<cfset disamt_bil1 = (val(form.dispec1) / 100) * amt1_bil>
	<cfset netamt = amt1_bil - disamt_bil1>
	<cfset disamt_bil2 = (val(form.dispec2) / 100) * netamt>
	<cfset netamt = netamt - disamt_bil2>
	<cfset disamt_bil3 = (val(form.dispec3) / 100) * netamt>
	<cfset netamt = netamt - disamt_bil3>
	<cfset disamt_bil = disamt_bil1 + disamt_bil2 + disamt_bil3>
        
    <cfset taxamt_bil = (val(form.taxpec1) / 100) * netamt>
	<!--- <cfset amt_bil = val(netamt) + taxamt_bil> --->
    <cfset amt_bil = val(netamt)>
    <cfset xprice = val(form.price) * currrate>
    <cfset amt1 = amt1_bil * currrate>
    <cfset disamt = disamt_bil * currrate>
    <cfset taxamt = taxamt_bil * currrate>
    <cfset amt = amt_bil * currrate>
    <cfset amt = val(amt)>
        
    <cfif val(form.factor1) neq 0>
		<cfset xprice = (xprice * val(form.factor2)) / val(form.factor1)>
    <cfelse>
        <cfset xprice = 0>
    </cfif>
    <cfif val(form.factor2) neq 0>
        <cfset act_qty = val(qtyArray[i]) * val(form.factor1) / val(form.factor2)>
    <cfelse>
        <cfset act_qty = 0>
    </cfif>
		
	<cfset oldqty = val(oldqtyArray[i])>
		
	<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
		<cfif trim(enterbatchcode) neq "">		<!--- Enterbatchcode neq Empty --->
			<cfif enterbatchcode eq oldbatchcode>		<!--- Enterbatcode eq Oldbatchcode --->
				<cfquery name="updatelobthob" datasource="#dts#">
					update obbatch 
					set #obtype#=(#obtype#+(#act_qty#-#oldqty#))
					where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
					and batchcode='#enterbatchcode#'
				</cfquery>
					
				<cfquery name="updatelobthob" datasource="#dts#">
					update lobthob set 
					#obtype#=(#obtype#+(#act_qty#-#oldqty#)) 
					where location= '#locationArray[i]#'
					and itemno= <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
					and batchcode='#enterbatchcode#'
				</cfquery>
			<cfelse>		<!--- Enterbatchcode neq Oldbatchcode --->
				<cfquery name="checkbatch" datasource="#dts#">
					select batchcode from obbatch 
					where batchcode='#enterbatchcode#'
					and itemno= <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
				</cfquery>
				<cfif checkbatch.recordcount eq 0>
					<cfquery name="insertbatch" datasource="#dts#">
						insert into obbatch
                         (
                            batchcode,
                            itemno,
                            type,
                            refno,
                            bth_QOB,
                            BTH_QIN,
                            BTH_QUT,
                            RPT_QOB,
                            RPT_QIN,
                            RPT_QUT,
                            EXP_DATE,
                            manu_date,
                            milcert,
                            importpermit,
                            RC_TYPE,
                            RC_REFNO,
                            RC_EXPDATE
                        ) 
                         values 
						(
							'#enterbatchcode#',
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
							'#tran#',
                            '#nexttranno#',
                            '0',
							'<cfif obtype eq "bth_qin">#act_qty#<cfelse>0</cfif>',
							'<cfif obtype eq "bth_qut">#act_qty#<cfelse>0</cfif>',
							'0',
                            '0',
                            '0',
							<cfif expdate neq "">#expdate#<cfelse>'0000-00-00'</cfif>,
							<cfif manudate neq "">#manudate#<cfelse>'0000-00-00'</cfif>,'#milcert#','#importpermit#',
							'#tran#',
                            '#nexttranno#',
							<cfif expdate neq "">#expdate#<cfelse>'0000-00-00'</cfif>
						)
					</cfquery>
				<cfelse>
					<cfquery name="updateobbatch" datasource="#dts#">
						update obbatch set 
						#obtype#=(#obtype#+#act_qty#) 
						where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and batchcode='#enterbatchcode#'
					</cfquery>
				</cfif>
					
				<cfquery name="checklobthob" datasource="#dts#">
					select batchcode from lobthob 
					where location = '#locationArray[i]#'
					and batchcode = '#enterbatchcode#'
					and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
				</cfquery>
				<cfif checklobthob.recordcount eq 0>
					<cfquery name="insertlobthob" datasource="#dts#">
						insert into lobthob
                        ( location,
                            batchcode,
                            itemno,
                            type,
                            refno,
                            bth_QOB,
                            BTH_QIN,
                            BTH_QUT,
                            RPT_QOB,
                            RPT_QIN,
                            RPT_QUT,
                            EXPDATE,
                            manudate,
                            milcert,
                            importpermit,
                            RC_TYPE,
                            RC_REFNO,
                            RC_EXPDATE
                            )
                         values 
						(
							'#locationArray[i]#',
                            '#enterbatchcode#',
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
							'#tran#',
                            '#nexttranno#',
                            '0',
							'<cfif obtype eq "bth_qin">#act_qty#<cfelse>0</cfif>',
							'<cfif obtype eq "bth_qut">#act_qty#<cfelse>0</cfif>',
							'0',
                            '0',
                            '0',
							<cfif expdate neq "">#expdate#<cfelse>'0000-00-00'</cfif>,
                            <cfif manudate neq "">#manudate#<cfelse>'0000-00-00'</cfif>,'#milcert#','#importpermit#',
							'#tran#',
                            '#nexttranno#',
							<cfif expdate neq "">#expdate#<cfelse>'0000-00-00'</cfif>
						)
					</cfquery>
				<cfelse>
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#+#act_qty#) 
						where location = '#locationArray[i]#'
						and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
						and batchcode = '#enterbatchcode#'
					</cfquery>
				</cfif>
					
				<cfif trim(oldbatchcode) neq "">	<!--- Oldbatchcode neq Empty --->
					<cfquery name="updateobbatch" datasource="#dts#">
						update obbatch set 
						#obtype#=(#obtype#-#oldqty#) 
						where batchcode='#oldbatchcode#' 
						and itemno= <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
					</cfquery>
					<cfquery name="updateobbatch" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#-#oldqty#) 
						where location = '#locationArray[i]#'
						and batchcode='#oldbatchcode#' 
						and itemno= <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
					</cfquery>				
				</cfif>
			</cfif>
		<cfelse>		<!--- Enterbatcode eq Empty --->
			<cfif trim(oldbatchcode) neq "">
				<cfquery name="updateobbatch" datasource="#dts#">
					update obbatch set 
					#obtype#=(#obtype#-#oldqty#) 
					where batchcode='#oldbatchcode#' 
					and itemno= <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
				</cfquery>
				<cfquery name="updateobbatch" datasource="#dts#">
					update lobthob set 
					#obtype#=(#obtype#-#oldqty#) 
					where location = '#locationArray[i]#'
					and batchcode='#oldbatchcode#' 
					and itemno= <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
				</cfquery>	
			</cfif>
		</cfif>
	</cfif>
	
	<cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#sodate#" returnvariable="sodate"/>
    <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#dodate#" returnvariable="dodate"/>
    <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#expdate#" returnvariable="expdate"/>
    <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#manudate#" returnvariable="manudate"/>
    <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="" returnvariable="exported1"/>
	<cfif checkexist.recordcount neq 0>
		<!--- <cfif val(checkexist.factor2) neq 0>
	        <cfset oldqty = val(oldqtyArray[i]) * val(checkexist.factor1) / val(checkexist.factor2)>
	    <cfelse>
	        <cfset oldqty = 0>
	    </cfif> --->
		  
		<cfif val(qtyArray[i]) neq 0>
			<cfquery datasource="#dts#" name="updateartran">
				update ictran set 
				wos_date=#getcust.wos_date#,
				location ='#locationArray[i]#',
				custno='#form.custno#',
				desp= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
				despa= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.despa#">,
				currrate='#currrate#',
				fperiod='#numberformat(readperiod,"00")#',
				agenno='#form.agenno#',
				dispec1='#form.dispec1#',
				dispec2='#form.dispec2#',
				dispec3='#form.dispec3#',
				taxpec1='#form.taxpec1#',
				gltradac='#form.gltradac#',
				qty_bil='#qtyArray[i]#',
				price_bil='#form.price#',
				unit_bil='#form.unit#',
				amt1_bil='#amt1_bil#', 
				disamt_bil='#disamt_bil#',
				amt_bil='#val(amt_bil)#',
				taxamt_bil ='#taxamt_bil#',
				<!--- <cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
					LOC_CURRRATE = '#loc_currrate#',
					LOC_CURRCODE =	'#loc_currrcode#',
				</cfif> --->
				qty='#act_qty#',
				price='#xprice#',
				unit='#getitem.unit#',
				factor1 = '#form.factor1#',
			    factor2 = '#form.factor2#',
				amt1='#amt1#',
				disamt='#disamt#',
				amt='#val(amt)#',
				taxamt='#taxamt#',
        		note_a='#form.selecttax#',
				brem1='#form.requestdate#',
				brem2='#form.crequestdate#',
				brem3='#form.brem3#',
				brem4='<cfif ucase(form.brem4) eq "XCOST">XCOST<cfelse>#form.brem4#</cfif>',
				<cfif lcase(hcomid) eq "avent_i" or lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
					brem5='#form.brem5#',
					brem6='#form.brem6#',
                <cfif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
                	brem7='#form.brem7#',
                    brem8='#form.brem8#',
                    brem9='#form.brem9#',
				</cfif>
				</cfif>
				packing='#form.packing#',
				van='#getcust.van#',
				name='#getcust.name#',
				wos_group='#getitem.wos_group#',
				category='#getitem.category#',
				sv_part='#form.sv_part#',
				sercost='#val(form.sercost)#',
				userid='#huserid#',
				trdatetime='#nowdatetime#',
				comment= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(form.comment)#">,
				sodate='#sodate#',
				dodate='#dodate#',
				adtcost1='#val(adtcost1)*currrate#',
				adtcost2='#val(adtcost2)*currrate#',
				batchcode='#enterbatchcode#',
				expdate='#expdate#',
                manudate='#manudate#',
                milcert='#milcert#',
                importpermit='#importpermit#',
				mc1_bil='#val(mc1bil)#',
				mc2_bil='#val(mc2bil)#',
				defective='#defective#',
				nodisplay='#form.nodisplay#',
				title_id='#form.title_id#',
				title_desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(form.title_desp)#">,
				source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
				job=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
				<cfif lcase(hcomid) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i">title_despa=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.title_despa#">,</cfif>
				mc3_bil=mc3_bil,
				mc4_bil=mc4_bil,
				mc5_bil=mc5_bil,
				mc6_bil=mc6_bil,
				mc7_bil=mc7_bil,
				m_charge1=m_charge1,
				m_charge2=m_charge2,
				m_charge3=m_charge3,
				m_charge4=m_charge4,
				m_charge5=m_charge5,
				m_charge6=m_charge6,
				m_charge7=m_charge7 
                <cfif isdefined('form.taxinclude') and wpitemtax eq "Y">,taxincl = '#form.taxinclude#'<cfelse>,taxincl = ''</cfif>
				<cfif isdefined('form.it_cos') and tran eq "CN">
				<cfif form.it_cos eq "" or form.it_cos eq 0>
                <cfset it_cos = val(amt)>
                <cfelse>
                <cfset it_cos = form.it_cos>
                </cfif>
                ,it_cos = <cfqueryparam cfsqltype="cf_sql_varchar" value="#it_cos#" >
                </cfif>
                <cfif isdefined('form.foc')>
                ,foc = "#form.foc#"
				</cfif>
                <cfif isdefined('form.asvoucher')>
        ,asvoucher="#form.asvoucher#"
        ,voucherno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucherno#"></cfif>
				where type='#tran#' 
				and refno='#nexttranno#' 
				and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
				and location = '#locationArray[i]#'
			</cfquery>
            
            <cfif lcase(hcomid) eq "accord_i" and tran eq "INV" and getcust.rem5 neq "" and isdate(form.brem4)>
            <cfquery name="updateexpdate" datasource="#dts#">
            Update vehicles SET inexpdate = "#dateformat(form.brem4,'YYYY-MM-DD')#" where carno = "#getcust.rem5#" and custcode = "#form.custno#"
            </cfquery>
			</cfif>
            
		<cfelse>
			<cfquery name="delete" datasource="#dts#">
				delete from ictran
				where type='#tran#' 
				and refno='#nexttranno#' 
				and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
				and location = '#locationArray[i]#'
			</cfquery>
		</cfif>
		
	<cfelse>
		<cfquery name="getmax" datasource="#dts#">
			select max(itemcount) as itemcnt 
			from ictran
			where type='#tran#'
			and refno='#nexttranno#'
		</cfquery>
		<cfif getmax.recordcount neq 0>
			<cfset itemcnt =  val(getmax.itemcnt) + 1>
		<cfelse>
			<cfset itemcnt = 1>
		</cfif>
		
		<cfset oldqty = 0>
		<cfif val(qtyArray[i]) neq 0>
			<cfquery name="insertictran" datasource="#dts#" >
				insert into ictran 
				(
					type,refno,custno,fperiod,wos_date,currrate,trancode,itemcount,linecode,
					itemno,desp,despa,agenno,location,
					qty_bil,price_bil,unit_bil,amt1_bil,
					dispec1,dispec2,dispec3,
					disamt_bil,amt_bil,
					taxpec1,gltradac,taxamt_bil,<!--- <cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">LOC_CURRRATE,LOC_CURRCODE,</cfif> --->
					qty,price,unit,factor1,factor2,amt1,disamt,amt,taxamt,note_a,
					dono,name,exported,exported1,sono,toinv,van,generated,
					wos_group,category,brem1,brem2,brem3,brem4,<cfif lcase(hcomid) eq "avent_i" or lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">brem5,brem6,<cfif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">brem7,brem8,brem9</cfif></cfif>
					packing,shelf,source,job,
					trdatetime,sv_part,sercost,userid,sodate,dodate,
					adtcost1,adtcost2,batchcode,expdate,manudate,milcert,importpermit,mc1_bil,mc2_bil,defective,nodisplay,title_id,title_desp,<cfif lcase(hcomid) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i">title_despa,</cfif>
					comment,
					m_charge1,m_charge2,m_charge3,m_charge4,m_charge5,m_charge6,m_charge7,
					mc3_bil,mc4_bil,mc5_bil,mc6_bil,mc7_bil<cfif isdefined('form.taxinclude')>,taxincl</cfif><cfif isdefined('form.foc')>,foc</cfif><cfif isdefined('form.asvoucher')>,asvoucher,voucherno</cfif>
				)
				values
				(
					'#tran#','#nexttranno#','#form.custno#','#numberformat(form.readperiod,"00")#',#getcust.wos_date#,
					'#currrate#','#itemcnt#','#itemcnt#',<cfif form.service neq "">'SV'<cfelse>''</cfif>,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.despa#">,
					'#form.agenno#','#locationArray[i]#','#val(qtyArray[i])#','#form.price#',
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.unit#">,'#amt1_bil#',
					'#val(form.dispec1)#','#val(form.dispec2)#','#val(form.dispec3)#',
					'#disamt_bil#','#val(amt_bil)#','#val(form.taxpec1)#','#form.gltradac#','#val(taxamt_bil)#',
					<!--- <cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">'#loc_currrate#','#loc_currrcode#',</cfif> --->
					'#act_qty#','#xprice#','#getitem.unit#','#form.factor1#','#form.factor2#',
					'#amt1#','#disamt#','#val(amt)#','#val(taxamt)#','#form.selecttax#','',
					'#getcust.name#','','#exported1#','','','#getcust.van#','',
					'#gettime.wos_group#','#gettime.category#','#form.requestdate#','#form.crequestdate#',
					'#form.brem3#','<cfif ucase(form.brem4) eq "XCOST">XCOST<cfelse>#form.brem4#</cfif>',
					<cfif lcase(hcomid) eq "avent_i" or lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">		'#form.brem5#','#form.brem6#',
                    <cfif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
                    '#form.brem7#','#form.brem8#','#form.brem9#',
					</cfif>
					</cfif>
					'#form.packing#','#form.shelf#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
					'#nowDatetime#','#form.sv_part#','#val(form.sercost)#',
					'#huserid#','#sodate#','#dodate#',
					'#val(adtcost1)*currrate#','#val(adtcost2)*currrate#',
					'#enterbatchcode#','#expdate#','#manudate#','#milcert#','#importpermit#',
					'#mc1bil#','#mc2bil#','#defective#','#form.nodisplay#','#form.title_id#','#form.title_desp#',
					<cfif lcase(hcomid) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i"><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.title_despa#">,</cfif>
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(form.comment)#">,
					'0','0','0','0','0','0','0','0','0','0','0','0'<cfif isdefined('form.taxinclude')>,'#form.taxinclude#'</cfif><cfif isdefined('form.foc')>,"#form.foc#"</cfif><cfif isdefined('form.asvoucher')>,"Y",<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucherno#"></cfif>
				)		
			</cfquery>
		</cfif>
	</cfif>
	
	<cfif val(act_qty) neq val(oldqty)>
		<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
			<cfif lcase(HUserID) neq "kellysteel2">
				<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">
					<cfset qname='QIN'&(readperiod+10)>
				<cfelse>
					<cfset qname='QOUT'&(readperiod+10)>
				</cfif>
				
				<cfquery name="checkitemqty" datasource="#dts#">
					select itemno from icitem 
					where itemno= <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
					and #qname# <> 0
				</cfquery>
				
				<cfif checkitemqty.recordcount eq 0>	<!--- when qin/qout eq 0 --->
					<cfset check = "y">
				<cfelse>
					<cfset check = "n">
				</cfif>
				
				<cfquery name="UpdateIcitem" datasource="#dts#">
					update icitem set 
					#qname#=<cfif check eq "y">(#qname#+#act_qty#)<cfelse>(#qname#+(#act_qty#-#oldqty#))</cfif> 
					where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
</cfloop>

<cfquery name="getLast" datasource="#dts#">
	select 
	itemcount 
	from 
	ictran 
	where type='#tran#'
	and refno='#nexttranno#' 
	and custno='#form.custno#' 
	order by itemcount
</cfquery>

<cfinvoke method="reorder" refno="#nexttranno#" itemcountlist="#valuelist(getLast.itemcount)#"/>

<cfif val(form.dispec1) eq 0 and val(form.dispec2) eq 0 and val(form.dispec3) eq 0 and val(discamt) neq 0>
	<cfquery name="getitemrecord" datasource="#dts#">
		select * from ictran
		where type='#tran#'
		and refno='#nexttranno#'
		and custno='#form.custno#'
		and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
		and price_bil='#form.price#'
		order by trancode
	</cfquery>
	<cfif getitemrecord.recordcount neq 0>
		<cfset count = getitemrecord.recordcount>
		<cfset thisdisamt_bil = Decimalformat(val(discamt) / count)>
		
		<cfset thisrow=1>
		<cfloop query="getitemrecord">
			<cfset thisamt1_bil = getitemrecord.qty_bil * val(getitemrecord.price_bil)>
			<cfset thisnetamt = thisamt1_bil - val(thisdisamt_bil)>
		        
		    <cfset thistaxamt_bil = (val(getitemrecord.taxpec1) / 100) * thisnetamt>
			<!--- <cfset thisamt_bil = val(thisnetamt) + thistaxamt_bil> --->
            <cfset thisamt_bil = val(thisnetamt)>
		    
		    <cfset thisdisamt = thisdisamt_bil * val(getitemrecord.currrate)>
		    <cfset thistaxamt = thistaxamt_bil * val(getitemrecord.currrate)>
		    <cfset thisamt = val(thisamt_bil) * val(getitemrecord.currrate)>
		    
			<cfif thisrow neq count>
				<cfquery name="update" datasource="#dts#">
					update ictran
					set DISAMT_BIL = #thisdisamt_bil#,
					AMT_BIL = #thisamt_bil#,
					TAXAMT_BIL = #thistaxamt_bil#,
					DISAMT = #thisdisamt#,
					AMT = #thisamt#,
					TAXAMT = #thistaxamt#
					where type='#getitemrecord.type#'
					and refno='#getitemrecord.refno#'
					and custno='#getitemrecord.custno#'
					and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#getitemrecord.itemno#">
					and trancode = #getitemrecord.trancode#
				</cfquery>
				<cfset thisamt1_bil = discamt - val(thisamt1_bil)>
				<cfset discamt = discamt - val(thisamt1_bil)>
			<cfelse>
				<cfquery name="update" datasource="#dts#">
					update ictran
					set DISAMT_BIL = #thisdisamt_bil#,
					AMT_BIL =  #thisamt_bil#,
					TAXAMT_BIL = #thistaxamt_bil#,
					DISAMT = #thisdisamt#,
					AMT = #thisamt#,
					TAXAMT = #thistaxamt#
					where type='#getitemrecord.type#'
					and refno='#getitemrecord.refno#'
					and custno='#getitemrecord.custno#'
					and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#getitemrecord.itemno#">
					and trancode = #getitemrecord.trancode#
				</cfquery>
			</cfif>			
			<cfset thisrow=thisrow+1>
		</cfloop>
	</cfif>	
</cfif>

<cfif wpitemtax eq "Y">
	<cfquery name="gettax" datasource="#dts#">
    	select sum(taxamt_bil) as tt_taxamt_bil from ictran where type='#tran#' and refno='#nexttranno#' and (void='' or void is null)
    </cfquery>
    <cfquery name="updatetax" datasource="#dts#">
    	update artran set tax_bil='#val(gettax.tt_taxamt_bil)#' where type='#tran#' and refno='#nexttranno#'
    </cfquery>
</cfif>

<cfset status = "Item Edited Successfully">