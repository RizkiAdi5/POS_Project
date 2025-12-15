<cfparam name="status" default="">

<cfif form.mode eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
	 	 Select * from title 
	 	 where title_id = '#form.title_id#'
 	</cfquery>
  	
	<cfif checkitemExist.recordcount gt 0 >
		<cfoutput>
      		<h3><font color="##FF0000">Error, This record ("#form.title_id#") Already Exist.</font></h3>
			<script language="javascript" type="text/javascript">
				alert("Error, This record #form.title_id# Already Exist.");
				javascript:history.back();
				javascript:history.back();
			</script>
	    </cfoutput> 
    	<cfabort>
	</cfif>
	
	<cfquery name="insert" datasource="#dts#">
		insert into title
		(title_id,desp)
		values
		('#form.title_id#','#form.desp#')
	</cfquery>
	
	<cfset status="The #form.title_id# had been successfully created. ">

<cfelse>
	<cfquery datasource='#dts#' name="checkitemExist">
	 	 Select * from title 
	 	 where title_id = '#form.title_id#'
 	</cfquery>
		
	<cfif checkitemExist.recordcount GT 0>
		<cfif form.mode eq "Delete">
			<cfquery datasource='#dts#' name="deleteitem">
				Delete from title
				where title_id = '#form.title_id#'
			</cfquery>
				
			<cfset status="The #form.title_id# had been successfully deleted. ">	
		</cfif>
			
		<cfif form.mode eq "Edit">
			<cfquery name="update" datasource="#dts#">
				update title
				set desp = '#form.desp#'
				where title_id = '#form.title_id#'
			</cfquery>
			
			<cfset status="The #form.title_id# had been successfully edited. ">
		</cfif>
				
	<cfelse>		
		<cfset status="Sorry, the #form.title_id# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>

<cfoutput>
	<form name="done" action="s_titletable.cfm?process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>