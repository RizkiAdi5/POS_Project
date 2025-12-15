<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Billing Listing Menu</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<h1><center>
    Purchase Reports Menu
  </center></h1>

<br><br>
Click on the following to select reports.
<br><br>
<table width="75%" border="0" class="data" align="center">
  <tr>
    <td colspan="2"><div align="center">PURCHASE REPORTS BY TYPE</div></td>
  </tr>
  <tr>
    <cfif getpin2.h4410 eq 'T'><td><a href="../report-purchase/purchase_listingreport.cfm?type=1" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Products
      Purchase</a></td></cfif>
    <cfif getpin2.h4420 eq 'T'><td><a href="../report-purchase/purchase_listingreport.cfm?type=2" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Vendors
      Supply </a></td></cfif>

  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>

  </tr>
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>
