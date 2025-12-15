<html>
<head>
	<title>View Bill Listing Report</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>


<cfif url.type eq 1>
	<cfset trantype = "Purchase Receive">
	<cfset trancode = "RC">
</cfif>
<cfif url.type eq 2>
	<cfset trantype = "Purchase Return">
	<cfset trancode = "PR">
</cfif>
<cfif url.type eq 3>
	<cfset trantype = "Delivery Order">
	<cfset trancode = "DO">
</cfif>
<cfif url.type eq 4>
	<cfset trantype = "Invoice">
	<cfset trancode = "INV">
</cfif>
<cfif url.type eq 5>
	<cfset trantype = "Credit Note">
	<cfset trancode = "CN">
</cfif>
<cfif url.type eq 6>
	<cfset trantype = "Debit Note">
	<cfset trancode = "DN">
</cfif>
<cfif url.type eq 7>
	<cfset trantype = "Cash Sales">
	<cfset trancode = "CS">
</cfif>
<cfif url.type eq 8>
	<cfset trantype = "Purchase Order">
	<cfset trancode = "PO">
</cfif>
<cfif url.type eq 9>
	<cfset trantype = "Quotation">
	<cfset trancode = "QUO">
</cfif>
<cfif url.type eq 10>
	<cfset trantype = "Sales Order">
	<cfset trancode = "SO">
</cfif>
<cfif url.type eq 11>
	<cfset trantype = "Sample">
	<cfset trancode = "SA">
</cfif>
<cfif url.type eq 12>
	<cfset trantype = "Issue">
	<cfset trancode = "ISS">
</cfif>
<cfif trancode eq "INV" or trancode eq "CN" or trancode eq "DN" or trancode eq "CS" or trancode eq "QUO" or trancode eq "SO" or trancode eq "DO">
	<cfquery datasource="#dts#" name="getsupp">
		select custno,name from #target_arcust# order by custno
	</cfquery>
	<cfset title = "Customer">

<cfelse>
	<cfquery datasource="#dts#" name="getsupp">
		select custno,name from #target_apvend# order by custno
	</cfquery>
	<cfset title = "Supplier">
</cfif>

<cfquery datasource="#dts#" name="getagent">
	select agent from icagent order by agent
</cfquery>

<body>
<cfform action="..\reports\solisting.cfm?type=#trantype#&trancode=#trancode#" method="post" name="form123">

<cfoutput>
    <h2>Print #trantype# Listing Report</h2>
  </cfoutput> <br>
  <br>

  <table border="0" align="center" width="80%" class="data">
    <cfoutput>
      <input type="hidden" name="title" value="#title#">
    </cfoutput>
    <tr>
      <th>Report Type</th>
      <td>&nbsp;</td>
      <td width="73%"><select name="reporttype">
          <!---           <option value="">Choose a report type</option> --->
          <option value="1">Summary</option>
          <option value="2">Detail</option></option>
          <option value="3">Completed</option></option>
          <!---           <option value="3">3</option> --->
        </select></td>
    </tr>
    <tr>
      <td colspan="4"><hr></td>
    </tr>
    <tr>
      <th width="19%"><cfoutput>#title#</cfoutput></th>
      <td width="8%"> <div align="center">From</div></td>
      <td><select name="getfrom">
          <cfoutput>
            <option value="">Choose a #title#</option>
          </cfoutput> <cfoutput query="getsupp">
            <option value="#custno#">#custno#
            - #name#</option>
          </cfoutput> </select></td>
    </tr>
    <tr>
      <th width="19%"><cfoutput>#title#</cfoutput></th>
      <td width="8%"> <div align="center">To</div></td>
      <td><select name="getto">
          <cfoutput>
            <option value="">Choose a #title#</option>
          </cfoutput> <cfoutput query="getsupp">
            <option value="#custno#">#custno#
            - #name#</option>
          </cfoutput> </select></td>
    </tr>
    <tr>
      <td colspan="4"><hr></td>
    </tr>
    <tr>
      <th width="19%">Agent</th>
      <td width="8%"> <div align="center">From</div></td>
      <td><select name="agentfrom">
          <option value="">Choose a Agent</option>
          <cfoutput query="getagent">
            <option value="#agent#">#agent#</option>
          </cfoutput> </select></td>
    </tr>
    <tr>
      <th width="19%">Agent</th>
      <td width="8%"> <div align="center">To</div></td>
      <td><select name="agentto">
          <option value="">Choose a Agent</option>
          <cfoutput query="getagent">
            <option value="#agent#">#agent#</option>
          </cfoutput> </select></td>
    </tr>
    <tr>
      <td colspan="4"><hr></td>
    </tr>
    <tr>
      <th width="19%">Period</th>
      <td width="8%"> <div align="center">From</div></td>
      <td><select name="periodfrom">
          <option value="">Choose a period</option>
          <option value="01">1</option>
          <option value="02">2</option>
          <option value="03">3</option>
          <option value="04">4</option>
          <option value="05">5</option>
          <option value="06">6</option>
          <option value="07">7</option>
          <option value="08">8</option>
          <option value="09">9</option>
          <option value="10">10</option>
          <option value="11">11</option>
          <option value="12">12</option>
          <option value="13">13</option>
          <option value="14">14</option>
          <option value="15">15</option>
          <option value="16">16</option>
          <option value="17">17</option>
          <option value="18">18</option>
        </select></td>
    </tr>
    <tr>
      <th width="19%">Period</th>
      <td width="8%"> <div align="center">To</div></td>
      <td><select name="periodto">
          <option value="">Choose a period</option>
          <option value="01">1</option>
          <option value="02">2</option>
          <option value="03">3</option>
          <option value="04">4</option>
          <option value="05">5</option>
          <option value="06">6</option>
          <option value="07">7</option>
          <option value="08">8</option>
          <option value="09">9</option>
          <option value="10">10</option>
          <option value="11">11</option>
          <option value="12">12</option>
          <option value="13">13</option>
          <option value="14">14</option>
          <option value="15">15</option>
          <option value="16">16</option>
          <option value="17">17</option>
          <option value="18">18</option>
        </select></td>
    </tr>
    <tr>
      <td colspan="4"><hr></td>
    </tr>
    <tr>
      <th width="19%">Date</th>
      <td width="8%"> <div align="center">From</div></td>
      <td><cfinput type="text" name="datefrom" maxlength="10" validate="eurodate" size="10">
        (DD/MM/YYYY) </td>
    </tr>
    <tr>
      <th width="19%">Date</th>
      <td width="8%"> <div align="center">To</div></td>
      <td> <cfinput type="text" name="dateto" maxlength="10" validate="eurodate" size="10">
        (DD/MM/YYYY)&nbsp; </td>
    </tr>
    <tr>
      <td colspan="4"><hr></td>
    </tr>
    <tr>
      <th>Sort by</th>
      <td>&nbsp;</td>
      <td><table width="433">
          <tr>
            <td width="425"><label>
              <input name="rgSort" type="radio" value="Contract No" checked>
              Contract No.</label></td>
          </tr>
          <tr>
            <td><label>
              <input type="radio" name="rgSort" value="Client Name">
              Client Name</label></td>
          </tr>
          <tr>
            <td><label>
              <input type="radio" name="rgSort" value="Client Code">
              Client Code</label></td>
          </tr>
          <tr>
            <td><label>
              <input type="radio" name="rgSort" value="Month">
              Month</label></td>
          </tr>
        </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td> <div align="right">
          <input type="Submit" name="Submit" value="Submit">
        </div></td>
    </tr>
  </table>

</cfform>
</body>
</html>