<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfparam name="status" default="">

<cfif form.mode eq "Create">
	<cfquery datasource='#dts#' name="checkagentExist">
 	 	Select * from business where business='#form.business#' 
 	 </cfquery>
  	
	<cfif checkagentExist.recordcount gt 0>
    	<h3><font color="#FF0000">Error, This Business Has Been Created Already.</font></h3>
		<cfabort>
	</cfif>
	
	<cfquery datasource='#dts#' name="checknameExist">
		Select * from business where desp='#form.desp#'
	</cfquery>
	
	<cfif checknameExist.recordcount GT 0 >
    	<h3><font color="#FF0000">Error, This Business Description has been created already.</font></h3>
		<cfabort>
	</cfif>
	
	<cfinsert datasource='#dts#' tablename="business" formfields="business,desp,pricelvl">
	
	<cfset status="The Business, #form.business# had been successfully created. ">

<cfelse>
	<cfquery datasource='#dts#' name="checkitemExist">
		select * from business where business='#form.business#'
	</cfquery>
	
	<cfif checkitemExist.recordcount GT 0>
		<cfif form.mode eq "Delete">
			<cfquery name="checktranexist" datasource="#dts#">
				select custno from artran where custno=(select custno from #target_arcust# where business='#form.business#') 
				or custno=(select custno from #target_apvend# where business='#form.business#')
			</cfquery>
			
			<cfif checktranexist.recordcount gt 0>
				<h3>You have created transaction for this business. You are not allowed to delete this business.</h3>					
				<cfabort>
			</cfif>
			
			<cfquery datasource='#dts#' name="deleteitem">
				Delete from business where business='#form.business#'
			</cfquery>
			
			<cfset status="The business, #form.business# had been successfully deleted. ">	
		</cfif>
		
		<cfif form.mode eq "Edit">
			<cfupdate datasource='#dts#' tablename="business" formfields="business,desp,pricelvl">
			<cfset status="The business, #form.business# had been successfully edited. ">
		</cfif>
				
	<cfelse>		
		<cfset status="Sorry, the business, #form.business# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>
<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->

<cfoutput>
	<form name="done" action="s_businesstable.cfm?type=business&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>