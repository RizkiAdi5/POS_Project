
<html>
<head>
<title>View <cfoutput>Language</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfquery datasource='#dts#' name="getPersonnel">
	Select * from iclanguage order by langno
</cfquery>
			
<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevFive" default="0">
<cfparam name="nextFive" default="0">
<cfoutput>
<h1>View Language Informations</h1>
</cfoutput>
<cfoutput>
	<h4>
		<cfif getpin2.h1H10 eq 'T'><a href="languagetable2.cfm?type=Create">Creating a Language</a> </cfif>
		<cfif getpin2.h1H20 eq 'T'>|| <a href="languagetable.cfm?">List all Language</a> </cfif>
		<cfif getpin2.h1H30 eq 'T'>|| <a href="s_languagetable.cfm?type=language">Search For Language</a>
	  </cfif>||<a href="p_language.cfm">Language Listing report</a>
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
	<cfform action="languagetable.cfm" method="post">
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
		<cfoutput>|| <a href="languagetable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
	</cfif>
	
	<cfif page neq noOfPage>
		<cfoutput> <a href="languagetable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
	</cfif>
	
	<cfoutput>Page #page# Of #noOfPage#</cfoutput>
</div>

<hr>

<cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1><hr></cfoutput>
</cfif>


	<cfoutput query="getPersonnel" startrow="#start#" maxrows="5">
	<cfset strNo = "Language">
	<!--- QCH <cfset strNo = "start">  --->
				
      <table align="center" class="data" width="550px">
        <!--- <tr> 
          <th width="20%">No</th>
          <td>#evaluate(strNo)#</td>
        </tr> --->
        <tr> 
          <th width="20%">Language</th>
          <td>#getPersonnel.langno#</td>
        </tr>
        <tr> 
          <th>English</th>
          <td>#getPersonnel.english#</td>
        </tr>
        <tr> 
          <th>Chinese</th>
          <td>#getPersonnel.chinese#</td>
        </tr>

        <tr> 
          <td colspan="2"><div align="right"><a href="languagetable2.cfm?type=Delete&langno=#langno#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0"> 
              Delete</a> <a href="languagetable2.cfm?type=Edit&langno=#langno#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
        </tr>
      </table>
							
				<br>
				<hr>
				
				</cfoutput>
				</cfform>
				<div align="right">
			
				<cfif start neq 1>
					<cfoutput>|| <a href="languagetable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
				</cfif>
				
			    <cfif page neq noOfPage>
					<cfoutput> <a href="languagetable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
				</cfif>
				
				<cfoutput>Page #page# Of #noOfPage#</cfoutput>
				</div>
			
				<hr>
				<cfelse>
					<h3>Sorry, No records were found.</h3>
				</cfif>			
</body>
</html>
