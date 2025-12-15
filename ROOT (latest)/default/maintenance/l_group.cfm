<html>
<head>
<title>Product Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfparam name="i" default="1" type="numeric">

<cfquery name="getGroup" datasource="#dts#">
  select * from icgroup
  <cfif form.groupfrom neq "" and form.groupto neq "">
	where wos_group >= '#form.groupfrom#' and wos_group <= '#form.groupto#'
  </cfif>
  order by wos_group
</cfquery>

<cfquery datasource='#dts#' name="getgeneral">
	Select lgroup as layer from gsetup
</cfquery>

<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>
<div align="center"><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong><cfoutput>#getgeneral.layer#</cfoutput> Listing</strong></font></div>

  <cfif getGroup.recordCount gt 0>

	<table width="95%" border="0" class="" align="center">
  	  <tr><td colspan="8"><hr></td></tr>
	  <tr>
    	<td><strong><font size="2" face="Arial, Helvetica, sans-serif">No</font></strong></td>
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>#getgeneral.layer#</cfoutput></font></strong></td>
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Description</font></strong></td>
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Credit Sales</font></strong></td>
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Cash Sales</font></strong></td>
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Sales Return</font></strong></td>
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Purchase</font></strong></td>
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Purchase Return</font></strong></td>
      </tr>
  	  <tr><td colspan="8"><hr></td></tr>
      <cfset i = 1>
	  <cfloop query="getGroup">
	  	<cfoutput>
	    <tr>
	      <td><div align="center">#i#</div></td>
	      <td><cfif getpin2.h1511 eq 'T'><a href="grouptable2.cfm?type=Edit&wos_group=#wos_group#">#wos_group#</a><cfelse>#wos_group#</cfif></td>
	      <td>#desp#</td>
	      <td><div align="center">#SALEC#</div></td>
	      <td><div align="center">#SALECSC#</div></td>
	      <td><div align="center">#SALECNC#</div></td>
	      <td><div align="center">#PURC#</div></td>
	      <td><div align="center">#PURPRC#</div></td>
	      <td>
		</tr>
 		</cfoutput>
	    <cfset i = incrementvalue(#i#)>
	  </cfloop>
	</table>

  <cfelse>
  <strong><font size="2" face="Arial, Helvetica, sans-serif">No Records were found.
  </font> </strong>
</cfif>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>


</body>
</html>
