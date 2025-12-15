<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfparam name="status" default="">
<cfif #form.mode# eq "Create">
<!--- 	<cfinsert datasource='#dts#' tablename="comments" formfields="code,desp,details"> --->
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from comments where code='#form.code#'
	</cfquery>
		
	<cfif checkitemExist.recordcount GT 0 >		
    	<h3>Error. This comment code has been created already.</h3>
		<cfabort>
	</cfif>
	
	<cfset status="The Comment, #form.code# had been successfully created. ">

	<cfquery datasource="#dts#" name="insertartran">
		Insert into comments values ('#form.code#', '#form.desp#', '#form.details#')
	</cfquery>

<cfelse>

		<cfquery datasource='#dts#' name="checkitemExist">
			Select * from comments where code='#form.code#'
		</cfquery>
		
		<cfif checkitemExist.recordcount GT 0 >
		
				<cfif #form.mode# eq "Delete">
						<cfquery datasource='#dts#' name="deleteitem">
								Delete from comments where code='#form.code#'
						</cfquery>
						<cfset status="The Comment, #form.code# had been successfully deleted. ">	
								
				</cfif>
				<cfif #form.mode# eq "Edit">
					
					<cfquery datasource='#dts#' name="updateartran">
						Update comments set desp ='#form.desp#', details = '#form.details#'
						where code = '#form.code#' 
					</cfquery>						

						<cfset status="The Comment, #form.code# had been successfully edited. ">
				</cfif>
				
		<cfelse>		
			<cfset status="Sorry, the comment, #form.code# was ALREADY removed from the system. Process unsuccessful.">
		</cfif>
</cfif>
<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->

<cfoutput>
	<form name="done" action="s_commenttable.cfm?type=comments&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>