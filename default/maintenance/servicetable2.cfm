<html>
<head>
<title>Service Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>
<cfquery name='getgsetup2' datasource='#dts#'>
  	select concat('.',repeat('_',Decl_Uprice)) as Decl_Uprice,Decl_Uprice as Decl_Uprice1, concat('.',repeat('_',DECL_DISCOUNT)) as DECL_DISCOUNT1, DECL_DISCOUNT from gsetup2
</cfquery>

<cfset stDecl_UPrice=getgsetup2.Decl_Uprice>
<cfset stDecl_Disc=getgsetup2.DECL_DISCOUNT1>
<script language="JavaScript"><!--- Ignored --->
	function validate()
	{
		if(document.CustomerForm.servi.value=='')
		{
			alert("Your Service's No. cannot be blank.");
			document.CustomerForm.servi.focus();
			return false;
		}
		return true;
	}
</script>

<body>

<cfif url.type eq "Edit">
	<cfquery datasource='#dts#' name="getitem">
		Select * from icservi where servi='#url.servi#'
	</cfquery>
		
	<cfset servi = getitem.servi>
	<cfset desp = getitem.desp>
	<cfset despa = getitem.despa>
	<cfset SALEC = getitem.SALEC>
	<cfset SALECSC = getitem.SALECSC>
	<cfset SALECNC = getitem.SALECNC>
	<cfset PURC = getitem.PURC>
	<cfset PURPRC = getitem.PURPRC>
    <cfset SERCOST = getitem.SERCOST>
    <cfset serprice = getitem.serprice>
	<cfset mode = "Edit">
	<cfset title = "Edit Item">
	<cfset button = "Edit">
</cfif>
	
<cfif url.type eq "Delete">
	<cfquery datasource='#dts#' name="getitem">
		Select * from icservi where servi='#url.servi#'
	</cfquery>
				
	<cfset servi = getitem.servi>
	<cfset desp = getitem.desp>
	<cfset despa = getitem.despa>
	<cfset SALEC = getitem.SALEC>
	<cfset SALECSC = getitem.SALECSC>
	<cfset SALECNC = getitem.SALECNC>
	<cfset PURC = getitem.PURC>
	<cfset PURPRC = getitem.PURPRC>
     <cfset SERCOST = getitem.SERCOST>
     <cfset serprice = getitem.serprice>
	<cfset mode = "Delete">
	<cfset title = "Delete Item">
	<cfset button = "Delete">
</cfif>
	
<cfif url.type eq "Create">
   	<cfset servi = "">
	<cfset desp = "">
	<cfset despa = "">
	<cfset SALEC = "">
	<cfset SALECSC = "">
	<cfset SALECNC = "">
	<cfset PURC = "">
	<cfset PURPRC = "">
     <cfset SERCOST = "0.00">
      <cfset serprice = "0.00">
	<cfset mode = "Create">
	<cfset title = "Create Item">
	<cfset button = "Create">
</cfif>

<cfoutput>
	<h1>#title#</h1>
	
	<h4>
		<cfif getpin2.h1G10 eq 'T'>
			<a href="servicetable2.cfm?type=Create">Creating a Service</a> 
		</cfif>
		<cfif getpin2.h1G20 eq 'T'>
			|| <a href="servicetable.cfm?">List All Service</a> 
		</cfif>
		<cfif getpin2.h1G30 eq 'T'>
			|| <a href="s_servicetable.cfm?type=icservi">Search For Service</a>
		</cfif>
	</h4>
	
	<cfform name="CustomerForm" action="servicetableprocess.cfm" method="post">
		<input type="hidden" name="mode" value="#mode#">
		
		<h1 align="center">Service File Maintenance</h1>
 		<table align="center" class="data" width="500">
    		<tr> 
        		<td width="20%">Service :</td>
        		<td colspan="4">
				<cfif mode eq "Delete" or mode eq "Edit">
            		<input type="text" size="10" name="servi" value="#url.servi#" readonly>
            	<cfelse>
					<cfif lcase(HcomID) eq "net_i" or lcase(HcomID) eq "netm_i" or lcase(HcomID) eq "dnet_i">
						<cfset maxchar="24">
					<cfelse>
						<cfset maxchar="8">
					</cfif>
            		<input type="text" size="10" name="servi" value="#servi#" maxlength="#maxchar#">
          		</cfif>
				</td>
      		</tr>
      		<tr> 
        		<td>Description:</td>
        		<td colspan="4"><input type="text" size="40" name="desp" value="#desp#" maxlength="100"></td>
      		</tr>
      		<tr> 
        		<td></td>
        		<td colspan="4"><input type="text" size="40" name="despa" value="#despa#" maxlength="100"></td>
      		</tr>
    		<tr> 
      			<td colspan="5"><hr></td>
    		</tr>
    		<tr> 
     	 		<th colspan="5"><div align="center"><strong>Product Details</strong></div></th>
    		</tr>
      		<tr> 
        		<td height="22">Credit Sales</td>
        		<td width="152"><input name="SALEC" type="text" id="SALEC" value="#SALEC#" size="8" maxlength="8"></td>
        		<td width="53" colspan="-1">&nbsp;</td>
        		<td width="118" colspan="-1">Purchase</td>
        		<td width="317" nowrap><input name="PURC" type="text" id="PURC" value="#PURC#" size="8" maxlength="8"></td>
      		</tr>
      		<tr> 
        		<td nowrap>Cash Sales</td>
        		<td><input name="SALECSC" type="text" id="SALECSC" value="#SALECSC#" size="8" maxlength="8"></td>
        		<td colspan="-1">&nbsp;</td>
        		<td colspan="-1">Purchase Return</td>
        		<td><input name="PURPRC" type="text" id="PURPRC" value="#PURPRC#" size="8" maxlength="8"></td>
      		</tr>
	  		<tr>
        		<td nowrap>Sales Return</td>
        		<td><input name="SALECNC" type="text" id="SALECNC" value="#SALECNC#" size="8" maxlength="8"></td>
        		<td colspan="-1">&nbsp;</td>
        		<td colspan="-1">&nbsp;</td>
        		<td>&nbsp;</td>
      		</tr>
            <tr> 
     	 		<th colspan="5"><div align="center"><strong>Service Cost</strong></div></th>
    		</tr>
            <tr>
            <td>Service Cost</td>
            <td><cfinput type="text" name="sercost" id="sercost" value="#numberformat(val(SERCOST),stDecl_UPrice)#" validate="float" validateat="onsubmit" /></td>
            </tr>
             <tr>
            <td>Service Price</td>
            <td><cfinput type="text" name="serprice" id="serprice" value="#numberformat(val(serprice),stDecl_UPrice)#" validate="float" validateat="onsubmit" /></td>
            </tr>
    		<tr> 
      			<td height="23"></td>
      			<td colspan="4" align="right"><input name="submit" type="submit" value="  #button#  "></td>
    		</tr>
  		</table>
	</cfform>
</cfoutput>

</body>
</html>