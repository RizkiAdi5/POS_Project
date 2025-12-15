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
			select wos_date,count(refno) as countsales,sum(invgross) as gross,sum(discount) as discount,sum(grand) as grand,sum(invgross-discount) as net,sum(tax) as tax from artran
			where type='CS' and (void = '' or void is null)
            <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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

			and fperiod = '#form.periodfrom#'

			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by wos_date order by wos_date
		</cfquery>

		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Cash Up Log</strong></font></div></td>
			</tr>

			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom#</font></div></td>
			</tr>
		
			
		
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
            	<td><font size="2" face="Times New Roman, Times, serif">Date</font></td>
                <td><font size="2" face="Times New Roman, Times, serif">Sales Qty</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">Number Of Sales</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"><div align="right">Gross Sales</div></font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Discount</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Net Sales</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Tax</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Grand</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Cost of Sales</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Pr bef disc</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Marg bef disc</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Pr aft disc</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Marg aft disc</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Avg Sales</font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			
            <cfset totalsales = 0>
            <cfset totalgross = 0>
           	<cfset totaldiscount = 0>
            <cfset totalnet = 0>
            <cfset totaltax = 0>
            <cfset totalgrand = 0>
             <cfset totalcost = 0>
            <cfset totalprofit1 = 0>
            <cfset totalprofit2 = 0>
            
            <cfset totalprofit3 = 0>
            <cfset totalprofit4 = 0>
            <cfset totalavg = 0>
            <cfset totalqty = 0>
            
			<cfif getagent.recordcount neq 0>
			<cfloop query="getagent">
            
            <cfquery name="gettotalcost" datasource="#dts#">
			select sum(it_cos) as ucost,sum(qty) as qty from ictran
			where type in ('CS','INV') and (void = '' or void is null)
            and amt>0
            and wos_date='#dateformat(getagent.wos_date,"yyyy-mm-dd")#'
			</cfquery>
            <cfif val(gettotalcost.ucost) eq 0>
            <cfset gettotalcost.ucost=1>
            </cfif>

					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
 						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getagent.wos_date,'dd/mm/yyyy')#</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#gettotalcost.qty#</font></div></td>
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getagent.countsales#</font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getagent.gross),',_.__')#</font></div></td>
						<td><div align="right">#numberformat(val(getagent.discount),',_.__')#</div></td>
						<td><div align="right">#numberformat(val(getagent.net),',_.__')#</div></td>
						<td><div align="right">#numberformat(val(getagent.tax),',_.__')#</div></td>
                        <td><div align="right">#numberformat(val(getagent.grand),',_.__')#</div></td>    
                        <td><div align="right">#numberformat(val(gettotalcost.ucost),',_.__')#</div></td> 
                        <td><div align="right">#numberformat(val(getagent.gross)-val(gettotalcost.ucost),',_.__')#</div></td> 
                        <td><div align="right"><cfif val(getagent.gross) eq 0>0.00<cfelse>#numberformat(((val(getagent.gross)-val(gettotalcost.ucost)) / val(getagent.gross))*100,',_.__')#</cfif></div></td> 
                        <td><div align="right">#numberformat(val(getagent.net)-val(gettotalcost.ucost),',_.__')#</div></td> 
                        <td><div align="right"><cfif val(getagent.net) eq 0>0.00<cfelse>#numberformat(((val(getagent.net)-val(gettotalcost.ucost)) / val(getagent.net))*100,',_.__')#</cfif></div></td> 
                        <td><div align="right">#numberformat(val(getagent.net)/val(getagent.countsales),'.__')#</div></td> 
                         
                         <cfset totalqty = totalqty+gettotalcost.qty>
                        <cfset totalcost = totalcost+val(gettotalcost.ucost)>
						<cfset totalsales = totalsales+getagent.countsales>
						<cfset totalgross = totalgross+getagent.gross>
                        <cfset totaldiscount = totaldiscount+getagent.discount>
                        <cfset totalnet = totalnet+getagent.net>
                        <cfset totaltax = totaltax+getagent.tax>
                        <cfset totalgrand = totalgrand+getagent.grand>
                        <cfset totalprofit1 = totalprofit1+val(getagent.gross)-val(gettotalcost.ucost)>
                        <cfset totalprofit2 = totalprofit2+val(getagent.net)-val(gettotalcost.ucost)>
						<cfif val(getagent.gross) eq 0>
						<cfset totalprofit3 = totalprofit3>
                        <cfelse>
						<cfset totalprofit3 = totalprofit3+(((val(getagent.gross)-val(gettotalcost.ucost)) / val(getagent.gross))*100)>
                        </cfif>
						<cfif val(getagent.net) eq 0>
						<cfset totalprofit4 = totalprofit4>
                        <cfelse>
                        <cfset totalprofit4 = totalprofit4+(((val(getagent.net)-val(gettotalcost.ucost)) / val(getagent.net))*100)>
                        
                        </cfif>
                        <cfset totalavg = totalavg+val(getagent.net)/val(getagent.countsales)>
					</tr>
				</cfloop>
			<cfflush>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
            
 						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Total :</strong></font></div></td>
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>#totalqty#</strong></font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>#totalsales#</strong></font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(val(totalgross),',_.__')#</strong></font></div></td>
						<td><div align="right"><strong>#numberformat(val(totaldiscount),',_.__')#</strong></div></td>
						<td><div align="right"><strong>#numberformat(val(totalnet),',_.__')#</strong></div></td>
						<td><div align="right"><strong>#numberformat(val(totaltax),',_.__')#</strong></div></td>
                        <td><div align="right"><strong>#numberformat(val(totalgrand),',_.__')#</strong></div></td>    
                        <td><div align="right"><strong>#numberformat(val(totalcost),',_.__')#</strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(totalprofit1),',_.__')#</strong></div></td> 
                        <td><div align="right"></div></td> 
                        <td><div align="right"><strong>#numberformat(val(totalprofit2),',_.__')#</strong></div></td> 
                        <td><div align="right"></div></td> 
                        <td><div align="right"></div></td> 
			
					</tr>
             <tr>
            
 						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Average :</strong></font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalqty/getagent.recordcount,'0')#</strong></font></div></td>
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalsales/getagent.recordcount,'0')#</strong></font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(val(totalgross)/getagent.recordcount,',_.__')#</strong></font></div></td>
						<td><div align="right"><strong>#numberformat(val(totaldiscount)/getagent.recordcount,',_.__')#</strong></div></td>
						<td><div align="right"><strong>#numberformat(val(totalnet)/getagent.recordcount,',_.__')#</strong></div></td>
						<td><div align="right"><strong>#numberformat(val(totaltax)/getagent.recordcount,',_.__')#</strong></div></td>
                        <td><div align="right"><strong>#numberformat(val(totalgrand)/getagent.recordcount,',_.__')#</strong></div></td>    
                        <td><div align="right"><strong>#numberformat(val(totalcost)/getagent.recordcount,',_.__')#</strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(totalprofit1)/getagent.recordcount,',_.__')#</strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(totalprofit3)/getagent.recordcount,',_.__')#</strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(totalprofit2)/getagent.recordcount,',_.__')#</strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(totalprofit4)/getagent.recordcount,',_.__')#</strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(totalavg)/getagent.recordcount,',_.__')#</strong></div></td> 
			
					</tr>
                    <cfquery name="highest" datasource="#dts#">
                        select wos_date,count(refno) as countsales,sum(invgross) as gross,sum(discount) as discount,sum(grand) as grand,sum(invgross-discount) as net,sum(tax) as tax from artran
                        where type='CS' and (void = '' or void is null)
                        <cfif form.locfrom neq "" and form.locto neq "">
                        and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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

                        and fperiod = '#form.periodfrom#'
						<cfif form.datefrom neq "" and form.dateto neq "">
                        and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
                        <cfelse>
                        and wos_date > #getgeneral.lastaccyear#
                        </cfif>
                       
                        and wos_date > #getgeneral.lastaccyear#

                        group by wos_date order by grand desc limit 1
                    </cfquery>
                    
                     <cfquery name="gethighesttotalcost" datasource="#dts#">
                        select sum(it_cos) as ucost,sum(qty) as qty from ictran
                        where type in ('CS','INV') and (void = '' or void is null)
                        and wos_date='#dateformat(highest.wos_date,"yyyy-mm-dd")#'
                        </cfquery>
                    
                     <tr >
 						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Highest</strong></font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>#gethighesttotalcost.qty#</strong></font></div></td>
                        
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>#highest.countsales#</strong></font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(val(highest.gross),',_.__')#</strong></font></div></td>
						<td><div align="right"><strong>#numberformat(val(highest.discount),',_.__')#</strong></div></td>
						<td><div align="right"><strong>#numberformat(val(highest.net),',_.__')#</strong></div></td>
						<td><div align="right"><strong>#numberformat(val(highest.tax),',_.__')#</strong></div></td>
                        <td><div align="right"><strong>#numberformat(val(highest.grand),',_.__')#</strong></div></td>    
                        <td><div align="right"><strong>#numberformat(val(gethighesttotalcost.ucost),',_.__')#</strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(highest.gross)-val(gethighesttotalcost.ucost),',_.__')#</strong></div></td> 
                        <td><div align="right"><strong><cfif val(highest.gross) eq 0>0.00<cfelse>#numberformat(((val(highest.gross)-val(gethighesttotalcost.ucost)) / val(highest.gross))*100,',_.__')#</cfif></strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(highest.net)-val(gethighesttotalcost.ucost),',_.__')#</strong></div></td> 
                        <td><div align="right"><strong><cfif val(highest.net) eq 0>0.00<cfelse>#numberformat(((val(highest.net)-val(gethighesttotalcost.ucost)) / val(highest.net))*100,',_.__')#</cfif></strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(highest.net)/val(highest.countsales),'.__')#</strong></div></td> 

					</tr>
                    
                    <cfquery name="lowest" datasource="#dts#">
                        select wos_date,count(refno) as countsales,sum(invgross) as gross,sum(discount) as discount,sum(grand) as grand,sum(invgross-discount) as net,sum(tax) as tax from artran
                        where type='CS' and (void = '' or void is null)
                        <cfif form.locfrom neq "" and form.locto neq "">
                        and refno in (select refno from ictran where location >='#form.locfrom#' and location <= '#form.locto#' group by refno)
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
                       
                        and fperiod = '#form.periodfrom#'
                      	<cfif form.datefrom neq "" and form.dateto neq "">
                        and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
                        <cfelse>
                        and wos_date > #getgeneral.lastaccyear#
                        </cfif>
                        and wos_date > #getgeneral.lastaccyear#

                        group by wos_date order by grand limit 1
                    </cfquery>
                    <cfquery name="getlowesttotalcost" datasource="#dts#">
                        select sum(it_cos) as ucost,sum(qty) as qty from ictran
                        where type in ('CS','INV') and (void = '' or void is null)
                        and wos_date='#dateformat(lowest.wos_date,"yyyy-mm-dd")#'
                        </cfquery>
                    
                    <tr >
 						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Lowest</strong></font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>#getlowesttotalcost.qty#</strong></font></div></td>
                        
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>#lowest.countsales#</strong></font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(val(lowest.gross),',_.__')#</strong></font></div></td>
						<td><div align="right"><strong>#numberformat(val(lowest.discount),',_.__')#</strong></div></td>
						<td><div align="right"><strong>#numberformat(val(lowest.net),',_.__')#</strong></div></td>
						<td><div align="right"><strong>#numberformat(val(lowest.tax),',_.__')#</strong></div></td>
                        <td><div align="right"><strong>#numberformat(val(lowest.grand),',_.__')#</strong></div></td>    
                        <td><div align="right"><strong>#numberformat(val(getlowesttotalcost.ucost),',_.__')#</strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(lowest.gross)-val(getlowesttotalcost.ucost),',_.__')#</strong></div></td> 
                        <td><div align="right"><strong><cfif val(lowest.gross) eq 0>0.00<cfelse>#numberformat(((val(lowest.gross)-val(getlowesttotalcost.ucost)) / val(lowest.gross))*100,',_.__')#</cfif></strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(lowest.net)-val(getlowesttotalcost.ucost),',_.__')#</strong></div></td> 
                        <td><div align="right"><strong><cfif val(lowest.net) eq 0>0.00<cfelse>#numberformat(((val(lowest.net)-val(getlowesttotalcost.ucost)) / val(lowest.net))*100,',_.__')#</cfif></strong></div></td> 
                        <td><div align="right"><strong>#numberformat(val(lowest.net)/val(lowest.countsales),'.__')#</strong></div></td> 

					</tr>
                    
                   </cfif> 
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
