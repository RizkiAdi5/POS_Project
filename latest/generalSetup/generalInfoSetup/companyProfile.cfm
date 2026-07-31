<cfset pageTitle="Update Company Profile">
<cfset pageAction="Update">

<cfquery name="listCurrency" datasource="#dts#">
	SELECT currcode,currency,currency1
	FROM #target_currency#
	ORDER BY currcode;
</cfquery>

<cfquery name="listCountry" datasource="#dts#">
	SELECT *
	FROM droplistcountry;
</cfquery>

<cfquery name="getGsetup" datasource="#dts#">
	SELECT ctycode
	FROM gsetup;
</cfquery>

<cfif getGsetup.ctycode EQ "IDR">
	<cfset gstWord = "NPWP">
    <cfset gstPlaceholder = "Nomor Pokok Wajib Pajak">
<cfelse>
    <cfset gstWord = "GST No">
    <cfset gstPlaceholder = "Goods and Services Tax Numbers">
</cfif>

<cfif Hlinkams eq "Y">
    <cfquery name="getGsetup" datasource="#replace(LCASE(dts),'_i','_a','all')#">
        SELECT *
        FROM gsetup;
    </cfquery>

    <cfset companyID = getGsetup.companyid>
    <cfset compro = getGsetup.compro>
    <cfset compro2 = getGsetup.compro2>
    <cfset compro3 = getGsetup.compro3>
    <cfset compro4 = getGsetup.compro4>
    <cfset compro5 = getGsetup.compro5>
    <cfset compro6 = getGsetup.compro6>
    <cfset compro7 = getGsetup.compro7>
    <cfset comUEN = getGsetup.comuen>

    <cfset GSTno = getGsetup.gstno>

    <cfset xcurrency= getGsetup.ctycode>
    <cfset currencyCode= listCurrency.currcode>

    <cfset lastYearClosing = Dateformat(getGsetup.lastaccyear, "DD/MM/YYYY")>
    <cfset thisYearClosing = getGsetup.period>
    <cfset debtorFrom = getGsetup.debtorfr>
    <cfset debtorTo = getGsetup.debtorto>
    <cfset creditorFrom = getGsetup.creditorfr>
    <cfset creditorTo = getGsetup.creditorto>
</cfif>

<!--- Ensure gsetup has opening-hour columns used by Customer AI restaurant_hours skill --->
<cftry>
	<cfquery name="chkOpenFromCol" datasource="#dts#">
		SELECT COUNT(*) AS cnt
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = DATABASE()
		AND TABLE_NAME = 'gsetup'
		AND COLUMN_NAME = 'open_from'
	</cfquery>
	<cfif val(chkOpenFromCol.cnt) EQ 0>
		<cfquery datasource="#dts#">
			ALTER TABLE gsetup
			ADD COLUMN open_from VARCHAR(10) NULL COMMENT 'Daily open time HH:MM for e-menu AI',
			ADD COLUMN open_to VARCHAR(10) NULL COMMENT 'Daily close time HH:MM for e-menu AI'
		</cfquery>
	</cfif>
	<cfcatch type="any">
		<!--- Column may already exist or user lacks ALTER privilege; form still loads --->
	</cfcatch>
</cftry>

<cfquery name="getGsetup" datasource="#dts#">
    SELECT *
    FROM gsetup;
</cfquery>

<cfset companyID = getGsetup.companyid>
<cfset compro = getGsetup.compro>
<cfset compro2 = getGsetup.compro2>
<cfset compro3 = getGsetup.compro3>
<cfset compro4 = getGsetup.compro4>
<cfset compro5 = getGsetup.compro5>
<cfset compro6 = getGsetup.compro6>
<cfset compro7 = getGsetup.compro7>
<cfset comUEN = getGsetup.comuen>
<cfset openFrom = "">
<cfset openTo = "">
<cfif listFindNoCase(getGsetup.columnList, "open_from")>
	<cfset openFrom = trim(toString(getGsetup.open_from))>
	<cfif len(openFrom) GTE 5>
		<cfset openFrom = left(openFrom, 5)>
	</cfif>
</cfif>
<cfif listFindNoCase(getGsetup.columnList, "open_to")>
	<cfset openTo = trim(toString(getGsetup.open_to))>
	<cfif len(openTo) GTE 5>
		<cfset openTo = left(openTo, 5)>
	</cfif>
</cfif>

<cfset GSTno = getGsetup.gstno>
<cfset xcurrency= getGsetup.bCurr>
<cfset currencyCode= listCurrency.currcode>

<cfset lastYearClosing = Dateformat(getGsetup.lastaccyear, "DD/MM/YYYY")>
<cfset thisYearClosing = getGsetup.period>
<cfset debtorFrom = getGsetup.debtorfr>
<cfset debtorTo = getGsetup.debtorto>
<cfset creditorFrom = getGsetup.creditorfr>
<cfset creditorTo = getGsetup.creditorto>
<cfset periodAllowed = getGsetup.periodalfr>

<!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>#pageTitle#</title>
	<link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="/latest/css/maintenance/target.css">

	<!--<link rel="stylesheet" type="text/css" href="/latest/js/bootstrapformhelpers/css/bootstrap-formhelpers.css">
	<link rel="stylesheet" type="text/css" href="/latest/js/bootstrapformhelpers/css/bootstrap-formhelpers.min.css">-->
    <!--[if lt IE 9]>
        <script type="text/javascript" src="/latest/js/html5shiv/html5shiv.js"></script>
        <script type="text/javascript" src="/latest/js/respond/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
    <script type="text/javascript" src="/latest/js/bootstrap-datepicker/bootstrap-datepicker.js"></script>
	<link rel="stylesheet" type="text/css" href="/latest/css/bootstrap-datepicker/datepicker3.css">
</head>
<script type="text/javascript">
$(document).ready(function(e) {
$('.input-group.date').datepicker({
		format:"dd/mm/yyyy",
		todayBtn:"linked",
		autoclose:true,
		todayHighlight:true
	});
});
</script>

<body class="container">
<cfoutput>
	<form class="form-horizontal" role="form" id="companyProfileForm" name="companyProfileForm" action="companyProfileProcess.cfm" method="post";>
        <div class="page-header">
            <h3>#pageTitle#</h3>
        </div>
        	<input type="hidden" id="companyID" name="companyID" value="#companyID#" />
            <div class="panel-group">
                    <div class="panel panel-default">
                        <div class="panel-heading" data-toggle="collapse" href="##mainInfoCollapse">
                            <h4 class="panel-title accordion-toggle">Main Information</h4>
                        </div>
                        <div id="mainInfoCollapse" class="panel-collapse collapse in">
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label for="compro" class="col-sm-4 control-label">Company Name</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="compro" name="compro" value="#compro#" placeholder="Company Name" required maxlength="80"/>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="compro2" class="col-sm-4 control-label">Address</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="compro2" name="compro2" value="#compro2#" placeholder="Street Address" maxlength="80">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="compro3" class="col-sm-4 control-label"></label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="compro3" name="compro3" value="#compro3#" placeholder="Apt, Suite, Bldg." maxlength="80">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="compro4" class="col-sm-4 control-label"></label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="compro4" name="compro4" value="#compro4#" placeholder="Additional Address Information" maxlength="80">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="compro5" class="col-sm-4 control-label"></label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="compro5" name="compro5" value="#compro5#" placeholder="Town/City" maxlength="80">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-sm-4 control-label"></label>
                                            <div class="col-sm-4">
												<select class="form-control input-sm" id="compro6" name="compro6">
													<option value="">Choose a Country</option>
													<cfloop query="listCountry">
														<option value="#listCountry.country#" <cfif listCountry.country EQ compro6>selected</cfif>>#listCountry.country#</option>
													</cfloop>
												</select>
                                            </div>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control input-sm" id="compro7" name="compro7" value="#compro7#" placeholder="Postal Code" maxlength="10">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="comUEN" class="col-sm-4 control-label">Company UEN</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="comUEN" name="comUEN" value="#comUEN#" placeholder="Company UEN Number" maxlength="80">
                                            </div>
                                        </div>

                                         <div class="form-group">
                                            <label for="language" class="col-sm-4 control-label">Language</label>
                                            <div class="col-sm-8">
                                            	<select class="form-control input-sm" id="language" name="language">
                                                	<option value="malay" <cfif getGsetup.dflanguage EQ "malay">selected</cfif>>Bahasa Malaysia</option>
                                                    <option value="indo" <cfif getGsetup.dflanguage EQ "indo">selected</cfif>>Bahasa Indonesia</option>
                                                	<option value="english" <cfif getGsetup.dflanguage EQ "english">selected</cfif>>English</option>

                                                    <option value="sim_ch" <cfif getGsetup.dflanguage EQ "sim_ch">selected</cfif>>Simplified Chinese</option>
                                                    <option value="tra_ch" <cfif getGsetup.dflanguage EQ "tra_ch">selected</cfif>>Traditional Chinese</option>
                                                    <option value="vietnam" <cfif getGsetup.dflanguage EQ "vietnam">selected</cfif>>Vietnamese</option>
                                                    <option value="thai" <cfif getGsetup.dflanguage EQ "thai">selected</cfif>>Thai</option>
                                                </select>
                                            </div>
                                        </div>
										<div class="form-group">
											<label class="col-sm-4 control-label">Opening Hours</label>
											<div class="col-sm-4">
												<input type="time" class="form-control input-sm" id="open_from" name="open_from" value="#openFrom#" title="Opens at">
												<span class="help-block" style="margin-bottom:0;font-size:11px;color:##888;">From (daily)</span>
											</div>
											<div class="col-sm-4">
												<input type="time" class="form-control input-sm" id="open_to" name="open_to" value="#openTo#" title="Closes at">
												<span class="help-block" style="margin-bottom:0;font-size:11px;color:##888;">To (daily) — used by e-menu AI</span>
											</div>
										</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>


                    <div class="panel panel-default">
                        <div class="panel-heading" data-toggle="collapse" href="##financialInfoCollapse">
                            <h4 class="panel-title accordion-toggle">Financial Information</h4>
                        </div>
                        <div id="financialInfoCollapse" class="panel-collapse collapse in">
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label for="GSTno" class="col-sm-4 control-label">Company #gstWord#</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="GSTno" name="GSTno" value="#GSTno#" placeholder="#gstPlaceholder#" maxlength="30">
                                            </div>
                                        </div>
                                        <div class="form-group">
										<label for="date" class="col-sm-4 control-label">Last A/C Year Closing Date</label>
										<div class="col-sm-8">
											<div class="input-group date">
												<input type="text" class="form-control input-sm" id="date" name="date" placeholder="Account Created Date" value="#DateFormat(lastYearClosing,'dd/mm/yyyy')#">
                                                <span class="input-group-addon min-padding calender-addon">
                                            		<span class="glyphicon glyphicon-calendar"></span>
                                        		</span>
											</div>
										</div>
									</div>
                                        <div class="form-group">
                                            <label for="thisYearClosing" class="col-sm-4 control-label">This A/C Year Closing Period</label>
                                            <div class="col-sm-8">
                                                <select class="form-control input-sm" id="thisYearClosing" name="thisYearClosing">
                                                    <cfloop index="i" from="1" to="18">
                                                        <option value="#numberformat(i,"00")#" <cfif val(#thisYearClosing#) EQ i>selected</cfif>>#i#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="currencyCode" class="col-sm-4 control-label">Currency</label>
                                            <div class="col-sm-4">
                                                <select class="form-control input-sm" id="currencyCode" name="currencyCode" required="required">
                                                    <option value="">Choose a Currency</option>
                                                    <cfloop query="listCurrency">
                                                        <option value="#listCurrency.currcode#" data-symbol="#listCurrency.currency#" data-description="#listCurrency.currency1#" <cfif listCurrency.currcode EQ xcurrency>selected</cfif>>#listCurrency.currcode#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="debtorFrom" class="col-sm-4 control-label">Debtor From</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="debtorFrom" name="debtorFrom" value="#debtorFrom#" placeholder="Debtor From" maxlength="4">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="debtorTo" class="col-sm-4 control-label">Debtor To</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="debtorTo" name="debtorTo" value="#debtorTo#" placeholder="Debtor To" maxlength="4">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="creditorFrom" class="col-sm-4 control-label">Creditor From</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="creditorFrom" name="creditorFrom" value="#creditorFrom#" placeholder="Creditor From" maxlength="4">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="creditorTo" class="col-sm-4 control-label">Creditor To</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="creditorTo" name="creditorTo" value="#creditorTo#" placeholder="Creditor To" maxlength="4">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="periodAllowed" class="col-sm-4 control-label">Period Allowed From</label>
                                            <div class="col-sm-8">
                                                <select class="form-control input-sm" id="periodAllowed" name="periodAllowed">
                                                    <cfloop index="i" from="1" to="18">
                                                        <option value="#numberformat(i,"00")#" <cfif val(#periodAllowed#) EQ i>selected</cfif>>#i#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
    </form>

	<!--- <form name="upload_picture" action="/latest/uploadImage/company_image.cfm" method="post" enctype="multipart/form-data" target="_blank">
        <div class="panel panel-default">
            <div class="panel-heading" data-toggle="collapse" href="##thirdPanel">
                <h4 class="panel-title accordion-toggle">Upload Company's Logo</h4>
            </div>
            <div id="thirdPanel" class="panel-collapse collapse in">
                <div class="panel-body">
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="col-sm-4 control-label"></label>
                                <div class="col-sm-8">
                               		<input type="file" name="formatlogo" id="formatlogo" size="50" accept="image/gif,image/jpeg,image/tiff,image/x-ms-bmp,image/x-photo-cd,image/x-png,image/x-portable-greymap,image/x-portable-pixmap,image/x-portablebitmap">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label"></label>
                                <div class="col-sm-8">
                                    <input type="text" name="picture_name" id="picture_name" size="50" value="">&nbsp;
        <input type="submit" name="Upload" value="Upload" onClick="javascript:return add_option(document.getElementById('picture_name').value);">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</form>  --->
			</div>

            <div class="pull-right">
				<input type="button" value="#pageAction#" class="btn btn-primary" onclick="document.getElementById('companyProfileForm').submit();"/>
				<input type="button" value="Cancel" onclick="window.location='/latest/body/bodymenu.cfm?id=60100'" class="btn btn-default" />
			</div>
</cfoutput>
</body>
</html>

