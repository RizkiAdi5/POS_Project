<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,agentlistuserid from gsetup
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
		<title>Cash Sales Report By User</title>
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

		<cfquery name="getagent" datasource="#dts#">
			select agenno from artran
			where type in ('CS','INV') and (void = '' or void is null)
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
			group by agenno order by agenno
		</cfquery>

		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Sales To Date By Sales Person</strong></font></div></td>
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
            
            <cfif form.locfrom neq "" and form.locto neq "">
				<tr>
				  <td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Location: #form.locfrom# - #form.locto#</font></div></td>
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
            	<td><font size="2" face="Times New Roman, Times, serif">Sales Person</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">Number Of Sales</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"><div align="right">Unit Sold</div></font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Value At Cost</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Retail Value</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Archive Date</font></div></td>
				
				
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			
            <cfset totalsales = 0>
            <cfset totalqty = 0>
           	<cfset totalcost = 0>
            <cfset totalamt = 0>

			<cfloop query="getagent">
            	<cfset subsales = 0>
				<cfset subqty = 0>
                <cfset subcost = 0>
                <cfset subamt = 0>

				<td><font size="2" face="Times New Roman, Times, serif"><strong><u>#getagent.agenno#</u></strong></font></td>

				<cfquery name="getdata" datasource="#dts#">
					select sum(qty) as qty,sum(amt) as amt,sum(it_cos) as cost,wos_date from ictran as a
                    left join (select agenno,type,refno from artran)as b on a.refno=b.refno and a.type=b.type
					where a.type in ('CS','INV') and (a.void = '' or a.void is null)
                    and b.agenno ='#getagent.agenno#'
                    <cfif form.locfrom neq "" and form.locto neq "">
                    and a.refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
                    </cfif>
                    <cfif form.userfrom neq "" and form.userto neq "">
                    and a.userid >='#form.userfrom#' and a.userid <= '#form.userto#'
                    </cfif>
                    
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
					group by a.wos_date order by a.wos_date
				</cfquery>

				<cfloop query="getdata">
             		<cfquery name="gettotalsales" datasource="#dts#">
                    	select count(refno) as countsales from artran where type in ('CS','INV') and (void = '' or void is null)
                    and agenno ='#getagent.agenno#'
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
					and wos_date ='#dateformat(getdata.wos_date,"yyyy-mm-dd")#'
                    
                    </cfquery>
                
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
                    <td></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#gettotalsales.countsales#</font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getdata.qty#</font></div></td>
						<td><div align="right">#numberformat(val(getdata.cost),',_.__')#</div></td>
						<td><div align="right">#numberformat(val(getdata.amt),',_.__')#</div></td>
						<td><div align="right">#dateformat(getdata.wos_date,'dd/mm/yyyy')#</div></td>
                                
						<cfset totalsales = totalsales+gettotalsales.countsales>
                        <cfset totalqty = totalqty+getdata.qty>
                        <cfset totalcost = totalcost+getdata.cost>
                        <cfset totalamt = totalamt+getdata.amt>
                        
                        <cfset subsales = subsales+gettotalsales.countsales>
                        <cfset subqty = subqty+getdata.qty>
                        <cfset subcost = subcost+getdata.cost>
                        <cfset subamt = subamt+getdata.amt>

					</tr>
				</cfloop>
				<tr>
					<td colspan="100%"><hr></td>
				</tr>
				<tr >
                    <td></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#subsales#</font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#subqty#</font></div></td>
						<td><div align="right">#numberformat(val(subcost),',_.__')#</div></td>
						<td><div align="right">#numberformat(val(subamt),',_.__')#</div></td>
					</tr>
				<tr><td><br></td></tr>
			</cfloop>
			<cfflush>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr >
                    <td></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#totalsales#</font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#totalqty#</font></div></td>
						<td><div align="right">#numberformat(val(totalcost),',_.__')#</div></td>
						<td><div align="right">#numberformat(val(totalamt),',_.__')#</div></td>
					</tr>
		  </table>
		</cfoutput>

		<cfif getagent.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
		</cfif>

		<br>
		<br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>
		</html>
