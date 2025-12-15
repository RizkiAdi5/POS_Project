<html>
<head>
<title>End User Summary Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfquery name="getdata" datasource="#dts#">
	select * from driver order by driverno
</cfquery>

<!--- ADD ON 15-07-2009 --->
<cfquery name="getGsetup" datasource="#dts#">
  Select lDRIVER from GSetup
</cfquery>

<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>
<p align="center"><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong><cfoutput>#getGsetup.lDRIVER#</cfoutput> Listing</strong></font></p>

<table align="center" border="0" width="100%">
	<tr><td colspan="5"><hr></td></tr>
	<tr>
		<td><div align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>#getGsetup.lDRIVER#</cfoutput></font></strong></div></td>
	    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Name</font></strong></td>
	    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Attention</font></strong></td>
		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Phone</font></strong></td>
	    <td><div align="center"><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfif lcase(HcomID) eq "iel_i" or lcase(HcomID) eq "ielm_i">Supp<cfelse>Cust</cfif> No</font></strong></div></td>
	</tr>
   	<tr><td colspan="5"><hr></td></tr>
  	<cfoutput query="getdata">
    <tr>
      	<td width="10%" nowrap>
			<div align="center"><font size="1" face="Arial, Helvetica, sans-serif">#driverno#</font></div>
		</td>
      	<td width="35%" nowrap>
        	<font size="1" face="Arial, Helvetica, sans-serif">#name# #name2#</font>
		</td>
      	<td width="20%" nowrap><font size="1" face="Arial, Helvetica, sans-serif">#attn#</font></td>
      	<td width="10%" nowrap><font size="1" face="Arial, Helvetica, sans-serif">#contact#</font></td>
      	<td width="10%" nowrap><div align="center"><font size="1" face="Arial, Helvetica, sans-serif">#customerno#</font></div></td>
    </tr>
  	</cfoutput>
  	<tr>
   		<td colspan="6"><font size="1" face="Arial, Helvetica, sans-serif">
			Total: <cfoutput>#getdata.recordcount#</cfoutput> </font>
		</td>
 	</tr>
</table>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint">
	<u>Print</u></a></font>
</div>
<p class="noprint">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</p>
</body>
</html>
