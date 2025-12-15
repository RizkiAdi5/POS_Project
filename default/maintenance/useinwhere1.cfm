<html>
<head>
<title>Use In Where</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<cfquery name="getgeneral" datasource="#dts#">
	select compro from gsetup
</cfquery>
<cfquery name="getdata" datasource="#dts#">
	select * from billmat where bmitemno = '#form.getitem#'
</cfquery>
<body>
<div align="center"><font color="#000000" size="4" face="Times New Roman, Times, serif">USE
  IN WHERE</font> </div>
  <br>

<table width="90%" border="0" cellspacing="0" cellpadding="3" align="center">
  <tr>
    <td colspan="4"><cfif getgeneral.compro neq "">
        <font size="2" face="Times New Roman, Times, serif"><cfoutput>#getgeneral.compro#</cfoutput></font> </cfif> </td>
    <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfoutput>#dateformat(now(),"dd/mm/yyyy")#</cfoutput></font></div></td>
  </tr>
  <tr>
    <td colspan="5"><hr></td>
  </tr>
  <tr>
    <td width="15%"><strong><font size="2" face="Times New Roman, Times, serif">ITEM NO</font></strong></td>
    <td width="10%"><div align="center"><strong><font size="2" face="Times New Roman, Times, serif">BOM
        NO</font></strong></div></td>
    <td><strong><font size="2" face="Times New Roman, Times, serif">DESCRIPTION</font></strong></td>
    <td width="15%"><strong><font size="2" face="Times New Roman, Times, serif">MATERIAL</font></strong></td>
    <td width="20%"><div align="right"><strong><font size="2" face="Times New Roman, Times, serif">MATERIAL
        QTY</font></strong></div></td>
  </tr>
  <tr>
    <td colspan="5"><hr></td>
  </tr>
  <cfoutput query="getdata">
  	<cfquery name="getitem" datasource="#dts#">
		select desp from icitem where itemno = '#itemno#'
	</cfquery>
  <tr>
    <td><font size="2" face="Times New Roman, Times, serif">#itemno#</font></td>
    <td><div align="center"><font size="2" face="Times New Roman, Times, serif">#bomno#</font></div></td>
    <td><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></td>
    <td><font size="2" face="Times New Roman, Times, serif">#bmitemno#</font></td>
    <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#bmqty#</font></div></td>
  </tr>
  </cfoutput>
  <tr>
    <td colspan="5"><hr></td>
  </tr>
</table>

</body>
</html>
