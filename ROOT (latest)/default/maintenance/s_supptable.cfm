<html>
<head>
<title>Create Or Edit Or View</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<h1>Manufacturer Selection Page</h1>
<cfoutput>
<h4><a href="supptable2.cfm?type=Create">Creating a Manufacturer</a> || <a href="supptable.cfm?">List 
    all Manufacturer</a> || <a href="s_supptable.cfm?type=icsupp">Search For 
    Manufacturer </a></h4>
</cfoutput>
		
		<cfoutput>
		<form action="s_supptable.cfm" method="post"></cfoutput>
			<cfoutput>
			<h1>Search By :
			
			<select name="searchType">
				<option value="supp">Manufacturer</option>
				<!--- <option value="phone">#URL.Type# Tel</option> --->
			</select>
      Search for Manufacturer : 
      <input type="text" name="searchStr" value=""> </h1>
			</cfoutput>
		</form>
		
		<cfif isdefined("url.process")>
				<cfoutput><h1>#form.status#</h1><hr></cfoutput>
		</cfif>
	
		<cfquery datasource='#dts#' name="type">
			Select * from icsupp order by supp, desp
		</cfquery>
<cfif isdefined("form.searchStr")>
  <cfquery dbtype="query" name="exactResult">
  Select * from TYPE where #form.searchType# = '#form.searchStr#' order by #form.searchType# 
  </cfquery>
  <cfquery dbtype="query" name="similarResult">
  Select * from TYPE where #form.searchType# LIKE '#form.searchStr#' order by 
  #form.searchType# 
  </cfquery>
  <h2>Exact Result</h2>
  <cfif #exactResult.recordCount# neq 0>
    <table align="center" class="data" width="600px">
      <tr> 
        <th>Manufacturer</th>
        <th>Description</th>
		<th>Action</th>
      </tr>
      <cfoutput query="exactResult" maxrows="10"> 
        <tr> 
          <td>#exactResult.supp#</td>
          <td>#exactResult.desp#</td>
          <td width="10%" nowrap> 
            <div align="center"><a href="supptable2.cfm?type=Delete&supp=#exactResult.supp#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              <a href="supptable2.cfm?type=Edit&supp=#exactResult.supp#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
        </tr>
      </cfoutput> 
    </table>
    <cfelse>
    <h3>No Exact Records were found.</h3>
  </cfif>
  <h2>Similar Result</h2>
  <cfif #similarResult.recordCount# neq 0>
    <table align="center" class="data" width="600px">
      <tr> 
        <th>Manufacturer</th>
        <th>Description</th>
		<th>Action</th>
      </tr>
      <cfoutput query="similarResult" maxrows="10"> 
        <tr> 
          <td>#similarResult.supp#</a></td>
          <td>#similarResult.desp#</td>
          <td width="10%" nowrap> 
            <div align="center"><a href="supptable2.cfm?type=Delete&supp=#similarResult.supp#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              <a href="supptable2.cfm?type=Edit&supp=#similarResult.supp#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
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
<cfoutput>20 Newest Manufacturer :</cfoutput></legend>
<br>
		<cfif #type.recordCount# neq 0>
		<table align="center" class="data" width="600px">					
				
				<tr>						
					<th>No.</th>						
					<th>Manufacturer</th>
					<th>Description</th>
					<th>Action</th>
				</tr>
				<cfoutput query="type" maxrows="20">
				<tr>
						
						<td>#i#</td>
						<td>#type.supp#</a></td>
						<td>#type.desp#<br></td>
						
        <td width="10%" nowrap> 
          <div align="center"><a href="supptable2.cfm?type=Delete&supp=#type.supp#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp;<a href="supptable2.cfm?type=Edit&supp=#type.supp#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
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
