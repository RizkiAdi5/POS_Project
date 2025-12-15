<html>
<head>
<title>View Users</title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<body>

<!--- Add On 11-01-2010 --->
<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy,transactionSortBy from dealer_menu limit 1
</cfquery>

<cfquery datasource='#dts#' name="getPersonnel">
	Select itemno,desp,despa,unit,category,sizeid,costcode,colorid,wos_group,shelf from icitem 
    <cfif Hitemgroup neq ''>
    where wos_group='#Hitemgroup#'
    </cfif>
    order by <cfif getdealer_menu.productSortBy neq "">#getdealer_menu.productSortBy#<cfelse>itemno</cfif>
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
		<a href="icitem2.cfm?type=Create">Creating a New Item</a> 
	</cfif>
	<cfif getpin2.h1320 eq 'T'>
		|| <a href="icitem.cfm?type=icitem">List all Item</a> 
	</cfif>
	<cfif getpin2.h1330 eq 'T'>
		|| <a href="s_icitem.cfm?type=icitem">Search For Item</a> 
	</cfif>
	<cfif getpin2.h1340 eq 'T'>
		|| <a href="p_icitem.cfm">Item Listing</a> 
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
      		<cfset strNo = "getPersonnel.itemno">
      		
			<table align="center" class="data" width="550px">
        		<tr> 
          			<th width="20%"><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>Item No</cfif></th>
          			<td>#getPersonnel.itemno#</td>
        		</tr>
        		<tr> 
          			<th>Name</th>
          			<td>#getPersonnel.desp#<br> #getPersonnel.despa#</td>
        		</tr>
        		<tr> 
          			<th>Unit</th>
          			<td>#getPersonnel.unit#</td>
        		</tr>
        		<tr> 
          			<th>#getgeneral.lcategory#</th>
          			<td>#getPersonnel.category#</td>
        		</tr>
        		<tr> 
          			<th>#getgeneral.lsize#</th>
          			<td>#getPersonnel.sizeid#<br></td>
        		</tr>
        		<tr> 
          			<th>#getgeneral.lrating#</th>
          			<td>#getPersonnel.costcode#<br></td>
        		</tr>
        		<tr> 
          			<th>#getgeneral.lmaterial#</th>
					<cfif lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
						<cfquery name="getmdesp" datasource="#dts#">
							select desp from iccolorid where colorid='#getPersonnel.colorid#'
						</cfquery>
						<td>#getmdesp.desp#<br></td>
					<cfelse>
          				<td>#getPersonnel.colorid#<br></td>
					</cfif>
        		</tr>
        		<tr> 
        	 	 	<th>#getgeneral.lgroup#</th>
          			<td>#getPersonnel.wos_group#<br></td>
        		</tr>
        		<tr> 
          			<th>#getgeneral.lmodel#</th>
          			<td>#getPersonnel.shelf#<br></td>
        		</tr>
				<cfif getpin2.h1311 eq 'T'>
        			<tr> 
          				<td colspan="2"><div align="right">
							<a href="icitem2.cfm?type=Delete&itemno=#urlencodedformat(getPersonnel.itemno)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0">Delete</a> 
							<a href="icitem2.cfm?type=Edit&Itemno=#urlencodedformat(getPersonnel.itemno)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></div>
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
     		|| <a href="icitem.cfm?start=#prevFive#">Previous</a> || 
    	</cfif>
    	
		<cfif page neq noOfPage>
      		<a href="icitem.cfm?start=#evaluate(nextFive)#">Next</a> || 
    	</cfif>
    	Page #page# Of #noOfPage#
	</cfoutput>
	</div><hr>
<cfelse>
  	<h3>Sorry, No records were found.</h3>
</cfif>

</body>
</html>