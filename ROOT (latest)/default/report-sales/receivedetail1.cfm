<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

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
	<title>Daily Cash Sales Detail Report</title>
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
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="9"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Receive Detail</strong></font></div></td>
		</tr>
		<cfif isdefined("form.periodfrom") and form.periodfrom neq "" and form.periodto neq "">
			<tr>
				<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
			</tr>
		</cfif>
		<cfif isdefined("form.datefrom") and form.datefrom neq "" and form.dateto neq "">
			<tr>
				<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
			</tr>
		</cfif>
		<tr>
			<td colspan="3"><font size="2" face="Times New Roman, Times, serif">
			  #getgeneral.compro#
			</font></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="1"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		

		<cfset totalqty = 0>
		<cfset totalamt = 0>
		<cfquery name="getgroup" datasource="#dts#">
		select * from artran a
		where (type = 'RC') and (void = '' or void is null)
		
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
		<cfelse>
		and wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by type,refno order by type,refno
	</cfquery>
    
    
    
    
		<cfloop query="getgroup">
        <tr>
			<td colspan="100%"><hr></td>
		</tr>
		<tr>
        	<td><font size="2" face="Times New Roman, Times, serif">DATE</font></td>
            <td><font size="2" face="Times New Roman, Times, serif">SUPPLIER</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">RECEIVE NO</font></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">RECEIVE GROSS</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">RECEIVE TAX</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">RECEIVE GRAND</font></div></td>
            <td><font size="2" face="Times New Roman, Times, serif">PO NUMBER</font></td>
		</tr>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
        <cfset subqty = 0>
		<cfset subamt = 0>
			<tr>
            		<td><font size="2" face="Times New Roman, Times, serif">#dateformat(wos_date,'dd-mm-yyyy')#</font></td>
                    <td><font size="2" face="Times New Roman, Times, serif">#name#</font></td>
					<td><font size="2" face="Times New Roman, Times, serif">#getgroup.refno#</font></td>
                    
                    <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(invgross,',.__')#</font></div></td>
                    <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(tax,',.__')#</font></div></td>
                     
                      <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grand,',.__')#</font></div></td>
                      <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#pono#</font></div></td>
			</tr>
            
            <tr>
			<td colspan="100%"><hr></td>
		</tr>
		<tr>
        	<td><font size="2" face="Times New Roman, Times, serif">Item No</font></td>
        	<td><font size="2" face="Times New Roman, Times, serif">Item Description</font></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Item Profile Cost</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Qty Received</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Receive Cost</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Receive Amount</font></div></td>
            <td><font size="2" face="Times New Roman, Times, serif">Comment</font></td>
		</tr>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
            
			<cfquery name="getitem" datasource="#dts#">
				select a.*,(select ucost from icitem where itemno=a.itemno) as profilecost from ictran as a
				where type='#getgroup.type#' and refno='#getgroup.refno#'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
                 and (void = '' or void is null)
			</cfquery>
            
            <cfloop query="getitem">
           <cfquery name="gettaxincl" datasource="#dts#">
            select taxincl from artran where type='#getitem.type#' and refno='#getitem.refno#'
            </cfquery>
            <cfif gettaxincl.taxincl eq 'T'>
            <cfset getitem.amt=getitem.amt-getitem.taxamt>
            <cfif getitem.qty neq 0>
            <cfset getitem.price=getitem.amt/getitem.qty>
            <cfelse>
            <cfset getitem.price=getitem.amt>
            </cfif>
			</cfif>
				<cfset subqty = subqty + val(getitem.qty)>
				<cfset subamt = subamt + val(getitem.amt)>
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<td><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></td>
					<td><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></td>
                    <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.profilecost,stDecl_UPrice)#</font></div></td>
                 
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(qty,"0")# #unit#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.price,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getitem.amt,stDecl_UPrice)#</font></div></td>
                    <td><font size="2" face="Times New Roman, Times, serif">#tostring(getitem.comment)#</font></td>
				</tr>

			</cfloop><!---
            <cfset totalqty = totalqty + subqty>
			<cfset totalamt = totalamt + subamt>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td><font size="2" face="Times New Roman, Times, serif">SUB-TOTAL</font></td>
				<td></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subqty,"0")#</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subamt,stDecl_UPrice)#</font></div></td>
			</tr>--->

		</cfloop>
       
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
         <!---
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
			<td ></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalqty,"0")#</strong></font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalamt,",.__")#</strong></font></div></td>
		</tr>--->
	  </table>

	<cfif getgroup.recordcount eq 0>
		<h3>Sorry, No records were found.</h3>
		<cfabort>
	</cfif>
	</cfoutput>
	<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()"><u>Print</u></a></font></div>
	<p><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
	</body>
	</html>