<html>
<head>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>

<cfset paytype = form.paytype>

<cfset reservedesp=''>

<cfif IsDefined("session.formName") and session.formname eq "transpage">

<cftry>
<cfset StructDelete(Session, "formName")>
<cfcatch type="any">
</cfcatch>
</cftry>

<cfquery name="getdefault" datasource="#dts#">
SELECT * FROM gsetup
</cfquery>

<cfquery name="getpayment" datasource="#dts#">
SELECT * FROM pospayment
</cfquery>


<cfif isdefined('form.reservebtn')><!---Reserve does not need to add point---->

<cfelse>

<cfif getdefault.memberpoint eq 'Y' and driver neq ''>
<cftry>
<!---Remember to create driver on server at every driver create page.---->

<cfquery name="gettotalpoint" datasource="#dts#">
select sum(amt) as totalamt from ictrantemp
where
type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#tran#">
and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
and (note1 ='' or note1 is null)
and (brem4 ='' or brem4 is null or brem4=0)
</cfquery>

<cfquery name="updatepoints" datasource="#dtssync#">
update driver set pointsredeem=pointsredeem+#val(form.cheque)# where driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">
</cfquery>

<cfif val(form.cheque) eq 0>
<cfquery name="updatepoints2" datasource="#dtssync#">
update driver set points=points+#fix((val(gettotalpoint.totalamt))/val(getdefault.memberpointamt))# where driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">
</cfquery>
</cfif>

<cfcatch>

<h3>Unable to connect to server to update point. Kindly use the on hold transaction to retrive this transaction.</h3>
<cfquery name="updateonhold" datasource="#dts#">
	update ictrantemp set onhold='Y' where uuid='#form.uuid#'
</cfquery>
<input type="button" name="btn" id="btn" value="New Transaction" onClick="window.location.href='/default/transaction/POS/'">
<cfabort>
</cfcatch>
</cftry>
</cfif>
</cfif><!---End Reserve does not need to add point---->

<cfquery datasource="#dts#" name="getGeneralInfo">
			select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse
            from refnoset
			where type = '#tran#'
			and counter = '1'
		</cfquery>





<cfset uuid = form.uuid>


<cfquery name="checkgrossamt" datasource="#dts#">
select sum(amt) as amt from ictrantemp where uuid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfif form.gross neq checkgrossamt.amt>
<h3>The Total Amount does not tally. <a href="##" onClick="history.go(-1);">Back</a></h3>
<cfabort>
</cfif>



<cfset type = form.tran>
<cfset refno = form.refno>
<cfset custno = form.custno>
<cfset currcode = form.currcode>
<cfset currrate = form.currrate>
<cfif isdefined('form.taxincl') or getdefault.wpitemtax eq 1>
<cfset form.gross=form.gross-form.taxamt>
</cfif>
<cfset gross_bil = form.gross>
<cfset disp1 = val(form.dispec1)>
<cfset disp2 = val(form.dispec2)>
<cfset disp3 = val(form.dispec3)>
<cfif isdefined('form.taxincl')>
<cfset taxincl = form.taxincl>
<cfelse>
<cfset taxincl = "">
</cfif>
<cfif isdefined('form.taxcode')>
<cfset note = form.taxcode>
<cfelse>
<cfset note = "">
</cfif>

<cfif lcase(hcomid) eq 'abc_i' and isdefined('form.taxincl')>
<cfset disc1_bil = form.disbil1>
<cfset disc2_bil = form.disbil2>
<cfset disc3_bil = form.disbil3>
<cfset disc_bil = val(form.cheque)+val(form.voucher)>
<cfset net_bil = form.net - (val(form.cheque)+val(form.voucher))>
<cfset grand_bil = net_bil>
<cfset taxp1 = form.taxper>
<cfset tax_bil = numberformat(grand_bil*(7/(100+val(form.taxper))),'.__')>
<cfset tax1_bil = numberformat(grand_bil*(7/(100+val(form.taxper))),'.__')>
<cfset actualamount=net_bil>
<cfset gross_bil = form.net-tax_bil>

<cfelse>
<cfset disc1_bil = form.disbil1>
<cfset disc2_bil = form.disbil2>
<cfset disc3_bil = form.disbil3>
<cfset disc_bil = form.disamt_bil>
<cfset net_bil = form.net>
<cfset taxp1 = form.taxper>
<cfset tax_bil = form.taxamt>
<cfset tax1_bil = form.taxamt>
<cfset grand_bil = form.grand>
<cfset roundadj = 0>
<cfset actualamount=form.grand>
</cfif>


<cfif lcase(hcomid) eq "tcds_i">
<cfif getdefault.dfpos eq "0.05">

<cfset grand_bil = numberformat((numberformat(Ceiling(val(grand_bil)* 2*10)/10,'._')/2),'.__')>
<cfset roundadj=grand_bil-actualamount>
</cfif>

<cfelse>
<cfif val(form.cash) neq 0 and val(form.cheque) eq 0 and val(form.credit_card1) eq 0 and val(form.credit_card2) eq 0 and val(form.debit_card) eq 0 and val(form.voucher) eq 0 and val(form.cashcamt) eq 0 and val(form.deposit) eq 0>
<cfif getdefault.dfpos eq "0.05">
<cfset grand_bil = numberformat((numberformat(val(grand_bil)* 2,'._')/2),'.__')>
<cfset roundadj=grand_bil-actualamount>
</cfif>
</cfif>
</cfif>

<cfif tran eq "rc" or tran eq "pr" or tran eq "po" or tran eq "CN">
<cfset credit_bil = grand_bil>
<cfset debit_bil = 0>
<cfelse>
<cfset debit_bil = grand_bil>
<cfset credit_bil = 0>
</cfif>
<cfif val(currrate) eq "0">
<cfset currrate = 1>
</cfif>
<cfset invgross = gross_bil * val(currrate)>
<cfset discount1 = disc1_bil * val(currrate)>
<cfset discount2 = disc2_bil * val(currrate)>
<cfset discount3 = disc3_bil * val(currrate)>
<cfset discount = disc_bil * val(currrate)>
<cfset net = net_bil * val(currrate)>
<cfset tax1 = tax1_bil * val(currrate)>
<cfset tax = tax_bil * val(currrate)>
<cfset grand = grand_bil * val(currrate)>
<cfset debitamt = debit_bil * val(currrate)>
<cfset creditamt = credit_bil * val(currrate)>
<cfset ndate = createdate(right(form.wos_date,4),mid(form.wos_date,4,2),left(form.wos_date,2))>
<cfinvoke component="cfc.Period" method="getCurrentPeriod" dts="#dts#" inputDate="#dateformat(ndate,'yyyy-mm-dd')#" returnvariable="fperiod"/>
<cfset wos_date = dateformat(ndate,'yyyy-mm-dd')>

<cfif getGeneralInfo.arun eq "1">
<cfif type eq "INV" or type eq "QUO">
<cfset minuslen = 4>
<cfelse>
<cfset minuslen = 3>
</cfif>
<cfset refnolen = len(refno)-minuslen>
<cfset refno = right(refno,refnolen)>
</cfif>

<cfquery name="checkexistrefno" datasource="#dts#">
select refno from artran where type='#type#' and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
</cfquery>
		<cfif checkexistrefno.recordcount neq 0>
        <cfquery datasource="#dts#" name="getGeneralInfo">
				select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse
                from refnoset
				where type = '#type#'
				and counter = 1
			</cfquery>

        <cfif getGeneralInfo.arun eq "1">
        <cfset refnocheck = 0>
        <cfset refno1 = checkexistrefno.refno>
        <cfloop condition="refnocheck eq 0">
        <cftry>
        <cfinvoke component="cfc.IncrementValue" method="getIncreament" input="#refno1#" returnvariable="refno"/>
		<cfcatch>
		<cfinvoke component="cfc.refno" method="processNum" oldNum="#refno1#" returnvariable="refno" />
		</cfcatch>
        </cftry>
        <cfquery name="checkexistence" datasource="#dts#">
        SELECT refno FROM artran WHERE
        refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#"> and type = '#type#'
        </cfquery>
        <cfif checkexistence.recordcount eq 0>
        <cfset refnocheck = 1>
        <cfelse>
        <cfset refno1 = refno>
		</cfif>
        </cfloop>
		<cfelse>
        <h3>The refno existed. Please enter new refno. <a href="##" onClick="history.go(-1);">Back</a></h3>
        <cfabort />
        </cfif>

        </cfif>
<cfif tran eq "rc" or tran eq "pr" or tran eq "po">
<cfquery name="getarea" datasource="#dts#">
select area,name from #target_apvend# where custno='#custno#'
</cfquery>
<cfelse>
<cfquery name="getarea" datasource="#dts#">
select area,name from #target_arcust# where custno='#custno#'
</cfquery>
</cfif>


<cfquery name="updaterate" datasource="#dts#">
update ictrantemp
SET
price = price_bil * #val(currrate)#,
amt1 = amt1_bil * #val(currrate)#,
amt = amt_bil * #val(currrate)#,
disamt = disamt_bil * #val(currrate)#,
fperiod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
wos_date = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
currrate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
van=<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">,
agenno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#agent#">,
trdatetime = now()
WHERE
uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfif getdefault.wpitemtax neq 1>
<cfif net neq 0>
	<!---<cfquery name="updateictrantax" datasource="#dts#">
    	UPDATE ictrantemp
        set note_a=<cfqueryparam cfsqltype="cf_sql_varchar" value="#note#">,
        TAXPEC1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxp1#">,
        TAXAMT_BIL=round((AMT_BIL/#val(net_bil)#)*#val(tax1_bil)#,3),
        TAXAMT=round((AMT/#val(net)#)*#val(tax)#,3)
        where
        type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
        and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
        and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
    </cfquery>--->

    <cfif taxincl eq "T">
    <cfquery name="updateictrantax" datasource="#dts#">
    	UPDATE ictrantemp
        set note_a=<cfqueryparam cfsqltype="cf_sql_varchar" value="#note#">,
        TAXPEC1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxp1#">,
        TAXAMT_BIL=round((AMT_BIL/#val(net_bil)+val(disc_bil)#)*#val(tax1_bil)#,5),
        TAXAMT=round((AMT/#val(net)+val(discount)#)*#val(tax)#,5),
        taxincl="#taxincl#"
        where
        type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
        and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
        and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">;
    </cfquery>

    <cfelse>
	<cfquery name="updateictrantax" datasource="#dts#">
    	UPDATE ictrantemp
        set note_a=<cfqueryparam cfsqltype="cf_sql_varchar" value="#note#">,
        TAXPEC1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxp1#">,
        TAXAMT_BIL=round((AMT_BIL/#val(gross_bil)#)*#val(tax1_bil)#,5),
        TAXAMT=round((AMT/#val(invgross)#)*#val(tax)#,5),
        taxincl="F"
        where
        type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
        and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
        and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">;
    </cfquery>
    </cfif>



</cfif>
</cfif>

<cfif isdefined('form.reservebtn')>
<!---Reserve bill--->
<cftry>
<cfset totaldepositamt=val(form.cash)+val(form.cheque)+val(form.credit_card1)+val(form.credit_card2)+val(form.debit_card)+val(form.voucher)+val(form.cashcamt)+val(form.deposit)>

<cfquery name="insertpackcode" datasource="#dts#">
    insert into reserve (reserveno,name,phone,email,note,grossamt,location,depositno,depositamt) values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reservename#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reservephone#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reserveemail#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="ZR">,'#val(invgross)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.coltype#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno#">,'#val(totaldepositamt)#')
    </cfquery>

<cfquery name="insertictran" datasource="#dts#">
	insert into reservedet
	(
		reserveno,
        trancode,
        itemno,
        desp,
        despa,
        qty_bil,
        price_bil,
        dispec1,
        dispec2,
        dispec3,
        disamt_bil,
        amt_bil,
        note_a
        )
        SELECT
REFNO, TRANCODE, ITEMNO, DESP, DESPA, QTY_BIL, PRICE_BIL, DISPEC1, DISPEC2, DISPEC3, DISAMT_BIL, AMT_BIL,  NOTE_A

FROM ictrantemp
where
type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>




<cfquery name="updatereserve" datasource="#dts#">
insert into deposit (depositno,desp,CS_PM_CASH) values ('#refno#','#refno#','#val(totaldepositamt)#')
</cfquery>
<cfcatch>
<h3>Kindly Delete Reserve or Deposit that have duplicate refno. Kindly use the on hold transaction to retrive this transaction.</h3>
<cfquery name="updateonhold" datasource="#dts#">
	update ictrantemp set onhold='Y' where uuid='#form.uuid#'
</cfquery>
<input type="button" name="btn" id="btn" value="New Transaction" onClick="window.location.href='/default/transaction/POS/'">
<cfabort>
</cfcatch>
</cftry>

<cfif dts eq "tcds_i">
<!---for tcds gwc--->
<cftry>

<cfquery name="insertartran" datasource="#dtssync#">
INSERT INTO artran
(type,refno,refno2,trancode,custno,fperiod,wos_date,desp,despa,agenno,source,job,currrate,gross_bil,disc1_bil,disc2_bil,disc3_bil,disc_bil,net_bil,tax1_bil,tax_bil,grand_bil,debit_bil,credit_bil,invgross,disp1,disp2,disp3,discount1,discount2,discount3,discount,net,tax1,tax,taxp1,grand,debitamt,creditamt,frem0,frem1,frem2,frem3,frem4,frem5,frem6,frem7,frem8,rem0,rem1,rem2,rem3,rem4,rem12,rem13,rem14,comm0,comm1,comm2,comm3,comm4,taxincl,note,created_by,created_on,rem10,PONO,DONO,userid,name,trdatetime,van,term,area,currcode,CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,DEPOSIT,rem11,checkno,CS_PM_CASHCD,rem9,rem8,counter,rem7,rem6,roundadj,M_charge1,MC1_bil,creditcardtype1,creditcardtype2,cashier,rem30,rem31,rem32)
values
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="CASH SALES">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvouchertype#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvoucherno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="F">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="ZR">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
now(),
"#form.cctype#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getarea.name#">,
now(),
<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">,
'#val(totaldepositamt)#',
'0',
'0',
'0',
'0',
'0',
'0',
'0',
'#form.checkno#',
'0',
'#form.rem9#',
"",
'#form.counterinfo#',
'#form.rem7#',
'#form.rem6#',
'#val(roundadj)#',
'#val(form.M_CHARGE1)#',
'#val(form.M_CHARGE1)#',
"",
"",
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reservename#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reservephone#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reserveemail#">
)
</cfquery>

<cfquery name="insertartran" datasource="#dts#">
INSERT INTO artran
(type,refno,refno2,trancode,custno,fperiod,wos_date,desp,despa,agenno,source,job,currrate,gross_bil,disc1_bil,disc2_bil,disc3_bil,disc_bil,net_bil,tax1_bil,tax_bil,grand_bil,debit_bil,credit_bil,invgross,disp1,disp2,disp3,discount1,discount2,discount3,discount,net,tax1,tax,taxp1,grand,debitamt,creditamt,frem0,frem1,frem2,frem3,frem4,frem5,frem6,frem7,frem8,rem0,rem1,rem2,rem3,rem4,rem12,rem13,rem14,comm0,comm1,comm2,comm3,comm4,taxincl,note,created_by,created_on,rem10,PONO,DONO,userid,name,trdatetime,van,term,area,currcode,CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,DEPOSIT,rem11,checkno,CS_PM_CASHCD,rem9,rem8,counter,rem7,rem6,cashierid,roundadj,M_charge1,MC1_bil,creditcardtype1,creditcardtype2,cashier,rem30,rem31,rem32)
values
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="CASH SALES">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvouchertype#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvoucherno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="F">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="ZR">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
now(),
"#form.cctype#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getarea.name#">,
now(),
<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">,
'#val(totaldepositamt)#',
'0',
'0',
'0',
'0',
'0',
'0',
'0',
'#form.checkno#',
'0',
'#form.rem9#',
"",
'#form.counterinfo#',
'#form.rem7#',
'#form.rem6#',
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">,
'#val(roundadj)#',
'#val(form.M_CHARGE1)#',
'#val(form.M_CHARGE1)#',
"",
"",
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reservename#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reservephone#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reserveemail#">
)
</cfquery>



<cfcatch>
<cfquery name="insertartran" datasource="#dts#">
INSERT INTO artran
(type,refno,refno2,trancode,custno,fperiod,wos_date,desp,despa,agenno,source,job,currrate,gross_bil,disc1_bil,disc2_bil,disc3_bil,disc_bil,net_bil,tax1_bil,tax_bil,grand_bil,debit_bil,credit_bil,invgross,disp1,disp2,disp3,discount1,discount2,discount3,discount,net,tax1,tax,taxp1,grand,debitamt,creditamt,frem0,frem1,frem2,frem3,frem4,frem5,frem6,frem7,frem8,rem0,rem1,rem2,rem3,rem4,rem12,rem13,rem14,comm0,comm1,comm2,comm3,comm4,taxincl,note,created_by,created_on,rem10,PONO,DONO,userid,name,trdatetime,van,term,area,currcode,CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,DEPOSIT,rem11,checkno,CS_PM_CASHCD,rem9,rem8,counter,rem7,rem6,cashierid,roundadj,M_charge1,MC1_bil,creditcardtype1,creditcardtype2,cashier,rem30,rem31,rem32)
values
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="CASH SALES">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvouchertype#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvoucherno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="F">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="ZR">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
now(),
"#form.cctype#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getarea.name#">,
now(),
<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">,
'#val(totaldepositamt)#',
'0',
'0',
'0',
'0',
'0',
'0',
'0',
'#form.checkno#',
'0',
'#form.rem9#',
"",
'#form.counterinfo#',
'#form.rem7#',
'#form.rem6#',
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">,
'#val(roundadj)#',
'#val(form.M_CHARGE1)#',
'#val(form.M_CHARGE1)#',
"",
"",
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reservename#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reservephone#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reserveemail#">
)
</cfquery>
</cfcatch>
</cftry>

<cfelse>

<cfquery name="insertartran" datasource="#dts#">
INSERT INTO artran
(type,refno,refno2,trancode,custno,fperiod,wos_date,desp,despa,agenno,source,job,currrate,gross_bil,disc1_bil,disc2_bil,disc3_bil,disc_bil,net_bil,tax1_bil,tax_bil,grand_bil,debit_bil,credit_bil,invgross,disp1,disp2,disp3,discount1,discount2,discount3,discount,net,tax1,tax,taxp1,grand,debitamt,creditamt,frem0,frem1,frem2,frem3,frem4,frem5,frem6,frem7,frem8,rem0,rem1,rem2,rem3,rem4,rem12,rem13,rem14,comm0,comm1,comm2,comm3,comm4,taxincl,note,created_by,created_on,rem10,PONO,DONO,userid,name,trdatetime,van,term,area,currcode,CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,DEPOSIT,rem11,checkno,CS_PM_CASHCD,rem9,rem8,counter,rem7,rem6,cashierid,roundadj,M_charge1,MC1_bil,creditcardtype1,creditcardtype2,cashier,rem30,rem31,rem32)
values
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="CASH SALES">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#val(totaldepositamt)#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvouchertype#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvoucherno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="F">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="ZR">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
now(),
"#form.cctype#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getarea.name#">,
now(),
<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">,
'#val(totaldepositamt)#',
'0',
'0',
'0',
'0',
'0',
'0',
'0',
'#form.checkno#',
'0',
'#form.rem9#',
"",
'#form.counterinfo#',
'#form.rem7#',
'#form.rem6#',
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">,
'#val(roundadj)#',
'#val(form.M_CHARGE1)#',
'#val(form.M_CHARGE1)#',
"",
"",
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reservename#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reservephone#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reserveemail#">
)
</cfquery>

</cfif>

<cfquery name="getictrantempitem" datasource="#dts#">
	SELECT itemno,desp,qty_bil
FROM ictrantemp
where
type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfoutput>
<cfloop query="getictrantempitem">
<cfif reservedesp eq ''>
<cfset reservedesp="deposit for #Chr(13)##Chr(10)##getictrantempitem.itemno# - #getictrantempitem.desp# - Qty #getictrantempitem.qty_bil#">
<cfelse>
<cfset reservedesp=reservedesp&", #Chr(13)##Chr(10)##getictrantempitem.itemno# - #getictrantempitem.desp# - Qty #getictrantempitem.qty_bil#">
</cfif>
</cfloop>
</cfoutput>

<cfif dts eq "tcds_i">
<!---for tcds gwc--->
<cftry>
<cfquery name="insertbody" datasource="#dtssync#">
INSERT INTO ictran

(TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, LOCATION,QTY_BIL, PRICE_BIL, AMT1_BIL, AMT_BIL, NOTE_A, QTY, PRICE, AMT1, AMT,FACTOR1,FACTOR2, TRDATETIME)

values (
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="deposit">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#reservedesp#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.coltype#">,
'1',
#val(totaldepositamt)#,
#val(totaldepositamt)#,
#val(totaldepositamt)#,
<cfqueryparam cfsqltype="cf_sql_varchar" value="ZR">,
'1',
#val(totaldepositamt)#,
#val(totaldepositamt)#,
#val(totaldepositamt)#,
'1',
'1',
now()

)
</cfquery>

<cfquery name="insertbody" datasource="#dts#">
INSERT INTO ictran

(TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, LOCATION,QTY_BIL, PRICE_BIL, AMT1_BIL, AMT_BIL, NOTE_A, QTY, PRICE, AMT1, AMT,FACTOR1,FACTOR2, TRDATETIME)

values (
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="deposit">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#reservedesp#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.coltype#">,
'1',
#val(totaldepositamt)#,
#val(totaldepositamt)#,
#val(totaldepositamt)#,
<cfqueryparam cfsqltype="cf_sql_varchar" value="ZR">,
'1',
#val(totaldepositamt)#,
#val(totaldepositamt)#,
#val(totaldepositamt)#,
'1',
'1',
now()

)
</cfquery>


<cfcatch>
<cfquery name="insertbody" datasource="#dts#">
INSERT INTO ictran

(TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, LOCATION,QTY_BIL, PRICE_BIL, AMT1_BIL, AMT_BIL, NOTE_A, QTY, PRICE, AMT1, AMT,FACTOR1,FACTOR2, TRDATETIME)

values (
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="deposit">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#reservedesp#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.coltype#">,
'1',
#val(totaldepositamt)#,
#val(totaldepositamt)#,
#val(totaldepositamt)#,
<cfqueryparam cfsqltype="cf_sql_varchar" value="ZR">,
'1',
#val(totaldepositamt)#,
#val(totaldepositamt)#,
#val(totaldepositamt)#,
'1',
'1',
now()

)
</cfquery>
</cfcatch>
</cftry>


<cfelse>

<cfquery name="insertbody" datasource="#dts#">
INSERT INTO ictran

(TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, LOCATION,QTY_BIL, PRICE_BIL, AMT1_BIL, AMT_BIL, NOTE_A, QTY, PRICE, AMT1, AMT,FACTOR1,FACTOR2, TRDATETIME)

values (
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="1">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="deposit">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#reservedesp#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.coltype#">,
'1',
#val(totaldepositamt)#,
#val(totaldepositamt)#,
#val(totaldepositamt)#,
<cfqueryparam cfsqltype="cf_sql_varchar" value="ZR">,
'1',
#val(totaldepositamt)#,
#val(totaldepositamt)#,
#val(totaldepositamt)#,
'1',
'1',
now()

)
</cfquery>
</cfif>

<cfelse>
<!---Cash Sales bill--->


<!--- use voucher--->


<cfif getpayment.vouchertype eq 'system'>
<cftry>
<cfif realvoucherno neq ''>
<cfset voucherlength=listlen(realvoucherno)>
<cfloop from="1" to="#val(voucherlength)#" index="i">
<cfquery name="updatevoucher" datasource="#dtssync#">
	update voucher set used='Y',invoiceno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#"> where voucherno='#listgetat(realvoucherno,i,',')#'
</cfquery>
</cfloop>
</cfif>
<cfcatch>

<h3>Unable to connect to server to use voucher. Kindly use the on hold transaction to retrive this transaction.</h3>
<cfquery name="updateonhold" datasource="#dts#">
	update ictrantemp set onhold='Y' where uuid='#form.uuid#'
</cfquery>
<input type="button" name="btn" id="btn" value="New Transaction" onClick="window.location.href='/default/transaction/POS/'">
<cfabort>
</cfcatch>
</cftry>
</cfif>
<!--- --->

<!---Sell Voucher--->
<cfquery name="getictranvoucher" datasource="#dts#">
	select * from ictrantemp where
    itemno='voucher'
    and type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
    and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
    and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>
<cfloop query="getictranvoucher">

<cfset newvoucherno=''>

<cfquery name="getlastvoucherno" datasource="#dts#">
	select max(voucherno) as lastvoucherno from voucher
</cfquery>

<cfif getlastvoucherno.lastvoucherno eq ''>
<cfset newvoucherno='V'&getdefault.ddllocation&'0000001'>
<cfelse>
		<cftry>
        <cfinvoke component="cfc.IncrementValue" method="getIncreament" input="#getlastvoucherno.lastvoucherno#" returnvariable="newvoucherno"/>
		<cfcatch>
		<cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastvoucherno.lastvoucherno#" returnvariable="newvoucherno" />
		</cfcatch>
        </cftry>
</cfif>

<cftry>
<cfquery name="insertvoucher" datasource="#dtssync#">
	insert into voucher (voucherno,type,value,desp,created_on,created_by) values ('#newvoucherno#','Value','#val(getictranvoucher.amt)#','#getictranvoucher.refno#',now(),<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">)
</cfquery>

<cfcatch>

<h3>Unable to connect to server to add voucher. Kindly use the on hold transaction to retrive this transaction.</h3>
<cfquery name="updateonhold" datasource="#dts#">
	update ictrantemp set onhold='Y' where uuid='#form.uuid#'
</cfquery>
<input type="button" name="btn" id="btn" value="New Transaction" onClick="window.location.href='/default/transaction/POS/'">
<cfabort>

</cfcatch>
</cftry>

<cfquery name="insertvoucher" datasource="#dts#">
	insert into voucher (voucherno,type,value,desp,created_on,created_by) values ('#newvoucherno#','Value','#val(getictranvoucher.amt)#','#getictranvoucher.refno#',now(),<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">)
</cfquery>



<cfquery name="update" datasource="#dts#">
	update ictrantemp set brem3='#newvoucherno#'
    where trancode='#getictranvoucher.trancode#'
    and type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
    and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
    and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

</cfloop>

<cfif dts eq "tcds_i">

<!---for tcds gwc--->
<cftry>

<cfquery name="insertartran" datasource="#dtssync#">
INSERT INTO artran
(type,refno,refno2,trancode,custno,fperiod,wos_date,desp,despa,agenno,source,job,currrate,gross_bil,disc1_bil,disc2_bil,disc3_bil,disc_bil,net_bil,tax1_bil,tax_bil,grand_bil,debit_bil,credit_bil,invgross,disp1,disp2,disp3,discount1,discount2,discount3,discount,net,tax1,tax,taxp1,grand,debitamt,creditamt,frem0,frem1,frem2,frem3,frem4,frem5,frem6,frem7,frem8,rem0,rem1,rem2,rem3,rem4,rem12,rem13,rem14,comm0,comm1,comm2,comm3,comm4,taxincl,note,created_by,created_on,rem10,PONO,DONO,userid,name,trdatetime,van,term,area,currcode,CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,DEPOSIT,rem11,checkno,CS_PM_CASHCD,rem9,rem8,counter,rem7,rem6,roundadj,M_charge1,MC1_bil,creditcardtype1,creditcardtype2,cashier,permitno,rem5<cfif getdefault.memberpoint eq 'Y' and driver neq ''>,point</cfif>,rem40,rem41)
values
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="CASH SALES">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#gross_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc1_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc2_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc3_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#net_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax1_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#grand_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#debit_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#credit_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#invgross#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp3#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount3#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#net#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxp1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#grand#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#debitamt#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#creditamt#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvouchertype#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvoucherno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxincl#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#note#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
now(),
"#form.cctype#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getarea.name#">,
now(),
<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">,
'#form.cash#',
'<cfif lcase(hcomid) eq 'tcds_i'>0<cfelse>#form.cheque#</cfif>',
'#form.credit_card1#',
'#form.credit_card2#',
'#form.debit_card#',
'<cfif lcase(hcomid) eq 'tcds_i'>0<cfelse>#form.voucher#</cfif>',
'#form.deposit#',
'#form.changeamt1#',
'#form.checkno#',
'#form.cashcamt#',
'#form.rem9#',
"#form.cctype2#",
'#form.counterinfo#',
'#form.rem7#',
'#form.rem6#',
'#val(roundadj)#',
'#val(form.M_CHARGE1)#',
'#val(form.M_CHARGE1)#',
"#form.cctype#",
"#form.cctype2#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">
<cfif lcase(hcomid) eq 'tcds_i'>
,'#form.voucher#'
,'#form.cheque#'
<cfelse>
,'',''
</cfif>
<cfif getdefault.memberpoint eq 'Y' and driver neq ''>
,<cfif val(form.cheque) eq 0>#fix((val(gettotalpoint.totalamt))/val(getdefault.memberpointamt))#<cfelse>'0'</cfif>
</cfif>
,'#form.realdeposit#'
,'#form.rem41#'
)
</cfquery>

<cfquery name="getlocalbody" datasource="#dts#">
SELECT

TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, DESPA, AGENNO, LOCATION, SOURCE, JOB, SIGN, QTY_BIL, PRICE_BIL, UNIT_BIL, AMT1_BIL, DISPEC1, DISPEC2, DISPEC3, DISAMT_BIL, AMT_BIL, TAXPEC1, TAXPEC2, TAXPEC3, TAXAMT_BIL, NOTE_A, IMPSTAGE, QTY, PRICE, UNIT, AMT1, DISAMT, AMT, TAXAMT, FACTOR1, FACTOR2, DONO, DODATE, SODATE, BREM1, BREM2, BREM3, BREM4, PACKING, NOTE1, NOTE2, GLTRADAC, UPDCOST, GST_ITEM, TOTALUP, WITHSN, NODISPLAY, GRADE, PUR_PRICE, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY_RET, TEMPFIGI, SERCOST, M_CHARGE1, M_CHARGE2, ADTCOST1, ADTCOST2, IT_COS, AV_COST, BATCHCODE, EXPDATE, POINT, INV_DISC, INV_TAX, SUPP, EDI_COU1, WRITEOFF, TOSHIP, SHIPPED, NAME, DEL_BY, VAN, GENERATED, UD_QTY, TOINV, EXPORTED, EXPORTED1, EXPORTED2, EXPORTED3, BRK_TO, SV_PART, LAST_YEAR, VOID, SONO, MC1_BIL, MC2_BIL, USERID, DAMT, OLDBILL, WOS_GROUP, CATEGORY, AREA, SHELF, TEMP, TEMP1, BODY, TOTALGROUP, MARK, TYPE_SEQ, PROMOTER, TABLENO, MEMBER, TOURGROUP, TRDATETIME, TIME, BOMNO, COMMENT, DEFECTIVE, M_CHARGE3, M_CHARGE4, M_CHARGE5, M_CHARGE6, M_CHARGE7, MC3_BIL, MC4_BIL, MC5_BIL, MC6_BIL, MC7_BIL, taxincl

FROM ictrantemp
where
type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfloop query="getlocalbody">
<cfquery name="insertbody" datasource="#dtssync#">
INSERT INTO ictran

(TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, DESPA, AGENNO, LOCATION, SOURCE, JOB, SIGN, QTY_BIL, PRICE_BIL, UNIT_BIL, AMT1_BIL, DISPEC1, DISPEC2, DISPEC3, DISAMT_BIL, AMT_BIL, TAXPEC1, TAXPEC2, TAXPEC3, TAXAMT_BIL, NOTE_A, IMPSTAGE, QTY, PRICE, UNIT, AMT1, DISAMT, AMT, TAXAMT, FACTOR1, FACTOR2, DONO, DODATE, SODATE, BREM1, BREM2, BREM3, BREM4, PACKING, NOTE1, NOTE2, GLTRADAC, UPDCOST, GST_ITEM, TOTALUP, WITHSN, NODISPLAY, GRADE, PUR_PRICE, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY_RET, TEMPFIGI, SERCOST, M_CHARGE1, M_CHARGE2, ADTCOST1, ADTCOST2, IT_COS, AV_COST, BATCHCODE, EXPDATE, POINT, INV_DISC, INV_TAX, SUPP, EDI_COU1, WRITEOFF, TOSHIP, SHIPPED, NAME, DEL_BY, VAN, GENERATED, UD_QTY, TOINV, WOS_GROUP, CATEGORY, COMMENT, taxincl)

values (
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.REFNO#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.REFNO2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.TRANCODE#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.CUSTNO#">,
"#getlocalbody.FPERIOD#",
"#dateformat(getlocalbody.WOS_DATE,'yyyy-mm-dd')#",
"#getlocalbody.CURRRATE#",
"#getlocalbody.ITEMCOUNT#",
"#getlocalbody.LINECODE#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.ITEMNO#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.DESP#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.DESPA#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.AGENNO#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.LOCATION#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.SOURCE#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.JOB#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getlocalbody.SIGN#">,
"#getlocalbody.QTY_BIL#",
"#getlocalbody.PRICE_BIL#",
"#getlocalbody.UNIT_BIL#",
"#getlocalbody.AMT1_BIL#",
"#getlocalbody.DISPEC1#",
"#getlocalbody.DISPEC2#",
"#getlocalbody.DISPEC3#",
"#getlocalbody.DISAMT_BIL#",
"#getlocalbody.AMT_BIL#",
"#getlocalbody.TAXPEC1#",
"#getlocalbody.TAXPEC2#",
"#getlocalbody.TAXPEC3#",
"#getlocalbody.TAXAMT_BIL#",
"#getlocalbody.NOTE_A#",
"#getlocalbody.IMPSTAGE#",
"#getlocalbody.QTY#",
"#getlocalbody.PRICE#",
"#getlocalbody.UNIT#",
"#getlocalbody.AMT1#",
"#getlocalbody.DISAMT#",
"#getlocalbody.AMT#",
"#getlocalbody.TAXAMT#",
"#getlocalbody.FACTOR1#",
"#getlocalbody.FACTOR2#",
"#getlocalbody.DONO#",
"0000-00-00",
"0000-00-00",
"#getlocalbody.BREM1#",
"#getlocalbody.BREM2#",
"#getlocalbody.BREM3#",
"#getlocalbody.BREM4#",
"#getlocalbody.PACKING#",
"#getlocalbody.NOTE1#",
"#getlocalbody.NOTE2#",
"#getlocalbody.GLTRADAC#",
"#getlocalbody.UPDCOST#",
"#getlocalbody.GST_ITEM#",
"#getlocalbody.TOTALUP#",
"#getlocalbody.WITHSN#",
"#getlocalbody.NODISPLAY#",
"#getlocalbody.GRADE#",
"#getlocalbody.PUR_PRICE#",
"#getlocalbody.QTY1#",
"#getlocalbody.QTY2#",
"#getlocalbody.QTY3#",
"#getlocalbody.QTY4#",
"#getlocalbody.QTY5#",
"#getlocalbody.QTY6#",
"#getlocalbody.QTY7#",
"#getlocalbody.QTY_RET#",
"#getlocalbody.TEMPFIGI#",
"#getlocalbody.SERCOST#",
"#getlocalbody.M_CHARGE1#",
"#getlocalbody.M_CHARGE2#",
"#getlocalbody.ADTCOST1#",
"#getlocalbody.ADTCOST2#",
"#getlocalbody.IT_COS#",
"#getlocalbody.AV_COST#",
"#getlocalbody.BATCHCODE#",
"0000-00-00",
"#getlocalbody.POINT#",
"#getlocalbody.INV_DISC#",
"#getlocalbody.INV_TAX#",
"#getlocalbody.SUPP#",
"#getlocalbody.EDI_COU1#",
"#getlocalbody.WRITEOFF#",
"#getlocalbody.TOSHIP#",
"#getlocalbody.SHIPPED#",
"#getlocalbody.NAME#",
"#getlocalbody.DEL_BY#",
"#getlocalbody.VAN#",
"#getlocalbody.GENERATED#",
"#getlocalbody.UD_QTY#",
"#getlocalbody.TOINV#",

"#getlocalbody.WOS_GROUP#",
"#getlocalbody.CATEGORY#",
"#tostring(getlocalbody.COMMENT)#",
"#getlocalbody.taxincl#"
)

</cfquery>

</cfloop>

<cfquery name="insertartran" datasource="#dts#">
INSERT INTO artran
(type,refno,refno2,trancode,custno,fperiod,wos_date,desp,despa,agenno,source,job,currrate,gross_bil,disc1_bil,disc2_bil,disc3_bil,disc_bil,net_bil,tax1_bil,tax_bil,grand_bil,debit_bil,credit_bil,invgross,disp1,disp2,disp3,discount1,discount2,discount3,discount,net,tax1,tax,taxp1,grand,debitamt,creditamt,frem0,frem1,frem2,frem3,frem4,frem5,frem6,frem7,frem8,rem0,rem1,rem2,rem3,rem4,rem12,rem13,rem14,comm0,comm1,comm2,comm3,comm4,taxincl,note,created_by,created_on,rem10,PONO,DONO,userid,name,trdatetime,van,term,area,currcode,CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,DEPOSIT,rem11,checkno,CS_PM_CASHCD,rem9,rem8,counter,rem7,rem6,cashierid,roundadj,M_charge1,MC1_bil,creditcardtype1,creditcardtype2,cashier,permitno,rem5<cfif getdefault.memberpoint eq 'Y' and driver neq ''>,point</cfif>,rem40,rem41)
values
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="CASH SALES">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#gross_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc1_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc2_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc3_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#net_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax1_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#grand_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#debit_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#credit_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#invgross#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp3#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount3#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#net#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxp1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#grand#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#debitamt#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#creditamt#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvouchertype#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvoucherno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxincl#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#note#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
now(),
"#form.cctype#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getarea.name#">,
now(),
<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">,
'#form.cash#',
'<cfif lcase(hcomid) eq 'tcds_i'>0<cfelse>#form.cheque#</cfif>',
'#form.credit_card1#',
'#form.credit_card2#',
'#form.debit_card#',
'<cfif lcase(hcomid) eq 'tcds_i'>0<cfelse>#form.voucher#</cfif>',
'#form.deposit#',
'#form.changeamt1#',
'#form.checkno#',
'#form.cashcamt#',
'#form.rem9#',
"#form.cctype2#",
'#form.counterinfo#',
'#form.rem7#',
'#form.rem6#',
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">,
'#val(roundadj)#',
'#val(form.M_CHARGE1)#',
'#val(form.M_CHARGE1)#',
"#form.cctype#",
"#form.cctype2#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">
<cfif lcase(hcomid) eq 'tcds_i'>
,'#form.voucher#'
,'#form.cheque#'
<cfelse>
,'',''
</cfif>
<cfif getdefault.memberpoint eq 'Y' and driver neq ''>
,<cfif val(form.cheque) eq 0>#fix((val(gettotalpoint.totalamt))/val(getdefault.memberpointamt))#<cfelse>'0'</cfif>
</cfif>
,'#form.realdeposit#'
,'#form.rem41#'
)
</cfquery>


<cfquery name="insertbody" datasource="#dts#">
INSERT INTO ictran

(TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, DESPA, AGENNO, LOCATION, SOURCE, JOB, SIGN, QTY_BIL, PRICE_BIL, UNIT_BIL, AMT1_BIL, DISPEC1, DISPEC2, DISPEC3, DISAMT_BIL, AMT_BIL, TAXPEC1, TAXPEC2, TAXPEC3, TAXAMT_BIL, NOTE_A, IMPSTAGE, QTY, PRICE, UNIT, AMT1, DISAMT, AMT, TAXAMT, FACTOR1, FACTOR2, DONO, DODATE, SODATE, BREM1, BREM2, BREM3, BREM4, PACKING, NOTE1, NOTE2, GLTRADAC, UPDCOST, GST_ITEM, TOTALUP, WITHSN, NODISPLAY, GRADE, PUR_PRICE, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY_RET, TEMPFIGI, SERCOST, M_CHARGE1, M_CHARGE2, ADTCOST1, ADTCOST2, IT_COS, AV_COST, BATCHCODE, EXPDATE, POINT, INV_DISC, INV_TAX, SUPP, EDI_COU1, WRITEOFF, TOSHIP, SHIPPED, NAME, DEL_BY, VAN, GENERATED, UD_QTY, TOINV, EXPORTED, EXPORTED1, EXPORTED2, EXPORTED3, BRK_TO, SV_PART, LAST_YEAR, VOID, SONO, MC1_BIL, MC2_BIL, USERID, DAMT, OLDBILL, WOS_GROUP, CATEGORY, AREA, SHELF, TEMP, TEMP1, BODY, TOTALGROUP, MARK, TYPE_SEQ, PROMOTER, TABLENO, MEMBER, TOURGROUP, TRDATETIME, TIME, BOMNO, COMMENT, DEFECTIVE, M_CHARGE3, M_CHARGE4, M_CHARGE5, M_CHARGE6, M_CHARGE7, MC3_BIL, MC4_BIL, MC5_BIL, MC6_BIL, MC7_BIL, taxincl)

SELECT

TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, DESPA, AGENNO, LOCATION, SOURCE, JOB, SIGN, QTY_BIL, PRICE_BIL, UNIT_BIL, AMT1_BIL, DISPEC1, DISPEC2, DISPEC3, DISAMT_BIL, AMT_BIL, TAXPEC1, TAXPEC2, TAXPEC3, TAXAMT_BIL, NOTE_A, IMPSTAGE, QTY, PRICE, UNIT, AMT1, DISAMT, AMT, TAXAMT, FACTOR1, FACTOR2, DONO, DODATE, SODATE, BREM1, BREM2, BREM3, BREM4, PACKING, NOTE1, NOTE2, GLTRADAC, UPDCOST, GST_ITEM, TOTALUP, WITHSN, NODISPLAY, GRADE, PUR_PRICE, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY_RET, TEMPFIGI, SERCOST, M_CHARGE1, M_CHARGE2, ADTCOST1, ADTCOST2, IT_COS, AV_COST, BATCHCODE, EXPDATE, POINT, INV_DISC, INV_TAX, SUPP, EDI_COU1, WRITEOFF, TOSHIP, SHIPPED, NAME, DEL_BY, VAN, GENERATED, UD_QTY, TOINV, EXPORTED, EXPORTED1, EXPORTED2, EXPORTED3, BRK_TO, SV_PART, LAST_YEAR, VOID, SONO, MC1_BIL, MC2_BIL, USERID, DAMT, OLDBILL, WOS_GROUP, CATEGORY, AREA, SHELF, TEMP, TEMP1, BODY, TOTALGROUP, MARK, TYPE_SEQ, PROMOTER, TABLENO, MEMBER, TOURGROUP, TRDATETIME, TIME, BOMNO, COMMENT, DEFECTIVE, M_CHARGE3, M_CHARGE4, M_CHARGE5, M_CHARGE6, M_CHARGE7, MC3_BIL, MC4_BIL, MC5_BIL, MC6_BIL, MC7_BIL, taxincl

FROM ictrantemp
where
type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfcatch>
<cfquery name="insertartran" datasource="#dts#">
INSERT INTO artran
(type,refno,refno2,trancode,custno,fperiod,wos_date,desp,despa,agenno,source,job,currrate,gross_bil,disc1_bil,disc2_bil,disc3_bil,disc_bil,net_bil,tax1_bil,tax_bil,grand_bil,debit_bil,credit_bil,invgross,disp1,disp2,disp3,discount1,discount2,discount3,discount,net,tax1,tax,taxp1,grand,debitamt,creditamt,frem0,frem1,frem2,frem3,frem4,frem5,frem6,frem7,frem8,rem0,rem1,rem2,rem3,rem4,rem12,rem13,rem14,comm0,comm1,comm2,comm3,comm4,taxincl,note,created_by,created_on,rem10,PONO,DONO,userid,name,trdatetime,van,term,area,currcode,CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,DEPOSIT,rem11,checkno,CS_PM_CASHCD,rem9,rem8,counter,rem7,rem6,cashierid,roundadj,M_charge1,MC1_bil,creditcardtype1,creditcardtype2,cashier,permitno,rem5<cfif getdefault.memberpoint eq 'Y' and driver neq ''>,point</cfif>,rem40,rem41)
values
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="CASH SALES">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#gross_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc1_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc2_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc3_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#net_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax1_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#grand_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#debit_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#credit_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#invgross#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp3#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount3#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#net#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxp1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#grand#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#debitamt#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#creditamt#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvouchertype#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvoucherno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxincl#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#note#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
now(),
"#form.cctype#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getarea.name#">,
now(),
<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">,
'#form.cash#',
'<cfif lcase(hcomid) eq 'tcds_i'>0<cfelse>#form.cheque#</cfif>',
'#form.credit_card1#',
'#form.credit_card2#',
'#form.debit_card#',
'<cfif lcase(hcomid) eq 'tcds_i'>0<cfelse>#form.voucher#</cfif>',
'#form.deposit#',
'#form.changeamt1#',
'#form.checkno#',
'#form.cashcamt#',
'#form.rem9#',
"#form.cctype2#",
'#form.counterinfo#',
'#form.rem7#',
'#form.rem6#',
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">,
'#val(roundadj)#',
'#val(form.M_CHARGE1)#',
'#val(form.M_CHARGE1)#',
"#form.cctype#",
"#form.cctype2#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">
<cfif lcase(hcomid) eq 'tcds_i'>
,'#form.voucher#'
,'#form.cheque#'
<cfelse>
,'',''
</cfif>
<cfif getdefault.memberpoint eq 'Y' and driver neq ''>
,<cfif val(form.cheque) eq 0>#fix((val(gettotalpoint.totalamt))/val(getdefault.memberpointamt))#<cfelse>'0'</cfif>
</cfif>
,'#form.realdeposit#'
,'#form.rem41#'
)
</cfquery>


<cfquery name="insertbody" datasource="#dts#">
INSERT INTO ictran

(TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, DESPA, AGENNO, LOCATION, SOURCE, JOB, SIGN, QTY_BIL, PRICE_BIL, UNIT_BIL, AMT1_BIL, DISPEC1, DISPEC2, DISPEC3, DISAMT_BIL, AMT_BIL, TAXPEC1, TAXPEC2, TAXPEC3, TAXAMT_BIL, NOTE_A, IMPSTAGE, QTY, PRICE, UNIT, AMT1, DISAMT, AMT, TAXAMT, FACTOR1, FACTOR2, DONO, DODATE, SODATE, BREM1, BREM2, BREM3, BREM4, PACKING, NOTE1, NOTE2, GLTRADAC, UPDCOST, GST_ITEM, TOTALUP, WITHSN, NODISPLAY, GRADE, PUR_PRICE, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY_RET, TEMPFIGI, SERCOST, M_CHARGE1, M_CHARGE2, ADTCOST1, ADTCOST2, IT_COS, AV_COST, BATCHCODE, EXPDATE, POINT, INV_DISC, INV_TAX, SUPP, EDI_COU1, WRITEOFF, TOSHIP, SHIPPED, NAME, DEL_BY, VAN, GENERATED, UD_QTY, TOINV, EXPORTED, EXPORTED1, EXPORTED2, EXPORTED3, BRK_TO, SV_PART, LAST_YEAR, VOID, SONO, MC1_BIL, MC2_BIL, USERID, DAMT, OLDBILL, WOS_GROUP, CATEGORY, AREA, SHELF, TEMP, TEMP1, BODY, TOTALGROUP, MARK, TYPE_SEQ, PROMOTER, TABLENO, MEMBER, TOURGROUP, TRDATETIME, TIME, BOMNO, COMMENT, DEFECTIVE, M_CHARGE3, M_CHARGE4, M_CHARGE5, M_CHARGE6, M_CHARGE7, MC3_BIL, MC4_BIL, MC5_BIL, MC6_BIL, MC7_BIL, taxincl)

SELECT

TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, DESPA, AGENNO, LOCATION, SOURCE, JOB, SIGN, QTY_BIL, PRICE_BIL, UNIT_BIL, AMT1_BIL, DISPEC1, DISPEC2, DISPEC3, DISAMT_BIL, AMT_BIL, TAXPEC1, TAXPEC2, TAXPEC3, TAXAMT_BIL, NOTE_A, IMPSTAGE, QTY, PRICE, UNIT, AMT1, DISAMT, AMT, TAXAMT, FACTOR1, FACTOR2, DONO, DODATE, SODATE, BREM1, BREM2, BREM3, BREM4, PACKING, NOTE1, NOTE2, GLTRADAC, UPDCOST, GST_ITEM, TOTALUP, WITHSN, NODISPLAY, GRADE, PUR_PRICE, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY_RET, TEMPFIGI, SERCOST, M_CHARGE1, M_CHARGE2, ADTCOST1, ADTCOST2, IT_COS, AV_COST, BATCHCODE, EXPDATE, POINT, INV_DISC, INV_TAX, SUPP, EDI_COU1, WRITEOFF, TOSHIP, SHIPPED, NAME, DEL_BY, VAN, GENERATED, UD_QTY, TOINV, EXPORTED, EXPORTED1, EXPORTED2, EXPORTED3, BRK_TO, SV_PART, LAST_YEAR, VOID, SONO, MC1_BIL, MC2_BIL, USERID, DAMT, OLDBILL, WOS_GROUP, CATEGORY, AREA, SHELF, TEMP, TEMP1, BODY, TOTALGROUP, MARK, TYPE_SEQ, PROMOTER, TABLENO, MEMBER, TOURGROUP, TRDATETIME, TIME, BOMNO, COMMENT, DEFECTIVE, M_CHARGE3, M_CHARGE4, M_CHARGE5, M_CHARGE6, M_CHARGE7, MC3_BIL, MC4_BIL, MC5_BIL, MC6_BIL, MC7_BIL, taxincl

FROM ictrantemp
where
type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

</cfcatch>
</cftry>



<cfelse>

<cfquery name="insertartran" datasource="#dts#">
INSERT INTO artran
(type,refno,refno2,trancode,custno,fperiod,wos_date,desp,despa,agenno,source,job,currrate,gross_bil,disc1_bil,disc2_bil,disc3_bil,disc_bil,net_bil,tax1_bil,tax_bil,grand_bil,debit_bil,credit_bil,invgross,disp1,disp2,disp3,discount1,discount2,discount3,discount,net,tax1,tax,taxp1,grand,debitamt,creditamt,frem0,frem1,frem2,frem3,frem4,frem5,frem6,frem7,frem8,rem0,rem1,rem2,rem3,rem4,rem12,rem13,rem14,comm0,comm1,comm2,comm3,comm4,taxincl,note,created_by,created_on,rem10,PONO,DONO,userid,name,trdatetime,van,term,area,currcode,CS_PM_CASH,CS_PM_CHEQ,CS_PM_CRCD,CS_PM_CRC2,CS_PM_DBCD,CS_PM_VOUC,DEPOSIT,rem11,checkno,CS_PM_CASHCD,rem9,rem8,counter,rem7,rem6,cashierid,roundadj,M_charge1,MC1_bil,creditcardtype1,creditcardtype2,cashier,permitno,rem5<cfif getdefault.memberpoint eq 'Y' and driver neq ''>,point</cfif>,rem40,rem41)
values
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refno2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="CASH SALES">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currrate#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#gross_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc1_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc2_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc3_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disc_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#net_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax1_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#grand_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#debit_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#credit_bil#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#invgross#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#disp3#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount2#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount3#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#discount#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#net#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#tax#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxp1#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#grand#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#debitamt#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#creditamt#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="Profile">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvouchertype#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.realvoucherno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxincl#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#note#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
now(),
"#form.cctype#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#Huserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#getarea.name#">,
now(),
<cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">,
'#form.cash#',
'<cfif lcase(hcomid) eq 'tcds_i'>0<cfelse>#form.cheque#</cfif>',
'#form.credit_card1#',
'#form.credit_card2#',
'#form.debit_card#',
'<cfif lcase(hcomid) eq 'tcds_i'>0<cfelse>#form.voucher#</cfif>',
'#form.deposit#',
'#form.changeamt1#',
'#form.checkno#',
'#form.cashcamt#',
'#form.rem9#',
"#form.cctype2#",
'#form.counterinfo#',
'#form.rem7#',
'#form.rem6#',
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">,
'#val(roundadj)#',
'#val(form.M_CHARGE1)#',
'#val(form.M_CHARGE1)#',
"#form.cctype#",
"#form.cctype2#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="#cashierinfo#">
<cfif lcase(hcomid) eq 'tcds_i'>
,'#form.voucher#'
,'#form.cheque#'
<cfelse>
,'',''
</cfif>
<cfif getdefault.memberpoint eq 'Y' and driver neq ''>
,<cfif val(form.cheque) eq 0>#fix((val(gettotalpoint.totalamt))/val(getdefault.memberpointamt))#<cfelse>'0'</cfif>
</cfif>
,'#form.realdeposit#'
,'#form.rem41#'
)
</cfquery>


<cfquery name="insertbody" datasource="#dts#">
INSERT INTO ictran

(TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, DESPA, AGENNO, LOCATION, SOURCE, JOB, SIGN, QTY_BIL, PRICE_BIL, UNIT_BIL, AMT1_BIL, DISPEC1, DISPEC2, DISPEC3, DISAMT_BIL, AMT_BIL, TAXPEC1, TAXPEC2, TAXPEC3, TAXAMT_BIL, NOTE_A, IMPSTAGE, QTY, PRICE, UNIT, AMT1, DISAMT, AMT, TAXAMT, FACTOR1, FACTOR2, DONO, DODATE, SODATE, BREM1, BREM2, BREM3, BREM4, PACKING, NOTE1, NOTE2, GLTRADAC, UPDCOST, GST_ITEM, TOTALUP, WITHSN, NODISPLAY, GRADE, PUR_PRICE, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY_RET, TEMPFIGI, SERCOST, M_CHARGE1, M_CHARGE2, ADTCOST1, ADTCOST2, IT_COS, AV_COST, BATCHCODE, EXPDATE, POINT, INV_DISC, INV_TAX, SUPP, EDI_COU1, WRITEOFF, TOSHIP, SHIPPED, NAME, DEL_BY, VAN, GENERATED, UD_QTY, TOINV, EXPORTED, EXPORTED1, EXPORTED2, EXPORTED3, BRK_TO, SV_PART, LAST_YEAR, VOID, SONO, MC1_BIL, MC2_BIL, USERID, DAMT, OLDBILL, WOS_GROUP, CATEGORY, AREA, SHELF, TEMP, TEMP1, BODY, TOTALGROUP, MARK, TYPE_SEQ, PROMOTER, TABLENO, MEMBER, TOURGROUP, TRDATETIME, TIME, BOMNO, COMMENT, DEFECTIVE, M_CHARGE3, M_CHARGE4, M_CHARGE5, M_CHARGE6, M_CHARGE7, MC3_BIL, MC4_BIL, MC5_BIL, MC6_BIL, MC7_BIL, taxincl)

SELECT

TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, CURRRATE, ITEMCOUNT, LINECODE, ITEMNO, DESP, DESPA, AGENNO, LOCATION, SOURCE, JOB, SIGN, QTY_BIL, PRICE_BIL, UNIT_BIL, AMT1_BIL, DISPEC1, DISPEC2, DISPEC3, DISAMT_BIL, AMT_BIL, TAXPEC1, TAXPEC2, TAXPEC3, TAXAMT_BIL, NOTE_A, IMPSTAGE, QTY, PRICE, UNIT, AMT1, DISAMT, AMT, TAXAMT, FACTOR1, FACTOR2, DONO, DODATE, SODATE, BREM1, BREM2, BREM3, BREM4, PACKING, NOTE1, NOTE2, GLTRADAC, UPDCOST, GST_ITEM, TOTALUP, WITHSN, NODISPLAY, GRADE, PUR_PRICE, QTY1, QTY2, QTY3, QTY4, QTY5, QTY6, QTY7, QTY_RET, TEMPFIGI, SERCOST, M_CHARGE1, M_CHARGE2, ADTCOST1, ADTCOST2, IT_COS, AV_COST, BATCHCODE, EXPDATE, POINT, INV_DISC, INV_TAX, SUPP, EDI_COU1, WRITEOFF, TOSHIP, SHIPPED, NAME, DEL_BY, VAN, GENERATED, UD_QTY, TOINV, EXPORTED, EXPORTED1, EXPORTED2, EXPORTED3, BRK_TO, SV_PART, LAST_YEAR, VOID, SONO, MC1_BIL, MC2_BIL, USERID, DAMT, OLDBILL, WOS_GROUP, CATEGORY, AREA, SHELF, TEMP, TEMP1, BODY, TOTALGROUP, MARK, TYPE_SEQ, PROMOTER, TABLENO, MEMBER, TOURGROUP, TRDATETIME, TIME, BOMNO, COMMENT, DEFECTIVE, M_CHARGE3, M_CHARGE4, M_CHARGE5, M_CHARGE6, M_CHARGE7, MC3_BIL, MC4_BIL, MC5_BIL, MC6_BIL, MC7_BIL, taxincl

FROM ictrantemp
where
type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>


</cfif>


</cfif>

<cfquery name="updateiserialtemp" datasource="#dts#">
	update iserialtemp set
    fperiod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fperiod#">,
    custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
    wos_date = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wos_date#">,
    type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
	refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
    where
	uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfquery name="insertiserial" datasource="#dts#">
INSERT INTO iserial

(TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, DEL_BY, ITEMNO, DESP, DESPA, SERIALNO, SEQ, AGENNO, LOCATION, SOURCE, JOB, CURRRATE, SIGN, VOID, PRICE, EXPORTED, GENERATED)

SELECT

TYPE, REFNO, REFNO2, TRANCODE, CUSTNO, FPERIOD, WOS_DATE, DEL_BY, ITEMNO, DESP, DESPA, SERIALNO, SEQ, AGENNO, LOCATION, SOURCE, JOB, CURRRATE, SIGN, VOID, PRICE, EXPORTED, GENERATED

FROM iserialtemp
where
uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>




<cfquery name="updateictrantemp" datasource="#dts#">
update ictrantemp set onhold=''
where
type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
and uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
</cfquery>

<cfif type eq "RC">
<cfquery name="checkupdate" datasource="#dts#">
SELECT UPDATE_UNIT_COST FROM gsetup2
</cfquery>
<cftry>
<cfif checkupdate.update_unit_cost eq "T">
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
		where type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
		and fperiod <> '99'
		order by itemcount;
	</cfquery>

	<cfif getictran.recordcount gt 0 and getictran.UPDCOST neq "Y">
		<cfloop query = "getictran">
			<cfquery name = "updateIcitem" datasource = "#dts#">
				update icitem
				set ucost=<cfqueryparam cfsqltype="cf_sql_double" value="#getictran.price#">
				where itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#getictran.itemno#">;
			</cfquery>

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
	</cfif>
<cfelse>
<cfquery name = "updateictran" datasource = "#dts#">
		UPDATE ICTRAN SET UPDCOST = "Y" WHERE
		type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
		and refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
		and fperiod <> '99
	</cfquery>
</cfif>
<cfcatch type="any">
</cfcatch>
</cftry>
</cfif>
<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>
<cfif getgsetup.comboard eq 'Y'>
<cfinvoke component="cfc.comboard" method="display" firstline="" secondlineleft="" secondlineright="#numberformat(grand,',_.__')#" comchannel="#getgsetup.comboardport#" returnvariable="test"/>
</cfif>

<cfquery name="updatedeposit" datasource="#dts#">
	update deposit set billno='#refno#' where depositno='#form.realdeposit#'
</cfquery>

<cfquery name="updatedeposit" datasource="#dts#">
	update reserve set status='Clear' where reserveno='#form.realdeposit#'
</cfquery>

<cfquery name="updatedeposit" datasource="#dts#">
	update reservedet set status='Clear' where reserveno='#form.realdeposit#'
</cfquery>

<cfquery datasource="#dts#" name="getGeneralInfo">
			select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse
            from refnoset
			where type = '#type#'
			and counter = 1
</cfquery>

 	<cfif (getGeneralInfo.refnocode2 neq "" or getGeneralInfo.refnocode neq "") and getGeneralInfo.presuffixuse eq "1" and getGeneralInfo.arun eq "1">
    <cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />
	<cfelse>
	<cfset newnextnum = refno>
	</cfif>

    <cfquery name="updaterefno" datasource="#dts#">
    UPDATE refnoset
    SET lastUsedNo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newnextnum#">
    where type = '#type#'
	and counter = <cfqueryparam cfsqltype="cf_sql_varchar" value="1">
    </cfquery>
    <cfquery name="getgeneral" datasource="#dts#">
    SELECT AECE FROM gsetup
    </cfquery>
	<cfif lcase(hcomid) eq "starfone_i">
    <cflocation url="/default/transaction/POS/processprintA4.cfm?tran=#type#&nexttranno=#refno#">
    <cfelseif getgsetup.bcurr eq "IDR">
    <cfform name="form1" id="form1" action="/default/transaction/POS/indoprocessprint.cfm" method="post">
    <cfinput type="hidden" name="type" id="type" value="#type#">
    <cfinput type="hidden" name="refno" id="refno" value="#refno#">
    </cfform>

   <script type="text/javascript">
    form1.submit();
    </script>
    <cfelse>
    <cfform name="form1" id="form1" action="/default/transaction/POS/processprint.cfm?paytype=#paytype#" method="post">
    <cfinput type="hidden" name="type" id="type" value="#type#">
    <cfinput type="hidden" name="refno" id="refno" value="#refno#">
    </cfform>

   <script type="text/javascript">
    form1.submit();
    </script>
    </cfif>
    <cfelse>
    <cfoutput>
    <h1>Duplicate Submission Detected. Please do not press back button.</h1>
    <cfabort />
    </cfoutput>
	</cfif>

    </body>
    </html>