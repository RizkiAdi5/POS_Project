<cfparam name="status" default="">

<cfif #form.mode# eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from Address where Code='#form.Code#'
  	</cfquery>
	
  	<cfif checkitemExist.recordcount GT 0 >
		<h3>Error. This address code has been created already.</h3>
		<cfabort>
	</cfif>
<!---   <cfinsert datasource='#dts#' tablename="address" formfields="Code,desp,custno,add1,add2,add3,add4,add5,attn,phone,fax"> --->
  <!--- <cfinsert datasource='#dts#' tablename="Address" formfields="Code,name,custno,add1,add2,add3,add4,country,postalcode,attn,phone,fax">  ---> 
  
  <cfquery name="insertcollect" datasource="#dts#">
  INSERT INTO address(code,name,custno,add1,add2,add3,add4,attn,phone,fax,phonea,e_mail) values ('#form.code#','#form.name#','#form.custno#','#form.add1#','#form.add2#','#form.add3#','#form.add4#','#form.attn#','#form.phone#','#form.fax#','#form.phone2#','#form.e_mail#')
  </cfquery>
  
  <cfset status="The Address, #form.Code# had been successfully created. ">
<cfelse>
  <cfquery datasource='#dts#' name="checkitemExist">
	Select * from Address where Code='#form.Code#'
  </cfquery>
	
  <cfif checkitemExist.recordcount GT 0 >
	<cfif #form.mode# eq "Delete">
	  <cfquery datasource='#dts#' name="deleteitem">
		Delete from Address where Code='#form.Code#'
	  </cfquery>
	
	  <cfset status="The Address, #form.Code# had been successfully deleted. ">	
	</cfif>

	<cfif #form.mode# eq "Edit">
<!--- 	  <cfupdate datasource='#dts#' tablename="Address" formfields="Code,desp,custno,add1,add2,add3,add4,add5,attn,phone,fax"> --->
	<!---   <cfupdate datasource='#dts#' tablename="Address" formfields="Code,name,custno,add1,add2,add3,add4,attn,phone,fax"> --->
		<cfquery name="update_address" datasource="#dts#">
			update address set 
			code=code,
			name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
			custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custno#">,
			add1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">,
			add2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">,
			add3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add3#">,
			add4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add4#">,
			country=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.country#">,
			postalcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.postalcode#">,
			attn=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.attn#">,
			phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
			fax=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">,
            phonea=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone2#">,
            e_mail=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.e_mail#">  
			where code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.code#">
		</cfquery>
	  <cfset status="The Address, #form.Code# had been successfully edited. ">
	</cfif>
  <cfelse>		
	<cfset status="Sorry, the Address, #form.Code# was ALREADY removed from the system. Process unsuccessful.">
  </cfif>
</cfif>

<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->
<cfoutput>
<cfif isdefined('form.frminvoice')>
<script type="text/javascript" >
window.opener.setDeliveryField('#form.code#','#form.name#'<!--- ,'#form.custno#' --->,'#form.add1#','#form.add2#','#form.add3#','#form.add4#',
'#form.attn#','#form.phone#','#form.fax#');
self.close();
</script>
<cfelse>
  <form name="done" action="s_Addresstable.cfm?type=Code&process=done" method="post">
	<input name="status" value="#status#" type="hidden">
  </form>
  </cfif>
</cfoutput>

<script>
	done.submit();
</script>