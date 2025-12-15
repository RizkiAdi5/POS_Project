<cfoutput>
	<cfinvoke component="cfc.create_update_delete_term" method="amend_term" returnvariable="status1">
		<cfinvokeargument name="dts" value="#dts#">
		<cfinvokeargument name="dts1" value="#dts#">
		<cfinvokeargument name="hlinkams" value="#hlinkams#">
		<cfinvokeargument name="huserid" value="#huserid#">
		<cfinvokeargument name="form" value="#form#">
	</cfinvoke>
	
	<form name="done" action="s_Termtable.cfm?type=icterm&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
 	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	done.submit();
</script>	
	
<cfabort>
	
<cfif form.mode eq "Create">
  <cfquery datasource='#dts#' name="checkitemExist">
	Select * from #target_icterm# where term = '#form.term#' 
  </cfquery>
  
  <cfif checkitemExist.recordcount GT 0 >
    <cfoutput>
      <h3><font color="FF0000">Error, This Term ("#form.term#") has been created already.</font></h3>
	</cfoutput> 
    <cfabort>
  </cfif>
	
	<cfif Hlinkams eq "Y">
		<cfinsert datasource="#replace(dts,'_i','_a','all')#" tablename="icterm" formfields="term,desp,sign,days">
	<cfelse>
		<cfinsert datasource="#dts#" tablename="icterm" formfields="term,desp,sign,days">
	</cfif>
  
  <cfset status="The Term, #form.term# had been successfully created. ">

<cfelse>

  <cfquery datasource='#dts#' name="checkitemExist">
	Select * from #target_icterm# where term='#form.term#'
  </cfquery>
		
  <cfif checkitemExist.recordcount GT 0 >
    <cfif #form.mode# eq "Delete">
	  	<cfif Hlinkams eq "Y">
			<cfquery datasource="#replace(dts,'_i','_a','all')#" name="deleteitem">
				delete from icterm where term='#form.term#'
	  		</cfquery>
		<cfelse>
			<cfquery datasource='#dts#' name="deleteitem">
				delete from icterm where term='#form.term#'
	  		</cfquery>
		</cfif>
	  
	  <cfset status="The Term, #form.term# had been successfully deleted. ">	
	</cfif>
    
	<cfif #form.mode# eq "Edit">
     	 <cfif Hlinkams eq "Y">
		  <cfupdate datasource="#replace(dts,'_i','_a','all')#" tablename="icterm" formfields="term,desp,sign,days">
		<cfelse>
			 <cfupdate datasource='#dts#' tablename="icterm" formfields="term,desp,sign,days">
		</cfif>
							
      <cfset status="The Term, #form.term# had been successfully edited. ">
	</cfif>
			
  <cfelse>		
	<cfset status="Sorry, the Term, #form.term# was ALREADY removed from the system. Process unsuccessful.">
  </cfif>
</cfif>

<cfoutput>
  
</cfoutput>

