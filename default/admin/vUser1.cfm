<html>
<head>
<title>View All IMS Users</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<h4>
	<cfif husergrpid eq "Muser">
		<a href="/home2.cfm"><u>Home</u></a>
	</cfif>
</h4>

<h1>User Maintenance</h1>
<hr>

<cfparam name="start" default="1">

<cfif isdefined("url.all")>
	<cfquery name="getUsers" datasource="main">
		select * 
		from users 
		order by userbranch,usergrpid,userid;
	</cfquery>
<cfelse>
	<cfif husergrpid eq "super">
		<cfquery datasource='main' name="getUsers">
			select * 
			from users 
			where userbranch='#comid#' 
			order by usergrpid,userid;
		</cfquery>
	<cfelseif husergrpid eq "admin">
		<cfquery datasource='main' name="getUsers">
			select * 
			from users 
			where userbranch='#comid#' and usergrpid <> 'super' 
			order by usergrpid,userid;
		</cfquery>
	<cfelse>
		<cfquery datasource='main' name="getUsers">
			select * 
			from users 
			where userid='#huserid#' and userbranch='#comid#'; 
		</cfquery>
	</cfif>
</cfif>

<cfif isdefined("url.start")>
	<cfset start = url.start>
</cfif>
			
<cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1></cfoutput><hr>
</cfif>

<table align="center" class="data" width="100%">
	<tr>
    <th>No.</th>
		<cfif husergrpid eq "admin" or husergrpid eq "super">
			<th>Delete</th>
		</cfif>
		<th>Edit</th>
		<th>Name</th>
		<th>ID</th>
		<th>Company</th>
		<th>Group</th>
		<th>Email</th>
		<cfif husergrpid eq "super">
			<th>Lastlogin</th>
			<th>Reactivate</th>
		</cfif>
	</tr>
	<cfloop query="getUsers">
		<cfoutput>
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
        <td>#getUsers.currentrow#</td>
			<cfif husergrpid eq "admin" or husergrpid eq "super">
				<td><a href="user.cfm?type=Delete&userId=#getUsers.userId#">Go</a></td>
			</cfif>
			<td><a href="user.cfm?type=Edit&userId=#getUsers.userId#">Go</a></td>
			<td>#getUsers.userName#</td>
			<td>#getUsers.userId#</td>
			<td>#getUsers.userbranch#</td>
			<td>
				<cfif getUsers.usergrpid eq "admin">
					Administrator
				</cfif>
				<cfif getUsers.usergrpid eq "suser">
					Standard
				</cfif>
				<cfif getUsers.usergrpid eq "guser">
					General User
				</cfif>
				<cfif getUsers.usergrpid eq "muser">
					Mobile User
				</cfif>
				<cfif getUsers.usergrpid eq "luser">
					Limited User
				</cfif>
				<cfif getUsers.usergrpid eq "super">
					Super User
                <cfelse>
                	#getUsers.usergrpid#
				</cfif>
			</td>
			<td>#getUsers.userEmail#</td>
			<cfif husergrpid eq "super">
				<td nowrap>#lastlogin#</td>
				<td><a href="reactivate.cfm?userid=#userid#">Go</a></td>
			</cfif>
		</tr>
		</cfoutput>
	</cfloop>
</table>
<cfif husergrpid eq "Super" and isdefined("url.comid")>
<br>
To create user, click <cfoutput><a href="user.cfm?type=Create&comid=#url.comid#">Here</a> </cfoutput>
<cfelseif husergrpid eq "admin" and isdefined("url.comid")>
<cfquery name="getusercount" datasource="main">
select count(userid) as totaluser from users where userbranch = "#dts#" and usergrpid <> "super" group by userbranch
</cfquery>
<cfquery name="getuserlimit" datasource="main">
SELECT usercount FROM useraccountlimit where companyid = "#dts#"
</cfquery>
<cfif val(getusercount.totaluser) lt val(getuserlimit.usercount)>
<br>
To create user, click <cfoutput><a href="user.cfm?type=Create&comid=#dts#">Here</a> </cfoutput>
</cfif>
</cfif>
</body>
</html>