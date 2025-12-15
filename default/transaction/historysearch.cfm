<html>
<head>
<title>History Item</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>
<body>
<h1></h1>
<br>

<cfoutput>
	Mode - #type#<br>
	Type - #stype#
	<!--- <cfif #type# eq "Create"> --->
	<!--- <form action="historysearch.cfm?tran=#tran#&type=#type#&stype=#stype#&nexttranno=#nexttranno#&custno=#custno#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#" method="post"> --->
	<!--- <input type="hidden" name="nexttranno" value="#nexttranno#"> --->
	<!--- <cfelse> --->
	<cfif checkcustom.customcompany eq "Y">
		<cfset remark5=url.remark5>
		<cfset remark6=url.remark6>
	<cfelse>
		<cfset remark5="">
		<cfset remark6="">
	</cfif>
	<form action="historysearch.cfm?tran=#tran#&hmode=#hmode#&type=#type#&stype=#stype#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#&remark5=#remark5#&remark6=#remark6#" method="post">
		<!--- <input type="hidden" name="nexttranno" value="#refno#"> --->
		<!--- </cfif> --->
		<cfif isdefined("form.updunitcost")>
			<input type='hidden' name='updunitcost' value='#form.updunitcost#'>
		</cfif>
		
		<h4><a href="..\maintenance\Icitem2.cfm?type=Create" target="_blank">Creating a New Item</a></h4>
		<h1>Search By :
			<select name="searchType">
				<option value="itemno"><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>Item No</cfif></option>
				<option value="aitemno" <cfif lcase(HcomID) eq "hairo_i">selected</cfif>><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Vendor's Code<cfelse>Product Code</cfif></option>
				<option value="desp">Description</option>
				<option value="category">Category</option>
				<option value="wos_group">Group</option>
				<option value="brand">Brand</option>
				<!--- <option value="phone">#Type# Tel</option> --->
			</select>
            <input type="checkbox" name="left" id="left" value="1" checked />
			Search for Item : 
			<input type="text" name="searchStr" value="">
			<cfif husergrpid eq "Muser">
				<input type="submit" name="submit" value="Search">
			</cfif>
		</h1>
		<!--- <input type="hidden" name="type" value="#type#">
		<input type="hidden" name="refno" value="#refno#">
		<input type="hidden" name="custno" value="#custno#">
		<input type="hidden" name="invoicedate" value="#invoicedate#"> --->
  	</form>
</cfoutput>

<cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1><hr></cfoutput>
</cfif>
	
<cfquery datasource='#dts#' name="type1">
	select a.aitemno,a.itemno,a.desp,a.despa,a.brand,a.wos_group,a.category,a.price,a.nonstkitem from icitem a,ictran b where a.itemno=b.itemno and b.custno = '#custno#' group by b.itemno order by b.wos_date desc,b.itemno desc
</cfquery>
		
<cfif isdefined("form.searchStr")>
	<cfquery dbtype="query" name="exactResult">
		Select * from TYPE1 where #form.searchType# = '#form.searchStr#' order by #form.searchType#
	</cfquery>
			
	<cfquery dbtype="query" name="similarResult">
	  Select * from TYPE1 where #form.searchType# LIKE <cfif isdefined('form.left')><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.searchStr#%"><cfelse>'#form.searchStr#'</cfif> order by #form.searchType#
	</cfquery>
			
	<h2>Exact Result</h2>
	
	<cfif exactResult.recordCount neq 0>
		<table align="center" class="data" width="550px">					
	    	<tr>
		  		<th><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>Item No</cfif></th>
		  		<th>Description</th>
		  		<th>Brand</th>
		  		<th>Category</th>
		  		<th>Group</th>
		  		<th>Price</th>
		  		<th>Status</th>
		  		<th>Action</th>
			</tr>
			
			<cfoutput query="exactResult">
		  		<tr>
		    		<td>#exactResult.itemno#</a></td>
		    		<td>#exactResult.desp#<br>#exactResult.despa#</td>
		    		<td>#exactResult.brand#</td>
		    		<td>#exactResult.category#</td>
		    		<td>#exactResult.wos_group#</td>
		    		<td>#exactResult.price#</td>
					<td>#exactResult.nonstkitem#</td>
		    		<td><cfif exactResult.nonstkitem neq "T">
							<cfif type eq "Create">
								<a href="transaction3.cfm?tran=#tran#&hmode=#hmode#&type=#type#&stype=#stype#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&itemno1=#urlencodedformat(exactResult.itemno)#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#&remark5=#remark5#&remark6=#remark6#">Select</a>
							<cfelse>
								<a href="transaction3.cfm?tran=#tran#&hmode=#hmode#&type=#type#&stype=#stype#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&itemno1=#urlencodedformat(exactResult.itemno)#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#&remark5=#remark5#&remark6=#remark6#">Select</a>
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
		<table align="center" class="data" width="600px">					
			<tr>
		  		<th><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>Item No</cfif></th>
		  		<th>Description</th>
		  		<th>Brand</th>
		  		<th>Category</th>
		  		<th>Group</th>
		  		<th>Price</th>
		  		<th>Status</th>
		  		<th>Action</th>
			</tr>
			
			<cfoutput query="similarResult">
		  		<tr>
		    		<td>#similarResult.itemno#</a></td>
		    		<td>#similarResult.desp#<br>#similarResult.despa#</td>
		    		<td>#similarResult.brand#</td>
		    		<td>#similarResult.category#</td>
		    		<td>#similarResult.wos_group#</td>
		    		<td>#similarResult.price#</td>
					<td>#similarResult.nonstkitem#</td>
		    		<td><cfif similarResult.nonstkitem neq "T">
							<cfif type eq "Create">
			    				<a href='transaction3.cfm?tran=#tran#&hmode=#hmode#&type=#type#&itemno1=#urlencodedformat(similarResult.itemno)#&stype=#stype#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#&remark5=#remark5#&remark6=#remark6#'>Select</a>
			  				<cfelse>
			    				<a href='transaction3.cfm?tran=#tran#&hmode=#hmode#&type=#type#&itemno1=#urlencodedformat(similarResult.itemno)#&stype=#stype#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#&remark5=#remark5#&remark6=#remark6#'>Select</a>
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

<cfparam name="i" default="1" type="numeric">

<hr>
<fieldset>
<legend style="font-family:Verdana, Arial,Helvetica,sans-serif;font-size:12px;font-style:italic;line-height:normal;font-weight:bold;text-transform:capitalize;color:#0066FF;"> 
	<cfoutput>25 Newest Historical Icitem:</cfoutput>
</legend>
<br>
	<cfif type1.recordCount neq 0>
		<table align="center" class="data" width="600px">					
			<tr>
		  		<th>No.</th>
		  		<th><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>Item No</cfif></th>
		  		<th>Description</th>
		  		<th>Brand</th>
		  		<th>Category</th>
		  		<th>Group</th>
		  		<th>Price</th>
		  		<th>Status</th>
		  		<th>Action</th>
			</tr>
			<cfoutput query="type1" maxrows="25">
		  		<tr>
		    		<td>#i#</td>
		    		<td>#type1.itemno#</a></td>
		    		<td>#type1.desp#<br>#type1.despa#</td>
		    		<td>#type1.brand#</td>
		    		<td>#type1.category#</td>
		    		<td>#type1.wos_group#</td>
		    		<td>#type1.price#</td>
					<td>#type1.nonstkitem#</td>
		    		<td><cfif type1.nonstkitem neq "T">
							<cfif type eq "Create">
								<a href="transaction3.cfm?tran=#tran#&itemno1=#urlencodedformat(type1.itemno)#&hmode=#hmode#&stype=#stype#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#&remark5=#remark5#&remark6=#remark6#">Select</a>
							<cfelse>
								<a href="transaction3.cfm?tran=#tran#&itemno1=#urlencodedformat(type1.itemno)#&hmode=#hmode#&stype=#stype#&type=#type#&nexttranno=#nexttranno#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&readperiod=#readperiod#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#&remark5=#remark5#&remark6=#remark6#">Select</a>
							</cfif>
						</cfif>
		    		</td>
		  		</tr>
				<cfset i = incrementvalue(i)>
			</cfoutput>
	  	</table>
	<cfelse>
		<h3>No Records were found.</h3>
	</cfif>
	<br>
  	</fieldset>
  	<!--- <cfelse>
	<h1>URL Error. Please Click On The Correct Link.</h1>
  	</cfif> --->	
</body>
</html>