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
		select userid,username from users where userbranch='#dts#'
       	and usergrpid !='super'
</cfquery>
	
<cfquery datasource="#dts#" name="getbill">
	select refno from artran where (type = 'INV' or type = 'CS') and fperiod <> '99' order by refno
</cfquery>

<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<cfquery name="getcust" datasource="#dts#" >
	select custno, name from #target_arcust# order by <cfif getdealer_menu.custSuppSortBy neq "">#getdealer_menu.custSuppSortBy#<cfelse>custno</cfif>
</cfquery> 
	
<cfset pageTitle = "Daily Sales Report">


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

	<cfinclude template="/latest/filter/filterLocation.cfm">
    <cfinclude template="/latest/filter/filterItem.cfm">
	<cfinclude template="/latest/filter/filterJob.cfm">
	<cfinclude template="/latest/filter/filterProject.cfm">
    <cfinclude template="/latest/filter/filterCustomer.cfm">

	<cfinclude template="/latest/date/datePickerFunction.cfm">

</head>

<body class="container">
<cfoutput>
	<cfform class="formContainer form3Button" name="salestype" id="salestype" action="salesreportitem2.cfm" method="post" target="_blank">
		<div>#pageTitle#</div>
        <div>
            <table> 
				<tr> 
                <input type="hidden" name="tran" id="tran" value="#target_arcust#" /><input type="hidden" name="fromto" id="fromto" value="" />
					<th><label for="refno">Ref No.</label></th>			
					<td>
						<select name="billfrom" id="billfrom">                     
							<option value="">[FROM] - Choose a Reference No.</option>
							<cfloop query="getbill">
								<option value="#refno#">#refno#</option>
							</cfloop>
						</select>
						<select name="billto" id="billto">
							<option value="">[TO] - Choose a Reference No.</option>
							<cfloop query="getbill">
								<option value="#refno#">#refno#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr> 
					<th><label for="customer">Customer</label></th>			
					<td>
						<select name="custfrom" id="custfrom">                     
							<option value="">[FROM] - Choose a Customer</option>
							<cfloop query="getcust">
								<option value="#custno#">#custno# - #name#</option>
							</cfloop>
						</select>
						<select name="custto" id="custto">
							<option value="">[TO] - Choose a Customer</option>
							<cfloop query="getcust">
								<option value="#custno#">#custno# - #name#</option>
							</cfloop>
						</select>
					</td>
				</tr>
               <!--- <tr> 
					<th><label for="customer">Customer</label></th>			
					<td>
						<input type="hidden" id="custfrom" name="custfrom" class="customerFilter" data-placeholder="[FROM] - Choose a Customer"/>
						<input type="hidden" id="custto" name="custto" class="customerFilter" placeholder="[TO] - Choose a Customer" />
					</td>
				</tr>  ---> 
				<tr> 
					<th><label for="item">Item No.</label></th>			
					<td>
						<input type="hidden" id="itemfrom" name="itemfrom" class="itemFilter" data-placeholder="[FROM] - Choose an Item"/>
						<input type="hidden" id="itemto" name="itemto" class="itemFilter" placeholder="[TO] - Choose an Item" />
					</td>
				</tr>   
				<tr> 
					<th><label for="project">Project</label></th>			
					<td>
						<input type="hidden" id="projectfrom" name="projectfrom" class="projectFilter" data-placeholder="[FROM] - Choose a Project"/>
						<input type="hidden" id="projectto" name="projectto" class="projectFilter" placeholder="[TO] - Choose a Project" />
					</td>
				</tr>   
				<tr> 
					<th><label for="job">Job</label></th>			
					<td>
						<input type="hidden" id="jobfrom" name="jobfrom" class="jobFilter" data-placeholder="[FROM] - Choose a Job"/>
						<input type="hidden" id="jobto" name="jobto" class="jobFilter" placeholder="[TO] - Choose a Job" />
					</td>
				</tr>   
				 <tr> 
					<th><label for="location">Location</label></th>			
					<td>
						<input type="hidden" id="locfrom" name="locfrom" class="locationFilter" data-placeholder="[FROM] - Choose a Location" />
						<input type="hidden" id="locto" name="locto" class="locationFilter" data-placeholder="[TO] - Choose a Location" />
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