<html>
<head>
<title>Product Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

<cfquery name="getdealer_menu" datasource="#dts#">
	select * from dealer_menu
</cfquery>
</head>

<script language="JavaScript">
<!--- 	document.form.Tick.value = toString(val(document.form.Tick.value)+1); --->

function selectlist(custno,fieldtype){

			for (var idx=0;idx<document.getElementById(fieldtype).options.length;idx++)
			{
        	if (custno==document.getElementById(fieldtype).options[idx].value)
			{
            document.getElementById(fieldtype).options[idx].selected=true;
        	}
    		}

									}

function TickCate()	{
  if(document.form.cbCate.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbCate.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickSizeID()	{
  if(document.form.cbSizeID.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbSizeID.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickCostCode()	{
  if(document.form.cbCostCode.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbCostCode.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickColorID()	{
  if(document.form.cbColorID.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbColorID.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickGroup()	{
  if(document.form.cbGroup.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbGroup.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickShelf()	{
  if(document.form.cbShelf.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbShelf.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickMItemNo()	{
  if(document.form.cbMItemNo.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbMItemNo.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickQtyBF()	{
  if(document.form.cbQtyBF.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbQtyBF.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickQty2()	{
  if(document.form.cbQty2.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbQty2.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickBrand()	{
  if(document.form.cbBrand.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbBrand.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickUnit()	{
  if(document.form.cbUnit.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbUnit.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickQty3()	{
  if(document.form.cbQty3.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbQty3.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickSupp()	{
  if(document.form.cbSupp.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbSupp.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickCost()	{
  if(document.form.cbCost.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbCost.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickQty4()	{
  if(document.form.cbQty4.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbQty4.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickPacking()	{
  if(document.form.cbPacking.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbPacking.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickPrice()	{
  if(document.form.cbPrice.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbPrice.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickQty5()	{
  if(document.form.cbQty5.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbQty5.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickMinimum()	{
  if(document.form.cbMinimum.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbMinimum.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickPrice2()	{
  if(document.form.cbPrice2.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbPrice2.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickQty6()	{
  if(document.form.cbQty6.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbQty6.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickMaximum()	{
  if(document.form.cbMaximum.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbMaximum.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickPrice3()	{
  if(document.form.cbPrice3.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbPrice3.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickQOH()	{
  if(document.form.cbQOH.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbQOH.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickReorder()	{
  if(document.form.cbReorder.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbReorder.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickfcurrcode()	{
  if(document.form.cbfcurrcode.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbfcurrcode.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickfucost()	{
  if(document.form.cbfucost.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbfucost.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickfprice()	{
  if(document.form.cbfprice.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbfprice.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickPrice_Min()	{
  if(document.form.cbPrice_Min.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbPrice_Min.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function TickCostformula()	{
  if(document.form.cbcostformula.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbcostformula.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickcreatedate()	{
  if(document.form.cbcredate.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbcredate.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem1()	{
  if(document.form.cbrem1.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem1.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem2()	{
  if(document.form.cbrem2.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem2.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem3()	{
  if(document.form.cbrem3.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem3.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem4()	{
  if(document.form.cbrem4.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem4.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem5()	{
  if(document.form.cbrem5.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem5.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem6()	{
  if(document.form.cbrem6.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem6.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem7()	{
  if(document.form.cbrem7.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem7.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem8()	{
  if(document.form.cbrem8.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem8.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem9()	{
  if(document.form.cbrem9.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem9.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem10()	{
  if(document.form.cbrem10.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem10.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem11()	{
  if(document.form.cbrem11.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem11.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem12()	{
  if(document.form.cbrem12.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem12.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem13()	{
  if(document.form.cbrem13.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem13.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem14()	{
  if(document.form.cbrem14.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem14.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem15()	{
  if(document.form.cbrem15.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem15.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem16()	{
  if(document.form.cbrem16.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem16.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem17()	{
  if(document.form.cbrem17.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem17.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem18()	{
  if(document.form.cbrem18.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem18.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem19()	{
  if(document.form.cbrem19.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem19.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function Tickrem20()	{
  if(document.form.cbrem20.checked) {
    if(eval(document.form.Tick.value)<=4){
	  document.form.Tick.value = eval(document.form.Tick.value) + 1;
	}
	else{
	  alert("You Are Over 5 Fields.");
	  document.form.cbrem20.checked = false;
	}
  }
  else {
	document.form.Tick.value = eval(document.form.Tick.value) - 1;
  }
  return true;
}

function ClearAll()	{
  document.form.Tick.value = "0";
  document.form.cbCate.checked = false;
  document.form.cbSizeID.checked = false;
  document.form.cbCostCode.checked = false;
  document.form.cbColorID.checked = false;
  document.form.cbGroup.checked = false;
  document.form.cbShelf.checked = false;
  document.form.cbMItemNo.checked = false;
  document.form.cbQtyBF.checked = false;
  document.form.cbQty2.checked = false;
  document.form.cbBrand.checked = false;
  document.form.cbUnit.checked = false;
  document.form.cbQty3.checked = false;
  document.form.cbSupp.checked = false;
  document.form.cbCost.checked = false;
  document.form.cbQty4.checked = false;
  document.form.cbPacking.checked = false;
  document.form.cbPrice.checked = false;
  document.form.cbQty5.checked = false;
  document.form.cbMinimum.checked = false;
  document.form.cbPrice2.checked = false;
  document.form.cbQty6.checked = false;
  document.form.cbMaximum.checked = false;
  document.form.cbPrice3.checked = false;
  document.form.cbReorder.checked = false;
  document.form.cbfcurrcode.checked = false;
  document.form.cbfucost.checked = false;
  document.form.cbfprice.checked = false;
  document.form.cbPrice_Min.checked = false;
    document.form.cbQOH.checked = false;
	document.form.cbcostformula.checked = false;
	document.form.cbcredate.checked = false;
	document.form.cbrem1.checked = false;
	document.form.cbrem2.checked = false;
	document.form.cbrem3.checked = false;
	document.form.cbrem4.checked = false;
	document.form.cbrem5.checked = false;
	document.form.cbrem6.checked = false;
	document.form.cbrem7.checked = false;
	document.form.cbrem8.checked = false;
	document.form.cbrem9.checked = false;
	document.form.cbrem10.checked = false;
	document.form.cbrem11.checked = false;
	document.form.cbrem12.checked = false;
	document.form.cbrem13.checked = false;
	document.form.cbrem14.checked = false;
	document.form.cbrem15.checked = false;
	document.form.cbrem16.checked = false;
	document.form.cbrem17.checked = false;
	document.form.cbrem18.checked = false;
	document.form.cbrem19.checked = false;
	document.form.cbrem20.checked = false;

  return true;
}

// begin: product search
function getProduct(type){
	if(type == 'productto'){
		var inputtext = document.form.searchitemto.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult);

	}else{
		var inputtext = document.form.searchitemfr.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult2);
	}
}

function getProductResult(itemArray){
	DWRUtil.removeAllOptions("productto");
	DWRUtil.addOptions("productto", itemArray,"KEY", "VALUE");
}

function getProductResult2(itemArray){
	DWRUtil.removeAllOptions("productfrom");
	DWRUtil.addOptions("productfrom", itemArray,"KEY", "VALUE");
}
// end: product search

</script>

<cfquery name="getitem" datasource="#dts#">
  select itemno, desp from icitem order by itemno
</cfquery>
<cfquery name="getcate" datasource="#dts#">
  select * from iccate order by cate
</cfquery>
<cfquery name="getsizeid" datasource="#dts#">
  select sizeid, desp from icsizeid order by sizeid
</cfquery>
<cfquery name="getcostcode" datasource="#dts#">
  select costcode, desp from iccostcode order by costcode
</cfquery>
<cfquery name="getcolorid" datasource="#dts#">
  select colorid, desp from iccolorid order by colorid
</cfquery>
<cfquery name="getshelf" datasource="#dts#">
  select shelf, desp from icshelf order by shelf
</cfquery>
<cfquery name="getgroup" datasource="#dts#">
  select wos_group, desp from icgroup order by wos_group
</cfquery>
<cfquery name="getgsetup" datasource='#dts#'>
  Select * from gsetup
</cfquery>

<body>
<h1 align="center">Product Listing</h1>
<cfoutput>
	<h4>
		<cfif getpin2.h1310 eq 'T'><a href="icitem2.cfm?type=Create">Creating a New Item</a> </cfif>
		<cfif getpin2.h1320 eq 'T'>|| <a href="icitem.cfm?">List all Item</a> </cfif>
		<cfif getpin2.h1330 eq 'T'>|| <a href="s_icitem.cfm?type=icitem">Search For Item</a> </cfif>
		<cfif getpin2.h1340 eq 'T'>|| <a href="p_icitem.cfm">Item Listing</a> </cfif>
		|| <a href="icitem_setting.cfm">More Setting</a>

	</h4>
</cfoutput>

<cfform action="l_icitem.cfm" name="form" method="post" target="_blank">
<input type="hidden" name="fromto" id="fromto" value="" />
  <input type="hidden" name="Tick" value="0">
  <table border="0" align="center" width="90%" class="data">
  <tr>
		<th>Report Format</th>
		<td colspan="3">
			<input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">EXCEL DEFAULT
		</td>
	</tr>
  <tr>
  <th>Without Discountinued Item</th>
  <td><input type="checkbox" name="cbdiscountinue" id="cbdiscountinue" value="1"></td>
  </tr>
    <tr>
      <th width="20%">Product</th>
      <td width="5%"><div align="center">From</div></td>
      <td colspan="6"><select name="productfrom">
          <option value="">Choose a product</option>
          <cfoutput query="getitem">
            <option value="#itemno#">#itemno#
              - #desp#</option>
          </cfoutput>
        </select>
          <cfif getgsetup.filterall eq "1">
          <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('finditem');" />&nbsp;
            <input type="text" name="searchitemfr" onKeyUp="getProduct('productfrom');">
          </cfif>
      </td>
    </tr>
    <tr>
      <th>Product</th>
      <td><div align="center">To</div></td>
      <td colspan="6" nowrap><select name="productto">
          <option value="">Choose a product</option>
          <cfoutput query="getitem">
            <option value="#itemno#">#itemno#
              - #desp#</option>
          </cfoutput>
        </select>
          <cfif getgsetup.filterall eq "1">
           <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('finditem');" />&nbsp;
            <input type="text" name="searchitemto" onKeyUp="getProduct('productto');">
          </cfif>
      </td>
    </tr>
    <tr>
      <td colspan="8">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="8"><div align="center">
          <h4><font color="#FF3333">Please Tick 5 Fields To Display In The Listing</font></h4>
      </div></td>
    </tr>
    <!---     <tr>
      <td colspan="8"><hr></td>
    </tr> --->
    <tr>
      <th width="20%"><cfoutput>#getgsetup.lCATEGORY#</cfoutput></th>
      <td width="5%"><div align="center">From</div></td>
      <td width="20%"><select name="Catefrom">
          <option value="">Choose a <cfoutput>#getgsetup.lCATEGORY#</cfoutput></option>
          <cfoutput query="getcate">
            <option value="#cate#">#cate# - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><div align="right">To</div></td>
      <td width="20%"><select name="Cateto">
          <option value="">Choose a <cfoutput>#getgsetup.lCATEGORY#</cfoutput></option>
          <cfoutput query="getcate">
            <option value="#cate#">#cate#
              - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><input type="checkbox" name="cbCate" value="checkbox" onClick="javascript:TickCate()"></td>
    </tr>
    <tr>
      <td colspan="8"><hr></td>
    </tr>
    <tr>
      <th width="20%"><cfoutput>#getgsetup.lSIZE#</cfoutput></th>
      <td width="5%"><div align="center">From</div></td>
      <td width="20%"><select name="sizeidfrom">
          <option value="">Choose a <cfoutput>#getgsetup.lSIZE#</cfoutput></option>
          <cfoutput query="getsizeid">
            <option value="#sizeid#">#sizeid#
              - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><div align="right">To</div></td>
      <td width="20%"><select name="sizeidto">
          <option value="">Choose a <cfoutput>#getgsetup.lSIZE#</cfoutput></option>
          <cfoutput query="getsizeid">
            <option value="#sizeid#">#sizeid#
              - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><input type="checkbox" name="cbSizeID" value="checkbox" onClick="javascript:TickSizeID()"></td>
    </tr>
    <tr>
      <td colspan="8"><hr></td>
    </tr>
    <tr>
      <th width="20%"><cfoutput>#getgsetup.lRATING#</cfoutput></th>
      <td width="5%"><div align="center">From</div></td>
      <td width="20%"><select name="Costcodefrom">
          <option value="">Choose a <cfoutput>#getgsetup.lRATING#</cfoutput></option>
          <cfoutput query="getCostcode">
            <option value="#costcode#">#costcode#
              - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><div align="right">To</div></td>
      <td width="20%"><select name="Costcodeto">
          <option value="">Choose a <cfoutput>#getgsetup.lRATING#</cfoutput></option>
          <cfoutput query="getCostcode">
            <option value="#costcode#">#costcode#
              - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><input type="checkbox" name="cbCostCode" value="checkbox" onClick="javascript:TickCostCode()"></td>
    </tr>
    <tr>
      <td colspan="8"><hr></td>
    </tr>
    <tr>
      <th width="20%"><cfoutput>#getgsetup.lMATERIAL#</cfoutput></th>
      <td width="5%"><div align="center">From</div></td>
      <td width="20%"><select name="coloridfrom">
          <option value="">Choose a <cfoutput>#getgsetup.lMATERIAL#</cfoutput></option>
          <cfoutput query="getcolorid">
            <option value="#colorid#">#colorid#
              - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><div align="right">To</div></td>
      <td width="20%"><select name="coloridto">
          <option value="">Choose a <cfoutput>#getgsetup.lMATERIAL#</cfoutput></option>
          <cfoutput query="getcolorid">
            <option value="#colorid#">#colorid#
              - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><input type="checkbox" name="cbColorID" value="checkbox" onClick="javascript:TickColorID()"></td>
    </tr>
    <tr>
      <td colspan="8"><hr></td>
    </tr>
    <tr>
      <th width="20%"><cfoutput>#getgsetup.lGROUP#</cfoutput></th>
      <td width="5%"><div align="center">From</div></td>
      <td width="20%"><select name="groupfrom">
          <option value="">Choose a <cfoutput>#getgsetup.lGROUP#</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#wos_group#">#wos_group#
              - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><div align="right">To</div></td>
      <td width="20%"><select name="groupto">
          <option value="">Choose a <cfoutput>#getgsetup.lGROUP#</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#wos_group#">#wos_group#
              - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><input type="checkbox" name="cbGroup" value="checkbox" onClick="javascript:TickGroup()"></td>
    </tr>
    <tr>
      <td colspan="8"><hr></td>
    </tr>
    <tr>
      <th width="20%"><cfoutput>#getgsetup.lMODEL#</cfoutput></th>
      <td width="5%"><div align="center">From</div></td>
      <td width="20%"><select name="shelffrom">
          <option value="">Choose a <cfoutput>#getgsetup.lMODEL#</cfoutput></option>
          <cfoutput query="getshelf">
            <option value="#shelf#">#shelf#
              - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><div align="right">To</div></td>
      <td width="20%"><select name="shelfto">
          <option value="">Choose a <cfoutput>#getgsetup.lMODEL#</cfoutput></option>
          <cfoutput query="getshelf">
            <option value="#shelf#">#shelf#
              - #desp#</option>
          </cfoutput>
      </select></td>
      <td width="5%"><input type="checkbox" name="cbShelf" value="checkbox" onClick="javascript:TickShelf()"></td>
    </tr>
    <tr>
      <td colspan="8"><hr></td>
    </tr>
    <tr>
      <th width="20%"><div align="right">Product Code</div></th>
      <td width="5%"><input type="checkbox" name="cbMItemNo" value="checkbox" onClick="javascript:TickMItemNo()"></td>
      <th width="20%"><div align="right">Qty B/F</div></th>
      <td width="5%"><input type="checkbox" name="cbQtyBF" value="checkbox" onClick="javascript:TickQtyBF()"></td>
      <th width="20%"><div align="right">Length</div></th>
      <td width="5%"><input type="checkbox" name="cbQty2" value="checkbox" onClick="javascript:TickQty2()"></td>
      <td width="12%" colspan="2"><div align="right">
          <input type="Button" name="ClearAllChkBox" value="Clear All Check Box" onClick="javascript:ClearAll()">
      </div></td>
    </tr>
    <tr>
      <th width="20%"><div align="right">Brand</div></th>
      <td width="5%"><input type="checkbox" name="cbBrand" value="checkbox" onClick="javascript:TickBrand()"></td>
      <th width="20%"><div align="right">Unit</div></th>
      <td width="5%"><input type="checkbox" name="cbUnit" value="checkbox" onClick="javascript:TickUnit()"></td>
      <th width="20%"><div align="right">Width</div></th>
      <td width="5%"><input type="checkbox" name="cbQty3" value="checkbox" onClick="javascript:TickQty3()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th width="20%"><cfif getpin2.h13C0 eq 'T'><div align="right">Supplier</div></cfif></th>
      <td width="5%"><cfif getpin2.h13C0 eq 'T'><input type="checkbox" name="cbSupp" value="checkbox" onClick="javascript:TickSupp()"></cfif></td>
      <th width="20%"><div align="right">Cost Price</div></th>
      <td width="5%"><input type="checkbox" name="cbCost" value="checkbox" onClick="javascript:TickCost()"></td>
      <th width="20%"><div align="right">Thickness</div></th>
      <td width="5%"><input type="checkbox" name="cbQty4" value="checkbox" onClick="javascript:TickQty4()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th width="20%"><div align="right">Packing</div></th>
      <td width="5%"><input type="checkbox" name="cbPacking" value="checkbox" onClick="javascript:TickPacking()"></td>
      <th width="20%"><div align="right">Selling Price</div></th>
      <td width="5%"><input type="checkbox" name="cbPrice" value="checkbox" onClick="javascript:TickPrice()"></td>
      <th width="20%"><div align="right">Weight / Length</div></th>
      <td width="5%"><input type="checkbox" name="cbQty5" value="checkbox" onClick="javascript:TickQty5()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th width="20%"><div align="right">Minimum Qty</div></th>
      <td width="5%"><input type="checkbox" name="cbMinimum" value="checkbox" onClick="javascript:TickMinimum()"></td>
      <th width="20%"><div align="right">Selling Price 2</div></th>
      <td width="5%"><input type="checkbox" name="cbPrice2" value="checkbox" onClick="javascript:TickPrice2()"></td>
      <th width="20%"><div align="right">Price / Weight</div></th>
      <td width="5%"><input type="checkbox" name="cbQty6" value="checkbox" onClick="javascript:TickQty6()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th width="20%"><div align="right">Maximum Qty</div></th>
      <td width="5%"><input type="checkbox" name="cbMaximum" value="checkbox" onClick="javascript:TickMaximum()"></td>
      <th width="20%"><div align="right">M. U. Price</div></th>
      <td width="5%"><input type="checkbox" name="cbPrice3" value="checkbox" onClick="javascript:TickPrice3()"></td>
      <th width="20%"><div align="right">Quantity On Hand</div></th>
      <td width="5%"><input type="checkbox" name="cbQOH" value="checkbox" onClick="javascript:TickQOH()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th width="20%"><div align="right">Reorder Qty</div></th>
      <td width="5%"><input type="checkbox" name="cbReorder" value="checkbox" onClick="javascript:TickReorder()"></td>
        <th width="20%"><div align="right">Foreign Currency</div></th>
    <td width="5%"><input type="checkbox" name="cbfcurrcode" value="checkbox" onClick="javascript:Tickfcurrcode()"></td>

      <th width="20%"><div align="right">Foreign Unit Cost</div></th>
      <td width="5%"><input type="checkbox" name="cbfucost" value="checkbox" onClick="javascript:Tickfucost()"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  		<th width="20%"><div align="right">Foreign Selling Price</div></th>
      <td width="5%"><input type="checkbox" name="cbfprice" value="checkbox" onClick="javascript:Tickfprice()"></td>

       <th width="20%"><div align="right">Created Date</div></th>
    <td width="5%"><input type="checkbox" name="cbcredate" value="checkbox" onClick="javascript:Tickcreatedate()"></td>
 <cfif getgsetup.gpricemin eq 1>
        <th width="20%"><div align="right">Min. Selling Price</div></th>
        <td width="5%"><input type="checkbox" name="cbPrice_Min" value="checkbox" onClick="javascript:TickPrice_Min()"></td>
        <cfelse>
        <th width="20%">&nbsp;</th>
        <td width="5%"><input type="checkbox" name="checkbox2" value="checkbox"></td>
      </cfif>
      </tr>
      <tr>
       <th width="20%"><div align="right">Cost Code</div></th>
        <td width="5%"><input type="checkbox" name="cbcostformula" value="checkbox" onClick="javascript:TickCostformula()"></td>
         <th width="20%"><div align="right">Remark 1</div></th>
        <td width="5%"><input type="checkbox" name="cbrem1" value="checkbox" onClick="javascript:Tickrem1()"></td>
         <th width="20%"><div align="right">Remark 2</div></th>
        <td width="5%"><input type="checkbox" name="cbrem2" value="checkbox" onClick="javascript:Tickrem2()"></td>

    <td width="12%"><cfoutput> </cfoutput></td>
    <td width="5%"></td>
  </tr>

   <tr>
       <th width="20%"><div align="right">Remark 3</div></th>
        <td width="5%"><input type="checkbox" name="cbrem3" value="checkbox" onClick="javascript:Tickrem3()"></td>
         <th width="20%"><div align="right">Remark 4</div></th>
        <td width="5%"><input type="checkbox" name="cbrem4" value="checkbox" onClick="javascript:Tickrem4()"></td>
         <th width="20%"><div align="right">Remark 5</div><div align="right"></div></th>
        <td width="5%"><input type="checkbox" name="cbrem5" value="checkbox" onClick="javascript:Tickrem5()"></td>

    <td width="12%"><cfoutput> </cfoutput></td>
    <td width="5%"></td>
  </tr>

  <tr>
       <th width="20%"><div align="right">Remark 6</div></th>
        <td width="5%"><input type="checkbox" name="cbrem6" value="checkbox" onClick="javascript:Tickrem6()"></td>
         <th width="20%"><div align="right">Remark 7</div></th>
        <td width="5%"><input type="checkbox" name="cbrem7" value="checkbox" onClick="javascript:Tickrem7()"></td>
         <th width="20%"><div align="right">Remark 8</div><div align="right"></div></th>
        <td width="5%"><input type="checkbox" name="cbrem8" value="checkbox" onClick="javascript:Tickrem8()"></td>

    <td width="12%"><cfoutput> </cfoutput></td>
    <td width="5%"></td>
  </tr>

  <tr>
       <th width="20%"><div align="right">Remark 9</div></th>
        <td width="5%"><input type="checkbox" name="cbrem19" value="checkbox" onClick="javascript:Tickrem9()"></td>
         <th width="20%"><div align="right">Remark 10</div></th>
        <td width="5%"><input type="checkbox" name="cbrem10" value="checkbox" onClick="javascript:Tickrem10()"></td>
         <th width="20%"><div align="right">Remark 11</div><div align="right"></div></th>
        <td width="5%"><input type="checkbox" name="cbrem11" value="checkbox" onClick="javascript:Tickrem11()"></td>

    <td width="12%"><cfoutput> </cfoutput></td>
    <td width="5%"></td>
  </tr>

  <tr>
       <th width="20%"><div align="right">Remark 12</div></th>
        <td width="5%"><input type="checkbox" name="cbrem12" value="checkbox" onClick="javascript:Tickrem12()"></td>
         <th width="20%"><div align="right">Remark 13</div></th>
        <td width="5%"><input type="checkbox" name="cbrem13" value="checkbox" onClick="javascript:Tickrem13()"></td>
         <th width="20%"><div align="right">Remark 14</div><div align="right"></div></th>
        <td width="5%"><input type="checkbox" name="cbrem14" value="checkbox" onClick="javascript:Tickrem14()"></td>

    <td width="12%"><cfoutput> </cfoutput></td>
    <td width="5%"></td>
  </tr>

  <tr>
       <th width="20%"><div align="right">Remark 15</div></th>
        <td width="5%"><input type="checkbox" name="cbrem15" value="checkbox" onClick="javascript:Tickrem15()"></td>
         <th width="20%"><div align="right">Remark 16</div></th>
        <td width="5%"><input type="checkbox" name="cbrem16" value="checkbox" onClick="javascript:Tickrem16()"></td>
         <th width="20%"><div align="right">Remark 17</div><div align="right"></div></th>
        <td width="5%"><input type="checkbox" name="cbrem17" value="checkbox" onClick="javascript:Tickrem17()"></td>

    <td width="12%"><cfoutput> </cfoutput></td>
    <td width="5%"></td>
  </tr>

  <tr>
       <th width="20%"><div align="right">Remark 18</div></th>
        <td width="5%"><input type="checkbox" name="cbrem18" value="checkbox" onClick="javascript:Tickrem18()"></td>
         <th width="20%"><div align="right">Remark 19</div></th>
        <td width="5%"><input type="checkbox" name="cbrem19" value="checkbox" onClick="javascript:Tickrem19()"></td>
         <th width="20%"><div align="right">Remark 20</div><div align="right"></div></th>
        <td width="5%"><input type="checkbox" name="cbrem20" value="checkbox" onClick="javascript:Tickrem20()"></td>

    <td width="12%"><cfoutput> </cfoutput></td>
    <td width="5%"></td>
  </tr>

   <tr>
       <th width="20%"><div align="right"></div></th>
        <td width="5%"></td>
         <th width="20%"></th>
         <td width="5%"></td>
         <th width="20%"><div align="right"></div></th>
        <td width="5%"></td>

    <td width="12%"><cfoutput> </cfoutput></td>
    <td width="5%"><div align="right">
          <input type="Submit" name="Submit" value="Submit">
      </div></td>
  </tr>

  </table>
  <table border="0" align="center" width="90%" class="data"><tr><cfif getgsetup.gpricemin eq 1>
  </cfif>
  </tr>
  </table>
</cfform>
</body>
</html>

<cfif getdealer_menu.itemformat eq '2'>
<cfwindow width="550" height="400" name="finditem" refreshOnShow="true"
        title="Find Item" initshow="false"
        source="finditem2.cfm?type=Product&fromto={fromto}" />
<cfelse>
<cfwindow  width="550" height="400" name="finditem" refreshOnShow="true"
        title="Find Item" initshow="false"
        source="finditem.cfm?type=Product&fromto={fromto}" />
        </cfif>