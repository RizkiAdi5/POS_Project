<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "432,95,433,98,125,146,65,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,143,182,
183,184,185,186,187,188,381,96">
<cfinclude template="/latest/words.cfm">
<!--- ** getGeneral ** --->
<!--- To display default values from AMS Accounting Default Setup--->
<cfquery name="getGeneral" datasource='#dts#'>
	SELECT creditsales,cashsales,salesreturn,purchasereceive,purchasereturn
    FROM gsetup;
</cfquery>

<cfquery name="getcate" datasource='#dts#'>
	SELECT *
    FROM iccate;
</cfquery>

<cfif IsDefined('url.wos_group')>
	<cfset URLwos_group = trim(urldecode(url.wos_group))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[432]#">
		<cfset pageAction="#words[95]#">
		<cfset group = "">
        <cfset desp = "">
        <cfloop index="i" from="1" to="15">
        	<cfif i eq 1>
            	<cfset category = "">
            <cfelse>
        		<cfset 'category#i#' = "">
            </cfif>
        </cfloop>
        <cfset salec = getGeneral.creditsales>
		<cfset salecsc = getGeneral.cashsales>
        <cfset salecnc = getGeneral.salesreturn>
        <cfset purc = getGeneral.purchasereceive>
        <cfset purprc = getGeneral.purchasereturn>
		<cfset displayDefaultValue = "Choose a GL Account">
        <cfloop from="11" to="40" index="i">
        	<cfset 'grade#i#' = "">
        </cfloop>

	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[433]#">
		<cfset pageAction="#words[98]#">
		<cfquery name="get_icGroup" datasource='#dts#'>
            SELECT *
            FROM icgroup
            WHERE wos_group=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLwos_group#">;
		</cfquery>

		<cfset group = get_icGroup.wos_group>
        <cfset desp = get_icGroup.desp>
        <cfloop index="i" from="1" to="15">
        	<cfif i eq 1>
            	<cfset category = evaluate('get_icGroup.category')>
            <cfelse>
        		<cfset 'category#i#' = evaluate('get_icGroup.category#i#')>
            </cfif>
        </cfloop>
        <cfset salec = get_icGroup.salec>
		<cfset salecsc = get_icGroup.salecsc>
        <cfset salecnc = get_icGroup.salecnc>
        <cfset purc = get_icGroup.purc>
        <cfset purprc = get_icGroup.purprc>
		<cfset displayDefaultValue = "Choose a GL Account">
        <cfloop from="11" to="40" index="i">
        	<cfset 'grade#i#' = evaluate('get_icGroup.gradd#i#')>
        </cfloop>
	</cfif>
</cfif>

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

    <link rel="stylesheet" type="text/css" href="/latest/css/maintenance/target.css">
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.css">
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>

    <cfinclude template="/latest/maintenance/filter/filterGL.cfm">
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
</head>

<body class="container">
<cfoutput>
<form class="form-horizontal" role="form" action="/latest/maintenance/groupProcess.cfm?action=#url.action#&menuID=#url.menuID#" method="post" onsubmit="document.getElementById('group').disabled=false";>
	<div class="page-header">
		<h3>#pageTitle#</h3>
	</div>
		<div class="panel-group">
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##mainInfoCollapse">
						<h4 class="panel-title accordion-toggle">#words[125]#</h4>
					</div>
					<div id="mainInfoCollapse" class="panel-collapse collapse in">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label for="group" class="col-sm-4 control-label">#words[146]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="group" name="group" placeholder="#words[146]#" required="yes" maxlength="25" <cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLwos_group#"  disabled="true"</cfif>/>
										</div>
									</div>

                                    <div class="form-group">
										<label for="desp" class="col-sm-4 control-label">#words[65]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="desp" name="desp" value="#desp#" placeholder="#words[65]#">
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##categoryInfoCollapse">
						<h4 class="panel-title accordion-toggle">#words[365]#</h4>
					</div>
					<div id="categoryInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
                                	<cfloop index = "i" from = "1" to = "15">
                                        <div class="form-group">
                                            <label for="category#i#" class="col-sm-4 control-label">#words[i+365]#</label>
                                            <div class="col-sm-8">
                                            <cfif i eq 1>
                                            <select class="form-control input-sm" id="category" name="category">
                                            	<option value="">#words[143]#</option>
                                            	<cfset categoryValue = category>
                                                <cfloop query="getcate">
                                                <option value="#getcate.cate#" <cfif categoryValue eq cate>selected</cfif>>#getcate.cate# #getcate.desp#</option>
                                                </cfloop>
                                            </select>
                                            <cfelse>
                                            <select class="form-control input-sm" id="category#i#" name="category#i#">
                                            	<option value="">#words[143]#</option>
                                            	<cfset categoryValue = evaluate('category#i#')>
                                                <cfloop query="getcate">
                                                <option value="#getcate.cate#" <cfif categoryValue eq cate>selected</cfif>>#getcate.cate# #getcate.desp#</option>
                                                </cfloop>
                                            </select>
                                            </cfif>
                                            </div>
                                        </div>
                                    </cfloop>
								</div>
							</div>
						</div>
					</div>
				</div>

                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##productInfoCollapse">
						<h4 class="panel-title accordion-toggle">#words[182]#</h4>
					</div>
					<div id="productInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
                                	<div class="form-group">
										<label for="creditSales" class="col-sm-4 control-label">#words[183]#</label>
										<div class="col-sm-8">
											<cfif hlinkams EQ 'Y'>
                                                <input type="hidden" id="creditSales" name="creditSales" class="accno1" value="#salec#" />
                                            <cfelse>
                                            	<input type="text" id="creditSales" name="creditSales" value="#salec#" />
                                        	</cfif>
										</div>
									</div>
                                    <div class="form-group">
										<label for="cashSales" class="col-sm-4 control-label">#words[185]#</label>
										<div class="col-sm-8">
											<cfif hlinkams EQ 'Y'>
                                                <input type="hidden" id="cashSales" name="cashSales" class="accno2" value="#salecsc#" />
                                            <cfelse>
                                                <input type="text" id="cashSales" name="cashSales" value="#salecsc#" />
                                            </cfif>
										</div>
									</div>
                                    <div class="form-group">
										<label for="salesReturn" class="col-sm-4 control-label">#words[186]#</label>
										<div class="col-sm-8">
											<cfif hlinkams EQ 'Y'>
                                                <input type="hidden" id="salesReturn" name="salesReturn" class="accno3" value="#salecnc#" />
                                            <cfelse>
                                                <input type="text" id="salesReturn" name="salesReturn" value="#salecnc#" />
                                            </cfif>
										</div>
									</div>
                                    <div class="form-group">
										<label for="purchase" class="col-sm-4 control-label">#words[187]#</label>
										<div class="col-sm-8">
											<cfif hlinkams EQ 'Y'>
                                                <input type="hidden" id="purchase" name="purchase" class="accno4" value="#purc#" />
                                            <cfelse>
                                                <input type="text" id="purchase" name="purchase" value="#purc#" />
                                            </cfif>
										</div>
									</div>
                                    <div class="form-group">
										<label for="purchaseReturn" class="col-sm-4 control-label">#words[188]#</label>
										<div class="col-sm-8">
											<cfif hlinkams EQ 'Y'>
                                                <input type="hidden" id="purchaseReturn" name="purchaseReturn" class="accno5" value="#purprc#" />
                                            <cfelse>
                                                <input type="text" id="purchaseReturn" name="purchaseReturn" value="#purprc#" />
                                            </cfif>
										</div>
									</div>
                                    <div class="form-group">
										<label for="meterReading" class="col-sm-4 control-label">#words[381]#</label>
										<div class="col-sm-8">
											<input type="checkbox" id="meterReading" name="meterReading" <cfif IsDefined("url.action") AND url.action NEQ "create"><cfif get_icGroup.meter_read eq 'T'>checked</cfif></cfif> />
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

            <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##panel5Collapse">
						<h4 class="panel-title accordion-toggle">Grade Information</h4>
					</div>
					<div id="panel5Collapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
                                	<div class="form-group">
                                    	<cfloop from="11" to="25" index="i">
                                            <label for="gradeLabel#i#" class="col-sm-4 control-label">Grade #i-10#</label>
                                            <div class="col-sm-8">
                                                <input type="text" id="grade#i#" name="grade#i#" class="form-control input-sm" value="#evaluate('grade#i#')#" />
                                            </div>
                                        </cfloop>
									</div>
								</div>
                                <div class="col-sm-6">
                                	<div class="form-group">
                                    	<cfloop from="26" to="40" index="i">
                                            <label for="gradeLabel#i#" class="col-sm-4 control-label">Grade #i-10#</label>
                                            <div class="col-sm-8">
                                                <input type="text" id="grade#i#" name="grade#i#" class="form-control input-sm" value="#evaluate('grade#i#')#" />
                                            </div>
                                        </cfloop>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

            <div class="pull-right">
				<input type="submit" value="#pageAction#" class="btn btn-primary"/>
				<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/groupProfile.cfm?menuID=#url.menuID#'" class="btn btn-default" />
			</div>
</form>
</cfoutput>
</body>
</html>

