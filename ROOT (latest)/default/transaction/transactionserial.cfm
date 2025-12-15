<html>
<head>
	<title>Add / Edit Serial Page</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<h2>Serial No Selection Screen</h2><br>
<hr>Please choose the serial no for the item selected.<br><br>

<cfquery datasource="#dts#" name="getserial">
	Select * from iserial where type = '#tran#' and refno = '#nexttranno#' and itemno = '#itemno#' and trancode = '#itemcount#'
</cfquery>

<table class="data">
	<tr>
		<th>Reference No</th>
		<th>Customer No</th>
		<th>Itemno</th>
		<th>Serial No</th>
		<th>Action</th>
	</tr>

	<cfoutput query="getserial">
	<tr>
		<td>#getserial.refno#</td>
		<td>#getserial.custno#</td>
		<td>#getserial.itemno#</td>
		<td>#getserial.serialno#</td>
		<td><a href="transactionserialdelete.cfm?serialno=#getserial.serialno#&tran=#tran#&currrate=#currrate#&refno3=#refno3#&status=#status#&hmode=#hmode#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&readperiod=#readperiod#&nDateCreate=#nDateCreate#&itemno=#itemno#&qty=#qty#&invoicedate=#invoicedate#&agenno=#agenno#&itemcount=#itemcount#&location=#location#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a></td>
	</tr>
	</cfoutput>
</table>

<cfquery datasource="#dts#" name="displayserial">
	Select count(serialno) as serialcnt, serialno from iserial where itemno = '#itemno#' group by serialno
</cfquery>

<!--- <cfquery datasource="#dts#" name="getserialcnt">
	Select count(serialno) as serialcnt, serialno from iserial where itemno = '#itemno#' group by serialno
</cfquery> --->

<cfquery datasource="#dts#" name="serialtotal">
	Select count(itemno) as itemcnt from iserial where itemno = '#itemno#' and refno = '#nexttranno#' and type = '#tran#' and trancode = '#itemcount#' group by itemno
</cfquery>

<cfif serialtotal.itemcnt eq "">
	<cfset qtybalance = val(qty)>
<cfelse>
	<cfset qtybalance = val(qty) - val(serialtotal.itemcnt)>
</cfif>

<br>No of qty to be select : <cfoutput>#qtybalance#</cfoutput>

<form action="transactionserial2.cfm" method="post" name="form">
	<cfoutput>
		<input type="hidden" name="itemcount" value="#itemcount#">
		<input type="hidden" name="tran" value="#tran#">
		<input type="hidden" name="currrate" value="#currrate#">
		<input type="hidden" name="agenno" value="#agenno#">
		<input type="hidden" name="refno3" value="#refno3#">
		<input name="status" value="#status#" type="hidden">
		<input name="type" value="#type#" type="hidden">
		<input name="hmode" value="#hmode#" type="hidden">
		<input type="hidden" name="nexttranno" value="#nexttranno#">
		<input type="hidden" name="custno" value="#custno#">
		<input type="hidden" name="readperiod" value="#readperiod#">
		<input type="hidden" name="nDateCreate" value="#nDateCreate#">
		<input type="hidden" name="itemno" value="#itemno#">
		<input type="hidden" name="qty" value="#qty#">
		<input type="hidden" name="location" value="#location#">
		<input type="hidden" name="invoicedate" value="#invoicedate#">
		<cfif isdefined("form.updunitcost")>
			<input type='hidden' name='updunitcost' value='#form.updunitcost#'>
		</cfif>
	</cfoutput>

	<cfif tran neq "RC" and tran neq "CN">
		<cfif displayserial.recordcount gt 0 and qtybalance gt 0>
			Serial No:
				<select name="serialno">
      				<cfoutput query="displayserial">
        				<cfif displayserial.serialcnt gt 1>
						<cfelse>
		 				<!--- <cfif #qtybalance# gt 0> --->
          					<option value="#serialno#">#serialno#</option>
         				</cfif>
      				</cfoutput>
    			</select>
			<!--- <cfelseif qtybalance gt 0 and displayserial.recordcount eq 0>
			<input type="text" name="serialno" maxlength="30" size="30"> --->
			<input type="submit" name="Submit" value="Add">
		</cfif>
	<cfelse>
 		Serial No:
  		<cfif qtybalance gt 0>
    		<input type="text" name="serialno" maxlength="30" size="30">
			<input type="submit" name="Submit1" value="Add">
		</cfif>
  	</cfif>
  	<!--- <cfif qtybalance gt 0><input type="submit" name="Submit" value="Add"></cfif> --->
</form>
<hr>
<br><br>Click Finish when done.

<form name="done" action="../transaction/transaction3.cfm?complete=complete" method="post">
	<cfoutput>
		<input type="hidden" name="tran" value="#tran#">
		<input type="hidden" name="currrate" value="#currrate#">
		<input type="hidden" name="agenno" value="#agenno#">
		<input type="hidden" name="refno3" value="#refno3#">
		<input name="status" value="#status#" type="hidden">
		<input name="type" value="#type#" type="hidden">
		<input name="hmode" value="#hmode#" type="hidden">
		<input type="hidden" name="nexttranno" value="#nexttranno#">
		<input type="hidden" name="custno" value="#form.custno#">
		<input type="hidden" name="readperiod" value="#form.readperiod#">
		<input type="hidden" name="nDateCreate" value="#form.nDateCreate#">
		<input type="hidden" name="invoicedate" value="#form.invoicedate#">
		<cfif isdefined("form.updunitcost")>
		  <input type='hidden' name='updunitcost' value='#form.updunitcost#'>
		</cfif>
  	</cfoutput>
  	<input type="submit" name="Submit2" value="Finish">
</form>

</body>
</html>