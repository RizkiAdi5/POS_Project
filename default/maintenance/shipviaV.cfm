<html>
<head>
<title>View Ship Via</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<cfquery datasource='#dts#' name="getPersonnel">
	Select * from shipvia order by shipvia
</cfquery>		
			
<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevFive" default="0">
<cfparam name="nextFive" default="0">

<h1>View Ship Via Informations</h1>

<cfoutput>
  <h4><cfif getpin2.h1A10 eq 'T'><a href="shipvia.cfm?type=Create">Creating a Ship Via</a> </cfif><cfif getpin2.h1A20 eq 'T'>|| <a href="shipviaV.cfm?">List 
    all Ship Via</a> </cfif><cfif getpin2.h1A30 eq 'T'>|| <a href="shipviaS.cfm">Search For Ship Via</a></cfif></h4>
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
  <cfform action="shipviaV.cfm" method="post">
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
        <cfoutput>|| <a href="shipviaV.cfm?start=#prevFive#">Previous</a> 
          ||</cfoutput> 
      </cfif>
      <cfif #page# neq #noOfPage#>
        <cfoutput> <a href="shipviaV.cfm?start=#evaluate(nextFive)#">Next</a> 
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
      <cfset strNo = "getPersonnel.shipvia">
      <table align="center" class="data" width="450px">
        <!--- <tr> 
          <th width="20%">No</th>
          <td>#evaluate(strNo)#</td>
        </tr> --->
        <tr> 
          <th width="20%"><p>Ship Via</p></th>
          <td>#getPersonnel.shipvia#</td>
        </tr>
        <tr> 
          <th>Description</th>
          <td>#getPersonnel.desp#<br></td>
        </tr>
		<cfif getpin2.h1A11 eq 'T'>
        <tr> 
          <td colspan="2"><div align="right"><a href="shipvia.cfm?type=Delete&shipvia=#evaluate(strNo)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0"> 
              Delete</a> <a href="shipvia.cfm?type=Edit&shipvia=#evaluate(strNo)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
        </tr></cfif>
      </table>
      <br>
      <hr>
    </cfoutput> 
  </cfform>
  <div align="right"> 
    <cfif #start# neq 1>
      <cfoutput>|| <a href="shipviaV.cfm?start=#prevFive#">Previous</a> 
        ||</cfoutput> 
    </cfif>
    <cfif #page# neq #noOfPage#>
      <cfoutput> <a href="shipviaV.cfm?start=#evaluate(nextFive)#">Next</a> 
        ||</cfoutput> 
    </cfif>
    <cfoutput>Page #page# Of #noOfPage#</cfoutput> </div>
  <hr>
  <cfelse>
  <h3>Sorry, No records were found.</h3>
</cfif>
</body>
</html>
