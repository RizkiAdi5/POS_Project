function refresh_from()
{
	var value_f = document.copy1.ff.value;
	changeType("ff_type",value_f);
	setOption();
	usrCtrl();
}

function refresh_to()
{
	var value_t = document.copy1.ft.value;
	changeLabelText(value_t);
	changeType("ft_type",value_t);
	changeBillNo(value_t);
}

function changeLabelText(BILL_ID)
{
	var to_type = document.getElementById("ft_type").value;
	var temp = "";

	if(BILL_ID == "RC" || BILL_ID == "PO" || BILL_ID == "PR")
	{
    	document.getElementById("L1").innerHTML = "Supp.No. From";
		document.getElementById("L2").innerHTML = "Supp.No. From";
		temp ="s";
	}
	else
	{
		document.getElementById("L1").innerHTML = "Cust.No. From";
		document.getElementById("L2").innerHTML = "Cust.No. From";
		temp ="c";
	}
	
	if(to_type != "")
	{
		if(to_type == "RC" || to_type == "PR" || to_type == "PO")
		{
			if(temp == "c")
			{
				setOption2("c");
			}
		}
		else
		{
			if(temp == "s")
			{
				setOption2("s");
			}
		}
	}
	else
	{
		setOption2(temp);
	}
	
}

function changeType(ID,VALUE)
{
	document.getElementById(ID).value = VALUE;
}

function changeBillNo(VALUE)
{
	<cfloop from="1" to="#listlen(billnolist)#" index="i" step="+2">
		if(VALUE == "#listgetat(billnolist,i)#")
		{
			document.getElementById("ft_refnofrom").value = "#listgetat(billnolist,i+1)#";
		}
	</cfloop>
}

function setOption()
{
	copy1.ff_refnofrom.length = 1;
	copy1.ff_refnofrom.selectedIndex = 0;
	
	copy1.ff_refnoto.length = 1;
	copy1.ff_refnoto.selectedIndex = 0;
	
	choice = copy1.ff.options[copy1.ff.selectedIndex].value;
	<cfloop index="count" from="1" to="#listlen(bill)#" step="+2">

	if (choice == "#listgetat(bill,count)#")
	{
	<cfloop index="x" From="1" to="#Evaluate('Refno#listgetat(bill,count)#.recordcount')#">
	(copy1.ff_refnofrom.length)++;
	copy1.ff_refnofrom.options[copy1.ff_refnofrom.length - 1].text  = "#Evaluate('Refno#listgetat(bill,count)#.rtext[x]')#";
	copy1.ff_refnofrom.options[copy1.ff_refnofrom.length - 1].value = "#Evaluate('Refno#listgetat(bill,count)#.refno[x]')#";
	
	(copy1.ff_refnoto.length)++;
	copy1.ff_refnoto.options[copy1.ff_refnoto.length - 1].text  = "#Evaluate('Refno#listgetat(bill,count)#.rtext[x]')#";
	copy1.ff_refnoto.options[copy1.ff_refnoto.length - 1].value = "#Evaluate('Refno#listgetat(bill,count)#.refno[x]')#";
	</cfloop>
	}
	</cfloop>
}

function setOption2(chosen)
{
	if(chosen == "c")
	{
		copy1.f_no_from.length = 1;
		copy1.f_no_from.selectedIndex = 0;
		copy1.f_no_to.length = 1;
		copy1.f_no_to.selectedIndex = 0;
		
		<cfloop query="get_cust">
			(copy1.f_no_from.length)++;
			(copy1.f_no_to.length)++;
			
			copy1.f_no_from.options[copy1.f_no_from.length - 1].text  = "#ctext#";
			copy1.f_no_from.options[copy1.f_no_from.length - 1].value = "#customerno#";
			
			copy1.f_no_to.options[copy1.f_no_to.length - 1].text  = "#ctext#";
			copy1.f_no_to.options[copy1.f_no_to.length - 1].value = "#customerno#";
		</cfloop>
	}
	else if(chosen == "s")
	{
		copy1.f_no_from.length = 1;
		copy1.f_no_from.selectedIndex = 0;
		copy1.f_no_to.length = 1;
		copy1.f_no_to.selectedIndex = 0;
		
		<cfloop query="get_supp">
			(copy1.f_no_from.length)++;
			(copy1.f_no_to.length)++;
			
			copy1.f_no_from.options[copy1.f_no_from.length - 1].text  = "#customerno#" +"-"+ "#name#"+" "+"#name2#";
			copy1.f_no_from.options[copy1.f_no_from.length - 1].value = "#customerno#";
			
			copy1.f_no_to.options[copy1.f_no_to.length - 1].text  = "#customerno#"+"-"+ "#name#"+" "+"#name2#";
			copy1.f_no_to.options[copy1.f_no_to.length - 1].value = "#customerno#";
		</cfloop>
	}
}

function usrCtrl()
{
	var getR_f = document.copy1.ff_refnofrom.value;
	var getR_t = document.copy1.ff_refnoto.value;
	
	var getC_f = document.copy1.f_no_from;
	var getC_t = document.copy1.f_no_to;
	
	getC_f.disabled = false;
	getC_t.disabled = false;
	
	if(getR_f != "" && getR_t != "")
	{
		if(getR_f == getR_t)
		{
			getC_f.disabled = true;
			getC_t.disabled = true;
		}
	}
}
