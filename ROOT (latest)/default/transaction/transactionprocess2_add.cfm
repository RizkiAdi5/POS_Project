<cfquery name="getcust" datasource="#dts#">
	select name,van,source,job,wos_date,rem5
	from artran 
	where type='#tran#'
	and refno='#nexttranno#'
</cfquery>

<cfset nowdatetime = dateformat(getcust.wos_date,"yyyy-mm-dd") & " " & timeformat(now(),"HH:mm:ss")>	

<cfquery name="getmax" datasource="#dts#">
	select max(itemcount) as itemcnt 
	from ictran
	where type='#tran#'
	and refno='#nexttranno#' 
	and custno='#form.custno#'  
</cfquery>
<cfif getmax.recordcount neq 0>
	<cfset itemcnt =  val(getmax.itemcnt) + 1>
<cfelse>
	<cfset itemcnt = 1>
</cfif>

<cfloop from="1" to="#ArrayLen(locationArray)#" index="i">
	<cfif val(qtyArray[i]) neq 0>
		
		<cfset enterbatcode = batchArray[i]>
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
        <cfset disamt_bil = numberformat(disamt_bil,'.__')>

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
		
		<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
			<cfif trim(enterbatcode) neq "">
				<cfif tran eq "RC" or tran eq "OAI" or tran eq "CN">
					<cfset obtype = "bth_qin">
				<cfelse>
					<cfset obtype = "bth_qut">
				</cfif>
				
				<cfquery name="checkbatch" datasource="#dts#">
					select batchcode from obbatch 
					where batchcode='#enterbatcode#' 
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
							'#enterbatcode#',
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
							'#tran#','#nexttranno#','0',
							'<cfif obtype eq "bth_qin">#act_qty#<cfelse>0</cfif>',
							'<cfif obtype eq "bth_qut">#act_qty#<cfelse>0</cfif>',
							'0','0','0',
							<cfif expdate neq "">#expdate#<cfelse>''</cfif>,
							<cfif manudate neq "">#manudate#<cfelse>''</cfif>,'#milcert#','#importpermit#',
							'#tran#','#nexttranno#',
							<cfif expdate neq "">#expdate#<cfelse>''</cfif>
						)
					</cfquery>
				<cfelse>
					<cfquery name="updateobbatch" datasource="#dts#">
						update obbatch set 
						#obtype#=(#obtype#+#act_qty#) 
						where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and batchcode='#enterbatcode#'
					</cfquery>
				</cfif>
				
				<cfquery name="checklobthob" datasource="#dts#">
					select batchcode from lobthob 
					where location = '#locationArray[i]#'
					and batchcode = '#enterbatcode#'
					and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
				</cfquery>
				<cfif checklobthob.recordcount eq 0>
					<cfquery name="insertlobthob" datasource="#dts#">
						insert into lobthob
                        (
                        location,
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
							'#locationArray[i]#','#enterbatcode#',
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
							'#tran#','#nexttranno#','0',
							'<cfif obtype eq "bth_qin">#act_qty#<cfelse>0</cfif>',
							'<cfif obtype eq "bth_qut">#act_qty#<cfelse>0</cfif>',
							'0','0','0',
							<cfif expdate neq "">#expdate#<cfelse>''</cfif>,
                            <cfif manudate neq "">#manudate#<cfelse>''</cfif>,'#milcert#','#importpermit#',
							'#tran#','#nexttranno#',
							<cfif expdate neq "">#expdate#<cfelse>''</cfif>
						)
					</cfquery>
				<cfelse>
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#+#act_qty#) 
						where location = '#locationArray[i]#'
						and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
						and batchcode = '#enterbatcode#'
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<!--- ADD PROJECT & JOB ON 24-11-2009 --->
		<cftry>
        	<cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#sodate#" returnvariable="sodate"/>
            <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#dodate#" returnvariable="dodate"/>
            <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#expdate#" returnvariable="expdate"/>
            <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#manudate#" returnvariable="manudate"/>
            <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="" returnvariable="exported1"/>
			
            <cfif isdefined('form.asvoucher')>
    
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
(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucherno#">,'Value','#val(amt1_bil)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,'#HUserID#',now(),<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#" >)
    </cfquery>
    <cfquery name="getID" datasource="#dts#">
			Select LAST_INSERT_ID() as en;
	</cfquery>
    <cfset form.voucherno = getID.en>
    
	</cfif>
            
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
                    wos_group,category,brem1,brem2,brem3,brem4,<cfif lcase(hcomid) eq "avent_i" or lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">brem5,brem6,<cfif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">brem7,brem8,brem9,</cfif></cfif>
                    <cfif isdefined('form.it_cos') and tran eq "CN">it_cos,</cfif>
                    packing,shelf,source,job,
                    trdatetime,sv_part,sercost,userid,sodate,dodate,
                    adtcost1,adtcost2,batchcode,expdate,manudate,milcert,importpermit,mc1_bil,mc2_bil,defective,nodisplay,title_id,title_desp,<cfif lcase(hcomid) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i">title_despa,</cfif>
                    comment,m_charge1,m_charge2,m_charge3,m_charge4,m_charge5,m_charge6,m_charge7,
                    mc3_bil,mc4_bil,mc5_bil,mc6_bil,mc7_bil<cfif isdefined('form.taxinclude') and wpitemtax eq "Y">,taxincl</cfif><cfif isdefined('form.foc')>,foc</cfif>
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
                    '#form.dispec1#','#form.dispec2#','#form.dispec3#',
                    '#disamt_bil#','#val(amt_bil)#','#form.taxpec1#','#form.gltradac#','#taxamt_bil#',
                    <!--- <cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">'#loc_currrate#','#loc_currrcode#',</cfif> --->
                    '#act_qty#','#xprice#','#getitem.unit#','#form.factor1#','#form.factor2#',
                    '#amt1#','#disamt#','#val(amt)#','#taxamt#','#form.selecttax#','',
                    '#getcust.name#','','#exported1#','','','#getcust.van#','',
                    '#getitem.wos_group#','#getitem.category#','#form.requestdate#','#form.crequestdate#',
                    '#form.brem3#','<cfif ucase(form.brem4) eq "XCOST">XCOST<cfelse>#form.brem4#</cfif>',
                    <cfif lcase(hcomid) eq "avent_i" or lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">'#form.brem5#','#form.brem6#',<cfif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
					'#form.brem7#','#form.brem8#','#form.brem9#',
					</cfif></cfif>
                    <cfif isdefined('form.it_cos') and tran eq "CN"> 
					<cfif form.it_cos eq "" or form.it_cos eq 0>
					<cfset it_cos = val(amt)>
                    <cfelse>
                    <cfset it_cos = form.it_cos>
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#it_cos#">,
                    </cfif>
                    '#form.packing#','#form.shelf#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
					'#nowDatetime#','#form.sv_part#','#val(form.sercost)#',
                    '#huserid#','#sodate#','#dodate#',
                    '#val(adtcost1)*currrate#','#val(adtcost2)*currrate#',
                    '#enterbatcode#','#expdate#','#manudate#','#milcert#','#importpermit#',
                    '#val(mc1bil)#','#val(mc2bil)#','#defective#','#form.nodisplay#','#form.title_id#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(form.title_desp)#">,
                    <cfif lcase(hcomid) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i"><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.title_despa#">,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#tostring(form.comment)#">,
                    '0','0','0','0','0','0','0','0','0','0','0','0'<cfif isdefined('form.taxinclude') and wpitemtax eq "Y">,'#form.taxinclude#'</cfif><cfif isdefined('form.foc')>,"#form.foc#"</cfif>
                )		
            </cfquery>
            <cfif tran eq "INV" or tran eq "DO" or tran eq "QUO" or tran eq "SO" or tran eq "CS">
            <cfquery name="checkpromotion" datasource="#dts#">
            SELECT * FROM promoitem as a right join promotion as b on a.promoid = b.promoid WHERE a.itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#"> and b.periodfrom <="#dateformat(now(),'yyyy-mm-dd')#" and b.periodto >= "#dateformat(now(),'yyyy-mm-dd')#" and (b.customer='#form.custno#' or b.customer='') and b.type = "free" <cfif isdefined("form.promotiontype")>and b.promoid='#form.promotiontype#'</cfif>
            </cfquery>
            <cfif checkpromotion.recordcount neq 0>
            <cfset validfree = 0>
            <cfset itemfreeqty = 0>
            <cfset promoqtyamt = act_qty>
            
			<cfif act_qty neq 0>
            <cfloop query="checkpromotion">
            <cfif val(checkpromotion.priceamt) lte promoqtyamt>
            <cfset leftcontrol = promoqtyamt / val(checkpromotion.priceamt)>
            <cfset validfree = int(leftcontrol) >
            <cfset itemfreeqty =itemfreeqty + ( validfree * val(checkpromotion.rangeFrom))>
            <cfset promoqtyamt = act_qty * (leftcontrol-validfree)/leftcontrol >
            </cfif>
            </cfloop>
			</cfif>
            <cfif itemfreeqty gt 0>
            <cfset qtyfree = itemfreeqty >
            
            <cfif val(form.factor2) neq 0>
            <cfset qtyfree_bil = val(qtyfree) * val(form.factor2) / val(form.factor1)>
			<cfelse>
            <cfset qtyfree_bil = 0>
            </cfif>            
			
            <cfset itemcnt = itemcnt + 1>
             <cfquery name="insertictran" datasource="#dts#" >
                insert into ictran 
                (
                    type,refno,custno,fperiod,wos_date,currrate,trancode,itemcount,linecode,
                    itemno,desp,despa,agenno,location,
                    qty_bil,price_bil,unit_bil,amt1_bil,
                    dispec1,dispec2,dispec3,
                    disamt_bil,amt_bil,
                    taxpec1,gltradac,taxamt_bil,
                    qty,price,unit,factor1,factor2,amt1,disamt,amt,taxamt,note_a,
                    dono,name,exported,exported1,sono,toinv,van,generated,
                    wos_group,category,brem1,brem2,brem3,brem4,
                     <cfif isdefined('form.it_cos') and tran eq "CN">it_cos,</cfif>
                    packing,shelf,source,job,
                    trdatetime,sv_part,sercost,userid,sodate,dodate
                )
                values
                (
                    '#tran#','#nexttranno#','#form.custno#','#numberformat(form.readperiod,"00")#',#getcust.wos_date#,
                    '#currrate#','#itemcnt#','#itemcnt#',<cfif form.service neq "">'SV'<cfelse>''</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.despa#">,
                    '#form.agenno#','#locationArray[i]#','#qtyfree_bil#','0',
                    <cfqueryparam cfsqltype="cf_sql_char" value="#form.unit#">,'0',
                    '0','0','0',
                    '0','0','0','#form.gltradac#','0',
                    '#qtyfree#','0','#getitem.unit#','#form.factor1#','#form.factor2#',
                    '0','0','0','0','','',
                    '#getcust.name#','','','','','#getcust.van#','',
                    '#getitem.wos_group#','#getitem.category#','#form.requestdate#','#form.crequestdate#',
                    '#form.brem3#','<cfif ucase(form.brem4) eq "XCOST">XCOST<cfelse>#form.brem4#</cfif>',
                    <cfif isdefined('form.it_cos') and tran eq "CN"> 
					<cfif form.it_cos eq "" or form.it_cos eq 0>
					<cfset it_cos = val(amt)>
                    <cfelse>
                    <cfset it_cos = form.it_cos>
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#it_cos#">,
                    </cfif>
                    '#form.packing#','#form.shelf#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
					'#nowDatetime#','#form.sv_part#','#val(form.sercost)#',
                    '#huserid#','#sodate#','#dodate#'
                )		
            </cfquery>
			</cfif>
            </cfif>
            </cfif>
            <cfif lcase(hcomid) eq "accord_i" and tran eq "INV" and getcust.rem5 neq "" and isdate(form.brem4)>
            <cfquery name="updateexpdate" datasource="#dts#">
            Update vehicles SET inexpdate = "#dateformat(form.brem4,'YYYY-MM-DD')#" where carno = "#getcust.rem5#" and custcode = "#form.custno#"
            </cfquery>
            
			</cfif>
        <cfcatch type="any">
        	<cfoutput>#cfcatch.Message#<br />#cfcatch.Detail#</cfoutput><cfabort>
        </cfcatch>
        </cftry>
        <cfset itemcnt = itemcnt + 1>
		
		<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
			<cfif lcase(HUserID) neq "kellysteel2">
				<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">
					<cfset qname='QIN'&(readperiod+10)>
				<cfelse>
					<cfset qname='QOUT'&(readperiod+10)>
				</cfif>
			
				<cfquery name="UpdateIcitem" datasource="#dts#">
					update icitem set 
					#qname#=(#qname#+#act_qty#) 
					where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
</cfloop>

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
    	update artran set tax_bil='#val(gettax.tt_taxamt_bil)#'
        <!--- <cfif isdefined('form.taxinclude')>
		<cfif form.taxinclude eq "T">
        ,taxincl = "T"
		</cfif>
        </cfif> --->
         where type='#tran#' and refno='#nexttranno#'
    </cfquery>
</cfif>

<cfset status = "Item Added Successfully">