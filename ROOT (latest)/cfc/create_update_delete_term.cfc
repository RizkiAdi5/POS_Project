<cfcomponent>
	<cfparam name="form.status" default="">
	
	<cffunction name="amend_term" returntype="any">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="hlinkams" required="yes" type="any">
		<cfargument name="huserid" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		
		<cfif hlinkams eq "Y">
			<cfset arguments.dts1 = replace(arguments.dts1,"_i","_a","all")>
		</cfif>
				
		<cfswitch expression="#form.mode#">
			<cfcase value="create">
				<cfinvoke component="cfc.create_update_delete_term" method="create_term" returnvariable="status1">
					<cfinvokeargument name="dts" value="#arguments.dts#">
					<cfinvokeargument name="dts1" value="#arguments.dts1#">
					<cfinvokeargument name="huserid" value="#arguments.huserid#">
					<cfinvokeargument name="form" value="#arguments.form#">
				</cfinvoke>
			</cfcase>
			<cfcase value="edit">
				<cfinvoke component="cfc.create_update_delete_term" method="edit_term" returnvariable="status1">
					<cfinvokeargument name="dts" value="#arguments.dts#">
					<cfinvokeargument name="dts1" value="#arguments.dts1#">
					<cfinvokeargument name="huserid" value="#arguments.huserid#">
					<cfinvokeargument name="form" value="#arguments.form#">
				</cfinvoke>
			</cfcase>
			<cfcase value="delete">
				<cfinvoke component="cfc.create_update_delete_term" method="delete_term" returnvariable="status1">
					<cfinvokeargument name="dts" value="#arguments.dts#">
					<cfinvokeargument name="dts1" value="#dts1#">
					<cfinvokeargument name="form" value="#arguments.form#">
				</cfinvoke>
			</cfcase>
		</cfswitch>
		<cfreturn status1>
	</cffunction>
	
	<cffunction name="create_term" returntype="any">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="huserid" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		
		<cftry>
			<cfquery name="checktermExist" datasource="#dts#">
				Select term 
				from #form.target_icterm#
				where term='#jsstringformat(form.term)#' 
				limit 1
			</cfquery>
  	
			<cfif checktermExist.recordcount eq 1>
				<h3 align="center"><font color="FF0000">Error, This <cfoutput>#form.term#</cfoutput> has been created already.</font></h3>
				<cfabort>
			</cfif>
			
			<cfquery name="insert_term" datasource="#arguments.dts1#">
				insert into icterm
				(	
					term,
					desp,
					sign,
					days
				) 
				values 
				(
					'#jsstringformat(form.term)#',
					'#jsstringformat(form.desp)#',
					'#form.sign#',
					'#jsstringformat(form.days)#'
				);
			</cfquery>
			
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
		
		<cfset status1 = "The Term Code, #form.term# Had Been Successfully Created !">
		
		<cfreturn status1>
	</cffunction>
	
	<cffunction name="edit_term" returntype="any">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		
		<cftry>
			<cfquery name="update_term" datasource="#arguments.dts1#">
				update icterm set 
				term=term,
				desp='#jsstringformat(form.desp)#',
				sign='#form.sign#',
				days='#jsstringformat(form.days)#' 
				where term='#jsstringformat(form.term)#';
			</cfquery>
			
			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
		
		<cfset status1 = "The Term code, #form.term# Had Been Successfully Edited !">
		
		<cfreturn status1>
	</cffunction>
	
	<cffunction name="delete_term" returntype="any">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="dts1" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">

		<cftry>
			<cfquery name="checktranexist" datasource="#arguments.dts#">
				select term 
				from artran
				where term='#jsstringformat(form.term)#' 
				limit 1
			</cfquery>
				
			<cfif checktranexist.recordcount eq 1>
				<h3 align="center"><font color="FF0000">You Have Created Transaction For This Term Code. You Are Not Allowed Yo Delete This Term Code.</font></h3>					
				<cfabort>
			</cfif>
				
			<cfquery name="delete_customer_supplier" datasource="#arguments.dts1#">
				delete from icterm 
				where term='#jsstringformat(form.term)#';
			</cfquery>

			<cfcatch>
				<h2 align="center">Close Error - info below</h2>
				<cfdump var="#cfcatch#">
				<cfabort>
			</cfcatch>
		</cftry>
		
		<cfset status1 = "The Term Code, #form.term# Had Been Successfully Deleted !">
		
		<cfreturn status1>
	</cffunction>
</cfcomponent>