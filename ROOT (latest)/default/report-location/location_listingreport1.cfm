<cfif getpin2.h4G00 eq "T">
<script language="JavaScript"> 
var popup="Sorry, right-click is disabled.";
 function noway(go) { if 
(document.all) { if (event.button == 2) { alert(popup); return false; } } if (document.layers) 
{ if (go.which == 3) { alert(popup); return false; } } } if (document.layers) 
{ document.captureEvents(Event.MOUSEDOWN); } document.onmousedown=noway;
</script>
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select cost,compro,lastaccyear,singlelocation from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfparam name="ndatefrom" default="">
<cfparam name="ndateto" default="">
<cfparam name="row" default="0">

<cfif isdefined("form.datefrom") and isdefined("form.dateto")>
	<cfset dd=#dateformat(form.datefrom, "DD")#>
	<cfif dd greater than '12'>
		<cfset ndatefrom=#dateformat(form.datefrom,"YYYYMMDD")#>
	<cfelse>
		<cfset ndatefrom=#dateformat(form.datefrom,"YYYYDDMM")#>
	</cfif>

	<cfset dd=#dateformat(form.dateto, "DD")#>
	<cfif dd greater than '12'>
		<cfset ndateto=#dateformat(form.dateto,"YYYYMMDD")#>
	<cfelse>
		<cfset ndateto=#dateformat(form.dateto,"YYYYDDMM")#>
	</cfif>
</cfif>

<cfswitch expression="#form.result#">
	<cfcase value="EXCELDEFAULT">
	<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
	<cfset stDecl_UPrice = "">

	<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		<cfset stDecl_UPrice = stDecl_UPrice & "0">
	</cfloop>

	<cfif form.type eq "1">
		<cfquery name="getlocation" datasource="#dts#">
			select location from ictran where (type = 'INV' or type = 'DN' or type = 'CN' or type = 'CS') and (void = '' or void is null)
			<cfif form.productfrom neq "" and form.productto neq "">
			and itemno >= '#form.productfrom#' and itemno <= '#form.productto#'
			</cfif>
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            <cfif getgeneral.singlelocation eq 'Y'>
            <cfif form.locfrom neq "">
			and location = '#form.locfrom#'
			</cfif>
            <cfelse>
			<cfif form.locfrom neq "" and form.locto neq "">
			and location >= '#form.locfrom#' and location <= '#form.locto#'
			</cfif>
            </cfif>
			group by location order by location
		</cfquery>
	<cfelse>
		<cfquery name="getlocation" datasource="#dts#">
			select location from ictran where (type = 'RC' or type = 'PR') and (void = '' or void is null)
			<cfif form.productfrom neq "" and form.productto neq "">
			and itemno >= '#form.productfrom#' and itemno <= '#form.productto#'
			</cfif>
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            <cfif getgeneral.singlelocation eq 'Y'>
			<cfif form.locfrom neq "" and form.locto neq "">
			and location = '#form.locfrom#'
			</cfif>
            <cfelse>
            <cfif form.locfrom neq "" and form.locto neq "">
			and location >= '#form.locfrom#' and location <= '#form.locto#'
			</cfif>
            </cfif>
			group by location order by location
		</cfquery>
	</cfif>

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
	</Styles>
	<Worksheet ss:Name="ITEM SALES REPORT BY MONTH">
	<cfoutput>

	<cfif form.type eq "1">
		<Table ss:ExpandedColumnCount="7" x:FullColumns="1" x:FullRows="1">
		<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="80.5" ss:Span="4"/>

		<cfset ttinvamt = 0>
		<cfset ttcnamt = 0>
		<cfset ttdnamt = 0>
		<cfset ttcsamt = 0>
		<cfset ttnetamt = 0>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:MergeAcross="6" ss:StyleID="s22"><Data ss:Type="String">ITEM LOCATION #TYPENAME# REPORT</Data></Cell>
		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s26"><Data ss:Type="String">#getgeneral.compro#</Data></Cell>
			<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:StyleID="s27"><Data ss:Type="String">LOCATION</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">DESCRIPTION</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">INV</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">CS</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">DN</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">CN</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">TOTAL</Data></Cell>
		</Row>

		<cfloop query="getlocation">
			<cfset sttinvamt = 0>
			<cfset sttcnamt = 0>
			<cfset sttdnamt = 0>
			<cfset sttcsamt = 0>
			<cfset sttnetamt = 0>
			<cfquery name="getdesp" datasource="#dts#">
			select desp from iclocation where location = '#location#'
			</cfquery>

			<cfwddx action = "cfml2wddx" input = "Location:#location#" output = "wddxText1">
			<cfwddx action = "cfml2wddx" input = "#getdesp.desp#" output = "wddxText2">

			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:MergeAcross="1" ss:StyleID="s34"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:MergeAcross="4" ss:StyleID="s34"><Data ss:Type="String">#wddxText2#</Data></Cell>
			</Row>

			<cfquery name="getitem" datasource="#dts#">
			select itemno,desp from ictran where location = '#location#' and (void = '' or void is null)
			<cfif form.productfrom neq "" and form.productto neq "">
			and itemno >= '#form.productfrom#' and itemno <= '#form.productto#'
			</cfif>
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			order by itemno
			</cfquery>

			<cfloop query="getitem">
				<cfset invamt = 0>
				<cfset csamt = 0>
				<cfset dnamt = 0>
				<cfset cnamt = 0>
				<cfset row=row+1>

				<cfquery name="getinv" datasource="#dts#">
				select sum(amt)as sumamt from ictran where type = 'INV' and itemno = '#itemno#'
				and location = '#getlocation.location#' and (void = '' or void is null)
				<cfif #form.datefrom# neq "" and #form.dateto# neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				</cfquery>

				<cfif getinv.sumamt neq "">
					<cfset invamt = #getinv.sumamt#>
				</cfif>

				<cfquery name="getcn" datasource="#dts#">
				select sum(amt)as sumamt from ictran where type = 'CN' and itemno = '#itemno#'
				and location = '#getlocation.location#' and (void = '' or void is null)
				<cfif #form.datefrom# neq "" and #form.dateto# neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				</cfquery>

				<cfif getcn.sumamt neq "">
					<cfset cnamt = #getcn.sumamt#>
				</cfif>

				<cfquery name="getcs" datasource="#dts#">
				select sum(amt)as sumamt from ictran where type = 'CS' and itemno = '#itemno#'
				and location = '#getlocation.location#' and (void = '' or void is null)
				<cfif #form.datefrom# neq "" and #form.dateto# neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				</cfquery>

				<cfquery name="getdn" datasource="#dts#">
				select sum(amt)as sumamt from ictran where type = 'DN' and itemno = '#itemno#'
				and location = '#getlocation.location#' and (void = '' or void is null)
				<cfif #form.datefrom# neq "" and #form.dateto# neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				</cfquery>

				<cfif getdn.sumamt neq "">
					<cfset dnamt = #getdn.sumamt#>
				</cfif>

				<cfset netamt = #invamt# + #dnamt# + #csamt# - #cnamt#>

				<cfwddx action = "cfml2wddx" input = "#row#." output = "wddxText1">
				<cfwddx action = "cfml2wddx" input = "#itemno#" output = "wddxText2">
				<cfwddx action = "cfml2wddx" input = "#desp#" output = "wddxText3">

				<Row ss:AutoFitHeight="0" ss:Height="12">
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
					<Cell ss:MergeAcross="4" ss:StyleID="s28"><Data ss:Type="String">#wddxText3#</Data></Cell>
				</Row>

				<Row ss:AutoFitHeight="0" ss:Height="12">
					<Cell ss:StyleID="s28"/>
					<Cell ss:StyleID="s28"/>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#invamt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#csamt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#dnamt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#cnamt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#netamt#</Data></Cell>
				</Row>

				<cfset sttinvamt = sttinvamt + invamt>
				<cfset sttdnamt = sttdnamt + dnamt>
				<cfset sttcnamt = sttcnamt + cnamt>
				<cfset sttcsamt = sttcsamt + csamt>
				<cfset sttnetamt = sttnetamt + netamt>
				<cfset ttinvamt = ttinvamt + invamt>
				<cfset ttdnamt = ttdnamt + dnamt>
				<cfset ttcnamt = ttcnamt + cnamt>
				<cfset ttcsamt = ttcsamt + csamt>
				<cfset ttnetamt = ttnetamt + netamt>
			</cfloop>

			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s30"><Data ss:Type="String">SUB TOTAL:</Data></Cell>
				<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttinvamt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttcsamt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttdnamt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttcnamt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttnetamt#</Data></Cell>
			</Row>

		</cfloop>

		<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s32"><Data ss:Type="String">TOTAL:</Data></Cell>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttinvamt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttcsamt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttdnamt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttcnamt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttnetamt#</Data></Cell>
		</Row>
	</cfif>

	<cfif form.type eq "2">
		<Table ss:ExpandedColumnCount="6" x:FullColumns="1" x:FullRows="1">
		<Column ss:AutoFitWidth="0" ss:Width="75.5"/>
		<Column ss:AutoFitWidth="0" ss:Width="85.5"/>
		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="80.5" ss:Span="2"/>

		<cfset ttrcamt = 0>
		<cfset ttpramt = 0>
		<cfset ttnetamt = 0>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s22"><Data ss:Type="String">ITEM LOCATION #TYPENAME# REPORT</Data></Cell>
		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="4" ss:StyleID="s26"><Data ss:Type="String">#getgeneral.compro#</Data></Cell>
			<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">LOCATION</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">DESCRIPTION</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">RC</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">PR</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">TOTAL</Data></Cell>
		</Row>

		<cfloop query="getlocation">
			<cfset sttrcamt = 0>
			<cfset sttpramt = 0>
			<cfset sttnetamt = 0>
			<cfquery name="getdesp" datasource="#dts#">
			select desp from iclocation where location = '#location#'
			</cfquery>

			<cfwddx action = "cfml2wddx" input = "Location:#location#" output = "wddxText1">
			<cfwddx action = "cfml2wddx" input = "#getdesp.desp#" output = "wddxText2">

			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:MergeAcross="1" ss:StyleID="s34"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:MergeAcross="3" ss:StyleID="s34"><Data ss:Type="String">#wddxText2#</Data></Cell>
			</Row>

			<cfquery name="getitem" datasource="#dts#">
			select itemno,desp from ictran where location = '#location#' and (void = '' or void is null)
			<cfif form.productfrom neq "" and form.productto neq "">
			and itemno >= '#form.productfrom#' and itemno <= '#form.productto#'
			</cfif>
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			order by itemno
			</cfquery>

			<cfloop query="getitem">
				<cfset rcamt = 0>
				<cfset pramt = 0>
				<cfset netamt = 0>
				<cfset row=row+1>

				<cfquery name="getrc" datasource="#dts#">
				select sum(amt)as sumamt from ictran where type = 'RC' and itemno = '#itemno#'
				and location = '#getlocation.location#' and (void = '' or void is null)
				<cfif #form.datefrom# neq "" and #form.dateto# neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				</cfquery>

				<cfif getrc.sumamt neq "">
					<cfset rcamt = #getrc.sumamt#>
				</cfif>

				<cfquery name="getpr" datasource="#dts#">
				select sum(amt)as sumamt from ictran where type = 'PR' and itemno = '#itemno#'
				and location = '#getlocation.location#' and (void = '' or void is null)
				<cfif #form.datefrom# neq "" and #form.dateto# neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				</cfquery>

				<cfif getpr.sumamt neq "">
					<cfset pramt = #getpr.sumamt#>
				</cfif>
				<cfset netamt = #rcamt# - #pramt#>

				<cfwddx action = "cfml2wddx" input = "#row#." output = "wddxText1">
				<cfwddx action = "cfml2wddx" input = "#itemno#" output = "wddxText2">
				<cfwddx action = "cfml2wddx" input = "#desp#" output = "wddxText3">

				<Row ss:AutoFitHeight="0" ss:Height="12">
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText3#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#rcamt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#pramt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#netamt#</Data></Cell>
				</Row>

				<cfset sttrcamt = sttrcamt + rcamt>
				<cfset sttpramt = sttpramt + pramt>
				<cfset sttnetamt = sttnetamt + netamt>
				<cfset ttrcamt = ttrcamt + rcamt>
				<cfset ttpramt = ttpramt + pramt>
				<cfset ttnetamt = ttnetamt + netamt>
			</cfloop>

			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s30"><Data ss:Type="String">SUB TOTAL:</Data></Cell>
				<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttrcamt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttpramt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttnetamt#</Data></Cell>
			</Row>
		</cfloop>

		<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s32"><Data ss:Type="String">TOTAL:</Data></Cell>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttrcamt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttpramt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttnetamt#</Data></Cell>
		</Row>
	</cfif>
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

	<cfif form.type eq "1">
		<cffile action="write" nameconflict="overwrite" file="C:\CFusionMX\wwwroot\GLOBAL ECN\Excel_Report\#dts#\LocationR_ILS_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="C:\CFusionMX\wwwroot\GLOBAL ECN\Excel_Report\#dts#\LocationR_ILS_#huserid#.xls">
	<cfelse>
		<cffile action="write" nameconflict="overwrite" file="C:\CFusionMX\wwwroot\GLOBAL ECN\Excel_Report\#dts#\LocationR_ILP_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="C:\CFusionMX\wwwroot\GLOBAL ECN\Excel_Report\#dts#\LocationR_ILP_#huserid#.xls">
	</cfif>
<!---
	<cffile action="write" nameconflict="overwrite" file="C:\Inetpub\wwwroot\WOS\Excel_Report\#dts#\LocationR_ILP_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="C:\Inetpub\wwwroot\WOS\Excel_Report\#dts#\LocationR_ILP_#huserid#.xls">
--->
	</cfcase>

	<cfcase value="HTML">
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	<html>
	<head>
	<title>View Reports Menu</title>
	<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
	<style type="text/css" media="print">
		.noprint { display: none; }
	</style>
	</head>

	<cfquery name="getgeneral" datasource="#dts#">
		select cost,compro,lastaccyear from gsetup
	</cfquery>

	<!--- <cfquery name="getgsetup2" datasource='#dts#'>
		select * from gsetup2
	</cfquery>

	<cfset iDecl_UPrice = #getgsetup2.Decl_UPrice#>
	<cfset stDecl_UPrice = ",.">

	<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		<cfset stDecl_UPrice = #stDecl_UPrice# & "_">
	</cfloop> --->

	<cfparam name="ndatefrom" default="">
	<cfparam name="ndateto" default="">
	<cfparam name="row" default="0">

	<cfif isdefined("form.datefrom") and isdefined("form.dateto")>
		<cfset dd=#dateformat(form.datefrom, "DD")#>
		<cfif dd greater than '12'>
			<cfset ndatefrom=#dateformat(form.datefrom,"YYYYMMDD")#>
		<cfelse>
			<cfset ndatefrom=#dateformat(form.datefrom,"YYYYDDMM")#>
		</cfif>

		<cfset dd=#dateformat(form.dateto, "DD")#>
		<cfif dd greater than '12'>
			<cfset ndateto=#dateformat(form.dateto,"YYYYMMDD")#>
		<cfelse>
			<cfset ndateto=#dateformat(form.dateto,"YYYYDDMM")#>
		</cfif>
	</cfif>

	<cfif form.type eq "1">
		<cfquery name="getlocation" datasource="#dts#">
			select location from ictran where (type = 'INV' or type = 'DN' or type = 'CN' or type = 'CS') and (void = '' or void is null)
			<cfif form.productfrom neq "" and form.productto neq "">
			and itemno >= '#form.productfrom#' and itemno <= '#form.productto#'
			</cfif>
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
            <cfif getgeneral.singlelocation eq 'Y'>
            <cfif form.locfrom neq "">
			and location = '#form.locfrom#'
			</cfif>
            <cfelse>
			<cfif form.locfrom neq "" and form.locto neq "">
			and location >= '#form.locfrom#' and location <= '#form.locto#'
			</cfif>
            </cfif>
			group by location order by location
		</cfquery>
	<cfelse>
		<cfquery name="getlocation" datasource="#dts#">
			select location from ictran where (type = 'RC' or type = 'PR') and (void = '' or void is null)
			<cfif form.productfrom neq "" and form.productto neq "">
			and itemno >= '#form.productfrom#' and itemno <= '#form.productto#'
			</cfif>
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
             <cfif getgeneral.singlelocation eq 'Y'>
             <cfif form.locfrom neq "">
			and location = '#form.locfrom#'
			</cfif>
             <cfelse>
			<cfif form.locfrom neq "" and form.locto neq "">
			and location >= '#form.locfrom#' and location <= '#form.locto#'
			</cfif>
            </cfif>
			group by location order by location
		</cfquery>
	</cfif>
	
	<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>
	<h1>
	<cfoutput>
		<center></center>
	</cfoutput>
	</h1>

	<cfif form.type eq "1">
	<cfset ttinvamt = 0>
	<cfset ttcnamt = 0>
	<cfset ttdnamt = 0>
	<cfset ttcsamt = 0>
	<cfset ttnetamt = 0>

	  <table width="100%" border="0" cellspacing="3" cellpadding="0">
		<cfoutput>
		  <tr>
			<td colspan="9"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>
				ITEM LOCATION #TYPENAME# REPORT</strong></font></div></tr>
		  <tr>
			<td colspan="4"><font size="2" face="Times New Roman, Times, serif"> #getgeneral.compro# </font>
			<td colspan="5"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		  </tr>
		</cfoutput>
		<tr>
		  <td colspan="8"><hr></td>
		</tr>
		<tr>
		  <td width="30%" colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">LOCATION</font></div></td>
		  <td><font size="2" face="Times New Roman, Times, serif">DESCRIPTION</font></td>
		  <td width="8%"> <div align="right"><font size="2" face="Times New Roman, Times, serif">INV</font></div></td>
		  <td width="8%"> <div align="right"><font size="2" face="Times New Roman, Times, serif">CS</font></div></td>
		  <td width="8%"> <div align="right"><font size="2" face="Times New Roman, Times, serif">DN</font></div></td>
		  <td width="8%"> <div align="right"><font size="2" face="Times New Roman, Times, serif">CN</font></div></td>
		  <td width="8%"> <div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
		</tr>
		<tr>
		  <td colspan="8"><hr></td>
		</tr>

		<cfloop query="getlocation">
		  <cfset sttinvamt = 0>
		  <cfset sttcnamt = 0>
		  <cfset sttdnamt = 0>
		  <cfset sttcsamt = 0>
		  <cfset sttnetamt = 0>
		  <cfquery name="getdesp" datasource="#dts#">
		  select desp from iclocation where location = '#location#'
		  </cfquery>
		  <cfoutput>
			<tr>
			  <td colspan="2" nowrap><font size="2" face="Times New Roman, Times, serif"><strong>Location:</strong>
				#location#</font></td>
			  <td colspan="6"><font size="2" face="Times New Roman, Times, serif">#getdesp.desp#</font></td>
			</tr>
		  </cfoutput>
		  <cfquery name="getitem" datasource="#dts#">
		  select itemno,desp from ictran where location = '#getlocation.location#' and (void = '' or void is null)
		  <cfif form.productfrom neq "" and form.productto neq "">
			and itemno >= '#form.productfrom#' and itemno <= '#form.productto#'
		  </cfif>
		  <cfif #form.datefrom# neq "" and #form.dateto# neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
		  </cfif>
		 group by location order by itemno
		  </cfquery>
		  <cfloop query="getitem">
			<cfset invamt = 0>
			<cfset csamt = 0>
			<cfset dnamt = 0>
			<cfset cnamt = 0>
			<cfset row=row+1>
			<cfquery name="getinv" datasource="#dts#">
			select sum(amt)as sumamt from ictran where type = 'INV' and itemno = '#itemno#'
			and location = '#getlocation.location#' and (void = '' or void is null)
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			  and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			  <cfelse>
			  and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by location
			</cfquery>
			<cfif getinv.sumamt neq "">
			  <cfset invamt = #getinv.sumamt#>
			</cfif>
			<cfquery name="getcn" datasource="#dts#">
			select sum(amt)as sumamt from ictran where type = 'CN' and itemno = '#itemno#'
			and location = '#getlocation.location#' and (void = '' or void is null)
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			  and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			  <cfelse>
			  and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by location
			</cfquery>
			<cfif getcn.sumamt neq "">
			  <cfset cnamt = #getcn.sumamt#>
			</cfif>
			<cfquery name="getcs" datasource="#dts#">
			select sum(amt)as sumamt from ictran where type = 'CS' and itemno = '#itemno#'
			and location = '#getlocation.location#' and (void = '' or void is null)
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			  and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			  <cfelse>
			  and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by location
			</cfquery>
			<cfquery name="getdn" datasource="#dts#">
			select sum(amt)as sumamt from ictran where type = 'DN' and itemno = '#itemno#'
			and location = '#getlocation.location#' and (void = '' or void is null)
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			  and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			  <cfelse>
			  and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by location
			</cfquery>
			<cfif getdn.sumamt neq "">
			  <cfset dnamt = #getdn.sumamt#>
			</cfif>
			<cfset netamt = #invamt# + #dnamt# + #csamt# - #cnamt#>
			<cfoutput>
			  <tr>
				<td nowrap><font size="2" face="Times New Roman, Times, serif">#row#.</font></td>
				<td nowrap><font size="2" face="Times New Roman, Times, serif">#itemno#</font></td>
				<td colspan="6"><font size="2" face="Times New Roman, Times, serif">#desp#</font></td>
			  </tr>
			  <tr>
				<td colspan="2" nowrap><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(invamt,",.__")#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(csamt,",.__")#</font></div></td>
				<td width="10%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(dnamt,",.__")#</font></div></td>
				<td width="10%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(cnamt,",.__")#</font></div></td>
				<td width="10%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(netamt,",.__")#</font></div></td>
			  </tr>
			</cfoutput>
			<cfset sttinvamt = sttinvamt + invamt>
			<cfset sttdnamt = sttdnamt + dnamt>
			<cfset sttcnamt = sttcnamt + cnamt>
			<cfset sttcsamt = sttcsamt + csamt>
			<cfset sttnetamt = sttnetamt + netamt>
			<cfset ttinvamt = ttinvamt + invamt>
			<cfset ttdnamt = ttdnamt + dnamt>
			<cfset ttcnamt = ttcnamt + cnamt>
			<cfset ttcsamt = ttcsamt + csamt>
			<cfset ttnetamt = ttnetamt + netamt>
		  </cfloop>
		  <tr>
			<td colspan="8"><hr></td>
		  </tr>
		  <cfoutput>
			<tr>
			  <td colspan="2">&nbsp;</td>
			  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">SUB
				  TOTAL:</font></div></td>
			  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(sttinvamt,",.__")#</font></div></td>
			  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(sttcsamt,",.__")#</font></div></td>
			  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(sttdnamt,",.__")#</font></div></td>
			  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(sttcnamt,",.__")#</font></div></td>
			  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(sttnetamt,",.__")#</font></div></td>
			</tr>
		  </cfoutput>
		</cfloop>
		<tr>
		  <td colspan="8"><hr></td>
		</tr>
		<cfoutput>
		  <tr>
			<td colspan="2">&nbsp;</td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL:</font></div></td>
			<td nowrap>
	<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(ttinvamt,",.__")#</font></div></td>
			<td nowrap>
	<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(ttcsamt,",.__")#</font></div></td>
			<td nowrap>
	<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(ttdnamt,",.__")#</font></div></td>
			<td nowrap>
	<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(ttcnamt,",.__")#</font></div></td>
			<td nowrap>
	<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(ttnetamt,",.__")#</font></div></td>
		  </tr>
		</cfoutput>
	  </table>
	</cfif>


	<cfif form.type eq "2">
	<cfset ttrcamt = 0>
	<cfset ttpramt = 0>
	<cfset ttnetamt = 0>
	  <table width="100%" border="0" cellspacing="2" cellpadding="0">
		<cfoutput>
		  <tr>
			<td colspan="9"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>
				ITEM LOCATION #TYPENAME# REPORT</strong></font></div></tr>
		  <tr>
			<td colspan="2"><font size="2" face="Times New Roman, Times, serif"> #getgeneral.compro# </font></td>
			<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		  </tr>
		</cfoutput>
		<tr>
		  <td colspan="6"><hr></td>
		</tr>
		<tr>
		  <td colspan="2" width="30%"><div align="left"><font size="2" face="Times New Roman, Times, serif">LOCATION</font></div></td>
		  <td><font size="2" face="Times New Roman, Times, serif">DESCRIPTION</font></td>
		  <td width="8%">
			<div align="right"><font size="2" face="Times New Roman, Times, serif">RC</font></div></td>
		  <td width="8%" nowrap>
			<div align="right"><font size="2" face="Times New Roman, Times, serif">PR</font></div></td>
		  <td width="8%">
	<div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
		</tr>
		<tr>
		  <td colspan="6"><hr></td>
		</tr>
		<cfloop query="getlocation">
		  <cfset sttrcamt = 0>
		  <cfset sttpramt = 0>
		  <cfset sttnetamt = 0>
		  <cfquery name="getdesp" datasource="#dts#">
		  select desp from iclocation where location = '#location#'
		  </cfquery>
		  <cfoutput>
			<tr>
			  <td colspan="2"><font size="2" face="Times New Roman, Times, serif"><strong>Location:</strong>
				#location#</font></td>
			  <td colspan="4"><font size="2" face="Times New Roman, Times, serif">#getdesp.desp#</font></td>
			</tr>
		  </cfoutput>
		  <cfquery name="getitem" datasource="#dts#">
		  select itemno,desp from ictran where location = '#getlocation.location#' and (void = '' or void is null)
		  <cfif form.productfrom neq "" and form.productto neq "">
			and itemno >= '#form.productfrom#' and itemno <= '#form.productto#'
		  </cfif>
		  <cfif #form.datefrom# neq "" and #form.dateto# neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
		  </cfif>
		  group by location order by itemno
		  </cfquery>
		  <cfloop query="getitem">
			<cfset rcamt = 0>
			<cfset pramt = 0>
			<cfset netamt = 0>
			<cfset row=row+1>
			<cfquery name="getrc" datasource="#dts#">
			select sum(amt)as sumamt from ictran where type = 'RC' and itemno = '#itemno#'
			and location = '#getlocation.location#' and (void = '' or void is null)
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			  and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			  <cfelse>
			  and wos_date > #getgeneral.lastaccyear# 
			
			</cfif> 
			group by location
			</cfquery>
			<cfif getrc.sumamt neq "">
			  <cfset rcamt = #getrc.sumamt#>
			</cfif>
			<cfquery name="getpr" datasource="#dts#">
			select sum(amt)as sumamt from ictran where type = 'PR' and itemno = '#itemno#'
			and location = '#getlocation.location#' and (void = '' or void is null)
			<cfif #form.datefrom# neq "" and #form.dateto# neq "">
			  and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			  <cfelse>
			  and wos_date > #getgeneral.lastaccyear#
			</cfif>
			 group by location
			</cfquery>
			<cfif getpr.sumamt neq "">
			  <cfset pramt = #getpr.sumamt#>
			</cfif>
			<cfset netamt = #rcamt# - #pramt#>
			<cfoutput>
			  <tr>
				<td><font size="2" face="Times New Roman, Times, serif">#row#.</font></td>
				<td nowrap><font size="2" face="Times New Roman, Times, serif">#itemno#</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#desp#</font></td>
				<td>
				  <div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(rcamt,",.__")#</font></div></td>
				<td>
				  <div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(pramt,",.__")#</font></div></td>
				<td width="9%">
				  <div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(netamt,",.__")#</font></div></td>
			  </tr>
			</cfoutput>
			<cfset sttrcamt = sttrcamt + rcamt>
			<cfset sttpramt = sttpramt + pramt>
			<cfset sttnetamt = sttnetamt + netamt>
			<cfset ttrcamt = ttrcamt + rcamt>
			<cfset ttpramt = ttpramt + pramt>
			<cfset ttnetamt = ttnetamt + netamt>
		  </cfloop>
		  <tr>
			<td colspan="6"><hr></td>
		  </tr>
		  <cfoutput>
			<tr>
			  <td colspan="2">&nbsp;</td>
			  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">SUB TOTAL:</font></div></td>
			  <td>
				<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(sttrcamt,",.__")#</font></div></td>
			  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(sttpramt,",.__")#</font></div></td>
			  <td>
				<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(sttnetamt,",.__")#</font></div></td>
			</tr>
		  </cfoutput>
		</cfloop>
		<tr>
		  <td colspan="6"><hr></td>
		</tr>
		<cfoutput>
		  <tr>
			<td colspan="2">&nbsp;</td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL:</font></div></td>
			<td nowrap>
	<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(ttrcamt,",.__")#</font></div></td>
			<td nowrap>
	<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(ttpramt,",.__")#</font></div></td>
			<td nowrap>
	<div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(ttnetamt,",.__")#</font></div></td>
		  </tr>
		</cfoutput>
	  </table>
	</cfif>
	<br>
	<br>
	<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
	<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
	</body>
	</html>
	</cfcase>
</cfswitch>