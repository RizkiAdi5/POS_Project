<cfif isdefined('url.grandtotal')>
<cfif url.type eq 'PO' or url.type eq 'PR' or url.type eq 'RC'>
<cfset dbname='Supplier'>
<cfset dbtype=target_apvend>
<cfelse>
<cfset dbname='Customer'>
<cfset dbtype=target_arcust>
</cfif>
<cfoutput>
<cfset url.grandtotal = numberformat((numberformat(val(url.grandtotal)* 2,'._')/2),'.__')>
<form action="processprint.cfm" method="post" onsubmit="
if(document.getElementById('custno6').value == '')
{
alert('Custno Is Required');
return false;
}
else
{
submitpay();
return false;
}" name="ccform6"  id="ccform6">
<h1>Payment</h1>
<table width="570px" >
<tr>
<td width="250px" style="font-size:16px;" height="30px">Custno</td>
<td width="20px" style="font-size:16px;">:</td>
<td width="300px" align="right" style="font-size:16px;">
<cfquery name="getcust" datasource="#dts#">
SELECT custno,name FROM #dbtype# where custno='#url.custno#' order by custno
</cfquery>
#getcust.custno# - #getcust.name#
<input type="hidden" name="custno6" id="custno6" value="#getcust.custno#" />
<!---

<select name="custno6" id="custno6">
<option value="">Choose a Customer</option>
<cfloop query="getcust">
<option value="#getcust.custno#" <cfif getcust.custno eq url.custno>selected</cfif>>#getcust.custno# - #getcust.name#</option>
</cfloop>
</select>--->
<cfquery datasource="#dts#" name="getGeneralInfo">
    select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse 
    from refnoset
    where type = '#url.type#'
    and counter = '1'
</cfquery>
<cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />
<cfset actual_nexttranno = newnextNum>
<cfif (getGeneralInfo.refnocode2 neq "" or getGeneralInfo.refnocode neq "") and getGeneralInfo.presuffixuse eq "1">
<cfset nexttranno = "#url.type#"&"-"&getGeneralInfo.refnocode&actual_nexttranno&getGeneralInfo.refnocode2>
<cfelse>
<cfset nexttranno = "#url.type#"&"-"&actual_nexttranno>
</cfif>
<input type="hidden" name="refnoinv" id="refnoinv" value="#nexttranno#" />
</td>
</tr>
<tr>
<td width="250px" style="font-size:16px;" height="30px">TOTAL</td>
<td width="20px" style="font-size:16px;">:</td>
<td width="300px" align="right" style="font-size:16px;">#numberformat(url.grandtotal,',.__')#<input type="hidden" name="hidgt6" id="hidgt6" value="#numberformat(url.grandtotal,'.__')#"  /><input type="hidden" name="payamt6" id="payamt6" value="0"  /></td>
</tr>
<tr>
<td style="font-size:16px; color:##000;">Cash</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="paycash6" id="paycash6" style="font-size:16px; text-align:right" value="0.00" onkeyup="calculatetotal(event,'cc16','')"/>
</td>
</tr>
<tr>
<td style="font-size:16px;">Balance</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="balanceamt6" id="balanceamt6" value="#numberformat(url.grandtotal,'.__')#" style="font-size:16px; text-align:right" readonly="readonly"/>
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
<input type="text" name="cc16" id="cc16" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc26','paycash6')" />
</td>
</tr>
<tr>
<td colspan="3">
<input type="radio" name="cctype16" id="cctype16" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype16" id="cctype16" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype16" id="cctype16" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype16" id="cctype16" value="DINERS" />Diners Club
</td>
</tr>
<tr>
<td style="font-size:16px;">Credit Card 2</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc26" id="cc26" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'dbc6','cc16')" />
</td>
</tr>
<tr>
<td colspan="3">
<input type="radio" name="cctype26" id="cctype26" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype26" id="cctype26" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype26" id="cctype26" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype26" id="cctype26" value="DINERS" />Diners Club
</td>
</tr>
<tr>
<td style="font-size:16px;">NETS</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="dbc6" id="dbc6" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cheq6','cc26')" />
</td>
</tr>
<tr>
<td style="font-size:16px;">Cheque</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cheq6" id="cheq6" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt6','dbc6')"/>
</td>
</tr>
<tr>
<td colspan="3">
Cheque No. <input type="text" name="chequeno6" id="chequeno6" value="" />
</td>
</tr>
<tr>
<td style="font-size:16px;">Voucher</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="voucheramt6" id="voucheramt6" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt6','cheq6')"/>
</td>
</tr>
<tr>
<td style="font-size:16px;">Deposit</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="depositamt6" id="depositamt6" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cashc6','voucheramt6')"/>
</td>
</tr>
<tr>
<td style="font-size:16px;">Cash Card</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cashc6" id="cashc6" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','depositamt6')"/>
</td>
</tr>
<tr>
<td style="font-size:16px;">Changes</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="change6" id="change6" style="font-size:16px; text-align:right" value="#numberformat(val(url.grandtotal)*-1,'.__')#" readonly="readonly" />
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
setTimeout("document.getElementById('paycash6').focus();document.getElementById('paycash6').select();",250);
</script>
</cfoutput>
</cfif> 