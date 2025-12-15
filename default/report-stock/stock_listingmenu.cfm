<html>
<head>
<title>Billing Listing Menu</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>

<h1><center>Inventory Listing Menu</center></h1>
<br><br>Click on the following to select reports.<br><br>

<table width="75%" border="0" class="data" align="center">
	<tr> 
    	<td colspan="4"><div align="center">Basic Report</div></td>
  	</tr>
  	<tr> 
    	<cfif getpin2.h4210 eq "T">
			<cftry>
				<cfquery name="getrecord" datasource="#dts#">
					SELECT lastaccdate FROM icitem_last_year limit 1
				</cfquery>
				<td><a href="../report-stock/stockcard0.cfm?type=1" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Stock Card</a></td>
			<cfcatch type="any">
				<td><a href="../report-stock/stockcard.cfm?type=1" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Stock Card</a></td>
			</cfcatch>
			</cftry>
			<!--- <cfif hcomid eq "idi_i" or hcomid eq "demo_i" or hcomid eq "saehan_i" or hcomid eq "ge_i" or hcomid eq "redd_i" or lcase(hcomid) eq "mhsl_i">
				<td><a href="../report-stock/stockcard0.cfm?type=1" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Stock Card</a></td>
			<cfelse>
				<td><a href="../report-stock/stockcard.cfm?type=1" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Stock Card</a></td>
			</cfif> --->
		</cfif>
        
    	<cfif getpin2.h4220 eq "T">
			<td><a href="../report-stock/reorderadvise.cfm?type=2" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Reorder Advice</a></td>
		</cfif>
        <cfif getpin2.h4260 eq "T">
    		<td><a href="../report-stock/stockaging.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Stock Aging</a></td>
            </cfif>
  	</tr>
 	<tr>
    <cfif getpin2.h4270 eq "T">
		<td><a href="../report-stock/physical_worksheet_menu.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Physical Worksheet</a></td>
        </cfif>
        <cfif getpin2.h4280 eq "T">
		<td><a href="../report-stock/transsummary.cfm?type=Quantity" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Transaction Summary By Quantity</a></td>
        </cfif>
        <cfif getpin2.h4290 eq "T">
		<td><a href="../report-stock/transsummary.cfm?type=Value" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Transaction Summary By Value</a></td>  
		</cfif>
         <cfif getpin2.h4210 eq "T">
			<td><a href="../report-stock/dailystockcard.cfm" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Daily stock card</a></td>
		</cfif>
    </tr>
    <tr>
    <cfif getpin2.h4270 eq "T">
		<td><a href="../report-stock/expressadjustment/" target="_blank"><img name="Cash Sales" src="../../images/reportlogo.gif">Express Quantity Adjustment</a></td>
        </cfif>
    </tr>
</table>

<br><br><br>

<table width="75%" border="0" align="center" class="data">
	<tr> 
    	<td colspan="4"><div align="center">Stock Value Report</div></td>
  	</tr>
  	<tr> 
    	<cfif getpin2.h4230 eq "T">
			<cftry>
				<cfquery name="getrecord" datasource="#dts#">
					SELECT lastaccdate FROM icitem_last_year limit 1
				</cfquery>
				<td><a href="../report-stock/itemstatus0.cfm?type=3" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Item Status and Value</a></td>
			<cfcatch type="any">
				<td><a href="../report-stock/itemstatus.cfm?type=3" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Item Status and Value</a></td>
			</cfcatch>
			</cftry>
			<!--- <td><a href="../report-stock/itemstatus.cfm?type=3" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Item Status and Value</a></td> --->
		</cfif>
    	<cfif getpin2.h4240 eq "T">
			<td><a href="../report-stock/groupstatus.cfm?type=4" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Group Status and Value</a></td>
		</cfif>
        <cfif getpin2.h4240 eq "T">
			<td><a href="../report-stock/catestatus.cfm?type=4" target="mainFrame"><img name="Cash Sales" src="../../images/reportlogo.gif">Category Status and Value</a></td>
		</cfif>
        
  	</tr>
    
</table>

</body>
</html>