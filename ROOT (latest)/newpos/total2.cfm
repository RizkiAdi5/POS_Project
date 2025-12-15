 <link rel="stylesheet" type="text/css" href="table.css" />
 
<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2074, 2062, 2075, 1347, 2063, 2081, 1297, 1298, 2077, 2078, 2079, 2076, 1104">
<cfinclude template="/latest/words.cfm">


<cfif isdefined('grandtotal')>
<cfoutput>
<cfset grandtotal = numberformat(val(grandtotal),'.__')>
<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>
<cfif getgsetup.comboard eq 'Y'>
<cftry>
<div style="display:none">
<cfinvoke component="cfc.comboard" method="display" firstline="" secondlineleft="" secondlineright="#numberformat(grandtotal,',_.__')#" comchannel="#getgsetup.comboardport#" returnvariable="test"/>
</div>
<cfcatch></cfcatch></cftry>
</cfif>
<form action="processprint.cfm" method="post" onsubmit="if(document.getElementById('reservebtn').checked==false){if(document.getElementById('change2').value*1 < 0){alert('Payment is not Enough');return false;}else{document.getElementById('sub_btn').disabled=true;submitpay();return false;}}else{submitpay();return false;}" name="ccform"  id="ccform">

<center>
<table class="table-style-three">
	<tbody>
    <tr>
    <th>
   <table class="table-style-three">
    <tr>
		<td>#words[2074]#:</td>
		<td>
        #numberformat(grandtotal,'.__')#<input type="hidden" name="hidgt2" id="hidgt2" value="#numberformat(grandtotal,'.__')#"  /><input type="hidden" name="payamt2" id="payamt2" value="0"  />
        </td>
	</tr>
	<tr>
		<td>#words[2062]#:</td>
		<td><input type="text" name="cc12" id="cc12" style="font: large bolder; text-align:right" value="#numberformat(grandtotal,'.__')#" onkeyup="calculatetotal(event,'dbc2','')" readonly/></td>
        
	</tr>
	<tr>
<td colspan="3">
<input type="radio" name="cctype1" id="cctype1" value="MASTER" checked="checked"/>Mastercard&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="VISA" />Visa&nbsp;&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="AMEX" />American Express&nbsp;&nbsp;
<input type="radio" name="cctype1" id="cctype1" value="DINERS" />Diners Club
<input type="radio" name="cctype1" id="cctype1" value="CUP" />CUP
</td>
</tr>
<tr style="display:none;">
		<td>#words[2075]#:</td>
		<td><input type="text" name="change2" id="change2" value="0.00" style="font: large bolder; text-align:right" readonly/></td>
	</tr>
    <tr style="display:none;">
<th colspan="100%"><div align="center">#words[1347]#</div></th>
</tr>
    	<tr style="display:none;">
		<td>#words[2063]#:</td>
		<td><input type="text" name="dbc2" id="dbc2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc22','cc12')" /></td>
	</tr>
    	<tr style="display:none;">
		<td>#words[2081]#:</td>
		<td><input type="text" name="cc22" id="cc22" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'paycash2','dbc2')" /></td>
	</tr>
    	<tr style="display:none;">
		<td>#words[1297]#:</td>
		<td><input type="text" name="paycash2" id="paycash2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cheq2','cc22')" /></td>
	</tr>
    	<tr style="display:none;">
		<td>#words[1298]#:</td>
		<td><input type="text" name="cheq2" id="cheq2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt2','paycash2')"/></td>
	</tr>
    <tr style="display:none;">
		<td>#words[2077]#:</td>
		<td><input type="text" name="voucheramt2" id="voucheramt2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt2','cheq2')"/></td>
	</tr>
    <tr style="display:none;">
		<td>#words[2078]#:</td>
		<td><input type="text" name="depositamt2" id="depositamt2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cashc2','voucheramt2')"/></td>
	</tr>
    <tr style="display:none;">
		<td>#words[2079]#:</td>
		<td><input type="text" name="cashc2" id="cashc2" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','depositamt2')"/></td>
	</tr>
    <tr style="display:none;">
		<td>#words[2076]#:</td>
		<td><input type="text" name="balanceamt2" id="balanceamt2" style="font-size:16px; text-align:right" value="#numberformat(val(grandtotal),'.__')#" readonly /></td>
	</tr>
	<tr>
		<td colspan="3" align="center"><input type="submit" name="sub_btn" id="sub_btn" value="#words[1104]#" style="font: large bolder;" /></td>
	</tr>
   </table>
  </th>
  </tr>
	</tbody>
</table>
</center>
</form>
<script type="text/javascript">
setTimeout("document.getElementById('cc12').focus();document.getElementById('cc12').select();",500);
</script>
</cfoutput>
</cfif> 

