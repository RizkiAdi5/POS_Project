<html>
<head>
	<title>Maintenance Counter</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>


<body>
<cfoutput>
    <link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>

		<h4>
<a href="adddailyopenning.cfm?type=Create">Create New Cash Recording</a>
|| <a href="s_dailycountertable.cfm?type=counter">Search For Cash Recording</a>
	</h4>

	<cfif url.type eq 'create'>
    <cfset counter=''>
    <cfset wos_date=dateformat(now(),'DD/MM/YYYY')>
    <cfset type=''>
    <cfset desp=''>
    <cfset amount=0>
    <cfset openingid=''>
    
    <cfset sub_btn='Create'>
    
    <cfelseif url.type eq 'delete'>
    <cfquery name="getdailyopening" datasource="#dts#">
    select * from dailycounter where id='#url.id#'
    </cfquery>
    
    <cfset counter=getdailyopening.counterid>
    <cfset wos_date=dateformat(getdailyopening.wos_date,'DD/MM/YYYY')>
    <cfset type=getdailyopening.type>
    <cfset amount=getdailyopening.openning>
    <cfset desp=getdailyopening.desp>
    <cfset openingid=url.id>
    
    <cfset sub_btn='Delete'>
    <cfelse>
    
    <cfquery name="getdailyopening" datasource="#dts#">
    select * from dailycounter where id='#url.id#'
    </cfquery>
    
    <cfset counter=getdailyopening.counterid>
    <cfset wos_date=dateformat(getdailyopening.wos_date,'DD/MM/YYYY')>
    <cfset type=getdailyopening.type>
    <cfset amount=getdailyopening.openning>
    <cfset desp=getdailyopening.desp>
    <cfset openingid=url.id>
    <cfset sub_btn='Edit'>
    </cfif>
    <cfquery name="getcounter" datasource="#dts#">
    select * from counter
    </cfquery>
	<cfform name="counterform" action="adddailyprocess.cfm" method="post">
    	<input type="hidden" name="mode" value="#sub_btn#">
		<input type="hidden" name="openingid" id="openingid" value="#openingid#">
		<h1 align="center">Add Cash Recording</h1>

		<table align="center" class="data" width="500">
      		<tr>
        		<td width="100">Counter :</td>
        		<td>
                <cfselect name="counter" required="yes" message="Please select a counter">
                <option value="">Choose a counter</option>
                <cfloop query="getcounter">
                 <option value="#getcounter.counterid#" <cfif counter eq getcounter.counterid>selected</cfif>>#getcounter.counterid# - #getcounter.counterdesp#</option>
                </cfloop>
                </cfselect>
				</td>
      		</tr>
            <tr>
            <td>Description</td>
            <td><cfinput type="text" name="desp" id="desp" value="#desp#"></td>
            </tr>
      		<tr>
        		<td>Date</td>
        		<td>
                <cfinput type="text" name="wos_date" id="wos_date"  value="#dateformat(now(),'DD/MM/YYYY')#" required="yes" message="Date is Required">&nbsp;<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(document.getElementById('wos_date'));">
				</td>
      		</tr>
            <tr>
        		<td>Type</td>
        		<td>
                <select name="type">
                <option value="opening" <cfif type eq 'opening'>selected</cfif>>Opening</option>
                <option value="cashin" <cfif type eq 'cashin'>selected</cfif>>Cash In</option>
                <option value="cashout" <cfif type eq 'cashout'>selected</cfif>>Cash Out</option>
                </select>
				</td>
      		</tr>
            <tr>
            <td>Amount</td>
            <td><cfinput type="text" name="amount" required="yes" message="Amount is Required" value="#amount#"></td>
            </tr>
            
      		<tr>
        		<td></td>
        		<td align="right"><cfinput name="submit" type="submit" value="#sub_btn#"></td>
      		</tr>
		</table>
	</cfform>
</body>
</cfoutput>
</html>