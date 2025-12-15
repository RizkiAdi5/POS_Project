<html>
<head>
<title>Search Items</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getdisplaysetup" datasource="#dts#">
    select * from displaysetup
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
	select * from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select concat(',.',(repeat('_',decl_uprice))) as decl_uprice 
	from gsetup2
</cfquery>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">

<!--- <cfquery name="getrecordcount" datasource="#dts#">
	select count(itemno) as totalrecord 
	from icitem 
	where #searchType# LIKE binary('#searchStr#') <cfif searchType eq "desp"> or despa LIKE binary('#searchStr#') </cfif>
	order by #searchType#
</cfquery> --->
<cfquery name="getrecordcount" datasource="#dts#">
	select count(entryno) as totalrecord 
	from vehicles 
	where (#searchType# LIKE <cfif isdefined('url.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif>)
    
	order by #searchType#
</cfquery>

<body>
<cfoutput>
<cfif getrecordcount.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage = round(getrecordcount.totalrecord/20)>
		<cfif getrecordcount.totalrecord mod 20 LT 10 and getrecordcount.totalrecord mod 20 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>
		
		<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
			<h3 align="center"><font color="FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
		</cfif>
 	</cfif>
	
	<cfform action="svehicles_similar.cfm?searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#" method="post" target="_self">
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
			from icitem 
			where #searchType# LIKE binary('#searchStr#') <cfif searchType eq "desp"> or despa LIKE binary('#searchStr#') </cfif>
			order by #searchType#
			limit #start-1#,20;
		</cfquery> --->
		<cfquery datasource='#dts#' name="getjob">
			select *
			from vehicles 
			where (#searchType# LIKE <cfif isdefined('url.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif>)
			order by #searchType#
			limit #start-1#,20;
		</cfquery>

		<cfif start neq 1>
			|| <a target="_self" href="svehicles_similar.cfm?start=#prevTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#<cfif isdefined('url.left')>&left=1</cfif>">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="svehicles_similar.cfm?start=#nextTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#<cfif isdefined('url.left')>&left=1</cfif>">Next</a> ||
		</cfif>

		Page #page# Of #noOfPage#
		</div>
		<hr>

		<table align="center" class="data" width="600px">
      		<tr> 
        		<th>No.</th>

				<th>Vehicle No</th>
                <th>Customer No</th>
                <th>Make</th>
                <th>Model</th>

                
        		<cfif getpin2.h1311 eq 'T'>
					<th>Action</th>
				</cfif>
      		</tr>
      		
			<cfloop query="getjob"> 
        		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';"> 
          			<td nowrap>#getjob.currentrow#</td>
                   
					<td nowrap>#getjob.entryno#</td>
                    <td nowrap>#getjob.custcode#  - #getjob.custname#</td>
                    <td nowrap>#getjob.make#</td>
                    <td nowrap>#getjob.model#</td>
                    
          			<cfif getpin2.h1311 eq 'T'>
						<td nowrap><div align="center">
							<a href="vehicles2.cfm?type=Delete&entryno=#urlencodedformat(getjob.entryno)#" target="_parent"><img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              				<a href="vehicles2.cfm?type=Edit&entryno=#urlencodedformat(getjob.entryno)#" target="_parent"><img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a>
                             <a href="vehicleserhistory1.cfm?type=Edit&entryno=#urlencodedformat(getjob.entryno)#" target="_parent"><img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">View</a>           
                             <cfif lcase(hcomid) eq "lkabb_i" or lcase(hcomid) eq "lkabp_i" or lcase(hcomid) eq "lkab_i" <!---or lcase(hcomid) eq "lkatlb_i"--->
				or lcase(hcomid) eq "lkatbh_i" or lcase(hcomid) eq "svcmm_i" or lcase(hcomid) eq "svcnvn_i" or lcase(hcomid) eq "svctm_i"
				or lcase(hcomid) eq "svcyr_i" or lcase(hcomid) eq "svcdm_i" or lcase(hcomid) eq "svcbd_i" or lcase(hcomid) eq "21bl_i"
				or lcase(hcomid) eq "21cmw_i" or lcase(hcomid) eq "jvtpy_i" or lcase(hcomid) eq "jvsbw_i" or lcase(hcomid) eq "stbrd_i"
				or lcase(hcomid) eq "stpylb_i" or lcase(hcomid) eq "stfsrg_i" or lcase(hcomid) eq "stfsk_i" or lcase(hcomid) eq "ftmps_i"
				or lcase(hcomid) eq "lkabt_i" or lcase(hcomid) eq "lkatb_i" or lcase(hcomid) eq "lkatl_i" or lcase(hcomid) eq "shell_i"
				or lcase(hcomid) eq "fttk_i" or lcase(hcomid) eq "svcnc_i" or lcase(hcomid) eq "autoserv_i">
                             <a href="lastyeartran.cfm?type=Edit&entryno=#urlencodedformat(getjob.entryno)#" target="_parent"><img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">View History</a>                 
							</cfif>
                        </td>
					</cfif>
        		</tr>
      		</cfloop> 
    	</table>
		<hr>
		<div align="right">
		<cfif start neq 1>
			<a target="_self" href="svehicles_similar.cfm?start=#prevTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="svehicles_similar.cfm?start=#nextTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#">Next</a> ||
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