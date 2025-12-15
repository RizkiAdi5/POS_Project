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
									
		
		

		
		function done()
		{
		window.close();
		opener.document.invoicesheet.submit;
		}
		
	</script>
</head>

<body> 
<h1 align="center">Net Total</h1>
<table align="center">
	<cfform name="form" action="" method="post">
	<tr align="left">
		<th>Total</th>
		<td nowrap>
			<cfinput type="text" name="totalamt" id="totalamt" value="#url.amt#" readonly>
		</td>
	</tr>
	
	<tr>
		<td colspan="100%" align="center">
			<input type="button" value="Save" onClick="done();">
			<input type="button" value="Cancel" onClick="javascript:window.close();">
		</td>
	</tr>
	</cfform>
</table>

</body>
</html>