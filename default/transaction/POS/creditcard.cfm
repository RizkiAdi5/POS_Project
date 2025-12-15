<cfinclude template = "/CFC/convert_single_double_quote_script.cfm">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>

<html>
<head>
	<title>Cash Payment</title>
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
		opener.document.invoicesheet.credit_card1.value=document.form.pcreditcard.value;
		opener.document.invoicesheet.creditcardtype.value=document.form.creditcardtype1.value;
		opener.document.invoicesheet.submit;
		window.close();
		}
		
	</script>
</head>

<body> 
<h1 align="center">Cash Payment</h1>
<table align="center">
	<cfform name="form" action="" method="post">
	<tr align="left">
		<th>Total</th>
		<td nowrap>
			<cfinput type="text" name="totalamt" id="totalamt" value="#url.amt#" readonly>
		</td>
	</tr>
    <tr align="left">
	<th>Credit Card Type</th>
		<td nowrap>
    <select name="creditcardtype1">
            <option value="">Choose a type of credit card</option>
            <option value="VISA">VISA</option>
            <option value="MASTER" >MASTER</option>
            <option value="AMEX">AMEX</option>
            <option value="JCB" >JCB</option>
            <option value="DINERS">DINERS</option>
			</select>
    </td>
	<tr align="left">
	<th>Paid</th>
		<td nowrap>
			<cfinput type="text" name="pcreditcard" id="pcreditcard" value="#url.amt#" validate="float" onKeyUp="">
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