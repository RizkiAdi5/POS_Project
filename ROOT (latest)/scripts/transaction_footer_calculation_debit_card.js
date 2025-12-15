function getDebit_cardCount()
{
	var debit_card=document.getElementById("debit_card").value;
	var cash=!isNaN(parseFloat(document.getElementById("cash").value)) ? parseFloat(document.getElementById("cash").value) : 0;
	var cheque=!isNaN(parseFloat(document.getElementById("cheque").value)) ? parseFloat(document.getElementById("cheque").value) : 0;
	var cashcd=!isNaN(parseFloat(document.getElementById("cashcd").value)) ? parseFloat(document.getElementById("cashcd").value) : 0;

	var credit_card1=!isNaN(parseFloat(document.getElementById("credit_card1").value)) ? parseFloat(document.getElementById("credit_card1").value) : 0;
	var credit_card2=!isNaN(parseFloat(document.getElementById("credit_card2").value)) ? parseFloat(document.getElementById("credit_card2").value) : 0;
	var telegraph_transfer=!isNaN(parseFloat(document.getElementById("telegraph_transfer").value)) ? parseFloat(document.getElementById("telegraph_transfer").value) : 0;
	var gift_voucher=!isNaN(parseFloat(document.getElementById("gift_voucher").value)) ? parseFloat(document.getElementById("gift_voucher").value) : 0;
	var dep=!isNaN(parseFloat(document.getElementById("deposit").value)) ? parseFloat(document.getElementById("deposit").value) : 0;
	var grand=parseFloat(document.getElementById("viewGrand").value);
	var debt=0;
	
	if(debit_card=="")
	{
		debt=(grand-cash-cheque-cashcd-credit_card1-telegraph_transfer-gift_voucher-dep-credit_card2).toFixed(fixnum);
	}
	else if(isNaN(debit_card))
	{
		alert("The value is not a number. Please try again");
		document.getElementById("debit_card").value=debit_card.substr(0,debit_card.length-1);
		debit_card=!isNaN(parseFloat(document.getElementById("debit_card").value)) ? parseFloat(document.getElementById("debit_card").value) : 0;
		debt=(grand-cash-cheque-cashcd-credit_card1-credit_card2-telegraph_transfer-gift_voucher-dep-debit_card).toFixed(fixnum);
	}
	else
	{
		debt=(grand-cash-cheque-cashcd-credit_card1-credit_card2-telegraph_transfer-gift_voucher-dep-debit_card).toFixed(fixnum);
	}
	
	document.getElementById("debt").value=debt;
}