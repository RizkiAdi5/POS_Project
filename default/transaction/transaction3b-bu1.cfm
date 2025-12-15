<cfparam name = "form.special_account_code" default = "">
<cfparam name = "form.taxincl" default = "F">
<cfif (lcase(HcomID) eq "net_i" or lcase(hcomid) eq "netm_i") and tran eq "INV">
	<cfparam name = "form.contract" default = "F">
</cfif>
<cfparam name = "form.selecttax" default = "">
<cfparam name = "form.wpitemtax" default = "">

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

<!--- ADD ON 27-07-2009 --->
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
<cfif isdefined('textincludeitem')>
<cfset xsubtotal = xgrand_bil - xtotalamttax >
</cfif>
<cfset xinvgross = xsubtotal*currrate>
<cfset xdiscount1 = disc1_bil*currrate>
<cfset xdiscount2 = disc2_bil*currrate>
<cfset xdiscount3 = disc3_bil*currrate>
<cfset xdiscount = iif(((disc1_bil+disc2_bil+disc3_bil)*currrate) neq 0,((disc1_bil+disc2_bil+disc3_bil)*currrate),(disc_bil*currrate))>
<cfset xnet = xnet_bil*currrate>
<cfset xtax = tax1_bil*currrate>
<cfset xgrand = xgrand_bil*currrate>
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
	cs_pm_crc2='#form.credit_card2#',
	cs_pm_vouc='#form.gift_voucher#',
    cs_pm_dbcd='#form.Debit_card#',
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
	where type='#tran#' and refno='#nexttranno#';
</cfquery>

<cfif form.wpitemtax neq "Y" and val(xnet) neq 0>
	<cfquery name="updateictrantax" datasource="#dts#">
    	UPDATE ictran 
        set note_a='#form.selecttax#',
        TAXPEC1='#xptax#',
        TAXAMT_BIL=round((AMT_BIL/#val(xnet_bil)#)*#val(tax1_bil)#,2),
        TAXAMT=round((AMT/#val(xnet)#)*#val(xtax)#,2)
        where type='#tran#' and refno='#nexttranno#';
    </cfquery>
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
		<cfif getartran.trdatetime neq "">#createdatetime(year(getartran.trdatetime),month(getartran.trdatetime),day(getartran.trdatetime),hour(getartran.trdatetime),minute(getartran.trdatetime),second(getartran.trdatetime))#<cfelse>''</cfif>,'#getartran.userid#','#getartran.created_by#','#getartran.updated_by#',
		<cfif getartran.created_on neq "">#createdatetime(year(getartran.created_on),month(getartran.created_on),day(getartran.created_on),hour(getartran.created_on),minute(getartran.created_on),second(getartran.created_on))#<cfelse>''</cfif>,
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

<cfquery name="getgeneral" datasource="#dts#">
	select printoption from gsetup;
</cfquery>

<cfset session.hcredit_limit_exceed = "">
<cfset session.bcredit_limit_exceed = "">
<cfset session.customercode = "">
<cfset session.tran_refno = "">

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