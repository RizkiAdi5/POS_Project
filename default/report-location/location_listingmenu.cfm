<html>
<head>
<title>Billing Listing Menu</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfquery name="getgeneral" datasource="#dts#">
	select lLOCATION from gsetup
</cfquery>
<h1>
	<center><cfoutput>#getgeneral.lLOCATION#</cfoutput> Reports Menu</center>
</h1>

<br><br>
Click on the following to select reports.
<br><br>

<table width="75%" border="0" class="data" align="center">
	<tr> 
    	<td colspan="4"><div align="center"><cfoutput>#getgeneral.lLOCATION#</cfoutput> REPORTS</div></td>
  	</tr>
  	<tr> 
    <cfif getpin2.h4510 eq "T">
		<td><a href="../report-location/location_listingreport.cfm?type=1" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif">Item - <cfoutput>#getgeneral.lLOCATION#</cfoutput> Sales</a></td>
	</cfif>
    <cfif getpin2.h4520 eq "T">
		<td><a href="../report-location/location_listingreport.cfm?type=2" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif">Item - <cfoutput>#getgeneral.lLOCATION#</cfoutput> Purchase</a></td>
	</cfif>
    <cfif getpin2.h4530 eq "T">
    <cftry>
				<cfquery name="getrecord" datasource="#dts#">
					SELECT lastaccdate FROM icitem_last_year limit 1
				</cfquery>

                <td><a href="../report-location/stockcard0.cfm?type=1" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif"><cfoutput>#getgeneral.lLOCATION#</cfoutput> Stock Card</a></td>
			<cfcatch type="any">
				<td><a href="../report-location/location_stockcard_stock_card.cfm" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif"><cfoutput>#getgeneral.lLOCATION#</cfoutput> Stock Card</a></td>
			</cfcatch>
			</cftry>
		
	</cfif>
    <cfif getpin2.h4540 eq "T">
		<td><a href="../report-location/location_stockcard_forecast.cfm" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif"><cfoutput>#getgeneral.lLOCATION#</cfoutput> Forecast</a></td>
	</cfif>
  	</tr>
    
  	<tr> 
    <cfif getpin2.h4550 eq "T">
		<td><a href="location_physical_worksheet_menu.cfm" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif"><cfoutput>#getgeneral.lLOCATION#</cfoutput> Physical Worksheet</a></td>
        <td><a href="location_physical_worksheetDO.cfm" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif"><cfoutput>#getgeneral.lLOCATION#</cfoutput> Physical Worksheet DO</a></td>
        <!---<td><a href="/default/report-location/locationexpressadjustment/" target="_blank"><img name="Cash Sales" src="/images/reportlogo.gif"><cfoutput>Express #getgeneral.lLOCATION#</cfoutput> Physical Adjustment</a></td>--->
        </cfif>
        <cfif getpin2.h4560 eq "T">
		<td><a href="location_status_form.cfm?type=item_location" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif">Item - <cfoutput>#getgeneral.lLOCATION#</cfoutput> Status & Value</a></td>
		<td><a href="location_status_form.cfm?type=location_item" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif"><cfoutput>#getgeneral.lLOCATION#</cfoutput> - Item Status & Value</a></td>
		<td>&nbsp;</td>
        </cfif>
  	</tr>
    
    <tr>
    <cfif getpin2.h4570 eq "T">
		<td><a href="../report-location/location_openingqty.cfm" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif"><cfoutput>#getgeneral.lLOCATION#</cfoutput> Opening Qty Check</a></td>
        <td><a href="../report-location/location_openingqty1.cfm" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif"><cfoutput>#getgeneral.lLOCATION#</cfoutput> Opening Qty</a></td>
	</cfif>
    <cfif getpin2.h4530 eq "T">
    <td><a href="../report-location/location_stockcard_stock_cardsummary.cfm" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif"><cfoutput>#getgeneral.lLOCATION#</cfoutput> Stock Card Summary</a></td>
	</cfif>
    <cfif getpin2.h4530 eq "T">
    <td><a href="../report-location/locationstockcheck.cfm" target="mainFrame"><img name="Cash Sales" src="/images/reportlogo.gif"><cfoutput>#getgeneral.lLOCATION#</cfoutput> Check Stock</a></td>
	</cfif>
    
    </tr>
</table>

</body>
</html>