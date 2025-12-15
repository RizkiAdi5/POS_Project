<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2087, 2074, 2078, 2113, 2114, 1297, 2076, 1347, 2080, 2081, 2063, 2112, 2115, 2116, 2117, 2077, 2119, 2120, 2118, 2121, 
2079, 2075, 1104">
<cfinclude template="/latest/words.cfm">

<link href="/stylesheet/stylesheetPOS.css" rel="stylesheet" type="text/css">
<cfif isdefined('url.grandtotal')>
<cfquery name="getpayment" datasource="#dts#">
SELECT * FROM pospayment
</cfquery>

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
<form name="total5form" action="processprint.cfm" method="post" onsubmit="" name="ccform5"  id="ccform5">
<table width="570px" >
<tr>
<td width="250px" style="font-size:24px;" height="30px">#words[2074]#</td>
<td width="20px" style="font-size:24px;">:</td>
<td width="300px" align="right" style="font-size:24px;">#numberformat(url.grandtotal,',.__')#<input type="hidden" name="hidgt5" id="hidgt5" value="#numberformat(url.grandtotal,'.__')#"  /><input type="hidden" name="payamt5" id="payamt5" value="0"  /></td>
</tr>

<cfif hcomid eq 'tcds_i'>
<tr>
<td colspan="3">&nbsp;</td>
</tr>
<tr <cfif getpayment.deposit neq "Y">style="display:none" </cfif>>
<td style="font-size:24px;">#words[2078]#</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="depositamt5" id="depositamt5" value="0.00" style="font: large bolder; text-align:right" onkeyup="calculatetotal(event,'cashc5','voucheramt5')"/>
</td>
</tr>

<tr <cfif getpayment.deposit neq "Y">style="display:none" </cfif>>
<td colspan="3" style="font-size:24px; color:##000;">
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
<td colspan="3">&nbsp;</td>
</tr>
<tr>
<td style="font-size:24px; color:##000;">#words[1297]#</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="paycash5" id="paycash5" style="font: large bolder; text-align:right" value="0.00" onkeyup="calculatetotal(event,'cc15','')"/>
</td>
</tr>
<tr>
<td colspan="3">&nbsp;</td>
</tr>
<tr>
<td style="font-size:24px;">#words[2076]#</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="balanceamt5" id="balanceamt5" value="#numberformat(url.grandtotal,'.__')#" style="font: large bolder; text-align:right" readonly/>
</td>
</tr>
</tr>
<tr>
<th colspan="100%"><div align="center">#words[1347]#</div></th>
</tr>
<tr <cfif getpayment.creditcard neq "Y">style="display:none" </cfif>>
<td style="font-size:16px;">#words[2080]#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc15" id="cc15" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc25','paycash5')" />
</td>
</tr>
<tr <cfif getpayment.creditcard neq "Y">style="display:none" </cfif>>
<td colspan="3">
<input type="radio" name="cctype15" id="cctype151" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype15" id="cctype152" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype15" id="cctype153" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype15" id="cctype154" value="DINERS" />Diners Club
<input type="radio" name="cctype15" id="cctype155" value="CUP" />CUP
</td>
</tr>
<tr <cfif getpayment.creditcard neq "Y">style="display:none" </cfif>>
<td style="font-size:16px;">#words[2081]#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cc25" id="cc25" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'dbc5','cc15')" />
</td>
</tr>
<tr <cfif getpayment.creditcard neq "Y">style="display:none" </cfif>>
<td colspan="3">
<input type="radio" name="cctype25" id="cctype251" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype25" id="cctype252" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype25" id="cctype253" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype25" id="cctype254" value="DINERS" />Diners Club
<input type="radio" name="cctype25" id="cctype255" value="CUP" />CUP

</td>
</tr>
<tr <cfif getpayment.nets neq "Y">style="display:none" </cfif>>
<td style="font-size:16px;">#words[2063]#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="dbc5" id="dbc5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cheq5','cc25')" />
</td>
</tr>

<cfif getgsetup.memberpoint eq 'Y'>
<cftry>
<tr <cfif getpayment.cheque neq "Y">style="display:none" </cfif>>

<cfquery name="getpoints" datasource="#dtssync#">
select ifnull(pointsbf+points-pointsredeem,0) as points from driver where driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.driverno#">
</cfquery>
<td>#words[2112]#</td>
<td style="font-size:16px;">:</td>
<td align="right" style="font-size:16px;"><b>#numberformat(getpoints.points,'.__')#</b><input type="hidden" name="accumpoints" id="accumpoints" value="#getpoints.points#" readonly style="font-size:16px; text-align:right"/>
</td>
</tr>
<cfcatch>
<tr <cfif getpayment.cheque neq "Y">style="display:none" </cfif>>
<td>#words[2112]#</td>
<td style="font-size:16px;">:</td>
<td align="right">#words[2115]#<input type="hidden" name="accumpoints" id="accumpoints" value="0" readonly style="font-size:16px; text-align:right"/>
</td>
</tr>
</cfcatch></cftry>
<cfelse>
<tr style="display:none">
<td align="right"><input type="hidden" name="accumpoints" id="accumpoints" value="9999999999" readonly style="font-size:16px; text-align:right"/>
</td>
</tr>
</cfif>
<tr <cfif getpayment.cheque neq "Y">style="display:none" </cfif>>
<td style="font-size:16px;">#words[2116]#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cheq5" id="cheq5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt5','dbc5')"/>
</td>
</tr>
<tr <cfif getpayment.cheque neq "Y">style="display:none" </cfif>>
<td colspan="3">
#words[2117]# <input type="text" name="chequeno5" id="chequeno5" value="" />
</td>
</tr>
<tr <cfif getpayment.voucher neq "Y">style="display:none" </cfif>>
<td style="font-size:16px;">#words[2077]#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="voucheramt5" id="voucheramt5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt5','cheq5')"/>
</td>
<tr>
<td colspan="3" <cfif getpayment.voucher neq "Y">style="display:none" </cfif>>

<cfif getpayment.vouchertype eq 'system'>
<div id="getvoucherajax"></div>
<input type="hidden" name="vouchertype" id="vouchertype" value="" />
<input type="text" name="voucherno" id="voucherno" value="" onkeyup="calculatetotal(event,'voucherno','voucheramt5')" />
<input type="button" name="multivoucher" id="multivoucher" value="#words[2119]#" onclick="PopupCenter('multivoucher.cfm?','linkname','600','1000');" />
<cfelse>
#words[2120]#
<cfquery name="getvouchertype" datasource="#dts#">
SELECT * FROM vouchertype
</cfquery>
<select name="vouchertype" id="vouchertype" onchange="document.getElementById('voucheramt5').value=document.getElementById('vouchertype').options[document.getElementById('vouchertype').selectedIndex].title;calculatetotal(event,'depositamt5','cheq5')">
<option value="">#words[2118]#</option>
<cfloop query="getvouchertype">
<option value="#getvouchertype.voucherid#" title="#getvouchertype.voucheramt#">#getvouchertype.voucherid# - #getvouchertype.voucherdesp#</option>
</cfloop>
</select>&nbsp;&nbsp;&nbsp;
#words[2121]#
<input type="text" name="voucherno" id="voucherno"  />
</cfif>
</td>
</tr>
</tr>
<cfif hcomid neq 'tcds_i'>
<tr <cfif getpayment.deposit neq "Y">style="display:none" </cfif>>
<td style="font-size:16px;">#words[2078]#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="depositamt5" id="depositamt5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cashc5','voucheramt5')"/>
</td>
</tr>

<tr <cfif getpayment.deposit neq "Y">style="display:none" </cfif>>
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
<tr <cfif getpayment.cashcard neq "Y">style="display:none" </cfif>>
<td style="font-size:16px;">#words[2079]#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="right">
<input type="text" name="cashc5" id="cashc5" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','depositamt5')"/>
</td>
</tr>
<tr>
<td style="font-size:24px;">#words[2075]#</td>
<td style="font-size:24px;">:</td>
<td style="font-size:24px;" align="right">
<input type="text" name="change5" id="change5" size="13" style="font-size:24px;font-weight: bold; text-align:right; font-family: Arial, Helvetica, sans-serif;" value="#numberformat(val(url.grandtotal)*-1,'.__')#" readonly />
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
<td align="center" colspan="3"><input type="button" name="sub_btn" id="sub_btn" value="#words[1104]#" onclick="if(document.getElementById('reservebtn').checked==false){
if(document.getElementById('change5').value*1 < 0){alert('#words[2087]#');return false;}
else if(((document.getElementById('voucheramt5').value*1)+(document.getElementById('cc15').value*1)+(document.getElementById('cc25').value*1)+(document.getElementById('cheq5').value*1)+(document.getElementById('dbc5').value*1)+(document.getElementById('depositamt5').value*1)) >document.getElementById('hidgt5').value*1 && document.getElementById('change5').value*1 !=0){alert('Voucher+Credit Card+Deposit+Net is Over Amount');return false;}
else if(document.getElementById('cheq5').value*1 >document.getElementById('accumpoints').value*1){alert('Points is Over');return false;}
else{document.getElementById('sub_btn').disabled=true;submitpay();return false;}}else{submitpay();return false;}" style="font: large bolder;" /></td>
</tr>
</table>
</form>
<script type="text/javascript">
setTimeout("document.getElementById('paycash5').focus();document.getElementById('paycash5').select();",250);
</script>
</cfoutput>
</cfif> 
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
