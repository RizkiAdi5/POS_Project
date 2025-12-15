<cfset pageTitle="Generate Cost">
<cfset pageAction="Generate">

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
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
    <cfinclude template="/latest/filter/filterItem.cfm">
</head>

<body class="container">
<cfoutput>
    <form class="formContainer form2Button" action="/latest/maintenance/bomCostProcess.cfm" method="post">
        <div>#pageTitle#</div>
        <div>
            <table>
                <tr> 
                    <th><label for="item">Item</label></th>			
                    <td>
                        <input type="hidden" id="itemFrom" name="itemFrom" class="itemFilter" data-placeholder="[FROM] -- Choose an Item" />
                        <input type="hidden" id="itemTo" name="itemTo" class="itemFilter" data-placeholder="[TO] -- Choose an Item" />
                    </td>
                </tr>
                <tr>
                    <th><label for="bom">BOM No</label></th>
                    <td>
                        <input type="text" id="bomNo" name="bomNo"/>
                    </td>
                </tr>
                <tr>
                    <th><label for="updateBomCost">Update Bom Cost</label></th>
                    <td>
                        <input type="checkbox" name="update_cost" value="Y">
                    </td>
                </tr>
                <tr>
                    <th><label for="movingAverage">According to Moving Average</label></th>
                    <td>
                        <input type="checkbox" name="movingavrg" value="">
                    </td>
                </tr>
            </table>
        </div>
        <div>
            <input type="submit" value="#pageAction#" />
            <input type="button" value="Cancel" onclick="window.location='/latest/maintenance/bomProfile.cfm'"/>
        </div>
    </form>
</cfoutput>
</body>
</html>