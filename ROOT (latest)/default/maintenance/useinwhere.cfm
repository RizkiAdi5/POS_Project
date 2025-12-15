<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getitem" datasource="#dts#">
	select a.bmitemno,b.desp from billmat a,icitem b where a.bmitemno = b.itemno group by a.bmitemno order by a.bmitemno
</cfquery>

<script language="JavaScript">

	function validate()
	{
		if(document.checkmat.getitem.value=='')
		{
			alert("Your Item's No. cannot be blank.");
			document.checkmat.getitem.focus();
			return false;
		}
		
		return true;
	}
</script>

<body>
<cfoutput> 
  <h4><cfif getpin2.h1J10 eq 'T'><a href="bom.cfm">Create B.O.M</a> </cfif><cfif getpin2.h1J20 eq 'T'>|| <a href="vbom.cfm">List B.O.M</a> </cfif><cfif getpin2.h1J30 eq 'T'>|| <a href="bom.cfm">Search B.O.M</a> </cfif><cfif getpin2.h1J40 eq 'T'>|| <a href="genbomcost.cfm">Generate 
    Cost</a> </cfif><cfif getpin2.h1J50 eq 'T'>|| <a href="checkmaterial.cfm">Check Material</a> </cfif><cfif getpin2.h1J60 eq 'T'>|| <a href="useinwhere.cfm">Use In Where</a></cfif></h4>
</cfoutput>  
<h1 align="center">Use In Where</h1>
<form  name="checkmat" action="useinwhere1.cfm" method="post" target="_blank" onSubmit="return validate()">
<cfif getitem.recordcount gt 0>
	
  <table border="0" class="data" width="65%" align="center">
    <tr> 
        <th>Where Use Material</th>
      <td><select name="getitem">
          <option value="">Choose an Item</option>
          <cfoutput query="getitem"> 
            <option value="#convertquote(bmitemno)#">#bmitemno# - #desp#</option>
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
