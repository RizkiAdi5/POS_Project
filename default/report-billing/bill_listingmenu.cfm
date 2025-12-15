<html>
<head>
<title>Billing Listing Menu</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<h1><center>Bill Listing Menu</center></h1>
<br><br>Click on the following to select reports.<br><br>

<table width="85%" border="0" class="data" align="center">
	<tr>
    	<td colspan="5"><div align="center">BILL LISTING REPORTS</div></td>
  	</tr>
  	<tr>
    	<cfif getpin2.h4110 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=1" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Purchase Receive</a></td></cfif>
    	<cfif getpin2.h4120 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=2" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Purchase Return</a></td></cfif>
    	<cfif getpin2.h4130 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=3" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Delivery Order</a></td></cfif>
    	<cfif getpin2.h4140 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=4" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Invoice</a></td></cfif>
    	<cfif getpin2.h4150 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=9" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Quotation</a></td></cfif>
  	</tr>
  	<tr>
    	<cfif getpin2.h4160 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=5" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Credit Note</a></td></cfif>
    	<cfif getpin2.h4170 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=6" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Debit Note</a></td></cfif>
    	<cfif getpin2.h4180 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=7" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Cash Sales</a></td></cfif>
    	<cfif getpin2.h4190 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=8" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Purchase Order</a></td></cfif>
    	<cfif getpin2.h41A0 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=10" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Sales Order</a></td></cfif>
  	</tr>
  	<tr>
    	<cfif getpin2.h41C0 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=11" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Sample</a></td></cfif>
		<cfif getpin2.h41B0 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=12" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Issue</a></td></cfif>
   		<cfif getpin2.h41D0 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=13" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Adjustment Increase</a></td></cfif>
    	<cfif getpin2.h41E0 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=14" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Adjustment Reduce</a></td></cfif>
    	<cfif getpin2.h41F0 eq 'T'><td><a href="../report-billing/bill_listingreport.cfm?type=15" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Transfer Note</a></td></cfif>
  	</tr>
</table>

</body>
</html>