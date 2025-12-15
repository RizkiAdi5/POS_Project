<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1913, 100, 56, 65, 1900,, 1910, 1914, 101">
<cfinclude template="/latest/words.cfm">

<cfif IsDefined('url.entryno')>
	<cfset URLtax = trim(urldecode(url.entryno))>
</cfif>

<cfif hlinkams eq "Y">
	<cfset dts = replace(LCASE(dts),'_i','_a','all')> 
<cfelse>
	<cfset dts = dts>
</cfif>


<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
        <cftry>
            <cfquery name="createTax" datasource="#dts#">
                INSERT INTO #target_taxtable# (code,desp,rate1,tax_type,tax_type2,corr_accno,currcode)
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.taxCode)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.rate1)/100#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.taxType)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.taxType2)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.customerNo)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currcode)#">    
                )
            </cfquery>
        <cfcatch type="any">
            <script type="text/javascript">
                alert('Failed to create #trim(form.taxCode)#!\nError Message: #cfcatch.message#');
                window.open('/latest/generalSetup/currencyTax/tax.cfm?action=create','_self');
            </script>
        </cfcatch>
        </cftry>
        <script type="text/javascript">
            alert('#trim(form.taxCode)# has been created successfully!');
            window.open('/latest/generalSetup/currencyTax/taxProfile.cfm','_self');
        </script>
	<cfelseif url.action EQ "update">
		<!--- <cftry> --->
			<cfquery name="updateCategory" datasource="#dts#">
				UPDATE #target_taxtable#
				SET
                    code= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.taxCode)#">,
                    desp= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                    rate1= <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(form.rate1)/100#">,
                    tax_type= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.taxType)#">,
                    tax_type2= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.taxType2)#">,
                    corr_accno= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.customerNo)#">,
					currcode= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.currcode)#">   
          		WHERE entryno =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.entryNo)#">;
			</cfquery>
		<!--- <cfcatch type="any"> 
			<script type="text/javascript">
				alert('Failed to update #trim(form.taxCode)#!\nError Message: #cfcatch.message#');
				window.open('/latest/generalSetup/currencyTax/tax.cfm?action=update&entryno=#form.entryNo#','_self');
			</script>
		</cfcatch>
		</cftry> --->
		<script type="text/javascript">
			alert('Updated #trim(form.taxCode)# successfully!');
			window.open('/latest/generalSetup/currencyTax/taxProfile.cfm','_self');
		</script>	
	<cfelseif url.action EQ "delete">
		<cftry>
			<cfquery name="deleteCategory" datasource="#dts#">
				DELETE FROM #target_taxtable#
				WHERE entryno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLtax#">;
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLtax#!\nError Message: #cfcatch.message#');
					window.open('/latest/generalSetup/currencyTax/taxProfile.cfm','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLtax# successfully!');
			window.open('/latest/generalSetup/currencyTax/taxProfile.cfm','_self');
		</script>
	<cfelseif url.action EQ "print">
    
		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro 
            FROM gsetup;
		</cfquery>
        
		<cfquery name="printTax" datasource="#dts#">
			SELECT entryno,code,desp,rate1,tax_type,corr_accno 
			FROM #target_taxtable#
			ORDER BY entryno
		</cfquery>
        		
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title>Tax Listing</title>
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
			<h1 class="text">#words[1913]#</h1>
			<p class="lead">#words[100]#: #getGsetup.compro#</p>
		</div>
        
		<div class="table-responsive">
		<table class="table table-hover">
			<thead>
				<tr>
					<th>#words[56]#</th>
					<th>#words[65]#</th>
					<th>#words[1900]#</th>
					<th>#words[1910]#</th>
					<th>#words[1914]#</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="printTax">
				<tr>
					<td>#code#</td>
					<td>#desp#</td>
					<td>#rate1#</td>
					<td>#tax_type#</td>
					<td>#corr_accno#</td>
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
			window.open('/latest/generalSetup/currencyTax/taxProfile.cfm','_self');
		</script>		
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/generalSetup/currencyTax/taxProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>