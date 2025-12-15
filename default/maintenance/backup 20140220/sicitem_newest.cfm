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

<cfquery name="getrecordcount" datasource="#dts#">
	select count(itemno) as totalrecord 
	from icitem 
    <cfif Hitemgroup neq ''>
            where wos_group='#Hitemgroup#'
            </cfif>
	order by wos_date
</cfquery>

<body>
<cfoutput>
<cfif getrecordcount.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage = round(getrecordcount.totalrecord/20)>
		<cfif getrecordcount.totalrecord mod 20 LT 10 and getrecordcount.totalrecord mod 20 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>
		
		<cfif form.skeypage gt noofpage or form.skeypage lt 1>
			<h3 align="center"><font color="FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
		</cfif>
 	</cfif>
	
	<cfform action="sicitem_newest.cfm" method="post" target="_self">
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
		
		<cfquery datasource='#dts#' name="getjob">
			select a.*,m.desp as mdesp
			from icitem a
			left join iccolorid m on (a.colorid=m.colorid)
            <cfif Hitemgroup neq ''>
            where a.wos_group='#Hitemgroup#'
            </cfif>
			order by a.created_on desc,a.wos_date desc
			limit #start-1#,20;
		</cfquery>

		<cfif start neq 1>
			|| <a target="_self" href="sicitem_newest.cfm?start=#prevTwenty#">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="sicitem_newest.cfm?start=#nextTwenty#">Next</a> ||
		</cfif>

		Page #page# Of #noOfPage#
		</div>
		<hr>

		<table align="center" class="data" width="600px">
      		<tr> 
				<th>No.</th>
        		<th><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>Item No</cfif></th>
        		<th>Description</th>
                <cfif lcase(HcomID) neq "pengwang_i">
        		<th>Brand</th>
                </cfif>
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
                    <cfif lcase(HcomID) neq "pengwang_i">
          			<td nowrap>#getjob.brand#</td>
                    </cfif>
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
	        			<td nowrap><div align="right">#NumberFormat(getjob.Price2,getgsetup2.decl_uprice)#</div></td>				<cfelseif lcase(HcomID) eq "mcjim_i" or lcase(HcomID) eq "acht_i">
                        <td nowrap><div align="right">#NumberFormat(getjob.UCOST,getgsetup2.decl_uprice)#</div></td>
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
			|| <a target="_self" href="sicitem_newest.cfm?start=#prevTwenty#">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a target="_self" href="sicitem_newest.cfm?start=#nextTwenty#">Next</a> ||
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