<cfparam name="status" default="">
<!--- <cfif lcase(hcomid) eq "mhca_i">
	<cfset title2 = "Marketer">
<cfelse>
	<cfset title2 = "Location">
</cfif> --->
<!--- ADD ON 15-07-2009 --->
<cfquery name="getGsetup" datasource="#dts#">
  Select lLOCATION from GSetup
</cfquery>
<cfif form.mode eq "Create">
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from iclocation where location='#form.location#'
	</cfquery>
	
	<cfif checkitemExist.recordcount GT 0 >
		<h3>Error. This <cfoutput>#getGsetup.lLOCATION#</cfoutput> has been created already.</h3>
		<cfabort>
	</cfif>
	
	<cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
		<cfif isdefined("form.foreignloc") and form.foreignloc eq "on">
			<cfquery name="getmax" datasource="#dts#">
				select max(foreignloc) as maxno from iclocation
			</cfquery>
			<cfset foreignloc = getmax.maxno + 1>
		<cfelse>
			<cfset foreignloc = 0>
		</cfif>
		<cfquery name="insert" datasource="#dts#">
			insert into iclocation
			(`LOCATION`,`DESP`,`ADDR1`,`ADDR2`,`ADDR3`,`ADDR4`,`OUTLET`,`CUSTNO`,`CURRCODE`,`FOREIGNLOC`) 
			values
			('#form.location#','#form.desp#','#form.addr1#','#form.addr2#','#form.addr3#','#form.addr4#','#form.outlet#',
			'#form.custno#','#form.currcode#',#foreignloc#)
		</cfquery>
	<cfelse>
		<cfinsert datasource='#dts#' tablename="iclocation" formfields="location,desp,addr1,addr2,addr3,addr4,outlet,custno">
	</cfif>
	<cfif isdefined('form.generateitem')>
    <cfquery name="insertlocation" datasource="#dts#">
    INSERT ignore INTO LOCQDBF (itemno,location,desp) SELECT itemno,"#form.location#","#form.desp#" as location from icitem order by itemno
    </cfquery>
	</cfif>
	<cfset status="The #getGsetup.lLOCATION#, #form.location# had been successfully created. ">
<cfelse>
	<cfquery datasource='#dts#' name="checkitemExist">
		Select * from iclocation where location='#form.location#'
	</cfquery>
	
	<cfif checkitemExist.recordcount GT 0 >
		<cfif form.mode eq "Delete">
			<cfquery datasource='#dts#' name="deleteitem">
				Delete from iclocation where location='#form.location#'
			</cfquery>
			
			<cfset status="The #getGsetup.lLOCATION#, #form.location# had been successfully deleted. ">	
		</cfif>
		
		<cfif form.mode eq "Edit">
			<cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
				<cfif isdefined("form.foreignloc") and form.foreignloc eq "on">
					<cfif checkitemExist.foreignloc neq 0>
						<cfset foreignloc = checkitemExist.foreignloc>
					<cfelse>
						<cfquery name="getmax" datasource="#dts#">
							select max(foreignloc) as maxno from iclocation
						</cfquery>
						<cfset foreignloc = getmax.maxno + 1>
					</cfif>
				<cfelse>
					<cfset foreignloc = 0>
				</cfif>
				
				<cfquery name="update" datasource="#dts#">
					update iclocation
					set desp = '#form.desp#',
					addr1 = '#form.addr1#',
					addr2 = '#form.addr2#',
					addr3 = '#form.addr3#',
					addr4 = '#form.addr4#',
					outlet = '#form.outlet#',
					custno = '#form.custno#',
					currcode = '#form.currcode#',
					foreignloc = #foreignloc#
					where location = '#form.location#'
				</cfquery>
			<cfelse>
				<cfquery name="update" datasource="#dts#">
					update iclocation
					set desp = '#form.desp#',
					addr1 = '#form.addr1#',
					addr2 = '#form.addr2#',
					addr3 = '#form.addr3#',
					addr4 = '#form.addr4#',
					outlet = '#form.outlet#',
					custno = '#form.custno#'
					where location = '#form.location#'
				</cfquery>

			</cfif>
            <cfif isdefined('form.generateitem')>
    <cfquery name="insertlocation" datasource="#dts#">
    INSERT ignore INTO LOCQDBF (itemno,location,desp) SELECT itemno,"#form.location#","#form.desp#" as location from icitem order by itemno
    </cfquery>
	</cfif>

			<cfset status="The #getGsetup.lLOCATION#, #form.location# had been successfully edited. ">
		</cfif>
				
	<cfelse>		
		<cfset status="Sorry, the #getGsetup.lLOCATION#, #form.location# was ALREADY removed from the system. Process unsuccessful.">
	</cfif>
</cfif>
<!---Get the messaged to be passed into the view user page. (vUser.cfm) --->
<cfoutput>
	<form name="done" action="s_locationtable.cfm?type=iclocation&process=done" method="post">
		<input name="status" value="#status#" type="hidden">
	</form>
</cfoutput>

<script>
	done.submit();
</script>