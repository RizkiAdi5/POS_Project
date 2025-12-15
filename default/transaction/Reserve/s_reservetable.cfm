<html>
<head>
<title>Search Reserve</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<h1>Reserve Selection Page</h1>

<cfoutput>
	<h4>
	<a href="Reservetable2.cfm?type=Create">Creating A New Reserve</a>
	|| <a href="Reservetable.cfm">List All Reserve</a> 
	|| <a href="s_Reservetable.cfm?type=package">Search For Reserve</a>

    || <a href="l_Reserve.cfm" target="_blank">Reserve Stock Listing</a>
	</h4>

    <form action="s_Reservetable.cfm" method="post">
		<h1>Search By :
        <select name="searchType">
			<option value="reserveno">Reserve</option>
	      	<option value="name">Name</option>
	    </select>
      	Search for Reserve : 
      	<input type="text" name="searchStr" value="" size="40">
	  	</h1>
	</form>
	
	<cfif isdefined("url.process")>
		<h1>#form.status#</h1><hr>
  	</cfif>
	
  	<cfquery datasource='#dts#' name="type">
		select * from Reserve order by reserveno
  	</cfquery>
		
  	<cfif isdefined("form.searchStr")>
  		<cfquery datasource="#dts#" name="exactResult">
    		select * from Reserve where #form.searchType# = '#form.searchStr#' order by #form.searchType#
		</cfquery>
			
  		<cfquery datasource="#dts#" name="similarResult">
    		select * from Reserve where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by #form.searchType#
		</cfquery>
			
		<h2>Exact Result</h2>
		<cfif exactResult.recordCount neq 0>
		
		<table align="center" class="data" width="80%">
      		<tr> 
        		<th>Reserve</th>
        		<th>Name</th>
                <th>Phone</th>
                <th>E-mail</th>
                <th>Amount</th>
                <th>Deposit No</th>
                <th>Deposit Amount</th>
                <th>Status</th>
        		<cfif getpin2.h1F11 eq 'T'>
					<th width="10%">Action</th>
				</cfif>
      		</tr>
      		<cfloop query="exactResult"> 
        	<tr> 
          		<td>#exactResult.reserveno#</td>
          		<td>#exactResult.name#</td>
                <td>#exactResult.phone#</td>
                <td>#exactResult.email#</td>
                <td>#exactResult.grossamt#</td>
                <td>#exactResult.depositno#</td>
                <td>#exactResult.depositamt#</td>
                <td>#exactResult.status#</td>
          		<cfif getpin2.h1F11 eq 'T'>
				<td nowrap> 
            		<div align="center">
					<!---
					<a href="Reservetable2.cfm?type=Delete&reserveno=#exactResult.reserveno#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="Reservetable2.cfm?type=Edit&reserveno=#exactResult.reserveno#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a> --->
                    <cfif exactResult.status eq ''>
                    <!---
                    <a href="clearreserve.cfm?reserveno=#exactResult.reserveno#" target="_blank">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Clear Order</a>--->
                    <a href="cancelreserve.cfm?reserveno=#exactResult.reserveno#" target="_blank">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Cancel Order</a>
                    </cfif>
                    
                    
                    
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
      	<table align="center" class="data" width="80%">					
	    	<tr>
	      		<th>Reserve</th>
        		<th>Name</th>
                <th>Phone</th>
                <th>E-mail</th>
                <th>Amount</th>
                <th>Deposit No</th>
                <th>Deposit Amount</th>
                <th>Status</th>
        		<cfif getpin2.h1F11 eq 'T'>
					<th width="10%">Action</th>
				</cfif>
	    	</tr>
	
	   		<cfloop query="similarResult">
	      	<tr> 
          		<td>#similarResult.reserveno#</td>
          		<td>#similarResult.name#</td>
                <td>#similarResult.phone#</td>
                <td>#similarResult.email#</td>
                <td>#similarResult.grossamt#</td>
                <td>#similarResult.depositno#</td>
                <td>#similarResult.depositamt#</td>
                <td>#similarResult.status#</td>
          		<cfif getpin2.h1F11 eq 'T'>
				<td nowrap> 
            		<div align="center">
					<!---
					<a href="Reservetable2.cfm?type=Delete&reserveno=#similarResult.reserveno#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="Reservetable2.cfm?type=Edit&reserveno=#similarResult.reserveno#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a>--->
                    <cfif similarResult.status eq ''><!---<a href="clearreserve.cfm?reserveno=#similarResult.reserveno#" target="_blank">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Clear Order</a> --->
                    <a href="cancelreserve.cfm?reserveno=#similarResult.reserveno#" target="_blank">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Cancel Order</a>
                    </cfif>
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
20 Newest Result:
</legend><br>


<cfif type.recordCount neq 0>
  	<table align="center" class="data" width="80%">
    	<tr> 
      		<th>No.</th>
      		<th>Package</th>
      		<th>Name</th>
            <th>Phone</th>
            <th>E-mail</th>
            <th>Amount</th>
                <th>Deposit No</th>
                <th>Deposit Amount</th>
                <th>Status</th>
      		<cfif getpin2.h1F11 eq 'T'>
				<th width="10%">Action</th>
			</cfif>
    	</tr>
    	<cfoutput query="type" maxrows="20"> 
      	<tr> 
        	<td width="5%">#type.currentrow#</td>
        	<td>#type.reserveno#</td>
        	<td nowrap>#type.name#</td>
            <td nowrap>#type.phone#</td>
            <td nowrap>#type.email#</td>
            <td>#type.grossamt#</td>
            <td>#type.depositno#</td>
            <td>#type.depositamt#</td>
            <td>#type.status#</td>
			<cfif getpin2.h1F11 eq 'T'>
				<td nowrap><div align="center">
                <!---
					<a href="Reservetable2.cfm?type=Delete&reserveno=#type.reserveno#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="Reservetable2.cfm?type=Edit&reserveno=#type.reserveno#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a>--->
                    <cfif type.status eq ''><!---<a href="clearreserve.cfm?reserveno=#type.reserveno#" target="_blank">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Clear Order</a> --->
                    <a href="cancelreserve.cfm?reserveno=#type.reserveno#" target="_blank">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Cancel Order</a>
                    </cfif>
                    </div> 
                
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