

<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<cfparam name="status" default="">
<cfif #form.mode# eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
	 	 Select * from info where title = '#form.title#' 
 	 </cfquery>
  	<cfif checkitemExist.recordcount GT 0 >
		<cfoutput>
      		<h3><font color="##FF0000">Error, This Update Title ("#form.title#") has been created already.</font></h3>
	    </cfoutput> 
    	<cfabort>
	</cfif>
	
	<cfquery name= "insertinfo" datasource='#dts#'>
	 Insert into info (type, title, desp,date)
     values ('#form.updatetype#' ,'#form.title#' ,'#form.desp#','#form.date#')
     </cfquery>
	
	<cfset status="The Update, #form.title# had been successfully created. ">

<cfelse>

		<cfquery datasource='#dts#' name="checkitemExist">
			Select * from info where title='#form.title#'
		</cfquery>
		
		<cfif checkitemExist.recordcount GT 0 >
		
				<cfif #form.mode# eq "Delete">
						
                                <cfquery datasource='#dts#' name="deleteitem">
								Delete from info where title='#form.title#'
						</cfquery>
						<cfset status="The Update, #form.title# had been successfully deleted. ">	
								
				</cfif>
				<cfif #form.mode# eq "Edit">
						<cfquery name= "editinfo" datasource='#dts#'>
	 update info set title = '#form.title#', type = '#form.updatetype#', desp = '#form.desp#', date = '#form.date#' where title = '#form.title#'
     </cfquery>						

						<cfset status="The Materail, #form.title# had been successfully edited. ">
				</cfif>
				
		<cfelse>		
			<cfset status="Sorry, the update, #form.title# was ALREADY removed from the system. Process unsuccessful.">
		</cfif>
</cfif>
<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->

<cfoutput>
	<form name="done" action="update.cfm?type=title&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>