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

	<cfquery name="getsupp" datasource="#dts#">
		select a.custno,a.name from #target_apvend# a, artran b
		where a.custno=b.custno and (b.void = '' or b.void is null) and (b.type='RC' or b.type='PR')
		<cfif form.agentfrom neq "" and form.agentto neq "">
		and b.agenno between '#form.agentfrom#' and '#form.agentto#'
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
		and a.area between '#form.areafrom#' and '#form.areato#'
		</cfif>
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		and a.custno between '#form.suppfrom#' and '#form.suppto#'
		</cfif>
        and a.custno<>'assm/999'
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and b.fperiod between '#form.periodfrom#' and '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and b.wos_date between '#ndatefrom#' and '#ndateto#'
		<cfelse>
		and b.wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by a.custno order by a.custno
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
	</Styles>
	<Worksheet ss:Name="PURCHASE LISTING REPORT">
	<cfoutput>
	<Table ss:ExpandedColumnCount="8" x:FullColumns="1" x:FullRows="1">
	<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="80.5" ss:Span="2"/>

	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:MergeAcross="4" ss:StyleID="s22"><Data ss:Type="String">Purchase Listing By Vendors Report</Data></Cell>
	</Row>

	<cfif form.periodfrom neq "" and form.periodto neq "">
		<cfwddx action = "cfml2wddx" input = "PERIOD: #form.periodfrom# - #form.periodto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="4" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif form.datefrom neq "" and form.dateto neq "">
		<cfwddx action = "cfml2wddx" input = "DATE: #lsdateformat(form.datefrom,"dd/mm/yyyy")# - #lsdateformat(form.dateto,"dd/mm/yyyy")#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="4" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif form.agentfrom neq "" and form.agentto neq "">
		<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="4" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif form.areafrom neq "" and form.areato neq "">
		<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="4" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
	<cfwddx action = "cfml2wddx" input = "SUPP_NO: #form.suppfrom# - #form.suppto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="4" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>

	<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="3" ss:StyleID="s26"><Data ss:Type="String">#getgeneral.compro#</Data></Cell>
		<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
	</Row>

	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:StyleID="s27"><Data ss:Type="String">REF.NO</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">DATE</Data></Cell>
         <cfif lcase(hcomid) eq "vsolutionspteltd_i">
        <Cell ss:StyleID="s27"><Data ss:Type="String">FOREIGN RC</Data></Cell>
        <Cell ss:StyleID="s27"><Data ss:Type="String">FOREIGN PR</Data></Cell>
        <Cell ss:StyleID="s27"><Data ss:Type="String">FOREIGN NET</Data></Cell>
       
       </cfif>
		<Cell ss:StyleID="s27"><Data ss:Type="String">RC</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">PR</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">NET</Data></Cell>
       
	</Row>

	<cfset totalrcamt = 0>
	<cfset totalpramt = 0>

	<cfloop query="getsupp">
		<cfset subrcamt = 0>
		<cfset subpramt = 0>

		<cfwddx action = "cfml2wddx" input = "#getsupp.custno#" output = "wddxText1">
		<cfwddx action = "cfml2wddx" input = "#getsupp.name#" output = "wddxText2">

		<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s34"><Data ss:Type="String">#wddxText1#</Data></Cell>
			<Cell ss:StyleID="s34"><Data ss:Type="String">#wddxText2#</Data></Cell>
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
		</Row>

		<cfquery name="getartran" datasource="#dts#">
			select type,refno,wos_date,CAST(net AS UNSIGNED) as net,grand,grand_bil from artran
			where (void = '' or void is null) and (type='RC' or type='PR') and custno='#getsupp.custno#'
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
		</cfquery>

		<cfloop query="getartran">
			<cfwddx action = "cfml2wddx" input = "#getartran.refno#" output = "wddxText1">

			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#lsdateformat(getartran.wos_date,"dd/mm/yyyy")#</Data></Cell>
 <cfif lcase(hcomid) eq "vsolutionspteltd_i">
                <cfswitch expression="#getartran.type#">
					<cfcase value="RC">
						
						<Cell ss:StyleID="s29"><Data ss:Type="Number">#getartran.grand_bil#</Data></Cell>
						<Cell ss:StyleID="s29"/>
						<Cell ss:StyleID="s29"/>
					</cfcase>

					<cfcase value="PR">
						
						<Cell ss:StyleID="s29"/>
						<Cell ss:StyleID="s29"><Data ss:Type="Number">#getartran.grand_bil#</Data></Cell>
						<Cell ss:StyleID="s29"/>
					</cfcase>
				</cfswitch>
                </cfif>


				<cfswitch expression="#getartran.type#">
					<cfcase value="RC">
						<cfset subrcamt = subrcamt + getartran.grand>
						<cfset totalrcamt = totalrcamt + getartran.grand>
						<Cell ss:StyleID="s29"><Data ss:Type="Number">#getartran.grand#</Data></Cell>
						<Cell ss:StyleID="s29"/>
						<Cell ss:StyleID="s29"/>
					</cfcase>

					<cfcase value="PR">
						<cfset subpramt = subpramt + getartran.grand>
						<cfset totalpramt = totalpramt + getartran.grand>
						<Cell ss:StyleID="s29"/>
						<Cell ss:StyleID="s29"><Data ss:Type="Number">#getartran.grand#</Data></Cell>
						<Cell ss:StyleID="s29"/>
					</cfcase>
				</cfswitch>
               
			</Row>
		</cfloop>

		<Row ss:AutoFitHeight="0" ss:Height="12">
        <Cell ss:StyleID="s30"/>
        <Cell ss:StyleID="s30"/>
        <Cell ss:StyleID="s30"/>
			<Cell ss:StyleID="s30"><Data ss:Type="String">SUB-TOTAL:</Data></Cell>
			<Cell ss:StyleID="s30"/>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#subrcamt#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#subpramt#</Data></Cell>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#(subrcamt-subpramt)#</Data></Cell>
		</Row>
		<Row ss:AutoFitHeight="0" ss:Height="12"/>
	</cfloop>

	<Row ss:AutoFitHeight="0" ss:Height="12">
		<Cell ss:StyleID="s32"/>
		<Cell ss:StyleID="s32"/>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalrcamt#</Data></Cell>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalpramt#</Data></Cell>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#(totalrcamt-totalpramt)#</Data></Cell>
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

	<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#_PLV_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#_PLV_#huserid#.xls">
	</cfcase>

	<cfcase value="HTML">
	<html>
	<head>
	<title>Purchase Listing By Vendors Report</title>
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

	<cfquery name="getsupp" datasource="#dts#">
		select a.custno,a.name from #target_apvend# a, artran b
		where a.custno=b.custno and (b.void = '' or b.void is null) and (b.type='RC' or b.type='PR')
		<cfif form.agentfrom neq "" and form.agentto neq "">
		and b.agenno between '#form.agentfrom#' and '#form.agentto#'
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
		and a.area between '#form.areafrom#' and '#form.areato#'
		</cfif>
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
		and a.custno between '#form.suppfrom#' and '#form.suppto#'
		</cfif>
        and a.custno<>'assm/999'
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and b.fperiod between '#form.periodfrom#' and '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and b.wos_date between '#ndatefrom#' and '#ndateto#'
		<cfelse>
		and b.wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by a.custno order by a.custno
	</cfquery>

	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="5"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Purchase Listing By Vendors Report</strong></font></div></td>
		</tr>
		<cfif form.periodfrom neq "" and form.periodto neq "">
			<tr>
				<td colspan="5"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
			</tr>
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
			<tr>
				<td colspan="5"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #lsdateformat(form.datefrom,"dd/mm/yyyy")# - #lsdateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
			</tr>
		</cfif>
		<cfif form.agentfrom neq "" and form.agentto neq "">
			<tr>
				<td colspan="5"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
			</tr>
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
			<tr>
				<td colspan="5"><div align="center"><font size="2" face="Times New Roman, Times, serif">AREA: #form.areafrom# - #form.areato#</font></div></td>
			</tr>
		</cfif>
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
			<tr>
				<td colspan="5"><div align="center"><font size="2" face="Times New Roman, Times, serif">SUPP_NO: #form.suppfrom# - #form.suppto#</font></div></td>
			</tr>
		</cfif>
		<tr>
			<td colspan="3"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
			<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">REF.NO</font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
            <cfif lcase(hcomid) eq "vsolutionspteltd_i">
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOREIGN CURRENCY</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOREIGN AMOUNT RC</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOREIGN AMOUNT PR</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOREIGN AMOUNT NET</font></div></td>
            </cfif>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">RC</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">PR</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">NET</font></div></td>
            
		</tr>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>

		<cfset totalrcamt = 0>
		<cfset totalpramt = 0>

		<cfloop query="getsupp">
			<cfset subrcamt = 0>
			<cfset subpramt = 0>
			<tr>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong><u>#getsupp.custno#</u></strong></font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong><u>#getsupp.name#</u></strong></font></div></td>
			</tr>

			<cfquery name="getartran" datasource="#dts#">
				select type,refno,wos_date,CAST(net AS UNSIGNED) as net,grand,grand_bil from artran
				where (void = '' or void is null) and (type='RC' or type='PR') and custno='#getsupp.custno#'
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
			</cfquery>

			<cfloop query="getartran">
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getartran.refno#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#lsdateformat(getartran.wos_date,"dd/mm/yyyy")#</font></div></td>
					<cfswitch expression="#getartran.type#">
						<cfcase value="RC">
							<cfset subrcamt = subrcamt + getartran.grand>
							<cfset totalrcamt = totalrcamt + getartran.grand>
							<!--- <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getartran.net,stDecl_UPrice)#</font></div></td> --->
                            <cfif lcase(hcomid) eq "vsolutionspteltd_i">
                            <cfquery name="getcurrencycode" datasource="#dts#">
    select currcode from #target_apvend# where custno='#getsupp.custno#'
    </cfquery>
                            <td><div align="right">#getcurrencycode.currcode#</div></td>
                            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getartran.grand_bil,stDecl_UPrice)#</font></div></td>
                            <td></td>
                            
                            <td></td>
                            
                            </cfif>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getartran.grand,stDecl_UPrice)#</font></div></td>
							<td></td>
						</cfcase>

						<cfcase value="PR">
							<cfset subpramt = subpramt + getartran.grand>
							<cfset totalpramt = totalpramt + getartran.grand>
                            
							<td></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getartran.grand,stDecl_UPrice)#</font></div></td>
						</cfcase>
					</cfswitch>
                    <td></td>
                 
					<td></td>
				</tr>
			</cfloop>
			<tr>
				<td colspan="2"></td>
				<td colspan="100%"><hr/></td>
			</tr>
			<tr>
				<td></td>
                <cfif lcase(hcomid) eq "vsolutionspteltd_i">
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                </cfif>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">SUB-TOTAL:</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subrcamt,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subpramt,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat((subrcamt-subpramt),stDecl_UPrice)#</font></div></td>
			</tr>
		</cfloop>
		<tr>
			<td colspan="2"></td>
			<td colspan="3"><br/></td>
		</tr>
		<tr>
			<td colspan="2"></td>
            <cfif lcase(hcomid) eq "vsolutionspteltd_i">
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            </cfif>
			<td class="borderformat"><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalrcamt,",.__")#</strong></font></div></td>
			<td class="borderformat"><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalpramt,",.__")#</strong></font></div></td>
			<td class="borderformat"><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat((val(totalrcamt)-val(totalpramt)),",.__")#</strong></font></div></td>
		</tr>
	</table>
	</cfoutput>

	<cfif getsupp.recordcount eq 0>
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