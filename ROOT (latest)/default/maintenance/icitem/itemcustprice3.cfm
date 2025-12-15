<html>
<head>
<title>Recommended Price - Customer/Item</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<!--- Add On 13-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<cfquery datasource="#dts#" name="getinfo">
	select * from icl3p2 where custno = "#custno#"
</cfquery>

<!--- <cfquery datasource="#dts#" name="getitem">
	select itemno,desp from icitem where (nonstkitem<>'T' or nonstkitem is null) order by itemno;
</cfquery> --->
<cfquery datasource="#dts#" name="getitem">
	select itemno,desp from icitem where (nonstkitem<>'T' or nonstkitem is null) 
	order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
</cfquery>

<cfif isdefined("form.mode")>
<cfelse>
	<cfset form.mode=url.type>
	<cfset mode=url.type>
</cfif>

<cfif form.mode eq "delete">
	<cfquery datasource="#dts#" name="deleteicl3p">
		Delete from icl3p2 where custno = "#custno#"
	</cfquery>

	<form name="done" action="itemcustprice.cfm" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
	<cfset status = "Deleted Successfully">
	<script>
		done.submit();
	</script>
</cfif>

<body>
<h1>Recommended Price - Customer/Item</h1>

<cfparam name="status" default="">

<cfoutput>
	<h4>
		<a href="itemcustprice2.cfm?type=create">Create a Recommended Price</a> ||
		<a href="itemcustprice.cfm">List all Recommended Price</a> ||
		<a href="sitemcustprice.cfm">Search Recommended Price</a> ||
		<a href="../icitem_setting.cfm">More Setting</a>
	</h4>
</cfoutput>

<table width="50%" align="center" class="data" cellpadding="2" cellspacing="0">
<cfoutput>
  	<cfquery datasource="#dts#" name="getcust">
  		select custno,name,name2,currcode from #target_arcust# where custno = '#custno#'
  	</cfquery>
	<tr>
      	<th width="37%">Customer No</th>
      	<td>#getcust.custno#</td>
    </tr>
    <tr>
      	<th>Customer Name</th>
      	<td>#getcust.name# #getcust.name2#</td>
    </tr>
	<tr>
      	<th>Currency</th>
      	<td>#getcust.currcode#</td>
    </tr>
</cfoutput>
</table>

<br>

<table width="100%"  align="center" class="data" cellpadding="2" cellspacing="0">
	<tr>
    	<th>Item No</th>
    	<th>Description</th>
        <cfif getpin2.h13B0 eq 'T'>
    	<th>Recommended Price</th>
    	<th>Disc % (1)</th>
    	<th>Disc % (2)</th>
    	<th>Disc % (3)</th>
		<th>Net Price</th>
        </cfif>
    	<th>Note</th>
        <cfif getpin2.h13B0 eq 'T'>
    	<th>Action</th>
        </cfif>
  	</tr>

  	<cfif getinfo.recordcount gt 0>
  		<cfoutput query="getinfo">
      		<cfquery datasource="#dts#" name="getname">
      			select desp from icitem where itemno = '#getinfo.itemno#'
      		</cfquery>
      		<tr>
        		<td width="10%">#getinfo.itemno#</td>
        		<td width="20%">#getname.desp#</td>
                <cfif getpin2.h13B0 eq 'T'>
        		<td width="10%" align="right">#numberFormat(price,",.____")#</td>
        		<td width="10%" align="right">#DecimalFormat(dispec)#</td>
        		<td width="10%" align="right">#DecimalFormat(dispec2)#</td>
        		<td width="10%" align="right">#DecimalFormat(dispec3)#</td>
				<td width="10%" align="right">#numberFormat(netprice,",.____")#</td>
                </cfif>
        		<td width="20%">#ci_note#</td>
				<input type="hidden" name="mode" value="#mode#">
                <cfif getpin2.h13B0 eq 'T'>
        		<cfif status neq "B">
					<td width="10%" nowrap><div align="center">
					<a href="itemcustprice4.cfm?type1=Edit&itemno=#URLEncodedFormat(itemno)#&custno=#URLEncodedFormat(custno)#&mode=#mode#">
					<img height="18px" width="18px" src="../../../images/edit.ICO" alt="Edit" border="0">Edit</a>&nbsp;
					<a href="itemcustprice4.cfm?type1=Delete&itemno=#(itemno)#&custno=#URLEncodedFormat(custno)#&mode=#mode#">
					<img height="18px" width="18px" src="../../../images/delete.ICO" alt="Delete" border="0">Delete</a></div>
					</td>
				</cfif>
				</cfif>
      		</tr>
    </cfoutput>
  </cfif>
</table>

<cfform name="form1" method="post" action="itemcustprice.cfm">
	<div align="right">
    	<input type="submit" name="Submit" value="Save">
  	</div>
</cfform>

<cfif status neq "B">
	<cfform name="form" action="itemcustprice4.cfm?type1=Add" method="post" onsubmit="return validate()">
		<cfoutput>
			<input type="hidden" name="custno" value="#custno#">
			<input type="hidden" name="mode" value="#mode#">
		</cfoutput>
		<hr>
		<table width="85%" align="center" class="data" cellpadding="2" cellspacing="0">
			<tr>
				<th width="20%">Item Code</th>
				<td><select name="itemno">
						<option value="">Choose an Item</option>
						<cfoutput query="getitem">
						<option value="#itemno#">#itemno# - #desp#</option>
						</cfoutput>
					</select>
				</td>
				<td><input type="submit" name="submit2" value="Add Item"></td>
			</tr>
		</table>
	</cfform>
</cfif>
</body>
</html>