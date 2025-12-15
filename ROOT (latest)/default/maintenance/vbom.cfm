<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getitem" datasource="#dts#">
	select a.itemno,b.desp from billmat a, icitem b where a.itemno = b.itemno group by a.itemno order by a.itemno
</cfquery>

<body>
<cfoutput> 
  <h4><cfif getpin2.h1J10 eq 'T'><a href="bom.cfm">Create B.O.M</a> </cfif><cfif getpin2.h1J20 eq 'T'>|| <a href="vbom.cfm">List B.O.M</a> </cfif><cfif getpin2.h1J30 eq 'T'>|| <a href="bom.cfm">Search B.O.M</a> </cfif><cfif getpin2.h1J40 eq 'T'>|| <a href="genbomcost.cfm">Generate 
    Cost</a> </cfif><cfif getpin2.h1J50 eq 'T'>|| <a href="checkmaterial.cfm">Check Material</a> </cfif><cfif getpin2.h1J60 eq 'T'>|| <a href="useinwhere.cfm">Use In Where</a></cfif></h4>
</cfoutput> 
<h1 align="center">List Bill of Material</h1>
<form action="vbom1.cfm" method="post" target="_blank">
<cfif getitem.recordcount gt 0>
	
  <table border="0" class="data" width="70%" align="center">
    <tr> 
      <th nowrap>Item No From</th>
      <td><select name="itemfrom">
          <option value="">Choose an Item</option>
          <cfoutput query="getitem"> 
            <option value="#convertquote(itemno)#">#itemno# - #desp#</option>
          </cfoutput> </select></td>
    </tr>    
    <tr> 
      <th>Item No To</th>
      <td><select name="itemto">
          <option value="">Choose an Item</option>
          <cfoutput query="getitem"> 
            <option value="#convertquote(itemno)#">#itemno# - #desp#</option>
          </cfoutput> </select></td>
    </tr>
	<tr>
      <td colspan="2" align="right"><input type="submit" name="submit" value="submit"></td>
      
    </tr>
  </table>
<cfelse>
	<h3>Sorry. No Records.</h3>
</cfif>
</form>
</body>
</html>
