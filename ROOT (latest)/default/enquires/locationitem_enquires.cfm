<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Item Balance Enquires</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

<script type="text/javascript">

// begin: product search
function getProductNo(){
	var inputtext = document.form.searchitem.value;
	DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult);
}

function getProduct(type){
	if(type == 'itemto'){
		var inputtext = document.form.searchitemto.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult3);
		
	}else{
		var inputtext = document.form.searchitemfr.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult2);
	}
}

function getProductResult3(itemArray){
	DWRUtil.removeAllOptions("itemto");
	DWRUtil.addOptions("itemto", itemArray,"KEY", "VALUE");
}

function getProductResult2(itemArray){
	DWRUtil.removeAllOptions("itemfrom");
	DWRUtil.addOptions("itemfrom", itemArray,"KEY", "VALUE");
}

function getProductResult(itemArray){
	DWRUtil.removeAllOptions("itemno");
	DWRUtil.addOptions("itemno", itemArray,"KEY", "VALUE");
}
// end: product search

</script>
</head>
<!--- Add On 12-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<!--- <cfquery datasource="#dts#" name="getitem">
	select itemno, desp from icitem order by itemno
</cfquery> --->
<cfquery datasource="#dts#" name="getitem">
	select itemno, desp from icitem order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
</cfquery>

<cfquery name="getgeneral" datasource="#dts#">
	select filterall,LLOCATION from gsetup
</cfquery>

<cfquery name="getlocation" datasource="#dts#">
	select location,desp 
	from iclocation 
	<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super' and Huserloc neq "All_loc">
		where location in (#ListQualify(Huserloc,"'",",")#)
	</cfif>
	order by location
</cfquery>
<body>
<h1><center>
    Item Balance Enquires 
  </center></h1>

<table width="75%" border="0" cellspacing="0" cellpadding="3" class="data" align="center">
<tr><th><u>Single Item Balance</u></th></tr>
		<cfform action="locationitem_enquiresreport.cfm" method="post" target="_self" name="form">	<tr>
		  	<th>Click one item to view balance.</th>
        	<td valign="center"><br/>
				<cfif isdefined("url.itemno1")>
					<cfinput type="text" name="itemno" value="#url.itemno1#">
				<cfelse>
					<select name="itemno">
						<option value="">Choose a Item No</option>
						<cfoutput query="getitem"> 
			    			<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
			    		</cfoutput>
					</select>
					<cfif getgeneral.filterall eq "1">
						<input type="text" name="searchitem" onKeyUp="getProductNo();" size="15">
					</cfif>
				</cfif>
                </td>
                </tr>
	<tr>
      	<th><cfoutput>#getgeneral.lLOCATION#</cfoutput> From</th>
      	<td colspan="2">
			<select name="locationfrom">
				<cfif HUserGrpID eq 'Super' or getpin2.h4700 neq 'T'>
          			<option value="">Choose a <cfoutput>#getgeneral.lLOCATION#</cfoutput></option>
				</cfif>
          		<!--- <option value="">Choose a Location</option> --->
          		<cfoutput query="getlocation">
					<option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
				</cfoutput>
			</select>
		</td>
    </tr>
    <tr>
      	<th><cfoutput>#getgeneral.lLOCATION#</cfoutput> To</th>
      	<td colspan="2">
			<select name="locationto">
				<cfif HUserGrpID eq 'Super' or getpin2.h4700 neq 'T'>
          			<option value="">Choose a <cfoutput>#getgeneral.lLOCATION#</cfoutput></option>
				</cfif>
          		<!--- <option value="">Choose a Location</option> --->
          		<cfoutput query="getlocation">
					<option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
				</cfoutput>
			</select>
           

		</td>
    </tr>
		<tr><td colspan="2" align="center">
         <!--- <input type="submit" name="Submit1" value="Submit"> ---><!---  --->
				<input type="submit" value="Submit" name="choose"> <a href="locationitem_enquiressearch.cfm?">SEARCH</a>
                </td>
        </tr>
		<tr> 
			<td colspan="3"><hr></td>
		</tr>
        <tr><th><u>Multiple Item Balance</u></th></tr>
		<cfoutput><tr>
		  	<th>Item No From</th>
        	<td><select name="itemfrom">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">
					<input type="text" name="searchitemfr" onKeyUp="getProduct('itemfrom');" size="15">
				</cfif>
			</td>
		</tr>
      	<tr> 
        	<th>Item No To</th>
        	<td><select name="itemto">
				<option value="">Choose a Item No</option>
				<cfloop query="getitem">
				<option value="#convertquote(itemno)#">#itemno# - #desp#</option>
				</cfloop>
				</select>
				<cfif getgeneral.filterall eq "1">
					<input type="text" name="searchitemto" onKeyUp="getProduct('itemto');" size="15">
				</cfif>
			
			</td>
      	</tr>
        <tr>
      	<th><cfoutput>#getgeneral.lLOCATION#</cfoutput> From</th>
      	<td colspan="2">
			<select name="locationfrom2">
				<cfif HUserGrpID eq 'Super' or getpin2.h4700 neq 'T'>
          			<option value="">Choose a <cfoutput>#getgeneral.lLOCATION#</cfoutput></option>
				</cfif>
          		<!--- <option value="">Choose a Location</option> --->
          		<cfloop query="getlocation">
					<option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
				</cfloop>
			</select>
		</td>
    </tr>
    <tr>
      	<th><cfoutput>#getgeneral.lLOCATION#</cfoutput> To</th>
      	<td colspan="2">
			<select name="locationto2">
				<cfif HUserGrpID eq 'Super' or getpin2.h4700 neq 'T'>
          			<option value="">Choose a <cfoutput>#getgeneral.lLOCATION#</cfoutput></option>
				</cfif>
          		<!--- <option value="">Choose a Location</option> --->
          		<cfloop query="getlocation">
					<option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
				</cfloop>
			</select>
           

		</td>
    </tr>
    <tr><td colspan="2" align="center"><input type="submit" value="Display" name="choose"> </td></tr>
		</cfoutput>
		</cfform>
	</table>
	

</body>
</html>
