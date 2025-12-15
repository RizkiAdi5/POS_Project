<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<cfparam name="status" default="">
<!--- ADD ON 15-07-2009 --->

<cfif form.mode eq "Create">
	<cfquery datasource='#dts#' name="checkattentionExist">
 		Select * from attention where attentionno='#form.attentionno#' 
 	</cfquery>
	 
  	<cfif checkattentionExist.recordcount GT 0 >
    	<h3><font color="#FF0000">Error, This Attention has been created already.</font></h3>
		<cfabort>
	</cfif>
    	<cfinsert datasource='#dts#' tablename="attention" formfields="attentionno,name,customerno,add1,add2,add3,phone,phonea,fax">

	<cfset status="The Attention, #form.attentionno# had been successfully created. ">

<cfelse>
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from attention where attentionno ='#form.attentionno#'
	</cfquery>
		
	<cfif checkitemExist.recordcount GT 0 >
		<cfif form.mode eq "Delete">
			<cfquery datasource='#dts#' name="deleteitem">
				Delete from attention where attentionno='#form.attentionno#'
			</cfquery>
			<cfset status="The Attention, #form.attentionno# had been successfully deleted. ">						
		</cfif>
				
		<cfif form.mode eq "Edit">
        	<!--- <cfif lcase(hcomid) eq "ovas_i"> --->
            	<cfquery name="update" datasource="#dts#">
                	update attention
                    set name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
                    customerno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.customerno#">,
                    add1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">,
                    add2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">,
                    add3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add3#">,
                    phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
                    phonea=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phonea#">,
                    fax=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">
                    where attentionno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.attentionno#">
                </cfquery>
            <!--- <cfelse>
				<cfupdate datasource='#dts#' tablename="attention" formfields="attentionno,name,name2,attn,customerno,add1,add2,add3,dept,contact,fax">
            </cfif> --->
			<cfset status="The Attention, #form.attentionno# had been successfully edited. ">
		</cfif>
	<cfelse>		
		<cfset status="Sorry, the Attention, #form.attentionno# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>
<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->

<cfoutput>
	<form name="done" action="sattention.cfm?process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>
<script>
	done.submit();
</script>