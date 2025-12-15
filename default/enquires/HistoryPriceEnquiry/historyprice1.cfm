<html>
<head>
<title>Customer - Item Last Price Enquiry</title>
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
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr> 
		<td colspan="13"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Customer - Item Last Price Enquiry</strong></font></div></td>
	</tr>
	<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
		<tr>
			<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">CUST: #form.custfrom# - #form.custto#</font></div></td>
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
		<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
			<td colspan="3">&nbsp;</td>
		</cfif>
		<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
	</tr>
	<tr> 
		<td colspan="100%"><hr></td>
	</tr>
	<tr> 
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CUST/ITEM NO</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DESP</font></div></td>
		<cfif isdefined("form.displaycurr")>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">C.CODE</font></div></td>
		</cfif>
	 	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">R.PRICE</font></div></td>
	 	<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY</font></div></td>
		</cfif>
      	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">L.PRICE</font></div></td>
		<td><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
		<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY&sup2;</font></div></td>
		</cfif>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">L&sup2;.PRICE</font></div></td>
		<td><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
		<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY&sup3;</font></div></td>
		</cfif>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">L&sup3;.PRICE</font></div></td>
		<td><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
    </tr>
   	<tr> 
      	<td colspan="100%"><hr></td>
    </tr>

	<cfquery name="getcust" datasource="#dts#">
		select a.custno as custno,a.name,a.currcode 
		from #target_arcust# as a, ictran as b,icitem as c
		where a.custno=b.custno and (b.type='INV' or b.type='DN' or b.type='CS')
		and b.itemno=c.itemno and (b.void='' or b.void is null)
		<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			and a.custno between '#form.custfrom#' and '#form.custto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			and c.itemno between '#form.itemfrom#' and '#form.itemto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
			and b.wos_date between '#ndatefrom#' and '#ndateto#'
		<cfelse>
			and b.wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by custno order by custno
	</cfquery>
		
	<cfloop query="getcust">
		<cfset custno = getcust.custno>
		<tr> 
			<td><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getcust.custno#</u></b></div></font></td>
			<td><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getcust.name#</u></b></div></font></td>
			<cfif isdefined("form.displaycurr")>
				<td><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getcust.currcode#</u></b></div></font></td>
			</cfif>
		</tr>
		<cfquery name="getdata" datasource="#dts#">
			select itemno,desp
			from ictran where custno='#custno#' and (type='INV' or type='DN' or type='CS') and (void='' or void is null)
			<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date between '#ndatefrom#' and '#ndateto#'
			<cfelse>
				and wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				and itemno between '#form.itemfrom#' and '#form.itemto#'
			</cfif>
			group by itemno 
			order by #form.sort#
		</cfquery>
			
		<cfloop query="getdata">
			<cfset itemno=getdata.itemno>
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';"> 
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdata.itemno#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdata.desp#</font></div></td>
				<cfif isdefined("form.displaycurr")>
				<td></td>
				</cfif>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#numberformat(0,"0")#</font></div></td>
				
				<cfquery name="getitem" datasource="#dts#">
					select a.itemno,date_format(b.wos_date1,'%d-%m-%Y') as wos_date1,ifnull(b.price1,0) as price1,
					date_format(c.wos_date2,'%d-%m-%Y') as wos_date2,ifnull(c.price2,0) as price2,date_format(d.wos_date3,'%d-%m-%Y') as wos_date3,ifnull(d.price3,0) as price3,
					ifnull(b.qty_1,0) as qty_1,ifnull(c.qty_2,0) as qty_2,ifnull(d.qty_3,0) as qty_3 
					from icitem as a  
					
					left join 
					(select itemno,wos_date as wos_date1,qty as qty_1,(<cfif isdefined("form.displaycurr")>price_bil<cfelse>price</cfif>) as price1 
					from ictran where custno='#custno#' and itemno='#itemno#'
					and (type='INV' or type='DN' or type='CS') and (void='' or void is null)
					<cfif isdefined("form.datefrom") and form.datefrom neq "" and form.dateto neq "">
						and wos_date between '#ndatefrom#' and '#ndateto#'
					<cfelse>
						and wos_date > #getgeneral.lastaccyear#
					</cfif>
					order by wos_date desc limit 1) as b on a.itemno=b.itemno 
					
					left join 
					(select itemno,wos_date as wos_date2,qty as qty_2,(<cfif isdefined("form.displaycurr")>price_bil<cfelse>price</cfif>) as price2 
					from ictran where custno='#custno#' and itemno='#itemno#'
					and (type='INV' or type='DN' or type='CS') and (void='' or void is null)
					<cfif isdefined("form.datefrom") and form.datefrom neq "" and form.dateto neq "">
						and wos_date between '#ndatefrom#' and '#ndateto#'
					<cfelse>
						and wos_date > #getgeneral.lastaccyear#
					</cfif>
					order by wos_date desc limit 1,1) as c on a.itemno=c.itemno 
					
					left join 
					(select itemno,wos_date as wos_date3,qty as qty_3,(<cfif isdefined("form.displaycurr")>price_bil<cfelse>price</cfif>) as price3 
					from ictran where custno='#custno#' and itemno='#itemno#'
					and (type='INV' or type='DN' or type='CS') and (void='' or void is null)
					<cfif isdefined("form.datefrom") and form.datefrom neq "" and form.dateto neq "">
						and wos_date between '#ndatefrom#' and '#ndateto#'
					<cfelse>
						and wos_date > #getgeneral.lastaccyear#
					</cfif>
					order by wos_date desc limit 2,1) as d on a.itemno=d.itemno 
					
					where a.itemno='#itemno#'
					order by a.itemno
				</cfquery>
				<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getitem.qty_1 eq 0,DE(''),DE(getitem.qty_1))#</font></div></td>
				</cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getitem.price1 eq 0,DE(''),DE(numberformat(getitem.price1,stDecl_UPrice)))#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getitem.wos_date1#</font></div></td>
				<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getitem.qty_2 eq 0,DE(''),DE(getitem.qty_2))#</font></div></td>
				</cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getitem.price2 eq 0,DE(''),DE(numberformat(getitem.price2,stDecl_UPrice)))#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getitem.wos_date2#</font></div></td>
				<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getitem.qty_3 eq 0,DE(''),DE(getitem.qty_3))#</font></div></td>
				</cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getitem.price3 eq 0,DE(''),DE(numberformat(getitem.price3,stDecl_UPrice)))#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getitem.wos_date3#</font></div></td>
			</tr>
		</cfloop>
		<tr><td><br></td></tr>
		<cfflush>
	</cfloop>
	<tr> 
		<td colspan="100%"><hr></td>
	</tr>
</table>
</cfoutput>

<cfif getcust.recordcount eq 0>
	<h4>Sorry, No records were found.</h4>
</cfif> 

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>