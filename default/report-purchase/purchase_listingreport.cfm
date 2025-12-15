<html>
<head>
<title>View Purchase Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">


<cfquery datasource="#dts#" name="getitem">
	select itemno, desp from icitem
</cfquery>
<cfquery datasource="#dts#" name="getsup">
	select custno, name from #target_apvend# order by custno
</cfquery>

<cfif url.type eq 1>
	<cfset trantype = "Products">
</cfif>
<cfif url.type eq 2>
	<cfset trantype = "Vendors">
</cfif>

<body>
<cfform action="purchase_listingreport1.cfm?type=#trantype#" method="post" target="_self" name="form">
  <cfoutput>
    <h2>Print #trantype# Purchase Report</h2>
  </cfoutput>
  <p>&nbsp;</p>
  <table border="0" align="center" width="80%" class="data">
    <tr>
      <th width="16%"><cfoutput>#trantype#</th>
      <td width="5%"> <div align="center">From</div></td>
      <td colspan="2"><select name="getfrom">
	  <option value="">Choose a #trantype#</cfoutput></option>

	  	<cfif url.type eq 1>
		<cfoutput query="getitem">
            <option value="#itemno#">#itemno#
            - #desp#</option>
        </cfoutput></cfif>

		<cfif url.type eq 2>
		<cfoutput query="getsup">
            <option value="#custno#">#custno#
            - #name#</option>
        </cfoutput></cfif>
	  </select></td>
    </tr>
    <tr>
      <th width="16%"><cfoutput>#trantype#</th>
      <td width="5%"> <div align="center">To</div></td>
      <td colspan="2"><select name="getto">
       <option value="">Choose a #trantype#</cfoutput></option>

	    <cfif url.type eq 1>
		<cfoutput query="getitem">
            <option value="#itemno#">#itemno#
            - #desp#</option>
        </cfoutput></cfif>

		<cfif url.type eq 2>
		<cfoutput query="getsup">
            <option value="#custno#">#custno#
            - #name#</option>
        </cfoutput></cfif>
		</select></td>
    </tr>
    <tr>
      <td colspan="5"><hr></td>
    </tr>
    <tr>
      <th width="16%">Date</th>
      <td width="5%"> <div align="center">From</div></td>
      <td colspan="2"><cfinput type="text" name="datefrom" maxlength="10" validate="eurodate" size="10">
        (DD/MM/YYYY) </td>
    </tr>
    <tr>
      <th width="16%">Date</th>
      <td width="5%"> <div align="center">To</div></td>
      <td width="69%"><cfinput type="text" name="dateto" maxlength="10" validate="eurodate" size="10">
        (DD/MM/YYYY)&nbsp; </td>
      <td width="10%"><input type="submit" name="Submit1" value="Submit"></td>
    </tr>
  </table>
  <p>&nbsp;</p></cfform>
</body>
</html>