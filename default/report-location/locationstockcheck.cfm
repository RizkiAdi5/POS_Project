<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title><cfif hcomid eq "pnp_i">View Location Stock Card Details Menu<cfelse>View <cfif lcase(hcomid) eq "mhca_i">Marketer<cfelse>Location</cfif> Stock Card Menu</cfif></title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

<script type="text/javascript">

function selectlist(custno,fieldtype){

			for (var idx=0;idx<document.getElementById(fieldtype).options.length;idx++) 
			{
        	if (custno==document.getElementById(fieldtype).options[idx].value) 
			{
            document.getElementById(fieldtype).options[idx].selected=true;
        	}
    		} 
			
									}

// begin: product search
function getProduct(type){
	if(type == 'productto'){
		var inputtext = document.form.searchitemto.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult);
		
	}else{
		var inputtext = document.form.searchitemfr.value;
		DWREngine._execute(_reportflocation, null, 'productlookup', inputtext, getProductResult2);
	}
}

function getProductResult(itemArray){
	DWRUtil.removeAllOptions("productto");
	DWRUtil.addOptions("productto", itemArray,"KEY", "VALUE");
}

function getProductResult2(itemArray){
	DWRUtil.removeAllOptions("productfrom");
	DWRUtil.addOptions("productfrom", itemArray,"KEY", "VALUE");
}
// end: product search

// begin: category search
function getCategory(type){
	if(type == 'catefrom'){
		var inputtext = document.form.searchcatefr.value;
		DWREngine._execute(_reportflocation, null, 'categorylookup', inputtext, getCategoryResult);
	}else{
		var inputtext = document.form.searchcateto.value;
		DWREngine._execute(_reportflocation, null, 'categorylookup', inputtext, getCategoryResult2);
	}
}

function getCategoryResult(cateArray){
	DWRUtil.removeAllOptions("catefrom");
	DWRUtil.addOptions("catefrom", cateArray,"KEY", "VALUE");
}

function getCategoryResult2(cateArray){
	DWRUtil.removeAllOptions("cateto");
	DWRUtil.addOptions("cateto", cateArray,"KEY", "VALUE");
}
// end: category search

// begin: group search
function getGroup(type){
	if(type == 'groupfrom'){
		var inputtext = document.form.searchgroupfr.value;
		DWREngine._execute(_reportflocation, null, 'grouplookup', inputtext, getGroupResult);
		
	}
	else{
		var inputtext = document.form.searchgroupto.value;
		DWREngine._execute(_reportflocation, null, 'grouplookup', inputtext, getGroupResult2);
	}
}

function getGroupResult(groupArray){
	DWRUtil.removeAllOptions("groupfrom");
	DWRUtil.addOptions("groupfrom", groupArray,"KEY", "VALUE");
}

function getGroupResult2(groupArray){
	DWRUtil.removeAllOptions("groupto");
	DWRUtil.addOptions("groupto", groupArray,"KEY", "VALUE");
}
// end: group search

function CheckAssign(){
	//var cateto = trim(document.form.cateto.value);
	//var groupto = trim(document.form.groupto.value);
	//var productto = trim(document.form.productto.value);
	
	if(document.form.cateto.value == ""){
		document.form.cateto.value = trim(document.form.catefrom.value);
	}
	if(document.form.groupto.value == ""){
		document.form.groupto.value = trim(document.form.groupfrom.value);
	}
	if(document.form.productto.value == ""){
		document.form.productto.value = trim(document.form.productfrom.value);
	}
	if(document.form.locto.value == ""){
		document.form.locto.value = trim(document.form.locfrom.value);
	}
	
	setTimeout('clearFields()', 200); 
	return true;
}

// Clear Form
function clearFields(){
	document.form.reset();
}

// This function is for stripping leading and trailing spaces
function trim(str){     
	if(str != null){        
		var i;         
		for(i=0; i<str.length; i++){            
			if (str.charAt(i)!=" "){                
				str=str.substring(i,str.length);                 
				break;            
			}         
		}             
		for(i=str.length-1; i>=0; i--){            
			if(str.charAt(i)!=" "){                
				str=str.substring(0,i+1);                 
				break;            
			}         
		}                 
		if(str.charAt(0)==" "){            
			return "";         
		}else{            
			return str;         
		}   
	}
}
</script>

</head>

<!--- <cfquery name="getlocation" datasource="#dts#">
	select 
	location,
	desp 
	from iclocation 
	order by location;
</cfquery> --->

<!--- ADD ON 210908 --->
<cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear,filterall,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION,singlelocation from gsetup
</cfquery>

<cfif isdefined("form.lastaccdaterange") and form.lastaccdaterange neq "">
	<cfquery name="getdate" datasource="#dts#">
		select LastAccDate,ThisAccDate FROM icitem_last_year
		where LastAccDate = #form.lastaccdaterange#
		limit 1
	</cfquery>
	<cfset clsyear = year(form.lastaccdaterange)>
	<cfset clsmonth = month(form.lastaccdaterange)>
	<cfset thislastaccdate = form.lastaccdaterange>
    <cfset diffmth= DateDiff("m",getdate.LastAccDate,getdate.ThisAccDate)>
<cfelse>

	<cfset clsyear = year(getgeneral.lastaccyear)>
	<cfset clsmonth = month(getgeneral.lastaccyear)>
	<cfset thislastaccdate = "">
</cfif>

<!--- Add On 15-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy from dealer_menu limit 1
</cfquery>

<cfif lcase(hcomid) eq "pnp_i">
	<cfquery name="getlocation" datasource="#dts#">
		select 
		if(location_count<>1,x.location,y.location) as location,
		if(location_count<>1,x.desp,y.desp) as desp 
		
		from
		(  select count(a.location) as location_count
			from iclocation as a,user_id_location as b
			where b.userid='#huserid#'
			and a.location=if(b.location='',a.location,b.location)
			group by null
		) as z
	
		left outer join
		(
			(
				select
				'' as location,
				'Choose a Location' as desp
			)
			union
			(
				select
				a.location,
				a.desp
				from iclocation as a,user_id_location as b
				where b.userid='#huserid#'
				and a.location=if(b.location='',a.location,b.location)
				order by a.location
			)
		) as x on z.location_count<>1
	
	  left outer join
		(
			select
			a.location,
			a.desp
			from iclocation as a,user_id_location as b
			where b.userid='#huserid#'
			and a.location=if(b.location='',a.location,b.location)
			order by a.location
		) as y on z.location_count=1
		
		order by location;
	</cfquery>
<cfelse>
	<cfquery name="getlocation" datasource="#dts#">
		select <cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser"> substring_index(location,'-',1) as </cfif>location,<cfif (lcase(hcomid) eq "swisspost_i" or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser"> substring_index(location,'-',1) as </cfif>desp 
		from iclocation
        where 1=1 
		<cfif getpin2.h4700 eq 'T' and HUserGrpID neq 'Super' and Huserloc neq "All_loc">
			 and location in (#ListQualify(Huserloc,"'",",")#)
		</cfif>
        <cfif lcase(hcomid) eq "simplysiti_i" and husergrpid eq "sales">
        and location not like '%OFFICE%' and location not like '%WAREHOUSE%'
        </cfif>
        <cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser">
        	group by substring_index(location,'-',1)
		</cfif>
		order by <cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser">substring_index(location,'-',1)<cfelse>location</cfif>
	</cfquery>
</cfif>

<!--- <cfquery name="getitem" datasource="#dts#">
	select 
	itemno,
	desp 
	from icitem 
	order by itemno;
</cfquery> --->
<cfquery name="getitem" datasource="#dts#">
	select itemno,<cfif lcase(hcomid) eq "vsolutionspteltd_i">concat(aitemno,' ------',desp) as desp<cfelse>desp</cfif> from icitem 
    <cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser">
    <cfset wos_group =HUserid>
    WHERE wos_group = "#wos_group#"
	</cfif>
    order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
</cfquery>

<cfquery name="getgroup" datasource="#dts#">
	select 
	wos_group,
	desp 
	from icgroup 
	<cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser">
    <cfset wos_group = HUserid>
    WHERE wos_group = "#wos_group#"
	</cfif>
	order by wos_group;
    
</cfquery>

<cfquery name="getcate" datasource="#dts#">
	select 
	cate,
	desp 
	from iccate 
	order by cate;
</cfquery>

<cfquery name="getbrand" datasource="#dts#">
	select 
	brand,
	desp 
	from brand 
	order by brand;
</cfquery>

<cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
	<cfquery name="getusergroup" datasource="main">
    	select * from users
        where userid = '#HUserID#'
    </cfquery>
    <cfset usergrp = getusergroup.userGrpID>
</cfif>
<body>

<!--- <h1 align="center"><cfif hcomid eq "pnp_i">View Location Stock Card Details<cfelse>View <cfif lcase(hcomid) eq "mhca_i">Marketer<cfelse>Location</cfif> Stock Card</cfif></h1> --->
<h3>
	<a href="location_listingmenu.cfm"><cfoutput>#getgeneral.lLOCATION#</cfoutput> Reports Menu</a> >> 
	<a><font size="2">View <cfoutput>#getgeneral.lLOCATION#</cfoutput> Stock Card <cfif hcomid eq "pnp_i">Details</cfif></font></a>
</h3>

<cfform action="locationstockcheck2.cfm" name="form" method="post" target="_blank">
<cfoutput><input type="hidden" name="thislastaccdate" value="#thislastaccdate#"></cfoutput>
	<table width="65%" border="0" align="center" class="data">
    <tr>
		<th>Report Format<cfoutput><input type="hidden" name="tran" id="tran" value="#target_apvend#" /><input type="hidden" name="fromto" id="fromto" value="" /></cfoutput></th>
	</tr>
    <tr>
    <td nowrap>
			<input type="radio" name="result" value="HTML" checked>HTML<br/>
			<input type="radio" name="result" value="EXCELDEFAULT">EXCEL DEFAULT<br/>
		</td>
    </tr>
	<tr>
		<td nowrap><input type="checkbox" name="include0" id="1" value="yes"> <label for="include0">Include 0 Figure</label></td>
        <td nowrap colspan="2"><input type="checkbox" name="groupitem" id="1" value="yes"  <cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser">style="visibility:hidden" checked </cfif>> <label <cfif (lcase(hcomid) eq "swisspost_i"  or lcase(hcomid) eq "swisspostdemo_i") and husergrpid eq "luser">style="visibility:hidden"</cfif> for="groupitem">Group Location</label>&nbsp;&nbsp;&nbsp;<input type="checkbox" name="dodate" id="dodate" value="yes" checked> <label for="include0">According to DO Date</label>&nbsp;&nbsp;&nbsp;<input type="checkbox" name="reserve" id="reserve" value="yes"> <label for="include0">Include reserved Qty</label></td>
        </tr>
    	<tr> 
      		<th><cfoutput>#getgeneral.lCATEGORY#</cfoutput></th>
      		<td><div align="center">From</div></td>
      		<td colspan="2">
				<select name="catefrom">
          			<option value="">Choose a <cfoutput>#getgeneral.lCATEGORY#</cfoutput></option>
          			<cfoutput query="getcate"> 
            		<option value="#getcate.cate#">#getcate.cate# - #getcate.desp#</option>
          			</cfoutput>
				</select>
                <cfif getgeneral.filterall eq "1">
					<input type="text" name="searchcatefr" onKeyUp="getCategory('catefrom');">
				</cfif>
			</td>
    	</tr>
    	<tr> 
      		<th><cfoutput>#getgeneral.lCATEGORY#</cfoutput></th>
			<td><div align="center">To</div></td>
      		<td colspan="2">
				<select name="cateto">
          			<option value="">Choose a <cfoutput>#getgeneral.lCATEGORY#</cfoutput></option>
          			<cfoutput query="getcate"> 
            		<option value="#getcate.cate#">#getcate.cate# - #getcate.desp#</option>
          			</cfoutput>
				</select>
				
                <cfif getgeneral.filterall eq "1">
					<input type="text" name="searchcateto" onKeyUp="getCategory('cateto');">
				</cfif>
			</td>
		</tr>
    	<tr>
			<td height="24" colspan="5"> <hr></td>
    	</tr>
    	<tr>
			<th width="16%"><cfoutput>#getgeneral.lGROUP#</cfoutput></th>
      		<td width="5%"><div align="center">From</div></td>
      		<td colspan="2">
				<select name="groupfrom">
					<option value="">Choose a <cfoutput>#getgeneral.lGROUP#</cfoutput></option>
					<cfoutput query="getgroup"> 
					<option value="#getgroup.wos_group#">#getgroup.wos_group# - #getgroup.desp#</option>
					</cfoutput>
				</select>
                <cfif getgeneral.filterall eq "1">
					<input type="text" name="searchgroupfr" onKeyUp="getGroup('groupfrom');">
				</cfif>
			</td>
    	</tr>
    	<tr>
		<th><cfoutput>#getgeneral.lGROUP#</cfoutput></th>
			<td><div align="center">To</div></td>
      		<td colspan="2" nowrap>
				<select name="groupto">
          			<option value="">Choose a <cfoutput>#getgeneral.lGROUP#</cfoutput></option>
        			<cfoutput query="getgroup"> 
					<option value="#getgroup.wos_group#">#getgroup.wos_group# - #getgroup.desp#</option>
					</cfoutput>
				</select>
				
                <cfif getgeneral.filterall eq "1">
					<input type="text" name="searchgroupto" onKeyUp="getGroup('groupto');">
				</cfif>
			</td>
    	</tr>
		<tr>
			<td height="24" colspan="5"> <hr></td>
    	</tr>
        <tr> 
      		<th><cfoutput>Brand</cfoutput></th>
      		<td><div align="center">From</div></td>
      		<td colspan="2">
				<select name="brandfrom">
          			<option value="">Choose a <cfoutput>Brand</cfoutput></option>
          			<cfoutput query="getbrand"> 
            		<option value="#getbrand.brand#">#getbrand.brand# - #getbrand.desp#</option>
          			</cfoutput>
				</select>
			</td>
    	</tr>
    	<tr> 
      		<th><cfoutput>Brand</cfoutput></th>
			<td><div align="center">To</div></td>
      		<td colspan="2">
				<select name="brandto">
          			<option value="">Choose a <cfoutput>Brand</cfoutput></option>
          			<cfoutput query="getbrand"> 
            		<option value="#getbrand.brand#">#getbrand.brand# - #getbrand.desp#</option>
          			</cfoutput>
				</select>
				
			</td>
		</tr>
    	<tr>
			<td height="24" colspan="5"> <hr></td>
    	</tr>
    	<tr> 
      		<th width="16%">Product</th>
      		<td width="5%"> <div align="center">From</div></td>
      		<td colspan="2">
				<select name="productfrom">
          			<option value="">Choose a product</option>
          			<cfoutput query="getitem"> 
            		<option value="#convertquote(getitem.itemno)#">#getitem.itemno# - #getitem.desp#</option>
          			</cfoutput>
				</select>
                <cfif getgeneral.filterall eq "1">
                <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='from';ColdFusion.Window.show('finditem');" />&nbsp;
					<input type="text" name="searchitemfr" onKeyUp="getProduct('productfrom');">
				</cfif>
			</td>
    	</tr>
    	<tr> 
      		<th>Product</th>
      		<td><div align="center">To</div></td>
      		<td colspan="2" nowrap>
				<select name="productto">
          			<option value="">Choose a product</option>
          			<cfoutput query="getitem"> 
            		<option value="#convertquote(getitem.itemno)#">#getitem.itemno# - #getitem.desp#</option>
          			</cfoutput>
				</select>
                <cfif getgeneral.filterall eq "1">
                <input type="button" size="10" value="Ajax Search" onClick="document.getElementById('fromto').value='to';ColdFusion.Window.show('finditem');" />&nbsp;
					<input type="text" name="searchitemto" onKeyUp="getProduct('productto');">
				</cfif>
			</td>
    	</tr>
        <cfif lcase(hcomid) neq "ecraft_i" and lcase(hcomid) neq "ovas_i">
            <tr> 
                <td height="24" colspan="5"> <hr></td>
            </tr>
            <cfoutput>
            <tr> 
                <th>Period</th>
                <td><div align="center">From</div></td>
                <td colspan="2">
                <cfif isdefined("form.lastaccdaterange") and form.lastaccdaterange neq "">
					<select name="periodfrom">
						<cfloop from="1" to="#diffmth#" index="a">
							<option value="#numberformat(a,"00")#">Period #numberformat(a,"00")# - #dateformat(dateadd('m',iif(year(dateadd("d",1,form.lastaccdaterange)) eq year(form.lastaccdaterange) and month(dateadd("d",1,form.lastaccdaterange)) eq month(form.lastaccdaterange),DE(numberformat((a-1),"00")),DE(numberformat((a),"00"))),form.lastaccdaterange),'mmm yyyy')#</option>
						</cfloop>
					</select>
				<cfelse>
                    <select name="periodfrom">
					<option value="">Choose a period</option>
					<option value="01">Period 01 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("00"),DE("01")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="02">Period 02 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("01"),DE("02")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="03">Period 03 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("02"),DE("03")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="04">Period 04 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("03"),DE("04")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="05">Period 05 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("04"),DE("05")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="06">Period 06 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("05"),DE("06")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="07">Period 07 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("06"),DE("07")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="08">Period 08 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("07"),DE("08")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="09">Period 09 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("08"),DE("09")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="10">Period 10 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("09"),DE("10")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="11">Period 11 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("10"),DE("11")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="12">Period 12 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("11"),DE("12")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="13">Period 13 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("12"),DE("13")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="14">Period 14 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("13"),DE("14")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="15">Period 15 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("14"),DE("15")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="16">Period 16 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("15"),DE("16")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="17">Period 17 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("16"),DE("17")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="18">Period 18 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("17"),DE("18")),getgeneral.lastaccyear),'mmm yyyy')#</option>
				</select>
                </cfif>
                </td>
            </tr>
            <tr> 
                <th>Period</th>
                <td><div align="center">To</div></td>
                <td colspan="2"><cfif isdefined("form.lastaccdaterange") and form.lastaccdaterange neq "">
					<select name="periodto">
						<cfloop from="1" to="#diffmth#" index="a">
							<option value="#numberformat(a,"00")#">Period #numberformat(a,"00")# - #dateformat(dateadd('m',iif(year(dateadd("d",1,form.lastaccdaterange)) eq year(form.lastaccdaterange) and month(dateadd("d",1,form.lastaccdaterange)) eq month(form.lastaccdaterange),DE(numberformat((a-1),"00")),DE(numberformat((a),"00"))),form.lastaccdaterange),'mmm yyyy')#</option>
						</cfloop>
					</select>
				<cfelse><select name="periodto">
					<option value="">Choose a period</option>
					<option value="01">Period 01 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("00"),DE("01")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="02">Period 02 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("01"),DE("02")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="03">Period 03 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("02"),DE("03")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="04">Period 04 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("03"),DE("04")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="05">Period 05 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("04"),DE("05")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="06">Period 06 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("05"),DE("06")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="07">Period 07 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("06"),DE("07")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="08">Period 08 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("07"),DE("08")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="09">Period 09 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("08"),DE("09")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="10">Period 10 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("09"),DE("10")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="11">Period 11 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("10"),DE("11")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="12">Period 12 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("11"),DE("12")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="13">Period 13 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("12"),DE("13")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="14">Period 14 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("13"),DE("14")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="15">Period 15 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("14"),DE("15")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="16">Period 16 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("15"),DE("16")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="17">Period 17 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("16"),DE("17")),getgeneral.lastaccyear),'mmm yyyy')#</option>
					<option value="18">Period 18 - #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE("17"),DE("18")),getgeneral.lastaccyear),'mmm yyyy')#</option>
				</select>&nbsp;</cfif></td>
          </tr>
          </cfoutput>
            <tr> 
                <td height="24" colspan="5"> <hr></td>
            </tr>
            <tr> 
                <th width="16%">Date</th>
                <td width="5%"> <div align="center">From</div></td>
                <td colspan="2"><cfinput type="text" name="datefrom" maxlength="10" validate="eurodate" size="10"> (DD/MM/YYYY)</td>
            </tr>
            <tr>
                <th width="16%">Date</th>
                <td width="5%"> <div align="center">To</div></td>
                <td colspan="2"> <cfinput type="text" name="dateto" maxlength="10" validate="eurodate" size="10"> (DD/MM/YYYY)</td>
            </tr>
           <!---  <tr> 
                <td colspan="4"><hr></td>
            </tr>
            <tr> 
                <th>Location</th>
                <td><div align="center">From</div></td>
                <td colspan="2">
                    <select name="locfrom">
                        <option value="">Choose a Location</option>
                        <cfoutput query="getlocation"> 
                        <option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <th>Location</th>
                <td><div align="center">To</div></td>
                <td width="69%">
                    <select name="locto">
                    <option value="">Choose a Location</option>
                    <cfoutput query="getlocation"> 
                        <option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
                        </cfoutput>
                    </select>
                </td>
                <td width="10%"><input type="Submit" name="Submit" value="Submit"></td>
            </tr> --->
		<cfelse>
        	<cfif findnocase("Sales",usergrp)>
                <input type="hidden" name="periodfrom" value="">
                <input type="hidden" name="periodto" value="">
                <input type="hidden" name="datefrom" value="">
                <input type="hidden" name="dateto" value="">
			<cfelse>
            	<tr> 
                    <td height="24" colspan="5"> <hr></td>
                </tr>
                <tr> 
                    <th>Period</th>
                    <td><div align="center">From</div></td>
                    <td colspan="2">
                        <select name="periodfrom">
                            <option value="">Choose a period</option>
                            <option value="01">1</option>
                            <option value="02">2</option>
                            <option value="03">3</option>
                            <option value="04">4</option>
                            <option value="05">5</option>
                            <option value="06">6</option>
                            <option value="07">7</option>
                            <option value="08">8</option>
                            <option value="09">9</option>
                            <option value="10">10</option>
                            <option value="11">11</option>
                            <option value="12">12</option>
                            <option value="13">13</option>
                            <option value="14">14</option>
                            <option value="15">15</option>
                            <option value="16">16</option>
                            <option value="17">17</option>
                            <option value="18">18</option>
                        </select>
                    </td>
                </tr>
                <tr> 
                    <th>Period</th>
                    <td><div align="center">To</div></td>
                    <td colspan="2">
                        <select name="periodto">
                            <option value="">Choose a period</option>
                            <option value="01">1</option>
                            <option value="02">2</option>
                            <option value="03">3</option>
                            <option value="04">4</option>
                            <option value="05">5</option>
                            <option value="06">6</option>
                            <option value="07">7</option>
                            <option value="08">8</option>
                            <option value="09">9</option>
                            <option value="10">10</option>
                            <option value="11">11</option>
                            <option value="12">12</option>
                            <option value="13">13</option>
                            <option value="14">14</option>
                            <option value="15">15</option>
                            <option value="16">16</option>
                            <option value="17">17</option>
                            <option value="18">18</option>
                        </select>
                    </td>
                </tr>
                <tr> 
                    <td height="24" colspan="5"> <hr></td>
                </tr>
                <tr> 
                    <th width="16%">Date</th>
                    <td width="5%"> <div align="center">From</div></td>
                    <td colspan="2"><cfinput type="text" name="datefrom" maxlength="10" validate="eurodate" size="10"> (DD/MM/YYYY)</td>
                </tr>
                <tr>
                    <th width="16%">Date</th>
                    <td width="5%"> <div align="center">To</div></td>
                    <td colspan="2"> <cfinput type="text" name="dateto" maxlength="10" validate="eurodate" size="10"> (DD/MM/YYYY)</td>
                </tr>
                <!--- <tr> 
                    <td colspan="4"><hr></td>
                </tr>
                <tr> 
                    <th>Location</th>
                    <td><div align="center">From</div></td>
                    <td colspan="2">
                        <select name="locfrom">
                            <option value="">Choose a Location</option>
                            <cfoutput query="getlocation"> 
                            <option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>Location</th>
                    <td><div align="center">To</div></td>
                    <td width="69%">
                        <select name="locto">
                        <option value="">Choose a Location</option>
                        <cfoutput query="getlocation"> 
                            <option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td width="10%"><input type="Submit" name="Submit" value="Submit"></td>
                </tr> --->
			</cfif>
		</cfif>
    	<tr> 
        	<td colspan="4"><hr></td>
        </tr>
        <cfif getgeneral.singlelocation eq 'Y'>
        <tr> 
        	<th><cfoutput>#getgeneral.lLOCATION#</cfoutput></th>
            <td><div align="center">From</div></td>
            <td colspan="2">
            	<select name="locfrom">
					<!--- <option value="">Choose a Location</option> --->
                    <cfoutput query="getlocation"> 
                    	<option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
                    </cfoutput>
                </select>
            </td>
		</tr>
        <cfelse>
        <tr> 
        	<th><cfoutput>#getgeneral.lLOCATION#</cfoutput></th>
            <td><div align="center">From</div></td>
            <td colspan="2">
            	<select name="locfrom">
					<cfif lcase(hcomid) eq "pnp_i">
						<cfif getlocation.recordcount neq 1>
							<option value="">Choose a <cfoutput>#getgeneral.lLOCATION#</cfoutput></option>
						</cfif>
					<cfelse>
	                	<cfif HUserGrpID eq 'Super' or getpin2.h4700 neq 'T'>
	          				<option value="">Choose a <cfoutput>#getgeneral.lLOCATION#</cfoutput></option>
						</cfif>
					</cfif>
					<!--- <option value="">Choose a Location</option> --->
                    <cfoutput query="getlocation"> 
                    	<option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
                    </cfoutput>
                </select>
            </td>
		</tr>
        
		<tr>
        	<th><cfoutput>#getgeneral.lLOCATION#</cfoutput></th>
            <td><div align="center">To</div></td>
            <td width="69%">
            	<select name="locto">
					<cfif lcase(hcomid) eq "pnp_i">
						<cfif getlocation.recordcount neq 1>
							<option value="">Choose a <cfoutput>#getgeneral.lLOCATION#</cfoutput></option>
						</cfif>
					<cfelse>
						<cfif HUserGrpID eq 'Super' or getpin2.h4700 neq 'T'>
	          				<option value="">Choose a <cfoutput>#getgeneral.lLOCATION#</cfoutput></option>
						</cfif>
					</cfif>
                	<!--- <option value="">Choose a Location</option> --->
                    <cfoutput query="getlocation"> 
                        <option value="#getlocation.location#">#getlocation.location# - #getlocation.desp#</option>
                    </cfoutput>
                </select>
            </td>
            
        </tr>
        </cfif>
        <tr>
        <td colspan="4" align="center"><input type="Submit" name="Submit" value="Submit" <cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">onclick="return CheckAssign();"</cfif>></td>
        </tr>
  	</table>
</cfform>
<cfwindow width="550" height="400" name="finditem" refreshOnShow="true"
        title="Find Item" initshow="false"
        source="finditem.cfm?type=Product&fromto={fromto}" />
</body>
</html>