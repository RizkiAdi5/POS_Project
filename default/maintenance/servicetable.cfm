<html>
<head>
<title>View Service</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfquery datasource='#dts#' name="getPersonnel">
	Select * from icservi order by servi
</cfquery>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevFive" default="0">
<cfparam name="nextFive" default="0">


<h1>View Service Informations</h1>
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

<cfif getPersonnel.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage=round(getPersonnel.recordcount/5)>
		
		<cfif getPersonnel.recordcount mod 5 LT 3 and getPersonnel.recordcount mod 5 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>
		
		<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
			<h3 align="center"><font color="#FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
		</cfif>
	</cfif>
	
	<cfform action="servicetable.cfm" method="post">
		<div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
		
		<cfset noOfPage=round(getPersonnel.recordcount/5)>
		
		<cfif getPersonnel.recordcount mod 5 LT 3 and getPersonnel.recordcount mod 5 neq 0>
			<cfset noOfPage = noOfPage+1>
		</cfif>
		
		<cfif isdefined("url.start")>
			<cfset start = url.start>
		</cfif>
		
		<cfif isdefined("form.skeypage")>				
			<cfset start = form.skeypage * 5 + 1 - 5>				
			
			<cfif form.skeypage eq "1">
				<cfset start = "1">					
			</cfif>  				
		</cfif> 

		<cfset prevFive = start -5>
		<cfset nextFive = start +5>
		<cfset page = round(nextFive/5)>
		
		<cfoutput>
			<cfif start neq 1>
				|| <a href="servicetable.cfm?start=#prevFive#">Previous</a> ||
			</cfif>
		
			<cfif page neq noOfPage>
				 <a href="servicetable.cfm?start=#evaluate(nextFive)#">Next</a> ||
			</cfif>
		
			Page #page# Of #noOfPage#
		</cfoutput>
	</div>
	<hr>
	
	<cfif isdefined("url.process")>
		<h1><cfoutput>#form.status#</cfoutput></h1><hr>
	</cfif>

	<cfoutput query="getPersonnel" startrow="#start#" maxrows="5">
		<table align="center" class="data" width="450px">
        	<tr> 
          		<th width="20%">Service</th>
          		<td>#getPersonnel.servi#</td>
        	</tr>
        	<tr> 
          		<th>Description</th>
          		<td>#getPersonnel.desp#</td>
        	</tr>
			
			<cfif getpin2.h1G11 eq 'T'>
        		<tr> 
          			<td colspan="2"><div align="right">
					<a href="servicetable2.cfm?type=Delete&servi=#urlencodedformat(getPersonnel.servi)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a> 
					<a href="servicetable2.cfm?type=Edit&servi=#urlencodedformat(getPersonnel.servi)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
        		</tr>
			</cfif>
      	</table>
		<br>
		<hr>
	</cfoutput>
	</cfform>
	
	<div align="right">
	<cfoutput>
		<cfif start neq 1>
			|| <a href="servicetable.cfm?start=#prevFive#">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a href="servicetable.cfm?start=#evaluate(nextFive)#">Next</a> ||
		</cfif>
		
		Page #page# Of #noOfPage#
	</cfoutput>
	</div>
	<hr>
<cfelse>
	<h3>Sorry, No records were found.</h3>
</cfif>

</body>
</html>