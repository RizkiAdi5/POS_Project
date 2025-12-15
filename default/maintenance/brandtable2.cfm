<html>
<head>
<title>Brand</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">
	function validate()
	{
		if(document.form1.brand.value=='')
		{
			alert("Your Brand cannot be blank.");
			document.form1.brand.focus();
			return false;
		}
		return true;
	}
	
</script>
<body>
			
<cfif url.type eq "Edit">
	<cfquery datasource='#dts#' name="getitem">
		Select * from brand where brand='#url.brand#'
	</cfquery>
	<cfset brand=getitem.brand>
	<cfset desp=getitem.desp>
	<cfif lcase(HComID) eq "ugateway_i">
		<cfset rangeForDisc=val(getitem.rangeForDisc)>
		<cfset dispec=val(getitem.dispec)>
	</cfif>
				
	<cfset mode="Edit">
	<cfset title="Edit Brand">
	<cfset button="Edit">
</cfif>

<cfif url.type eq "Delete">
	<cfquery datasource='#dts#' name="getitem">
		Select * from brand where brand='#url.brand#'
	</cfquery>
	<cfset brand=getitem.brand>
	<cfset desp=getitem.desp>
	<cfif lcase(HComID) eq "ugateway_i">
		<cfset rangeForDisc=val(getitem.rangeForDisc)>
		<cfset dispec=val(getitem.dispec)>
	</cfif>
				
	<cfset mode="Delete">
	<cfset title="Delete Brand">
	<cfset button="Delete">
</cfif>
			
<cfif url.type eq "Create">   
    <cfset brand="">
	<cfset desp="">
	<cfif lcase(HComID) eq "ugateway_i">
		<cfset rangeForDisc=0>
		<cfset dispec=0>
	</cfif>
				
	<cfset mode="Create">
	<cfset title="Create Brand">
	<cfset button="Create">
</cfif>

<cfoutput>
	<h1>#title#</h1>
	<h4>
		<cfif getpin2.h1P10 eq 'T'><a href="brandtable2.cfm?type=Create">Creating a New Brand</a> </cfif>
		<cfif getpin2.h1P20 eq 'T'>|| <a href="brandtable.cfm">List all Brand</a> </cfif>
		<cfif getpin2.h1P30 eq 'T'>|| <a href="s_brandtable.cfm?type=Iccate">Search For Brand</a></cfif>
	</h4>
</cfoutput>

<cfform name="form1" action="brandprocess.cfm" method="post" onsubmit="return validate()">
	<cfoutput><input type="hidden" name="mode" value="#mode#"></cfoutput>
  	<h1 align="center">Brand File Maintenance</h1>
  	
  	<table align="center" class="data" width="500">
    <cfoutput> 
		<tr> 
        	<td width="80" nowrap>Brand :</td>
        	<td width="420"> 
			<cfif mode eq "Delete" or mode eq "Edit">
        		<input type="text" size="40" name="brand" id="brand" value="#url.brand#" readonly>
       		<cfelse>
            	<input type="text" size="40" name="brand" id="brand" value="#brand#" maxlength="40">
        	</cfif> 
			</td>
      	</tr>
		<tr> 
        	<td>Description :</td>
        	<td>
				<input type="text" size="40" name="desp" id="desp" value="#desp#" maxlength="100">
			</td>
      	</tr>
		<cfif lcase(HComID) eq "ugateway_i">
			<tr> 
	        	<td>Amount :</td>
	        	<td>
					<input type="text" size="15" name="rangeForDisc" id="rangeForDisc" value="#rangeForDisc#" onBlur="if(this.value==''){this.value = '0'}">
				</td>
	      	</tr>
			<tr> 
	        	<td>Discount (%):</td>
	        	<td>
					<input type="text" size="15" name="dispec" id="dispec" value="#dispec#" onBlur="if(this.value==''){this.value = '0'}">
				</td>
	      	</tr>
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
