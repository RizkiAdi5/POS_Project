<html>
<head>
<title>Item - Customer</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<!--- Add On 13-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<!--- <cfquery datasource="#dts#" name="getcust">
	select custno,name,name2,currcode from #target_arcust# where status<>'B' order by custno
</cfquery> --->
<cfquery datasource="#dts#" name="getcust">
	select custno,name,name2,currcode from #target_arcust# where (status<>'B' or status is null)  
	order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
</cfquery>

<cfquery datasource="#dts#" name="getinfo">
	select * from icl3p2 where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#itemno#">
</cfquery>

<cfif isdefined("form.mode")>
<cfelse>
	<cfset form.mode=url.type>
	<cfset mode=url.type>
</cfif>

<cfif form.mode eq "Create" and form.mode eq "Edit">
	<cfset custno="">
	<cfset name="">
	<cfset name2="">
</cfif>

<cfif form.mode eq "delete">
	<cfquery datasource="#dts#" name="deleteicl3p2">
		Delete from icl3p2 where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#itemno#">
	</cfquery>
	<form name="done" action="custitemprice.cfm" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
	<cfset status = "Deleted Successfully">

	<script>
		done.submit();
	</script>
</cfif>

<body>
<h1>Recommended Price - Item / Customer</h1>

<cfparam name="status" default="">

<cfoutput>
	<h4>
	<a href="custitemprice2.cfm?type=create">Create a Recommended Price</a> ||
	<a href="custitemprice.cfm"> List all Recommended Price</a> ||<a href="scustitemprice.cfm">Search Recommended Price</a> ||
	<a href="../icitem_setting.cfm">More Setting</a>
	</h4>
</cfoutput>

<table width="50%" align="center" class="data" cellpadding="2" cellspacing="0">
<cfoutput>
  	<cfquery datasource="#dts#" name="getdesp">
  		select * from icitem where itemno = <cfqueryparam cfsqltype="cf_sql_char" value="#itemno#">
  	</cfquery>
    <tr>
      	<th width="25%">Item No</th>
      	<td>#getdesp.itemno#</td>
    </tr>
    <tr>
      	<th>Description</th>
      	<td>#getdesp.desp#</td>
    </tr>
</cfoutput>
</table>

<br>

<table width="100%"  align="center" class="data" cellpadding="2" cellspacing="0">
  	<tr>
    	<th width="8%">Cust No</th>
    	<th width="20%">Cust Name</th>
		<th width="8%">Currency</th>
        <cfif getpin2.h13B0 eq 'T'>
    	<th width="10%">Recommended Price&nbsp; </th>
    	<th width="8%">Disc % (1)
    	<th width="8%">Disc % (2)</th>
    	<th width="8%">Disc % (3)</th>
		<th width="10%">Net Price</th>
        </cfif>
    	<th width="20%">Note</th>
        <cfif getpin2.h13B0 eq 'T'>
    	<th width="10%">Action</th>
        </cfif>
  	</tr>

	<cfif getinfo.recordcount gt 0>
    	<cfoutput query="getinfo">
      		<cfquery datasource="#dts#" name="getname">
      			select name,currcode from #target_arcust# where custno = '#getinfo.custno#'
      		</cfquery>
      		<tr>
        		<td>#custno#</td>
        		<td>#getname.name#</td>
				<td>#getname.currcode#</td>
                <cfif getpin2.h13B0 eq 'T'>
        		<td><div align="right">#numberFormat(price,",.____")#</div></td>
        		<td><div align="right">#DecimalFormat(dispec)#</div></td>
        		<td><div align="right">#DecimalFormat(dispec2)#</div></td>
        		<td><div align="right">#DecimalFormat(dispec3)#</div></td>
				<td><div align="right">#numberFormat(netprice,",.____")#</div></td>
                </cfif>
        		<td>#ci_note#</td>
				<input type="hidden" name="mode" value="#mode#">
                <cfif getpin2.h13B0 eq 'T'>
        		<cfif status neq "T">
					<td nowrap><div align="center">
					<a href="custitemprice4.cfm?type1=Edit&itemno=#URLEncodedFormat(itemno)#&custno=#URLEncodedFormat(custno)#&mode=#URLEncodedFormat(mode)#">
					<img height="18px" width="18px" src="../../../images/edit.ICO" alt="Edit" border="0">Edit</a>&nbsp;
					<a href="custitemprice4.cfm?type1=Delete&itemno=#URLEncodedFormat(itemno)#&custno=#URLEncodedFormat(custno)#&mode=#URLEncodedFormat(mode)#">
					<img height="18px" width="18px" src="../../../images/delete.ICO" alt="Delete" border="0">Delete</a></div>
					</td>
				</cfif>
                </cfif>
			</tr>
    	</cfoutput>
  	</cfif>
</table>

<cfform name="form1" method="post" action="custitemprice.cfm">
  	<div align="right">
    	<input type="submit" name="Submit" value="Save">
  	</div>
</cfform>

<p>&nbsp;</p>

<cfif status neq "T">
	<cfform name="form" action="custitemprice4.cfm?type1=Add" method="post" onsubmit="return validate()">
		<cfoutput>
			<input type="hidden" name="itemno" value="#itemno#">
			<input type="hidden" name="mode" value="#mode#">
		</cfoutput>
		<hr>
		<table width="85%"  align="center" class="data" cellpadding="2" cellspacing="0">
			<tr>
				<th width="20%">Customer No</th>
				<td>
				<select name="custno">
					<option value="">Choose a Customer</option>
					<cfoutput query = "getcust">
					<option value="#custno#">#custno# - #name#</option>
					</cfoutput>
				</select>
				</td>
				<td><input type="submit" name="submit2" value="Add Customer"></td>
			</tr>
		</table>
	</cfform>
</cfif>
</body>
</html>