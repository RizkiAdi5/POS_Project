
<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2067,6,1097,536">
<cfinclude template="/latest/words.cfm">

<cfquery name="getsumamt" datasource="#dts#">
select sum(amt) as amt,driver,rem9 from ictrantemp where uuid='#url.uuid#'
</cfquery>

<cfquery name="getdriverdetail" datasource="#dts#">
select * from driver where driverno='#getsumamt.driver#'
</cfquery>

<cfoutput>
<center>
<table>
	<tbody>
	<tr>
		<td>#words[2067]#</td>
		<td>#getdriverdetail.name# #getdriverdetail.name2#</td>
	</tr>
	<tr>
		<td>#words[6]#</td>
		<td>#getdriverdetail.add1# #getdriverdetail.add2# #getdriverdetail.add3#</td>
	</tr>
	<tr>
		<td>#words[1097]#</td>
		<td>#numberformat(getsumamt.amt,',_.__')#</td>
	</tr>
	<tr>
		<td>#words[536]#</td>
		<td>#getlast.rem9#</td>
	</tr>
	</tbody>
</table>
</center>
</cfoutput>
