<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<cfparam name="status" default="">

<cfif form.mode eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from iclanguage where langno = '#form.langno#' 
	</cfquery>
  
	<cfif checkitemExist.recordcount GT 0 >
		<cfoutput>
	      <h3><font color="##FF0000">Error, This Language ("#form.langno#") has been created already.</font></h3>
		</cfoutput> 
	    <cfabort>
	</cfif>
	
	
		<cfquery datasource="#dts#" name="insertartran">
			Insert into iclanguage 
			(english,chinese)
			values 
			(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.english#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.chinese#">
            )
		</cfquery>
  	<cfset status="Language had been successfully created. ">
<cfelse>
  	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from iclanguage where langno='#form.langno#'
  	</cfquery>
		
  	<cfif checkitemExist.recordcount GT 0 >
		<cfif form.mode eq "Delete">
      		<cfquery datasource='#dts#' name="deleteitem">
	    		Delete from iclanguage where langno='#form.langno#'
	  		</cfquery>
	  		<cfset status="The Language had been successfully deleted. ">	
		</cfif>
		<cfif form.mode eq "Edit">

	  		
		  		<cfquery datasource='#dts#' name="updatelanguage">
					Update iclanguage 
					set english =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.english#">, 
					chinese =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.chinese#">
					where langno = '#form.langno#'
		  		</cfquery>

	  		<cfset status="The Language, #form.langno# had been successfully edited. ">
		</cfif>
  	<cfelse>		
		<cfset status="Sorry, the Language, #form.langno# was ALREADY removed from the system. Process unsuccessful.">
  	</cfif>
</cfif>
<cfoutput>

<form name="done" action="s_languagetable.cfm?type=language&process=done" method="post">
  <input name="status" value="#status#" type="hidden">
</form>
</cfoutput>

<script>
	done.submit();
</script>