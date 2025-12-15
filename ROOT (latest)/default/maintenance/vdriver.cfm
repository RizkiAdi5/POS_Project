<html>
<head>
<title>View Driver</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--- ADD ON 15-07-2009 --->
<cfquery name="getGsetup" datasource="#dts#">
  Select lDRIVER from GSetup
</cfquery>

<cfquery datasource='#dts#' name="getPersonnel">
	select * from driver order by driverno
</cfquery>

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevFive" default="0">
<cfparam name="nextFive" default="0">

<cfoutput> 
  <h1>View #getGsetup.lDRIVER# Informations</h1>
</cfoutput> 
<cfoutput> 
	<h4>
		<cfif getpin2.h1C10 eq 'T'><a href="Driver.cfm?type=Create"> Creating a #getGsetup.lDRIVER#</a> </cfif>
		<cfif getpin2.h1C20 eq 'T'>|| <a href="vdriver.cfm">List all #getGsetup.lDRIVER#</a> </cfif>
		<cfif getpin2.h1C30 eq 'T'>|| <a href="sdriver.cfm">Search #getGsetup.lDRIVER#</a> </cfif>
		<cfif getpin2.h1C40 eq 'T'>|| <a href="pdriver.cfm" target="_blank">#getGsetup.lDRIVER# Listing</a></cfif>
	</h4>
</cfoutput> 
<cfif #getPersonnel.recordcount# neq 0>
	<cfif isdefined("form.skeypage")>
    	<cfset noOfPage=round(#getPersonnel.recordcount#/5)>
    	<cfif #getPersonnel.recordcount# mod 5 LT 3 and #getPersonnel.recordcount# mod 5 neq 0>
      		<cfset noOfPage=#noOfPage#+1>
    	</cfif>
    	<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
      		<h3 align="center"><font color="#FF0000">Wrong page number! Please try again.</font></h3>
      		<cfabort>
    	</cfif>
  	</cfif>
  	<cfform action="vdriver.cfm" method="post">
    	<div align="right">Page 
      	<cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
      	<cfset noOfPage=round(#getPersonnel.recordcount#/5)>
      	<cfif #getPersonnel.recordcount# mod 5 LT 3 and #getPersonnel.recordcount# mod 5 neq 0>
        	<cfset noOfPage=#noOfPage#+1>
      	</cfif>
      	<cfif isdefined("url.start")>
        	<cfset start=#url.start#>
      	</cfif>
      	<cfif isdefined("form.skeypage")>
        	<cfset start = #form.skeypage# * 5 + 1 - 5>
        	<cfif form.skeypage eq "1">
          		<cfset start = "1">
        	</cfif>
      	</cfif>
      	<cfset prevFive=#start# -5>
      	<cfset nextFive=#start# +5>
      	<cfset page=round(#nextFive#/5)>
      	<cfif #start# neq 1>
        	<cfoutput>|| <a href="vdriver.cfm?start=#prevFive#">Previous</a> 
          	||</cfoutput> 
      	</cfif>
      	<cfif #page# neq #noOfPage#>
        	<cfoutput> <a href="vdriver.cfm?start=#evaluate(nextFive)#">Next</a> 
          	||</cfoutput> 
      	</cfif>
      	<cfoutput>Page #page# Of #noOfPage#</cfoutput> </div>
    	<hr>
    	<cfif isdefined("url.process")>
      		<cfoutput>
        		<h1>#form.status#</h1>
        		<hr>
      		</cfoutput> 
    	</cfif>
    	<cfoutput query="getPersonnel" startrow="#start#" maxrows="5"> 
      	<cfset strNo = "getPersonnel.driverno">
      	<table align="center" class="data" width="500px">
        	<tr> 
          		<th width="20%">#getGsetup.lDRIVER# No</th>
          		<td>#evaluate(strNo)#</td>
        	</tr>
	        <tr> 
		    	<th>Name</th>
		        <td>#getPersonnel.name# #getPersonnel.name2#</td>
	        </tr>
	        <tr> 
	          	<th>NRIC No</th>
	          	<td>#getPersonnel.attn#</td>
	        </tr>
	        <tr> 
	          	<th><cfif lcase(HcomID) eq "iel_i" or lcase(HcomID) eq "ielm_i">Supplier<cfelse>Customer</cfif> No</th>
	          	<td>#getPersonnel.customerno#<br></td>
	        </tr>
	        <tr> 
	          	<th>Address</th>
	          	<td>#getPersonnel.add1#<br> #getPersonnel.add2#<br> #getPersonnel.add3#</td>
	        </tr>
	        <tr> 
	          	<th>Contact</th>
	          	<td>#getPersonnel.contact#</td>
	        </tr>
			<cfif getpin2.h1C11 eq 'T'>
		        <tr> 
		          <td colspan="2"><div align="right"><a href="driver.cfm?type=Delete&driverno=#evaluate(strNo)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0"> 
		              Delete</a> <a href="driver.cfm?type=Edit&driverno=#evaluate(strNo)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
		        </tr>
			</cfif>
      	</table>
      	<br>
      	<hr>
    </cfoutput> 
  	</cfform>
  	<div align="right"> 
    	<cfif #start# neq 1>
      		<cfoutput>|| <a href="driver.cfm?start=#prevFive#">Previous</a> 
        	||</cfoutput> 
    	</cfif>
    	<cfif #page# neq #noOfPage#>
      		<cfoutput> <a href="driver.cfm?start=#evaluate(nextFive)#">Next</a> 
        	||</cfoutput> 
    	</cfif>
    	<cfoutput>Page #page# Of #noOfPage#</cfoutput> 
	</div>
 	<hr>
<cfelse>
  <h3>Sorry, No records were found.</h3>
</cfif>
</body>
</html>
