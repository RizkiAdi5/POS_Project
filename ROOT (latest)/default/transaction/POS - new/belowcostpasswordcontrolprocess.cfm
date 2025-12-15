<cfquery name="getAdminPass" datasource="main">
SELECT userID from users Where userGrpId in ("admin","super","guser","general") and userDept = "#dts#" and userPwd = "#hash(url.password)#"
</cfquery>
<cfif getAdminPass.recordcount neq 0>
<input type="hidden" name="comfirmpassword" id="comfirmpassword" value="1" />
<cfelse>
<input type="hidden" name="comfirmpassword" id="comfirmpassword" value="0" />
</cfif>