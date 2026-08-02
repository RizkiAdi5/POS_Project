<cfprocessingdirective pageencoding="UTF-8">
<cfset pageTitle="Kitchen Profile">
<cfset targetTitle="Kitchen">
<cfset targetTable="kitchen">
<!--- Always allow add/edit/delete for admin & super; fall back to cashier pin column if available --->
<cfif isDefined("getuserpin2.H10412_3b")>
    <cfset displayEditDelete = getuserpin2.H10412_3b>
<cfelse>
    <cfset displayEditDelete = "T">
</cfif>
<cfif isDefined("getuserpin2.H10412_3a")>
    <cfset displayAdd = getuserpin2.H10412_3a>
<cfelse>
    <cfset displayAdd = "T">
</cfif>
<cfif isDefined("getuserpin2.H10412_3c")>
    <cfset displayPrint = getuserpin2.H10412_3c>
<cfelse>
    <cfset displayPrint = "T">
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/latest/css/dataTables/dataTables_bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="/latest/css/maintenance/profile.css" />
    <!--[if lt IE 9]>
        <script type="text/javascript" src="/latest/js/html5shiv/html5shiv.js"></script>
        <script type="text/javascript" src="/latest/js/respond/respond.min.js"></script>
    <![endif]-->

    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
    <script type="text/javascript" src="/latest/js/dataTables/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="/latest/js/dataTables/dataTables_bootstrap.js"></script>

    <cfoutput>
    <script type="text/javascript">
        var dts         = '#dts#';
        var display     = '#displayEditDelete#';
        var targetTitle = '#targetTitle#';
        var targetTable = '#targetTable#';
    </script>
    </cfoutput>
    <script type="text/javascript" src="/latest/js/maintenance/kitchenProfile.js"></script>

</head>

<body>
<cfoutput>
<div class="container">
    <div class="page-header">
        <h2>
            #pageTitle#
            <span class="glyphicon glyphicon-question-sign btn-link"></span>

            <div class="pull-right">
                <cfif displayAdd EQ "T">
                    <button type="button" class="btn btn-default"
                            onclick="window.open('/latest/maintenance/kitchen.cfm?action=create','_self');">
                        <span class="glyphicon glyphicon-plus"></span> Add Kitchen Staff
                    </button>
                </cfif>
                <cfif displayPrint EQ "T">
                    <button type="button" class="btn btn-default"
                            onclick="window.open('/latest/maintenance/kitchenProcess.cfm?action=print','_blank');">
                        <span class="glyphicon glyphicon-print"></span> Print
                    </button>
                </cfif>
            </div>
        </h2>
    </div>
    <div class="container">
        <table class="table table-bordered table-hover" id="resultTable" style="table-layout:fixed">
            <thead></thead>
            <tbody></tbody>
        </table>
    </div>
</div>
</cfoutput>
</body>
</html>
