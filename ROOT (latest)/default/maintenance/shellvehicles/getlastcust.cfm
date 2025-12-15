<cfsetting showdebugoutput="no">

<cfquery name="getlastcust" datasource="#dts#">
select * from #target_arcust# where custno='#url.member#'
</cfquery>

<cfoutput>
<table align="left">
<tr>
<th width="50%">#dbname# Name</th>
<td><input type="text" name="b_name" id="b_name" value="#getcustdetail.name#" maxlength="40" size="40"/></td>
</tr>
<tr>
<th></th>
<td><input type="text" name="b_name2" id="b_name2" value="#getcustdetail.name2#" maxlength="40" size="40"/></td>
</tr>
<tr>
<th>Address</th>
<td>
<input type="text" name="b_add1" id="b_add1" value="#getcustdetail.add1#" maxlength="35" size="40"></td>
</tr>
<tr>
<th></th>
<td>
<input type="text" name="b_add2" id="b_add2" value="#getcustdetail.add2#" maxlength="35" size="40"></td>
</tr>
<tr>
<th></th>
<td>
<input type="text" name="b_add3" id="b_add3" value="#getcustdetail.add3#" maxlength="35" size="40"></td>
</tr>
<tr>
<th></th>
<td>
<input type="text" name="b_add4" id="b_add4" value="#getcustdetail.add4#" maxlength="35" size="40"></td>
</tr>
<tr>
<th>Tel</th>
<td>
<input type="text" name="b_phone" id="b_phone" value="#getcustdetail.phone#" maxlength="40" size="40"></td>
</tr>
<tr>
<th>Attention</th>
<td>
<input type="text" name="b_attn" id="b_attn" value="#getcustdetail.attn#" maxlength="35" size="40"><input type="button" name="Sattn1" value="Ajax Search" onClick="javascript:ColdFusion.Window.show('findattention');"></td>
</tr>
</table>
<cfquery name="getcurrratecust" datasource="#dts#">
    SELECT currrate FROM #target_currency# where currcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getcustdetail.currcode#" >
    </cfquery>
    
    <cfif getcurrratecust.currrate neq "">
    <cfset currratecust = getcurrratecust.currrate>
    <cfelse>
    <cfset currratecust = 1>
	</cfif>
<input type="hidden" name="driverajaxhid" id="driverajaxhid" value="#getcustdetail.end_user#" />
<input type="hidden" name="agentajaxhid" id="agentajaxhid" value="#getcustdetail.agent#" />
<input type="hidden" name="termajaxhid" id="termajaxhid" value="#getcustdetail.term#" />
<input type="hidden" name="currcodeajaxhid" id="currcodeajaxhid" value="#getcustdetail.currcode#" />
<input type="hidden" name="currrateajaxhid" id="currrateajaxhid" value="#getcurrratecust.currrate#" />
<input type="hidden" name="ngstcusthid" id="ngstcusthid" value="#getcustdetail.NGST_CUST#" />

</cfoutput>
