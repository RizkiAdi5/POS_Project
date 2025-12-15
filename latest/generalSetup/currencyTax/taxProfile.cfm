<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1894, 1099, 10, 1899, 56, 65, 1900, 877, 1901, 1895, 1896, 3, 1272, 1897, 187, 1898, 11">
<cfinclude template="/latest/words.cfm">

<cfset pageTitle="#words[1894]#">
<cfset targetTitle="#words[1099]#">
<cfset targetTable="#target_taxtable#">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/latest/css/dataTables/dataTables_bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="/latest/css/general/taxprofile.css" />
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
        var targetTitle='#targetTitle#';
        var targetTable='#targetTable#';
		var SEARCH = '#words[11]#';
		var action = '#words[10]#';
		var entrycode = '#words[1899]#';
		var taxcode = '#words[56]#';
		var description = '#words[65]#';
		var rate = '#words[1900]#';
		var type = '#words[877]#';
		var correspondentacc = '#words[1901]#';
    </script>
    </cfoutput>
    <script type="text/javascript" src="/latest/js/generalSetup/currencyTax/taxProfile.js"></script>

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
			<button type="button" class="btn btn-default" onclick="window.open('/latest/generalSetup/currencyTax/tax.cfm?action=create','_self');">
				<span class="glyphicon glyphicon-plus"></span> #words[1895]#
			</button>
            <button type="button" class="btn btn-default" onclick="window.open('/latest/generalSetup/currencyTax/taxauto.cfm','_self');">
				<span class="glyphicon glyphicon-flash"></span> #words[1896]#
			</button>            
			<button type="button" class="btn btn-default" onclick="window.open('/latest/generalSetup/currencyTax/taxProcess.cfm?action=print','_blank');">
				<span class="glyphicon glyphicon-print"></span> #words[3]#
			</button>
			</div>
		</h2>
	</div>
    <ul class="nav nav-tabs">
		<li id="allNav" class="active"><a id="allButton" class="navButton">#words[1272]#</a></li>
		<li id="generalNav"><a id="generalButton" class="navButton">#words[1897]#</a></li>
		<li id="purchaseNav"><a id="purchaseButton" class="navButton">#words[187]#</a></li>
		<li id="salesNav"><a id="salesButton" class="navButton">#words[1898]#</a></li>
	</ul>
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