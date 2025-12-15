<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "663,664,188,665,666,185,689,667,690,668,669,670,671,672,673,674,662">
<cfinclude template="/latest/words.cfm">
<cfquery name="getTermsAndCondition" datasource='#dts#'>
    SELECT *
    FROM ictermandcondition
</cfquery>

<cfset irc = getTermsAndCondition.lrc>
<cfset ipr = getTermsAndCondition.lpr>
<cfset ido = getTermsAndCondition.ldo>
<cfset inv = getTermsAndCondition.linv>
<cfset ics = getTermsAndCondition.lcs>
<cfset icn = getTermsAndCondition.lcn>
<cfset idn = getTermsAndCondition.ldn>
<cfset ipo = getTermsAndCondition.lpo>
<cfset iquo = getTermsAndCondition.lquo>
<cfset iquo2 = getTermsAndCondition.lquo2>
<cfset iquo3 = getTermsAndCondition.lquo3>
<cfset iquo4 = getTermsAndCondition.lquo4>
<cfset iquo5 = getTermsAndCondition.lquo5>
<cfset iso = getTermsAndCondition.lso>
<cfset isam = getTermsAndCondition.lsam>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#words[663]#</cfoutput></title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
</head>

<body class="container">
<cfoutput>
<form class="formContainer form2Button" action="/latest/maintenance/termsAndConditionProcess.cfm" method="post">
	<div>#words[663]#</div>
	<div>
        <div class="form-group">
          <label for="irc" class="col-sm-4 control-label">#words[664]#</label>
            <div class="col-sm-8">
              <textarea name="irc" cols="150" rows="8" class="form-control input-sm" id="irc">#irc#</textarea>
            </div>
        </div>
        <div class="form-group">
          <label for="ipr" class="col-sm-4 control-label">#words[188]#</label>
            <div class="col-sm-8">
              <textarea name="ipr" cols="150" rows="8" class="form-control input-sm" id="ipr">#ipr#</textarea>
            </div>
        </div>
        <div class="form-group">
          <label for="ido" class="col-sm-4 control-label">#words[665]#</label>
            <div class="col-sm-8">
              <textarea name="ido" cols="150" rows="8" class="form-control input-sm" id="ido">#ido#</textarea>
            </div>
        </div>
        <div class="form-group">
          <label for="inv" class="col-sm-4 control-label">#words[666]#</label>
            <div class="col-sm-8">
              <textarea name="inv" cols="150" rows="8" class="form-control input-sm" id="inv">#inv#</textarea>
            </div>
        </div>
        <div class="form-group">
          <label for="ics" class="col-sm-4 control-label">#words[185]#</label>
            <div class="col-sm-8">
              <textarea name="ics" cols="150" rows="8" class="form-control input-sm" id="ics">#ics#</textarea>
          </div>
        </div>
        <div class="form-group">
          <label for="icn" class="col-sm-4 control-label">#words[689]#</label>
            <div class="col-sm-8">
              <textarea name="icn" cols="150" rows="8" class="form-control input-sm" id="icn">#icn#</textarea>
          </div>
        </div>
        <div class="form-group">
          <label for="idn" class="col-sm-4 control-label">#words[667]#</label>
            <div class="col-sm-8">
              <textarea name="idn" cols="150" rows="8" class="form-control input-sm" id="idn">#idn#</textarea>
          </div>
        </div>
        <div class="form-group">
          <label for="ipo" class="col-sm-4 control-label">#words[690]#</label>
            <div class="col-sm-8">
              <textarea name="ipo" cols="150" rows="8" class="form-control input-sm" id="ipo">#ipo#</textarea>
          </div>
        </div>

        <div class="form-group">
          <label for="iquo" class="col-sm-4 control-label">#words[668]#</label>
        <div class="col-sm-8">
              <textarea name="iquo" cols="150" rows="8" class="form-control input-sm" id="iquo">#iquo#</textarea>
          </div>
        </div>

        <div class="form-group">
          <label for="iquo2" class="col-sm-4 control-label">#words[669]#</label>
        <div class="col-sm-8">
              <textarea name="iquo2" cols="150" rows="8" class="form-control input-sm" id="iquo2">#iquo2#</textarea>
          </div>
        </div>
        <div class="form-group">
          <label for="iquo3" class="col-sm-4 control-label">#words[670]#</label>
            <div class="col-sm-8">
              <textarea name="iquo3" cols="150" rows="8" class="form-control input-sm" id="iquo3">#iquo3#</textarea>
          </div>
        </div>
        <div class="form-group">
          <label for="iquo4" class="col-sm-4 control-label">#words[671]#</label>
            <div class="col-sm-8">
              <textarea name="iquo4" cols="150" rows="8" class="form-control input-sm" id="iquo4">#iquo4#</textarea>
          </div>
        </div>
        <div class="form-group">
          <label for="iquo5" class="col-sm-4 control-label">#words[672]#</label>
                <div class="col-sm-8">
              <textarea name="iquo5" cols="150" rows="8" class="form-control input-sm" id="iquo5">#iquo5#</textarea>
          </div>
        </div>
        <div class="form-group">
			<label for="iso" class="col-sm-4 control-label">#words[673]#</label>
			<div class="col-sm-8">
				<textarea name="iso" cols="150" rows="8" class="form-control input-sm" id="iso">#iso#</textarea>
			</div>
        </div>
        <div class="form-group">
			<label for="isam" class="col-sm-4 control-label">#words[674]#</label>
			<div class="col-sm-8">
				<textarea name="isam" cols="150" rows="8" class="form-control input-sm" id="isam">#isam#</textarea>
			</div>
        </div>
	</div>
	<div>
		<input type="submit" name="Save" value="#words[662]#" />
	</div>
</form>
</cfoutput>
</body>
</html>