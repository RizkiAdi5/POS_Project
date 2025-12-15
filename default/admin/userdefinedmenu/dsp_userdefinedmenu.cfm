<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../../stylesheet/stylesheet.css"/>

</head>
<cfparam name="groupname" default="Admin">
<body>
<form action="usergroup.cfm">
<h1 align="center">User Defined Menu</h1>
<!---table>
	<tr>
		<td>Group Name: <cfoutput>#groupname#</cfoutput></td>
	</tr>
</table--->
<p><font size="2" face="Verdana">Group Name: <cfoutput><input type="text" value="#groupname#" readonly></cfoutput></font></p>
<p>
<cfoutput>
<iframe name="firstframe" id="firstframe" src="dsp_frame1.cfm?groupname=#groupname#" width="30%" height="300" marginwidth="0" marginheight="0" scrolling="no"></iframe>
<iframe name="secondframe" id="secondframe" src="dsp_frame2.cfm?groupname=#groupname#" width="30%" height="300" marginwidth="0" marginheight="0"></iframe>
<iframe name="thirdframe" id="thirdframe" src="dsp_frame3.cfm?groupname=#groupname#" width="30%" height="300" marginwidth="0" marginheight="0"></iframe>
</cfoutput>
<br>
<p align="center"><input type="submit" name="back" value="Back"></p>
</p>
</form>
</body>
</html>
