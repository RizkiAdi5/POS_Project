<cfoutput>
<script type="text/javascript" src="/scripts/prototypenew.js" ></script>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<div id="updatechatrequest">
<cfquery name="getchat" datasource="chattrack">
SELECT * FROM chattrack order by tracktime DESC limit 10
</cfquery>
<table width="500px">
<tr>
<th>System</th>
<th>User Name</th>
<th>Company ID</th>
<th>Time</th>
</tr>
<cfloop query="getchat">
<tr>
<td>#getchat.type#</td>
<td>#getchat.username#</td>
<td>#getchat.comid#</td>
<td>#dateformat(getchat.tracktime,'YYYY-MM-DD')# - #timeformat(getchat.tracktime,'HH:MM:SS')#</td>
</tr>
</cfloop>
</table>
</div>
<script type="text/javascript">
new Ajax.PeriodicalUpdater('updatechatrequest','/chatsupportajax.cfm',{
method: 'get', frequency: 5, decay: 0
});
</script>
</cfoutput>