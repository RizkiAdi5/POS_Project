<cfquery name="getsumamt" datasource="#dts#">
select sum(amt) as amt,driver,rem9 from ictrantemp where uuid='#url.uuid#'
</cfquery>

<cfquery name="getdriverdetail" datasource="#dts#">
select * from driver where driverno='#getsumamt.driver#'
</cfquery>


<cfoutput>
<table>
<tr>
<th>Member Name</th>
<td>
#getdriverdetail.name# #getdriverdetail.name2#
</td>
</tr>
<tr>
<th>Address</th>
<td>
#getdriverdetail.add1# #getdriverdetail.add2# #getdriverdetail.add3#
</td>
</tr>
<tr>
<th>Amount</th>
<td>
#numberformat(getsumamt.amt,',_.__')#
</td>
</tr>
<tr>
<th>Remark</th>
<td>
#getsumamt.rem9#
</td>
</tr>
</table>
</cfoutput>
