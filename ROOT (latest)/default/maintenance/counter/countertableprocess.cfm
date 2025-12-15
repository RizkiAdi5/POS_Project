<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfparam name="status" default="">

<cfif form.mode eq "Create">
		<cfquery name="checkexist" datasource="#dts#">
        select counterid from counter where counterid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.counter#">
        </cfquery>
    
    <cfif checkexist.recordcount eq 0>
		<cfquery name="insertcounter" datasource="#dts#">
        INSERT INTO counter
        (counterid,counterdesp,bonduser,created_by,created_on)
        VALUES
        (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.counter#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bonduser#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#huserid#">,
        now()
        )
        </cfquery>
	<cfelse>
		<cfoutput>
			<script type="text/javascript">
            alert('The counter has existed');
            history.go(-1);
            </script>
        	<cfabort>
        </cfoutput>
        
    </cfif>
	<cfset status="The counter, #form.counter# Has Been Created successfully !">

<cfelse>
	<cfswitch expression="#form.mode#">
		<cfcase value="Delete">

				<cfquery datasource='#dts#' name="deletecounter">
					Delete from counter where counterid='#form.counter#'
				</cfquery>

			
			<cfset status="The Counter, #form.counter# Has Been Deleted Successfully!">
		</cfcase>
		<cfcase value="Edit">
			<cfquery name="updatecounter" datasource="#dts#">
            UPDATE counter SET
            counterdesp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
            bonduser = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bonduser#">
            WHERE counterid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.counter#">
            </cfquery>
            
			<cfset status="The counter, #form.counter# Has Been Edited Successfully!">
		</cfcase>
	</cfswitch>
</cfif>

<cfoutput>
	<form name="done" action="s_countertable.cfm?type=counter&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>