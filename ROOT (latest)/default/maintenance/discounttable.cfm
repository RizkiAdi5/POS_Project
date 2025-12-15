<html>
<head>
<title>View Discount</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfquery datasource='#dts#' name="getPersonnel">
	Select * from discount order by discount
</cfquery>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevFive" default="0">
<cfparam name="nextFive" default="0">
			
<h1>View Cashier Informations</h1>

<cfoutput>
	<h4>
		<cfif getpin2.h1P10 eq 'T'><a href="discounttable2.cfm?type=Create">Creating a New Discount</a> </cfif>
		<cfif getpin2.h1P20 eq 'T'>|| <a href="discounttable.cfm">List all Discount</a> </cfif>
		<cfif getpin2.h1P30 eq 'T'>|| <a href="s_discounttable.cfm?type=discount">Search For Discount</a></cfif>
        <cfif getpin2.h1630 eq 'T'>|| <a href="p_discount.cfm">Discount Listing</a>
        </cfif>
	</h4>
</cfoutput>
<cfif getPersonnel.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
  		<cfset noOfPage=round(getPersonnel.recordcount/5)>
		<cfif getPersonnel.recordcount mod 5 LT 3 and getPersonnel.recordcount mod 5 neq 0>
			<cfset noOfPage=noOfPage+1>
		</cfif>
		<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
			<h3 align="center"><font color="#FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
		</cfif>
 	</cfif>
	<cfform action="discounttable.cfm" method="post">
		<div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
			<cfset noOfPage=round(getPersonnel.recordcount/5)>
			
			<cfif getPersonnel.recordcount mod 5 LT 3 and getPersonnel.recordcount mod 5 neq 0>
				<cfset noOfPage=noOfPage+1>
			</cfif>
			<cfif isdefined("url.start")>
				<cfset start=url.start>
			</cfif>
			<cfif isdefined("form.skeypage")>				
				<cfset start = form.skeypage * 5 + 1 - 5>				
				<cfif form.skeypage eq "1">
					<cfset start = "1">					
				</cfif>  				
			</cfif> 
			<cfset prevFive=start -5>
			<cfset nextFive=start +5>
			<cfset page=round(nextFive/5)>
			<cfif start neq 1>
				<cfoutput>|| <a href="discounttable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
			</cfif>
			<cfif page neq noOfPage>
				<cfoutput> <a href="discounttable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
			</cfif>
			<cfoutput>Page #page# Of #noOfPage#</cfoutput>
		</div>
		<hr>
		<cfif isdefined("url.process")>
			<cfoutput><h1>#form.status#</h1><hr></cfoutput>
		</cfif>
		<cfoutput query="getPersonnel" startrow="#start#" maxrows="5">
			<cfset strNo = "getPersonnel.discount"> 
					
			<table align="center" class="data" width="450px">
	        	<tr> 
	          		<th width="20%">Discount</th>
	          		<td>#getPersonnel.discount#</td>
	        	</tr>
		        <tr> 
		          <th>Desp</th>
		          <td>#getPersonnel.desp#<br></td>
		        </tr>
                 <cfif getpin2.h1P11 eq 'T'><tr> 
		        <td colspan="2">
			        <div align="right"><a href="discounttable2.cfm?type=Delete&discount=#URLEncodedFormat(evaluate(strNo))#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a> 
			        <a href="discounttable2.cfm?type=Edit&discount=#URLEncodedFormat(evaluate(strNo))#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
		        </tr>
				</cfif>
			</table>			
			<br><hr>	
		</cfoutput>
	</cfform>
	<div align="right">
		<cfif start neq 1>
			<cfoutput>|| <a href="discounttable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
		</cfif>
		<cfif page neq noOfPage>
			<cfoutput> <a href="discounttable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
		</cfif>
		<cfoutput>Page #page# Of #noOfPage#</cfoutput>
	</div>
	<hr>
<cfelse>
	<h3>Sorry, No records were found.</h3>
</cfif>			
</body>
</html>
