<cfif ttype eq "edit">
	<cfset plink = "tran_edit1">
<cfelse>
	<cfset plink = "transaction1">
</cfif>

<html>
<head>
	<title>Address Search</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">

<body>
  <h1>Address Selection Page</h1>

  <cfoutput><h4><a href="../maintenance/Addresstable2.cfm?type=Create" target="_blank">Creating a New Address</a></h4></cfoutput>

  <cfoutput>
    <form action="tranaddrsearch.cfm?invset=#invset#&&nexttranno=#nexttranno#&bcode=#bcode#&dcode=#dcode#&addrtype=#addrtype#&custno=#URLEncodedFormat(custno)#&invoicedate=#invoicedate#&ccode=#ccode#" method="post"><!--- </cfoutput> --->
		<input type="hidden" name="ttype" value="#ttype#">
		<input type="hidden" name="stype" value="#stype#">
		<input type="hidden" name="tran" value="#tran#">
		<cfif ttype eq "Edit" or ttype eq "delete">
			<input type="hidden" name="refno" value="#refno#">
		</cfif>

<!---     <cfoutput> --->
	  <h1>Search By :
        <select name="searchType">
	      <option value="Code">Code</option>
		  <option value="Custno">Cust/Supp No</option>
          <option value="name">Name</option>
	      <option value="Phone">Telephone</option>
	      <option value="Fax">Fax</option>
	    </select>
        Search for Code : <input type="text" name="searchStr" value="">
	  </h1>
	</form>
  </cfoutput>

  <cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1><hr></cfoutput>
  </cfif>

  <cfquery datasource='#dts#' name="type">
	select * from Address
	<cfif lcase(hcomid) eq "iel_i" or lcase(hcomid) eq "ielm_i">
		where custno='#custno#'
	</cfif> 
	order by Code, custno, name
  </cfquery>

  <cfif isdefined("form.searchStr")>
	<cfquery datasource='#dts#' name="exactResult">
	  Select * from address 
	  where #form.searchType# = '#form.searchStr#'
	</cfquery>

	<cfquery datasource='#dts#' name="similarResult">
	  Select * from address 
	  where #form.searchType# LIKE '%#form.searchStr#%'
	</cfquery>

	<h2>Exact Result</h2>
	<cfif exactResult.recordCount neq 0>

    <table align="center" class="data" width="550px">
      <tr>
        <th>Code</th>
        <th>Name</th>
		<th>Cust/Supp No</th>
        <th>Address</th>
        <th>Attn</th>
        <th>Telephone</th>
        <th>Fax</th>
        <th>Action</th>
      </tr>
      <cfoutput query="exactResult" maxrows="10">
        <tr>
          <td>#exactResult.Code#</td>
          <td>#exactResult.name#<br>#exactResult.name#</td>
		  <td>#exactResult.custno#</td>
          <td>#exactResult.add1#<br>
            #exactResult.add2#<br>
            #exactResult.add3#<br>
            #exactResult.add4#
		  </td>
          <td>#exactResult.attn#</td>
          <td>#exactResult.phone#</td>
          <td>#exactResult.fax#</td>
          <td>
		  <cfif url.addrtype eq "Bill">
		    <cfif ttype eq "Create">
	  		  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#exactResult.code#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
		    <cfelse>
			  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#exactResult.code#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
		    </cfif>
          <cfelseif url.addrtype eq "Collect">
		    <cfif ttype eq "Create">
	  		  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#exactResult.code#">Select</a>
		    <cfelse>
			  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#exactResult.code#">Select</a>
		    </cfif>
		  <cfelse>
		    <cfif ttype eq "Create">
	  		  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#url.bcode#&dcode=#exactResult.code#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
		    <cfelse>
			  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#url.bcode#&dcode=#exactResult.code#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
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
        <th>Code</th>
        <th>Name</th>
		<th>Cust/Supp No</th>
        <th>Address</th>
        <th>Attn</th>
        <th>Telephone</th>
        <th>Fax</th>
        <th>Action</th>
      </tr>
      <cfoutput query="similarResult" maxrows="10">
        <tr>
          <td>#similarResult.Code#</td>
          <td>#similarResult.name#</td>
			<td>#similarResult.custno#</td>
          <td>#similarResult.add1#<br>
            #similarResult.add2#<br>
            #similarResult.add3#<br>
            #similarResult.add4#
		  </td>
          <td>#similarResult.attn#</td>
          <td>#similarResult.phone#</td>
          <td>#similarResult.fax#</td>
          <td>
		  <cfif url.addrtype eq "Bill">
		    <cfif ttype eq "Create">
	  		  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#similarResult.code#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
		    <cfelse>
			  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#similarResult.code#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
		    </cfif>
          <cfelseif url.addrtype eq "Collect">
		    <cfif ttype eq "Create">
	  		  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#similarResult.code#">Select</a>
		    <cfelse>
			  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#similarResult.code#">Select</a>
		    </cfif>
		  <cfelse>
		    <cfif ttype eq "Create">
	  		  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#url.bcode#&dcode=#similarResult.code#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
		    <cfelse>
			  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#url.bcode#&dcode=#similarResult.code#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
		    </cfif>
		  </cfif>
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
    <legend style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 12px;
	  font-style: italic;line-height: normal;font-weight: bold;text-transform: capitalize;color: #0066FF;">
      10 Newest Address:
	</legend>
	<br>
		<cfif type.recordCount neq 0>
			<cfif isdefined("form.skeypage")>
  					<cfset noOfPage=ceiling(type.recordcount/10)>
					<!---<cfif type.recordcount mod 10 LT 10 and type.recordcount mod 10 neq 0>
						<cfset noOfPage=noOfPage+1>
					</cfif>--->
					<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
						<h3 align="center"><font color="#FF0000">Wrong page number! Please try again.</font></h3>
						<cfabort>
					</cfif>
 				</cfif>

			<cfform action="tranaddrsearch.cfm?invset=#invset#&&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&addrtype=#url.addrtype#&custno=#URLEncodedFormat(url.custno)#&invoicedate=#invoicedate#&ccode=#url.ccode#" method="post">
			<cfoutput>
			<input type="hidden" name="ttype" value="#ttype#">
			<input type="hidden" name="stype" value="#stype#">
			<input type="hidden" name="tran" value="#tran#">
			<cfif ttype eq "Edit" or ttype eq "delete">
				<input type="hidden" name="refno" value="#refno#">
			</cfif>
			</cfoutput>
				<div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">

			<cfset noOfPage=ceiling(Type.recordcount/10)>

			<!---<cfif type.recordcount mod 10 LT 10 and type.recordcount mod 10 gt 0.5>
				<cfset noOfPage = noOfPage + 1>
			</cfif>--->

			<cfif isdefined("start")>
				<cfset start=start>
			</cfif>

			<cfif isdefined("form.skeypage")>
				<cfset start = form.skeypage * 10 + 1 - 10>
				<cfif form.skeypage eq "1">
					<cfset start = "1">
				</cfif>
			</cfif>

			<cfset prevTwenty=start -10>
			<cfset nextTwenty=start +10>
			<cfset page=round(nextTwenty/10)>

			<cfif start neq 1>
				<cfif ttype eq "Create">
					<cfoutput>|| <a href="tranaddrsearch.cfm?invset=#invset#&tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&addrtype=#url.addrtype#&custno=#URLEncodedFormat(url.custno)#&invoicedate=#invoicedate#&ccode=#url.ccode#">Previous</a> ||</cfoutput>
				<cfelse>
					<cfoutput>|| <a href="tranaddrsearch.cfm?invset=#invset#&tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&addrtype=#url.addrtype#&custno=#URLEncodedFormat(url.custno)#&invoicedate=#invoicedate#&ccode=#url.ccode#">Previous</a> ||</cfoutput>
				</cfif>
			</cfif>

		    <cfif page neq noOfPage>
				<cfif ttype eq "Create">
					<cfoutput> <a href="tranaddrsearch.cfm?invset=#invset#&tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&addrtype=#url.addrtype#&custno=#URLEncodedFormat(url.custno)#&invoicedate=#invoicedate#&ccode=#url.ccode#">Next</a> ||</cfoutput>
				<cfelse>
					<cfoutput> <a href="tranaddrsearch.cfm?invset=#invset#&tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&addrtype=#url.addrtype#&custno=#URLEncodedFormat(url.custno)#&invoicedate=#invoicedate#&ccode=#url.ccode#">Next</a> ||</cfoutput>
				</cfif>
			</cfif>

			<cfoutput>Page #page# Of #noOfPage#</cfoutput>

			</cfform>
			</div>

  <table align="center" class="data" width="600px">
    <tr>
      <th>No.</th>
      <th>Code</th>
      <th>Name</th>
	  <th>Cust/Supp No</th>
      <th>Address</th>
      <th>Attn</th>
      <th>Telephone</th>
      <th>Fax</th>
      <th>Action</th>
    </tr>

    <cfoutput query="type" startrow="#start#" maxrows="10">
      <tr>
        <td>#i#</td>
        <td>#type.Code#</td>
        <td>#type.name#</td>
		<td>#type.custno#</td>
        <td>#type.add1#<br>
          #type.add2#<br>
          #type.add3#<br>
          #type.add4#
		</td>
        <td>#type.attn#</td>
        <td>#type.phone#</td>
        <td>#type.fax#</td>
        <td>
		  <cfif url.addrtype eq "Bill">
		    <cfif ttype eq "Create">
	  		  <a href="#plink#.cfm?invset=#invset#&custno=#URLEncodedFormat(url.custno)#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&BCode=#type.code#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
		    <cfelse>
			  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#type.code#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
		    </cfif>
          <cfelseif url.addrtype eq "Collect">
		    <cfif ttype eq "Create">
	  		  <a href="#plink#.cfm?invset=#invset#&custno=#URLEncodedFormat(url.custno)#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&BCode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#type.code#">Select</a>
		    <cfelse>
			  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#url.bcode#&dcode=#url.dcode#&first=1&invoicedate=#invoicedate#&ccode=#type.code#">Select</a>
		    </cfif>
		  <cfelse>
		    <cfif ttype eq "Create">
	  		  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#url.bcode#&dcode=#type.code#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
		    <cfelse>
			  <a href="#plink#.cfm?invset=#invset#&tran=#tran#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&custno=#URLEncodedFormat(url.custno)#&BCode=#url.bcode#&dcode=#type.code#&first=1&invoicedate=#invoicedate#&ccode=#url.ccode#">Select</a>
		    </cfif>
		  </cfif>
      </tr>
      <cfset i = incrementvalue(#i#)>
    </cfoutput>
  </table>
		<div align="right">
   			<cfif start neq 1>
				<cfif ttype eq "Create">
					<cfoutput>|| <a href="tranaddrsearch.cfm?invset=#invset#&tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&addrtype=#url.addrtype#&custno=#URLEncodedFormat(url.custno)#&invoicedate=#invoicedate#&ccode=#url.ccode#">Previous</a> ||</cfoutput>
				<cfelse>
					<cfoutput>|| <a href="tranaddrsearch.cfm?invset=#invset#&tran=#tran#&start=#prevTwenty#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&addrtype=#url.addrtype#&custno=#URLEncodedFormat(url.custno)#&invoicedate=#invoicedate#&ccode=#url.ccode#">Previous</a> ||</cfoutput>
				</cfif>
			</cfif>

		    <cfif page neq noOfPage>
				<cfif ttype eq "Create">
					<cfoutput> <a href="tranaddrsearch.cfm?invset=#invset#&tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&addrtype=#url.addrtype#&custno=#URLEncodedFormat(url.custno)#&invoicedate=#invoicedate#&ccode=#url.ccode#">Next</a> ||</cfoutput>
				<cfelse>
					<cfoutput> <a href="tranaddrsearch.cfm?invset=#invset#&tran=#tran#&start=#evaluate(nextTwenty)#&stype=#stype#&ttype=#ttype#&refno=#refno#&nexttranno=#url.nexttranno#&bcode=#url.bcode#&dcode=#url.dcode#&addrtype=#url.addrtype#&custno=#URLEncodedFormat(url.custno)#&invoicedate=#invoicedate#&ccode=#url.ccode#">Next</a> ||</cfoutput>
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