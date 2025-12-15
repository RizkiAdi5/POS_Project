<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>
<cfif isdefined("form.submit") and form.submit eq "Select Batch Code">
	<cfabort>
</cfif>

<!--- REMARK ON 090608 AND REPLACE WITH THE IF ELSE CONDITION --->
<!---cfset amt1_bil = form.qty * form.price--->

<cfif val(form.qty) neq 0>
	<cfset amt1_bil = form.qty * val(form.price)>
<cfelse>
	<cfset amt1_bil = val(form.amt)>
</cfif>

<cfif form.dispec1 eq "">
	<cfset form.dispec1 = 0>
</cfif>

<cfif form.dispec2 eq "">
  	<cfset form.dispec2 = 0>
</cfif>

<cfif form.dispec3 eq "">
  	<cfset form.dispec3 = 0>
</cfif>

<cfset disamt_bil1 = (val(form.dispec1) / 100) * amt1_bil>
<cfset netamt = amt1_bil - disamt_bil1>
<cfset disamt_bil2 = (val(form.dispec2) / 100) * netamt>
<cfset netamt = netamt - disamt_bil2>
<cfset disamt_bil3 = (val(form.dispec3) / 100) * netamt>
<cfset netamt = netamt - disamt_bil3>
<cfset disamt_bil = disamt_bil1 + disamt_bil2 + disamt_bil3>
<cfset taxamt_bil = (val(form.taxpec1) / 100) * netamt>
<!--- <cfset amt_bil = netamt + taxamt_bil> --->
<cfset amt_bil = netamt>
<cfset xprice = val(form.price)> 
<cfset amt1 = amt1_bil>
<cfset disamt = disamt_bil>
<cfset taxamt = taxamt_bil>
<cfset amt = amt_bil>

<cfquery name="getitem" datasource="#dts#">
	select category,wos_group, wserialno,unit from icitem where itemno = '#form.itemno#'
</cfquery>

<cfif form.mode eq "Delete"><!--- Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete Delete  --->
	<cfquery datasource="#dts#" name="getartran">
		Select name from artran where refno = '#nexttranno#' and type = '#tran#'
	</cfquery>
	
	<cfif listfirst(tran) eq 'TR'>
		<cfquery name="getitem" datasource="#dts#">
			select a.*,b.wserialno 
			from ictran as a, icitem as b
			where a.itemno='#form.itemno#' 
			and a.itemno=b.itemno
			and (a.type = 'TRIN' or a.type = 'TROU') 
			and a.refno='#nexttranno#' 
			and a.itemcount = '#itemcount#'
		</cfquery>
		
		<cfif getitem.batchcode neq "">
			<cfloop query="getitem">
				<cfquery name="updatelobthob" datasource="#dts#">
					update lobthob set <cfif getitem.type eq "TROU">bth_qut=(bth_qut-#getitem.qty#)<cfelseif getitem.type eq "TRIN">bth_qin=(bth_qin-#getitem.qty#)</cfif> 
					where location='#getitem.location#' and itemno='#getitem.itemno#' and batchcode='#getitem.batchcode#'
				</cfquery>
				
				<cfif checkcustom.customcompany eq "Y">
					<cfquery name="updateobbatch" datasource="#dts#">
						update obbatch set <cfif getitem.type eq "TROU">bth_qut=(bth_qut-#getitem.qty#)<cfelseif getitem.type eq "TRIN">bth_qin=(bth_qin-#getitem.qty#)</cfif> 
						where batchcode = '#getitem.batchcode#' and itemno='#getitem.itemno#'
					</cfquery>
				</cfif>
			</cfloop>
			
			<!--- <cfif lcase(hcomid) neq "thaipore_i" or lcase(hcomid) eq "jaynbtrading_i"> --->
			
		</cfif>
		
		<cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set QIN#(readperiod+10)#=(QIN#(readperiod+10)#-#qty#),QOUT#(readperiod+10)#=(QOUT#(readperiod+10)#-#qty#) where itemno = '#itemno#'
		</cfquery>
		
		<cfquery datasource='#dts#' name="deleteitem">
			Delete from ictran where itemno='#form.itemno#' and refno = '#nexttranno#' and (type = 'TRIN' or type = 'TROU')and itemcount = '#itemcount#'
		</cfquery>
		
		<cfquery name="checkexist" datasource="#dts#">
			select * from igrade
			where type='TRIN' 
			and refno='#nexttranno#' 
			and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
			and trancode='#itemcount#'
		</cfquery>

		<cfif checkexist.recordcount neq 0>
			<cfset firstcount = 11>
			<cfset maxcounter = 70>
			<cfset totalrecord = (maxcounter - firstcount + 1)>
	
			<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
				<cfloop from="#firstcount#" to="#maxcounter#" index="i">
					<cfif i eq firstcount>
						<cfset grdvaluelist = Evaluate("checkexist.GRD#i#")>
						<cfset bgrdlist = "bgrd"&i>
					<cfelse>
						<cfset grdvaluelist = grdvaluelist&","&Evaluate("checkexist.GRD#i#")>
						<cfset bgrdlist = bgrdlist&",bgrd"&i>
					</cfif>	
				</cfloop>
	
				<cfset myArray = ListToArray(bgrdlist,",")>
				<cfset myArray2 = ListToArray(grdvaluelist,",")>
		
				<cfquery name="updatelogrdob" datasource="#dts#">
					update logrdob
					set
					<cfloop from="1" to="#totalrecord#" index="i">
						<cfif i neq totalrecord>
							#myArray[i]# = #myArray[i]#-#myArray2[i]#,
						<cfelse>
							#myArray[i]# = #myArray[i]#-#myArray2[i]#
						</cfif>
					</cfloop>
					where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.itemno#">
					and location = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.location#">
				</cfquery>
		
			</cfif>
	
			<cfquery name="delete" datasource="#dts#">
				delete from igrade
				where type='TRIN' 
				and refno='#nexttranno#' 
				and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.itemno#"> 
				and trancode='#itemcount#'
			</cfquery>
		</cfif>
		
		<cfquery name="checkexist2" datasource="#dts#">
			select * from igrade
			where type='TROU' 
			and refno='#nexttranno#' 
			and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
			and trancode='#itemcount#'
		</cfquery>

		<cfif checkexist2.recordcount neq 0>
			<cfset firstcount = 11>
			<cfset maxcounter = 70>
			<cfset totalrecord = (maxcounter - firstcount + 1)>
	
			<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
				<cfloop from="#firstcount#" to="#maxcounter#" index="i">
					<cfif i eq firstcount>
						<cfset grdvaluelist = Evaluate("checkexist2.GRD#i#")>
						<cfset bgrdlist = "bgrd"&i>
					<cfelse>
						<cfset grdvaluelist = grdvaluelist&","&Evaluate("checkexist2.GRD#i#")>
						<cfset bgrdlist = bgrdlist&",bgrd"&i>
					</cfif>	
				</cfloop>
	
				<cfset myArray = ListToArray(bgrdlist,",")>
				<cfset myArray2 = ListToArray(grdvaluelist,",")>
		
				<cfquery name="updatelogrdob" datasource="#dts#">
					update logrdob
					set
					<cfloop from="1" to="#totalrecord#" index="i">
						<cfif i neq totalrecord>
							#myArray[i]# = #myArray[i]#+#myArray2[i]#,
						<cfelse>
							#myArray[i]# = #myArray[i]#+#myArray2[i]#
						</cfif>
					</cfloop>
					where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist2.itemno#">
					and location = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist2.location#">
				</cfquery>
		
			</cfif>
	
			<cfquery name="delete" datasource="#dts#">
				delete from igrade
				where type='TROU' 
				and refno='#nexttranno#' 
				and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist2.itemno#"> 
				and trancode='#itemcount#'
			</cfquery>
		</cfif>
		
	<cfelse>
		<cfif enterbatch neq "">
			<cfif tran eq "OAI">
				<cfset obtype= "bth_qin">
			<cfelse>
				<cfset obtype= "bth_qut">
			</cfif>
			
			<cfif location neq "">
				<cfquery name="updatelobthob" datasource="#dts#">
					update lobthob set #obtype#=(#obtype#-#qty#) 
					where location='#location#' and itemno='#itemno#' and batchcode='#enterbatch#'
				</cfquery>
			<cfelse>
				<cfquery name="updateobbatch" datasource="#dts#">
					update obbatch set #obtype#=(#obtype#-#qty#) 
					where itemno='#itemno#' and batchcode='#enterbatch#'
				</cfquery>
			</cfif>
		</cfif>
		
		<cfif listfirst(tran) eq "OAI">
			<cfset qname='QIN'&(readperiod+10)>
		<cfelse>
			<cfset qname='QOUT'&(readperiod+10)>
		</cfif>
		
		<cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set #qname#=(#qname#-#qty#) where itemno = '#itemno#'
		</cfquery>
		
		<cfquery datasource='#dts#' name="deleteitem">
			Delete from ictran where itemno='#form.itemno#' and refno = '#nexttranno#' and type = '#tran#'and itemcount = '#itemcount#'
		</cfquery>
		
		<cfquery name="checkexist" datasource="#dts#">
			select * from igrade
			where type='#tran#' 
			and refno='#nexttranno#' 
			and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#"> 
			and trancode='#itemcount#'
		</cfquery>
		
		<cfif checkexist.recordcount neq 0>
			<cfset firstcount = 11>
			<cfset maxcounter = 70>
			<cfset totalrecord = (maxcounter - firstcount + 1)>
	
			<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
				<cfloop from="#firstcount#" to="#maxcounter#" index="i">
					<cfif i eq firstcount>
						<cfset grdvaluelist = Evaluate("checkexist.GRD#i#")>
						<cfset bgrdlist = "bgrd"&i>
					<cfelse>
						<cfset grdvaluelist = grdvaluelist&","&Evaluate("checkexist.GRD#i#")>
						<cfset bgrdlist = bgrdlist&",bgrd"&i>
					</cfif>	
				</cfloop>
	
				<cfset myArray = ListToArray(bgrdlist,",")>
				<cfset myArray2 = ListToArray(grdvaluelist,",")>
	
				<cfquery name="updateitemgrd" datasource="#dts#">
					update itemgrd
					set
					<cfloop from="1" to="#totalrecord#" index="i">
						<cfif i neq totalrecord>
							#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#,
						<cfelse>
							#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#
						</cfif>
					</cfloop>
					where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.itemno#"> 
				</cfquery>
	
		
				<cfquery name="updatelogrdob" datasource="#dts#">
					update logrdob
					set
					<cfloop from="1" to="#totalrecord#" index="i">
						<cfif i neq totalrecord>
							#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#,
						<cfelse>
							#myArray[i]# = #myArray[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray2[i]#
						</cfif>
					</cfloop>
					where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.itemno#">
					and location = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.location#">
				</cfquery>
		
			</cfif>
	
			<cfquery name="delete" datasource="#dts#">
				delete from igrade
				where type='#tran#' 
				and refno='#nexttranno#' 
				and itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#checkexist.itemno#"> 
				and trancode='#itemcount#'
			</cfquery>
		</cfif>
		<cfquery name="deleteserial" datasource="#dts#">
			delete from iserial 
			where type='#tran#' 
			and refno='#nexttranno#' 
			and itemno='#form.itemno#' 
			and trancode='#itemcount#'
		</cfquery>
	</cfif>
	
	<cfset status = "Item Deleted Successfully">
		
<cfelseif form.mode eq "Add"><!--- Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add Add  --->
	<cfif listfirst(tran) eq 'TR'>
		<cfquery datasource='#dts#' name="checkitemExist">
			select * from ictran where refno='#nexttranno#' and type = 'TRIN' order by itemcount
		</cfquery>
	<cfelse>
		<cfquery datasource='#dts#' name="checkitemExist">
			select * from ictran where refno='#nexttranno#' and type = '#tran#'
		</cfquery>
	</cfif>
	
	<cfif checkitemExist.recordcount gt 0>
		<cfset largest = 0>	
		
		<cfoutput query="checkitemExist">
			<cfset itemcnt = checkitemExist.itemcount>
			<cfif itemcnt gt largest>
				<cfset largest = itemcnt>
			</cfif>
		</cfoutput>
		<cfset itemcnt = largest + 1>		
	<cfelse>
		<cfset itemcnt = 1>
	</cfif> 	
	
	<!--- ADD THE PROJECT & JOB ON 25-11-2009 --->	
	<cfquery datasource="#dts#" name="getartran">
		Select name,source,job from artran where refno = '#nexttranno#' and type = '#tran#'
	</cfquery> 
	
	<cfset status = "Item Added Successfully">
	
	<!--- <cfif expdate neq "">
		<cfset expdate=mid(expdate,7,4)&"-"&mid(expdate,4,2)&"-"&mid(expdate,1,2)>
	<cfelse>
		<cfset expdate=expdate>
	</cfif>
	
	<cfif sodate neq "">
		<cfset sodate=mid(sodate,7,4)&"-"&mid(sodate,4,2)&"-"&mid(sodate,1,2)>
	<cfelse>
		<cfset sodate=sodate>
	</cfif>
	
	<cfif dodate neq "">
		<cfset dodate=mid(dodate,7,4)&"-"&mid(dodate,4,2)&"-"&mid(dodate,1,2)>
	<cfelse>
		<cfset dodate=dodate>
	</cfif> --->
	<cfif trim(expdate) neq "">
		<cfset expdate = createDate(ListGetAt(expdate,3,"-"),ListGetAt(expdate,2,"-"),ListGetAt(expdate,1,"-"))>
	<cfelse>
		<cfset expdate = "">
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
    <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#sodate#" returnvariable="sodate"/>
    <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#dodate#" returnvariable="dodate"/>
    <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#expdate#" returnvariable="expdate"/>
		
	<cfif listfirst(tran) eq 'TR'>
    	<cftry>
            <cfquery datasource="#dts#" name="insertartran">
                Insert into ictran (type,refno,custno,fperiod,wos_date,currrate,itemcount,itemno,desp,despa,agenno,source,job,
                location,qty_bil,price_bil,amt1_bil,dispec1,dispec2,dispec3,disamt_bil,amt_bil,taxpec1,taxamt_bil,qty,price,
                amt1,disamt,amt,taxamt,dono,name,exported,exported1,exported2,exported3,sono,toinv,generated,wos_group,category,trdatetime,
                sodate,dodate,adtcost1,adtcost2,batchcode,expdate,mc1_bil,mc2_bil,defective,factor1,factor2,comment,
				brem1,brem2,brem3,brem4,unit
                <cfif checkcustom.customcompany eq "Y">
                    ,brem5,brem6,brem7,brem8,brem9,brem10
                </cfif>,consignment)
            
                values ('TROU', '#nexttranno#', '#form.custno#', '#numberformat(form.readperiod,"00")#', 
                #ndatecreate#, '1', '#itemcnt#', '#form.itemno#', '#form.desp#', '#form.despa#','#form.agenno#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
                '#listfirst(form.trfrom)#', '#form.qty#', '#val(form.price)#','#amt1_bil#', '#val(form.dispec1)#','#val(form.dispec2)#','#val(form.dispec3)#',
                '#disamt_bil#', '#amt_bil#', '#val(form.taxpec1)#','#taxamt_bil#','#val(form.qty)#', '#xprice#', '#amt1#', 
                '#disamt#',	'#amt#', '#taxamt#', 'DONO','#getartran.name#','','0000-00-00','','0000-00-00','SONO','','', '#getitem.wos_group#',
                '#getitem.category#',#now()#,'#sodate#','#dodate#',
                '#val(adtcost1)#','#val(adtcost2)#','#form.enterbatch#','#expdate#','#val(mc1bil)#','#val(mc2bil)#','#defective#','1.00000','1.00000',
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.comment#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem3#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem4#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.unit#">
                <cfif checkcustom.customcompany eq "Y">
                    ,'#form.bremark5#','#form.bremark6#','#form.bremark7#','#form.bremark8#','#form.bremark9#','#form.bremark10#'
                </cfif>
                ,'#listfirst(form.consignment)#')
            </cfquery>
        <cfcatch type="any">
        	<cfoutput>#cfcatch.Message#::#cfcatch.Detail#</cfoutput><cfabort>
        </cfcatch>
        </cftry>
		
		<cfquery datasource="#dts#" name="insertartran">
			Insert into ictran (type,refno,custno,fperiod,wos_date,currrate,itemcount,itemno,desp,despa,agenno,source,job,
			location,qty_bil,price_bil,amt1_bil,dispec1,dispec2,dispec3,disamt_bil,amt_bil,taxpec1,taxamt_bil,qty,price,
			amt1,disamt,amt,taxamt,dono,name,exported,exported1,exported2,exported3,sono,toinv,generated,wos_group,category,trdatetime,
			sodate,dodate,adtcost1,adtcost2,batchcode,expdate,mc1_bil,mc2_bil,defective,factor1,factor2,comment,
			brem1,brem2,brem3,brem4,unit
			<cfif checkcustom.customcompany eq "Y">
				,brem5,brem6,brem7
			</cfif>,consignment)
		
			values ('TRIN', '#nexttranno#', '#form.custno#', '#numberformat(form.readperiod,"00")#', 
			#ndatecreate#, '1', '#itemcnt#', '#form.itemno#', '#form.desp#', '#form.despa#','#form.agenno#',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
			'#listfirst(form.trto)#', '#form.qty#', '#val(form.price)#','#amt1_bil#', '#form.dispec1#','#form.dispec2#','#form.dispec3#',
			'#disamt_bil#', '#amt_bil#', '#form.taxpec1#','#taxamt_bil#','#form.qty#', '#xprice#', '#amt1#', 
			'#disamt#',	'#amt#', '#taxamt#', 'DONO','#getartran.name#','','0000-00-00','','0000-00-00','SONO','','', '#getitem.wos_group#',
			'#getitem.category#',#now()#,'#sodate#','#dodate#',
			'#val(adtcost1)#','#val(adtcost2)#',<cfif checkcustom.customcompany eq "Y">'#form.batchcode2#'<cfelse>'#enterbatch#'</cfif>,
			'#expdate#','#val(mc1bil)#','#val(mc2bil)#','#defective#','1.00000','1.00000',
			<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.comment#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem1#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem2#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem3#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem4#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#getitem.unit#">
			<cfif checkcustom.customcompany eq "Y">
				,'#form.hremark5#','#form.bremark6#','#form.hremark6#'
			</cfif>,'#listfirst(form.consignment)#')
		</cfquery>

		
		
		<cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set QIN#(readperiod+10)#=(QIN#(readperiod+10)#+#qty#),QOUT#(readperiod+10)#=(QOUT#(readperiod+10)#+#qty#) where itemno = '#itemno#'
		</cfquery>
		
		<!--- Add on 030908 for Graded Item --->
		<cfif form.grdcolumnlist neq "">
			<cfset grdcolumnlist = form.grdcolumnlist>
			<cfset bgrdcolumnlist = form.bgrdcolumnlist>
			<cfset grdvaluelist = form.grdvaluelist>
			<cfset myArray = ListToArray(grdcolumnlist,",")>
			<cfset myArray2 = ListToArray(grdvaluelist,",")>
			<cfset myArray3 = ListToArray(bgrdcolumnlist,",")>
			
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
				('TRIN','#nexttranno#','#itemcnt#','#form.itemno#',#ndatecreate#,'#numberformat(form.readperiod,"00")#',
				'1','','#listfirst(form.trto)#','','','#form.custno#','','1','1',
				<cfloop from="1" to="#form.totalrecord#" index="i">
					<cfif i neq form.totalrecord>
						#myArray2[i]#,
					<cfelse>
						#myArray2[i]#
					</cfif>
				</cfloop>)
			</cfquery>
			
			<cfquery name="insertigrade2" datasource="#dts#">
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
				('TROU','#nexttranno#','#itemcnt#','#form.itemno#',#ndatecreate#,'#numberformat(form.readperiod,"00")#',
				'-1','','#listfirst(form.trfrom)#','','','#form.custno#','','1','1',
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
				
				<cfquery name="checkexist1" datasource="#dts#">
					select * from logrdob
					where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
					and location = <cfqueryparam cfsqltype="cf_sql_char" value="#listfirst(form.trfrom)#">
				</cfquery>
		
				<cfif checkexist1.recordcount eq 0>
					<cfquery name="insert" datasource="#dts#">
						insert into logrdob 
						(itemno,location)
						values
						(<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#listfirst(form.trfrom)#">)
					</cfquery>
				</cfif>
		
				<cfquery name="updatelogrdob" datasource="#dts#">
					update logrdob
					set
					<cfloop from="1" to="#form.totalrecord#" index="i">
						<cfif i neq form.totalrecord>
							#myArray3[i]# = #myArray3[i]#-#myArray2[i]# ,
						<cfelse>
							#myArray3[i]# = #myArray3[i]#-#myArray2[i]#
						</cfif>
					</cfloop>
					where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
					and location = <cfqueryparam cfsqltype="cf_sql_char" value="#listfirst(form.trfrom)#">
				</cfquery>
				
				<cfquery name="checkexist2" datasource="#dts#">
					select * from logrdob
					where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
					and location = <cfqueryparam cfsqltype="cf_sql_char" value="#listfirst(form.trto)#">
				</cfquery>
		
				<cfif checkexist2.recordcount eq 0>
					<cfquery name="insert" datasource="#dts#">
						insert into logrdob 
						(itemno,location)
						values
						(<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#listfirst(form.trto)#">)
					</cfquery>
				</cfif>
		
				<cfquery name="updatelogrdob" datasource="#dts#">
					update logrdob
					set
					<cfloop from="1" to="#form.totalrecord#" index="i">
						<cfif i neq form.totalrecord>
							#myArray3[i]# = #myArray3[i]#+#myArray2[i]# ,
						<cfelse>
							#myArray3[i]# = #myArray3[i]#+#myArray2[i]#
						</cfif>
					</cfloop>
					where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
					and location = <cfqueryparam cfsqltype="cf_sql_char" value="#listfirst(form.trto)#">
				</cfquery>
				
			</cfif>	
		</cfif>
	<cfelse><!--- tran neq TR --->	<!--- Add Add Add Add Add Add Add Add --->	
		<cftry>
            <cfquery  name="insertartran" datasource="#dts#">
                Insert into ictran (type,refno,custno,fperiod,wos_date,currrate,itemcount,itemno,desp,despa,agenno,source,job,
                location,qty_bil,price_bil,amt1_bil,dispec1,dispec2,dispec3,disamt_bil,amt_bil,taxpec1,taxamt_bil,qty,price,
                amt1,disamt,amt,taxamt,dono,name,exported,exported1,exported2,exported3,sono,toinv,generated,wos_group,category,
                sodate,dodate,adtcost1,adtcost2,batchcode,expdate,mc1_bil,mc2_bil,defective,trdatetime,factor1,factor2,comment,
				brem1,brem2,brem3,brem4
                <cfif checkcustom.customcompany eq "Y">
                    ,brem5,brem7,brem8,brem9,brem10
                </cfif>)
            
                values ('#tran#', '#nexttranno#', '#form.custno#', '#numberformat(form.readperiod,"00")#', 
                #ndatecreate#, '1', '#itemcnt#', '#form.itemno#', '#form.desp#', '#form.despa#','#form.agenno#',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
                '#form.location#', '#val(form.qty)#', '#val(form.price)#','#amt1_bil#', '#val(form.dispec1)#','#val(form.dispec2)#','#val(form.dispec3)#',
                '#disamt_bil#', '#amt_bil#', '#form.taxpec1#','#taxamt_bil#','#form.qty#', '#xprice#', '#amt1#', 
                '#disamt#',	'#amt#', '#taxamt#', 'DONO','#getartran.name#','','0000-00-00','','0000-00-00','SONO','','', '#getitem.wos_group#',
                '#getitem.category#','#sodate#','#dodate#','#val(adtcost1)#','#val(adtcost2)#',
                '#enterbatch#','#expdate#','#val(mc1bil)#','#val(mc2bil)#','#defective#', #now()#,'1.00000','1.00000',
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.comment#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem3#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem4#">
                <cfif checkcustom.customcompany eq "Y">
                    ,'#form.hremark5#','#form.hremark6#','#form.bremark8#','#form.bremark9#','#form.bremark10#'
                </cfif>)
            </cfquery>
        <cfcatch type="any">
        	<cfoutput>#cfcatch.Message#::#cfcatch.Detail#</cfoutput><cfabort>
        </cfcatch>
        </cftry>
		
		<cfif trim(enterbatch) neq "">
			<cfif tran eq "ISS" or tran eq "OAR">
				<cfset obtype= "bth_qut">
			<cfelse>
				<cfset obtype= "bth_qin">
			</cfif>
			
			<cfif location neq "">
				<cfquery name="checkobbatch" datasource="#dts#">
					select batchcode,itemno from obbatch where batchcode='#form.enterbatch#' and itemno='#form.itemno#'
				</cfquery>
				
				<cfquery name="checklobthob" datasource="#dts#">
					select location,batchcode,itemno from lobthob where location='#form.location#' and batchcode='#form.enterbatch#' and itemno='#form.itemno#'
				</cfquery>
				
				<cfif checkobbatch.recordcount eq 0>
					<cfif (checkcustom.customcompany eq "Y") and tran eq "OAI">
						<cfquery name="updateLotNo" datasource="#dts#">
							update gsetup
							set lotno = '#form.enterbatch#'
						</cfquery>
						<cfquery name="insert" datasource="#dts#">
							insert into lotnumber
							(LotNumber,itemno)
							value
							(<cfqueryparam cfsqltype="cf_sql_char" value="#form.enterbatch#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">)
						</cfquery>
					</cfif>
					<cfquery name="insertobbatch" datasource="#dts#">
						insert into obbatch 
						(batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,exp_date,rc_type,rc_refno,rc_expdate
						<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif>) 
						values
						('#form.enterbatch#','#form.itemno#','','','0',<cfif tran eq "OAI">'#form.qty#'<cfelse>'0'</cfif>,<cfif tran eq "ISS" or tran eq "OAR">'#form.qty#'<cfelse>'0'</cfif>,'0','0','0','0000-00-00','','','0000-00-00'
						<cfif checkcustom.customcompany eq "Y">
							,'#form.hremark5#','#form.hremark6#'
						</cfif>)
					</cfquery>
				<cfelse>
					<cfquery name="checkobbatchqty" datasource="#dts#">
						select batchcode,itemno from obbatch  
						where itemno='#form.itemno#' and batchcode='#form.enterbatch#' and #obtype# <> 0
					</cfquery>
					
					<cfif checkobbatchqty.recordcount eq 0>
						<cfset check = "y">
					<cfelse>
						<cfset check = "n">
					</cfif>
					
					<cfquery name="updateobbatch" datasource="#dts#">
						update obbatch set #obtype#=<cfif check eq "y">(#obtype#+#qty#)<cfelse>(#obtype#+(#qty#-#oldqty#))</cfif> 
						where itemno='#itemno#' and batchcode='#enterbatch#'
					</cfquery>
				</cfif>
				
				<cfif checklobthob.recordcount eq 0>
					<cfquery name="insertobbatch" datasource="#dts#">
						insert into lobthob 
						(location,batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,expdate,rc_type,rc_refno,rc_expdate
						<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif>) 
						values
						('#form.location#','#form.enterbatch#','#form.itemno#','','','0',<cfif tran eq "OAI">'#form.qty#'<cfelse>'0'</cfif>,<cfif tran eq "ISS" or tran eq "OAR">'#form.qty#'<cfelse>'0'</cfif>,'0','0','0','0000-00-00','','','0000-00-00'
						<cfif checkcustom.customcompany eq "Y">
							,'#form.hremark5#','#form.hremark6#'
						</cfif>)
					</cfquery>
				<cfelse>
					<cfquery name="checklocationbatchqty" datasource="#dts#">
						select location,batchcode,itemno from lobthob 
						where location = '#location#' and itemno='#form.itemno#' and batchcode='#form.enterbatch#' and #obtype# <> 0
					</cfquery>
					
					<cfif checklocationbatchqty.recordcount eq 0>
						<cfset check = "y">
					<cfelse>
						<cfset check = "n">
					</cfif>
					
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set #obtype#=<cfif check eq "y">(#obtype#+#qty#)<cfelse>(#obtype#+(#qty#-#oldqty#))</cfif> 
						where location ='#location#' and itemno='#itemno#' and batchcode='#enterbatch#'
					</cfquery>
				</cfif>
			<cfelse>
				<cfquery name="checkobbatch" datasource="#dts#">
					select batchcode,itemno from obbatch where batchcode='#form.enterbatch#' and itemno='#form.itemno#'
				</cfquery>
				
				<cfif checkobbatch.recordcount eq 0>
					<cfif (checkcustom.customcompany eq "Y") and tran eq "OAI">
						<cfquery name="updateLotNo" datasource="#dts#">
							update gsetup
							set lotno = '#form.enterbatch#'
						</cfquery>
						<cfquery name="insert" datasource="#dts#">
							insert into lotnumber
							(LotNumber,itemno)
							value
							(<cfqueryparam cfsqltype="cf_sql_char" value="#form.enterbatch#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">)
						</cfquery>
					</cfif>
					<cfquery name="insertobbatch" datasource="#dts#">
						insert into obbatch 
						(batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,exp_date,rc_type,rc_refno,rc_expdate
						<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif>) 
						values
						('#form.enterbatch#','#form.itemno#','','','0',<cfif tran eq "OAI">'#form.qty#'<cfelse>'0'</cfif>,<cfif tran eq "ISS" or tran eq "OAR">'#form.qty#'<cfelse>'0'</cfif>,'0','0','0','0000-00-00','','','0000-00-00'
						<cfif checkcustom.customcompany eq "Y">
							,'#form.hremark5#','#form.hremark6#'
						</cfif>)
					</cfquery>
				<cfelse>
					<cfquery name="checkbatchqty" datasource="#dts#">
						select batchcode from obbatch where itemno='#form.itemno#' and batchcode='#form.enterbatch#' and #obtype# <> 0
					</cfquery>
					
					<cfif checkbatchqty.recordcount eq 0>
						<cfset check = "y">
					<cfelse>
						<cfset check = "n">
					</cfif>
					
					<cfquery name="updateobbatch" datasource="#dts#">
						update obbatch set #obtype#=<cfif check eq "y">(#obtype#+#qty#)<cfelse>(#obtype#+(#qty#-#oldqty#))</cfif> 
						where itemno='#itemno#' and batchcode='#enterbatch#'
					</cfquery>
				</cfif>
			</cfif>
		</cfif>

		<cfif tran eq "OAI">
			<cfset qname='QIN'&(readperiod+10)>
		<cfelse>
			<cfset qname='QOUT'&(readperiod+10)>
		</cfif>
		
		<cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set #qname#=(#qname#+#qty#) where itemno = '#itemno#'
		</cfquery>
		
		<!--- Add on 030908 for Graded Item --->
		<cfif form.grdcolumnlist neq "">
			<cfset grdcolumnlist = form.grdcolumnlist>
			<cfset bgrdcolumnlist = form.bgrdcolumnlist>
			<cfset grdvaluelist = form.grdvaluelist>
			<cfset myArray = ListToArray(grdcolumnlist,",")>
			<cfset myArray2 = ListToArray(grdvaluelist,",")>
			<cfset myArray3 = ListToArray(bgrdcolumnlist,",")>
			
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
				('#tran#','#nexttranno#','#itemcnt#','#form.itemno#',#ndatecreate#,'#numberformat(form.readperiod,"00")#',
				<cfif tran eq "RC" or tran eq "PO" or tran eq "CN" or tran eq "OAI">'1'<cfelse>'-1'</cfif>,
				'','#location#','','','#form.custno#','','1','1',
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
	
				<cfquery name="updateitemgrd" datasource="#dts#">
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
		
				<cfquery name="updatelogrdob" datasource="#dts#">
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
				</cfquery>
				
			</cfif>
			
		</cfif>
	</cfif>

<cfelseif listfirst(form.mode) eq "Edit"><!--- Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit Edit  --->
	<cfquery name="getartran" datasource="#dts#" >
		Select name,wos_date from artran where refno = '#nexttranno#' and type = '#listfirst(tran)#'
	</cfquery>
		
	<!--- <cfif expdate neq "">
		<cfset expdate=mid(expdate,7,4)&"-"&mid(expdate,4,2)&"-"&mid(expdate,1,2)>
	<cfelse>
		<cfset expdate=expdate>
	</cfif>
	
	<cfif sodate neq "">
		<cfset sodate=mid(sodate,7,4)&"-"&mid(sodate,4,2)&"-"&mid(sodate,1,2)>
	<cfelse>
		<cfset sodate=sodate>
	</cfif>
	
	<cfif dodate neq "">
		<cfset dodate=mid(dodate,7,4)&"-"&mid(dodate,4,2)&"-"&mid(dodate,1,2)>
	<cfelse>
		<cfset dodate=dodate>
	</cfif> --->
	<cftry>
		<cfif trim(expdate) neq "">
			<cfset expdate = createDate(ListGetAt(expdate,3,"-"),ListGetAt(expdate,2,"-"),ListGetAt(expdate,1,"-"))>
		<cfelse>
			<cfset expdate = "">
		</cfif>
	<cfcatch type="any">
		<cfset expdate = "">
	</cfcatch>
	</cftry>
		
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
    
    <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#sodate#" returnvariable="sodate"/>
    <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#dodate#" returnvariable="dodate"/>
    <cfinvoke component="cfc.date" method="getFormatedDate" inputDate="#expdate#" returnvariable="expdate"/>

	<cfif listfirst(tran) neq "TR"><!---  Edit when Tran neq TR --->
		<cfif listfirst(tran) eq "OAI">
			<cfset obtype= "bth_qin">
		<cfelse>
			<cfset obtype= "bth_qut">
		</cfif>
			
		<cfif trim(listfirst(enterbatch)) neq ""><!--- Enterbatch neq Empty --->
			<cfif listfirst(enterbatch) eq listfirst(oldenterbatch)><!--- Enterbatch eq Oldenterbatch --->
				<cfif listfirst(location) neq ""><!--- Location neq Empty --->
					<cfquery name="checkbatchqty2" datasource="#dts#">
						select batchcode from lobthob where location='#listfirst(location)#' and itemno='#listfirst(form.itemno)#' 
						and batchcode='#listfirst(form.enterbatch)#' and #obtype# <> 0
					</cfquery>
							
					<cfif checkbatchqty2.recordcount eq 0>
						<cfset check2 = "y">
					<cfelse>
						<cfset check2 = "n">
					</cfif>
					
					<cfif listfirst(location) eq listfirst(oldlocation)><!--- Location eq Oldlocation --->
						<cfquery name="updatelobthob" datasource="#dts#">
							update lobthob set #obtype#=<cfif check2 eq "y">(#obtype#+#qty#)<cfelse>(#obtype#+(#qty#-#batchqty#))</cfif>  
							where location='#listfirst(location)#' and itemno='#listfirst(itemno)#' and batchcode='#listfirst(enterbatch)#'
						</cfquery>
							
						<cfquery name="updateobbatch" datasource="#dts#">
							update obbatch set #obtype#=(#obtype#+(#qty#-#batchqty#)) 
							where itemno='#listfirst(itemno)#' and batchcode='#listfirst(enterbatch)#'
						</cfquery>
					<cfelse><!--- Location neq Oldlocation --->
						<cfquery name="checklobthob" datasource="#dts#">
							select location,batchcode,itemno from lobthob where location='#location#' and batchcode='#enterbatch#' and itemno='#itemno#'
						</cfquery>
						
						<cfif checklobthob.recordcount eq 0>
							<cfquery name="insertlobthob" datasource="#dts#">
								insert into lobthob 
								(location,batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,expdate,rc_type,rc_refno,rc_expdate
								<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif>) 
								values
								('#listfirst(location)#','#listfirst(enterbatch)#','#listfirst(itemno)#','','','0',<cfif obtype eq "bth_qin">'#form.qty#'<cfelse>'0'</cfif>,<cfif obtype eq "bth_qut">'#form.qty#'<cfelse>'0'</cfif>,'0','0','0','0000-00-00','','','0000-00-00'
								<cfif checkcustom.customcompany eq "Y">
									,'#form.hremark5#','#form.hremark6#'
								</cfif>)
							</cfquery>
								
							<cfquery name="updatelobthob" datasource="#dts#">
								update lobthob set #obtype#=(#obtype#-#batchqty#) 
								where location='#listfirst(oldlocation)#' and itemno='#listfirst(itemno)#' and batchcode='#listfirst(enterbatch)#'
							</cfquery>
								
							<cfquery name="updateobbatch" datasource="#dts#">
								update obbatch set #obtype#=(#obtype#+(#qty#-#batchqty#)) 
								where itemno='#listfirst(itemno)#' and batchcode='#listfirst(enterbatch)#'
							</cfquery>
						<cfelse>
							<cfquery name="updatelobthob" datasource="#dts#">
								update lobthob set #obtype#=(#obtype#+#qty#) 
								where location='#listfirst(location)#' and itemno='#listfirst(itemno)#' and batchcode='#listfirst(enterbatch)#'
							</cfquery>
								
							<cfquery name="updatelobthob" datasource="#dts#">
								update lobthob set #obtype#=(#obtype#-#batchqty#) 
								where location='#listfirst(oldlocation)#' and itemno='#listfirst(itemno)#' and batchcode='#listfirst(enterbatch)#'
							</cfquery>
								
							<cfquery name="updateobbatch" datasource="#dts#">
								update obbatch set #obtype#=(#obtype#+(#qty#-#batchqty#)) 
								where itemno='#listfirst(itemno)#' and batchcode='#listfirst(enterbatch)#'
							</cfquery>
						</cfif>
					</cfif>
				<cfelse><!--- Location eq Empty --->
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set #obtype#=(#obtype#-#batchqty#) 
						where location='#listfirst(oldlocation)#' and itemno='#listfirst(itemno)#' and batchcode='#listfirst(enterbatch)#'
					</cfquery>
								
					<cfquery name="updateobbatch" datasource="#dts#">
						update obbatch set #obtype#=(#obtype#+(#qty#-#batchqty#)) 
						where itemno='#listfirst(itemno)#' and batchcode='#listfirst(enterbatch)#'
					</cfquery>
				</cfif>
			<cfelse><!--- Enterbatch neq Oldenterbatch --->
				<cfif listfirst(location) neq ""><!--- Location neq Empty --->
					<cfif listfirst(location) eq listfirst(oldlocation)><!--- Location eq Oldlocation --->
						<cfquery name="checkobbatch" datasource="#dts#">
							select batchcode,itemno from obbatch where batchcode='#form.enterbatch#' and itemno='#form.itemno#'
						</cfquery>
						
						<cfquery name="checklobthob" datasource="#dts#">
							select location,batchcode,itemno from lobthob where location='#form.location#' and batchcode='#form.enterbatch#' and itemno='#form.itemno#'
						</cfquery>
						
						<cfif checkobbatch.recordcount eq 0>
							<cfif (checkcustom.customcompany eq "Y") and (tran eq "RC" or tran eq "OAI" or tran eq "CN")>
								<cfquery name="updateLotNo" datasource="#dts#">
									update gsetup
									set lotno = '#listfirst(enterbatch)#'
								</cfquery>
								<cfquery name="insert" datasource="#dts#">
									insert ignore into lotnumber
									(LotNumber,itemno)
									value
									(<cfqueryparam cfsqltype="cf_sql_char" value="#listfirst(enterbatch)#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#">)
								</cfquery>
							</cfif>
							<cfquery name="insertlobthob" datasource="#dts#">
								insert into obbatch 
								(batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,exp_date,rc_type,rc_refno,rc_expdate
								<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif>) 
								values
								('#listfirst(enterbatch)#','#listfirst(itemno)#','','','0',<cfif obtype eq "bth_qin">'#form.qty#'<cfelse>'0'</cfif>,<cfif obtype eq "bth_qut">'#form.qty#'<cfelse>'0'</cfif>,'0','0','0','0000-00-00','','','0000-00-00'
								<cfif checkcustom.customcompany eq "Y">
									,'#form.hremark5#','#form.hremark6#'
								</cfif>)
							</cfquery>
							
							<cfquery name="updateobbatch" datasource="#dts#">
								update obbatch set #obtype#=(#obtype#-#batchqty#) where batchcode='#form.oldenterbatch#' and itemno='#form.itemno#'
							</cfquery>
						<cfelse>
							<cfquery name="updateobbatch" datasource="#dts#">
								update obbatch set #obtype#=(#obtype#+(#qty#-#batchqty#)) where batchcode='#form.enterbatch#' and itemno='#form.itemno#'
							</cfquery>
							
							<cfquery name="updateobbatch" datasource="#dts#">
								update obbatch set #obtype#=(#obtype#-#batchqty#) where batchcode='#form.oldenterbatch#' and itemno='#form.itemno#'
							</cfquery>
						</cfif>
							
						<cfif checklobthob.recordcount eq 0>
							<cfquery name="insertlobthob" datasource="#dts#">
								insert into lobthob 
								(location,batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,expdate,rc_type,rc_refno,rc_expdate
								<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif>) 
								values
								('#listfirst(location)#','#listfirst(enterbatch)#','#listfirst(itemno)#','','','0',<cfif obtype eq "bth_qin">'#form.qty#'<cfelse>'0'</cfif>,<cfif obtype eq "bth_qut">'#form.qty#'<cfelse>'0'</cfif>,'0','0','0','0000-00-00','','','0000-00-00'
								<cfif checkcustom.customcompany eq "Y">
									,'#form.hremark5#','#form.hremark6#'
								</cfif>)
							</cfquery>
								
							<cfquery name="updateobbatch" datasource="#dts#">
								update lobthob set #obtype#=(#obtype#-#batchqty#) where location='#form.location#' and batchcode='#form.oldenterbatch#' and itemno='#form.itemno#'
							</cfquery>
						<cfelse>
							<cfquery name="updateobbatch" datasource="#dts#">
								update lobthob set #obtype#=(#obtype#+(#qty#-#batchqty#)) where location='#form.location#' and batchcode='#form.enterbatch#' and itemno='#form.itemno#'
							</cfquery>
							
							<cfquery name="updateobbatch" datasource="#dts#">
								update lobthob set #obtype#=(#obtype#-#batchqty#) where location='#form.location#' and batchcode='#form.oldenterbatch#' and itemno='#form.itemno#'
							</cfquery>
						</cfif>
					<cfelse><!--- Location neq Oldlocation --->
						<cfquery name="checkobbatch" datasource="#dts#">
							select batchcode,itemno from obbatch where batchcode='#form.enterbatch#' and itemno='#form.itemno#'
						</cfquery>
						
						<cfquery name="checklobthob" datasource="#dts#">
							select location,batchcode,itemno from lobthob where location='#form.location#' and batchcode='#form.enterbatch#' and itemno='#form.itemno#'
						</cfquery>
						
						<cfif checkobbatch.recordcount eq 0>
							<cfif (checkcustom.customcompany eq "Y") and (tran eq "RC" or tran eq "OAI" or tran eq "CN")>
								<cfquery name="updateLotNo" datasource="#dts#">
									update gsetup
									set lotno = '#listfirst(enterbatch)#'
								</cfquery>
								<cfquery name="insert" datasource="#dts#">
									insert into lotnumber
									(LotNumber,itemno)
									value
									(<cfqueryparam cfsqltype="cf_sql_char" value="#listfirst(enterbatch)#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#">)
								</cfquery>
							</cfif>
							<cfquery name="insertlobthob" datasource="#dts#">
								insert into obbatch 
								(batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,exp_date,rc_type,rc_refno,rc_expdate
								<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif>) 
								values
								('#listfirst(enterbatch)#','#listfirst(itemno)#','','','0',<cfif obtype eq "bth_qin">'#form.qty#'<cfelse>'0'</cfif>,<cfif obtype eq "bth_qut">'#form.qty#'<cfelse>'0'</cfif>,'0','0','0','0000-00-00','','','0000-00-00'
								<cfif checkcustom.customcompany eq "Y">
									,'#form.hremark5#','#form.hremark6#'
								</cfif>)
							</cfquery>
								
							<cfquery name="updateobbatch" datasource="#dts#">
								update obbatch set #obtype#=(#obtype#-#batchqty#) where batchcode='#form.oldenterbatch#' and itemno='#form.itemno#'
							</cfquery>
						<cfelse>
							<cfquery name="updateobbatch" datasource="#dts#">
								update obbatch set #obtype#=(#obtype#+(#qty#-#batchqty#)) where batchcode='#form.enterbatch#' and itemno='#form.itemno#'
							</cfquery>
							
							<cfquery name="updateobbatch" datasource="#dts#">
								update obbatch set #obtype#=(#obtype#-#batchqty#) where batchcode='#form.oldenterbatch#' and itemno='#form.itemno#'
							</cfquery>
						</cfif>
							
						<cfif checklobthob.recordcount eq 0>
							<cfquery name="insertlobthob" datasource="#dts#">
								insert into lobthob 
								(location,batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,expdate,rc_type,rc_refno,rc_expdate
								<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif>) 
								values
								('#listfirst(location)#','#listfirst(enterbatch)#','#listfirst(itemno)#','','','0',<cfif obtype eq "bth_qin">'#form.qty#'<cfelse>'0'</cfif>,<cfif obtype eq "bth_qut">'#form.qty#'<cfelse>'0'</cfif>,'0','0','0','0000-00-00','','','0000-00-00'
								<cfif checkcustom.customcompany eq "Y">
									,'#form.hremark5#','#form.hremark6#'
								</cfif>)
							</cfquery>
								
							<cfquery name="updateobbatch" datasource="#dts#">
								update lobthob set #obtype#=(#obtype#-#batchqty#) where location='#form.oldlocation#' and batchcode='#form.oldenterbatch#' and itemno='#form.itemno#'
							</cfquery>
						<cfelse>
							<cfquery name="updateobbatch" datasource="#dts#">
								update lobthob set #obtype#=(#obtype#+(#qty#-#batchqty#)) where location='#form.location#' and batchcode='#form.enterbatch#' and itemno='#form.itemno#'
							</cfquery>
								
							<cfquery name="updateobbatch" datasource="#dts#">
								update lobthob set #obtype#=(#obtype#-#batchqty#) where location='#form.oldlocation#' and batchcode='#form.oldenterbatch#' and itemno='#form.itemno#'
							</cfquery>
						</cfif>
					</cfif>
				<cfelse><!--- Location eq Empty --->
					<cfquery name="checkobbatch" datasource="#dts#">
						select batchcode,itemno from obbatch where batchcode='#form.enterbatch#' and itemno='#form.itemno#'
					</cfquery>
					
					<cfif checkobbatch.recordcount eq 0>
						<cfif (checkcustom.customcompany eq "Y") and (tran eq "RC" or tran eq "OAI" or tran eq "CN")>
							<cfquery name="updateLotNo" datasource="#dts#">
								update gsetup
								set lotno = '#listfirst(enterbatch)#'
							</cfquery>
							<cfquery name="insert" datasource="#dts#">
								insert into lotnumber
								(LotNumber,itemno)
								value
								(<cfqueryparam cfsqltype="cf_sql_char" value="#listfirst(enterbatch)#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#">)
							</cfquery>
						</cfif>
						<cfquery name="insertobbatch" datasource="#dts#">
							insert into obbatch 
							(batchcode,itemno,type,refno,bth_qob,bth_qin,bth_qut,rpt_qob,rpt_qin,rpt_qut,exp_date,rc_type,rc_refno,rc_expdate
							<cfif checkcustom.customcompany eq "Y">,permit_no,permit_no2</cfif>) 
							values
							('#listfirst(enterbatch)#','#listfirst(itemno)#','','','0',<cfif obtype eq "bth_qin">'#form.qty#'<cfelse>'0'</cfif>,<cfif obtype eq "bth_qut">'#form.qty#'<cfelse>'0'</cfif>,'0','0','0','0000-00-00','','','0000-00-00'
							<cfif checkcustom.customcompany eq "Y">
								,'#form.hremark5#','#form.hremark6#'
							</cfif>)
						</cfquery>
							
						<cfquery name="updateobbatch" datasource="#dts#">
							update obbatch set #obtype#=(#obtype#-#batchqty#) 
							where itemno='#listfirst(itemno)#' and batchcode='#listfirst(oldenterbatch)#'
						</cfquery>
					<cfelse>
						<cfquery name="updateobbatch" datasource="#dts#">
							update obbatch set #obtype#=(#obtype#+(#qty#-#batchqty#)) 
							where itemno='#listfirst(itemno)#' and batchcode='#listfirst(enterbatch)#'
						</cfquery>
							
						<cfquery name="updateobbatch" datasource="#dts#">
							update obbatch set #obtype#=(#obtype#-#batchqty#) 
							where itemno='#listfirst(itemno)#' and batchcode='#listfirst(oldenterbatch)#'
						</cfquery>
					</cfif>
						
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set #obtype#=(#obtype#-#batchqty#) 
						where location='#listfirst(oldlocation)#' and itemno='#listfirst(itemno)#' and batchcode='#listfirst(enterbatch)#'
					</cfquery>
				</cfif>
			</cfif>
		<cfelse>
			<cfquery name="updateobbatch" datasource="#dts#">
				update obbatch set #obtype#=(#obtype#-#batchqty#) 
				where itemno='#listfirst(itemno)#' and batchcode='#listfirst(oldenterbatch)#'
			</cfquery>
				
			<cfquery name="updatelobthob" datasource="#dts#">
				update lobthob set #obtype#=(#obtype#-#batchqty#) 
				where location='#oldlocation#' and itemno='#listfirst(itemno)#' and batchcode='#listfirst(oldenterbatch)#'
			</cfquery>
		</cfif>
			
		<cfif listfirst(tran) eq "OAI">
			<cfset qname='QIN'&(readperiod+10)>
		<cfelse>
			<cfset qname='QOUT'&(readperiod+10)>
		</cfif>
		
		<cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set #qname#=(#qname#+(#qty#-#oldqty#)) where itemno = '#listfirst(itemno)#'
		</cfquery>
		
		<cfif form.grdcolumnlist neq "">
			<cfset grdcolumnlist = form.grdcolumnlist>
			<cfset grdvaluelist = form.grdvaluelist>
			<cfset bgrdcolumnlist = form.bgrdcolumnlist>
			<cfset oldgrdvaluelist = form.oldgrdvaluelist>
	
			<cfset myArray = ListToArray(grdcolumnlist,",")>
			<cfset myArray2 = ListToArray(grdvaluelist,",")>
			<cfset myArray3 = ListToArray(bgrdcolumnlist,",")>
			<cfset myArray4 = ListToArray(oldgrdvaluelist,",")>
			
			<cfquery name="checkexist" datasource="#dts#">
				select * from igrade
				where type='#tran#' 
				and refno='#nexttranno#' 
				and itemno='#form.itemno#' 
				and trancode='#itemcount#'
			</cfquery>
	
			<cfif checkexist.recordcount eq 0>
				<cfquery name="insert" datasource="#dts#">
					insert into igrade
					(type,refno,itemno,trancode,sign)
					values
					('#tran#','#nexttranno#','#form.itemno#','#itemcount#',<cfif tran eq "RC" or tran eq "PO" or tran eq "CN" or tran eq "OAI">'1'<cfelse>'-1'</cfif>)
				</cfquery>
			</cfif>
	
			<cfquery name="updateigrade" datasource="#dts#">
				update igrade
				set wos_date=#getartran.wos_date#,
				fperiod='#numberformat(readperiod,"00")#',
				location ='#form.location#',
				custno='#form.custno#',
				<cfloop from="1" to="#form.totalrecord#" index="i">
					<cfif i neq form.totalrecord>
						#myArray[i]# = #myArray2[i]#,
					<cfelse>
						#myArray[i]# = #myArray2[i]#
					</cfif>
				</cfloop>
				where type='#tran#' 
				and refno='#nexttranno#' 
				and itemno='#form.itemno#' 
				and trancode='#itemcount#'
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
		
				<cfquery name="updateitemgrd" datasource="#dts#">
					update itemgrd
					set
					<cfloop from="1" to="#form.totalrecord#" index="i">
						<cfif i neq form.totalrecord>
							#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray4[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>#myArray2[i]#,
						<cfelse>
							#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray4[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>#myArray2[i]#
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
			
				<cfif form.oldlocation eq form.location>	<!--- If the Old Location is same with the New Location --->
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#form.totalrecord#" index="i">
							<cfif i neq form.totalrecord>
								#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray4[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>#myArray2[i]#,
							<cfelse>
								#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray4[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and location = <cfqueryparam cfsqltype="cf_sql_char" value="#form.location#">
					</cfquery>
				<cfelse>
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#form.totalrecord#" index="i">
							<cfif i neq form.totalrecord>
								#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>#myArray2[i]#,
							<cfelse>
								#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and location = <cfqueryparam cfsqltype="cf_sql_char" value="#form.location#">
					</cfquery>
				
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#form.totalrecord#" index="i">
							<cfif i neq form.totalrecord>
								#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray4[i]#,
							<cfelse>
								#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>#myArray4[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and location = <cfqueryparam cfsqltype="cf_sql_char" value="#form.oldlocation#">
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		
	<cfelse><!---  Edit when Tran eq TR --->
		
			
		<cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set QIN#(readperiod+10)#=(QIN#(readperiod+10)#+(#qty#-#batchqty#)),QOUT#(readperiod+10)#=(QOUT#(readperiod+10)#+(#qty#-#batchqty#))
			where itemno = '#listfirst(itemno)#'
		</cfquery>
		
		<cfif form.grdcolumnlist neq "">
			<cfset grdcolumnlist = form.grdcolumnlist>
			<cfset grdvaluelist = form.grdvaluelist>
			<cfset bgrdcolumnlist = form.bgrdcolumnlist>
			<cfset oldgrdvaluelist = form.oldgrdvaluelist>
	
			<cfset myArray = ListToArray(grdcolumnlist,",")>
			<cfset myArray2 = ListToArray(grdvaluelist,",")>
			<cfset myArray3 = ListToArray(bgrdcolumnlist,",")>
			<cfset myArray4 = ListToArray(oldgrdvaluelist,",")>
			
			<cfquery name="checkexist" datasource="#dts#">
				select * from igrade
				where type='TRIN' 
				and refno='#nexttranno#' 
				and itemno='#form.itemno#' 
				and trancode='#itemcount#'
			</cfquery>
	
			<cfif checkexist.recordcount eq 0>
				<cfquery name="insert" datasource="#dts#">
					insert into igrade
					(type,refno,itemno,trancode,sign)
					values
					('TRIN','#nexttranno#','#form.itemno#','#itemcount#','1')
				</cfquery>
				
				<cfquery name="insert" datasource="#dts#">
					insert into igrade
					(type,refno,itemno,trancode,sign)
					values
					('TROU','#nexttranno#','#form.itemno#','#itemcount#','-1')
				</cfquery>
			</cfif>
	
			<cfquery name="updateigrade" datasource="#dts#">
				update igrade
				set wos_date=#getartran.wos_date#,
				fperiod='#numberformat(readperiod,"00")#',
				location ='#listfirst(form.trto)#',
				custno='#form.custno#',
				<cfloop from="1" to="#form.totalrecord#" index="i">
					<cfif i neq form.totalrecord>
						#myArray[i]# = #myArray2[i]#,
					<cfelse>
						#myArray[i]# = #myArray2[i]#
					</cfif>
				</cfloop>
				where type='TRIN' 
				and refno='#nexttranno#' 
				and itemno='#form.itemno#' 
				and trancode='#itemcount#'
			</cfquery>
			
			<cfquery name="updateigrade2" datasource="#dts#">
				update igrade
				set wos_date=#getartran.wos_date#,
				fperiod='#numberformat(readperiod,"00")#',
				location ='#listfirst(form.trfrom)#',
				custno='#form.custno#',
				<cfloop from="1" to="#form.totalrecord#" index="i">
					<cfif i neq form.totalrecord>
						#myArray[i]# = #myArray2[i]#,
					<cfelse>
						#myArray[i]# = #myArray2[i]#
					</cfif>
				</cfloop>
				where type='TROU' 
				and refno='#nexttranno#' 
				and itemno='#form.itemno#' 
				and trancode='#itemcount#'
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
				
				<cfquery name="checkexist1" datasource="#dts#">
					select * from logrdob
					where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
					and location = '#listfirst(form.trto)#'
				</cfquery>
				
				<cfquery name="checkexist4" datasource="#dts#">
					select * from logrdob
					where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
					and location = '#listfirst(form.trfrom)#'
				</cfquery>
		
				<cfif checkexist1.recordcount eq 0>
					<cfquery name="insert" datasource="#dts#">
						insert into logrdob 
						(itemno,location)
						values
						(<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
						'#listfirst(form.trto)#')
					</cfquery>
				</cfif>
				
				<cfif checkexist4.recordcount eq 0>
					<cfquery name="insert" datasource="#dts#">
						insert into logrdob 
						(itemno,location)
						values
						(<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
						'#listfirst(form.trfrom)#')
					</cfquery>
				</cfif>
			
				<cfif listfirst(form.oldtrto) eq listfirst(form.trto)>	<!--- If the Old Location is same with the New Location --->
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#form.totalrecord#" index="i">
							<cfif i neq form.totalrecord>
								#myArray3[i]# = #myArray3[i]#-#myArray4[i]#+#myArray2[i]#,
							<cfelse>
								#myArray3[i]# = #myArray3[i]#-#myArray4[i]#+#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and location = '#listfirst(form.trto)#'
					</cfquery>
				<cfelse>
					<cfquery name="checkexist3" datasource="#dts#">
						select * from logrdob
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and location = '#listfirst(form.oldtrto)#'
					</cfquery>
					
					<cfif checkexist3.recordcount eq 0>
						<cfquery name="insert" datasource="#dts#">
							insert into logrdob 
							(itemno,location)
							values
							(<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
							'#listfirst(form.oldtrto)#')
						</cfquery>
					</cfif>
				
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#form.totalrecord#" index="i">
							<cfif i neq form.totalrecord>
								#myArray3[i]# = #myArray3[i]#+#myArray2[i]#,
							<cfelse>
								#myArray3[i]# = #myArray3[i]#+#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and location = '#listfirst(form.trto)#'
					</cfquery>
				
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#form.totalrecord#" index="i">
							<cfif i neq form.totalrecord>
								#myArray3[i]# = #myArray3[i]#-#myArray4[i]#,
							<cfelse>
								#myArray3[i]# = #myArray3[i]#-#myArray4[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and location = '#listfirst(form.oldtrto)#'
					</cfquery>
				</cfif>
				
				<cfif listfirst(form.oldtrfrom) eq listfirst(form.trfrom)>	<!--- If the Old Location is same with the New Location --->
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#form.totalrecord#" index="i">
							<cfif i neq form.totalrecord>
								#myArray3[i]# = #myArray3[i]#+#myArray4[i]#-#myArray2[i]#,
							<cfelse>
								#myArray3[i]# = #myArray3[i]#+#myArray4[i]#-#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and location = '#listfirst(form.trfrom)#'
					</cfquery>
				<cfelse>
					<cfquery name="checkexist5" datasource="#dts#">
						select * from logrdob
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and location = '#listfirst(form.oldtrfrom)#'
					</cfquery>
					
					<cfif checkexist5.recordcount eq 0>
						<cfquery name="insert" datasource="#dts#">
							insert into logrdob 
							(itemno,location)
							values
							(<cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">,
							'#listfirst(form.oldtrfrom)#')
						</cfquery>
					</cfif>
					
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#form.totalrecord#" index="i">
							<cfif i neq form.totalrecord>
								#myArray3[i]# = #myArray3[i]#-#myArray2[i]#,
							<cfelse>
								#myArray3[i]# = #myArray3[i]#-#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and location = '#listfirst(form.trfrom)#'
					</cfquery>
				
					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#form.totalrecord#" index="i">
							<cfif i neq form.totalrecord>
								#myArray3[i]# = #myArray3[i]#+#myArray4[i]#,
							<cfelse>
								#myArray3[i]# = #myArray3[i]#+#myArray4[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
						and location = '#listfirst(form.oldtrfrom)#'
					</cfquery>
				</cfif>
				
			</cfif>
		</cfif>
	</cfif>
	
	<cfif listfirst(tran) eq 'TR'>
		<cfquery datasource='#dts#' name="updateartran">
			Update ictran set fperiod='#numberformat(form.readperiod,"00")#', location ='#listfirst(form.trto)#', custno='#form.custno#', desp = '#form.desp#',
			despa = '#form.despa#', dispec1 = '#form.dispec1#', dispec2 = '#form.dispec2#', dispec3 = '#form.dispec3#', 
			taxpec1 = '#form.taxpec1#', qty_bil ='#form.qty#', price_bil ='#val(form.price)#',
			amt1_bil= '#amt1_bil#', disamt_bil ='#disamt_bil#', amt_bil='#amt_bil#', taxamt_bil ='#taxamt_bil#', 
			qty = '#form.qty#', price = '#xprice#', amt1 = '#amt1#', disamt = '#disamt#',
			amt = '#amt#', taxamt = '#taxamt#', name = '#getartran.name#', sodate='#sodate#', dodate='#dodate#',
			adtcost1='#val(adtcost1)#', adtcost2='#val(adtcost2)#', batchcode=<cfif checkcustom.customcompany eq "Y">'#form.batchcode2#'<cfelse>'#enterbatch#'</cfif>,
			expdate='#expdate#',mc1_bil='#val(mc1bil)#', mc2_bil='#val(mc2bil)#',defective='#defective#',
			source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
			job=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
			comment=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.comment#">,
			brem1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem1#">,
			brem2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem2#">,
			brem3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem3#">,
			brem4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem4#">
			<cfif checkcustom.customcompany eq "Y">
				,brem5='#form.hremark5#',brem6='#form.bremark6#',brem7='#form.hremark6#'
			</cfif>
			where refno = '#nexttranno#' and itemno = '#form.itemno#' and type = 'TRIN' and itemcount = '#itemcount#' and consignment='#listfirst(form.consignment)#'
		</cfquery>
		
		<cfquery datasource='#dts#' name="updateartran">
			Update ictran set fperiod='#numberformat(form.readperiod,"00")#', location ='#listfirst(form.trfrom)#', custno='#form.custno#', desp = '#form.desp#',
			despa = '#form.despa#', dispec1 = '#form.dispec1#', dispec2 = '#form.dispec2#', dispec3 = '#form.dispec3#', 
			taxpec1 = '#form.taxpec1#', qty_bil ='#form.qty#', price_bil ='#val(form.price)#',
			amt1_bil= '#amt1_bil#', disamt_bil ='#disamt_bil#', amt_bil='#amt_bil#', taxamt_bil ='#taxamt_bil#', 
			qty = '#form.qty#', price = '#xprice#', amt1 = '#amt1#', disamt = '#disamt#',
			amt = '#amt#', taxamt = '#taxamt#', name = '#getartran.name#', sodate='#sodate#', dodate='#dodate#',
			adtcost1='#val(adtcost1)#', adtcost2='#val(adtcost2)#', batchcode='#enterbatch#',expdate='#expdate#',
			mc1_bil='#val(mc1bil)#', mc2_bil='#val(mc2bil)#',defective='#defective#',
			source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
			job=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
			comment=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.comment#">,
			brem1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem1#">,
			brem2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem2#">,
			brem3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem3#">,
			brem4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem4#">
			<cfif checkcustom.customcompany eq "Y">
				,brem5='#form.bremark5#',brem6='#form.bremark6#',brem7='#form.bremark7#',brem8='#form.bremark8#'
				,brem9='#form.bremark9#',brem10='#form.bremark10#'
			</cfif>
			where refno = '#nexttranno#' and itemno = '#form.itemno#' and type = 'TROU' and itemcount = '#itemcount#' and consignment='#listfirst(form.consignment)#'
		</cfquery>
	<cfelse>
		<cfquery datasource='#dts#' name="updateartran">
			Update ictran set fperiod='#numberformat(form.readperiod,"00")#', location ='#form.location#', custno='#form.custno#', desp = '#form.desp#',
			despa = '#form.despa#', dispec1 = '#form.dispec1#', dispec2 = '#form.dispec2#', dispec3 = '#form.dispec3#', 
			taxpec1 = '#form.taxpec1#', qty_bil ='#form.qty#', price_bil ='#val(form.price)#',
			amt1_bil= '#amt1_bil#', disamt_bil ='#disamt_bil#', amt_bil='#amt_bil#', taxamt_bil ='#taxamt_bil#', 
			qty = '#form.qty#', price = '#xprice#', amt1 = '#amt1#', disamt = '#disamt#',
			amt = '#amt#', taxamt = '#taxamt#', name = '#getartran.name#', sodate='#sodate#',dodate= '#dodate#', 
			adtcost1='#val(adtcost1)#', adtcost2='#val(adtcost2)#',	batchcode='#enterbatch#' , expdate='#expdate#',
			mc1_bil='#val(mc1bil)#' , mc2_bil='#val(mc2bil)#',defective='#defective#',trdatetime=#createdatetime(year(now()),month(now()),day(now()),hour(now()),minute(now()),second(now()))#,
			source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
			job=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
			comment=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.comment#">,
			brem1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem1#">,
			brem2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem2#">,
			brem3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem3#">,
			brem4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brem4#">
			<cfif checkcustom.customcompany eq "Y">
				,brem5='#form.hremark5#',brem7='#form.hremark6#',brem8='#form.bremark8#',brem9='#form.bremark9#',brem10='#form.bremark10#'
			</cfif>
			where refno = '#nexttranno#' and itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#"> and type = '#tran#' and itemcount = '#itemcount#'
		</cfquery>
	</cfif>
	
	<cfset status = "Item Edited Successfully">
</cfif>	

<cfoutput>

<cfif getitem.wserialno eq "T" and (tran eq 'OAI' or tran eq 'OAR' or tran eq 'ISS')>
	<cfinvoke component="cfc.Date" method="getDbDate3" inputDate="#form.nDateCreate#" returnvariable="cfc_nDateCreate"/>
	<form name="done" action="serial.cfm" method="post">
	<cfif form.mode neq "Add">
		<input type="hidden" name="itemcount" value="#listfirst(itemcount)#">
	<cfelse>
		<input type="hidden" name="itemcount" value="#listfirst(itemcnt)#">
	</cfif>
    <input type="hidden" name="consignment" value="#listfirst(consignment)#">
	<input type="hidden" name="tran" value="#listfirst(tran)#">
	<input type="hidden" name="currrate" value="1">
	<input type="hidden" name="agenno" value="#listfirst(agenno)#">
	<input type="hidden" name="type" value="#listfirst(mode)#">
	<input type="hidden" name="nexttranno" value="#listfirst(nexttranno)#">
	<input type="hidden" name="custno" value="#listfirst(form.custno)#">
	<input type="hidden" name="readperiod" value="#listfirst(form.readperiod)#">
	<input type="hidden" name="nDateCreate" value="#cfc_nDateCreate#">
	<input type="hidden" name="itemno" value="#convertquote(listfirst(form.itemno))#">
	<input type="hidden" name="qty" value="#listfirst(form.qty)#">
	<input type="hidden" name="location" value="#listfirst(form.location)#">
	<input type="hidden" name="invoicedate" value="#dateformat(form.invoicedate,"dd/mm/yyyy")#">
	<input type="hidden" name="price" value="#form.price#">
	
	<input type="hidden" name="status" value="#status#">
	<input type="hidden" name="name" value="#getartran.name#">
	<!--- Add on 260808 --->
	<input type="hidden" name="hmode" value="#listfirst(hmode)#">
	<!--- ADD ON 31-03-2009 --->
	<cfif checkcustom.customcompany eq "Y">
		<input type="hidden" name="remark5" value="#listfirst(hremark5)#">
		<input type="hidden" name="remark6" value="#listfirst(hremark6)#">
	</cfif>
<cfelseif getitem.wserialno eq "T" and (listfirst(tran) eq 'TR')>
	<form name="done" action="../transaction/iss_serial.cfm" method="post">
    <input type="hidden" name="consignment" value="#listfirst(consignment)#">
		<cfif listfirst(tran) eq 'TR'>
			<input type="hidden" name="trfrom" value="#listfirst(trfrom)#">
			<input type="hidden" name="trto" value="#listfirst(trto)#">
			<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
			<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
			<input type="hidden" name="ttran" value="#listfirst(ttran)#">
		</cfif>
        <cfif form.mode neq "Add">
            <input type="hidden" name="itemcount" value="#listfirst(itemcount)#">
        <cfelse>
            <input type="hidden" name="itemcount" value="#listfirst(itemcnt)#">
        </cfif>
        <input type="hidden" name="itemno" value="#convertquote(listfirst(form.itemno))#">
        <input type="hidden" name="qty" value="#listfirst(form.qty)#">
		<input type="hidden" name="tran" value="#listfirst(tran)#">
		<input type="hidden" name="status" value="#status#">
		<input type="hidden" name="type" value="Inprogress">				
		<input type="hidden" name="nexttranno" value="#nexttranno#">
		<input type="hidden" name="agenno" value="#listfirst(form.agenno)#">
		<input type="hidden" name="custno" value="#form.custno#">
		<input type="hidden" name="name" value="#getartran.name#">
		<input type="hidden" name="readperiod" value="#form.readperiod#">
		<input type="hidden" name="nDateCreate" value="#form.nDateCreate#">
		<input type="hidden" name="invoicedate" value="#dateformat(form.invoicedate,"dd/mm/yyyy")#">
		<!--- Add on 260808 --->
		<input type="hidden" name="hmode" value="#listfirst(hmode)#">
		<!--- ADD ON 31-03-2009 --->
		<cfif checkcustom.customcompany eq "Y">
			<input type="hidden" name="remark5" value="#listfirst(hremark5)#">
			<input type="hidden" name="remark6" value="#listfirst(hremark6)#">
		</cfif>
	</form>
<cfelse>
	<form name="done" action="../transaction/iss3.cfm?complete=complete" method="post">
		<cfif listfirst(tran) eq 'TR'>
			<input type="hidden" name="trfrom" value="#listfirst(trfrom)#">
			<input type="hidden" name="trto" value="#listfirst(trto)#">
			<input type="hidden" name="oldtrfrom" value="#listfirst(oldtrfrom)#">
			<input type="hidden" name="oldtrto" value="#listfirst(oldtrto)#">
			<input type="hidden" name="ttran" value="#listfirst(ttran)#">
            <input type="hidden" name="consignment" value="#listfirst(consignment)#">
		</cfif>
		<input type="hidden" name="tran" value="#listfirst(tran)#">
		<input type="hidden" name="status" value="#status#">
		<input type="hidden" name="type" value="Inprogress">				
		<input type="hidden" name="nexttranno" value="#nexttranno#">
		<input type="hidden" name="agenno" value="#listfirst(form.agenno)#">
		<input type="hidden" name="custno" value="#form.custno#">
		<input type="hidden" name="name" value="#getartran.name#">
		<input type="hidden" name="readperiod" value="#form.readperiod#">
		<input type="hidden" name="nDateCreate" value="#form.nDateCreate#">
		<input type="hidden" name="invoicedate" value="#dateformat(form.invoicedate,"dd/mm/yyyy")#">
		<!--- Add on 260808 --->
		<input type="hidden" name="hmode" value="#listfirst(hmode)#">
		<!--- ADD ON 31-03-2009 --->
		<cfif checkcustom.customcompany eq "Y">
			<input type="hidden" name="remark5" value="#listfirst(hremark5)#">
			<input type="hidden" name="remark6" value="#listfirst(hremark6)#">
		</cfif>
	</form>
</cfif>
</cfoutput> 

<script>done.submit();</script>