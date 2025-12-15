<html>
<head>
<title>Recommended Price - Supplier / Item</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<!--- Add On 13-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<!--- <cfquery datasource="#dts#" name="getsupp">
	select custno,name,name2,currcode from #target_apvend# where status<>'B' order by custno
</cfquery> --->
<cfquery datasource="#dts#" name="getsupp">
	select custno,name,name2,currcode 
	from #target_apvend# 
	where (status<>'B' or status is null) 
	order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
</cfquery>

<cfquery name="currency" datasource="#dts#">
	select * from #target_currency# order by currcode
</cfquery>

<script language="JavaScript">
function validate()
	{
		if(document.invoicesheet.custno.value=='')
		{
			alert("Your Customer's No. cannot be blank.");
			document.invoicesheet.custno.focus();
			return false;
		}
	}
function displayname()
	{
		<cfoutput query ="getsupp">
		if(document.invoicesheet.custno.value=="#custno#")
		{
			document.invoicesheet.name.value="#getsupp.name#";
			document.invoicesheet.name2.value="#getsupp.name2#";
			document.invoicesheet.currcode.value="#getsupp.currcode#";
		}
		</cfoutput>
	}
</script>

<body>

<cfoutput>
  	<cfif url.type eq "edit">
    	<cfquery datasource='#dts#' name="getitem">
    		Select * from icl3p where custno = '#url.custno#'
    	</cfquery>

		<cfquery datasource="#dts#" name="getsupp">
    		select custno,name,name2,currcode from #target_apvend# where custno = '#url.custno#'
    	</cfquery>

		<cfset custno=getitem.custno>
    	<cfset name=getsupp.name>
    	<cfset name2=getsupp.name2>
		<cfset currcode=getsupp.currcode>
    	<cfset mode="Edit">
    	<cfset title="Edit">
    	<cfset button="Edit">
  	</cfif>

	<cfif url.type eq "delete">
    	<cfquery datasource='#dts#' name="getitem">
    		Select * from icl3p where custno = '#url.custno#'
    	</cfquery>

		<cfquery datasource="#dts#" name="getsupp">
    		select custno,name,name2,currcode from #target_apvend# where custno = '#url.custno#'
    	</cfquery>

		<cfset custno=getitem.custno>
    	<cfset name=getsupp.name>
    	<cfset name2=getsupp.name2>
		<cfset currcode=getsupp.currcode>
    	<cfset mode="Delete">
    	<cfset title="Delete">
    	<cfset button="Delete">
  	</cfif>

	<cfif url.type eq "create">
    	<cfset custno="">
    	<cfset name="">
    	<cfset name2="">
		<cfset currcode = "">
    	<cfset mode="Create">
    	<cfset title="Create">
    	<cfset button="Create">
  	</cfif>

	<h1>#title# Recommended Price - Supplier/Item</h1>
  	<h4>
		<a href="itemsupprice2.cfm?type=create">Create a Recommended Price</a> ||
		<a href="itemsupprice.cfm">List All Recommended Price</a> ||
		<a href="sitemsupprice.cfm">Search Recommended Price</a> ||
		<a href="../icitem_setting.cfm">More Setting</a>
	</h4>
</cfoutput>

<form name="invoicesheet" action="itemsupprice3.cfm" method="post" <cfif type eq 'Create'>onsubmit="return validate()"</cfif>>
  	<cfoutput><input type="hidden" name="mode" value="#mode#"></cfoutput>

	<h1 align="center">Recommended Price - Supplier</h1>

	<table align="center" class="data" width="70%" cellpadding="2" cellspacing="0">
    	<tr>
      		<th width="20%">Supplier No</th>
      		<td>
			<cfif mode eq "Delete" or mode eq "Edit">
          		<cfoutput>
            	<h2>#url.custno#</h2>
            	<input name = "custno" type="hidden" value="#custno#">
				<input name = "status" type="hidden" value="#status#">
          		</cfoutput>
          	<cfelse>
          		<select name="custno" onChange="displayname()">
            		<option value="">Choose a Supplier</option>
            		<cfoutput query = "getsupp">
              		<option value="#custno#"<cfif custno eq getsupp.custno>Selected </cfif>>#custno# - #name#</option>
            		</cfoutput>
          		</select>
			</cfif>
			</td>
    	</tr>
    	<tr>
      		<th>Name</th>
      		<td>
			<cfoutput>
	  		<cfif mode eq "Delete" or mode eq "Edit">
				 #name# #name2#
			<cfelse>
          		<input name="name" type="text" size="50" maxlength="50" value="#name#"><br>
				<input name="name2" type="text" size="50" maxlength="50" value='#name2#'>
		  	</cfif>
			</cfoutput>
         	</td>
    	</tr>
    	<tr>
      		<th>Currency</th>
      		<td>
	  		<cfif mode eq "Delete" or mode eq "Edit">
            	<cfoutput>#currcode#</cfoutput>
			<cfelse>
          		<input name="currcode" type="text" size="20" readonly>
		  	</cfif>
        	</td>
    	</tr>
    	<tr>
      		<td></td>
      		<td align="right"><cfoutput><input name="submit" type="submit" value="#button#"></cfoutput></td>
    	</tr>
  	</table>
</form>

</body>
</html>