<html>
<head>
<title>View Term</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfquery datasource='#dts#' name="getPersonnel">
	select * from #target_icterm# order by term
</cfquery>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevFive" default="0">
<cfparam name="nextFive" default="0">

<h1>View Term Informations</h1>

<h4>
	<cfif getpin2.h1I10 eq 'T'>
		<a href="Termtable2.cfm?type=Create">Creating a Term</a> || 
	</cfif>
	<cfif getpin2.h1I20 eq 'T'>
		<a href="Termtable.cfm?">List all Term</a> || 
	</cfif>
	<cfif getpin2.h1I30 eq 'T'> 
		<a href="s_Termtable.cfm?type=icterm">Search For Term</a>
	</cfif>
</h4>

<cfif getPersonnel.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage = round(getPersonnel.recordcount/5)>
		
		<cfif getPersonnel.recordcount mod 5 lt 3 and getPersonnel.recordcount mod 5 neq 0>
			<cfset noOfPage = noOfPage+1>
	  	</cfif>
	  	
		<cfif form.skeypage gt noofpage or form.skeypage lt 1>
			<h3 align="center"><font color="FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
	  	</cfif>
 	</cfif>
	
	<cfform action="Termtable.cfm" method="post">
		<div align="right">Page 
		<cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
		
	    <cfset noOfPage = round(getPersonnel.recordcount/5)>
		
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
			
	    <cfif start neq 1>
		  <cfoutput>|| <a href="Termtable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
	    </cfif>
		
		<cfoutput>
	    	<cfif page neq noOfPage>
		  	 	<a href="Termtable.cfm?start=#evaluate(nextFive)#">Next</a> ||
	    	</cfif>
				
	   		Page #page# Of #noOfPage#
		</cfoutput>
		</div>
		<hr>
	
		<cfif isdefined("url.process")>
			<cfoutput><h1>#form.status#</h1><hr></cfoutput>
		</cfif>
	
		<cfoutput query="getPersonnel" startrow="#start#" maxrows="5">
			<table align="center" class="data" width="450px">
				<tr>
					<th width="20%">Term</th>
					<td>#getPersonnel.term#</td>
				</tr>
				<tr> 
					<th>Description</th>
					<td>#getPersonnel.desp#</td>
				</tr>
				<tr> 
					<th>Setting</th>
					<td><cfif getPersonnel.sign eq "P"> + <cfelse> - </cfif> #getPersonnel.days# Day/s</td>
				</tr>
				<cfif getpin2.h1I11 eq "T">
					<tr>
						<td colspan="2">
							<div align="right">
								<a href="Termtable2.cfm?type=Delete&term=#urlencodedformat(getPersonnel.term)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a> 
								<a href="Termtable2.cfm?type=Edit&term=#urlencodedformat(getPersonnel.term)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a>
							</div>
						</td>
					</tr>
				</cfif>
			</table>
			<br>
			<hr>
		</cfoutput>
	</cfform>

	<cfoutput>
		<div align="right">
		<cfif start neq 1>
			|| <a href="Termtable.cfm?start=#prevFive#">Previous</a> ||
		</cfif>
		
		<cfif page neq noOfPage>
			<a href="Termtable.cfm?start=#evaluate(nextFive)#">Next</a> ||
		</cfif>
		
		Page #page# Of #noOfPage#
		</div>
		<hr>
	</cfoutput>	
<cfelse>
	<h3>Sorry, No records were found.</h3>
</cfif>

</body>
</html>