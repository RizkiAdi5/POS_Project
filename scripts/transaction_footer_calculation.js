function validateAddItem()
{
	if(document.getElementById("itemno").value.indexOf("-1")==0 && document.form.service.value=='')
	{
		alert("Please select an item or a service.");
		document.getElementById("itemno").focus();
		return false;
	}
	if(document.getElementById("itemno").value.indexOf("-1")!=0 && document.form.service.value!='')
	{
		alert("You only can add one item or one service at a time.");
		document.form.itemno.focus();
		return false;
	}
	
	setTimeout('document.form.submit();',200);
	return false;
}

function clear_special_account_code(val)
{
	var sac=document.invoicesheet.special_account_code;
	
	if(val=="no")
	{
		sac.disabled=false;sac.style.backgroundColor="";
	}
	else
	{
		sac.value="";sac.style.backgroundColor="#FFFF99";
		sac.disabled=true;
	}
}

function permit()
{
	var sac=document.invoicesheet.special_account_code;
	
	if(sac.value != "")
	{
		var str=new String(sac.value);
		var str1=str.charAt(7);
		var str2=str.charAt(4);
		
		if(str.match(" "))
		{
			alert("Special Account Code Can Not Contain Any Spaces!");
			sac.select();
			return false;
		}
		else if(str.lastIndexOf(str1) != 7 || str1 == null || str1 == "" || str2 != "/")
		{
			alert("Please Enter Correct Special Account Code !");
			sac.select();
			return false;
		}
	}
	return true;
}

function getDiscountControl()
{
	var d1=document.invoicesheet.totaldisc1;
	var d2=document.invoicesheet.totaldisc2;
	var d3=document.invoicesheet.totaldisc3;
	var ttld=document.invoicesheet.totalamtdisc;
	
	try
	{
		if(isNaN(d1.value) || isNaN(d2.value) || isNaN(d3.value) || isNaN(ttld.value))
		{
			alert("The value is not a number. Please try again");
			
			if(isNaN(d1.value))
			{
				d1.value="";
			}
			else if(isNaN(d2.value))
			{
				d2.value="";
			}
			else if(isNaN(d3.value))
			{
				d3.value="";
			}
			else
			{	
				ttld.value="";
			}
			getDiscountControl();
		}
		else if((d1.value)>(document.invoicesheet.discountlimit.value*1))
		{
			alert("Discount is over Discount limit");

			d1.value="";
			getDiscountControl();

			
		}
		else if((d1.value+d2.value+d3.value)!=0)
		{
			ttld.readOnly=true;
			ttld.style.backgroundColor="#FFFF99";
			getDiscount();
		}
		else if((d1.value+d2.value+d3.value)==0 && window.event.srcElement.id!="totalamtdisc_id")
		{
			ttld.value=0;
			ttld.readOnly=false;
			ttld.style.backgroundColor="";
			getDiscount();
		}
		/*else if((d1.value+d2.value+d3.value)==0)
		{
			try
			{
				if(window.event.srcElement.id!="totalamtdisc_id")
				{
					alert(window.event.srcElement);
					ttld.value=0;
					ttld.readOnly=false;
					ttld.style.backgroundColor="";
					getDiscount();
				}
			}
			catch(err)
			{
				alert(err);getDiscount();
			}
		}*/
		else
		{
			if(window.event.srcElement.id=="totalamtdisc_id")
			{
				ttld.readOnly=false;
				ttld.style.backgroundColor="";
				getDiscount();
			}
		}
	}
	
	catch(err)
	{
		ttld.readOnly=false;
		ttld.style.backgroundColor="";
		getDiscount();
	}
	
	getCashCount();
}

function getDiscountControl2(){
	var d1=document.invoicesheet.totaldisc1;
	var d2=document.invoicesheet.totaldisc2;
	var d3=document.invoicesheet.totaldisc3;
	var ttld=document.invoicesheet.totalamtdisc;
	
	try
	{
		if(isNaN(d1.value) || isNaN(d2.value) || isNaN(d3.value) || isNaN(ttld.value))
		{
			alert("The value is not a number. Please try again");
			
			if(isNaN(d1.value))
			{
				d1.value="";
			}
			else if(isNaN(d2.value))
			{
				d2.value="";
			}
			else if(isNaN(d3.value))
			{
				d3.value="";
			}
			else
			{	
				ttld.value="";
			}
			getDiscountControl2();
		}
		else if((d1.value)>document.invoicesheet.discountlimit.value)
		{
			alert("Discount is over Discount limit");

			d1.value="";
			getDiscountControl();

			
		}

		else if((d1.value+d2.value+d3.value)!=0)
		{
			ttld.readOnly=true;
			ttld.style.backgroundColor="#FFFF99";
			getDiscount();
		}
		else if((d1.value+d2.value+d3.value)==0 && window.event.srcElement.id!="totalamtdisc_id")
		{
			ttld.value=0;
			ttld.readOnly=true;
			ttld.style.backgroundColor="#FFFF99";
			getDiscount();
		}
		else
		{
			if(window.event.srcElement.id=="totalamtdisc_id")
			{
				ttld.value=0;
				ttld.readOnly=true;
				ttld.style.backgroundColor="#FFFF99";
				getDiscount();
			}
		}
	}
	
	catch(err)
	{
		ttld.value=0;
		ttld.readOnly=true;
		ttld.style.backgroundColor="#FFFF99";
		getDiscount();
	}
	
	getCashCount();
}

function getDiscount()
{
	var subtotal=document.invoicesheet.subtotal.value;
	var d1=document.invoicesheet.totaldisc1.value;
	var d2=document.invoicesheet.totaldisc2.value;
	var d3=document.invoicesheet.totaldisc3.value;
	var ttld=document.invoicesheet.totalamtdisc.value;
	var totaldiscount=0;
	var temp=0;
	
	if((d1+d2+d3)!=0)
	{
		temp=(subtotal*d1/100).toFixed(fixnum);
		totaldiscount=temp;
		temp=(subtotal-totaldiscount).toFixed(fixnum);
		temp=(temp*d2/100).toFixed(fixnum);
		totaldiscount=(parseFloat(totaldiscount)+parseFloat(temp)).toFixed(fixnum);
		temp=(subtotal-totaldiscount).toFixed(fixnum);
		temp=(temp*d3/100).toFixed(fixnum);
		totaldiscount=(parseFloat(totaldiscount)+parseFloat(temp)).toFixed(fixnumdisc);
	}
	else
	{
		totaldiscount=ttld;
	}
	document.invoicesheet.totalamtdisc.value=totaldiscount;
	document.invoicesheet.viewNet.value=(subtotal-totaldiscount).toFixed(fixnum);//get Net amount
	getTaxControl();
}

function getTaxControl()
{
	var ptax=document.invoicesheet.pTax;
	var ttltax=document.invoicesheet.totalamttax;
	var stax=document.invoicesheet.selecttax.value;

	if(wpitemtax!='Y'){
		if(stax!="ZR" && stax!="NTAX" && stax!="ZPTAX" && stax!="ZSTAX")
		{
			if(isNaN(ptax.value) || isNaN(ttltax.value))
			{
				alert("The value is not a number. Please try again");
				if(isNaN(ptax.value)){
					ptax.value="";
					ttltax.value="0.00";
				}
				if(isNaN(ttltax.value)){
					ttltax.value="0.00";
				}
				//getTaxControl();
			}
			/*else if(ptax.value!=0)
			{
				ttltax.readOnly=true;
				ttltax.style.backgroundColor="#FFFF99";
				getTax();
			}*/
			else
			{
				ptax.readOnly=false;
				ptax.style.backgroundColor="";
				ttltax.readOnly=false;
				ttltax.style.backgroundColor="";
				getTax();
			}
		}
		else
		{
			ptax.value=0;//ptax.readOnly=true;
			//ptax.style.backgroundColor="#FFFF99";
			ttltax.value="0.00";//ttltax.readOnly=true;
			//ttltax.style.backgroundColor="#FFFF99";
			getTax();
		}
	}
	else{
		ptax.value=0;
		//getTax();
		getGrand();
	}
	
	getCashCount();
}

function getTax()
{
	var ptax=document.invoicesheet.pTax.value;
	var temp=0;
	var net=parseFloat(document.invoicesheet.viewNet.value);

	if(ptax!=0)
	{
		//temp=(net*ptax/100).toFixed(fixnum);
		//document.invoicesheet.totalamttax.value=temp;
		//Edit on 15-01-2009
		if(document.getElementById("taxincl").checked==true)
		{
			ptax=parseFloat(ptax);
			temp=((ptax/(100+ptax))*net).toFixed(fixnum);
			document.invoicesheet.totalamttax.value=temp;
		}
		else{
			temp=(net*ptax/100).toFixed(fixnum);
			document.invoicesheet.totalamttax.value=temp;
		}
	}
	//add this "else" condition for ptax at 240608
	else {
		//temp= 0;
		//document.invoicesheet.totalamttax.value=temp.toFixed(fixnum);
		temp=(net*ptax/100).toFixed(fixnum);
		document.invoicesheet.totalamttax.value=temp;
	}
	getGrand();
}

function getGrand()
{
	var ttltax=parseFloat(document.invoicesheet.totalamttax.value);
	var net=parseFloat(document.invoicesheet.viewNet.value);
	
	var dep=document.invoicesheet.deposit.value;
	var cash=document.getElementById("cash").value;
	var cheque=document.getElementById("cheque").value;
	var credit_card1=document.getElementById("credit_card1").value;
	var credit_card2=document.getElementById("credit_card1").value;
	var gift_voucher=document.getElementById("gift_voucher").value;
	var misc1=parseFloat(document.invoicesheet.mc1_bil.value);
	var misc2=parseFloat(document.invoicesheet.mc2_bil.value);
	var misc3=parseFloat(document.invoicesheet.mc3_bil.value);
	var misc4=parseFloat(document.invoicesheet.mc4_bil.value);
	var misc5=parseFloat(document.invoicesheet.mc5_bil.value);
	var misc6=parseFloat(document.invoicesheet.mc6_bil.value);
	var misc7=parseFloat(document.invoicesheet.mc7_bil.value);

	var grand=0;
	
	if(!isNaN(ttltax))
	{
		//grand=(ttltax+net).toFixed(fixnum);
		//Edit on 15-01-2009
		if(document.getElementById("taxincl").checked==true)
		{
			grand=net;
		}
		else{
			grand=ttltax+net;
		}
	}
	else if(net!=0)
	{
		grand=net;
	}
	
	if(hcomid=='mhsl_i' && tran =='RC'){
		var ttNBTtax=parseFloat(document.invoicesheet.xnbttax.value);	
		if(!isNaN(ttNBTtax))
		{
			grand=ttNBTtax+grand;
			
		}
	}
	
	if(!isNaN(misc1) && !isNaN(misc2) && !isNaN(misc3) && !isNaN(misc4) && !isNaN(misc5) && !isNaN(misc6) && !isNaN(misc7))
	{
	grand=(grand+misc1+misc2+misc3+misc4+misc5+misc6+misc7).toFixed(fixnum)
	}
	else
	{
	grand=(grand).toFixed(fixnum)

	}
	

	document.invoicesheet.viewGrand.value=grand;
	
	if(dep!="" && dep!=0)
	{
		grand=(grand-dep).toFixed(fixnum);
	}
	if(cash!="" && cash!=0)
	{
		grand=(grand-cash).toFixed(fixnum);
	}
	if(cheque!="" && cheque!=0)
	{
		grand=(grand-cheque).toFixed(fixnum);
	}
	if(credit_card1!="" && credit_card1!=0)
	{
		grand=(grand-credit_card1).toFixed(fixnum);
	}
	if(credit_card2!="" && credit_card2!=0)
	{
		grand=(grand-credit_card2).toFixed(fixnum);
	}
	if(gift_voucher!="" && gift_voucher!=0)
	{
		grand=(grand-gift_voucher).toFixed(fixnum);
	}
	
	document.invoicesheet.debt.value=grand;
	adjustgrand();
}

function getDepositCount()
{
	getDepositCount2();
}

function getNBTTaxControl(){
	var ptax=document.invoicesheet.pnbtTax;
	var ttltax=document.invoicesheet.xnbttax;
	
	if(isNaN(ptax.value) || isNaN(ttltax.value))
	{
		alert("The value is not a number. Please try again");
		if(isNaN(ptax.value)){
			ptax.value="";
			ttltax.value="0.00";
		}
		if(isNaN(ttltax.value)){
			ttltax.value="0.00";
		}
	}
	else if(ptax.value!=0)
	{
		ttltax.readOnly=true;
		ttltax.style.backgroundColor="#FFFF99";
		getNBTTax();
	}
	else
	{
		ptax.readOnly=false;
		ptax.style.backgroundColor="";
		ttltax.readOnly=false;
		ttltax.style.backgroundColor="";
		getNBTTax();
	}
}

function getNBTTax(){
	var ptax=document.invoicesheet.pnbtTax.value;
	var temp=0;
	var net=parseFloat(document.invoicesheet.viewNet.value);
	var ttltax=parseFloat(document.invoicesheet.totalamttax.value);
	var total=net+ttltax;

	if(ptax!=0)
	{
		temp=(total*ptax/100).toFixed(fixnum);
		document.invoicesheet.xnbttax.value=temp;
	}
	getGrand();
}