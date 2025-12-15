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

<!--- <cfquery datasource="#dts#" name="getcust">
	select custno,name,name2,currcode from #target_arcust# where status<>'B' order by custno
</cfquery> --->
<cfquery datasource="#dts#" name="getcust">
	select custno,name,name2,currcode 
	from #target_arcust# 
	where (status<>'B' or status is null)  
	order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
</cfquery>

<Script language="JavaScript">
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

		<cfoutput query ="getcust">
		if(document.invoicesheet.custno.value=="#custno#")
		{
			document.invoicesheet.name.value="#getcust.name#";
			document.invoicesheet.name2.value="#getcust.name2#";
			document.invoicesheet.currcode.value="#getcust.currcode#";
		}
		</cfoutput>
	}
</Script>

<body>

<cfif url.type eq "edit">
	<cfquery datasource='#dts#' name="getitem">
    	Select * from icl3p2 where custno='#url.custno#'
    </cfquery>

	<cfquery datasource="#dts#" name="getcust">
    	select custno,name,name2,currcode from #target_arcust# where custno = '#url.custno#'
    </cfquery>

	<cfset xcustno=getitem.custno>
    <cfset name=getcust.name>
    <cfset name2=getcust.name2>
	<cfset currcode=getcust.currcode>
    <cfset mode="Edit">
    <cfset title="Edit">
    <cfset button="Edit">
</cfif>

<cfif url.type eq "delete">
    <cfquery datasource='#dts#' name="getitem">
    	Select * from icl3p2 where custno='#url.custno#'
    </cfquery>

	<cfquery datasource="#dts#" name="getcust">
    	select custno,name,name2,currcode from #target_arcust# where custno = '#url.custno#'
    </cfquery>

	<cfset xcustno=getitem.custno>
    <cfset name=getcust.name>
    <cfset name2=getcust.name2>
	<cfset currcode=getcust.currcode>
    <cfset mode="Delete">
    <cfset title="Delete">
    <cfset button="Delete">
</cfif>

<cfif url.type eq "create">
    <cfset xcustno="">
    <cfset name="">
    <cfset name2="">
	<cfset currcode ="">
    <cfset mode="Create">
    <cfset title="Create">
    <cfset button="Create">
</cfif>

<cfoutput>
	<h1>#title# Recommended Price - Customer/Item</h1>
  	<h4>
		<a href="itemcustprice2.cfm?type=create">Create a Recommended Price</a> ||
		<a href="itemcustprice.cfm">List All Recommended Price</a> ||
		<a href="sitemcustprice.cfm">Search Recommended Price</a> ||
		<a href="../icitem_setting.cfm">More Setting</a>
	</h4>
</cfoutput>

<form name="invoicesheet" action="itemcustprice3.cfm" method="post" <cfif type eq 'Create'>onSubmit="return validate()"</cfif>>
  	<cfoutput><input type="hidden" name="mode" value="#mode#"></cfoutput>

	<h1 align="center">Recommended Price - Customer</h1>

	<table align="center" class="data" width="65%" cellpadding="2" cellspacing="0">
    	<tr>
      		<th width="20%">Customer No</th>
      		<td>
			<cfif mode eq "Delete" or mode eq "Edit">
          		<cfoutput>
				<h2>#url.custno#</h2>
            	<input name = "custno" type="hidden" value="#url.custno#">
				<input name = "status" type="hidden" value="#url.status#">
          		</cfoutput>
          	<cfelse>
          		<select name="custno" onChange="displayname()">
            		<option value="">Choose a Customer</option>
            		<cfoutput query = "getcust">
              		<option value="#custno#"<cfif #xcustno# eq #getcust.custno#>Selected </cfif>>#custno# - #name#</option>
            		</cfoutput>
          		</select>
        	</cfif>
			</td>
    	</tr>
    	<tr>
      		<th>Customer Name</th>
      		<td><cfoutput>
	  		<cfif mode eq "Delete" or mode eq "Edit">
            	#name# #name2#
			<cfelse>
          		<input name="name" type="text" size="50" maxlength="50"><br>
		  		<input name="name2" type="text" size="50" maxlength="50">
		  	</cfif></cfoutput>
		</td>
    	</tr>
   	 	<tr>
      		<th>Currency</th>
      		<td>
	  		<cfoutput>
	  			<cfif mode eq "Delete" or mode eq "Edit">
               	#currcode#
				<cfelse>
          			<input name="currcode" type="text" size="20" readonly>
		  		</cfif>
        	</cfoutput>
       		</td>
    	</tr>
    	<tr>
      		<td></td>
      		<td align="right">
			<cfoutput>
          	<input name="submit" type="submit" value="#button#">
        	</cfoutput>
			</td>
    	</tr>
  	</table>
</form>
</body>
</html>