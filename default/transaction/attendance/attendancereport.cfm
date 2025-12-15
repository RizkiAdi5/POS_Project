<html>
<head>
<title>Product Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>

<script type='text/javascript' src='/ajax/core/engine.js'></script>
<script type='text/javascript' src='/ajax/core/util.js'></script>
<script type='text/javascript' src='/ajax/core/settings.js'></script>

<cfquery name="getdealer_menu" datasource="#dts#">
	select * from dealer_menu
</cfquery>
</head>

<cfquery name="getgsetup" datasource='#dts#'>
  Select * from gsetup
</cfquery>

<body>
<h1 align="center">Product Listing</h1>
<cfoutput>
<h4>
		<cfif getpin2.h1P10 eq 'T'><a href="cashiertable2.cfm?type=Create">Creating a New Cashier</a> </cfif>
		<cfif getpin2.h1P20 eq 'T'>|| <a href="cashiertable.cfm">List all Cashier</a> </cfif>
		<cfif getpin2.h1P30 eq 'T'>|| <a href="s_cashiertable.cfm?type=brand">Search For Cashier</a></cfif>
        <cfif getpin2.h1630 eq 'T'>|| <a href="p_cashier.cfm">Cashier Listing</a>
        || <a href="attendancereport.cfm">Staff Attendance Report</a>
        </cfif>
	</h4>
</cfoutput>

<cfform action="attendancereport2.cfm" name="form" method="post" target="_blank">
<cfoutput>
<input type="hidden" name="fromto" id="fromto" value="" />
  <input type="hidden" name="Tick" value="0">
  <table border="0" align="center" class="data">
 	<tr> 
    	<th>Date From</th>
        <td><input type="text" name="datefrom" value="#dateformat(now(),'DD/MM/YYYY')#" maxlength="10" size="11"> (DD/MM/YYYY)</td>
    </tr>
    <tr> 
        <th>Date To</th>
        <td><input type="text" name="dateto"  value="#dateformat(now(),'DD/MM/YYYY')#" maxlength="10" size="11"> (DD/MM/YYYY)</td>
    </tr>
    <tr>
    <td colspan="100%"><hr></td>
    </tr>
    <tr>
    <td colspan="100%"><div align="center">
          <input type="Submit" name="Submit" value="Submit">
      </div></td>
  </tr>
  
  </table>
</cfoutput>
</cfform>
</body>
</html>