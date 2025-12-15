<cfquery datasource='#dts#' name="getgeneral">
	Select lgroup as layer from gsetup
</cfquery>

<html>
<head>
<title>View <cfoutput>#getgeneral.layer#</cfoutput></title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
	<cfquery datasource='#dts#' name="getPersonnel">
		Select * from icgroup order by wos_group
	</cfquery>

	<cfparam name="start" default="1">
	<cfparam name="page" default="1">
	<cfparam name="prevFive" default="0">
	<cfparam name="nextFive" default="0">

<h1>View <cfoutput>#getgeneral.layer#</cfoutput> Informations</h1>

<cfoutput>
	<h4>
		<cfif getpin2.h1510 eq 'T'>
		<a href="grouptable2.cfm?type=Create&showgrade=no">Creating a New #getgeneral.layer#</a> </cfif>
		<cfif getpin2.h1520 eq 'T'>|| <a href="grouptable.cfm">List all #getgeneral.layer#</a> </cfif>
		<cfif getpin2.h1530 eq 'T'>|| <a href="s_grouptable.cfm?type=Icitem">Search For #getgeneral.layer#</a> </cfif>
		<cfif getpin2.h1540 eq 'T'>|| <a href="p_group.cfm">#getgeneral.layer# Listing</a></cfif>
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
	
	<cfform action="grouptable.cfm" method="post">
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
			<cfoutput>|| <a href="grouptable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
		</cfif>
		
		<cfif page neq noOfPage>
			<cfoutput> <a href="grouptable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
		</cfif>
				
		<cfoutput>Page #page# Of #noOfPage#</cfoutput>
		</div>
		<hr>
		
		<cfif isdefined("url.process")>
			<cfoutput><h1>#form.status#</h1><hr></cfoutput>
		</cfif>
		
		<cfoutput query="getPersonnel" startrow="#start#" maxrows="5">
			<cfset strNo = "getPersonnel.wos_group">
			
			<table align="center" class="data" width="450px">
        		<tr> 
          			<th width="20%">#getgeneral.layer#</th>
          			<td>#getPersonnel.wos_group#</td>
        		</tr>
        		<tr> 
          			<th>Description</th>
          			<td>#getPersonnel.desp#</td>
        		</tr>
				<cfif getpin2.h1511 eq 'T'>
        			<tr> 
          				<td colspan="2"><div align="right"><a href="grouptable2.cfm?type=Delete&wos_group=#evaluate(strNo)#">
						<img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a> 
						<a href="grouptable2.cfm?type=Edit&wos_group=#evaluate(strNo)#&showgrade=no">
						<img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
        			</tr>
				</cfif>
      		</table>
			<br><hr>
		</cfoutput>
	</cfform>
	
	<div align="right">
			
	<cfif start neq 1>
		<cfoutput>|| <a href="grouptable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
	</cfif>
	
	<cfif page neq noOfPage>
		<cfoutput> <a href="grouptable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
	</cfif>
				
	<cfoutput>Page #page# Of #noOfPage#</cfoutput>
	</div><hr>
<cfelse>
	<h3>Sorry, No records were found.</h3>
</cfif>
			
</body>
</html>