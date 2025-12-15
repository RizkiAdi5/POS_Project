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

<cfquery name="getlocation" datasource="#dts#">
	select location,desp 
	from iclocation 
	<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super' and Huserloc neq "All_loc">
		where location in (#ListQualify(Huserloc,"'",",")#)
	</cfif>
	order by location
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
		else if(document.checkmat.qty.value=='')
		{
			alert("Your Item's Quantity cannot be blank.");
			document.checkmat.qty.focus();
			return false;
		}
		
		return true;
	}
</script>

<body>
<cfoutput> 
  <h4><a href="bom.cfm">Create B.O.M</a> || <a href="vbom.cfm">List B.O.M</a> || <a href="bom.cfm">Search B.O.M</a> || <a href="genbomcost.cfm">Generate 
    Cost</a> || <a href="checkmaterial.cfm">Check Material</a> || <a href="useinwhere.cfm">Use In Where</a></h4>
</cfoutput> 
<h1 align="center">Check Material</h1>
<form  name="checkmat" action="checkmaterial1.cfm" method="post" target="_blank" onSubmit="return validate()">
<cfif getitem.recordcount gt 0>
	
  <table border="0" class="data" width="60%" align="center">
    <tr> 
        <th>Item No</th>
      	<td>
			<select name="getitem">
          		<option value="">Choose an Item</option>
          		<cfoutput query="getitem"> 
          			<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
          		</cfoutput> 
			</select>
		</td>
    </tr>    
    <tr> 
      	<th>Quantity</th>
      	<td><input type="text" name="qty" maxlength="10" size="10" value="1"></td> 
    </tr>
    <tr>
      	<th>Location</th>
      	<td colspan="2">
			<select name="location">
          			<option value="">Choose a Location</option>
          		<!--- <option value="">Choose a Location</option> --->
          		<cfoutput query="getlocation">
					<option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
				</cfoutput>
			</select>
		</td>
    </tr>
	<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
		<tr><td colspan="100%"><hr></td></tr>
	    <tr> 
	        <th>Item No (2)</th>
	      	<td>
				<select name="getitem2">
	          		<option value="">Choose an Item</option>
	          		<cfoutput query="getitem"> 
	          			<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
	          		</cfoutput> 
				</select>
			</td>
	    </tr>    
	    <tr> 
	      	<th>Quantity</th>
	      	<td><input type="text" name="qty2" maxlength="10" size="10" value="1"></td> 
	    </tr>
	    <tr><td colspan="100%"><hr></td></tr>
	    <tr> 
	        <th>Item No (3)</th>
	      	<td>
				<select name="getitem3">
	          		<option value="">Choose an Item</option>
	          		<cfoutput query="getitem"> 
	          			<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
	          		</cfoutput> 
				</select>
			</td>
	    </tr>    
	    <tr> 
	      	<th>Quantity</th>
	      	<td><input type="text" name="qty3" maxlength="10" size="10" value="1"></td> 
	    </tr>
	</cfif>
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
