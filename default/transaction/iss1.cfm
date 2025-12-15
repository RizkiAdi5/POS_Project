<cfquery name="gettranname" datasource="#dts#">
select lconsignin,lconsignout,lISS,lOAI,lOAR from gsetup
</cfquery> 

<cfif tran eq "ISS">
	<cfset tran = "ISS">
	<cfset tranname = gettranname.lISS>
	<cfset trancode = "issno">
</cfif>

<html>
<head>
<title><cfoutput>#tranname#</cfoutput></title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<cfoutput>#tran#-#mode#-#ttype#</cfoutput>

<cfquery datasource="#dts#" name="getGeneralInfo">
	Select #trancode# from GSetup
</cfquery>

<cfif ttype eq "Create">
	<cfset custno="">
	<cfset name="">
	<cfset mode = "Create">
	
	<cfif tran eq "iss">
		<cfset nexttranno= getGeneralInfo.issno + 1>
	</cfif>
	
	<cfset nDateCreate="">
</cfif>

<cfif url.ttype eq "Edit">
	<cfquery datasource='#dts#' name="getitem">
		select * from artran where refno='#url.refno#' and type = '#tran#'
	</cfquery>
	
	<cfset custno=getitem.custno>
	<cfset name=getitem.name>
	<cfset mode = "Edit">
	<cfset nexttranno= url.refno>
	<cfset nDateCreate=getitem.wos_date>
</cfif>

<cfif url.ttype eq "Delete">
	<cfquery datasource='#dts#' name="getitem">
		select * from artran where refno='#url.refno#' and type = '#tran#'
	</cfquery>
	
	<cfset custno=getitem.custno>
	<cfset nDateCreate=getitem.wos_date>
	<cfset mode = "Delete">
	<cfset nexttranno= url.refno>
</cfif>	

<body>
<cfoutput>
<h4>
	<a href="iss2.cfm?ttype=create&tran=#tran#">Create New #tranname#</a> || 
	<a href="iss.cfm?tran=#tran#">List all #tranname#</a> || 
	<a href="siss.cfm?tran=#tran#">Search For #tranname#</a>
</h4>
</cfoutput>

<cfform name="invoicesheet" action="iss2.cfm" method="post" onsubmit="return test()">
	<cfoutput>
	<input type="hidden" name="type" value="#mode#">
	<input type="hidden" name="tran" value="#tran#">
	<cfif url.ttype eq "Delete" or url.ttype eq "Edit">
		<input type="hidden" name="currefno" value="#url.refno#">
	</cfif>
	</cfoutput>
<table align="center" class="data">
	<cfoutput> 
    <tr>
		<th width="126">
			<cfif url.ttype eq "Create">
            	Next 
          	</cfif>
          	<cfoutput>#tranname#</cfoutput> No </th>
        <td width="234"><h3>#nexttranno#</h3></td>
        <th width="115">Type </th>
        <td width="177"><h2>
		<cfif url.ttype eq "Create">
			New
		</cfif>
		
		<cfif url.ttype eq "Delete">
			Delete
		</cfif>
		
		<cfif url.ttype eq "Edit">
			Edit
		</cfif>
		#tranname# </h2></td>
    </tr>
    </cfoutput> 
    <tr> 
      	<th><cfoutput>#tranname# </cfoutput>Date</th>
      	<td><cfif url.ttype eq "Create">
          <cfinput type="text" name="invoicedate" size="10" value="#dateformat(now(),"dd/mm/yyyy")#" validate="eurodate" maxlength="10">
          (DD/MM/YYYY) </cfif> <cfif url.ttype eq "Delete" or url.ttype eq "Edit">
          <cfinput type="text" name="invoicedate" size="10" value="#dateformat(nDateCreate,"dd/mm/yyyy")#" validate="eurodate" maxlength="10">
          (DD/MM/YYYY) </cfif> </td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
    </tr>
	<tr> 
      	<th>Authorised By</th>
		<td><cfoutput><input name="custno" type="text" value="#custno#" maxlength="8"></cfoutput></td>
      	<td></td>
		<td></td>
	</tr>
    <tr> 
      	<th>Reason for Issue</th>
      	<td><cfoutput><input name="name" type="text" size="50" maxlength="40" value="#name#"></cfoutput></td>
      	<td></td>
      	<td></td>
	</tr>
    <tr> 
      	<td height="23"></td>
      	<td></td>
      	<td></td>
      	<td align="right"><cfoutput><input name="submit" type="submit" value="#mode#"></cfoutput></td>
    </tr>
</table>
</cfform>

<script language="JavaScript">
	function test()
	{
		if(document.invoicesheet.custno.value=='')
		{
			alert("Your Customer's No. cannot be blank.");
			document.invoicesheet.custno.focus();
			return false;
		}
		return true;
	}
</script> 

</body>
</html>