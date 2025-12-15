<cfquery name="getAdminPass" datasource="main">
SELECT userID from users Where userGrpId in ("admin","super","guser") and userDept = "#dts#" and userPwd = "#hash(url.passwordString)#"
</cfquery>
<cfif getAdminPass.recordcount neq 0>
<input type="hidden" name="checkpasswordnegaqty" id="checkpasswordnegaqty" value="correct" />
<cfelse>
<input type="hidden" name="checkpasswordnegaqty" id="checkpasswordnegaqty" value="wrong" />

</cfif>