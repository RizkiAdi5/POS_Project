<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Generate BOM Cost</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getitem" datasource="#dts#">
	select a.itemno,b.desp 
	from billmat as a,icitem as b 
	where a.itemno=b.itemno 
	group by a.itemno 
	order by a.itemno
</cfquery>

<body>
<h4>
	<cfif getpin2.h1J10 eq 'T'>
		<a href="bom.cfm">Create B.O.M</a>
	</cfif>
	<cfif getpin2.h1J20 eq 'T'>
		|| <a href="vbom.cfm">List B.O.M</a> 
	</cfif>
	<cfif getpin2.h1J30 eq 'T'>
		|| <a href="bom.cfm">Search B.O.M</a>
	</cfif>
	<cfif getpin2.h1J40 eq 'T'>
		|| <a href="genbomcost.cfm">Generate Cost</a> 
	</cfif>
	<cfif getpin2.h1J50 eq 'T'>
		|| <a href="checkmaterial.cfm">Check Material</a>
	</cfif>
	<cfif getpin2.h1J60 eq 'T'>
		|| <a href="useinwhere.cfm">Use In Where</a>
	</cfif>
</h4>

<h1 align="center">Generate Cost</h1>

<cfif getitem.recordcount eq 0>
	<h3>Sorry. No Records.</h3>
	<cfabort>
</cfif>

<form action="genbomcost1.cfm" method="post" target="_blank">
	<table border="0" class="data" width="60%" align="center">
		<tr> 
        	<th>Item No From</th>
        	<td>
				<select name="itemfrom">
            		<option value="">Choose an Item</option>
            		<cfoutput query="getitem"> 
              			<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
            		</cfoutput>
				</select>
			</td>
		</tr>
		<tr> 
        	<th>Item No To</th>
        	<td>
				<select name="itemto">
            		<option value="">Choose an Item</option>
            		<cfoutput query="getitem"> 
              			<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
	  	<tr>
        	<th>Bom No</th>
        	<td><input type="text" name="bomno" value="" size="2" maxlength="2"></td>
      	</tr>
		<tr>
        	<th>Update Bom Cost ?</th>
        	<td><input type="checkbox" name="update_cost" value="Y"></td>
      	</tr>
        <tr>
        	<th>According to Moving Average</th>
        	<td><input type="checkbox" name="movingavrg" value=""></td>
      	</tr>
      	<tr> 
        	<td colspan="2" align="right"><input type="submit" name="submit" value="submit"></td>
      	</tr>
	</table>
</form>

</body>
</html>