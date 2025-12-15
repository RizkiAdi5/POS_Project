<cfif url.target EQ "type1">
	<cfset pageTitle="View Login History">
	<cfset formAction="report1.cfm">
  
<cfelseif url.target EQ "type2">
	<cfset pageTitle="Log In and Out Report">
	<cfset formAction="report2.cfm">
                           
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>#pageTitle#</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link rel="stylesheet" href="/latest/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
    <script type="text/javascript" src="/latest/js/jqueryui/jquery-ui-1.10.3.custom.min.js"></script>
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>

	<cfinclude template="/latest/filter/filterUser.cfm">
	<cfinclude template="/latest/date/datePickerFunction.cfm"> 
    <cfinclude template="/CFC/LastDayOfMonth.cfm">

</head>

<body class="container">
<cfoutput>
	<cfform class="formContainer form3Button" name="logInOutForm" id="logInOutForm" action="#formAction#" method="post" target="_blank">
        <div>#pageTitle#</div>
        <div>
        <table> 
        	<cfif url.target EQ 'type2'>
                <tr>
                <th><label for="">User</label></th>			
                    <td>
                        <input type="hidden" id="userFrom" name="userFrom" class="userFilter" data-placeholder="[FROM] -- Choose a User" />
                        <input type="hidden" id="userTo" name="userTo" class="userFilter" data-placeholder="[TO] -- Choose a User" />
                    </td>
                </tr>
			</cfif>
            <tr> 
                <th><label for="date">Date</label></th>			
                <td>
					<input type="Text" name="dateFrom" id="dateFrom" maxlength="10" size="10" placeholder="[FROM] -- Choose a Date" readonly="readonly" />
					<input type="Text" name="dateTo" id="dateTo" maxlength="10" size="10" placeholder="[TO] -- Choose a Date" readonly="readonly" />
                </td>
			</tr>
           
        </table>
        </div>
        <div>
            <input type="Submit" name="Submit" id="Submit" value="SUBMIT">
        </div>
    </cfform>
</cfoutput>
</body>
</html>