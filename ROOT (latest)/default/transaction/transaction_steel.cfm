<cfif isdefined("form.submit")>
	<cfif form.submit eq "Change Item">
		<cfquery name="getOldItem" datasource="#dts#">
		Update ictran set itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.itemno#">
		<cfif form.overwrite eq "yes">
			<cfquery name="getDesp" datasource="#dts#">
				select desp,despa from icitem where itemno='#form.itemno#'
			</cfquery>
			,desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getDesp.desp#">
			,despa=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getDesp.despa#">
		</cfif>
		where type='#form.tran#' and refno='#form.nexttranno#' and itemcount='#form.itemcount#' and custno='#form.custno#';
		</cfquery>
		
		<cfif form.tran neq "SO" and form.tran neq "PO" and form.tran neq "QUO">
			<cfif form.tran eq "OAI" or form.tran eq "RC" or form.tran eq "CN">
				<cfset qname='QIN'&(readperiod+10)>
			<cfelse>
				<cfset qname='QOUT'&(readperiod+10)>
			</cfif>
			
			<cfquery name="UpdateIcitem" datasource="#dts#">
				update icitem set #qname#=(#qname#-#form.qty#) where itemno='#form.oldItemno#'
			</cfquery>
			<cfquery name="UpdateIcitem" datasource="#dts#">
				update icitem set #qname#=(#qname#+#form.qty#) where itemno='#form.itemno#'
			</cfquery>
		</cfif>
	</cfif>
	
	<form name="done" action="../transaction/transaction3.cfm?complete=complete" method="post">
		<cfoutput>				
		<input type="hidden" name="tran" value="#tran#">
		<input type="hidden" name="hmode" value="#hmode#">
		<input type="hidden" name="type" value="#type#">
		<input type="hidden" name="currrate" value="#currrate#">
		<input type="hidden" name="agenno" value="#agenno#">
		<input type="hidden" name="refno3" value="#refno3#">
		<input type="hidden" name="nexttranno" value="#nexttranno#">
		<input type="hidden" name="custno" value="#custno#">
		<input type="hidden" name="readperiod" value="#readperiod#">
		<input type="hidden" name="nDateCreate" value="#nDateCreate#">				
		<input type="hidden" name="invoicedate" value="#invoicedate#">
		</cfoutput>
	</form>
		
	<script>done.submit();</script>
<cfelse>
	<cfquery name="getOldItem" datasource="#dts#">
		SELECT itemno,desp,qty FROM ictran
		where type='#url.tran#' and refno='#url.nexttranno#' and itemcount='#url.itemcount#' and custno='#url.custno#';
	</cfquery>
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Change Item No</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>
	
<script language="javascript">
	function validation(){
		if(document.getElementById("itemno").value.indexOf("-1")==0){
			alert("Please select an item.");
			document.getElementById("itemno").focus();
			return false;
		}
		return true;
	}
	
	var s1="";
	var s2="";
	var running="0";
	var first="1";
	//Ajax
	function getItem(process) {
		if(running=="0" || process=="1")
		{
			s1=document.getElementById("letter").value;
			running="1";
			
			if (first=="1"){
				first="2";
				running="0";
				getItem2();
			}
			else if(first=="2" && (s1==s2)){
				running="0";
				getItem2();
			}
			else {
				s2=document.getElementById("letter").value;
				setTimeout('getItem("1")', 800);
				running="1";
			}
		}
	}

	function getItem2()
	{
		var letter = DWRUtil.getValue("letter");
		var searchtype = DWRUtil.getValue("searchtype");
		letter=letter.replace(/#/g, "##");
		DWREngine._execute(_tranflocation, null, 'itemlookup', letter, searchtype, getItemResult);
	}
	
	function getItemResult(itemArray)
	{
		DWRUtil.removeAllOptions("itemno");
		DWRUtil.addOptions("itemno", itemArray,"KEY", "VALUE");
	}
	
	function resetLetter(){
		document.getElementById("letter").value="";
		getItem();
	}
	
	function init()
	{
		DWRUtil.useLoadingMessage();
		DWREngine._errorHandler =  errorHandler;
		getItem();
		document.getElementById("letter").focus();
	}
</script>

<body onLoad="init()">
	<h3>Change Item Code</h3>
	<cfoutput>
	<form name="chgItmform" action="" method="post">
		<input type="hidden" name="itemcount" value="#url.itemcount#">
		<input type="hidden" name="tran" value="#listfirst(tran)#">
		<input type="hidden" name="hmode" value="#listfirst(hmode)#">
		<input type="hidden" name="type" value="#listfirst(type1)#">
		<input type="hidden" name="currrate" value="#listfirst(currrate)#">
		<input type="hidden" name="agenno" value="#listfirst(agenno)#">
		<input type="hidden" name="refno3" value="#listfirst(refno3)#">
		<input type="hidden" name="nexttranno" value="#listfirst(nexttranno)#">
		<input type="hidden" name="custno" value="#listfirst(url.custno)#">
		<input type="hidden" name="readperiod" value="#listfirst(url.readperiod)#">
		<input type="hidden" name="nDateCreate" value="#listfirst(nDateCreate)#">				
		<input type="hidden" name="invoicedate" value="#listfirst(url.invoicedate)#">
		<input type="hidden" name="oldItemno" value="#getOldItem.itemno#">
		<input type="hidden" name="qty" value="#getOldItem.qty#">
	<table align='center' class='data' cellspacing="0">
	<tr>
		<th>Old Item Code</th>
		<td>#getOldItem.itemno#</td>
	</tr>
	<tr>
		<th>Old Item Desc</th>
		<td>#getOldItem.desp#</td>
	</tr>
	<tr>
		<th>New Item Code</th>
		<td>
		<select id="itemno" name='itemno'></select> Filter by:
		<input id="letter" name="letter" type="text" size="8" onKeyUp="getItem('0')"> in:
		<select id="searchtype" name="searchtype" onChange="resetLetter()">
			<option value="itemno">Item No</option>
			<option value="mitemno">Product Code</option>
			<option value="desp">Description</option>
			<option value="category">Category</option>
			<option value="wos_group">Group</option>
			<option value="brand">Brand</option>
		</select>
		</td>
	</tr>
	<tr>
		<th>Overwrite Des</th>
		<td>
		<input type="radio" name="overwrite" value="no" checked>No &nbsp;
		<input type="radio" name="overwrite" value="yes">Yes
		</td>
	</tr>
	<tr>
		<td colspan="2" align="right">
		<input type='submit' name='submit' value='Cancel'>
		<input type='submit' name='submit' value='Change Item' onClick="return validation();">
		</td>
	</tr>
	</table>
	</form>
	</cfoutput>
</body>
</html>