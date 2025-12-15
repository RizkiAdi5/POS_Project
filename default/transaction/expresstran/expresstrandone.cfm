<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Bill Create Success!</title>
</head>

<body>
<table width="1000px" align="center">
    <tr>
    <th><h2>Actions</h2></th>
    </tr>
    <tr>
    <td align="center">
    <h3>
    <cfoutput>
    <a href="/default/transaction/expresstran/index.cfm?type=#url.type#" ><img src="/images/Create.png" width="32" height="32" />&nbsp;Create Another Bill</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="##" onclick="window.close()"><img src="/images/Close.png" width="32" height="32" />&nbsp;Close</a>
    </cfoutput>
    </h3>
    </td>
    </tr>
    <tr>
    <th><h2>Print Bills</h2></th>
    </tr>
    <tr>
    <td>
    <cfif url.type neq "TR">
	<cfset url.tran = url.type>
    <cfset url.nexttranno = url.refno>
    <cfinclude template="/default/transaction/transaction3c.cfm" />
    <cfelse>
    <cfset url.tran = url.type>
    <cfset url.nexttranno = url.refno>
    <cfinclude template="/billformat/printoptionpage.cfm" />
    </cfif>
    </td>
    </tr>
    </table>
</body>
</html>
