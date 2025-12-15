<cfif isdefined('url.grandtotal')>
<cfoutput>
<cfset url.grandtotal = numberformat(val(url.grandtotal),'.__')>
<form action="process.cfm" method="post" onsubmit="if(document.getElementById('change2').value*1 < 0){alert('Payment is not Enough');return false;}else{submitpay();return false;}" name="ccform"  id="ccform">
<table width="570px" >
<tr>
<td width="250px" style="font-size:24px;" height="30px">TOTAL</td>
<td width="20px" style="font-size:24px;">:</td>
<td width="300px" align="right" style="font-size:24px;">#numberformat(url.grandtotal,',.__')#<input type="hidden" name="hidgt2" id="hidgt2" value="#numberformat(url.grandtotal,'.__')#"  /><input type="hidden" name="payamt2" id="payamt2" value="0"  /></td>
</tr>
<tr>
<td colspan="3">&nbsp;</td>
</tr>
<tr>
<td style="font-size:24px; color:##000;">CREDIT CARD</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="cc12" id="cc12" style="font: large bolder; text-align:right" value="#numberformat(url.grandtotal,'.__')#" onkeyup="calculatetotal(event,'dbc2','')" readonly="readonly"/>
</td>
</tr>
<tr>
<td colspan="3">
<input type="radio" name="cctype1" id="cctype1" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="DINERS" />Diners Club
</td>
</tr>
<tr style="display:none;">
<td style="font-size:24px;">Change</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="change2" id="change2" value="0.00" style="font: large bolder; text-align:right" readonly="readonly"/>
</td>
</tr>
</tr>
<tr style="display:none;">
<th colspan="100%"><div align="center">Multi Payment</div></th>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">NETS</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="dbc2" id="dbc2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc22','cc12')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Credit Card 2</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc22" id="cc22" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'paycash2','dbc2')" />
</td>
</tr>
<tr  style="display:none;">
<td style="font-size:16px;">Cash</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="paycash2" id="paycash2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cheq2','cc22')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Cheque</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cheq2" id="cheq2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt2','paycash2')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Voucher</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="voucheramt2" id="voucheramt2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt2','cheq2')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Deposit</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="depositamt2" id="depositamt2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cashc2','voucheramt2')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Cash Card</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cashc2" id="cashc2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','depositamt2')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Balance</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="balanceamt2" id="balanceamt2" style="font-size:16px; text-align:right" value="#numberformat(val(url.grandtotal),'.__')#" readonly="readonly" />
</td>
</tr>
<!--- <tr>
<td style="font-size:16px;">Remark</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<textarea name="rem9desp2" id="rem9desp2" rows="3" cols="25">
</textarea>
</td>
</tr> --->
<tr>
<td align="center" colspan="3"><input type="submit" name="sub_btn" id="sub_btn" value="Accept" style="font: large bolder;" /></td>
</tr>
</table>
</form>
<script type="text/javascript">
setTimeout("document.getElementById('cctype1').focus();document.getElementById('cctype1').select();",500);
</script>
</cfoutput>
</cfif> 