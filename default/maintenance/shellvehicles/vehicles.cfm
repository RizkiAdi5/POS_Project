<html>
<head>
<title>View Vehicles</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>


<cfquery datasource='#dts#' name="getPersonnel">
	Select * from vehicles 
    order by entryno
</cfquery>

<cfquery datasource='#dts#' name="getgeneral">
	Select * from gsetup
</cfquery>		

<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevFive" default="0">
<cfparam name="nextFive" default="0">

<h1>View icitem Informations</h1>

<h4>
	<cfif getpin2.h1310 eq 'T'>
		<a href="vehicles2.cfm?type=Create">Creating a Vehicle</a> 
	</cfif>
	<cfif getpin2.h1320 eq 'T'>
		|| <a href="vehicles.cfm">List all Vehicles</a> 
	</cfif>
	<cfif getpin2.h1330 eq 'T'>
		|| <a href="s_Vehicles.cfm">Search For Vehicles</a> 
	</cfif>
	<cfif getpin2.h1340 eq 'T'>
		|| <a href="p_Vehicles.cfm">Vehicles Listing</a> 
	</cfif>
</h4>

<cfif getPersonnel.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
    	<cfset noOfPage = round(getPersonnel.recordcount/5)>
    	
		<cfif getPersonnel.recordcount mod 5 LT 3 and getPersonnel.recordcount mod 5 neq 0>
      		<cfset noOfPage = noOfPage + 1>
    	</cfif>
    	
		<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
      		<h3 align="center"><font color="#FF0000">Wrong page number! Please try again.</font></h3>
      		<cfabort>
    	</cfif>
  	</cfif>
  	
	<cfform action="icitem.cfm" method="post">
    	<div align="right">Page 
      	<cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">
      	<cfset noOfPage=round(getPersonnel.recordcount/5)>
      	
		<cfif getPersonnel.recordcount mod 5 LT 3 and getPersonnel.recordcount mod 5 neq 0>
        	<cfset noOfPage = noOfPage + 1>
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
        	|| <a href="icitem.cfm?start=#prevFive#">Previous</a> || 
      	</cfif>
		
      	<cfif page neq noOfPage>
        	 <a href="icitem.cfm?start=#evaluate(nextFive)#">Next</a> || 
      	</cfif>
      	Page #page# Of #noOfPage#
	  	</cfoutput></div><hr>
		
    	<cfif isdefined("url.process")>
			<h1><cfoutput>#form.status#</cfoutput></h1><hr>
		</cfif>
    	
		<cfoutput query="getPersonnel" startrow="#start#" maxrows="5"> 
      		<cfset strNo = "getPersonnel.entryno">
      		
			<table align="center" class="data" width="550px">
        		<tr> 
          			<th width="20%">Vehicles No</th>
          			<td>#getPersonnel.entryno#</td>
        		</tr>
        		<tr> 
          			<th>Engine No</th>
          			<td>#getPersonnel.engineno#</td>
        		</tr>
        		<tr> 
          			<th>Make</th>
          			<td>#getPersonnel.Make#</td>
        		</tr>
        		<tr> 
          			<th>Model</th>
          			<td>#getPersonnel.Model#</td>
        		</tr>
        		<tr> 
          			<th>Customer No</th>
          			<td>#getPersonnel.custcode#<br></td>
        		</tr>
        		<tr> 
          			<th>Customer Name</th>
          			<td>#getPersonnel.custname#<br></td>
        		</tr>
				<cfif getpin2.h1311 eq 'T'>
        			<tr> 
          				<td colspan="2"><div align="right">
							<a href="vehicles2.cfm?type=Delete&entryno=#urlencodedformat(getPersonnel.entryno)#"><img height="18px" width="18px" src="/images/delete.ICO" alt="Delete" border="0">Delete</a> 
							<a href="vehicles2.cfm?type=Edit&entryno=#urlencodedformat(getPersonnel.entryno)#"><img height="18px" width="18px" src="/images/edit.ICO" alt="Edit" border="0">Edit</a></div>
						</td>
        			</tr>
				</cfif>
      		</table>
      		<br><hr>
    	</cfoutput> 
  	</cfform>
  	
	<div align="right">
	<cfoutput>
    	<cfif start neq 1>
     		|| <a href="vehicles.cfm?start=#prevFive#">Previous</a> || 
    	</cfif>
    	
		<cfif page neq noOfPage>
      		<a href="vehicles.cfm?start=#evaluate(nextFive)#">Next</a> || 
    	</cfif>
    	Page #page# Of #noOfPage#
	</cfoutput>
	</div><hr>
<cfelse>
  	<h3>Sorry, No records were found.</h3>
</cfif>

</body>
</html>