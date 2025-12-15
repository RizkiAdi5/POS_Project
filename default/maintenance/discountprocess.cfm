<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfparam name="status" default="">
<cfif form.mode eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
 	 	Select * from discount where discount = #val(form.discount)#
 	 </cfquery>
  	<cfif checkitemExist.recordcount GT 0>
		<cfoutput>
      		<h3><font color="##FF0000">Error, This Discount ("#form.discount#") has been created already.</font></h3>
	    </cfoutput> 
    	<cfabort>
	</cfif>
	
	<!--- <cfinsert datasource='#dts#' tablename="discount" formfields="discount,desp"> --->
	<cfquery name="insert" datasource="#dts#">
		insert into discount
		(discount,desp)
		values
		(#val(form.discount)#,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">)
	</cfquery>
	<cfset status="The Discount, #form.discount# had been successfully created. ">
<cfelse>
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from discount where discount=#val(form.discount)#
	</cfquery>
		
	<cfif checkitemExist.recordcount GT 0>
		<cfif form.mode eq "Delete">
			<cfquery datasource='#dts#' name="deleteitem">
				Delete from discount where discount=#val(form.discount)#
			</cfquery>
			<cfset status="The Discount, #form.discount# had been successfully deleted. ">	
		</cfif>
		<cfif form.mode eq "Edit">
			<cfquery name="update" datasource="#dts#">           
				Update discount
				set desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desp#">

				where discount=#val(form.discount)#
                </cfquery>                      
			<cfset status="The Discount , #form.discount# had been successfully edited. ">
		</cfif>
	<cfelse>		
		<cfset status="Sorry, the Discount, #form.discount# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>

<cfoutput>
	<form name="done" action="s_discounttable.cfm?type=discount&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>