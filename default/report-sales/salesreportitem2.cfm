<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,site from gsetup
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

<cfswitch expression="#form.result#">
	<cfcase value="EXCELDEFAULT">
	<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
	<cfset stDecl_UPrice = "">

	<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		<cfset stDecl_UPrice = stDecl_UPrice & "0">
	</cfloop>

	<cfset i=1>
		<cfset totalqty = 0>
		<cfset totalamt = 0>
		<cfquery name="getgroup" datasource="#dts#">
		select b.itemno, b.desp,a.refno,b.category,a.location,sum(a.qty) as qty,sum(a.amt) as amt,sum(a.disamt) as disamt,b.price from ictran a, icitem b
		where (type = 'INV' or type = 'CS')  and b.itemno = a.itemno and (void = '' or void is null)
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and b.category >='#form.catefrom#' and b.category <='#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and b.wos_group >='#form.groupfrom#' and b.wos_group <='#form.groupto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and b.itemno >='#form.itemfrom#' and b.itemno <= '#form.itemto#'
		</cfif>
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and a.fperiod+0 >= '#form.periodfrom#' and a.fperiod+0 <= '#form.periodto#'
		</cfif>
        
		<cfif form.datefrom neq "" and form.dateto neq "">
		and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
		<cfelse>
		and a.wos_date > #getgeneral.lastaccyear#
		</cfif>
        <cfif form.locfrom neq "" and form.locto neq "">
				and a.location >= '#form.locfrom#' and a.location <= '#form.locto#'
				</cfif>
        <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				and a.custno >='#form.custfrom#' and a.custno <= '#form.custto#'
				</cfif>
		group by a.itemno,a.location order by a.location,a.itemno
	</cfquery>

	<cfxml variable="data">
	<?xml version="1.0"?>
	<?mso-application progid="Excel.Sheet"?>
	<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:o="urn:schemas-microsoft-com:office:office"
	xmlns:x="urn:schemas-microsoft-com:office:excel"
	xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
	xmlns:html="http://www.w3.org/TR/REC-html40">
	<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
	<Author>Netiquette Technology</Author>
	<LastAuthor>Netiquette Technology</LastAuthor>
	<Company>Netiquette Technology</Company>
	</DocumentProperties>
	<Styles>
	<Style ss:ID="Default" ss:Name="Normal">
	<Alignment ss:Vertical="Bottom"/>
	<Borders/>
	<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9"/>
	<Interior/>
	<NumberFormat/>
	<Protection/>
	</Style>
	<Style ss:ID="s22">
	<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
	<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
	</Style>
	<Style ss:ID="s24">
	<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
	<Font ss:FontName="Verdana" x:Family="Swiss"/>
	</Style>
	<Style ss:ID="s26">
	<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
	<Font ss:FontName="Verdana" x:Family="Swiss"/>
	</Style>
	<Style ss:ID="s27">
	<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
	<Borders>
	<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
	<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	</Borders>
	</Style>
	<Style ss:ID="s28">
	<NumberFormat ss:Format="@"/>
	</Style>
	<Style ss:ID="s29">
	<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
	</Style>
	<Style ss:ID="s30">
	<Borders>
	<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	</Borders>
	<NumberFormat ss:Format="@"/>
	</Style>
	<Style ss:ID="s31">
	<Borders>
	<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
	</Borders>
	<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
	</Style>
	<Style ss:ID="s32">
	<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
	</Style>
	<Style ss:ID="s33">
	<Borders>
	<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
	</Borders>
	<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
	</Style>
	<Style ss:ID="s34">
	<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
	<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
	</Style>
	<Style ss:ID="s35">
	<NumberFormat ss:Format="0"/>
	</Style>
	<Style ss:ID="s36">
	<Borders>
	<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
	</Borders>
	<NumberFormat ss:Format="0"/>
	</Style>
	<Style ss:ID="s37">
	<Borders>
	<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
	</Borders>
	<NumberFormat ss:Format="0"/>
	</Style>
	</Styles>
	<Worksheet ss:Name="PRODUCT SALES REPORT">
	<cfoutput>
	<Table ss:ExpandedColumnCount="15" x:FullColumns="1" x:FullRows="1">
	<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="80.5" ss:Span="4"/>

	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s22"><Data ss:Type="String">PRODUCT SALES REPORT</Data></Cell>
	</Row>

	<cfif isdefined("form.periodfrom") and form.periodfrom neq "" and form.periodto neq "">
		<cfwddx action = "cfml2wddx" input = "PERIOD: #form.periodfrom# - #form.periodto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif isdefined("form.datefrom") and form.datefrom neq "" and form.dateto neq "">
		<cfwddx action = "cfml2wddx" input = "DATE: #form.datefrom# - #form.dateto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif isdefined("form.catefrom") and trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		<cfwddx action = "cfml2wddx" input = "CATEGORY: #form.catefrom# - #form.cateto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif isdefined("form.groupfrom") and trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		<cfwddx action = "cfml2wddx" input = "GROUP: #form.groupfrom# - #form.groupto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif isdefined("form.itemfrom") and trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		<cfwddx action = "cfml2wddx" input = "ITEM NO: #form.itemfrom# - #form.itemto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
    <cfif isdefined("form.locfrom") and trim(form.locfrom) neq "" and trim(form.locto) neq "">
		<cfwddx action = "cfml2wddx" input = "LOCATION : #form.locfrom# - #form.locto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>

	<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="5" ss:StyleID="s26"><Data ss:Type="String"><cfif getgeneral.compro neq "">#getgeneral.compro# </cfif></Data></Cell>
		<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
	</Row>

	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    <Cell ss:StyleID="s27"><Data ss:Type="String">S/No</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">Item No.</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">Item Desp</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">Qty</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">Nett Sales</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">Unit Price</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">Disc %</Data></Cell>
        <Cell ss:StyleID="s27"><Data ss:Type="String">Discount Amount</Data></Cell>
        <Cell ss:StyleID="s27"><Data ss:Type="String">Category</Data></Cell>
        <Cell ss:StyleID="s27"><Data ss:Type="String">Point of Sale</Data></Cell>
        <Cell ss:StyleID="s27"><Data ss:Type="String">Outlet</Data></Cell>

	</Row>

	<cfset totalqty = 0>
		<cfset totalamt = 0>

		<cfloop query="getgroup">
        <cfset totalqty = totalqty + val(getgroup.qty)>
		<cfset totalamt = totalamt + val(getgroup.amt)>
		<Row ss:AutoFitHeight="0" ss:Height="12">
				<cfwddx action = "cfml2wddx" input = "#i#" output = "wddxText1">
				<cfwddx action = "cfml2wddx" input = "#getgroup.itemno#" output = "wddxText2">
				<cfwddx action = "cfml2wddx" input = "#getgroup.desp#" output = "wddxText3">
                <cfwddx action = "cfml2wddx" input = "#getgroup.category#" output = "wddxText4">
                <cfwddx action = "cfml2wddx" input = "#getgroup.location#" output = "wddxText5">
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
                <Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText3#</Data></Cell>
                <Cell ss:StyleID="s28"><Data ss:Type="Number">#getgroup.qty#</Data></Cell>
                <Cell ss:StyleID="s29"><Data ss:Type="Number">#getgroup.amt#</Data></Cell>
                <Cell ss:StyleID="s29"><Data ss:Type="Number">#getgroup.price#</Data></Cell>
                <Cell ss:StyleID="s29"><Data ss:Type="Number"><cfif (getgroup.amt+getgroup.disamt) neq 0>#numberformat((getgroup.disamt/(getgroup.amt+getgroup.disamt))*100,'__')#%<cfelse>0%</cfif></Data></Cell>
                <Cell ss:StyleID="s29"><Data ss:Type="Number">#getgroup.disamt#</Data></Cell>
                <Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText4#</Data></Cell>
                <Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText5#</Data></Cell>
                <Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText5#</Data></Cell>
			<cfset i=i+1>
			<Cell ss:StyleID="s29"/>
		</Row>

	</cfloop>
	<Row ss:AutoFitHeight="0" ss:Height="12">
		<Cell ss:StyleID="s32"><Data ss:Type="String">TOTAL</Data></Cell>
		<Cell ss:StyleID="s32"/>
		<Cell ss:StyleID="s32"/>
		<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalqty#</Data></Cell>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalamt#</Data></Cell>
	</Row>
     <cfquery name="getroundadj" datasource="#dts#">
        select ifnull(sum(roundadj),0) as roundadj from artran
        where (type = 'INV' or type = 'CS') and (void = '' or void is null)
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
		<cfelse>
		and wos_date > #getgeneral.lastaccyear#
		</cfif>
        <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				and custno >='#form.custfrom#' and custno <= '#form.custto#'
		</cfif>
        <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >= '#form.locfrom#' and location <= '#form.locto#' group by refno)
		</cfif>
        </cfquery>
    <Row ss:AutoFitHeight="0" ss:Height="12">
		<Cell ss:StyleID="s32"><Data ss:Type="String">Rounding Adjustment</Data></Cell>
		<Cell ss:StyleID="s32"/>
		<Cell ss:StyleID="s32"/>
		<Cell ss:StyleID="s37"><Data ss:Type="Number"></Data></Cell>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#getroundadj.roundadj#</Data></Cell>
	</Row>
    <cfset totalamt=totalamt+getroundadj.roundadj>
    <Row ss:AutoFitHeight="0" ss:Height="12">
		<Cell ss:StyleID="s32"><Data ss:Type="String">GRAND TOTAL</Data></Cell>
		<Cell ss:StyleID="s32"/>
		<Cell ss:StyleID="s32"/>
		<Cell ss:StyleID="s37"><Data ss:Type="Number"></Data></Cell>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalamt#</Data></Cell>
	</Row>
    </Table>
	</cfoutput>
	<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
	<Unsynced/>
	<Print>
	<ValidPrinterInfo/>
	<HorizontalResolution>600</HorizontalResolution>
	<VerticalResolution>600</VerticalResolution>
	</Print>
	<Selected/>
	<Panes>
	<Pane>
	<Number>3</Number>
	<ActiveRow>12</ActiveRow>
	<ActiveCol>1</ActiveCol>
	</Pane>
	</Panes>
	<ProtectObjects>False</ProtectObjects>
	<ProtectScenarios>False</ProtectScenarios>
	</WorksheetOptions>
	</Worksheet>
	</Workbook>
	</cfxml>

	<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\ProductR_PP_Type_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\ProductR_PP_Type_#huserid#.xls">
	</cfcase>

	<cfcase value="HTML">
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
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>PRODUCT SALES REPORT</strong></font></div></td>
		</tr>
        <tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Site : #getgeneral.site#</font></div></td>
			</tr>
		<cfif isdefined("form.periodfrom") and form.periodfrom neq "" and form.periodto neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
			</tr>
		</cfif>
		<cfif isdefined("form.datefrom") and form.datefrom neq "" and form.dateto neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #form.datefrom# - #form.dateto#</font></div></td>
			</tr>
		</cfif>
		
        <cfif trim(form.locfrom) neq "" and trim(form.locto) neq "">
			<tr>
			  <td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">LOCATION: #form.locfrom# - #form.locto#</font></div></td>
			</tr>
		</cfif>
		<tr>
			<td colspan="8"><font size="2" face="Times New Roman, Times, serif">
			  #getgeneral.compro#
			</font></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="1"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
		<tr>
       		<td><font size="2" face="Times New Roman, Times, serif">S/No</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">Item No</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">Item Desp</font></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Qty</font></div></td>
            <cfif lcase(hcomid) eq "gamemartz_i">
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Cost</font></div></td>
            </cfif>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Nett Sales</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Unit Price</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Retail Price</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Discount %</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Discount Amount</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Category</font></div></td>
           
             <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Outlet</font></div></td>
		</tr>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
		<cfset i=1>
		<cfset totalqty = 0>
		<cfset totalamt = 0>
		<cfquery name="getgroup" datasource="#dts#">
		select b.itemno,sum(a.it_cos) as it_cos, b.desp,a.refno,b.category,a.location,sum(a.qty) as qty,sum(a.amt) as amt,sum(a.disamt) as disamt,b.price from ictran a, icitem b
		where (type = 'INV' or type = 'CS')  and b.itemno = a.itemno and (void = '' or void is null)
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and a.fperiod+0 >= '#form.periodfrom#' and a.fperiod+0 <= '#form.periodto#'
		</cfif>
        <cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and a.itemno >='#form.itemfrom#' and a.itemno <= '#form.itemto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
		<cfelse>
		and a.wos_date > #getgeneral.lastaccyear#
		</cfif>
        <cfif form.locfrom neq "" and form.locto neq "">
				and a.location >= '#form.locfrom#' and a.location <= '#form.locto#'
				</cfif>
        <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				and a.custno >='#form.custfrom#' and a.custno <= '#form.custto#'
				</cfif>
		group by a.itemno,a.location order by a.location,a.itemno
	</cfquery>
		<cfloop query="getgroup">
        
        
				<cfset totalqty = totalqty + val(getgroup.qty)>
				<cfset totalamt = totalamt + val(getgroup.amt)>
            <tr>
					<td><font size="2" face="Times New Roman, Times, serif">#i#</font></td>
					<td><font size="2" face="Times New Roman, Times, serif">#getgroup.itemno#</font></td>
					<td><font size="2" face="Times New Roman, Times, serif">#getgroup.desp#</font></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getgroup.qty#</font></div></td>
            <cfif lcase(hcomid) eq "gamemartz_i">
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.it_cos,',_.__')#</font></div></td>
            </cfif>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.amt,',_.__')#</font></div></td>
            
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif getgroup.qty neq 0>#numberformat(getgroup.amt/getgroup.qty,',_.__')#</cfif></font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.price,',_.__')#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif (getgroup.amt+getgroup.disamt) neq 0>#numberformat((getgroup.disamt/(getgroup.amt+getgroup.disamt))*100,'__')#%<cfelse>0%</cfif></font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getgroup.disamt,',_.__')#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getgroup.category#</font></div></td>
             <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getgroup.location#</font></div></td>
			</tr>
			<cfset i=i+1>
		</cfloop>
        <cfquery name="getroundadj" datasource="#dts#">
        select ifnull(sum(roundadj),0) as roundadj from artran
        where (type = 'INV' or type = 'CS') and (void = '' or void is null)
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
		<cfelse>
		and wos_date > #getgeneral.lastaccyear#
		</cfif>
        <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				and custno >='#form.custfrom#' and custno <= '#form.custto#'
		</cfif>
        <cfif form.locfrom neq "" and form.locto neq "">
			and refno in (select refno from ictran where location >= '#form.locfrom#' and location <= '#form.locto#' group by refno)
		</cfif>
        </cfquery>
        
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
        <tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
			<td colspan="2"></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalqty,"0")#</strong></font></div></td>
			<cfif lcase(hcomid) eq "gamemartz_i">
            <td></td>
            </cfif>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalamt,",.__")#</strong></font></div></td>
		</tr>
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Rounding Adjustment:</strong></font></div></td>
			<td colspan="2"></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong></strong></font></div></td>
			<cfif lcase(hcomid) eq "gamemartz_i">
            <td></td>
            </cfif>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(getroundadj.roundadj,",.__")#</strong></font></div></td>
		</tr>
        <cfset totalamt=totalamt+getroundadj.roundadj>
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>GRAND TOTAL:</strong></font></div></td>
			<td colspan="2"></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong></strong></font></div></td>
			<cfif lcase(hcomid) eq "gamemartz_i">
            <td></td>
            </cfif>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalamt,",.__")#</strong></font></div></td>
		</tr>
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
	</cfcase>
</cfswitch>
