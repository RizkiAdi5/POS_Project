<cfparam name="alcreate" default="0">
<cfparam name="aledit" default="0">
<cfparam name="aldelete" default="0">
<cfparam name="alown" default="0">

<cfquery name="gettranname" datasource="#dts#">
select lconsignin,lconsignout,lISS,lOAI,lOAR from gsetup
</cfquery> 
<cfquery name="getmodule" datasource="#dts#">
    select * from modulecontrol
</cfquery>

<cfif tran eq "ISS">
	<cfset tran = "ISS">
	<cfset tranname = gettranname.lISS>
	<cfset trancode = "issno">
	
	<cfif getpin2.h2821 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2822 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2823 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2824 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
<cfelseif tran eq "TR">
	<cfset tran = "TR">
    <cfif isdefined('consignment')>
    <cfif consignment eq "out">
    <cfset tranname = "#gettranname.lconsignout#">
	<cfset trancode = "trno">
    <cfelseif consignment eq "return">
    <cfset tranname = "#gettranname.lconsignin#">
	<cfset trancode = "trno">
    <cfelse>
    <cfset tranname = "Transfer">
	<cfset trancode = "trno">
    </cfif>
    <cfelse>
	<cfset tranname = "Transfer">
	<cfset trancode = "trno">
	</cfif>
	<cfif getpin2.h28A1 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h28A2 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h28A3 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h28A4 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
<cfelseif tran eq "OAI">
	<cfset tran = "OAI">
	<cfset tranname = gettranname.lOAI>
	<cfset trancode = "oaino">
	
	<cfif getpin2.h2831 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2832 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2833 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2834 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
<cfelseif tran eq "OAR">
	<cfset tran = "OAR">
	<cfset tranname = gettranname.lOAR>
	<cfset trancode = "oarno">
	
	<cfif getpin2.h2841 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
  	
	<cfif getpin2.h2842 eq 'T'>
  		<cfset aledit = 1>
  	</cfif>
  	
	<cfif getpin2.h2843 eq 'T'>
  		<cfset aldelete = 1>
 	</cfif>
 	
	<cfif getpin2.h2844 eq 'T'>
  		<cfset alown = 1>
 	</cfif>
</cfif>

<cfif isdefined('consignment')>
<cfset consignment = consignment>
<cfelse>
<cfset consignment = ''>
</cfif>

<html>
<head>
	<title><cfoutput>Search #tranname#</cfoutput></title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery datasource="#dts#" name="getGeneralInfo">
	Select #trancode# as result, iss_oneset, tr_oneset, oai_oneset, oar_oneset
	from GSetup
</cfquery>
<cfif consignment eq 'out'>
<cfquery datasource="#dts#" name="Checkconsignmentoutno">
select lastUsedNo as result, refnoused as arun from refnoset
	where type = '#tran#'
	and counter = 2
</cfquery>
</cfif>

<cfif consignment eq 'return'>
<cfquery datasource="#dts#" name="Checkconsignmentoutno">
select lastUsedNo as result, refnoused as arun from refnoset
	where type = '#tran#'
	and counter = 3
</cfquery>
</cfif>

<cfquery datasource="#dts#" name="getRefnoset">
	select lastUsedNo as result, refnoused as arun from refnoset
	where type = '#tran#'
	and counter = <cfif consignment eq 'out' and Checkconsignmentoutno.recordcount neq 0>2<cfelseif consignment eq 'return' and Checkconsignmentoutno.recordcount neq 0>3<cfelse>1</cfif>
</cfquery>

<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy,transactionSortBy from dealer_menu limit 1
</cfquery>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">

<cfquery datasource='#dts#' name="getjob">
	Select refno,agenno,wos_date,PRINTSTATUS,name,fperiod,custno,rem8,rem9,source,refno2,userid,void,type from artran where type = '#tran#' <cfif alown eq 1>and (userid = '#huserid#' or agenno = '#huserid#')</cfif> and consignment='#consignment#' order by <cfif getdealer_menu.transactionSortBy neq "">#getdealer_menu.transactionSortBy#<cfelse>wos_date desc</cfif>
</cfquery>

<body>
<cfoutput>
  <h1>Search #tranname#</h1>

<h4>
	<cfif alcreate eq 1>
    <cfif getgeneralinfo.iss_oneset neq '1' and tran eq 'ISS'>
			<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
		<cfelseif getgeneralinfo.tr_oneset neq '1' and tran eq 'TR'>
			<a href="iss0.cfm?ttype=create&tran=#tran#&consignment=#consignment#">Create New #tranname#</a> ||
		<cfelseif getgeneralinfo.oai_oneset neq '1' and tran eq 'OAI'>
			<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
		<cfelseif getgeneralinfo.oar_oneset neq '1' and tran eq 'OAR'>
			<a href="iss0.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> ||
		<cfelse>
    <a href="iss2.cfm?ttype=create&tran=#tran#&consignment=#consignment#">Create New #tranname#</a> || 
	</cfif></cfif>
	<a href="iss.cfm?tran=#tran#&consignment=#consignment#">List all #tranname#</a> ||
	<a href="siss.cfm?tran=#tran#&consignment=#consignment#">Search For #tranname#</a>
    <cfif getmodule.matrixtran eq 1>
         <cfif alcreate eq 1>
         || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/matrixexpressbill/index.cfm?first=true&tran=#tran#','','fullscreen=yes')">
				Matrix New
			</a>
         </cfif>
         </cfif>
     <cfif alcreate eq 1 and tran eq 'TR'>
	 || <a href="/newbody.cfm" target="mainFrame" onClick="window.open('/default/transaction/expresstransfer/index.cfm?first=true&type=#tran#&consignment=#consignment#','','fullscreen=yes,scrollbars=yes')">
				Simple New
                </a>
                </cfif>
</h4>
<cfoutput>
<p><strong><br>Last Used #tran# No :</strong><font color="##FF0000"><strong>#getRefnoset.result#</strong></font></p>
</cfoutput>
<form action="siss.cfm" method="post">
	<h1>Search By :
	<select name="searchType">
    <option value="refno">#tranname# No</option>
		<option value="custno">Authorised By</option>
        <cfif tran eq "TR">
        <option value="locationfr">Location From</option>
        <option value="locationto">Location To</option>		
        </cfif>
        <cfif tran eq "OAI" or tran eq "OAR">
        <option value="name">Reason for Adjustment</option>
        <option value="refno2">Ref No 2</option>
        </cfif>
	</select>
	
	<input type="hidden" name="tran" value="#tran#">
    <input type="hidden" name="consignment" value="#consignment#">
	Search for 
	<input type="text" name="searchStr" value="">
	<cfif husergrpid eq "Muser">
	
		<input type="submit" name="submit" value="Search">
	</cfif>
	</h1>
</form>
</cfoutput>

<cfif isdefined("form.searchStr")>

<cfif form.searchType eq "locationfr">

<cfquery datasource="#dts#" name="exactResult">
		select b.refno,b.agenno,b.wos_date,b.fperiod,b.source,b.refno2,b.rem8,b.rem9,b.custno,b.name,b.userid,b.printstatus,b.void,b.type from ictran as a left join(select refno,agenno,wos_date,fperiod,custno,name,printstatus,userid,void,type,refno2,source,rem8,rem9 from artran where type='TR') as b on a.refno=b.refno where a.type = 'TROU' and a.location =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.searchStr#"> and consignment='#consignment#' group by a.refno order by a.location 
	</cfquery>
	
	<cfquery datasource="#dts#" name="similarResult">
        select b.refno,b.agenno,b.wos_date,b.fperiod,b.refno2,b.source,b.rem8,b.rem9,b.custno,b.name,b.printstatus,b.userid,b.void,b.type from ictran as a left join(select refno,printstatus,agenno,wos_date,fperiod,custno,name,userid,void,type,refno2,source,rem8,rem9 from artran where type='TR') as b on a.refno=b.refno where a.type = 'TROU' and a.location LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> and consignment='#consignment#' group by a.refno order by a.location
	</cfquery>
<cfelseif form.searchType eq "locationto">

<cfquery datasource="#dts#" name="exactResult">
		select b.refno,b.agenno,b.wos_date,b.fperiod,b.name,b.source,b.rem8,b.rem9,b.refno2,b.printstatus,b.custno,b.userid,b.void,b.type from ictran as a left join(select refno,printstatus,agenno,wos_date,fperiod,custno,name,userid,void,type,refno2,source,rem8,rem9 from artran where type='TR') as b on a.refno=b.refno where a.type = 'TRIN' and a.location =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.searchStr#">  and consignment='#consignment#'group by a.refno order by a.location 
	</cfquery>
	
	<cfquery datasource="#dts#" name="similarResult">
        select b.refno,b.agenno,b.wos_date,b.fperiod,b.refno2,b.source,b.rem8,b.printstatus,b.rem9,b.custno,b.name,b.userid,b.void,b.type from ictran as a left join(select refno,printstatus,agenno,wos_date,fperiod,custno,userid,void,type,name,refno2,source,rem8,rem9 from artran where type='TR') as b on a.refno=b.refno where a.type = 'TRIN' and a.location LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> and consignment='#consignment#' group by a.refno order by a.location
	</cfquery>


<cfelse>
	<cfquery datasource="#dts#" name="exactResult">
		select refno,agenno,wos_date,fperiod,custno,printstatus,userid,source,refno2,void,type,name,rem8,rem9 from artran where type = '#tran#' and #form.searchType# =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.searchStr#"> and consignment='#consignment#' order by #form.searchType#
	</cfquery>
	
	<cfquery datasource="#dts#" name="similarResult">
		select refno,agenno,wos_date,fperiod,custno,printstatus,userid,source,refno2,void,type,name,rem8,rem9 from artran where type = '#tran#' and #ucase(form.searchType)# LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> and consignment='#consignment#' order by #form.searchType#
	</cfquery>
</cfif>
	<h2>Exact Result</h2>
	
	<cfif exactResult.recordCount neq 0>
		<table align="center" class="data">
			<tr>
				<th><cfoutput>#tranname#</cfoutput> No</th>
			   	<th>Agent</th>
                <cfif lcase(hcomid) eq "xinbao_i" and (tran eq "ISS")>
                <th>Project</th>
                </cfif>
 			   	<th>Date</th>
  			  	<th>Period</th>
                <cfif tran eq "OAI" or tran eq "OAR">
                <th>Ref No 2</th>
                <th>Reason for Adjustment</th>
                </cfif>
                <cfif lcase(hcomid) eq "simplysiti_i" and tran eq "TR">
       			<th>Courier Type</th>
        		<th>Courier No</th>
        		</cfif>
  			  	<th>Authorised By</th>
  			  	<th>User</th>
                <cfif tran eq "TR">
       		    <th>Transfer From</th>
        		<th>Transfer To</th>
        		</cfif>
				<th>Status</th>
  			  	<th>Action</th>
			</tr>
  			<cfoutput query="exactresult">
				<tr>
					<td>#exactresult.refno#</td>
					<td>#exactresult.agenno#</td>
                    <cfif lcase(hcomid) eq "xinbao_i" and (tran eq "ISS")>
                    <td>#exactresult.source#</td>
                    </cfif>
					<td>#dateformat(exactresult.wos_date,"dd-mm-yyyy")#</td>
					<td>#exactresult.fperiod#</td>
                    <cfif tran eq "OAI" or tran eq "OAR">
                    <td>#exactresult.refno2#</td>
                    <td>#exactresult.name#</td>
        			</cfif>
                    <cfif lcase(hcomid) eq "simplysiti_i" and tran eq "TR">
        			<td>#exactresult.rem8#</td>
        			<td>#exactresult.rem9#</td>
        			</cfif>
        			<cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
                    <cfquery name="getusername" datasource="main">
                    select username from users where userbranch ='#dts#' and userid='#exactresult.custno#'
                    </cfquery>
                    <td>#getusername.username#</td>
                    <cfelse>
					<td nowrap>#exactresult.custno#</td>
                    </cfif>
                    
					<td>#exactresult.userid#</td>
                    <cfif tran eq "TR">
        			<cfquery name="gettransferfrom" datasource="#dts#">
        			select location from ictran where refno='#exactresult.refno#' and type='TROU'
       				</cfquery>
       				<cfquery name="gettransferto" datasource="#dts#">
        			select location from ictran where refno='#exactresult.refno#' and type='TRIN'
        			</cfquery>
                <cfquery name="gettransferfromname" datasource="#dts#">
                select desp from iclocation where location='#gettransferfrom.location#'
                </cfquery>
                <cfquery name="gettransfertoname" datasource="#dts#">
                select desp from iclocation where location='#gettransferto.location#'
                </cfquery>
                <cfif lcase(hcomid) eq "vsolutionspteltd_i">
                <td>#gettransferfromname.desp#</td>
       			<td>#gettransfertoname.desp#</td>
                <cfelse>
        			<td>#gettransferfrom.location#</td>
        			<td>#gettransferto.location#</td>
                </cfif>
        			</cfif>
					<td align="center"><cfif exactresult.void neq ""><font color="red"><strong>Void</strong></font></cfif></td>
					<td nowrap align="right">
						<cfif lcase(hcomid) eq "migif_i" and tran eq "TR">
							<a href="../../billformat/#dts#/consignmentnote.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
                        <cfelseif lcase(hcomid) eq "verjas_i" and tran eq "TR">
                        <a href="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
                        <cfelseif lcase(hcomid) eq "supervalu_i" and tran eq "TR">
				<a href="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
						<cfelse>
							<a href="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
						</cfif>
							
						<cfif aledit eq 1 and exactresult.fperiod neq "99" and exactresult.void eq "" and exactresult.printstatus eq "">
							<a href="iss2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(exactresult.custno)#&consignment=#consignment#">
								<img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit
							</a>
						<cfelse>
							<img height="18px" width="18px" src="../../images/edit.ICO" alt="Not Allowed to Edit" border="0">Edit
						</cfif>
                        <cfif getpin2.H2890 eq 'T'>
                <img height="18px" width="18px" src="../../images/Copy Icon.jpg" alt="Copy" border="0"><a onMouseOver="this.style.cursor='hand'" onClick="window.open('copyfunction.cfm?refno=#refno#&type=#tran#');">Copy</a>
                </cfif>
						<cfif aldelete eq 1 and exactresult.fperiod neq "99" and exactresult.void eq "" and exactresult.printstatus eq "">
							<a href="iss2.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(exactresult.custno)#">
								<img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete
							</a>
						<cfelse>
							<img height="18px" width="18px" src="../../images/delete.ICO" alt="Not Allowed to Delete" border="0">Delete
						</cfif>
					</td>
				</tr>
			</cfoutput>
		</table>
	<cfelse>
		<h3>No Exact Records were found.</h3>
	</cfif>
	
	<h2>Similar Result</h2>
	
	<cfif similarResult.recordCount neq 0>
		<table align="center" class="data">
			<tr>
				<th><cfoutput>#tranname# No</cfoutput></th>
			   	<th>Agent</th>
                <cfif lcase(hcomid) eq "xinbao_i" and (tran eq "ISS")>
                <th>Project</th>
                </cfif>
 			   	<th>Date</th>
  			  	<th>Period</th>
                <cfif tran eq "OAI" or tran eq "OAR">
                <th>Ref No 2</th>
                <th>Reason for Adjustment</th>
                </cfif>
                <cfif lcase(hcomid) eq "simplysiti_i" and tran eq "TR">
                <th>Courier Type</th>
                <th>Courier No</th>
        		</cfif>
  			   	<th>Authorised By</th>
  			  	<th>User</th>
                <cfif tran eq "TR">
       		    <th>Transfer From</th>
        		<th>Transfer To</th>
        		</cfif>
				<th>Status</th>
  			  	<th>Action</th>
			</tr>
  			<cfoutput query="similarResult">
				<tr>
   			   		<td>#similarResult.refno#</td>
			   		<td>#similarResult.agenno#</td>
                    <cfif lcase(hcomid) eq "xinbao_i" and (tran eq "ISS")>
                    <td>#similarResult.source#</td>
                    </cfif>
   			   		<td>#dateformat(similarResult.wos_date,"dd-mm-yyyy")#</td>
   			   		<td>#similarResult.fperiod#</td>
                    <cfif tran eq "OAI" or tran eq "OAR">
                    <td>#similarResult.refno2#</td>
                <td>#similarResult.name#</td>
                </cfif>
                <cfif lcase(hcomid) eq "simplysiti_i" and tran eq "TR">
        			<td>#similarResult.rem8#</td>
        			<td>#similarResult.rem9#</td>
        			</cfif>
                <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
                    <cfquery name="getusername" datasource="main">
                    select username from users where userbranch ='#dts#' and userid='#similarResult.custno#'
                    </cfquery>
                    <td>#getusername.username#</td>
                    <cfelse>
					<td nowrap>#similarResult.custno#</td>
                    </cfif>
                   
					<td>#similarResult.userid#</td>
 
                    <cfif tran eq "TR">
        			<cfquery name="gettransferfrom2" datasource="#dts#">
        			select location from ictran where refno='#similarResult.refno#' and type='TROU'
        			</cfquery>
        			<cfquery name="gettransferto2" datasource="#dts#">
        			select location from ictran where refno='#similarResult.refno#' and type='TRIN'
        			</cfquery>
                    <cfquery name="gettransferfromname2" datasource="#dts#">
                select desp from iclocation where location='#gettransferfrom2.location#'
                </cfquery>
                <cfquery name="gettransfertoname2" datasource="#dts#">
                select desp from iclocation where location='#gettransferto2.location#'
                </cfquery>
                <cfif lcase(hcomid) eq "vsolutionspteltd_i">
        		<td>#gettransferfromname2.desp#</td>
        		<td>#gettransfertoname2.desp#</td>
        		<cfelse>
        			<td>#gettransferfrom2.location#</td>
        			<td>#gettransferto2.location#</td>
                 </cfif>
        			</cfif>
					<td align="center"><cfif similarResult.void neq ""><font color="red"><strong>Void</strong></font></cfif></td>
					<td align="right" nowrap>
						<cfif lcase(hcomid) eq "migif_i" and tran eq "TR">
							<a href="../../billformat/#dts#/consignmentnote.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
                            <cfelseif lcase(hcomid) eq "verjas_i" and tran eq "TR">
                        <a href="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
                        <cfelseif lcase(hcomid) eq "supervalu_i" and tran eq "TR">
				<a href="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
						<cfelse>
							<a href="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
						</cfif>
						<cfif aledit eq 1 and similarResult.fperiod neq "99" and similarResult.void eq "" and similarResult.printstatus eq "">
							<a href="iss2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(similarResult.custno)#&consignment=#consignment#">
								<img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit
							</a>
						<cfelse>
							<img height="18px" width="18px" src="../../images/edit.ICO" alt="Not Allowed to Edit" border="0">Edit
						</cfif>
                        <cfif getpin2.H2890 eq 'T'>
                <img height="18px" width="18px" src="../../images/Copy Icon.jpg" alt="Copy" border="0"><a onMouseOver="this.style.cursor='hand'" onClick="window.open('copyfunction.cfm?refno=#refno#&type=#tran#');">Copy</a>
                </cfif>
            			<cfif aldelete eq 1 and similarResult.fperiod neq "99" and similarResult.void eq "" and similarResult.printstatus eq "">
							<a href="iss2.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(similarResult.custno)#">
								<img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete
							</a>
						<cfelse>
							<img height="18px" width="18px" src="../../images/delete.ICO" alt="Not Allowed to Delete" border="0">Delete
						</cfif>
					</td>
  			  	</tr>
			</cfoutput>
		</table>
	<cfelse>
		<h3>No Similar Records were found.</h3>
	</cfif>
</cfif>

<cfif getjob.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage=round(#getJob.recordcount#/20)>
		
		<cfif getJob.recordcount mod 20 LT 10 and getJob.recordcount mod 20 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>
		
		<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
			<h3 align="center"><font color="#FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
		</cfif>
 	</cfif>
	
	<cfform action="siss.cfm?tran=#tran#&tranname=#tranname#&consignment=#consignment#" method="post">
		<div align="right">Page 
		<cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
		
		<cfset noOfPage = round(getJob.recordcount/20)>
		
		<cfif getJob.recordcount mod 20 LT 10 and getJob.recordcount mod 20 neq 0>
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
		
		<cfoutput>
			<cfif start neq 1>
				|| <a href="siss.cfm?tran=#tran#&start=#prevTwenty#&consignment=#consignment#">Previous</a> ||
			</cfif>
			
			<cfif page neq noOfPage>
				 <a href="siss.cfm?tran=#tran#&start=#evaluate(nextTwenty)#&consignment=#consignment#">Next</a> ||
			</cfif>
		
			Page #page# Of #noOfPage#
		</cfoutput>
			</div>
			<hr>
		
			<table align="center" class="data">
				<tr>
					<td colspan="7"><div align="center"><font color="#336699" size="3" face="Arial, Helvetica, sans-serif"><strong><cfoutput>#tranname#</cfoutput></strong></font></div></td>
				</tr>
				<tr>
					<th><cfoutput>#tranname#</cfoutput> No</th>
					
					<th>Agent</th>
                    <cfif lcase(hcomid) eq "xinbao_i" and (tran eq "ISS")>
                    <th>Project</th>
                    </cfif>
					<th>Date</th>
					<th>Period</th>
                    <cfif tran eq "OAI" or tran eq "OAR">
                    <th>Ref No 2</th>
                <th>Reason for Adjustment</th>
                </cfif>
                	<cfif lcase(hcomid) eq "simplysiti_i" and tran eq "TR">
        			<th>Courier Type</th>
        			<th>Courier No</th>
        			</cfif>
					<th>Authorised By</th>
					<th>User</th>
                    <cfif tran eq "TR">
       		    	<th>Transfer From</th>
        			<th>Transfer To</th>
        			</cfif>
					<th>Status</th>
					<th>Action</th>
			 </tr>
			 
			 <cfoutput query="getjob" startrow="#start#" maxrows="20">
			 	<tr>
      				<td>#getjob.refno#</td>
	  				<td>#getjob.agenno#</td>
                    <cfif lcase(hcomid) eq "xinbao_i" and (tran eq "ISS")>
                    <td>#getjob.source#</td>
                    </cfif>
      				<td>#dateformat(getjob.wos_date,"dd-mm-yyyy")#</td>
      				<td>#getjob.fperiod#</td>
                    <cfif tran eq "OAI" or tran eq "OAR">
                    <td>#getjob.refno2#</td>
                <td>#getjob.name#</td>
                </cfif>
                <cfif lcase(hcomid) eq "simplysiti_i" and tran eq "TR">
        			<td>#getjob.rem8#</td>
        			<td>#getjob.rem9#</td>
        			</cfif>
                <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "kjctrial_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
                    <cfquery name="getusername" datasource="main">
                    select username from users where userbranch ='#dts#' and userid='#getjob.custno#'
                    </cfquery>
                    <td>#getusername.username#</td>
                    <cfelse>
      				<td nowrap>#getjob.custno#</td>
                    </cfif>
                    
      				<td>#getjob.userid#</td>
                    
                    <cfif tran eq "TR">
        			<cfquery name="gettransferfrom3" datasource="#dts#">
        			select location from ictran where refno='#getjob.refno#' and type='TROU'
        			</cfquery>
        			<cfquery name="gettransferto3" datasource="#dts#">
        			select location from ictran where refno='#getjob.refno#' and type='TRIN'
        			</cfquery>
                     <cfquery name="gettransferfromname3" datasource="#dts#">
                select desp from iclocation where location='#gettransferfrom3.location#'
                </cfquery>
                <cfquery name="gettransfertoname3" datasource="#dts#">
                select desp from iclocation where location='#gettransferto3.location#'
                </cfquery>
                <cfif lcase(hcomid) eq "vsolutionspteltd_i">
        		<td>#gettransferfromname3.desp#</td>
        		<td>#gettransfertoname3.desp#</td>
        		<cfelse>
        			<td>#gettransferfrom3.location#</td>
        			<td>#gettransferto3.location#</td>
                    </cfif>
        			</cfif>
					<td align="center"><cfif getjob.void neq ""><font color="red"><strong>Void</strong></font></cfif></td>
          			<td align="right" nowrap>
						<cfif lcase(hcomid) eq "migif_i" and tran eq "TR">
							<a href="../../billformat/#dts#/consignmentnote.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
                            <cfelseif lcase(hcomid) eq "verjas_i" and tran eq "TR">
                        <a href="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
                        <cfelseif lcase(hcomid) eq "supervalu_i" and tran eq "TR">
				<a href="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
						<cfelse>
							<a href="../../billformat/printoptionpage.cfm?tran=#tran#&nexttranno=#refno#&consignment=#consignment#" target="_blank">Print</a>&nbsp;
						</cfif>
						<cfif aledit eq 1 and getjob.fperiod neq "99" and getjob.void eq "" and getjob.printstatus eq "">
							<a href="iss2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(getjob.custno)#&consignment=#consignment#">
								<img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit
							</a>
						<cfelse>
							<img height="18px" width="18px" src="../../images/edit.ICO" alt="Not Allowed to Edit" border="0">Edit
						</cfif>
                        <cfif getpin2.H2890 eq 'T'>
                <img height="18px" width="18px" src="../../images/Copy Icon.jpg" alt="Copy" border="0"><a onMouseOver="this.style.cursor='hand'" onClick="window.open('copyfunction.cfm?refno=#refno#&type=#tran#');">Copy</a>
                </cfif>
            			<cfif aldelete eq 1 and getjob.fperiod neq "99" and getjob.void eq "" and getjob.printstatus eq "">
							<a href="iss2.cfm?tran=#tran#&ttype=Delete&refno=#refno#&custno=#URLEncodedFormat(getjob.custno)#">
								<img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete
							</a>
						<cfelse>
							<img height="18px" width="18px" src="../../images/delete.ICO" alt="Not Allowed to Delete" border="0">Delete
						</cfif>
					</td>
    			</tr>
  			</cfoutput>
		</table>
		<hr>
    	<div align="right">
		<cfoutput>
      		<cfif start neq 1>
        		<a href="siss.cfm?tran=#tran#&start=#prevTwenty#">Previous</a> || 
      		</cfif>
      		<cfif page neq noOfPage>
        		<a href="siss.cfm?tran=#tran#&start=#evaluate(nextTwenty)#">Next</a> || 
			</cfif>
     		Page #page# Of #noOfPage#</div>
  		</cfoutput>
	</cfform>
<cfelse>
	<h3>No Records were found.</h3>
</cfif>

</body>
</html>