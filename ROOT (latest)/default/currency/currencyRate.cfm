<html>
<head>
<title>Create Currency Rate</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body onload="document.currency.currP1.select()">

<cfif isdefined("Form.CurrCode")>
	<cfquery datasource='#dts#' name="checkCode">
		select * 
		from #target_currency# 
		where currcode='#form.currcode#'
	</cfquery>
	
	<cfif checkcode.recordcount eq 0>
		<cftry>
			<cftransaction>
				<cfinsert datasource='#dts#' tablename="currencyrate" formfields="CurrCode,Currency,CurrDollar,CurrCent">
			</cftransaction>
			<cfcatch type="database">
				<H1>DATABASE ERROR! PLEASE CONTACT THE ADMINISTRATOR.</H1>
			</cfcatch>
		</cftry> 
	<cfelse>
		<cfset status="Currency Code had already been created. Please key in a different code.">
		
		<form name="done" action="createCurrency.cfm" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
	</cfif>
</cfif>
	
<cfform name="currency" action="currencyRateS2.cfm" method="post">
	<cfset mode=Isdefined("url.type")>
	
	<cfif url.type eq "Edit">
		<cfquery datasource='#dts#' name="getCurrCode">
			select * from 
			#target_currency# 
			where currcode='#url.currcode#'
		</cfquery>
		
		<cfif getCurrCode.recordcount gt 0>
			<cfset JobNo = getCurrCode.JobNo>
		</cfif>
	</cfif>
	
	<H1>Please update the following rates: </H1>

	<cfoutput><input type="hidden" name="mode" value="#mode#"><input type="hidden" name="currcode" value="#form.currcode#"></cfoutput>
	<table align="center" class="data" width="500px">		
		<tr>
			<th>PERIOD 1 :</th>
			<td><CFinput type="text" name="currP01" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 2 :</th>
			<td><CFinput type="text" name="currP02" value="1.0000000000"></td>
		</tr>
		<tr>
		<tr>
     		<th>PERIOD 3 :</th>
			<td><CFinput type="text" name="currP03" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 4 :</th>
			<td><CFinput type="text" name="currP04" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 5 :</th>
			<td><CFinput type="text" name="currP05" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 6 :</th>
			<td><CFinput type="text" name="currP06" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 7 :</th>
			<td><CFinput type="text" name="currP07" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 8 :</th>
			<td><CFinput type="text" name="currP08" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 9 :</th>
			<td><CFinput type="text" name="currP09" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 10 :</th>
			<td><CFinput type="text" name="currP10" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 11 :</th>
			<td><CFinput type="text" name="currP11" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 13 :</th>
			<td><CFinput type="text" name="currP13" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 14 :</th>
			<td><CFinput type="text" name="currP14" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 15 :</th>
			<td><CFinput type="text" name="currP15" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 16 :</th>
			<td><CFinput type="text" name="currP16" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 17 :</th>
			<td><CFinput type="text" name="currP17" value="1.0000000000"></td>
		</tr>
		<tr>
			<th>PERIOD 18 :</th>
			<td><CFinput type="text" name="currP18" value="1.0000000000"></td>
		</tr>
		<tr>
			<th></th>
      		<td><input type="submit" name="submit" value="Save"></td>
		</tr>
	</table>
</cfform>	

</body>
</html>