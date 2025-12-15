<cfif isdefined('url.grandtotal')>
<cfoutput>
<cfset url.grandtotal = numberformat(val(url.grandtotal),'.__')>
<form action="process.cfm" method="post" onsubmit="if(document.getElementById('change4').value*1 < 0){alert('Payment is not Enough');return false;}else{submitpay();return false;}" name="ccform"  id="ccform">
<table width="570px" >
<tr>
<td width="250px" style="font-size:24px;" height="30px">TOTAL</td>
<td width="20px" style="font-size:24px;">:</td>
<td width="300px" align="right" style="font-size:24px;">#numberformat(url.grandtotal,',.__')#<input type="hidden" name="hidgt4" id="hidgt4" value="#numberformat(url.grandtotal,'.__')#"  /><input type="hidden" name="payamt4" id="payamt4" value="0"  /></td>
</tr>
<tr>
<td colspan="3">&nbsp;</td>
</tr>
<tr>
<td style="font-size:24px; color:##000;">Cash Card</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="cashc4" id="cashc4" style="font: large bolder; text-align:right" value="#numberformat(url.grandtotal,'.__')#" onkeyup="calculatetotal(event,'dbc4','')" readonly="readonly"/>
</td>
</tr>
<tr>
<td colspan="3">&nbsp;
</td>
</tr>
<tr style="display:none;">
<td style="font-size:24px;">Change</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="change4" id="change4" value="0.00" style="font: large bolder; text-align:right" readonly="readonly"/>
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
<input type="text" name="dbc4" id="dbc4" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc14','cashc4')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Credit Card 1</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc14" id="cc14" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc24','dbc4')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Credit Card 2</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc24" id="cc24" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'paycash4','cc14')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Cash</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="paycash4" id="paycash4" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cheq4','cc24')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Cheque</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cheq4" id="cheq4" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt4','dbc4')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Voucher</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="voucheramt4" id="voucheramt4" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt4','cheq4')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Deposit</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="depositamt4" id="depositamt4" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','voucheramt4')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Balance</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="balanceamt4" id="balanceamt4" style="font-size:16px; text-align:right" value="#numberformat(val(url.grandtotal),'.__')#" readonly="readonly" />
</td>
</tr>
<!--- <tr>
<td style="font-size:16px;">Remark</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<textarea name="rem9desp4" id="rem9desp4" rows="3" cols="25">
</textarea>
</td>
</tr> --->
<tr>
<td align="center" colspan="3"><input type="submit" name="sub_btn" id="sub_btn" value="Accept" style="font: large bolder;" /></td>
</tr>
</table>
</form>
<script type="text/javascript">
setTimeout("document.getElementById('cashc4').focus();document.getElementById('cashc4').select();",500);
</script>
</cfoutput>
</cfif> 