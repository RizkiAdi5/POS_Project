<cfset pageTitle = "Payment Gateway">
<cfinclude template="/PaymentGateway/_pgBootstrap.cfm">

<cfquery name="qProfile" datasource="#dts#">
	SELECT * FROM pg_payment_profile ORDER BY profile_id LIMIT 1
</cfquery>
<cfquery name="qGsetup" datasource="#dts#">
	SELECT compro, ctycode, bCurr FROM gsetup LIMIT 1
</cfquery>

<cfset f = pgProfileDefaults()>
<cfif qProfile.recordCount>
	<cfset f = pgApplyQuery(f, qProfile)>
<cfelseif qGsetup.recordCount>
	<cfset f.business_name = qGsetup.compro>
	<cfset f.country_code = pgCurrencyToCountry(qGsetup.ctycode)>
</cfif>

<cfset payoutCurrency = "IDR">
<cfif qGsetup.recordCount AND Len(qGsetup.bCurr)><cfset payoutCurrency = qGsetup.bCurr></cfif>
<cfset payoutCurrency = pgCountryCurrency(f.country_code, payoutCurrency)>
<cfif StructKeyExists(URL, "country") AND Len(Trim(URL.country)) EQ 2>
	<cfset f.country_code = UCase(Trim(URL.country))>
	<cfset payoutCurrency = pgCountryCurrency(f.country_code, payoutCurrency)>
</cfif>

<cfset bankLoad = pgLoadBanks(payoutCurrency)>
<cfset banks = bankLoad.channels>
<!--- <cfset st = pgStatus(qProfile)> --->

<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title><cfoutput>#pageTitle#</cfoutput></title>
	<link rel="stylesheet" href="/latest/css/bootstrap/bootstrap.css">
	<script src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
</head>
<body class="container" style="padding:1.5rem 0 2rem">
<cfoutput>
	<h2>#pageTitle#</h2>

	<cfif StructKeyExists(URL, "msg") AND URL.msg EQ "saved">
		<div class="alert alert-success">Saved.</div>
		<!---
		<cfif StructKeyExists(URL, "warn") AND Len(URL.warn)>
			<div class="alert alert-warning">Xendit: #XmlFormat(URL.warn)#</div>
		</cfif>
		--->
	<cfelseif StructKeyExists(URL, "msg") AND URL.msg EQ "synced">
		<div class="alert alert-success">Status: #XmlFormat(URL.status)#</div>
	</cfif>
	<cfif StructKeyExists(URL, "err")>
		<div class="alert alert-danger">#XmlFormat(URL.err)#</div>
	</cfif>

	<!---
	<p class="well well-sm" style="font-size:13px;margin-bottom:1rem">
		API | xenPlatform | Bank | Sub-account — <a href="auth.cfm?xenditTest=1" target="_blank">API test</a>
	</p>
	<cfif st.api AND NOT st.xp>
		<div class="alert alert-warning small">xenPlatform 401: update pgConfig.cfm, restart app pool.</div>
	</cfif>
	--->

	<form method="post" action="profileProcess.cfm" class="form-horizontal" id="pgForm">
		<input type="hidden" name="profile_id" value="#f.profile_id#">
		<input type="hidden" name="payout_channel_name" id="payout_channel_name" value="#XmlFormat(f.payout_channel_name)#">

		<div class="panel panel-default">
			<div class="panel-heading"><strong>Settlement bank</strong> (#XmlFormat(payoutCurrency)#)</div>
			<div class="panel-body">
				<div class="form-group">
					<label class="col-sm-3 control-label" for="payout_channel_code">Bank *</label>
					<div class="col-sm-9">
						<select class="form-control" name="payout_channel_code" id="payout_channel_code" required>
							<option value="">-- Select bank --</option>
							<cfset pgBankFound = false>
							<cfloop from="1" to="#ArrayLen(banks)#" index="i">
								<cfset c = pgCh(banks[i], "channel_code")>
								<cfset n = pgCh(banks[i], "channel_name")>
								<cfif c EQ f.payout_channel_code><cfset pgBankFound = true></cfif>
								<option value="#XmlFormat(c)#" data-name="#XmlFormat(n)#"<cfif c EQ f.payout_channel_code> selected</cfif>>#XmlFormat(n)#</option>
							</cfloop>
							<cfif Len(f.payout_channel_code) AND NOT pgBankFound>
								<cfset pgSavedBankLabel = f.payout_channel_code>
								<cfif Len(f.payout_channel_name)><cfset pgSavedBankLabel = f.payout_channel_name></cfif>
								<option value="#XmlFormat(f.payout_channel_code)#" data-name="#XmlFormat(f.payout_channel_name)#" selected>#XmlFormat(pgSavedBankLabel)#</option>
							</cfif>
						</select>
						<cfif NOT bankLoad.ok AND Len(bankLoad.message)>
							<p class="help-block text-warning" style="margin:6px 0 0">#XmlFormat(bankLoad.message)#</p>
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label">Account no *</label>
					<div class="col-sm-9"><input type="text" class="form-control" name="payout_account_number" required maxlength="40" value="#XmlFormat(f.payout_account_number)#" pattern="[0-9]+"></div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label">Holder *</label>
					<div class="col-sm-9"><input type="text" class="form-control" name="payout_account_holder" required maxlength="120" value="#XmlFormat(f.payout_account_holder)#"></div>
				</div>
			</div>
		</div>

		<div class="panel panel-default">
			<div class="panel-heading"><strong>Business</strong></div>
			<div class="panel-body">
				<div class="form-group">
					<label class="col-sm-3 control-label">Name *</label>
					<div class="col-sm-9"><input type="text" class="form-control" name="business_name" required value="#XmlFormat(f.business_name)#"></div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label">Email *</label>
					<div class="col-sm-9"><input type="email" class="form-control" name="business_email" required value="#XmlFormat(f.business_email)#"<cfif Len(f.xendit_account_id)> readonly</cfif>></div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label">Country</label>
					<div class="col-sm-3">
						<select class="form-control" name="country_code" id="country_code">
							<option value="ID"<cfif f.country_code EQ "ID"> selected</cfif>>Indonesia</option>
							<option value="PH"<cfif f.country_code EQ "PH"> selected</cfif>>Philippines</option>
							<option value="MY"<cfif f.country_code EQ "MY"> selected</cfif>>Malaysia</option>
							<option value="TH"<cfif f.country_code EQ "TH"> selected</cfif>>Thailand</option>
							<option value="VN"<cfif f.country_code EQ "VN"> selected</cfif>>Vietnam</option>
						</select>
					</div>
					<label class="col-sm-2 control-label">Type</label>
					<div class="col-sm-3">
						<select class="form-control" name="account_type"<cfif Len(f.xendit_account_id)> disabled</cfif>>
							<option value="MANAGED"<cfif f.account_type EQ "MANAGED"> selected</cfif>>MANAGED</option>
							<option value="OWNED"<cfif f.account_type EQ "OWNED"> selected</cfif>>OWNED</option>
						</select>
						<cfif Len(f.xendit_account_id)><input type="hidden" name="account_type" value="#XmlFormat(f.account_type)#"></cfif>
					</div>
				</div>
			</div>
		</div>

		<div class="panel panel-default">
			<div class="panel-heading"><strong>Channels</strong></div>
			<div class="panel-body">
				<label class="checkbox-inline"><input type="checkbox" name="enable_qris" value="Y"<cfif f.enable_qris EQ "Y"> checked</cfif>> QRIS</label>
				<label class="checkbox-inline"><input type="checkbox" name="enable_ewallet" value="Y"<cfif f.enable_ewallet EQ "Y"> checked</cfif>> E-Wallet</label>
				<label class="checkbox-inline"><input type="checkbox" name="enable_va" value="Y"<cfif f.enable_va EQ "Y"> checked</cfif>> VA</label>
				<label class="checkbox-inline"><input type="checkbox" name="enable_card" value="Y"<cfif f.enable_card EQ "Y"> checked</cfif>> Card</label>
				<label class="checkbox-inline"><input type="checkbox" name="is_active" value="Y"<cfif f.is_active EQ "Y"> checked</cfif>> Active</label>
			</div>
		</div>

		<div class="form-group">
			<div class="col-sm-offset-3 col-sm-9">
				<button type="submit" class="btn btn-primary">Save</button>
				<cfif Len(f.xendit_account_id)><a class="btn btn-default" href="profileProcess.cfm?action=sync">Sync</a></cfif>
			</div>
		</div>
	</form>
</cfoutput>
<script>
(function ($) {
	$('#payout_channel_code').on('change', function () {
		var $opt = $(this).find('option:selected');
		$('#payout_channel_name').val($opt.attr('data-name') || '');
	});
	$('#country_code').on('change', function () {
		location.href = 'paymentProfile.cfm?country=' + $(this).val();
	});
})(jQuery);
</script>
</body>
</html>
