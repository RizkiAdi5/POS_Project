function remove_others1()
{
	document.getElementById("refno_from3").value="";
	document.getElementById("refno_from4").value="";
	document.getElementById("refno_from5").value="";
	document.getElementById("refno_from6").value="";
}

function remove_others2()
{
	document.getElementById("refno_from1").value="";
	document.getElementById("refno_from2").value="";
	document.getElementById("refno_from5").value="";
	document.getElementById("refno_from6").value="";
}

function remove_others3()
{
	document.getElementById("refno_from1").value="";
	document.getElementById("refno_from2").value="";
	document.getElementById("refno_from3").value="";
	document.getElementById("refno_from4").value="";
}

function check_refno_entry()
{
	if
	(
		document.getElementById("refno_from1").value==""&&
		document.getElementById("refno_from2").value==""&&
		document.getElementById("refno_from3").value==""&&
		document.getElementById("refno_from4").value==""&&
		document.getElementById("refno_from5").value==""&&
		document.getElementById("refno_from6").value==""
	)
	{
		alert("Please Fill In The Reference No !");
		return false;
	}
	else
	{
		return true;
	}
}