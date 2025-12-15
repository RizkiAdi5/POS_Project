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

<cfquery datasource="#dts#" name="getcust">
	select 
	name,
	van,
	wos_date,
    rem5
	from artran 
	where type='#tran#' 
	and refno='#nexttranno#';
</cfquery>

<cfquery datasource="#dts#" name="gettime">
	select 
	trdatetime 
	from ictran 
	where type='#tran#' 
	and refno='#nexttranno#' 
	and itemno='#form.itemno#'
	and itemcount='#itemcount#';
</cfquery>

<cfif tran eq "RC" or tran eq "OAI" or tran eq "CN">
	<cfset obtype= "bth_qin">
<cfelse>
	<cfset obtype= "bth_qut">
</cfif>

<cfif trim(listfirst(enterbatch)) neq ""><!--- Enterbatch neq Empty --->
	<cfif listfirst(enterbatch) eq listfirst(oldenterbatch)><!--- Enterbatch eq Oldenterbatch --->
		<!--- <cfquery name="updatelobthob" datasource="#dts#">
			update obbatch set 
			#obtype#=(#obtype#+(#qty#-#oldqty#))
			where itemno='#form.itemno#' 
			and batchcode='#form.enterbatch#';
		</cfquery> --->
		<cfquery name="updatelobthob" datasource="#dts#">
			update obbatch set 
			#obtype#=(#obtype#+(#act_qty#-#oldqty#))
			where itemno='#form.itemno#' 
			and batchcode='#form.enterbatch#';
		</cfquery>
		
		<cfif listfirst(location) neq ""><!--- Location neq Empty --->
			<cfif listfirst(location) eq listfirst(oldlocation)><!--- Location eq Oldlocation --->
				<!--- <cfquery name="updatelobthob" datasource="#dts#">
					update lobthob set 
					#obtype#=(#obtype#+(#qty#-#oldqty#)) 
					where location='#listfirst(location)#' 
					and itemno='#itemno#' 
					and batchcode='#listfirst(enterbatch)#';
				</cfquery> --->
				<cfquery name="updatelobthob" datasource="#dts#">
					update lobthob set 
					#obtype#=(#obtype#+(#act_qty#-#oldqty#)) 
					where location='#listfirst(location)#' 
					and itemno='#itemno#' 
					and batchcode='#listfirst(enterbatch)#';
				</cfquery>
			<cfelse><!--- Location neq Oldlocation --->
				<cfquery name="checklocationbatch" datasource="#dts#">
					select 
					batchcode 
					from lobthob 
					where location='#listfirst(location)#' 
					and batchcode='#listfirst(enterbatch)#' 
					and itemno='#itemno#';
				</cfquery>
					
				<cfif checklocationbatch.recordcount eq 0>
					<!--- <cfquery name="insertbatch" datasource="#dts#">
						insert into lobthob 
						values 
						(
							'#listfirst(location)#',
							'#listfirst(enterbatch)#',
							'#itemno#',
							'#form.tran#',
							'#form.nexttranno#',
							'0',
							'<cfif obtype eq "bth_qin">#qty#<cfelse>0</cfif>',
							'<cfif obtype eq "bth_qut">#qty#<cfelse>0</cfif>',
							'0',
							'0',
							'0',
							'#dateformat(expdate,"yyyy-mm-dd")#',
							'#form.tran#',
							'#form.nexttranno#',
							'#dateformat(expdate,"yyyy-mm-dd")#'
						);
					</cfquery> --->
					<cfquery name="insertbatch" datasource="#dts#">
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
							'#listfirst(location)#',
							'#listfirst(enterbatch)#',
							'#itemno#',
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
					
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#-#oldqty#) 
						where location='#listfirst(oldlocation)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(enterbatch)#';
					</cfquery>
				<cfelse>
					<!--- <cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#+#qty#)
						where location='#listfirst(location)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(enterbatch)#';
					</cfquery> --->
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#+#act_qty#)
						where location='#listfirst(location)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(enterbatch)#';
					</cfquery>
					
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#-#oldqty#) 
						where location='#listfirst(oldlocation)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(enterbatch)#';
					</cfquery>
				</cfif>					
			</cfif>
		<cfelse><!--- Location eq Empty --->
			<cfquery name="updatelobthob" datasource="#dts#">
				update lobthob set 
				#obtype#=(#obtype#-#oldqty#)
				where location='#listfirst(oldlocation)#' 
				and itemno='#itemno#' 
				and batchcode='#listfirst(enterbatch)#';
			</cfquery>
		</cfif>
	<cfelse><!--- Enterbatch neq Oldenterbatch --->
		<cfquery name="checkbatch" datasource="#dts#">
			select batchcode 
			from obbatch 
			where batchcode='#listfirst(enterbatch)#' 
			and itemno='#itemno#';
		</cfquery>
		
		<cfif checkbatch.recordcount eq 0>
			<!--- <cfquery name="insertbatch" datasource="#dts#">
				insert into obbatch 
				values 
				(
					'#listfirst(enterbatch)#',
					'#itemno#',
					'#form.tran#',
					'#form.nexttranno#',
					'0',
					'<cfif obtype eq "bth_qin">#qty#<cfelse>0</cfif>',
					'<cfif obtype eq "bth_qut">#qty#<cfelse>0</cfif>',
					'0',
					'0',
					'0',
					'#dateformat(expdate,"yyyy-mm-dd")#',
					'#form.tran#',
					'#form.nexttranno#',
					'#dateformat(expdate,"yyyy-mm-dd")#'
				);
			</cfquery> --->
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
					'#listfirst(enterbatch)#',
					'#itemno#',
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
			
			<cfquery name="updateobbatch" datasource="#dts#">
				update obbatch set 
				#obtype#=(#obtype#-#oldqty#) 
				where batchcode='#listfirst(oldenterbatch)#' 
				and itemno='#itemno#';
			</cfquery>
		<cfelse>
			<!--- <cfquery name="updateobbatch" datasource="#dts#">
				update obbatch set 
				#obtype#=(#obtype#+#qty#) 
				where batchcode='#listfirst(enterbatch)#' 
				and itemno='#itemno#';
			</cfquery> --->
			<cfquery name="updateobbatch" datasource="#dts#">
				update obbatch set 
				#obtype#=(#obtype#+#act_qty#) 
				where batchcode='#listfirst(enterbatch)#' 
				and itemno='#itemno#';
			</cfquery>
			
			<cfquery name="updateobbatch" datasource="#dts#">
				update obbatch set 
				#obtype#=(#obtype#-#oldqty#) 
				where batchcode='#listfirst(oldenterbatch)#' 
				and itemno='#itemno#';
			</cfquery>
		</cfif>

		<cfif listfirst(location) neq ""><!--- Location neq Empty --->
			<cfquery name="checklocationbatch" datasource="#dts#">
				select 
				batchcode 
				from lobthob 
				where location='#listfirst(location)#' 
				and batchcode='#listfirst(enterbatch)#' 
				and itemno='#itemno#';
			</cfquery>
			
			<cfif listfirst(location) eq listfirst(oldlocation)><!--- Location eq Oldlocation --->					
				<cfif checklocationbatch.recordcount eq 0>
					<!--- <cfquery name="insertbatch" datasource="#dts#">
						insert into lobthob 
						values 
						(
							'#listfirst(location)#',
							'#listfirst(enterbatch)#',
							'#itemno#',
							'#form.tran#',
							'#form.nexttranno#',
							'0',
							'<cfif obtype eq "bth_qin">#qty#<cfelse>0</cfif>',
							'<cfif obtype eq "bth_qut">#qty#<cfelse>0</cfif>',
							'0',
							'0',
							'0',
							'#dateformat(expdate,"yyyy-mm-dd")#',
							'#form.tran#',
							'#form.nexttranno#',
							'#dateformat(expdate,"yyyy-mm-dd")#'
						);
					</cfquery> --->
					<cfquery name="insertbatch" datasource="#dts#">
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
							'#listfirst(location)#',
							'#listfirst(enterbatch)#',
							'#itemno#',
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
					
					<!--- ADD ON 21-04-2009 --->
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#-#oldqty#) 
						where batchcode='#listfirst(oldenterbatch)#'
						and location='#listfirst(oldlocation)#' 
						and itemno='#itemno#';
					</cfquery>
				<cfelse>
					<!--- <cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#+(#qty#-#oldqty#))
						where location='#listfirst(location)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(enterbatch)#';
					</cfquery> --->
					<!--- <cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#+(#act_qty#-#oldqty#))
						where location='#listfirst(location)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(enterbatch)#';
					</cfquery> REMARK ON 21-04-2009 AND REPLACE WITH THE BELOW ONE --->
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#+(#act_qty#))
						where location='#listfirst(location)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(enterbatch)#';
					</cfquery>
					
					<!--- ADD ON 21-04-2009 --->
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#-#oldqty#) 
						where batchcode='#listfirst(oldenterbatch)#'
						and location='#listfirst(oldlocation)#' 
						and itemno='#itemno#';
					</cfquery>
				</cfif>
			<cfelse><!--- Location neq Oldlocation --->
				<cfif checklocationbatch.recordcount eq 0>
					<!--- <cfquery name="insertbatch" datasource="#dts#">
						insert into lobthob 
						values 
						(
							'#listfirst(location)#',
							'#listfirst(enterbatch)#',
							'#itemno#',
							'#form.tran#',
							'#form.nexttranno#',
							'0',
							'<cfif obtype eq "bth_qin">#qty#<cfelse>0</cfif>',
							'<cfif obtype eq "bth_qut">#qty#<cfelse>0</cfif>',
							'0',
							'0',
							'0',
							'#dateformat(expdate,"yyyy-mm-dd")#',
							'#form.tran#',
							'#form.nexttranno#',
							'#dateformat(expdate,"yyyy-mm-dd")#'
						);
					</cfquery> --->
					<cfquery name="insertbatch" datasource="#dts#">
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
							'#listfirst(location)#',
							'#listfirst(enterbatch)#',
							'#itemno#',
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
					
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#-#oldqty#)
						where location='#listfirst(oldlocation)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(oldenterbatch)#';
					</cfquery>
				<cfelse>
					<!--- <cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#+(#qty#-#oldqty#))
						where location='#listfirst(location)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(enterbatch)#';
					</cfquery> --->
					<!--- <cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#+(#act_qty#-#oldqty#))
						where location='#listfirst(location)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(enterbatch)#';
					</cfquery> REMARK ON 21-04-2009 AND REPLACE WITH THE BELOW ONE --->
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#+(#act_qty#))
						where location='#listfirst(location)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(enterbatch)#';
					</cfquery>
					
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set 
						#obtype#=(#obtype#-#oldqty#)
						where location='#listfirst(oldlocation)#' 
						and itemno='#itemno#' 
						and batchcode='#listfirst(oldenterbatch)#';
					</cfquery>
				</cfif>
			</cfif>
		<cfelse><!--- Location eq Empty --->						
			<cfquery name="updatelobthob" datasource="#dts#">
				update lobthob set 
				#obtype#=(#obtype#-#oldqty#)
				where location='#listfirst(oldlocation)#' 
				and itemno='#itemno#' 
				and batchcode='#listfirst(enterbatch)#';
			</cfquery>
		</cfif>
	</cfif>
<cfelse><!--- Enterbatch eq Empty --->
	<cfif listfirst(oldenterbatch) neq "">
		<cfquery name="updatelobthob" datasource="#dts#">
			update obbatch set 
			#obtype#=(#obtype#-#oldqty#) 
			where itemno='#listfirst(itemno)#' 
			and batchcode='#listfirst(oldenterbatch)#';
		</cfquery>
				
		<cfquery name="updatelobthob" datasource="#dts#">
			update lobthob set 
			#obtype#=(#obtype#-#oldqty#) 
			where location='#oldlocation#' 
			and itemno='#listfirst(itemno)#' 
			and batchcode='#listfirst(oldenterbatch)#';
		</cfquery>
	</cfif>
</cfif>

<cfif lcase(HUserID) neq "kellysteel2">
	<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
		<cfif tran eq "OAI" or tran eq "RC" or tran eq "DN">
			<cfset qname='QIN'&(readperiod+10)>
		<cfelse>
			<cfset qname='QOUT'&(readperiod+10)>
		</cfif>
	
		<cfquery name="checkitemqty" datasource="#dts#">
			select 
			itemno 
			from icitem 
			where itemno='#form.itemno#' 
			and #qname# <> 0
		</cfquery>
		
		<cfif checkitemqty.recordcount eq 0>
			<cfset check = "y">
		<cfelse>
			<cfset check = "n">
		</cfif>
			
		<!--- <cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set 
			#qname#=<cfif check eq "y">(#qname#+#qty#)<cfelse>(#qname#+(#qty#-#oldqty#))</cfif> 
			where itemno='#itemno#';
		</cfquery> --->
		<cfquery name="UpdateIcitem" datasource="#dts#">
			update icitem set 
			#qname#=<cfif check eq "y">(#qname#+#act_qty#)<cfelse>(#qname#+(#act_qty#-#oldqty#))</cfif> 
			where itemno='#itemno#';
		</cfquery>
	</cfif>
</cfif>

<cfif form.grdcolumnlist neq "" and form.service eq "">
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
		<cfset oldfactor1 = 1>
		<cfset oldfactor2 = 1>
	<cfelse>
		<cfset oldfactor1 = checkexist.factor1>
		<cfset oldfactor2 = checkexist.factor2>
	</cfif>
	
	<!--- <cfquery name="updateigrade" datasource="#dts#">
		update igrade
		set wos_date=#getcust.wos_date#,
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
	</cfquery> --->
	<cfquery name="updateigrade" datasource="#dts#">
		update igrade
		set wos_date=#getcust.wos_date#,
		fperiod='#numberformat(readperiod,"00")#',
		location ='#form.location#',
		custno='#form.custno#',
		factor1='#form.factor1#',
		factor2='#form.factor2#',
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
		
		<!--- <cfquery name="updateitemgrd" datasource="#dts#">
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
		</cfquery> --->
		<cfquery name="updateitemgrd" datasource="#dts#">
			update itemgrd
			set
			<cfloop from="1" to="#form.totalrecord#" index="i">
				<cfif i neq form.totalrecord>
					#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>
					<cfif val(oldfactor2) neq 0>
						(#myArray4[i]# * #oldfactor1# / #oldfactor2#)
					<cfelse>
						0
					</cfif>
					<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>
					<cfif val(form.factor2) neq 0>
						(#myArray2[i]# * #form.factor1# / #form.factor2#)
					<cfelse>
						0
					</cfif>,
				<cfelse>
					#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>
					<cfif val(oldfactor2) neq 0>
						(#myArray4[i]# * #oldfactor1# / #oldfactor2#)
					<cfelse>
						0
					</cfif>
					<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>
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
		
		<cfif oldlocation eq form.location>		<!--- Old location same with new location --->
			<!--- <cfquery name="updatelogrdob" datasource="#dts#">
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
			</cfquery> --->
			<cfquery name="updatelogrdob" datasource="#dts#">
				update logrdob
				set
				<cfloop from="1" to="#form.totalrecord#" index="i">
					<cfif i neq form.totalrecord>
						#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>
						<cfif val(oldfactor2) neq 0>
							(#myArray4[i]# * #oldfactor1# / #oldfactor2#)
						<cfelse>
							0
						</cfif>
						<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>
						<cfif val(form.factor2) neq 0>
							(#myArray2[i]# * #form.factor1# / #form.factor2#)
						<cfelse>
							0
						</cfif>,
					<cfelse>
						#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>
						<cfif val(oldfactor2) neq 0>
							(#myArray4[i]# * #oldfactor1# / #oldfactor2#)
						<cfelse>
							0
						</cfif>
						<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>
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
		<cfelse>
			<!--- <cfquery name="updatelogrdob" datasource="#dts#">
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
			</cfquery> --->
			<cfquery name="updatelogrdob" datasource="#dts#">
				update logrdob
				set
				<cfloop from="1" to="#form.totalrecord#" index="i">
					<cfif i neq form.totalrecord>
						#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>
						<cfif val(oldfactor2) neq 0>
							(#myArray4[i]# * #oldfactor1# / #oldfactor2#)
						<cfelse>
							0
						</cfif>,
					<cfelse>
						#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">-<cfelse>+</cfif>
						<cfif val(oldfactor2) neq 0>
							(#myArray4[i]# * #oldfactor1# / #oldfactor2#)
						<cfelse>
							0
						</cfif>
					</cfif>
				</cfloop>
				where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#form.itemno#">
				and location = <cfqueryparam cfsqltype="cf_sql_char" value="#form.oldlocation#">
			</cfquery>
			
			<!--- <cfquery name="updatelogrdob2" datasource="#dts#">
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
			</cfquery> --->
			<cfquery name="updatelogrdob2" datasource="#dts#">
				update logrdob
				set
				<cfloop from="1" to="#form.totalrecord#" index="i">
					<cfif i neq form.totalrecord>
						#myArray3[i]# = #myArray3[i]#<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">+<cfelse>-</cfif>
						<cfif val(form.factor2) neq 0>
							(#myArray2[i]# * #form.factor1# / #form.factor2#)
						<cfelse>
							0
						</cfif>,
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
</cfif>

<cfset xtime = right(gettime.trdatetime,10)>
<cfset xtime2 = timeformat(now(),"HH:MM:SS")>		
<cfset nowdatetime = dateformat(getcust.wos_date,"yyyy-mm-dd") & " " & xtime2>

<!---cfquery datasource="#dts#" name="updateartran">
	update ictran set 
	wos_date=#getcust.wos_date#,
	location ='#form.location#',
	custno='#form.custno#',
	desp='#jsstringformat(preservesinglequotes(form.desp))#',
	despa='#jsstringformat(preservesinglequotes(form.despa))#',
	currrate='#currrate#',
	fperiod='#numberformat(readperiod,"00")#',
	agenno='#form.agenno#',
	dispec1='#form.dispec1#',
	dispec2='#form.dispec2#',
	dispec3='#form.dispec3#',
	taxpec1='#form.taxpec1#',
	gltradac='#form.gltradac#',
	qty_bil='#form.qty#',
	price_bil='#form.price#',
	unit_bil='#form.unit#',
	amt1_bil='#amt1_bil#', 
	disamt_bil='#disamt_bil#',
	amt_bil='#val(amt_bil)#',
	taxamt_bil ='#taxamt_bil#',
	qty='#form.qty#',
	price='#xprice#',
	unit='#jsstringformat(preservesinglequotes(form.unit))#',
	amt1='#amt1#',
	disamt='#disamt#',
	amt='#val(amt)#',
	taxamt='#taxamt#',
	brem1='#form.requestdate#',
	brem2='#form.crequestdate#',
	brem3='#form.brem3#',
	brem4='<cfif ucase(form.brem4) eq "XCOST">XCOST<cfelse>#form.brem4#</cfif>',
	packing='#form.packing#',
	van='#getcust.van#',
	name='#getcust.name#',
	wos_group='#getitem.wos_group#',
	category='#getitem.category#',
	sv_part='#form.sv_part#',
	sercost='#form.sercost#',
	userid='#huserid#',
	trdatetime='#nowdatetime#',
	comment='#jsstringformat(preservesinglequotes(form.comment))#',
	sodate='#dateformat(sodate,"yyyy-mm-dd")#',
	dodate='#dateformat(dodate,"yyyy-mm-dd")#',
	adtcost1='#val(form.adtcost1)*currrate#',
	adtcost2='#val(form.adtcost2)*currrate#',
	batchcode='#form.enterbatch#',
	expdate='#dateformat(expdate,"yyyy-mm-dd")#',
	mc1_bil='#form.mc1bil#',
	mc2_bil='#form.mc2bil#',
	defective='#form.defective#',
	mc1_bil=mc1_bil,
	mc2_bil=mc2_bil,
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
	
	where type='#tran#' 
	and refno='#nexttranno#' 
	and itemno='#form.itemno#' 
	and itemcount='#itemcount#';
</cfquery--->		
<cftry>
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

    <cfquery datasource="#dts#" name="updateartran">
        update ictran set 
        wos_date=#getcust.wos_date#,
        location ='#form.location#',
        custno='#form.custno#',
        desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
        despa=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.despa#">,
        currrate='#currrate#',
        fperiod='#numberformat(readperiod,"00")#',
        agenno='#form.agenno#',
        dispec1='#val(form.dispec1)#',
        dispec2='#val(form.dispec2)#',
        dispec3='#val(form.dispec3)#',
        taxpec1='#form.taxpec1#',
        gltradac='#form.gltradac#',
        qty_bil='#form.qty#',
        price_bil='#form.price#',
        unit_bil='#form.unit#',
        amt1_bil='#amt1_bil#', 
        disamt_bil='#disamt_bil#',
        amt_bil='#val(amt_bil)#',
        taxamt_bil ='#taxamt_bil#',
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
        <cfelseif checkcustom.customcompany eq "Y">
            brem5='#form.hremark5#',
            brem7='#form.hremark6#',
            brem8='#form.bremark8#',
            brem9='#form.bremark9#',
            brem10='#form.bremark10#',
        </cfif>
        packing='#form.packing#',
        supp='#form.supp#',
        qty1='#val(form.qty1)#',
        qty2='#val(form.qty2)#',
        qty3='#val(form.qty3)#',
        qty4='#val(form.qty4)#',
        qty5='#val(form.qty5)#',
        qty6='#val(form.qty6)#',
        qty7='#val(form.qty7)#',
        van='#getcust.van#',
        name='#getcust.name#',
        wos_group='#getitem.wos_group#',
        category='#getitem.category#',
        sv_part='#form.sv_part#',
        sercost='#val(form.sercost)#',
        userid='#huserid#',
        trdatetime='#nowdatetime#',
        comment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#tostring(form.comment)#">,
        sodate='#sodate#',
        dodate='#dodate#',
        adtcost1='#val(form.adtcost1)*currrate#',
        adtcost2='#val(form.adtcost2)*currrate#',
        batchcode='#form.enterbatch#',
        expdate='#expdate#',
        manudate='#manudate#',
        milcert='#form.milcert#',
        importpermit='#form.importpermit#',
        mc1_bil='#form.mc1bil#',
        mc2_bil='#form.mc2bil#',
        defective='#form.defective#',
        nodisplay='#form.nodisplay#',
        title_id='#form.title_id#',
        title_desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(form.title_desp)#">,
		source=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">,
		job=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.job#">,
        <cfif lcase(hcomid) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i">title_despa=<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.title_despa#">,</cfif>
        mc1_bil=mc1_bil,
        mc2_bil=mc2_bil,
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
        <cfif isdefined('form.foc')>,foc="#form.foc#"</cfif>
        <cfif isdefined('form.asvoucher')>
        ,asvoucher="#form.asvoucher#"
        ,voucherno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.voucherno#"></cfif>
        <cfif isdefined('form.ictranfilename')>
            ,ictranfilename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ictranfilename#">
			</cfif>
        where type='#tran#' 
        and refno='#nexttranno#' 
        and itemno='#form.itemno#' 
        and itemcount='#itemcount#';
    </cfquery>
    
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
    	update artran set tax_bil='#val(gettax.tt_taxamt_bil)#' where type='#tran#' and refno='#nexttranno#'
    </cfquery>
</cfif>
<cfset status = "Item Edited Successfully">