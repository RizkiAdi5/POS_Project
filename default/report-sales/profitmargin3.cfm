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
	<cfcase value="HTML">
		<html>
		<head>
		<title>Profit Margin By Agent Report</title>
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
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<tr>
					<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
				</tr>
			</cfif>
            
            <cfif form.teamfrom neq "" and form.teamto neq "">
				<tr>
					<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">Team: #form.teamfrom# - #form.teamto#</font></div></td>
				</tr>
			</cfif>
            
			<cfif form.areafrom neq "" and form.areato neq "">
				<tr>
					<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">AREA: #form.areafrom# - #form.areato#</font></div></td>
				</tr>
			</cfif>
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				<tr>
					<td colspan="6"><div align="center"><font size="2" face="Times New Roman, Times, serif">CUSTOMER: #form.custfrom# - #form.custto#</font></div></td>
				</tr>
			</cfif>
			<tr>
				<td colspan="2"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
			<tr>
				<td colspan="6"><hr></td>
			</tr>
			<tr>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">AGENT NO</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">NAME</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SALES AMT</font></div></td>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FORIEGN CURRENCYSALES AMT</font></div></td>
                </cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SALES COST</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">GROSS PROFIT</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">MARGIN (%)</font></div></td>
			</tr>
			<tr>
				<td colspan="6"><hr></td>
			</tr>

			<cfquery name="getagent" datasource="#dts#"><!---Agent No--->
				select agenno from artran
				where (type = 'INV' or type = 'DN' or type = 'CS') and (void = '' or void is null)
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >= '#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				<cfif form.areafrom neq "" and form.areato neq "">
				and area >= '#form.areafrom#' and area <= '#form.areato#'
				</cfif>
				<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				and custno >= '#form.custfrom#' and custno <= '#form.custto#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by agenno order by agenno
			</cfquery>

			<cfset totalsales = 0>
            <cfset totalsales2 = 0>
			<cfset totalcost = 0>
			<cfset totalprofit = 0>

			<cfloop query="getagent">
				<cfset agenno = getagent.agenno>
				<cfset sales = 0>
                <cfset sales2 = 0>
				<cfset cost = 0>
				<cfset profit = 0>

				<cfquery name="getsales" datasource="#dts#">
					select a.agenno,sum(a.net) as sumamt,sum(a.net_bil) as sumamt_bil,b.sumcost from artran as a
					left join
					(select agenno,sum(it_cos) as sumcost from ictran
					where 1=1
                    <cfif form.radio1 eq 'item'>
                and linecode ='' or linecode is null
                <cfelseif form.radio1 eq 'serv'>
                and linecode ='SV'
                <cfelse>
                </cfif>
					<cfif form.areafrom neq "" and form.areato neq "">
					and area >= '#form.areafrom#' and area <= '#form.areato#'
					</cfif>
					<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
					and custno >= '#form.custfrom#' and custno <= '#form.custto#'
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
					group by agenno) as b on a.agenno=b.agenno

					where (a.type = 'INV' or a.type = 'CS' or a.type = 'DN') and a.agenno = '#agenno#' and (a.void = '' or a.void is null)
					<cfif form.areafrom neq "" and form.areato neq "">
					and a.area >= '#form.areafrom#' and a.area <= '#form.areato#'
					</cfif>
					<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
					and a.custno >= '#form.custfrom#' and a.custno <= '#form.custto#'
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and a.fperiod >= '#form.periodfrom#' and a.fperiod <= '#form.periodto#'
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
					<cfelse>
					and a.wos_date > #getgeneral.lastaccyear#
					</cfif>
					group by a.agenno
				</cfquery>

				<cfset cost = cost + val(getsales.sumcost)>
				<cfset sales = sales + val(getsales.sumamt)>
                <cfset sales2 = sales2 + val(getsales.sumamt_bil)>
				<cfset totalcost = totalcost + val(getsales.sumcost)>
				<cfset totalsales = totalsales + val(getsales.sumamt)>
				<cfset profit = sales - cost>
				<cfset totalprofit = totalprofit + profit>

				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<cfif getagent.agenno eq "">
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">No - Agent</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">No - Agent</font></div></td>
					<cfelse>
						<cfquery name="getagentname" datasource="#dts#">
							select desp from icagent where agent = '#getagent.agenno#'
						</cfquery>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getagent.agenno#</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getagentname.desp#</font></div></td>
					</cfif>
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
				<cfflush>
			</cfloop>
			<tr>
				<td colspan="6"><hr></td>
			</tr>
			<tr>
				<td><div align="left"></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
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

		<cfif getagent.recordcount eq 0>
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
				<Style ss:ID="s22">
					<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
					<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
				</Style>
				<Style ss:ID="s24">
					<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
					<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="8"/>
				</Style>
				<Style ss:ID="s26">
					<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="8"/>
				</Style>
				<Style ss:ID="s29">
					<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
				   <Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="8"/>
				</Style>
				<Style ss:ID="s31">
					<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
				</Style>
				<Style ss:ID="s32">
					<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9"/>
				</Style>
				<Style ss:ID="s33">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
					</Borders>
					<NumberFormat ss:Format="#,###,###,##0.00"/>
				</Style>
				<Style ss:ID="s35">
					<NumberFormat ss:Format="Fixed"/>
				</Style>

				<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
				<cfset stDecl_UPrice = "">

				<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
					<cfset stDecl_UPrice = stDecl_UPrice & "0">
				</cfloop>

				<Style ss:ID="s36">
					<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
				</Style>
			</Styles>

			<Worksheet ss:Name="Agent_Profit_Margin">
				<Table ss:ExpandedColumnCount="7" x:FullColumns="1" x:FullRows="1">
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="3"/>
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="5" ss:StyleID="s22"><Data ss:Type="String">Profit Margin By Agent Report</Data></Cell>
					</Row>
					<cfoutput>
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">Calculated by #costingmethod#</Data></Cell>
					</Row>
					<cfif form.periodfrom neq "" and form.periodto neq "">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
						</Row>
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</Data></Cell>
						</Row>
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
							<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
					<cfif form.areafrom neq "" and form.areato neq "">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
							<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
					<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<cfwddx action = "cfml2wddx" input = "CUSTOMER: #form.custfrom# - #form.custto#" output = "wddxText">
							<Cell ss:MergeAcross="5" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
					<Row ss:AutoFitHeight="0" ss:Height="20.0625">
						<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
						<Cell ss:MergeAcross="3" ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:MergeAcross="1" ss:StyleID="s29"><Data ss:Type="String">#dateformat(now(),"dd-mm-yyyy")#</Data></Cell>
					</Row>
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:StyleID="s31"><Data ss:Type="String">Agent</Data></Cell>
						<Cell ss:StyleID="s31"><Data ss:Type="String">Agent Description</Data></Cell>
						<Cell ss:StyleID="s31"><Data ss:Type="String">Sales</Data></Cell>
                        <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                        <Cell ss:StyleID="s31"><Data ss:Type="String">Foriegn Currency Sales</Data></Cell>
                        </cfif>
						<Cell ss:StyleID="s31"><Data ss:Type="String">Cost</Data></Cell>
						<Cell ss:StyleID="s31"><Data ss:Type="String">Profit</Data></Cell>
						<Cell ss:StyleID="s31"><Data ss:Type="String">Margin</Data></Cell>
					</Row>

					<cfquery name="getagent" datasource="#dts#"><!---Agent No--->
						select agenno from artran
						where (type = 'inv' or type = 'dn' or type = 'cs') and (void = '' or void is null)
						<cfif form.agentfrom neq "" and form.agentto neq "">
						and agenno >= '#form.agentfrom#' and agenno <= '#form.agentto#'
						</cfif>
                         <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
						<cfif form.areafrom neq "" and form.areato neq "">
						and area >= '#form.areafrom#' and area <= '#form.areato#'
						</cfif>
						<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
						and custno >= '#form.custfrom#' and custno <= '#form.custto#'
						</cfif>
						<cfif form.periodfrom neq "" and form.periodto neq "">
						and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
						</cfif>
						<cfif form.datefrom neq "" and form.dateto neq "">
						and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
						<cfelse>
						and wos_date > #getgeneral.lastaccyear#
						</cfif>
						group by agenno order by agenno
					</cfquery>

					<cfset totalsales = 0>
                    <cfset totalsales2 = 0>
					<cfset totalcost = 0>
					<cfset totalprofit = 0>

					<cfloop query="getagent">
						<cfset agenno = getagent.agenno>
						<cfset sales = 0>
                        <cfset sales2 = 0>
						<cfset cost = 0>
						<cfset profit = 0>

						<cfquery name="getsales" datasource="#dts#">
							select sum(qty) as sumqty, sum(amt) as sumamt, sum(amt_bil) as sumamt_bil, sum(it_cos) as sumcost from ictran
							where (type = 'inv' or type = 'cs' or type = 'dn') and agenno = '#agenno#' and (void = '' or void is null)
                            <cfif form.radio1 eq 'item'>
                and linecode ='' or linecode is null
                <cfelseif form.radio1 eq 'serv'>
                and linecode ='SV'
                <cfelse>
                </cfif>
							<cfif form.areafrom neq "" and form.areato neq "">
							and area >= '#form.areafrom#' and area <= '#form.areato#'
							</cfif>
							<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
							and custno >= '#form.custfrom#' and custno <= '#form.custto#'
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

						<cfset cost = cost + val(getsales.sumcost)>
						<cfset sales = sales + val(getsales.sumamt)>
                        <cfset sales2 = sales2 + val(getsales.sumamt_bil)>
						<cfset totalcost = totalcost + val(getsales.sumcost)>
						<cfset totalsales = totalsales + val(getsales.sumamt)>
                        <cfset totalsales2 = totalsales2 + val(getsales.sumamt_bil)>
						<cfset profit = sales - cost>
						<cfset totalprofit = totalprofit + profit>

						<Row ss:AutoFitHeight="0">
							<cfif getagent.agenno eq "">
								<Cell ss:StyleID="s32"><Data ss:Type="String">No - Agent</Data></Cell>
								<Cell><Data ss:Type="String">No - Agent</Data></Cell>
							<cfelse>
								<cfquery name="getagentname" datasource="#dts#">
									select desp from icagent where agent = '#getagent.agenno#'
								</cfquery>
								<cfwddx action = "cfml2wddx" input = "#getagent.agenno#" output = "wddxText">
								<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
								<cfwddx action = "cfml2wddx" input = "#getagentname.desp#" output = "wddxText">
								<Cell><Data ss:Type="String"></Data>#wddxText#</Cell>
							</cfif>
							<Cell ss:StyleID="s36"><Data ss:Type="Number">#sales#</Data></Cell>
                            <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                            <Cell ss:StyleID="s36"><Data ss:Type="Number">#sales2#</Data></Cell>
                            </cfif>
							<Cell ss:StyleID="s36"><Data ss:Type="Number">#cost#</Data></Cell>
							<Cell ss:StyleID="s36"><Data ss:Type="Number">#profit#</Data></Cell>
							<cfif sales neq 0 and profit neq 0 and sales neq "">
								<Cell ss:StyleID="s35"><Data ss:Type="Number">#profit / sales * 100#</Data></Cell>
							<cfelse>
								<Cell ss:StyleID="s35"><Data ss:Type="Number">0</Data></Cell>
							</cfif>
						</Row>
					</cfloop>

					<Row ss:AutoFitHeight="0" ss:Height="12">
						<Cell ss:Index="3" ss:StyleID="s33"><Data ss:Type="Number">#totalsales#</Data></Cell>
                        <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#totalsales2#</Data></Cell>
                        </cfif>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalcost#</Data></Cell>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalprofit#</Data></Cell>
						<cfif totalsales neq 0 and totalprofit neq 0 and totalsales neq "">
							<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalprofit / totalsales * 100#</Data></Cell>
						<cfelse>
							<Cell ss:StyleID="s33"><Data ss:Type="Number">0</Data></Cell>
						</cfif>
					</Row>
					</cfoutput>
					<Row ss:AutoFitHeight="0" ss:Height="12"/>
				</Table>
			</Worksheet>
			</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Agent_Profit_Margin_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Agent_Profit_Margin_#huserid#.xls">
	</cfcase>
</cfswitch>