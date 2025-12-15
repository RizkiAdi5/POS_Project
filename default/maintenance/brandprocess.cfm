<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfparam name="status" default="">
<cfif form.mode eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
 	 	Select * from brand where brand = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brand#">
 	 </cfquery>
  	<cfif checkitemExist.recordcount GT 0>
		<cfoutput>
      		<h3><font color="##FF0000">Error, This Brand ("#form.brand#") has been created already.</font></h3>
	    </cfoutput> 
    	<cfabort>
	</cfif>
	
	<!--- <cfinsert datasource='#dts#' tablename="brand" formfields="brand,desp"> --->
	<cfquery name="insert" datasource="#dts#">
		insert into brand
		(brand,desp<cfif lcase(HComID) eq "ugateway_i">,rangeForDisc,dispec</cfif>)
		values
		(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brand#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
		<cfif lcase(HComID) eq "ugateway_i">
			,'#val(form.rangeForDisc)#','#val(form.dispec)#'
		</cfif>)
	</cfquery>
	<cfset status="The Brand, #form.brand# had been successfully created. ">
<cfelse>
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from brand where brand=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brand#">
	</cfquery>
		
	<cfif checkitemExist.recordcount GT 0>
		<cfif form.mode eq "Delete">
			<cfquery datasource='#dts#' name="deleteitem">
				Delete from brand where brand=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brand#">
			</cfquery>
			<cfset status="The Brand, #form.brand# had been successfully deleted. ">	
		</cfif>
		<cfif form.mode eq "Edit">
			<cfquery name="update" datasource="#dts#">
				Update brand
				set desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">
				<cfif lcase(HComID) eq "ugateway_i">
					,rangeForDisc='#val(form.rangeForDisc)#'
					,dispec='#val(form.dispec)#'
				</cfif>
				where brand=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.brand#">
			</cfquery>
			<cfset status="The Brand, #form.brand# had been successfully edited. ">
		</cfif>
	<cfelse>		
		<cfset status="Sorry, the Brand, #form.brand# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>

<cfoutput>
	<form name="done" action="s_brandtable.cfm?type=brand&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>