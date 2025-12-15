<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>	
<h1>Service Selection Page</h1>

<h4>
	<cfif getpin2.h1G10 eq 'T'>
		<a href="servicetable2.cfm?type=Create">Creating a Service</a> 
	</cfif>
	<cfif getpin2.h1G20 eq 'T'>
		|| <a href="servicetable.cfm?">List All Service</a> 
	</cfif>
	<cfif getpin2.h1G30 eq 'T'>
		|| <a href="s_servicetable.cfm?type=icservi">Search For Service</a>
	</cfif>
</h4>


<form action="s_servicetable.cfm" method="post">
	<h1>Search By :
		<select name="searchType">
			<option value="servi">Service</option>
			<option value="desp">Description</option>
		</select>
    Search for Service : 
	<input type="text" name="searchStr" value=""> </h1>
</form>


<cfif isdefined("url.process")>
	<h1><cfoutput>#form.status#</cfoutput></h1><hr>
</cfif>
	
<cfquery datasource='#dts#' name="type">
	Select * from icservi order by servi, desp, salec, salecsc, salecnc, purc, purprc
</cfquery>
	
<cfif isdefined("form.searchStr")>
	<cfquery datasource='#dts#' name="exactResult">
		Select * from icservi where #form.searchType# = '#form.searchStr#' order by servi, desp, salec, salecsc, salecnc, purc, purprc
	</cfquery>
			
	<cfquery datasource='#dts#' name="similarResult">
		Select * from icservi where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by servi, desp, salec, salecsc, salecnc, purc, purprc
	</cfquery>
			
	<h2>Exact Result</h2>
	
	<cfif exactResult.recordCount neq 0>
		<table align="center" class="data" width="600px">
   			<tr> 
      			<th>Service</th>
       			<th>Description</th>
				<cfif getpin2.h1G11 eq 'T'><th>Action</th></cfif>
   			</tr>
      		
			<cfoutput query="exactResult"> 
        		<tr> 
          			<td>#exactResult.servi#</a></td>
          			<td>#exactResult.desp#</td>
          			<cfif getpin2.h1G11 eq 'T'>
						<td width="10%" nowrap><div align="center">
							<a href="servicetable2.cfm?type=Delete&servi=#urlencodedformat(exactResult.servi)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              				<a href="servicetable2.cfm?type=Edit&servi=#urlencodedformat(exactResult.servi)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>							
						</td>
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
        		<th>Service</th>
        		<th>Description</th>
				<cfif getpin2.h1G11 eq 'T'><th>Action</th></cfif>
      		</tr>
      		
			<cfoutput query="similarResult"> 
        		<tr> 
          			<td>#similarResult.servi#</a></td>
          			<td>#similarResult.desp#</td>
          			<cfif getpin2.h1G11 eq 'T'>
						<td width="10%" nowrap><div align="center">
							<a href="servicetable2.cfm?type=Delete&servi=#urlencodedformat(similarResult.servi)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
              				<a href="servicetable2.cfm?type=Edit&servi=#urlencodedformat(similarResult.servi)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
						</td>
					</cfif>
        		</tr>
      		</cfoutput> 
    	</table>
	<cfelse>
		<h3>No Similar Records were found.</h3>
	</cfif>
</cfif>

<cfparam name="i" default="1" type="numeric">

<hr><fieldset><legend style="font-family:Verdana,Arial,Helvetica,sans-serif;font-size:12px;font-style:italic;line-height:normal;font-weight:bold;text-transform:capitalize;color:##0066FF;"> 20 Newest Service :</legend>
<br>

<cfif type.recordCount neq 0>
	<table align="center" class="data" width="600px">
    	<tr> 
      		<th>No</th>
      		<th>Service</th>
      		<th>Description</th>
	  		<cfif getpin2.h1G11 eq 'T'><th>Action</th></cfif>
    	</tr>
    	
		<cfoutput query="type" maxrows="20"> 
      		<tr> 
        		<td>#i#</td>
       		 	<td>#type.servi#</a></td>
        		<td>#type.desp#</td>
        		<cfif getpin2.h1G11 eq 'T'>
					<td width="10%" nowrap><div align="center">
						<a href="servicetable2.cfm?type=Delete&servi=#urlencodedformat(type.servi)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>&nbsp; 
            			<a href="servicetable2.cfm?type=Edit&servi=#urlencodedformat(type.servi)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
					</td>
				</cfif>
      		</tr>
      		<cfset i = incrementvalue(i)>
    	</cfoutput> 
  	</table>
<cfelse>
	<h3>No Records were found.</h3>
</cfif>

<br>
</fieldset>

</body>
</html>