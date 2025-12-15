<html>
<head>
<title>Cashier Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getgroup" datasource="#dts#">
  select cashierid, name,password from cashier order by cashierid
</cfquery>

<cfquery datasource='#dts#' name="getPersonnel">
	Select * from cashier order by cashierid
</cfquery>

<body>
<h1 align="center"><cfoutput>Cashier Listing</cfoutput></h1>
  <cfoutput>
    <h4>
    <cfif getpin2.h1P10 eq 'T'><a href="cashiertable2.cfm?type=Create">Creating a New Cashier</a> </cfif>
		<cfif getpin2.h1P20 eq 'T'>|| <a href="cashiertable.cfm">List all Cashier</a> </cfif>
		<cfif getpin2.h1P30 eq 'T'>|| <a href="s_cashiertable.cfm?type=brand">Search For Cashier</a></cfif>
        <cfif getpin2.h1630 eq 'T'>|| <a href="p_cashier.cfm">Cashier Listing</a>
        </cfif>
  </h4>
  </cfoutput>

<cfform action="l_cashier.cfm" name="form" method="post" target="_blank">
  <table border="0" align="center" width="90%" class="data">
    <tr>
      <th width="20%"><cfoutput>Cashier</cfoutput></th>
      <td width="5%"> <div align="center">From</div></td>
      <td colspan="6"><select name="groupfrom">
          <option value=""><cfoutput>Choose a Cashier</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#cashierid#">#cashierid# - #name#</option>
          </cfoutput> </select></td>
    </tr>
    <tr>
      <th height="24"><cfoutput>Cashier</cfoutput></th>
      <td><div align="center">To</div></td>
      <td colspan="6" nowrap> <select name="groupto">
          <option value=""><cfoutput>Choose a Cashier</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#cashierid#">#cashierid# - #name#</option>
          </cfoutput> </select> </td>
    </tr>
    <tr>
      <td colspan="8">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="8"> <cfoutput> </cfoutput> <div align="right">
          <input type="Submit" name="Submit" value="Submit">
        </div></td>
    </tr>
  </table>
</cfform>
</body>
</html>
