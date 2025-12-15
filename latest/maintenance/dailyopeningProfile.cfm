<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "2145,2146,585,65,10,11,2147,702,877,1116,3">
<cfinclude template="/latest/words.cfm">

<cfset pageTitle="#words[2145]#">
<cfset targetTitle="#words[2146]#">
<cfset targetTable="dailycounter">
<cfset displayEditDelete=getUserPin2.H10412_3b>

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
		var display='#displayEditDelete#';
        var targetTitle='#targetTitle#';
        var targetTable='#targetTable#';
        var counter='#words[585]#';
        var description='#words[65]#';
        var action='#words[10]#';
        var SEARCH='#words[11]#';
        var opening='#words[2147]#';
        var date='#words[702]#';
        var type='#words[877]#';
    </script>
    </cfoutput>
    <script type="text/javascript" src="/latest/js/maintenance/dailyopeningProfile.js"></script>

</head>

<body>
<cfoutput>
<div class="container">
	<div class="page-header">
		<h2>
			#pageTitle#
			<span class="glyphicon glyphicon-question-sign btn-link"></span>
			<span class="glyphicon glyphicon-facetime-video btn-link"></span>

			<div class="pull-right">
            	<cfif getUserPin2.H10412_3a EQ 'T'>
                	<button type="button" class="btn btn-default" onclick="window.open('/latest/maintenance/dailyopening.cfm?action=create','_self');">
                    	<span class="glyphicon glyphicon-plus"></span> #words[1116]# #targetTitle#
                	</button>
            	</cfif>
                <cfif getUserPin2.H10412_3c EQ 'T'>
                	<button type="button" class="btn btn-default" onclick="window.open('/latest/maintenance/dailyopeningProcess.cfm?action=print','_blank');">
                    	<span class="glyphicon glyphicon-print"></span> #words[3]#
                	</button>
                </cfif>
			</div>
		</h2>
	</div>
	<div class="container">
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