<html>
<head>
<title>Search Cash Recording</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<h1>Cash Recording Selection Page</h1>



<cfoutput>
	<h4>
<a href="adddailyopenning.cfm?type=Create">Create New Cash Recording</a>
|| <a href="s_dailycountertable.cfm?type=counter">Search For Cash Recording</a>
	</h4>

    <form action="/default/maintenance/counter/s_countertable.cfm" method="post">
		<h1>Search By :
        <select name="searchType">
			<option value="counterid">Counter</option>
	      	<option value="opening">Type</option>
	    </select>
      	Search for Cash Recording : 
      	<input type="text" name="searchStr" value="" size="40">
	  	</h1>
	</form>
	
	<cfif isdefined("url.process")>
		<h1>#form.status#</h1><hr>
  	</cfif>
	
  	<cfquery datasource='#dts#' name="type">
		select * from dailycounter order by created_on desc
  	</cfquery>
		
  	<cfif isdefined("form.searchStr")>
  		<cfquery datasource="#dts#" name="exactResult">
    		select * from dailycounter where #form.searchType# = '#form.searchStr#' order by #form.searchType#
		</cfquery>
			
  		<cfquery datasource="#dts#" name="similarResult">
    		select * from dailycounter where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by #form.searchType#
		</cfquery>
			
		<h2>Exact Result</h2>
		<cfif exactResult.recordCount neq 0>
		
		<table align="center" class="data" width="50%">
      		<tr> 
        		<th>Counter</th>
        		<th>Date</th>
                <th>Desp</th>
                <th>Type</th>
                <th>Amount</th>
				<th width="10%">Action</th>
      		</tr>
      		<cfloop query="exactResult"> 
        	<tr> 
          		<td>#exactResult.counterid#</td>
          		<td>#dateformat(exactResult.wos_date,'DD/MM/YYYY')#</td>
                <td>#exactResult.desp#</td>
                <td>#exactResult.type#</td>
                <td>#exactResult.openning#</td>

				<td nowrap> 
            		<div align="center">
                    <a href="processprint.cfm?id=#exactResult.id#" target="_blank">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Print" border="0">Print</a> &nbsp;
					<a href="adddailyopenning.cfm?type=Delete&id=#exactResult.id#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="adddailyopenning.cfm?type=Edit&id=#exactResult.id#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a> &nbsp;
                    
                    
            		</div>
				</td>

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
	      		<th>Counter</th>
        		<th>Date</th>
                <th>Desp</th>
                <th>Type</th>
                <th>Amount</th>
					<th width="10%">Action</th>
	    	</tr>
	
	   		<cfloop query="similarResult">
	      	<tr> 
          		<td>#similarResult.counterid#</td>
          		<td>#dateformat(similarResult.wos_date,'DD/MM/YYYY')#</td>
                <td>#similarResult.desp#</td>
                <td>#similarResult.type#</td>
                <td>#similarResult.openning#</td>
				<td nowrap> 
            		<div align="center">
                    <a href="processprint.cfm?id=#similarResult.id#" target="_blank">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Print" border="0">Print</a> &nbsp;
					<a href="adddailyopenning.cfm?type=Delete&id=#similarResult.id#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="adddailyopenning.cfm?type=Edit&id=#similarResult.id#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a>&nbsp;
                    
            		</div>
				</td>
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
20 Newest Counter:
</legend><br>


<cfif type.recordCount neq 0>
  	<table align="center" class="data" width="50%">
    	<tr> 
      		<th>No.</th>
      		<th>Counter</th>
        		<th>Date</th>
                <th>Desp</th>
                <th>Type</th>
                <th>Amount</th>
			<th width="10%">Action</th>

    	</tr>
    	<cfoutput query="type" maxrows="20"> 
      	<tr> 
        	<td width="5%">#type.currentrow#</td>
        	<td>#type.counterid#</td>
        	<td nowrap>#dateformat(type.wos_date,'DD/MM/YYYY')#</td>
            <td>#type.desp#</td>
            <td>#type.type#</td>
            <td>#type.openning#</td>

				<td nowrap><div align="center">
                	<a href="processprint.cfm?id=#type.id#" target="_blank">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Print" border="0">Print</a> &nbsp;
					<a href="adddailyopenning.cfm?type=Delete&id=#type.id#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="adddailyopenning.cfm?type=Edit&id=#type.id#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a>&nbsp;
                    
				</td>

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