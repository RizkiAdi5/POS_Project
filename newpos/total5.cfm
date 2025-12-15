 <link rel="stylesheet" type="text/css" href="table.css" />

<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1298, 2087, 2074, 2078, 2113, 2114, 1297, 2076, 1347, 2080, 2081, 2063, 2112, 2115, 2116, 2117, 2077, 2119, 2120, 2118, 2121, 
2079, 2075, 1104">
<cfinclude template="/latest/words.cfm">

 
<cfif isdefined('grandtotal')>

<cfoutput>
<cfif lcase(hcomid) eq 'tcds_i'>
<cfset grandtotal = numberformat((numberformat(Ceiling(val(grandtotal)* 2*10)/10,'._')/2),'.__')>
<cfelse>
<cfset grandtotal = numberformat((numberformat(val(grandtotal)* 2,'._')/2),'.__')>
</cfif>
<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<form name="total5form" action="processprint.cfm" method="post" onsubmit="" name="ccform5"  id="ccform5">

<center>
<table class="table-style-three">
	<tbody>
    <tr>
    <th>
   <table class="table-style-three">
    <tr>
		<td>#words[2074]#:</td>
		<td>
       #numberformat(grandtotal,'.__')#<input type="hidden" name="hidgt5" id="hidgt5" value="#numberformat(grandtotal,'.__')#"  /><input type="hidden" name="payamt5" id="payamt5" value="0"  />
        </td>
	</tr>
	<cfif hcomid eq 'tcds_i'>
	
	<tr>
		<td>#words[2078]#:</td>
		<td><input type="text" name="depositamt5" id="depositamt5" value="0.00" style="font: large bolder; text-align:right" onkeyup="calculatetotal(event,'cashc5','voucheramt5')"/></td>
	</tr>
	<tr>
		<td colspan="3">
			<div id="getdepositajax"></div>
			#words[2113]# :&nbsp;
			<cfquery name="getdepositno" datasource="#dts#">
			SELECT * from deposit where billno='' or billno is null order by depositno
			</cfquery>
			<select name="depositno" id="depositno" onchange="getdeposit(5);">
			<option value="">#words[2114]#</option>
			<cfloop query="getdepositno">
			<option value="#getdepositno.depositno#">#getdepositno.depositno#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	</cfif>
	<tr>
		<td>#words[1297]#:</td>
		<td><input type="text" name="paycash5" id="paycash5" style="font: large bolder; text-align:right" value="0.00" onkeyup="calculatetotal(event,'cc15','')"/></td>
	</tr>
	<tr>
		<td>#words[2076]#:</td>
		<td><input type="text" name="balanceamt5" id="balanceamt5" value="#numberformat(grandtotal,'.__')#" style="font: large bolder; text-align:right" readonly/></td>
	</tr>
    <tr style="display:none;">
		<th colspan="100%"><div align="center">#words[1347]#</div></th>
	</tr>
		<td>#words[2080]#:</td>
		<td><input type="text" name="cc15" id="cc15" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc25','paycash5')" /></td>
	</tr>
	<tr>
		<td colspan="3">
			<input type="radio" name="cctype15" id="cctype151" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
			<input type="radio" name="cctype15" id="cctype152" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
			<input type="radio" name="cctype15" id="cctype153" value="AMEX" />American Express&nbsp;&nbsp;
			<input type="radio" name="cctype15" id="cctype154" value="DINERS" />Diners Club
			<input type="radio" name="cctype15" id="cctype155" value="CUP" />CUP
		</td>
	</tr>
    	<tr>
		<td>#words[2081]#:</td>
		<td><input type="text" name="cc25" id="cc25" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'dbc5','cc15')" /></td>
	</tr>
	<tr >
		<td colspan="3">
			<input type="radio" name="cctype25" id="cctype251" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
			<input type="radio" name="cctype25" id="cctype252" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
			<input type="radio" name="cctype25" id="cctype253" value="AMEX" />American Express&nbsp;&nbsp;
			<input type="radio" name="cctype25" id="cctype254" value="DINERS" />Diners Club
			<input type="radio" name="cctype25" id="cctype255" value="CUP" />CUP
		</td>
	</tr>
    	<tr>
		<td>#words[2063]#:</td>
		<td><input type="text" name="dbc5" id="dbc5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cheq5','cc25')" /></td>
	</tr>
    	<tr style="display:none">
		<td><input type="hidden" name="accumpoints" id="accumpoints" value="9999999999" readonly style="font-size:16px; text-align:right"/></td>
	</tr>
    <tr>
		<td>#words[1298]#:</td>
		<td><input type="text" name="cheq5" id="cheq5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt5','dbc5')"/></td>
	</tr>
		<td colspan="3">
			#words[2117]# <input type="text" name="chequeno5" id="chequeno5" value="" />
		</td>
	</tr>
    <tr>
		<td>#words[2077]#:</td>
		<td><input type="text" name="voucheramt5" id="voucheramt5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt5','cheq5')"/></td>
	</tr>
	<tr>
	<td colspan="3" >
		<div id="getvoucherajax"></div>
		<input type="hidden" name="vouchertype" id="vouchertype" value="" />
		<input type="text" name="voucherno" id="voucherno" value="" onkeyup="calculatetotal(event,'voucherno','voucheramt5')" />
		<input type="button" name="multivoucher" id="multivoucher" value="#words[2119]#" onclick="PopupCenter('multivoucher.cfm?','linkname','600','1000');" />
	</td>
	</tr>
	<cfif hcomid neq 'tcds_i'>
    <tr>
		<td>#words[2078]#:</td>
		<td><input type="text" name="depositamt5" id="depositamt5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cashc5','voucheramt5')"/></td>
	</tr>
	<tr >
		<td colspan="3">
			<div id="getdepositajax"></div>
			#words[2113]# :&nbsp;
			<cfquery name="getdepositno" datasource="#dts#">
			SELECT * from deposit where billno='' or billno is null order by depositno
			</cfquery>
			<select name="depositno" id="depositno" onchange="getdeposit(5);">
			<option value="">#words[2114]#</option>
			<cfloop query="getdepositno">
			<option value="#getdepositno.depositno#">#getdepositno.depositno#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	</cfif>
    <tr>
		<td>#words[2079]#:</td>
		<td><input type="text" name="cashc5" id="cashc5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','depositamt5')"/></td>
	</tr>
	<tr>
		<td>#words[2075]#:</td>
		<td><input type="text" name="change5" id="change5" style="font-size:16px; text-align:right" value="#numberformat(val(grandtotal)*-1,'.__')#" readonly /></td>
	</tr>
	<tr>
		<td align="center" colspan="3"><input type="button" name="sub_btn" id="sub_btn" value="#words[1104]#" onclick="if(document.getElementById('reservebtn').checked==false){
		if(document.getElementById('change5').value*1 < 0){alert('#words[2087]#');return false;}
		else if(((document.getElementById('voucheramt5').value*1)+(document.getElementById('cc15').value*1)+(document.getElementById('cc25').value*1)+(document.getElementById('cheq5').value*1)+(document.getElementById('dbc5').value*1)+(document.getElementById('depositamt5').value*1)) >document.getElementById('hidgt5').value*1 && document.getElementById('change5').value*1 !=0){alert('Voucher+Credit Card+Deposit+Net is Over Amount');return false;}
		else if(document.getElementById('cheq5').value*1 >document.getElementById('accumpoints').value*1){alert('Points is Over');return false;}
		else{document.getElementById('sub_btn').disabled=true;submitpay();return false;}}else{submitpay();return false;}" style="font: large bolder;" /></td>
	</tr>
   </table>
  </th>
  </tr>
	</tbody>
</table>
</center>
</form>
<script type="text/javascript">
setTimeout("document.getElementById('paycash5').focus();document.getElementById('paycash5').select();",250);
</script>
</cfoutput>
</cfif> 
