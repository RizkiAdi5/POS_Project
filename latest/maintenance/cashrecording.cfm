<cfif IsDefined('url.cashierID')>
	<cfset URLID = trim(urldecode(url.ID))>
</cfif>


<cfif IsDefined("url.action")>
	<cfquery name="getcounter" datasource="#dts#">
    select * from counter
    </cfquery>
	
	<cfif url.action EQ "create">
		<cfset pageTitle="Create Cash Recording Profile">
		<cfset pageAction="Create">
		<cfset counter=''>
		<cfset wos_date=dateformat(now(),'DD/MM/YYYY')>
        <cfset type=''>
        <cfset desp=''>
        <cfset amount=0>
        <cfset openingid=''>
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Cash Recording Profile">
		<cfset pageAction="Update">
		<cfquery name="getdailyopening" datasource="#dts#">
        select * from dailycounter where id='#url.id#'
        </cfquery>
		
		<cfset counter=getdailyopening.counterid>
		<cfset wos_date=dateformat(getdailyopening.wos_date,'DD/MM/YYYY')>
        <cfset type=getdailyopening.type>
        <cfset amount=getdailyopening.openning>
        <cfset desp=getdailyopening.desp>
        <cfset openingid=url.id>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Cashier Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getdailyopening" datasource="#dts#">
        select * from dailycounter where id='#url.id#'
        </cfquery>
		
		<cfset counter=getdailyopening.counterid>
		<cfset wos_date=dateformat(getdailyopening.wos_date,'DD/MM/YYYY')>
        <cfset type=getdailyopening.type>
        <cfset amount=getdailyopening.openning>
        <cfset desp=getdailyopening.desp>
        <cfset openingid=url.id>
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
    <form class="formContainer form2Button" action="/latest/maintenance/cashrecordingProcess.cfm?action=#url.action#" method="post">
        <div>#pageTitle#</div>
        <div>
            <table>
                <tr><input type="hidden" name="openingid" id="openingid" value="#openingid#">
                    <th><label for="Counter">Counter</label></th>
                    <td>
                       <select name="counter" id="counter" required="yes" message="Please select a counter">
                        <option value="">Choose a counter</option>
                        <cfloop query="getcounter">
                         <option value="#getcounter.counterid#" <cfif counter eq getcounter.counterid>selected</cfif>>#getcounter.counterid# - #getcounter.counterdesp#</option>
                        </cfloop>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><label for="Description">Description</label></th>
                    <td>
                        <input type="text" name="desp" id="desp" value="#desp#">           
                    </td>
                </tr> 
                <tr>
                    <th><label for="Date">Date</label></th>
                    <td>
                       <input type="text" name="wos_date" id="wos_date"  value="#dateformat(now(),'DD/MM/YYYY')#" required="yes" message="Date is Required">&nbsp;<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('wos_date'));">   
                    </td>
                </tr> 
                <tr>
                    <th><label for="Type">Type</label></th>
                    <td>
                        <select name="type">
                        <option value="opening" <cfif type eq 'opening'>selected</cfif>>Opening</option>
                        <option value="cashin" <cfif type eq 'cashin'>selected</cfif>>Cash In</option>
                        <option value="cashout" <cfif type eq 'cashout'>selected</cfif>>Cash Out</option>
                        </select>
                    </td>
                </tr> 
                <tr>
                    <th><label for="Amount">Amount</label></th>
                    <td>
                       <input type="text" name="amount" required="yes" message="Amount is Required" value="#amount#">
                    </td>
                </tr> 
            </table>
        </div>
        <div>
            <input type="submit" value="#pageAction#" />
            <input type="button" value="Cancel" onclick="window.location='/latest/maintenance/cashierProfile.cfm'" />
        </div>
    </form>
</cfoutput>
</body>
</html>