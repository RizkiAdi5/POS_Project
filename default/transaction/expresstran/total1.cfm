<cfif isdefined('url.grandtotal')>
<cfoutput>
<cfset url.grandtotal = numberformat(val(url.grandtotal),'.__')>
<form action="process.cfm" method="post" onsubmit="if(document.getElementById('change1').value*1 < 0){alert('Payment is not Enough');return false;}else{submitpay();return false;}">
<table width="570px" >
<tr>
<td width="250px" style="font-size:24px;" height="30px">TOTAL</td>
<td width="20px" style="font-size:24px;">:</td>
<td width="300px" align="right" style="font-size:24px;">#numberformat(url.grandtotal,',.__')#<input type="hidden" name="hidgt1" id="hidgt1" value="#numberformat(url.grandtotal,'.__')#"  /><input type="hidden" name="payamt1" id="payamt1" value="0"  /></td>
</tr>
<tr>
<td colspan="3">&nbsp;</td>
</tr>
<tr>
<td style="font-size:24px; color:##000;">NETS</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="dbc1" id="dbc1" style="font: large bolder; text-align:right" value="#numberformat(url.grandtotal,'.__')#" onkeyup="calculatetotal(event,'cc11','')" readonly="readonly"/>
</td>
</tr>
<tr>
<td colspan="3">&nbsp;</td>
</tr>
<tr  style="display:none;">
<td style="font-size:24px;">Change</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="change1" id="change1" value="0.00" style="font: large bolder; text-align:right" readonly="readonly"/>
</td>
</tr>
</tr>
<tr style="display:none;">
<th colspan="100%"><div align="center">Multi Payment</div></th>
</tr>
<tr  style="display:none;">
<td style="font-size:16px;">Credit Card 1</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc11" id="cc11" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc21','dbc1')" />
</td>
</tr>
<tr  style="display:none;">
<td style="font-size:16px;">Credit Card 2</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc21" id="cc21" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'paycash1','cc11')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Cash</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="paycash1" id="paycash1" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cheq1','cc21')" />
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Cheque</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cheq1" id="cheq1" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt1','paycash1')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Voucher</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="voucheramt1" id="voucheramt1" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt1','cheq1')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Deposit</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="depositamt1" id="depositamt1" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cashc1','voucheramt1')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Cash Card</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cashc1" id="cashc1" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','depositamt1')"/>
</td>
</tr>
<tr style="display:none;">
<td style="font-size:16px;">Balance</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="balanceamt1" id="balanceamt1" style="font-size:16px; text-align:right" value="#numberformat(val(url.grandtotal),'.__')#" readonly="readonly" />
</td>
</tr>
<!--- <tr>
<td style="font-size:16px;">Remark</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<textarea name="rem9desp1" id="rem9desp1" rows="3" cols="25">
</textarea>
</td>
</tr> --->
<tr>
<td align="center" colspan="3"><input type="submit" name="sub_btn" id="sub_btn" value="Accept" style="font: large bolder;" /></td>
</tr>
</table>
</form>
<script type="text/javascript">
setTimeout("document.getElementById('dbc1').focus();document.getElementById('dbc1').select();",500);
</script>
</cfoutput>
</cfif> 