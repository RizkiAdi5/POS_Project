<html>
<head>
<title>View Bill Listing Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href = "../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
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
<cfset stDecl_UPrice = ",.">

<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
	<cfset stDecl_UPrice = stDecl_UPrice & "_">
</cfloop>

<cfparam name="ndatefrom" default="">
<cfparam name="ndateto" default="">
<cfparam name="totalamt" default="0">
<cfparam name="totaldisc" default="0">
<cfparam name="totaltax" default="0">
<cfparam name="totalgrand" default="0">
<cfparam name="totalfcamt" default="0">

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

<cfquery datasource="#dts#" name="gettran">
	Select * from artran where type = '#url.trancode#' and (void = '' or void is null)
	<cfif ndatefrom neq "" and ndateto neq "">
	and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
	<cfelse>
	and wos_date > #getgeneral.lastaccyear#
	</cfif>
	<cfif form.agentfrom neq "" and form.agentto neq "">
	and agenno >= '#form.agentfrom#' and agenno <= '#form.agentto#'
	</cfif>
	<cfif form.getfrom neq "" and form.getto neq "">
	and custno >= '#form.getfrom#' and custno <= '#form.getto#'
	</cfif>
	<cfif form.periodfrom neq "" and form.periodto neq "">
	and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
	</cfif>
	<cfif form.billfrom neq "" and form.billto neq "">
	and refno >= '#form.billfrom#' and refno <= '#form.billto#'
	</cfif>
	order by refno
</cfquery>

<body>

<table align="center" cellpadding="3" cellspacing="0" width="100%">
<cfoutput>
	<tr>
      	<td colspan="11"><div align="center"><font size="3" face="Arial, Helvetica, sans-serif"><strong>#url.type# Listing Report</strong></font></div></td>
    </tr>
    <cfif form.billfrom neq "" and form.billto neq "">
		<tr>
        	<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Ref No From #form.billfrom# To #form.billto#</font></div></td>
      	</tr>
    </cfif>
    <cfif ndatefrom neq "" and ndateto neq "">
      	<tr>
        	<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">#form.datefrom# - #form.dateto#</font></div></td>
      	</tr>
    </cfif>
    <cfif form.periodfrom neq "" and form.periodto neq "">
      	<tr>
        	<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Period From #form.periodfrom# To #form.periodto#</font></div></td>
      	</tr>
    </cfif>
    <cfif form.agentfrom neq "" and form.agentto neq "">
      	<tr>
        	<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Agent From #form.agentfrom# To #form.agentto#</font></div></td>
      	</tr>
    </cfif>
    <tr>
		<td colspan="4"><font size="1.5" face="Arial, Helvetica, sans-serif">
        <cfif getgeneral.compro neq "">
          	#getgeneral.compro#
		</cfif>
        </font></td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td colspan="5"><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr>
</cfoutput>
  	<tr>
    	<td colspan="10"><hr></td>
  	</tr>
  	<tr>
    	<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Refno</strong></font></div></td>
    	<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Date</strong></font></div></td>
    	<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Cust No</strong></font></div></td>
    	<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Name</strong></font></div></td>
    	<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Amount</strong></font></div></td>
    	<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Discount</strong></font></div></td>
    	<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Tax</strong></font></div></td>
    	<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Grand Local</strong></font></div></td>
    	<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Grand Foreign</strong></font></div></td>
    	<td><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Created By</strong></font></div></td>
  	</tr>
  	<tr>
    	<td colspan="10"><hr></td>
  	</tr>

	<cfoutput query="gettran">
    	<cfif currrate neq "">
        	<cfset xcurrrate = currrate>
        <cfelse>
        	<cfset xcurrrate = 1>
      	</cfif>

		<tr>
        	<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#gettran.refno#</font></div></td>
        	<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#dateformat(wos_date,"dd-mm-yy")#</font></div></td>
        	<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#custno#</font></div></td>
        	<cfquery datasource="#dts#" name="getcust">
        		Select name, currcode from #form.title# where customerno = "#custno#"
        	</cfquery>
        	<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#name#</font></div></td>

			<cfset xamt = val(gettran.invgross)>
          	<cfset xdisc = val(gettran.discount)>
          	<cfset xtax = val(gettran.tax)>
          	<cfset xgrand = val(gettran.grand)>

			<td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(xamt,",.__")#</font></div></td>
        	<td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(xdisc,",.__")#</font></div></td>
        	<td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(xtax,",.__")#</font></div></td>
        	<td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(xgrand,",.__")#</font></div></td>

			<cfif xcurrrate eq "1">
          		<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">-</font></div></td>
          	<cfelse>
          		<cfif gettran.grand_bil neq "">
            		<cfset xfcamt = val(gettran.grand_bil)>
          		</cfif>
          		<td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#getcust.currcode# #numberformat(xfcamt,stDecl_UPrice)#</font></div></td>
          		<cfset totalfcamt = totalfcamt + xfcamt>
        	</cfif>
        	<td><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">#userid#</font></div></td>
      	</tr>
      	<cfset totalamt = totalamt + xamt>
      	<cfset totaldisc = totaldisc + xdisc>
      	<cfset totaltax = totaltax + xtax>
      	<cfset totalgrand = totalgrand + xgrand>
    </cfoutput>
	<tr>
      	<td colspan="10"><hr></td>
    </tr>
    <tr>
      	<td></td>
      	<td></td>
      	<td></td>
	  	<cfoutput>
      	<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Total:</strong></font></div></td>
      	<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#numberformat(totalamt,",.__")#</strong></font></div></td>
      	<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#numberformat(totaldisc,",.__")#</strong></font></div></td>
      	<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#numberformat(totaltax,",.__")#</strong></font></div></td>
      	<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#numberformat(totalgrand,",.__")#</strong></font></div></td>
      	<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#numberformat(totalfcamt,",.__")#</strong></font></div></td>
      	</cfoutput>
		<td></td>
    </tr>
</table>

<br><br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>