
<html>
<head>

<cfset currentURL = CGI.SERVER_NAME >



<cfif currentURL eq "simplysiti.fiatech.com.my">
<title>Simplysiti Inventory Management System</title>
<cfelse>
<title>Netiquette Software Pte Ltd :: User Login</title>
</cfif>
<link rel="stylesheet" href="login.css"/>
</head>

<body onLoad="document.login.userId.focus()">

<!--- <div align="left">
	<br>&nbsp;&nbsp;&nbsp;<img src="/images/IMS.png" alt="Inventory Management System"><br>
</div> --->

<table width="100%" border="0" align="center">
  	<tr align="center">
		<td>
        <cfif currentURL eq "simplysiti.fiatech.com.my">
        <img src="/images/simplysiti_i/simplysiti.png"  alt="Inventory Management System">
        <cfelse>
   			<img src="/images/IMS.png" alt="Inventory Management System">
		</cfif>
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
else if(comid == "demo")
{
document.login.action = "/newinterface/index.cfm";
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
	<table width="100%" border="0" >
		<tr><td colspan="5">&nbsp;</td></tr>
      	<tr align="center">
			<td width="330px"></td> 
        	<td width="95px" class="labeltxt" align="left">User Id</td>
			<td width="2px">:</td>
        	<td width="200px" align="left"><cfinput type="text" required="yes" maxlength="50" size="40" name="userId" message="Please enter your user ID." tabindex="1"></td>
      		<td width="350px" rowspan="4" align="left"><cfif cgi.SERVER_PORT_SECURE neq 0><!-- Begin DigiCert/ClickID site seal HTML and JavaScript --><div align="left" style="position:absolute"><div id="DigiCertClickID_uiXvm7Mo"></div>
<script type="text/javascript">
var __dcid = __dcid || [];__dcid.push(["DigiCertClickID_uiXvm7Mo", "3", "l", "black", "uiXvm7Mo"]);(function(){var cid=document.createElement("script");cid.type="text/javascript";cid.async=true;cid.src=("https:" === document.location.protocol ? "https://" : "http://")+"seal.digicert.com/seals/cascade/seal.min.js";var s = document.getElementsByTagName("script");var ls = s[(s.length - 1)];ls.parentNode.insertBefore(cid, ls.nextSibling);}());
</script>
<!-- End DigiCert/ClickID site seal HTML and JavaScript -->
</div>
</cfif>            
            </td>
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
        	<td colspan="4" align="right"><input class="button" name="submit" type="submit" value="Login" onClick="validsubmit();" tabindex="4">&nbsp;<input class="button" name="Cancel" type="Reset" value="Cancel"></td>
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