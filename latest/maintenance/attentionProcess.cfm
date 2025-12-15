<cfif IsDefined('url.attentionNo')>
	<cfset URLattentionNo = trim(urldecode(url.attentionNo))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT attentionno 
            FROM attention
			WHERE attentionno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.attentionNo)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.attentionNo)# already exist!');
				window.open('/latest/maintenance/attention.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createAttention" datasource="#dts#">
					INSERT INTO attention  (attentionno,salutation,name,customerno,c_phone,c_mobile,c_email,title2,designation,
                    					   	b_add1,b_add2,b_add3,b_add4,b_city,b_state,b_country,b_postalcode,
                    						o_add1,o_add2,o_add3,o_add4,o_city,o_state,o_country,o_postalcode,
                    						business,assistant,asst_phone,department,description,
                    						dob,contactgroup,category,commodity)
					VALUES

					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.attentionNo)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.salutation)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.name)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.customerNo)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.c_phone)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.c_mobile)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.c_email)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.title)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.designation)#">,
                        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add1)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add3)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.add4)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.city)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.state)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.country)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.postalCode)#">,
                        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add1)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add3)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_add4)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_city)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_state)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_country)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.d_postalcode)#">,
      
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.business)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.assistant)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.assistantPhone)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.department)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.description)#">,
                        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.dob)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.contactGroup)#">,
                 		<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.customerCategory)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.commodity)#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.attentionNo)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/attention.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.attentionNo)# has been created successfully!');
				window.open('/latest/maintenance/attentionProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
   		
		<cftry>
			<cfquery name="updateAttention" datasource="#dts#">
				UPDATE attention
				SET
					
                   	attentionno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.attentionNo#">,
                    salutation=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.salutation#">,
					name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
                    customerno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.customerNo#">,
                    c_phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.c_phone#">,
                    c_mobile=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.c_mobile#">,
                    c_email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.c_email#">,
                    title2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.title#">,
                    designation=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.designation#">,
                    
                    b_add1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">,
                    b_add2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">,
                    b_add3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add3#">,
                    b_add4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add4#">,
                    b_city=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.city#">,
                    b_state=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.state#">,
                    b_country=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.country#">,
                    b_postalcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.postalCode#">,
                                        
                    o_add1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_add1#">,
                    o_add2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_add2#">,
                    o_add3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_add3#">,
                    o_add4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_add4#">,
                    o_city=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_city#">,
                    o_state=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_state#">,
                    o_country=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_country#">,
                    o_postalcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.d_postalcode#">,
                    
                    business=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.business#">,
                    assistant=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.assistant#">,
                    asst_phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.assistantPhone#">,
                    department=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.department#">,
                    description=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.description#">,
                    
                    dob=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dob#">,
                    contactgroup=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contactGroup#">,						
					category=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.customerCategory#">,
                    commodity=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.commodity#">
                    
				WHERE attentionno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.attentionNo)#">;
			</cfquery>    
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.attentionNo)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/attention.cfm?action=update&attentionNo=#form.attentionNo#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.attentionNo)# successfully!');
			window.open('/latest/maintenance/attentionProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteAttention" datasource="#dts#">
				DELETE FROM attention
				WHERE attentionno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLattentionNo#">;
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLattentionNo#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/attentionProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLattentionNo# successfully!');
			window.open('/latest/maintenance/attentionProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printAttention" datasource="#dts#">
			SELECT attentionno,name,customerno
			FROM attention
			ORDER BY attentionno;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Attention Listing</title>
		<link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
		<!--[if lt IE 9]>
			<script type="text/javascript" src="/latest/js/html5shiv/html5shiv.js"></script>
			<script type="text/javascript" src="/latest/js/respond/respond.min.js"></script>
		<![endif]-->
		<script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
		</head>
		<body>
		
		<div class="container">
		<div class="page-header">
			<h1 class="text">Attention Listing</h1>
			<p class="lead">Company: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>ATTENTION</th>
					<th>NAME</th>
                    <th>CUSTOMERNO</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printAttention">
				<tr>
					<td>#attentionno#</td>
					<td>#name#</td>
                    <td>#customerno#</td>
				</tr>
				</cfloop>
			</tbody>
		</table>
		</div>
		<div class="panel-footer">
		<p>Printed at #DateFormat(Now(),'dd-mm-yyyy')#, #TimeFormat(Now(),'HH:MM:SS')#</p>
		</div>
		</div>		
		
		</body>
		</html>
	<cfelse>
		<script type="text/javascript">
			window.open('/latest/maintenance/attentionProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/attentionProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>