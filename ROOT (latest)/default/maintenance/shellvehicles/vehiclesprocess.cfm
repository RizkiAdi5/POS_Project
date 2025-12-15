<cfparam name="status" default="">

<cfif form.lastserdate neq ''>
<cfset rlastserdate = createdate('#right(form.lastserdate,4)#','#mid(form.lastserdate,4,2)#','#left(form.lastserdate,2)#')>
<cfset reallastserdate = dateformat(rlastserdate,'YYYY-MM-DD')>
<cfelse>
<cfset reallastserdate = '0000-00-00' >
</cfif>

<cfif form.nextserdate neq ''>
<cfset rnextserdate = createdate('#right(form.nextserdate,4)#','#mid(form.nextserdate,4,2)#','#left(form.nextserdate,2)#')>
<cfset realnextserdate = dateformat(rnextserdate,'YYYY-MM-DD')>
<cfelse>
<cfset realnextserdate = '0000-00-00' >
</cfif>

<cfif form.oriregdate neq ''>
<cfset roriregdate = createdate('#right(form.oriregdate,4)#','#mid(form.oriregdate,4,2)#','#left(form.oriregdate,2)#')>
<cfset realoriregdate = dateformat(roriregdate,'YYYY-MM-DD')>
<cfelse>
<cfset realoriregdate = '0000-00-00' >
</cfif>



<cfif form.mode eq "Create">
	<cfquery name="checkitemExist" datasource="#dts#">
 	 	select * from vehicles where entryno = '#form.entryno#'
 	 </cfquery>
	
	<cfif checkitemExist.recordcount gt 0>
		<cfoutput><h3><font color="##FF0000">Error, This Vehicle Number ("#form.entryno#") has been created already.</font></h3></cfoutput>
		<cfabort>
	</cfif>
    
    <!---check customer exist--->
    <cfif isdefined('form.createnewcustomer')>
    
    <cfif isdefined('form.s_prefix') and isdefined('form.s_suffix')>
	<cfset newCustomerNo = #form.s_prefix#&"/"&#form.s_suffix# >
    <cfset form.custno = newCustomerNo>
    <cfelse>
    <cfset newCustomerNo = "#form.custno#">
	</cfif>
    
    <cfquery name="checkcustExist" datasource="#dts#">
 	 	select * from #target_arcust# where custno = '#newCustomerNo#'
 	 </cfquery>
	
	<cfif checkcustExist.recordcount gt 0>
		<cfoutput><h3><font color="##FF0000">Error, This Customer Number ("#newCustomerNo#") has been created already.</font></h3></cfoutput>
		<cfabort>
	</cfif>
    </cfif>
    <!--- --->

	<cfquery name="insertitem" datasource="#dts#">
		insert into vehicles (entryno,custcode,custname,Add1,Add2,Add3,Add4,postalcode,Email,phone,Hp,contactperson,make,model,engineno,chasisno,capacity,regyear,lastmileage,lastserdate,nextmileage,nextserdate,oriregdate,remark,colour,memberid,gender,honorific,contact,owner)
		values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.entryno#">,<cfif isdefined('form.createnewcustomer')><cfqueryparam cfsqltype="cf_sql_varchar" value="#newCustomerNo#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custcode#"></cfif>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custname#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Add1#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Add2#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Add3#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Add4#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.postalcode#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Email#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Hp#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contactperson#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.make#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.model#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.engineno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.chasisno#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.capacity#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.regyear#">,'#form.lastmileage#','#reallastserdate#','#form.nextmileage#','#realnextserdate#','#realoriregdate#',<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.remark#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.colour#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberid#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gender#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.honorific#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contact#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.owner#">)
	</cfquery>
	
    <cfif isdefined('form.createnewcustomer')>
    
    <cfquery name="updatearcust" datasource="#dts#">
    insert into #target_arcust# (custno,name,add1,add2,add3,add4,postalcode,e_mail,phone,phonea,attn,arrem1,arrem2,arrem3,contact)
    values(
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#newCustomerNo#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custname#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add3#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add4#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.postalcode#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hp#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contactperson#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberid#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gender#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.honorific#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contact#">
    )
    </cfquery>
    
    <cfquery name="updatelastusedno" datasource="#dts#">
    Update refnoset SET lastUsedNo = "#right(newCustomerNo,3)#" WHERE type = "CUST"
    </cfquery>
    
    <cfelse>
    <cfquery name="updatearcust" datasource="#dts#">
    update #target_arcust# set name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custname#">,add1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">,add2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">,add3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add3#">,add4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add4#">,postalcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.postalcode#">,e_mail=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,phonea=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Hp#">,attn=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contactperson#">,arrem1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberid#">,arrem2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gender#">,arrem3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.honorific#">,contact=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contact#"> where custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custcode#">
    </cfquery>
    </cfif>
	<cfset status="The Vehicle, #form.entryno# had been successfully created.">
	
<cfelse>
	<cfquery name="checkitemExist" datasource="#dts#">
		select * from vehicles where entryno='#form.entryno#'
	</cfquery>
	
	<cfif checkitemExist.recordcount GT 0 >
		<cfif form.mode eq "Delete">
			<cfquery name="checktranexist" datasource="#dts#">
				select refno from artran where rem5 = '#form.entryno#'
			</cfquery>
			
			<cfif checktranexist.recordcount gt 0>
				<h3>You have created transaction for this Vehicle.</h3>					
				<cfabort>
			</cfif>
				
			<cfquery name="deleteitem" datasource='#dts#'>
				Delete from vehicles where entryno='#form.entryno#'
			</cfquery>
			
			<cfset status="The vehicle, #form.entryno# had been successfully deleted. ">	
		</cfif>
				
		<cfif form.mode eq "Edit">
			<cfquery name="updateicitem" datasource="#dts#">
				UPDATE vehicles
				SET 
                custcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custcode#">,
                custname=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custname#">,
                Add1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Add1#">,
                Add2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Add2#">,
                Add3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Add3#">,
                Add4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Add4#">,
                postalcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.postalcode#">,
                Email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Email#">,
                phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
                Hp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Hp#">,
                contactperson=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contactperson#">,
                make=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.make#">,
                model=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.model#">,
                engineno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.engineno#">,
                chasisno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.chasisno#">,
                capacity=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.capacity#">,
                regyear=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.regyear#">,
                lastmileage='#form.lastmileage#',
                lastserdate='#reallastserdate#',
                nextmileage='#form.nextmileage#',
                nextserdate='#realnextserdate#',
                oriregdate='#realoriregdate#',
                remark=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.remark#">,
                colour=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.colour#">,
                memberid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberid#">,
                gender=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gender#">,
                honorific=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.honorific#">,
                contact=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contact#">,
                owner=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.owner#">
				WHERE entryno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.entryno#">
			</cfquery>
            
            
            <cfquery name="updatearcust" datasource="#dts#">
    update #target_arcust# set name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custname#">,add1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">,add2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">,add3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add3#">,add4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add4#">,postalcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.postalcode#">,e_mail=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,phone=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,phonea=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Hp#">,attn=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contactperson#">,arrem1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.memberid#">,arrem2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.gender#">,arrem3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.honorific#">,contact=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contact#"> where custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.custcode#">
    		</cfquery>
			<cfset status="The Vehicle, #form.entryno# had been successfully edited. ">

		</cfif>				
	<cfelse>		
		<cfset status="Sorry, the Vehicle, #form.entryno# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>
<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->

<cfoutput>
		<form name="done" action="s_vehicles.cfm?type=vehicles&process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
</cfoutput>

<script language="javascript" type="text/javascript">

<cfif isdefined('form.express')>
<cfoutput>
window.opener.getvehicle2('#form.entryno#');
window.close();
</cfoutput>
</cfif>	
done.submit();
</script>
