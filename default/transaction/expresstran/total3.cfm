<cfif isdefined('url.grandtotal')>
<cfoutput>
<cfset url.grandtotal = numberformat(val(url.grandtotal),'.__')>
<form action="process.cfm" method="post" onsubmit="if(document.getElementById('change3').value*1 < 0){alert('Payment is not Enough');return false;}else{submitpay();return false;}" name="ccform"  id="ccform">
<table width="570px" >
<tr>
<td width="250px" style="font-size:24px;" height="30px">TOTAL</td>
<td width="20px" style="font-size:24px;">:</td>
<td width="300px" align="right" style="font-size:24px;">#numberformat(url.grandtotal,',.__')#<input type="hidden" name="hidgt3" id="hidgt3" value="#numberformat(url.grandtotal,'.__')#"  /><input type="hidden" name="payamt3" id="payamt3" value="0"  /></td>
</tr>
<tr>
<td colspan="3">&nbsp;</td>
</tr>
<tr>
<td style="font-size:24px; color:##000;">Cheque</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="cheq3" id="cheq3" style="font: large bolder; text-align:right" value="#numberformat(url.grandtotal,'.__')#" onkeyup="calculatetotal(event,'dbc3','')" readonly="readonly"/>
</td>
</tr>
<tr>
<td colspan="3">
Cheque No. <input type="text" name="chequeno" id="chequeno" value="" />
</td>
</tr>
<tr  style="display:none;">
<td style="font-size:24px;">Change</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="change3" id="change3" value="0.00" style="font: large bolder; text-align:right" readonly="readonly"/>
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
<input type="text" name="dbc3" id="dbc3" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc13','cheq3')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Credit Card 1</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc13" id="cc13" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc23','dbc3')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Credit Card 2</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc23" id="cc23" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'paycash3','cc13')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Cash</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="paycash3" id="paycash3" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt3','cc23')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Voucher</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="voucheramt3" id="voucheramt3" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt3','paycash3')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Deposit</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="depositamt3" id="depositamt3" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cashc3','voucheramt3')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Cash Card</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cashc3" id="cashc3" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','depositamt3')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Balance</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="balanceamt3" id="balanceamt3" style="font-size:16px; text-align:right" value="#numberformat(val(url.grandtotal),'.__')#" readonly="readonly" />
</td>
</tr>
<!--- <tr>
<td style="font-size:16px;">Remark</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<textarea name="rem9desp3" id="rem9desp3" rows="3" cols="25">
</textarea>
</td>
</tr> --->
<tr>
<td align="center" colspan="3"><input type="submit" name="sub_btn" id="sub_btn" value="Accept" style="font: large bolder;" /></td>
</tr>
</table>
</form>
<script type="text/javascript">
setTimeout("document.getElementById('chequeno').focus();document.getElementById('chequeno').select();",500);
</script>
</cfoutput>
</cfif> 