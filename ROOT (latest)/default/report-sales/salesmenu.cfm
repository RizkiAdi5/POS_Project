<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Sales Report Menu</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<h1><center>Sales Report Menu</center></h1>
<br><br>
Click on the following to select reports.
<br><br>

<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<table width="75%" border="0" class="data" align="center">
	<tr> 
    	<td colspan="4"><div align="center">SALES REPORT BY TYPE</div></td>
  	</tr>
  	<tr> 
    	<cfif getpin2.h4310 eq 'T'><td><a href="../report-sales/salestype.cfm?type=producttype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Products Sales</a></td></cfif>
    	<cfif getpin2.h4320 eq 'T'><td><a href="../report-sales/salestype.cfm?type=customertype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Customers Sales</a></td></cfif>
    	<cfif getpin2.h4330 eq 'T'><td><a href="../report-sales/salestype.cfm?type=agenttype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif"><cfoutput>#getgsetup.lagent#</cfoutput> Sales</a></td></cfif>
    	<cfif getpin2.h4340 eq 'T'><td><a href="../report-sales/salestype.cfm?type=grouptype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Groups Sales</a></td></cfif>
  	</tr>
  	<tr> 
    	<cfif getpin2.h4350 eq 'T'><td><a href="../report-sales/salestype.cfm?type=endusertype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif"><cfoutput>#getgsetup.ldriver#</cfoutput> Sales</a></td></cfif>
        <cfif getpin2.h4340 eq 'T'><td><a href="../report-sales/salestype.cfm?type=brandtype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Brand Sales</a></td></cfif>
    	<td>&nbsp;</td>
    	<td>&nbsp;</td>
  	</tr>
  	<tr> 
    	<td colspan="4" height="20"></td>
  	</tr>
  	<tr> 
    	<td colspan="4"><div align="center">SALES REPORT BY MONTH</div></td>
  	</tr>
  	<tr> 
		<cfif lcase(hcomid) neq "gel_i">
			<cfif getpin2.h4360 eq 'T'><td><a href="../report-sales/salesmonthnew.cfm?type=productmonth" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Products Sales</a></td></cfif>
		</cfif>
    	<cfif getpin2.h4370 eq 'T'><td><a href="../report-sales/salesmonthnew.cfm?type=customermonth" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Customers Sales</a></td></cfif>
    	<cfif getpin2.h4380 eq 'T'><td><a href="../report-sales/salesmonthnew.cfm?type=agentmonth" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif"><cfoutput>#getgsetup.lagent#</cfoutput> Sales</a></td></cfif>
    	<cfif getpin2.h4390 eq 'T'><td><a href="../report-sales/salesmonth.cfm?type=groupmonth" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Groups Sales</a></td></cfif>
  	</tr>
  	<tr> 
    	<cfif getpin2.h43A0 eq 'T'><td><a href="../report-sales/salesmonth.cfm?type=endusermonth" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif"><cfoutput>#getgsetup.ldriver#</cfoutput> Sales</a></td></cfif>
    	<cfif getpin2.h4360 eq 'T'><td><a href="../report-sales/salesmonth_2.cfm?type=productmonth" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Products Sales</a></td></cfif>
    		<cfif getpin2.h4360 eq 'T'><td><a href="../report-sales/activecust.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Active Customer</a></td></cfif>
    	<cfif getpin2.h4390 eq 'T'><td><a href="../report-sales/salesmonthnew.cfm?type=brandmonth" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Brand Sales</a></td></cfif>
  	</tr>
  	<tr> 
    	<td colspan="4" height="20"></td>
  	</tr>
  	<tr> 
    	<td colspan="4"><div align="center">SALES REPORT BY WEEK</div></td>
  	</tr>
  	<tr> 
    	<cfif getpin2.h4360 eq 'T'><td><a href="../report-sales/salesweek.cfm?type=productweek" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Products Sales</a></td></cfif>
    	<cfif getpin2.h4370 eq 'T'><td><a href="../report-sales/salesweek.cfm?type=customerweek" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Customers Sales</a></td></cfif>
    	<cfif getpin2.h4380 eq 'T'><td><a href="../report-sales/salesweek.cfm?type=agentweek" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif"><cfoutput>#getgsetup.lagent#</cfoutput> Sales</a></td></cfif>
    	<cfif getpin2.h4390 eq 'T'><td><a href="../report-sales/salesweek.cfm?type=groupweek" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Groups Sales</a></td></cfif>
  	</tr>
  	<tr> 
    	<cfif getpin2.h43A0 eq 'T'><td><a href="../report-sales/salesweek.cfm?type=enduserweek" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif"><cfoutput>#getgsetup.ldriver#</cfoutput> Sales</a></td></cfif>
    	<td>&nbsp;</td>
    	<td>&nbsp;</td>
    	<td>&nbsp;</td>
  	</tr>
    <tr> 
    	<td colspan="4" height="20"></td>
  	</tr>
    <tr> 
    	<td colspan="4"><div align="center">SALES REPORT BY DAY</div></td>
  	</tr>
    <tr> 
    	<cfif getpin2.h43A0 eq 'T'><td><a href="../report-sales/salesday.cfm?type=enduserday" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif"><cfoutput>#getgsetup.ldriver#</cfoutput> Sales</a></td></cfif>
    	<cfif getpin2.h43A0 eq 'T'><td><a href="../report-sales/dailyendusersalesform.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif"><cfoutput>#getgsetup.ldriver#</cfoutput> Sales 2</a></td></cfif>
    	<td>&nbsp;</td>
    	<td>&nbsp;</td>
  	</tr>
  	<tr> 
    	<td colspan="4" height="20"></td>
  	</tr>
  	<tr> 
    	<td colspan="4"><div align="center">CALCULATE COST OF SALES</div></td>
  	</tr>
  	<tr> 
  		<cfif getpin2.h43I0 eq 'T'><td><a href="../report-sales/calculatecostmenu.cfm?type=fixed" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Fixed Cost</a></td></cfif>
		<cfif getpin2.h43J0 eq 'T'><td><a href="../report-sales/calculatecostmenu.cfm?type=fifo" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">First In First Out</a></td></cfif>
		<cfif getpin2.h43K0 eq 'T'><td><a href="../report-sales/calculatecostmenu.cfm?type=lifo" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Last In First Out</a></td></cfif>
  		<td>&nbsp;</td>
	</tr> 
  	<tr> 
		<cfif getpin2.h43L0 eq 'T'><td><a href="../report-sales/calculatecostmenu.cfm?type=month" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Month Average</a></td></cfif>
    	<cfif getpin2.h43M0 eq 'T'><td><a href="../report-sales/calculatecostmenu.cfm?type=moving" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Moving Average</a></td></cfif>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
  	</tr>
  	<tr> 
    	<td colspan="4" height="20"></td>
  	</tr>
  	<tr> 
    	<td colspan="4"><div align="center">PROFIT MARGIN REPORT</div></td>
  	</tr>
  	<tr> 
    	<cfif getpin2.h43B0 eq 'T'><td><a href="../report-sales/profitmargin.cfm?type=productmargin" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">By Products</a></td></cfif>
    	<cfif getpin2.h43C0 eq 'T'><td><a href="../report-sales/profitmargin.cfm?type=billmargin" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">By Bill</a></td></cfif>
    	<cfif getpin2.h43D0 eq 'T'><td><a href="../report-sales/profitmargin.cfm?type=agentmargin" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">By <cfoutput>#getgsetup.lagent#</cfoutput></a></td></cfif>
    	<cfif getpin2.h43E0 eq 'T'><td><a href="../report-sales/profitmargin.cfm?type=projectmargin" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">By Project</a></td></cfif>
  	</tr>
	<tr> 
		<!---<cfif getpin2.h43I0 eq 'T'>---><cfif getpin2.h43N0 eq 'T'><td><a href="../report-sales/profitmargin.cfm?type=billitemmargin" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">By Bill Item</a></td></cfif><!---</cfif>--->
  		<cfif getpin2.h43O0 eq 'T'><td><a href="../report-sales/profitmargin.cfm?type=customermargin" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">By Customer</a></td></cfif></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
  	<tr> 
    	<td colspan="4" height="20"></td>
  	</tr>
  	<tr> 
    	<td colspan="4"><div align="center">SALES LISTING</div></td>
  	</tr>
  	<tr> 
    	<cfif getpin2.h43F0 eq 'T'><td><a href="../report-sales/saleslisting.cfm?type=customerlist" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">By Customers</a></td></cfif>
    	<cfif getpin2.h43G0 eq 'T'><td><a href="../report-sales/saleslisting.cfm?type=productlist" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">By Products</a></td></cfif>
    	<cfif getpin2.h43H0 eq 'T'><td><a href="../report-sales/saleslisting.cfm?type=agentlist" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">By <cfoutput>#getgsetup.lagent#</cfoutput></a></td></cfif>
    	<!---<cfif getpin2.h43I0 eq 'T'>---><cfif getpin2.h43P0 eq 'T'><td><a href="../report-sales/saleslisting.cfm?type=arealist" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">By Area</a></td></cfif><!---</cfif>--->
  	</tr>
  	<tr> 
    	<td colspan="4" height="20"></td>
  	</tr>
  	<tr> 
    	<td colspan="4"><div align="center">TOP/BOTTOM PRODUCT SALES</div></td>
  	</tr>
  	<tr> 
    	<cfif getpin2.h43Q0 eq 'T'><td><a href="../report-sales/topbottomsales.cfm?type=top" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Top Product Sales</a></td></cfif>
    	<cfif getpin2.h43R0 eq 'T'><td><a href="../report-sales/topbottomsales.cfm?type=bottom" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Bottom Product Sales</a></td></cfif>
  	</tr>
	<tr> 
    	<td colspan="4"><div align="center">TOP SALES REPORT</div></td>
  	</tr>
  	<tr> 
    	<cfif getpin2.h43S0 eq 'T'><td><a href="../report-sales/topsales.cfm?type=customertype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Top Sales By Customers</a></td></cfif>
		<cfif getpin2.h43T0 eq 'T'><td><a href="../report-sales/topsales.cfm?type=agenttype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Top Sales By <cfoutput>#getgsetup.lagent#</cfoutput></a></td></cfif>
		<cfif getpin2.h43U0 eq 'T'><td><a href="../report-sales/topsales.cfm?type=areatype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Top Sales By Area</a></td></cfif>
  	</tr>
    <tr>
        	<td colspan="4"><div align="center">SALES REPORT</div></td>
              	</tr>
  	<tr> 

		<cfif getpin2.h43V0 eq 'T'><td><a href="../report-sales/salesreport.cfm?type=agenttype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif"><cfoutput>#getgsetup.lagent#</cfoutput> Sales Commision Report</a></td></cfif>
        <cfif getpin2.h43V0 eq 'T'><td><a href="../report-sales/endusersalesreport.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">End User Sales Report</a></td></cfif>
       
</tr>
<tr> 
    	<td colspan="4"><div align="center">Print Statement</div></td>
  	</tr>
    <tr>
 <cfif getpin2.h43V0 eq 'T'><td><a href="../report-sales/statementform.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Statement Report</a></td></cfif>
 </tr>
 <tr> 
    	<td colspan="4"><div align="center">Sales Detail report</div></td>
  	</tr>
    <tr>
 <td><a href="../report-sales/salesdetailbysupp.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Sales Detail by Customer</a></td>
 <td><a href="../report-sales/salesdetailbyitem.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Sales Detail by Item</a></td>
 <td><a href="../report-sales/salesdetailbyrefno.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Sales Detail by Ref No</a></td>
  <td><a href="../report-sales/salesdetailbyagent.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Sales Detail by Agent</a></td>
 </tr>
<tr> 
    	<td colspan="4"><div align="center">Cash Sales report</div></td>
  	</tr>
      <tr>
 <td><a href="../report-sales/cashsales.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Cash Sales Report By User</a></td>
  <td><a href="../report-sales/cashsalessummary.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Cash Sales Summary Report </a></td>
  <td><a href="../report-sales/cashsalesbycounter.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Cash Sales Report By Counter </a></td>
  
 </tr>
 <tr>
  <td><a href="../report-sales/dailycheckout.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Daily Checkout Report </a></td>
 <td><a href="../report-sales/dailycheckoutA.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Daily Checkout Report 2</a></td>
 <td><a href="../report-sales/salesreportitem.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Product Sales Report</a></td>
 <td><a href="../report-sales/cashsalesbycashier.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Daily Sales Report By Cashier</a></td>
 </tr>

<!---  <tr> 
    	<td colspan="4"><div align="center">NEW SALES REPORT BY MONTH</div></td>
        
  	</tr>
    <tr>
    <cfif getpin2.h4360 eq 'T'><td><a href="/default/report-sales/salesmonthnew.cfm?type=productmonth" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif">Products Sales</a></td></cfif>
    <cfif getpin2.h4370 eq 'T'><td><a href="/default/report-sales/salesmonthnew.cfm?type=customermonth" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif">Customers Sales</a></td></cfif>
    	<cfif getpin2.h4380 eq 'T'><td><a href="/default/report-sales/salesmonthnew.cfm?type=agentmonth" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif">Agent Sales</a></td></cfif>
    	<cfif getpin2.h4390 eq 'T'><td><a href="/default/report-sales/salesmonthnew.cfm?type=groupmonth" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif">Groups Sales</a></td></cfif>
  	</tr>
  	<tr> 
    	<cfif getpin2.h43A0 eq 'T'><td><a href="/default/report-sales/salesmonthnew.cfm?type=endusermonth" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif">End User Sales</a></td></cfif>
    	<cfif getpin2.h4360 eq 'T'><td><a href="/default/report-sales/salesmonth_2.cfm?type=productmonth" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif">Products Sales</a></td></cfif>
    </tr> --->
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>