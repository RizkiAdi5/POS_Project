<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfswitch expression="#form.result#">
	<cfcase value="EXCELDEFAULT">
		<cfif form.show eq "option">
			<cfset rangenum = form.rangeto>
		<cfelse>
			<cfquery name="gettotalitem" datasource="#dts#">
				select count(itemno) as total from icitem
			</cfquery>

			<cfset rangenum = val(gettotalitem.total)>
		</cfif>

		<cfif form.showby eq "qty">
			<cfset msg = "By Sales Quantity">
		<cfelse>
			<cfset msg = "By Sales Value">
		</cfif>

		<cfxml variable="data">
		<?mso-application progid="Excel.Sheet"?>
		<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">
		<Styles>
 			<Style ss:ID="Default" ss:Name="Normal">
		   		<Alignment ss:Vertical="Bottom"/>
		   		<Borders/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9"/>
		   		<Interior/>
		   		<NumberFormat/>
		   		<Protection/>
		  	</Style>
		  	<Style ss:ID="s24">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		  	</Style>
		  	<Style ss:ID="s28">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0"/>
		  	</Style>
		  	<Style ss:ID="s29">
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s30">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s31">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0"/>
		  	</Style>
		  	<Style ss:ID="s32">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>
		  	<Style ss:ID="s33">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  	</Style>
		  	<Style ss:ID="s34">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s35">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s37">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s39">
		   		<Alignment ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		</Styles>
		<cfoutput>
		<Worksheet ss:Name="#trantype#_Product_Sales_Report">
  		<Table ss:ExpandedColumnCount="5" x:FullColumns="1" x:FullRows="1">
   			<Column ss:Width="21"/>
   			<Column ss:AutoFitWidth="0" ss:Width="123.75"/>
   			<Column ss:AutoFitWidth="0" ss:Width="243.75"/>
   			<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="1"/>

			<cfif isdefined("form.rangeto")>
				<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    				<Cell ss:MergeAcross="4" ss:StyleID="s34"><Data ss:Type="String">#trantype# #rangenum# PRODUCT SALES REPORT - #msg#</Data></Cell>
   				</Row>
			<cfelse>
				<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    				<Cell ss:MergeAcross="4" ss:StyleID="s34"><Data ss:Type="String">#trantype# PRODUCT SALES REPORT - #msg#</Data></Cell>
   				</Row>
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
    				<Cell ss:MergeAcross="4" ss:StyleID="s35"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
   				</Row>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
					<Cell ss:MergeAcross="4" ss:StyleID="s35"><Data ss:Type="String">#wddxText#</Data></Cell>
			   	</Row>
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
					<Cell ss:MergeAcross="4" ss:StyleID="s35"><Data ss:Type="String">#wddxText#</Data></Cell>
		   		</Row>
			</cfif>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
				<Cell ss:MergeAcross="3" ss:StyleID="s37"><Data ss:Type="String">#wddxText#</Data></Cell>
				<Cell ss:StyleID="s39"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
		   	</Row>
			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
				<Cell ss:StyleID="s24"><Data ss:Type="String">No.</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Item No.</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Item Description</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Qty Sold</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Sales</Data></Cell>
		   	</Row>

			<cfset totalqty =0>
			<cfset totalamt =0>

			<cfquery name="getitem" datasource="#dts#">
				select itemno, desp, sum(qty) as sumqty, sum(amt) as sumamt from ictran
				where (type = 'INV' or type = 'DN' or type = 'CS') and wos_date > #getgeneral.lastaccyear# and (void = '' or void is null)
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				<cfif form.areafrom neq "" and form.areato neq "">
				and area >='#form.areafrom#' and area <='#form.areato#'
				</cfif>
				group by itemno
				<cfif form.showby eq "amt">
				order by sumamt
				<cfelse>
				order by sumqty
				</cfif>
				<cfif url.trantype eq "TOP PRODUCT SALES">
				desc
				</cfif>
			</cfquery>

			<cfif rangenum neq 0>
				<cfloop query="getitem" startrow="1" endrow="#rangenum#">
					<Row ss:Height="12">
						<Cell ss:StyleID="s28"><Data ss:Type="Number">#getitem.currentrow#.</Data></Cell>
						<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText">
						<Cell ss:StyleID="s30"><Data ss:Type="String">#wddxText#</Data></Cell>
						<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText">
						<Cell ss:StyleID="s30"><Data ss:Type="String">#wddxText#</Data></Cell>
						<cfset totalqty = totalqty + val(getitem.sumqty)>
						<Cell ss:StyleID="s28"><Data ss:Type="Number">#val(getitem.sumqty)#</Data></Cell>
						<cfset totalamt = totalamt + val(getitem.sumamt)>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#val(getitem.sumamt)#</Data></Cell>
		   			</Row>
				</cfloop>
			<cfelse>
				<cfloop query="getitem">
					<Row ss:Height="12">
						<Cell ss:StyleID="s28"><Data ss:Type="Number">#getitem.currentrow#.</Data></Cell>
						<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText">
						<Cell ss:StyleID="s30"><Data ss:Type="String">#wddxText#</Data></Cell>
						<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText">
						<Cell ss:StyleID="s30"><Data ss:Type="String">#wddxText#</Data></Cell>
						<cfset totalqty = totalqty + val(getitem.sumqty)>
						<Cell ss:StyleID="s28"><Data ss:Type="Number">#val(getitem.sumqty)#</Data></Cell>
						<cfset totalamt = totalamt + val(getitem.sumamt)>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#val(getitem.sumamt)#</Data></Cell>
		   			</Row>
				</cfloop>
			</cfif>
			<Row ss:Height="12">
				<Cell ss:StyleID="s29"/>
				<Cell ss:Index="4" ss:StyleID="s31"><Data ss:Type="Number">#totalqty#</Data></Cell>
				<Cell ss:StyleID="s32"><Data ss:Type="Number">#totalamt#</Data></Cell>
		   	</Row>
			</cfoutput>
		   	<Row ss:Height="12"/>
  		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\#trantype#_Product_Sales_Report_#msg#_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\#trantype#_Product_Sales_Report_#msg#_#huserid#.xls">
	</cfcase>

	<cfcase value="HTML">
		<html>
		<head>
		<title>Top/Bottom Sales Report</title>
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

		<cfif form.show eq "option">
			<cfset rangenum = form.rangeto>
		<cfelse>
			<cfquery name="gettotalitem" datasource="#dts#">
				select count(itemno) as total from icitem
			</cfquery>

			<cfset rangenum = val(gettotalitem.total)>
		</cfif>

		<cfif form.showby eq "qty">
			<cfset msg = "By Sales Quantity">
		<cfelse>
			<cfset msg = "By Sales Value">
		</cfif>

		<cfset totalqty =0>
		<cfset totalamt =0>

		<cfquery name="getitem" datasource="#dts#">
			select itemno, desp, sum(qty) as sumqty, sum(amt) as sumamt from ictran
			where (type = 'INV' or type = 'DN' or type = 'CS') and wos_date > #getgeneral.lastaccyear# and (void = '' or void is null)
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
			and area >='#form.areafrom#' and area <='#form.areato#'
			</cfif>
			group by itemno
			<cfif form.showby eq "amt">
			order by sumamt
			<cfelse>
			order by sumqty
			</cfif>
			<cfif url.trantype eq "top">
			desc
			</cfif>
		</cfquery>

		<body>
		<cfoutput>
		  <table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<cfif isdefined("form.rangeto")>
					<td colspan="7"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# #rangenum# PRODUCT SALES REPORT - #msg#</strong></font></div></td>
				<cfelse>
					<td colspan="7"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# PRODUCT SALES REPORT - #msg#</strong></font></div></td>
				</cfif>
			</tr>
			<cfif form.periodfrom neq "" and form.periodto neq "">
				<tr>
					<td colspan="7"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<tr>
					<td colspan="7"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
				</tr>
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
				<tr>
					<td colspan="7"><div align="center"><font size="2" face="Times New Roman, Times, serif">TEAM: #form.teamfrom# - #form.teamto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
				<tr>
					<td colspan="7"><div align="center"><font size="2" face="Times New Roman, Times, serif">AREA: #form.areafrom# - #form.areato#</font></div></td>
				</tr>
			</cfif>
			<tr>
				<td colspan="3"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
			<tr>
				<td colspan="7"><hr></td>
			</tr>
			<tr>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">NO</font></div></td>
				<td></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">ITEM NO.</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DESP</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY SOLD</font></div></td>
				<td></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SALES</font></div></td>
			</tr>
			<tr>
				<td colspan="7"><hr></td>
			</tr>

			<cfif rangenum neq 0>
				<cfloop query="getitem" startrow="1" endrow="#rangenum#">
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.currentrow#.</font></div></td>
						<td></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></div></td>
						<cfset totalqty = totalqty + val(getitem.sumqty)>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumqty),"0")#</font></div></td>
						<td></td>
						<cfset totalamt = totalamt + val(getitem.sumamt)>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumamt),stDecl_UPrice)#</font></div></td>
					</tr>
				</cfloop>
			<cfelse>
				<cfloop query="getitem">
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.currentrow#.</font></div></td>
						<td></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></div></td>
						<cfset totalqty = totalqty + val(getitem.sumqty)>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumqty),"0")#</font></div></td>
						<td></td>
						<cfset totalamt = totalamt + val(getitem.sumamt)>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getitem.sumamt),stDecl_UPrice)#</font></div></td>
					</tr>
				</cfloop>
			</cfif>
			<tr>
				<td colspan="7"><hr></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalqty,"0")#</strong></font></div></td>
				<td></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalamt,",___.__")#</strong></font></div></td>
			</tr>
		</table>

		<cfif getitem.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
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