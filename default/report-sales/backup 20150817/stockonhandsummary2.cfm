<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,site from gsetup
</cfquery>

<cfquery name="createtable" datasource="#dts#">
CREATE TABLE IF NOT EXISTS `dolink`  (
  `useddo` VARCHAR(50)
)
ENGINE = MyISAM;
</cfquery>
<cfquery name="truncatedolink" datasource="#dts#">
truncate dolink
</cfquery>
<cfquery name="getdoupdated" datasource="#dts#">
INSERT INTO dolink SELECT frrefno FROM iclink WHERE frtype = "DO" 
<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
	and itemno between '#form.productfrom#' and '#form.productto#'
</cfif> group by frrefno
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfset outtrantypewithinv1="'DO','DN','PR','CS','ISS','OAR','TROU'">

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
	<title>PRODUCT SALES REPORT</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
	</head>
	<body>
	<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
	<cfset stDecl_UPrice = ",___.">

	<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		<cfset stDecl_UPrice = stDecl_UPrice & "_">
	</cfloop>
	<cfoutput>
    <cfset totalcost=0>
    <cfset totalprice=0>
    <cfset totalprice2=0>
    <cfset totalbalance=0>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Stock On Hand Summary Total (By Group)</strong></font></div></td>
		</tr>
		<tr>
			<td colspan="5"><font size="2" face="Times New Roman, Times, serif">
			  #getgeneral.compro#
			</font></td>
			<td colspan="1"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
		<tr>
       		<td><font size="2" face="Times New Roman, Times, serif">Group No</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">Description</font></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Cost</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Selling Price</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Selling Price 2</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">On Hand Qty</font></div></td>
          </tr>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
		<cfquery name="getitem" datasource="#dts#">
        select desp,wos_group,sum(balance) as balance,sum(ucost) as ucost,sum(price) as price,sum(price2) as price2 FROM(
        select 
        a.itemno,
        (select desp from icgroup where wos_group=a.wos_group) as desp,
        a.unit,
        a.price*ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) as price,
        a.price2*ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) as price2,
        a.packing,
        a.category,
        a.wos_group,
        round(a.ucost*ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0),2) as ucost,
        ifnull(b.sumtotalin,0) as qtyin,
        ifnull(c.sumtotalout,0) as qtyout,
        ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) as balance,
        ifnull(a.qtybf,0) as openbal
        from icitem as a
        
        left join 
        (
            select itemno,sum(qty) as sumtotalin 
            from ictran 
            where type in ('RC','CN','OAI','TRIN') 
            <cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
                and itemno between '#form.productfrom#' and '#form.productto#' 
                </cfif>
            <cfif form.periodfrom neq "" and form.periodto neq "">
            and fperiod <= '#form.periodto#'
            </cfif>
            <cfif form.datefrom neq "" and form.dateto neq "">
            and wos_date <= '#ndateto#'
            <cfelse>
            and wos_date > #getgeneral.lastaccyear#
            </cfif>
            and fperiod<>'99'
            and (void = '' or void is null)
            group by itemno
        ) as b on a.itemno=b.itemno
        
        left join 
        (
            select itemno,sum(qty) as sumtotalout 
            from ictran 
            where 
            (type in (#PreserveSingleQuotes(outtrantypewithinv1)#) or 
				(type='INV' and (dono = "" or dono is null or dono not in (select useddo from dolink))))
            
            <cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
                and itemno between '#form.productfrom#' and '#form.productto#' 
                </cfif>
            <cfif form.periodfrom neq "" and form.periodto neq "">
            and fperiod <= '#form.periodto#'
            </cfif>
            <cfif form.datefrom neq "" and form.dateto neq "">
            and wos_date <= '#ndateto#'
            <cfelse>
            and wos_date > #getgeneral.lastaccyear#
            </cfif>
            and fperiod<>'99'
            and (void = '' or void is null) 
            and (toinv='' or toinv is null)
            group by itemno
        ) as c on a.itemno=c.itemno
        
        where 0=0
        <cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
                and a.itemno between '#form.productfrom#' and '#form.productto#' 
        </cfif>
        <cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
                and a.wos_group between '#form.groupfrom#' and '#form.groupto#' 
        </cfif>
        <cfif isdefined('form.qty0')>
        <cfelse>
        and ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) <> 0
        </cfif>
        
        and (a.itemtype <> 'SV' or a.itemtype is null)
        order by a.itemno
        )as aa  group by aa.wos_group order by aa.wos_group

        </cfquery>
        <cfloop query="getitem">
        <cfset totalcost=totalcost+getitem.ucost>
		<cfset totalprice=totalprice+getitem.price>
        <cfset totalprice2=totalprice2+getitem.price2>
        <cfset totalbalance=totalbalance+getitem.balance>
            <tr>
			<td><font size="2" face="Times New Roman, Times, serif">#getitem.wos_group#</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.ucost,'.__')#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.price,'.__')#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.price2,'.__')#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.balance#</font></div></td>
            </tr>
		</cfloop>
       
        
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
        <tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
			<td></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcost,'.__')#</strong></font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalprice,'.__')#</strong></font></div></td>
			
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalprice2,'.__')#</strong></font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#totalbalance#</strong></font></div></td>
			</tr>
		
	  </table>

	<cfif getitem.recordcount eq 0>
		<h3>Sorry, No records were found.</h3>
		<cfabort>
	</cfif>
	</cfoutput>
	<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()"><u>Print</u></a></font></div>
	<p><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
	</body>
	</html>