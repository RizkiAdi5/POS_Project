<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "95,2145,98,805,585,1348,65,702,877,2147,1097,96">
<cfinclude template="/latest/words.cfm">

<cfoutput>
<cfif IsDefined('url.dailyopeningID')>
	<cfset URLcounter = trim(urldecode(url.dailyopeningID))>
</cfif>
	<cfquery name="getcounter" datasource='#dts#'>
        SELECT *
        FROM counter;
    </cfquery>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[95]# #words[2145]#">
		<cfset pageAction="#words[95]#">
		<cfset counter=''>
		<cfset wos_date=dateformat(now(),'DD/MM/YYYY')>
		<cfset type=''>
		<cfset desp=''>
		<cfset amount=0>

	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[98]# #words[2145]#">
		<cfset pageAction="#words[98]#">
		<cfquery name="getdailyopening" datasource='#dts#'>
            SELECT *
            FROM dailycounter
            WHERE counterid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcounter#">;
		</cfquery>

		<cfset counter=getdailyopening.counterid>
		<cfset wos_date=dateformat(getdailyopening.wos_date,'DD/MM/YYYY')>
		<cfset type=getdailyopening.type>
		<cfset amount=getdailyopening.openning>
		<cfset desp=getdailyopening.desp>

    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="#words[805]# #words[2145]#">
		<cfset pageAction="#words[805]#">
		<cfquery name="getdailyopening" datasource='#dts#'>
            SELECT *
            FROM dailycounter
            WHERE counterid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcounter#">;
		</cfquery>

		<cfset counter=getdailyopening.counterid>
		<cfset wos_date=dateformat(getdailyopening.wos_date,'DD/MM/YYYY')>
		<cfset type=getdailyopening.type>
		<cfset amount=getdailyopening.openning>
		<cfset desp=getdailyopening.desp>
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

    <cfinclude template="/latest/date/datePickerFunction.cfm">
</head>
<body class="container">
<nav>
  <form class="formContainer form3Button" action="/latest/maintenance/dailyopeningProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('counter').disabled=false";>
    <div>#pageTitle#</div>
    <div>
      <table>
        <tr>
          <th><label for="counter">#words[585]#</label></th>
          <td>
            <select id="counter" name="counter" required="yes" message="Please select a counter">
              <option value="">#words[1348]#</option>
              <cfloop query="getcounter">
                <option value="#getcounter.counterid#" <cfif counter eq getcounter.counterid>selected</cfif>>#getcounter.counterid# - #getcounter.counterdesp#</option>
                </cfloop>
              </select>
            </td>
          </tr>
        <tr>
          <th><label for="desp">#words[65]#</label></th>
          <td>
            <input type="text" id="desp" name="desp" value="#desp#" />
            </td>
          </tr>
        <tr>
			<th><label for="dateFrom">#words[702]#</label></th>
            <td>
			<input type="Text" name="wos_date" id="dateFrom" maxlength="10" size="10" placeholder="(DD/MM/YYYY)" readonly="readonly" value="#wos_date#"/>
            </td>
        </tr>
        <tr>
          <th><label for="type">#words[877]#</label></th>
          <td>
            <select name="type">
              <option value="opening" <cfif type eq "opening">selected</cfif>>#words[2147]#</option>
              <option value="cashin" <cfif type eq "cashin">selected</cfif> >Cash In</option>
              <option value="cashout" <cfif type eq "cashout">selected</cfif> >Cash Out</option>
            </select>
            </td>
          </tr>
        <tr>
          <th><label for="amount">#words[1097]#</label></th>
          <td><input type="text" id="amount" name="amount" required="yes" message="Amount is Required" value="#amount#"/></td>
          </tr>
        </table>
      </div>
    <div>
      <input type="submit" value="#pageAction#" />
      <input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/dailyopeningProfile.cfm'" />
      </div>
  </form>
</nav>
</body>
</html>
</cfoutput>