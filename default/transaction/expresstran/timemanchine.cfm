<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
    <script type='text/javascript' src='/ajax/core/engine.js'></script>
	<script type='text/javascript' src='/ajax/core/util.js'></script>
	<script type='text/javascript' src='/ajax/core/settings.js'></script>
    <script type='text/javascript' src='/ajax/core/shortcut.js'></script>
    <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
    <link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>
    <script type="text/javascript" src="/scripts/prototypenew.js" ></script>
    
<h2>Auto Save</h2>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfquery name="getlast" datasource="#dts#">
SELECT uuid,trdatetime,type,driver,rem9 from ictrantemp where   type='#url.type#' group by uuid order by trdatetime desc limit 30 
</cfquery>
<cfoutput>
<table>
<tr>
<td>
<select name="oldlist" id="oldlist" onchange="ajaxFunction(document.getElementById('gethistorydetail'),'/default/transaction/expresstran/timemanchineajax.cfm?type=#url.type#&uuid='+document.getElementById('oldlist').value);">
<cfloop query="getlast">
<option value="#getlast.uuid#">#getlast.type#-#dateformat(getlast.trdatetime,'YYYY-MM-DD')# #timeformat(getlast.trdatetime,'HH:MM:SS')#</option>
</cfloop>
</select>
</td>
</tr>
<tr>
<td>
<input type="button" name="btngo" value="Recover" onclick="revertback()" />
</td>
</tr>
</table>
</cfoutput>
<cfquery name="getdriverdetail" datasource="#dts#">
select * from driver where driverno='#getlast.driver#'
</cfquery>
<cfquery name="getsumamt" datasource="#dts#">
select sum(amt) as amt from ictrantemp where uuid='#getlast.uuid#'
</cfquery>

<div id="gethistorydetail">
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
#getlast.rem9#
</td>
</tr>
</table>
</cfoutput>
</div>


<cfoutput>
<script type="text/javascript">
	function revertback()
	{
	var answer = confirm('Are you sure you want to proceed?')
	if(answer)
	{
	var newuuid = document.getElementById('oldlist').value;
	opener.window.location.href="index.cfm?type=#url.type#&uuid="+newuuid;
	window.close();
	}
	}
</script>
</cfoutput>