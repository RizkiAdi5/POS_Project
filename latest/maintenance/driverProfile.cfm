<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "3, 11, 1499, 23, 16, 10">
<cfinclude template="/latest/words.cfm">

<cfquery name="getgsetup" datasource="#dts#">
	select * from gsetup
</cfquery>

<cfset pageTitle="End User Profile">
<cfset targetTitle="#getgsetup.ldriver#">
<cfset targetTable="driver">
<cfset displayEditDelete=getUserPin2.H10319a_3b>

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
		var SEARCH = '#words[11]#';
		var driverno = '#words[1499]#';
		var name = '#words[23]#';
		var customerno = '#words[16]#';
		var action = '#words[10]#';
    </script>
    </cfoutput>
    
    <script type="text/javascript" src="/latest/js/maintenance/driverProfile.js"></script>

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
				<cfif getUserPin2.H10319a_3a EQ 'T'>
                    <button type="button" class="btn btn-default" onclick="window.open('/latest/maintenance/driver.cfm?action=create','_self');">
                        <span class="glyphicon glyphicon-plus"></span> Add #words[1499]#
                    </button>
                </cfif>
                <cfif getUserPin2.H10319a_3a EQ 'T'>
                    <button type="button" class="btn btn-default" onclick="window.open('/latest/maintenance/driverProcess.cfm?action=print','_blank');">
                        <span class="glyphicon glyphicon-print"></span> #words[3]#
                    </button>
                    
                    <button type="button" class="btn btn-default" onclick="window.open('/latest/maintenance/driverexcel.cfm','_blank');">
                        <span class="glyphicon glyphicon-print"></span> #words[3]# Excel
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