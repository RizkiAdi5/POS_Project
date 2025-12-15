<html>
<head>
<title>Term Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
	function validate()
	{
		if(document.CustomerForm.Term.value=='') 
		{
			alert("Your Term's No. cannot be blank.");
			document.CustomerForm.Term.focus();
			return false;
		}
		return true;
	}
</script>
</head>

<body>

<cfif type eq "Edit">
	<cfquery name="getitem" datasource="#dts#">
		select * from #target_icterm# where term = '#url.term#'
	</cfquery>
	
	<cfset xterm = getitem.term>
	<cfset desp = getitem.desp>
	<cfset sign = getitem.sign>
	<cfset days = getitem.days>
	<cfset mode = "Edit">
	<cfset title = "Edit Item">
	<cfset button = "Edit">
</cfif>

<cfif type eq "Delete">
	<cfquery datasource='#dts#' name="getitem">
		select * from #target_icterm# where term = '#url.term#'
	</cfquery>
	
	<cfset xterm = getitem.term>
	<cfset desp = getitem.desp>
	<cfset sign = getitem.sign>
	<cfset days = getitem.days>
	<cfset mode = "Delete">
	<cfset title = "Delete Item">
	<cfset button = "Delete">
</cfif>

<cfif type eq "Create">
	<cfset xterm = "">
	<cfset desp = "">
	<cfset sign = "P">
	<cfset days = "0">
	<cfset mode = "Create">
	<cfset title = "Create Item">
	<cfset button = "Create">
</cfif>

<h1><cfoutput>#title#</cfoutput></h1>
<h4>
	<cfif getpin2.h1I10 eq "T">
		<a href="Termtable2.cfm?type=Create">Creating a Term</a> || 
	</cfif>
	<cfif getpin2.h1I20 eq 'T'>
	  	<a href="Termtable.cfm?">List all Term</a> || 
	</cfif>
	<cfif getpin2.h1I30 eq 'T'>
	  	<a href="s_Termtable.cfm?type=icterm">Search For Term</a>
	</cfif>
</h4>

<cfform name="CustomerForm" action="Termtableprocess.cfm" method="post" onsubmit="return validate()">
	<cfoutput>
	<input type="hidden" name="mode" value="#mode#">
	
	<h1 align="center">Term File Maintenance</h1>
	
	<table align="center" class="data" width="500">
		<tr> 
        	<td width="20%">Term :</td>
        	<td>
				<input type="hidden" name="target_icterm" value="#target_icterm#">
				<cfif mode eq "Delete" or mode eq "Edit">
					<input type="text" size="12" name="Term" value="#xterm#" readonly>
				<cfelse>
					<input type="text" size="12" name="Term" value="#xterm#" maxlength="12">
				</cfif>
			</td>
      	</tr>
      	<tr> 
       		<td>Description:</td>
        	<td><cfif lcase(hcomid) eq "topsteel_i" or lcase(hcomid) eq "topsteelhol_i">
					<input type="text" size="60" name="desp" value="#desp#" maxlength="80">
				<cfelse>
					<input type="text" size="40" name="desp" value="#desp#" maxlength="40">
				</cfif>
			</td>
      	</tr>
		<tr> 
      		<td colspan="2"><hr></td>
    	</tr>
    	<tr> 
      		<th colspan="2"><div align="center"><strong>Setting</strong></div></th>
    	</tr>
		<tr> 
        	<td height="22">Sign</td>
        	<td width="640">
				<input type="radio" name="Sign" id="sign" value="P" <cfif sign eq "P">checked</cfif>> + (Plus)<br/>
				<input type="radio" name="Sign" id="sign" value="" <cfif sign eq "">checked</cfif>>
			</td>
		</tr>
      	<tr> 
        	<td nowrap>Day/s</td>
        	<td><cfinput name="Days" type="text" value="#days#" size="5" maxlength="2" validate="integer" required="yes" message="Please enter number for Day !"></td>
      	</tr>
		<tr> 
      		<td height="23"></td>
      		<td align="right"><input name="submit" type="submit" value="  #button#  "></td>
    	</tr>
	</table>
  	</cfoutput>
</cfform>

</body>
</html>