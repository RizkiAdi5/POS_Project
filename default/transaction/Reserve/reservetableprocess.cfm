<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfparam name="status" default="">

<cfif form.mode eq "Create">
	<cfquery name="checkexist" datasource="#dts#">
    select * from reserve where reserveno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reserveno#">
    </cfquery>
    <cfif checkexist.recordcount eq 0>
    <cfquery name="insertpackcode" datasource="#dts#">
    insert into reserve (reserveno,name,phone,email,note,grossamt,location) values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reserveno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.note#">,'#val(grossamt)#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.location#">)
    </cfquery>
    
    <cfelse>
    <cfquery name="updatepackcode" datasource="#dts#">
    update reserve set name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
    phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
    email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
    note=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.note#">,
    location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.location#">
    ,grossamt='#val(grossamt)#' where reserveno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reserveno#">
    </cfquery>
    </cfif>
    
    <cfquery name="updatepackcodedet" datasource="#dts#">
    update reservedet set
    location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.location#">
    where reserveno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reserveno#">
    </cfquery>
	
	<cfset status="The Reserve, #form.reserveno# Has Been Created successfully !">

<cfelse>
	<cfswitch expression="#form.mode#">
		<cfcase value="Delete">
			<cftry>
				<cfquery datasource='#dts#' name="deletePackage">
					Delete from reserve where reserveno='#form.reserveno#'
				</cfquery>
                
                <cfquery datasource='#dts#' name="deletedeposit">
					Delete from deposit where depositno='#form.reserveno#'
				</cfquery>
                
                <cfquery datasource='#dts#' name="deletePackage">
					Delete from reservedet where reserveno='#form.reserveno#'
				</cfquery>
				<cfcatch type="database">
					<cfset status="Sorry, The Reserve, #form.reserveno# was Removed From The System !">
					<p align="center"><input type="button" name="Back" value="Back" onClick="javascrip:history.back()"></p>
					<cfabort>
				</cfcatch>
			</cftry>
			
			<cfset status="The Reserve, #form.reserveno# Has Been Deleted Successfully!">
		</cfcase>
		<cfcase value="Edit">
			<cfquery name="updatereserve" datasource="#dts#">
            update reserve set name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
            phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
            email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
            note=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.note#">
            ,grossamt='#val(grossamt)#' ,
            status=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.status#">
            where reserveno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reserveno#">
            
            </cfquery>
            
            <cfquery name="updatereservedet" datasource="#dts#">
            update reservedet set
            status=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.status#">
            where reserveno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.reserveno#">
            
            </cfquery>
            
			<cfset status="The Reserve, #form.reserveno# Has Been Edited Successfully!">
		</cfcase>
	</cfswitch>
</cfif>

<cfoutput>
	<form name="done" action="s_reservetable.cfm?type=reserve&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
<cfif form.express eq 1>
<cfoutput>
window.opener.document.getElementById('refno2').value='#form.reserveno#';
</cfoutput>
window.close();
<cfelse>
	done.submit();
</cfif>
</script>