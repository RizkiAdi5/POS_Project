<html>
<head>
<title>Item - Supplier Last Price Enquiry</title>
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
		<td colspan="13"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Item - Supplier Last Price Enquiry</strong></font></div></td>
	</tr>
	<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		<tr>
			<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">SUPPLIER: #form.suppfrom# - #form.suppto#</font></div></td>
		</tr>
	</cfif>
	<cfif form.datefrom neq "" and form.dateto neq "">
		<tr> 
      		<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd-mm-yyyy")# - #dateformat(form.dateto,"dd-mm-yyyy")#</font></div></td>
    	</tr>
	</cfif>
	<tr> 
		<td colspan="2"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
			<td colspan="3">&nbsp;</td>
		</cfif>
		<td colspan="5"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd-mm-yyyy")#</font></div></td>
	</tr>
	<tr> 
		<td colspan="100%"><hr></td>
	</tr>
	<tr> 
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">SUPP/ITEM NO</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DESP</font></div></td>
		<cfif isdefined("form.displaycurr")>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">C.CODE</font></div></td>
		</cfif>
	 	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">R.PRICE</font></div></td>
	 	<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY</font></div></td>
		</cfif>
      	<td width="70px"><div align="right"><font size="2" face="Times New Roman, Times, serif">L.PRICE</font></div></td>
		<td width="100px"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
		<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY&sup2;</font></div></td>
		</cfif>
		<td width="70px"><div align="right"><font size="2" face="Times New Roman, Times, serif">L&sup2;.PRICE</font></div></td>
		<td width="100px"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
		<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY&sup3;</font></div></td>
		</cfif>
		<td width="70px"><div align="right"><font size="2" face="Times New Roman, Times, serif">L&sup3;.PRICE</font></div></td>
		<td width="100px"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
    </tr>
   	<tr> 
      	<td colspan="100%"><hr></td>
    </tr>
	
	<cfquery name="getitem" datasource="#dts#">
		select c.itemno,c.desp from ictran as a, #target_apvend# as b, icitem as c
		where a.type='RC' and a.custno=b.custno and (a.void='' or a.void is null) and a.itemno=c.itemno
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		and b.custno between '#form.suppfrom#' and '#form.suppto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and c.itemno between '#form.itemfrom#' and '#form.itemto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and a.wos_date between '#ndatefrom#' and '#ndateto#'
		<cfelse>
		and a.wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by a.itemno order by a.itemno
	</cfquery>
	
	<cfloop query="getitem">
		<cfset itemno=getitem.itemno>
        <cfif trim(form.suppfrom) neq trim(form.suppto) or (trim(form.suppfrom) eq "" and trim(form.suppto) eq "")>
        		<tr> 
			<td><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getitem.itemno#</u></b></div></font></td>
			<td><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getitem.desp#</u></b></div></font></td>
		</tr>
        <cfelse>
        <cfif getitem.currentrow eq 1>
        <cfquery name="getsuppdetail" datasource="#dts#">
			select custno,name from #target_apvend# where custno = '#form.suppfrom#'
		</cfquery>
        	<tr> 
							<td><div align="left"><font size="3" face="Times New Roman, Times, serif">#getsuppdetail.custno#</font></div></td>
				<td><div align="left"><font size="3" face="Times New Roman, Times, serif">#getsuppdetail.name#</font></div></td>
		</tr>
        <tr>
        <td>&nbsp;</td>
        </tr>
        </cfif>
		</cfif>
		<cfquery name="getsupp" datasource="#dts#">
			select b.custno,b.name,b.currcode from ictran a, #target_apvend# b
			where a.type='RC' and a.custno=b.custno and (a.void='' or a.void is null) and a.itemno='#getitem.itemno#' 
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
			and b.custno between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and a.wos_date between '#ndatefrom#' and '#ndateto#'
			<cfelse>
			and a.wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by b.custno order by b.custno
		</cfquery>

		<cfloop query="getsupp">
			<cfset customerno=getsupp.custno>
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';"> 
            <cfif trim(form.suppfrom) neq trim(form.suppto)  or (trim(form.suppfrom) eq "" and trim(form.suppto) eq "")>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsupp.custno#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsupp.name#</font></div></td>
            <cfelse>
            <td><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getitem.itemno#</u></b></div></font></td>
			<td><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getitem.desp#</u></b></div></font></td>
			</cfif>
				<cfif isdefined("form.displaycurr")>
					<td><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getsupp.currcode#</u></b></div></font></td>
				</cfif>
				
				<cfquery name="getprice" datasource="#dts#">
					select a.custno,a.name,a.currcode,date_format(b.wos_date1,'%d-%m-%Y') as wos_date1,ifnull(b.price1,0) as price1,
					date_format(c.wos_date2,'%d-%m-%Y') as wos_date2,ifnull(c.price2,0) as price2,date_format(d.wos_date3,'%d-%m-%Y') as wos_date3,ifnull(d.price3,0) as price3,
					ifnull(b.qty_1,0) as qty_1,ifnull(c.qty_2,0) as qty_2,ifnull(d.qty_3,0) as qty_3  
					from #target_apvend# as a 
		
					left join 
					(select custno,itemno,wos_date as wos_date1,qty as qty_1,<cfif isdefined("form.displaycurr")>(price_bil) as price1<cfelse>(price) as price1</cfif> 
					from ictran where itemno='#itemno#' and custno='#customerno#' and type='RC' and (void='' or void is null)
					<cfif form.datefrom neq "" and form.dateto neq "">
						and wos_date between '#ndatefrom#' and '#ndateto#'
					<cfelse>
						and wos_date > #getgeneral.lastaccyear#
					</cfif>
					order by wos_date desc limit 1) as b on a.custno=b.custno 
		
					left join 
					(select custno,itemno,wos_date as wos_date2,qty as qty_2,<cfif isdefined("form.displaycurr")>(price_bil) as price2<cfelse>(price) as price2</cfif> 
					from ictran where itemno='#itemno#' and custno='#customerno#' and type='RC' and (void='' or void is null)
					<cfif form.datefrom neq "" and form.dateto neq "">
						and wos_date between '#ndatefrom#' and '#ndateto#'
					<cfelse>
						and wos_date > #getgeneral.lastaccyear#
					</cfif>
					order by wos_date desc limit 1,1) as c on a.custno=c.custno
		
					left join 
					(select custno,itemno,wos_date as wos_date3,qty as qty_3,<cfif isdefined("form.displaycurr")>(price_bil) as price3<cfelse>(price) as price3</cfif> 
					from ictran where itemno='#itemno#' and custno='#customerno#' and type='RC' and (void='' or void is null)
					<cfif form.datefrom neq "" and form.dateto neq "">
						and wos_date between '#ndatefrom#' and '#ndateto#'
					<cfelse>
						and wos_date > #getgeneral.lastaccyear#
					</cfif>
					order by wos_date desc limit 2,1) as d on a.custno=d.custno
					
					where a.custno='#customerno#'
					order by a.custno
				</cfquery>
				
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#numberformat(0,"0.00")#</font></div></td>
				<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getprice.qty_1 eq 0,DE(''),DE(getprice.qty_1))#</font></div></td>
				</cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getprice.price1 eq 0,DE(''),DE(numberformat(getprice.price1,stDecl_UPrice)))#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getprice.wos_date1#</font></div></td>
				<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getprice.qty_2 eq 0,DE(''),DE(getprice.qty_2))#</font></div></td>
				</cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getprice.price2 eq 0,DE(''),DE(numberformat(getprice.price2,stDecl_UPrice)))#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getprice.wos_date2#</font></div></td>
				<cfif isdefined("form.displayqty") and form.displayqty eq "yes">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getprice.qty_3 eq 0,DE(''),DE(getprice.qty_3))#</font></div></td>
				</cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#iif(getprice.price3 eq 0,DE(''),DE(numberformat(getprice.price3,stDecl_UPrice)))#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getprice.wos_date3#</font></div></td>
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

<cfif getitem.recordcount eq 0>
	<h4>Sorry, No records were found.</h4>
</cfif> 

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>