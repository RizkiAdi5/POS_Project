<cfif getpin2.h4G00 eq "T">
<script language="JavaScript"> 
var popup="Sorry, right-click is disabled.";
 function noway(go) { if 
(document.all) { if (event.button == 2) { alert(popup); return false; } } if (document.layers) 
{ if (go.which == 3) { alert(popup); return false; } } } if (document.layers) 
{ document.captureEvents(Event.MOUSEDOWN); } document.onmousedown=noway;
</script>
</cfif>

<cfquery name="getdisplaydetail" datasource="#dts#">
select * from displaysetup
</cfquery>

<html>
<head>
<title>Location Opening Quantity</title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getgeneral" datasource="#dts#">
	select 
	cost,
	compro,
	lastaccyear,
    singlelocation
	from gsetup;
</cfquery>

<cfset totalqty=0>

<cfquery name="getlocationopeningqty" datasource="#dts#">
	select sum(a.locqfield) as locationqty ,a.itemno,b.aitemno,b.desp,a.location from locqdbf as a left join (select itemno,aitemno,desp from icitem)as b on a.itemno=b.itemno
    where 0=0
    <cfif form.locfrom neq '' and form.locto neq ''>
    and location between '#form.locfrom#' and '#form.locto#'
    </cfif>
    group by a.location,a.itemno
</cfquery>

<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>

<table align="center" border="0" width="100%">
	<tr>
		<td colspan="8"><div align="center"><font size="3" face="Times New Roman,Times,serif"><strong>Location Opening Quantity</strong></font></div></td>
	</tr>
	<cfoutput>

	<tr>
		<td colspan="3"><div align="left"><font size="2" face="Times New Roman,Times,serif">#getgeneral.compro#</font></div></td>
    	<td colspan="5"><div align="right"><font size="2" face="Times New Roman,Times,serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
	</tr>
	<tr>
		<td colspan="8"><hr></td>
	</tr>
	<tr>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">ITEM NO.</font></div></td>
        <cfif getdisplaydetail.report_aitemno eq 'Y'>
        <td><div align="left"><font size="2" face="Times New Roman,Times,serif">PRODUCT CODE.</font></div></td>
        </cfif>
		<td><div align="left"><font size="2" face="Times New Roman,Times,serif">DESPCRIPTION</font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman,Times,serif">LOCATION</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman,Times,serif">LOCATION OPENING</font></div></td>
    </tr>
	<tr>
      	<td colspan="8"><hr></td>
    </tr>
	<cfloop query="getlocationopeningqty">
		<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
			<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getlocationopeningqty.itemno#</font></div></td>
            <cfif getdisplaydetail.report_aitemno eq 'Y'>
        <td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getlocationopeningqty.aitemno#</font></div></td>
        </cfif>
			<td><div align="left"><font size="2" face="Times New Roman,Times,serif">#getlocationopeningqty.desp#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getlocationopeningqty.location#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#getlocationopeningqty.locationqty#</font></div></td>
		</tr>
        <cfset totalqty=totalqty+getlocationopeningqty.locationqty>
</cfloop></cfoutput>
		<tr><td colspan="100%"><hr></td></tr>
		<cfoutput>
        <tr>
			<td></td>
            <cfif getdisplaydetail.report_aitemno eq 'Y'>
        <td></td>
        </cfif>
			<td></td>
            <td>Total :</td>
            <td><div align="right"><font size="2" face="Times New Roman,Times,serif">#totalqty#</font></div></td>
		</tr>
        </cfoutput>
</table>

<cfif getlocationopeningqty.recordcount eq 0>
	<h3>Sorry, No records were found.</h3>
</cfif>

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>