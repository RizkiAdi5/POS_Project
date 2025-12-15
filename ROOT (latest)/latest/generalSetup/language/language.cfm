<cfoutput>
<cfif IsDefined('url.languageID')>
	<cfset URLlanguage= trim(urldecode(url.languageID))>
</cfif>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Add Language">
		<cfset pageAction="Create">
		<cfset language=''>
		<cfset english=''>
		<cfset sim_ch=''>
		<cfset indo=''>
		<cfset malay=''>

	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Language Profile">
		<cfset pageAction="Update">
		<cfquery name="getlanguage" datasource='main'>
        	SELECT *
        	FROM words
			WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLlanguage#">;
    	</cfquery>

		<cfset language=getlanguage.id>
		<cfset english=getlanguage.english>
		<cfset sim_ch=getlanguage.sim_ch>
		<cfset indo=getlanguage.indo>
		<cfset malay=getlanguage.malay>

    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Language Profile">
		<cfset pageAction="Delete">
		<cfquery name="getlanguage" datasource='main'>
        	SELECT *
        	FROM words
			WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLlanguage#">;
    	</cfquery>

		<cfset language=getlanguage.id>
		<cfset english=getlanguage.english>
		<cfset sim_ch=getlanguage.sim_ch>
		<cfset indo=getlanguage.indo>
		<cfset malay=getlanguage.malay>

	</cfif>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>#pageTitle#</title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
    <link rel="stylesheet" href="/latest/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
    <script type="text/javascript" src="/latest/js/jqueryui/jquery-ui-1.10.3.custom.min.js"></script>

</head>
<body class="container">
<nav>
  <form class="formContainer form3Button" action="/latest/generalSetup/language/languageProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('language').disabled=false";>
    <div>#pageTitle#</div>
    <div>
      <table>
        <tr>
          <th><label for="language">Language ID</label></th>
          <td>
            <input type="text" id="language" name="language" value="#language#" />
            </td>
          </tr>
        <tr>
          <th><label for="english">English</label></th>
          <td>
            <input type="text" id="english" name="english" value="#english#" />
            </td>
          </tr>
        <tr>
			<th><label for="sim_ch">sim_ch</label></th>
            <td>
			<input type="text" id="sim_ch" name="sim_ch" value="#sim_ch#" />
            </td>
        </tr>
		 <tr>
			<th><label for="indo">indo</label></th>
            <td>
			<input type="text" id="indo" name="indo" value="#indo#" />
            </td>
        </tr>
		 <tr>
			<th><label for="malay">malay</label></th>
            <td>
			<input type="text" id="malay" name="malay" value="#malay#" />
            </td>
        </tr>
        </table>
      </div>
    <div>
      <input type="submit" value="#pageAction#" />
      <input type="button" value="Cancel" onclick="window.location='/latest/generalSetup/language/index.cfm'" />
      </div>
  </form>
</nav>
</body>
</html>
</cfoutput>