<html>
<head>
	<title>Attention Page</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">

	function validate()
	{
		if(document.AttentionForm.AttentionNo.value=='')
		{
			alert("Your Attention's No. cannot be blank.");
			document.AttentionForm.AttentionNo.focus();
			return false;
		}
		else if(document.AttentionForm.add1.value=='')
		{
			alert("Your Attention's Address cannot be blank.");
			document.AttentionForm.add1.focus();
			return false;			
		}
		
		return true;
	}
	
</script>
<body>	
<!--- ADD ON 15-07-2009 --->

<cfif url.type eq "Edit">
	<cfquery datasource='#dts#' name="getPersonnel">
		Select * from Attention where AttentionNo='#url.AttentionNo#'
	</cfquery>
				
	<cfif getPersonnel.recordcount gt 0>
		<cfset AttentionNo=getPersonnel.AttentionNo>
		<cfset name=getPersonnel.name>
		<cfset xcustomerno=getPersonnel.customerno>						
		<cfset add1=getPersonnel.add1>
		<cfset add2=getPersonnel.add2>
		<cfset add3=getPersonnel.add3>
		<cfset phone=getPersonnel.phone>						
		<cfset phonea=getPersonnel.phonea>						
		<cfset fax=getPersonnel.fax>	
        <cfif lcase(hcomid) eq "ovas_i">
			<cfset phone=getPersonnel.phone>
			<cfset phonea=getPersonnel.phonea>
		</cfif>							
						
		<cfset mode="Edit">
			<cfset title="Edit Attention">
			<cfset button="Edit">
		<cfelse>
			<cfset status="Sorry, the Attention, #url.AttentionNo# was ALREADY removed from the system. Process unsuccessful.">
			<form name="done" action="vattention.cfm?process=done" method="post">
				<input name="status" value="#status#" type="hidden">
			</form>
			<script>
				done.submit();
			</script>
		</cfif>
	<cfelseif url.type eq "Create">
		<cfset AttentionNo="">
		<cfset name="">
		<cfset xcustomerno="">						
		<cfset add1="">
		<cfset add2="">
		<cfset add3="">
		<cfset phone="">						
		<cfset phonea="">						
		<cfset fax="">	
        <cfif lcase(hcomid) eq "ovas_i">
			<cfset phone="">	
			<cfset phonea="">	
		</cfif>
			
		<cfset mode="Create">
		<cfset title="Create Attention">
		<cfset button="Create">
	<cfelseif url.type eq "Delete">
		<cfquery datasource='#dts#' name="getPersonnel">
			Select * from Attention where AttentionNo='#url.AttentionNo#'
		</cfquery>
				
		<cfif getPersonnel.recordcount gt 0>
			<cfset AttentionNo=getPersonnel.AttentionNo>
			<cfset name=getPersonnel.name>
			<cfset xcustomerno=getPersonnel.customerno>						
			<cfset add1=getPersonnel.add1>
			<cfset add2=getPersonnel.add2>
			<cfset add3=getPersonnel.add3>
			<cfset phone=getPersonnel.phone>						
			<cfset phonea=getPersonnel.phonea>						
			<cfset fax=getPersonnel.fax>	
			<cfif lcase(hcomid) eq "ovas_i">
                <cfset phone=getPersonnel.phone>
                <cfset phonea=getPersonnel.phonea>
            </cfif>
						
			<cfset mode="Delete">
			<cfset title="Delete Attention">
			<cfset button="Delete">
	<cfelse>
		<cfset status="Sorry, the Attention, #url.AttentionNo# was ALREADY removed from the system. Process unsuccessful. Please refresh your webpage.">
		<form name="done" action="vAttention.cfm?process=done" method="post">
			<input name="status" value="#status#" type="hidden">
		</form>
		<script>
			done.submit();
		</script>
	</cfif>			
</cfif>
<cfoutput>
	<cfif husergrpid eq "Muser"><a href="../home2.cfm"><u>Home</u></a></cfif>
	<h1>#title#</h1>
			
  	<h4>
		<a href="attention.cfm?type=Create"> Creating a Attention</a> 
		|| <a href="vattention.cfm">List all Attention</a> 
		|| <a href="sattention.cfm">Search Attention</a> 
		|| <a href="pattention.cfm" target="_blank">Attention Listing</a>
	</h4>

<form name="AttentionForm" action="attentionProcess.cfm" method="post" onsubmit="return validate()">
	<input type="hidden" name="mode" value="#mode#">
	
		<cfquery name="getcust" datasource="#dts#">
			select custno,name from #target_arcust# where status<>'B' order by custno
		</cfquery>

	<!--- <cfquery name="getcust" datasource="#dts#">
		select custno,name from #target_arcust# where status<>'B' order by custno
	</cfquery> --->
					
  	<table align="center" class="data" width="550px">
	    <tr> 
	      	<td>Attention No :</td>
	      	<td> 
		      	<cfif mode eq "Delete" or mode eq "Edit">
	          		<h2>#url.AttentionNo#</h2>
	          		<input type="hidden" name="AttentionNo" value="#AttentionNo#">  
	          	<cfelse>
	          		<input type="text" size="40" name="AttentionNo" value="" maxlength="8">
	        	</cfif> 
			</td>
	    </tr>
		<tr> 
	      	<td>Name :</td>
	      	<td><input type="text" size="40" name="Name"  value="#name#" maxlength="40"></td>
	    </tr>
		
    	<tr> 
      		<td>Customer No :</td>
      		<td>
				<select name="customerno">
	  				<option value="">Choose a Customer</option>
					<cfloop query="getcust">
	  					<option value="#custno#"<cfif xcustomerno eq custno>selected</cfif>>#custno# - #name#</option>
					</cfloop>
	  			</select>
			</td>
    	</tr>
    	<tr> 
	      	<td>Address :</td>
	      	<td><input type="text" size="40" name="Add1" value="#Add1#" maxlength="40"></td>
   	 	</tr>
	    <tr> 
	      	<td></td>
	      	<td><input type="text" size="40" name="Add2"  value="#Add2#" maxlength="40"></td>
	    </tr>
	 	<tr> 
      		<td></td>
      		<td><input type="text" size="40" name="Add3"  value="#Add3#" maxlength="40"></td>
    	</tr>
	 	<tr> 
      		<td>Tel :</td>
      		<td><input type="text" size="40" name="phone"  value="#phone#" maxlength="30"></td>
    	</tr>
    	<tr> 
      		<td>Tel2 :</td>
      		<td><input type="text" size="40" name="phonea"  value="#phonea#" maxlength="20"></td>
    	</tr>	
	 	<tr> 
      		<td>Fax :</td>
      		<td><input type="text" size="40" name="fax"  value="#fax#" maxlength="20"></td>
    	</tr>
  		<tr> 
			<td></td>
			<td align="right"><input type="submit" value="  #button#  "></td>
 		</tr>
    </cfoutput> 
  	</table>
</form>			
</body>
</html>
