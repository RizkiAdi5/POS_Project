<html>
<head>
<title><cfoutput>#type#</cfoutput> Summary Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfquery name="getdata" datasource="#dts#">
	select * from #type# order by custno
</cfquery>

<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</font>
<p align="center"><font color="##000000" size="3" face="Arial, Helvetica, sans-serif"><strong>#type# </cfoutput>
  Summary Report</strong></font></p>


<table align="center" border="0" width="100%">

  <th><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>#type#</cfoutput> No</font></th>
    <th><font size="2" face="Arial, Helvetica, sans-serif">Customer Name</font></th>
    <th><font size="2" face="Arial, Helvetica, sans-serif">Attention</font></th>
    <th><font size="2" face="Arial, Helvetica, sans-serif">Phone</font></th>
    <th><font size="2" face="Arial, Helvetica, sans-serif">Agent</font></th>
    <th><font size="2" face="Arial, Helvetica, sans-serif">CurrCode</font></th>

  <cfoutput query="getdata">
    <tr>
      <td width="10%" nowrap>
		<div align="center"><font size="1" face="Arial, Helvetica, sans-serif">#custno#</font></div></td>
      <td width="35%" nowrap>
        <font size="1" face="Arial, Helvetica, sans-serif">#name# #name2#</font></td>
      <td width="20%" nowrap><font size="1" face="Arial, Helvetica, sans-serif">#attn#</font></td>
      <td width="10%" nowrap><font size="1" face="Arial, Helvetica, sans-serif">#phone#</font></td>
      <td width="20%" nowrap><font size="1" face="Arial, Helvetica, sans-serif">#agent#</font></td>
      <td width="5%" nowrap><div align="center"><font size="1" face="Arial, Helvetica, sans-serif">#currcode#</font></div></td>

    </tr>
  </cfoutput>
  <tr>
    <td colspan="6"><font size="1" face="Arial, Helvetica, sans-serif">Total:
      <cfoutput>#getdata.recordcount#</cfoutput> </font></td>
  </tr>
</table>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font>
</div>
<p class="noprint">Please print in Landscape format. Go to File - Page Setup,
  select "Landscape".</p>
</body>
</html>
