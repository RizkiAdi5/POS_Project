<html>
<head>
<title>Edit Opening Qty</title>

<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>

<script language='JavaScript'>
function dataupdate(itemno,fieldvalue){
	var x = document.getElementById('qtybf_' + itemno);
	if(isNaN(fieldvalue)){
		alert("The value is not a number. Please try again");
		x.value = "";
	}else{
		if(fieldvalue == ''){
			fieldvalue = 0;
		}
		if (confirm("Are you sure you want to Edit?")) {
			
			x.style.backgroundColor  = 'red';
 			DWREngine._execute(_maintenanceflocation, null, 'updateqtybf', itemno, fieldvalue, show_reply);
		}
	}	
}

function show_reply(itemObject){
	var x = document.getElementById('qtybf_' + itemObject.ITEMNO);
 	x.style.backgroundColor  = '';
}
</script>
</head>

<body>
<h1>Edit Opening Qty</h1>
<h2 align="right"><a href="s_matrixitemtable.cfm"><u>Exit</u></a></h2>		
<cfoutput>
  <h4>
	<cfif getpin2.h1M10 eq 'T'><a href="matrixitemtable2.cfm?type=Create">Creating a New Matrix Item</a> </cfif>
	<cfif getpin2.h1M20 eq 'T'>|| <a href="matrixitemtable.cfm">List all Matrix Item</a> </cfif>
	<cfif getpin2.h1M30 eq 'T'>|| <a href="s_matrixitemtable.cfm?type=Icitem">Search For Matrix Item</a> </cfif>
  </h4>
</cfoutput>

<cfif isdefined("url.process")>
	<cfoutput><h1>#form.status#</h1><hr></cfoutput>
</cfif>

<cfquery datasource='#dts#' name="geticmitem">
	Select * from icmitem
	where mitemno = '#form.mitemno#'
</cfquery>
<cfset colorlist = "">
<cfset sizelist = "">
<cfif form.sizecolor eq "SC">
	<cfloop from="1" to="20" index="i">
		<cfif Evaluate("geticmitem.color#i#") neq "">
			<cfif colorlist eq "">
				<cfset colorlist = Evaluate("geticmitem.color#i#")>
			<cfelse>
				<cfset colorlist = colorlist&','&Evaluate("geticmitem.color#i#")>
			</cfif>
		</cfif>
		<cfif Evaluate("geticmitem.size#i#") neq "">
			<cfif sizelist eq "">
				<cfset sizelist = Evaluate("geticmitem.size#i#")>
			<cfelse>
				<cfset sizelist = sizelist&','&Evaluate("geticmitem.size#i#")>
			</cfif>
		</cfif>
	</cfloop>
<cfelseif form.sizecolor eq "S">
	<cfloop from="1" to="20" index="i">
		<cfif Evaluate("geticmitem.size#i#") neq "">
			<cfif sizelist eq "">
				<cfset sizelist = Evaluate("geticmitem.size#i#")>
			<cfelse>
				<cfset sizelist = sizelist&','&Evaluate("geticmitem.size#i#")>
			</cfif>
		</cfif>
	</cfloop>
<cfelse>
	<cfloop from="1" to="20" index="i">
		<cfif Evaluate("geticmitem.color#i#") neq "">
			<cfif colorlist eq "">
				<cfset colorlist = Evaluate("geticmitem.color#i#")>
			<cfelse>
				<cfset colorlist = colorlist&','&Evaluate("geticmitem.color#i#")>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<form name="form" method="post">

<cfif colorlist neq "" and sizelist neq "">
	<cfoutput>
	<input type="hidden" name="mitemno" value="#form.mitemno#">
	<table align="center" class="data">
		<tr>
			<td width="30">&nbsp;</td>
			<cfloop from="1" to="20" index="i">
				<cfif geticmitem["size#i#"][1] neq "">
					<td width="30" align="center">#geticmitem["size#i#"][1]#</td>
				</cfif>
			</cfloop>
		</tr>
		<cfloop from="1" to="20" index="j">
			<cfset thiscolor = geticmitem["color#j#"][1]>
			<cfif thiscolor neq "">
				<tr>
					<td>#thiscolor#</td>
					<cfloop from="1" to="20" index="i">
						<cfset thissize = geticmitem["size#i#"][1]>
						<cfif thissize neq "">
							<cfif form.inserthyphen eq 1>
								<cfset thisitemno = form.mitemno&'-'&thiscolor&'-'&thissize>
							<cfelse>
								<cfset thisitemno = form.mitemno&thiscolor&thissize>
							</cfif>
							<cfquery name="getqtybf" datasource="#dts#">
								select qtybf from icitem
								where itemno = '#thisitemno#'
							</cfquery>
							<td><input type="text" value="#val(getqtybf.qtybf)#" size="5" name="qtybf_#thisitemno#" id="qtybf_#thisitemno#" onBlur="if(this.value==''){this.value = '0'}" onchange="dataupdate('#thisitemno#',this.value);"></td>
						</cfif>
					</cfloop>
				</tr>
			</cfif>
		</cfloop>
	</table>
	</cfoutput>
<cfelseif sizelist neq "">
	<cfoutput>
	<input type="hidden" name="mitemno" value="#form.mitemno#">
	<table align="center" class="data">
		<tr>
			<cfloop from="1" to="20" index="i">
				<cfif geticmitem["size#i#"][1] neq "">
					<td width="30" align="center">#geticmitem["size#i#"][1]#</td>
				</cfif>
			</cfloop>
		</tr>
		<tr>
			<cfloop from="1" to="20" index="i">
				<cfset thissize = geticmitem["size#i#"][1]>
				<cfif thissize neq "">
					<cfif form.inserthyphen eq 1>
						<cfset thisitemno = form.mitemno&'-'&thissize>
					<cfelse>
						<cfset thisitemno = form.mitemno&thissize>
					</cfif>
					<cfquery name="getqtybf" datasource="#dts#">
						select qtybf from icitem
						where itemno = '#thisitemno#'
					</cfquery>
					<td><input type="text" value="#val(getqtybf.qtybf)#" size="5" name="qtybf_#thisitemno#" id="qtybf_#thisitemno#" onBlur="if(this.value==''){this.value = '0'}" onchange="dataupdate('#thisitemno#',this.value);"></td>
				</cfif>
			</cfloop>
		</tr>
	</table>
	</cfoutput>
<cfelseif colorlist neq "">
	<cfoutput>
	<input type="hidden" name="mitemno" value="#form.mitemno#">
	<table align="center" class="data">
		<tr>
			<cfloop from="1" to="20" index="i">
				<cfif geticmitem["color#i#"][1] neq "">
					<td width="30" align="center">#geticmitem["color#i#"][1]#</td>
				</cfif>
			</cfloop>
		</tr>
		<tr>
			<cfloop from="1" to="20" index="i">
				<cfset thiscolor = geticmitem["color#i#"][1]>
				<cfif thiscolor neq "">
					<cfif form.inserthyphen eq 1>
						<cfset thisitemno = form.mitemno&'-'&thiscolor>
					<cfelse>
						<cfset thisitemno = form.mitemno&thiscolor>
					</cfif>
					<cfquery name="getqtybf" datasource="#dts#">
						select qtybf from icitem
						where itemno = '#thisitemno#'
					</cfquery>
					<td><input type="text" value="#val(getqtybf.qtybf)#" size="5" name="qtybf_#thisitemno#" id="qtybf_#thisitemno#" onBlur="if(this.value==''){this.value = '0'}" onchange="dataupdate('#thisitemno#',this.value);"></td>
				</cfif>
			</cfloop>
		</tr>
	</table>
	</cfoutput>
<cfelse>
<h3>No Record found.</h3>
</cfif>

</form>
</body>
</html>