<cfparam name="status" default="">
<cfif form.sercost eq "">
<cfset form.sercost = 0>
</cfif>
<cfif form.serprice eq "">
<cfset form.serprice = 0>
</cfif>
<cfif form.mode eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
	 	 Select * from icservi where servi = '#form.servi#' 
 	</cfquery>
  	
	<cfif checkitemExist.recordcount GT 0 >
		<h3><font color="##FF0000">Error, This Service ("<cfoutput>#form.servi#</cfoutput>") has been created already.</font></h3>
		<cfabort>
	</cfif>
	
	<cfinsert datasource='#dts#' tablename="icservi" formfields="servi,desp,despa,salec,salecsc,salecnc,purc,purprc,sercost,serprice">

	<cfset status="The Service, #form.servi# had been successfully created. ">
<cfelse>
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from icservi where servi='#form.servi#'
	</cfquery>
	
	<cfif checkitemExist.recordcount GT 0 >
		<cfif form.mode eq "Delete">
			<cfquery datasource='#dts#' name="deleteitem">
				Delete from icservi where servi='#form.servi#'
			</cfquery>
			
			<cfset status="The Service, #form.servi# had been successfully deleted. ">	
		</cfif>
		
		<cfif form.mode eq "Edit">
			<cfquery name="update" datasource="#dts#">
				update icservi 
				set desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">,
				despa=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.despa#">,
				salec='#salec#',salecsc='#salecsc#',salecnc='#salecnc#',purc='#purc#',purprc='#purprc#',SERCOST='#form.SERCOST#',SERPRICE='#form.SERPRICE#' 
				where servi=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.servi#">
			</cfquery>
			
			<cfset status="The Service, #form.servi# had been successfully edited. ">
		</cfif>
	<cfelse>		
		<cfset status="Sorry, the Service, #form.servi# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>

<form name="done" action="s_servicetable.cfm?type=icservi&process=done" method="post">
	<input name="status" value="<cfoutput>#status#</cfoutput>" type="hidden">
</form>

<script>
	done.submit();
</script>