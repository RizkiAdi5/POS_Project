<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "573,95,574,98,571,23,572,96">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.cashierID')>
	<cfset URLcashierID = trim(urldecode(url.cashierID))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[573]#">
		<cfset pageAction="#words[95]#">
		<cfset cashierID = "">
        <cfset name = "">
        <cfset password = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[574]#">
		<cfset pageAction="#words[98]#">
		<cfquery name="getCashier" datasource='#dts#'>
            SELECT * 
            FROM cashier 
            WHERE cashierID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcashierID#">;
		</cfquery>
		
		<cfset cashierID = getCashier.cashierID>
        <cfset name = getCashier.name>
        <cfset password = getCashier.password>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Cashier Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getCashier" datasource='#dts#'>
            SELECT * 
            FROM cashier 
            WHERE cashierID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcashierID#">;
		</cfquery>
		
		<cfset cashierID = getCashier.cashierID>
        <cfset name = getCashier.name>  
        <cfset password = getCashier.password>   
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
</head>

<body class="container">
<cfoutput>
    <form class="formContainer form2Button" action="/latest/maintenance/cashierProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('cashierID').disabled=false";>
        <div>#pageTitle#</div>
        <div>
            <table>
                <tr>
                    <th><label for="cashierID">#words[571]#</label></th>
                    <td>
                        <input type="text" id="cashierID" name="cashierID" required="required" maxlength="25"
                            <cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLcashierID#"  disabled="true"</cfif>/>
                    </td>
                </tr>
                <tr>
                    <th><label for="name">#words[23]#</label></th>
                    <td>
                        <input type="text" id="name" name="name" value="#name#" />                   
                    </td>
                </tr> 
                <tr>
                    <th><label for="password">#words[572]#</label></th>
                    <td>
                        <input type="password" id="password" name="password" value="#password#" />                   
                    </td>
                </tr> 
            </table>
        </div>
        <div>
            <input type="submit" value="#pageAction#" />
            <input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/cashierProfile.cfm'" />
        </div>
    </form>
</cfoutput>
</body>
</html>