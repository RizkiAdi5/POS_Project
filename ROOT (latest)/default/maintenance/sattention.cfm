<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<!--- ADD ON 15-07-2009 --->

<!--- <cfset typeNo=#url.type# & "No"> 
	<cfset link = #url.type# &".cfm"> --->
<!--- <cfif isdefined("URL.Type")> --->
<h1><cfoutput>Attention Selection Page</cfoutput></h1>
<cfoutput> 
  <h4>
		<a href="attention.cfm?type=Create"> Creating a Attention</a> 
		|| <a href="vattention.cfm">List all Attention</a> 
		|| <a href="sattention.cfm">Search Attention</a> 
		|| <a href="pattention.cfm" target="_blank">Attention Listing</a>
	</h4>
</cfoutput>
<cfoutput>
<form action="sattention.cfm" method="post">
    <h1>Search By : 
    	<select name="searchType">
        	<option value="attentionno">Attention No</option>
        	<option value="name">Attention Name</option>
        	<option value="customerno">Customer No</option>
        	<!--- <option value="phone">#URL.Type# Tel</option> --->
      	</select>
      	Search for Attention : 
      	<input type="text" name="searchStr" value="">
    </h1>
</form>
</cfoutput>			
<cfif isdefined("url.process")>
	<h1><cfoutput>#form.status#</cfoutput></h1>
    <hr>
</cfif>
<cfquery datasource='#dts#' name="type">
	Select * from attention order by attentionno desc
</cfquery>
		
<cfif isdefined("form.searchStr")>
	<cfquery datasource="#dts#" name="exactResult">
		Select * from attention where #form.searchType# = '#form.searchStr#' order by #form.searchType#
	</cfquery>
			
	<cfquery datasource="#dts#" name="similarResult">
		Select * from attention where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by #form.searchType#
	</cfquery>
			
	<h2>Exact Result</h2>
	<cfif exactResult.recordCount neq 0>
		<table align="center" class="data" width="600px">	
			<tr>	
				<th><cfoutput>Attention</cfoutput></th>
				<th>Name</th>						
				<th>Customer No</th>					
				<th>Phone</th>
				<cfif getpin2.h1C11 eq 'T'><th>Action</th></cfif>
			</tr>
			<cfoutput query="exactResult">
				<tr>
					<td>#exactResult.attentionno#</td>
					<td>#exactResult.name#</td>
					<td>#exactResult.customerno#</td>
					<td>#exactResult.Phone#</td>
					<cfif getpin2.h1C11 eq 'T'>
          				<td width="10%" nowrap>
						<div align="center"><a href="attention.cfm?type=Delete&attentionno=#exactResult.attentionno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="attention.cfm?type=Edit&attentionno=#exactResult.attentionno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
					</cfif>
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
			<th><cfoutput>Attention</cfoutput></th>
			<th>Name</th>				
			<th><cfif lcase(HcomID) eq "iel_i" or lcase(HcomID) eq "ielm_i">Supplier<cfelse>Customer</cfif> No</th>					
			<th>Phone</th>
			<cfif getpin2.h1C11 eq 'T'><th>Action</th></cfif>
		</tr>
		<cfoutput query="similarResult">
			<tr>
				<td>#similarResult.attentionno#</td>
				<td>#similarResult.name#</td>
				<td>#similarResult.customerno#</td>
				<td>#similarResult.Phone#</td>
				<cfif getpin2.h1C11 eq 'T'>
          			<td width="10%" nowrap> 
            			<div align="center"><a href="attention.cfm?type=Delete&attentionno=#similarResult.attentionno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="attention.cfm?type=Edit&attentionno=#similarResult.attentionno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
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
		
<fieldset><legend style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 12px;font-style: italic;line-height: normal;font-weight: bold;text-transform: capitalize;color: #0066FF;">
	<cfoutput>20 Newest Attention:</cfoutput></legend><br>
	<cfif #type.recordCount# neq 0>
		<table align="center" class="data" width="600px">	
			<tr>
				<th>No.</th>
				<th><cfoutput>Attention</cfoutput></th>
				<th>Name</th>
				<th>Customer No</th>					
				<th>Phone</th>
				<cfif getpin2.h1C11 eq 'T'><th>Action</th></cfif>
			</tr>
			<cfoutput query="type" maxrows="20">
				<tr>
					<td>#i#</td>
					<td>#type.attentionno#</td>
					<td>#type.name#</td>
					<td>#type.customerno#</td>
					<td>#type.Phone#</td>
					<cfif getpin2.h1C11 eq 'T'>
        				<td width="10%" nowrap> 
         				<div align="center"><a href="attention.cfm?type=Delete&attentionno=#type.attentionno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="attention.cfm?type=Edit&attentionno=#type.attentionno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
					</cfif>
				</tr>
				<cfset i = incrementvalue(#i#)>
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
