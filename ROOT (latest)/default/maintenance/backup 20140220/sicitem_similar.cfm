<html>
<head>
<title>Search Items</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

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
	select count(itemno) as totalrecord 
	from icitem 
	where 
    <cfif searchType eq 'All'>
            (itemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or aitemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or barcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or brand like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or desp like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or category like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or size like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or costcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or colorid like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or wos_group like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or shelf like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or price like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%">)
            <cfelse>
    (#searchType# LIKE <cfif isdefined('url.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif> <cfif searchType eq "desp"> or despa LIKE <cfif isdefined('url.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif> </cfif>
    		<cfif lcase(hcomid) eq 'tcds_i' and searchType eq 'Sizeid'>
            or remark1 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%">
            </cfif>
            <cfif lcase(hcomid) eq 'tcds_i' and searchType eq 'Colorid'>
            or remark2 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%">
            </cfif>
    
    )</cfif>
    <cfif Hitemgroup neq ''>
    and wos_group='#Hitemgroup#'
    </cfif>
	order by <cfif lcase(hcomid) eq 'tcds_i'>sizeid,desp<cfelse><cfif searchType eq "All"> itemno <cfelse>#searchType#</cfif></cfif>
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
	
	<cfform action="sicitem_similar.cfm?searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#" method="post" target="_self">
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
			select a.*,m.desp as mdesp
			from icitem a
			left join iccolorid m on (a.colorid=m.colorid)
			where 
            <cfif searchType eq 'All'>
            (a.itemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or a.aitemno like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or a.barcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or a.brand like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or a.desp like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or a.category like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or a.size like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or a.costcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or a.colorid like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or a.wos_group like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or a.shelf like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"> or a.price like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%">)
            <cfelse>
            (a.#searchType# LIKE <cfif isdefined('url.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif> <cfif searchType eq "desp"> or a.despa LIKE <cfif isdefined('url.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchStr#%"></cfif> </cfif>
            <cfif lcase(hcomid) eq 'tcds_i' and searchType eq 'Sizeid'>
            or a.remark1 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%">
            </cfif>
            <cfif lcase(hcomid) eq 'tcds_i' and searchType eq 'Colorid'>
            or a.remark2 like <cfqueryparam cfsqltype="cf_sql_varchar" value="#searchStr#%">
            </cfif>
            )
            </cfif>
            
            <cfif Hitemgroup neq ''>
            and a.wos_group='#Hitemgroup#'
            </cfif>
			order by <cfif lcase(hcomid) eq 'tcds_i'>a.sizeid,a.desp<cfelse>a.<cfif searchType eq "All"> itemno <cfelse>#searchType#</cfif></cfif>
			limit #start-1#,20;
		</cfquery>

		<cfif start neq 1>
			|| <a target="_self" href="sicitem_similar.cfm?start=#prevTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#<cfif isdefined('url.left')>&left=1</cfif>">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="sicitem_similar.cfm?start=#nextTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#<cfif isdefined('url.left')>&left=1</cfif>">Next</a> ||
		</cfif>

		Page #page# Of #noOfPage#
		</div>
		<hr>

		<table align="center" class="data" width="600px">
      		<tr> 
        		<th>No.</th>
				<th><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>Item No</cfif></th>
        		<th>Description</th>
        		<th>Brand</th>
        		<th>#getgsetup.lcategory#</th>
        		<th>#getgsetup.lsize#</th>
				<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
					<th>Stock Bal</th>
				<cfelse>
        			<th>#getgsetup.lrating#</th>
				</cfif>
        		<th>#getgsetup.lmaterial#</th>
        		<th>#getgsetup.lgroup#</th>
        		<th>#getgsetup.lmodel#</th>
        		<th>Price</th>
				<cfif lcase(HcomID) eq "ovas_i">
        			<th>Price 2</th>
                <cfelseif lcase(HcomID) eq "mcjim_i" or lcase(HcomID) eq "acht_i">
               <th>UCost</th>
				</cfif>
                <cfif getgsetup.fcurrency eq "Y">
                <th>F.Currency</th>
                <th>F.Unit Cost</th>
                <th>F.Selling Price</th>
                </cfif>
        		<cfif getpin2.h1311 eq 'T'>
					<th>Action</th>
				</cfif>
      		</tr>
      		
			<cfloop query="getjob"> 
        		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';" <cfif getpin2.h1311 eq 'T'>ondblclick="javascript:window.parent.location.href('icitem2.cfm?type=Edit&itemno=#urlencodedformat(getjob.itemno)#');"</cfif>> 
          			<td nowrap>#getjob.currentrow#</td>
					<td nowrap>#getjob.itemno#</td>
          			<td nowrap>#getjob.desp#<br>#getjob.despa#</td>
          			<td nowrap>#getjob.brand#</td>
          			<td nowrap>#getjob.category#</td>
          			<td nowrap>#getjob.sizeid#</td>
					<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
						<cfset stkbal=val(getjob.qtybf)>
						<cfloop from="11" to="28" index="i">
							<cfset stkbal=stkbal+val(getjob["qin#i#"][getjob.currentrow])-val(getjob["qout#i#"][getjob.currentrow])>
						</cfloop>
						<td nowrap>#stkbal#</td>
					<cfelse>
          				<td nowrap>#getjob.costcode#</td>
					</cfif>
					<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
						<td nowrap>#getjob.mdesp#</td>
					<cfelse>
          				<td nowrap>#getjob.colorid#</td>
					</cfif>
          			<td nowrap>#getjob.wos_group#</td>
          			<td nowrap>#getjob.shelf#</td>
          			<td nowrap><div align="right">#NumberFormat(getjob.Price,getgsetup2.decl_uprice)#</div></td>
					<cfif lcase(HcomID) eq "ovas_i">
	        			<td nowrap><div align="right">#NumberFormat(getjob.Price2,getgsetup2.decl_uprice)#</div></td>				
						<cfelseif lcase(HcomID) eq "mcjim_i" or lcase(HcomID) eq "acht_i">
               		<td>#NumberFormat(getjob.UCOST,getgsetup2.decl_uprice)#</td>
					</cfif>
                    <cfif getgsetup.fcurrency eq "Y">
                    <td nowrap><div align="center">#getjob.fcurrcode#</div></td>
                    <td nowrap>#NumberFormat(getjob.fucost,getgsetup2.decl_uprice)#</td>
                    <td nowrap>#NumberFormat(getjob.fprice,getgsetup2.decl_uprice)#</td>
                    </cfif>
          			<cfif getpin2.h1311 eq 'T'>
						<td nowrap><div align="center">
							<a href="icitem2.cfm?type=Delete&itemno=#urlencodedformat(getjob.itemno)#" target="_parent"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              				<a href="icitem2.cfm?type=Edit&itemno=#urlencodedformat(getjob.itemno)#" target="_parent"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
						</td>
					</cfif>
        		</tr>
      		</cfloop> 
    	</table>
		<hr>
		<div align="right">
		<cfif start neq 1>
			<a target="_self" href="sicitem_similar.cfm?start=#prevTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="sicitem_similar.cfm?start=#nextTwenty#&searchtype=#urlencodedformat(searchtype)#&searchstr=#urlencodedformat(searchstr)#">Next</a> ||
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