<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "11">
<cfinclude template="/latest/words.cfm">
<cfinclude template="/latest/pageTitle/pageTitle.cfm">
<cfset pageTitle = "Raw Material Consumption Summary">

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
        var dts='#dts#';
        var menuID='#url.menuID#';
        var materialLabel='Raw Material';
        var usedLabel='Total Used (selected period)';
        var stockLabel='Current Stock';
        var SEARCH='#words[11]#';
    </script>
    </cfoutput>
    <script type="text/javascript" src="/latest/js/maintenance/materialConsumptionSummary.js"></script>

</head>

<body>
<cfoutput>
<div class="container">
	<div class="page-header">
		<h2>#pageTitle#</h2>
		<p class="text-muted">Total raw material consumed, summed across every order in the selected period.</p>
	</div>
	<div class="container">
		<div style="margin-bottom:12px;">
			<label for="rangeSelect" style="font-weight:bold;margin-right:8px;">Period:</label>
			<select id="rangeSelect" class="form-control" style="width:220px;display:inline-block;">
				<option value="today">Today</option>
				<option value="week">Last 7 Days</option>
				<option value="month">Last 30 Days</option>
				<option value="all" selected>All Time</option>
			</select>
		</div>
		<table class="table table-bordered table-hover" id="resultTable" style="table-layout:fixed">
			<thead>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</div>
</cfoutput>
</body>
</html>
