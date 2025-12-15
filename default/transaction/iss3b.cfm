<cfparam name = "form.selecttax" default = "">

<cfif form.totaldisc1 neq "">
	<cfset xtotaldisc1 = form.totaldisc1>
<cfelse>
	<cfset xtotaldisc1 = 0>
</cfif>

<cfif form.totaldisc2 neq "">
	<cfset xtotaldisc2 = form.totaldisc2>
<cfelse>
	<cfset xtotaldisc2 = 0>
</cfif>

<cfif form.totaldisc3 neq "">
	<cfset xtotaldisc3 = form.totaldisc3>
<cfelse>
	<cfset xtotaldisc3 = 0>
</cfif>

<cfif form.totalamtdisc neq "">
	<cfset xtotalamtdisc = form.totalamtdisc>
<cfelse>
	<cfset xtotalamtdisc = 0>
</cfif>

<cfif form.subtotal neq "">
	<cfset xsubtotal = form.subtotal>
<cfelse>
	<cfset xsubtotal = 0>
</cfif>

<cfif form.totaltax neq "">
	<cfset xtotaltax = form.totaltax>
<cfelse>
	<cfset xtotaltax = 0>
</cfif>

<cfif xtotaldisc1 neq 0 and xtotalamtdisc eq 0>
	<cfset disc1_bil = xsubtotal * xtotaldisc1 / 100>
	<cfset xnet_bil = xsubtotal - disc1_bil>
	<cfset disc2_bil = xnet_bil * xtotaldisc2 / 100>
	<cfset xnet_bil = xnet_bil - disc2_bil>
	<cfset disc3_bil = xnet_bil * xtotaldisc3 / 100>
	<cfset xnet_bil = xnet_bil - disc3_bil>
<cfelseif xtotalamtdisc neq 0 and xtotaldisc1 eq 0 and xtotaldisc2 eq 0 and xtotaldisc3 eq 0>	
	<cfset disc1_bil = xtotalamtdisc>
	<cfset xnet_bil = xsubtotal - disc1_bil>
	<cfset disc2_bil = 0>
	<cfset disc3_bil = 0>
<cfelse>
	<cfset disc1_bil = xsubtotal * xtotaldisc1 / 100>
	<cfset xnet_bil = xsubtotal - disc1_bil>
	<cfset disc2_bil = xnet_bil * xtotaldisc2 / 100>
	<cfset xnet_bil = xnet_bil - disc2_bil>
	<cfset disc3_bil = xnet_bil * xtotaldisc3 / 100>
	<cfset xnet_bil = xnet_bil - disc3_bil>
</cfif>

<cfset tax1_bil =  xnet_bil * xtotaltax / 100>
<cfset xgrand_bil = xsubtotal - disc1_bil + tax1_bil>
<cfset xinvgross = xsubtotal>
<cfset xdiscount1 = disc1_bil>
<cfset xdiscount2 = disc2_bil>
<cfset xdiscount3 = disc3_bil>
<cfset xdiscount = (disc1_bil + disc2_bil + disc3_bil)>
<cfset xnet = xnet_bil>
<cfset xtax = tax1_bil>
<cfset xgrand = xgrand_bil>		
	
<cfquery datasource="#dts#" name="updateartran">
	Update artran set 
	gross_bil ='#val(xsubtotal)#', 
	disc1_bil = '#val(disc1_bil)#', 
	disc2_bil = '#val(disc2_bil)#', 
	disc3_bil = '#val(disc3_bil)#', 
	tax1_bil='#val(tax1_bil)#',
	net_bil = '#val(xnet_bil)#', 
	grand_bil = '#val(xgrand_bil)#', 
	invgross = '#val(xinvgross)#',
	disp1 = '#val(xtotaldisc1)#', 
	disp2 = '#val(xtotaldisc2)#', 
	disp3 = '#val(xtotaldisc3)#', 
	discount1 = '#val(xdiscount1)#', 
	discount2 = '#val(xdiscount2)#', 
	discount3 = '#val(xdiscount3)#', 
	taxp1 = '#val(xtotaltax)#', 
	discount = '#val(xdiscount)#',
	net = '#val(xnet)#',
	tax = '#val(xtax)#',
	grand = '#val(xgrand)#',
	note = '#form.selecttax#',
    trdatetime=#createdatetime(year(now()),month(now()),day(now()),hour(now()),minute(now()),second(now()))#
	where refno = "#nexttranno#" and type = '#tran#'
</cfquery>

<!--- Add on 250808 --->
<cfif (tran NEQ "DO" and tran NEQ "PO" and tran NEQ "SO" and tran NEQ "QUO" and tran NEQ "SAM") and hmode eq "Edit">
	<cfquery datasource="#dts#" name="getartran">
		select * from artran
		where type='#tran#' and refno='#nexttranno#' <cfif tran eq 'TR'>and consignment='#form.consignment#'</cfif>
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
		TRDATETIME,USERID,CREATED_BY,UPDATED_BY,CREATED_ON,UPDATED_ON)
		values
		('#tran#','#nexttranno#','#getartran.custno#','#getartran.fperiod#','0000-00-00','#getartran.desp#','#getartran.despa#',
		<cfswitch expression="#tran#">
			<cfcase value="RC,CN,OAI" delimiters=",">
				'#xgrand#'
			</cfcase>
			<cfdefaultcase>
				'#xgrand#'
			</cfdefaultcase>
		</cfswitch>,
		<cfif getartran.trdatetime neq "" and getartran.trdatetime neq "0000-00-00">
			#createdatetime(year(getartran.trdatetime),month(getartran.trdatetime),day(getartran.trdatetime),hour(getartran.trdatetime),minute(getartran.trdatetime),second(getartran.trdatetime))#
		<cfelse>
			'0000-00-00'
		</cfif>,
		'#getartran.userid#','#getartran.created_by#','#getartran.updated_by#',
		<cfif getartran.created_on neq "">
			#createdatetime(year(getartran.created_on),month(getartran.created_on),day(getartran.created_on),hour(getartran.created_on),minute(getartran.created_on),second(getartran.created_on))#
		<cfelse>
			'0000-00-00'
		</cfif>,
		
		<cfif getartran.updated_on neq "" and getartran.updated_on neq "0000-00-00">        #createdatetime(year(getartran.updated_on),month(getartran.updated_on),day(getartran.updated_on),hour(getartran.updated_on),minute(getartran.updated_on),second(getartran.updated_on))#)
        <cfelse>
        '0000-00-00')
        </cfif>
	</cfquery>
</cfif>


<cfif lcase(hcomid) eq "migif_i" and tran eq "TR">
	<cflocation url="../../billformat/#dts#/consignmentnote.cfm?tran=#tran#&nexttranno=#nexttranno#">
<cfelseif lcase(hcomid) eq "avt_i" and (tran eq "OAR" or tran eq "OAI")>
	<cflocation url="../../billformat/#dts#/loanmenu.cfm?tran=#tran#&nexttranno=#nexttranno#">
<cfelseif lcase(hcomid) eq "valore_i">
	<cflocation url="../../billformat/#dts#/transaction3c.cfm?tran=#tran#&nexttranno=#nexttranno#">
<cfelseif isdefined('form.consignment')>
<cflocation url="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#nexttranno#&consignment=#form.consignment#">
<cfelse>
	<cflocation url="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#nexttranno#">
</cfif>