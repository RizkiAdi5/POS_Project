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
	<cfquery name="checkexist" datasource="#dts#">
    select * from arcust where custno = '#form.custno#'
    </cfquery>

    <cfif checkexist.recordcount eq 0>
    <cfquery name="insertcust" datasource="#dtslink#">
		insert into arcust
		(
        custno,
		autopay,
		date,
		name,
		name2,
        comuen,
		add1,
		add2,
		add3,
		add4,
		attn,
		daddr1,
		daddr2,
		daddr3,
		daddr4,
        dattn,
		groupto,
		area,
		agent,
		term,
		crlimit,
		e_mail,
		web_site,
		phone,
		phonea,
		fax,
		contact,
		business,
		currcode,
		currency,
		currency1,
		cust_type,
		ct_group,
		ngst_cust,
		arrem1,
		arrem2,
		arrem3,
		arrem4,
		bankAccno,
		mod_Del,
		termexceed,
		salec,
		salecnc,
		lc_ex,
        created_by,
        created_on,
        GSTNO,updated_by,postalcode,country)
		values
		(
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#newcustomerno#">,
       <cfif isdefined("form.OIC")>'O'<cfelse>'B'</cfif>,
        <cfqueryparam cfsqltype="cf_sql_date" value="#form.date#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.name2#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.comuen#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add1#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add2#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add3#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.add4#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.attn#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dadd1#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dadd2#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dadd3#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.dadd4#">,
        '',
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.groupto#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.area#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.agent#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.term#">,
        <cfqueryparam cfsqltype="cf_sql_decimal" value="#form.crlimit#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.e_mail#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.web_site#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phonea#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fax#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contact#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.business#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currcode#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currency#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.currency1#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cust_type#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ct_group#">,

		<cfif isdefined("form.ngst_cust")>
        <cfqueryparam cfsqltype="cf_sql_varchar" value="T">,
		<cfelse>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="F">,
		</cfif>

        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem1#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem2#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem3#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.arrem4#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.bankAccno#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mod_Del#">,
        <cfif isdefined("form.termExceed")>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="Y">,
		<cfelse>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
		</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.salec#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.salecnc#">,

		<cfif isdefined("form.lc_ex")>
		<cfqueryparam cfsqltype="cf_sql_decimal" value="#form.lc_ex#">,
		<cfelse>
		<cfqueryparam cfsqltype="cf_sql_decimal" value="0">,
		</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserName#">,
        now(),
        <cfif isdefined('form.GSTNO')>
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GSTNO#">,
        <cfelse>
        "",
		</cfif>
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#HUserName#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.postalcode#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.country#">
		)
	</cfquery>

	<cfif hlinkams eq "Y">
	<cfset dts1 = replace(dts,"_i","_a","all")>
	<cfquery name="insertgldata" datasource="#dts1#">
	insert into gldata
	(accno,
	desp,
	desp2,
	id,
	acctype,
	groupto,
	crlimit,
	currcode)
	values
	(
	'#newcustomerno#',
	'#form.name#',
	'#form.name2#',
	'1',
	'F',
	'#form.groupto#',
	'#form.crlimit#',
	'#form.currcode#'
	)
	</cfquery>
    </cfif>

    <cfif isdefined('newCustomerNo')>
    <cfif form.nexcustno eq 1>
    <cfset lastusedno = right(form.custno,3) >
	<cfelse>
    <cfset lastusedno = form.custno >
	</cfif>
    <cfquery name="updatelastusedno" datasource="#dts#">
    Update refnoset SET lastUsedNo = "#lastusedno#" WHERE type = "CUST"
    </cfquery>
	</cfif>


 <cfoutput>
 <h2>Create New Company Success!</h2>
 <input type="button" onClick="window.opener.getCustSupp2('#newCustomerNo#','#form.name#');window.close();" value="Close">
 </cfoutput>
<cfelse>
 <cfoutput>
 <cfset msg="Duplicate #newCustomerNo# No. Please Use Another Supplier No.">
 <h2>#msg#</h2>
 <input type="button" onClick="window.close();" value="Close" >
 </cfoutput>
</cfif>