<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1349, 585, 1276">
<cfinclude template="/latest/words.cfm">

<cfoutput>
<h1>#words[1349]#</h1>
<cfform name="choosecounter" id="choosecounter" action="" method="post">
<table>
<tr>
<th width="100px">#words[585]#</th>
<td width="15px">:</td>
<td width="200px">
<cfquery name="getcounter" datasource="#dts#">
SELECT "" as counterid,"Pilih Konter" as counterdesp
union all
SELECT * from (
SELECT counterid, concat(counterid,' - ',counterdesp) as counterdesp FROM counter order by counterid) as a
</cfquery>
<cfquery name="getbond" datasource="#dts#">
Select counterid FROM counter WHERE bonduser = <cfqueryparam cfsqltype="cf_sql_varchar" value="#huserid#">
</cfquery>

<cfselect name="counterlist" id="counterlist" query="getcounter" value="counterid" display="counterdesp" selected="#getbond.counterid#">
</cfselect>
</td>
</tr>
<tr>
<td colspan="3" align="center">
<input type="button" name="counter_btn" id="counter_btn" value="#words[1276]#" onClick="
if(document.getElementById('counterlist').value == '')
{
    if(confirm('The counter is empty, are you sure you want to proceed with empty counter?'))
    {
    ColdFusion.Window.hide('choosecounter');
    }
    else
    {
    document.getElementById('counterlist').focus();
    }
}
else
{
	if(document.getElementById('counterlist').value != '#getbond.counterid#')
    {
        if(confirm('The counter you selected is not bond to you, are you sure you want to proceed with this counter?'))
        {
        document.getElementById('counterinfo').value=document.getElementById('counterlist').value;
        ColdFusion.Window.hide('choosecounter');        
        }
        else
        {
        document.getElementById('counterlist').focus();
        }
    
    }
    else
    {
    	document.getElementById('counterinfo').value=document.getElementById('counterlist').value;
        ColdFusion.Window.hide('choosecounter');
    }
};document.getElementById('expressservicelist').focus();
">
</td>
</tr>
</table>
</cfform>
</cfoutput>