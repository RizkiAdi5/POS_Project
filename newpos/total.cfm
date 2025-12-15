 <link rel="stylesheet" type="text/css" href="table.css" />
 
<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2074, 1297, 2075, 1347, 2079, 2080, 2063, 1298, 2077, 2076, 2081, 1104,2078">
<cfinclude template="/latest/words.cfm">
 
<cfif isdefined('grandtotal')>
<cfoutput>
<cfquery name="getdefault" datasource="#dts#">
SELECT dfpos FROM gsetup
</cfquery>
<cfif getdefault.dfpos eq "0.05">
<cfif lcase(hcomid) eq 'tcds_i'>
<cfset grandtotal = numberformat((numberformat(Ceiling(val(grandtotal)* 2*10)/10,'._')/2),'.__')>
<cfelse>
<cfset grandtotal = numberformat((numberformat(val(grandtotal)* 2,'._')/2),'.__')>
</cfif>
<cfelse>
<cfset grandtotal = numberformat(numberformat(val(grandtotal),'._'),'.__')>
</cfif>
<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>
<cfset btname = #btnname# />
<cfif getgsetup.comboard eq 'Y'>
<cftry>
<div style="display:none">
<cfinvoke component="cfc.comboard" method="display" firstline="" secondlineleft="" secondlineright="#numberformat(grandtotal,',_.__')#" comchannel="#getgsetup.comboardport#" returnvariable="test"/>
</div>
<cfcatch></cfcatch></cftry>
</cfif>
<form action="processprint.cfm" method="post" onsubmit="if(document.getElementById('reservebtn').checked==false){if(document.getElementById('change0').value*1 < 0){alert('Payment is not Enough');return false;}else if(document.getElementById('voucheramt0').value*1 >document.getElementById('hidgt0').value*1 && document.getElementById('change0').value*1 !=0){alert('Voucher is Over Amount');return false;}else{document.getElementById('sub_btn').disabled=true;submitpay();return false;}}else{submitpay();return false;}" >


<table class="table-style-three">
	<tbody>
    <tr>
    <th>
   <table class="table-style-three">
    <tr>
		<td>#words[2074]#:</td>
		<td>
        #numberformat(grandtotal,'.__')#<input type="hidden" name="hidgt0" id="hidgt0" value="#numberformat(grandtotal,'.__')#"  /><input type="hidden" name="payamt0" id="payamt0" value="0"  /><input type="hidden" id="changehighlight" name="changehighlight" value="1" />
        </td>
         <td rowspan="11">
<cfinclude template="button.cfm"> 
</td>
	</tr>
	<tr>
		<td>#words[1297]#:</td>
		<td><input type="text" name="paycash0" id="paycash0" style="font: large bolder; text-align:right" value="#numberformat(grandtotal,'.__')#" onClick="" onkeyup="calculatetotal(event,'cc10','')" /></td>
        
	</tr>
    	<tr>
		<td>#words[2075]#:</td>
		<td><input type="text" name="change0" id="change0" value="0.00" style="font: large bolder; text-align:right" readonly/></td>
	</tr>
    <tr style="display:none;">
<th colspan="100%"><div align="center">#words[1347]#</div></th>
</tr>
    	<tr>
		<td>#words[2079]#:</td>
		<td><input type="text" name="cc10" id="cc10" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cc20','paycash0')" /></td>
	</tr>
    	<tr>
		<td>#words[2080]#:</td>
		<td><input type="text" name="cc20" id="cc20" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'dbc0','cc10')" /></td>
	</tr>
    	<tr>
		<td>#words[2063]#:</td>
		<td><input type="text" name="dbc0" id="dbc0" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cheq0','cc20')" /></td>
	</tr>
    	<tr>
		<td>#words[1298]#:</td>
		<td><input type="text" name="cheq0" id="cheq0" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'voucheramt0','dbc0')"/></td>
	</tr>
    <tr>
		<td>#words[2077]#:</td>
		<td><input type="text" name="voucheramt0" id="voucheramt0" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'depositamt0','cheq0')"/></td>
	</tr>
    <tr>
		<td>#words[2078]#:</td>
		<td><input type="text" name="depositamt0" id="depositamt0" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'cashc0','voucheramt0')"/></td>
	</tr>
    <tr>
		<td>#words[2081]#:</td>
		<td><input type="text" name="cashc0" id="cashc0" value="0.00" style="font-size:16px; text-align:right" onkeyup="calculatetotal(event,'','depositamt0')"/></td>
	</tr>
    <tr>
		<td>#words[2076]#:</td>
		<td><input type="text" name="balanceamt0" id="balanceamt0" style="font-size:16px; text-align:right" value="#numberformat(val(grandtotal),'.__')#" readonly /></td>
	</tr>
	<tr>
		<td colspan="3" align="center"><input type="submit" name="sub_btn" id="sub_btn" value="Accept" style="font: large bolder;" /></td>
	</tr>
   </table>
  </th>
  </tr>
	</tbody>
</table>

</form>
<script type="text/javascript">
setTimeout("document.getElementById('paycash0').focus();document.getElementById('paycash0').select();",500);
</script>
</cfoutput>
</cfif> 
