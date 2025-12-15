<html>
<head>
	<title>Address Page</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language='JavaScript'>
	function validate()
	{
		if(document.CustomerForm.Code.value=='')
		{
			alert("Your Code cannot be blank.");
			document.CustomerForm.Code.focus();
			return false;
		}
		return true;
	}
</script>
<body>

  <cfoutput>
	<cfif url.type eq "Edit">
	  <cfquery datasource='#dts#' name="getitem">
		Select * from Address where Code='#url.Code#'
	  </cfquery>
	  <cfset Code=getitem.Code>
	  <cfset name=getitem.name>
	  <cfset xCUSTNO=getitem.custno>
	  <cfset add1=getitem.add1>
	  <cfset add2=getitem.add2>
	  <cfset add3=getitem.add3>
	  <cfset add4=getitem.add4>
	  <cfset country=getitem.country>
	  <cfset postalcode=getitem.postalcode>
	  <cfset attn=getitem.attn>
	  <cfset phone=getitem.phone>
	  <cfset fax=getitem.fax>
      <cfset phone2=getitem.phonea>
      <cfset e_mail=getitem.e_mail>

	  <cfset mode="Edit">
	  <cfset title="Edit Item">
	  <cfset button="Edit">
	</cfif>

	<cfif url.type eq "Delete">
	  <cfquery datasource='#dts#' name="getitem">
		Select * from Address where Code='#url.Code#'
	  </cfquery>
	  <cfset Code=getitem.Code>
	  <cfset name=getitem.name>
	  <cfset xCUSTNO=getitem.custno>
	  <cfset add1=getitem.add1>
	  <cfset add2=getitem.add2>
	  <cfset add3=getitem.add3>
	  <cfset add4=getitem.add4>
	  <cfset country=getitem.country>
	  <cfset postalcode=getitem.postalcode>
	  <cfset attn=getitem.attn>
	  <cfset phone=getitem.phone>
	  <cfset fax=getitem.fax>
      <cfset phone2=getitem.phonea>
      <cfset e_mail=getitem.e_mail>

	  <cfset mode="Delete">
	  <cfset title="Delete Item">
	  <cfset button="Delete">
	</cfif>

    <cfif url.type eq "Create">
	  <cfset Code="">
	  <cfset name="">
	  <cfset xCUSTNO="">
	  <cfset add1="">
	  <cfset add2="">
	  <cfset add3="">
	  <cfset add4="">
	  <cfset country="">
	  <cfset postalcode="">
	  <cfset attn="">
	  <cfset phone="">
	  <cfset fax="">
      <cfset phone2="">
      <cfset e_mail="">

	  <cfset mode="Create">
	  <cfset title="Create Item">
	  <cfset button="Create">
	</cfif>
    
        <cfif url.type eq "Create" and isdefined('url.custno')>
        
        <cfquery name="selectcust" datasource="#dts#" >
        SELECT * FROM arcust WHERE custno = "#url.custno#"
        </cfquery>
        
        <cfquery name="selectcode" datasource="#dts#" >
        select * from address where custno='#url.custno#'
		order by Code DESC
        </cfquery>
       
       <cfif selectcode.code neq ""> 
       <cfinvoke component="cfc.refno" method="processNum" oldNum="#selectcode.code#" returnvariable="newnextNum" />
		<cfset nexttranno = newnextNum>
        <cfelse>
        <cfset nexttranno = "" >
        </cfif> 
            
	  <cfset Code="#nexttranno#">
	  <cfset name="#selectcust.name#">
	  <cfset xCUSTNO="#url.custno#">
	  <cfset add1="">
	  <cfset add2="">
	  <cfset add3="">
	  <cfset add4="">
	  <cfset country="">
	  <cfset postalcode="">
	  <cfset attn="">
	  <cfset phone="">
	  <cfset fax="">
      <cfset phone2="">
      <cfset e_mail="">

	  <cfset mode="Create">
	  <cfset title="Create Item">
	  <cfset button="Create">
	</cfif>

	<h1>#title#</h1>

    <h4><cfif getpin2.h1F10 eq 'T'><a href="Addresstable2.cfm?type=Create">Creating a New Address</a> </cfif><cfif getpin2.h1F20 eq 'T'>|| <a href="Addresstable.cfm">List
    all Address</a> </cfif><cfif getpin2.h1F30 eq 'T'>|| <a href="s_Addresstable.cfm?type=Icitem">Search For Address</a></cfif></h4>

  </cfoutput>

<cfform name="CustomerForm" action="Addresstableprocess.cfm" method="post" onsubmit="return validate()">
<cfoutput>
	<input type="hidden" name="mode" value="#mode#">
</cfoutput>
 <cfif url.type eq "Create" and isdefined('url.custno')>
 <input type="hidden" name="frminvoice" value="1" >
 </cfif>
<h1 align="center">Address File Maintenance</h1>
	<!--- Customer --->
	<cfquery name="getcust" datasource="#dts#">
		select custno, name from #target_arcust# where (status<>'B' or status is null) order by custno;
	</cfquery>

    <cfoutput>

    <table align="center" class="data" width="500">
		<tr>
        	<th width="129">Code :</th>
        	<td>
				<cfif mode eq "Delete" or mode eq "Edit">
            		<!--- <h2>#url.Code#</h2> --->
            		<input type="text" size="30" name="Code" value="#url.Code#" readonly>
            	<cfelse>
            		<input type="text" size="30" name="Code" value="#Code#" maxlength="8">
          		</cfif> 
			</td>
      	</tr>
      	<tr>
        	<th>Name :</th>
        	<td><input type="text" size="50" name="name" value="#name#" maxlength="40"></td>
      	</tr>
      	<tr>
        	<th height="24">Customer No :</th>
          	<td>
      			<!--- <input type="text" size="40" name="CUSTNO" value="#CUSTNO#"> --->
      			<select name="custno" id="custno" >
        			<option value="">-</option>
        			<cfloop query="getcust">
          				<option value="#custno#"<cfif custno eq xcustno>selected</cfif>>#custno# - #name#</option>
        			</cfloop>
      			</select>
				</td>
		</tr>

      <!---     </cfoutput> <cfoutput>  --->
      <!--- <tr>
        <td>&nbsp;</td>
        <td><input type="text" size="50" name="name2" value="#name2#" maxlength="40"></td>
      </tr> --->
      	<tr>
        	<th>Address :</th>
        	<td><input name="add1" type="text" value="#add1#" size="50" maxlength="35"></td>
      	</tr>
      <!---     </cfoutput> <cfoutput>  --->
      	<tr>
        	<td>&nbsp;</td>
        	<td><input name="add2" type="text" value="#add2#" size="50" maxlength="35"></td>
      	</tr>
      <!---     </cfoutput> <cfoutput>  --->
      	<tr>
        	<td>&nbsp;</td>
        	<td><input name="add3" type="text" value="#add3#" size="50" maxlength="35"></td>
      	</tr>
      <!---     </cfoutput> <cfoutput>  --->
      	<tr>
        	<td nowrap>&nbsp;</td>
        	<td> <input name="add4" type="text" value="#add4#" size="50" maxlength="35">
        	</td>
      	</tr>
		<tr>
		    <th>Country :</th>
		    <td><input type="text" size="40" name="country" value="#country#" maxlength="50"></td>
		</tr>
		<tr>
		    <th>Postal Code :</th>
		    <td><input type="text" size="40" name="postalcode" value="#postalcode#" maxlength="50"></td>
		</tr>
      	<tr>
        	<th>Attn :</th>
       		<td><input type="text" size="50" name="attn" value="#attn#" maxlength="35"></td>
      	</tr>
      	<tr>
        	<th>Telephone :</th>
        	<td><input type="text" size="40" name="phone" value="#phone#" maxlength="25"></td>
      	</tr>
      	<tr>
        	<th>Fax :</th>
        	<td><input type="text" size="40" name="fax" value="#fax#" maxlength="25"></td>
      	</tr>
        <tr>
        	<th>Phone 2 :</th>
        	<td><input type="text" size="40" name="phone2" value="#phone2#" maxlength="40"></td>
      	</tr>
        <tr>
        	<th>Email :</th>
        	<td><input type="text" size="40" name="e_mail" value="#e_mail#" maxlength="80"></td>
      	</tr>
      <!---     </cfoutput> <cfoutput> </cfoutput> <cfoutput> </cfoutput> <cfoutput> </cfoutput>  --->
      <!---     <cfoutput> </cfoutput> <cfoutput> </cfoutput> <cfoutput>  --->
      	<tr>
        	<td></td>
        	<td align="right"><input name="submit" type="submit" value="  #button#  "></td>
      	</tr>
    </table>
    </cfoutput>
</cfform>
</body>
</html>
