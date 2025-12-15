<cfoutput>
<h1>Choose Agent</h1>
<cfform name="chooseagent" id="chooseagent" action="" method="post">
<table>
<tr>
<th width="100px">Agent</th>
<td width="15px">:</td>
<td width="200px">
<cfquery name="getagent" datasource="#dts#">
SELECT "Please select an agent" as agentdesp, "" as agent
            union all
            SELECT concat(agent,' - ',desp) as agentdesp, agent FROM icagent
</cfquery>

<cfselect name="agentlist" id="agentlist" query="getagent" value="agent" display="agentdesp">
</cfselect>
</td>
</tr>
<tr>
<td colspan="3" align="center">
<input type="button" name="counter_btn" id="counter_btn" value="Go" onClick="
if(document.getElementById('agentlist').value == '')
{
	alert('Please Choose Agent');
}
else{
	for (var idx=0;idx<document.getElementById('agent').options.length;idx++) {
		if (document.getElementById('agentlist').value==document.getElementById('agent').options[idx].value) {
		document.getElementById('agent').options[idx].selected=true;
		}
	} 
    ColdFusion.Window.hide('chooseagent');
    document.getElementById('sub_btn').disabled=false;
}
">
</td>
</tr>
</table>
</cfform>
</cfoutput>