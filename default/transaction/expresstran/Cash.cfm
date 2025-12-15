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
			if(document.form.totalamt.value >= document.form.pcash.value){
				alert("Paid Amount Lesser than Total Amount");
				return false;
			}
				return true;
			}
		
		function calculatechange()
		{
		document.form.changeamt.value=((document.form.pcash.value*1)-(document.form.totalamt.value*1)).toFixed(2);
		}
		
		function done()
		{
		opener.document.invoicesheet.cash.value=document.form.pcash.value;
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
	<th>Paid</th>
		<td nowrap>
			<cfinput type="text" name="pcash" id="pcash" value="0.00" validate="float" onKeyUp="calculatechange();">
		</td>
	</tr>
	<tr align="left">
		<th>Change</th>
		<td nowrap>
			<cfinput name="changeamt" id="changeamt" type="text" value="0.00" readonly>
		</td>
	</tr>
	
	<tr>
		<td colspan="100%" align="center">
			<input type="button" value="Save" onClick="return validation();done();">
			<input type="button" value="Cancel" onClick="javascript:window.close();">
		</td>
	</tr>
	</cfform>
</table>

</body>
</html>