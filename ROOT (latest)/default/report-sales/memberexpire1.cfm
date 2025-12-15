<cfif isdefined("form.datefrom") and isdefined("form.dateto")>
	<cfset dd = dateformat(form.datefrom, "DD")>
	<cfif dd greater than '12'>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYMMDD")>
	<cfelse>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYDDMM")>
	</cfif>

	<cfset dd = dateformat(form.dateto, "DD")>
	<cfif dd greater than '12'>
		<cfset ndateto = dateformat(form.dateto,"YYYYMMDD")>
	<cfelse>
		<cfset ndateto = dateformat(form.dateto,"YYYYDDMM")>
	</cfif>
</cfif>


<html>
<head>
<title>D.O.B</title>
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
</head>

<body>
<cfquery name="getDOB" datasource="#dts#">
            SELECT * FROM driver
            WHERE dob BETWEEN '#ndatefrom#' AND '#ndateto#'
            ORDER BY dob;
</cfquery>

<cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="2">
    <tr>
      <td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Member Birthday</strong></font></div></td>
    </tr>
    <tr>
      <td colspan="100"><div align="center"><font size="2" face="Times New Roman, Times, serif">Date printed : #dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr>
    <tr></tr>
    <tr><td colspan="100%"><hr></td></tr>
    <tr>
      <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>MEMBER NO</strong></font></div></td>
      <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>IC</strong></font></div></td>
      <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>NAME</strong></font></div></td>
      <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Expire Date</strong></font></div></td>
      <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>GENDER</strong></font></div></td>
      <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>ADDRESS</strong></font></div></td>
    </tr>
    <tr><td colspan="100%"><hr></td></tr>
    <cfloop query="getDOB">
      <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getDOB.driverno#</font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getDOB.icno#</font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getDOB.name#</font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getDOB.expiredate,'dd/mm/yyyy')#</font></div></td>
        <td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getDOB.gender#</font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getDOB.add1# #getDOB.add2# #getDOB.add3#</font></div></td>
      </tr>
    </cfloop>
  </table>
</cfoutput> <br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>
