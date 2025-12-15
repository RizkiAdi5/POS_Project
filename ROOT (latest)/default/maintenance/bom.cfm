<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<cfquery name="getitem" datasource="#dts#">
	select itemno,desp from icitem order by itemno
</cfquery>

<cfquery name="getgeneral" datasource="#dts#">
	select filterall from gsetup
</cfquery>

<body>
<cfoutput> 
  <h4><cfif getpin2.h1J10 eq 'T'><a href="bom.cfm">Create B.O.M</a> </cfif><cfif getpin2.h1J20 eq 'T'>|| <a href="vbom.cfm">List B.O.M</a> </cfif><cfif getpin2.h1J30 eq 'T'>|| <a href="bom.cfm">Search B.O.M</a> </cfif><cfif getpin2.h1J40 eq 'T'>|| <a href="genbomcost.cfm">Generate 
    Cost</a> </cfif><cfif getpin2.h1J50 eq 'T'>|| <a href="checkmaterial.cfm">Check Material</a> </cfif><cfif getpin2.h1J60 eq 'T'>|| <a href="useinwhere.cfm">Use In Where</a></cfif></h4>
</cfoutput> 
<script type="text/javascript">
// begin: product search
function getProduct(type){
		var inputtext = document.form1.searchitemfr.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult);
}

function getProductResult(itemArray){
	DWRUtil.removeAllOptions("sitemno");
	DWRUtil.addOptions("sitemno", itemArray,"KEY", "VALUE");
}
// end: product search

function selectlist(custno,fieldtype){

			for (var idx=0;idx<document.getElementById(fieldtype).options.length;idx++) 
			{
        	if (custno==document.getElementById(fieldtype).options[idx].value) 
			{
            document.getElementById(fieldtype).options[idx].selected=true;
        	}
    		} 
			
									}
</script>

<cfform name="form1" method="post" action="bom2.cfm">
<table width="60%" border="0" align="center" class="data">
  <tr>
      <th width="26%"> Item No :</th>
    <td width="39%">
		<select name="sitemno">
			<option value="">Choose an Item</option>
			<cfoutput query="getitem"><option value="#convertquote(itemno)#">#itemno# - #desp#</option></cfoutput>
      	</select>
      	<input type="hidden" name="ttype" value="Add">
        <cfif getgeneral.filterall eq "1">
        <input type="button" size="10" value="Ajax Search" onClick="ColdFusion.Window.show('finditem');" />
				<input type="text" name="searchitemfr" onKeyUp="getProduct('productfrom');">
			</cfif>
      </td>
    
  </tr>
  <tr>
      <th>Bom No :</th>
    <td><cfinput name="bomno" type="text" size="5" maxlength="2" required="yes">
        <input type="submit" name="Submit" value="Submit"></td>
    
  </tr>
 
</table>


</cfform>

<cfwindow  width="550" height="400" name="finditem" refreshOnShow="true"
        title="Find Item" initshow="false"
        source="bomfinditem.cfm?type=Product" />
</body>
</html>
