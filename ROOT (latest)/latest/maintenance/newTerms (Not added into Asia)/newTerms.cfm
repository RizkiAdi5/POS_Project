<cfif IsDefined('url.id')>
	<cfset URLid = trim(urldecode(url.id))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create New Terms Profile">
		<cfset pageAction="Create">
        <cfset id = "">
		<cfset billType = "">
        <cfset desp = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update New Terms Profile">
		<cfset pageAction="Update">
		<cfquery name="getCategory" datasource='#dts#'>
            SELECT * 
            FROM termsAndConditions 
            WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLid#">;
		</cfquery>
		<cfset id = getCategory.id>
 		<cfset billType = getCategory.billType>    
        <cfset desp = getCategory.desp>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete New Terms Profile">
		<cfset pageAction="Delete">   
        
		<cfquery name="getCategory" datasource='#dts#'>
            SELECT * 
            FROM termsAndConditions 
            WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLid#">;
		</cfquery>
		<cfset id = getCategory.id>
		<cfset billType = getCategory.billType>
        <cfset desp = getCategory.desp>   
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
</head>

<body class="container">
<cfoutput>
<form class="formContainer form2Button" action="/latest/maintenance/newTerms/newTermsProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('category').disabled=false";>
	<div>#pageTitle#</div>
	<div>
		<table>
        	<input type="hidden" id="id" name="id" value="#id#" />
			<tr>
				<th><label for="billType">Bill Type</label></th>
				<td>
                	<select id="billType" name="billType">
                    	<option value="">Choose a Bill Type</option>
                    	<option value="PO" <cfif billType EQ "PO">selected</cfif>>Purchase Order</option>
                      	<option value="PR" <cfif billType EQ "PR">selected</cfif>>Purchase Return</option>
                        <option value="RC" <cfif billType EQ "RC">selected</cfif>>Purchase Receive</option>
                        <option value="QUO" <cfif billType EQ "QUO">selected</cfif>>Quotation</option>
                        <option value="SO" <cfif billType EQ "SO">selected</cfif>>Sales Order</option>
                        <option value="DO" <cfif billType EQ "DO">selected</cfif>>Delivery Order</option>
                        <option value="INV" <cfif billType EQ "INV">selected</cfif>>Invoice</option>
                        <option value="CS" <cfif billType EQ "CS">selected</cfif>>Cash Sales</option>
                        <option value="DN" <cfif billType EQ "DN">selected</cfif>>Debit Note</option>
                        <option value="CN" <cfif billType EQ "CN">selected</cfif>>Credit Note</option>
                        <option value="SAM" <cfif billType EQ "SAM">selected</cfif>>Sample</option>
                        <option value="ISS" <cfif billType EQ "ISS">selected</cfif>>Issue</option>
                        <option value="OAI" <cfif billType EQ "OAI">selected</cfif>>Adjustment Increase</option>
                        <option value="OAR" <cfif billType EQ "OAR">selected</cfif>>Adjustment Reduce</option>
                        <option value="TR" <cfif billType EQ "TR">selected</cfif>>Transfer</option>
                    </select>                    	
                </td>
			</tr>
			<tr>
				<th><label for="desp">Description</label></th>
				<td><textarea name="desp" cols="80" rows="8" class="form-control input-sm" id="desp">#desp#</textarea>             
                </td>
			</tr> 
		</table>
	</div>
	<div>
		<input type="submit" value="#pageAction#" />
		<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/newTerms/newTermsProfile.cfm'" />
	</div>
</form>
</cfoutput>
</body>
</html>