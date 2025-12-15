<html>
<head>
<title>Discount Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getgroup" datasource="#dts#">
  select discount, desp from discount order by discount
</cfquery>

<cfquery datasource='#dts#' name="getPersonnel">
	Select * from discount order by discount
</cfquery>

<body>
<h1 align="center"><cfoutput>Discount Listing</cfoutput></h1>
  <cfoutput>
    <h4>
		<cfif getpin2.h1P10 eq 'T'><a href="discounttable2.cfm?type=Create">Creating a New Discount</a> </cfif>
		<cfif getpin2.h1P20 eq 'T'>|| <a href="discounttable.cfm">List all Discount</a> </cfif>
		<cfif getpin2.h1P30 eq 'T'>|| <a href="s_discounttable.cfm?type=discount">Search For Discount</a></cfif>
        <cfif getpin2.h1630 eq 'T'>|| <a href="p_discount.cfm">Discount Listing</a>
        </cfif>
	</h4>
  </cfoutput>

<cfform action="l_discount.cfm" name="form" method="post" target="_blank">
  <table border="0" align="center" width="90%" class="data">
    <tr>
      <th width="20%"><cfoutput>Discount</cfoutput></th>
      <td width="5%"> <div align="center">From</div></td>
      <td colspan="6"><select name="groupfrom">
          <option value=""><cfoutput>Choose a Discount</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#discount#">#discount# - #desp#</option>
          </cfoutput> </select></td>
    </tr>
    <tr>
      <th height="24"><cfoutput>Discount</cfoutput></th>
      <td><div align="center">To</div></td>
      <td colspan="6" nowrap> <select name="groupto">
          <option value=""><cfoutput>Choose a Discount</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#discount#">#discount# - #desp#</option>
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
