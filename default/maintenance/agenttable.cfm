<html>
<head>
	<title>View Agent</title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevFive" default="0">
<cfparam name="nextFive" default="0">

<body>
<cfif lcase(HcomID) eq "tmt_i" or lcase(HcomID) eq "taff_i" or lcase(HcomID) eq "taftc_i">
	<cfquery datasource='#dts#' name="getPersonnel">
		Select i.*,i2.desp as atype from icagent i
		left join icagent_type i2 on i.hp=i2.atype_id
		order by agent
	</cfquery>
<cfelse>
	<cfquery datasource='#dts#' name="getPersonnel">
		Select * from icagent order by agent
	</cfquery>
</cfif>
<!--- ADD ON 15-07-2009 --->
<cfquery name="getGsetup" datasource="#dts#">
  Select lAGENT from GSetup
</cfquery>
<cfoutput>
<h1>View #getGsetup.lAGENT# Informations</h1>
</cfoutput>

<cfoutput>
<h4>
	<cfif getpin2.h1B10 eq 'T'><a href="agenttable2.cfm?type=Create">Creating a New #getGsetup.lAGENT#</a> </cfif>
	<cfif getpin2.h1B20 eq 'T'>|| <a href="agenttable.cfm">List all #getGsetup.lAGENT#</a> </cfif>
	<cfif getpin2.h1B30 eq 'T'>|| <a href="s_agenttable.cfm?type=Icitem">Search For #getGsetup.lAGENT#</a></cfif>
</h4>
</cfoutput>

<cfif getPersonnel.recordcount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage=round(getPersonnel.recordcount/5)>
		<cfif getPersonnel.recordcount mod 5 LT 3 and getPersonnel.recordcount mod 5 neq 0>
			<cfset noOfPage=#noOfPage#+1>
		</cfif>
		<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
			<h3 align="center"><font color="#FF0000">Wrong page number! Please try again.</font></h3>
			<cfabort>
		</cfif>
	</cfif>

	<cfform action="agenttable.cfm" method="post">
	<div align="right">Page <cfinput name="skeypage" type="text" size="2" validate="integer" message="Wrong value in Page field.">

	<cfset noOfPage=round(getPersonnel.recordcount/5)>

	<cfif getPersonnel.recordcount mod 5 LT 3 and getPersonnel.recordcount mod 5 neq 0>
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
		<cfoutput>|| <a href="agenttable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
	</cfif>

	<cfif #page# neq #noOfPage#>
		<cfoutput> <a href="agenttable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
	</cfif>

	<cfoutput>Page #page# Of #noOfPage#</cfoutput>
	</div>

	<hr>

	<cfif isdefined("url.process")>
		<cfoutput><h1>#form.status#</h1><hr></cfoutput>
	</cfif>


	<cfoutput query="getPersonnel" startrow="#start#" maxrows="5">
	<cfset strNo = "getPersonnel.agent">
	<table align="center" class="data" width="450px">
		<!--- <tr><th width="20%">No</th><td>#evaluate(strNo)#</td></tr> --->
		<tr><th width="20%">#getGsetup.lAGENT#</th><td>#getPersonnel.agent#</td></tr>
		<tr><th>Description</th><td>#getPersonnel.desp#<br></td></tr>
		<cfif lcase(HcomID) eq "avt_i" or lcase(HcomID) eq "net_i" or lcase(HcomID) eq "netm_i" or lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i">
		<tr><th>Email</th><td>#getPersonnel.commsion1#</td></tr>
		<tr><th>Contact</th><td>#getPersonnel.hp#</td></tr>
		<cfelseif lcase(HcomID) eq "tmt_i" or lcase(HcomID) eq "taff_i" or lcase(HcomID) eq "taftc_i">
		<tr><th>Commission</th><td>#getPersonnel.commsion1#</td></tr>
		<tr><th>Agent Type</th><td>#getPersonnel.atype#</td></tr>
		<cfelse>
		<tr><th>Commission</th><td>#getPersonnel.commsion1# %</td></tr>
		<tr><th>Contact</th><td>#getPersonnel.hp#</td></tr>
		</cfif>
		<cfif getpin2.h1B11 eq 'T'><tr><td></td><td align="right"><a href="agenttable2.cfm?type=Delete&agent=#evaluate(strNo)#"><img height="18px" width="18px" src="../../images/delete.ICO" alt="Delete" border="0"> Delete</a> <a href="agenttable2.cfm?type=Edit&agent=#evaluate(strNo)#"><img height="18px" width="18px" src="../../images/edit.ICO" alt="Edit" border="0">Edit</a></td></tr></cfif>

	</table>

	<br>
	<hr>

	</cfoutput>
	</cfform>
	<div align="right">

	<cfif #start# neq 1>
		<cfoutput>|| <a href="agenttable.cfm?start=#prevFive#">Previous</a> ||</cfoutput>
	</cfif>

	<cfif #page# neq #noOfPage#>
		<cfoutput> <a href="agenttable.cfm?start=#evaluate(nextFive)#">Next</a> ||</cfoutput>
	</cfif>

	<cfoutput>Page #page# Of #noOfPage#</cfoutput>
	</div>

	<hr>
<cfelse>
	<h3>Sorry, No records were found.</h3>
</cfif>
</body>
</html>
