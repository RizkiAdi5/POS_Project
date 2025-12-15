<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<cfoutput>
<form action="" method="post" onsubmit="" name="ccformremark"  id="ccformremark">
<table width="570px" >
<!---
<tr style="display:none">
<th colspan="100%"><div align="center">Delivery Address</div></th>
</tr>
<tr style="display:none">
<td width="250px" style="font-size:16px;" height="30px">Name</td>
<td width="20px" style="font-size:16px;">:</td>
<td width="300px" align="left" style="font-size:16px;">
<cfquery name="getcust" datasource="#dts#">
select name,name2,daddr1,daddr2,daddr3,daddr4,dattn,dphone,dfax from #target_arcust# where custno='#url.custno#'
</cfquery>
<input type="text" name="delname" id="delname" value="#getcust.name#" maxlength="40" size="50" /> <input type="button" name="changedaddr" id="changedaddr" onClick="ColdFusion.Window.show('changedaddr');" value="Change Del Add">
</td>
</tr>
<tr style="display:none">
<td width="250px" style="font-size:16px;" height="30px"></td>
<td width="20px" style="font-size:16px;"></td>
<td width="300px" align="left" style="font-size:16px;"><input type="text" name="delname2" id="delname2" value="#getcust.name2#" maxlength="40" size="50" /></td>
</tr>
<tr style="display:none">
<td style="font-size:16px; color:##000;">Delivery Address</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">
<input type="text" name="deladd1" id="deladd1" value="#getcust.daddr1#" maxlength="35" size="50" />
</td>
</tr>

<tr style="display:none">
<td style="font-size:16px; color:##000;"></td>
<td style="font-size:16px;"></td>
<td style="font-size:16px;" align="left">
<input type="text" name="deladd2" id="deladd2" value="#getcust.daddr2#" maxlength="35" size="50" />
</td>
</tr>

<tr style="display:none">
<td style="font-size:16px; color:##000;"></td>
<td style="font-size:16px;"></td>
<td style="font-size:16px;" align="left">
<input type="text" name="deladd3" id="deladd3" value="#getcust.daddr3#" maxlength="35" size="50" />
</td>
</tr>

<tr style="display:none">
<td style="font-size:16px; color:##000;"></td>
<td style="font-size:16px;"></td>
<td style="font-size:16px;" align="left">
<input type="text" name="deladd4" id="deladd4" value="#getcust.daddr4#" maxlength="35" size="50" />
</td>
</tr>
<tr style="display:none">
<td style="font-size:16px; color:##000;">Delivery Attention</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">
<input type="text" name="delattn" id="delattn" value="#getcust.dattn#" maxlength="40" size="50" />
</td>
</tr>
<tr style="display:none">
<td style="font-size:16px; color:##000;">Delivery Tel</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">
<input type="text" name="deltel" id="deltel" value="#getcust.dphone#" maxlength="25" size="50" />
</td>
</tr>
<tr style="display:none">
<td style="font-size:16px; color:##000;">Delivery Fax</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">
<input type="text" name="delfax" id="delfax" value="#getcust.dfax#" maxlength="25" size="50" />
</td>
</tr>
--->

</tr>
<tr>
<th colspan="100%"><div align="center">Remarks</div></th>
</tr>
<tr>
<td style="font-size:16px;">#getgsetup.rem5#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">

			<cfif trim(getGsetup.remark5list) eq ''>
            <input type="text" name="hidrem5" id="hidrem5" value="" maxlength="80" size="50" />
            <cfelse>
            <select name="hidrem5" id="hidrem5">
            <option value="">Please choose</option>
            <cfloop list="#getGsetup.remark5list#" index="i">
            <option value="#i#" >#i#</option>
            </cfloop>
            </select>
            </cfif>

</td>
</tr>

<tr>
<td style="font-size:16px;">#getgsetup.rem6#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">

			<cfif trim(getGsetup.remark6list) eq ''>
            <input type="text" name="hidrem6" id="hidrem6" value="" maxlength="80" size="50" />
            <cfelse>
            <select name="hidrem6" id="hidrem6">
            <option value="">Please choose</option>
            <cfloop list="#getGsetup.remark6list#" index="i">
            <option value="#i#" >#i#</option>
            </cfloop>
            </select>
            </cfif>

</td>
</tr>

<tr>
<td style="font-size:16px;">#getgsetup.rem7#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">

			<cfif trim(getGsetup.remark7list) eq ''>
            <input type="text" name="hidrem7" id="hidrem7" value="" maxlength="80" size="50" />
            <cfelse>
            <select name="hidrem7" id="hidrem7">
            <option value="">Please choose</option>
            <cfloop list="#getGsetup.remark7list#" index="i">
            <option value="#i#">#i#</option>
            </cfloop>
            </select>
            </cfif>
</td>
</tr>

<tr>
<td style="font-size:16px;">#getgsetup.rem8#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">
			<cfif trim(getGsetup.remark8list) eq ''>
            <input type="text" name="hidrem8" id="hidrem8" value="" maxlength="80" size="50" />
            <cfelse>
            <select name="hidrem8" id="hidrem8">
            <option value="">Please choose</option>
            <cfloop list="#getGsetup.remark8list#" index="i">
            <option value="#i#">#i#</option>
            </cfloop>
            </select>
            </cfif>
</td>
</tr>

<tr>
<td style="font-size:16px;">#getgsetup.rem9#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">

			<cfif trim(getGsetup.remark9list) eq ''>
            <input type="text" name="hidrem9" id="hidrem9" value="" maxlength="80" size="50" />
            <cfelse>
            <select name="hidrem9" id="hidrem9">
            <option value="">Please choose</option>
            <cfloop list="#getGsetup.remark9list#" index="i">
            <option value="#i#" >#i#</option>
            </cfloop>
            </select>
            </cfif>
</td>
</tr>

<tr>
<td style="font-size:16px;">#getgsetup.rem10#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">
<cfif (lcase(hcomid) eq "bnbm_i" or lcase(HcomID) eq "bnbp_i") >
<div id="termajax"></div>
<select name="hidrem10" id="hidrem10" onChange="bnbpupdatedetail();">
            	<option value="">Please Choose a Remark</option>
            	<option value="">Remark 1</option>
                <option value="2">Remark 2</option>
                <option value="3">Remark 3</option>
                <option value="4">Remark 4</option>
                <option value="5">Remark 5</option>
            	</select>
<cfelse>
			<cfif trim(getGsetup.remark10list) eq ''>
            <input type="text" name="hidrem10" id="hidrem10" value="" maxlength="80" size="50" />
            <cfelse>
            <select name="hidrem10" id="hidrem10">
            <option value="">Please choose</option>
            <cfloop list="#getGsetup.remark10list#" index="i">
            <option value="#i#" >#i#</option>
            </cfloop>
            </select>
            </cfif>
</cfif>
</td>
</tr>

<tr>
<td style="font-size:16px;">#getgsetup.rem11#</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">
<cfif lcase(hcomid) eq "bnbm_i" or lcase(hcomid) eq "bnbp_i">
<textarea name="hidrem11" id="hidrem11" cols='60' rows='4'></textarea>
<cfelse>
<input type="text" name="hidrem11" id="hidrem11" value="" maxlength="40" size="50"/>
</cfif>
</td>
</tr>

<tr>
<td align="center" colspan="3"><input type="button" name="remarkbtn" id="remarkbtn" value="Accept" onclick="updateremark();ColdFusion.Window.hide('remarks');"/></td>
</tr>
</table>
</form>

</cfoutput>