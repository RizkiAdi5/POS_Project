<cfparam name="status" default="">

<cfset form.photo = form.picture_available>

<cfif form.mode eq "Create">
	<cfquery name="checkitemExist" datasource="#dts#">
 	 	select * from icitem where itemno = '#form.itemno#'
 	 </cfquery>
	
	<cfif checkitemExist.recordcount gt 0>
		<cfoutput><h3><font color="##FF0000">Error, This Item Number ("#form.itemno#") has been created already.</font></h3></cfoutput>
		<cfabort>
	</cfif>

	<cfquery name="insertitem" datasource="#dts#">
		insert into icitem ()
		
		values ()
	</cfquery>

	<cfset status="The Item, #form.itemno# had been successfully created.">
	
<cfelse>
	<cfquery name="checkitemExist" datasource="#dts#">
		select * from icitem where itemno='#form.itemno#'
	</cfquery>
	
	<cfif checkitemExist.recordcount GT 0 >
		<cfif form.mode eq "Delete">
			<cfquery name="checktranexist" datasource="#dts#">
				select vehicle from ictran where itemno = '#form.itemno#'
			</cfquery>
			
			<cfif checktranexist.recordcount gt 0>
				<h3>You have created transaction for this Vehicle.</h3>					
				<cfabort>
			</cfif>
				
			<cfquery name="deleteitem" datasource='#dts#'>
				Delete from vehicle where entryno='#form.entryno#'
			</cfquery>
            
			
			<cfset status="The vehicle, #form.entryno# had been successfully deleted. ">	
		</cfif>
				
		<cfif form.mode eq "Edit">
			<cfquery name="updateicitem" datasource="#dts#">
				UPDATE icitem
				SET 

				WHERE entryno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.entryno#">
			</cfquery>
			<cfset status="The Vehicle, #form.entryno# had been successfully edited. ">

		</cfif>				
	<cfelse>		
		<cfset status="Sorry, the Vehicle, #form.entryno# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>
<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->

<cfoutput>
		<form name="done" action="s_icitem.cfm?type=icitem&process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
</cfoutput>
<!---
<script language="javascript" type="text/javascript">
<cfif isdefined('form.express')>
opener.document.invoicesheet.expressservicelist.value = <cfoutput>'#form.itemno#'</cfoutput>;
opener.document.invoicesheet.expressservicelist.focus();
window.close();

<cfelseif isdefined('form.ovasexpress')>
<cfoutput>window.opener.updateitem('#form.itemno#','#form.desp#');</cfoutput>
</cfif>	
done.submit();
</script>
--->