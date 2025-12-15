
	
	<cfif isdefined('form.s_prefix') and isdefined('form.s_suffix')>
	<cfset newCustomerNo = #form.s_prefix#&"/"&#form.s_suffix# >
    <cfset form.custno = newCustomerNo>
    <cfelse>
    <cfset newCustomerNo = "#form.custno#">
    
	</cfif>
    <cfset dtslink = dts>
    <cfif hlinkams eq "Y">
			<cfset dtslink = replace(dts,"_i","_a","all")>
		</cfif>
    
    <cfquery name="checkexist" datasource="#dtslink#">
    select custno from apvend where custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#newcustomerno#">
    </cfquery>
    
    <cfif checkexist.recordcount neq 0>
    <cfset refnocheck = 0>
    <cfset newCustomerNo1 = checkexist.custno>
    <cfloop condition="refnocheck eq 0">
    <cftry>
    <cfinvoke component="cfc.IncrementValue" method="getIncreament" input="#newCustomerNo1#" returnvariable="newCustomerNo"/>
	<cfcatch>
	<cfinvoke component="cfc.refno" method="processNum" oldNum="#newCustomerNo1#" returnvariable="newCustomerNo" />	
	</cfcatch>
    </cftry>
    <cfquery name="checkexistence" datasource="#dtslink#">
    select custno from apvend where custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#newcustomerno#">
    </cfquery>
    <cfif checkexistence.recordcount eq 0>
    <cfset refnocheck = 1>
    <cfelse>
    <cfset newCustomerNo1 = newCustomerNo>
	</cfif>
    </cfloop>
    </cfif> 
    

    <cfquery name="insertcust" datasource="#dtslink#">
		insert into apvend 
		(
        custno, 
		date,
		name,
		name2,
		add1,
		add2,
		add3,
		add4,
		attn,
		agent,
		e_mail,
		web_site,
		phone,
		phonea,
		fax,
		contact,
		arrem1,
		arrem2,
        arrem3,
        created_by,
        created_on,
        postalcode,
        gstno,
        ngst_cust
        )
		values
		( 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#newcustomerno#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#form.date#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name2#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add3#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add4#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.attn#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.e_mail#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.web_site#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phonea#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contact#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem1#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem2#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem3#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserName#">,
        now(),
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.postalcode#">,
        '-',
        'F'
		)
	</cfquery>
    <cftry>
	<cfif hlinkams eq "Y">
	<cfset dts1 = replace(dts,"_i","_a","all")>	
	<cfquery name="insertgldata" datasource="#dts1#">
	insert into gldata
	(accno,
	desp,
	desp2,
	id,
	acctype)
	values
	(
	'#newcustomerno#',
	'#form.name#',
	'#form.name2#',
	'1',
	'F'
	) 
	</cfquery>
    </cfif>
    <cfcatch>
    
    </cfcatch></cftry>
    
    <cfif isdefined('newCustomerNo')>
    <cfif form.nexcustno eq 1>
    <cfset lastusedno = right(form.custno,3) >
	<cfelse>
    <cfset lastusedno = form.custno >
	</cfif>
    <cfquery name="updatelastusedno" datasource="#dts#">
    Update refnoset SET lastUsedNo = "#lastusedno#" WHERE type = "SUPP"
    </cfquery>
	</cfif>
    
 <cfoutput>
 <h2>Create New Company Success!</h2>
 <cfif isdefined('form.mainid')>
 <input type="button" onClick="window.open('/default/maintenance/linkPage.cfm?type=Customer','mainFrame','')" value="Close" >
 <cfelse>
 <cfset form.name=replace(form.name,"'","","all")>
 <cfset form.name=replace(form.name,'"','','all')>
 <input type="button" onClick="getCustSupp3('#newCustomerNo#','#form.name#');ColdFusion.Window.hide('createSupplier');" value="Close" >
 </cfif>
 </cfoutput>
 