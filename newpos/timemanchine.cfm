 <link rel="stylesheet" type="text/css" href="table.css" />

<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2094, 2066,2067,6,1097,536,2065">
<cfinclude template="/latest/words.cfm">

<cfquery name="getlast" datasource="#dts#">
SELECT uuid,trdatetime,type,driver,rem9 from ictrantemp where onhold='Y' group by uuid order by trdatetime desc limit 10 
</cfquery>

<cfquery name="getdriverdetail" datasource="#dts#">
select * from driver where driverno='#getlast.driver#'
</cfquery>
<cfquery name="getsumamt" datasource="#dts#">
select sum(amt) as amt from ictrantemp where uuid='#getlast.uuid#'
</cfquery>

<cfoutput>
<center>
<table class="table-style-three" >
	<thead>
	<tr>
		<th colspan="2"><h2>#words[2066]#</h2></th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td align="center">
			<select name="oldlist" id="oldlist" onchange="ajaxFunction(document.getElementById('gethistorydetail'),'/newpos/timemanchineajax.cfm?uuid='+document.getElementById('oldlist').value);">
			<cfloop query="getlast">
			<option value="#getlast.uuid#">#getlast.type#-#dateformat(getlast.trdatetime,'YYYY-MM-DD')# #timeformat(getlast.trdatetime,'HH:MM:SS')#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td align="center"><input type="button" name="btngo" value="#words[2065]#" onclick="revertback()" /></td>
	</tr>
	</tbody>
</table>
</center>
</cfoutput>


<div id="gethistorydetail">
<cfoutput>
<center>
<table class="table-style-three" width="206">
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
</div>

<cfoutput>
<script type="text/javascript">
	function revertback()
	{
	var answer = confirm("#words[2094]#");
	if(answer)
	{
	var newuuid = document.getElementById('oldlist').value;
	window.location.href="Interface.cfm?uuid="+newuuid+"&counter=#counter#"+"&cashier=#cashier#";
	$('##fade').modal('hide');
	}
	}
</script>
</cfoutput>