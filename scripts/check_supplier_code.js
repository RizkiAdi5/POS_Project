function validate(code1,code2,type)
{
	var codefr = new String(code1);
	var codeto = new String(code2);
	var entercode = new String(document.SupplierForm.custno.value);	
	if (type == "1")
	{
	var seperated_entercode = entercode.split(/[/]/g);
	var seperated_entercode_part1 = seperated_entercode[0];
	var seperated_entercode_part2 = seperated_entercode[1];
	var codepatern = new RegExp(/[\w]{4}[/][\w]{3}/g);
	}
	else
	{
	var seperated_entercode_part1 = entercode.substring(0,4);
	var seperated_entercode_part2 = entercode.substring(4,8);
	var codepatern = new RegExp(/[\w]{4}[\w]{4}/g);
		
	}
	var check = new Boolean(true);
	var counter = codefr.length;
	
	if(document.SupplierForm.custno.value=="")
	{
		alert("Your Supplier's No. cannot be blank.");
		document.SupplierForm.custno.focus();
		return false;
	}
		
	if(entercode.match(codepatern) == null)
	{
		alert("Wrong Format!");
		document.SupplierForm.custno.focus();
		return false;
	}
	else
	{
		if(seperated_entercode_part2 == "000")
		{
			alert("Your Supplier Code's Surfix Can Not Contain 000 !");
			document.SupplierForm.custno.focus();
			return false;
		}
		
		for(var start = 0; start <= counter; start++)
		{
			if((seperated_entercode_part1.charAt(start) >= codefr.charAt(start)) && (seperated_entercode_part1.charAt(start) <= codeto.charAt(start)))
			{
				check = true;
			}
			else
			{
				check = false;
				break;
			}
		}

		if(check == false)
		{
			alert("Your Supplier Code Is Out of Range "+codefr+"---"+codeto+" !");
			document.SupplierForm.custno.focus();
			return false;
		}
		else
		{
			return true;
		}
	}
	return true;
}
/*
function validate()
{
	if(document.CustomerForm.custno.value=="")
	{
		alert("Your Customer's No. cannot be blank.");
		document.CustomerForm.custno.focus();
		return false;
	}
	//else if(document.CustomerForm.Name.value=='')
	//{
	//	alert("Your Customer's Company Name cannot be blank.");
	//	document.CustomerForm.Name.focus();
	//	return false;
	//}
	//else if(document.CustomerForm.Add1.value=='')
	//{
	//	alert("Your Customer's Address cannot be blank.");
	//	document.CustomerForm.Add1.focus();
	//	return false;			
	//}
	
	var codefr = new String("#getcodepatern.debtorfr#");
	var codeto = new String("#getcodepatern.debtorto#");
	var entercode = new String(document.CustomerForm.custno.value);	
	var seperated_codefr = codefr.split(/[/]/g);
	var seperated_codefr_part1 = seperated_codefr[0];
	var seperated_codefr_part2 = seperated_codefr[1];
	var seperated_codeto = codeto.split(/[/]/g);
	var seperated_codeto_part1 = seperated_codeto[0];
	var seperated_codeto_part2 = seperated_codeto[1];
	var seperated_entercode = entercode.split(/[/]/g);
	var seperated_entercode_part1 = seperated_entercode[0];
	var seperated_entercode_part2 = seperated_entercode[1];
	var codepatern = new RegExp(/\w{4}[/]\w{3}/g);
	var check = new Boolean(true);
	var counter_prefix = seperated_codefr_part1.length;
	var counter_surfix = seperated_codefr_part2.length;
	
	if(entercode.match(codepatern) == null)
	{
		alert("Wrong Format!");
		document.CustomerForm.custno.focus();
		return false;
	}
	else
	{
		for(var start = 0; start <= counter_prefix; start++)
		{
			if((seperated_entercode_part1.charAt(start) >= seperated_codefr_part1.charAt(start)) && (seperated_entercode_part1.charAt(start) <= seperated_codeto_part1.charAt(start)))
			{
				check = true;
			}
			else
			{
				check = false;
				break;
			}
		}
		
		if(check == true)
		{
			for(var start = 0; start <= counter_surfix; start++)
			{
				if((seperated_entercode_part2.charAt(start) >= seperated_codefr_part2.charAt(start)) && (seperated_entercode_part2.charAt(start) <= seperated_codeto_part2.charAt(start)))
				{
					check = true;
				}
				else
				{
					check = false;
					break;
				}
			}
		}

		if(check == false)
		{
			alert("Your Customer Code Is Out of Range "+codefr+"---"+codeto+" !");
			document.CustomerForm.custno.focus();
			return false;
		}
		else
		{
			return true;
		}
	}
	return true;
}
*/