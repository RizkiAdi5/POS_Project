<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfif ttype eq "edit">
	<cfset plink = "tran_edit1">
<cfelse>
	<cfset plink = "transaction1">
</cfif>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">

<cfquery datasource="#dts#" name="getGeneralInfo">
	Select invsecure,agentlistuserid from GSetup
</cfquery>

<body>

<cfif husergrpid eq "Muser">
	<a href="../home2.cfm"><u>Home</u></a>
</cfif>

<h1>Customer Selection Page</h1>

<cfoutput>
	<cfif ttype eq "Create">
		<form action="trancustsearch.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&invoicedate=#invoicedate#&ccode=" method="post">
	<cfelse>
		<form action="trancustsearch.cfm?tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&invoicedate=#invoicedate#&ccode=" method="post">
	</cfif>
	
	<cfif getpin2.h1210 eq 'T'>
		<h4><a href="..\maintenance\Customer.cfm?type=Create" target="_blank">Creating a New Customer</a></h4>
	</cfif>
	<cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
		<cfif lcase(Huserloc) eq "malaysia">
			<cfquery name="getLastUsedNo" datasource="#dts#">
				select custno from #target_arcust# 
				where custno <> '300C/999'
				and	custno like '300M/%'
				order by custno desc limit 1
			</cfquery>
			<strong><br>Last Used Customer No. : </strong><font color="##FF0000"><strong><cfif getLastUsedNo.recordcount neq 0>#getLastUsedNo.custno#<cfelse>300M/000</cfif></strong></font>
		<cfelse>
			<cfquery name="getLastUsedNo" datasource="#dts#">
				select a.custno,SUBSTR(a.custno,1,4) 
				from (select custno from #target_arcust# 
						where custno <> '300C/999'
						and	custno not like '300M/%'
						order by custno desc) as a
				group by SUBSTR(a.custno,1,4)
			</cfquery>
			<cfloop query="getLastUsedNo">
				<strong>Last Used Customer No. #getLastUsedNo.currentrow#: </strong><font color="##FF0000"><strong>#getLastUsedNo.custno#</strong></font>&nbsp&nbsp;&nbsp&nbsp;
			</cfloop>
		</cfif>			
	</cfif>
	
	<h1>Search By :
		<select name="searchType">
			<option value="name">Customer Name</option>
			<option value="custno">Customer ID</option>
			<option value="phone">Customer Tel</option>
		</select>
        
		Search for Customer : <input type="text" name="searchStr" value="">
		<cfif husergrpid eq "Muser">
			<input type="submit" name="submit" value="Search">
		</cfif>
	</h1>

		<input type="hidden" name="ttype" value="#ttype#">
		<input type="hidden" name="stype" value="#stype#">
		<input type="hidden" name="tran" value="#tran#">
	</form>
</cfoutput>

<cfquery datasource='#dts#' name="type">
	Select * from #target_arcust# where 0=0 <cfif getpin2.h1250 eq 'T'>and agent = '#huserid#'</cfif> 
     <cfif getpin2.h1t00 eq 'T'>
<cfif getGeneralInfo.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(created_by)='#ucase(huserid)#' or ucase(agent)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
                    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                   
                    <cfelse>
					<cfif Huserloc neq "All_loc">
					and (created_by in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
                    </cfif>
                    </cfif>
	order by <cfif lcase(HcomID) neq "sjgroup_i">created_on desc,Date desc,</cfif>Name
	limit 10
</cfquery>

<cfif isdefined("form.searchStr")>
	<!--- <cfquery dbtype="query" name="exactResult">
		Select * from TYPE where #form.searchType# = '#form.searchStr#' order by #form.searchType#
	</cfquery>

	<cfquery dbtype="query" name="similarResult">
		Select * from TYPE where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by #form.searchType#
	</cfquery> --->
	<cfquery name="exactResult" datasource='#dts#'>
		Select * from #target_arcust# where #form.searchType# = '#form.searchStr#' <cfif getpin2.h1250 eq 'T'>and agent = '#huserid#'</cfif>
        <cfif getpin2.h1t00 eq 'T'>
		<cfif getGeneralInfo.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(created_by)='#ucase(huserid)#' or ucase(agent)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
                    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                   
                    <cfelse>
					<cfif Huserloc neq "All_loc">
					and (created_by in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
                    </cfif>
                    </cfif>

         order by #form.searchType#
	</cfquery>

	<cfquery name="similarResult" datasource='#dts#'>
		Select * from #target_arcust# where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> <cfif getpin2.h1250 eq 'T'>and agent = '#huserid#'</cfif>
        <cfif getpin2.h1t00 eq 'T'>
		<cfif getGeneralInfo.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(created_by)='#ucase(huserid)#' or ucase(agent)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
                    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                   
                    <cfelse>
					<cfif Huserloc neq "All_loc">
					and (created_by in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
                    </cfif>
					</cfif>
         order by #form.searchType#
	</cfquery>
			
	<h2>Exact Result</h2>
	
	<cfif exactResult.recordCount neq 0>
		<table width="600" align="center" class="data">
      		<tr>
				<th>Agent</th>
			   	<th>Cust No</th>
			   	<th>Name</th>
			   	<th>Curr Code</th>
 			   	<th>Address</th>
  			  	<th>Telephone</th>
  			  	<th>Attention</th>
			  	<th>Status</th>
  			  	<th>Action</th>
			</tr>
  			<cfoutput query="exactresult">
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
   					<td nowrap>#exactresult.agent#</td>
					<td nowrap>#exactresult.custno#</td>
          			<td nowrap>#exactresult.name#<br/>#exactresult.name2#</td>
					<td nowrap>#exactresult.currcode#</td>
   			   		<td nowrap>#exactResult.Add1#<br>#exactResult.Add2#<br>#exactResult.Add3#<br>#exactResult.Add4#</td>
   			   		<td nowrap>(1) #exactResult.phone#<br>(2) #exactResult.phonea#</td>
    			  	<td nowrap>#exactResult.attn#<br/><font style="background-color:FFFFFF">#exactResult.e_mail#</font></td>
				  	<td nowrap>#exactResult.status#</td>
    			  	<td nowrap>
				  	<cfif exactResult.status neq "B">
						<cfif ttype eq "Create">
							<a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(exactResult.custno)#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&first=1&invoicedate=#invoicedate#&ccode=">Select</a>
					  	<cfelse>
							<a href="#plink#.cfm?tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(exactResult.custno)#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&first=1&invoicedate=#invoicedate#&ccode=">Select</a>
						</cfif>
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
		<table width="600" align="center" class="data">
        	<tr>
				<th>Agent</th>
				<th>Cust No</th>
				<th>Name</th>
				<th>Curr Code</th>
 			  	<th>Address</th>
				<th>Telephone</th>
				<th>Attention</th>
				<th>Status</th>
				<th>Action</th>
			</tr>
  			<cfoutput query="similarResult">
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			 		<td nowrap>#similarResult.agent#</td>
					<td nowrap>#similarResult.custno#</td>
   			   		<td nowrap>#similarResult.name#<br/>#similarResult.name2#</td>
			   		<td nowrap>#similarResult.currcode#</td>
   			   		<td nowrap>#similarResult.Add1#<br>#similarResult.Add2#<br>#similarResult.Add3#<br>#similarResult.Add4#</td>
   			   		<td nowrap>(1) #similarResult.phone#<br>(2) #similarResult.phonea#</td>
    		   		<td nowrap>#similarResult.attn#<br/><font style="background-color:FFFFFF">#similarResult.e_mail#</font></td>
					<td nowrap>#similarResult.status#</td>
  			   		<td nowrap>	
			   		<cfif similarResult.status neq "B">
			   			<cfif ttype eq "Create">
							<a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(similarResult.custno)#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&first=1&invoicedate=#invoicedate#&ccode=">Select</a>
						<cfelse>
							<a href="#plink#.cfm?tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(similarResult.custno)#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&first=1&invoicedate=#invoicedate#&ccode=">Select</a>
						</cfif>
			   		</cfif>		  
					</td>
  			  	</tr>
 			 </cfoutput>
		</table>
	<cfelse>
		<h3>No Similar Records were found.</h3>
	</cfif>
</cfif>

<hr>
<fieldset>
<legend style="font-family:Verdana,Arial,Helvetica,sans-serif;font-size:12px;font-style:italic;line-height:normal;font-weight:bold;text-transform:capitalize;color:#0066FF;">
	10 Newest Customer:
</legend>
<br>
<cfif type.recordCount neq 0>
	<cfform action="trancustsearch.cfm?nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&invoicedate=#invoicedate#&ccode=" method="post">
		<cfoutput>
			<input type="hidden" name="ttype" value="#ttype#">
			<input type="hidden" name="stype" value="#stype#">
			<input type="hidden" name="tran" value="#tran#">
			
			<cfif ttype eq "Edit" or ttype eq "delete">
				<input type="hidden" name="refno" value="#refno#">
			<cfelse>
			  	<input type="hidden" name="invset" value="#invset#">
			</cfif>
		</cfoutput>
		
		<div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
		
		<cfset noOfPage=round(Type.recordcount/10)>
		
		<cfif type.recordcount mod 10 LT 5 and type.recordcount mod 10 neq 0>
			<cfset noOfPage=noOfPage+1>
		</cfif>
		
		<cfif isdefined("start")>
			<cfset start=start>
		</cfif>

		<cfif isdefined("form.skeypage")>
			<cfset start = val(form.skeypage) * 10 + 1 - 10>
			<cfif form.skeypage eq "1">
				<cfset start = "1">
			</cfif>
		</cfif>

		<cfparam name="i" default="#start#" type="numeric">

		<cfset prevTwenty=start -10>
		<cfset nextTwenty=start +10>
		<cfset page=round(nextTwenty/10)>
		
		<cfif start neq 1>
			<cfif ttype eq "Create">
				<cfoutput>|| <a href="trancustsearch.cfm?invset=#invset#&tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&invoicedate=#invoicedate#&ccode=">Previous</a> ||</cfoutput>
			<cfelse>
				<cfoutput>|| <a href="trancustsearch.cfm?tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&invoicedate=#invoicedate#&ccode=">Previous</a> ||</cfoutput>
			</cfif>
		</cfif>
		
		<cfif page neq noOfPage>
			<cfif ttype eq "Create">
				<cfoutput> <a href="trancustsearch.cfm?invset=#invset#&tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&invoicedate=#invoicedate#&ccode=">Next</a> ||</cfoutput>
			<cfelse>
				<cfoutput> <a href="trancustsearch.cfm?tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&invoicedate=#invoicedate#&ccode=">Next</a> ||</cfoutput>
			</cfif>
		</cfif>

		<cfoutput>Page #page# Of #noOfPage#</cfoutput>
	</cfform>
	
	</div>
	<table align="center" class="data" width="600px">
		<tr>
			<th>No.</th>
			<th>Agent</th>
			<th>Cust No</th>
			<th>Name</th>
			<th>Curr Code</th>
			<th>Address</th>
			<th>Telephone</th>
			<th>Attention</th>
			<th>Status</th>
			<th>Action</th>
		</tr>
		<cfoutput query="type" startrow="#start#" maxrows="10">
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td nowrap>#i#</td>
				<td nowrap>#type.agent#</td>
				<td nowrap>#type.custno#</td>
				<td nowrap>#type.Name#<br />#type.Name2#</td>
				<td nowrap>#type.currcode#</td>
				<td nowrap>#type.Add1#<br>#type.Add2#<br>#type.Add3#<br>#type.Add4#</td>
				<td nowrap>(1) #type.phone#<br>(2) #type.phonea#</td>
				<td nowrap>#type.attn#<br/><font style="background-color:FFFFFF">#type.e_mail#</font></td>
				<td nowrap>#type.status#</td>
				<td nowrap>
					<cfif type.status neq "B">
						<cfif ttype eq "Create">
							<a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(type.custno)#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&first=1&invoicedate=#invoicedate#&ccode=">Select</a>
						<cfelse>
							<a href="#plink#.cfm?tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(type.custno)#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&first=1&invoicedate=#invoicedate#&ccode=">Select</a>
						</cfif>
					</cfif>	
				</td>
			</tr>
			<cfset i = incrementvalue(i)>
		</cfoutput>
	</table>
	
	<hr>
	<div align="right">
   	
	<cfif start neq 1>
		<cfif ttype eq "Create">
			<cfoutput>|| <a href="trancustsearch.cfm?invset=#invset#&tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&invoicedate=#invoicedate#&ccode=">Previous</a> ||</cfoutput>
		<cfelse>
			<cfoutput>|| <a href="trancustsearch.cfm?tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&invoicedate=#invoicedate#&ccode=">Previous</a> ||</cfoutput>
		</cfif>
	</cfif>
	
	<cfif page neq noOfPage>
		<cfif ttype eq "Create">
			<cfoutput> <a href="trancustsearch.cfm?invset=#invset#&tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&invoicedate=#invoicedate#&ccode=">Next</a> ||</cfoutput>
		<cfelse>
			<cfoutput> <a href="trancustsearch.cfm?tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=<!--- #url.dcode# --->&invoicedate=#invoicedate#&ccode=">Next</a> ||</cfoutput>
		</cfif>
	</cfif>
	
	<cfoutput>Page #page# Of #noOfPage#</cfoutput> </div>
<cfelse>
	<h3>No Records were found.</h3>
</cfif>

<br>
</fieldset>
</body>
</html>