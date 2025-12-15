<html>
<head>
<title>Search Voucher Type</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<h1>Voucher Type Selection Page</h1>



<cfoutput>
	<h4>
<a href="vouchertable2.cfm?type=Create">Create New Voucher Type</a>
|| <a href="vouchertable.cfm">List All Voucher Type</a>
|| <a href="s_vouchertable.cfm?type=voucher">Search For Voucher Type</a>
	</h4>

    <form action="s_vouchertable.cfm" method="post">
		<h1>Search By :
        <select name="searchType">
			<option value="voucherid">Voucher Type</option>
	      	<option value="voucherdesp">Description</option>
	    </select>
      	Search for Voucher Type : 
      	<input type="text" name="searchStr" value="" size="40">
	  	</h1>
	</form>
	
	<cfif isdefined("url.process")>
		<h1>#form.status#</h1><hr>
  	</cfif>
	
  	<cfquery datasource='#dts#' name="type">
		select * from vouchertype order by voucherid
  	</cfquery>
		
  	<cfif isdefined("form.searchStr")>
  		<cfquery datasource="#dts#" name="exactResult">
    		select * from vouchertype where #form.searchType# = '#form.searchStr#' order by #form.searchType#
		</cfquery>
			
  		<cfquery datasource="#dts#" name="similarResult">
    		select * from vouchertype where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by #form.searchType#
		</cfquery>
			
		<h2>Exact Result</h2>
		<cfif exactResult.recordCount neq 0>
		
		<table align="center" class="data" width="50%">
      		<tr> 
        		<th>Voucher Type</th>
        		<th>Description</th>
				<th width="10%">Action</th>
      		</tr>
      		<cfloop query="exactResult"> 
        	<tr> 
          		<td>#exactResult.voucherid#</td>
          		<td>#exactResult.voucherdesp#</td>

				<td nowrap> 
            		<div align="center">
					<a href="vouchertable2.cfm?type=Delete&voucher=#exactResult.voucherid#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="vouchertable2.cfm?type=Edit&voucher=#exactResult.voucherid#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a> 
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
	      		<th>Voucher Type</th>
        		<th>Description</th>
					<th width="10%">Action</th>
	    	</tr>
	
	   		<cfloop query="similarResult">
	      	<tr> 
          		<td>#similarResult.voucherid#</td>
          		<td>#similarResult.voucherdesp#</td>
				<td nowrap> 
            		<div align="center">
					<a href="vouchertable2.cfm?type=Delete&voucher=#similarResult.voucherid#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="vouchertable2.cfm?type=Edit&voucher=#similarResult.voucherid#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a> 
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
20 Newest Voucher Type:
</legend><br>


<cfif type.recordCount neq 0>
  	<table align="center" class="data" width="50%">
    	<tr> 
      		<th>No.</th>
      		<th>Voucher Type</th>
      		<th>Description</th>
			<th width="10%">Action</th>

    	</tr>
    	<cfoutput query="type" maxrows="20"> 
      	<tr> 
        	<td width="5%">#type.currentrow#</td>
        	<td>#type.voucherid#</td>
        	<td nowrap>#type.voucherdesp#</td>

				<td nowrap><div align="center">
					<a href="vouchertable2.cfm?type=Delete&voucher=#type.voucherid#">
					<img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
					<a href="vouchertable2.cfm?type=Edit&voucher=#type.voucherid#">
					<img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a></div> 
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