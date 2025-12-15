<html>
<head>
<title>User Process</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfparam name="status" default="">

<cfquery datasource='main' name="checkUserExist">
	select userid 
	from users 
	where userId='#form.userId#';
</cfquery>

<cfset form.userPwd = hash('#form.userPwd#')>

<cfif checkUserExist.recordcount GT 0 >
	<cfif form.mode eq "Create">
		<h2>This User ID has been used. Please kindly create another one. Thanks.</h2>
		<cfabort>
	<cfelseif form.mode eq "Delete">
		<cfquery name="insert" datasource="main">
			insert into users_d (userID, userPwd, userGrpID, userName, userBranch, userDept, userCty, userEmail, lastLogin, userDirectory, linktoams, status, location, start_time, end_time, userphone, remark, deleteBy, deleteOn)
			select a.userID, a.userPwd, a.userGrpID, a.userName, a.userBranch, a.userDept, a.userCty, a.userEmail, a.lastLogin, a.userDirectory, a.linktoams, a.status, a.location, a.start_time, a.end_time, a.userphone,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.remark#">,'#HUserID#',now()
			from users as a
			where a.userID='#jsstringformat(preservesinglequotes(form.userId))#'
		</cfquery>
		<cfquery datasource='main' name="deleteUser">
			delete from users 
			where userId='#form.userId#';
		</cfquery>
		
		<cfset status = "The user, #form.userName# had been successfully deleted. ">
		
		<!--- <form name="done" action="../admin/vUser.cfm?process=done" method="post">
			<input name="status" value="<cfoutput>#status#</cfoutput>" type="hidden">
		</form> --->
		<cfoutput>
			<form name="done" action="../admin/vUser1.cfm?process=done&comid=#lcase(form.userDept)#" method="post">
				<input name="status" value="#status#" type="hidden">
			</form>
		</cfoutput>
		
		<script language="javascript" type="text/javascript">
			alert("User <cfoutput>#form.userid#</cfoutput> Has Been Deleted !");
			done.submit();
		</script>
	<cfelseif form.mode eq "Edit">
    	<cfset starttime=form.start_hr&":"&form.start_min&":00">
        <cfset endtime=form.end_hr&":"&form.end_min&":00">
		<cfquery datasource='main' name="editUser">
			update users set 
			userPwd='#form.userpwd#',
			userGrpId='#form.usergrpid#',
			userName='#form.username#',
			userBranch='#lcase(form.userbranch)#',
			userDept='#lcase(form.userdept)#',
			userCty='#form.usercty#',
			userEmail='#form.useremail#',
            userPhone='#form.userphone#',
			userdirectory='#form.userdirectory#',
			location = '#form.sel1#',
            itemgroup = '#form.sel2#',
            start_time='#starttime#',
            end_time='#endtime#'
			where userId='#form.userId#';
		</cfquery>
		<cfset status="The user, #form.userName# had been successfully edited. ">
		
		<!--- <form name="done" action="../admin/vUser.cfm?process=done" method="post">
			<input name="status" value="<cfoutput>#status#</cfoutput>" type="hidden">
		</form> --->
		<cfoutput>
			<form name="done" action="../admin/vUser1.cfm?process=done&comid=#lcase(form.userDept)#" method="post">
				<input name="status" value="#status#" type="hidden">
			</form>
		</cfoutput>
		
		<script language="javascript" type="text/javascript">
			alert("User <cfoutput>#form.userid#</cfoutput> Has Been Edited !");
			done.submit();
		</script>
	</cfif>
<cfelse>
	<cfif form.mode eq "Create">
    	<cfquery name="getlink" datasource="main">
        	select linktoams from users where userbranch='#form.userbranch#' limit 1
        </cfquery>
        <cfif getlink.recordcount eq 0>
			<cfset getlink.linktoams="">
		</cfif>
		
		<cfset starttime=form.start_hr&":"&form.start_min&":00">
        <cfset endtime=form.end_hr&":"&form.end_min&":00">
        
		<cfquery datasource='main' name="addUser">
			insert into users (userID, userPwd, userGrpID, userName, userBranch, userDept, userCty, userEmail, lastLogin, userDirectory, linktoams, status, location, start_time, end_time, userphone,itemgroup)
			select 
			'#form.userid#','#form.userpwd#','#form.usergrpid#','#form.username#','#lcase(form.userbranch)#','#lcase(form.userdept)#','#form.usercty#','#form.useremail#',
			'0000-00-00 00:00:00','#form.userdirectory#',<cfqueryparam cfsqltype="cf_sql_char" value="#getlink.linktoams#">,
			'1','#form.sel1#','#starttime#','#endtime#','#form.userphone#','#form.sel2#';
		</cfquery>
		
		<cfset status="The user, #form.userName# had been successfully created. ">
		
	<cfelse>
		<cfset status="Sorry, the user, #form.userName# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
	
	<cfif isdefined("form.comid")>
		<!--- <form name="done" action="<cfoutput>../admin/vUser1.cfm?comid=#form.comid#</cfoutput>" method="post">
			<input name="status" value="<cfoutput>#status#</cfoutput>" type="hidden">
		</form> --->
		<cfoutput>
			<form name="done" action="user.cfm?type=Create&comid=#form.comid#" method="post">
				<input name="status" value="#status#" type="hidden">              
              <input type="submit" name="submit" value="Create Another User">
   			 <input type="button" name="button1" value="Close" onClick="location.href='../admin/vUser1.cfm?comid=#form.comid#'">
			</form>
		</cfoutput>
	<cfelse>
		<form name="done" action="../admin/user.cfm?type=create" method="post">
			<input name="status" value="<cfoutput>#status#</cfoutput>" type="hidden">
              <input type="submit" name="submit" value="Create Another User">
    <input type="button" name="button1" value="Close" onClick="location.href='../admin/vuser1.cfm?all=all'">
		</form>
	</cfif>
	
	<script>
		alert("User <cfoutput>#form.userid#</cfoutput> Has Been Added !");

	</script>
</cfif>

</body>
</html>