<html>
<head>
	<title>Add / Edit Serial Page</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfif isdefined("form.Submit1") and form.Submit1 eq "Add">
	<cfquery name="checkserial" datasource="#dts#">
		select serialno from iserial where itemno='#form.itemno#' and type='#tran#' and serialno='#form.serialno#'
	</cfquery>

	<cfif checkserial.recordcount eq 0>
		<cfquery name="insertserial" datasource="#dts#">
			insert into iserial values ("#tran#", "#nexttranno#", "", "#itemcount#", "#custno#", "#readperiod#", #ndatecreate#, "", "#itemno#",
			"", "", "#serialno#", "", "#agenno#", "#location#", "", "", "#currrate#", "", "", "", "", "")
		</cfquery>
	<cfelse>
		<h1 align="center">Duplicate Serial No <font color="red">"<cfoutput>#serialno#</cfoutput>"</font> For Item <font color="red">"<cfoutput>#itemno#</cfoutput>"</font></h1>
		<table align="center">
			<tr>
				<td><input align="middle" type="button" name="Back" value="Back" onClick="javascript:history.back();"></td>
			</tr>
		</table>
		<cfabort>
	</cfif>
<cfelse>
	<cfquery name="insertserial" datasource="#dts#">
		insert into iserial values ("#tran#", "#nexttranno#", "", "#itemcount#", "#custno#", "#readperiod#", #ndatecreate#, "", "#itemno#",
		"", "", "#serialno#", "", "#agenno#", "#location#", "", "", "#currrate#", "", "", "", "", "")
	</cfquery>
</cfif>

<form name="done" action="../transaction/transactionserial.cfm?complete=complete" method="post">
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
</form>

<script>
	done.submit();
</script>

</body>
</html>