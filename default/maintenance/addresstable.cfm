<html>
<head>
	<title>View Address</title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>
  <cfquery datasource='#dts#' name="getPersonnel">
	Select * from Address order by Code
  </cfquery>

  <cfparam name="start" default="1">
  <cfparam name="page" default="1">
  <cfparam name="prevFive" default="0">
  <cfparam name="nextFive" default="0">

  <cfoutput><h1>View Address Informations</h1></cfoutput>
  <cfoutput>
    <h4><cfif getpin2.h1F10 eq 'T'><a href="Addresstable2.cfm?type=Create">Creating a New Address</a> </cfif><cfif getpin2.h1F20 eq 'T'>|| <a href="Addresstable.cfm">List
    all Address</a> </cfif><cfif getpin2.h1F30 eq 'T'>|| <a href="s_Addresstable.cfm?type=Icitem">Search For Address</a></cfif></h4>
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

	<cfform action="Addresstable.cfm" method="post">
      <div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
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
	    <cfoutput>|| <a href="Addresstable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
	  </cfif>

	  <cfif #page# neq #noOfPage#>
	    <cfoutput> <a href="Addresstable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
	  </cfif>

	  <cfoutput>Page #page# Of #noOfPage#</cfoutput></div>

	  <hr>

	  <cfif isdefined("url.process")>
	    <cfoutput><h1>#form.status#</h1><hr></cfoutput>
	  </cfif>

	  <cfoutput query="getPersonnel" startrow="#start#" maxrows="5">
	    <cfset strNo = getPersonnel.Code>

      <table align="center" class="data" width="450px">
        <!--- <tr>
          <th width="20%">No</th>
          <td>#evaluate(strNo)#</td>
        </tr> --->
        <tr>
          <th width="20%">Code</th>
          <td>#getPersonnel.Code#</td>
        </tr>
        <tr>
          <th>Name</th>
          <td>#getPersonnel.name#</td>
        </tr>
        <tr><th>Customer No</th><td>#getPersonnel.custno#</td></tr>
        <tr>
          <th>Address</th>
          <td>#getPersonnel.add1#<br> #getPersonnel.add2#<br> #getPersonnel.add3#<br> #getPersonnel.add4#</td>
        </tr>
        <tr>
          <th>Attn</th>
          <td>#getPersonnel.attn#</td>
        </tr>
        <tr>
          <th>Telephone</th>
          <td>#getPersonnel.phone#</td>
        </tr>
        <tr>
          <th>Fax</th>
          <td>#getPersonnel.fax#</td>
        </tr>
        <tr>
          <th>Phone 2</th>
          <td>#getPersonnel.phonea#</td>
        </tr>
        <tr>
          <th>Email</th>
          <td>#getPersonnel.e_mail#</td>
        </tr>
        <cfif getpin2.h1F11 eq 'T'><tr>
          <td colspan="2"><div align="right"><a href="Addresstable2.cfm?type=Delete&Code=#urlencodedformat(strNo)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">
              Delete</a> <a href="Addresstable2.cfm?type=Edit&Code=#urlencodedformat(strNo)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div></td>
        </tr></cfif>
      </table>

	    <br>
	    <hr>
	  </cfoutput>
    </cfform>

	<div align="right">
	  <cfif #start# neq 1>
		<cfoutput>|| <a href="Addresstable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
	  </cfif>

	  <cfif #page# neq #noOfPage#>
		<cfoutput> <a href="Addresstable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
	  </cfif>

	  <cfoutput>Page #page# Of #noOfPage#</cfoutput>
	</div>

	<hr>
  <cfelse>
	<h3>Sorry, No records were found.</h3>
  </cfif>
</body>
</html>
