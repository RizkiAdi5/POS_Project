<html>
<head>
	<title>Transaction 2A</title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
	<h1>Address Selection Page</h1>
	<h4><a href="Addresstable2.cfm?type=Create">Creating a Address</a></h4>

	<cfoutput>
    <form action="s_Addresstable.cfm" method="post">
		<h1>
		Search By :
        <select name="searchType">
	      	<option value="Code">Code</option>
	    </select>
        Search for Code : <input type="text" name="searchStr" value="">
	  	</h1>
	</form>
  	</cfoutput>

  	<cfif isdefined("url.process")>
		<cfoutput><h1>#form.status#</h1><hr></cfoutput>
  	</cfif>

	<cfquery datasource='#dts#' name="type">
		select * from Address where custno = '#url.custno#' order by Code, desp, custno
	</cfquery>

  	<cfif isdefined("form.searchStr")>
		<cfquery dbtype="query" name="exactResult">
	  		Select * from TYPE where #form.searchType# = '#form.searchStr#'
		</cfquery>

		<cfquery dbtype="query" name="similarResult">
	  		Select * from TYPE where #form.searchType# LIKE '%#form.searchStr#%'
		</cfquery>

		<h2>Exact Result</h2>

		<cfif exactResult.recordCount neq 0>
	  		<table align="center" class="data" width="550px">
				<tr>
		  			<th>Code</th>
		  			<th>Description</th>
		  			<th>Customer No</th>
		  			<th>Address</th>
		  			<th>Attn</th>
		  			<th>Action</th>
				</tr>
			<cfoutput query="exactResult" maxrows="10">
		  		<tr>
					<td>#exactResult.Code#</td>
					<td>#exactResult.desp#</td>
					<td>#exactResult.custno#</td>
					<td>#exactResult.add1#<br>#exactResult.add2#<br>#exactResult.add3#<br>#exactResult.add4#</td>
					<td>#exactResult.attn#</td>
					<td><a href="Transaction2.cfm?">Select</a></td>
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
          			<th>Description</th>
	      			<th>Customer No</th>
	      			<th>Address</th>
	      			<th>Attn</th>
	      			<th>Action</th>
	    		</tr>
			<cfoutput query="similarResult" maxrows="10">
	      		<tr>
		    		<td>#similarResult.Code#</td>
		    		<td>#similarResult.desp#</td>
		    		<td>#similarResult.custno#</td>
		    		<td>#similarResult.add1#<br>#similarResult.add2#<br>#similarResult.add3#<br>#similarResult.add4#</td>
		    		<td>#similarResult.attn#</td>
		    		<td><a href="Transaction2.cfm?">Select</a></td>
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
  	20 Newest Address:
	</legend>
	<br>

	<cfif type.recordCount neq 0>
		<table align="center" class="data" width="600px">
			<tr>
		  		<th>No.</th>
		  		<th>Code</th>
		  		<th>Description</th>
		  		<th>Customer No</th>
		  		<th>Address</th>
		  		<th>Attn</th>
		  		<th>Action</th>
			</tr>
		<cfoutput query="type" maxrows="20">
		  	<tr>
				<td>#i#</td>
				<td>#type.Code#</td>
				<td>#type.desp#</td>
				<td>#type.custno#</td>
				<td>#type.add1#<br>#type.add2#<br>#type.add3#<br>#type.add4#</td>
				<td>#type.attn#</td>
				<td><a href="Transaction2.cfm?">Select</a></td>
		  	</tr>
		  	<cfset i = incrementvalue(i)>
		</cfoutput>
	  	</table>
	<cfelse>
  		<h3><cfoutput>No Address were found for the #url.ptype# : #url.custno#.</cfoutput></h3>
	</cfif>
	<br>
  	</fieldset>
</body>
</html>