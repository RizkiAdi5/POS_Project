<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>News</title>
</head>

<body style="background-repeat: repeat-y;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	color: #336699;
	scrollbar-face-color:#CFCED2;
	scrollbar-shadow-color:#CFCED2;
	scrollbar-highlight-color:#F6F6F7;
	scrollbar-3dlight-color:#B3B3B3;
	scrollbar-darkshadow-color:#919194;
	scrollbar-track-color:#E5E5E5;
	scrollbar-arrow-color:#000000;
	background-color: #C0CFE2;">
 	<script type='text/javascript' src='/ajax/core/engine.js'></script>
	<script type='text/javascript' src='/ajax/core/util.js'></script>
	<script type='text/javascript' src='/ajax/core/settings.js'></script>
    <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
    <link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>
    <script type="text/javascript" src="/scripts/prototypenew.js" ></script>
    <script type="text/javascript">
	
	
	</script>
<cfquery name="getGeneralInfo" datasource="#dts#">
	select * 
	from gsetup;
</cfquery>

<img src="images/pos Purchase.jpg" alt="Purchase" usemap="#purchasemap" style="border:none">

 <map name="purchasemap">
 	<cfif getpin2.h1100 eq "T">
   	<area shape="rect" coords="190,100,270,190" href="/default/maintenance/linkPage.cfm?type=Supplier" alt="Supplier">
    </cfif>
    
    <cfif getpin2.h1300 eq "T">
   	<area shape="rect" coords="300,100,380,190" href="/default/maintenance/s_icitem.cfm?type=icitem" alt="Item">
    </cfif>
    
    <cfif getpin2.h2860 eq 'T'>
   	<area shape="rect" coords="30,230,130,330" href="/default/transaction/transaction.cfm?tran=po" alt="Purchase Order">
    </cfif>
    
    <cfif getpin2.h2100 eq "T">
   	<area shape="rect" coords="230,230,310,330" href="/default/transaction/transaction.cfm?tran=rc" alt="Purcahse Receive">
    </cfif>
    
    <cfif getpin2.h2200 eq "T">
   	<area shape="rect" coords="410,230,500,330" href="/default/transaction/transaction.cfm?tran=pr" alt="Purcahse Return">
    </cfif>

    <!---
    <cfif getpin2.h4400 eq "T">
   	<area shape="rect" coords="60,440,130,550" href="/default/report-purchase/purchasemenu.cfm" alt="Purcahse Report">
    </cfif>
    --->
<!---
   	<area shape="rect" coords="180,440,260,550" href="/default/report-chart/purchasebybrand.cfm" alt="Purcahse Chart">
--->
    
   
   	<area shape="rect" coords="321,440,410,550" href="/default/report-stock/stockcard.cfm" alt="Stock Card">

   

 </map> 


</body>
</html>
