<cfquery name="getgeneral" datasource="#dts#">
	select cost,compro,lastaccyear from gsetup
</cfquery>

<cfif getgeneral.cost eq "FIXED">
	<cfset costingmethod = "Fixed Cost Method">
<cfelseif getgeneral.cost eq "MONTH">
	<cfset costingmethod = "Month Average Method">
<cfelseif getgeneral.cost eq "MOVING">
	<cfset costingmethod = "Moving Average Method">
<cfelseif getgeneral.cost eq "FIFO">
	<cfset costingmethod = "First In First Out Method">
<cfelse>
	<cfset costingmethod = "Last In First Out Method">
</cfif>

<cfquery name="getgsetup2" datasource='#dts#'>
	Select * from gsetup2
</cfquery>

<cfswitch expression="#form.result#">
	<cfcase value="HTML">
		<html>
		<head>
		<title>Profit Margin By Project Report</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href = "../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
		<style type="text/css" media="print">
			.noprint { display: none; }
		</style>
		</head>

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

		<body>
		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="11"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Print #url.trantype# Report</strong></font></div></td>
			</tr>
			<tr>
				<td colspan="11"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Calculated by #costingmethod#</strong></font></div></td>
			</tr>
			<cfif form.periodfrom neq "" and form.periodto neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
				</tr>
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATEGORY: #form.catefrom# - #form.cateto#</font></div></td>
				</tr>
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
				</tr>
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM NO: #form.itemfrom# - #form.itemto#</font></div></td>
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
				<td colspan="7"><hr></td>
			</tr>
			<tr>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">PROJECT</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DISCRIPTION</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY SOLD</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SALES</font></div></td>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FORIEGN CURRENCY SALES </font></div></td>
                </cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SALES COST</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">PROFIT</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">(%) PROFIT</font></div></td>
			</tr>
			<tr>
				<td colspan="7"><hr></td>
			</tr>

		<cfquery name="getproject" datasource="#dts#"><!---Project No--->
			select a.source from ictran a, icitem b
			where b.itemno = a.itemno
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			and b.category >= '#form.catefrom#' and b.category <= '#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
			and b.wos_group >= "#form.groupfrom#" and b.wos_group <= "#form.groupto#"
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			and b.itemno >= '#form.itemfrom#' and b.itemno <= '#form.itemto#'
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and a.fperiod >= '#form.periodfrom#' and a.fperiod <= '#form.periodto#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
			<cfelse>
			and a.wos_date > #getgeneral.lastaccyear#
			</cfif>
			<cfif form.projectfrom neq "" and form.projectto neq "">
			and a.source >= "#form.projectfrom#" and a.source <= "#form.projectto#"
			</cfif>
			group by a.source order by a.source
		</cfquery>

			<cfset totalqty = 0>
			<cfset totalsales = 0>
            <cfset totalsales2 = 0>
			<cfset totalcost = 0>
			<cfset totalprofit = 0>

			<cfloop query="getproject">
				<cfset source = getproject.source>
				<cfset qty = 0>
				<cfset sales = 0>
                <cfset sales2 = 0>
				<cfset cost = 0>
				<cfset profit = 0>

				<cfquery name="getsales" datasource="#dts#">
					select sum(qty) as sumqty, sum(amt) as sumamt
,sum(amt_bil) as sumamt_bil, sum(it_cos) as sumcost from ictran
					where (type='inv' or type='cs' or type='dn') and source = '#source#' and (void = '' or void is null)
					<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
					and category >= '#form.catefrom#' and category <= '#form.cateto#'
					</cfif>
					<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
					and wos_group >= "#form.groupfrom#" and wos_group <= "#form.groupto#"
					</cfif>
					<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
					and itemno >= '#form.itemfrom#' and itemno <= '#form.itemto#'
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
				</cfquery>

				<cfset qty = qty + val(getsales.sumqty)>
				<cfset cost = cost + val(getsales.sumcost)>
				<cfset sales = sales + val(getsales.sumamt)>
                <cfset sales2 = sales2 + val(getsales.sumamt_bil)>
				<cfset totalqty = totalqty + val(getsales.sumqty)>
				<cfset totalcost = totalcost + val(getsales.sumcost)>
				<cfset totalsales = totalsales + val(getsales.sumamt)>
                <cfset totalsales2 = totalsales2 + val(getsales.sumamt_bil)>
				<cfset profit = sales - cost>
				<cfset totalprofit = totalprofit + profit>

				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<cfif getproject.source eq "">
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">No - Project</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">No - Project</font></div></td>
					<cfelse>
						<cfquery name="getsourcename" datasource="#dts#">
							select project from project where source = '#source#'
						</cfquery>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#source#</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsourcename.project#</font></div></td>
					</cfif>

					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#NumberFormat(qty,"0")#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#NumberFormat(sales,stDecl_UPrice)#</font></div></td>
                    <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                    <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#NumberFormat(sales2,stDecl_UPrice)#</font></div></td>
                    </cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#NumberFormat(cost,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#NumberFormat(profit,stDecl_UPrice)#</font></div></td>
					<cfif sales neq 0 and profit neq 0 and sales neq "">
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#NumberFormat(profit / sales * 100,"0.00")#</font></div></td>
					<cfelse>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#NumberFormat(0,"0.00")#</font></div></td>
					</cfif>
				</tr>
			</cfloop>
			<tr>
				<td colspan="7"><hr></td>
			</tr>
			<tr>
				<td><div align="left"></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#NumberFormat(totalqty,"0")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#NumberFormat(totalsales,",.__")#</strong></font></div></td>
                 <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                 <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#NumberFormat(totalsales2,",.__")#</strong></font></div></td>
                 </cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#NumberFormat(totalcost,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#NumberFormat(totalprofit,",.__")#</strong></font></div></td>
				<cfif totalsales neq 0 and totalprofit neq 0 and totalsales neq "">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#NumberFormat(totalprofit / totalsales * 100,"0.00")#</strong></font></div></td>
				<cfelse>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#NumberFormat(0,"0.00")#</strong></font></div></td>
				</cfif>
			</tr>
		</table>

		<cfif getproject.recordcount eq 0>
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

	<cfcase value="EXCEL">
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
  			<Style ss:ID="s25">
   				<Borders>
    				<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    				<Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>
   				</Borders>
   				<NumberFormat ss:Format="@"/>
  			</Style>
  			<Style ss:ID="s26">
   				<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
  			</Style>
  			<Style ss:ID="s28">
   				<Borders>
    				<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    				<Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>
   				</Borders>
   				<NumberFormat ss:Format="#,###,###,##0"/>
  			</Style>

			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>

			<Style ss:ID="s30">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  	</Style>
		  	<Style ss:ID="s31">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s32">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s35">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0"/>
		  	</Style>
		  	<Style ss:ID="s36">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s38">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>
		   		</Borders>
		   		<NumberFormat ss:Format="Fixed"/>
		  	</Style>
		  	<Style ss:ID="s39">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Interior/>
		   		<NumberFormat ss:Format="Fixed"/>
		  	</Style>
		  	<Style ss:ID="s40">
		  	 	<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s42">
		   		<Alignment ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s45">
		   		<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		</Styles>
 		<Worksheet ss:Name="Project_Profit_Margin_Report">
		<Table ss:ExpandedColumnCount="8" x:FullColumns="1" x:FullRows="1">
   			<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   			<Column ss:AutoFitWidth="0" ss:Width="123.75"/>
   			<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="4"/>
   			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    			<Cell ss:MergeAcross="6" ss:StyleID="s31"><Data ss:Type="String">Project Profit Margin Report</Data></Cell>
   			</Row>
			<cfoutput>
   			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
    			<Cell ss:MergeAcross="6" ss:StyleID="s32"><Data ss:Type="String">Calculated by #costingmethod#</Data></Cell>
   			</Row>
	   		<cfif form.periodfrom neq "" and form.periodto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="6" ss:StyleID="s32"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="6" ss:StyleID="s32"><Data ss:Type="String">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</Data></Cell>
				</Row>
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "CATEGORY: #form.catefrom# - #form.cateto#" output = "wddxText">
					<Cell ss:MergeAcross="6" ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "GROUP: #form.groupfrom# - #form.groupto#" output = "wddxText">
					<Cell ss:MergeAcross="6" ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "ITEM NO: #form.itemfrom# - #form.itemto#" output = "wddxText">
					<Cell ss:MergeAcross="6" ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>

			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
				<Cell ss:MergeAcross="3" ss:StyleID="s40"><Data ss:Type="String">#wddxText#</Data></Cell>
				<Cell ss:StyleID="s42"/>
				<Cell ss:MergeAcross="1" ss:StyleID="s45"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
			</Row>
			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
				<Cell ss:StyleID="s24"><Data ss:Type="String">Project</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Project Description</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Qty Sold</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Sales</Data></Cell>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <Cell ss:StyleID="s24"><Data ss:Type="String">Foriegn Currency Sales</Data></Cell>
                </cfif>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Cost</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Profit</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Margin</Data></Cell>
			</Row>

			<cfquery name="getproject" datasource="#dts#"><!---Project No--->
				select a.source from ictran a, icitem b
				where b.itemno = a.itemno
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and b.category >= '#form.catefrom#' and b.category <= '#form.cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and b.wos_group >= "#form.groupfrom#" and b.wos_group <= "#form.groupto#"
				</cfif>
				<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				and b.itemno >= '#form.itemfrom#' and b.itemno <= '#form.itemto#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and a.fperiod >= '#form.periodfrom#' and a.fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
				<cfelse>
				and a.wos_date > #getgeneral.lastaccyear#
				</cfif>
				<cfif form.projectfrom neq "" and form.projectto neq "">
				and a.source >= "#form.projectfrom#" and a.source <= "#form.projectto#"
				</cfif>
				group by a.source order by a.source
			</cfquery>

			<cfset totalqty = 0>
			<cfset totalsales = 0>
            <cfset totalsales2 = 0>
			<cfset totalcost = 0>
			<cfset totalprofit = 0>

			<cfloop query="getproject">
				<cfset source = getproject.source>

				<cfquery name="getsales" datasource="#dts#">
					select sum(qty) as sumqty, sum(amt) as sumamt,sum(amt_bil) as sumamt_bil, sum(it_cos) as sumcost,(sum(amt)-sum(it_cos)) as profit,
					(((sum(amt)-sum(it_cos))/sum(amt))*100) as margin from ictran
					where (type='inv' or type='cs' or type='dn') and source = '#source#' and (void = '' or void is null)
					<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
					and category >= '#form.catefrom#' and category <= '#form.cateto#'
					</cfif>
					<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
					and wos_group >= "#form.groupfrom#" and wos_group <= "#form.groupto#"
					</cfif>
					<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
					and itemno >= '#form.itemfrom#' and itemno <= '#form.itemto#'
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
				</cfquery>

				<cfset totalqty = totalqty + val(getsales.sumqty)>
				<cfset totalcost = totalcost + val(getsales.sumcost)>
				<cfset totalsales = totalsales + val(getsales.sumamt)>
                <cfset totalsales2 = totalsales2 + val(getsales.sumamt_bil)>
				<cfset totalprofit = totalprofit + val(getsales.profit)>

				<Row ss:Height="12">
					<cfif getproject.source eq "">
						<Cell ss:StyleID="s25"><Data ss:Type="String">No - Project</Data></Cell>
						<Cell ss:StyleID="s25"><Data ss:Type="String">No - Project</Data></Cell>
					<cfelse>
						<cfquery name="getsourcename" datasource="#dts#">
							select project from project where source = '#source#'
						</cfquery>

						<cfwddx action = "cfml2wddx" input = "#source#" output = "wddxText">
						<Cell ss:StyleID="s25"><Data ss:Type="String">#wddxText#</Data></Cell>
						<cfwddx action = "cfml2wddx" input = "#getsourcename.project#" output = "wddxText">
						<Cell ss:StyleID="s25"><Data ss:Type="String">#wddxText#</Data></Cell>
					</cfif>
					<Cell ss:StyleID="s28"><Data ss:Type="Number">#val(getsales.sumqty)#</Data></Cell>
					<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getsales.sumamt)#</Data></Cell>
                    <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                    <Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getsales.sumamt_bil)#</Data></Cell>
                    </cfif>
					<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getsales.sumcost)#</Data></Cell>
					<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getsales.profit)#</Data></Cell>
					<Cell ss:StyleID="s38"><Data ss:Type="Number">#val(getsales.margin)#</Data></Cell>
				</Row>
			</cfloop>
			<Row ss:Height="12">
				<Cell ss:StyleID="s26"/>
				<Cell ss:Index="3" ss:StyleID="s35"><Data ss:Type="Number">#val(totalqty)#</Data></Cell>
				<Cell ss:StyleID="s36"><Data ss:Type="Number">#val(totalsales)#</Data></Cell>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <Cell ss:StyleID="s36"><Data ss:Type="Number">#val(totalsales2)#</Data></Cell>
                </cfif>
				<Cell ss:StyleID="s36"><Data ss:Type="Number">#val(totalcost)#</Data></Cell>
				<Cell ss:StyleID="s36"><Data ss:Type="Number">#val(totalprofit)#</Data></Cell>
				<cfif totalsales neq 0 and totalprofit neq 0 and totalsales neq "">
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#val((totalprofit/totalsales)*100)#</Data></Cell>
				<cfelse>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">0</Data></Cell>
				</cfif>
			</Row>
			</cfoutput>
			<Row ss:Height="12"/>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Project_Profit_Margin_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Project_Profit_Margin_#huserid#.xls">
	</cfcase>
</cfswitch>