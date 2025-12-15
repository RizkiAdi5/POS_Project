<cfif IsDefined('url.serialno')>
	<cfset URLserialno = trim(urldecode(url.serialno))>
</cfif>
<cfif IsDefined('url.location')>
	<cfset URLlocation = trim(urldecode(url.location))>
</cfif>
<cfif IsDefined('url.itemno')>
	<cfset URLitemno = trim(urldecode(url.itemno))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create Serial No - Item #URLitemno#">
		<cfset pageAction="Create">
		<cfset location = "">
        <cfset date = "">
        <cfset quantity = "">
        <cfset URLlocation = "">
        <cfset URLserialno = "">
 
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Serial No - Item #URLitemno# ">
		<cfset pageAction="Update">
		<cfquery name="getSerialNo" datasource='#dts#'>
            SELECT * 
            FROM iserial 
            WHERE type = 'ADD'
         	AND serialno = '#URLserialno#'
            AND location = '#URLlocation#'
            AND itemno = '#URLitemno#'  	    
		</cfquery>
		
		<cfset location = getSerialNo.location>
        <cfset serialNo = getSerialNo.serialno>
        <cfset date = getSerialNo.wos_date>
        
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Serial No - Item #URLitemno#">
		<cfset pageAction="Delete">   
		<cfquery name="getSerialNo" datasource='#dts#'>
            SELECT * 
            FROM iserial 
            WHERE type = 'ADD'
         	AND serialno = '#URLserialno#'
            AND location = '#URLlocation#'
            AND itemno = '#URLitemno#'  	    
		</cfquery>
		
		<cfset location = getSerialNo.location>
        <cfset serialNo = getSerialNo.serialno>
        <cfset date = getSerialNo.wos_date>    
	</cfif>
    
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
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
    <cfinclude template="/latest/date/datePickerFunction4.cfm">
    
    
    <script type="text/javascript" >
		$(function () {
	
			var newFields = $('');
		
			$('#quantity').bind('blur keyup change', function() {
				var n = this.value || 0;
				if (n+1) {
					if (n > newFields.length) {
						addFields(n);
					} else {
						removeFields(n);
					}
				}
			});
		
			function addFields(n) {
				for (i = newFields.length; i < n; i++) {
					var input = $('<input type="text" id="serialNo'+i+'" name="serialNo'+i+'" placeholder="Serial No '+i+'"/>');
					var newInput = input.clone();
					newFields = newFields.add(newInput);
					newInput.appendTo('#newFields');
				}
			}
		
			function removeFields(n) {
				var removeField = newFields.slice(n).remove();
				newFields = newFields.not(removeField);
			}
		});
	</script>
    
    <style>
		#newFields input {
    		display:block;
		}
	</style>

</head>

<body class="container">
<cfoutput>
<form class="formContainer form2Button" action="/latest/maintenance/addSerialNoProcess.cfm?action=#url.action#&itemno=#URLitemno#&serialno=#URLserialno#&location=#URLlocation#" method="post" >
	<div>#pageTitle#</div>
	<div>
		<table>
			<tr>
				<th><label for="location">Location</label></th>
				<td>
                	<input type="hidden" id="location" name="location" class="locationFilter" data-placeholder="Choose a Location" required="yes" />
                </td>
			</tr> 
            <tr>
				<th><label for="date">Date</label></th>
				<td>
                	<input type="text" name="date" id="date" maxlength="10" size="10" value="#DateFormat(date,'DD/MM/YYYY')#" placeholder="Choose a Date" readonly="readonly" />                  
                </td>
			</tr>
            <cfif IsDefined("url.action") AND url.action NEQ "create" >
                <tr>
                    <th><label for="serialNo">Serial No</label></th>
                    <td>
                        <input type="text" id="serialNo" name="serialNo" value="#serialNo#" placeholder="Serial No" />
                    </td>
                </tr> 
            <cfelse>
                <tr>
                    <th><label for="quantity">Quantity</label></th>
                    <td>
                        <input type="text" id="quantity" name="quantity" value="#quantity#" placeholder="Quantity E.g 100"  required="yes" />                     
                    </td>
                </tr>
            </cfif> 

            <tr>
            	<th><label for=""></label></th>
                <td>
                	<div id="newFields"></div>
                </td>    
            </tr>
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/editSerialNoOpeningQty.cfm'" />
	</div>
</form>
</cfoutput>
</body>
</html>