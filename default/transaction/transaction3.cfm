<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2153,664,188,665,666,185,689,667,690,668,673,674,104,5,58,702,900,2060,189,274,438,1241,1106,1109,11,294,
1831,592,1294,1099,1102,1100,1101,1103,1297,1296,1298,2062,2117,2080,2081,2077,877,121,65,482,227,1096,1098,
1097,56,10,53,2148,805">
<cfinclude template="/latest/words.cfm">

<!--- <cfajaximport tags="cfform">
<cfajaximport tags="cfform">
<cfajaximport tags="CFINPUT-AUTOSUGGEST">  --->
<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<!--- UPDATE GSETUP2 UNIT COST STATUS --->
<cfif tran eq "RC">
	<cfinclude template = "transaction3_update_unit_cost_status.cfm">
</cfif>
<!--- UPDATE GSETUP2 UNIT COST STATUS --->

<cfset alcreate=0>
<cfset newtrancode=0>

<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>

<cfquery name="getdefault" datasource="#dts#">
SELECT dfpos FROM gsetup
</cfquery>

<cfquery name="gettermcondition" datasource="#dts#">
    select * from ictermandcondition
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
	select * from gsetup
</cfquery>
<cfif getgsetup.prefixbycustquo eq 'Y' or getgsetup.prefixbycustso eq 'Y' or getgsetup.prefixbycustinv eq 'Y'>
<cfif isdefined('form.custno')>
<cfquery name="getcustprefixno" datasource="#dts#">
	select arrem2,arrem3,arrem4 from #target_arcust# where custno='#form.custno#'
</cfquery>
</cfif>
</cfif>

<cfquery datasource="#dts#" name="gettranname">
	Select lRC,lPR,lDO,lINV,lCS,lCN,lDN,lPO,lQUO,lSO,lSAM

	from GSetup
</cfquery>

<cfswitch expression="#tran#">
	<cfcase value="RC">
		<cfset tran = 'RC'><cfset tranname = words[664]><cfset trancode = 'rcno'><cfset tranarun = 'rcarun'>
		<cfif getpin2.h2102 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
	<cfcase value="PR">
		<cfset tran = 'PR'><cfset tranname = words[188]><cfset trancode = 'prno'><cfset tranarun = 'prarun'>
		<cfif getpin2.h2201 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
	<cfcase value="DO">
		<cfset tran = 'DO'><cfset tranname = words[665]><cfset trancode = 'dono'><cfset tranarun = 'doarun'>
		<cfif getpin2.h2301 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
	<cfcase value="INV">
		<cfset tran = 'INV'><cfset tranname = words[666]>
		<cfif isdefined("form.invset")><cfset trancode = form.invset><cfset tranarun = form.tranarun>
  		<cfelse><cfset trancode = "invno"><cfset tranarun = "invarun">
  		</cfif>
  		<cfif getpin2.h2401 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
	<cfcase value="CS">
		<cfset tran = 'CS'><cfset tranname = words[185]><cfset trancode = 'csno'><cfset tranarun = 'csarun'>
		<cfif getpin2.h2501 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
	<cfcase value="CN">
		<cfset tran = 'CN'><cfset tranname = words[689]><cfset trancode = 'cnno'><cfset tranarun = 'cnarun'>
		<cfif getpin2.h2601 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
	<cfcase value="DN">
		<cfset tran = 'DN'><cfset tranname = words[667]><cfset trancode = 'dnno'><cfset tranarun = 'dnarun'>
		<cfif getpin2.h2701 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
	<cfcase value="PO">
		<cfset tran = 'PO'><cfset tranname = words[690]><cfset trancode = 'pono'><cfset tranarun = 'poarun'>
		<cfif getpin2.h2861 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
	<cfcase value="QUO">
		<cfset tran = 'QUO'><cfset tranname = words[668]><cfset trancode = 'quono'><cfset tranarun = 'quoarun'>
		<cfif getpin2.h2871 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
	<cfcase value="SO">
		<cfset tran = 'SO'><cfset tranname = words[673]><cfset trancode = 'sono'><cfset tranarun = 'soarun'>
		<cfif getpin2.h2881 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
	<cfcase value="SAM">
		<cfset tran = "SAM"><cfset tranname = words[674]><cfset trancode = "samno"><cfset tranarun = "samarun">
		<cfif getpin2.h2851 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
    <cfcase value="SAMM">
		<cfset tran = "SAMM"><cfset tranname = "Sales Order"><cfset trancode = "sammno"><cfset tranarun = "sammarun">
		<cfif getpin2.h2851 eq 'T'><cfset alcreate = 1></cfif>
	</cfcase>
</cfswitch>

<cfif isdefined("form.invoicedate")>
	<cfinvoke component="cfc.Date" method="getDbDate" inputDate="#form.invoicedate#" returnvariable="nDateCreate"/>
</cfif>

<cfif isdefined("form.transactiondate")>
	<cfinvoke component="cfc.Date" method="getDbDate" inputDate="#form.transactiondate#" returnvariable="ndatecreatetran"/>
</cfif>

<cfif isdefined('form.type') and isdefined("form.remark12")> <!--- from first page --->
	<!--- Add On 12-01-2010 --->
	<cfif form.type eq 'Create' and isdefined('session.tran_refno')>
    <cfset newformname = "transpage"&form.newuuid>
    <cfif IsDefined("session.#newformname#") and session[#newformname#] eq "transpage">
    <cfset StructDelete(Session, "#newformname#")>
	<cfelse>
    <cfoutput>
    <h1>Duplicate Submission Detected. Please do not press back button.</h1>
    <cfabort />
    </cfoutput>
    </cfif>
		<cfquery name="checkexistrefno" datasource="#dts#">
			select * from artran where type='#tran#' and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.tran_refno#">
		</cfquery>
		<cfif checkexistrefno.recordcount neq 0>
        <cfquery datasource="#dts#" name="getGeneralInfo">
				select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse
                from refnoset
				where type = '#tran#'
				and counter = <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
			</cfquery>
            <!---cust refno --->
            <cfif getgsetup.prefixbycustquo eq 'Y' and tran eq 'QUO' and getcustprefixno.arrem2 neq "">
  			<cfquery name="getcustrefno" datasource="#dts#">
			select arrem2 from #target_arcust# where custno ='#form.custno#'
  			</cfquery>
			<cfset getGeneralInfo.tranno=getcustrefno.arrem2>
			</cfif>

            <cfif getgsetup.prefixbycustso eq 'Y' and tran eq 'SO' and getcustprefixno.arrem3 neq "">
  			<cfquery name="getcustrefno" datasource="#dts#">
			select arrem3 from #target_arcust# where custno ='#form.custno#'
  			</cfquery>
			<cfset getGeneralInfo.tranno=getcustrefno.arrem3>
			</cfif>

            <cfif getgsetup.prefixbycustinv eq 'Y' and tran eq 'INV' and getcustprefixno.arrem4 neq "">
  			<cfquery name="getcustrefno" datasource="#dts#">
			select arrem4 from #target_arcust# where custno ='#form.custno#'
  			</cfquery>
			<cfset getGeneralInfo.tranno=getcustrefno.arrem4>
			</cfif>
            <!--- --->

         <cfif getGeneralInfo.arun eq "1">
        <cfset refnocheck = 0>
        <cfset refno1 = checkexistrefno.refno>
        <cfloop condition="refnocheck eq 0">
        <cftry>
        <cfinvoke component="cfc.IncrementValue" method="getIncreament" input="#refno1#" returnvariable="newnextNum"/>
		<cfcatch>
		<cfinvoke component="cfc.refno" method="processNum" oldNum="#refno1#" returnvariable="newnextNum" />
		</cfcatch>
        </cftry>
        <cfquery name="checkexistence" datasource="#dts#">
        SELECT refno FROM artran WHERE
        refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newnextNum#"> and type = '#tran#'
        </cfquery>
        <cfif checkexistence.recordcount eq 0>
        <cfset refnocheck = 1>
        <cfelse>
        <cfset refno1 = newnextNum>
		</cfif>
        </cfloop>
            <cfset form.currefno=newnextNum>
            <cfelse>
			<cfset form.type='Edit'>
			<cfset form.currefno=checkexistrefno.refno>
			</cfif>
		</cfif>
	</cfif>

	<cfif form.type eq 'Delete'>
		<cfif isdefined("form.keepDeleted")>	<!--- ADD ON 22-12-2009 --->
			<cfset keepDeleted="1">
			<cfset deleteStatus="Voided">
		<cfelse>
			<cfset keepDeleted="">
			<cfset deleteStatus="Deleted">
		</cfif>
		<cfset status = '#tranname# #deleteStatus# Successfully'>
		<!--- UNUPDATE --->
		<cfif isdefined("form.recover") and isdefined("form.related")>
			<cfquery datasource='#dts#' name='getitem'>
				select frtype,frrefno,frdate,frtrancode,itemno,qty from iclink where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfif getitem.recordcount gt 0>
				<cfloop query='getitem'>
					<cfif getitem.qty eq 0>
						<cfset itemqty = 0>
					<cfelse>
						<cfset itemqty = getitem.qty>
					</cfif>

					<cfquery datasource="#dts#" name="getship">
						select shipped from ictran where refno = '#frrefno#' and type = '#frtype#' and itemno = '#itemno#' and trancode = '#frtrancode#'
					</cfquery>

					<cfif getship.recordcount gt 0>
						<cfset oldshipped = getship.shipped>

						<cfif tran eq 'PO' or tran eq 'SAM'><!--- SO tp PO no minus shipped --->
							<cfset newshipped = oldshipped>
						<cfelse>
							<cfset newshipped = oldshipped - itemqty>
						</cfif>

						<cfquery datasource='#dts#' name='recoverictran'>
							update ictran set <cfif tran neq 'SAM'>toinv = '', exported = '', exported1 = '0000-00-00'<cfelse>exported2 = '', exported3 = '0000-00-00'</cfif>, shipped = '#newshipped#' where refno = '#getitem.frrefno#' and type = '#frtype#' and itemno = '#itemno#' and trancode = '#frtrancode#'
						</cfquery>

						<!--- Add On 071008, For Graded Item --->
						<cfquery name="recoverigrade" datasource="#dts#">
							update igrade set exported = '',generated=''
							where refno = '#getitem.frrefno#' and type = '#frtype#'
							and itemno = '#itemno#' and trancode = '#frtrancode#'
						</cfquery>
					</cfif>

					<cfif frtype eq "QUO" and (tran eq "INV" or tran eq "DO" or tran eq "SO" or tran eq "CS")>
						<cfquery datasource='#dts#' name='recoverartran'>
							update artran
							set toinv = '', generated='', order_cl = ''
							where refno = '#getitem.frrefno#' and type = '#frtype#'
						</cfquery>
					<cfelse>
						<cfquery datasource='#dts#' name='recoverartran'>
							update artran set <cfif tran neq 'SAM'>toinv = '', order_cl = '', exported = '', exported1 = '0000-00-00'<cfelse>exported2 = '', exported3 = '0000-00-00'</cfif> where refno = '#getitem.frrefno#' and type = '#frtype#'
						</cfquery>
					</cfif>
				 </cfloop>
			</cfif>

			<cfquery datasource='#dts#' name='deliclink'>
				delete from iclink where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfquery datasource='#dts#' name='deliclink'>
				delete from ictran where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>
		</cfif>

		<!--- <cfif lcase(HcomID) eq "avent_i" or lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "winbells_i" or lcase(HcomID) eq "iel_i"> --->
		<cftry>
			<cfquery datasource='#dts#' name='deleteartran_remark'>
				Delete from artran_remark where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>
		<cfcatch type="any">
		</cfcatch>
		</cftry>
		<!--- </cfif> --->

		<!--- Add On 061008, For View Audit Trail --->
		<cfquery datasource="#dts#" name="getartran">
			select * from artran
			where refno = '#form.currefno#' and type = '#tran#'
		</cfquery>

		<cfquery datasource="#dts#" name="insert">
			insert into artranat
			(TYPE,REFNO,CUSTNO,FPERIOD,WOS_DATE,DESP,DESPA,
			<cfswitch expression="#tran#">
				<cfcase value="RC,CN,OAI" delimiters=",">
					CREDITAMT
				</cfcase>
				<cfdefaultcase>
					DEBITAMT
				</cfdefaultcase>
			</cfswitch>,
			TRDATETIME,USERID,REMARK,CREATED_BY,UPDATED_BY,CREATED_ON,UPDATED_ON)
			values
			('#tran#','#form.currefno#','#getartran.custno#','#getartran.fperiod#',#getartran.wos_date#,'#getartran.desp#','#getartran.despa#',
			<cfswitch expression="#tran#">
				<cfcase value="RC,CN,OAI" delimiters=",">
					'#getartran.CREDITAMT#'
				</cfcase>
				<cfdefaultcase>
				'#getartran.DEBITAMT#'
				</cfdefaultcase>
			</cfswitch>,
			#createdatetime(year(getartran.trdatetime),month(getartran.trdatetime),day(getartran.trdatetime),hour(getartran.trdatetime),minute(getartran.trdatetime),second(getartran.trdatetime))#,
			'#getartran.userid#','#deleteStatus#','#getartran.created_by#','#Huserid#',
			<cfif getartran.created_on neq "">#createdatetime(year(getartran.created_on),month(getartran.created_on),day(getartran.created_on),hour(getartran.created_on),minute(getartran.created_on),second(getartran.created_on))#<cfelse>''</cfif>,
			#now()#)
		</cfquery>
		<!--- Add On 061008, For View Audit Trail --->
        <cfquery name="checkvoucertype" datasource="#dts#">
        SELECT * FROM pospayment
        </cfquery>
		<cfif checkvoucertype.vouchertype eq "system">
        <cftry>
        <cfquery name="checkdeletevoucher" datasource="#dtssync#">
        		select * from voucher where desp = '#form.currefno#' and used='Y'
        </cfquery>

        <cfif checkdeletevoucher.recordcount neq 0>
        <h3>Voucher has already been used.</h3>
        <cfabort>
        <cfelse>
        <cfquery name="deletevoucher2" datasource="#dtssync#">
        		update voucher set used='V' where desp = '#form.currefno#'
        </cfquery>
        </cfif>

        <cfcatch>
        <h3>Unable to connect to server to delete voucher.</h3>
        <cfabort>
        </cfcatch>
        </cftry>
        </cfif>


        <cfquery name="deletevoucher" datasource="#dts#">
        		update voucher set used='V' where desp = '#form.currefno#'
        </cfquery>

        <cfquery datasource='#dts#' name='getdeleteartran'>
				select rem40 from artran where refno = '#form.currefno#' and type = '#tran#'
		</cfquery>

		<cfif keepDeleted eq "1">
			<cfquery datasource='#dts#' name='voidartran'>
				Update artran
				set void='Y'
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>
		<cfelse>
			<cfquery datasource='#dts#' name='deleteartran'>
				Delete from artran where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>
		</cfif>
        <cfquery name="deletereserve" datasource="#dts#">
        		update reservedet set status='Void' where reserveno = '#form.currefno#'
        </cfquery>
        <cfquery name="deletereserve" datasource="#dts#">
        		update reserve set status='Void' where reserveno = '#form.currefno#'
        </cfquery>
        <cfquery name="deletereserve" datasource="#dts#">
        		update deposit set billno='Void' where depositno = '#form.currefno#'
        </cfquery>
        <!---recover reserve--->
        <cfquery name="updatedeposit" datasource="#dts#">
            update deposit set billno='' where depositno='#getdeleteartran.rem40#'
        </cfquery>

        <cfquery name="updatedeposit" datasource="#dts#">
            update reserve set status='' where reserveno='#getdeleteartran.rem40#'
        </cfquery>

        <cfquery name="updatedeposit" datasource="#dts#">
            update reservedet set status='' where reserveno='#getdeleteartran.rem40#'
        </cfquery>
        <!--- --->

        <cfif lcase(hcomid) eq "fdipx_i">
        <cfif tran eq "QUO">
        <cfquery datasource='#dts#' name='deletejobordertoquo'>
				Delete from joborder_update_to_quotation where quotation_refno = '#form.currefno#'
			</cfquery>
            <cfelseif tran eq "DO">
            <cfquery datasource='#dts#' name='deletejobordertodo'>
				Delete from joborder_update_to_delivery_order where DELIVERY_ORDER_REFNO = '#form.currefno#'
			</cfquery>
            <cfelseif tran eq "INV">
            <cfquery datasource='#dts#' name='deletejobordertoinv'>
				Delete from joborder_update_to_invoice where INVOICE_REFNO = '#form.currefno#'
			</cfquery>
            <cfelseif tran eq "CS">
            <cfquery datasource='#dts#' name='deletejobordertocs'>
				Delete from joborder_update_to_cs where CS_REFNO = '#form.currefno#'
			</cfquery>
        </cfif>
        </cfif>
		<!--- DELETE AND UPDATE OBBATCH DETAIL --->
		<cfquery name="getallbatchitem" datasource="#dts#">
			select * from ictran where refno = '#form.currefno#' and type = '#tran#' and batchcode<>''
		</cfquery>

		<cfif getallbatchitem.recordcount gt 0>
			<cfif tran eq "RC" or tran eq "OAI" or tran eq "CN">
				<cfset obtype = "bth_qin">
			<cfelse>
				<cfset obtype = "bth_qut">
			</cfif>

			<cfloop query="getallbatchitem">
				<cfquery name="updateobbatch" datasource="#dts#">
					update obbatch set #obtype#=(#obtype#-#getallbatchitem.qty#)
					where itemno='#getallbatchitem.itemno#' and batchcode='#getallbatchitem.batchcode#'
				</cfquery>

				<cfif getallbatchitem.location neq "">
					<cfquery name="updatelobthob" datasource="#dts#">
						update lobthob set #obtype#=(#obtype#-#getallbatchitem.qty#)
						where location='#getallbatchitem.location#' and itemno='#getallbatchitem.itemno#' and batchcode='#getallbatchitem.batchcode#'
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!--- END OF DELETE AND UPDATE OBBATCH DETAIL--->

		<cfquery name="getallitem" datasource="#dts#">
			select itemno,fperiod,qty from ictran where refno = '#form.currefno#' and type = '#tran#'
		</cfquery>

		<cfif getallitem.recordcount gt 0>
			<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">
				<cfset qname = 'QIN'&(getallitem.fperiod+10)>
			<cfelse>
				<cfset qname = 'QOUT'&(getallitem.fperiod+10)>
			</cfif>

			<cfloop query="getallitem">
				<cfquery name="UpdateIcitem" datasource="#dts#">
					update icitem set #qname#=(#qname#-#getallitem.qty#) where itemno = '#getallitem.itemno#'
				</cfquery>
			</cfloop>
		</cfif>

		<cfif keepDeleted eq "1">
			<cfquery datasource='#dts#' name='updateictran'>
				Update ictran
				set void='Y'
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfquery datasource='#dts#' name='updateserial'>
				Update iserial
				set void='Y'
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>
		<cfelse>
			<cfquery datasource='#dts#' name='deleteictran'>
				Delete from ictran where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfquery datasource='#dts#' name='deleteserial'>
				Delete from iserial where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>
		</cfif>

		<!--- Begin: Add on 040908 for Graded Item --->
		<cfquery name="getigrade" datasource="#dts#">
			select * from igrade where refno = "#form.currefno#" and type = '#tran#'
		</cfquery>

		<cfif getigrade.recordcount neq 0>
			<cfset firstcount = 11>
			<cfset maxcounter = 160>
			<cfset totalrecord = (maxcounter - firstcount + 1)>

			<cfloop query="getigrade">
				<cfif getigrade.type neq "SO" and getigrade.type neq "PO" and getigrade.type neq "QUO" and getigrade.type neq "SAM">
					<cfloop from="#firstcount#" to="#maxcounter#" index="i">
						<cfif i eq firstcount>
							<cfset grdvaluelist = Evaluate("getigrade.GRD#i#")>
							<cfset bgrdlist = "bgrd"&i>
						<cfelse>
							<cfset grdvaluelist = grdvaluelist&","&Evaluate("getigrade.GRD#i#")>
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
								#myArray[i]# = #myArray[i]#<cfif getigrade.type eq "OAI" or getigrade.type eq "RC" or getigrade.type eq "CN">-<cfelse>+</cfif>#myArray2[i]#,
							<cfelse>
								#myArray[i]# = #myArray[i]#<cfif getigrade.type eq "OAI" or getigrade.type eq "RC" or getigrade.type eq "CN">-<cfelse>+</cfif>#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">
					</cfquery>


					<cfquery name="updatelogrdob" datasource="#dts#">
						update logrdob
						set
						<cfloop from="1" to="#totalrecord#" index="i">
							<cfif i neq totalrecord>
								#myArray[i]# = #myArray[i]#<cfif getigrade.type eq "OAI" or getigrade.type eq "RC" or getigrade.type eq "CN">-<cfelse>+</cfif>#myArray2[i]#,
							<cfelse>
								#myArray[i]# = #myArray[i]#<cfif getigrade.type eq "OAI" or getigrade.type eq "RC" or getigrade.type eq "CN">-<cfelse>+</cfif>#myArray2[i]#
							</cfif>
						</cfloop>
						where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.itemno#">
						and location = <cfqueryparam cfsqltype="cf_sql_char" value="#getigrade.location#">
					</cfquery>
				</cfif>
			</cfloop>

			<cfif keepDeleted eq "1">
				<cfquery name="updateigrade" datasource="#dts#">
					Update igrade
					set void='Y'
					where type= '#tran#' and refno="#form.currefno#"
				</cfquery>
			<cfelse>
				<cfquery name="deleteigrade" datasource="#dts#">
					delete from igrade
					where type= '#tran#' and refno="#form.currefno#"
				</cfquery>
			</cfif>
		</cfif>
		<!--- End 040908 for Graded Item --->

		<form name='done' action='transaction.cfm' method='post'>
			<cfoutput>
				<input type='hidden' value='#tran#' name='tran'>
				<input name='status' value='#status#' type='hidden'>
			</cfoutput>
		</form>

		<script>done.submit();</script>
		<cfabort>

	<cfelseif form.type eq 'Edit'>
		<cfset status = 'Invoice Edited Successfully'>
		<cfset hmode = "Edit">
		<!--- Calculate the period --->
		<cfquery datasource='#dts#' name="getGeneralInfo">
			Select * from GSetup
		</cfquery>

		<cfset lastaccyear = dateformat(getGeneralInfo.lastaccyear, 'dd/mm/yyyy')>
		<cfset period=getGeneralInfo.period>
		<cfset currentdate = dateformat(form.invoicedate,'dd/mm/yyyy')>

		<cfset tmpYear = year(currentdate)>
		<cfset clsyear = year(lastaccyear)>

		<cfset tmpmonth = month(currentdate)>
		<cfset clsmonth = month(lastaccyear)>

		<cfset intperiod = (tmpyear - clsyear) * 12 + tmpmonth - clsmonth>

		<cfif intperiod gt 18 or intperiod lte 0>
			<cfset readperiod = 99>
		<cfelse>
			<cfset readperiod = numberformat(intperiod,"00")>
		</cfif>
		<!--- To add more fields to add in!! --->
		<cfquery datasource='#dts#' name='getar'>
			select * from artran where refno = '#form.currefno#' and type = '#tran#'
		</cfquery>

		<!--- ADD ON 090608, TO DEDUCT FROM THE PREVIOUS QIN/QOUT AND ADD INTO THE CURRENT QIN/QOUT --->
		<cfif tran neq "SO" and tran neq "PO" and tran neq "QUO">
			<cfquery name="geticitem" datasource="#dts#">
				select * from ictran
				where refno = '#form.currefno#' and type = '#tran#'
				and (void = '' or void is null)
				and toinv= ''
				<cfif tran eq "INV">
					and dono = ''
				</cfif>
			</cfquery>
			<cfif geticitem.recordcount neq 0>



				<cfif lcase(HUserID) neq "kellysteel2" and readperiod neq getar.fperiod>

					<cfif tran eq "OAI" or tran eq "RC" or tran eq "CN">
						<cfset qname_old='QIN'&(getar.fperiod+10)>
						<cfset qname_new='QIN'&(readperiod+10)>
					<cfelse>
						<cfset qname_old='QOUT'&(val(getar.fperiod)+10)>
						<cfset qname_new='QOUT'&(val(readperiod)+10)>
					</cfif>
					<cfloop query="geticitem">
						<cfquery name="UpdateIcitem" datasource="#dts#">
							update icitem set
							#qname_old#=(#qname_old#-#geticitem.qty#),
							#qname_new#=(#qname_new#+#geticitem.qty#)
							where itemno='#geticitem.itemno#'
						</cfquery>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
		<!--- ADD ON 090608, TO DEDUCT FROM THE PREVIOUS QIN/QOUT AND ADD INTO THE CURRENT QIN/QOUT --->

		<cfset xinvgross = val(getar.gross_bil) * currrate>
		<cfset xdiscount1 = val(getar.disc1_bil) * currrate>
		<cfset xdiscount2 = val(getar.disc2_bil)* currrate>
		<cfset xdiscount3 = val(getar.disc3_bil) * currrate>
		<cfset xdiscount = val(getar.disc_bil) * currrate>
		<cfset xtax = val(getar.tax_bil) * currrate>
		<cfset xnet = val(getar.net_bil) * currrate>
		<cfset xgrand = val(getar.grand_bil) * currrate>
		<cfset xgrand = numberformat(xgrand,".__")>
        <!--- ADD ON 27-07-2009 --->
        <cfif lcase(hcomid) eq "mhsl_i" and tran eq "RC">
			<cfset xtaxnbt= val(getar.taxnbt_bil) * currrate>
		</cfif>

		<!--- ADD ON 17-08-2009 --->
		<cfif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV">
			<cfif form.remark10 neq "" and isdate(form.remark10) eq "Yes" and form.remark11 eq "">
				<cfset date1=createDate(ListGetAt(form.remark10,3,"/"),ListGetAt(form.remark10,2,"/"),ListGetAt(form.remark10,1,"/"))>
				<cfset form.remark11=dateformat(DateAdd("d", 364, date1),"dd/mm/yyyy")>
			</cfif>
		</cfif>

		<!--- ADD ON 01-10-2009 --->
		<cfif lcase(HcomID) eq "ovas_i" and (tran eq "CS" or tran eq "SAM")>
			<cfif form.driver neq "">
				<cfquery name="getdriver" datasource="#dts#">
	            	select name,name2,add1,add2,add3,'' as add4,attn,phone,phonea as hphone,fax
					from driver
	                where driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.driver#">
	            </cfquery>
				<cfset form.remark0="">
	            <cfset form.frem0=getdriver.name>
			  	<cfset form.frem1=getdriver.name2>
			  	<cfset form.frem2=getdriver.add1>
			  	<cfset form.frem3=getdriver.add2>
			  	<cfset form.frem4=getdriver.add3>
			  	<cfset form.frem5=getdriver.add4>
			  	<cfset form.remark13="">
			  	<cfset form.remark2=getdriver.attn>
			  	<cfset form.remark4=getdriver.phone>
			  	<cfset form.frem6=getdriver.fax>
			  	<cfset form.phonea=getdriver.hphone>
			</cfif>
		</cfif>

		<!--- <cfset invdate=createDate(ListGetAt(form.invoicedate,3,"/"),ListGetAt(form.invoicedate,2,"/"),ListGetAt(form.invoicedate,1,"/"))>
		<cfset nowtrdatetime = CreateDateTime(year(invdate),month(invdate),day(invdate),hour(now()),minute(now()),second(now()))> --->
		<cfif lcase(hcomid) eq "taftc_i">
			<cfif getar.source neq form.source>
                	<cfquery name="getcoursedetail" datasource="#dts#">
                    SELECT camt,bydeposit,cprice from project where source = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.source#">
                    </cfquery>
                    <cfif getcoursedetail.bydeposit eq "1">
                    <cfset pricenew = val(getcoursedetail.camt) / 2>
                    <cfset cpricenew = val(getcoursedetail.cprice) / 2>
                    <cfelse>
                    <cfset pricenew = val(getcoursedetail.camt)>
                    <cfset cpricenew = val(getcoursedetail.cprice)>
                    </cfif>
                    <cfquery name="updatenewprice" datasource="#dts#">
                    Update ictran SET
                    price = '#pricenew#',
                    price_bil = '#pricenew#',
                    amt = '#pricenew#',
                    amt_bil = '#pricenew#',
                    source = '#form.source#',
                    job = '#form.job#'
                    where refno = '#form.currefno#' and type = '#tran#' and brem1 <> "no"
                    </cfquery>
                    <cfquery name="updatenewprice" datasource="#dts#">
                    Update ictran SET
                    price = '#cpricenew#',
                    price_bil = '#cpricenew#',
                    amt = '#cpricenew#',
                    amt_bil = '#cpricenew#',
                    source = '#form.source#',
                    job = '#form.job#'
                    where refno = '#form.currefno#' and type = '#tran#' and brem1 = "no"
                    </cfquery>


		</cfif>

		</cfif>

		<cfquery datasource='#dts#' name='updateartran'>
			Update artran set refno2 = '#refno2#', wos_date = #ndatecreate#, fperiod = '#numberformat(readperiod,"00")#',
			currcode = '#listfirst(form.refno3)#',currrate = '#currrate#',custno = '#form.custno#',desp = '#desp#',despa = '#despa#',
			name = '#form.name#', term = '#form.terms#', source = '#form.source#', job = '#form.job#',
			agenno = '#form.agenno#', invgross = '#xinvgross#', discount1 = '#xdiscount1#',
			discount2 = '#xdiscount2#',discount = '#xdiscount#',tax = '#xtax#', net = '#xnet#', grand='#xgrand#',
			pono = '#form.pono#',dono = '#form.dono#',sono = '#form.sono#', rem0 = '#form.remark0#', rem1 = '#form.remark1#',
			rem2 = '#form.remark2#', rem3 = '#form.remark3#', rem4 = '#form.remark4#', rem5 = '#form.remark5#',
			rem6 = '#form.remark6#', rem7 = '#form.remark7#', rem8 = '#form.remark8#',
			<cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">
				<cfif form.remark9 neq "">
                    <cfinvoke component="cfc.Date" method="getDbDate" inputDate="#form.remark9#" returnvariable="remark9"/>
				<cfelse>
					<cfset form.remark9='0000-00-00'>
				</cfif>
				<cfif form.remark11 neq "">
                    <cfinvoke component="cfc.Date" method="getDbDate" inputDate="#form.remark11#" returnvariable="remark11"/>
				<cfelse>
					<cfset form.remark11='0000-00-00'>
				</cfif>
				rem9='#remark9#', rem10='#form.remark10#',rem11='#remark11#',permitno='#permitno#',
			<cfelseif (lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i") and tran eq "PO">
				<cfif form.remark9 neq "">
					<cfset remark9 = createDate(ListGetAt(form.remark9,3,"/"),ListGetAt(form.remark9,2,"/"),ListGetAt(form.remark9,1,"/"))>
					rem9 = #remark9#
				<cfelse>
					rem9 = '#form.remark9#'
				</cfif>
				,rem10 = '#form.remark10#', rem11 = '#form.remark11#',permitno = '#form.permitno#',
			<cfelse>
				rem9 = '#form.remark9#',rem10 = '#form.remark10#', rem11 = '#form.remark11#',permitno = '#form.permitno#',
			</cfif>
			rem12 = '#form.remark12#',  rem13 = '#form.remark13#',
			rem14 = '#remark14#',frem0 = '#form.frem0#',frem1 = '#form.frem1#',frem2 = '#form.frem2#',frem3 = '#form.frem3#',
			frem4 = '#form.frem4#',frem5 = '#form.frem5#',frem6 = '#form.frem6#',frem7 = '#form.frem7#',
			frem8 = '#form.frem8#',frem9 = '#form.frem9#',comm0='#form.comm0#',comm1='#form.comm1#',comm2='#form.comm2#',
			comm3='#form.comm3#',comm4='#form.comm4#',	van = '#form.driver#',phonea='#form.phonea#',e_mail='#form.e_mail#',
			<!--- REMARK ON 06-08-2009 --->
			<!--- <cfif lcase(husergrpid) neq "super">userid='#Huserid#',</cfif> --->
			<cfif getar.userid eq "" and lcase(husergrpid) neq "super"><cfif getgsetup.tranuserid neq "Y">userid='#Huserid#',</cfif></cfif>
			updated_by = '#Huserid#',updated_on = #now()#
            <cfif lcase(hcomid) eq 'iel_i' or lcase(hcomid) eq 'ielm_i'>
				,rem15='#form.remark15#',rem16='#form.remark16#',rem17='#form.remark17#',rem18='#form.remark18#',rem19='#form.remark19#'
                ,rem20='#form.remark20#',rem21='#form.remark21#',rem22='#form.remark22#',rem23='#form.remark23#',rem24='#form.remark24#'
                ,rem25='#form.remark25#'
			</cfif>
            <cfif lcase(hcomid) eq 'ugateway_i'>
            	,via = '#form.via#'
			</cfif>
            <cfif lcase(hcomid) eq "accord_i" and tran eq "INV">
            	,checkno = '#form.checkno#'
			</cfif>
            <!--- ADD ON 27-07-2009 --->
            <cfif lcase(hcomid) eq "mhsl_i" and tran eq "RC">
				,taxnbt='#val(xtaxnbt)#'
			</cfif>
            <cfif getgsetup.transactiondate eq 'Y'>
            ,tran_date='#nDateCreatetran#'
            </cfif>
			where refno = '#form.currefno#' and type = '#tran#'
		</cfquery>

        <cfif getgsetup.addonremark eq 'Y'>
        <cfinclude template="tran2updateaddonremark.cfm">
        </cfif>
        <cfif getgsetup.multiagent eq 'Y'>
        <cfinclude template="multiagentupdate.cfm">
        </cfif>

		 <cfif lcase(HcomID) eq "avent_i">
			<cfquery datasource='#dts#' name='getcomment'>
				select * from artran_remark
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfif getcomment.recordcount neq 0>
				<cfquery datasource='#dts#' name='updatecomment'>
					Update artran_remark
					set remark1 = '#form.comment_selected#',
					remark2 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
					remark3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.xremark3#">
					where refno = '#form.currefno#' and type = '#tran#'
				</cfquery>
			<cfelse>
				<cfquery datasource='#dts#' name='insertcomment'>
					Insert into artran_remark
					(TYPE,REFNO,REMARK1,REMARK2,REMARK3)
					values
					('#tran#','#form.currefno#','#form.comment_selected#',
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.xremark3#">)
				</cfquery>
			</cfif>
		<cfelseif lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i">
			<cfquery datasource='#dts#' name='getcomment'>
				select * from artran_remark
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfif getcomment.recordcount neq 0>
				<cfquery datasource='#dts#' name='updatecomment'>
					Update artran_remark
					set remark1 = '#form.xremark1#',
					remark2 = '#form.xremark2#'
					where refno = '#form.currefno#' and type = '#tran#'
				</cfquery>
			<cfelse>
				<cfquery datasource='#dts#' name='insertcomment'>
					Insert into artran_remark
					(TYPE,REFNO,REMARK1,REMARK2)
					values
					('#tran#','#form.currefno#','#form.xremark1#','#form.xremark2#')
				</cfquery>
			</cfif>
		<cfelseif lcase(HcomID) eq "winbells_i">
			<cfquery datasource='#dts#' name='getcomment'>
				select * from artran_remark
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfif getcomment.recordcount neq 0>
				<cfquery datasource='#dts#' name='updatecomment'>
					Update artran_remark
					set REMARK1 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
					REMARK2 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
					REMARK3 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
					REMARK4 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">,
					REMARK5 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark5#">,
					REMARK6 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark6#">,
					REMARK7 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark7#">,
					REMARK8 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark8#">,
					REMARK9 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark9#">,
					REMARK10 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark10#">,
					REMARK11 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark11#">,
					REMARK12 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark12#">,
					REMARK13 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark13#">,
					REMARK14 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark14#">,
					REMARK15 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark15#">,
					REMARK16 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark16#">,
					REMARK17 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark17#">
					where refno = '#form.currefno#' and type = '#tran#'
				</cfquery>
			<cfelse>
				<cfquery datasource='#dts#' name='insertcomment'>
					Insert into artran_remark
					(TYPE,REFNO,REMARK1,REMARK2,REMARK3,REMARK4,REMARK5,REMARK6,REMARK7,REMARK8,REMARK9,REMARK10,
					REMARK11,REMARK12,REMARK13,REMARK14,REMARK15,REMARK16,REMARK17)
					values
					('#tran#','#form.currefno#',<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark5#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark6#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark7#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark8#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark9#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark10#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark11#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark12#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark13#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark14#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark15#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark16#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark17#">)
				</cfquery>
			</cfif>
        <cfelseif lcase(HcomID) eq "iel_i">
			<cfquery datasource='#dts#' name='getcomment'>
				select * from artran_remark
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfif getcomment.recordcount neq 0>
				<cfquery datasource='#dts#' name='updatecomment'>
					Update artran_remark
					set REMARK1 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
					REMARK2 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
					REMARK3 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
					REMARK4 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">
					where refno = '#form.currefno#' and type = '#tran#'
				</cfquery>
			<cfelse>
				<cfquery datasource='#dts#' name='insertcomment'>
					Insert into artran_remark
					(TYPE,REFNO,REMARK1,REMARK2,REMARK3,REMARK4)
					values
					('#tran#','#form.currefno#',<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">)
				</cfquery>
			</cfif>
		<cfelseif lcase(HcomID) eq "zeadine_i" or lcase(HcomID) eq "zeadine09_i">
			<cfquery datasource='#dts#' name='getcomment'>
				select * from artran_remark
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfif getcomment.recordcount neq 0>
				<cfquery datasource='#dts#' name='updatecomment'>
					Update artran_remark
					set remark1 = '#form.xremark1#'
					where refno = '#form.currefno#' and type = '#tran#'
				</cfquery>
			<cfelse>
				<cfquery datasource='#dts#' name='insertcomment'>
					Insert into artran_remark
					(TYPE,REFNO,REMARK1)
					values
					('#tran#','#form.currefno#','#form.xremark1#')
				</cfquery>
			</cfif>
		<cfelseif lcase(HcomID) eq "chemline_i">
			<cfquery datasource='#dts#' name='getcomment'>
				select * from artran_remark
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfif getcomment.recordcount neq 0>
				<cfquery datasource='#dts#' name='updatecomment'>
					Update artran_remark
					set REMARK1 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
					REMARK2 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
					REMARK3 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
					REMARK4 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">,
					REMARK5 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark5#">,
					REMARK6 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark6#">,
					REMARK7 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark7#">,
					REMARK8 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.comment_selected#">
					where refno = '#form.currefno#' and type = '#tran#'
				</cfquery>
			<cfelse>
				<cfquery datasource='#dts#' name='insertcomment'>
					Insert into artran_remark
					(TYPE,REFNO,REMARK1,REMARK2,REMARK3,REMARK4,REMARK5,REMARK6,REMARK7,REMARK8)
					values
					('#tran#','#form.currefno#',<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark5#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark6#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark7#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.comment_selected#">)
				</cfquery>
			</cfif>
		<cfelseif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
			<cfquery datasource='#dts#' name='getcomment'>
				select * from artran_remark
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfif getcomment.recordcount neq 0>
				<cfquery datasource='#dts#' name='updatecomment'>
					Update artran_remark
					set remark1 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
					remark2 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">
					where refno = '#form.currefno#' and type = '#tran#'
				</cfquery>
			<cfelse>
				<cfquery datasource='#dts#' name='insertcomment'>
					Insert into artran_remark
					(TYPE,REFNO,REMARK1,REMARK2)
					values
					('#tran#','#form.currefno#',
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">)
				</cfquery>
			</cfif>
		<cfelseif lcase(HcomID) eq "probulk_i">
			<cfquery datasource='#dts#' name='getcomment'>
				select * from artran_remark
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfif getcomment.recordcount neq 0>
				<cfquery datasource='#dts#' name='updatecomment'>
					Update artran_remark
					set remark1 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
					remark2 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
					remark3 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
					remark4 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">,
					remark5 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark5#">,
					remark6 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark6#">,
					remark7 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#val(form.xremark7)#">
					where refno = '#form.currefno#' and type = '#tran#'
				</cfquery>
			<cfelse>
				<cfquery datasource='#dts#' name='insertcomment'>
					Insert into artran_remark
					(TYPE,REFNO,REMARK1,REMARK2,REMARK3,REMARK4,REMARK5,REMARK6,REMARK7)
					values
					('#tran#','#form.currefno#',
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark5#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark6#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#val(form.xremark7)#">)
				</cfquery>
			</cfif>
		</cfif>

		<!--- REMARK ON 24-03-2009 --->
		<!--- <cfquery datasource='#dts#' name='updateictran'>
			update ictran set wos_date = #ndatecreate#, fperiod = '#numberformat(readperiod,"00")#',
			currrate = '#currrate#', custno = '#form.custno#',name = '#form.name#',
			agenno = '#form.agenno#', userid='#Huserid#' where refno = '#form.currefno#' and type = '#tran#'
		</cfquery> --->
		<cfquery datasource='#dts#' name='updateictran'>
			update ictran
			set wos_date = #ndatecreate#, fperiod = '#numberformat(readperiod,"00")#',
			currrate = '#currrate#', custno = '#form.custno#',name = '#form.name#',
			agenno = '#form.agenno#'
			<cfif getGeneralInfo.projectbybill eq "1">
				,source = '#form.source#', job = '#form.job#'
                <cfelseif getGeneralInfo.jobbyitem eq "Y">
                ,source = '#form.source#'
			</cfif>
			<!--- REMARK ON 06-08-2009 --->
			<!--- <cfif lcase(husergrpid) neq "super">, userid='#Huserid#'</cfif> --->
			<cfif getar.userid eq "" and lcase(husergrpid) neq "super"><cfif getgsetup.tranuserid neq "Y">,userid='#Huserid#'</cfif></cfif>
			<cfif (checkcustom.customcompany eq "Y") and (tran eq "RC" or tran eq "OAI" or tran eq "CN")>,BREM5='#form.remark5#',BREM7='#form.remark6#'</cfif>
			where refno = '#form.currefno#' and type = '#tran#'
		</cfquery>

		<cfif (checkcustom.customcompany eq "Y") and (tran eq "RC" or tran eq "OAI" or tran eq "CN")>
			<cfquery name="updateobbatch" datasource="#dts#">
				update obbatch
				set permit_no='#form.remark5#',
				permit_no2='#form.remark6#'
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>

			<cfquery name="updatelobthob" datasource="#dts#">
				update lobthob
				set permit_no='#form.remark5#',
				permit_no2='#form.remark6#'
				where refno = '#form.currefno#' and type = '#tran#'
			</cfquery>
		</cfif>

		<!--- Add on 040908, For Graded Item --->
		<cfquery name="updateigrade" datasource="#dts#">
			update igrade
			set wos_date = #ndatecreate#,
			fperiod = '#numberformat(readperiod,"00")#',
			custno = '#form.custno#'
			where refno = '#form.currefno#' and type = '#tran#'
		</cfquery>
		<!--- End 040908 --->

		<cfif isdefined("form.itemrate")>
			<cfquery name="getic" datasource="#dts#">
				select * from ictran where refno = '#form.currefno#' and type = '#tran#' order by itemcount
			</cfquery>

			<cfloop query="getic">
				<cfset xprice = price_bil * currrate>
				<cfset xamt1 = amt1_bil * currrate>
				<cfset xdisamt = disamt_bil * currrate>
				<cfset xtaxamt = taxamt_bil * currrate>
				<cfset xamt = amt_bil * currrate>
				<cfset xamt = numberformat(xamt,".__")>

				<cfquery datasource='#dts#' name='updateictran'>
					update ictran set currrate = '#currrate#', price = '#xprice#',
					amt1 = '#xamt1#', disamt = '#xdisamt#', taxamt = '#xtaxamt#',
					amt = '#xamt#'
					where refno = '#form.currefno#' and type = '#tran#' and itemcount = '#itemcount#'
				</cfquery>
			</cfloop>
		</cfif>
		<cfset nexttranno = form.currefno>
		<!--- ADD ON 10-12-2009 --->
        <!---
		<cftry>
		<cfif isdefined("form.submit1") and form.submit1 eq "  Save  ">
			<cfif getGeneralInfo.printoption eq "1">
				<cflocation url="transaction3c.cfm?tran=#tran#&nexttranno=#nexttranno#">
			<cfelse>

			<cfoutput>
				<form name="done" action="transaction.cfm?tran=#tran#" method="post">
				</form>
			</cfoutput>
			<script>
				<cfoutput>window.open('../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#nexttranno#');</cfoutput>
				done.submit();
			</script>
			</cfif>
			<cfabort>
		</cfif>
		<cfcatch type="any">
			<cfoutput>#cfcatch.Message#:::#cfcatch.Detail#</cfoutput><cfabort>
		</cfcatch>
		</cftry>---->
		<!--- Readperiod will be inserted into the period in the database. --->
		<!--- End of Read period --->
	<cfelseif form.type eq 'Create'>
		<cfset hmode = "Create">

		<cfif HcomID eq "pnp_i">
			<cfif isdefined("form.invset")>
				<!--- <cfquery datasource="main" name="getGeneralInfo">
					select lastUsedNo as tranno, refnoused as arun from refnoset
					where userDept = '#dts#'
					and type = '#tran#'
					and counter = <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
				</cfquery> --->

				<cfquery datasource="#dts#" name="getGeneralInfo">
					select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse
                    from refnoset
					where type = '#tran#'
					and counter = <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
				</cfquery>
			<cfelse>
				<cfinclude template="../../pnp/get_target_refno.cfm">
			</cfif>
		<cfelse>
			<!---cfquery datasource="#dts#" name="getGeneralInfo">
				select
				#trancode# as tranno,
				#tranarun# as arun,
				invoneset
				from GSetup
			</cfquery--->
			<!--- <cfquery datasource="main" name="getGeneralInfo">
				select lastUsedNo as tranno, refnoused as arun from refnoset
				where userDept = '#dts#'
				and type = '#tran#'
				and counter = <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
			</cfquery> --->

			<cfquery datasource="#dts#" name="getGeneralInfo">
				select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse
                from refnoset
				where type = '#tran#'
				and counter = <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
			</cfquery>
            <!---cust refno --->
            <cfif getgsetup.prefixbycustquo eq 'Y' and tran eq 'QUO' and getcustprefixno.arrem2 neq "">
  			<cfquery name="getcustrefno" datasource="#dts#">
			select arrem2 from #target_arcust# where custno ='#form.custno#'
  			</cfquery>
			<cfset getGeneralInfo.tranno=getcustrefno.arrem2>
			</cfif>

            <cfif getgsetup.prefixbycustso eq 'Y' and tran eq 'SO' and getcustprefixno.arrem3 neq "">
  			<cfquery name="getcustrefno" datasource="#dts#">
			select arrem3 from #target_arcust# where custno ='#form.custno#'
  			</cfquery>
			<cfset getGeneralInfo.tranno=getcustrefno.arrem3>
			</cfif>

            <cfif getgsetup.prefixbycustinv eq 'Y' and tran eq 'INV' and getcustprefixno.arrem4 neq "">
  			<cfquery name="getcustrefno" datasource="#dts#">
			select arrem4 from #target_arcust# where custno ='#form.custno#'
  			</cfquery>
			<cfset getGeneralInfo.tranno=getcustrefno.arrem4>
			</cfif>
            <!--- --->
		</cfif>

		<!--- <cfquery datasource='#dts#' name='getGeneralInfo'>
			Select #trancode# as tranno, #tranarun# as arun, invoneset from GSetup
  		</cfquery> --->

		<cfif getGeneralInfo.arun eq '1'>
			<cftry>
				<cfinvoke component="cfc.IncrementValue" method="getIncreament" input="#getGeneralInfo.tranno#" returnvariable="nexttranno"/>
			<cfcatch>
				<cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />
				<cfset nexttranno = newnextNum>
			</cfcatch>
			</cftry>

        <cfquery name="checkexistrefnonew" datasource="#dts#">
        select refno from artran where
        type='#tran#'
        and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#nexttranno#">
        </cfquery>

		<cfif checkexistrefnonew.recordcount neq 0>
        <cfset refnocheck = 0>
        <cfset refno1 = checkexistrefnonew.refno>
        <cfloop condition="refnocheck eq 0">
        <cftry>
        <cfinvoke component="cfc.IncrementValue" method="getIncreament" input="#refno1#" returnvariable="nexttranno"/>
		<cfcatch>
		<cfinvoke component="cfc.refno" method="processNum" oldNum="#refno1#" returnvariable="nexttranno" />
		</cfcatch>
        </cftry>
        <cfquery name="checkexistence" datasource="#dts#">
        SELECT refno FROM artran WHERE
        refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nexttranno#"> and type = '#tran#'
        </cfquery>
        <cfif checkexistence.recordcount eq 0>
        <cfset refnocheck = 1>
        <cfelse>
        <cfset refno1 = nexttranno>
		</cfif>
        </cfloop>
        </cfif>


			<!--- ADD ON 19-12-2008 --->
			<!--- <cfif lcase(HcomID) eq "mhsl_i" and tran eq "INV"> --->
			<cfif (lcase(HcomID) eq "mhsl_i" and tran eq "INV") or (lcase(HcomID) eq "ideal_i")>
				<cfset actual_nexttranno = nexttranno>
				<cfif getGeneralInfo.refnocode2 neq "">
					<cfset nexttranno = actual_nexttranno&"/"&getGeneralInfo.refnocode2>
				</cfif>
			<cfelseif lcase(HcomID) eq "zeadine_i" or lcase(HcomID) eq "zeadine09_i">
				<cfset actual_nexttranno = nexttranno>
				<cfif getGeneralInfo.refnocode2 neq "">
					<cfset nexttranno = actual_nexttranno&"-"&getGeneralInfo.refnocode2>
				</cfif>
			<cfelseif lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i" or lcase(HcomID) eq "chemline_i" or lcase(HcomID) eq "kingston_i" or lcase(HcomID) eq "probulk_i">
				<cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />
				<cfset nexttranno = newnextNum>
            <cfelse>
<!--- 				<cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" /> --->
        		<cfset actual_nexttranno = nexttranno>

                <cfif (getGeneralInfo.refnocode2 neq "" or getGeneralInfo.refnocode neq "") and getGeneralInfo.presuffixuse eq "1">
                    <cfset nexttranno = getGeneralInfo.refnocode&actual_nexttranno&getGeneralInfo.refnocode2>
                <cfelse>
                <cfif (getgsetup.prefixbycustquo eq 'Y' and tran eq 'QUO' and getcustprefixno.arrem2 neq "") or (getgsetup.prefixbycustso eq 'Y' and tran eq 'SO' and getcustprefixno.arrem3 neq "") or (getgsetup.prefixbycustinv eq 'Y' and tran eq 'INV' and getcustprefixno.arrem4 neq "")>
                <cftry>
                <cfset nexttranno = listgetat(form.custno,2,'/')&"-"&actual_nexttranno>
                <cfcatch>
                <cfset nexttranno = actual_nexttranno>
                </cfcatch>
                </cftry>
                <cfelse>
                    <cfset nexttranno = actual_nexttranno>
                </cfif>
                </cfif>
			</cfif>

            <cfquery name="getrefnolen" datasource="#dts#">
            SELECT refnoNACC,refnoACC,ddlitem from gsetup
            </cfquery>

			<cfif tran eq 'SO' or tran eq 'PO' or tran eq 'QUO'>
				<cfset limit = getrefnolen.refnoNACC>
			<cfelse>
				<cfset limit = getrefnolen.refnoACC>
			</cfif>
			<cfif len(nexttranno) gt limit><cfset nexttranno = '99999999'></cfif>
		<cfelse>
	  		<cfset nexttranno= form.nexttranno>
		</cfif>

		<cfquery name='checkexist' datasource='#dts#'>
			select refno from artran where refno='#nexttranno#' and type='#tran#'
		</cfquery>

		<cfif checkexist.recordcount gt 0>
			<h3>This transaction refence number has been used. Please use another number.</h3>
			<cfoutput><h2><a href='transaction1.cfm?ttype=create&tran=#tran#&nexttranno=&bcode=&dcode=&first=0'>Create New #tranname#</a></h2></cfoutput>
			<cfabort>
		</cfif>

		<cfif HcomID eq "pnp_i">
			<cfif isdefined("form.invset")>
				<!--- <cfquery name="updategsetup" datasource="main">
					update refnoset set
					lastUsedNo=UPPER('#nexttranno#')
					where userDept = '#dts#'
					and type = '#tran#'
					and counter =  <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
				</cfquery> --->

				<cfquery name="updategsetup" datasource="#dts#">
					update refnoset set
					lastUsedNo=UPPER('#nexttranno#')
					where type = '#tran#'
					and counter =  <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
				</cfquery>
			<cfelse>
				<cfinclude template="../../pnp/update_target_refno.cfm">
			</cfif>
		<cfelse>
			<!---cfquery name="updategsetup" datasource="#dts#">
				update Gsetup set
				#trancode#=UPPER('#nexttranno#');
			</cfquery--->
			<!--- <cfquery name="updategsetup" datasource="main">
				update refnoset set
				lastUsedNo=UPPER('#nexttranno#')
				where userDept = '#dts#'
				and type = '#tran#'
				and counter =  <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
			</cfquery> --->

			<!--- <cfquery name="updategsetup" datasource="#dts#">
				update refnoset set
				lastUsedNo=UPPER('#nexttranno#')
				where type = '#tran#'
				and counter =  <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
			</cfquery> --->

			<!--- MODIFIED ON 19-12-2008 --->
            <cfif getgsetup.prefixbycustquo eq 'Y' and tran eq 'QUO' and getcustprefixno.arrem2 neq "">
             <!---cust refno --->
            <cfquery name="getcustrefno" datasource="#dts#">
			update #target_arcust# set arrem2=<cfif isdefined("actual_nexttranno")>UPPER('#actual_nexttranno#')<cfelse>UPPER('#nexttranno#')</cfif> where custno ='#form.custno#'
  			</cfquery>
              <cfelseif getgsetup.prefixbycustso eq 'Y' and tran eq 'SO' and getcustprefixno.arrem3 neq "">
            <cfquery name="getcustrefno" datasource="#dts#">
			update #target_arcust# set arrem3=<cfif isdefined("actual_nexttranno")>UPPER('#actual_nexttranno#')<cfelse>UPPER('#nexttranno#')</cfif> where custno ='#form.custno#'
  			</cfquery>
             <cfelseif getgsetup.prefixbycustinv eq 'Y' and tran eq 'INV' and getcustprefixno.arrem4 neq "">
            <cfquery name="getcustrefno" datasource="#dts#">
			update #target_arcust# set arrem4=<cfif isdefined("actual_nexttranno")>UPPER('#actual_nexttranno#')<cfelse>UPPER('#nexttranno#')</cfif> where custno ='#form.custno#'
  			</cfquery>
             <!--- --->
            <cfelse>
			<cfquery name="updategsetup" datasource="#dts#">
				update refnoset set
				lastUsedNo=<cfif isdefined("actual_nexttranno")>UPPER('#actual_nexttranno#')<cfelse>UPPER('#nexttranno#')</cfif>
				where type = '#tran#'
				and counter =  <cfif isdefined("form.invset")>'#form.invset#'<cfelse>1</cfif>
			</cfquery>


			</cfif>

		</cfif>
        <cfif isdefined('form.invset2')>
        <cfif isdefined("form.invset")>
        <cfset invsettest = form.invset>
        <cfelse>
        <cfset invsettest = 1>
		</cfif>
        <cfif form.invset2 neq invsettest>
        <cfquery name="getrefno2" datasource="#dts#">
        SELECT lastusedno from refnoset where type = "#tran#" and counter = "#form.invset2#"
        </cfquery>
        <cfinvoke component="cfc.refno" method="processNum" oldNum="#getrefno2.lastusedno#" returnvariable="newrefno2" />
        <cfquery name="updategsetup" datasource="#dts#">
				update refnoset set
				lastUsedNo= '#newrefno2#'
				where type = '#tran#'
				and counter =  '#form.invset2#'
			</cfquery>
        </cfif>
		</cfif>

		<!--- Format the date to MYSQL readable --->
		<cfset dd = dateformat(form.invoicedate, 'DD')>

		<cfif dd greater than '12'>
			<cfset nDateCreate = dateformat(form.invoicedate,"YYYYMMDD")>
			<cfset nDatecreate2 = dateformat(form.invoicedate,"YYYY-MM-DD")>
		<cfelse>
			<cfset nDateCreate = dateformat(form.invoicedate,"YYYYDDMM")>
			<cfset nDateCreate2 = dateformat(form.invoicedate,"YYYY-DD-MM")>
		</cfif>

		<cfset dd = dateformat(now(), 'DD')>

		<cfif dd greater than '12'>
			<cfset nDateNow = dateformat(now(),'YYYYMMDD')>
		<cfelse>
			<cfset nDateNow = dateformat(now(),'YYYYDDMM')>
		</cfif>
		<cfif isdefined("form.transactiondate")>
        <cfset ddtran = dateformat(form.transactiondate, 'DD')>

		<cfif ddtran greater than '12'>
			<cfset nDatecreatetran = dateformat(form.transactiondate,"YYYY-MM-DD")>
		<cfelse>
			<cfset nDateCreate2tran = dateformat(form.transactiondate,"YYYY-DD-MM")>
		</cfif>
        </cfif>
		<!--- End of date format --->
		<!--- Calculate the period --->
		<cfquery datasource='#dts#' name='getGeneralInfo'>
			Select * from GSetup
		</cfquery>

		<cfset lastaccyear = dateformat(getGeneralInfo.lastaccyear, 'dd/mm/yyyy')>
		<cfset period = getGeneralInfo.period>
		<cfset currentdate = dateformat(form.invoicedate,'dd/mm/yyyy')>
		<cfset tmpYear = year(currentdate)>
		<cfset clsyear = year(lastaccyear)>
		<cfset tmpmonth = month(currentdate)>
		<cfset clsmonth = month(lastaccyear)>
		<cfset intperiod = (tmpyear - clsyear) * 12 + tmpmonth - clsmonth>

		<cfif intperiod gt 18 or intperiod lte 0>
			<cfset readperiod = 99>
		<cfelse>
			<cfset readperiod = numberformat(intperiod,"00")>
		</cfif>

		<cfset nowdatetime = ndatecreate2 & " " & timeformat(now(),"HH:MM:SS")>

		<!--- Readperiod will be inserted into the period in the database. --->
		<!--- End of Read period --->

<!--- 		<cfif hcomid eq "pnp_i">
			<!--- Default TAX Inceluded Setting --->
			<cfinclude template="transaction_body_setting_checking/default_tax_included_setting.cfm">
			<!--- Default TAX Inceluded Setting --->
		<cfelse>
			<cfset form.taxincl = "">
		</cfif> --->

		<cfset form.taxincl = "">
        <cfif isdefined('getGeneralInfo.ngstcustautotax')>
        <cfif getGeneralInfo.ngstcustautotax eq '1'>

        <cfif tran eq 'rc' or tran eq 'pr' or tran eq 'po'>
        <cfquery name="gettaxinclcust" datasource="#dts#">
        SELECT taxincl_cust from #target_apvend# where custno = '#form.custno#'
        </cfquery>
        <cfelse>
        <cfquery name="gettaxinclcust" datasource="#dts#">
        SELECT taxincl_cust from #target_arcust# where custno = '#form.custno#'
        </cfquery>
		</cfif>

        <cfset form.taxincl = gettaxinclcust.taxincl_cust>
        </cfif>
        </cfif>

		<!--- ADD ON 17-08-2009 --->
		<cfif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV">
			<cfif form.remark10 neq "" and isdate(form.remark10) eq "Yes" and form.remark11 eq "">
				<cfset date1=createDate(ListGetAt(form.remark10,3,"/"),ListGetAt(form.remark10,2,"/"),ListGetAt(form.remark10,1,"/"))>
				<cfset form.remark11=dateformat(DateAdd("d", 364, date1),"dd/mm/yyyy")>
			</cfif>
		</cfif>
		<!--- ADD ON 01-10-2009 --->
		<cfif lcase(HcomID) eq "ovas_i" and (tran eq "CS" or tran eq "SAM")>
			<cfif form.driver neq "">
				<cfquery name="getdriver" datasource="#dts#">
	            	select name,name2,add1,add2,add3,'' as add4,attn,phone,phonea as hphone,fax
					from driver
	                where driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.driver#">
	            </cfquery>
				<cfset form.remark0="">
	            <cfset form.frem0=getdriver.name>
			  	<cfset form.frem1=getdriver.name2>
			  	<cfset form.frem2=getdriver.add1>
			  	<cfset form.frem3=getdriver.add2>
			  	<cfset form.frem4=getdriver.add3>
			  	<cfset form.frem5=getdriver.add4>
			  	<cfset form.remark13="">
			  	<cfset form.remark2=getdriver.attn>
			  	<cfset form.remark4=getdriver.phone>
			  	<cfset form.frem6=getdriver.fax>
			  	<cfset form.phonea=getdriver.hphone>
			</cfif>
		</cfif>
		<!--- MODIFIED ON 26-10-2009 --->
		<!--- <cfif lcase(hcomid) eq "net_i">
			<cfset dnote = 'STAX'>
		<cfelseif lcase(hcomid) eq "lioncity_i" or lcase(hcomid) eq "ugateway_i">
			<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
				<cfset dnote = 'PTAX'>
			<cfelseif tran eq "CS" or tran eq 'INV' or tran eq 'DO' or tran eq 'QUO' or tran eq 'SO'>
				<cfset dnote = 'STAX'>
			<cfelse>
				<cfset dnote = ''>
			</cfif>
		<cfelseif lcase(hcomid) eq "iaf_i">
			<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
				<cfset dnote = 'TX7'>
			<cfelse>
				<cfset dnote = 'SR'>
			</cfif>
		<cfelse>
			<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
				<cfset dnote = ''>
			<cfelse>
				<cfset dnote = 'STAX'>
			</cfif>
		</cfif> --->

		<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
			<cfset dnote=getGeneralInfo.df_purchasetax>
		<cfelse>
			<cfset dnote=getGeneralInfo.df_salestax>
		</cfif>
        <cftry>
            <cfquery datasource='#dts#' name='insertartran'>
                Insert into artran (type,refno,refno2,custno,desp,despa,fperiod,wos_date,agenno,currrate,
                term,source,job,pono,dono,sono,rem0,rem1,rem2,rem3,rem4,rem5,rem6,rem7,rem8,rem9,rem10,rem11,permitno,rem12,
                rem13,rem14,frem0,frem1,frem2,frem3,frem4,frem5,frem6,frem7,frem8,frem9,comm1,comm2,comm3,comm4,phonea,E_mail,
                name,toinv,exported,van,trdatetime,userid,currcode,comm0,taxincl,created_by,created_on,updated_by,updated_on,note
                <cfif getgsetup.addonremark eq 'Y'>
                ,rem30,rem31,rem32,rem33,rem34,rem35,rem36,rem37,rem38,rem39,rem40,rem41,rem42,rem43,rem44,rem45,
                rem46,rem47,rem48,rem49
                </cfif>
                <cfif getgsetup.multiagent eq 'Y'>
                ,multiagent1,multiagent2,multiagent3,multiagent4,multiagent5,multiagent6,multiagent7,multiagent8
                </cfif>
                <cfif lcase(hcomid) eq 'iel_i' or lcase(hcomid) eq 'ielm_i'>
                    ,rem15,rem16,rem17,rem18,rem19,rem20,rem21,rem22,rem23,rem24,rem25

                </cfif>
                <cfif lcase(hcomid) eq 'ugateway_i'>
            	,via
				</cfif>
                <cfif lcase(hcomid) eq "accord_i" and tran eq "INV">
                ,checkno
				</cfif>
                <cfif getgsetup.transactiondate eq 'Y'>
                ,tran_date
                </cfif>
                )

                values('#tran#','#nexttranno#','#refno2#','#form.custno#','#desp#','#despa#','#numberformat(readperiod,"00")#',
                #nDateCreate#,'#form.agenno#','#currrate#','#form.terms#',<cfif getgsetup.soautocreaproj eq 'Y' and tran eq 'SO'>'#nexttranno#'<cfelse>'#form.source#'</cfif>,'#form.job#',
                '#form.pono#','#form.dono#','#form.sono#','#form.remark0#','#form.remark1#', '#form.remark2#','#form.remark3#',
                '#form.remark4#','#form.remark5#','#form.remark6#', '#form.remark7#','#form.remark8#',
                <cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">
					<cfif form.remark9 neq "">
                    	<cfinvoke component="cfc.date" method="getDbDate" inputDate="#form.remark9#" returnvariable="remark9"/>
					<cfelse>
						<cfset form.remark9='0000-00-00'>
					</cfif>
					<cfif form.remark11 neq "">
                    	<cfinvoke component="cfc.date" method="getDbDate" inputDate="#form.remark11#" returnvariable="remark11"/>
					<cfelse>
						<cfset form.remark11='0000-00-00'>
					</cfif>
                    '#remark9#', '#form.remark10#','#remark11#', '#permitno#',
                <cfelseif (lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i") and tran eq "PO">
                    <cfif form.remark9 neq "">
                        <cfset remark9 = createDate(ListGetAt(form.remark9,3,"/"),ListGetAt(form.remark9,2,"/"),ListGetAt(form.remark9,1,"/"))>
                        #remark9#
                    <cfelse>
                        '#form.remark9#'
                    </cfif>
                    ,'#form.remark10#','#form.remark11#','#permitno#',
                <cfelse>
                    '#form.remark9#', '#form.remark10#','#form.remark11#', '#permitno#',
                </cfif>
                '#form.remark12#','#form.remark13#','#form.remark14#',
                '#form.frem0#','#form.frem1#','#form.frem2#','#form.frem3#','#form.frem4#','#form.frem5#',
                '#form.frem6#','#form.frem7#','#form.frem8#','#form.frem9#','#form.comm1#','#form.comm2#','#form.comm3#',
                '#form.comm4#','#form.phonea#','#form.e_mail#',
				'#form.name#','','','#form.driver#','#nowDatetime#', '#HUserID#','#listfirst(form.refno3)#','#form.comm0#',
                '#form.taxincl#','#HUserID#',#now()#,'#HUserID#',#now()#,'#dnote#'
                <cfif getgsetup.addonremark eq 'Y'>
                ,'#form.remark30#','#form.remark31#','#form.remark32#','#form.remark33#','#form.remark34#'
                    ,'#form.remark35#','#form.remark36#','#form.remark37#','#form.remark38#','#form.remark39#'
                    ,'#form.remark40#'
                    ,'#form.remark41#','#form.remark42#','#form.remark43#','#form.remark44#','#form.remark45#'
                    ,'#form.remark46#','#form.remark47#','#form.remark48#','#form.remark49#'
                </cfif>
                <cfif getgsetup.multiagent eq 'Y'>
                ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.multiagent1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.multiagent2#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.multiagent3#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.multiagent4#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.multiagent5#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.multiagent6#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.multiagent7#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.multiagent8#">
				</cfif>
                <cfif lcase(hcomid) eq 'iel_i' or lcase(hcomid) eq 'ielm_i'>
                    ,'#form.remark15#','#form.remark16#','#form.remark17#','#form.remark18#','#form.remark19#'
                    ,'#form.remark20#','#form.remark21#','#form.remark22#','#form.remark23#','#form.remark24#'
                    ,'#form.remark25#'
                </cfif>
                <cfif lcase(hcomid) eq 'ugateway_i'>
            	 ,'#form.via#'
			</cfif>
            <cfif lcase(hcomid) eq "accord_i" and tran eq "INV">
                ,'#form.checkno#'
				</cfif>
            <cfif getgsetup.transactiondate eq 'Y'>
                ,'#nDatecreatetran#'
                </cfif>
                )
            </cfquery>
            <cfif getgsetup.soautocreaproj eq 'Y' and tran eq "SO">
            <cfquery datasource='#dts#' name='insertnewproject'>
            insert into project (source,project,porj) values ('#nexttranno#','#nexttranno#','P')
            </cfquery>
			</cfif>

        <cfif isdefined('getGeneralInfo.appDisSupCus')>
        <cfif getGeneralInfo.appDisSupCus eq "Y" and tran neq "CN" or tran neq "DN">
        <cfif tran eq 'rc' or tran eq 'pr' or tran eq 'po'>
        <cfquery name="getdisccust" datasource="#dts#">
        SELECT dispec1,dispec2,dispec3 from #target_apvend# where custno = '#form.custno#'
        </cfquery>
        <cfelse>
        <cfquery name="getdisccust" datasource="#dts#">
        SELECT dispec1,dispec2,dispec3 from #target_arcust# where custno = '#form.custno#'
        </cfquery>
        </cfif>
        <cfquery name="updateartrandisc" datasource="#dts#">
        UPDATE artran SET
        disp1 = "#val(getdisccust.dispec1)#",
        disp2 = "#val(getdisccust.dispec2)#",
        disp3 = "#val(getdisccust.dispec3)#"
        WHERE
        type = '#tran#'
        and refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nexttranno#">
        and custno = "#form.custno#"
        </cfquery>

		</cfif>
		</cfif>

        <cfcatch type="any">
        	<cfoutput>#cfcatch.Message#::#cfcatch.Detail#</cfoutput>
            <cfabort />
        </cfcatch>
        </cftry>

		<cfif lcase(HcomID) eq "avent_i">
			<cfquery datasource='#dts#' name='insertcomment'>
				Insert into artran_remark
				(TYPE,REFNO,REMARK1,REMARK2,REMARK3)
				values
				('#tran#','#nexttranno#','#form.comment_selected#',
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.xremark3#">)
			</cfquery>
		<cfelseif lcase(HcomID) eq "topsteel_i" or lcase(HcomID) eq "topsteelhol_i">
			<cfquery datasource='#dts#' name='insertcomment'>
				Insert into artran_remark
				(TYPE,REFNO,REMARK1,REMARK2)
				values
				('#tran#','#nexttranno#','#form.xremark1#','#form.xremark2#')
			</cfquery>
		<cfelseif lcase(HcomID) eq "winbells_i">
			<cfquery datasource='#dts#' name='insertcomment'>
				Insert into artran_remark
				(TYPE,REFNO,REMARK1,REMARK2,REMARK3,REMARK4,REMARK5,REMARK6,REMARK7,REMARK8,REMARK9,REMARK10,
				REMARK11,REMARK12,REMARK13,REMARK14,REMARK15,REMARK16,REMARK17)
				values
				('#tran#','#nexttranno#',<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark5#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark6#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark7#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark8#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark9#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark10#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark11#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark12#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark13#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark14#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark15#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark16#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark17#">)
			</cfquery>
        <cfelseif lcase(HcomID) eq "iel_i">
			<cfquery datasource='#dts#' name='insertcomment'>
				Insert into artran_remark
				(TYPE,REFNO,REMARK1,REMARK2,REMARK3,REMARK4)
				values
				('#tran#','#nexttranno#',<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">)
			</cfquery>
		<cfelseif lcase(HcomID) eq "zeadine_i" or lcase(HcomID) eq "zeadine09_i">
			<cfquery datasource='#dts#' name='insertcomment'>
				Insert into artran_remark
				(TYPE,REFNO,REMARK1)
				values
				('#tran#','#nexttranno#','#form.xremark1#')
			</cfquery>
		<cfelseif lcase(HcomID) eq "chemline_i">
			<cfquery datasource='#dts#' name='insertcomment'>
				Insert into artran_remark
				(TYPE,REFNO,REMARK1,REMARK2,REMARK3,REMARK4,REMARK5,REMARK6,REMARK7,REMARK8)
				values
				('#tran#','#nexttranno#',<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark5#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark6#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark7#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.comment_selected#">)
			</cfquery>
		<cfelseif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
			<cfquery datasource='#dts#' name='insertcomment'>
				Insert into artran_remark
				(TYPE,REFNO,REMARK1,REMARK2)
				values
				('#tran#','#nexttranno#',
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">)
			</cfquery>
		<cfelseif lcase(HcomID) eq "probulk_i">
			<cfquery datasource='#dts#' name='insertcomment'>
				Insert into artran_remark
				(TYPE,REFNO,REMARK1,REMARK2,REMARK3,REMARK4,REMARK5,REMARK6,REMARK7)
				values
				('#tran#','#nexttranno#',
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark1#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark2#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark3#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark4#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark5#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.xremark6#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#val(form.xremark7)#">)
			</cfquery>
		</cfif>
	</cfif>
</cfif>

<!--- <cfset nextinvno= 'INV00021'> --->
<cfif tran eq 'rc' or tran eq 'pr' or tran eq 'po'>
	<cfquery name='getcust' datasource='#dts#'>
		select name from #target_apvend# where custno = '#custno#'
	</cfquery>
	<cfset ptype = words[104]>
<cfelse>
	<cfquery name='getcust' datasource='#dts#'>
		select name from #target_arcust# where custno = '#custno#'
	</cfquery>
	<cfset ptype = words[5]>
</cfif>

<cfif lcase(hcomid) neq "steel_i">
	<cfquery name='getitem' datasource='#dts#'>
		select itemno, desp from icitem where (nonstkitem<>'T' or nonstkitem is null)
        <cfif tran eq 'rc' or tran eq 'pr' or tran eq 'po'>
                    and (itemtype = "P" or itemtype = "")
					<cfelse>
                    and (itemtype = "S" or itemtype = "")
					</cfif>
        <cfif Hitemgroup neq ''>
        and wos_group='#Hitemgroup#'
        </cfif>
        <cfif lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i">
                    and wos_group = (SELECT coalesce(agent,'') from <cfif tran eq 'rc' or tran eq 'pr' or tran eq 'po'>#target_apvend#<cfelse>#target_arcust#</cfif> WHERE custno = "#custno#")
					</cfif>
		order by <cfif lcase(hcomid) eq "glenn_i">desp<cfelse>itemno</cfif>
	</cfquery>
</cfif>

<cfquery name='getservice' datasource='#dts#'>
	select servi, desp from icservi order by servi
</cfquery>
<!--- Control The Decimal Point --->
<cfquery name='getgsetup2' datasource='#dts#'>
  	select concat('.',repeat('_',Decl_Uprice)) as Decl_Uprice,DECL_TOTALAMT as Decl_Uprice1, concat('.',repeat('_',DECL_DISCOUNT)) as DECL_DISCOUNT1, DECL_DISCOUNT from gsetup2
</cfquery>

<cfset stDecl_UPrice=getgsetup2.Decl_Uprice>
<cfset stDecl_Disc=getgsetup2.DECL_DISCOUNT1>

<cfquery name='getgeneralinfo' datasource='#dts#'>
	select gst,filteritem,filterall,
	invoneset,rc_oneset,pr_oneset,do_oneset,cs_oneset,cn_oneset,dn_oneset,iss_oneset,
	po_oneset,so_oneset, quo_oneset, assm_oneset, tr_oneset, oai_oneset, oar_oneset, sam_oneset, multilocation,wpitemtax,wpitemtax1,EAPT,voucher,filteritemAJAX,voucherbal,asvoucher,voucherb4disc
	from gsetup
</cfquery>

<cfset multilocation = "">
<cfif getGeneralInfo.multilocation neq "">
	<cfif ListFindNoCase(getgeneralinfo.multilocation, tran, ",") neq 0>
		<cfset multilocation = "Y">
	</cfif>
</cfif>

<!--- ADD ON 30-07-2009 --->
<cfset wpitemtax="">
<cfif getGeneralInfo.wpitemtax eq "1">
	<cfif getGeneralInfo.wpitemtax1 neq "">
    	<cfif ListFindNoCase(getgeneralinfo.wpitemtax1, tran, ",") neq 0>
			<cfset wpitemtax = "Y">
        </cfif>
	<cfelse>
    	<cfset wpitemtax="Y">
	</cfif>
</cfif>

<cfif multilocation neq "Y">
	<cfquery name='getictran' datasource='#dts#'>
		select * from ictran where refno='#nexttranno#' and type='#tran#' order by itemcount
	</cfquery>

	<cfif getictran.recordcount eq 0>
		<cfset newtrancode=1>
	<cfelse>
		<cfset newtrancode=getictran.recordcount+1>
	</cfif>
<cfelse>
	<cfquery name='getictran' datasource='#dts#'>
		select sum(qty_bil) as qty_bil,sum(amt_bil) as amt_bil,sum(qty) as qty,sum(amt1_bil) as amt1_bil,sum(TAXAMT_BIL) as TAXAMT_BIL,
		itemno,desp,despa,custno,price_bil,grade,linecode,'' as itemcount,'' as batchcode,note_a,taxincl
		from ictran
		where refno='#nexttranno#'
		and type='#tran#'
		and ( linecode <>  'SV' or linecode is null)
		group by itemno,desp,despa,custno,price_bil,grade,linecode,note_a

		union

		select qty_bil,amt_bil,qty,amt1_bil,TAXAMT_BIL,
		itemno,desp,despa,custno,price_bil,grade,linecode,itemcount,batchcode,note_a,taxincl
		from ictran
		where refno='#nexttranno#'
		and type='#tran#'
		and linecode = 'SV'
	</cfquery>
	<cfquery name="getnewtrancode" datasource="#dts#">
		select max(trancode) as newtrancode
		from ictran
		where refno='#nexttranno#'
		and type='#tran#'
	</cfquery>
	<cfif getnewtrancode.recordcount eq 0>
		<cfset newtrancode=1>
	<cfelse>
		<cfset newtrancode = val(getnewtrancode.newtrancode)+1>
	</cfif>
</cfif>


<html>
<head>
	<title><cfoutput>#tranname#</cfoutput></title>
	<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

	<script type='text/javascript' src='../../ajax/core/engine.js'></script>
	<script type='text/javascript' src='../../ajax/core/util.js'></script>
	<script type='text/javascript' src='../../ajax/core/settings.js'></script>
</head>

<OBJECT CLASSID="clsid:333C7BC4-460F-11D0-BC04-0080C7055A83" ID="feedcontact1" WIDTH="0" HEIGHT="0">
<PARAM NAME="FieldDelim" VALUE="|"><PARAM NAME="UseHeader" VALUE="True"></OBJECT>
<script for="feedcontact1" event="ondatasetcomplete">show_info(this.recordset);</script>

<script type='text/javascript' src='../../ajax/core/util.js'></script>

<script language="javascript" type="text/javascript">
<cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">
function trim1 (str) {
				var	str = str.replace(/^\s\s*/, ''),
					ws = /\s/,
					i = str.length;
				while (ws.test(str.charAt(--i)));
				return str.slice(0, i + 1);
			}

	function getselectadd(event)
	{
	var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
			if(keyCode==13){

			var getitemnostring = document.getElementById('itemselect').value;

			var itemnofield = document.getElementById('itemno');
				var mySplitResult = getitemnostring.split("    ");
				var spliresult = trim1(mySplitResult[3]);
				splitresult = spliresult.toLowerCase();
				for (var idx=0;idx<itemnofield.options.length;idx++)
				{
					if (spliresult==trim(itemnofield.options[idx].value).toLowerCase())
					{
						itemnofield.options[idx].selected=true;
						releaseDirtyFlag();
						form.submit();
						return true;

					}
				}

			return false;}
			return true;
	}
</cfif>

	function settaxcode()
	{
	<cfoutput>
	var tran='#tran#'
	</cfoutput>
	if(tran=='PO'||tran=='PR'||tran=='RC' ){
	if(document.getElementById('pTax').value==0)
	{
	<cfoutput>
	for (var idx=0;idx<document.getElementById('selecttax').options.length;idx++)
		{
			if ('#getgsetup.df_purchasetaxzero#'==document.getElementById('selecttax').options[idx].value)
			{
				document.getElementById('selecttax').options[idx].selected=true;

			}
		}
	</cfoutput>
	}
	}
	else{
	if(document.getElementById('pTax').value==0)
	{
	<cfoutput>
	for (var idx=0;idx<document.getElementById('selecttax').options.length;idx++)
		{
			if ('#getgsetup.df_salestaxzero#'==document.getElementById('selecttax').options[idx].value)
			{
				document.getElementById('selecttax').options[idx].selected=true;

			}
		}
	</cfoutput>
	}
	}
	}

	function updateVal()
	{
	var validdesp = document.getElementById('desphid').value;
	var droplist = document.getElementById('expunit');

	  while (droplist.length > 0)
	  {
		  droplist.remove(droplist.length - 1);
	  }


	if (validdesp == "itemisnoexisted")
	{
	document.getElementById('btn_add').value = "Item No Existed";
	document.getElementById('btn_add').disabled = true;
	}
	else
	{
	var commaSeparatedValueList = document.getElementById('unithid').value;
	var valueArray = commaSeparatedValueList.split(",");
	for(var i=0; i<valueArray.length; i++){
		var opt = document.createElement("option");
        document.getElementById("expunit").options.add(opt);
        opt.text = valueArray[i];
        opt.value = valueArray[i];

	}
	document.getElementById('desp').value = document.getElementById('desphid').value;
	document.getElementById('expunit').selectedIndex =0;
	document.getElementById('expprice').value = document.getElementById('pricehid').value;
	document.getElementById('btn_add').value = "Add";
	document.getElementById('btn_add').disabled = false;
	}
	}

	function searchSel(fieldid,textid) {
  var input=document.getElementById(textid).value.toLowerCase();
  var output=document.getElementById(fieldid).options;
  for(var i=0;i<output.length;i++) {
    if(output[i].text.toLowerCase().indexOf(input)>=0 && i != 0){
      output[i].selected=true;
	  break;
      }
    if(document.getElementById(textid).value==''){
      output[0].selected=true;
      }
  }
}

	function caldisamt()
	{
	var qtydis = document.getElementById('expqtycount').value;
	var disamt = document.getElementById('expunitdis').value;
	qtydis = qtydis * 1;
	disamt = disamt * 1;
	var totaldiscount = qtydis * disamt;
	document.getElementById('expdis').value = totaldiscount.toFixed(2);
	}
	<cfoutput>
	var fixnum=#getgsetup2.Decl_UPrice1#;
	var fixnumdisc=#getgsetup2.DECL_DISCOUNT#;
	var default_gst=#val(getGeneralInfo.gst)#;
	var hcomid='#lcase(hcomid)#';
	var tran='#tran#';
	var wpitemtax='#wpitemtax#';
	</cfoutput>
	function init()
	{
		<cfif isdefined ('url.complete') or type eq 'Edit'>
		getDiscountControl();
		getDepositCount();
		getCashCount();
		getChequeCount();
		getCredit_Card1Count();
		getCredit_Card2Count();
		getGift_VoucherCount();
		</cfif>
		<cfif hcomid eq "pnp_i">
			document.getElementById("cash").select();
		</cfif>
		<cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">
document.getElementById('itemselect').focus();
</cfif>
	}

	function assignvoucher(vcode,vvalue,vtype)
	{

	var billgrand1 = document.getElementById('subtotal').value * 1;
	var billgrand = document.getElementById('viewGrand').value * 1;

	if(vtype == "Value")
	{
	vvalue = vvalue * 1;
	<cfif getgeneralinfo.voucherbal eq "Y">
	if (vvalue > 0)
	{
	document.getElementById('gift_voucher').readOnly=true;
	}
	else
	{
	document.getElementById('gift_voucher').readOnly=false;
	}
	</cfif>
	if (vvalue >=<cfif getgeneralinfo.voucherb4disc eq "Y">billgrand1<cfelse>billgrand</cfif>)
	{
	document.getElementById('gift_voucher').value = billgrand;
	}
	else
	{
	<cfif (lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i") and tran neq "CN">
	document.getElementById('gift_voucher').readOnly=false;
	alert('Voucher Value is Not Enough');
	document.getElementById('vouchernum').selectedIndex = 0;
	return false;
	</cfif>
	document.getElementById('gift_voucher').value = vvalue.toFixed(2);
	}
	}
	else
	{
	var totalamount = document.getElementById('viewGrand').value;
	var totalvouc = (vvalue/100) * totalamount;
	<cfif getgeneralinfo.voucherbal eq "Y">
	if (totalvouc > 0)
	{
	document.getElementById('gift_voucher').readOnly=true;
	}
	else
	{
	document.getElementById('gift_voucher').readOnly=false;
	}
	</cfif>
	if (totalvouc >= <cfif getgeneralinfo.voucherb4disc eq "Y">billgrand1<cfelse>billgrand</cfif>)
	{
	document.getElementById('gift_voucher').value = billgrand;
	}
	else
	{
	document.getElementById('gift_voucher').value = totalvouc.toFixed(2);
	}
	}
	getGift_VoucherCount();
	/*var disamt = document.getElementById('totalamtdisc_id').value * 1;
	var voucamt = document.getElementById('gift_voucher').value * 1;
	document.getElementById('totalamtdisc_id').value = disamt + voucamt;
	getDiscountControl();*/
	}

	function getItem(){
		var text = document.form.letter.value;
		var w = document.form.searchtype.selectedIndex;
		var searchtype = document.form.searchtype.options[w].value;
		if(text != ''){
			document.all.feedcontact1.dataurl="databind/act_getitem.cfm?searchtype=" + searchtype + "&text=" + text;
			//prompt("D",document.all.feedcontact1.dataurl);
			document.all.feedcontact1.charset=document.charset;
			document.all.feedcontact1.reset();
		}
	}

	function show_info(rset){
		rset.MoveFirst();
		DWRUtil.removeAllOptions("itemno");
		newArray = unescape(rset.fields("itemnolist").value);
		var itemnoArray = newArray.split(";;");
		newArray2 = unescape(rset.fields("itemdesclist").value);
		var itemdescArray = newArray2.split(";;");

		for(i=0;i<itemnoArray.length;i++){

			myoption = document.createElement("OPTION");
			if(itemnoArray[i] == '-1'){
				myoption.text = itemdescArray[i];
			}else{
				myoption.text = itemnoArray[i] + " - " + itemdescArray[i];
			}

			myoption.value = itemnoArray[i];
			document.form.itemno.options.add(myoption);
		}
		//Add On 30-12-2009
		if(document.getElementById("itemno").value !='' && document.getElementById("itemno").value !='-1'){
			showImage(document.getElementById("itemno").value);
		}
	}

	function getProduct(){
		var inputtext = document.form.searchitemto.value;
		DWREngine._execute(_tranflocation, null, 'productlookup', inputtext, getProductResult);
	}

	function getProductResult(itemArray){
		DWRUtil.removeAllOptions("itemno");
		DWRUtil.addOptions("itemno", itemArray,"KEY", "VALUE");
	}

	function getService(servi,servidesp){
		myoption = document.createElement("OPTION");
		myoption.text = servi + " - " + servidesp;
		myoption.value = servi;
		document.form.service.options.add(myoption);
		var indexvalue = document.getElementById("service").length-1;
		document.getElementById("service").selectedIndex=indexvalue;
	}

	function check_witempertax(){
		if(wpitemtax == 'Y'){
			if(document.getElementById("taxincl").checked==true){
				var taxincl='T';
			}else{
				var taxincl='F';
			}

			var tran=document.form.tran.value;
			var refno=document.form.nexttranno.value;
			DWREngine._execute(_tranflocation, null, 'updatetax', tran, refno, taxincl, getTaxResult);
		}
	}

	function getTaxResult(taxObject){
		var taxamt=parseFloat(taxObject.TTAXAMT_BIL);
		DWRUtil.setValue("totalamttax", taxamt);
		check_taxincls();
	}

	//function showImage: Add On 30-12-2009
	function showImage(thisitemno){
		if(thisitemno=='' || thisitemno=='-1'){
			var newHTML ="";
		}else{
			var newHTML = "&nbsp;| <a href='view_image.cfm?itemno="+escape(thisitemno)+"' target='_blank'>IMAGE</a>";
		}
		document.getElementById("itemimages").innerHTML=newHTML;
	}

	function assignDisc(){
		checkboxObj=document.getElementById("assigndisc");
		checkboxObj.checked =false;
		var tran=document.form.tran.value;
		var refno=document.form.nexttranno.value;
		var opt = 'Width=500px, Height=350px, Top=200px, left=400px scrollbars=no, status=no';
		<cfoutput>window.open('dsp_assignDisc.cfm?type=' + tran + '&refno=' + refno, 'discwindow',opt);</cfoutput>
	}
</script>

<script language="javascript" type="text/javascript" src="/scripts/transaction_footer_calculation.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/transaction_footer_calculation_deposit.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/transaction_footer_calculation_cash.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/transaction_footer_calculation_cheque.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/transaction_footer_calculation_credit_card1.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/transaction_footer_calculation_credit_card2.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/transaction_footer_calculation_debit_card.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/transaction_footer_calculation_voucher.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/transaction_footer_calculation_tax_included.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/transaction_footer_calculation_telegraph_transfer.js"></script>

<cfif HcomID eq "bhl_i">
	<script language="javascript" type="text/javascript" src="/bhl/auto_fill_discount.js"></script>
</cfif>

<body <cfif hmode eq 'Create'>onLoad="init();"</cfif>>
<cfoutput>
	<h4>


		<a href='transaction.cfm?tran=#tran#'>List all #tranname#</a> ||
		<a href='stransaction.cfm?tran=#tran#&searchtype=&searchstr='>Search For #tranname#</a>
	</h4>
<!--- Add Items Button --->
<cfform name='form' id="form" action='transaction4.cfm?type1=Add&ndatecreate=#ndatecreate#&itemcount=0&multilocation=#multilocation#' method='post' onSubmit="releaseDirtyFlag();return validateAddItem();return false;">
    <input type='hidden' name='tran' value='#listfirst(tran)#'>
    <input type='hidden' name='currrate' value='#listfirst(currrate)#'>
    <input type='hidden' name='agenno' value='#listfirst(agenno)#'>
    <input type='hidden' name='refno3' value='#listfirst(refno3)#'>
    <input type='hidden' name='nexttranno' value='#listfirst(nexttranno)#'>
	<input type='hidden' name='hmode' value='#listfirst(hmode)#'>
    <input type='hidden' name='custno' value='#listfirst(custno)#'>
    <input type='hidden' name='readperiod' value='#listfirst(readperiod)#'>
    <input type='hidden' name='nDateCreate' value='#dateformat(listfirst(invoicedate),'dd/mm/yyyy')#'>
    <input type='hidden' name='nDateNow' value='#dateformat(now(),'dd/mm/yyyy')#'>
    <input type='hidden' name='invoicedate' value='#dateformat(listfirst(invoicedate),'dd/mm/yyyy')#'>

	<cfif checkcustom.customcompany eq "Y">
		<input type="hidden" name="remark5" value="#listfirst(remark5)#">	<!--- PERMIT NUMBER, ADD ON 24-03-2009 --->
		<input type="hidden" name="remark6" value="#listfirst(remark6)#">
	</cfif>

	<cfif isdefined("form.updunitcost")><input type='hidden' name='updunitcost' value='#form.updunitcost#'></cfif>

	<table width='85%' align='center' class='data' cellspacing="0">
    <tr>
		<th rowspan="2" nowrap width="18%">#tranname# #words[58]#</th>
		<td rowspan="2" nowrap width="20%"><h3>#nexttranno#</h3></td>
		<th nowrap width="15%">#tranname# #words[702]#</th>
		<td nowrap>#invoicedate#</td>
	</tr>
	 <tr>
		<th nowrap width="15%">#words[900]# #words[2060]# #words[58]#</th>
		<td nowrap><select name="newtrancode"><cfloop from="#newtrancode#" to="1" index="i" step="-1"><option value="#i#">#i#</option></cfloop></select></td>
	</tr>
	<tr>
		<th nowrap>#ptype#</th>
		<td colspan="3" nowrap>#custno# - #getcust.name#</td>
	</tr>
    <tr>
      	<td colspan="4"><hr></td>
   	</tr>
    <tr>
    	<th nowrap height="30"><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>#words[189]#<cfelse>#words[274]#</cfif> #words[438]#</th>
      	<td width='60%' colspan="3" nowrap>
            <cfquery name="getgsetup10" datasource="#dts#">
	select ddlitem from gsetup
      </cfquery>
		<cfif lcase(hcomid) eq "steel_i">
			<select id="itemno" name='itemno'></select> #words[1241]#:
			<input id="letter" name="letter" type="text" size="8" onKeyUp="getItem('0')"> in:
			<select id="searchtype" name="searchtype" onChange="resetLetter()">
				<cfloop list="itemno,mitemno,desp,category,wos_group,brand" index="i">
                <cfif #i# eq "itemno">
                <cfset sitemdesp ="Item No">
                <cfelseif #i# eq "mitemno">
                <cfset sitemdesp ="Product Code">
                <cfelseif #i# eq "desp">
                <cfset sitemdesp ="Description">
                <cfelseif #i# eq "category">
                <cfset sitemdesp ="Category">
                <cfelseif #i# eq "wos_group">
                <cfset sitemdesp ="Group">
                <cfelseif #i# eq "brand">
                <cfset sitemdesp ="Brand">
                </cfif>
                <option value="#i#" <cfif #sitemdesp# eq #getrefnolen.ddlitem#>selected</cfif>>#sitemdesp#</option>
                </cfloop>
			</select>
			<select id="itemno2" name='itemno2'>
              <option value='-1'>#words[1106]#</option>
              <cfloop query='getitem'>
                <option value="#convertquote(itemno)#">#itemno# - #desp#</option>
              </cfloop>
            </select>
			<input type='submit' name='submit2' value='#words[1109]#'>
		<cfelseif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i" or lcase(hcomid) eq "pnp_i">
        <select id="itemno" name='itemno'>
				<option value='-1'>#words[1106]#</option>
				<cfloop query='getitem'>
					<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
           		</cfloop>
       		</select>
		<cfif getgeneralinfo.filterall eq "1">
					<input type="text" name="searchitemto" onKeyUp="getProduct();" size="10">
			</cfif>
			<input type='submit' name='submit2' value='#words[1109]#'>
		<cfelse>
			<cfif getgeneralinfo.filteritem eq "1">
				<select id="itemno" name='itemno' onChange="showImage(this.value);">
					<option value='-1'>Please Filter The Item</option>
				</select> #words[1241]#:
				<input id="letter" name="letter" type="text" size="8" onKeyup="getItem()"> in:

				<select id="searchtype" name="searchtype" onChange="getItem()">
                    <cfloop list="itemno,desp,category,wos_group,brand" index="i">
                <cfif #i# eq "itemno">
                <cfset sitemdesp ="Item No">
                <cfelseif #i# eq "mitemno">
                <cfset sitemdesp ="Product Code">
                <cfelseif #i# eq "desp">
                <cfset sitemdesp ="Description">
                <cfelseif #i# eq "category">
                <cfset sitemdesp ="Category">
                <cfelseif #i# eq "wos_group">
                <cfset sitemdesp ="Group">
                <cfelseif #i# eq "brand">
                <cfset sitemdesp ="Brand">
                </cfif>
                <option value="#i#" <cfif #sitemdesp# eq #getgsetup10.ddlitem#>selected</cfif>>#sitemdesp#</option>
                </cfloop>
				</select>
				<input type='submit' name='submit2' value='#words[1109]#'>


                <cfif multilocation neq "Y">
                <!--- <input type="button" value="Express" name="ExpressBtn" onClick="javascript:ColdFusion.Window.show('expressproduct');"> --->
				</cfif>

			<cfelse>
            <cfif getgeneralinfo.filteritemAJAX eq "1" >
            <cfif isdefined("url.itemno1")>
            <cfset selecteditemno = url.itemno1>
			<cfelse>
            <cfset selecteditemno = "">
			</cfif>
            <cfquery name='getitemlist' datasource='#dts#'>
                    SELECT "Choose an Item" as itemdesp, "-1" as itemno
                    union all
                    select concat(itemno," - ",desp) as itemdesp, itemno from icitem
                    where (nonstkitem<>'T' or nonstkitem is null)
                    <cfif tran eq 'rc' or tran eq 'pr' or tran eq 'po'>
                    and (itemtype = "P" or itemtype = "")
					<cfelse>
                    and (itemtype = "S" or itemtype = "")
					</cfif>
                    <cfif Hitemgroup neq ''>
                    and wos_group='#Hitemgroup#'
                    </cfif>
					<cfif lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i">
                    and wos_group = (SELECT coalesce(agent,'') from <cfif tran eq 'rc' or tran eq 'pr' or tran eq 'po'>#target_apvend#<cfelse>#target_arcust#</cfif> WHERE custno = "#custno#")
					</cfif>
                    order by itemno
                    </cfquery>

            <cfselect name="itemno" id="itemno" onChange="showImage(this.value);" query="getitemlist" display="itemdesp" value="itemno" selected="#URLDECODE(selecteditemno)#" />
            <cfelse>
				<select id="itemno" name='itemno' onChange="showImage(this.value);">
       				<option value='-1'>#words[1106]#</option>
					<cfloop query='getitem'><option value="#convertquote(itemno)#" <cfif isdefined("url.itemno1") and getitem.itemno eq url.itemno1>selected</cfif>><cfif lcase(hcomid) eq "mhca_i">#desp# - #itemno#<cfelse>#itemno# - #desp#</cfif></option>
           			</cfloop>
       			</select>
             </cfif>
             <cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">
            <input type="text" name="itemnoselect" id="itemselect" value="" onKeyPress="return getselectadd(event)">
			</cfif>
				<input type='submit' name='submit2' value='#words[1109]#'>
                <cfif multilocation neq "Y">
                <!--- <input type="button" value="Express" name="ExpressBtn" onClick="javascript:ColdFusion.Window.show('expressproduct');"> --->
				</cfif>
				<cfif multilocation neq "Y" and tran eq 'SO' and getgsetup.projectcompany eq 'Y'>
               <!---  <input type="button" value="Material" name="MatBtn" onClick="javascript:ColdFusion.Window.show('matproduct');"> --->
				</cfif>
				<!--- <a href='tranitemsearch.cfm?tran=#tran#&stype=#tran#&hmode=#hmode#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(listfirst(custno))#&invoicedate=#URLEncodedFormat(listfirst(invoicedate))#&readperiod=#readperiod#&ndatecreate=#URLEncodedFormat(listfirst(ndatecreate))#&currrate=#URLEncodedFormat(listfirst(currrate))#&refno3=#URLEncodedFormat(listfirst(refno3))#&agenno=#URLEncodedFormat(listfirst(agenno))#'>SEARCH</a>&nbsp;|&nbsp;
            	<a href='historysearch.cfm?tran=#tran#&hmode=#hmode#&stype=#tran#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(listfirst(custno))#&invoicedate=#URLEncodedFormat(listfirst(invoicedate))#&readperiod=#readperiod#&ndatecreate=#URLEncodedFormat(listfirst(ndatecreate))#&currrate=#URLEncodedFormat(listfirst(currrate))#&refno3=#URLEncodedFormat(listfirst(refno3))#&agenno=#URLEncodedFormat(listfirst(agenno))#'>HISTORY</a> --->
				<cfif checkcustom.customcompany eq "Y">
					<!--- ADD PERMIT NUMBER, ADD ON 24-03-2009 --->
					<!--- <a  onMouseOver="JavaScript:this.style.cursor='hand';" onClick="javascript:ColdFusion.Window.show('searchitem');">AS</a>&nbsp;&nbsp;| ---><a onClick="releaseDirtyFlag();"  href='tranitemsearch.cfm?tran=#tran#&stype=#tran#&hmode=#hmode#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(listfirst(custno))#&invoicedate=#URLEncodedFormat(listfirst(invoicedate))#&readperiod=#readperiod#&ndatecreate=#URLEncodedFormat(listfirst(ndatecreate))#&currrate=#URLEncodedFormat(listfirst(currrate))#&refno3=#URLEncodedFormat(listfirst(refno3))#&agenno=#URLEncodedFormat(listfirst(agenno))#&remark5=#URLEncodedFormat(listfirst(remark5))#&remark6=#URLEncodedFormat(listfirst(remark6))#'>#words[11]#</a>&nbsp;<!--- |&nbsp;<a  onMouseOver="JavaScript:this.style.cursor='hand';" onClick="javascript:ColdFusion.Window.show('historyitem');">HS</a>&nbsp; --->|&nbsp;
	            	<a onClick="releaseDirtyFlag();" href='historysearch.cfm?tran=#tran#&hmode=#hmode#&stype=#tran#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(listfirst(custno))#&invoicedate=#URLEncodedFormat(listfirst(invoicedate))#&readperiod=#readperiod#&ndatecreate=#URLEncodedFormat(listfirst(ndatecreate))#&currrate=#URLEncodedFormat(listfirst(currrate))#&refno3=#URLEncodedFormat(listfirst(refno3))#&agenno=#URLEncodedFormat(listfirst(agenno))#&remark5=#URLEncodedFormat(listfirst(remark5))#&remark6=#URLEncodedFormat(listfirst(remark6))#'>HISTORY</a>
				<cfelse>
					<!--- <a  onMouseOver="JavaScript:this.style.cursor='hand';" onClick="javascript:ColdFusion.Window.show('searchitem');">AS</a>&nbsp;&nbsp;| ---><a onClick="releaseDirtyFlag();" href='tranitemsearch.cfm?tran=#tran#&stype=#tran#&hmode=#hmode#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(listfirst(custno))#&invoicedate=#URLEncodedFormat(listfirst(invoicedate))#&readperiod=#readperiod#&ndatecreate=#URLEncodedFormat(listfirst(ndatecreate))#&currrate=#URLEncodedFormat(listfirst(currrate))#&refno3=#URLEncodedFormat(listfirst(refno3))#&agenno=#URLEncodedFormat(listfirst(agenno))#'>#words[11]#</a>&nbsp;<!--- |&nbsp;<a  onMouseOver="JavaScript:this.style.cursor='hand';" onClick="javascript:ColdFusion.Window.show('historyitem');">HS</a>&nbsp; --->|&nbsp;
	            	<a onClick="releaseDirtyFlag();" href='historysearch.cfm?tran=#tran#&hmode=#hmode#&stype=#tran#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(listfirst(custno))#&invoicedate=#URLEncodedFormat(listfirst(invoicedate))#&readperiod=#readperiod#&ndatecreate=#URLEncodedFormat(listfirst(ndatecreate))#&currrate=#URLEncodedFormat(listfirst(currrate))#&refno3=#URLEncodedFormat(listfirst(refno3))#&agenno=#URLEncodedFormat(listfirst(agenno))#'>HISTORY</a>
				</cfif>
			</cfif>

			<!--- REMARK ON 100608 AND REPLACE WITH THE UPPER ONE, LET THE USER CAN FILTER THE ITEM --->
			<!---select id="itemno" name='itemno'>
       			<option value='-1'>Choose an Item</option>
				<cfloop query='getitem'><option value='#itemno#' <cfif isdefined("url.itemno1") and getitem.itemno eq url.itemno1>selected</cfif>>#itemno# - #desp#</option>
           		</cfloop>
       		</select>
			<input type='submit' name='submit2' value='Add Item'>

			<a href='tranitemsearch.cfm?tran=#tran#&stype=#tran#&hmode=#hmode#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(listfirst(custno))#&invoicedate=#URLEncodedFormat(listfirst(invoicedate))#&readperiod=#readperiod#&ndatecreate=#URLEncodedFormat(listfirst(ndatecreate))#&currrate=#URLEncodedFormat(listfirst(currrate))#&refno3=#URLEncodedFormat(listfirst(refno3))#&agenno=#URLEncodedFormat(listfirst(agenno))#'>SEARCH</a>&nbsp;|&nbsp;
            <a href='historysearch.cfm?tran=#tran#&hmode=#hmode#&stype=#tran#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(listfirst(custno))#&invoicedate=#URLEncodedFormat(listfirst(invoicedate))#&readperiod=#readperiod#&ndatecreate=#URLEncodedFormat(listfirst(ndatecreate))#&currrate=#URLEncodedFormat(listfirst(currrate))#&refno3=#URLEncodedFormat(listfirst(refno3))#&agenno=#URLEncodedFormat(listfirst(agenno))#'>HISTORY</a--->
		</cfif>
        <cfif lcase(hcomid) eq "nikbra_i">
			| <a href="/customized/#dts#/upload_excel.cfm?tran=#tran#&refno=#nexttranno#&custno=#form.custno#&currrate=#currrate#">UPLOAD EXCEL</a>
		</cfif>
		<!--- Add On 30-12-2009 --->
		<label id="itemimages"><cfif isdefined("url.itemno1")>&nbsp;| <a href="view_image.cfm?itemno=#url.itemno1#" target="_blank">IMAGE</a></cfif></label>		</td>
    </tr>
    <tr>
      	<th nowrap height="30">#words[294]#</th>
      	<td colspan="3" nowrap>
		<select name='service'>
        	<option value=''>#words[1831]#</option>
          	<cfloop query='getservice'>
				<cfif getservice.servi eq ""><option value='Unnamed'>Unnamed - #desp#</option>
				<cfelse><option value='#servi#'>#servi# - #desp#</option>
				</cfif>
          	</cfloop>
		</select>
		<input type='submit' name='submit22' value='Add Service'>
        <cfif isdefined ('url.complete') or type eq 'Edit'>
        <!--- <input type="button" name="expressservice" value="Express" onClick="javascript:ColdFusion.Window.show('expressservice');" > --->
		</cfif>
		<cfif getpin2.h1G10 eq 'T'>
			<!--- <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="javascript:ColdFusion.Window.show('createservice');">Create New Service</a> --->
		</cfif>
        &nbsp;&nbsp;|&nbsp;&nbsp;<a onClick="releaseDirtyFlag()" href="/default/transaction/tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#nexttranno#&custno=#custno#&first=0"><b>Edit Detail Information</b></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a style="cursor:pointer;" onClick="window.open('uploadfile.cfm?refno=#URLENCODEDFORMAT(nexttranno)#&type=#tran#','UploadDocument','width=600, height=500, status=yes, menubar=no, location=no, scrollbars=yes')"><b>Upload Document</b></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a style="cursor:pointer;" onClick="window.open('itembody.cfm?refno=#URLENCODEDFORMAT(nexttranno)#&type=#tran#','UploadDocument','width=600, height=500, status=yes, menubar=no, location=no, scrollbars=yes')"><b>Export Item</b></a></td>
    </tr>
  	</table>
</cfform>
<script type="text/javascript">


<cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
	function copygrandtocash()
	{
	if(document.getElementById("checkcash").checked == true)
	{
	document.getElementById("cash").value=document.getElementById("viewGrand").value;
	}
	else{
	document.getElementById("cash").value='0.00';
	}

	getCashCount();
	}

	function copygrandtocheq()
	{
	if(document.getElementById("checkcheq").checked == true)
	{
	document.getElementById("cheque").value=document.getElementById("viewGrand").value;
	}
	else{
	document.getElementById("cheque").value='0.00';
	}
	getChequeCount();
	}
</cfif>

function selectitem(itemChoose)
{
itemChoose = unescape(itemChoose);

for (var idx=0;idx<document.getElementById('itemno').options.length;idx++) {
        if (itemChoose==document.getElementById('itemno').options[idx].value) {
            document.getElementById('itemno').options[idx].selected=true;
        }
    }

}
function trim(strval)
{
return strval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}

function checkexpress(addType)
{

var expressservice=trim(document.getElementById('expressservicelist').value);
var desp = trim(document.getElementById('desp').value);

if (addType == "Products")
{
var expressamt = trim(document.getElementById('expqty').value);
var expprice = trim(document.getElementById('expprice').value);
}
else
{
var expressamt = trim(document.getElementById('expressamt').value);
}
var intvalid = true;
if (addType == "Products")
{
try
{
expressamt = expressamt * 1;
expprice = expprice * 1;
}
catch(err)
{
intvalid = false;
}
}
var msg = "";

if (expressservice == "")
{
if (addType == "Products")
{
msg = msg + "-Please select a product\n";
}
else
{
msg = msg + "-Please select a service\n";
}
}
if ( desp == "")
{
msg = msg + "-Description field is required\n";
}

if (addType == "Products")
{
if ( expressamt == "" || expressamt <= 0 )
{
msg = msg + "-Quantity field is required\n";
}
if ( expprice == "" || expprice <= 0 )
{
msg = msg + "-Price field is required\n";
}
if (intvalid == false)
{
msg = msg + "-Price or quantity field is invalid\n";
}

else
{
if ( expressamt == "")
{
msg = msg + "-Amount field is required\n";
}
}
}

if (expressservice == "" || desp == "" || expressamt == "" || intvalid == false)
{
alert(msg);
return false;
}

}

function setdespprice()
{
document.getElementById('desp').value = document.getElementById('desphid').value;
document.getElementById('expprice').value = document.getElementById('pricehid').value;
}

function calamt()
{
var expqty = trim(document.getElementById('expqty').value);
var expprice = trim(document.getElementById('expprice').value);
expqty = expqty * 1;
expprice = expprice * 1;
var itemamt = expqty * expprice;
document.getElementById('expressamt').value =  itemamt.toFixed(2);
}

function calamtadvance()
{
var expqty = trim(document.getElementById('expqty').value);
var expprice = trim(document.getElementById('expprice').value);
var expdis = trim(document.getElementById('expdis').value);
expqty = expqty * 1;
expprice = expprice * 1;
expdis = expdis * 1;
var itemamt = (expqty * expprice) - expdis;
document.getElementById('expressamt').value =  itemamt.toFixed(2);
}

function addItem(addType)
{
if (addType == "Services")
{
var validatefield = checkexpress('Services');
}
else
{
var validatefield = checkexpress('Products');
}
if (validatefield == false)
{
}
else
{

var expressservice=trim(document.getElementById('expressservicelist').value);
var desp = encodeURI(trim(document.getElementById('desp').value));
var expressamt = trim(document.getElementById('expressamt').value);
var ajaxurl = '/default/transaction/services/addservicesAjax.cfm?servicecode='+expressservice+'&desp='+desp+'&expressamt='+expressamt+'&tran=#tran#&tranno=#nexttranno#&custno=#custno#';
if (addType == "Services")
{
ajaxFunction(document.getElementById('ajaxFieldSer'),ajaxurl);
}
if (addType == "Products")
{
var expqty = trim(document.getElementById('expqty').value);
var expprice = trim(document.getElementById('expprice').value);
var location = encodeURI(trim(document.getElementById('location').value));

<cfquery name="check_compulsory_location_setting" datasource="#dts#">
	select
	compulsory_location
	from transaction_menu;
</cfquery>

<cfif check_compulsory_location_setting.compulsory_location eq "Y">
	if(location=="")
	{
		alert("Please Select A Location !");
		document.getElementById("location").focus();
		return false;
	}
</cfif>
var ajaxurl = '/default/transaction/products/addproductsAjax.cfm?servicecode='+expressservice+'&desp='+desp+'&expressamt='+expressamt+'&expqty='+expqty+'&expprice='+expprice+'&tran=#tran#&tranno=#nexttranno#&custno=#custno#&location='+escape(location);
ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
}


clearform(addType);
}

}

function addmat(addType)
{
if (addType == "Services")
{
var validatefield = checkexpress('Services');
}
else
{
var validatefield = checkexpress('Products');
}
if (validatefield == false)
{
}
else
{

var expressservice=trim(document.getElementById('expressservicelist').value);
var desp = encodeURI(trim(document.getElementById('desp').value));
var expressamt = trim(document.getElementById('expressamt').value);
var ajaxurl = '/default/transaction/services/addservicesAjax.cfm?servicecode='+expressservice+'&desp='+desp+'&expressamt='+expressamt+'&tran=#tran#&tranno=#nexttranno#&custno=#custno#';
if (addType == "Services")
{
ajaxFunction(document.getElementById('ajaxFieldSer'),ajaxurl);
}
if (addType == "Products")
{
var expqty = trim(document.getElementById('expqty').value);
var expprice = trim(document.getElementById('expprice').value);
var location = encodeURI(trim(document.getElementById('location').value));

<cfquery name="check_compulsory_location_setting" datasource="#dts#">
	select
	compulsory_location
	from transaction_menu;
</cfquery>

<cfif check_compulsory_location_setting.compulsory_location eq "Y">
	if(location=="")
	{
		alert("Please Select A Location !");
		document.getElementById("location").focus();
		return false;
	}
</cfif>
var ajaxurl = '/default/transaction/material/addproductsAjax.cfm?servicecode='+expressservice+'&desp='+desp+'&expressamt='+expressamt+'&expqty='+expqty+'&expprice='+expprice+'&tran=#tran#&tranno=#nexttranno#&custno=#custno#&location='+escape(location);
ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
}


clearform(addType);
}

}

function addItemAdvance()
{
var validatefield = checkexpress('Products');

if (validatefield == false)
{
}
else
{
var expressservice=trim(document.getElementById('expressservicelist').value);
var desp = escape(trim(document.getElementById('desp').value));
var expressamt = trim(document.getElementById('expressamt').value);
var expqty = trim(document.getElementById('expqty').value);
var expprice = trim(document.getElementById('expprice').value);
var expcomment = escape(trim(document.getElementById('expcomment').value));
var expunit = trim(document.getElementById('expunit').value);
var expdis = trim(document.getElementById('expdis').value);
var ajaxurl = '/default/transaction/advanceProduct/addproductsAjax.cfm?servicecode='+expressservice+'&desp='+desp+'&expressamt='+expressamt+'&expqty='+expqty+'&expprice='+expprice+'&comment='+expcomment+'&unit='+expunit+'&dis='+expdis+'&tran=#tran#&tranno=#nexttranno#&custno=#custno#';
ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
clearformadvance();
}
}

function clearform(addType)
{
document.getElementById('expressservicelist').selectedIndex = 0;
document.getElementById('desp').value = '';
document.getElementById('expressamt').value = '0.00';
if (addType == "Products")
{
document.getElementById('expqty').value = '0';
document.getElementById('expprice').value = '0.00';
document.getElementById('location').selectedIndex = 0;
}
}

function clearformadvance()
{
document.getElementById('expressservicelist').value = '';
document.getElementById('desp').value = '';
document.getElementById('expressamt').value = '0.00';
document.getElementById('expqty').value = '1';
document.getElementById('expqtycount').value = '1';
document.getElementById('expprice').value = '0.00';
document.getElementById('expunit').value = '';
document.getElementById('expdis').value = '0.00';
document.getElementById('expunitdis').value = '0.00';
document.getElementById('expcomment').value = '';
document.getElementById('expressservicelist').focus();
}

function nextIndex(thisid,id)
{
var itemno = document.getElementById('expressservicelist').value;
if (thisid == 'expressservicelist' && itemno == '')
{
}
else
{
if(event.keyCode==13){
document.getElementById(''+id+'').focus();
document.getElementById(''+id+'').select();
}
}
}

function checkstring(strText)
{
var strReplaceAll = strText;
var intIndexOfMatch = strReplaceAll.indexOf( "%" );


// Loop over the string value replacing out each matching
// substring.
while (intIndexOfMatch != -1){
// Relace out the current instance.
strReplaceAll = strReplaceAll.replace( "%", "925925925925" )


// Get the index of any next matching substring.
intIndexOfMatch = strReplaceAll.indexOf( "%" );
}
return strReplaceAll;
}
</script>
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>

</cfoutput>

<cfif isdefined ('url.complete') or type eq 'Edit'>


	<cfquery name='getartran' datasource='#dts#'>
		select * from artran where refno = '#nexttranno#' and type = '#tran#'
	</cfquery>

	<cfquery name='getictran2' datasource='#dts#'>
		select sum(amt_bil) as subtotal from ictran where refno = '#nexttranno#' and type = '#tran#'
	</cfquery>

	<cfif getartran.recordcount gt 0>
		<cfif hmode eq 'Create' and wpitemtax neq "Y">
			<!--- Modified on 17-03-2009 --->
			<cfif lcase(hcomid) eq "net_i" or lcase(hcomid) eq "ideal_i" >
				<cfset xtaxp1="7">
			<cfelseif lcase(hcomid) eq "efrozenfood_i">
				<cfset xtaxp1=getgeneralinfo.gst>
			<cfelse>
				<!--- Modified on 14-10-2009 --->
				<cfquery name="selected_tax" datasource="#dts#">
					SELECT * FROM #target_taxtable#
					WHERE
					<cfif getartran.note neq "">
						code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.note#">
					<cfelse>
						code=code
					</cfif>
					<cfif lcase(hcomid) eq "iaf_i">
						AND tax_type in ('T',
						<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
							'PT'
						<cfelse>
							'ST'
						</cfif>
						)
					</cfif>
					limit 1
				</cfquery>
				<cfif selected_tax.recordcount neq 0>
					<cfset xnote = selected_tax.code>
					<cfset selected_taxrate = selected_tax.rate1 * 100>
					<cfset xtaxp1 = selected_taxrate>
				<cfelse>
					<cfset xtaxp1=getgeneralinfo.gst>
			  </cfif>
			</cfif>
		<cfelse>
			<cfset xtaxp1=getartran.taxp1>
		</cfif>

		<cfset xdisp1 = val(getartran.disp1)>
		<cfset xdisp2 = val(getartran.disp2)>
		<cfset xdisp3 = val(getartran.disp3)>
		<cfset xttlamttax=val(getartran.tax_bil)>
		<cfset xamtdisp1=val(getartran.disc_bil)>
        <cfif val(getictran2.subtotal) neq 0>
			<!--- ADD ON 23-11-2009 --->
			<cfif xdisp1 neq 0 or xdisp2 neq 0 or xdisp3 neq 0>
				<cfset disc1_bil = val(getictran2.subtotal) * xdisp1 / 100>
				<cfset disc1_bil = numberformat(disc1_bil,stDecl_Disc)>
			  	<cfset xnet_bil = val(getictran2.subtotal) - val(disc1_bil)>
				<cfset disc2_bil = xnet_bil * xdisp2 / 100>
				<cfset disc2_bil = numberformat(disc2_bil,stDecl_Disc)>
			  	<cfset xnet_bil = xnet_bil - val(disc2_bil)>
				<cfset disc3_bil = xnet_bil * xdisp3 / 100>
				<cfset disc3_bil = numberformat(disc3_bil,stDecl_Disc)>
				<cfset xamtdisp1 = val(disc1_bil) + val(disc2_bil) + val(disc3_bil)>
			</cfif><!--- ADD ON 23-11-2009 --->
        	<cfset xnet=val(getictran2.subtotal)-xamtdisp1>
			<!--- REMARK ON 23-11-2009 AND REPLACE WITH THE BELOW CONDITION --->
		  	<!--- <cfif wpitemtax neq "Y" and type neq 'Edit' and val(xtaxp1) neq 0> --->
		  	<cfif wpitemtax neq "Y" and isdefined ('url.complete') and val(xtaxp1) neq 0>
				<!--- MODIFIED ON 10-11-2009 --->
				<cfif getartran.taxincl neq "T">
					<cfset xttlamttax=numberformat(xnet*val(xtaxp1)/100,"0.00")>
				<cfelse>
					<cfset xttlamttax=numberformat(xnet*val(xtaxp1)/(100+val(xtaxp1)),"0.00")>
				</cfif>
		  	</cfif>
			<!--- MODIFIED ON 10-11-2009 --->
		  <cfif getartran.taxincl neq "T">
				<cfset xgrand=xnet+xttlamttax>
			<cfelse>
				<cfset xgrand=xnet>
		  </cfif>
		<cfelse>
			<cfset xnet=val(getartran.net_bil)>
			<cfset xgrand=val(getartran.grand_bil)>
    </cfif>
	<cfset xdebt=xgrand>
	<cfif val(getartran.deposit) neq 0>
		<cfset xdebt=xdebt-val(getartran.deposit)>
    </cfif>
	<cfif val(getartran.cs_pm_cash) neq 0>
		<cfset xdebt=xdebt-val(getartran.cs_pm_cash)>
    </cfif>
	<cfif val(getartran.cs_pm_cheq) neq 0>
		<cfset xdebt=xdebt-val(getartran.cs_pm_cheq)>
    </cfif>
	<cfif val(getartran.cs_pm_crcd) neq 0>
		<cfset xdebt=xdebt-val(getartran.cs_pm_crcd)>
    </cfif>
	<cfif val(getartran.cs_pm_crc2) neq 0>
		<cfset xdebt=xdebt-val(getartran.cs_pm_crc2)>
    </cfif>
    <cfif val(getartran.cs_pm_dbcd) neq 0>
		<cfset xdebt=xdebt-val(getartran.cs_pm_dbcd)>
    </cfif>
	<cfif val(getartran.cs_pm_vouc) neq 0>
		<cfset xdebt=xdebt-val(getartran.cs_pm_vouc)>
    </cfif>
	<!--- REMARK ON 23-11-2009 --->
	<!--- <cfif val(getartran.cs_pm_vouc) neq 0>
		<cfset xdebt=xdebt-val(getartran.cs_pm_vouc)>
    </cfif> --->
	<cfif (lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i") and (tran eq 'PO' or tran eq "RC" or tran eq "PR")>
		<cfif val(getartran.cs_pm_tt) neq 0>
			<cfset xdebt=xdebt-val(getartran.cs_pm_tt)>
		</cfif>
    </cfif>
		<!--- <cfset xnet=val(getartran.net_bil)>
		<cfset xgrand=val(getartran.grand_bil)> --->

		<!--- <cfif hmode eq 'Create' and wpitemtax neq "Y">
			<!--- Modified on 17-03-2009 --->
			<cfif lcase(hcomid) eq "net_i">
				<cfset xtaxp1="7">
			<cfelseif lcase(hcomid) eq "efrozenfood_i">
				<cfset xtaxp1=getgeneralinfo.gst>
			<cfelse>
				<!--- Modified on 14-10-2009 --->
				<cfquery name="selected_tax" datasource="#dts#">
					SELECT * FROM #target_taxtable#
					WHERE
					<cfif getartran.note neq "">
						code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getartran.note#">
					<cfelse>
						code=code
					</cfif>
					<cfif lcase(hcomid) eq "iaf_i">
						AND tax_type in ('T',
						<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
							'PT'
						<cfelse>
							'ST'
						</cfif>
						)
					</cfif>
					limit 1
				</cfquery>
				<cfif selected_tax.recordcount neq 0>
					<cfset xnote = selected_tax.code>
					<cfset selected_taxrate = selected_tax.rate1 * 100>
					<cfset xtaxp1 = selected_taxrate>
				<cfelse>
					<cfset xtaxp1=getgeneralinfo.gst>
				</cfif>
			</cfif>
		<cfelse>
			<cfset xtaxp1=getartran.taxp1>
		</cfif> --->

		<!--- Modified on 17-11-2008 --->
		<!--- <cfif getartran.note neq ""><cfset xnote=getartran.note>
		<cfelse>
			<cfif getgeneralinfo.gst neq 0>
				<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'><cfset xnote = ''>
				<cfelse><cfset xnote = 'STAX'>
				</cfif>
			<cfelse>
				<cfset xnote = 'ZR'>
			</cfif>
		</cfif> --->
		<!--- MODIFIED ON 24-02-2009 --->
		<!--- <cfif lcase(hcomid) neq "ecraft_i">
			<cfif getartran.note neq "">
				<cfset xnote=getartran.note>
			<cfelse>
				<cfif getgeneralinfo.gst neq 0>
					<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
						<cfset xnote = ''>
					<cfelse>
						<cfset xnote = 'STAX'>
					</cfif>
				<cfelse>
					<cfset xnote = 'ZR'>
				</cfif>
			</cfif>
		<cfelse>
			<cfset xnote=getartran.note>
		</cfif> --->
		<cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
			<cfset xnote=getartran.note>
		<cfelse>
			<cfif getartran.note neq "">
				<cfset xnote=getartran.note>
			<cfelse>
				<cfif getgeneralinfo.gst neq 0>
			  		<cfif hmode eq "Create">
						<!--- Modified on 17-03-2009 --->
						<cfif lcase(hcomid) eq "net_i">
							<cfset xnote = 'STAX'>
						<cfelseif lcase(hcomid) eq "lioncity_i" or lcase(hcomid) eq "ugateway_i">
				  			<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
								<cfset xnote = 'PTAX'>
							<cfelseif tran eq "CS" or tran eq 'INV' or tran eq 'DO' or tran eq 'QUO' or tran eq 'SO'>
								<cfset xnote = 'STAX'>
							<cfelse>
								<cfset xnote = ''>
				  			</cfif>
						<cfelse>
				  			<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
								<cfset xnote = ''>
							<cfelse>
								<cfset xnote = 'STAX'>
				  			</cfif>
						</cfif>
					<cfelse>
						<cfset xnote=getartran.note>
					</cfif>
				<cfelse>
					<cfset xnote = 'ZR'>
				</cfif>
		  	</cfif>
	  	</cfif>
	</cfif>

    <!--- ADD ON 27-07-2009 --->
    <cfif lcase(hcomid) eq "mhsl_i" and tran eq "RC">
    	<cfset xnbttaxp=val(getartran.taxnbtp)>
        <cfset xnbttax=val(getartran.taxnbt)>
	</cfif>

	<cfif tran eq "DO">
		<cfif getpin2.h5700 eq "T">
			<cfset hidestatus="text">
		<cfelse>
			<cfset hidestatus="hidden">
	  	</cfif>
	<cfelse>
		<cfset hidestatus="text">
	</cfif>

	<cfif lcase(hcomid) eq "steel_i">
		<cfset mcList="Freight Insurance mc1:,Freight Charges mc2:,Marine Insurance mc3:,Packing mc4:,Inland Handling mc5:,mc6:,mc7:">
	<cfelse>
		<cfset mcList="Misc. Charges (1):,Misc. Charges (2):,Misc. Charges (3):,Misc. Charges (4):,Misc. Charges (5):,Misc. Charges (6):,Misc. Charges (7):">
	</cfif>
	<cfoutput>
	<form name='invoicesheet' action='transaction3b.cfm' method='post' onSubmit="releaseDirtyFlag();return permit();">
		<input type='hidden' name='currrate' value='#listfirst(currrate)#'>
  		<input type='hidden' name='tran' value='#listfirst(tran)#'>
 		<input type='hidden' name='nexttranno' value='#listfirst(nexttranno)#'>
    	<input type='hidden' name='custno' value='#listfirst(custno)#'>
		<input type="hidden" name='discformat' value="#stDecl_Disc#">
		<!--- Add on 250808 --->
		<input type="hidden" name='hmode' value="#hmode#">
        <input type="hidden" name='discountlimit' value="#getgsetup.disclimit#">

		<cfif isdefined("form.updunitcost")><input type='hidden' name='updunitcost' value='#form.updunitcost#'></cfif>
		<input name='frem9' type='hidden' value='#getartran.frem9#'>

		<table width='100%' border="0" align='center' cellspacing="0">

			<td width="33%" align="right" <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#getgsetup.misccharge1# :<input type="#hidestatus#" name="mc1_bil" value="#numberformat(getartran.mc1_bil,'0.00')#" maxlength="18" size="18" onClick="select();" <cfif (lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i") and husergrpid neq "Admin" and husergrpid neq "Super">onKeyUp="getDiscountControl2();"<cfelse>onKeyUp="getDiscountControl();"</cfif>></td>
			<td width="1%">&nbsp;</td>
			<td width="12%" <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>Special Account Code</td>
			<td width="1%" <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<td <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input type="text" name="special_account_code"  value="#getartran.special_account_code#" maxlength="8" size="10" onClick="select();"></td>
			<td width="10%" <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#words[1098]#</td>
			<td width="1%" <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<td width="7%">&nbsp;</td>
			<td width="7%">&nbsp;</td>
			<td width="6%">&nbsp;</td>
			<!--- MODIFIED ON 04-03-2009 --->
			<!--- <td width="10%"><input name='subtotal' type='#hidestatus#' size='10' maxlength='15' value='#numberformat(getictran2.subtotal,stDecl_UPrice<!--- '.__' --->)#' style="background-color:##FFFF99" readonly></td> --->
			<td width="10%" <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name='subtotal' id="subtotal" type='#hidestatus#' size='10' maxlength='15' value='#numberformat(getictran2.subtotal,'.__')#' style="background-color:##FFFF99" readonly></td>
		</tr>
		<tr>
			<td align="right" <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#getgsetup.misccharge2# :<input type="#hidestatus#" name="mc2_bil" value="#numberformat(getartran.mc2_bil,'0.00')#" maxlength="18" size="18" onClick="select();" <cfif (lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i") and husergrpid neq "Admin" and husergrpid neq "Super">onKeyUp="getDiscountControl2();"<cfelse>onKeyUp="getDiscountControl();"</cfif>></td>
			<td>&nbsp;</td>
			<td rowspan="2" <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>Clear All Special Account Code ?</td>
			<td width="1%" <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<td <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>
				<input type="radio" name="clear_all_special_account_code" value="yes" onClick="clear_special_account_code(this.value);">YES &nbsp;
				<input type="radio" name="clear_all_special_account_code" value="no" onClick="clear_special_account_code(this.value);" checked>NO
			</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#words[592]# (%)</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<cfif lcase(hcomid) eq "gel_i" and husergrpid neq "Admin" and husergrpid neq "Super">
				<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name='totaldisc1' type='#hidestatus#' size='4' maxlength='5' value='#xdisp1#' readonly> +</td>
				<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name='totaldisc2' type='#hidestatus#' size='4' maxlength='5' value='#xdisp2#' readonly> +</td>
				<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name='totaldisc3' type='#hidestatus#' size='4' maxlength='5' value='#xdisp3#' readonly></td>
				<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name='totalamtdisc' id="totalamtdisc_id" type='#hidestatus#' size='10' maxlength='15' value='#xamtdisp1#' readonly></td>
			<cfelse>
				<cfif (lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i") and husergrpid neq "Admin" and husergrpid neq "Super">
					<cfquery name="getDisc" datasource="#dts#">
						select * from discounttable order by discount
					</cfquery>
					<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>
						<select name='totaldisc1' onChange="getDiscountControl2();">
							<option value="">-</option>
							<cfloop query="getDisc">
								<option value="#getDisc.discount#" <cfif getDisc.discount eq xdisp1>selected</cfif>>#getDisc.discount#</option>
							</cfloop>
						</select> +
					</td>
					<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>
						<select name='totaldisc2' onChange="getDiscountControl2();">
							<option value="">-</option>
							<cfloop query="getDisc">
								<option value="#getDisc.discount#" <cfif getDisc.discount eq xdisp2>selected</cfif>>#getDisc.discount#</option>
							</cfloop>
						</select> +
					</td ><cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>
					<td>
						<select name='totaldisc3' onChange="getDiscountControl2();">
							<option value="">-</option>
							<cfloop query="getDisc">
								<option value="#getDisc.discount#" <cfif getDisc.discount eq xdisp3>selected</cfif>>#getDisc.discount#</option>
							</cfloop>
						</select>
					</td>
				<cfelse>
					<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name='totaldisc1' type='#hidestatus#' size='4' maxlength='5' value='#xdisp1#' onKeyUp="getDiscountControl();"> +</td>
					<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name='totaldisc2' type='#hidestatus#' size='4' maxlength='5' value='#xdisp2#' onKeyUp="getDiscountControl();"> +</td>
					<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name='totaldisc3' type='#hidestatus#' size='4' maxlength='5' value='#xdisp3#' onKeyUp="getDiscountControl();"></td>
				</cfif>
				<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name='totalamtdisc' id="totalamtdisc_id" type='#hidestatus#' size='10' maxlength='15' value='#xamtdisp1#' <cfif (lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i") and husergrpid neq "Admin" and husergrpid neq "Super">onKeyUp="getDiscountControl2();"<cfelse>onKeyUp="getDiscountControl();"</cfif>></td>
			</cfif>
		</tr>
		<tr>
			<td align="right" <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#getgsetup.misccharge3# :<input type="#hidestatus#" name="mc3_bil" value="#numberformat(getartran.mc3_bil,'0.00')#" maxlength="18" size="18" onClick="select();" <cfif (lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i") and husergrpid neq "Admin" and husergrpid neq "Super">onKeyUp="getDiscountControl2();"<cfelse>onKeyUp="getDiscountControl();"</cfif>></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>#words[1294]#</td>
			<td>:</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><input name='viewNet' id='viewNet' type='#hidestatus#' size='10' value='#xnet#' style="background-color:##FFFF99" readonly></td>
		</tr>

		<tr>
		<tr>
			<td  align="right" <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#getgsetup.misccharge4# :<input type="#hidestatus#" name="mc4_bil" value="#numberformat(getartran.mc4_bil,'0.00')#" maxlength="18" size="18" onClick="select();" <cfif (lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i") and husergrpid neq "Admin" and husergrpid neq "Super">onKeyUp="getDiscountControl2();"<cfelse>onKeyUp="getDiscountControl();"</cfif>></td>
			<td>&nbsp;</td>
			<td colspan="3" <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><div align="center" style="color:##FF0000; font-size:13px;"><b>Payment Made By</b></div></td>
			<td>
			<cfif getgsetup.ngstcustdisabletax eq "1">
            	<cfif tran eq 'rc' or tran eq 'pr' or tran eq 'po'>
            	<cfquery name="getnongstcust" datasource="#dts#">
            	select NGST_CUST from #target_apvend# where custno='#custno#'
            	</cfquery>
           		<cfelse>
            	<cfquery name="getnongstcust" datasource="#dts#">
            	select NGST_CUST from #target_arcust# where custno='#custno#'
            	</cfquery>
            	</cfif>

					<cfif getnongstcust.NGST_CUST eq 'T'>

            		<cfelse>
                    #words[1099]# (%)
            		</cfif>

			<cfelse>#words[1099]# (%)</cfif></td>
			<td>:</td>
			<td align="right" colspan="2">
                <cfif wpitemtax eq "Y">
                <select name="selecttax" id="selecttax" style="visibility:hidden">
                <option value="#xnote#"></option>
                </select>
                    <input type="hidden" name="wpitemtax" id="wpitemtax" value="Y">
				<cfelse>
					<!--- REMARK ON 08-10-2009 --->
                    <!--- <select name="selecttax" onChange="getTaxControl();">
                        <cfif lcase(hcomid) eq "efrozenfood_i" and tran eq "INV">
		                    <option value="EX"<cfif xnote eq "EX">selected</cfif>>Exempted</option>
	                        <option value="STAX"<cfif xnote eq "STAX">selected</cfif>>STAX</option>
	                        <option value="ZR"<cfif xnote eq "ZR">selected</cfif>>Zero Rated</option>
						<cfelse>
	                        <option value="XGST" <cfif xnote eq "XGST">selected</cfif>>X-GST</option>
	                        <cfif lcase(hcomid) eq "efrozenfood_i" and (tran eq 'RC' or tran eq 'PO' or tran eq 'PR')>
		                        <option value="PTAX"<cfif xnote eq "PTAX">selected</cfif>>PTAX</option>
							<cfelse>
			                    <option value="EX"<cfif xnote eq "EX">selected</cfif>>Exempted</option>
								<option value="OS"<cfif xnote eq "OS">selected</cfif>>Out of Scope</option>
		                        <option value="STAX"<cfif xnote eq "STAX">selected</cfif>>STAX</option>
		                        <option value="PTAX"<cfif xnote eq "PTAX">selected</cfif>>PTAX</option>
		                        <option value="ZR"<cfif xnote eq "ZR">selected</cfif>>ZR</option>
		                        <cfif tran eq "RC" or tran eq "PR">
		                        	<option value="MES"<cfif xnote eq "MES">selected</cfif>>MES</option>
		                        </cfif>
		                        <cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
		                            <option value="PTAXS"<cfif xnote eq "PTAXS">selected</cfif>>PTAXS</option>
		                            <option value="SPTAX"<cfif xnote eq "SPTAX">selected</cfif>>SPTAX</option>
		                            <option value="EPTAX"<cfif xnote eq "EPTAX">selected</cfif>>EPTAX</option>
		                            <option value="ZPTAX"<cfif xnote eq "ZPTAX">selected</cfif>>ZPTAX</option>
		                            <option value="TX7"<cfif xnote eq "TX7">selected</cfif>>TX7</option>
		                            <option value="IM"<cfif xnote eq "IM">selected</cfif>>IM</option>
		                            <option value="ME"<cfif xnote eq "ME">selected</cfif>>ME</option>
		                            <option value="BL"<cfif xnote eq "BL">selected</cfif>>BL</option>
		                            <option value="NR"<cfif xnote eq "NR">selected</cfif>>NR</option>
		                            <option value="ZP"<cfif xnote eq "ZP">selected</cfif>>ZP</option>
		                            <option value="EP"<cfif xnote eq "EP">selected</cfif>>EP</option>
		                            <option value="OP"<cfif xnote eq "OP">selected</cfif>>OP</option>
		                            <option value="E33"<cfif xnote eq "E33">selected</cfif>>E33</option>
		                            <option value="EN33"<cfif xnote eq "EN33">selected</cfif>>EN33</option>
		                            <option value="RE"<cfif xnote eq "RE">selected</cfif>>RE</option>
		                        <cfelse>
		                            <option value="STAXS"<cfif xnote eq "STAXS">selected</cfif>>STAXS</option>
		                            <option value="SSTAX"<cfif xnote eq "SSTAX">selected</cfif>>SSTAX</option>
		                            <option value="ESTAX"<cfif xnote eq "ESTAX">selected</cfif>>ESTAX</option>
		                            <option value="ZSTAX"<cfif xnote eq "ZSTAX">selected</cfif>>ZSTAX</option>
		                            <option value="SR"<cfif xnote eq "SR">selected</cfif>>SR</option>
		                            <option value="ES33"<cfif xnote eq "ES33">selected</cfif>>ES33</option>
		                            <option value="ESN33"<cfif xnote eq "ESN33">selected</cfif>>ESN33</option>
		                            <option value="DS"<cfif xnote eq "DS">selected</cfif>>DS</option>
		                            <option value="OS"<cfif xnote eq "OS">selected</cfif>>OS</option>
		                        </cfif>
		                        <option value="PM"<cfif xnote eq "PM">selected</cfif>>PM</option>
		                        <option value="NTAX"<cfif xnote eq "NTAX">selected</cfif>>NTAX</option>
							</cfif>
						</cfif>
                    </select> --->
					<cfif lcase(hcomid) eq "efrozenfood_i">
						<select name="selecttax" onChange="getTaxControl();">
							<cfif tran eq "INV">
			                    <option value="EX"<cfif xnote eq "EX">selected</cfif>>#words[1102]# </option>
		                        <option value="STAX"<cfif xnote eq "STAX">selected</cfif>> #words[1100]# </option>
		                        <option value="ZR"<cfif xnote eq "ZR">selected</cfif>>#words[1101]#</option>
		                    <cfelse>
		                    	<option value="XGST" <cfif xnote eq "XGST">selected</cfif>>X-GST</option>
		                    	<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
		                        	<option value="PTAX"<cfif xnote eq "PTAX">selected</cfif>>PTAX</option>
		                        <cfelse>
				                    <option value="EX"<cfif xnote eq "EX">selected</cfif>>#words[1102]#</option>
									<option value="OS"<cfif xnote eq "OS">selected</cfif>>#words[1103]#</option>
			                        <option value="STAX"<cfif xnote eq "STAX">selected</cfif>>#words[1100]#</option>
			                        <option value="PTAX"<cfif xnote eq "PTAX">selected</cfif>>PTAX</option>
			                        <option value="ZR"<cfif xnote eq "ZR">selected</cfif>>ZR</option>
								</cfif>
							</cfif>
						</select>
                        <!---ngstcustdisabletax --->
                        <cfelseif getgsetup.ngstcustdisabletax eq "1">
                        <cfif getnongstcust.NGST_CUST eq "T">
                         <select name="selecttax" id="selecttax" style="visibility:hidden">
            		    <option value="#xnote#"></option>
             		   </select>
                        <cfelse>
                        <cfquery name="select_tax" datasource="#dts#">
							SELECT * FROM #target_taxtable#
							<cfif lcase(hcomid) eq "iaf_i">
								WHERE tax_type in ('T',
								<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
									'PT'
								<cfelse>
									'ST'
								</cfif>
								)
                            <cfelse>

							<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
                            WHERE tax_type <> "ST"
                            <cfelseif tran eq 'DN' or tran eq 'CN' >
                            <cfelse>
                            WHERE tax_type <> "PT"
                            </cfif>

							</cfif>
						</cfquery>
						<select name="selecttax" id="selecttax" onChange="JavaScript:document.getElementById('pTax').value=this.options[this.selectedIndex].id;getTaxControl();">
			                <cfloop query="select_tax">
			                	<cfset idrate = select_tax.rate1 * 100>
			                	<option value="#select_tax.code#" id="#idrate#" <cfif xnote eq select_tax.code>selected</cfif>>#select_tax.code#</option>
			                </cfloop>
		                </select>
                        </cfif>
                        <!---end ngstcustdisabletax --->
					<cfelse>
						<cfquery name="select_tax" datasource="#dts#">
							SELECT * FROM #target_taxtable#
							<cfif lcase(hcomid) eq "iaf_i">
								WHERE tax_type in ('T',
								<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
									'PT'
								<cfelse>
									'ST'
								</cfif>
								)
                            <cfelse>

							<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
                            WHERE tax_type <> "ST"
                            <cfelseif tran eq 'DN' or tran eq 'CN' >
                            <cfelse>
                            WHERE tax_type <> "PT"
                            </cfif>

							</cfif>
						</cfquery>
						<select name="selecttax" id="selecttax" onChange="JavaScript:document.getElementById('pTax').value=this.options[this.selectedIndex].id;getTaxControl();">
			                <cfloop query="select_tax">
			                	<cfset idrate = select_tax.rate1 * 100>
			                	<option value="#select_tax.code#" id="#idrate#" <cfif xnote eq select_tax.code>selected</cfif>>#select_tax.code#</option>
			                </cfloop>
		                </select>
					</cfif>
				</cfif>
			</td>
			<td>
            	<cfif wpitemtax eq "Y">
                	<input name="pTax" id="pTax" type="hidden" size="5" maxlength="5" value="0">
				<cfelse>
                 <cfif getgsetup.ngstcustdisabletax eq "1">
                 <cfif getnongstcust.NGST_CUST eq "T">
                 <input name="pTax" id="pTax" type="hidden" size="5" maxlength="5" value="0">
                 <cfelse>
                 <input name="pTax" id="pTax" type="#hidestatus#" size="5" maxlength="5" value="#xtaxp1#" onKeyUp="getTaxControl();" onBlur="settaxcode();">

                 </cfif>
                 <cfelse>
                	<input name="pTax" id="pTax" type="#hidestatus#" size="5" maxlength="5" value="#xtaxp1#" onKeyUp="getTaxControl();" onBlur="settaxcode();">
                    </cfif>
				</cfif>
            </td>
			<td>
            	<!--- <input name="totalamttax" type="#hidestatus#" size="10" value="#xttlamttax#" onKeyUp="getGrand();" style="background-color:##FFFF99" readonly> --->
                <input name="totalamttax" id="totalamttax" type="#hidestatus#" size="10" value="#xttlamttax#" onKeyUp="getGrand();" <cfif wpitemtax eq "Y">style="background-color:##FFFF99" readonly</cfif>>
            </td>
		</tr>
        <!--- ADD ON 27-07-2009 --->
        <!--- <cfif lcase(hcomid) eq "mhsl_i" and tran eq "RC">
			<tr>
            	<td colspan="5">&nbsp;</td>
                <td>NBT (%)</td>
				<td>:</td>
                <td colspan="2">&nbsp;</td>
                <td><input name="pnbtTax" type="#hidestatus#" size="5" maxlength="5" value="#xnbttaxp#" onKeyUp="getNBTTaxControl();"></td>
                <td><input name="xnbttax" type="#hidestatus#" size="10" value="#xnbttax#" onKeyUp="getNBTTaxControl();" style="background-color:##FFFF99" readonly></td>
            </tr>
		</cfif> --->
        <tr>
        <td align="right"></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
            <td>&nbsp;</td>
			<td>Roundadj</td>
			<td>:</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><input name='roundadj' id='roundadj' type='text' size='10' value='' style="background-color:##FFFF99" readonly></td>
        </tr>
		<tr>
			<td  align="right" <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#getgsetup.misccharge5# :<input type="#hidestatus#" name="mc5_bil" value="#numberformat(getartran.mc5_bil,'0.00')#" maxlength="18" size="18" onClick="select();" <cfif (lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i") and husergrpid neq "Admin" and husergrpid neq "Super">onKeyUp="getDiscountControl2();"<cfelse>onKeyUp="getDiscountControl();"</cfif>></td>
			<td>&nbsp;</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#words[1297]#</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input tabindex="0" name="cash" id="cash" type="#hidestatus#" value="#numberformat(getartran.cs_pm_cash,'0.00')#" size="10" maxlength="15" onKeyUp="getCashCount();">
            <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
            <input type="checkbox" name="checkcash" onClick="copygrandtocash();">
            </cfif>
            </td>
			<td><cfif lcase(hcomid) eq "mhsl_i" and tran eq "RC">NBT Tax (%)<cfelse>#words[1296]#</cfif></td>
			<td>:</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<cfif HcomID eq "bhl_i">
				<td>&nbsp;</td>
				<td><input name="viewGrand" id="viewGrand" type="#hidestatus#" size="10" maxlength="15" value="#xgrand#" onKeyUp="auto_fill_discount_value();" onClick="select();"></td>
            <cfelseif lcase(hcomid) eq "mhsl_i" and tran eq "RC">
                <td><input name="pnbtTax" type="#hidestatus#" size="5" maxlength="5" value="#xnbttaxp#" onKeyUp="getNBTTaxControl();"></td>
                <td><input name="xnbttax" type="#hidestatus#" size="10" value="#xnbttax#" onKeyUp="getNBTTaxControl();" style="background-color:##FFFF99" readonly></td>
			<cfelse>
				<td>&nbsp;</td>
				<td><input name="viewGrand" id="viewGrand" type="#hidestatus#" size="10" maxlength="15" value="#xgrand#" style="background-color:##00FFCC" readonly></td>
			</cfif>
		</tr>
		<tr>
			<td  align="right" <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#getgsetup.misccharge6# :<input type="#hidestatus#" name="mc6_bil" value="#numberformat(getartran.mc6_bil,'0.00')#" maxlength="18" size="18" onClick="select();" <cfif (lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i") and husergrpid neq "Admin" and husergrpid neq "Super">onKeyUp="getDiscountControl2();"<cfelse>onKeyUp="getDiscountControl();"</cfif>></td>
			<td>&nbsp;</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#words[1298]#</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name="cheque" id="cheque" type="#hidestatus#" value="#numberformat(getartran.cs_pm_cheq,'0.00')#" size="10" maxlength="15" onKeyUp="getChequeCount();">
            <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
            <input type="checkbox" name="checkcheq" onClick="copygrandtocheq();">
            </cfif>
            </td>
            <cfif lcase(hcomid) eq "mhsl_i" and tran eq "RC">
            	<td>#words[1296]#</td>
				<td>:</td>
			<cfelse>
				<!--- REMARK ON 10-11-2009 --->
            	 <cfif getGeneralInfo.wpitemtax neq "1">
            		<td nowrap><input name="taxincl" id="taxincl" type="checkbox" value="T" #iif(getartran.taxincl eq "T",DE("checked"),DE(""))#<cfif hmode eq 'Create' and getgsetup.taxincluded eq 'Y'>checked</cfif><cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i") and hmode eq 'Create' and tran eq "CS"></cfif> <cfif wpitemtax eq "Y">onClick="check_witempertax();"<cfelse>onClick="check_taxincls();"</cfif> > Tax Already Included </td>
                <cfelse>
                   <td nowrap><input name="taxincl" id="taxincl" type="checkbox" value="T"  style="visibility:hidden" ></td>
                </cfif>
			</cfif>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<cfif lcase(hcomid) eq "mhsl_i" and tran eq "RC">
            	<td><input name="viewGrand" id="viewGrand" type="#hidestatus#" size="10" maxlength="15" value="#xgrand#" style="background-color:##00FFCC" readonly></td>
			<cfelse>
				<td>&nbsp;</td>
			</cfif>
		</tr>
		<tr>
			<td align="right" <cfif lcase(hcomid) eq "mastercare_i" or lcase(HcomID) eq "gorgeous_i" or lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#getgsetup.misccharge7# :<input type="#hidestatus#" name="mc7_bil" value="#numberformat(getartran.mc7_bil,'0.00')#" maxlength="18" size="18" onClick="select();" <cfif (lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i") and husergrpid neq "Admin" and husergrpid neq "Super">onKeyUp="getDiscountControl2();"<cfelse>onKeyUp="getDiscountControl();"</cfif>></td>
			<td>&nbsp;</td>
			<!--- <td>Credit Card 1</td> --->	<!--- REMARK ON 190908 & REPLACE BY THE BELOW ONE --->
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">AMEX<cfelseif lcase(hcomid) eq "manhattan_i" or lcase(hcomid) eq "elmanhattan_i" or lcase(hcomid) eq "manhattan09_i">#words[2062]# 1
            <select name="creditcardtype1">
            <option value="">Choose a type of credit card</option>
            <option value="VISA" <cfif getartran.creditcardtype1 eq 'VISA'>selected</cfif>>VISA</option>
            <option value="MASTER" <cfif getartran.creditcardtype1 eq 'MASTER'>selected</cfif>>MASTER</option>
            <option value="AMEX" <cfif getartran.creditcardtype1 eq 'AMEX'>selected</cfif>>AMEX</option>
            <option value="JCB" <cfif getartran.creditcardtype1 eq 'JCB'>selected</cfif>>JCB</option>
            <option value="DINERS" <cfif getartran.creditcardtype1 eq 'DINERS'>selected</cfif>>DINERS</option>
            <option value="CUP" <cfif getartran.creditcardtype1 eq 'CUP'>selected</cfif>>CUP</option>
			</select>
            <cfelse>
            <cfif getgsetup.crcdtype eq 'Y'>
            <select name="creditcardtype1">
            <option value="">Choose a type of credit card</option>
            <option value="VISA" <cfif getartran.creditcardtype1 eq 'VISA'>selected</cfif>>VISA</option>
            <option value="MASTER" <cfif getartran.creditcardtype1 eq 'MASTER'>selected</cfif>>MASTER</option>
            <option value="AMEX" <cfif getartran.creditcardtype1 eq 'AMEX'>selected</cfif>>AMEX</option>
            <option value="JCB" <cfif getartran.creditcardtype1 eq 'JCB'>selected</cfif>>JCB</option>
            <option value="DINERS" <cfif getartran.creditcardtype1 eq 'DINERS'>selected</cfif>>DINERS</option>
            <option value="CUP" <cfif getartran.creditcardtype1 eq 'CUP'>selected</cfif>>CUP</option>
			</select>
            <cfelse>
            Credit Card 1
            </cfif>
			</cfif></td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name="credit_card1" id="credit_card1" type="#hidestatus#" value="#numberformat(getartran.cs_pm_crcd,'0.00')#" size="10" maxlength="15" onKeyUp="getCredit_Card1Count();"></td>
			<cfif lcase(hcomid) eq "mhsl_i" and tran eq "RC">
            	<td nowrap><input name="taxincl" id="taxincl" type="checkbox" value="T" #iif(getartran.taxincl eq "T",DE("checked"),DE(""))# onClick="javascript:check_taxincls();"> Tax Already Included</td>
			<!--- ADD ON 17-08-2009 --->
			<cfelseif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV">
				<td nowrap><input name="contract" type="checkbox" value="T" #iif(getartran.frem9 eq "T",DE("checked"),DE(""))#> Contract</td>
			<cfelseif (lcase(HcomID) eq "ugateway_i") and tran eq "INV">
				<td nowrap><input type="checkbox" name="assigndisc" id="assigndisc" value="T" onClick="assignDisc();"> Assign Discount</td>
			<cfelseif lcase(HcomID) eq "accord_i" and tran eq "INV">
				<td>Payment Refno</td>
            <cfelseif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i")>
            	<td>#words[2117]#</td>
                <cfelse>
                <td>&nbsp;</td>
		  </cfif>
			<td><cfif lcase(HcomID) eq "accord_i" and tran eq "INV">:<cfelseif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i")>
            	:<cfelse>&nbsp;</cfif></td>
			<td><cfif lcase(HcomID) eq "accord_i" and tran eq "INV"><input type="text" name="paymentrefno" id="paymentrefno" value="<cfif isdefined('getartran.refno2')>#getartran.refno2#</cfif>" /><cfelseif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i")><input type="text" name="paymentrefno" id="paymentrefno" value="<cfif isdefined('getartran.rem6')>#getartran.rem6#</cfif>" /><cfelse>&nbsp;</cfif></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<!--- <td><cfif HcomID eq "pnp_i">NET<cfelse>Credit Card 2</cfif></td> --->	<!--- REMARK ON 190908 & REPLACE BY THE BELOW ONE --->
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><cfif HcomID eq "pnp_i">NET<cfelseif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">VISA/MC<cfelseif lcase(hcomid) eq "manhattan_i" or lcase(hcomid) eq "elmanhattan_i" or lcase(hcomid) eq "manhattan09_i">#words[2080]#
			<select name="creditcardtype2">
            <option value="">Choose a type of credit card</option>
            <option value="VISA" <cfif getartran.creditcardtype2 eq 'VISA'>selected</cfif>>VISA</option>
            <option value="MASTER" <cfif getartran.creditcardtype2 eq 'MASTER'>selected</cfif>>MASTER</option>
            <option value="AMEX" <cfif getartran.creditcardtype2 eq 'AMEX'>selected</cfif>>AMEX</option>
            <option value="JCB" <cfif getartran.creditcardtype2 eq 'JCB'>selected</cfif>>JCB</option>
            <option value="DINERS" <cfif getartran.creditcardtype2 eq 'DINERS'>selected</cfif>>DINERS</option>
            <option value="CUP" <cfif getartran.creditcardtype2 eq 'CUP'>selected</cfif>>CUP</option>
			</select>
            <cfelse>
            <cfif getgsetup.crcdtype eq 'Y'>
            <select name="creditcardtype2">
            <option value="">Choose a type of credit card</option>
            <option value="VISA" <cfif getartran.creditcardtype2 eq 'VISA'>selected</cfif>>VISA</option>
            <option value="MASTER" <cfif getartran.creditcardtype2 eq 'MASTER'>selected</cfif>>MASTER</option>
            <option value="AMEX" <cfif getartran.creditcardtype2 eq 'AMEX'>selected</cfif>>AMEX</option>
            <option value="JCB" <cfif getartran.creditcardtype2 eq 'JCB'>selected</cfif>>JCB</option>
            <option value="DINERS" <cfif getartran.creditcardtype2 eq 'DINERS'>selected</cfif>>DINERS</option>
            <option value="CUP" <cfif getartran.creditcardtype2 eq 'CUP'>selected</cfif>>CUP</option>
			</select>
            <cfelse>
            #words[2080]#
            </cfif>
			</cfif></td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name="credit_card2" id="credit_card2" type="#hidestatus#" value="#numberformat(getartran.cs_pm_crc2,'0.00')#" size="10" maxlength="15" onKeyUp="getCredit_Card2Count();"></td>
			<td><cfif lcase(HcomID) eq "accord_i" and tran eq "INV">Cheque No<cfelse>&nbsp;</cfif></td>
			<td><cfif lcase(HcomID) eq "accord_i" and tran eq "INV">:<cfelse>&nbsp;</cfif></td>
			<td><cfif lcase(HcomID) eq "accord_i" and tran eq "INV"><input type="text" name="checkno" id="checkno" value="<cfif isdefined('getartran.checkno')>#getartran.checkno#</cfif>" /><cfelse>&nbsp;</cfif></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<cfif (lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i") and (tran eq 'PO' or tran eq "RC" or tran eq "PR")>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>T.T.</td>
				<td>:</td>
				<td><input name="telegraph_transfer" id="telegraph_transfer" type="#hidestatus#" value="#numberformat(getartran.cs_pm_tt,'0.00')#" size="10" maxlength="15" onKeyUp="getTelegraph_Transfer();"></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		<cfelse>
			<input name="telegraph_transfer" id="telegraph_transfer" type="hidden" value="0">
		</cfif>

			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>#words[2081]#</td>
				<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
				<td><input name="cashCD" id="cashcd" type="#hidestatus#" value="#numberformat(getartran.cs_pm_cashCD,'0.00')#" size="10" maxlength="15" onKeyUp="getCashCDCount();"></td>
				<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>Cheque No</td>
				<td>:</td>
				<td><input type="text" name="checkno" id="checkno" value="<cfif isdefined('getartran.checkno')>#getartran.checkno#</cfif>" /></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>Gift Voucher</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name="gift_voucher" id="gift_voucher" type="#hidestatus#" value="#numberformat(getartran.cs_pm_vouc,'0.00')#" size="10" maxlength="15" onKeyUp="getGift_VoucherCount();"></td>
			<td>
			<cfif getgeneralinfo.voucher eq "Y" and (tran eq "INV" or tran eq "DO" or tran eq "CN" or tran eq "SO")>
            <cfquery name="getusedvoucher" datasource="#dts#">
            SELECT a.voucherno,coalesce(a.value,0)-coalesce(b.usagevalue,0) as value,a.type from voucher as a
            left join
            (
            SELECT sum(usagevalue) as usagevalue,voucherno FROM vouchertran
            <cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">
where type in('DO','CN')
</cfif>
            group by voucherno
            )
            as b on a.voucherno = b.voucherno
            where <cfif getgeneralinfo.asvoucher eq "Y"> a.custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#"> and</cfif> (a.used = "N" or a.used = "" or a.used is null)
            </cfquery>

            <select name="vouchernum" id="vouchernum" onChange="assignvoucher(this.value,this.options[this.selectedIndex].id,this.options[this.selectedIndex].title);">
			<option value="">Select a voucher</option>
            <cfif getartran.voucher neq "">
			<option value="#getartran.voucher#" id="#numberformat(getartran.cs_pm_vouc,'0.00')#" title="#numberformat(getartran.cs_pm_vouc,'0.00')#" selected>#getartran.voucher#-#numberformat(getartran.cs_pm_vouc,'0.00')#</option>
			</cfif>
            <cfloop query="getusedvoucher">
            <option value="#getusedvoucher.voucherno#" id="#getusedvoucher.value#" title="#getusedvoucher.type#">
            #getusedvoucher.voucherno#-<cfif getusedvoucher.type eq "Value">$ #numberformat(getusedvoucher.value,'.__')#<cfelse>#getusedvoucher.value#%</cfif>
            </option>
            </cfloop>

            </select>
	   </cfif>

       </td>
			<td colspan="3"><cfif getgeneralinfo.voucherb4disc eq "Y"><input type="text" name="voucherb4disc" id="voucherb4disc" value="#numberformat(getictran2.subtotal,'.__')#" size="10"></cfif></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
        <!---Debit card --->
        <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>Debit Card</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name="debit_card" id="debit_card" type="#hidestatus#" value="#numberformat(getartran.cs_pm_dbcd,'0.00')#" size="10" maxlength="15" onKeyUp="getDebit_cardCount();" <cfif lcase(hcomid) eq "gel_i" and husergrpid neq "Admin" and husergrpid neq "Super">readonly</cfif>></td>
			<td>#words[2077]# #words[877]#</td>
			<td>:</td>
			<td><!---<cfquery name="getvouchertype" datasource="#dts#">
			SELECT * FROM vouchertype
			</cfquery>
            <select name="rem13" id="rem13">
			<option value="">Choose a Voucher Type</option>
			<cfloop query="getvouchertype">
			<option value="#getvouchertype.voucherid#" <cfif getartran.rem13 eq getvouchertype.voucherid>selected</cfif>>#getvouchertype.voucherid# - #getvouchertype.voucherdesp#</option>
			</cfloop>
			</select>---></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
        <!--- --->
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><cfif lcase(hcomid) eq "visionlaw_i">Legal Subsidy<cfelse>Deposit</cfif></td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name="deposit" id="deposit" type="#hidestatus#" value="#numberformat(getartran.deposit,'0.00')#" size="10" maxlength="15" onKeyUp="getDepositCount();" <cfif lcase(hcomid) eq "gel_i" and husergrpid neq "Admin" and husergrpid neq "Super">readonly</cfif>></td>
			<td>#words[2077]# #words[58]#</td>
			<td>:</td>
			<td><input name="rem14" type="text" value="#getartran.rem14#" size="10" maxlength="15"></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>As Debt</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>>:</td>
			<td <cfif lcase(HcomID) eq "visionlaw_i">style="visibility:hidden"</cfif>><input name="debt" id="debt" type="#hidestatus#" size="10" value="#xdebt#" style="background-color:##FFFF99" readonly></td>
			<td colspan='6' align='left'><input type='submit' name='Submit' value='Accept & Preview'><!---<font color='##FF0000'> <--Please click 'Accept' when you finished </font>---><cfif alcreate eq 1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <input type='submit' name='Submit' value='Accept & Create New'> </cfif></td>
		</tr>
        <cfif getgsetup.termscondition eq 'Y'>
        <tr>
        <td><div align="right">#words[2153]#</div></td>
        <td colspan="10">
			<textarea name="termscondition" id="termscondition" cols="100" rows="5"><cfif getartran.termscondition neq ''>#convertquote(getartran.termscondition)#<cfelse><cfif tran eq 'RC'>#convertquote(gettermcondition.lRC)#<cfelseif tran eq 'PR'>#convertquote(gettermcondition.lPR)#<cfelseif tran eq 'DO'>#convertquote(gettermcondition.lDO)#<cfelseif tran eq 'INV'>#convertquote(gettermcondition.lINV)#<cfelseif tran eq 'CS'>#convertquote(gettermcondition.lCS)#<cfelseif tran eq 'CN'>#convertquote(gettermcondition.lCN)#<cfelseif tran eq 'DN'>#convertquote(gettermcondition.lDN)#<cfelseif tran eq 'PO'>#convertquote(gettermcondition.lPO)#<cfelseif tran eq 'QUO'>#convertquote(gettermcondition.lQUO)#<cfelseif tran eq 'SO'>#convertquote(gettermcondition.lSO)#<cfelseif tran eq 'SAM'>#convertquote(gettermcondition.lSAM)#</cfif></cfif></textarea>
			</td>
        </tr>
        <cfelse>
        <input type="hidden" name="termscondition" id="termscondition" value="">
        </cfif>
		</table>
        <cfquery datasource="#dts#" name="getartran">
			select * from artran
			where refno = '#nexttranno#' and type = '#tran#'
		</cfquery>


        <cfquery name="gettaxincludesum" datasource="#dts#">
        select sum(TAXAMT_BIL) as TAXAMT_BIL from ictran where refno = '#nexttranno#' and type = '#tran#' and taxincl = "T"
        </cfquery>



<cfif isdefined('gettaxincludesum.recordcount')>
<cfif gettaxincludesum.recordcount neq 0>
<input type="hidden" name="textincludeitem" id="textincludeitem" value="1" >
</cfif>
</cfif>
	</form>
	</cfoutput>
</cfif>

<table width='100%' align='center' class='data'>
	<cfoutput>
<tr>
	<th>#words[58]#</th>
    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
    <th>#words[121]#</th>
    </cfif>
	<th><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>Item Code</cfif></th>
	<th>#words[65]#</th>
    <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i")>
    <th>#words[482]#</th>
    </cfif>
	<th>#words[227]#</th>
    <cfif getpin2.h1360 eq 'T' and (tran eq 'PO' or tran eq 'PR' or tran eq 'RC')>

	<th><cfif tran eq "DO" and getpin2.h5700 eq "T">Price<cfelseif tran neq "DO">#words[1096]#</cfif></th>

	<th>Curr Code</th>
	<cfif wpitemtax eq "Y">
		<th>Tax Amount</th>
	</cfif>
	<th><cfif tran eq "DO" and getpin2.h5700 eq "T">#words[1097]#<cfelseif tran neq "DO">#words[1097]#</cfif></th>
	<cfif wpitemtax eq "Y">
		<th>#words[56]#</th>
	</cfif>
    </cfif>

    <cfif getpin2.h1361 eq 'T' and (tran eq 'INV' or tran eq 'DO' or tran eq 'CS' or tran eq 'CN' or tran eq 'DN' or tran eq 'QUO' or tran eq 'SO' or tran eq 'SAM')>
    <th><cfif tran eq "DO" and getpin2.h5700 eq "T">Price<cfelseif tran neq "DO">#words[1096]#</cfif></th>

	<th>Curr Code</th>
	<cfif wpitemtax eq "Y">
		<th>#words[1099]# #words[1097]#</th>
	</cfif>
	<th><cfif tran eq "DO" and getpin2.h5700 eq "T">#words[1097]#<cfelseif tran neq "DO">#words[1097]#</cfif></th>
	<cfif wpitemtax eq "Y">
		<th>#words[1099]# #words[438]#</th>
	</cfif>
    </cfif>

	<th>#words[10]#</th>
</tr>
</cfoutput>
<cfif getictran.recordcount gt 0>
	<cfquery name='getarrate' datasource='#dts#'>
		select currrate from artran where refno='#nexttranno#' and type='#tran#'
	</cfquery>

	<cfset xcurrrate=getarrate.currrate>
	<cfoutput query='getictran'>
	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
		<td>#getictran.currentrow#.</td>
        <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i">
        <cfquery name="getproductcode" datasource="#dts#">
        select aitemno from icitem where itemno='#getictran.itemno#'
        </cfquery>
        <td>#getproductcode.aitemno#</td>
        </cfif>
		<td><font face='Arial, Helvetica, sans-serif'>#itemno#</font></td>
		<td><font face='Arial, Helvetica, sans-serif'>#desp#</font></td>
        <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i")>
    	<td><font face='Arial, Helvetica, sans-serif'>#location#</font></td>
    	</cfif>
		<td><div align='right'><font face='Arial, Helvetica, sans-serif'>#qty_bil#</font></div></td>

        <cfif getpin2.h1360 eq 'T' and (tran eq 'PO' or tran eq 'PR' or tran eq 'RC')>
		<td><div align='right'><font face='Arial, Helvetica, sans-serif'><cfif tran eq "DO" and getpin2.h5700 eq "T">#numberFormat(price_bil, stDecl_UPrice)#<cfelseif tran neq "DO">#numberFormat(price_bil, stDecl_UPrice)#</cfif></font></div></td>
		<td><div align='right'><font face='Arial, Helvetica, sans-serif'>#listfirst(refno3)#</font></div></td>
		<cfif wpitemtax eq "Y">
			<td><div align='right'><font face='Arial, Helvetica, sans-serif'>#numberFormat(TAXAMT_BIL, ".__")#</font></div></td>
		</cfif>
		<td><div align='right'><font face='Arial, Helvetica, sans-serif'><cfif tran eq "DO" and getpin2.h5700 eq "T"><cfif multilocation neq "Y">#numberFormat(amt_bil, ".__")#<cfelse>#numberFormat(amt_bil, stDecl_UPrice)#</cfif><cfelseif tran neq "DO"><cfif multilocation neq "Y">#numberFormat(amt_bil, ".__")#<cfelse>#numberFormat(amt_bil, stDecl_UPrice)#</cfif></cfif></font></div></td>
		<cfif wpitemtax eq "Y">
			<td><div align='left'><font face='Arial, Helvetica, sans-serif'>
			  #note_a#
		      <cfif getictran.taxincl eq "T"> (#words[53]#)</cfif></font></div></td>
		</cfif>
        </cfif>

        <cfif getpin2.h1361 eq 'T' and (tran eq 'INV' or tran eq 'DO' or tran eq 'CS' or tran eq 'CN' or tran eq 'DN' or tran eq 'QUO' or tran eq 'SO' or tran eq 'SAM')>
        <td><div align='right'><font face='Arial, Helvetica, sans-serif'><cfif tran eq "DO" and getpin2.h5700 eq "T">#numberFormat(price_bil, stDecl_UPrice)#<cfelseif tran neq "DO">#numberFormat(price_bil, stDecl_UPrice)#</cfif></font></div></td>
		<td><div align='right'><font face='Arial, Helvetica, sans-serif'>#listfirst(refno3)#</font></div></td>
		<cfif wpitemtax eq "Y">
			<td><div align='right'><font face='Arial, Helvetica, sans-serif'>#numberFormat(TAXAMT_BIL, ".__")#</font></div></td>
		</cfif>
		<td><div align='right'><font face='Arial, Helvetica, sans-serif'><cfif tran eq "DO" and getpin2.h5700 eq "T"><cfif multilocation neq "Y">#numberFormat(amt_bil, ".__")#<cfelse>#numberFormat(amt_bil, stDecl_UPrice)#</cfif><cfelseif tran neq "DO"><cfif multilocation neq "Y">#numberFormat(amt_bil, ".__")#<cfelse>#numberFormat(amt_bil, stDecl_UPrice)#</cfif></cfif></font></div></td>
		<cfif wpitemtax eq "Y">
			<td><div align='left'><font face='Arial, Helvetica, sans-serif'>
			  #note_a#
		      <cfif getictran.taxincl eq "T"> (#words[53]#)</cfif></font></div></td>
		</cfif>
        </cfif>

		<td><div align='center'><font face='Arial, Helvetica, sans-serif'>
			<cfif lcase(hcomid) eq "steel_i" and tran neq "TR">
			<a onClick="releaseDirtyFlag();" href='transaction_steel.cfm?tran=#tran#&hmode=#hmode#&type1=Edit&itemcount=#itemcount#&
			ndatecreate=#ndatecreate#&nexttranno=#nexttranno#&refno3=#listfirst(refno3)#&currrate=#xcurrrate#&agenno=#agenno#&
			custno=#URLEncodedFormat(custno)#&readperiod=#readperiod#&invoicedate=#invoicedate#'>
			<img height='18px' width='18px' src='../../images/edit.ICO' alt='Change Item' border='0'>Change Item</a>&nbsp;
			</cfif>
		 	<!--- <cfif multilocation neq "Y"> --->
				<a onClick="releaseDirtyFlag();" href='transaction4.cfm?tran=#tran#&hmode=#hmode#&type1=Edit&itemno=#URLEncodedFormat(itemno)#&service=#linecode#&itemcount=#itemcount#&ndatecreate=#ndatecreate#&nexttranno=#nexttranno#&refno3=#listfirst(refno3)#&currrate=#xcurrrate#&agenno=#agenno#
				&enterbatch=#URLENCODEDFORMAT(batchcode)#&oldqty=#qty#&grade=#grade#&newtrancode=#newtrancode#&multilocation=#multilocation#'><img height='18px' width='18px' src='../../images/edit.ICO' alt='Edit' border='0'>#words[2148]#</a>&nbsp;
				<a onClick="relesaeDirtyFlag();" href='transaction4.cfm?tran=#tran#&hmode=#hmode#&type1=Delete&itemno=#URLEncodedFormat(itemno)#&service=#linecode#&itemcount=#itemcount#&ndatecreate=#ndatecreate#&nexttranno=#nexttranno#&refno3=#listfirst(refno3)#&currrate=#xcurrrate#&agenno=#agenno#
				&enterbatch=#URLENCODEDFORMAT(batchcode)#&oldqty=#qty#&newtrancode=#newtrancode#&multilocation=#multilocation#'><img height='18px' width='18px' src='../../images/delete.ICO' alt='Delete' border='0'>#words[805]#</a> </font></div>
			<!--- <cfelse>
				<a href='transaction4.cfm?tran=#tran#&hmode=#hmode#&type1=Edit&itemno=#URLEncodedFormat(itemno)#&service=&itemcount=&ndatecreate=#ndatecreate#&nexttranno=#nexttranno#&refno3=#listfirst(refno3)#&currrate=#xcurrrate#&agenno=#agenno#
				&enterbatch=&oldqty=#qty#&grade=#grade#&newtrancode=#newtrancode#&multilocation=#multilocation#'><img height='18px' width='18px' src='../../images/edit.ICO' alt='Edit' border='0'>Edit</a>&nbsp;
				<a href='transaction4.cfm?tran=#tran#&hmode=#hmode#&type1=Delete&itemno=#URLEncodedFormat(itemno)#&service=&itemcount=&ndatecreate=#ndatecreate#&nexttranno=#nexttranno#&refno3=#listfirst(refno3)#&currrate=#xcurrrate#&agenno=#agenno#
				&enterbatch=&oldqty=#qty#&newtrancode=#newtrancode#&multilocation=#multilocation#'><img height='18px' width='18px' src='../../images/delete.ICO' alt='Delete' border='0'>Delete</a> </font></div>
			</cfif> --->		</td>
	</tr>
   	</cfoutput>
</cfif>
</table>

<cftry>
		<cfif isdefined("form.submit1") and form.submit1 eq "  Save  ">
			<script type="text/javascript">
			document.invoicesheet.submit();
			</script>
        </cfif>
		<cfcatch type="any">
			<cfoutput>#cfcatch.Message#:::#cfcatch.Detail#</cfoutput><cfabort>
		</cfcatch>
</cftry>


<cfoutput>
<script type="text/javascript">

	function adjustgrand()
	{
		<cfif isdefined('gettaxincludesum.TAXAMT_BIL')>
			<cfif gettaxincludesum.TAXAMT_BIL neq "" >
				var totaltaxincl = #gettaxincludesum.TAXAMT_BIL#;
			<cfelse>
				var totaltaxincl = 0;
			</cfif>
		<cfelse>
			var totaltaxincl = 0;
		</cfif>
		var totalamount =document.invoicesheet.viewGrand.value;
		document.invoicesheet.viewGrand.value = (totalamount - totaltaxincl).toFixed(fixnum);
		<cfif getdefault.dfpos eq "0.05">
		<cfif lcase(hcomid) eq "gramas_i">
		document.invoicesheet.roundadj.value=((((document.invoicesheet.viewGrand.value* 2).toFixed(1))/2).toFixed(2)-document.invoicesheet.viewGrand.value).toFixed(fixnum);
		document.invoicesheet.viewGrand.value=(((document.invoicesheet.viewGrand.value* 2).toFixed(1))/2).toFixed(2);;
		<cfelseif lcase(hcomid) eq "tcds_i">
		var grandafterround=((Math.ceil(document.invoicesheet.viewGrand.value* 2*10)/10).toFixed(1));
		document.invoicesheet.roundadj.value=((grandafterround/2).toFixed(2)-document.invoicesheet.viewGrand.value).toFixed(fixnum);
		document.invoicesheet.viewGrand.value=(grandafterround/2).toFixed(2);;
		<cfelse>
		if(document.getElementById("cash").value!=0 && document.getElementById("cheque").value==0 && document.getElementById("credit_card1").value==0 && document.getElementById("credit_card2").value==0 && document.getElementById("telegraph_transfer").value==0 && document.getElementById("gift_voucher").value==0 && document.getElementById("deposit").value==0 && document.getElementById("Debit_card").value==0 && document.getElementById("cashcd").value==0)
		{
		document.invoicesheet.roundadj.value=((((document.invoicesheet.viewGrand.value* 2).toFixed(1))/2).toFixed(2)-document.invoicesheet.viewGrand.value).toFixed(fixnum);
		document.invoicesheet.viewGrand.value=(((document.invoicesheet.viewGrand.value* 2).toFixed(1))/2).toFixed(2);;
		}
		</cfif>
		</cfif>
		//document.invoicesheet.debt.value = (totalamount - totaltaxincl).toFixed(fixnum);
		var grand=parseFloat(document.getElementById("viewGrand").value);
		var cash=!isNaN(parseFloat(document.getElementById("cash").value)) ? parseFloat(document.getElementById("cash").value) : 0;
		var cheque=!isNaN(parseFloat(document.getElementById("cheque").value)) ? parseFloat(document.getElementById("cheque").value) : 0;
		var credit_card1=!isNaN(parseFloat(document.getElementById("credit_card1").value)) ? parseFloat(document.getElementById("credit_card1").value) : 0;
		var credit_card2=!isNaN(parseFloat(document.getElementById("credit_card2").value)) ? parseFloat(document.getElementById("credit_card2").value) : 0;
		var telegraph_transfer=!isNaN(parseFloat(document.getElementById("telegraph_transfer").value)) ? parseFloat(document.getElementById("telegraph_transfer").value) : 0;
		var gift_voucher=!isNaN(parseFloat(document.getElementById("gift_voucher").value)) ? parseFloat(document.getElementById("gift_voucher").value) : 0;
		var dep=!isNaN(parseFloat(document.getElementById("deposit").value)) ? parseFloat(document.getElementById("deposit").value) : 0;
		debt=(grand-cash-cheque-credit_card1-credit_card2-telegraph_transfer-gift_voucher-dep).toFixed(fixnum);
		document.invoicesheet.debt.value = debt;
	}
	adjustgrand();
	getDiscountControl();
	<cfif isdefined('xtaxp1')>
	<cfif xtaxp1 eq 0>
	var taxfield = document.getElementById('selecttax');
	document.getElementById('pTax').value=taxfield.options[taxfield.selectedIndex].id;
	getTaxControl();
	</cfif>
	</cfif>
</script>
<script type="text/javascript">
function submitinvoice()
{
document.invoicesheetpost.submit();

}


</script>
</cfoutput>

        <!--- <cfwindow  width="600" height="400" name="expressservice" refreshOnShow="true" closable="false" modal="true" title="Add Services" initshow="false"
        source="/default/transaction/services/addservices.cfm?tran=#tran#&custno=#custno#&tranno=#nexttranno#" />
        <cfwindow  width="550" height="400" name="searchitem" refreshOnShow="true" closable="true" modal="false" title="Search Item" initshow="false"
        source="/default/transaction/searchitem/searchitem.cfm" />

        <cfwindow  width="550" height="400" name="historyitem" refreshOnShow="true" closable="true" modal="false" title="History Item" initshow="false"
        source="/default/transaction/historyitem/historyitem.cfm?custno=#custno#" />

        <cfwindow  width="600" height="400" name="createservice" refreshOnShow="true" closable="true" modal="true" title="Create Services" initshow="false"
        source="/default/transaction/createservice/createservice.cfm" /> --->
        <cfif getGeneralInfo.EAPT eq "1">
        <cfset eAdd="/default/transaction/products/addproducts.cfm?tran="&tran&"&custno="&custno&"&tranno="&nexttranno >
        <cfset ewidth = "800" >
        <cfset eheight = "400" >
		<cfelse>
        <cfset eAdd="/default/transaction/advanceproduct/addproducts.cfm?tran="&tran&"&custno="&custno&"&tranno="&nexttranno >
        <cfset ewidth = "800" >
        <cfset eheight = "500" >
        </cfif>
        <!--- <cfwindow  width="#ewidth#" height="#eheight#" name="expressproduct" refreshOnShow="true" closable="false" modal="true" title="Add Products" initshow="false"
        source="#eAdd#" /> --->
        <cfset eAdd2="/default/transaction/material/addproducts.cfm?tran="&tran&"&custno="&custno&"&tranno="&nexttranno >
        <!--- <cfwindow  width="#ewidth#" height="#eheight#" name="matproduct" refreshOnShow="true" closable="false" modal="true" title="Add Material" initshow="false"
        source="#eAdd2#" /> --->

</body>
</html>
<script type="text/javascript">
var needToConfirm = true;

function setDirtyFlag()
{
needToConfirm = true; //Call this function if some changes is made to the web page and requires an alert
// Of-course you could call this is Keypress event of a text box or so...
}

function releaseDirtyFlag()
{
needToConfirm = false; //Call this function if dosent requires an alert.
//this could be called when save button is clicked
}


window.onbeforeunload = confirmExit;
function confirmExit()
{
if (needToConfirm)
return "You have attempted to leave this page. If you have made any changes to the fields without clicking the accept button, your changes will be lost. Are you sure you want to exit this page?";
}

<cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">
document.getElementById('itemselect').focus();
</cfif>
</script>
<cfabort>

<!--- <cfwindow  width="700" height="500" name="searchitem" refreshOnShow="true" closable="true" modal="false" title="Search Item" initshow="false"
        source="/default/transaction/products/searchitem2.cfm" /> --->