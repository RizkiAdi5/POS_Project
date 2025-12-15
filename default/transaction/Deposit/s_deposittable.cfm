<html>
<head>
<title>Search Deposit</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<h1>Deposit Selection Page</h1>

<cfoutput>
	<h4>
	<cfif getpin2.h1F10 eq 'T'><a href="Deposittable2.cfm?type=Create">Creating A New Deposit</a> </cfif>
	<cfif getpin2.h1F20 eq 'T'>|| <a href="Deposittable.cfm">List All Deposit</a> </cfif>
	<cfif getpin2.h1F30 eq 'T'>|| <a href="s_Deposittable.cfm?type=Deposit">Search For Deposit</a></cfif>
    
    
    <cfif getpin2.h1630 eq 'T'>|| <a href="p_Deposit.cfm">Deposit Listing</a></cfif>
	</h4>

    <form action="s_Deposittable.cfm" method="post">
		<h1>Search By :
        <select name="searchType">
			<option value="Deposit">Deposit</option>
	      	<option value="Desp">Description</option>
	    </select>
      	Search for Deposit : 
      	<input type="text" name="searchStr" value="" size="40">
	  	</h1>
	</form>
	
	<cfif isdefined("url.process")>
		<h1>#form.status#</h1><hr>
  	</cfif>
	
  	<cfquery datasource='#dts#' name="type">
		select * from Deposit order by Depositno
  	</cfquery>
		
  	<cfif isdefined("form.searchStr")>
  		<cfquery datasource="#dts#" name="exactResult">
    		select * from Deposit where #form.searchType# = '#form.searchStr#' order by #form.searchType#
		</cfquery>
			
  		<cfquery datasource="#dts#" name="similarResult">
    		select * from Deposit where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by #form.searchType#
		</cfquery>
			
		<h2>Exact Result</h2>
		<cfif exactResult.recordCount neq 0>
		
		<table align="center" class="data" width="50%">
      		<tr> 
        		<th>Deposit</th>
        		<th>Description</th>
        		<cfif getpin2.h1F11 eq 'T'>
					<th width="10%">Action</th>
				</cfif>
      		</tr>
      		<cfloop query="exactResult"> 
        	<tr> 
          		<td>#exactResult.Depositno#</td>
          		<td>#exactResult.desp#</td>
          		<cfif getpin2.h1F11 eq 'T'>
				<td nowrap> 
            		<div align="center">
					<a href="Deposittable2.cfm?type=Delete&Deposit=#exactResult.Depositno#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="Deposittable2.cfm?type=Edit&Deposit=#exactResult.Depositno#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a> 
            		</div>
				</td>
				</cfif>
        	</tr>
      		</cfloop> 
    	</table>
	<cfelse>
	  	<h3>No Exact Records were found.</h3>
    </cfif>
			
    <h2>Similar Result</h2>
    <cfif similarResult.recordCount neq 0>
      	<table align="center" class="data" width="50%">					
	    	<tr>
	      		<th>Deposit</th>
        		<th>Description</th>
        		<cfif getpin2.h1F11 eq 'T'>
					<th width="10%">Action</th>
				</cfif>
	    	</tr>
	
	   		<cfloop query="similarResult">
	      	<tr> 
          		<td>#similarResult.Depositno#</td>
          		<td>#similarResult.desp#</td>
          		<cfif getpin2.h1F11 eq 'T'>
				<td nowrap> 
            		<div align="center">
                    <a href="printdeposit.cfm?depositno=#type.Depositno#" target="_blank">
					Print</a>&nbsp; 
					<a href="Deposittable2.cfm?type=Delete&Deposit=#similarResult.Depositno#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="Deposittable2.cfm?type=Edit&Deposit=#similarResult.Depositno#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a> 
            		</div>
				</td>
				</cfif>
        	</tr>
	    	</cfloop>
      	</table>
    <cfelse>
	  	<h3>No Similar Records were found.</h3>
    </cfif>
</cfif>
</cfoutput>
<hr><fieldset>
<legend style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 12px;font-style: italic;line-height: normal;font-weight: bold;text-transform: capitalize;color: #0066FF;">
20 Newest Address:
</legend><br>


<cfif type.recordCount neq 0>
  	<table align="center" class="data" width="50%">
    	<tr> 
      		<th>No.</th>
      		<th>Deposit</th>
      		<th>Description</th>
      		<cfif getpin2.h1F11 eq 'T'>
				<th width="10%">Action</th>
			</cfif>
    	</tr>
    	<cfoutput query="type" maxrows="20"> 
      	<tr> 
        	<td width="5%">#type.currentrow#</td>
        	<td>#type.Depositno#</td>
        	<td nowrap>#type.desp#</td>
			<cfif getpin2.h1F11 eq 'T'>
				<td nowrap><div align="center">
                <a href="printdeposit.cfm?depositno=#type.Depositno#"  target="_blank">
					Print</a>&nbsp; 
					<a href="Deposittable2.cfm?type=Delete&Deposit=#type.Depositno#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="Deposittable2.cfm?type=Edit&Deposit=#type.Depositno#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a></div> 
				</td>
			</cfif>
      	</tr>
    	</cfoutput>
	</table>
<cfelse>
  	<h3>No Records were found.</h3>
</cfif>
<br>
</fieldset>
</body>
</html>