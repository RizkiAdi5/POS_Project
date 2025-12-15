<cfquery name="getAdminPass" datasource="main">
SELECT userID from users Where userGrpId in ("admin","super") and userDept = "#dts#" and userPwd = "#hash(form.passwordString)#"
</cfquery>
<cfif getAdminPass.recordcount neq 0>
<script type="text/javascript">
addItemAdvance();
ColdFusion.Window.hide('negativestock');
</script>
<cfelse>
<h4>Wrong Password</h4>
<cfform action="negativestock.cfm" method="post" name="wrongpass" id="wrongpass">
<input type="submit" name="submit_btn" value="Retry"  />
</cfform>
</cfif>