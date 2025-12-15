<cfquery name="getfilename" datasource="#dts#">
    select tenantno from POSFTP
    </cfquery>
<html>
<head>
<title>Daily Sales Submission </title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
<h2 align="center">The Daily Sales file has been generated</h2>
<!---<p align="center">Click <a href="/default/transaction/POSSubmission/posFileDownload.cfm?ndate=#form.billdate#">here</a> to download the generated file</p>
<p align="center">Click <u><a onMouseOver="JavaScript:this.style.cursor='hand'" onClick="window.open('#getfilename.tenantno##form.billdate#.txt')">here</a></u> to preview the generated file</p>
---></cfoutput>
<cfoutput>
<form action="/default/transaction/POSSubmission/POSPostProcess.cfm" method="post">
<table width="75%" border="0" class="data" align="center">
<tr>
<td align="center" colspan="6">
<input type="hidden" name="afilename" id="afilename" value="#form.afilename#" />
<input type="hidden" name="ndate" id="ndate" value="#form.billdate#">
<input type="hidden" name="timenow" id="timenow" value="#timeformat(now(),'HHMMSS')#" />
<input type="submit" value="Send Daily Sales" name="submit">
</td>
</tr>
</table>
</form>
</cfoutput>
<cfoutput>
<!---<cfwindow name="previewfile" source="posFilePreview.cfm?ndate=#form.billdate#" width="650" height="400" initshow="false" modal="true" refreshonshow="true">
</cfwindow>---></cfoutput>
</body>
</html>