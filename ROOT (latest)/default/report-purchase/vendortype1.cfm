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

<cfswitch expression="#form.result#">
	<cfcase value="EXCELDEFAULT">

	<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
	<cfset stDecl_UPrice = "">

	<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		<cfset stDecl_UPrice = stDecl_UPrice & "0">
	</cfloop>

	<cfquery name="getsupp" datasource="#dts#">
		select custno,name from ictran
		where (type = 'PR' or type = 'RC') and (void = '' or void is null) and (linecode ='' or linecode is null) and itemno not in (select servi from icservi) 
		<cfif form.agentfrom neq "" and form.agentto neq "">
		and agenno >='#form.agentfrom#' and agenno <='#form.agentto#'
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
		and area >='#form.areafrom#' and area <='#form.areato#'
		</cfif>
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		and custno >='#form.suppfrom#' and custno <= '#form.suppto#'
		</cfif>
        and custno<>'assm/999'
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
		<cfelse>
		and wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by custno
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
	<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim('.00')#</cfoutput>"/>
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
	<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim('.00')#</cfoutput>"/>
	</Style>
	<Style ss:ID="s32">
	<Borders>
	<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	</Borders>
	<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
	</Style>
	<Style ss:ID="s33">
	<Borders>
	<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
	</Borders>
	<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim('.00')#</cfoutput>"/>
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
	<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
	</Borders>
	<NumberFormat ss:Format="0"/>
	</Style>
	</Styles>
	<Worksheet ss:Name="PURCHASE REPORT BY TYPE">
	<cfoutput>
	<Table ss:ExpandedColumnCount="11" x:FullColumns="1" x:FullRows="1">
	<Column ss:AutoFitWidth="0" ss:Width="85.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="180.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="75.5" ss:Span="5"/>

	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:MergeAcross="7" ss:StyleID="s22"><Data ss:Type="String">#trantype# REPORT (By Type)</Data></Cell>
	</Row>

	<cfif isdefined("form.periodfrom") and form.periodfrom neq "" and form.periodto neq "">
	<cfwddx action = "cfml2wddx" input = "PERIOD: #form.periodfrom# - #form.periodto#" output = "wddxText">
		<Row ss:Height="15">
		<Cell ss:MergeAcross="7" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
   	<cfif isdefined("form.datefrom") and form.datefrom neq "" and form.dateto neq "">
		<cfwddx action = "cfml2wddx" input = "DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#" output = "wddxText">
		<Row ss:Height="15">
		<Cell ss:MergeAcross="7" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif isdefined("form.agentfrom") and form.agentfrom neq "" and form.agentto neq "">
		<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
		<Row ss:Height="15">
		<Cell ss:MergeAcross="7" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif isdefined("form.areafrom") and form.areafrom neq "" and form.areato neq "">
		<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
		<Row ss:Height="15">
		<Cell ss:MergeAcross="7" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>

	<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s26"><Data ss:Type="String"><cfif getgeneral.compro neq "">#getgeneral.compro#</cfif></Data></Cell>
		<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
	</Row>

	<cfif isdefined("form.showqty") and form.showqty eq "yes">
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:StyleID="s27"><Data ss:Type="String">VEND NO.</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">NAME</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">RC(AMT)</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">RC(QTY)</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">PR(AMT)</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">PR(QTY)</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">NET(AMT)</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">NET(QTY)</Data></Cell>
		</Row>
	<cfelse>
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:StyleID="s27"><Data ss:Type="String">VEND NO.</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">NAME</Data></Cell>
             <cfif lcase(hcomid) eq "vsolutionspteltd_i">
            <Cell ss:StyleID="s27"><Data ss:Type="String">FOREIGN RC(AMT)</Data></Cell>
            <Cell ss:StyleID="s27"><Data ss:Type="String">FOREIGN PR(AMT)</Data></Cell>
            <Cell ss:StyleID="s27"><Data ss:Type="String">FOREIGN NET(AMT)</Data></Cell>
            </cfif>
			<Cell ss:StyleID="s27"><Data ss:Type="String">RC(AMT)</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">PR(AMT)</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">NET(AMT)</Data></Cell>
           
			<Cell ss:StyleID="s27"/>
			<Cell ss:StyleID="s27"/>
			<Cell ss:StyleID="s27"/>
		</Row>
	</cfif>

	<cfset totalrcqty = 0>
	<cfset totalprqty = 0>
	<cfset totalrcamt = 0>
	<cfset totalpramt = 0>

	<cfloop query="getsupp">
		<cfquery name="getrc" datasource="#dts#">
			select sum(qty) as sumqty, sum(amt) as sumamt,sum(amt_bil) as sumamt_bil from ictran
			where type = 'RC' and custno = '#getsupp.custno#' and (void = '' or void is null) and (linecode ='' or linecode is null) and itemno not in (select servi from icservi)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <='#form.agentto#'
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
			and area >='#form.areafrom#' and area <='#form.areato#'
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			order by itemno
		</cfquery>

		<cfquery name="getpr" datasource="#dts#">
			select sum(qty) as sumqty, sum(amt) as sumamt,sum(amt_bil) as sumamt_bil from ictran
			where type = 'PR' and custno = '#getsupp.custno#' and (void = '' or void is null) and (linecode ='' or linecode is null) and itemno not in (select servi from icservi)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <='#form.agentto#'
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
			and area >='#form.areafrom#' and area <='#form.areato#'
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			order by itemno
		</cfquery>

		<cfset totalrcqty = totalrcqty + val(getrc.sumqty)>
		<cfset totalprqty = totalprqty + val(getpr.sumqty)>
		<cfset totalrcamt = totalrcamt + val(getrc.sumamt)>
		<cfset totalpramt = totalpramt + val(getpr.sumamt)>

		<cfwddx action = "cfml2wddx" input = "#getsupp.custno#" output = "wddxText1">
		<cfwddx action = "cfml2wddx" input = "#getsupp.name#" output = "wddxText2">

		<cfif isdefined("form.showqty") and form.showqty eq "yes">
			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#getrc.sumamt#</Data></Cell>
				<Cell ss:StyleID="s35"><Data ss:Type="Number">#getrc.sumqty#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#getpr.sumamt#</Data></Cell>
				<Cell ss:StyleID="s35"><Data ss:Type="Number">#getpr.sumqty#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#(val(getrc.sumamt) - val(getpr.sumamt))#</Data></Cell>
				<Cell ss:StyleID="s35"><Data ss:Type="Number">#(val(getrc.sumqty) - val(getpr.sumqty))#</Data></Cell>
			</Row>
		<cfelse>
			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
                <cfif lcase(hcomid) eq "vsolutionspteltd_i">
                <Cell ss:StyleID="s29"><Data ss:Type="Number">#getrc.sumamt_bil#</Data></Cell>
                <Cell ss:StyleID="s29"><Data ss:Type="Number">#getpr.sumamt_bil#</Data></Cell>
                <Cell ss:StyleID="s29"><Data ss:Type="Number">#(val(getrc.sumamt_bil) - val(getpr.sumamt_bil))#</Data></Cell>
                </cfif>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#getrc.sumamt#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#getpr.sumamt#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#(val(getrc.sumamt) - val(getpr.sumamt))#</Data></Cell>
                
				<Cell ss:StyleID="s29"/>
				<Cell ss:StyleID="s29"/>
				<Cell ss:StyleID="s29"/>
			</Row>
		</cfif>
	</cfloop>

	<cfif isdefined("form.showqty") and form.showqty eq "yes">
		<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s32"><Data ss:Type="String">TOTAL:</Data></Cell>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalrcamt#</Data></Cell>
			<Cell ss:StyleID="s36"><Data ss:Type="Number">#totalrcqty#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalpramt#</Data></Cell>
			<Cell ss:StyleID="s36"><Data ss:Type="Number">#totalprqty#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#(totalrcamt - totalpramt)#</Data></Cell>
			<Cell ss:StyleID="s36"><Data ss:Type="Number">#(totalrcqty - totalprqty)#</Data></Cell>
		</Row>
	<cfelse>
		<Row ss:AutoFitHeight="0" ss:Height="12">
        <Cell ss:StyleID="s32"/>
        <Cell ss:StyleID="s32"/>
        <Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"><Data ss:Type="String">TOTAL:</Data></Cell>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalrcamt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalpramt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#(totalrcamt - totalpramt)#</Data></Cell>
			<Cell ss:StyleID="s33"/>
			<Cell ss:StyleID="s33"/>
			<Cell ss:StyleID="s33"/>
		</Row>
	</cfif>
  </Table>
	<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
	<Print>
	<ValidPrinterInfo/>
	<Scale>80</Scale>
	<HorizontalResolution>600</HorizontalResolution>
	<VerticalResolution>600</VerticalResolution>
	<Gridlines/>
	</Print>
	<Selected/>
	<Panes>
	<Pane>
	<Number>3</Number>
	<ActiveRow>2</ActiveRow>
	<RangeSelection>R3C1:R3C5</RangeSelection>
	</Pane>
	</Panes>
	<ProtectObjects>False</ProtectObjects>
	<ProtectScenarios>False</ProtectScenarios>
	</WorksheetOptions>
	</Worksheet>
	</Workbook>
	</cfoutput>
	</cfxml>

	<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls" output="#tostring(data)#" charset="utf-8">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls">
<!---
	<cffile action="write" nameconflict="overwrite" file="C:\Inetpub\wwwroot\WOS\Excel_Report\#dts#\ProductR_VS_Type_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="C:\Inetpub\wwwroot\WOS\Excel_Report\#dts#\ProductR_VS_Type_#huserid#.xls">
--->
	</cfcase>

	<cfcase value="HTML">
	<html>
	<head>
	<title>Vendor Supply Purchase Report By Type</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
	<style type="text/css" media="print">
		.noprint { display: none; }
	</style>
	</head>

	<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
	<cfset stDecl_UPrice = ",___.">

	<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		<cfset stDecl_UPrice = stDecl_UPrice & "_">
	</cfloop>

	<cfquery name="getsupp" datasource="#dts#">
		select custno,name from artran
		where (type = 'PR' or type = 'RC') and (void = '' or void is null)
		<cfif form.agentfrom neq "" and form.agentto neq "">
		and agenno >='#form.agentfrom#' and agenno <='#form.agentto#'
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
		and area >='#form.areafrom#' and area <='#form.areato#'
		</cfif>
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		and custno >='#form.suppfrom#' and custno <= '#form.suppto#'
		</cfif>
        and custno<>'assm/999'
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
		<cfelse>
		and wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by custno
	</cfquery>

	<body>
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="9"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# REPORT (By Type)</strong></font></div></td>
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
		<cfif isdefined("form.agentfrom") and form.agentfrom neq "" and form.agentto neq "">
			<tr>
				<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
			</tr>
		</cfif>
		<cfif isdefined("form.areafrom") and form.areafrom neq "" and form.areato neq "">
			<tr>
				<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">AREA: #form.areafrom# - #form.areato#</font></div></td>
			</tr>
		</cfif>
		<tr>
			<td colspan="4"><font size="2" face="Times New Roman, Times, serif">
			<cfif getgeneral.compro neq "">
			  #getgeneral.compro#
			</cfif>
			</font></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		<tr>
			<td colspan="12"><hr></td>
		</tr>
		<tr>
			<td><font size="2" face="Times New Roman, Times, serif">VEND NO.</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">NAME</font></td>
            <cfif lcase(hcomid) eq "vsolutionspteltd_i">
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOREIGN CURRENCY</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOREIGN CURRENCY RC(AMT)</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOREIGN CURRENCY PR(AMT)</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOREIGN CURRENCY NET(AMT)</font></div></td>
            </cfif>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">RC(AMT)</font></div></td>
			<cfif isdefined("form.showqty") and form.showqty eq "yes">
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">RC(QTY)</font></div></td>
			</cfif>
            
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">PR(AMT)</font></div></td>
			<cfif isdefined("form.showqty") and form.showqty eq "yes">
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">PR(QTY)</font></div></td>
			</cfif>
            
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">NET(AMT)</font></div></td>
			<cfif isdefined("form.showqty") and form.showqty eq "yes">
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">NET(QTY)</font></div></td>
			</cfif>
            
		</tr>
		<tr>
			<td colspan="12"><hr></td>
		</tr>

		<cfset totalrcqty = 0>
		<cfset totalprqty = 0>
		<cfset totalrcamt = 0>
		<cfset totalpramt = 0>

		<cfloop query="getsupp">
			<cfquery name="getrc" datasource="#dts#">
				select sum(qty) as sumqty, sum(amt) as sumamt, sum(amt_bil) as sumamt_bil 
				from ictran
				where type = 'RC' and custno = '#getsupp.custno#' and (void = '' or void is null) and (linecode ='' or linecode is null) and itemno not in (select servi from icservi)
				<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno >='#form.agentfrom#' and agenno <='#form.agentto#'
				</cfif>
				<cfif form.areafrom neq "" and form.areato neq "">
					and area >='#form.areafrom#' and area <='#form.areato#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				order by itemno
			</cfquery>

			<cfquery name="getpr" datasource="#dts#">
				select sum(qty) as sumqty, sum(amt) as sumamt,sum(amt) as sumamt_bil 
				from ictran
				where type = 'PR' and custno = '#getsupp.custno#' and (void = '' or void is null) and (linecode ='' or linecode is null) and itemno not in (select servi from icservi)
				<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno >='#form.agentfrom#' and agenno <='#form.agentto#'
				</cfif>
				<cfif form.areafrom neq "" and form.areato neq "">
					and area >='#form.areafrom#' and area <='#form.areato#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				order by itemno
			</cfquery>

			<cfset totalrcqty = totalrcqty + val(getrc.sumqty)>
			<cfset totalprqty = totalprqty + val(getpr.sumqty)>
			<cfset totalrcamt = totalrcamt + val(getrc.sumamt)>
			<cfset totalpramt = totalpramt + val(getpr.sumamt)>
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><font size="2" face="Times New Roman, Times, serif">#getsupp.custno#</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#getsupp.name#</font></td>
                  <cfif lcase(hcomid) eq "vsolutionspteltd_i">
        <cfquery name="getcurrencycode" datasource="#dts#">
    select currcode from #target_apvend# where custno='#getsupp.custno#'
    </cfquery>
                <td><div align="right">#getcurrencycode.currcode#</div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getrc.sumamt_bil),'.00')#</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getpr.sumamt_bil),'.00')#</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getrc.sumamt_bil) - val(getpr.sumamt_bil),'.00')#</font></div></td>
                </cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getrc.sumamt),'.00')#</font></div></td>
				<cfif isdefined("form.showqty") and form.showqty eq "yes">
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getrc.sumqty),"0")#</font></div></td>
				</cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getpr.sumamt),'.00')#</font></div></td>
				<cfif isdefined("form.showqty") and form.showqty eq "yes">
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getpr.sumqty),"0")#</font></div></td>
				</cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getrc.sumamt) - val(getpr.sumamt),'.00')#</font></div></td>
				<cfif isdefined("form.showqty") and form.showqty eq "yes">
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getrc.sumqty) - val(getpr.sumqty),"0")#</font></div></td>
				</cfif>
                
			</tr>
		</cfloop>
		<tr>
			<td colspan="12"><hr></td>
		</tr>
		<tr>
      	<cfif lcase(hcomid) eq "vsolutionspteltd_i">
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        </cfif>
			<td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
			<td><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalrcamt,",.__")#</strong></font></div></td>
			<cfif isdefined("form.showqty") and form.showqty eq "yes">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalrcqty,"0")#</strong></font></div></td>
			</cfif>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalpramt,",.__")#</strong></font></div></td>
			<cfif isdefined("form.showqty") and form.showqty eq "yes">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalprqty,"0")#</strong></font></div></td>
			</cfif>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalrcamt - totalpramt,",.__")#</strong></font></div></td>
			<cfif isdefined("form.showqty") and form.showqty eq "yes">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalrcqty - totalprqty,"0")#</strong></font></div></td>
			</cfif>
		</tr>
	  </table>

	<cfif getsupp.recordcount eq 0>
		<h3>Sorry, No records were found.</h3>
		<cfabort>
	</cfif>
	</cfoutput>
	<br>
	<br>
	<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
	<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
	</body>
	</html>
	</cfcase>
</cfswitch>
