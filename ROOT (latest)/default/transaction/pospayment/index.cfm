<cfoutput>
<cfquery name="getcheck" datasource="#dts#">
SELECT * FROM pospayment
</cfquery>

<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<h1>POS Payment Control</h1>
<form name="pospaymentprocess" action="pospaymentprocess.cfm" method="post">
<table>
<tr>
<th width="200px">Credit Card</th>
<td>:</td>
<td width="50px">
<input type="checkbox" name="creditcard" id="creditcard" <cfif getcheck.creditcard eq "Y">Checked</cfif> value="1">
</td>
</tr>
<tr>
<th>NETS</th>
<td>:</td>
<td>
<input type="checkbox" name="nets" id="nets" <cfif getcheck.nets eq "Y">Checked</cfif> value="1">
</td>
</tr>
<tr>
<th>Cash Card</th>
<td>:</td>
<td>
<input type="checkbox" name="cashcard" id="cashcard" <cfif getcheck.cashcard eq "Y">Checked</cfif>  value="1">
</td>
</tr>
<tr>
<th>Voucher</th>
<td>:</td>
<td>
#getcheck.vouchertype#
<input type="checkbox" name="voucher" id="voucher" <cfif getcheck.voucher eq "Y">Checked</cfif>  value="1">
<select name="vouchertype" id="vouchertype">
<option value="type" <cfif getcheck.vouchertype eq "type">selected</cfif>>Voucher Type</option>
<option value="system" <cfif getcheck.vouchertype eq "system">selected</cfif>>Voucher From IMS</option>
</select>
</td>
</tr>
<tr>
<th>Cheque</th>
<td>:</td>
<td>
<input type="checkbox" name="cheque" id="cheque" value="1" <cfif getcheck.cheque eq "Y">Checked</cfif>>
</td>
</tr>
<tr>
<th>Deposit</th>
<td>:</td>
<td>
<input type="checkbox" name="deposit" id="deposit" value="1" <cfif getcheck.deposit eq "Y">Checked</cfif>>
</td>
</tr>

<tr>
<th colspan="100%">Short Cut Key</th>
</tr>

<tr>
<th>Cancel</th>
<td>:</td>
<td>
<input type="text" name="sccancel" id="sccancel" value="#getcheck.sccancel#">
</td>
</tr>

<tr>
<th>Add Deposit</th>
<td>:</td>
<td>
<input type="text" name="scdeposit" id="scdeposit" value="#getcheck.scdeposit#">
</td>
</tr>

<tr>
<th>Cash</th>
<td>:</td>
<td>
<input type="text" name="sccash" id="sccash" value="#getcheck.sccash#">
</td>
</tr>

<tr>
<th>Net</th>
<td>:</td>
<td>
<input type="text" name="scnet" id="scnet" value="#getcheck.scnet#">
</td>
</tr>

<tr>
<th>Credit Card</th>
<td>:</td>
<td>
<input type="text" name="sccreditcard" id="sccreditcard" value="#getcheck.sccreditcard#">
</td>
</tr>

<tr>
<th>Cheque</th>
<td>:</td>
<td>
<input type="text" name="sccheque" id="sccheque" value="#getcheck.sccheque#">
</td>
</tr>

<tr>
<th>Cash Card</th>
<td>:</td>
<td>
<input type="text" name="sccashcard" id="sccashcard" value="#getcheck.sccashcard#">
</td>
</tr>

<tr>
<th>Multi Payment</th>
<td>:</td>
<td>
<input type="text" name="scmulti" id="scmulti" value="#getcheck.scmulti#">
</td>
</tr>

<tr>
<th>Close</th>
<td>:</td>
<td>
<input type="text" name="scclose" id="scclose" value="#getcheck.scclose#">
</td>
</tr>

<tr>
<th>Search</th>
<td>:</td>
<td>
<input type="text" name="scsearch" id="scsearch" value="#getcheck.scsearch#">
</td>
</tr>

<tr>
<th>Focus Item No</th>
<td>:</td>
<td>
<input type="text" name="scfocus" id="scfocus" value="#getcheck.scfocus#">
</td>
</tr>

<tr>
<th>POS Sync</th>
<td>:</td>
<td>
<select name="possync" id="possync">
<option value="1" <cfif getcheck.possync eq '1'></cfif>>Pos Default Sync</option>
<option value="2" <cfif getcheck.possync eq '1'></cfif>>Pos Net Sync (purhcase and adjustment all from POS)</option>
</select>

</td>
</tr>


<tr>
<td colspan="3" align="center">
<input type="submit" name="pos_sub_btn" id="pos_sub_btn" value="Save" />
</td>
</tr>
</table>
</form>
</cfoutput>