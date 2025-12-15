<cfif isdefined('url.grandtotal')>
<cfoutput>
<cfset url.grandtotal = numberformat((numberformat(val(url.grandtotal)* 2,'._')/2),'.__')>
<form action="process.cfm" method="post" onsubmit="if(document.getElementById('change5').value*1 < 0){alert('Payment is not Enough');return false;}else{submitpay();return false;}" name="ccform5"  id="ccform5">
<table width="570px" >
<tr>
<td width="250px" style="font-size:24px;" height="30px">TOTAL</td>
<td width="20px" style="font-size:24px;">:</td>
<td width="300px" align="right" style="font-size:24px;">#numberformat(url.grandtotal,',.__')#<input type="hidden" name="hidgt5" id="hidgt5" value="#numberformat(url.grandtotal,'.__')#"  /><input type="hidden" name="payamt5" id="payamt5" value="0"  /></td>
</tr>
<tr>
<td colspan="3">&nbsp;</td>
</tr>
<tr>
<td style="font-size:24px; color:##000;">Cash</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="paycash5" id="paycash5" style="font: large bolder; text-align:right" value="0.00" onkeyup="calculatetotal(event,'cc15','')"/>
</td>
</tr>
<tr>
<td colspan="3">&nbsp;</td>
</tr>
<tr>
<td style="font-size:24px;">Balance</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="balanceamt5" id="balanceamt5" value="#numberformat(url.grandtotal,'.__')#" style="font: large bolder; text-align:right" readonly="readonly"/>
</td>
</tr>
</tr>
<tr>
<th colspan="100%"><div align="center">Multi Payment</div></th>
</tr>
<tr>
<td style="font-size:16px;">Credit Card 1</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc15" id="cc15" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc25','paycash5')" />
</td>
</tr>
<tr>
<td colspan="3">
<input type="radio" name="cctype15" id="cctype15" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype15" id="cctype15" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype15" id="cctype15" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype15" id="cctype15" value="DINERS" />Diners Club
</td>
</tr>
<tr>
<td style="font-size:16px;">Credit Card 2</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc25" id="cc25" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'dbc5','cc15')" />
</td>
</tr>
<tr>
<td colspan="3">
<input type="radio" name="cctype25" id="cctype25" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype25" id="cctype25" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype25" id="cctype25" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype25" id="cctype25" value="DINERS" />Diners Club
</td>
</tr>
<tr>
<td style="font-size:16px;">NETS</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="dbc5" id="dbc5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cheq5','cc25')" />
</td>
</tr>
<tr>
<td style="font-size:16px;">Cheque</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cheq5" id="cheq5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt5','dbc5')"/>
</td>
</tr>
<tr>
<td colspan="3">
Cheque No. <input type="text" name="chequeno5" id="chequeno5" value="" />
</td>
</tr>
<tr>
<td style="font-size:16px;">Voucher</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="voucheramt5" id="voucheramt5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt5','cheq5')"/>
</td>
</tr>
<tr>
<td style="font-size:16px;">Deposit</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="depositamt5" id="depositamt5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cashc5','voucheramt5')"/>
</td>
</tr>
<tr>
<td style="font-size:16px;">Cash Card</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cashc5" id="cashc5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','depositamt5')"/>
</td>
</tr>
<tr>
<td style="font-size:16px;">Changes</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="change5" id="change5" style="font-size:16px; text-align:right" value="#numberformat(val(url.grandtotal)*-1,'.__')#" readonly="readonly" />
</td>
</tr>
<!--- <tr>
<td style="font-size:16px;">Remark</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<textarea name="rem9desp5" id="rem9desp5" rows="3" cols="25">
</textarea>
</td>
</tr> --->
<tr>
<td align="center" colspan="3"><input type="submit" name="sub_btn" id="sub_btn" value="Accept" style="font: large bolder;" /></td>
</tr>
</table>
</form>
<script type="text/javascript">
setTimeout("document.getElementById('paycash5').focus();document.getElementById('paycash5').select();",250);
</script>
</cfoutput>
</cfif> 