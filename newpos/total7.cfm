<link href="/stylesheet/stylesheetPOS.css" rel="stylesheet" type="text/css">
<cfif isdefined('url.grandtotal')>
<cfoutput>
<cfif lcase(hcomid) eq 'tcds_i'>
<cfset url.grandtotal = numberformat((numberformat(Ceiling(val(url.grandtotal)* 2*10)/10,'._')/2),'.__')>
<cfelse>
<cfset url.grandtotal = numberformat((numberformat(val(url.grandtotal)* 2,'._')/2),'.__')>
</cfif>
<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>
<cfif getgsetup.comboard eq 'Y'>
<cftry>
<div style="display:none">
<cfinvoke component="cfc.comboard" method="display" firstline="" secondlineleft="" secondlineright="#numberformat(url.grandtotal,',_.__')#" comchannel="#getgsetup.comboardport#" returnvariable="test"/>
</div>
<cfcatch></cfcatch></cftry>
</cfif>
<form action="processprint.cfm" method="post" onsubmit="
if(document.getElementById('custno7').value == '')
{
alert('Custno Is Required');
return false;
}
else
{
document.getElementById('sub_btn').disabled=true;
submitpay();
return false;
}" name="ccform7"  id="ccform7">
<h1>Save As SO</h1>
<table width="570px" >
<tr>
<td width="250px" style="font-size:16px;" height="30px">Custno</td>
<td width="20px" style="font-size:16px;">:</td>
<td width="300px" align="right" style="font-size:16px;">
<cfquery name="getcust" datasource="#dts#">
SELECT custno,name FROM #target_arcust# order by custno
</cfquery>
<select name="custno7" id="custno7">
<option value="">Choose a Customer</option>
<cfloop query="getcust">
<option value="#getcust.custno#">#getcust.custno# - #getcust.name#</option>
</cfloop>
</select>
<cfquery datasource="#dts#" name="getGeneralInfo">
    select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse 
    from refnoset
    where type = 'SO'
    and counter = '1'
</cfquery>

<cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />


<cfset actual_nexttranno = newnextNum>
<cfif (getGeneralInfo.refnocode2 neq "" or getGeneralInfo.refnocode neq "") and getGeneralInfo.presuffixuse eq "1">
<cfset nexttranno = "SO"&"-"&getGeneralInfo.refnocode&actual_nexttranno&getGeneralInfo.refnocode2>
<cfelse>
<cfset nexttranno = "SO"&"-"&actual_nexttranno>
</cfif>
<input type="hidden" name="refnoSO" id="refnoSO" value="#nexttranno#" />
</td>
</tr>
<tr>
<td width="250px" style="font-size:16px;" height="30px">TOTAL</td>
<td width="20px" style="font-size:16px;">:</td>
<td width="300px" align="right" style="font-size:16px;">#Replace( NumberFormat(val(url.grandtotal), "," ), ",", ".", "ALL" )#<input type="hidden" name="hidgt7" id="hidgt7" value="#numberformat(url.grandtotal,'.__')#"  /><input type="hidden" name="payamt7" id="payamt7" value="0"  /></td>
</tr>
<tr>
<td style="font-size:16px; color:##000;">Cash</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="paycash7" id="paycash7" style="font-size:16px; text-align:right" value="0.00" onkeyup="calculatetotal(event,'cc17','')"/>
</td>
</tr>
<tr>
<td style="font-size:16px;">Balance</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="balanceamt7" id="balanceamt7" value="#numberformat(url.grandtotal,'.__')#" style="font-size:16px; text-align:right" readonly/>
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
<input type="text" name="cc17" id="cc17" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc27','paycash7')" />
</td>
</tr>
<tr>
<td colspan="3">
<input type="radio" name="cctype17" id="cctype17" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype17" id="cctype17" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype17" id="cctype17" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype17" id="cctype17" value="DINERS" />Diners Club
<input type="radio" name="cctype17" id="cctype17" value="CUP" />CUP
</td>
</tr>
<tr>
<td style="font-size:16px;">Credit Card 2</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc27" id="cc27" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'dbc7','cc17')" />
</td>
</tr>
<tr>
<td colspan="3">
<input type="radio" name="cctype27" id="cctype27" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype27" id="cctype27" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype27" id="cctype27" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype27" id="cctype27" value="DINERS" />Diners Club
<input type="radio" name="cctype27" id="cctype27" value="CUP" />
</td>
</tr>
<tr>
<td style="font-size:16px;">NETS</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="dbc7" id="dbc7" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cheq7','cc27')" />
</td>
</tr>
<tr>
<td style="font-size:16px;">Cheque</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cheq7" id="cheq7" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt7','dbc7')"/>
</td>
</tr>
<tr>
<td colspan="3">
Cheque No. <input type="text" name="chequeno7" id="chequeno7" value="" />
</td>
</tr>
<tr>
<td style="font-size:16px;">Voucher</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="voucheramt7" id="voucheramt7" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt7','cheq7')"/>
</td>
</tr>
<tr>
<td style="font-size:16px;">Deposit</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="depositamt7" id="depositamt7" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cashc7','voucheramt7')"/>
</td>
</tr>
<tr>
<td colspan="3">
<div id="getdepositajax"></div>
Deposit No :&nbsp;
<cfquery name="getdepositno" datasource="#dts#">
SELECT * from deposit where billno='' or billno is null order by depositno
</cfquery>
<select name="depositno7" id="depositno7" onchange="getdeposit(7);">
<option value="">Choose a Deposit No</option>
<cfloop query="getdepositno">
<option value="#getdepositno.depositno#">#getdepositno.depositno#</option>
</cfloop>
</select>

</td>
</tr>
<tr>
<td style="font-size:16px;">Cash Card</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cashc7" id="cashc7" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','depositamt7')"/>
</td>
</tr>
<tr>
<td style="font-size:16px;">Changes</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="change7" id="change7" style="font-size:16px; text-align:right" value="#numberformat(val(url.grandtotal)*-1,'.__')#" readonly />
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
setTimeout("document.getElementById('paycash7').focus();document.getElementById('paycash7').select();",250);
</script>
</cfoutput>
</cfif> 
<br/>
<br/>
<br/>
<br/>
<br/>
