


<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,agentlistuserid,ddllocation from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>


    
<cfif isdefined("form.datefrom") and isdefined("form.dateto")>
	<cfset dd = dateformat(form.datefrom, "DD")>
	<cfif dd greater than '12'>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYMMDD")>
	<cfelse>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYDDMM")>
	</cfif>

	<cfset dd = dateformat(form.dateto, "DD")>
	<cfif dd greater than '12'>
		<cfset ndateto = dateformat(form.dateto,"YYYYMMDD")>
	<cfelse>
		<cfset ndateto = dateformat(form.dateto,"YYYYDDMM")>
	</cfif>
</cfif>
    
  
<cfset grouptotal=0>
<cfset catetotal=0>
<cfset itemtotal=0>
<cfset billtotal=0>
<cfset agenttotal=0>

		<html>
		<head>
		<title>Cash Sales Summary Report</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
		<style type="text/css" media="print">
			.noprint { display: none; }
		</style>
		</head>

		<body>
		<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
		<cfset stDecl_UPrice = ",___.">

		<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		  <cfset stDecl_UPrice = stDecl_UPrice & "_">
		</cfloop>

		<cfquery name="gettotal" datasource="#dts#">
			select sum(invgross) as invgross,sum(roundadj) as roundadj,sum(m_charge1) as m_charge1,sum(discount) as discount,sum(net) as net,sum(tax) as tax,sum(grand) as grand,sum(CS_PM_cash) as CS_PM_cash,sum(CS_PM_crcd)+sum(CS_PM_crc2) as CS_PM_crcd,sum(CS_PM_cheq) as CS_PM_cheq,sum(CS_PM_vouc) as CS_PM_vouc,sum(CS_PM_dbcd) as CS_PM_dbcd,sum(CS_PM_cashcd) as CS_PM_cashcd,sum(permitno) as permitno,sum(rem5) as rem5,sum(deposit) as deposit from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
		</cfquery>
        
        <cfquery name="getvisa" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            
          
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
            and (creditcardtype1='VISA')
		</cfquery>
        
        <cfquery name="getvisa2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
          
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
            and (creditcardtype2='VISA')
		</cfquery>
        
        <cfquery name="getmaster" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
           
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
            and (creditcardtype1='MASTER')
		</cfquery>
        
        <cfquery name="getmaster2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
           
            
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
            and (creditcardtype2='MASTER')
		</cfquery>
        
        <cfquery name="getamex" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>

            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
            and (creditcardtype1='AMEX')
		</cfquery>
        
        <cfquery name="getamex2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
           
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
            and (creditcardtype2='AMEX')
		</cfquery>
        
        <cfquery name="getcup" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>

            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
            and (creditcardtype1='CUP')
		</cfquery>
        
        <cfquery name="getcup2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
           
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
            and (creditcardtype2='CUP')
		</cfquery>

		<cfoutput>
		<table width="230px" style="font-size:11px; border-width:thin;" cellpadding="0" cellspacing="0" >
        	<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#getgeneral.ddllocation#</strong></font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Daily Checkout Report</strong></font></div></td>
			</tr>
            <tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Printing : #dateformat(now(),'DD/MM/YYYY')# #timeformat(now(),'HH:MM')#</font></div></td>
			</tr>
            <tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Counter : #getgeneral.ddllocation#</font></div></td>
			</tr>
            <tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Casher : #huserid#</font></div></td>
			</tr>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">#form.datefrom# - #form.dateto#</font></div></td>
				</tr>
			</cfif>
			
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
            
            <tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif"><strong>Sales Record</strong></font></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
            
			<tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Gross Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.invgross,',_.__')#</font></td>
			</tr>
            <cfif lcase(hcomid) eq "tcds_i">

            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Voucher Discount :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(val(gettotal.permitno),',_.__')#</font></td>
              
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">VIP $ Discount :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(val(gettotal.rem5),',_.__')#</font></td>
              
			</tr>
           	<cfelse>
           
           
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Discount Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.discount,',_.__')#</font></td>
			</tr>
            </cfif>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Net Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.net,',_.__')#</font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Tax Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.tax,',_.__')#</font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Rounding Adjustment :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.roundadj,',_.__')#</font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Misc Charges Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.M_charge1,',_.__')#</font></td>
			</tr>
            <cfif lcase(hcomid) eq "tcds_i">
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Deposit Amount :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.deposit,',_.__')#</font></td>
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Grand Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.grand-gettotal.deposit,',_.__')#</font></td>
			</tr>
            <cfelse>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Grand Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.grand,',_.__')#</font></td>
			</tr>
            </cfif>
            
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td colspan="100%"><br></td>
			</tr>
            <tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif"><strong>Cash Sales Detail</strong></font></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Mode of Payment</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">Amount</font></td>
                
			</tr>
            <tr>
				<td colspan="100%"><hr></td>
			</tr>
            
<cfif val(gettotal.grand) eq 0>
<cfset gettotal.grand=1>
</cfif>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Cash :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_Cash,',_.__')#</font></td>
                
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Nets :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_dbcd,',_.__')#</font></td>
                
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif"><cfif lcase(hcomid) eq "kjpe_i" or lcase(hcomid) eq "belco_i">Visa<cfelse>Cash Card</cfif> :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif"><cfif lcase(hcomid) eq "kjpe_i" or lcase(hcomid) eq "belco_i">#numberformat(val(getvisa.CS_PM_crcd)+val(getvisa2.CS_PM_crcd),',_.__')#<cfelse>#numberformat(gettotal.CS_PM_Cashcd,',_.__')#</cfif></font></td>
                
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif"><cfif lcase(hcomid) eq "kjpe_i" or lcase(hcomid) eq "belco_i">Master<cfelse>Credit Card</cfif> :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif"><cfif lcase(hcomid) eq "kjpe_i" or lcase(hcomid) eq "belco_i">#numberformat(val(getmaster.CS_PM_crcd)+val(getmaster2.CS_PM_crcd),',_.__')#<cfelse>#numberformat(gettotal.CS_PM_crcd,',_.__')#</cfif></font></td>
               
			</tr>
            <cfif lcase(hcomid) neq "tcds_i">
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif"><cfif lcase(hcomid) eq "kjpe_i" or lcase(hcomid) eq "belco_i">Amex<cfelse>Cheque</cfif> :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif"><cfif lcase(hcomid) eq "kjpe_i" or lcase(hcomid) eq "belco_i">#numberformat(val(getamex.CS_PM_crcd)+val(getamex2.CS_PM_crcd),',_.__')#<cfelse>#numberformat(gettotal.CS_PM_cheq,',_.__')#</cfif></font></td>
              
			</tr>
            <cfif lcase(hcomid) eq "belco_i" or lcase(hcomid) eq "kjpe_i">
            <cfquery name="getvouchertype" datasource="#dts#">
            	select sum(cs_pm_vouc) as totalvoucamt,rem13 from artran
                where type in ('CS','INV') and (void = '' or void is null)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
           
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
            and cs_pm_vouc <> 0
            group by rem13
            </cfquery>
            
            <cfloop query="getvouchertype">
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">#getvouchertype.rem13# :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(getvouchertype.totalvoucamt,',_.__')#</font></td>
               
			</tr>
            </cfloop>
            
            <cfelse>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Voucher :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_vouc,',_.__')#</font></td>
               
			</tr>
            </cfif>
            </cfif>
            <tr>
				<td colspan="100%"><hr></td>
			</tr>
            <cfif lcase(hcomid) neq "kjpe_i"  and lcase(hcomid) neq "belco_i">
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Total Payment:</font></td>
				<td><font size="2" face="Times New Roman, Times, serif"><cfif lcase(hcomid) eq "tcds_i">#numberformat(val(gettotal.CS_PM_Cash)+val(gettotal.CS_PM_vouc)+val(gettotal.CS_PM_dbcd)+val(gettotal.CS_PM_crcd),',_.__')#<cfelse>#numberformat(val(gettotal.CS_PM_Cash)+val(gettotal.CS_PM_vouc)+val(gettotal.CS_PM_crcd)+val(gettotal.CS_PM_dbcd)+val(gettotal.CS_PM_cheq),',_.__')#</cfif></font></td>
                
			</tr>
            </cfif>
            
           <tr>
				<td colspan="100%"><br></td>
			</tr>
           
              <cfoutput>
               
            <tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif"><strong>Credit Card Detail</strong></font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Card Details</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">Amount</font></td>
                
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Visa</font></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getvisa.CS_PM_crcd)+val(getvisa2.CS_PM_crcd),',_.__')#</font></div></td>
                
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Master</font></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getmaster.CS_PM_crcd)+val(getmaster2.CS_PM_crcd),',_.__')#</font></div></td>
                
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Amex</font></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getamex.CS_PM_crcd)+val(getamex2.CS_PM_crcd),',_.__')#</font></div></td>
                
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Cup</font></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcup.CS_PM_crcd)+val(getcup2.CS_PM_crcd),',_.__')#</font></div></td>
                
			</tr>
            </cfoutput>
            <tr>
				<td colspan="100%"><hr></td>
			</tr>
            
			<tr>
				<td colspan="100%"><br></td>
			</tr>
          
            
            <cfquery name="getcashsalesno" datasource="#dts#">
			select refno from artran
			where type='CS' and (void = '' or void is null)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
          
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            <cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
			
		</cfquery>
        
        <cfquery name="getinvoiceno" datasource="#dts#">
			select refno from artran
			where type='INV' and (void = '' or void is null)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
           
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            <cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
			
		</cfquery>
        
        <cfquery name="getSOno" datasource="#dts#">
			select refno from artran
			where type='SO' and (void = '' or void is null)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
           
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            <cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
			
		</cfquery>
        
        <cfquery name="getvoidno" datasource="#dts#">
			select refno from artran
			where type in ('INV','CS') and void='Y'
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            <cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
			
		</cfquery>
            
            <cfquery name="getdeposit" datasource="#dts#">
			select refno from artran
			where type in ('CS','INV') and (void = '' or void is null)
            and deposit<>0
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
           
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            <cfif form.counter neq "">
			and counter ='#form.counter#'
			</cfif>
			
		</cfquery>
            
            <tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif"><strong>Bills Record</strong></font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">No of Cash Sales :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(getcashsalesno.recordcount,',_.__')#</font></td>
                
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">No of VOID :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(getvoidno.recordcount,',_.__')#</font></td>
                
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">No of Invoice :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(getinvoiceno.recordcount,',_.__')#</font></td>
                
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">No of Sales Order :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(getSOno.recordcount,',_.__')#</font></td>
                
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">No of Deposit :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(getdeposit.recordcount,',_.__')#</font></td>
                
			</tr>
            
            
			 <tr>
				<td colspan="100%"><br></td>
			</tr>
            
            <cfquery name="getopening" datasource="#dts#">
			select openning from dailycounter
			where type='Opening'
			<cfif form.counter neq "">
			and counterid ='#form.counter#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date = '#ndatefrom#'
            </cfif>
			</cfquery>
            
            <cfquery name="getcashin" datasource="#dts#">
			select sum(openning) as cashin from dailycounter
			where type='cashin'
			<cfif form.counter neq "">
			and counterid ='#form.counter#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date = '#ndatefrom#'
            </cfif>
			</cfquery>
            
            <cfquery name="getcashout" datasource="#dts#">
			select sum(openning) as cashout from dailycounter
			where type='cashout'
			<cfif form.counter neq "">
			and counterid ='#form.counter#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date = '#ndatefrom#'
            </cfif>
			</cfquery>
            
        	<tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif"><strong>Cash In Drawer</strong></font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Opening</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(getopening.openning,',_.__')#</font></td>
                
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Total Cash In</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(getcashin.cashin,',_.__')#</font></td>
                
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Total Cash Out</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">-#numberformat(getcashout.cashout,',_.__')#</font></td>
                
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Collection</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_Cash,',_.__')#</font></td>
                
			</tr>
            
            <tr>
            	<td colspan="2"><hr></td>
				
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif"><strong>Total :</strong></font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getopening.openning)+val(getcashin.cashin)+val(gettotal.CS_PM_Cash)-val(getcashout.cashout),',_.__')#</font></td>
                
			</tr>
           
            
            
             <cfquery name="getcategorytran" datasource="#dts#">
			select sum(amt) as amt,category from ictran
			where type in ('CS','INV') and (void = '' or void is null)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            <cfif form.counter neq "">
			and refno in(select refno from artran where counter='#form.counter#' and (type='CS' or type='INV'))
			</cfif>
            
			group by category
		</cfquery>
		<tr>
				<td colspan="100%"><br></td>
			</tr>
        <tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif"><strong>Transaction Detail : Category</strong></font></td>
			</tr>
            <cfloop query="getcategorytran">
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">#getcategorytran.category#</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(getcategorytran.amt,',_.__')#</font></td>
                
			</tr>
            <cfset catetotal=catetotal+getcategorytran.amt>

            </cfloop>
            <tr>
				<td colspan="100%"><hr></td>
			</tr>
            <cfif lcase(hcomid) neq "kjpe_i"  and lcase(hcomid) neq "belco_i">
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(catetotal,',_.__')#</font></td>
                
			</tr>
            </cfif>
            
            <cfquery name="getgrouptran" datasource="#dts#">
			select sum(amt) as amt,wos_group from ictran
			where type in ('CS','INV') and (void = '' or void is null)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
           
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            <cfif form.counter neq "">
			and refno in(select refno from artran where counter='#form.counter#' and (type='CS' or type='INV'))
			</cfif>
			group by wos_group
		</cfquery>
		<tr>
				<td colspan="100%"><br></td>
			</tr>
        <tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif"><strong>Transaction Detail : Group</strong></font></td>
			</tr>
            <cfloop query="getgrouptran">
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">#getgrouptran.wos_group#</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(getgrouptran.amt,',_.__')#</font></td>
                
			</tr>
			<cfset grouptotal=grouptotal+getgrouptran.amt>

            </cfloop>
            <tr>
				<td colspan="100%"><hr></td>
			</tr>
            <cfif lcase(hcomid) neq "kjpe_i" and lcase(hcomid) neq "belco_i">
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(grouptotal,',_.__')#</font></td>
                
			</tr>
            </cfif>
           
		  </table>
		</cfoutput>

		
		<br>
		<br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>
		</html>
