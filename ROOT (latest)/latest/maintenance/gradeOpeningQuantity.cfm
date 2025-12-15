<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Grade Opening Quantity</title>
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
    
	<cfinclude template="filterItem.cfm">
    <cfinclude template="filterCategory.cfm">
    <cfinclude template="filterGroup.cfm">
    <cfinclude template="filterLocation.cfm">
</head>

<body class="container">
<cfoutput>
	<cfform class="formContainer form3Button" name="gradeOpeningQuantity" id="gradeOpeningQuantity" action="/default/maintenance/openqtymaintenance/grade_opening_qty_maintenance.cfm" method="post" target="_blank">
        <div>Grade Opening Quantity</div>
        <div>
        <table> 
            <tr> 
                <th><label for="item">Item</label></th>			
                <td>
                    <input type="hidden" id="nofrom" name="nofrom" class="itemNo" data-placeholder="[FROM] -- Choose an Item" />
                    <input type="hidden" id="noto" name="noto" class="itemNo" data-placeholder="[TO] -- Choose an Item" />
                </td>
            </tr>
            <tr> 
                <th><label for="category">Category</label></th>			
                <td>
                    <input type="hidden" id="categoryFrom" name="categoryFrom" class="category" data-placeholder="[FROM] -- Choose a Category" />
                    <input type="hidden" id="categoryTo" name="categoryTo" class="category" data-placeholder="[TO] -- Choose a Category" />
                </td>
            </tr>
            <tr> 
                <th><label for="group">Group</label></th>			
                <td>
                    <input type="hidden" id="groupFrom" name="groupFrom" class="wosGroup" data-placeholder="[FROM] -- Choose a Group" />
                    <input type="hidden" id="groupTo" name="groupTo" class="wosGroup" data-placeholder="[TO] -- Choose a Group" />
                </td>
            </tr>
            <tr> 
                <th><label for="location">Location</label></th>			
                <td>
                    <input type="hidden" id="locationFrom" name="locationFrom" class="location" data-placeholder="[FROM] -- Choose a Location" />
                    <input type="hidden" id="locationTo" name="locationTo" class="location" data-placeholder="[TO] -- Choose a Location" />
                </td>
            </tr>
        </table>
        </div>
        <div>
            <input type="Submit" name="Submit" value="HTML">
        </div>
    </cfform>
</cfoutput>
</body>
</html>
<!---
<cfset headertype = url.type>
<cfinclude template="/object/searchdebcrd/search.cfm">
--->