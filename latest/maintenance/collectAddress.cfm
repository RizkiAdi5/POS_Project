<cfif IsDefined('url.code')>
	<cfset URLaddress = trim(urldecode(url.code))>
</cfif>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create Address Profile">
		<cfset pageAction="Create">
		<cfset code = "">
        <cfset name = "">
        <cfset customerNo = "">
        <cfset add1 = "">
        <cfset add2 = "">
        <cfset add3 = "">
        <cfset add4 = "">
        <cfset country = "">
        <cfset postalCode = "">
        <cfset attention = "">
        <cfset telephone = "">
        <cfset fax = "">
        <cfset phone2 = "">
        <cfset email = ""> 
        
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Address Profile">
		<cfset pageAction="Update">
		<cfquery name="getCollectAddress" datasource='#dts#'>
            SELECT * 
            FROM collect_address 
            WHERE code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLaddress#">;
		</cfquery>
		
		<cfset code = getCollectAddress.code>
        <cfset name = getCollectAddress.name>
        <cfset customerNo = getCollectAddress.custno>
        <cfset add1 = getCollectAddress.add1>
        <cfset add2 = getCollectAddress.add2>
        <cfset add3 = getCollectAddress.add3>
        <cfset add4 = getCollectAddress.add4>
        <cfset country = getCollectAddress.country>
        <cfset postalCode = getCollectAddress.postalcode>
        <cfset attention = getCollectAddress.attn>
        <cfset telephone = getCollectAddress.phone>
        <cfset fax = getCollectAddress.fax>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Address Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getCollectAddress" datasource='#dts#'>
            SELECT * 
            FROM collect_address 
            WHERE code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLaddress#">;
		</cfquery>
		
		<cfset code = getCollectAddress.code>
        <cfset name = getCollectAddress.name>
        <cfset customerNo = getCollectAddress.custno>
        <cfset add1 = getCollectAddress.add1>
        <cfset add2 = getCollectAddress.add2>
        <cfset add3 = getCollectAddress.add3>
        <cfset add4 = getCollectAddress.add4>
        <cfset country = getCollectAddress.country>
        <cfset postalCode = getCollectAddress.postalcode>
        <cfset attention = getCollectAddress.attn>
        <cfset telephone = getCollectAddress.phone>
        <cfset fax = getCollectAddress.fax>    
	</cfif>
    
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
    
	<cfinclude template="filterCustomer.cfm">
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
</head>

<body class="container">
<cfoutput>
<form class="formContainer form2Button" action="/latest/maintenance/collectAddressProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('code').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="code">Code</label></th>
				<td>
                	<input type="text" id="code" name="code" required="required" maxlength="25"
                    	<cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLaddress#"  disabled="true"</cfif>/>
                </td>
			</tr>
			<tr>
				<th><label for="name">Name</label></th>
				<td>
                	<input type="text" id="name" name="name" value="#name#" />                   
                </td>
			</tr>
            <tr>
				<th><label for="customerNo">Customer No</label></th>
				<td>
                	<input type="hidden" id="customerNo" name="customerNo" class="customerNo" data-placeholder="#customerNo#" />	                   
                </td>
			</tr>
            <tr>
				<th><label for="add1">Address</label></th>
				<td>
                	<input type="text" id="add1" name="add1" value="#add1#" />                   
                </td>
			</tr>
            <tr>
				<th></th>
				<td>
                	<input type="text" id="add2" name="add2" value="#add2#" />                   
                </td>
			</tr>
            <tr>
				<th></th>
				<td>
                	<input type="text" id="add3" name="add3" value="#add3#" />                   
                </td>
			</tr>
            <tr>
				<th></th>
				<td>
                	<input type="text" id="add4" name="add4" value="#add4#" />                   
                </td>
			</tr> 
            <tr>
				<th><label for="country">Country</label></th>
				<td>
                	<input type="text" id="country" name="country" value="#country#" />                   
                </td>
			</tr>
            <tr>
				<th><label for="postalCode">Postal Code</label></th>
				<td>
                	<input type="text" id="postalCode" name="postalCode" value="#postalCode#" />                   
                </td>
			</tr>
            <tr>
				<th><label for="attention">Attention</label></th>
				<td>
                	<input type="text" id="attention" name="attention" value="#attention#" />                   
                </td>
			</tr>
            <tr>
				<th><label for="telephone">Telephone</label></th>
				<td>
                	<input type="text" id="telephone" name="telephone" value="#telephone#" />                   
                </td>
			</tr>	
            <tr>
				<th><label for="fax">Fax</label></th>
				<td>
                	<input type="text" id="fax" name="fax" value="#fax#" />                   
                </td>
			</tr>	
    	</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/collectAddressProfile.cfm'" />
	</div>
</form>
</cfoutput>
</body>
</html>