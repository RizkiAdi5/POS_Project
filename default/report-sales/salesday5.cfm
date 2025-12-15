<html>
<head>
<title>End User Sales By Week Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfquery name="getgeneral" datasource="#dts#">
	select cost,compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
<cfset stDecl_UPrice = ",___.">

<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
	<cfset stDecl_UPrice = stDecl_UPrice & "_">
</cfloop>

<body>
<cfoutput>
<h1 align="center">PRINT #url.trantype# SALES WEEKLY REPORT (Excluded DN/CN)</h1>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
    	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">MONTH: #form.monthfrom#</font></div></td>
    </tr>
    <cfif form.userfrom neq "" and form.userto neq "">
        <tr>
          	<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">END USER: #form.userfrom# - #form.userto#</font></div></td>
        </tr>
    </cfif>
    <tr>
      	<td colspan="90%"><font size="2" face="Times New Roman, Times, serif"><cfif getgeneral.compro neq "">#getgeneral.compro#</cfif></font></td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td colspan="10%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr>
    <tr>
      	<td colspan="100%"><hr></td>
    </tr>

	<cfset lastyear = year(getgeneral.lastaccyear)>
	<cfset lastmonth = month(getgeneral.lastaccyear)>
	<cfset lastday = 1>
	<cfset selectedmonth = val(form.periodfrom)>
	<cfset count = 1>
	<cfset nodays = arraynew(1)>
	<cfset lastmonth = lastmonth + selectedmonth>
	<cfif lastmonth gt 24>
		<cfset lastyear = lastyear + 2>
		<cfset lastmonth = lastmonth -24>
        <cfelseif lastmonth gt 12>
        <cfset lastyear = lastyear + 1>
		<cfset lastmonth = lastmonth -12>
	</cfif>

	<cfset days = firstdayofmonth(createdate(lastyear,lastmonth,lastday))-2>

	<cfset totalday = daysinmonth(createdate(lastyear,lastmonth,1))>

	<cfloop index="a" from="1" to="#totalday#">
		<cfset nodays[a] = a>
	</cfloop>

	<cfset newtime = createdate(lastyear,1,1) + days>

	<tr>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">ITEM NO.</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DESP</font></div></td>
	<cfloop index="a" from="1" to="#totalday#">
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(createdate(lastyear,lastmonth,a),'DD/MM/YYYY')#</font></div></td>
	</cfloop>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
	</tr>
	<tr>
      	<td colspan="100%"><hr></td>
    </tr>

<cfquery name="getdriver" datasource="#dts#">
	select * from driver where 0=0
    <cfif form.userfrom neq "" and form.userto neq "">
	 and driverno >='#form.userfrom#' and driverno <='#form.userto#'
	</cfif>
    group by driverno order by driverno
</cfquery>

<cfset total = arraynew(1)>
<cfset subtotal = arraynew(1)>

<cfloop index="a" from="1" to="#totalday#">
	<cfset total[a] = 0>
</cfloop>

<cfloop query="getdriver">
	<cfset van = getdriver.driverno>

	<cfloop index="a" from="1" to="#totalday#">
		<cfset subtotal[a] = 0>
	</cfloop>

	<cfquery name="getintran" datasource="#dts#">
		select wos_date,invgross as amt from artran
		where wos_date > #getgeneral.lastaccyear# and fperiod = '#form.periodfrom#' and van = '#van#' and (void = '' or void is null)
		and (type = 'INV' or type = 'CS')
		
		order by fperiod
	</cfquery>

	<cfloop query="getintran">
		<cfset checkday = day(getintran.wos_date)>
		<cfloop index="a" from="1" to="#totalday#">
			<cfif nodays[a] eq checkday>
				<cfset subtotal[a] = subtotal[a] + val(getintran.amt)>
				<cfset total[a] = total[a] + val(getintran.amt)>
			</cfif>
		</cfloop>
	</cfloop>

	<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdriver.driverno#</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdriver.name#</font></div></td>
		<cfloop index="a" from="1" to="#totalday#">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subtotal[a],stDecl_UPrice)#</font></div></td>
		</cfloop>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(arraysum(subtotal),stDecl_UPrice)#</font></div></td>
	</tr>
	<cfflush>
</cfloop>
	<tr>
      	<td colspan="100%"><hr></td>
    </tr>
	<tr>
		<td></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
		<cfloop index="a" from="1" to="#totalday#">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(total[a],",.__")#</strong></font></div></td>
		</cfloop>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(arraysum(total),",.__")#</strong></font></div></td>
	</tr>
</table>

<cfif getdriver.recordcount eq 0>
	<h3>Sorry, No records were found.</h3>
</cfif>
</cfoutput>
<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>