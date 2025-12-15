<!--- <cfoutput><cfcache action="cache" timespan="#CreateTimeSpan(1,0,0,0)#"></cfoutput> --->
<html>
<head>
<title>Purchase Report Menu</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<h1><center>Purchase Report Menu</center></h1>
<br><br>Click on the following to select reports.<br><br>

<table width="50%" border="0" class="data" align="center">
	<tr> 
    	<td colspan="2"><div align="center">PURCHASE REPORT BY TYPE</div></td>
  	</tr>
  	<tr> 
    	<td><a href="../report-purchase/purchasetype.cfm?type=producttype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Products Purchase</a></td>
    	<td><a href="../report-purchase/purchasetype.cfm?type=vendortype" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Vendor Supply</a></td>    
  	</tr>
	<tr> 
    	<td colspan="2" height="20"></td>
  	</tr>
  	<tr> 
    	<td colspan="2"><div align="center">PURCHASE REPORT BY MONTH</div></td>
  	</tr>
  	<tr> 
    	<td><a href="../report-purchase/purchasemonth.cfm?type=productmonth" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Products Purchase</a></td>
		<td><a href="../report-purchase/purchasemonth.cfm?type=vendormonth" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Vendor Supply </a></td>
    </tr>
	<tr> 
    	<td colspan="2" height="20"></td>
  	</tr>
	<tr> 
    	<td colspan="2"><div align="center">PURCHASE REPORT BY QUANTITY</div></td>
  	</tr>
  	<tr> 
    	<td><a href="../report-purchase/purchasequantity.cfm?type=vendorproduct" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Vendor - Products</a></td>
		<td><a href="../report-purchase/purchasequantity.cfm?type=productvendor" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Products - Vendor</a></td>
    </tr>
	<tr> 
    	<td colspan="2" height="20"></td>
  	</tr>
	<tr> 
    	<td colspan="2"><div align="center">PURCHASE LISTING REPORT</div></td>
  	</tr>
	<tr> 
    	<td><a href="../report-purchase/purchaselisting.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Purchase Listing By Vendors</a></td>
    </tr>
    <tr> 
    	<td colspan="2"><div align="center">PURCHASE DETAIL REPORT</div></td>
  	</tr>
	<tr> 
    	<td><a href="../report-purchase/purchasedetailbyitem.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Purchase Detail By Items</a></td>
        <td><a href="../report-purchase/purchasedetailbysupp.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Purchase Detail By Supplier</a></td>
    </tr>
    <tr> 
    	<td><a href="../report-purchase/purchasedetailbyrefno.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Purchase Detail By Ref No</a></td>
    </tr>
    	
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>