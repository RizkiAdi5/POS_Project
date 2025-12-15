<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<cfparam name="status" default="">
<cfif #form.mode# eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
	 	 Select * from shipvia where shipvia = '#form.shipvia#' 
 	 </cfquery>
  	<cfif checkitemExist.recordcount GT 0 >
		<cfoutput>
      		<h3><font color="##FF0000">Error, This Ship Via ("#form.shipvia#") has been created already.</font></h3>
	    </cfoutput> 
    	<cfabort>
	</cfif>
	
	<cfquery name="insert" datasource="#dts#">
		insert into shipvia values ('#shipvia#','#desp#')
	</cfquery>
	
	<cfset status="The Ship Via, #form.shipvia# had been successfully created. ">

<cfelse>

		<cfquery datasource='#dts#' name="checkitemExist">
			Select * from shipvia where shipvia='#form.shipvia#'
		</cfquery>
		
		<cfif checkitemExist.recordcount GT 0 >
		
				<cfif #form.mode# eq "Delete">
						<cfquery datasource='#dts#' name="deleteitem">
								Delete from shipvia where shipvia='#form.shipvia#'
						</cfquery>
						<cfset status="The Ship Via, #form.shipvia# had been successfully deleted. ">	
								
				</cfif>
				<cfif #form.mode# eq "Edit">
					<cfquery name="update" datasource="#dts#">
						update shipvia set desp = '#form.desp#'
						where shipvia = '#form.shipvia#'
					</cfquery>										

					<cfset status="The Ship Via, #form.shipvia# had been successfully edited. ">
				</cfif>
				
		<cfelse>		
			<cfset status="Sorry, the Ship Via, #form.shipvia# was ALREADY removed from the system. Process unsuccessful.">
		</cfif>
</cfif>
<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->

<cfoutput>
	<form name="done" action="shipviaS.cfm?type=shipvia&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>