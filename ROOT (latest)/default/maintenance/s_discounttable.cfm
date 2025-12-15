<html>
<head>
<title>Create Or Edit Or View</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<body>
		
<h1><cfoutput>Discount Selection Page</cfoutput></h1>
		
<cfoutput>
	<h4>
		<cfif getpin2.h1P10 eq 'T'><a href="discounttable2.cfm?type=Create">Creating a New Discount</a> </cfif>
		<cfif getpin2.h1P20 eq 'T'>|| <a href="discounttable.cfm">List all Discount</a> </cfif>
		<cfif getpin2.h1P30 eq 'T'>|| <a href="s_discounttable.cfm?type=discount">Search For Discount</a></cfif>
        <cfif getpin2.h1630 eq 'T'>|| <a href="p_discount.cfm">Discount Listing</a>
        </cfif>
	</h4>
</cfoutput>
		
<cfoutput>
	<form action="s_discounttable.cfm" method="post"></cfoutput>
	<cfoutput>
		<h1>Search By :
		<select name="searchType">
			<option value="discount">Discount</option>
		</select>
        Search for Discount : <input type="text" name="searchStr" value=""> </h1>
	</cfoutput>
	</form>
		
	<cfif isdefined("url.process")>
		<cfoutput><h1>#form.status#</h1><hr></cfoutput>
	</cfif>
	
	<cfquery datasource='#dts#' name="type">
		Select * from discount order by discount,desp
	</cfquery>
		
	<cfif isdefined("form.searchStr")>
		<cfquery datasource='#dts#' name="exactResult">
			Select * from discount where #form.searchType# = '#form.searchstr#' order by discount, desp
		</cfquery>
			
		<cfquery datasource='#dts#' name="similarResult">
			Select * from discount where #form.searchType# LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.searchStr#%"> order by discount,desp
            </cfquery>
			
		<h2>Exact Result</h2>
		<cfif exactResult.recordCount neq 0>
			<table align="center" class="data" width="600px">				
	     		<tr> 
	        		<cfoutput><th>Discount</th></cfoutput>
					<th>Desp</th>
                    <cfif getpin2.h1P11 eq 'T'><th>Action</th></cfif>				
				</tr>
				<cfoutput query="exactResult">
					<tr>
						<td>#exactResult.discount#</a></td>
						<td>#exactResult.desp#</td>
	          			<cfif getpin2.h1P11 eq 'T'>
		          			<td width="10%" nowrap><div align="center">
			          			<a href="discounttable2.cfm?type=Delete&discount=#URLEncodedFormat(exactResult.discount)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>
			          			&nbsp;<a href="discounttable2.cfm?type=Edit&discount=#URLEncodedFormat(exactResult.discount)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
							</div></td>
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
	        		<cfoutput><th>Discount</th></cfoutput>
					<th>Desp</th>
					<cfif getpin2.h1P11 eq 'T'><th>Action</th></cfif>
				</tr>
				<cfoutput query="similarResult">
					<tr>
						<td>#similarResult.discount#</a></td>
						<td>#similarResult.desp#</td>
	          			<cfif getpin2.h1P11 eq 'T'>
		          			<td width="10%" nowrap> 
	            				<div align="center"><a href="discounttable2.cfm?type=Delete&discount=#URLEncodedFormat(similarResult.discount)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>
	            				&nbsp;<a href="discounttable2.cfm?type=Edit&discount=#URLEncodedFormat(similarResult.discount)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
								</div>
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
	<hr>
		
	<fieldset>
	<legend style="font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 12px;
		font-style: italic;line-height: normal;font-weight: bold;text-transform: capitalize;color: #0066FF;"> 
		<cfoutput>20 Newest Discount :</cfoutput>
	</legend>
	<br>
		<cfif type.recordCount neq 0>
			<table align="center" class="data" width="600px">	
				<tr>
					<th>No</th>
	      			<cfoutput><th>Discount</th></cfoutput>
					<th>Desp</th>
					<cfif getpin2.h1P11 eq 'T'><th>Action</th></cfif>
				</tr>
				<cfoutput query="type" maxrows="20">
					<tr>	
						<td>#i#</td>
						<td>#type.discount#</a></td>
						<td>#type.desp#<br></td>
		       			<cfif getpin2.h1P11 eq 'T'>
			       			<td width="10%" nowrap>
				       			<div align="center"><a href="discounttable2.cfm?type=Delete&discount=#URLEncodedFormat(type.discount)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a>
				       			&nbsp;<a href="discounttable2.cfm?type=Edit&discount=#URLEncodedFormat(type.discount)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
								</div>
							</td>
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
</body>
</html>
