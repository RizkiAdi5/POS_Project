<html>
<head>
<title>Color - Size Maintenance</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
	<cfquery datasource='#dts#' name="getPersonnel">
		Select * from iccolor2 order by colorno,colorid2
	</cfquery>

	<cfparam name="start" default="1">
	<cfparam name="page" default="1">
	<cfparam name="prevFive" default="0">
	<cfparam name="nextFive" default="0">

<h1>View Color - Size Informations</h1>

<cfoutput>
	<h4>
		<cfif getpin2.h1L10 eq 'T'>
		<a href="colorsizetable2.cfm?type=Create">Creating a New Color - Size</a> </cfif>
		<cfif getpin2.h1L20 eq 'T'>|| <a href="colorsizetable.cfm">List all Color - Size</a> </cfif>
		<cfif getpin2.h1L30 eq 'T'>|| <a href="s_colorsizetable.cfm?type=Icitem">Search For Color - Size</a> </cfif>
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
	
	<cfform action="colorsizetable.cfm" method="post">
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
			<cfoutput>|| <a href="colorsizetable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
		</cfif>
		
		<cfif page neq noOfPage>
			<cfoutput> <a href="colorsizetable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
		</cfif>
				
		<cfoutput>Page #page# Of #noOfPage#</cfoutput>
		</div>
		<hr>
		
		<cfif isdefined("url.process")>
			<cfoutput><h1>#form.status#</h1><hr></cfoutput>
		</cfif>
		
		<cfoutput query="getPersonnel" startrow="#start#" maxrows="5">
			<cfset strNo = "getPersonnel.colorid2">
			
			<table align="center" class="data" width="450px">
        		<tr> 
          			<th width="20%">Color No.</th>
          			<td>#getPersonnel.colorno#</td>
        		</tr>
				<tr> 
          			<th width="20%">Color ID</th>
          			<td>#getPersonnel.colorid2#</td>
        		</tr>
        		<tr> 
          			<th>Description</th>
          			<td>#getPersonnel.desp#</td>
        		</tr>
				<cfif getpin2.h1L11 eq 'T'>
        			<tr> 
          				<td colspan="2"><div align="right"><a href="colorsizetable2.cfm?type=Delete&colorid2=#evaluate(strNo)#&colorno=#getPersonnel.colorno#">
						<img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a> 
						<a href="colorsizetable2.cfm?type=Edit&colorid2=#evaluate(strNo)#&colorno=#getPersonnel.colorno#">
						<img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
        			</tr>
				</cfif>
      		</table>
			<br><hr>
		</cfoutput>
	</cfform>
	
	<div align="right">
			
	<cfif start neq 1>
		<cfoutput>|| <a href="colorsizetable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
	</cfif>
	
	<cfif page neq noOfPage>
		<cfoutput> <a href="colorsizetable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
	</cfif>
				
	<cfoutput>Page #page# Of #noOfPage#</cfoutput>
	</div><hr>
<cfelse>
	<h3>Sorry, No records were found.</h3>
</cfif>
			
</body>
</html>