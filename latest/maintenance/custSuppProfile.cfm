<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1,102,104,5,4,6,7,8,9,10,11,2,103,3,299">
<cfinclude template="/latest/words.cfm">
<cfinclude template="/latest/pageTitle/pageTitle.cfm">
<cfquery name="getGsetup" datasource="#dts#">
	SELECT ctycode
    FROM gsetup;
</cfquery>

<cfif url.target EQ "Supplier">
	<cfset targetTitle="Supplier">
	<cfset targetTable=target_apvend>
    <cfset formAction="supplierProcess.cfm?action=print&pageTitle=#targetTitle#">
    <cfset displayEditDelete=getUserPin2.H10102_3b>
    <cfset urlMenuID=url.menuID>
	<cfset targetWords="#words[104]#">
	<cfset pageTitle="#words[102]#">
<cfelseif url.target EQ "Customer">
	<cfset targetTitle="Customer">
	<cfset targetTable=target_arcust>
    <cfset formAction="customerProcess.cfm?action=print&pageTitle=#targetTitle#">
    <cfset displayEditDelete=getUserPin2.H10101_3b>
    <cfset urlMenuID=url.menuID>
	<cfset targetWords="#words[5]#">
	<cfset pageTitle="#words[1]#">
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
            var dts='#dts#';
            var target='#url.target#';
            var targetTitle='#targetTitle#';
            var targetTable='#targetTable#';
            var ctycode='#getGsetup.ctycode#';
			var display='#displayEditDelete#';
			var menuID='#urlMenuID#';
			var account="#words[4]#";
			var targerWords="#targetWords#";
			var address="#words[6]#";
			var contact="#words[7]#";
			var attention="#words[8]#";
			var currency="#words[9]#";
			var action="#words[10]#";
			var SEARCH="#words[11]#";

			<cfif IsDefined('url.message')>
				window.setTimeout(function() {
					$(".alert").fadeTo(500, 0).slideUp(500, function(){
						$(this).remove();
					});
				}, 3000);
			</cfif>
        </script>
    </cfoutput>
    <script type="text/javascript" src="/latest/js/maintenance/custSuppProfile.js"></script>
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
            	<cfif getUserPin2.H10101_3a EQ 'T' AND targetTitle EQ 'Customer'>
                    <button type="button" class="btn btn-default" onclick="window.open('/latest/maintenance/target.cfm?target=#url.target#&action=create&menuID=#url.menuID#','_self');">
                        <span class="glyphicon glyphicon-plus"></span> #words[2]#
                    </button>
                </cfif>
                <cfif getUserPin2.H10102_3a EQ 'T' AND targetTitle EQ 'Supplier'>
                    <button type="button" class="btn btn-default" onclick="window.open('/latest/maintenance/target.cfm?target=#url.target#&action=create&menuID=#url.menuID#','_self');">
                        <span class="glyphicon glyphicon-plus"></span> #words[103]#
                    </button>
                </cfif>
                <cfif getUserPin2.H10101_3c EQ 'T' AND targetTitle EQ 'Customer'>
                	<!---<cfif HUSERID EQ 'ultraprinesh'>--->
                    <button type="button" class="btn btn-default" onclick="window.open('../../../../default/maintenance/p_suppcust.cfm?type=Customer','_blank');">
                   <!--- <cfelse>
                    <button type="button" class="btn btn-default" onclick="window.open('/latest/maintenance/#formAction#','_blank');">
                    </cfif>--->
                        <span class="glyphicon glyphicon-print"></span> #words[3]#
                    </button>
                </cfif>
                <cfif getUserPin2.H10102_3c EQ 'T' AND targetTitle EQ 'Supplier'>
                    <button type="button" class="btn btn-default" onclick="window.open('../../../../default/maintenance/p_suppcust.cfm?type=Supplier','_blank');">
                        <span class="glyphicon glyphicon-print"></span> #words[3]#
                    </button>
                </cfif>
			</div>
		</h2>
	</div>
	<div class="container">
    	<cfif IsDefined('url.message')>
        	<div class="alert alert-danger alert-dismissable">
              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
              <strong>#url.custno# #words[299]#</strong>
            </div>
    	</cfif>
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