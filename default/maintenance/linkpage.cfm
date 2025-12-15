<html>
<head>
<title>Create Or Edit Or View</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfset target_table = iif(url.type eq "customer",DE(target_arcust),DE(target_apvend))>
<cfset link = url.type &".cfm">

<cfif husergrpid eq "Muser">
	<a href="../home2.cfm"><u>Home</u></a>
</cfif>

<cfoutput>
	<cfif isdefined("URL.Type")>
		<h1>#URL.Type# Selection Page</h1>
		<cfif url.type eq "Customer">
			<h4>
			<cfif getpin2.h1210 eq 'T'><a href="#link#?type=Create"> Creating a New #type#</a> </cfif><cfif getpin2.h1220 eq 'T'>|| 
				<a href="vPersonnel.cfm?type=#url.type#">List all #type#</a> </cfif><cfif getpin2.h1230 eq 'T'>|| 
				<a href="linkPage.cfm?type=#url.type#">Search #type#</a> </cfif><cfif getpin2.h1240 eq 'T'>|| 
				<a href="p_suppcust.cfm?type=#url.type#">#type# Listing</a></cfif>
				|| <a href="printlabel.cfm?type=Customer">Print Customer Labels</a>				
				</h4>
			<cfelse>
				<h4>
				<cfif getpin2.h1110 eq 'T'><a href="#link#?type=Create"> Creating a New #type#</a> </cfif><cfif getpin2.h1120 eq 'T'>|| 
				<a href="vPersonnel.cfm?type=#url.type#">List all #type#</a> </cfif><cfif getpin2.h1130 eq 'T'>|| 
				<a href="linkPage.cfm?type=#url.type#">Search #type#</a> </cfif><cfif getpin2.h1140 eq 'T'>|| 
				<a href="p_suppcust.cfm?type=#url.type#">#type# Listing</a></cfif>
				|| <a href="printlabel.cfm?type=Supplier">Print Supplier Labels</a>
				</h4>			
			</cfif>

			<form action="linkPage.cfm?type=#URL.Type#" method="post">
			<h1>Search By :
            <cfif #URL.Type# eq 'Customer'>
            <cfquery name="getcustlist" datasource="#dts#">
            select ddlcust from gsetup
            </cfquery>
            <select name="searchType">
                <cfif hcomid eq "kimlee_i" or lcase(HcomID) eq "bakersoven_i">
                <option value="name" <cfif lcase(hcomid) eq "mhca_i" or lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">selected</cfif>>#URL.Type# Name</option>	
                <option value="custno">#URL.Type# ID</option>
					<cfelse>
					<option value="custno" <cfif getcustlist.ddlcust eq 'Customer ID'>selected</cfif>>#URL.Type# ID</option>
					<option value="name" <cfif getcustlist.ddlcust eq 'Customer Name'>selected</cfif>>#URL.Type# Name</option>	
				<!--- Remark on 250708 --->
				<!--- <option value="custno">#URL.Type# ID</option>
				<option value="name">#URL.Type# Name</option> --->				
				<option value="agent" <cfif getcustlist.ddlcust eq 'Agent'>selected</cfif>>Agent</option>
				<option value="phone" <cfif getcustlist.ddlcust eq 'Customer Tel'>selected</cfif>>#URL.Type# Tel</option></cfif>
				<cfif hcomid eq "tmt_i" or lcase(HcomID) eq "taff_i" or lcase(HcomID) eq "taftc_i">
					<option value="attn"><cfif lcase(HcomID) eq "taftc_i">Attn.<cfelse>IC.No.</cfif></option>
					<option value="phonea">Mobile No</option>
				</cfif>
                <option value="phonea">Phone 2</option>
                <option value="fax">Fax</option>
                <option value="allphone">Phone All</option>
                <option value="add2">Address 2</option>
			</select>
            <cfelse>
            <cfquery name="getcustlist" datasource="#dts#">
            select ddlsupp from gsetup
            </cfquery>
			<select name="searchType"><!--- 
				<cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
					<option value="name">#URL.Type# Name</option>
					<option value="custno">#URL.Type# ID</option>
				<cfelse> --->
                <cfif hcomid eq "kimlee_i" or lcase(HcomID) eq "bakersoven_i">
                <option value="name" <cfif lcase(hcomid) eq "mhca_i" or lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">selected</cfif>>#URL.Type# Name</option>	
                <option value="custno">#URL.Type# ID</option>
					<cfelse>
					<option value="custno" <cfif getcustlist.ddlsupp eq 'Supplier ID'>selected</cfif>>#URL.Type# ID</option>
					<option value="name" <cfif getcustlist.ddlsupp eq 'Supplier Name'>selected</cfif>>#URL.Type# Name</option>	</cfif>
				<!--- </cfif> --->
				<!--- Remark on 250708 --->
				<!--- <option value="custno">#URL.Type# ID</option>
				<option value="name">#URL.Type# Name</option> --->				
				<option value="agent" <cfif getcustlist.ddlsupp eq 'Agent'>selected</cfif>>Agent</option>
				<option value="phone" <cfif getcustlist.ddlsupp eq 'Supplier Tel'>selected</cfif>>#URL.Type# Tel</option>
				<cfif hcomid eq "tmt_i" or lcase(HcomID) eq "taff_i" or lcase(HcomID) eq "taftc_i">
					<option value="attn">IC.No.</option>
					<option value="phonea">Mobile No</option>
				</cfif>
                <option value="phonea">Phone 2</option>
                <option value="fax">Fax</option>
                <option value="allphone">Phone All</option>
                <option value="area">Area</option>
			</select>
            </cfif>
            <input type="checkbox" name="left" id="left" value="1" />
			Search for #URL.Type# : 
			<input type="text" name="searchStr" value=""> 

				<input type="submit" name="submit" value="Search">

			</h1>
			</form>
		<cfif isdefined("form.searchStr")>
			<!--- <cfquery name="getrecordcount" datasource="#dts#">
				select count(custno) as totalsimilarrecord 
				from #target_table# 
				where #form.searchType# like binary('#form.searchStr#')
				<cfif url.type eq "Customer" and getpin2.h1250 eq 'T'>
				and agent = '#huserid#'
				</cfif>
			</cfquery> --->
			<cfquery name="getrecordcount" datasource="#dts#">
				select count(custno) as totalsimilarrecord 
				from #target_table# 
				where 
                <cfif searchType eq 'allphone'>
                (phone like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                phonea like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                fax like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                phonea like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                dphone like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                dfax like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                contact like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%">)
                
                <cfelse>
                #form.searchType# like <cfif isdefined('form.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif></cfif>
				<cfif url.type eq "Customer" and getpin2.h1250 eq 'T'>
					and agent = '#huserid#'
				</cfif>
			</cfquery>
		
			<cfif getrecordcount.totalsimilarrecord neq 0>
				<h2>Similar Results</h2>
				<iframe align="middle" scrolling="auto" frameborder="0" width="100%" height="650" src="scustsupp_similar.cfm?type=#urlencodedformat(url.type)#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#<cfif isdefined('form.left')>&left=1</cfif>"></iframe>
			<cfelse>
				<h3>No Similar Results Found !</h3>
			</cfif>
		</cfif>
		
		<h2>Newest 20 Results</h2>
		<iframe align="middle" scrolling="auto" frameborder="0" width="100%" height="650" src="scustsupp_newest.cfm?type=#urlencodedformat(url.type)#"></iframe>
	<cfelse>
		<h1>URL Error. Please Click On The Correct Link.</h1>
	</cfif>
</cfoutput>
</body>
</html>