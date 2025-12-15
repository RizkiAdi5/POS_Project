<html>
<head>
<title>Color - Size Page</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript">
	function validate()
	{
		if(document.form.colorid2.value=='')
		{
			alert("Your ColorID cannot be blank.");
			document.form.colorid2.focus();
			return false;
		}
		if(document.form.colorno.value=='')
		{
			alert("Your Color No. cannot be blank.");
			document.form.colorno.focus();
			return false;
		}
		return true;
	}
	
</script>

<!--- <cfoutput>
<cfif isdefined("form.submit")>
	<cfif form.submit eq "Create" or form.submit eq "Edit" or form.submit eq "Delete">
		<form name="done" action="colorsizetableprocess.cfm" method="post" onSubmit="return validate()">
	</cfif>
		<input type="hidden" name="mode" value="#listfirst(mode)#">
		<input type="hidden" name="type" value="#listfirst(type)#">
		<input type="hidden" size="8" name="colorid2" value="#listfirst(colorid2)#" maxlength="8">
		<input type="hidden" size="8" name="colorno" value="#listfirst(colorno)#" maxlength="8">
		<input type="hidden" size="40" name="desp" value="#listfirst(desp)#" maxlength="40">
	</form>
	<script language="javascript" type="text/javascript">
		done.submit();
	</script>
</cfif>
</cfoutput> --->

<cfif type neq "Create" and type neq "Create1">
	<cfif type eq "Edit1">
		<cfset colorno = listfirst(colorno)>
		<cfset colorid2 = listfirst(colorid2)>
		<cfset desp = listfirst(desp)>	
	<cfelseif type eq "Edit" or type eq "Delete">
		<cfquery datasource='#dts#' name="getitem">
			Select * from iccolor2 
			where colorid2='#colorid2#'
			and colorno = '#colorno#'
		</cfquery>
		<cfset colorno = listfirst(getitem.colorno)>
		<cfset colorid2 = listfirst(getitem.colorid2)>
		<cfset desp=getitem.desp>		
	</cfif>

	<cfif type eq "Edit" or type eq "Edit1">
		<cfset mode="Edit">
		<cfset title="Edit Color - Size">
		<cfset button="Edit">
	<cfelse>
		<cfset mode="Delete">
		<cfset title="Delete Color - Size">
		<cfset button="Delete">
	</cfif>
<cfelse>	
	<cfif type eq "Create1" or type eq "Edit1" or type eq "Edit">
		<cfset colorno = listfirst(colorno)>
		<cfset colorid2 = listfirst(colorid2)>
		<cfset desp = listfirst(desp)>	
	<cfelse>
		<cfset colorno = "">
		<cfset colorid2 = "">
		<cfset desp = "">		
	</cfif>
	
	<cfset mode="Create">
	<cfset title="Create Color - Size">
	<cfset button="Create">
</cfif>

<body>
<cfoutput>
<h1>#title#</h1>

<h4>
	<cfif getpin2.h1L10 eq 'T'><a href="colorsizetable2.cfm?type=Create">Creating a New Color - Size</a> </cfif>
	<cfif getpin2.h1L20 eq 'T'>|| <a href="colorsizetable.cfm">List all Color - Size</a> </cfif>
	<cfif getpin2.h1L30 eq 'T'>|| <a href="s_colorsizetable.cfm?type=Icitem">Search For Color - Size</a> </cfif>
</h4>

<form name="form" action="colorsizetableprocess.cfm" method="post" onSubmit="return validate()">
	<input type="hidden" name="mode" value="#mode#">
	<cfif type eq "Create" or type eq "Create1">
		<input type="hidden" name="type" value="Create1">
	<cfelseif type eq "Edit" or type eq "Edit1">
		<input type="hidden" name="type" value="Edit1">
	<cfelse>
		<input type="hidden" name="type" value="#type#">
	</cfif>
	<h1 align="center">Color - Size File Maintenance</h1>
  	
	<table align="center" class="data" width="600">
      	<tr>
			<td width="15%" nowrap>Color No:</td>
			<td colspan="4">
			<cfif mode eq "Delete" or mode eq "Edit">
            	<input type="text" size="8" name="colorno" value="#colorno#" maxlength="8" readonly>
            <cfelse>
            	<input type="text" size="8" name="colorno" value="#colorno#" maxlength="8">
          	</cfif>
			</td>
		</tr>
		<tr> 
        	<td>Color ID:</td>
        	<td colspan="4">
			<cfif mode eq "Delete" or mode eq "Edit">
            	<input type="text" size="8" name="colorid2" value="#colorid2#" maxlength="8" readonly>
            <cfelse>
            	<input type="text" size="8" name="colorid2" value="#colorid2#" maxlength="8">
          	</cfif>
			</td>
      	</tr>
      	<tr> 
        	<td>Description:</td>
        	<td colspan="4"><input type="text" size="40" name="desp" value="#desp#" maxlength="40"></td>
      	</tr>
		<tr> 
			<td colspan="4"><hr></td>
		</tr>
		<cfset totcol = 4>
		<cfset totalrecord = 20>
		<cfset totrow = ceiling(totalrecord / totcol)>
		<cfloop from="1" to="#totrow#" index="i">
			<tr>
				<cfloop from="0" to="#totcol-1#" index="j">
					<cfset thisrecord = i+(j*totrow)>
					<cfif thisrecord LTE totalrecord>
						<cfoutput>
							<td width="25%">
								Size #thisrecord#.&nbsp;
								<cfif type neq "Create" and type neq "Create1">
									<input type="text" value="#Evaluate("getitem.size#thisrecord#")#" size="10" id="size#thisrecord#" name="size#thisrecord#">
								<cfelse>
									<input type="text" value="" size="10" id="size#thisrecord#" name="size#thisrecord#">
								</cfif>
								
							</td>
						</cfoutput>
					</cfif>
				</cfloop>
			</tr>
		</cfloop>
		<tr align="center"> 
			<td colspan="5" align="center">
			<input name="submit" type="submit" value="#button#">
			</td>
		</tr>
	</table>
</form>
</cfoutput>

</body>
</html>