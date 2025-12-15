<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,agentlistuserid,site from gsetup
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
			select sum(invgross) as invgross,sum(discount) as discount,sum(net) as net,sum(tax) as tax,sum(grand) as grand,sum(CS_PM_cash) as CS_PM_cash,sum(CS_PM_crcd)+sum(CS_PM_crc2) as CS_PM_crcd,sum(CS_PM_cheq) as CS_PM_cheq,sum(CS_PM_vouc) as CS_PM_vouc,sum(CS_PM_dbcd) as CS_PM_dbcd,sum(CS_PM_cashcd) as CS_PM_cashcd from artran
			where type='CS' and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>

		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Cash Sales Summary Report</strong></font></div></td>
			</tr>
            <tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Site : #getgeneral.site#</font></div></td>
			</tr>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
			</tr>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
				</tr>
			</cfif>
			
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<tr>
				  <td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
				</tr>
			</cfif>
			<tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
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
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Discount Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.discount,',_.__')#</font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Net Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.net,',_.__')#</font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Tax Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.tax,',_.__')#</font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Grand Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.grand,',_.__')#</font></td>
			</tr>
            
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td colspan="100%"><br></td>
			</tr>
            <tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif"><strong>Collection Record</strong></font></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Mode of Payment</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">Amount</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">%</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">No. of Transaction</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">%</font></td>
			</tr>
            <tr>
				<td colspan="100%"><hr></td>
			</tr>
            
            <cfquery name="gettotalrecord" datasource="#dts#">
			select refno from artran
			where type='CS' and (void = '' or void is null)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getcashrecord" datasource="#dts#">
			select refno from artran
			where type='CS' and (void = '' or void is null) and CS_PM_cash !=0
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getdbcdrecord" datasource="#dts#">
			select refno from artran
			where type='CS' and (void = '' or void is null) and CS_PM_dbcd !=0
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getcashcdrecord" datasource="#dts#">
			select refno from artran
			where type='CS' and (void = '' or void is null) and CS_PM_cashcd !=0
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getcrcdrecord" datasource="#dts#">
			select refno from artran
			where type='CS' and (void = '' or void is null) and (CS_PM_crcd !=0 or CS_PM_crc2 !=0)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getcheqrecord" datasource="#dts#">
			select refno from artran
			where type='CS' and (void = '' or void is null) and CS_PM_cheq !=0
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getvoucrecord" datasource="#dts#">
			select refno from artran
			where type='CS' and (void = '' or void is null) and CS_PM_vouc !=0
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>

<cfif val(gettotal.grand) eq 0>
<cfset gettotal.grand=1>
</cfif>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Cash :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_Cash,',_.__')#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#numberformat((val(gettotal.cs_pm_cash)/val(gettotal.grand))*100,',_.__')#%</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#getcashrecord.recordcount#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"><cfif gettotalrecord.recordcount eq 0><cfelse>#numberformat((val(getcashrecord.recordcount)/val(gettotalrecord.recordcount))*100,',_.__')#</cfif></font></td>
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Net :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_dbcd,',_.__')#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#numberformat((val(gettotal.cs_pm_cash)/val(gettotal.grand))*100,',_.__')#%</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#getdbcdrecord.recordcount#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"><cfif gettotalrecord.recordcount eq 0><cfelse>#numberformat((val(getdbcdrecord.recordcount)/val(gettotalrecord.recordcount))*100,',_.__')#</cfif></font></td>
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Cash Card :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_Cashcd,',_.__')#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#numberformat((val(gettotal.cs_pm_cash)/val(gettotal.grand))*100,',_.__')#%</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#getcashcdrecord.recordcount#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"><cfif gettotalrecord.recordcount eq 0><cfelse>#numberformat((val(getcashcdrecord.recordcount)/val(gettotalrecord.recordcount))*100,',_.__')#</cfif></font></td>
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Credit Card :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_crcd,',_.__')#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#numberformat((val(gettotal.CS_PM_crcd)/val(gettotal.grand))*100,',_.__')#%</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#getcrcdrecord.recordcount#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"><cfif gettotalrecord.recordcount eq 0><cfelse>#numberformat((val(getcrcdrecord.recordcount)/val(gettotalrecord.recordcount))*100,',_.__')#</cfif></font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Cheque :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_cheq,',_.__')#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#numberformat((val(gettotal.CS_PM_cheq)/val(gettotal.grand))*100,',_.__')#%</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#getcheqrecord.recordcount#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"><cfif gettotalrecord.recordcount eq 0><cfelse>#numberformat((val(getcheqrecord.recordcount)/val(gettotalrecord.recordcount))*100,',_.__')#</cfif></font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Voucher :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_vouc,',_.__')#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#numberformat((val(gettotal.CS_PM_vouc)/val(gettotal.grand))*100,',_.__')#%</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#getvoucrecord.recordcount#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"><cfif gettotalrecord.recordcount eq 0><cfelse>#numberformat((val(getvoucrecord.recordcount)/val(gettotalrecord.recordcount))*100,',_.__')#</cfif></font></td>
			</tr>
            <tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td colspan="100%"><br></td>
			</tr>
            <tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif"><strong>Credit Card Record</strong></font></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
            <cfquery name="getvisa" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type='CS' and (void = '' or void is null) and (rem10='VISA')
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getmaster" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type='CS' and (void = '' or void is null) and (rem10='MASTER')
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getamex" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type='CS' and (void = '' or void is null) and (rem10='AMEX')
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getjcb" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type='CS' and (void = '' or void is null) and (rem10='JCB')
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getdiners" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type='CS' and (void = '' or void is null) and (rem10='DINERS')
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        
        <cfquery name="getvisa2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type='CS' and (void = '' or void is null) and (rem8='VISA')
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getmaster2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type='CS' and (void = '' or void is null) and (rem8='MASTER')
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getamex2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type='CS' and (void = '' or void is null) and (rem8='AMEX')
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getjcb2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type='CS' and (void = '' or void is null) and (rem8='JCB')
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
        
        <cfquery name="getdiners2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type='CS' and (void = '' or void is null) and (rem8='DINERS')
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
			
		</cfquery>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Type</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">Total</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">Charges</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">Usage%</font></td>
			</tr>
            <tr>
				<td colspan="100%"><hr></td>
			</tr>
            <cfif val(gettotal.CS_PM_crcd) eq 0>
            <cfset gettotal.CS_PM_crcd=1>
            </cfif>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Visa</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getvisa.CS_PM_crcd)+val(getvisa2.CS_PM_crcd),',_.__')#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"></font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#numberformat(((val(getvisa.CS_PM_crcd)+val(getvisa2.CS_PM_crcd))/val(gettotal.CS_PM_crcd))*100,',_.__')#%</font></td>
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Master</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getmaster.CS_PM_crcd)+val(getmaster2.CS_PM_crcd),',_.__')#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"></font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#numberformat(((val(getmaster.CS_PM_crcd)+val(getmaster2.CS_PM_crcd))/val(gettotal.CS_PM_crcd))*100,',_.__')#%</font></td>
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Amex</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getamex.CS_PM_crcd)+val(getamex2.CS_PM_crcd),',_.__')#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"></font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#numberformat(((val(getamex.CS_PM_crcd)+val(getamex2.CS_PM_crcd))/val(gettotal.CS_PM_crcd))*100,',_.__')#%</font></td>
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">JCB</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getjcb.CS_PM_crcd)+val(getjcb2.CS_PM_crcd),',_.__')#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"></font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#numberformat(((val(getjcb.CS_PM_crcd)+val(getjcb2.CS_PM_crcd))/val(gettotal.CS_PM_crcd))*100,',_.__')#%</font></td>
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">DINERS</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getdiners.CS_PM_crcd)+val(getdiners2.CS_PM_crcd),',_.__')#</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"></font></td>
                <td><font size="2" face="Times New Roman, Times, serif">#numberformat(((val(getdiners.CS_PM_crcd)+val(getdiners2.CS_PM_crcd))/val(gettotal.CS_PM_crcd))*100,',_.__')#%</font></td>
			</tr>

		  </table>
		</cfoutput>

		
		<br>
		<br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>
		</html>