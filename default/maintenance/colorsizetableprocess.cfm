<cfparam name="status" default="">

<cfif form.mode eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
	 	 Select * from iccolor2 
	 	 where colorno = '#form.colorno#' and  colorid2 = '#form.colorid2#'
 	</cfquery>
  	
	<cfif checkitemExist.recordcount gt 0 >
		<cfoutput>
      		<h3><font color="##FF0000">Error, This record ("#form.colorno# - #form.colorid2#") Already Exist.</font></h3>
			<script language="javascript" type="text/javascript">
				alert("Error, This record #form.colorno# - #form.colorid2# Already Exist.");
				javascript:history.back();
				javascript:history.back();
			</script>
	    </cfoutput> 
    	<cfabort>
	</cfif>
	
	<cfquery name="insert" datasource="#dts#">
		insert into iccolor2
		(colorno,colorid2,desp,
		<cfloop from="1" to="20" index="i">
			size#i#,
		</cfloop>
		created_by,created_on,updated_by,updated_on 
		)
		values
		('#form.colorno#','#form.colorid2#','#form.desp#',
		<cfloop from="1" to="20" index="i">
			'#Evaluate("form.size#i#")#',
		</cfloop>
		'#HUserID#',#now()#,'#HUserID#',#now()#
		)
	</cfquery>
	
	<cfset status="The #form.colorno# - #form.colorid2# had been successfully created. ">

<cfelse>
	<cfquery datasource='#dts#' name="checkitemExist">
	 	 Select * from iccolor2 
	 	 where colorno = '#form.colorno#' 
	 	 and colorid2 = '#form.colorid2#'
 	</cfquery>
		
	<cfif checkitemExist.recordcount GT 0>
		<cfif form.mode eq "Delete">
			<cfquery datasource='#dts#' name="deleteitem">
				Delete from iccolor2
				where colorno = '#form.colorno#' 
	 	 		and colorid2 = '#form.colorid2#'
			</cfquery>
				
			<cfset status="The #form.colorno# - #form.colorid2# had been successfully deleted. ">	
		</cfif>
			
		<cfif form.mode eq "Edit">
			<cfquery name="update" datasource="#dts#">
				update iccolor2
				set desp = '#form.desp#',
				<cfloop from="1" to="20" index="i">
					size#i# = '#Evaluate("form.size#i#")#',
				</cfloop>
				updated_by = '#HUserID#',
				updated_on = #now()#
				where colorno = '#form.colorno#' 
	 	 		and colorid2 = '#form.colorid2#'
			</cfquery>
			
			<cfset status="The #form.colorno# - #form.colorid2# had been successfully edited. ">
		</cfif>
				
	<cfelse>		
		<cfset status="Sorry, the #form.colorno# - #form.colorid2# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>

<cfoutput>
	<form name="done" action="s_colorsizetable.cfm?type=Icitem&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>