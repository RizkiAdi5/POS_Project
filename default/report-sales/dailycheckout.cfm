<cfprocessingdirective pageencoding="UTF-8">
<cfquery name="getgsetup" datasource="#dts#">
	SELECT * 
    FROM gsetup
</cfquery>
<cfset c_Period = getgsetup.Period>

<cfparam name="alown" default="0">
<cfif getpin2.h4700 eq 'T'>
	<cfset alown = 1>
</cfif>

<cfquery name="getuserid" datasource="main">
	SELECT userid,username 
    FROM users WHERE userbranch='#dts#'
    <cfif husergrpid EQ 'super' OR husergrpid EQ 'admin'>
    <cfelse>
    AND userid ='#huserid#'
    </cfif>
</cfquery>

<cfquery name="getcounter" datasource="#dts#">
	select counterid from counter order by counterid
</cfquery>
	
<cfset pageTitle = "Daily Checkout Report">


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><cfoutput>#pageTitle#</cfoutput></title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link rel="stylesheet" href="/latest/css/jqueryui/smoothness/jquery-ui-1.10.3.custom.min.css" />
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
    <script type="text/javascript" src="/latest/js/jqueryui/jquery-ui-1.10.3.custom.min.js"></script>
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
    
    <cfinclude template="/latest/filter/filterAgent.cfm">

	<cfinclude template="/latest/date/datePickerFunction.cfm"> 

</head>

<body class="container">
<cfoutput>
	<cfform class="formContainer form3Button" name="saleslist" id="saleslist" action="dailycheckout1.cfm?alown=#alown#" method="post" target="_blank">
		<div>#pageTitle#</div>
        <div>
            <table> 
				<tr> 
					<th><label for="agent">Agent</label></th>			
					<td>
						<input type="hidden" id="agentfrom" name="agentfrom" class="agentFilter" data-placeholder="[FROM] - Choose an Agent" />
						<input type="hidden" id="agentto" name="agentto" class="agentFilter" data-placeholder="[TO] - Choose an Agent" />
					</td>
				</tr>
				<tr> 
					<th><label for="date">Counter</label></th>		
					<td><select name="counter">       
						<option value="">Choose a counter</option>
						<cfloop query="getcounter">
						<option value="#getcounter.counterid#">#getcounter.counterid#</option>
						</cfloop>
						</select>
					</td>
				</tr>
				<tr> 
					<th><label for="user">User</label></th>			
					<td>
						<select name="userfrom" id="userfrom">
                        <cfif husergrpid eq 'super' or husergrpid eq 'admin'>>
							<option value="">[FROM] - Choose an User</option>
                        </cfif>							  
							<cfloop query="getuserid">
								<option value="#getuserid.userid#">#getuserid.userid# - #getuserid.username#</option>
							</cfloop>
						</select>
						<select name="userto" id="userto">
                        <cfif husergrpid eq 'super' or husergrpid eq 'admin'>>
							<option value="">[TO] - Choose an User</option>
                        </cfif>
							<cfloop query="getuserid">
								<option value="#getuserid.userid#" >#getuserid.userid# - #getuserid.username#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				 <tr> 
					<th><label for="period">Period</label></th>			
					<td>
						<select name="periodfrom" id="periodfrom" Onchange="tf_fperiodfromDesp.value = this.options[this.selectedIndex].title;">
							<option value="">[FROM] - Choose a Period</option>
							  <cfloop index="fCurrMonth" from="1" to="#c_Period#">
								  <cfset fccurr = DateAdd('m', fCurrMonth, "#getgsetup.LastAccYear#")>
								  <cfset fdmont = dateformat(fccurr,"mm")>
								  <cfset fdmont2 = dateformat(fccurr,"mmmm ''yyyy")>
								  <option title="#fdmont2#" value="#numberFormat(fCurrMonth,'00')#"<cfif fcurrmonth eq 1>selected</cfif>>#fCurrMonth# - #dateformat(fccurr,"mmm'yyyy")#</option>
							  </cfloop>
						</select>
						<select name="periodto" id="periodto" Onchange="tf_fperiodtoDesp.value = this.options[this.selectedIndex].title;">
							<option value="">[TO] - Choose a Period</option>
							<cfloop index="fCurrMonth" from="1" to="#c_Period#">
								<cfset fccurr = DateAdd('m', fCurrMonth, "#getgsetup.LastAccYear#")>
								<cfset fdmont = dateformat(fccurr,"mm")>
								<cfset fdmont2 = dateformat(fccurr,"mmmm ''yyyy")>
								<cfset fnow = dateformat(now(),"mmmm ''yyyy")>
								<option title="#fdmont2#" value="#numberFormat(fCurrMonth,'00')#"<cfif fnow eq fdmont2>selected</cfif>>#fCurrMonth# - #dateformat(fccurr,"mmm'yyyy")#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr> 
                	<th><label for="date">Date</label></th>							                   
                    <td>
					<input type="Text" name="dateFrom" id="dateFrom" maxlength="10" size="10" placeholder="(DD/MM/YYYY)" readonly="readonly" value="#dateformat(now(),'dd/mm/yyyy')#" />
                    <input type="Text" name="dateTo" id="dateTo" maxlength="10" size="10" placeholder="(DD/MM/YYYY)" readonly="readonly" value="#dateformat(now(),'dd/mm/yyyy')#" />
                    </td>
				</tr>           
            </table>
		</div>
        <div>
            <input type="Submit" name="result" id="result" value="HTML"  />
        </div>       
    </cfform>
</cfoutput>
</body>
</html>