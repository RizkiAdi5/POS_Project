<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<cfparam name="status" default="">
<!--- ADD ON 15-07-2009 --->
<cfquery name="getGsetup" datasource="#dts#">
  Select lDRIVER,memberpoint from GSetup
</cfquery>

<cftry>
<cfset newdob=createdate(right(dob,4),mid(dob,4,2),left(dob,2))>
<cfcatch>
<cfset newdob=form.dob>
</cfcatch>
</cftry>

<cftry>
<cfset newexpiredate=createdate(right(expiredate,4),mid(expiredate,4,2),left(expiredate,2))>
<cfcatch>
<cfset newexpiredate=form.expiredate>
</cfcatch>
</cftry>


<cfif form.mode eq "Create">
	<cfif getGsetup.memberpoint eq 'Y'>
    
    <cftry>
	<cfquery datasource='#dtssync#' name="checkdriverExist">
 		Select * from driver where driverno='#form.driverno#' 
 	</cfquery>
    <cfcatch><h3>No Internet connection</h3><cfabort></cfcatch></cftry>
    
    <cfelse>
    
    <cfquery datasource='#dts#' name="checkdriverExist">
 		Select * from driver where driverno='#form.driverno#' 
 	</cfquery>
    
   </cfif>
	 
  	<cfif checkdriverExist.recordcount GT 0 >
    	<h3><font color="#FF0000">Error, This <cfoutput>#getGsetup.lDRIVER#</cfoutput> has been created already.</font></h3>
		<cfabort>
	</cfif>
	
	<!--- <cfquery datasource='#dts#' name="checknameExist">
			Select * from driver where attn='#form.attn#'
	</cfquery>
	
	<cfif checknameExist.recordcount GT 0 >
		
    	<h3><font color="#FF0000">Error, This Driver Name has been created already.</font></h3>
		<cfabort>
	</cfif> --->
	
	<cfif lcase(hcomid) eq "ovas_i">
    	<cfinsert datasource='#dts#' tablename="driver" formfields="driverno,name,name2,attn,customerno,add1,add2,add3,dept,contact,phone,phonea,fax,commission1,pointsbf">
	<cfelse>
    	<cfinsert datasource='#dts#' tablename="driver" formfields="driverno,name,name2,attn,customerno,add1,add2,add3,dept,contact,fax,dadd1,dadd2,dadd3,dadd4,dattn,dcontact,remarks">
	</cfif>
    
    <cfif getGsetup.memberpoint eq 'Y'>
    	<cfinsert datasource='#dtssync#' tablename="driver" formfields="driverno,name,name2,attn,customerno,add1,add2,add3,dept,contact,fax,dadd1,dadd2,dadd3,dadd4,dattn,dcontact,remarks">
    
    	<cfquery name="insertpicture" datasource="#dtssync#">
    	update driver set photo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.picture_available#">,commission1='#val(form.commission1)#',pointsbf='#val(pointsbf)#',created_on=now() where driverno='#form.driverno#'
    	</cfquery>
    
    </cfif>
    
	
    <cfquery name="insertpicture" datasource="#dts#">
    update driver set photo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.picture_available#">,created_on=now(),
    icno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.icno#">,
    dob=<cfif dob eq ''>'0000-00-00'<cfelse>'#dateformat(newdob,'yyyy-mm-dd')#'</cfif>,
    expiredate=<cfif expiredate eq ''>'0000-00-00'<cfelse>'#dateformat(newexpiredate,'yyyy-mm-dd')#'</cfif>,
    gender=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gender#">,
    pricelevel=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pricelevel#">,
    discontinuedriver=<cfif isdefined('form.discontinuedriver')>'Y'<cfelse>'N'</cfif>
    where driverno='#form.driverno#'
    </cfquery>
    
    <cfif getGsetup.memberpoint eq 'Y'>
    <cfquery name="insertpicture" datasource="#dtssync#">
    update driver set photo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.picture_available#">,created_on=now(),
    icno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.icno#">,
    dob=<cfif dob eq ''>'0000-00-00'<cfelse>'#dateformat(newdob,'yyyy-mm-dd')#'</cfif>,
    expiredate=<cfif expiredate eq ''>'0000-00-00'<cfelse>'#dateformat(newexpiredate,'yyyy-mm-dd')#'</cfif>,
    gender=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gender#">,
    discontinuedriver=<cfif isdefined('form.discontinuedriver')>'Y'<cfelse>'N'</cfif>
    where driverno='#form.driverno#'
    </cfquery>
    </cfif>
    
	<cfset status="The #getGsetup.lDRIVER#, #form.driverno# had been successfully created. ">

<cfelse>
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from driver where driverno ='#form.driverno#'
	</cfquery>
		
	<cfif checkitemExist.recordcount GT 0 >
		<cfif form.mode eq "Delete">
			<cfquery datasource='#dts#' name="deleteitem">
				Delete from driver where driverno='#form.driverno#'
			</cfquery>
			<cfset status="The #getGsetup.lDRIVER#, #form.driverno# had been successfully deleted. ">						
		</cfif>
				
		<cfif form.mode eq "Edit">
        	<!--- <cfif lcase(hcomid) eq "ovas_i"> --->
            	<cfquery name="update" datasource="#dts#">
                	update driver
                    set name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
                    name2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name2#">,
                    attn=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.attn#">,
                    customerno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.customerno#">,
                    add1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">,
                    add2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">,
                    add3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add3#">,
                    dept=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dept#">,
                    contact=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contact#">,
                    dadd1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dadd1#">,
                    dadd2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dadd2#">,
                    dadd3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dadd3#">,
                    dattn=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dattn#">,
                    dcontact=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dcontact#">,
                    remarks=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.remarks#">,
                    <cfif lcase(hcomid) eq "ovas_i">
                        phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
                        phonea=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phonea#">,
					</cfif>
                    dob=<cfif dob eq ''>'0000-00-00'<cfelse>'#dateformat(newdob,'yyyy-mm-dd')#'</cfif>,
                    expiredate=<cfif expiredate eq ''>'0000-00-00'<cfelse>'#dateformat(newexpiredate,'yyyy-mm-dd')#'</cfif>,
                    fax=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">,
                    commission1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.commission1#">,
                    pointsbf="#val(form.pointsbf)#",
                    pricelevel=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pricelevel#">,
                    photo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.picture_available#">
                    where driverno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.driverno#">
                </cfquery>
            <!--- <cfelse>
				<cfupdate datasource='#dts#' tablename="driver" formfields="driverno,name,name2,attn,customerno,add1,add2,add3,dept,contact,fax">
            </cfif> --->
			<cfset status="The #getGsetup.lDRIVER#, #form.Driverno# had been successfully edited. ">
		</cfif>
	<cfelse>		
		<cfset status="Sorry, the #getGsetup.lDRIVER#, #form.Driverno# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>
<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->

<cfoutput>
	<form name="done" action="sDriver.cfm?process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>
<script>
	done.submit();
</script>