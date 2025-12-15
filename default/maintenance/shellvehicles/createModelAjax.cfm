<cfquery name="getgsetup" datasource="#dts#">
  select * from gsetup
</cfquery>

<cfform name="CreateCustomer" id="CreateCustomer" method="post" action="/default/maintenance/shellvehicles/createmodelAjaxProcess.cfm"> 
<table width="1000px" style="font-size:-2">
<tr>
<th width="200px" align="left">Make No.</th>
<td>
<cfoutput>
<input type="text" size="30" name="modelno" value="" maxlength="30">
</cfoutput>
</td>
</tr>
            <tr>
            <th align="left">Description</th>
            <td><cfinput type="text" name="desp" id="desp" size="50" ></td>
            <td>&nbsp;</td>
</tr>
</table>
<cfinput name="SubmitButton" id="SubmitButton" type="submit" value="Submit"/>
</cfform>	
