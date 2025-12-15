<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<!--- <cfparam name="Add" default=""> --->
<cfparam name="Save" default="">
<cfparam name="Finish" default="">
<cfparam name="xbom" default=""> 
<cfparam name="xitem" default="">
<cfparam name="xqty" default="1">
<cfparam name="xlocation" default="">
<cfparam name="xgroup" default="">
<!--- <cfparam name="xitemno" default=""> --->
<cfparam name="mode" default="">

<body>

<cfform name="form" method="post" action="">

<cfif Save eq "save">
	<cfquery name="updatecost" datasource="#dts#">
		update icitem set bom_cost = '#form.mcost#' where itemno = '#form.sitemno#'
	</cfquery>
	<cfoutput> 
  <h4><cfif getpin2.h1J10 eq 'T'><a href="bom.cfm">Create B.O.M</a> </cfif><cfif getpin2.h1J20 eq 'T'>|| <a href="vbom.cfm">List B.O.M</a> </cfif><cfif getpin2.h1J30 eq 'T'>|| <a href="bom.cfm">Search B.O.M</a> </cfif><cfif getpin2.h1J40 eq 'T'>|| <a href="genbomcost.cfm">Generate 
    Cost</a> </cfif><cfif getpin2.h1J50 eq 'T'>|| <a href="checkmaterial.cfm">Check Material</a> </cfif><cfif getpin2.h1J60 eq 'T'>|| <a href="useinwhere.cfm">Use In Where</a></cfif></h4>
</cfoutput> 
	<h2>You have update the miscellaneous cost successfully. </h2><!--- <a href = "vbom.cfm"><U>View Bill of Material</U></a> --->
	<cfabort>
</cfif>

<cfif Finish eq "Finish">
	
	<cfoutput>
 	<h2 align="center">#form.sitemno#</h2>
	<p align="center"><font size="2">Miscellaneous Cost :</font> 
    <cfinput type="text" name="mcost" size="10" maxlength="10" validate="float" value="#form.misc#">&nbsp;
	<input type="Submit" name="Save" value="Save"></p>
	<input type="hidden" name="sitemno" value="#form.sitemno#">
	<!--- <cflocation url="vbom.cfm"> --->
	<cfabort>
	</cfoutput>
</cfif>


<cfif mode eq "Add">
	<!--- <cfset xbom = #form.bomno#> --->
	<!--- <cfset xitemno = #form.item1#> --->
	<cfquery name="checkexist" datasource="#dts#">
		select * from billmat where itemno = '#form.sitemno#' and bomno = '#form.bomno#' and bmitemno = '#form.sitem#'
	</cfquery>
	<cfif checkexist.recordcount gt 0>
		<h2 align="center">Duplicate Item! Please select other item.
		<input type="button" name="back" value="Back" onClick="javascript:history.back()"></h2>
		<cfabort>
	</cfif>
	
	<cfquery name="insertbom" datasource="#dts#">
		insert into billmat values('#form.sitemno#','#form.bomno#','#form.sitem#','#form.qty#','#form.locat#','#form.sgroup#')
	</cfquery>
	
</cfif>

<cfif mode eq "Edit">
	<!--- <cfoutput>origin #sitemori#</cfoutput> --->
	<cfquery name="insertbom" datasource="#dts#">
		update billmat set itemno = '#sitemno#', bomno = '#bomno#', bmitemno = '#sitem#',
		bmqty = '#qty#', bmlocation = '#locat#', assm_group = '#sgroup#' where 
		itemno = '#xitemno#' and bomno = '#xbom#' and bmitemno = '#sitemori#' 
	</cfquery>
	<cfset xbom = #form.bomno#>
	<cfset xitemno = #xitemno#>
	<cfset mode = "Add">
</cfif>

<cfif mode eq "Delete">
	<cfquery name="deletedata" datasource="#dts#">
		delete from billmat where itemno = '#xitemno#' and bomno = '#xbom#' and bmitemno = '#sitem#' 
	</cfquery>
	<cfset mode = "Add">
</cfif>


<cfif isdefined("url.ttype")>	

		<!--- <cfset xitemno = #sitem#> --->
		<cfquery name="getdata" datasource="#dts#">
			select * from billmat where itemno = '#xitemno#' and bomno = '#xbom#' and bmitemno = '#sitem#' 
			order by bomno,bmitemno
		</cfquery>
		<cfoutput query="getdata">
			<cfset xbom = #bomno#>
			<cfset xitem = #bmitemno#>
			<cfset xqty = #bmqty#>
			<cfset xlocation = #bmlocation#>
			<cfset xgroup = #assm_group#>
		</cfoutput>
		<cfquery name="getitem" datasource="#dts#">
			select itemno,desp from icitem where itemno <> '#xitemno#' order by itemno
		</cfquery>
		<cfquery name="getbomdata" datasource="#dts#">
			select * from billmat where bomno = '#xbom#' and itemno = '#xitemno#' order by bomno,bmitemno
		</cfquery>
		<cfquery name="getbomcost" datasource="#dts#">
			select bom_cost from icitem where itemno = '#xitemno#'
		</cfquery>
<cfelseif isdefined("form.mode")>
	
		<cfquery name="getbomdata" datasource="#dts#">
			select * from billmat where bomno = '#form.bomno#' and itemno = '#sitemno#' order by bomno,bmitemno
		</cfquery>
		<cfset xbom = "#form.bomno#">
		<cfset xitem = "">
		<cfset xqty = "1">
		<cfset xlocation = "">
		<cfset xgroup = "">
		<cfquery name="getitem" datasource="#dts#">
			select itemno,desp from icitem where itemno <> '#sitemno#' order by itemno
		</cfquery>
		<cfset xitemno = #sitemno#>
		<cfquery name="getbomcost" datasource="#dts#">
			select bom_cost from icitem where itemno = '#xitemno#'
		</cfquery>	
<cfelseif isdefined("form.ttype")> 
	
	<cfset xbom = "#form.bomno#">
	<cfset xitem = "">
	<cfset xqty = 1>
	<cfset xlocation = "">
	<cfset xgroup = "">
	<cfquery name="getitem" datasource="#dts#">
		select itemno,desp from icitem where itemno <> '#sitemno#' order by itemno
	</cfquery>
	<cfset xitemno = #sitemno#>
	<cfquery name="getbomdata" datasource="#dts#">
		select * from billmat where bomno = '#xbom#' and itemno = '#sitemno#' order by bomno,bmitemno
	</cfquery>
	<cfquery name="getbomcost" datasource="#dts#">
		select bom_cost from icitem where itemno = '#sitemno#'
	</cfquery>
	<!--- <cfset ttype = #form.mode#> --->
</cfif>

<cfquery name="getlocation" datasource="#dts#">
	select location from iclocation order by location
</cfquery>

<cfoutput><h4><a href="bom.cfm">Create Bill of Material</a> || <a href="vbom.cfm">List all Bill of Material</a> || <a href="bom.cfm">Search Bill of Material</a></h4></cfoutput>
<h1 align="center">Item No : <cfoutput>#xitemno#</cfoutput></h1>

<p align="right">Miscellaneous Cost : <cfoutput>#numberformat(getbomcost.bom_cost,".__")#</cfoutput></p>

<table width="80%" border="0" align="center" class="data">
  <tr>
      <th>Bom No</th>
	  <th>Item No</th>
	  <th>Quantity</th>
	  <th>Location</th>
	  <th>Assm Group</th>
	  <th>Action</th>
	
  </tr>
  <cfoutput query="getbomdata">
  <tr>
    
    <td>#bomno#</td>
    <td>#bmitemno#</td>
    <td>#bmqty#</td>
    <td>#bmlocation#</td>
    <td>#assm_group#</td>
	<td align="center">
		<a href = "bom2.cfm?ttype=Edit&xitemno=#urlencodedformat(xitemno)#&sitem=#urlencodedformat(bmitemno)#&xbom=#urlencodedformat(bomno)#">Edit</a>&nbsp;&nbsp;
		<a href="bom2.cfm?ttype=Delete&xitemno=#urlencodedformat(xitemno)#&sitem=#urlencodedformat(bmitemno)#&xbom=#urlencodedformat(bomno)#">Delete</a>
	</td>
  </tr>
  </cfoutput>
</table>

<br>
<table width="60%" border="0" align="center" class="data">
  <cfoutput>
  <tr>
    <th>BOM No :</th>
    <td><input name="bomno" type="text" size="5" maxlength="2" required="yes" value="#xbom#" readonly></td>
  </tr>
  </cfoutput>
  <tr> 
      <th width="37%"> Item No :</th>
    <td width="63%"><select name="sitem">
		<option value="">Choose an Item</option>
        <cfoutput query="getitem">
          <option value="#convertquote(itemno)#"<cfif xitem eq itemno>selected</cfif>>#itemno# - #desp#</option>
        </cfoutput> </select>
      </td>
  </tr>
  <tr> 
      <th>Quantity :</th>
    <td><cfinput type="text" name="qty" size="5" value="#xqty#" maxlength="5" required="yes"></td>
  </tr>
  <tr> 
      <th>Location :</th>
    <td><select name="locat">
		<option value="">Please choose a Location</option>
		<cfoutput query="getlocation"><option value="#location#"<cfif xlocation eq location>selected</cfif>>#location#</option></cfoutput>
	</select></td>
  </tr>
  <tr> 
    <th>Assembly Group :</th>
    <td><cfinput type="text" name="sgroup" maxlength="40" value="#xgroup#">
      <cfoutput>  <cfif isdefined("form.ttype")><input type="submit" name="mode" value="#form.ttype#"><cfelseif isdefined("form.mode")><input type="submit" name="mode" value="#mode#"><cfelse><input type="submit" name="mode" value="#ttype#"><input type="hidden" name="sitemori" value="#sitem#"></cfif>
        <input type="Submit" name="Finish" value="Finish">
		<input type="hidden" name="sitemno" value="#convertquote(xitemno)#">
		<input type="hidden" name="misc" value="#getbomcost.bom_cost#"></cfoutput>
		</td>
  </tr>
</table>
</body></cfform>

</html>
