<cfoutput>
<cfform name="checkcreditlimitform" id="checkcreditlimitform" method="post" action="creditlimitpasswordprocess.cfm">
<h3>Credit limit / Credit Term is over</h3>
<table>
<tr>
<th>Password</th>
<td>
<cfinput type="text" name="creditlimitpassword" id="creditlimitpassword" value="" required="yes" message="Password is Required"/>
</td>
</tr>
<tr>
<td colspan="2">
<input type="submit" name="sub_btn" id="sub_btn" value="Submit" />
</td>
</tr>
</table>

</cfform>
</cfoutput>
