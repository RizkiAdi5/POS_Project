<html>
<head>
<title>Discount</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">
	function validate()
	{
		if(document.form1.discount.value=='')
		{
			alert("Your Discount cannot be blank.");
			document.form1.discount.focus();
			return false;
		}
		return true;
	}
	
</script>
<body>
			
<cfif url.type eq "Edit">
	<cfquery datasource='#dts#' name="getitem">
		Select * from discount where discount='#url.discount#'
	</cfquery>
	<cfset discount=getitem.discount>
	<cfset desp=getitem.desp>
				
	<cfset mode="Edit">
	<cfset title="Edit Discount">
	<cfset button="Edit">
</cfif>

<cfif url.type eq "Delete">
	<cfquery datasource='#dts#' name="getitem">
		Select * from discount where discount='#url.discount#'
	</cfquery>
	<cfset discount=getitem.discount>
	<cfset desp=getitem.desp>
				
	<cfset mode="Delete">
	<cfset title="Delete Brand">
	<cfset button="Delete">
</cfif>
			
<cfif url.type eq "Create">   
    <cfset discount="1">
	<cfset desp="">
				
	<cfset mode="Create">
	<cfset title="Create Discount">
	<cfset button="Create">
</cfif>

<cfoutput>
	<h1>#title#</h1>
	<h4>
		<cfif getpin2.h1P10 eq 'T'><a href="discounttable2.cfm?type=Create">Creating a New Discount</a> </cfif>
		<cfif getpin2.h1P20 eq 'T'>|| <a href="discounttable.cfm">List all Discount</a> </cfif>
		<cfif getpin2.h1P30 eq 'T'>|| <a href="s_discounttable.cfm?type=discount">Search For Discount</a></cfif>
        <cfif getpin2.h1630 eq 'T'>|| <a href="p_discount.cfm">Discount Listing</a>
        </cfif>
	</h4>
</cfoutput>

<cfform name="form1" action="discountprocess.cfm" method="post" onsubmit="return validate()">
	<cfoutput><input type="hidden" name="mode" value="#mode#"></cfoutput>
  	<h1 align="center">Discount File Maintenance</h1>
  	
  	
  	<table align="center" class="data" width="500">
    <cfoutput> 
		<tr> 
        	<td width="80" nowrap>Discount:</td>
        	<td width="420"> 
			<cfif mode eq "Delete" or mode eq "Edit">
        		<cfinput type="text" size="40" name="discount" id="discount" value="#url.discount#" range="1,100" message="Please key in from 1 to 100 only" readonly>
       		<cfelse>
            	<cfinput type="text" size="40" name="discount" id="discount" value="#discount#" range="1,100" message="Please key in from 1 to 100 only" maxlength="40">
        	</cfif> 
			</td>
      	</tr>
		<tr> 
        	<td>Desp :</td>
        	<td>
				<input type="text" size="40" name="desp" id="desp" value="#desp#" maxlength="100">
			</td>
      	</tr>
        <cfif lcase(HComID) eq "ugateway_i">
			
			
		</cfif>
      	<tr> 
       		<td></td>
        	<td>&nbsp;</td>
      	</tr>
      	<tr> 
        	<td></td>
        	<td align="right"><input name="submit" type="submit" value="  #button#  "></td>
      	</tr>
    </cfoutput> 
  	</table>
</cfform>
			
</body>
</html>
