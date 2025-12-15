<html>
<head>
<title>Item - Supplier Transacted Price Enquiry</title>
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

<cfoutput>
<table border="0" cellspacing="0" cellpadding="2">
	<tr> 
		<td colspan="13"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Item - Supplier Transacted Price Enquiry</strong></font></div></td>
	</tr>
	<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		<tr>
			<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">CUST: #form.suppfrom# - #form.suppto#</font></div></td>
		</tr>
	</cfif>
	<cfif form.datefrom neq "" and form.dateto neq "">
		<tr> 
      		<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
    	</tr>
	</cfif>
	<tr> 
		<td colspan="2"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>  
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td colspan="5"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
	</tr>
	<tr> 
		<td colspan="100%"><hr></td>
	</tr>
	<tr> 
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">TYPE</font></div></td>
	  	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">REF NO</font></div></td>
	  	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CUST NO</font></div></td>
	 	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">NAME</font></div></td>
	 	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CURRENCY</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">F.PRICE</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">PRICE</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">AMOUNT</font></div></td>
    </tr>
    <tr> 
    	<td colspan="100%"><hr></td>
    </tr>
		
	<cfquery name="getitem" datasource="#dts#">
		select a.itemno,a.desp from ictran a, #target_apvend# b
		where (a.type='RC' or a.type='PR') and a.custno=b.custno and (a.void='' or a.void is null)
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		and b.custno between '#form.suppfrom#' and '#form.suppto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and a.itemno between '#form.itemfrom#' and '#form.itemto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and a.wos_date between '#ndatefrom#' and '#ndateto#'
		<cfelse>
		and a.wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by itemno order by itemno
	</cfquery>

	<cfloop query="getitem">
		<tr> 
			<td colspan="3"><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getitem.itemno#</u></b></div></font></td>
			<td colspan="3"><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getitem.desp#</u></b></div></font></td>
		</tr>
			
		<cfquery name="getsupp" datasource="#dts#">
			select a.type,a.refno,a.custno,a.name,a.wos_date,a.price,a.price_bil,a.unit,a.qty,b.currcode,b.currrate,a.amt
			from ictran a, artran b 
			where a.type=b.type and a.refno=b.refno
			and (a.type='RC' or a.type='PR') and a.itemno='#getitem.itemno#' and (a.void='' or a.void is null) 
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
			and a.custno between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and a.wos_date between '#ndatefrom#' and '#ndateto#'
			<cfelse>
			and a.wos_date > #getgeneral.lastaccyear#
			</cfif>
			order by a.custno,a.refno,a.wos_date
		</cfquery>
			
		<cfloop query="getsupp">
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsupp.type#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsupp.refno#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getsupp.wos_date,"dd-mm-yyyy")#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsupp.custno#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsupp.name#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getsupp.qty,"0")#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getsupp.currcode#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getsupp.price_bil,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getsupp.price,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getsupp.amt,stDecl_UPrice)#</font></div></td>
			</tr>
		</cfloop>
		<tr><td><br></td></tr>
		<tr> 
			<td colspan="10"><hr></td>
		</tr>
		<cfflush>
	</cfloop>
</table>
</cfoutput>

<cfif getitem.recordcount eq 0>
	<h4 style="color:red">Sorry, No records were found.</h4>
</cfif> 

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>