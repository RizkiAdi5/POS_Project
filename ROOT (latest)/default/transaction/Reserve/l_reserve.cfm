<html>
<head>
<title>Reserve Stock Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfparam name="i" default="1" type="numeric">

<cfquery datasource='#dts#' name="getPersonnel">
	Select * from reservestock order by itemno
</cfquery>
<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>
<div align="center"><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong>Reserve Stock Listing</strong></font></div>

  <cfif getPersonnel.recordCount gt 0>

	<table width="95%" border="0" class="" align="center">
  	  <tr><td colspan="8"><hr></td></tr>
	  <tr>
    	<td><strong><font size="2" face="Arial, Helvetica, sans-serif"><center>No</center></font></strong></td>
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Item No</font></strong></td>
        <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">GWC</font></strong></td>
        <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">MBS</font></strong></td>
        <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">PP</font></strong></td>
        <td align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif">RF</font></strong></td>
      </tr>
  	  <tr><td colspan="8"><hr></td></tr>
      <cfset i = 1>
	  <cfloop query="getPersonnel">
	  	<cfoutput>
	    <tr>
	      <td><div align="center">#i#</div></td>
	      <td>#itemno#</td>
	      <td align="center">#gwc#</td>
          <td align="center">#mbs#</td>
          <td align="center">#pp#</td>
          <td align="center">#rf#</td>
	      
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
