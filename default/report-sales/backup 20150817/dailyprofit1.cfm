


<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,agentlistuserid,ddllocation from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfif isdefined("form.fixcost")>

<cfquery name="update_fixed_cost" datasource="#dts#">
			update ictran,
			(select itemno,ucost from icitem) as cost 
			set ictran.it_cos=(ictran.qty*cost.ucost) 
			where ictran.itemno=cost.itemno and (ictran.toinv='' or ictran.toinv is null) and (ictran.void = '' or ictran.void is null) and (ictran.type='DO' or ictran.type='ISS' or ictran.type='INV' or ictran.type='CS' or ictran.type='DN' or ictran.type='CN')
			;
		</cfquery>
<cfelse>

<cfinvoke component="calculatecost3" method="calculate_moving_average_cost">
			<cfinvokeargument name="dts" value="#dts#">
			<cfinvokeargument name="itemfrom" value="">
			<cfinvokeargument name="itemto" value="">
		</cfinvoke>
</cfif>
    
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
			select sum(invgross<cfif isdefined('form.excludevisa') or isdefined('form.excludenett')>/10</cfif>) as invgross,sum(roundadj<cfif isdefined('form.excludevisa') or isdefined('form.excludenett')>/10</cfif>) as roundadj,sum(m_charge1<cfif isdefined('form.excludevisa') or isdefined('form.excludenett')>/10</cfif>) as m_charge1,sum(discount<cfif isdefined('form.excludevisa') or isdefined('form.excludenett')>/10</cfif>) as discount,sum((invgross-discount)<cfif isdefined('form.excludevisa') or isdefined('form.excludenett')>/10</cfif>) as net,sum(tax<cfif isdefined('form.excludevisa') or isdefined('form.excludenett')>/10</cfif>) as tax,sum(grand<cfif isdefined('form.excludevisa') or isdefined('form.excludenett')>/10</cfif>) as grand,sum(CS_PM_cash<cfif isdefined('form.excludevisa') or isdefined('form.excludenett')>/10</cfif>) as CS_PM_cash,sum(CS_PM_crcd)+sum(CS_PM_crc2) as CS_PM_crcd,sum(CS_PM_cheq) as CS_PM_cheq,sum(CS_PM_vouc) as CS_PM_vouc,sum(CS_PM_dbcd<cfif isdefined('form.excludevisa') or isdefined('form.excludenett')>/10</cfif>) as CS_PM_dbcd,sum(deposit) as deposit,sum(CS_PM_cashcd) as CS_PM_cashcd,sum(permitno) as permitno,sum(rem5) as rem5,count(refno) as billcount from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            
            <cfif isdefined('form.excludevisa')>        
            and (creditcardtype1 <> 'VISA')
            and (creditcardtype2 <> 'VISA')
            and (creditcardtype1 <> 'MASTER')
            and (creditcardtype2 <> 'MASTER')
            </cfif>
            <cfif isdefined('form.excludenett')>        
            and cs_pm_dbcd=0
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
        
        
        <cfquery name="gettotalcost" datasource="#dts#">
			select sum(it_cos<cfif isdefined('form.excludevisa') or isdefined('form.excludenett')>/10</cfif>) as ucost from ictran as a
            left join (
            select refno,type,creditcardtype1,creditcardtype2,cs_pm_dbcd from artran
            where 1=1
            <cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            )as b on a.type=b.type and a.refno=b.refno
            
			where b.type in ('CS','INV') and (void = '' or void is null)
            and amt>0
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            
            <cfif isdefined('form.excludevisa')>        
            and (b.creditcardtype1 <> 'VISA')
            and (b.creditcardtype2 <> 'VISA')
            and (b.creditcardtype1 <> 'MASTER')
            and (b.creditcardtype2 <> 'MASTER')
            </cfif>
            <cfif isdefined('form.excludenett')>        
            and b.cs_pm_dbcd=0
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
        
        
        <cfquery name="getvisa" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
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

            and (creditcardtype1='VISA')
            and (creditcardtype1 <> 'MASTER')
		</cfquery>
        
        <cfquery name="getvisa2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
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
			
            and (creditcardtype2='VISA')
            and (creditcardtype2 <> 'MASTER')
		</cfquery>
        
        <cfquery name="getmaster" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
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
			
            and (creditcardtype1='MASTER')
		</cfquery>
        
        <cfquery name="getmaster2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
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
			
            and (creditcardtype2='MASTER')
		</cfquery>
        
        <cfquery name="getamex" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
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
			
            and (creditcardtype1='AMEX')
		</cfquery>
        
        <cfquery name="getamex2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
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
			
            and (creditcardtype2='AMEX')
		</cfquery>
        
        <cfquery name="getcup" datasource="#dts#">
			select sum(CS_PM_crcd) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
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
			
            and (creditcardtype1='CUP')
		</cfquery>
        
        <cfquery name="getcup2" datasource="#dts#">
			select sum(CS_PM_crc2) as CS_PM_crcd from artran
			where type in ('CS','INV') and (void = '' or void is null)
            
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
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
		
            and (creditcardtype2='CUP')
		</cfquery>

		<cfoutput>
		<table width="100%" style="font-size:11px; border-width:thin;" cellpadding="0" cellspacing="0" >
        	<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#getgeneral.ddllocation#</strong></font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Daily Profit Report</strong></font></div></td>
			</tr>
            <tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Printing : #dateformat(now(),'DD/MM/YYYY')# #timeformat(now(),'HH:MM')#</font></div></td>
			</tr>
            <tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Casher : #huserid#</font></div></td>
			</tr>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">#form.datefrom# - #form.dateto#</font></div></td>
				</tr>
			</cfif>
			</table>
            </cfoutput>
            <cfoutput>
            <table width="100%">
            <tr>
            <td width="50%">
            <table width="100%" border="1">
            <tr>
            <th  width="30%">Description</th>
            <th  width="30%">Value</th>
            <th  width="30%">Number</th>
            </tr>
       
			<tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Gross Total :</font></td>
				<td ><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.invgross,',_.__')#</font></div></td>
                <td ><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.billcount,',_.__')#</font></div></td>
			</tr>
            
           
           
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Discount Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(gettotal.discount,',_.__')#</div></font></td>
                <td>&nbsp;</td>
			</tr>

            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Net Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(gettotal.net,',_.__')#</div></font></td>
                <td>&nbsp;</td>

			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Tax Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(gettotal.tax,',_.__')#</div></font></td>
                <td>&nbsp;</td>

			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Rounding Adjustment :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(gettotal.roundadj,',_.__')#</div></font></td>
                <td>&nbsp;</td>

			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Misc Charges Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(gettotal.M_charge1,',_.__')#</div></font></td>
                <td>&nbsp;</td>

			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Grand Total :</font></td>
				<td><font size="2" face="Times New Roman, Times, serif"><div align="right">#numberformat(gettotal.grand,',_.__')#</div></font></td>
                <td>&nbsp;</td>

			</tr>
            </table>
            </td>
            <td rowspan="2"  width="50%" valign="top">
            <table width="100%">
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
            <tr>
            	<th><font size="2" face="Times New Roman, Times, serif">Mode of Payment</font></th>
				<th><font size="2" face="Times New Roman, Times, serif">Amount</font></th>
                
			</tr>
            <tr>
				<td colspan="100%"><hr></td>
			</tr>
            
<cfif val(gettotal.grand) eq 0>
<cfset gettotal.grand=1>
</cfif>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Cash :</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_Cash,',_.__')#</font></div></td>
                
			</tr>
            <cfif not isdefined('form.excludenett')>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Nets :</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_dbcd,',_.__')#</font></div></td>
                
			</tr>
            </cfif>
            <cfif not isdefined('form.excludevisa')>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Visa</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getvisa.CS_PM_crcd)+val(getvisa2.CS_PM_crcd),',_.__')#</font></div></td>
                
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Master</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getmaster.CS_PM_crcd)+val(getmaster2.CS_PM_crcd),',_.__')#</font></div></td>
                
			</tr>
            </cfif>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Amex</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getamex.CS_PM_crcd)+val(getamex2.CS_PM_crcd),',_.__')#</font></div></td>
                
			</tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Cup</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcup.CS_PM_crcd)+val(getcup2.CS_PM_crcd),',_.__')#</font></div></td>
                
			</tr>
  
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Cheque :</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_cheq,',_.__')#</font></div></td>
              
			</tr>
            
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Voucher :</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotal.CS_PM_vouc,',_.__')#</font></div></td>
               
			</tr>
            <cfquery name="getdeposittotal" datasource="#dts#">
            select ifnull(sum(cs_pm_cash+cs_pm_crcd+cs_pm_crc2+cs_pm_cheq+cs_pm_dbcd+cs_pm_vouc),0) as deposit from deposit
            where 0=0
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            </cfquery>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Deposit Collected:</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getdeposittotal.deposit,',_.__')#</font></div></td>
               
			</tr>
            
            </table>
            </td>
            </tr>
            <tr>
            <td>
            <table width="100%" border="1">
            <tr>
            	<td  width="33%"><font size="2" face="Times New Roman, Times, serif">Cost Of Sales :</font></td>
				<td  width="33%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(gettotalcost.ucost,',_.__')#</font></div></td>
                <td>&nbsp;</td>
            </tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Profit before discount :</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(gettotal.invgross)-val(gettotalcost.ucost),',_.__')#</font></div></td>
                <td>&nbsp;</td>

            </tr>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Profit after discount :</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(gettotal.net)-val(gettotalcost.ucost),',_.__')#</font></div></td>
                <td>&nbsp;</td>

            </tr>
            <cfif val(gettotal.invgross) eq 0>
            <cfset gettotal.invgross=1>
            </cfif>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Margin before discount(%):</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(((val(gettotal.invgross)-val(gettotalcost.ucost)) / val(gettotal.invgross))*100,',_.__')#</font></div></td>
                <td>&nbsp;</td>

            </tr>
            <cfif val(gettotal.net) eq 0>
            <cfset gettotal.net = 1>
            </cfif>
            <tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Margin after discount(%):</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(((val(gettotal.net)-val(gettotalcost.ucost)) / val(gettotal.net))*100,',_.__')#</font></div></td>
                <td>&nbsp;</td>

            </tr>
            <tr>
            <cfif val(gettotal.billcount) eq 0>
            <cfset gettotal.billcount=1>
            </cfif>
            	<td><font size="2" face="Times New Roman, Times, serif">Average Sales:</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(gettotal.net)/val(gettotal.billcount),'.__')#</font></div></td>
                <td>&nbsp;</td>

            </tr>
            </table>
            </td>
            </tr>
            </table>
            </cfoutput>
		
		<br>
		<br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>
		</html>
