<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<cfparam name="status" default="">

<cfif form.mode eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
 	 	Select * from Supervisor where Supervisorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Supervisor#">
 	 </cfquery>
  	<cfif checkitemExist.recordcount GT 0>
		<cfoutput>
      		<h3><font color="##FF0000">Error, This Supervisor ("#form.Supervisorid#") has been created already.</font></h3>
	    </cfoutput> 
    	<cfabort>
	</cfif>
	
	<!--- <cfinsert datasource='#dts#' tablename="brand" formfields="Supervisor,name,password"> --->
	<cfquery name="insert" datasource="#dts#">
		insert into Supervisor
		(Supervisorid,name,password<cfif lcase(HComID) eq "ugateway_i">,rangeForDisc,dispec</cfif>)
		values
		(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Supervisor#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.password#">	)	
	</cfquery>
	<cfset status="The Supervisor, #form.Supervisor# had been successfully created. ">
<cfelse>
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from Supervisor where Supervisorid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Supervisorid#">
	</cfquery>
		
	<cfif checkitemExist.recordcount GT 0>
		<cfif form.mode eq "Delete">
			<cfquery datasource='#dts#' name="deleteitem">
				Delete from Supervisor where Supervisorid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Supervisorid#">
			</cfquery>
			<cfset status="The Supervisor, #form.Supervisorid# had been successfully deleted. ">	
		</cfif>
		<cfif form.mode eq "Edit">
			<cfquery name="update" datasource="#dts#">
           
				Update Supervisor
				set name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
                Password=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.password#">
                <cfif lcase(HComID) eq "ugateway_i">
					,rangeForDisc='#val(form.rangeForDisc)#'
					,dispec='#val(form.dispec)#'
				</cfif>
				where Supervisorid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Supervisorid#">
                

                
                			</cfquery>
                            
                            
			<cfset status="The Supervisor , #form.Supervisorid# had been successfully edited. ">
		</cfif>
	<cfelse>		
		<cfset status="Sorry, the Supervisor, #form.Supervisorid# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>

<cfoutput>
	<form name="done" action="s_Supervisortable.cfm?type=Supervisor&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>