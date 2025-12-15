<cfif isdefined('form.save_btn')>
<cfif form.ftppass neq form.ftpconpass>
<cfoutput>
<script type="text/javascript">
alert('FTP password is not same with FTP confirm Password. Please kindly check.');
history.go(-1);
</script>
</cfoutput>
<cfabort>
</cfif>


<cftry>
<cfftp connection="testftp" server="#form.ftphost#" username="#form.ftpuser#" password="#form.ftppass#" port="#form.ftpport#" action="open" stoponerror="yes">
<cfcatch type="any">
<cfoutput>
<script type="text/javascript">
alert('FTP Establish Connection Fail. Please kindly check the FTP detail.');
history.go(-1);
</script>

</cfoutput>
</cfcatch>
</cftry>
<cfftp connection="testftp" action="close" stoponerror="yes">

<cfquery name="checkexist" datasource="#dts#">
SELECT * FROM POSFTP
</cfquery>

<cfif checkexist.recordcount neq 0>
<cfquery name="updatedetail" datasource="#dts#">
UPDATE POSFTP SET
tenantno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tenantno#">,
ftphost = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ftphost#">,
ftpport = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ftpport#">,
ftpuser = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ftpuser#">,
ftppass = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ftppass#">,
posdirectory = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.posdirectory#">,
mall = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mall#">
</cfquery>
<cfelse>
<cfquery name="insertdetail" datasource="#dts#">
INSERT INTO POSFTP
(tenantno,ftphost,ftpport,ftpuser,ftppass,posdirectory,mall)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tenantno#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ftphost#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ftpport#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ftpuser#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ftppass#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.posdirectory#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mall#">
)
</cfquery>
</cfif>
<script type="text/javascript">
alert('FTP connection established Successfully!');
</script>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Setup FTP</title>
</head>
<body>
<h1>POS Submission</h1>
<h4>
<a href="POSSubmission.cfm">Daily Sales Submission</a>||
<a href="SetupFtp.cfm">Setup FTP</a>
</h4>
<cfquery name="getFTP" datasource="#dts#">
SELECT * FROM POSFTP
</cfquery>
<cfif getFTP.recordcount neq 0>
<cfset tenantno= getFTP.tenantno>
<cfset ftphost = getFTP.ftphost>
<cfset ftpuser = getFTP.ftpuser>
<cfset ftppass = getFTP.ftppass>
<cfset posdirectory = getFTP.posdirectory>
<cfset ftpport = getFTP.ftpport>
<cfset mall = getFTP.mall>
<cfelse>
<cfset tenantno="">
<cfset ftphost = "">
<cfset ftpuser = "">
<cfset ftppass = "">
<cfset ftpport = "21">
<cfset posdirectory="C:\possubmission">
<cfset mall = "">
</cfif>

<cfif posdirectory eq ''>
<cfset posdirectory="C:\possubmission">
</cfif>

<cfform name="setupftp" action="" method="post">
<table align="center" width="70%">
<tr><th>Tenant Number</th>
<td>:</td>
<td><cfinput type="text" name="tenantno" id="tenantno" value="#tenantno#"  size="35" required="yes"></td></tr>
<tr>
<th>Ftp Host</th>
<td>:</td>
<td><cfinput type="text" name="ftphost" id="ftphost" size="35" required="yes" message="FTP Host is Required" value="#ftphost#"/></td>
</tr>
<tr>
<th>Ftp Port</th>
<td>:</td>
<td><cfinput type="text" name="ftpport" id="ftpport" size="35" required="yes"  message="FTP PORT is Required" value="#ftpport#" /></td>
</tr>
<tr>
<th>FTP Username</th>
<td>:</td>
<td>
<cfinput type="text" name="ftpuser" id="ftpuser" size="35" required="yes" message="FTP Username is Required" value="#ftpuser#"/>
</td>
</tr>
<tr>
<th>FTP Password</th>
<td>:</td>
<td>
<cfinput type="password" name="ftppass" id="ftppass" size="35" required="yes" message="FTP Password is Required" value="#ftppass#" />
</td>
</tr>
<tr>
<th>FTP Confirm Password</th>
<td>:</td>
<td>
<cfinput type="password" name="ftpconpass" id="ftpconpass" size="35" required="yes" message="FTP Confirm Password is Required" value="#ftppass#" />
</td>
</tr>

<tr>
<th>Default Directory</th>
<td>:</td>
<td>
<cfinput type="text" name="posdirectory" id="posdirectory" size="35" required="yes" message="Default Directory" value="#posdirectory#" />
</td>
</tr>

<tr>
<th>Mall</th>
<td>:</td>
<td>
<select name="mall" id="mall">
<option value="jurong" <cfif mall eq 'jurong'>selected</cfif>>Jurong POint</option>
<option value="vivocity" <cfif mall eq 'vivocity'>selected</cfif>>Vivo City</option>
<option value="vivocity2" <cfif mall eq 'vivocity2'>selected</cfif>>Vivo City Special GST</option>
<option value="central" <cfif mall eq 'central'>selected</cfif>>Central</option>
<option value="jem" <cfif mall eq 'jem'>selected</cfif>>Jem Shopping Central</option>
<option value="drf" <cfif mall eq 'drf'>selected</cfif>>Daily RAFFLES CITY</option>
<option value="mrf" <cfif mall eq 'mrf'>selected</cfif>>Monthly RAFFLES CITY</option>
<option value="smp313" <cfif mall eq 'smp313'>selected</cfif>>313 Somerset Point</option>
<option value="katong112" <cfif mall eq 'katong112'>selected</cfif>>112 Katong Mall</option>
<option value="capitaland" <cfif mall eq 'capitaland'>selected</cfif>>Bugis Junction</option>
<option value="serangoon" <cfif mall eq 'serangoon'>selected</cfif>>Serangoon</option>
</select>
</td>
</tr>

<tr>
<td colspan="3" align="center"><input type="submit" name="save_btn" value="Save" /></td>
</tr>
</table>
</cfform>
</body>
</html>
