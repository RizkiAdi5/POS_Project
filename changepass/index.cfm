<cfif isdefined('form.sub_btn')>
<cfquery name="checkoldpass" datasource="#dts#">
SELECT userid FROM main.users WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#"> and userpwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.oldpass)#"> and userbranch = "#dts#"
</cfquery>
	<cfif checkoldpass.recordcount neq 1>
    	<h3>Wrong Old Password</h3>
    <cfelse>
        <cfquery name="updatepass" datasource="#dts#">
        UPDATE main.users SET 
        userpwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.newpass)#">
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getauthuser()#"> and userpwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.oldpass)#"> and userbranch = "#dts#"
        </cfquery>
        <h3>Change Password Success!</h3>
    </cfif>
</cfif>
<cfoutput>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<h1>Change Password</h1>
<cfform name="changepassword" id="changepassword" action="" method="post" preservedata="no" onsubmit="if(document.getElementById('newpassrep').value != document.getElementById('newpass').value){alert('New Password and New Password Repeat is not same');return false;} else {return _CF_checkchangepassword(this);}">
<table>
<tr>
<th>Old Password</th>
<td>:</td>
<td><cfinput type="password" name="oldpass" id="oldpass" required="yes" message="Old Password is Required." size="30"></td>
</tr>
<tr>
<th>New Password</th>
<td>:</td>
<td><cfinput type="password" name="newpass" id="newpass" required="yes" message="New Password is Required." size="30" ></td>
</tr>
<tr>
<th>New Password Repeat</th>
<td>:</td>
<td><cfinput type="password" name="newpassrep" id="newpassrep" required="yes" message="New Password Repeat is Required." size="30" ></td>
</tr>
<tr>
<td colspan="100%" align="center">
<input type="submit" name="sub_btn" id="sub_btn" value="Change Password">
</td>
</tr>
</table>
</cfform>
</cfoutput>