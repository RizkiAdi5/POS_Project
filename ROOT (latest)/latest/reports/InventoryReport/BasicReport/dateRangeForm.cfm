<cfset consignment=''>
<cfif url.target EQ "type1">
	<cfset pageTitle = "Item Status and Value">
<cfelseif url.target EQ "type2">
	<cfset pageTitle = "Group Status and Value">
<cfelseif url.target EQ "type3">
	<cfset pageTitle = "Category Status and Value">
</cfif>

<cfquery name="getGsetup" datasource="#dts#">
	SELECT lastaccyear 
    FROM gsetup;
</cfquery>

<cfquery name="getICITEM" datasource="#dts#">
	SELECT LastAccDate,ThisAccDate 
    FROM icitem_last_year 
    GROUP BY LastAccDate,ThisAccDate 
    ORDER BY LastAccDate DESC;
</cfquery>

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
</head>

<body class="container">
<cfoutput>
	<cfform class="formContainer form2Button" name="dateRangeForm" id="dateRangeForm" action="stockValueForm.cfm?target=#url.target#&pageTitle=#pageTitle#" method="post" target="_self">
        <div>#pageTitle#</div>
        <div>
        <table> 
            <tr> 
                <th><label for="period">Date Range</label></th>			
                <td>
                	<select name="dateRange">
                    	<option value="#getGsetup.lastaccyear#">#DateFormat(getGsetup.lastaccyear,"dd/mm/yyy")# - #DateFormat(NOW(),"dd/mm/yyy")#</option>
                        <cfloop query="getICITEM">
                        	<option value="#getICITEM.LastAccDate#">#DateFormat(getICITEM.LastAccDate,"dd/mm/yyy")# - #DateFormat(getICITEM.ThisAccDate,"dd/mm/yyy")#</option>
                        </cfloop>
                    </select>
                </td>
            </tr> 
        </table>
        </div>
        <input type="hidden" name="title" id="title" value="#pageTitle#" /> 
        <div>
            <input type="Submit" name="submit" id="submit" value="Submit"  />
        </div>
    </cfform>
</cfoutput>
</body>
</html>