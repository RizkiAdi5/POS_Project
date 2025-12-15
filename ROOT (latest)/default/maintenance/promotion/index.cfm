<html>
<head>
<title>Promotion Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

</head>

<script language="JavaScript">


</script>

<body>
<cfquery name="getgroup" datasource="#dts#">
  select promoid,type from promotion order by promoid
</cfquery>



  <h1 align="center"><cfoutput>Promotion Listing</cfoutput></h1>
<cfoutput>
    <h4 align = "center">Promotion Listing
  </h4>
  </cfoutput>

<cfform action="l_vehicles.cfm" name="form" method="post" target="_blank">
  	<input type="hidden" name="Tick" value="0">

	
  <table border="0" align="center" width="90%" class="data">
    <tr> 
      <th width="20%"><cfoutput>Promotion From</cfoutput></th>
      <td colspan="6"><select name="groupfrom">
          <option value=""><cfoutput>Choose a Promotion</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#promoid#">#promoid# - #type#</option>
          </cfoutput> </select></td>
    </tr>
    <tr>
      <th height="24"><cfoutput>Promotion To</cfoutput></th>
      <td colspan="6" nowrap> <select name="groupto">
          <option value=""><cfoutput>Choose a Promotion</cfoutput></option>
          <cfoutput query="getgroup">
            <option value="#promoid#">#promoid# - #type#</option>
          </cfoutput> </select> </td>
	  </td>
    </tr>

    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
    <tr>
    <th >Price Discount Type</th>

<td>
<select name="pricedistype" id="pricedistype">
<option value="">Please Choose a promotion type</option>
<option value="price">Price</option>
<option value="percent">Percent</option>
<option value="buy">Buyying</option>
<option value="free">Free</option>
</select>
  </td></tr>
  
 
  
  <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
    <cfoutput>
<tr>
      	<th width="16%">Date From</th>
      	<td colspan="2"><select name="day1" id="day1">
<cfloop from="1" to="31" index="i">
<option value="#i#">#i#</option>
</cfloop>
</select>
<select name="month1" id="month1">
<cfloop from="1" to="12" index="i">
<cfset datecrete = createdate('2010',i,'1')>
<option value="#i#">#ucase(dateformat(datecrete,'mmmm'))#</option>
</cfloop>
</select>
<select name="year1" id="year1">
<cfloop from="1990" to="2020" index="i">
<option value="#i#">#i#</option>
</cfloop>
</select></td>
    </tr>
    <tr>
      	<th width="16%">Date To</th>
      	<td width="69%"><select name="day2" id="day2">
<cfloop from="1" to="31" index="i">
<option value="#i#">#i#</option>
</cfloop>
</select>
<select name="month2" id="month2">
<cfloop from="1" to="12" index="i">
<cfset datecrete = createdate('2010',i,'1')>
<option value="#i#">#ucase(dateformat(datecrete,'mmmm'))#</option>
</cfloop>
</select>
<select name="year2" id="year2">
<cfloop from="1990" to="2020" index="i">
<option value="#i#">#i#</option>
</cfloop>
</select></td>
        </tr>
</cfoutput>
<tr>
<td colspan="9" align="center"><input type="submit" name="submit" id="submit" value="Submit">
</td>
</tr>

  </table>
</cfform>
</body>
</html>
