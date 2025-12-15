
<cfparam name = "form.special_account_code" default = "">
<cfparam name = "form.taxincl" default = "F">
<cfif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV">
	<cfparam name = "form.contract" default = "F">
</cfif>
<cfparam name = "form.selecttax" default = "">
<cfparam name = "form.wpitemtax" default = "">

<cfquery name="getdefault" datasource="#dts#">
SELECT dfpos FROM gsetup
</cfquery>

<cfset xtotaldisc1 = val(form.totaldisc1)>
<cfset xtotaldisc2 = val(form.totaldisc2)>
<cfset xtotaldisc3 = val(form.totaldisc3)>
<cfset xtotalamtdisc = val(form.totalamtdisc)>
<cfset xsubtotal = val(form.subtotal)>
<cfset xptax = val(form.pTax)>
<cfset xtotalamttax = val(form.totalamttax)>
<cfset xdeposit = val(form.deposit)>

<cfif (xtotaldisc1 neq 0 or xtotaldisc2 neq 0 or xtotaldisc3 neq 0) and xtotalamtdisc neq 0>
	<cfset disc1_bil = xsubtotal * xtotaldisc1 / 100>
	<cfset disc1_bil = numberformat(disc1_bil,discformat)>
  	<cfset xnet_bil = xsubtotal - val(disc1_bil)>
	<cfset disc2_bil = xnet_bil * xtotaldisc2 / 100>
	<cfset disc2_bil = numberformat(disc2_bil,discformat)>
  	<cfset xnet_bil = xnet_bil - val(disc2_bil)>
	<cfset disc3_bil = xnet_bil * xtotaldisc3 / 100>
	<cfset disc3_bil = numberformat(disc3_bil,discformat)>
  	<cfset xnet_bil = xnet_bil - val(disc3_bil)>
	<cfset disc_bil = val(disc1_bil) + val(disc2_bil) + val(disc3_bil)>
<cfelseif (xtotaldisc1 eq 0 and xtotaldisc2 eq 0 and xtotaldisc3 eq 0) and xtotalamtdisc neq 0>	
  	<cfset disc1_bil = 0>
  	<cfset disc2_bil = 0>
  	<cfset disc3_bil = 0>
  	<cfset disc_bil = xtotalamtdisc>
  	<cfset xnet_bil = xsubtotal - disc_bil>
<cfelse>
  	<cfset disc1_bil = xsubtotal * xtotaldisc1 / 100>	
  	<cfset xnet_bil = xsubtotal - disc1_bil>
	<cfset disc2_bil = xnet_bil * xtotaldisc2 / 100>
  	<cfset xnet_bil = xnet_bil - disc2_bil>
	<cfset disc3_bil = xnet_bil * xtotaldisc3 / 100>
  	<cfset xnet_bil = xnet_bil - disc3_bil>
  	<cfset disc_bil = disc1_bil + disc2_bil + disc3_bil>
</cfif>

<!--- Add on 030708 --->
<cfset disc_bil = numberformat(disc_bil,discformat)>

<!--- <cfif selecttax eq "">
	<cfset tax1_bil = 0>
	<cfset tax_bil = 0>
<cfelse> --->
	<!--- REMARK ON 17-10-2009 --->
	<!--- <cfif xptax neq 0>
		<cfif lcase(hcomid) eq "steel_i"><cfset xnet_bil=xnet_bil-xdeposit></cfif>
		<cfset tax1_bil = xnet_bil * xptax / 100>
		<cfif form.taxincl eq "T">
			<cfset tax1_bil = xnet_bil * xptax / (100+xptax)>
		<cfelse>
			<cfset tax1_bil = xnet_bil * xptax / 100>
		</cfif>
	<cfelse> --->
		<cfset tax1_bil = xtotalamttax>		<!-- GET TAX AMOUNT FROM FORM --->
	<!--- </cfif> --->
	<cfset tax_bil = tax1_bil>
<!--- </cfif> --->
<cfif form.taxincl eq "T">
	<cfset xgrand_bil = #form.viewgrand#>
<cfelse>
	<cfset xgrand_bil = #form.viewgrand#>
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select printoption,voucher,voucherbal,voucherb4disc,crcdtype from gsetup;
</cfquery>
<!--- ADD ON 27-07-2009 --->
<cfif getgeneral.voucher eq "Y" and (tran eq "INV" or tran eq "DO" or tran eq "CN" or tran eq "SO")>
<cfquery name="reversevoucher" datasource="#dts#">
SELECT Voucher,wos_date From artran where type='#tran#' and refno='#nexttranno#';
</cfquery>
<cfif reversevoucher.voucher neq "">
<cfquery name="updatevoucher" datasource="#dts#">
update voucher set used = "N",updated_by ="#HuserId#",updated_on = now() where voucherno = "#reversevoucher.voucher#"
</cfquery>
<cfif getgeneral.voucherbal eq "Y">
<cfquery name="updatevoucher" datasource="#dts#">
delete from vouchertran WHERE refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nexttranno#"> and type = '#tran#'
</cfquery>
</cfif>
</cfif>
</cfif>

<cfif lcase(hcomid) eq "mhsl_i" and tran eq "RC">
	<cfset xpnbtTax=val(form.pnbtTax)>
    <cfset xnbttax=val(form.xnbttax)>
    
	<cfif val(form.pnbtTax) neq 0>
		<cfset taxnbt_bil=xgrand_bil*xpnbtTax / 100>
    <cfelse>
		<cfset taxnbt_bil=xnbttax>
	</cfif>
    
    <cfset xgrand_bil=xgrand_bil+taxnbt_bil>
    <cfset xtaxnbt=taxnbt_bil*currrate>
</cfif>

<cfset xgrand_bil = val(xgrand_bil)>
<cfset totalmisc = 0>
<cftry>
<cfset totalmisc = val(form.mc1_bil)+val(form.mc2_bil)+val(form.mc3_bil)+val(form.mc4_bil)+val(form.mc5_bil)+val(form.mc6_bil)+val(form.mc7_bil)>
<cfcatch type="any">
</cfcatch>
</cftry>
<cfif isdefined('form.textincludeitem')>
<cfif isdefined('form.roundadj')>
<cfset xsubtotal = xgrand_bil - xtotalamttax + val(disc_bil)-val(totalmisc)-val(form.roundadj)>
<cfelse>
<cfset xsubtotal = xgrand_bil - xtotalamttax + val(disc_bil)-val(totalmisc)>
</cfif>
</cfif>
<cfset xinvgross = xsubtotal*currrate>
<cfset xdiscount1 = disc1_bil*currrate>
<cfset xdiscount2 = disc2_bil*currrate>
<cfset xdiscount3 = disc3_bil*currrate>
<cfset xdiscount = iif(((disc1_bil+disc2_bil+disc3_bil)*currrate) neq 0,((disc1_bil+disc2_bil+disc3_bil)*currrate),(disc_bil*currrate))>

<cfset xnet = xnet_bil*currrate>
<cfset xtax = tax1_bil*currrate>
<cfset xgrand = xgrand_bil*currrate>
	

<cfif currrate neq 1>
<cfset xnet = numberformat(xnet_bil,'.__')*currrate>
<cfset xtax = numberformat(tax1_bil,'.__')*currrate>
<cfset xgrand = numberformat(xgrand_bil,'.__')*currrate>
</cfif>
<cfset xgrand = val(xgrand)>	
<cfquery datasource="#dts#" name="updateartran">
  	Update artran set 
  	gross_bil='#xsubtotal#', 
  	disc1_bil='#disc1_bil#', 
  	disc2_bil='#disc2_bil#', 
  	disc3_bil='#disc3_bil#', 
  	disc_bil='#disc_bil#', 
  	tax1_bil='#tax1_bil#',
  	tax_bil='#tax_bil#',
  	net_bil='#xnet_bil#', 
  	grand_bil='#xgrand_bil#', 
  	invgross='#xinvgross#',
  	disp1='#xtotaldisc1#', 
  	disp2='#xtotaldisc2#', 
  	disp3='#xtotaldisc3#', 
  	discount1='#xdiscount1#', 
  	discount2='#xdiscount2#', 
  	discount3='#xdiscount3#', 
  	discount='#xdiscount#',
  	taxp1='#xptax#', 
  	tax='#xtax#',
  	net='#xnet#',
    <cfif isdefined('form.roundadj')>
    roundadj='#val(form.roundadj)#',
    </cfif>
   <cfif getgeneral.voucher eq "Y" and (tran eq "INV" or tran eq "DO" or tran eq "CN" or tran eq "SO")>
    voucher=<cfif form.gift_voucher neq 0>'#form.vouchernum#'<cfelse>''</cfif>,
    </cfif> 
  	frem9='<cfif lcase(hcomid) eq "hco_i">#form.frem9#<cfelseif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV">#form.contract#<cfelse>#form.frem9#</cfif>',
  	grand='#xgrand#',
	<cfswitch expression="#tran#">
		<cfcase value="RC,CN,OAI" delimiters=",">
			creditamt='#xgrand#',
		</cfcase>
		<cfdefaultcase>
			debitamt='#xgrand#',
		</cfdefaultcase>
	</cfswitch>
  	note = '#form.selecttax#',
	mc1_bil = '#form.mc1_bil#',
	mc2_bil = '#form.mc2_bil#',
	mc3_bil = '#form.mc3_bil#',
	mc4_bil = '#form.mc4_bil#',
	mc5_bil = '#form.mc5_bil#',
	mc6_bil = '#form.mc6_bil#',
	mc7_bil = '#form.mc7_bil#',
	m_charge1 = '#form.mc1_bil * currrate#',
	m_charge2 = '#form.mc2_bil * currrate#',
	m_charge3 = '#form.mc3_bil * currrate#',
	m_charge4 = '#form.mc4_bil * currrate#',
	m_charge5 = '#form.mc5_bil * currrate#',
	m_charge6 = '#form.mc6_bil * currrate#',
	m_charge7 = '#form.mc7_bil * currrate#',
	<!--- multipayment mode --->
	deposit='#xdeposit#',
	cs_pm_cash='#form.cash#',
	cs_pm_cheq='#form.cheque#',
	cs_pm_crcd='#form.credit_card1#',
    cs_pm_dbcd='#form.Debit_card#',
    <cfif lcase(hcomid) eq "manhattan_i" or lcase(hcomid) eq "elmanhattan_i">
    creditcardtype1='#form.creditcardtype1#',
    creditcardtype2='#form.creditcardtype2#',
    <cfelse>
    <cfif getgeneral.crcdtype eq 'Y'>
    creditcardtype1='#form.creditcardtype1#',
    creditcardtype2='#form.creditcardtype2#',
    </cfif>
    </cfif>
	cs_pm_crc2='#form.credit_card2#',
	cs_pm_vouc='#form.gift_voucher#',
	cs_pm_debt='#form.debt#',
	<cfif (lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i") and (tran eq 'PO' or tran eq "RC" or tran eq "PR")>
		cs_pm_tt='#form.telegraph_transfer#',
	</cfif>
	<!--- multipayment mode --->
	<!--- tax already included --->
	taxincl='#form.taxincl#',
	<!--- tax already included --->
	<cfif form.clear_all_special_account_code eq "yes" or form.special_account_code eq "">
		special_account_code=''
	<cfelseif form.special_account_code neq "">
		special_account_code='#form.special_account_code#'
	</cfif> 
	<!--- ADD ON 27-07-2009 --->
	<cfif lcase(hcomid) eq "mhsl_i" and tran eq "RC">
		,TAXNBTP='#val(xpnbtTax)#'
        ,TAXNBT_BIL='#val(taxnbt_bil)#'
        ,TAXNBT='#val(xtaxnbt)#'
	</cfif>
    <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i")>
    ,rem6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.paymentrefno#" >
    </cfif>
    <cfif lcase(HcomID) eq "accord_i" and tran eq "INV">
    <cfif isdefined('form.checkno')>
    	,checkno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.checkno#" >
	</cfif>
    <cfif isdefined('form.paymentrefno')>
    	,refno2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.paymentrefno#" >
	</cfif>
    </cfif>
    	,checkno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.checkno#" >
        ,cs_pm_cashCD = '#val(cashCD)#'
    	,termscondition = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.termscondition#" >
        <cfif isdefined('form.rem13')>
        ,rem13 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rem13#" >
        </cfif>
        <cfif isdefined('form.rem14')>
        ,rem14 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rem14#" >
        </cfif>
	where type='#tran#' and refno='#nexttranno#';
</cfquery>

<cfif getgeneral.voucher eq "Y" and (tran eq "INV" or tran eq "DO" or tran eq "CN" or tran eq "SO")>
<cfif getgeneral.voucherbal eq "Y">
<cfquery name="insertvouchertran" datasource="#dts#">
INSERT INTO vouchertran (voucherno,usagevalue,wos_date,refno,type,created_by,created_on)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.vouchernum#">,
<cfif tran eq "CN">
<cfif getgeneral.voucherbal eq "Y">
"#val(form.subtotal)*-1#",
<cfelse>
"#val(form.gift_voucher)*-1#",
</cfif>
<cfelse>
<cfif getgeneral.voucherbal eq "Y">
"#val(form.subtotal)#",
<cfelse>
"#form.gift_voucher#",
</cfif>
</cfif>
"#dateformat(reversevoucher.wos_date,'YYYY-MM-DD')#",
<cfqueryparam cfsqltype="cf_sql_varchar" value="#nexttranno#">,
'#tran#',
'#huserid#',
now()
)
</cfquery>

<cfquery name="checkfull" datasource="#dts#">
SELECT a.voucherno,coalesce(a.value,0)-coalesce(b.usagevalue,0) as value,a.type from voucher as a
            left join
            (
            SELECT sum(usagevalue) as usagevalue,voucherno FROM vouchertran
            group by voucherno
            )
            as b on a.voucherno = b.voucherno
            where a.voucherno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.vouchernum#">
</cfquery>

<cfif val(checkfull.value) lte 0>
<cfquery name="updatevouchery" datasource="#dts#">
Update voucher set used = "Y",invoiceno ='#nexttranno#',updated_by ="#HuserId#",updated_on = now()  where voucherno = '#form.vouchernum#'
</cfquery>
</cfif>

<cfelse>
<cfquery name="updatevouchery" datasource="#dts#">
Update voucher set used = "Y",invoiceno ='#nexttranno#',updated_by ="#HuserId#",updated_on = now()  where voucherno = '#form.vouchernum#'
</cfquery>
</cfif>
</cfif>

<cfif form.wpitemtax neq "Y" and val(xinvgross) neq 0>

	<cfif form.taxincl eq "T">
    <cfquery name="updateictrantax" datasource="#dts#">
    	UPDATE ictran 
        set note_a='#form.selecttax#',
        TAXPEC1='#xptax#',
        TAXAMT_BIL=round((AMT_BIL/#val(xnet_bil)#)*#val(tax1_bil)#,5),
        TAXAMT=round((AMT/#val(xnet)#)*#val(xtax)#,5)
        where type='#tran#' and refno='#nexttranno#';
    </cfquery>
    <cfelse>
	<cfquery name="updateictrantax" datasource="#dts#">
    	UPDATE ictran 
        set note_a='#form.selecttax#',
        TAXPEC1='#xptax#',
        TAXAMT_BIL=round((AMT_BIL/#val(xsubtotal)#)*#val(tax1_bil)#,5),
        TAXAMT=round((AMT/#val(xinvgross)#)*#val(xtax)#,5)
        where type='#tran#' and refno='#nexttranno#';
    </cfquery>
    </cfif>
</cfif>

<!--- Add on 250808 --->
<cfif tran NEQ "SAM" and hmode eq "Edit">
	<cfquery datasource="#dts#" name="getartran">
		select * from artran
		where type='#tran#' and refno='#nexttranno#'
	</cfquery>
	
	<cfif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV" and form.contract eq "T" and getartran.rem10 eq "">
		<cfset date1=dateformat(getartran.wos_date,"dd/mm/yyyy")>
		<cfset date2=dateformat(DateAdd("d", 364, getartran.wos_date),"dd/mm/yyyy")>
		
		<cfquery name="update" datasource="#dts#">
			update artran
			set rem10='#date1#',
			rem11='#date2#'
			where type='#tran#' and refno='#nexttranno#'
		</cfquery>
	</cfif>
	
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
		TRDATETIME,USERID,CREATED_BY,UPDATED_BY,CREATED_ON,UPDATED_ON)
		values
		('#tran#','#nexttranno#','#getartran.custno#','#getartran.fperiod#',#getartran.wos_date#,'#getartran.desp#','#getartran.despa#',
		<cfswitch expression="#tran#">
			<cfcase value="RC,CN,OAI" delimiters=",">
				'#xgrand#'
			</cfcase>
			<cfdefaultcase>
				'#xgrand#'
			</cfdefaultcase>
		</cfswitch>,
		<cfif getartran.trdatetime neq "">#createdatetime(year(getartran.trdatetime),month(getartran.trdatetime),day(getartran.trdatetime),hour(getartran.trdatetime),minute(getartran.trdatetime),second(getartran.trdatetime))#<cfelse>'0000-00-00 00:00'</cfif>,'#getartran.userid#','#getartran.created_by#','#getartran.updated_by#',
		<cfif getartran.created_on neq "">#createdatetime(year(getartran.created_on),month(getartran.created_on),day(getartran.created_on),hour(getartran.created_on),minute(getartran.created_on),second(getartran.created_on))#<cfelse>'0000-00-00 00:00'</cfif>,
		#createdatetime(year(getartran.updated_on),month(getartran.updated_on),day(getartran.updated_on),hour(getartran.updated_on),minute(getartran.updated_on),second(getartran.updated_on))#)
	</cfquery>
</cfif>


<cfquery name="update_ictran_special_account_code" datasource="#dts#">
	update ictran set 	
	<cfif form.clear_all_special_account_code eq "yes">
		gltradac=''
	<cfelseif form.special_account_code neq "">
		gltradac='#form.special_account_code#'
	<cfelse>
		gltradac=gltradac
	</cfif> 
	where type='#tran#' and refno='#nexttranno#';
</cfquery>

<!--- UPDATE ICITEM AND ICL3P2 --->
<cfif tran eq "RC">
	<cfinclude template = "transaction3b_update_unit_cost_process.cfm">
</cfif>
<!--- UPDATE ICITEM AND ICL3P2 --->  

<cfif lcase(hcomid) eq "nikbra_i" and tran eq "SO">
	<cfinclude template = "/customized/#dts#/updatetopo_process.cfm">
</cfif>



<cfset session.hcredit_limit_exceed = "">
<cfset session.bcredit_limit_exceed = "">
<cfset session.customercode = "">
<cfset session.tran_refno = "">

<cfif isdefined ('form.submit')>


<cfif form.submit eq 'Accept & Create New'>
<cfquery name='getgeneralinfo' datasource='#dts#'>
	select gst,filteritem,filterall, 
	invoneset,rc_oneset,pr_oneset,do_oneset,cs_oneset,cn_oneset,dn_oneset,iss_oneset,
	po_oneset,so_oneset, quo_oneset, assm_oneset, tr_oneset, oai_oneset, oar_oneset, sam_oneset, multilocation,wpitemtax,wpitemtax1,EAPT,voucher,filteritemAJAX,voucherbal,asvoucher,crcdtype
	from gsetup
</cfquery>

<cfif getgeneralinfo.invoneset neq '1' and tran eq 'INV'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.rc_oneset neq '1' and tran eq 'RC'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.pr_oneset neq '1' and tran eq 'PR'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.do_oneset neq '1' and tran eq 'DO'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.cs_oneset neq '1' and tran eq 'CS'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.cn_oneset neq '1' and tran eq 'CN'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.dn_oneset neq '1' and tran eq 'DN'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.iss_oneset neq '1' and tran eq 'ISS'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.po_oneset neq '1' and tran eq 'PO'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.so_oneset neq '1' and tran eq 'SO'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.quo_oneset neq '1' and tran eq 'QUO'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.assm_oneset neq '1' and tran eq 'ASSM'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.tr_oneset neq '1' and tran eq 'TR'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.oai_oneset neq '1' and tran eq 'OAI'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.oar_oneset neq '1' and tran eq 'OAR'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelseif getgeneralinfo.sam_oneset neq '1' and tran eq 'SAM'>
				<cflocation url="transaction0.cfm?tran=#tran#">
			<cfelse>
            <cflocation url="transaction1.cfm?ttype=create&tran=#tran#&nexttranno=&bcode=&dcode=&first=0">
			</cfif>

<cfelse>

<cfif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV" and form.contract eq "T">
	<cflocation url="chkcntct.cfm?tran=#tran#&nexttranno=#nexttranno#&custno=#form.custno#">
<cfelse>
	<cfif getgeneral.printoption eq "1">
   
		<cflocation url="transaction3c.cfm?tran=#tran#&nexttranno=#nexttranno#">
     
	<cfelse>
		<!--- <cflocation url="../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#nexttranno#"> --->
		<!--- Modified on 06-02-2009 --->
		<cfoutput>
			<form name="done" action="transaction.cfm?tran=#tran#" method="post">
			</form>
		</cfoutput>
		<script>
			<cfoutput>window.open('../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#nexttranno#');</cfoutput>
			done.submit();
			
		</script>
	</cfif>	
</cfif>
</cfif>

<cfelse>

<cfif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV" and form.contract eq "T">
	<cflocation url="chkcntct.cfm?tran=#tran#&nexttranno=#nexttranno#&custno=#form.custno#">
<cfelse>
	<cfif getgeneral.printoption eq "1">
   
		<cflocation url="transaction3c.cfm?tran=#tran#&nexttranno=#nexttranno#">
     
	<cfelse>
		<!--- <cflocation url="../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#nexttranno#"> --->
		<!--- Modified on 06-02-2009 --->
		<cfoutput>
			<form name="done" action="transaction.cfm?tran=#tran#" method="post">
			</form>
		</cfoutput>
		<script>
			<cfoutput>window.open('../../billformat/#dts#/transactionformat.cfm?tran=#tran#&nexttranno=#nexttranno#');</cfoutput>
			done.submit();
			
		</script>
	</cfif>	
</cfif>

</cfif>