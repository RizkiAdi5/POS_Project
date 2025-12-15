
<html>
<head>

<cfset currentURL = CGI.SERVER_NAME >
<cfif cgi.SERVER_PORT_SECURE eq 0 and currentURL eq "ims.netiquette.com.sg">
<cflocation addtoken="no" url="https://ims.netiquette.com.sg">
</cfif>

<div style="height:15%; text-align:left;margin: -15px 0 10PX 0px;
	background: #a5def8; /* Old browsers */
/* IE9 SVG, needs conditional override of 'filter' to 'none' */
background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIxJSIgc3RvcC1jb2xvcj0iI2E1ZGVmOCIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMwMGFiY2MiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
background: -moz-linear-gradient(top,  #a5def8 1%, #00abcc 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(1%,#a5def8), color-stop(100%,#00abcc)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* IE10+ */
background: linear-gradient(to bottom,  #a5def8 1%,#00abcc 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#a5def8', endColorstr='#00abcc',GradientType=0 ); /* IE6-8 */

    ; width:100%">
        
		<cfif currentURL eq "simplysiti.fiatech.com.my">
        <div style="float:left; width:25%">
        <img width="100%" src="/images/simplysiti_i/simplysiti.png" alt="Inventory Management System">
        </div>
        <cfelse>
        <div style="float:left; width:25%">
        <img class="headerlogo" width="100%" style="margin:20px 0 0 30px; float:left; size:100%" src="/login/newlogo.png" alt="Netiquette">
        </div>
        <div style="float:right; width:22%">
			<img class="headerlogo" width="100%" style="margin:25px 30px 0 0" src="/login/starhubH.png" alt="Netiquette">
		</div>
		</cfif>
        

</div>

<title>Netiquette Software Pte Ltd :: User Login</title>
<link rel="stylesheet" href="../stylesheet/stylesheet.css"/>
</head>

<body onLoad="document.login.userId.focus()">

<table width="100%" border="0" align="center">
  	<tr align="center">
		<td>
   			<img src="/images/IMS.png" alt="Inventory Management System">
		</td>
	</tr>
    <tr align="center">
		<td>
        <h3>Version 3.0 <!---(5 December 2012)---></h3>
		</td>
	</tr>
</table>
<script type="text/javascript">
function validsubmit()
{
var comid = document.getElementById('companyId').value.toLowerCase();
if(comid == "ncm" || comid == "ncm_i")
{
document.login.action = "http://119.73.212.38/index.cfm";
}
else if(comid == "hunting" || comid == "hunting_i")
{
document.login.action = "http://119.73.212.41/index.cfm";
}
}
</script>

<cfform action="/index.cfm" method="post" name="login" id="login" preservedata="no">
	
<table width="100%" border="0" align="center">
	<tr>
		<td>
		<div align="center">
  	
			<cfif isdefined("url.login")>
            <cfif isdefined('url.reason')>
            	<h3>You have reach maximum retry limit. Please wait for 15 minuets or contact support personnel</h3>
            <cfelse>
  				<h3>Incorrect User Id or Password. Please try again.</h3>
			</cfif>
			</cfif>
			<!---h3>Maintenance Is In Progess.</h3--->
  			<cfif isdefined("url.logout")>
				<h3>You had been successfully logged off.</h3>
			</cfif>           
			 <a class="a2"><b>Please enter your User ID, Password and Company ID</b></a>
   			 <!--- <h3><font size="3">The System Is Under Maintenance!</font></h3> --->
		</div>
		</td>
	</tr>
</table>

<div class="fieldset" style="width:100%">
	<table width="100%" border="0">
		<tr><td colspan="5">&nbsp;</td></tr>
      	<tr align="center">
			<td width="330px"></td> 
        	<td width="95px" class="labeltxt" align="left">User Id</td>
			<td width="2px">:</td>
        	<td width="200px" align="left"><cfinput type="text" required="yes" maxlength="50" size="40" name="userId" message="Please enter your user ID." tabindex="1"></td>
      		<td width="350px" rowspan="4" align="left"><cfif currentURL eq "ims.netiquette.com.sg"><!-- BEGIN DigiCert Site Seal Code --><div id="digicertsitesealcode" style="width: 81px; margin: 5px auto 5px 5px;" align="center"><script language="javascript" type="text/javascript" src="https://www.digicert.com/custsupport/sealtable.php?order_id=00262189&amp;seal_type=a&amp;seal_size=large&amp;seal_color=blue&amp;new=1"></script><a href="http://www.digicert.com/welcome/wildcard-plus.htm"></a><script language="javascript" type="text/javascript">coderz();</script></div><!-- END DigiCert Site Seal Code --></cfif><cfif currentURL eq "ims.mynetiquette.com"><img src="/images/green.jpg" height="125" width="125"></cfif></td>
		</tr>
      	<tr> 
			<td></td>
        	<td class="labeltxt">Password</td>
			<td>:</td>
        	<td><cfinput type="password" required="yes" maxlength="32" size="40" name="userPwd" id="userPwd" message="Please enter your password." tabindex="2"></td>
            
		</tr>
		<tr> 
			<td></td> 
        	<td class="labeltxt">Company Id</td>
			<td>:</td>
        	<td><cfinput type="text" required="yes" maxlength="50" size="40" name="companyId" id="companyId" message="Please enter your Company ID." tabindex="3"></td>
      	</tr>
      	<tr> 
        	<td colspan="100%" align="center">
            <input class="button" name="submit" type="submit" value="Login" onClick="validsubmit();" tabindex="4" style="display:inline-block;
	border-radius: 6px;
	-moz-border-radius:6px;
	-webkit-border-radius: 6px;
	text-transform:capitalize;
	border:0px;
	width:100px;
	height:30px;
	margin: 0;
	padding: 0;
	background: #a5def8; /* Old browsers */
/* IE9 SVG, needs conditional override of 'filter' to 'none' */
background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIxJSIgc3RvcC1jb2xvcj0iI2E1ZGVmOCIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMwMGFiY2MiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
background: -moz-linear-gradient(top,  #a5def8 1%, #00abcc 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(1%,#a5def8), color-stop(100%,#00abcc)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* IE10+ */
background: linear-gradient(to bottom,  #a5def8 1%,#00abcc 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#a5def8', endColorstr='#00abcc',GradientType=0 ); /* IE6-8 */

	color:#FFF;
	font-weight:bolder;
    font:Calibri;
    font-size:18px;
	cursor: pointer; /* hand-shaped cursor */
	cursor: hand; /* for IE 5.x */">&nbsp;<input class="button" name="Cancel" type="Reset" value="Cancel" style="display:inline-block;
	border-radius: 6px;
	-moz-border-radius:6px;
	-webkit-border-radius: 6px;
	text-transform:capitalize;
	border:0px;
	width:100px;
	height:30px;
	margin: 0;
	padding: 0;
	background: #a5def8; /* Old browsers */
/* IE9 SVG, needs conditional override of 'filter' to 'none' */
background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIxJSIgc3RvcC1jb2xvcj0iI2E1ZGVmOCIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMwMGFiY2MiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
background: -moz-linear-gradient(top,  #a5def8 1%, #00abcc 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(1%,#a5def8), color-stop(100%,#00abcc)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  #a5def8 1%,#00abcc 100%); /* IE10+ */
background: linear-gradient(to bottom,  #a5def8 1%,#00abcc 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#a5def8', endColorstr='#00abcc',GradientType=0 ); /* IE6-8 */

	color:#FFF;
	font-weight:bolder;
    font:Calibri;
    font-size:18px;
	cursor: pointer; /* hand-shaped cursor */
	cursor: hand; /* for IE 5.x */">
            
            </td>
      	</tr>
    </table>
	
</div>
</cfform>
<div>
	<table width="100%" border="0" align="center">
  		<tr><td width="350">&nbsp;</td><td width="400"><cfoutput>
        <cfif currentURL eq "ims.mynetiquette.com">
        <img src="/images/footerims1.png" alt="Inventory Management System">
        <cfelse>
        <cfif currentURL neq "simplysiti.fiatech.com.my">
   		<img src="/images/footerims.png" alt="Inventory Management System">
        </cfif>
        </cfif>
		</td><td width="300">
  		</td></cfoutput> </tr>
	</table>
</div>
</body>
</html>