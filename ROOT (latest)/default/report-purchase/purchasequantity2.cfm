<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
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
		select a.wos_group,(select z.desp from icgroup z where a.wos_group=z.wos_group) as desp
		from icitem a,ictran b
		where a.itemno=b.itemno and (b.void = '' or b.void is null) and (b.type = 'RC' or b.type = 'PR')
		<cfif form.agentfrom neq "" and form.agentto neq "">
		and b.agenno between '#form.agentfrom#' and '#form.agentto#'
		</cfif>
        and b.custno<>'assm/999'
		<cfif form.areafrom neq "" and form.areato neq "">
		and b.area between '#form.areafrom#' and '#form.areato#'
		</cfif>
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		and b.custno between '#form.suppfrom#' and '#form.suppto#'
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and a.category between '#form.catefrom#' and '#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and a.itemno between '#form.itemfrom#' and '#form.itemto#'
		</cfif>
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and b.fperiod between '#form.periodfrom#' and '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and b.wos_date between '#ndatefrom#' and '#ndateto#'
		<cfelse>
		and b.wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by a.wos_group order by a.wos_group
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
	<Worksheet ss:Name="PURCHASE REPORT BY QUANTITY">
	<cfoutput>
	<Table ss:ExpandedColumnCount="6" x:FullColumns="1" x:FullRows="1">
	<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="80.5" ss:Span="3"/>

	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:MergeAcross="5" ss:StyleID="s22"><Data ss:Type="String">#trantype# (QUANTITY) PURCHASE REPORT</Data></Cell>
	</Row>

	<cfif form.periodfrom neq "" and form.periodto neq "">
		<cfwddx action = "cfml2wddx" input = "PERIOD: #form.periodfrom# - #form.periodto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif form.datefrom neq "" and form.dateto neq "">
		<cfwddx action = "cfml2wddx" input = "DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif form.agentfrom neq "" and form.agentto neq "">
		<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif form.areafrom neq "" and form.areato neq "">
		<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		<cfwddx action = "cfml2wddx" input = "SUPP_NO: #form.suppfrom# - #form.suppto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		<cfwddx action = "cfml2wddx" input = "CATEGORY: #form.catefrom# - #form.cateto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
	<cfwddx action = "cfml2wddx" input = "GROUP: #form.groupfrom# - #form.groupto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		<cfwddx action = "cfml2wddx" input = "ITEM_NO: #form.itemfrom# - #form.itemto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>

	<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="4" ss:StyleID="s26"><Data ss:Type="String">#getgeneral.compro#</Data></Cell>
		<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
	</Row>

	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:StyleID="s27"><Data ss:Type="String">VEND.NO/ITEM.NO</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">DESCRIPTION</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">QTY-RC</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">AMT-RC</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">QTY-PR</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">AMT-PR</Data></Cell>
	</Row>

	<cfset totalrcqty = 0>
	<cfset totalrcamt = 0>
	<cfset totalprqty = 0>
	<cfset totalpramt = 0>

	<cfloop query="getgroup">
		<cfset grouprcqty = 0>
		<cfset grouprcamt = 0>
		<cfset groupprqty = 0>
		<cfset grouppramt = 0>

		<Row ss:AutoFitHeight="0" ss:Height="12">
			<cfswitch expression="#getgroup.wos_group#">
				<cfcase value="">
					<Cell ss:StyleID="s34"><Data ss:Type="String">GROUP: Non-Grouped</Data></Cell>
					<Cell ss:StyleID="s34"><Data ss:Type="String">Non-Grouped</Data></Cell>
				</cfcase>

				<cfdefaultcase>
					<Cell ss:StyleID="s34"><Data ss:Type="String">GROUP: #getgroup.wos_group#</Data></Cell>
					<Cell ss:StyleID="s34"><Data ss:Type="String">#getgroup.desp#</Data></Cell>
				</cfdefaultcase>
			</cfswitch>
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
		</Row>

		<cfquery name="getitem" datasource="#dts#">
			select a.itemno,a.desp from icitem a, ictran b
			where a.wos_group='#getgroup.wos_group#' and (b.void = '' or b.void is null) and (b.type='RC' or b.type='PR')
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and b.agenno between '#form.agentfrom#' and '#form.agentto#'
			</cfif>
            and b.custno<>'assm/999'
			<cfif form.areafrom neq "" and form.areato neq "">
			and b.area between '#form.areafrom#' and '#form.areato#'
			</cfif>
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
			and b.custno between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			and a.itemno between '#form.itemfrom#' and '#form.itemto#'
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and b.fperiod between '#form.periodfrom#' and '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and b.wos_date between '#ndatefrom#' and '#ndateto#'
			<cfelse>
			and b.wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by a.itemno order by a.itemno
		</cfquery>

		<cfloop query="getitem">

			<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText1">
			<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText2">

			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
				<Cell ss:StyleID="s29"/>
				<Cell ss:StyleID="s29"/>
				<Cell ss:StyleID="s29"/>
				<Cell ss:StyleID="s29"/>
			</Row>

			<cfquery name="getsupp" datasource="#dts#">
				select a.custno,a.name,b.sumrcqty,b.sumrcamt,c.sumprqty,c.sumpramt from #target_apvend# as a
				left join
				(select custno,sum(qty) as sumrcqty,sum(amt) as sumrcamt from ictran
				where itemno='#getitem.itemno#' and (void = '' or void is null) and type='RC'
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno between '#form.agentfrom#' and '#form.agentto#'
				</cfif>
				<cfif form.areafrom neq "" and form.areato neq "">
				and area between '#form.areafrom#' and '#form.areato#'
				</cfif>
				<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and custno between '#form.suppfrom#' and '#form.suppto#'
				</cfif>
                and custno<>'assm/999'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date between '#ndatefrom#' and '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by custno order by custno)as b on a.custno=b.custno

				left join
				(select custno,sum(qty) as sumprqty,sum(amt) as sumpramt from ictran
				where itemno='#getitem.itemno#' and (void = '' or void is null) and type='PR'
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno between '#form.agentfrom#' and '#form.agentto#'
				</cfif>
                and custno<>'assm/999'
				<cfif form.areafrom neq "" and form.areato neq "">
				and area between '#form.areafrom#' and '#form.areato#'
				</cfif>
				<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and custno between '#form.suppfrom#' and '#form.suppto#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date between '#ndatefrom#' and '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by custno order by custno)as c on a.custno=c.custno

				where (b.sumrcqty<>'' or b.sumrcamt<>'' or c.sumprqty<>'' or c.sumpramt<>'') and a.custno<>''
				<cfif form.areafrom neq "" and form.areato neq "">
				and a.area between '#form.areafrom#' and '#form.areato#'
				</cfif>
				<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.custno between '#form.suppfrom#' and '#form.suppto#'
				</cfif>
                and a.custno<>'assm/999'
				group by a.custno order by a.custno
			</cfquery>

			<cfset subrcqty = 0>
			<cfset subrcamt = 0>
			<cfset subprqty = 0>
			<cfset subpramt = 0>

			<cfloop query="getsupp">
				<cfset subrcqty = subrcqty + val(getsupp.sumrcqty)>
				<cfset subrcamt = subrcamt + val(getsupp.sumrcamt)>
				<cfset subprqty = subprqty + val(getsupp.sumprqty)>
				<cfset subpramt = subpramt + val(getsupp.sumpramt)>
				<cfset grouprcqty = grouprcqty + val(getsupp.sumrcqty)>
				<cfset grouprcamt = grouprcamt + val(getsupp.sumrcamt)>
				<cfset groupprqty = groupprqty + val(getsupp.sumprqty)>
				<cfset grouppramt = grouppramt + val(getsupp.sumpramt)>
				<cfset totalrcqty = totalrcqty + val(getsupp.sumrcqty)>
				<cfset totalrcamt = totalrcamt + val(getsupp.sumrcamt)>
				<cfset totalprqty = totalprqty + val(getsupp.sumprqty)>
				<cfset totalpramt = totalpramt + val(getsupp.sumpramt)>

				<cfwddx action = "cfml2wddx" input = "#getsupp.custno#" output = "wddxText1">
				<cfwddx action = "cfml2wddx" input = "#getsupp.name#" output = "wddxText2">

				<Row ss:AutoFitHeight="0" ss:Height="12">
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
					<Cell ss:StyleID="s35"><Data ss:Type="Number">#getsupp.sumrcqty#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#getsupp.sumrcamt#</Data></Cell>
					<Cell ss:StyleID="s35"><Data ss:Type="Number">#getsupp.sumprqty#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#getsupp.sumpramt#</Data></Cell>
				</Row>
			</cfloop>
			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s36"><Data ss:Type="Number">#subrcqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#subrcamt#</Data></Cell>
				<Cell ss:StyleID="s36"><Data ss:Type="Number">#subprqty#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#subpramt#</Data></Cell>
			</Row>
			<Row ss:AutoFitHeight="0" ss:Height="12"/>
		</cfloop>
		<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s30"><Data ss:Type="String">GROUP TOTAL:</Data></Cell>
			<Cell ss:StyleID="s30"/>
			<Cell ss:StyleID="s36"><Data ss:Type="Number">#grouprcqty#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#grouprcamt#</Data></Cell>
			<Cell ss:StyleID="s36"><Data ss:Type="Number">#groupprqty#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#grouppramt#</Data></Cell>
		</Row>

	</cfloop>

	<Row ss:AutoFitHeight="0" ss:Height="12"/>
	<Row ss:AutoFitHeight="0" ss:Height="12">
		<Cell ss:StyleID="s32"/>
		<Cell ss:StyleID="s32"/>
		<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalrcqty#</Data></Cell>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalrcamt#</Data></Cell>
		<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalprqty#</Data></Cell>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalpramt#</Data></Cell>
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

	<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\ProductR_PV_Quantity_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\ProductR_PV_Quantity_#huserid#.xls">
<!---
	<cffile action="write" nameconflict="overwrite" file="C:\Inetpub\wwwroot\WOS\Excel_Report\#dts#\ProductR_PV_Quantity_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="C:\Inetpub\wwwroot\WOS\Excel_Report\#dts#\ProductR_PV_Quantity_#huserid#.xls">
--->
	</cfcase>

	<cfcase value="HTML">
	<html>
	<head>
	<title>Product - Vendor (Quantity) Purchase Report</title>
	<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
	<style type="text/css" media="print">
		.noprint { display: none; }
	</style>
	<style type="text/css">
		.borderformat {border-top-style:double;border-bottom-style:double;border-bottom-color:black;border-top-color:black}
	</style>
	</head>

	<body>

	<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
	<cfset stDecl_UPrice = ",___.">

	<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
	  <cfset stDecl_UPrice = stDecl_UPrice & "_">
	</cfloop>

	<cfquery name="getgroup" datasource="#dts#">
		select a.wos_group,(select z.desp from icgroup z where a.wos_group=z.wos_group) as desp
		from icitem a,ictran b
		where a.itemno=b.itemno and (b.void = '' or b.void is null) and (b.type = 'RC' or b.type = 'PR')
		<cfif form.agentfrom neq "" and form.agentto neq "">
		and b.agenno between '#form.agentfrom#' and '#form.agentto#'
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
		and b.area between '#form.areafrom#' and '#form.areato#'
		</cfif>
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		and b.custno between '#form.suppfrom#' and '#form.suppto#'
		</cfif>
        and b.custno<>'assm/999'
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and a.category between '#form.catefrom#' and '#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and a.itemno between '#form.itemfrom#' and '#form.itemto#'
		</cfif>
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and b.fperiod between '#form.periodfrom#' and '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and b.wos_date between '#ndatefrom#' and '#ndateto#'
		<cfelse>
		and b.wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by a.wos_group order by a.wos_group
	</cfquery>

	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="6"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# (QUANTITY) PURCHASE REPORT</strong></font></div></td>
		</tr>
		<cfif form.periodfrom neq "" and form.periodto neq "">
			<tr>
				<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
			</tr>
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
			<tr>
				<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
			</tr>
		</cfif>
		<cfif form.agentfrom neq "" and form.agentto neq "">
			<tr>
				<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
			</tr>
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
			<tr>
				<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">AREA: #form.areafrom# - #form.areato#</font></div></td>
			</tr>
		</cfif>
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
			<tr>
				<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">SUPP_NO: #form.suppfrom# - #form.suppto#</font></div></td>
			</tr>
		</cfif>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			<tr>
				<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATEGORY: #form.catefrom# - #form.cateto#</font></div></td>
			</tr>
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
			<tr>
				<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
			</tr>
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			<tr>
				<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM_NO: #form.itemfrom# - #form.itemto#</font></div></td>
			</tr>
		</cfif>
		<tr>
			<td colspan="2"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		<tr>
			<td colspan="6"><hr></td>
		</tr>
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">VEND.NO/ITEM.NO</font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DESCRIPTION</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY-RC</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">AMT-RC</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY-PR</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">AMT-PR</font></div></td>
		</tr>
		<tr>
			<td colspan="6"><hr></td>
		</tr>

		<cfset totalrcqty = 0>
		<cfset totalrcamt = 0>
		<cfset totalprqty = 0>
		<cfset totalpramt = 0>

		<cfloop query="getgroup">
			<cfset grouprcqty = 0>
			<cfset grouprcamt = 0>
			<cfset groupprqty = 0>
			<cfset grouppramt = 0>

			<tr>
				<cfswitch expression="#getgroup.wos_group#">
					<cfcase value="">
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>GROUP: Non-Grouped</strong></font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Non-Grouped</strong></font></div></td>
					</cfcase>

					<cfdefaultcase>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>GROUP: #getgroup.wos_group#</strong></font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>#getgroup.desp#</strong></font></div></td>
					</cfdefaultcase>
				</cfswitch>
			</tr>

			<cfquery name="getitem" datasource="#dts#">
				select a.itemno,a.desp from icitem a, ictran b
				where a.wos_group='#getgroup.wos_group#' and (b.void = '' or b.void is null) and (b.type='RC' or b.type='PR')
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and b.agenno between '#form.agentfrom#' and '#form.agentto#'
				</cfif>
				<cfif form.areafrom neq "" and form.areato neq "">
				and b.area between '#form.areafrom#' and '#form.areato#'
				</cfif>
				<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and b.custno between '#form.suppfrom#' and '#form.suppto#'
				</cfif>
                and b.custno<>'assm/999'
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
				</cfif>
				<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				and a.itemno between '#form.itemfrom#' and '#form.itemto#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and b.fperiod between '#form.periodfrom#' and '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and b.wos_date between '#ndatefrom#' and '#ndateto#'
				<cfelse>
				and b.wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by a.itemno order by a.itemno
			</cfquery>

			<cfloop query="getitem">
				<tr>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><u>#getitem.itemno#</u></font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><u>#getitem.desp#</u></font></div></td>
				</tr>

				<cfquery name="getsupp" datasource="#dts#">
					select a.custno,a.name,b.sumrcqty,b.sumrcamt,c.sumprqty,c.sumpramt from #target_apvend# as a
					left join
					(select custno,sum(qty) as sumrcqty,sum(amt) as sumrcamt from ictran
					where itemno='#getitem.itemno#' and (void = '' or void is null) and type='RC'
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between '#form.agentfrom#' and '#form.agentto#'
					</cfif>
					<cfif form.areafrom neq "" and form.areato neq "">
					and area between '#form.areafrom#' and '#form.areato#'
					</cfif>
					<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
					and custno between '#form.suppfrom#' and '#form.suppto#'
					</cfif>
                    and custno<>'assm/999'
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between '#form.periodfrom#' and '#form.periodto#'
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between '#ndatefrom#' and '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
					group by custno order by custno)as b on a.custno=b.custno

					left join
					(select custno,sum(qty) as sumprqty,sum(amt) as sumpramt from ictran
					where itemno='#getitem.itemno#' and (void = '' or void is null) and type='PR'
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between '#form.agentfrom#' and '#form.agentto#'
					</cfif>
					<cfif form.areafrom neq "" and form.areato neq "">
					and area between '#form.areafrom#' and '#form.areato#'
					</cfif>
					<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
					and custno between '#form.suppfrom#' and '#form.suppto#'
					</cfif>
                    and custno<>'assm/999'
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between '#form.periodfrom#' and '#form.periodto#'
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between '#ndatefrom#' and '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
					group by custno order by custno)as c on a.custno=c.custno

					where (b.sumrcqty<>'' or b.sumrcamt<>'' or c.sumprqty<>'' or c.sumpramt<>'') and a.custno<>''
					<cfif form.areafrom neq "" and form.areato neq "">
					and a.area between '#form.areafrom#' and '#form.areato#'
					</cfif>
					<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
					and a.custno between '#form.suppfrom#' and '#form.suppto#'
					</cfif>
                    and a.custno<>'assm/999'
					group by a.custno order by a.custno
				</cfquery>

				<cfset subrcqty = 0>
				<cfset subrcamt = 0>
				<cfset subprqty = 0>
				<cfset subpramt = 0>

				<cfloop query="getsupp">
					<cfset subrcqty = subrcqty + val(getsupp.sumrcqty)>
					<cfset subrcamt = subrcamt + val(getsupp.sumrcamt)>
					<cfset subprqty = subprqty + val(getsupp.sumprqty)>
					<cfset subpramt = subpramt + val(getsupp.sumpramt)>
					<cfset grouprcqty = grouprcqty + val(getsupp.sumrcqty)>
					<cfset grouprcamt = grouprcamt + val(getsupp.sumrcamt)>
					<cfset groupprqty = groupprqty + val(getsupp.sumprqty)>
					<cfset grouppramt = grouppramt + val(getsupp.sumpramt)>
					<cfset totalrcqty = totalrcqty + val(getsupp.sumrcqty)>
					<cfset totalrcamt = totalrcamt + val(getsupp.sumrcamt)>
					<cfset totalprqty = totalprqty + val(getsupp.sumprqty)>
					<cfset totalpramt = totalpramt + val(getsupp.sumpramt)>
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsupp.custno#</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsupp.name#</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#val(getsupp.sumrcqty)#</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getsupp.sumrcamt),stDecl_UPrice)#</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#val(getsupp.sumprqty)#</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getsupp.sumpramt),stDecl_UPrice)#</font></div></td>
					</tr>
				</cfloop>
				<tr>
					<td colspan="2"></td>
					<td colspan="4"><hr/></td>
				</tr>
				<tr>
					<td colspan="2"></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#subrcqty#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subrcamt,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#subprqty#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subpramt,stDecl_UPrice)#</font></div></td>
				</tr>
			</cfloop>
			<tr>
				<td colspan="2"></td>
				<td colspan="4"><hr/></td>
			</tr>
			<tr>
				<td></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">GROUP TOTAL:</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#grouprcqty#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grouprcamt,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#groupprqty#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(grouppramt,stDecl_UPrice)#</font></div></td>
			</tr>
		</cfloop>
		<tr>
			<td colspan="2"></td>
			<td colspan="4"><br/></td>
		</tr>
		<tr>
			<td colspan="2"></td>
			<td class="borderformat"><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#totalrcqty#</strong></font></div></td>
			<td class="borderformat"><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalrcamt,",.__")#</strong></font></div></td>
			<td class="borderformat"><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#totalprqty#</strong></font></div></td>
			<td class="borderformat"><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalpramt,",.__")#</strong></font></div></td>
		</tr>
	</table>
	</cfoutput>

	<cfif getgroup.recordcount eq 0>
		<h3>Sorry, No records were found.</h3>
	</cfif>

	<br>
	<br>
	<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
	<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
	</body>
	</html>
	</cfcase>
</cfswitch>