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

<!--- <cfquery datasource="#dts#" name="getitem">
	select itemno, desp from icitem where (nonstkitem<>'T' or nonstkitem is null) order by itemno
</cfquery> --->
<cfquery datasource="#dts#" name="getitem">
	select itemno, desp from icitem where (nonstkitem<>'T' or nonstkitem is null) 
	order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
</cfquery>

<cfquery name="currency" datasource="#dts#">
	select * from #target_currency#
</cfquery>

<script language="JavaScript">

function displayrate()
	{
		if(document.form.refno3.value!='')
		{
			<cfoutput query ="currency">
			if(document.form.refno3.value=='#currency.currcode#')
			{	<cfquery datasource="#dts#" name="getGeneralInfo">
					Select * from GSetup
				</cfquery>

				<cfset lastaccyear = dateformat(getGeneralInfo.lastaccyear, "dd/mm/yyyy")>
				<cfset period = getGeneralInfo.period>
				<cfset currentdate = dateformat(now(),"dd/mm/yyyy")>

				<cfset tmpYear = year(currentdate)>
				<cfset clsyear = year(lastaccyear)>

				<cfset tmpmonth = month(currentdate)>
				<cfset clsmonth = month(lastaccyear)>

				<cfset intperiod = (tmpyear - clsyear) * 12 + tmpmonth - clsmonth>
				<cfif intperiod gt 18 or intperiod lt 0>
					<cfset readperiod = 18>
				<cfelse>
					<cfset readperiod = numberformat(intperiod,"00")>
				</cfif>

					<cfif readperiod eq '01'>
						<cfset rates2 = currency.CurrP1>
					</cfif>
					<cfif readperiod eq '02'>
						<cfset rates2 = currency.CurrP2>
					</cfif>
					<cfif readperiod eq '03'>
						<cfset rates2 = currency.CurrP3>
					</cfif>
					<cfif readperiod eq '04'>
						<cfset rates2 = currency.CurrP4>
					</cfif>
					<cfif readperiod eq '05'>
						<cfset rates2 = currency.CurrP5>
					</cfif>
					<cfif readperiod eq '06'>
						<cfset rates2 = currency.CurrP6>
					</cfif>
					<cfif readperiod eq '07'>
						<cfset rates2 = currency.CurrP7>
					</cfif>
					<cfif readperiod eq '08'>
						<cfset rates2 = currency.CurrP8>
					</cfif>
					<cfif readperiod eq '09'>
						<cfset rates2 = currency.CurrP9>
					</cfif>
					<cfif readperiod eq '10'>
						<cfset rates2 = currency.CurrP10>
					</cfif>
					<cfif readperiod eq '11'>
						<cfset rates2 = currency.CurrP11>
					</cfif>
					<cfif readperiod eq '12'>
						<cfset rates2 = currency.CurrP12>
					</cfif>
					<cfif readperiod eq '13'>
						<cfset rates2 = currency.CurrP13>
					</cfif>
					<cfif readperiod eq '14'>
						<cfset rates2 = currency.CurrP14>
					</cfif>
					<cfif readperiod eq '15'>
						<cfset rates2 = currency.CurrP15>
					</cfif>
					<cfif readperiod eq '16'>
						<cfset rates2 = currency.CurrP16>
					</cfif>
					<cfif readperiod eq '17'>
						<cfset rates2 = currency.CurrP17>
					</cfif>
					<cfif readperiod eq '18'>
						<cfset rates2 = currency.CurrP18>
					</cfif>
				document.form.currrate.value='#rates2#';
			}
		</cfoutput>
		}
	}
</script>

<body>
<cfoutput>
  	<cfif url.type eq "edit">
    	<cfquery datasource='#dts#' name="getitem">
    		Select * from icl3p2 where itemno='#url.itemno#'
   	 	</cfquery>

		<cfquery datasource="#dts#" name="getname">
    		select desp,despa from icitem where itemno = '#url.itemno#'
    	</cfquery>

		<cfset itemno=getitem.itemno>
    	<cfset desp = getname.desp>
    	<cfset despa = getname.despa>
    	<cfset mode="Edit">
    	<cfset title="Edit">
    	<cfset button="Edit">
  	</cfif>

	<cfif url.type eq "delete">
    	<cfquery datasource='#dts#' name="getitem">
    		Select * from icl3p2 where itemno='#url.itemno#'
    	</cfquery>

		<cfquery datasource="#dts#" name="getname">
    		select desp,despa from icitem where itemno = '#url.itemno#'
    	</cfquery>

		<cfset itemno=getitem.itemno>
    	<cfset desp=getname.desp>
    	<cfset despa=getname.despa>
    	<cfset mode="Delete">
    	<cfset title="Delete">
    	<cfset button="Delete">
  	</cfif>

	<cfif url.type eq "create">
		<cfset itemno="">
		<cfset desp="">
		<cfset despa="">
		<cfset mode="Create">
		<cfset title="Create">
		<cfset button="Create">
  	</cfif>

	<h1>#title# Recommended Price - Item/Customer</h1>
  	<h4>
  	<a href="custitemprice2.cfm?type=create">Create a Recommended Price</a> ||
  	<a href="custitemprice.cfm"> List all Recommended Price</a> ||
  	<a href="scustitemprice.cfm"> Search Recommended Price</a> ||
  	<a href="../icitem_setting.cfm">More Setting</a>
  	</h4>
</cfoutput>

<cfform name="form" action="custitemprice3.cfm" method="post" onsubmit="return validate()">
	<cfoutput><input type="hidden" name="mode" value="#mode#"></cfoutput>

	<h1 align="center">Recommended Price - Item</h1>
  	<table align="center" class="data" width="65%" cellpadding="2" cellspacing="0">
    	<tr>
      		<th width="20%">Item No</th>
      		<td>
			<cfif mode eq "Delete" or mode eq "Edit">
          		<cfoutput>
					<h2>#url.itemno# - #desp#</h2>
            		<input name = "itemno" type="hidden" value="#url.itemno#">
					<input name = "status" type="hidden" value="#url.status#">
          		</cfoutput>
          	<cfelse>
          		<select name="itemno">
            		<option value="">Choose an Item</option>
            		<cfoutput query="getitem">
              		<option value="#itemno#">#itemno# - #desp#</option>
            		</cfoutput>
          		</select>
        	</cfif>
			</td>
    	</tr>
    	<tr>
      		<td></td>
      		<td align="right"><cfoutput><input name="submit" type="submit" value="#button#"></cfoutput></td>
    	</tr>
  	</table>
</cfform>
</body>
</html>