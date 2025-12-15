<cfif ttype eq "edit">
	<cfset plink = "tran_edit1">
<cfelse>
	<cfset plink = "transaction1">
</cfif>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">

<cfset typeNo="custno">
<cfset link = "custsearch.cfm">

<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<h1>Supplier Selection Page</h1>

<cfoutput>
	<cfif ttype eq "Create">
		<form action="transuppsearch.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&invoicedate=#invoicedate#" method="post">
	<cfelse>
		<form action="transuppsearch.cfm?tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&invoicedate=#invoicedate#" method="post">
	</cfif>
</cfoutput>

<h4><a href="..\maintenance\Supplier.cfm?type=Create" target="_blank">Creating a New Supplier</a></h4>

<cfoutput>
	<h1>Search By :
	<select name="searchType">
		<option value="name">Supplier Name</option>
		<option value="#typeNo#">Supplier ID</option>
		<option value="phone">Supplier Tel</option>
	</select>
	Search for Supplier : 
	<input type="text" name="searchStr" value="">
	
	<cfif husergrpid eq "Muser">
		<input type="submit" name="submit" value="Search">
	</cfif> 
	<!--- <input type="hidden" name="ttype" value="#ttype#">
	<input type="hidden" name="stype" value="#stype#">
	<input type="hidden" name="tran" value="tran=#tran#"> --->
	</form>
	</h1>
</cfoutput>

<cfquery datasource='#dts#' name="type">
	select * from #target_apvend# 
	order by created_on desc,Date desc,Name
	limit 100
</cfquery>

<cfif isdefined("form.searchStr")>
	<!--- <cfquery dbtype="query" name="exactResult">
		Select * from TYPE where #form.searchType# = '#form.searchStr#' order by #form.searchType#
	</cfquery>

	<cfquery dbtype="query" name="similarResult">
		Select * from TYPE where #form.searchType# LIKE '#form.searchStr#' order by #form.searchType#
	</cfquery> --->
	<cfquery name="exactResult" datasource='#dts#'>
		Select * from #target_apvend# where #form.searchType# = '#form.searchStr#' order by #form.searchType#
	</cfquery>

	<cfquery name="similarResult" datasource='#dts#'>
		Select * from #target_apvend# where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by #form.searchType#
	</cfquery>
	
	<h2>Exact Result</h2>
	<cfif exactResult.recordCount neq 0>
		<table width="700" align="center" class="data">
			<tr>
				<th>Cust No</th>
			   	<th>Name</th>
			   	<th>Curr Code</th>
 			   	<th>Address</th>
  			  	<th>Telephone</th>
  			  	<th>Attention</th>
  			  	<th>Action</th>
			</tr>
  			
			<cfoutput query="exactresult">
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
    				<td nowrap>#exactresult.custno#</td>
          			<td nowrap>#exactresult.name#</td>
					<td nowrap>#exactresult.currcode#</td>
   			   		<td nowrap>#exactResult.Add1#<br>#exactResult.Add2#<br>#exactResult.Add3#<br>#exactResult.Add4#</td>
   			   		<td nowrap>(1) #exactResult.phone#<br>(2) #exactResult.phonea#</td>
    			  	<td nowrap>#exactResult.attn#<br/><font style="background-color:FFFFFF">#exactResult.e_mail#</font></td>
    			  	<td nowrap>
				  	<cfif ttype eq "Create">
				  		<a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(exactResult.custno)#&bcode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#">Select</a>
				  	<cfelse>
						<a href="#plink#.cfm?tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(exactResult.custno)#&bcode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#">Select</a>
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
		<table width="700" align="center" class="data">
			<tr>
				<th>Cust No</th>
				<th>Name</th>
				<th>Curr Code</th>
 			  	<th>Address</th>
				<th>Telephone</th>
				<th>Attention</th>
				<th>Action</th>
			</tr>
  			
			<cfoutput query="similarResult">
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			 		<td nowrap>#similarResult.custno#</td>
   			   		<td nowrap>#similarResult.name#</td>
			   		<td nowrap>#similarResult.Currcode#</td>
   			   		<td nowrap>#similarResult.Add1#<br>#similarResult.Add2#<br>#similarResult.Add3#<br>#similarResult.Add4#</td>
   			   		<td nowrap>(1) #similarResult.phone#<br>(2) #similarResult.phonea#</td>
    		   		<td nowrap>#similarResult.attn#<br/><font style="background-color:FFFFFF">#similarResult.e_mail#</font></td>
					<td nowrap>
					<cfif ttype eq "Create">
						<a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(similarResult.custno)#&bcode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#">Select</a>
					<cfelse>
						<a href="#plink#.cfm?tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(similarResult.custno)#&bcode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#">Select</a>
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
	100 Newest Supplier:
</legend>
<br>

<cfif type.recordCount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage=round(type.recordcount/100)>
		<cfif type.recordcount mod 100 LT 5 and type.recordcount mod 100 neq 0>
			<cfset noOfPage=noOfPage+1>
		</cfif>
		<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
			<h3 align="center"><font color="#FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
		</cfif>
 	</cfif>
	
	<cfform action="transuppsearch.cfm?nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&invoicedate=#invoicedate#" method="post">
		<cfoutput>
			<input type="hidden" name="ttype" value="#ttype#">
			<input type="hidden" name="stype" value="#stype#">
			<input type="hidden" name="tran" value="#tran#">
			
			<cfif ttype eq "Edit" or ttype eq "delete">
				<input type="hidden" name="refno" value="#refno#">
			</cfif>
		</cfoutput>
		
		<div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
		
		<cfset noOfPage=round(Type.recordcount/100)>
		
		<cfif type.recordcount mod 100 LT 5 and type.recordcount mod 100 neq 0>
			<cfset noOfPage=noOfPage+1>
		</cfif>
		
		<cfif isdefined("start")>
			<cfset start=start>
		</cfif>
		
		<cfif isdefined("form.skeypage")>
			<cfset start = form.skeypage * 100 + 1 - 100>
	
			<cfif form.skeypage eq "1">
				<cfset start = "1">
			</cfif>
		</cfif>
		
		<cfparam name="i" default="#start#" type="numeric">
		<cfset prevTwenty=start -100>
		<cfset nextTwenty=start +100>
		<cfset page=round(nextTwenty/100)>
		<cfif isdefined('invoicedate') eq false>
        <cfset invoicedate = ''>
		</cfif>
		<cfif start neq 1>
			<cfif ttype eq "Create">
				<cfoutput>|| <a href="transuppsearch.cfm?invset=#invset#&tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&invoicedate=#invoicedate#">Previous</a> ||</cfoutput>
			<cfelse>
				<cfoutput>|| <a href="transuppsearch.cfm?tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&invoicedate=#invoicedate#">Previous</a> ||</cfoutput>
			</cfif>
		</cfif>
		
		<cfif page neq noOfPage>
			<cfif ttype eq "Create">
				<cfoutput> <a href="transuppsearch.cfm?invset=#invset#&tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&invoicedate=#invoicedate#">Next</a> ||</cfoutput>
			<cfelse>
				<cfoutput> <a href="transuppsearch.cfm?tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&invoicedate=#invoicedate#">Next</a> ||</cfoutput>
			</cfif>
		</cfif>
		
		<cfoutput>Page #page# Of #noOfPage#</cfoutput>
	</cfform>
	</div>
	
	<table align="center" class="data" width="700px">
		<tr>
			<th>No.</th>
			<th>Cust No</th>
			<th>Name</th>
			<th>Curr Code</th>
			<th>Address</th>
			<th>Telephone</th>
			<th>Attention</th>
			<th>Action</th>
		</tr>
		
		<cfoutput query="type" maxrows="100" startrow="#start#">
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td nowrap>#i#</td>
				<td nowrap>#type.custno#</td>
				<td nowrap>#type.Name#</td>
				<td nowrap>#type.Currcode#</td>
				<td nowrap>#type.Add1#<br>#type.Add2#<br>#type.Add3#<br>#type.Add4#</td>
				<td nowrap>(1) #type.phone#<br>(2) #type.phonea#</td>
				<td nowrap>#type.attn#<br/><font style="background-color:FFFFFF">#type.e_mail#</font></td>
				<td nowrap>
					<cfif ttype eq "Create">
						<a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(type.custno)#&bcode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#">Select</a>
					<cfelse>
						<a href="#plink#.cfm?tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(type.custno)#&bcode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#">Select</a>
					</cfif>
				</td>
			</tr>
			<cfset i = incrementvalue(i)>
		</cfoutput>
	</table>
	
	<div align="right">
	
	<cfif start neq 1>
		<cfif ttype eq "Create">
			<cfoutput>|| <a href="transuppsearch.cfm?invset=#invset#&tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&invoicedate=#invoicedate#">Previous</a> ||</cfoutput>
		<cfelse>
			<cfoutput>|| <a href="transuppsearch.cfm?tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&invoicedate=#invoicedate#">Previous</a> ||</cfoutput>
		</cfif>
	</cfif>
	
	<cfif page neq noOfPage>
		<cfif ttype eq "Create">
			<cfoutput> <a href="transuppsearch.cfm?invset=#invset#&tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#">Next</a> ||</cfoutput>
		<cfelse>
			<cfoutput> <a href="transuppsearch.cfm?tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#">Next</a> ||</cfoutput>
		</cfif>
	</cfif>
	
	<cfoutput>Page #page# Of #noOfPage#</cfoutput></div>
<cfelse>
	<h3>No Records were found.</h3>
</cfif>

<br>
</fieldset>

</body>
</html>