function getDiscountControl()
{
	var d1=document.form1.totaldisc1;
	var d2=document.form1.totaldisc2;
	var d3=document.form1.totaldisc3;
	var ttld=document.form1.totalamtdisc;
	
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
		else if((parseFloat(d1.value)+parseFloat(d2.value)+parseFloat(d3.value))!=0)
		{
			ttld.readOnly=true;
			ttld.style.backgroundColor="#FFFF99";
			getDiscount();
		}
		else if((parseFloat(d1.value)+parseFloat(d2.value)+parseFloat(d3.value))==0 && window.event.srcElement.id!="totalamtdisc")
		{
			ttld.value=0;
			ttld.readOnly=false;
			ttld.style.backgroundColor="";
			getDiscount();
		}
		else
		{
			if(window.event.srcElement.id=="totalamtdisc")
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
	
}

function getDiscountControl2()
{
	var d1=document.form1.dispec1;
	var d2=document.form1.dispec2;
	var d3=document.form1.dispec3;
	var ttld=document.form1.discamt;
	
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
		else if((parseFloat(d1.value)+parseFloat(d2.value)+parseFloat(d3.value))!=0)
		{
			ttld.readOnly=true;
			ttld.style.backgroundColor="#FFFF99";
			getDiscount2();
		}
		else if((parseFloat(d1.value)+parseFloat(d2.value)+parseFloat(d3.value))==0 && window.event.srcElement.id!="discamt_id")
		{
			ttld.value=0;
			ttld.readOnly=true;
			ttld.style.backgroundColor="#FFFF99";
			getDiscount2();
		}
		else
		{
			if(window.event.srcElement.id=="discamt_id")
			{
				ttld.readOnly=true;
				ttld.style.backgroundColor="#FFFF99";
				getDiscount2();
			}
		}
	}
	
	catch(err)
	{
		ttld.readOnly=true;
		ttld.style.backgroundColor="#FFFF99";
		getDiscount2();
	}
	
}

function getDiscount()
{
	var subtotal=document.form1.subtotal.value;
	var d1=document.form1.totaldisc1.value;
	var d2=document.form1.totaldisc2.value;
	var d3=document.form1.totaldisc3.value;
	var ttld=document.form1.totalamtdisc.value;
	var totaldiscount=0;
	var temp=0;
	
	if((parseFloat(d1)+parseFloat(d2)+parseFloat(d3))!=0)
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
	document.form1.totalamtdisc.value=totaldiscount;
	getTax();
}

function getDiscount2()
{
	var subtotal=document.form1.amt.value;
	var d1=document.form1.dispec1.value;
	var d2=document.form1.dispec2.value;
	var d3=document.form1.dispec3.value;
	var ttld=document.form1.discamt.value;
	var totaldiscount=0;
	var temp=0;
	
	if((parseFloat(d1)+parseFloat(d2)+parseFloat(d3))!=0)
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
	document.form1.discamt.value=totaldiscount;
	getTax2();
}

function checkqty(){
	if(parseFloat(document.form1.qty.value) > 0){
		var temp_amt = parseFloat(document.form1.qty.value) * parseFloat(document.form1.price.value);
		document.form1.amt.value = temp_amt.toFixed(2); 
		document.form1.amt.readOnly =true;
		document.form1.amt.style.backgroundColor="#FFFF99";
			
	}else if(parseFloat(document.form1.qty.value) == 0){
		document.form1.amt.value = 0;
		document.form1.amt.readOnly =false;
	}
	getDiscount2();
	getTax2();
}

function getTax(){
	var subtotal=parseFloat(document.form1.subtotal.value);
	var totaldiscount=parseFloat(document.form1.totalamtdisc.value);
	var ptax=parseFloat(document.form1.pTax.value);
	subtotal=subtotal-totaldiscount;
	document.form1.viewNet.value = parseFloat(subtotal);
	var temp=0;
	temp=(subtotal*ptax/100).toFixed(2);
	document.form1.viewGrand.value = (parseFloat(subtotal) + parseFloat(temp)).toFixed(2);
	document.form1.totalamttax.value=temp;
}

function getTax2(){
	var subtotal=parseFloat(document.form1.amt.value);
	var totaldiscount=parseFloat(document.form1.discamt.value);
	var ptax=parseFloat(document.form1.taxpec1.value);
	subtotal=subtotal-totaldiscount;
	var temp=0;
	temp=(subtotal*ptax/100).toFixed(2);
	document.form1.itemtotalamt.value = (parseFloat(subtotal) + parseFloat(temp)).toFixed(2);
	document.form1.taxamt_bil.value=temp;
}

function getTax1(){
	if(parseFloat(document.form1.qty.value) > 0){
		var temp_amt = parseFloat(document.form1.qty.value) * parseFloat(document.form1.price.value);
		document.form1.amt.value = temp_amt.toFixed(2); 
		document.form1.amt.readOnly =true;
			
	}else if(parseFloat(document.form1.qty.value) == 0){
		document.form1.amt.value = 0;
		document.form1.amt.readOnly =false;
	}
	
	getDiscount();
	var subtotal=parseFloat(document.form1.amt.value);
	var totaldiscount=parseFloat(document.form1.discamt.value);
	var ptax=parseFloat(document.form1.taxpec1.value);
	subtotal=subtotal-totaldiscount;
	var temp=0;
	
	temp=(subtotal*ptax/100).toFixed(2);
	document.form1.itemtotalamt.value = (parseFloat(subtotal) + parseFloat(temp)).toFixed(2);
	
	document.form1.taxamt_bil.value=temp;
}

function getTaxControl()
{
	var ptax=document.form1.pTax;
	var ttltax=document.form1.taxamt_bil;
	var stax=document.form1.selecttax.value;

	if(stax!="ZR" && stax!="NTAX" && stax!="ZPTAX" && stax!="ZSTAX")
	{
		//ptax.value=gstvalue;
	}
	else{
		ptax.value=0;
	}
	getTax();
}