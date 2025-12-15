<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "116,120,121,65,122,123,10,11,117,118,119,3,299,1096">
<cfinclude template="/latest/words.cfm">
<cfinclude template="/latest/pageTitle/pageTitle.cfm">
<cfset targetTitle="Product">
<cfset targetTable="icitem">
<cfset pageTitle="#words[116]#">
<cfset displayEditDelete=getUserPin2.H10103_3b>

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
		var hitemgroup='#hitemgroup#';
        var targetTitle='#targetTitle#';
        var targetTable='#targetTable#';
		var display='#displayEditDelete#';
		var menuID='#url.menuID#';
		var itemno='#words[120]#';
		var productcode='#words[121]#';
		var description='#words[65]#';
		var brand='#words[122]#';
		var category='#words[123]#';
		var action='#words[10]#';
		var SEARCH='#words[11]#';
		var price='#words[1096]#';

		<cfif IsDefined('url.message')>
			window.setTimeout(function() {
				$(".alert").fadeTo(500, 0).slideUp(500, function(){
					$(this).remove();
				});
			}, 3000);
		</cfif>
    </script>
    </cfoutput>
    <script type="text/javascript" src="/latest/js/maintenance/productProfile.js"></script>

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
            	<cfif getUserPin2.H10103_3a EQ 'T'>
                    <button type="button" class="btn btn-default" onclick="window.open('/latest/maintenance/product.cfm?action=create&menuID=#url.menuID#','_self');">
                        <span class="glyphicon glyphicon-plus"></span> #words[117]#
                    </button>
                </cfif>
                <button type="button" class="btn btn-default" onclick="window.open('/../../../default/maintenance/icitem_setting.cfm','_self');">
                	#words[118]#
                </button>

                <!---
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                     <span class="glyphicon glyphicon-wrench"></span>
                      More Settings
						<span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu">
						<li><a href="customerItemProfile.cfm" id="customerItem" style="cursor:pointer;">Customer/Item Price</a></li>
                        <li><a href="supplierItemProfile.cfm" id="supplierItem" style="cursor:pointer;">Supplier/Item Price</a></li>
                        <li><a href="itemCustomerProfile.cfm" id="itemCustomer" style="cursor:pointer;">Item/Customer Price</a></li>
                    	<li><a href="itemSupplierProfile.cfm" id="itemSupplier" style="cursor:pointer;">Item/Supplier Price</a></li>
                    </ul>
				</div>
				--->
                <cfif getUserPin2.H10103_3d EQ 'T'>
                    <button type="button" class="btn btn-default" onclick="window.open('../../../../default/maintenance/printbarcode_filter.cfm','_self');">
                        <span class="glyphicon glyphicon-print"></span> #words[119]#
                    </button>
                </cfif>
                <cfif getUserPin2.H10103_3c EQ 'T'>
                    <button type="button" class="btn btn-default" onclick="window.open('../../../../default/maintenance/p_icitem.cfm','_blank');">
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
              <strong>#url.itemno# #words[299]#</strong>
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