<cfoutput>
<h1>Delivery Detail</h1>
<cfform name="deliverydetail" method="post" id="deliverydetail" action="delprocess.cfm">
<table>
<tr>
<th width="150px">
Delivery Date
</th>
<td>:</td>
<td>
<input type="text" name="deliverydate" id="deliverydate" value="" /><img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('deliverydate'));">&nbsp;(DD/MM/YYYY)
</td>
</tr>
<tr>
<th width="150px">
Delivery Time
</th>
<td>:</td>
<td>
<input type="text" name="deliverytime" id="deliverytime" value="" />
</td>
</tr>
<tr>
<th colspan="3">Member</th>
</tr>
<tr>
<th>Member Id</th>
<td>:</td>
<td>
<cfinput type="text" name="memberidsearch" id="memberidsearch" size="35" readonly="yes">&nbsp;&nbsp;<input type="button" name="searchmembet_btn" id="searchmember_btn" onclick="document.getElementById('checkmain').value='in';ColdFusion.Window.show('searchmember');" value="Search" />
</td>
</tr>
<tr>
<th>Name</th>
<td>:</td>
<td>
<cfinput type="text" name="membernamesearch" id="membernamesearch" size="35">
</td>
</tr>
<tr>
<th>Tel:</th>
<td>:</td>
<td>
<cfinput type="text" name="membertelsearch" id="membertelsearch" size="35">
</td>
</tr>
<tr>
<th>Address</th>
<td>:</td>
<td>
<cfinput type="text" name="memberadd1search" id="memberadd1search" size="45">
</td>
</tr>
<tr>
<td></td>
<td></td>
<td>
<cfinput type="text" name="memberadd2search" id="memberadd2search" size="45">
</td>
</tr>
<tr>
<td></td>
<td></td>
<td>
<cfinput type="text" name="memberadd3search" id="memberadd3search" size="45">
</td>
</tr>
<tr>
<td colspan="3" align="center">
<input type="submit" name="del_btn" id="del_btn" value="OK" onclick="" />
</td>
</tr>
</table>
</cfform>
<h1>Create New Member</h1>
<cfform action="neweuprocess.cfm" method="post" id="euform" name="euform">
<table>
<tr>
<th>Member Id</th>
<td>:</td>
<td>
<cfinput type="text" name="memberid" id="memberid" required="yes" message="Member Id is Required" size="35">
</td>
</tr>
<tr>
<th>Name</th>
<td>:</td>
<td>
<cfinput type="text" name="membername" id="membername" required="yes" message="Name is Required" size="35">
</td>
</tr>
<tr>
<th>Tel:</th>
<td>:</td>
<td>
<cfinput type="text" name="membertel" id="membertel" required="yes" message="Telephone is Required" size="35">
</td>
</tr>
<tr>
<th>Address</th>
<td>:</td>
<td>
<cfinput type="text" name="memberadd1" id="memberadd1" size="45">
</td>
</tr>
<tr>
<td></td>
<td></td>
<td>
<cfinput type="text" name="memberadd2" id="memberadd2" size="45">
</td>
</tr>
<tr>
<td></td>
<td></td>
<td>
<cfinput type="text" name="memberadd3" id="memberadd3" size="45">
</td>
</tr>
<tr>
<td colspan="3" align="center"><input type="submit" name="sub_btn" id="sub_btn" value="Create"></td>
</tr>
</table>
</cfform>
</cfoutput>