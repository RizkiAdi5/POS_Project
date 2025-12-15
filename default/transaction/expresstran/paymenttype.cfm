<cfinclude template = "/CFC/convert_single_double_quote_script.cfm">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>

<html>
<head>
	<title>Net Total</title>
	<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	
	<script type="text/javascript">
	
	function selectlist(custno,fieldtype){

			for (var idx=0;idx<document.getElementById(fieldtype).options.length;idx++) 
			{
        	if (custno==document.getElementById(fieldtype).options[idx].value) 
			{
            document.getElementById(fieldtype).options[idx].selected=true;
        	}
    		} 
			
									}
		
	</script>
</head>

<body> 
<h1 align="center">Net Total</h1>
<table align="center">
	<cfform name="form" action="" method="post">
	<tr align="center">
		<td nowrap>
		<cfinput type="button" name="bcash" id="bcash" value="CASH" onClick="window.location.href='cash.cfm?amt=#url.amt#';">
		</td>
	</tr>
	
	<tr align="center">
		<td nowrap>
		<cfinput type="button" name="bCredit_Card" id="bCredit_Card" value="Credit Card" onClick="window.location.href='creditcard.cfm?amt=#url.amt#';">
		</td>
	</tr>
    <tr align="center">
		<td nowrap>
		<cfinput type="button" name="bmultipayment" id="bmultipayment" value="Multi Payment" onClick="window.location.href='multipayment.cfm?amt=#url.amt#';">
		</td>
	</tr>
    <tr align="center">
		<td nowrap>
		<cfinput type="button" name="bnet" id="bnet" value="Net" onClick="window.location.href='net.cfm?amt=#url.amt#';">
		</td>
	</tr>
	</cfform>
</table>

</body>
</html>