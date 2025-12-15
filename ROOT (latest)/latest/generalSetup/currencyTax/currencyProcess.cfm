<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1892, 100, 785, 9, 1893, 101">
<cfinclude template="/latest/words.cfm">

<cfif IsDefined('url.currcode')>
	<cfset URLcurrcode = trim(urldecode(url.currcode))>
</cfif>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT currcode 
            FROM #target_currency#
			WHERE currcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Currency)#">
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.currency)# already exist!');
				window.open('/latest/generalSetup/currencyTax/currency.cfm?action=create','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createCurrency" datasource="#dts#">
					INSERT INTO #target_currency# (currcode,currency,currency1,currency2,<cfloop index="i" from="1" to="18">currP#i#,</cfloop>currrate)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currcode)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currency)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currency1)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currency2)#">,
                        <cfloop index="i" from="1" to="18">
                        	<cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(evaluate('form.currP#i#')))#">,	
                        </cfloop>
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.currRate))#">
					)
				</cfquery>
				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.currency)#!\nError Message: #cfcatch.message#');
						window.open('/latest/generalSetup/currencyTax/currency.cfm?action=create','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.currency)# has been created successfully!');
				window.open('/latest/generalSetup/currencyTax/currencyProfile.cfm','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
		<cftry>
			<cfquery name="updateCurrency" datasource="#dts#">
				UPDATE #target_currency#
				SET
					currcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currcode)#">,
					currency = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currency)#">,
                    currency1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currency1)#">,
                   	currency2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currency2)#">,
                    <cfloop index="i" from="1" to="18">
                    	currP#i# = <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(evaluate('form.currP#i#')))#">,	
                    </cfloop>
                    currRate = <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.currRate))#">   
				WHERE currcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currcode)#">;
			</cfquery>
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.currency)#!\nError Message: #cfcatch.message#');
				window.open('/latest/generalSetup/currencyTax/currency.cfm?action=update&currcode=#form.currcode#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.currency)# successfully!');
			window.open('/latest/generalSetup/currencyTax/currencyProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteCurrency" datasource="#dts#">
				DELETE FROM #target_currency#
				WHERE currcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcurrcode#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLcurrcode#!\nError Message: #cfcatch.message#');
					window.open('/latest/generalSetup/currencyTax/currencyProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLcurrcode# successfully!');
			window.open('/latest/generalSetup/currencyTax/currencyProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printCurrency" datasource="#dts#">
			SELECT currcode,currency,currency1
			FROM #target_currency#
			ORDER BY currcode;
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Currency Listing</title>
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
			<h1 class="text">#words[1892]#</h1>
			<p class="lead">#words[100]#: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>#words[785]#</th>
					<th>#words[9]#</th>
                    <th>#words[1893]#</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printCurrency">
				<tr>
					<td>#currcode#</td>
					<td>#currency#</td>
					<td>#currency1#</td>
				</tr>
				</cfloop>
			</tbody>
		</table>
		</div>
		<div class="panel-footer">
		<p>#words[101]# #DateFormat(Now(),'dd-mm-yyyy')#, #TimeFormat(Now(),'HH:MM:SS')#</p>
		</div>
		</div>		
		
		</body>
		</html>
	<cfelse>
		<script type="text/javascript">
			window.open('/latest/generalSetup/currencyTax/currencyProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/generalSetup/currencyTax/currencyProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>