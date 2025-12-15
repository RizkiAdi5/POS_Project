<html>
<head>
<title>Supplier - Item Transacted Price Enquiry</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<body>
<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
<cfset stDecl_UPrice = ",___.">

<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
  <cfset stDecl_UPrice = stDecl_UPrice & "_">
</cfloop>

<cfoutput>
<table border="0" cellspacing="0" cellpadding="2">
	<tr> 
		<td colspan="13"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Supplier - Item Transacted Price Enquiry</strong></font></div></td>
	</tr>
	<cfif form.periodfrom neq "" and form.periodto neq "">
		<tr>		
			<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
		</tr>
	</cfif>
	<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		<tr>
			<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">SUPP: #form.suppfrom# - #form.suppto#</font></div></td>
		</tr>
	</cfif>
	<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		<tr>
			<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM.NO: #form.itemfrom# - #form.itemto#</font></div></td>
		</tr>
	</cfif>
	<cfif form.locatefrom neq "" and form.locateto neq "">
		<tr>
			<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">LOCATION: #form.locatefrom# - #form.locateto#</font></div></td>
		</tr>
	</cfif>
	<tr> 
		<td colspan="2"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>  
	  	<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td colspan="5"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
	</tr>
	<tr><td><br></td></tr>
		
	<cfquery name="getsupp" datasource="#dts#">
		select a.custno as suppno,a.name as name,a.currcode as currcode 
		from #target_apvend# a,ictran b
		where a.custno=b.custno and b.wos_date > #getgeneral.lastaccyear# and (b.type='RC' or b.type='PR') and (b.void='' or b.void is null)
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and b.fperiod between '#form.periodfrom#' and '#form.periodto#'
		</cfif>
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		and a.custno between '#form.suppfrom#' and '#form.suppto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and b.itemno between '#form.itemfrom#' and '#form.itemto#'
		</cfif>
		<cfif form.locatefrom neq "" and form.locateto neq "">
		and b.location between '#form.locatefrom#' and '#form.locateto#'
		</cfif>
		group by suppno order by suppno
	</cfquery>

	<cfloop query="getsupp">
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><b>#getsupp.suppno#</b></font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><b>#getsupp.name#</b></font></div></td>
			<cfif isdefined("form.displaycurr")>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><b>#getsupp.currcode#</b></font></div></td>
			</cfif>
		</tr>
		<tr> 
			<td colspan="10"><hr></td>
		</tr>
		<tr> 
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">PD</font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">TYPE</font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">REF.NO</font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">ITEM</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">U.M</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">PRICE</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">AMT</font></div></td>
		</tr>
		<tr> 
			<td colspan="10"><hr></td>
		</tr>
			
		<cfquery name="getitem" datasource="#dts#">
			select fperiod,wos_date,type,refno,itemno,desp,qty,unit,<cfif isdefined("form.displaycurr")>(price_bil) as price,(amt_bil) as amt<cfelse>(price) as price,(amt) as amt</cfif>
			from ictran
			where wos_date > #getgeneral.lastaccyear# and (type='RC' or type='PR') and custno='#getsupp.suppno#' and (void='' or void is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod between '#form.periodfrom#' and '#form.periodto#'
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			and itemno between '#form.itemfrom#' and '#form.itemto#'
			</cfif>
			<cfif form.locatefrom neq "" and form.locateto neq "">
			and location between '#form.locatefrom#' and '#form.locateto#'
			</cfif>
			order by wos_date
		</cfquery>
			
		<cfloop query="getitem">
			<tr>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.fperiod#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getitem.wos_date,"dd-mm-yyyy")#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.type#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.refno#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.qty#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.unit#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.price,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.amt,stDecl_UPrice)#</font></div></td>
			</tr>
			<cfif isdefined("form.displaydesp")>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></div></td>
			</tr>
			</cfif>
		</cfloop>
		<tr> 
			<td colspan="10"><hr></td>
		</tr>
		<tr><td><br></td></tr>
		<cfflush>
	</cfloop>
</table>
</cfoutput>

<cfif getsupp.recordcount eq 0>
	<h4 style="color:red">Sorry, No records were found.</h4>
</cfif> 

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>