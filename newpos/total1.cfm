 <link rel="stylesheet" type="text/css" href="table.css" />
 
<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2074, 2063, 2075, 1347, 2080, 2081, 1297, 1298, 2077, 2078, 2079, 2076, 1104">
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
<form action="processprint.cfm" method="post" onsubmit="if(document.getElementById('reservebtn').checked==false){if(document.getElementById('change1').value*1 < 0){alert('Payment is not Enough');return false;}else{document.getElementById('sub_btn').disabled=true;submitpay();return false;}}else{submitpay();return false;}">


<center>
<table class="table-style-three">
	<tbody>
    <tr>
    <th>
   <table class="table-style-three">
    <tr>
		<td>#words[2074]#:</td>
		<td>
        #numberformat(grandtotal,'.__')#<input type="hidden" name="hidgt1" id="hidgt1" value="#numberformat(grandtotal,'.__')#"  /><input type="hidden" name="payamt1" id="payamt1" value="0"  />
        </td>
	</tr>
	<tr>
		<td>#words[2063]#:</td>
		<td><input type="text" name="dbc1" id="dbc1" style="font: large bolder; text-align:right" value="#numberformat(grandtotal,'.__')#" onkeyup="calculatetotal(event,'cc11','')" readonly/></td>
        
	</tr>
    	<tr>
		<td>#words[2075]#:</td>
		<td><input type="text" name="change1" id="change1" value="0.00" style="font: large bolder; text-align:right" readonly/></td>
	</tr>
    <tr style="display:none;">
<th colspan="100%"><div align="center">#words[1347]#</div></th>
</tr>
    	<tr style="display:none;">
		<td>#words[2080]#:</td>
		<td><input type="text" name="cc11" id="cc11" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc21','dbc1')" /></td>
	</tr>
    	<tr style="display:none;">
		<td>#words[2081]#:</td>
		<td><input type="text" name="cc21" id="cc21" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'paycash1','cc11')" /></td>
	</tr>
    	<tr style="display:none;">
		<td>#words[1297]#:</td>
		<td><input type="text" name="paycash1" id="paycash1" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cheq1','cc21')" /></td>
	</tr>
    	<tr style="display:none;">
		<td>#words[1298]#:</td>
		<td><input type="text" name="cheq1" id="cheq1" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt1','paycash1')"/></td>
	</tr>
    <tr style="display:none;">
		<td>#words[2077]#:</td>
		<td><input type="text" name="voucheramt1" id="voucheramt1" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt1','cheq1')"/></td>
	</tr>
    <tr style="display:none;">
		<td>#words[2078]#:</td>
		<td><input type="text" name="depositamt1" id="depositamt1" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cashc1','voucheramt1')"/></td>
	</tr>
    <tr style="display:none;">
		<td>#words[2079]#:</td>
		<td><input type="text" name="cashc1" id="cashc1" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','depositamt1')"/></td>
	</tr>
    <tr style="display:none;">
		<td>#words[2076]#:</td>
		<td><input type="text" name="balanceamt1" id="balanceamt1" style="font-size:16px; text-align:right" value="#numberformat(val(grandtotal),'.__')#" readonly /></td>
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
setTimeout("document.getElementById('dbc1').focus();document.getElementById('dbc1').select();",500);

</script>
</cfoutput>
</cfif> 

