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
									
		function validation(){
			if(document.form.totalamt.value > document.form.pcash.value){
				alert("Paid Amount Lesser than Total Amount");
				return false;
			}
				return true;
			}
		
		function calculatechange()
		{
		document.form.balanceamt.value=((document.form.totalamt.value*1)-((document.form.pcash.value*1)+(document.form.pcredit_card1.value*1)+(document.form.pcredit_card2.value*1)+(document.form.pdebit_card.value*1)+(document.form.pcheque.value*1)+(document.form.pdeposit.value*1))).toFixed(2);
		}
		
		function done()
		{
		opener.document.invoicesheet.cash.value=document.form.pcash.value;
		
		opener.document.invoicesheet.credit_card1.value=document.form.pcredit_card1.value;
		opener.document.invoicesheet.credit_card2.value=document.form.pcredit_card2.value;
		opener.document.invoicesheet.debit_card.value=document.form.pdebit_card.value;
		opener.document.invoicesheet.cheque.value=document.form.pcheque.value;
		opener.document.invoicesheet.voucher.value=document.form.pvoucher.value;
		opener.document.invoicesheet.deposit.value=document.form.pdeposit.value;

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
		<th>Grand Total</th>
		<td nowrap>
			<cfinput type="text" name="totalamt" id="totalamt" value="#url.amt#" readonly>
		</td>
	</tr>
	<tr align="left">
	<th>Cash</th>
		<td nowrap>
			<cfinput type="text" name="pcash" id="pcash" value="0.00" validate="float" onKeyUp="calculatechange();">
		</td>
	</tr>
    
    <tr align="left">
	<th>Credit Card 1</th>
		<td nowrap>
			<cfinput type="text" name="pcredit_card1" id="pcredit_card1" value="0.00" validate="float" onKeyUp="calculatechange();">
		</td>
	</tr>
    
    <tr align="left">
	<th>Credit Card 2</th>
		<td nowrap>
			<cfinput type="text" name="pcredit_card2" id="pcredit_card2" value="0.00" validate="float" onKeyUp="calculatechange();">
		</td>
	</tr>
    
    <tr align="left">
	<th>Debit Card</th>
		<td nowrap>
			<cfinput type="text" name="pdebit_card" id="pdebit_card" value="0.00" validate="float" onKeyUp="calculatechange();">
		</td>
	</tr>
    
    <tr align="left">
	<th>Cheque</th>
		<td nowrap>
			<cfinput type="text" name="pcheque" id="pcheque" value="0.00" validate="float" onKeyUp="calculatechange();">
		</td>
	</tr>
    
    <tr align="left">
	<th>Voucher</th>
		<td nowrap>
			<cfinput type="text" name="pvoucher" id="pvoucher" value="0.00" validate="float" onKeyUp="calculatechange();">
		</td>
	</tr>
    
    <tr align="left">
	<th>Deposit</th>
		<td nowrap>
			<cfinput type="text" name="pdeposit" id="pdeposit" value="0.00" validate="float" onKeyUp="calculatechange();">
		</td>
	</tr>
    
    
	<tr align="left">
		<th>Balance</th>
		<td nowrap>
			<cfinput name="balanceamt" id="balanceamt" type="text" value="0.00" readonly>
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