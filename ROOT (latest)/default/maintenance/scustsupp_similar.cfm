<html>
<head>
<cfoutput>
<title>Search #type#</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">

<cfquery name="getgeneral" datasource="#dts#">
select agentlistuserid,lagent from gsetup
</cfquery>

<cfset target_table = iif(url.type eq "customer",DE(target_arcust),DE(target_apvend))>

<!--- <cfquery name="getrecordcount" datasource="#dts#">
	select count(custno) as totalrecord 
	from #target_table# 
	where #searchType# like binary('#searchStr#')
	<cfif url.type eq "Customer" and getpin2.h1250 eq 'T'>
	and agent = '#huserid#'
	</cfif>
</cfquery> --->
<cfquery name="getrecordcount" datasource="#dts#">
	select count(custno) as totalrecord 
	from #target_table# 
	where <cfif searchType eq 'allphone'>
    (phone like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
    phonea like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
    fax like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
    phonea like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
    dphone like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
    dfax like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
    contact like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%">)
	
	<cfelse>#searchType# like <cfif isdefined('url.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif></cfif>
	<cfif url.type eq "Customer" and getpin2.h1250 eq 'T'>
		and agent = '#huserid#'
	</cfif>
    <cfif url.type eq "Customer" and getpin2.h1t00 eq 'T'>
<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(created_by)='#ucase(huserid)#' or ucase(agent)='#ucase(huserid)#')  
					</cfif>
					<cfelse><cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                    
                    <cfelse>
					<cfif Huserloc neq "All_loc">
					and (created_by in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif></cfif>
                    </cfif>
</cfquery>

<body>

<cfif getrecordcount.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage = round(getrecordcount.totalrecord/20)>
		<cfif getrecordcount.recordcount mod 20 LT 10 and getrecordcount.totalrecord mod 20 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>
		
		<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
			<h3 align="center"><font color="FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
		</cfif>
 	</cfif>
	
	<cfform action="scustsupp_similar.cfm?type=#urlencodedformat(type)#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#" method="post" target="_self">
		<div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
		
		<cfset noOfPage = round(getrecordcount.totalrecord/20)>
		
		<cfif getrecordcount.totalrecord mod 20 LT 10 and getrecordcount.totalrecord mod 20 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>
		
		<cfif isdefined("url.start")>
			<cfset start = url.start>
		</cfif>
		
		<cfif isdefined("form.skeypage")>
			<cfset start = form.skeypage * 20 + 1 - 20>
			<cfif form.skeypage eq "1">
				<cfset start = "1">
			</cfif>
		</cfif>

		<cfset prevTwenty = start -20>
		<cfset nextTwenty = start +20>
		<cfset page = round(nextTwenty/20)>
		
		<!--- <cfquery datasource='#dts#' name="getjob">
			select *
			from #target_table# 
			where #searchType# like binary('#searchStr#')
			<cfif url.type eq "Customer" and getpin2.h1250 eq 'T'>
			and agent = '#huserid#'
			</cfif>
			order by #searchType#
			limit #start-1#,20;
		</cfquery> --->
		
		<cfif lcase(HcomID) eq "topsteel_i">
			<!--- <cfquery datasource='#dts#' name="getjob">
				select a.*,b.desp as businessdesp
				from #target_table# as a
				
				left join business as b on a.business=b.business
				
				where #searchType# like binary('#searchStr#')
				<cfif url.type eq "Customer" and getpin2.h1250 eq 'T'>
					and agent = '#huserid#'
				</cfif>
				order by #searchType#
				limit #start-1#,20;
			</cfquery> --->
			<cfquery datasource='#dts#' name="getjob">
				select a.*,b.desp as businessdesp
				from #target_table# as a
				
				left join business as b on a.business=b.business
				
				where 
                <cfif searchType eq 'allphone'>
                (phone like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                phonea like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                fax like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                phonea like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                dphone like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                dfax like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                contact like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%">)
                
                <cfelse>
                #searchType# like <cfif isdefined('url.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif></cfif>
				<cfif url.type eq "Customer" and getpin2.h1250 eq 'T'>
					and agent = '#huserid#'
				</cfif>
                <cfif url.type eq "Customer" and getpin2.h1t00 eq 'T'>
<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(created_by)='#ucase(huserid)#' or ucase(agent)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
                    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                    
                    <cfelse>
					<cfif Huserloc neq "All_loc">
					and (created_by in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif></cfif>
                    </cfif>
				order by <cfif searchType eq 'allphone'>phone<cfelse>#searchType#</cfif>
				limit #start-1#,20
			</cfquery>
		<cfelse>
			<!--- <cfquery datasource='#dts#' name="getjob">
				select *
				from #target_table# 
				where #searchType# like binary('#searchStr#')
				<cfif url.type eq "Customer" and getpin2.h1250 eq 'T'>
				and agent = '#huserid#'
				</cfif>
				order by #searchType#
				limit #start-1#,20;
			</cfquery> --->
			<cfquery datasource='#dts#' name="getjob">
				select *
				from #target_table# 
				where 
                <cfif searchType eq 'allphone'>
                (phone like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                phonea like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                fax like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                phonea like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                dphone like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                dfax like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or
                contact like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%">)
                
                <cfelse>
                #searchType# like <cfif isdefined('url.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif></cfif>
				<cfif url.type eq "Customer" and getpin2.h1250 eq 'T'>
				and agent = '#huserid#'
				</cfif>
                <cfif url.type eq "Customer" and getpin2.h1t00 eq 'T'>
<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(created_by)='#ucase(huserid)#' or ucase(agent)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
                    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                    <cfelse>
					<cfif Huserloc neq "All_loc">
					and (created_by in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif></cfif>
                    </cfif>
				order by <cfif searchType eq 'allphone'>phone<cfelse>#searchType#</cfif>
				limit #start-1#,20
			</cfquery>
		</cfif>

		<cfif start neq 1>
			|| <a target="_self" href="scustsupp_similar.cfm?type=#type#&start=#prevTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#<cfif isdefined('url.left')>&left=1</cfif>">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="scustsupp_similar.cfm?type=#type#&start=#nextTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#<cfif isdefined('url.left')>&left=1</cfif>">Next</a> ||
		</cfif>

		Page #page# Of #noOfPage#
		</div>
		<hr>

		<table align="center" class="data" width="100%">
			<tr>
				<th>No.</th>
				<cfif lcase(HcomID) neq "topsteel_i"><th>#getgeneral.lagent#</th></cfif>
				<th>ID</th>
				<th>Name</th>
				<th>Address</th>
				<th>Telephone</th>
				<th>Fax</th>
				<th><cfif lcase(HcomID) eq "tmt_i" or lcase(HcomID) eq "taff_i">I.C no.<cfelse>Attention</cfif></th>
				<cfif url.type eq "Customer" and getpin2.h1211 eq "T">
					<th>Action</th>
				<cfelseif url.type eq "Supplier" and getpin2.h1111 eq 'T'>
					<th>Action</th>
				</cfif>
			</tr>
				
			<cfloop query="getjob">
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';" <cfif (type eq "Customer" and getpin2.h1211 eq "T") or (type eq "Supplier" and getpin2.h1111 eq 'T')>ondblclick="javascript:window.parent.location.href('#url.type#.cfm?type=Edit&custno=#URLEncodedFormat(custno)#');"</cfif>>
					<td nowrap>#getjob.currentrow#</td>
					<cfif lcase(HcomID) neq "topsteel_i"><td nowrap>#getjob.agent#</td></cfif>
           			<td nowrap>#getjob.custno#</td>
					<td nowrap>#getjob.Name#
                    	<cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                        <br>#getjob.Name2#
                        </cfif>
						<cfif lcase(HcomID) eq "ge_i" or lcase(HcomID) eq "saehan_i" or lcase(HcomID) eq "idi_i" or lcase(HcomID) eq "gwa_i">
							<cfif getjob.web_site neq "">
								<cfif findnocase("http://",getjob.web_site) eq 0>
									<cfset getjob.web_site = "http://"&getjob.web_site>
								</cfif>
								<br><a href="#getjob.web_site#" target="_blank">#getjob.web_site#</a>
							</cfif>
						<cfelseif lcase(HcomID) eq "topsteel_i">
							<cfif getjob.businessdesp neq "">
								<br>(#getjob.businessdesp#)
							</cfif>
						</cfif>
					</td>
					<td nowrap>#getjob.Add1#<br>#getjob.Add2#<br>#getjob.Add3#<br>#getjob.Add4#</td>
					<td nowrap>(1) #getjob.Phone#<br>(2) #getjob.phonea#</td>
					<td nowrap>#getjob.fax#</td>
					<td nowrap>#getjob.attn#<br/><font style="background-color:FFFFFF">#getjob.e_mail#</font></td>
           			<td nowrap>
						<cfif url.type eq "Customer" and getpin2.h1211 eq "T">
							<div align="center">
								<a href="#url.type#.cfm?type=Delete&custno=#URLEncodedFormat(custno)#" target="_parent"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;
								<a href="#url.type#.cfm?type=Edit&custno=#URLEncodedFormat(custno)#" target="_parent"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
							</div>
						<cfelseif url.type eq "Supplier" and getpin2.h1111 eq 'T'>
							<div align="center">
								<a href="#url.type#.cfm?type=Delete&custno=#URLEncodedFormat(custno)#" target="_parent"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;
								<a href="#url.type#.cfm?type=Edit&custno=#URLEncodedFormat(custno)#" target="_parent"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
							</div>
						</cfif>
					</td>
				</tr>
			</cfloop>
		</table>
		<hr>
		<div align="right">
		<cfif start neq 1>
			<a target="_self" href="scustsupp_similar.cfm?type=#type#&start=#prevTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="scustsupp_similar.cfm?type=#type#&start=#nextTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#">Next</a> ||
		</cfif>
		
		Page #page# Of #noOfPage#
		</div>
	</cfform>
<cfelse>
	<h3>No Records were found.</h3>
</cfif>
</cfoutput>
</body>
</html>