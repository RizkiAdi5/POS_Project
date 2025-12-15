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

	<cfquery name="getgroup" datasource="#dts#">
		select b.wos_group, b.desp from ictran a, icitem b
		where (type = 'PR' or type = 'RC') and b.itemno = a.itemno and (void = '' or void is null)
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and b.category >='#form.catefrom#' and b.category <='#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and b.wos_group >='#form.groupfrom#' and b.wos_group <='#form.groupto#'
		</cfif>
        and a.custno<>'assm/999'
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
		group by b.wos_group order by b.wos_group
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
	<Worksheet ss:Name="PURCHASE REPORT BY TYPE">
	<cfoutput>
	<Table ss:ExpandedColumnCount="12" x:FullColumns="1" x:FullRows="1">
	<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="80.5" ss:Span="4"/>

	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s22"><Data ss:Type="String">#trantype# REPORT (By Type)</Data></Cell>
	</Row>

	<cfif isdefined("form.periodfrom") and form.periodfrom neq "" and form.periodto neq "">
		<cfwddx action = "cfml2wddx" input = "PERIOD: #form.periodfrom# - #form.periodto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif isdefined("form.datefrom") and form.datefrom neq "" and form.dateto neq "">
		<cfwddx action = "cfml2wddx" input = "DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#" output = "wddxText">
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

	<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="5" ss:StyleID="s26"><Data ss:Type="String"><cfif getgeneral.compro neq "">#getgeneral.compro# </cfif></Data></Cell>
		<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
	</Row>

	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:StyleID="s27"><Data ss:Type="String">Item No.</Data></Cell>
		<cfif lcase(hcomid) eq "vsolutionspteltd_i">
		<Cell ss:StyleID="s27"><Data ss:Type="String">Product Code</Data></Cell>
		</cfif>
		<Cell ss:StyleID="s27"><Data ss:Type="String">ITEM DESP</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">U/M</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">QTY PURCHASED</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">RC</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">PR</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">NET</Data></Cell>
		<cfif lcase(hcomid) eq "vsolutionspteltd_i">
			<Cell ss:StyleID="s27"><Data ss:Type="String">Foriegn curr code</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Foriegn RC</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Foriegn PR</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Foriegn Net</Data></Cell>
		</cfif>
	</Row>


	<cfif lcase(hcomid) eq "vsolutionspteltd_i">
	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:StyleID="s27"><Data ss:Type="String"></Data></Cell>
		<cfif lcase(hcomid) eq "vsolutionspteltd_i">
		<Cell ss:StyleID="s27"><Data ss:Type="String"></Data></Cell>
		</cfif>
		<Cell ss:StyleID="s27"><Data ss:Type="String"></Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String"></Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String"></Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">SGD</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">SGD</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">SGD</Data></Cell>
		
	</Row>
	</cfif>
	<cfset totalqty = 0>
	<cfset totalrcamt = 0>
	<cfset totalrcbil = 0>
	<cfset totalpramt = 0>
	<cfset totalprbil = 0>
	<cfset totalrcamt_bil = 0>
	<cfset totalpramt_bil = 0>
	<cfloop query="getgroup">

		<Row ss:AutoFitHeight="0" ss:Height="12">
			<cfif getgroup.wos_group eq "">
				<Cell ss:StyleID="s34"><Data ss:Type="String">GROUP: No - Grouped</Data></Cell>
				<Cell ss:StyleID="s34"><Data ss:Type="String">No - Grouped</Data></Cell>
			<cfelse>
				<cfquery name="getgroupname" datasource="#dts#">
					select * from icgroup where wos_group = '#getgroup.wos_group#'
				</cfquery>

				<cfwddx action = "cfml2wddx" input = "GROUP: #getgroup.wos_group#" output = "wddxText1">
				<cfwddx action = "cfml2wddx" input = "#getgroupname.desp#" output = "wddxText2">
				<Cell ss:StyleID="s34"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:StyleID="s34"><Data ss:Type="String">#wddxText2#</Data></Cell>
			</cfif>
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
		</Row>

		<cfquery name="getitem" datasource="#dts#">
			select b.itemno, b.desp, b.unit,b.aitemno,b.fcurrcode from ictran a, icitem b
			where (a.type = 'PR' or a.type = 'RC') and b.wos_group = '#getgroup.wos_group#' and b.itemno = a.itemno and (void = '' or void is null)
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			and b.category >='#form.catefrom#' and b.category <='#form.cateto#'
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			and b.itemno >='#form.itemfrom#' and b.itemno <= '#form.itemto#'
			</cfif>
            and a.custno<>'assm/999'
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and a.fperiod+0 >= '#form.periodfrom#' and a.fperiod+0 <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
			<cfelse>
			and a.wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by b.itemno order by b.itemno
		</cfquery>

		<cfset subqty = 0>
		<cfset subrcamt = 0>
		<cfset subpramt = 0>
		<cfset subrcamt_bil = 0>
		<cfset subpramt_bil = 0>

		<cfloop query="getitem">
			<cfquery name="getrc" datasource="#dts#">
				select sum(qty) as sumqty, sum(amt) as sumamt, sum(amt_bil) as sumamt_bil from ictran
				where type = 'RC' and itemno = '#getitem.itemno#' and (void = '' or void is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
				</cfif>
                and custno<>'assm/999'
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				order by itemno
			</cfquery>

			<cfquery name="getpr" datasource="#dts#">
				select sum(qty) as sumqty, sum(amt) as sumamt, sum(amt_bil) as sumamt_bil from ictran
				where type = 'PR' and itemno = '#getitem.itemno#' and (void = '' or void is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
				</cfif>
                and custno<>'assm/999'
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				order by itemno
			</cfquery>

			<cfset subqty = subqty + (val(getrc.sumqty) - val(getpr.sumqty))>
			<cfset subrcamt = subrcamt + val(getrc.sumamt)>
			<cfset subpramt = subpramt + val(getpr.sumamt)>
			<cfset totalqty = totalqty + (val(getrc.sumqty) - val(getpr.sumqty))>
			<cfset totalrcamt = totalrcamt + val(getrc.sumamt)>
			<cfset totalpramt = totalpramt + val(getpr.sumamt)>

			<cfset subrcamt_bil = subrcamt_bil + val(getrc.sumamt_bil)>
				<cfset subpramt_bil = subpramt_bil + val(getpr.sumamt_bil)>
				<cfset totalrcamt_bil = totalrcamt_bil + val(getrc.sumamt_bil)>
				<cfset totalpramt_bil = totalpramt_bil + val(getpr.sumamt_bil)>

			<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText1">
			<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText2">
			<cfwddx action = "cfml2wddx" input = "#getitem.unit#" output = "wddxText3">
			<cfwddx action = "cfml2wddx" input = "#getitem.aitemno#" output = "wddxText4">
			<cfwddx action = "cfml2wddx" input = "#getitem.fcurrcode#" output = "wddxText5">

			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<cfif lcase(hcomid) eq "vsolutionspteltd_i">
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText4#</Data></Cell>
				</cfif>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText3#</Data></Cell>
				
				<Cell ss:StyleID="s35"><Data ss:Type="Number">#(val(getrc.sumqty) - val(getpr.sumqty))#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#getrc.sumamt#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#getpr.sumamt#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#(subrcamt - subpramt)#</Data></Cell>
				<cfif lcase(hcomid) eq "vsolutionspteltd_i">
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText5#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#getrc.sumamt_bil#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#getpr.sumamt_bil#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#(subrcamt_bil - subpramt_bil)#</Data></Cell>
					
				</cfif>

			</Row>
		</cfloop>

		<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s30"><Data ss:Type="String">SUB-TOTAL</Data></Cell>
			<cfif lcase(hcomid) eq "vsolutionspteltd_i">
			<Cell ss:StyleID="s30"/>
			
			</cfif>
			<Cell ss:StyleID="s30"/>
			<Cell ss:StyleID="s30"/>
			<Cell ss:StyleID="s36"><Data ss:Type="Number">#subqty#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#subrcamt#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#subpramt#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#(subrcamt - subpramt)#</Data></Cell>
			<cfif lcase(hcomid) eq "vsolutionspteltd_i">
			<Cell ss:StyleID="s30"/>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#subrcamt_bil#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#subpramt_bil#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#(subrcamt_bil - subpramt_bil)#</Data></Cell>
			</cfif>			

		</Row>
		<Row ss:AutoFitHeight="0" ss:Height="12"/>
	</cfloop>
	<Row ss:AutoFitHeight="0" ss:Height="12">
		<Cell ss:StyleID="s32"><Data ss:Type="String">TOTAL</Data></Cell>
		<Cell ss:StyleID="s32"/>
		<cfif lcase(hcomid) eq "vsolutionspteltd_i">
		<Cell ss:StyleID="s32"/>
		</cfif>
		<Cell ss:StyleID="s32"/>
		<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalqty#</Data></Cell>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalrcamt#</Data></Cell>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalpramt#</Data></Cell>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#(totalrcamt - totalpramt)#</Data></Cell>
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
<!---
	<cffile action="write" nameconflict="overwrite" file="C:\Inetpub\wwwroot\WOS\Excel_Report\#dts#\ProductR_PP_Type_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="C:\Inetpub\wwwroot\WOS\Excel_Report\#dts#\ProductR_PP_Type_#huserid#.xls">
--->
	</cfcase>

	<cfcase value="HTML">
	<html>
	<head>
	<title>Product Purchase Report By Type</title>
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

	<cfquery name="getgroup" datasource="#dts#">
		select b.wos_group, b.desp from ictran a, icitem b
		where (type = 'PR' or type = 'RC') and b.itemno = a.itemno and (void = '' or void is null)
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and b.category >='#form.catefrom#' and b.category <='#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and b.wos_group >='#form.groupfrom#' and b.wos_group <='#form.groupto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and b.itemno >='#form.itemfrom#' and b.itemno <= '#form.itemto#'
		</cfif>
        and a.custno<>'assm/999'
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and a.fperiod+0 >= '#form.periodfrom#' and a.fperiod+0 <= '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
		<cfelse>
		and a.wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by b.wos_group order by b.wos_group
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
		<cfif isdefined("form.catefrom") and trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			<tr>
			  <td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATEGORY: #form.catefrom# - #form.cateto#</font></div></td>
			</tr>
		</cfif>
		<cfif isdefined("form.groupfrom") and trim(form.groupfrom )neq "" and trim(form.groupto) neq "">
			<tr>
			  <td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
			</tr>
		</cfif>
		<cfif isdefined("form.itemfrom") and trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			<tr>
			  <td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM NO: #form.itemfrom# - #form.itemto#</font></div></td>
			</tr>
		</cfif>
		<tr>
			<td colspan="3"><font size="2" face="Times New Roman, Times, serif">
			<cfif getgeneral.compro neq "">
			  #getgeneral.compro#
			</cfif>
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
			<td><font size="2" face="Times New Roman, Times, serif">ITEM NO.</font></td>
			<cfif lcase(hcomid) eq "vsolutionspteltd_i">
			<td><font size="2" face="Times New Roman, Times, serif">PRODUCT CODE.</font></td>
			</cfif>
			<td><font size="2" face="Times New Roman, Times, serif">ITEM DESP</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">U/M</font></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY PURCHASED</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">RC</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">PR</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">NET</font></div></td>
			<cfif lcase(hcomid) eq "vsolutionspteltd_i">
			<td><font size="2" face="Times New Roman, Times, serif">Foriegn curr code</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">Foriegn RC</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">Foriegn PR</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">Foriegn Net</font></td>
			</cfif>
		</tr>

		<cfif lcase(hcomid) eq "vsolutionspteltd_i">
		<tr>
			
			<td><font size="2" face="Times New Roman, Times, serif"></font></td>
			<cfif lcase(hcomid) eq "vsolutionspteltd_i">
			<td><font size="2" face="Times New Roman, Times, serif"></font></td>
			</cfif>
			<td><font size="2" face="Times New Roman, Times, serif"></font></td>
			<td><font size="2" face="Times New Roman, Times, serif"></font></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SGD</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SGD</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SGD</font></div></td>
		</tr>
		</cfif>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>

		<cfset totalqty = 0>
		<cfset totalrcamt = 0>
		<cfset totalrcbil = 0>
		<cfset totalpramt = 0>
		<cfset totalprbil = 0>
		
				<cfset totalrcamt_bil = 0>
				<cfset totalpramt_bil = 0>

		<cfloop query="getgroup">
			<tr>
				<cfif getgroup.wos_group eq "">
					<td><font size="2" face="Times New Roman, Times, serif"><strong><u>GROUP: No - Grouped</u></strong></font></td>
					<td><font size="2" face="Times New Roman, Times, serif"><strong><u>No - Grouped</u></strong></font></td>
				<cfelse>
					<cfquery name="getgroupname" datasource="#dts#">
						select * from icgroup where wos_group = '#getgroup.wos_group#'
					</cfquery>
					<td><font size="2" face="Times New Roman, Times, serif"><strong><u>GROUP: #getgroup.wos_group#</u></strong></font></td>
					<td><font size="2" face="Times New Roman, Times, serif"><strong><u>#getgroupname.desp#</u></strong></font></td>
				</cfif>
			</tr>
			<!--- MODIFIED ON 030608, IN THE QUERY, CONVERT THE FPERIOD COLUMN (VARCHAR) TO INTEGER WITH ADD +0 BEHIND THE COLUMN NAME  
					IF THE COLUMN TYPE IS VACHAR, THE COMPUETR WILL COMPARE THE FPERIOD LIKE COMPARE THE STRING --->
			<cfquery name="getitem" datasource="#dts#">
				select b.itemno, b.desp, b.unit,B.AITEMNO,b.fcurrcode from ictran a, icitem b
				where (a.type = 'PR' or a.type = 'RC') and b.wos_group = '#getgroup.wos_group#' and b.itemno = a.itemno and (void = '' or void is null)
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and b.category >='#form.catefrom#' and b.category <='#form.cateto#'
				</cfif>
				<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				and b.itemno >='#form.itemfrom#' and b.itemno <= '#form.itemto#'
				</cfif>
                and a.custno<>'assm/999'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and a.fperiod+0 >= '#form.periodfrom#' and a.fperiod+0 <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
				<cfelse>
				and a.wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by b.itemno order by b.itemno
			</cfquery>

			<cfset subqty = 0>
			<cfset subrcamt = 0>
			<cfset subpramt = 0>
			<cfset subrcamt_bil = 0>
			<cfset subpramt_bil = 0>

			<cfloop query="getitem">
				<cfquery name="getrc" datasource="#dts#">
					select sum(qty) as sumqty, sum(amt) as sumamt, sum(amt_bil) as sumamt_bil from ictran
					where type = 'RC' and itemno = '#getitem.itemno#' and (void = '' or void is null)
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
					</cfif>
                    and custno<>'assm/999'
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
					order by itemno
				</cfquery>

				<cfquery name="getpr" datasource="#dts#">
					select sum(qty) as sumqty, sum(amt) as sumamt, sum(amt_bil) as sumamt_bil from ictran
					where type = 'PR' and itemno = '#getitem.itemno#' and (void = '' or void is null)
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
					</cfif>
                    and custno<>'assm/999'
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
					order by itemno
				</cfquery>

				<cfset subqty = subqty + (val(getrc.sumqty) - val(getpr.sumqty))>
				<cfset subrcamt = subrcamt + val(getrc.sumamt)>
				<cfset subpramt = subpramt + val(getpr.sumamt)>
				<cfset totalqty = totalqty + (val(getrc.sumqty) - val(getpr.sumqty))>
				<cfset totalrcamt = totalrcamt + val(getrc.sumamt)>
				<cfset totalpramt = totalpramt + val(getpr.sumamt)>

				<cfset subrcamt_bil = subrcamt_bil + val(getrc.sumamt_bil)>
				<cfset subpramt_bil = subpramt_bil + val(getpr.sumamt_bil)>
				<cfset totalrcamt_bil = totalrcamt_bil + val(getrc.sumamt_bil)>
				<cfset totalpramt_bil = totalpramt_bil + val(getpr.sumamt_bil)>

				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<td><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></td>
					<cfif lcase(hcomid) eq "vsolutionspteltd_i">
					<td><font size="2" face="Times New Roman, Times, serif">#getitem.aitemno#</font></td>
					</cfif>
					<td><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></td>
					<td><font size="2" face="Times New Roman, Times, serif">#getitem.unit#</font></td>
					
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getrc.sumqty) - val(getpr.sumqty),"0")#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getrc.sumamt),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getpr.sumamt),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subrcamt - subpramt,stDecl_UPrice)#</font></div></td>
					<cfif lcase(hcomid) eq "vsolutionspteltd_i">
					<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getitem.fcurrcode#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getrc.sumamt_bil),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getpr.sumamt_bil),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subrcamt_bil - subpramt_bil,stDecl_UPrice)#</font></div></td>
					</cfif>
				</tr>

			</cfloop>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td colspan="1"></td>
				<td><font size="2" face="Times New Roman, Times, serif">SUB-TOTAL</font></td>
				<td colspan="1"></td>
				<cfif lcase(hcomid) eq "vsolutionspteltd_i">
				<td colspan="1"></td>
				
				</cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subqty,"0")#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subrcamt,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subpramt,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subrcamt - subpramt,stDecl_UPrice)#</font></div></td>
				<cfif lcase(hcomid) eq "vsolutionspteltd_i">
				<td colspan="1"></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subrcamt_bil,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subpramt_bil,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subrcamt_bil - subpramt_bil,stDecl_UPrice)#</font></div></td>
				</cfif>

			</tr>
			<tr><td><br></td></tr>
		</cfloop>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
		<tr>
			<td colspan="1"></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
			<td colspan="1"></td>
			<cfif lcase(hcomid) eq "vsolutionspteltd_i">
				<td colspan="1"></td>
				</cfif>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalqty,"0")#</strong></font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalrcamt,",.__")#</strong></font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalpramt,",.__")#</strong></font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalrcamt - totalpramt,",.__")#</strong></font></div></td>
<!---
			<cfif lcase(hcomid) eq "vsolutionspteltd_i">
			<td colspan="1"></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalrcamt_bil,",.__")#</strong></font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalpramt_bil,",.__")#</strong></font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalrcamt_bil - totalpramt_bil,",.__")#</strong></font></div></td>
			</cfif>--->
		</tr>
	  </table>

	<cfif getgroup.recordcount eq 0>
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
