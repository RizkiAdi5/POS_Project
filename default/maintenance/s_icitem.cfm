<html>
<head>
<title>Products Profile</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfquery name="getgsetup" datasource="#dts#">
	select * from gsetup
</cfquery>

<h1>Items Selection Page</h1>		
<h4>
	<cfif getpin2.h1310 eq 'T'>
    <cfif lcase(hcomid) eq 'tcds_i'>
    	<a href="tcdsicitem2.cfm?type=Create">Creating a New Item</a> 
    <cfelse>
		<a href="icitem2.cfm?type=Create">Creating a New Item</a> 
    </cfif>
	|| 
	</cfif>
	<cfif getpin2.h1320 eq 'T'>
		<a href="icitem.cfm?type=icitem">List all Item</a> ||  
	</cfif>
	<cfif getpin2.h1330 eq 'T'>
		<a href="s_icitem.cfm?type=icitem">Search For Item</a> ||  
	</cfif>
	<cfif getpin2.h1340 eq 'T'>
		<a href="p_icitem.cfm">Item Listing</a> ||  
	</cfif>
	<a href="icitem_setting.cfm">More Setting</a> || 
	<cfif getpin2.h1350 eq 'T'>
		<a href="printbarcode_filter.cfm">Print Barcode</a> 
	</cfif>
    <cfif getpin2.h1311 eq 'T' and getpin2.h13D0 eq 'T'>
		||<a href="edititemexpress.cfm">Edit Item Express</a> 
	</cfif>
    <cfif getpin2.h1311 eq 'T'>
    <cfquery name="checkitemnum" datasource="#dts#">
    select itemno from icitem
    </cfquery>
    <cfif checkitemnum.recordcount lt 400>
    ||<a href="edititemexpress2.cfm">Edit Item Express 2</a> 
    </cfif>
    </cfif>
    <cfif getpin2.h1310 eq 'T'>
    <cfif lcase(HcomID) eq "vsolutionspteltd_i" or lcase(HcomID) eq "netivan_i" or lcase(HcomID) eq "demo_i" or lcase(HcomID) eq "vsyspteltd_i">
    ||<a href="updatepricetable2.cfm">Update Price & Foreign Price</a> 
    </cfif>
    </cfif>
    <cfif lcase(HcomID) eq "tcds_i">
    ||<a href="tcdsupdatesupplier.cfm">Update Supplier According To Label</a>
    ||<a href="tcdsupdatelabel.cfm">Change Label</a>
    </cfif>
</h4>

<cfoutput>
	<form action="s_icitem.cfm" method="post">
		<h1>Search By :
		<select name="searchType">
        <cfif hcomid eq "kimlee_i" or lcase(HcomID) eq "bakersoven_i">
        	<option value="desp" <cfif lcase(hcomid) eq "mhca_i" or lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i">selected</cfif>>Description</option>
			<option value="itemno"><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>#getgsetup.litemno#</cfif></option>
			<option value="aitemno"><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Vendor's Code<cfelse>#getgsetup.laitemno#</cfif></option>
			<option value="brand">#getgsetup.lbrand#</option>
			<cfelse>
            <option value="itemno" <cfif getgsetup.ddlitem eq 'Item No'>selected</cfif>><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>#getgsetup.litemno#</cfif></option>
			<option value="aitemno" <cfif getgsetup.ddlitem eq 'Product Code'>selected</cfif>><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Vendor's Code<cfelse>#getgsetup.laitemno#</cfif></option>

            <option value="barcode" <cfif getgsetup.ddlitem eq 'Bar Code'>selected</cfif>>Bar Code</option>
			<option value="brand" <cfif getgsetup.ddlitem eq 'Brand'>selected</cfif>>#getgsetup.lbrand#</option>
			<option value="desp" <cfif getgsetup.ddlitem eq 'Description'>selected</cfif><cfif lcase(hcomid) eq "mhca_i" or lcase(hcomid) eq "ideal_i" or lcase(hcomid) eq "idealb_i">selected</cfif>>Description</option>
            </cfif>
			<cfoutput>
				<option value="category" <cfif getgsetup.ddlitem eq 'Category'>selected</cfif>>#getgsetup.lcategory#</option>
				<option value="Sizeid" <cfif getgsetup.ddlitem eq 'Size'>selected</cfif>>#getgsetup.lsize#</option>
				<option value="costcode" <cfif getgsetup.ddlitem eq 'Rating'>selected</cfif>>#getgsetup.lrating#</option>
				<option value="colorid" <cfif getgsetup.ddlitem eq 'Material'>selected</cfif>>#getgsetup.lmaterial#</option>
				<option value="wos_group" <cfif getgsetup.ddlitem eq 'Group'>selected</cfif>>#getgsetup.lgroup#</option>
				<option value="shelf" <cfif getgsetup.ddlitem eq 'Model'>selected</cfif>>#getgsetup.lmodel#</option>	
                <option value="price" <cfif getgsetup.ddlitem eq 'Price'>selected</cfif>>Price</option>	
                <option value="Salec">Credit Sales</option>	
                <option value="purc">Purchase</option>	
                <option value="All" <cfif getgsetup.ddlitem eq 'All'>selected</cfif>>All</option>				
			</cfoutput>
		</select>
        <input type="checkbox" name="left" id="left" value="1" />
		Search for item : 
		<input type="text" name="searchStr" value="">
        <input type="submit" name="submit" value="Search">
		</h1>
	</form>

	<cfif isdefined("form.searchStr")>
		<!--- <cfquery name="getrecordcount" datasource="#dts#">
			select count(itemno) as totalsimilarrecord 
			from icitem 
			where #searchType# LIKE binary('#searchStr#') <cfif searchType eq "desp"> or despa LIKE binary('#searchStr#') </cfif>
			order by #searchType#
		</cfquery> --->
		<cfquery name="getrecordcount" datasource="#dts#">
			select count(itemno) as totalsimilarrecord 
			from icitem 
			where 
            <cfif searchType eq 'All'>
            (itemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or aitemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or barcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or brand like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or desp like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or category like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or size like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or costcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or colorid like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or wos_group like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or shelf like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or price like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%">)
            <cfelse>
            (#searchType# LIKE <cfif isdefined('form.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif> <cfif searchType eq "desp"> or despa LIKE <cfif isdefined('form.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif> </cfif>
            <cfif lcase(hcomid) eq 'tcds_i' and searchType eq 'Sizeid'>
            or remark1 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%">
            </cfif>
            <cfif lcase(hcomid) eq 'tcds_i' and searchType eq 'Colorid'>
            or remark2 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%">
            </cfif>
            
            )
            
            </cfif>
            <cfif Hitemgroup neq ''>
            and wos_group='#Hitemgroup#'
            </cfif>
			order by <cfif searchType eq "All"> itemno <cfelse>#searchType#</cfif>
            
		</cfquery>
		
		<cfif getrecordcount.totalsimilarrecord neq 0>
			<h2>Similar Results</h2>
			<iframe allowtransparency="true" align="middle" scrolling="auto" frameborder="0" width="100%" height="650" src="sicitem_similar.cfm?searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#<cfif isdefined('form.left')>&left=1</cfif>"></iframe>
		<cfelse>
			<h3>No Similar Results Found !</h3>
		</cfif>
	</cfif>

	<h2>Newest 20 Results</h2>
	<iframe allowtransparency="true" align="middle" scrolling="auto" frameborder="0" width="100%" height="650" src="sicitem_newest.cfm"></iframe>
	<cfabort>
</cfoutput>

</body>
</html>