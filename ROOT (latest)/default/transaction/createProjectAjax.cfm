<cfquery name="getgsetup" datasource="#dts#">
  select * from gsetup
</cfquery>

<cfform name="CreateCustomer" id="CreateCustomer" method="post" action="/default/transaction/createProjectAjaxProcess.cfm"> 
<table width="1000px" style="font-size:-2">
<tr>
<th width="200px" align="left"><cfoutput>#getgsetup.lproject#</cfoutput> No.</th>
<td>
<cfoutput>
<input type="text" size="30" name="Projectno" value="" maxlength="40">
</cfoutput>
</td>
</tr>
            <tr>
            <th align="left">Description</th>
            <cfif lcase(hcomid) eq "aepl_i" or lcase(hcomid) eq "aeisb_i" or lcase(hcomid) eq "aespl_i" or lcase(hcomid) eq "risb_i">
             <td><cfinput type="text" name="desp" id="web_site" size="50" maxlength="500" ></td>
            <cfelse> 
            <td><cfinput type="text" name="desp" id="web_site" size="50" maxlength="40" ></td>
            </cfif>
            <td>&nbsp;</td>
</tr>
</table>
<cfinput name="SubmitButton" id="SubmitButton" type="submit" value="Submit"/>
</cfform>	
