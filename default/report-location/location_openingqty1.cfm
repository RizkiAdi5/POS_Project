<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Location Opening Qty</title>
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
	<a><font size="2">View <cfoutput>#getgeneral.lLOCATION#</cfoutput> Opening Qty</font></a>
</h3>

<cfform action="location_openingqty2.cfm" name="form" method="post" target="_blank">
<cfoutput><input type="hidden" name="thislastaccdate" value="#thislastaccdate#"></cfoutput>
	<table width="65%" border="0" align="center" class="data">
    <tr>
		<th>Report Format<cfoutput><input type="hidden" name="tran" id="tran" value="#target_apvend#" /><input type="hidden" name="fromto" id="fromto" value="" /></cfoutput></th>
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
        <td colspan="4" align="center"><input type="Submit" name="Submit" value="Submit"></td>
        </tr>
  	</table>
</cfform>
<cfwindow width="550" height="400" name="finditem" refreshOnShow="true"
        title="Find Item" initshow="false"
        source="finditem.cfm?type=Product&fromto={fromto}" />
</body>
</html>