<html>
<head>
<title>Vehicle Profile</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfquery name="getgsetup" datasource="#dts#">
	select * from gsetup
</cfquery>

<h1>Vehicle Selection Page</h1>		
<h4>
	<cfif getpin2.h1310 eq 'T'>
		<a href="vehicles2.cfm?type=Create">Creating a Vehicle</a> 
	</cfif>
	<cfif getpin2.h1320 eq 'T'>
		|| <a href="vehicles.cfm">List all Vehicles</a> 
	</cfif>
	<cfif getpin2.h1330 eq 'T'>
		|| <a href="s_Vehicles.cfm">Search For Vehicles</a> 
	</cfif>
	<cfif getpin2.h1340 eq 'T'>
		|| <a href="p_Vehicles.cfm">Vehicles Listing</a> 
	</cfif>
</h4>

<cfoutput>
	<form action="s_vehicles.cfm" method="post">
		<h1>Search By :
		<select name="searchType">
			<cfoutput>
				<option value="entryno">Vehicle No</option>
				<option value="custcode">Customer No</option>
				<option value="make">Vehicle Make</option>
				<option value="model">Vehicle Model</option>
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
			select count(entryno) as totalsimilarrecord 
			from vehicles 
			where (#searchType# LIKE <cfif isdefined('form.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif>)
			order by #searchType#
            
		</cfquery>
		
		<cfif getrecordcount.totalsimilarrecord neq 0>
			<h2>Similar Results</h2>
			<iframe allowtransparency="true" align="middle" scrolling="auto" frameborder="0" width="100%" height="650" src="svehicles_similar.cfm?searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#<cfif isdefined('form.left')>&left=1</cfif>"></iframe>
		<cfelse>
			<h3>No Similar Results Found !</h3>
		</cfif>
	</cfif>

	<h2>Newest 20 Results</h2>
	<iframe allowtransparency="true" align="middle" scrolling="auto" frameborder="0" width="100%" height="650" src="svehicles_newest.cfm"></iframe>
	<cfabort>
</cfoutput>

</body>
</html>