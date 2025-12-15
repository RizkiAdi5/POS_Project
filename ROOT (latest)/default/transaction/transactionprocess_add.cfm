<!--- <cfif expdate neq "">
	<cfset expdate = mid(expdate,7,4)&"-"&mid(expdate,4,2)&"-"&mid(expdate,1,2)>
<cfelse>
	<cfset expdate = expdate>
</cfif> --->

<!--- <cfif sodate neq "">
	<cfset sodate = mid(sodate,7,4)&"-"&mid(sodate,4,2)&"-"&mid(sodate,1,2)>
<cfelse>
	<cfset sodate = sodate>
</cfif> --->

<!--- <cfif dodate neq "">
	<cfset dodate = mid(dodate,7,4)&"-"&mid(dodate,4,2)&"-"&mid(dodate,1,2)>
<cfelse>
	<cfset dodate = dodate>
</cfif> --->
<cfquery name="getgsetup" datasource="#dts#">
select autobom from gsetup
</cfquery>

<cfif trim(expdate) neq "">
	<cfset expdate = createDate(ListGetAt(expdate,3,"-"),ListGetAt(expdate,2,"-"),ListGetAt(expdate,1,"-"))>
<cfelse>
	<cfset expdate = "">
</cfif>

<cfif trim(manudate) neq "">
	<cfset manudate = createDate(ListGetAt(manudate,3,"-"),ListGetAt(manudate,2,"-"),ListGetAt(manudate,1,"-"))>
<cfelse>
	<cfset manudate = "">
</cfif>

<cfif trim(sodate) neq "">
	<cfset sodate = createDate(ListGetAt(sodate,3,"-"),ListGetAt(sodate,2,"-"),ListGetAt(sodate,1,"-"))>
<cfelse>
	<cfset sodate = "">
</cfif>

<cfif trim(dodate) neq "">
	<cfset dodate = createDate(ListGetAt(dodate,3,"-"),ListGetAt(dodate,2,"-"),ListGetAt(dodate,1,"-"))>
<cfelse>
	<cfset dodate = "">
</cfif>

<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>

<cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#sodate#" returnvariable="sodate"/>
<cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#dodate#" returnvariable="dodate"/>
<cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#expdate#" returnvariable="expdate"/>
<cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#manudate#" returnvariable="manudate"/>
<cfinvoke component="cfc.date" method="getFormatedDate" inputDate="" returnvariable="exported1"/>

<cfquery name="checkitemExist" datasource="#dts#">
	select 
	itemcount 
	from ictran 
	where type='#tran#'
	and refno='#nexttranno#' 
	and custno='#form.custno#' 
	order by itemcount;
</cfquery>

<cfif checkitemExist.recordcount GT 0>
	<cfinvoke method="reorder" refno="#nexttranno#" itemcountlist="#valuelist(checkitemExist.itemcount)#"/>
	<cfinvoke method="relocate" refno="#nexttranno#" end="#checkitemExist.itemcount[checkitemExist.recordcount]#" newtc="#newtrancode#"/>
	
	<cfset itemcnt = newtrancode>
	<cfset trcode = itemcnt>
<cfelse>
	<cfset itemcnt = 1>
	<cfset trcode = itemcnt>
</cfif> 

<cfif getgsetup.autobom eq 'Y'>
<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
		<cfquery name="checkexistbom" datasource="#dts#">
		select bomno from billmat where itemno='#form.itemno#'
        </cfquery>
		
        <cfif checkexistbom.recordcount neq 0>
	<cfoutput>
        
			<cfinvoke component="transactionautobom" method="generatebom" returnvariable="">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="qty" value="#form.qty#">
			<cfinvokeargument name="itemno" value="#form.itemno#">
            <cfinvokeargument name="bomno" value="#checkexistbom.bomno#">
            <cfinvokeargument name="location" value="#form.location#">
            <cfinvokeargument name="huserid" value="#huserid#">
		</cfinvoke>
        </cfoutput>
        </cfif>
        </cfif>
</cfif>

<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
	<cfif trim(enterbatch) neq "">
		<cfif tran eq "RC" or tran eq "OAI" or tran eq "CN">
			<cfset obtype = "bth_qin">
			<cfif checkcustom.customcompany eq "Y">
				<cfquery name="updateLotNo" datasource="#dts#">
					update gsetup
					set lotno = '#enterbatch#'
				</cfquery>
				<cfquery name="insert" datasource="#dts#">
					insert into lotnumber
					(LotNumber,itemno)
					value
					(<cfqueryparam cfsqltype="cf_sql_char" value="#enterbatch#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#">)
				</cfquery>
			</cfif>
		<cfelse>
			<cfset obtype = "bth_qut">
		</cfif>
		
		<cfquery name="checkbatch" datasource="#dts#">
			select 
			batchcode 
			from obbatch 
			where batchcode='#enterbatch#' 
			and itemno='#itemno#';
		</cfquery>
		
		<cfif checkbatch.recordcount eq 0>
			<!--- <cfquery name="insertbatch" datasource="#dts#">
				insert into obbatch values 
				(
					'#form.enterbatch#',
					'#form.itemno#',
					'#form.tran#',
					'#form.nexttranno#',
					'0',
					'<cfif obtype eq "bth_qin">#form.qty#<cfelse>0</cfif>',
					'<cfif obtype eq "bth_qut">#form.qty#<cfelse>0</cfif>',
					'0',
					'0',
					'0',
					'#dateformat(expdate,"yyyy-mm-dd")#',
					'#form.tran#',
					'#form.nexttranno#',
					'#dateformat(expdate,"yyyy-mm-dd")#'
				);
			</cfquery> --->
            <cfif isdefined('manudate')>
            <cfif manudate eq "">
            <cfset manudate = "0000-00-00">
			</cfif>
			</cfif>
            
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
                    <cfif checkcustom.customcompany eq "Y">
                    ,permit_no,permit_no2
                	</cfif>
                ) 
                values  
				(
					'#form.enterbatch#',
					'#form.itemno#',
					'#form.tran#',
					'#form.nexttranno#',
					'0',
					'<cfif obtype eq "bth_qin">#act_qty#<cfelse>0</cfif>',
					'<cfif obtype eq "bth_qut">#act_qty#<cfelse>0</cfif>',
					'0',
					'0',
					'0',
					'#expdate#',
                    '#manudate#',
                    '#form.milcert#',
                    '#form.importpermit#',
					'#form.tran#',
					'#form.nexttranno#',
					'#expdate#'                 
					<cfif checkcustom.customcompany eq "Y">
						,'#form.hremark5#','#form.hremark6#'
					</cfif>
				);
			</cfquery>
		<cfelse>
			<!--- <cfquery name="updateobbatch" datasource="#dts#">
				update obbatch set 
				#obtype#=(#obtype#+#form.qty#) 
				where itemno='#itemno#' 
				and batchcode='#enterbatch#';
			</cfquery> --->
			<cfquery name="updateobbatch" datasource="#dts#">
				update obbatch set 
				#obtype#=(#obtype#+#act_qty#) 
				where itemno='#itemno#' 
				and batchcode='#enterbatch#';
			</cfquery>
		</cfif>
		
		<cfif location neq "">
			<cfquery name="checklobthob" datasource="#dts#">
				select 
				batchcode 
				from lobthob 
				where location='#location#' 
				and batchcode='#enterbatch#' 
				and itemno='#itemno#';
			</cfquery>
			
			<cfif checklobthob.recordcount eq 0>
				<!--- <cfquery name="insertlobthob" datasource="#dts#">
					insert into lobthob values 
					(
						'#form.location#',
						'#form.enterbatch#',
						'#form.itemno#',
						'#form.tran#',
						'#form.nexttranno#',
						'0',
						'<cfif obtype eq "bth_qin">#form.qty#<cfelse>0</cfif>',
						'<cfif obtype eq "bth_qut">#form.qty#<cfelse>0</cfif>',
						'0',
						'0',
						'0',
						'#dateformat(expdate,"yyyy-mm-dd")#',
						'#form.tran#',
						'#form.nexttranno#',
						'#dateformat(expdate,"yyyy-mm-dd")#'
					);
				</cfquery> --->
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
                    <cfif checkcustom.customcompany eq "Y">
                    ,permit_no,permit_no2
                	</cfif>
                ) 
                     values 
					(
						'#form.location#',
						'#form.enterbatch#',
						'#form.itemno#',
						'#form.tran#',
						'#form.nexttranno#',
						'0',
						'<cfif obtype eq "bth_qin">#act_qty#<cfelse>0</cfif>',
						'<cfif obtype eq "bth_qut">#act_qty#<cfelse>0</cfif>',
						'0',
						'0',
						'0',
						'#expdate#',
                        '#manudate#',
                        '#form.milcert#',
                        '#form.importpermit#',
						'#form.tran#',
						'#form.nexttranno#',
						'#expdate#'
                        
						<cfif checkcustom.customcompany eq "Y">
							,'#form.hremark5#','#form.hremark6#'
						</cfif>
					);
				</cfquery>
			<cfelse>
				<!--- <cfquery name="updatelobthob" datasource="#dts#">
					update lobthob set 
					#obtype#=(#obtype#+#form.qty#) 
					where location='#location#' 
					and itemno='#itemno#' 
					and batchcode='#enterbatch#';
				</cfquery> --->
				<cfquery name="updatelobthob" datasource="#dts#">
					update lobthob set 
					#obtype#=(#obtype#+#act_qty#) 
					where location='#location#' 
					and itemno='#itemno#' 
					and batchcode='#enterbatch#';
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
	
	<cfif lcase(HUserID) neq "kellysteel2">
		<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">
			<cfset qname='QIN'&(val(readperiod)+10)>
		<cfelse>
			<cfset qname='QOUT'&(val(readperiod)+10)>
		</cfif>
		
		<!--- <cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set 
			#qname#=(#qname#+#form.qty#) 
			where itemno='#itemno#';
		</cfquery> --->
		
		<cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set 
			#qname#=(#qname#+#act_qty#) 
			where itemno='#itemno#';
		</cfquery>
	</cfif>
</cfif>

<!--- <cfquery name="checkitemExist" datasource="#dts#">
	select 
	itemcount 
	from ictran 
	where type='#tran#'
	and refno='#nexttranno#' 
	and custno='#form.custno#' 
	order by itemcount;
</cfquery>

<cfif checkitemExist.recordcount GT 0>
	<cfinvoke method="reorder" refno="#nexttranno#" itemcountlist="#valuelist(checkitemExist.itemcount)#"/>
	<cfinvoke method="relocate" refno="#nexttranno#" end="#checkitemExist.itemcount[checkitemExist.recordcount]#" newtc="#newtrancode#"/>
	
	<cfset itemcnt = newtrancode>
	<cfset trcode = itemcnt>
<cfelse>
	<cfset itemcnt = 1>
	<cfset trcode = itemcnt>
</cfif>  --->	

<cfquery name="getcust" datasource="#dts#">
	select 
	name,
	van,source,job,
	wos_date,rem5
	from artran 
	where type='#tran#'
	and refno='#nexttranno#'; 
</cfquery>

<!--- Add on 020908 for Graded Item --->
<cfif form.grdcolumnlist neq "" and form.service eq "">
	<cfset grdcolumnlist = form.grdcolumnlist>
	<cfset bgrdcolumnlist = form.bgrdcolumnlist>
	<cfset grdvaluelist = form.grdvaluelist>
	<cfset myArray = ListToArray(grdcolumnlist,",")>
	<cfset myArray2 = ListToArray(grdvaluelist,",")>
	<cfset myArray3 = ListToArray(bgrdcolumnlist,",")>
	
	<!--- <cfquery name="insertigrade" datasource="#dts#">
		insert into igrade
		(type,refno,trancode,itemno,wos_date,fperiod,sign,del_by,location,void,generated,custno,exported,
		<cfloop from="1" to="#form.totalrecord#" index="i">
			<cfif i neq form.totalrecord>
				#myArray[i]#,
			<cfelse>
				#myArray[i]#
			</cfif>
		</cfloop>
		)
		values
		('#tran#','#nexttranno#','#itemcnt#','#form.itemno#',#getcust.wos_date#,'#numberformat(form.readperiod,"00")#',
		<cfif tran eq "RC" or tran eq "PO" or tran eq "CN" or tran eq "OAI">'1'<cfelse>'-1'</cfif>,'','#location#','','','#form.custno#','',
		<cfloop from="1" to="#form.totalrecord#" index="i">
			<cfif i neq form.totalrecord>
				#myArray2[i]#,
			<cfelse>
				#myArray2[i]#
			</cfif>
		</cfloop>)
	</cfquery> --->
	<cfquery name="insertigrade" datasource="#dts#">
		insert into igrade
		(type,refno,trancode,itemno,wos_date,fperiod,sign,del_by,location,void,generated,custno,exported,factor1,factor2,
		<cfloop from="1" to="#form.totalrecord#" index="i">
			<cfif i neq form.totalrecord>
				#myArray[i]#,
			<cfelse>
				#myArray[i]#
			</cfif>
		</cfloop>
		)
		values
		('#tran#','#nexttranno#','#itemcnt#','#form.itemno#',#getcust.wos_date#,'#numberformat(form.readperiod,"00")#',
		<cfif tran eq "RC" or tran eq "PO" or tran eq "CN" or tran eq "OAI">'1'<cfelse>'-1'</cfif>,'','#location#','','',
		'#form.custno#','','#form.factor1#','#form.factor2#',
		<cfloop from="1" to="#form.totalrecord#" index="i">
			<cfif i neq form.totalrecord>
				#myArray2[i]#,
			<cfelse>
				#myArray2[i]#
			</cfif>
		</cfloop>)
	</cfquery>
	
	<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
		<cfquery name="checkexist2" datasource="#dts#">
			select * from itemgrd
			where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
		</cfquery>
	
		<cfif checkexist2.recordcount eq 0>
			<cfquery name="insert" datasource="#dts#">
				insert into itemgrd 
				(itemno)
				values
				(<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">)
			</cfquery>
		</cfif>
	
		<!--- <cfquery name="updateitemgrd" datasource="#dts#">
			update itemgrd
			set
			<cfloop from="1" to="#form.totalrecord#" index="i">
				<cfif i neq form.totalrecord>
					#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>#myArray2[i]# ,
				<cfelse>
					#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>#myArray2[i]#
				</cfif>
			</cfloop>
			where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
		</cfquery> --->
		
		<cfquery name="updateitemgrd" datasource="#dts#">
			update itemgrd
			set
			<cfloop from="1" to="#form.totalrecord#" index="i">
				<cfif i neq form.totalrecord>
					#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>
					<cfif val(form.factor2) neq 0>
						(#myArray2[i]# * #form.factor1# / #form.factor2#)
					<cfelse>
						0
					</cfif> ,
				<cfelse>
					#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>
					<cfif val(form.factor2) neq 0>
						(#myArray2[i]# * #form.factor1# / #form.factor2#)
					<cfelse>
						0
					</cfif>
				</cfif>
			</cfloop>
			where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
		</cfquery>
		
		<cfquery name="checkexist1" datasource="#dts#">
			select * from logrdob
			where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
			and location = <cfqueryparam cfsqltype="cf_sql_char" value="#form.location#">
		</cfquery>
		
		<cfif checkexist1.recordcount eq 0>
			<cfquery name="insert" datasource="#dts#">
				insert into logrdob 
				(itemno,location)
				values
				(<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.location#">)
			</cfquery>
		</cfif>
		
		<!--- <cfquery name="updatelogrdob" datasource="#dts#">
			update logrdob
			set
			<cfloop from="1" to="#form.totalrecord#" index="i">
				<cfif i neq form.totalrecord>
					#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>#myArray2[i]# ,
				<cfelse>
					#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>#myArray2[i]#
				</cfif>
			</cfloop>
			where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
			and location = <cfqueryparam cfsqltype="cf_sql_char" value="#form.location#">
		</cfquery> --->
		<cfquery name="updatelogrdob" datasource="#dts#">
			update logrdob
			set
			<cfloop from="1" to="#form.totalrecord#" index="i">
				<cfif i neq form.totalrecord>
					#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>
					<cfif val(form.factor2) neq 0>
						(#myArray2[i]# * #form.factor1# / #form.factor2#)
					<cfelse>
						0
					</cfif> ,
				<cfelse>
					#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>
					<cfif val(form.factor2) neq 0>
						(#myArray2[i]# * #form.factor1# / #form.factor2#)
					<cfelse>
						0
					</cfif>
				</cfif>
			</cfloop>
			where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
			and location = <cfqueryparam cfsqltype="cf_sql_char" value="#form.location#">
		</cfquery>

	</cfif>
</cfif>

<cfset status = "Item Added Successfully">
<cfset nowdatetime = dateformat(getcust.wos_date,"yyyy-mm-dd") & " " & timeformat(now(),"HH:mm:ss")>	

<!--- REMARK ON 290908 --->
<!--- <cfquery name="insertictran" datasource="#dts#" >
	insert into ictran 
	(
		type,
		refno,
		custno,
		fperiod,
		wos_date,
		currrate,
		trancode,
		itemcount,
		linecode,
		itemno,
		desp,
		despa,
		agenno,
		location,
		qty_bil,
		price_bil,
		unit_bil,
		amt1_bil,
		dispec1,
		dispec2,
		dispec3,
		disamt_bil,
		amt_bil,
		taxpec1,
		gltradac,
		taxamt_bil,
		qty,
		price,
		unit,
		amt1,
		disamt,
		amt,
		taxamt,
		dono,
		name,
		exported,
		exported1,
		sono,
		toinv,
		van,
		generated,
		wos_group,
		category,
		brem1,
		brem2,
		brem3,
		brem4,
		packing,
		shelf,
		trdatetime,
		sv_part,
		sercost,
		userid,
		sodate,
		dodate,
		adtcost1,
		adtcost2,
		batchcode,
		expdate,
		mc1_bil,
		mc2_bil,
		defective,
		comment,
		m_charge1,
		m_charge2,
		m_charge3,
		m_charge4,
		m_charge5,
		m_charge6,
		m_charge7,
		mc3_bil,
		mc4_bil,
		mc5_bil,
		mc6_bil,
		mc7_bil
	)
	values
	(
		'#tran#',
		'#nexttranno#',
		'#form.custno#',
		'#numberformat(form.readperiod,"00")#',
		#getcust.wos_date#,
		'#currrate#',
		'#itemcnt#',
		'#trcode#',
		<cfif form.service neq "">'SV'<cfelse>''</cfif>,
		'#form.itemno#',
		'#jsstringformat(preservesinglequotes(form.desp))#',
		'#jsstringformat(preservesinglequotes(form.despa))#',
		'#form.agenno#',
		'#form.location#',
		'#form.qty#',
		'#form.price#',
		'#jsstringformat(preservesinglequotes(form.unit))#',
		'#amt1_bil#',
		'#form.dispec1#',
		'#form.dispec2#',
		'#form.dispec3#',
		'#disamt_bil#',
		'#val(amt_bil)#',
		'#form.taxpec1#',
		'#form.gltradac#',
		'#taxamt_bil#',
		'#form.qty#',
		'#xprice#',
		'#form.unit#',
		'#amt1#',
		'#disamt#',
		'#val(amt)#',
		'#taxamt#',
		'',
		'#getcust.name#',
		'',
		'',
		'',
		'',
		'#getcust.van#',
		'',
		'#getitem.wos_group#',
		'#getitem.category#',
		'#form.requestdate#',
		'#form.crequestdate#',
		'#form.brem3#',
		'<cfif ucase(form.brem4) eq "XCOST">XCOST<cfelse>#form.brem4#</cfif>',
		'#form.packing#',
		'#form.shelf#',
		'#nowDatetime#',
		'#form.sv_part#',
		'#form.sercost#',
		'#huserid#',
		'#dateformat(sodate,"yyyy-mm-dd")#',
		'#dateformat(dodate,"yyyy-mm-dd")#',
		'#val(form.adtcost1)*currrate#',
		'#val(form.adtcost2)*currrate#',
		'#form.enterbatch#',
		'#dateformat(expdate,"yyyy-mm-dd")#',
		'#form.mc1bil#',
		'#form.mc2bil#',
		'#form.defective#',
		
		<cfset CommentLen = len(tostring(form.comment))>
		<cfset xComment = tostring(form.comment)>
		<cfset SingleQ = "">
		<cfset DoubleQ = "">
		
		<cfloop index = "Count" from = "1" to = "#CommentLen#">
			<cfif mid(xComment,Count,1) eq "'">
				<cfset SingleQ = 'Y'>
			<cfelseif mid(xComment,Count,1) eq '"'>
				<cfset DoubleQ = 'Y'>
			</cfif>
		</cfloop>
		
		<cfif SingleQ eq "Y" and DoubleQ eq "">
			<!--- Found ' in the comment --->
			"#tostring(form.comment)#",'0','0','0','0','0','0','0','0','0','0','0','0')
		<cfelseif SingleQ eq "" and DoubleQ eq "Y">
			<!--- Found " in the comment --->
			'#tostring(form.comment)#','0','0','0','0','0','0','0','0','0','0','0','0')
		<cfelseif SingleQ eq "" and DoubleQ eq "">
			'#tostring(form.comment)#','0','0','0','0','0','0','0','0','0','0','0','0')
		<cfelse>
			<h3>Error. You cannot key in both ' and " in the comment.</h3>
		<cfabort>
	</cfif>
</cfquery> --->

<!--- ADD PROJECT & JOB ON 24-11-2009 --->

<cftry> 
<cfif tran eq "INV" or tran eq "DO" or tran eq "QUO" or tran eq "SO" or tran eq "CS">
    <cfquery name="checkpromotion" datasource="#dts#">
            SELECT * FROM promoitem as a right join promotion as b on a.promoid = b.promoid WHERE a.itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#"> and b.periodfrom <="#dateformat(now(),'yyyy-mm-dd')#" and b.periodto >= "#dateformat(now(),'yyyy-mm-dd')#" and (b.customer='#form.custno#' or b.customer='') and b.type = "free" <cfif isdefined("form.promotiontype")>and b.promoid='#form.promotiontype#'</cfif> order by priceamt desc
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
                    packing,shelf,source,job,
                    trdatetime,sv_part,sercost,userid,sodate,dodate<cfif isdefined('form.it_cos') and tran eq "CN">,it_cos</cfif>
                )
                values
                (
                    '#tran#','#nexttranno#','#form.custno#','#numberformat(form.readperiod,"00")#',#getcust.wos_date#,
                    '#currrate#','#itemcnt#','#trcode#',<cfif form.service neq "">'SV'<cfelse>''</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.despa#">,
                    '#form.agenno#','#form.location#','#qtyfree_bil#','0',
                    <cfqueryparam cfsqltype="cf_sql_char" value="#form.unit#">,'0',
                    '0','0','0',
                    '0','0','0','#form.gltradac#','0',
                    '#qtyfree#','0','#getitem.unit#','#form.factor1#','#form.factor2#',
                    '0','0','0','0','','',
                    '#getcust.name#','','0000-00-00','','','#getcust.van#','',
                    '#getitem.wos_group#','#getitem.category#','#form.requestdate#','#form.crequestdate#',
                    '#form.brem3#','<cfif ucase(form.brem4) eq "XCOST">XCOST<cfelse>#form.brem4#</cfif>',
                    '#form.packing#','#form.shelf#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
					'#nowDatetime#','#form.sv_part#','#val(form.sercost)#',
                    '#huserid#','#sodate#','#dodate#'
					<cfif isdefined('form.it_cos') and tran eq "CN"> 
					<cfif form.it_cos eq "" or form.it_cos eq 0>
					<cfset it_cos = val(amt)>
                    <cfelse>
                    <cfset it_cos = form.it_cos>
                    </cfif>
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#it_cos#" >
					</cfif>
                )		
            </cfquery>
            
                 <cfquery name="checkitemExist" datasource="#dts#">
                select 
                itemcount 
                from ictran 
                where type='#tran#'
                and refno='#nexttranno#' 
                and custno='#form.custno#' 
                order by itemcount;
            </cfquery>
            
            <cfif checkitemExist.recordcount GT 0>
                <cfinvoke method="reorder" refno="#nexttranno#" itemcountlist="#valuelist(checkitemExist.itemcount)#"/>
                <cfinvoke method="relocate" refno="#nexttranno#" end="#checkitemExist.itemcount[checkitemExist.recordcount]#" newtc="#newtrancode#"/>
                
                <cfset itemcnt = newtrancode>
                <cfset trcode = itemcnt>
            <cfelse>
                <cfset itemcnt = 1>
                <cfset trcode = itemcnt>
            </cfif> 
			</cfif>
            </cfif>
            </cfif>
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
    <cfquery name="getitemphoto" datasource="#dts#" >
    select photo from icitem where itemno='#form.itemno#'
    </cfquery>
    
    
    
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
            wos_group,category,brem1,brem2,brem3,brem4,
            <cfif lcase(hcomid) eq "avent_i" or lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
                brem5,brem6,
				<cfif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
                brem7,brem8,brem9,
				</cfif>
            <cfelseif checkcustom.customcompany eq "Y">
                brem5,brem7,brem8,brem9,brem10,
            </cfif>
			<cfif isdefined('form.it_cos') and tran eq "CN">it_cos,</cfif>
            packing,shelf,supp,qty1,qty2,qty3,qty4,qty5,qty6,qty7,source,job,
            trdatetime,sv_part,sercost,userid,sodate,dodate,
            adtcost1,adtcost2,batchcode,expdate,manudate,milcert,importpermit,mc1_bil,mc2_bil,defective,nodisplay,title_id,title_desp,<cfif lcase(hcomid) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i">title_despa,</cfif>
            comment,m_charge1,m_charge2,m_charge3,m_charge4,m_charge5,m_charge6,m_charge7,
            mc3_bil,mc4_bil,mc5_bil,mc6_bil,mc7_bil<cfif isdefined('form.taxinclude') and wpitemtax eq "Y">,taxincl</cfif><cfif isdefined('form.foc')>,foc</cfif><cfif isdefined('form.asvoucher')>,asvoucher,voucherno</cfif>,photo<cfif isdefined('form.ictranfilename')>,ictranfilename</cfif>
        )
        values
        (
            '#tran#','#nexttranno#','#form.custno#','#numberformat(form.readperiod,"00")#',#getcust.wos_date#,
            '#currrate#','#itemcnt#','#trcode#',<cfif form.service neq "">'SV'<cfelse>''</cfif>,
            '#form.itemno#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.despa#">,
            '#form.agenno#','#form.location#',
            '#form.qty#','#form.price#','#jsstringformat(preservesinglequotes(form.unit))#','#amt1_bil#',
            '#form.dispec1#','#form.dispec2#','#form.dispec3#',
            '#disamt_bil#','#val(amt_bil)#','#form.taxpec1#','#form.gltradac#','#taxamt_bil#',
            <!--- <cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">'#loc_currrate#','#loc_currrcode#',</cfif> --->
            '#act_qty#','#xprice#','#getitem.unit#','#form.factor1#','#form.factor2#',
            '#amt1#','#disamt#','#val(amt)#','#taxamt#','#form.selecttax#','',
            '#getcust.name#','','#exported1#','','','#getcust.van#','',
            '#getitem.wos_group#','#getitem.category#','#form.requestdate#','#form.crequestdate#',
            '#form.brem3#','<cfif ucase(form.brem4) eq "XCOST">XCOST<cfelse>#form.brem4#</cfif>',
            <cfif lcase(hcomid) eq "avent_i" or lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
                '#form.brem5#','#form.brem6#',
            <cfif lcase(hcomid) eq "mcjim_i" or lcase(hcomid) eq "redhorn_i">
            	'#form.brem7#','#form.brem8#','#form.brem9#',
			</cfif>
            <cfelseif checkcustom.customcompany eq "Y">
                '#form.hremark5#','#form.hremark6#','#form.bremark8#','#form.bremark9#','#form.bremark10#',
            </cfif>
			<cfif isdefined('form.it_cos') and tran eq "CN"> 
					<cfif form.it_cos eq "" or form.it_cos eq 0>
					<cfset it_cos = val(amt)>
                    <cfelse>
                    <cfset it_cos = form.it_cos>
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#it_cos#" >,
					</cfif>
'#form.packing#','#form.shelf#','#form.supp#','#val(form.qty1)#','#val(form.qty2)#','#val(form.qty3)#','#val(form.qty4)#',
            '#val(form.qty5)#','#val(form.qty6)#','#val(form.qty7)#',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
            '#nowDatetime#','#form.sv_part#','#val(form.sercost)#',
            '#huserid#','#sodate#','#dodate#',
            '#val(form.adtcost1)*currrate#','#val(form.adtcost2)*currrate#',
            '#form.enterbatch#','#expdate#','#manudate#','#form.milcert#','#form.importpermit#',
            '#val(form.mc1bil)#','#val(form.mc2bil)#','#form.defective#','#form.nodisplay#','#form.title_id#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(form.title_desp)#">,
            <cfif lcase(hcomid) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i"><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.title_despa#">,</cfif>
            
            <cfset CommentLen = len(tostring(form.comment))>
            <cfset xComment = tostring(form.comment)>
            <cfset SingleQ = "">
            <cfset DoubleQ = "">
            
            <cfloop index = "Count" from = "1" to = "#CommentLen#">
                <cfif mid(xComment,Count,1) eq "'">
                    <cfset SingleQ = 'Y'>
                <cfelseif mid(xComment,Count,1) eq '"'>
                    <cfset DoubleQ = 'Y'>
                </cfif>
            </cfloop>
            
            <cfif SingleQ eq "Y" and DoubleQ eq "">
                <!--- Found ' in the comment --->
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#tostring(form.comment)#">,'0','0','0','0','0','0','0','0','0','0','0','0'<cfif isdefined('form.taxinclude') and wpitemtax eq "Y">,'#form.taxinclude#'</cfif><cfif isdefined('form.foc')>,"#form.foc#"</cfif><cfif isdefined('form.asvoucher')>,"Y",<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucherno#"></cfif>,<cfif getitemphoto.recordcount eq 0>''<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#getitemphoto.photo#"></cfif><cfif isdefined('form.ictranfilename')>
            ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ictranfilename#">
			</cfif>)
            <cfelseif SingleQ eq "" and DoubleQ eq "Y">
                <!--- Found " in the comment --->
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#tostring(form.comment)#">,'0','0','0','0','0','0','0','0','0','0','0','0'<cfif isdefined('form.taxinclude') and wpitemtax eq "Y">,'#form.taxinclude#'</cfif><cfif isdefined('form.foc')>,"#form.foc#"</cfif><cfif isdefined('form.asvoucher')>,"Y",<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucherno#"></cfif>,<cfif getitemphoto.recordcount eq 0>''<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#getitemphoto.photo#"></cfif><cfif isdefined('form.ictranfilename')>
            ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ictranfilename#">
			</cfif>)
            <cfelseif SingleQ eq "" and DoubleQ eq "">
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#tostring(form.comment)#">,'0','0','0','0','0','0','0','0','0','0','0','0'<cfif isdefined('form.taxinclude') and wpitemtax eq "Y">,'#form.taxinclude#'</cfif><cfif isdefined('form.foc')>,"#form.foc#"</cfif><cfif isdefined('form.asvoucher')>,"Y",<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucherno#"></cfif>,<cfif getitemphoto.recordcount eq 0>''<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#getitemphoto.photo#"></cfif><cfif isdefined('form.ictranfilename')>
            ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ictranfilename#">
			</cfif>)
            <cfelse>
                <h3>Error. You cannot key in both ' and " in the comment.</h3>
            <cfabort>
            
        </cfif>
    </cfquery>
    
    
    <cfif (lcase(hcomid) eq "amalax_i" or lcase(hcomid) eq "gamemartz_i") and tran eq "RC">
        <cfif val(form.requestdate) neq 0>
        <cfquery name="updateamalax" datasource="#dts#">
        update icitem set price='#val(form.requestdate)#' where itemno='#form.itemno#'
        </cfquery> 
        </cfif>
        

        <!--- average price--->
        
        <cfquery name="checkupdate" datasource="#dts#">
        SELECT UPDATE_UNIT_COST FROM gsetup2
        </cfquery>
		<cfquery name = "getictran" datasource = "#dts#">
		select 
		custno,
		itemno,
		price,
		dispec1,
		dispec2,
		dispec3,
        UPDCOST,
        type,
        refno
		from ictran 
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#tran#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#nexttranno#">
		and fperiod <> '99' 
        and (UPDCOST = "" or UPDCOST is null)
		order by itemcount;
        
	</cfquery>
	
	<cfif getictran.recordcount gt 0 and getictran.UPDCOST neq "Y">
    
		<cfloop query = "getictran">
			
            <cfif lcase(hcomid) eq "gamemartz_i">

            <!---gamemartz--->
            <cfquery name="getgeneral" datasource="#dts#">
                select compro,lastaccyear,agentlistuserid,fifocal from gsetup
            </cfquery>
            <cfquery name="getqtybf" datasource="#dts#">
			select avcost2,qtybf FROM icitem
			where itemno='#getictran.itemno#'
			limit 1
            </cfquery>

            <cfset movingunitcost=val(getqtybf.avcost2)>
            <cfset movingbal=val(getqtybf.qtybf)>
            
            <cfquery name="getmovingictran" datasource="#dts#">
			select 
		    a.amt,a.qty,a.toinv,
            a.type,a.refno,a.itemno,a.trancode
			from ictran a,artran b

			where a.itemno='#getictran.itemno#' 
            and a.refno=b.refno and a.type=b.type
			and (a.void = '' or a.void is null)
			and (a.linecode = '' or a.linecode is null)
			and a.type not in ('QUO','SO','PO','SAM')
			and a.fperiod<>'99'
			order by a.wos_date,b.created_on,a.trdatetime

			</cfquery>
        
        <cfloop query="getmovingictran">
        <cfif isdefined('form.dodate')>
  		<cfif type eq "INV">
  		<cfquery name="checkexist2" datasource="#dts#">
  		select toinv,refno,type,itemno from ictran a  where refno ='#getmovingictran.refno#' and itemno =			
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#getmovingictran.itemno#"> and type = "#getmovingictran.type#" and 
        trancode = "#getmovingictran.trancode#" and (dono = "" or dono is null or dono not in (select 
        frrefno from iclink as b where frtype='DO' and type='INV' and b.itemno = a.itemno group by frrefno))
  		</cfquery>
  		</cfif>
  		</cfif>
        <!---exclude CN --->
        
        	<cfif getmovingictran.type eq "CN">
            <cfif (val(movingbal)+val(getmovingictran.qty)) gt 0>
            <cfif movingbal lt 0>
            <cfset movingunitcost=((0*val(movingunitcost))+val(getmovingictran.amt))/(0+val(getmovingictran.qty))>
            <cfelse>
            <cfset movingunitcost=((val(movingbal)*val(movingunitcost))+val(getmovingictran.amt))/(val(movingbal)+val(getmovingictran.qty))>
            </cfif>
            <cfelse>
            <cfset movingunitcost=0>
            </cfif>
            
            <cfset movingbal=val(movingbal)+val(getmovingictran.qty)>
            </cfif>

        
        
        	<cfif getmovingictran.type eq "OAI">
            <cfif (val(movingbal)+val(getmovingictran.qty)) gt 0>
            <cfif movingbal lt 0>
            <cfset movingunitcost=((0*val(movingunitcost))+val(getmovingictran.amt))/(0+val(getmovingictran.qty))>
            <cfelse>
            <cfset movingunitcost=((val(movingbal)*val(movingunitcost))+val(getmovingictran.amt))/(val(movingbal)+val(getmovingictran.qty))>
            </cfif>
            <cfelse>
            <cfset movingunitcost=0>
            </cfif>
            
            <cfset movingbal=val(movingbal)+val(getmovingictran.qty)>
            </cfif>
        
			<cfif getmovingictran.type eq "RC" or getmovingictran.type eq "TRIN">
            <cfif (val(movingbal)+val(getmovingictran.qty)) gt 0>
            <cfif movingbal lt 0>
            <cfset movingunitcost=((0*val(movingunitcost))+val(getmovingictran.amt))/(0+val(getmovingictran.qty))>
            <cfelse>
            <cfset movingunitcost=((val(movingbal)*val(movingunitcost))+val(getmovingictran.amt))/(val(movingbal)+val(getmovingictran.qty))>
            </cfif>
            <cfelse>
            <cfset movingunitcost=0>
            </cfif>
            
            <cfset movingbal=val(movingbal)+val(getmovingictran.qty)>
            </cfif>
        
        
        <cfif (type eq "INV" or type eq "DO" or type eq "DN" or type eq "CS" or type eq "PR" or type eq "ISS" or type eq "OAR" or type eq "TROU" or type eq "SO")>
        
        <cfif isdefined('form.dodate')>
                    
        <cfif getmovingictran.type eq "DO">
        <cfset movingbal=val(movingbal)-val(getmovingictran.qty)>
		<cfelseif getmovingictran.type eq "INV" and checkexist2.recordcount eq 0>
        <cfelse>
	    <cfset movingbal=val(movingbal)-val(getmovingictran.qty)>
	    </cfif>
        <cfelse>
        
        <cfif getmovingictran.type eq "DO" and getmovingictran.toinv neq "">
		<cfelse>
	    <cfset movingbal=val(movingbal)-val(getmovingictran.qty)>
	    </cfif>
        
        </cfif>
        </cfif>

        
        </cfloop>
        
		<cfset movingstockbal=val(movingbal)*val(movingunitcost)>
		<cfquery name="updateIcitem" datasource="#dts#">
            update icitem 
				set ucost=<cfqueryparam cfsqltype="cf_sql_double" value="#val(movingunitcost)#">
				where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#getictran.itemno#">;
        </cfquery>

       
            <!--- --->
            <cfelse>
            
            <cfquery name = "updateIcitem" datasource = "#dts#">
				update icitem 
				set ucost=<cfqueryparam cfsqltype="cf_sql_double" value="#getictran.price#">
				where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#getictran.itemno#">;
			</cfquery>
            
            </cfif>
            
            
            <cfquery name="updateictran" datasource="#dts#">
            	UPDATE ICTRAN SET UPDCOST = "Y" WHERE 
                type=<cfqueryparam cfsqltype="cf_sql_char" value="#getictran.type#">
                and refno=<cfqueryparam cfsqltype="cf_sql_char" value="#getictran.refno#">
                and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#getictran.itemno#">
                and fperiod <> '99'
                
            </cfquery>
			
			<cfif getictran.custno neq "">
				<cfquery name = "update_icl3p2" datasource = "#dts#">
					insert into icl3p2 
					(
						itemno,
						custno,
						price,
						dispec,
						dispec2,
						dispec3
					)
					values 
					(
						<cfqueryparam cfsqltype="cf_sql_char" value="#getictran.itemno#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#getictran.custno#">,
						<cfqueryparam cfsqltype="cf_sql_double" value="#getictran.price#">,
						<cfqueryparam cfsqltype="cf_sql_double" value="#getictran.dispec1#">,
						<cfqueryparam cfsqltype="cf_sql_double" value="#getictran.dispec2#">,
						<cfqueryparam cfsqltype="cf_sql_double" value="#getictran.dispec3#">
					) 
					on duplicate key update 
					price=<cfqueryparam cfsqltype="cf_sql_double" value="#getictran.price#">,
					dispec=<cfqueryparam cfsqltype="cf_sql_double" value="#getictran.dispec1#">,
					dispec2=<cfqueryparam cfsqltype="cf_sql_double" value="#getictran.dispec2#">,
					dispec3=<cfqueryparam cfsqltype="cf_sql_double" value="#getictran.dispec3#">;
				</cfquery>
			</cfif>
		</cfloop>
		<cfelse>
        <cfquery name = "updateictran" datasource = "#dts#">
                UPDATE ICTRAN SET UPDCOST = "Y" WHERE 
                type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#tran#">
                and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#nexttranno#">
                and fperiod <> '99'
        </cfquery>
		</cfif>

        
        
        <!--- --->
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

<cfif wpitemtax eq "Y">
	<cfquery name="gettax" datasource="#dts#">
    	select sum(taxamt_bil) as tt_taxamt_bil from ictran where type='#tran#' and refno='#nexttranno#' and (void='' or void is null)
    </cfquery>
	<cfset gettax.tt_taxamt_bil=numberformat(val(gettax.tt_taxamt_bil),".__")>
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