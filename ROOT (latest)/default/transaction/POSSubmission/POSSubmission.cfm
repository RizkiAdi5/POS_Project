
<html>
<cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear from gsetup
</cfquery>

<head>
<title>POS Submission </title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script src="/scripts/CalendarControl.js" language="javascript"></script>
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<cfoutput>
</cfoutput>
</head>

<body>

<h4>
<a href="POSSubmission.cfm">Daily Sales Submission</a>||
<a href="SetupFtp.cfm">Setup FTP</a>
</h4>


<h1><center>Daily Sales Submission</center></h1>
<br><br>

<cfif isdefined('form.msg')>
<cfoutput>
<h3>#form.msg#</h3>
</cfoutput>
</cfif>

<cfform name="form1" id="form1" method="post" action="/default/transaction/POSSubmission/POSSubmissionprocess.cfm">
<table width="75%" border="0" class="data" align="center">

 <tr>
 <th>Date1</th>
 <td>:</td>
 <td><cfinput type="text" readonly name="billdate" id="billdate" maxlength="10" size="10" value="#dateformat(now(),'DD/MM/YYYY')#" required="yes" validate="eurodate">&nbsp;<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(billdate);">(DD/MM/YYYY)</td>
 </tr>
 <tr><td colspan="100%" align="center"><input type="submit" name="submit" id="submit" value="Generate"></td></tr>
</table>
</cfform>
<br/>
</body>
</html>
