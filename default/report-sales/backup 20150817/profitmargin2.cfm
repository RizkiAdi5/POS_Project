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
		<title>Profit Margin By Bill Report</title>
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
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Print #url.trantype# Report</strong></font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Calculated by #costingmethod#</strong></font></div></td>
			</tr>
			<cfif form.periodfrom neq "" and form.periodto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
				</tr>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
				</tr>
			</cfif>
            
            <cfif form.teamfrom neq "" and form.teamto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Team: #form.teamfrom# - #form.teamto#</font></div></td>
				</tr>
			</cfif>
            
			<cfif form.areafrom neq "" and form.areato neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">AREA: #form.areafrom# - #form.areato#</font></div></td>
				</tr>
			</cfif>
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">CUSTOMER: #form.custfrom# - #form.custto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.projectfrom neq "" and form.projectto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PROJECT: #form.projectfrom# - #form.projectto#</font></div></td>
				</tr>
			</cfif>
			<tr>
				<td colspan="5"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">PD</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">TYPE</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">REF NO</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CUST NO</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">AGENT</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SALES AMT</font></div></td>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FORIEGN CURRENCY SALES AMT</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">CURRENCY CODE</font></div></td>
                </cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SALES COST</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">GROSS PROFIT</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">MARGIN (%)</font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>

			<cfset totalsales = 0>
            <cfset totalsales2 = 0>
			<cfset totalcost = 0>
			<cfset totalprofit = 0>

			<cfquery name="getsales" datasource="#dts#">
				select refno,type,fperiod,custno,sum(amt) as sumamt,sum(amt_bil) as sumamt_bil, sum(it_cos) as sumcost,agenno from ictran
				where (type = 'inv' or type = 'cs' or type = 'dn') and (void = '' or void is null)
                <cfif form.radio1 eq 'item'>
                and linecode !='SV'
                <cfelseif form.radio1 eq 'serv'>
                and linecode ='SV'
                <cfelse>
                </cfif>
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
				<cfif form.projectfrom neq "" and form.projectto neq "">
					and source >= '#form.projectfrom#' and source <= '#form.projectto#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				<cfif lcase(HcomID) eq "chemline_i" and form.refnofrom neq "" and form.refnoto neq "">
					and refno between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refnofrom#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refnoto#">
				</cfif>
				<cfif isdefined("form.sort") and form.sort eq "yes">
					group by refno,type order by refno
				<cfelse>
					group by refno order by wos_date
				</cfif>
			</cfquery>

			<cfloop query="getsales">
				<cfset profit = val(getsales.sumamt) - val(getsales.sumcost)>
				<cfset totalsales = totalsales + val(getsales.sumamt)>
                <cfset totalsales2 = totalsales2 + val(getsales.sumamt_bil)>
				<cfset totalcost = totalcost + val(getsales.sumcost)>
				<cfset totalprofit = totalprofit + profit>
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsales.fperiod#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsales.type#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsales.refno#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsales.custno#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsales.agenno#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getsales.sumamt),stDecl_UPrice)#</font></div></td>
                    <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                    <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getsales.sumamt_bil),stDecl_UPrice)#</font></div></td>
                    <cfquery name="getcurrcode" datasource="#dts#">
                    select currcode from artran where refno='#getsales.refno#' and type='#getsales.type#'
                    </cfquery>
                     <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getcurrcode.currcode#</font></div></td>
                    </cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getsales.sumcost),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(profit,stDecl_UPrice)#</font></div></td>
					<cfif val(getsales.sumamt) neq 0 and profit neq 0 and val(getsales.sumamt) neq "">
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#NumberFormat(profit / val(getsales.sumamt) * 100,"0.00")#</font></div></td>
					<cfelse>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#NumberFormat(0,"0.00")#</font></div></td>
					</cfif>
				</tr>
				<cfflush>
			</cfloop>
			<tr>
				<td colspan="9"><hr></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalsales,",.__")#</strong></font></div></td>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalsales2,",.__")#</strong></font></div></td>
                <td></td>
                </cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcost,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalprofit,",.__")#</strong></font></div></td>
				<cfif totalsales neq 0 and totalprofit neq 0 and totalsales neq "">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#NumberFormat(totalprofit / totalsales * 100,"0.00")#</strong></font></div></td>
				<cfelse>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#NumberFormat(0,"0.00")#</strong></font></div></td>
				</cfif>
			</tr>
		</table>

		<cfif getsales.recordcount eq 0>
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

	<cfcase value="EXCELDEFAULT">
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
				<NumberFormat ss:Format="#,###,###,##00"/>
			</Style>
			<Style ss:ID="s26">
				<NumberFormat ss:Format="@"/>
			</Style>

			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>

			<Style ss:ID="s27">
				<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
			</Style>
			<Style ss:ID="s29">
				<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
			</Style>
			<Style ss:ID="s33">
				<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
				<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
			</Style>
			<Style ss:ID="s34">
				<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
			<Style ss:ID="s36">
				<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
			<Style ss:ID="s38">
				<Alignment ss:Vertical="Center"/>
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
			<Style ss:ID="s41">
				<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
			<Style ss:ID="s42">
				<NumberFormat ss:Format="Fixed"/>
			</Style>
			<Style ss:ID="s43">
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<NumberFormat ss:Format="#,###,###,##0.00"/>
			</Style>
		</Styles>
		<Worksheet ss:Name="Bill_Profit_Margin_Report">
		<Table ss:ExpandedColumnCount="10" x:FullColumns="1" x:FullRows="1">
			<Column ss:Width="35.25"/>
			<Column ss:Width="27.75"/>
			<Column ss:Width="53.25"/>
			<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
			<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
			<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="2"/>
			<Column ss:Index="10" ss:AutoFitWidth="0" ss:Width="63.75"/>

			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s33"><Data ss:Type="String">Bill Profit Margin Report</Data></Cell>
			</Row>
			<cfoutput>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s34"><Data ss:Type="String">Calculated by #costingmethod#</Data></Cell>
			</Row>
			<cfif form.periodfrom neq "" and form.periodto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="8" ss:StyleID="s34"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="8" ss:StyleID="s34"><Data ss:Type="String">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
					<Cell ss:MergeAcross="8" ss:StyleID="s34"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
					<Cell ss:MergeAcross="8" ss:StyleID="s34"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "CUSTOMER: #form.custfrom# - #form.custto#" output = "wddxText">
					<Cell ss:MergeAcross="8" ss:StyleID="s34"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.projectfrom neq "" and form.projectto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "PROJECT: #form.projectfrom# - #form.projectto#" output = "wddxText">
					<Cell ss:MergeAcross="8" ss:StyleID="s34"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
				<Cell ss:MergeAcross="4" ss:StyleID="s36"><Data ss:Type="String">#wddxText#</Data></Cell>
				<Cell ss:StyleID="s38"/>
				<Cell ss:StyleID="s38"/>
				<Cell ss:MergeAcross="1" ss:StyleID="s41"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
			</Row>
			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
				<Cell ss:StyleID="s24"><Data ss:Type="String">Period</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Type</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Ref.No.</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Cust.No.</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Customer Name</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Sales</Data></Cell>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <Cell ss:StyleID="s24"><Data ss:Type="String">Foriegn Currency Sales</Data></Cell>
                <Cell ss:StyleID="s24"><Data ss:Type="String">Foriegn Code</Data></Cell>
                </cfif>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Cost</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Profit</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Margin</Data></Cell>
			</Row>
			<cfset totalsales = 0>
            <cfset totalsales2 = 0>
			<cfset totalcost = 0>
			<cfset totalprofit = 0>

			<cfquery name="getsales" datasource="#dts#">
				select refno,type,fperiod,custno,sum(amt) as sumamt,sum(amt_bil) as sumamt_bil, sum(it_cos) as sumcost,name from ictran
				where (type = 'inv' or type = 'cs' or type = 'dn') and (void = '' or void is null)
                <cfif form.radio1 eq 'item'>
                and linecode ='' or linecode is null
                <cfelseif form.radio1 eq 'serv'>
                and linecode ='SV'
                <cfelse>
                </cfif>
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
				<cfif form.projectfrom neq "" and form.projectto neq "">
					and source >= '#form.projectfrom#' and source <= '#form.projectto#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
					and wos_date > #getgeneral.lastaccyear#
				</cfif>
				<cfif lcase(HcomID) eq "chemline_i" and form.refnofrom neq "" and form.refnoto neq "">
					and refno between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refnofrom#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refnoto#">
				</cfif>
				<cfif isdefined("form.sort") and form.sort eq "yes">
				group by refno,type order by refno
				<cfelse>
				group by refno order by wos_date
				</cfif>
			</cfquery>

			 <cfloop query="getsales">
				<cfset profit = val(getsales.sumamt) - val(getsales.sumcost)>
				<cfset totalsales = totalsales + val(getsales.sumamt)>
                <cfset totalsales2 = totalsales2 + val(getsales.sumamt_bil)>
				<cfset totalcost = totalcost + val(getsales.sumcost)>
				<cfset totalprofit = totalprofit + profit>
				<Row ss:Height="12">
					<Cell ss:StyleID="s25"><Data ss:Type="Number">#getsales.fperiod#</Data></Cell>
					<Cell ss:StyleID="s26"><Data ss:Type="String">#getsales.type#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getsales.refno#" output = "wddxText">
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getsales.custno#" output = "wddxText">
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getsales.name#" output = "wddxText">
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#val(getsales.sumamt)#</Data></Cell>
                    <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                    <Cell ss:StyleID="s27"><Data ss:Type="Number">#val(getsales.sumamt_bil)#</Data></Cell>
                    <cfquery name="getcurrcode" datasource="#dts#">
                    select currcode from artran where refno='#getsales.refno#' and type='#getsales.type#'
                    </cfquery>
                    <Cell ss:StyleID="s26"><Data ss:Type="String">#getcurrcode.currcode#</Data></Cell>
                    </cfif>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#val(getsales.sumcost)#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#val(profit)#</Data></Cell>
					<cfif val(getsales.sumamt) neq 0 and profit neq 0 and val(getsales.sumamt) neq "">
						<Cell ss:StyleID="s42"><Data ss:Type="Number">#NumberFormat(profit / val(getsales.sumamt) * 100,"0.00")#</Data></Cell>
					<cfelse>
						<Cell ss:StyleID="s42"><Data ss:Type="Number">#NumberFormat(0,"0.00")#</Data></Cell>
					</cfif>
				</Row>
			</cfloop>
			<Row ss:Height="12">
				<Cell ss:StyleID="s29"/>
				<Cell ss:Index="6" ss:StyleID="s43"><Data ss:Type="Number">#numberformat(totalsales,",.__")#</Data></Cell>			
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <Cell ss:StyleID="s43"><Data ss:Type="Number">#numberformat(totalsales2,",.__")#</Data></Cell>
                <Cell ss:StyleID="s43"><Data ss:Type="Number"></Data></Cell>
                </cfif>
				<Cell ss:StyleID="s43"><Data ss:Type="Number">#numberformat(totalcost,",.__")#</Data></Cell>
				<Cell ss:StyleID="s43"><Data ss:Type="Number">#numberformat(totalprofit,",.__")#</Data></Cell>
				<cfif totalsales neq 0 and totalprofit neq 0 and totalsales neq "">
					<Cell ss:StyleID="s43"><Data ss:Type="Number">#NumberFormat(totalprofit / totalsales * 100,"0.00")#</Data></Cell>
				<cfelse>
					<Cell ss:StyleID="s43"><Data ss:Type="Number">#NumberFormat(0,"0.00")#</Data></Cell>
				</cfif>
			</Row>
			</cfoutput>
			<Row ss:Height="12"/>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Bill_Profit_Margin_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Bill_Profit_Margin_#huserid#.xls">
	</cfcase>

	<cfcase value="EXCELDISCOUNT">
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
				<NumberFormat ss:Format="#,###,###,##00"/>
			</Style>
			<Style ss:ID="s26">
				<!--- <NumberFormat ss:Format="@"/> --->
			</Style>
			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>
			<Style ss:ID="s27">
				<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
			</Style>
			<Style ss:ID="s29">
				<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
			</Style>
			<Style ss:ID="s33">
				<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
				<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
			</Style>
			<Style ss:ID="s34">
				<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
			<Style ss:ID="s36">
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<NumberFormat ss:Format="#,###,###,##0.00"/>
			</Style>
			<Style ss:ID="s37">
				<NumberFormat ss:Format="Fixed"/>
			</Style>
			<Style ss:ID="s38">
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<NumberFormat ss:Format="Fixed"/>
			</Style>
			<Style ss:ID="s39">
				<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
				 <Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
			<Style ss:ID="s41">
				<Alignment ss:Vertical="Center"/>
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
			<Style ss:ID="s44">
				<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
		</Styles>

		<Worksheet ss:Name="Bill_Profit_Margin_Report">
		<Table ss:ExpandedColumnCount="10" x:FullColumns="1" x:FullRows="1">
			<Column ss:Width="35.25"/>
			<Column ss:Width="27.75"/>
			<Column ss:Width="53.25"/>
			<Column ss:Width="54.75"/>
			<Column ss:AutoFitWidth="0" ss:Width="153.75"/>
			<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="3"/>
			<Column ss:Index="10" ss:AutoFitWidth="0" ss:Width="63.75"/>

			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
				<Cell ss:MergeAcross="9" ss:StyleID="s33"><Data ss:Type="String">Bill Profit Margin Report - After Provision for Discount</Data></Cell>
			</Row>
			<cfoutput>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="9" ss:StyleID="s34"><Data ss:Type="String">Calculated by #costingmethod#</Data></Cell>
			</Row>
			<cfif form.periodfrom neq "" and form.periodto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="9" ss:StyleID="s34"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="9" ss:StyleID="s34"><Data ss:Type="String">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
					<Cell ss:MergeAcross="9" ss:StyleID="s34"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
					<Cell ss:MergeAcross="9" ss:StyleID="s34"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "CUSTOMER: #form.custfrom# - #form.custto#" output = "wddxText">
					<Cell ss:MergeAcross="9" ss:StyleID="s34"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.projectfrom neq "" and form.projectto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "PROJECT: #form.projectfrom# - #form.projectto#" output = "wddxText">
					<Cell ss:MergeAcross="9" ss:StyleID="s34"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
				<Cell ss:MergeAcross="4" ss:StyleID="s39"><Data ss:Type="String">#wddxText#</Data></Cell>
				<Cell ss:StyleID="s41"/>
				<Cell ss:StyleID="s41"/>
				<Cell ss:StyleID="s41"/>
				<Cell ss:MergeAcross="1" ss:StyleID="s44"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
			</Row>
			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
				<Cell ss:StyleID="s24"><Data ss:Type="String">Period</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Type</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Ref.No.</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Cust.No.</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Customer Name</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Sales</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Provision Disc.</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Cost</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Profit</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Margin</Data></Cell>
			</Row>
			<cfset totalsales = 0>
			<cfset totalcost = 0>
			<cfset totalprofit = 0>
			<cfset totaldiscount = 0>

			<cfquery name="getsales" datasource="#dts#">
				select a.refno,a.type,a.fperiod,a.custno,sum(a.amt) as sumamt,b.discount, sum(a.it_cos) as sumcost,a.name from ictran a, artran b
				where (a.type = 'inv' or a.type = 'cs' or a.type = 'dn') and (a.void = '' or a.void is null) and a.refno=b.refno and a.type=b.type and a.custno=b.custno
                
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and a.agenno >= '#form.agentfrom#' and a.agenno <= '#form.agentto#'
				</cfif>
                 <cfif form.teamfrom neq "" and form.teamto neq "">
					and a.agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				<cfif form.areafrom neq "" and form.areato neq "">
				and a.area >= '#form.areafrom#' and a.area <= '#form.areato#'
				</cfif>
				<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				and a.custno >= '#form.custfrom#' and a.custno <= '#form.custto#'
				</cfif>
				<cfif form.projectfrom neq "" and form.projectto neq "">
				and a.source >= '#form.projectfrom#' and a.source <= '#form.projectto#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and a.fperiod >= '#form.periodfrom#' and a.fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
				<cfelse>
				and a.wos_date > #getgeneral.lastaccyear#
				</cfif>
				<cfif isdefined("form.sort") and form.sort eq "yes">
				group by a.refno,type order by a.refno
				<cfelse>
				group by a.refno order by a.wos_date
				</cfif>
			</cfquery>

			<cfloop query="getsales">
				<cfset profit = val(getsales.sumamt) - val(getsales.sumcost)>
				<cfset totalsales = totalsales + val(getsales.sumamt)>
				<cfset totalcost = totalcost + val(getsales.sumcost)>
				<cfset totalprofit = totalprofit + profit>
				<cfset totaldiscount = totaldiscount + val(getsales.discount)>

				<Row ss:Height="12">
					<Cell ss:StyleID="s25"><Data ss:Type="Number">#getsales.fperiod#</Data></Cell>
					<Cell ss:StyleID="s26"><Data ss:Type="String">#getsales.type#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getsales.refno#" output = "wddxText">
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getsales.custno#" output = "wddxText">
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getsales.name#" output = "wddxText">
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#val(getsales.sumamt)#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#val(getsales.discount)#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#val(getsales.sumcost)#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="Number">#val(profit)#</Data></Cell>
					<cfif val(getsales.sumamt) neq 0 and profit neq 0 and val(getsales.sumamt) neq "">
						<Cell ss:StyleID="s37"><Data ss:Type="Number">#numberformat(profit / val(getsales.sumamt) * 100,"0.00")#</Data></Cell>
					<cfelse>
						<Cell ss:StyleID="s37"><Data ss:Type="Number">#numberformat(0,"0.00")#</Data></Cell>
					</cfif>
				</Row>
			</cfloop>
			<Row ss:Height="12">
				<Cell ss:StyleID="s29"/>
				<Cell ss:Index="6" ss:StyleID="s36"><Data ss:Type="Number">#numberformat(totalsales,",.__")#</Data></Cell>
				<Cell ss:StyleID="s36"><Data ss:Type="Number">#numberformat(totaldiscount,",.__")#</Data></Cell>
				<Cell ss:StyleID="s36"><Data ss:Type="Number">#numberformat(totalcost,",.__")#</Data></Cell>
				<Cell ss:StyleID="s36"><Data ss:Type="Number">#numberformat(totalprofit,",.__")#</Data></Cell>
				<cfif totalsales neq 0 and totalprofit neq 0 and totalsales neq "">
					<Cell ss:StyleID="s38"><Data ss:Type="Number">#numberformat(totalprofit / totalsales * 100,"0.00")#</Data></Cell>
				<cfelse>
					<Cell ss:StyleID="s38"><Data ss:Type="Number">#numberformat(0,"0.00")#</Data></Cell>
				</cfif>
			</Row>
			</cfoutput>
			<Row ss:Height="12"/>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Bill_Profit_Margin-Discount_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Bill_Profit_Margin-Discount_#huserid#.xls">
	</cfcase>

	<cfcase value="EXCELXCOST">
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
				<NumberFormat ss:Format="#,###,###,##0"/>
			</Style>
			<Style ss:ID="s29">
				<NumberFormat ss:Format="@"/>
			</Style>

			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>

			<Style ss:ID="s30">
				<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
			</Style>
			<Style ss:ID="s31">
				<NumberFormat ss:Format="Fixed"/>
			</Style>
			<Style ss:ID="s32">
				<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
			</Style>
			<Style ss:ID="s33">
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<NumberFormat ss:Format="#,###,###,##0.00"/>
			</Style>
			<Style ss:ID="s34">
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<NumberFormat ss:Format="Fixed"/>
			</Style>
			<Style ss:ID="s35">
				<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
			<Style ss:ID="s37">
				<Alignment ss:Vertical="Center"/>
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
			<Style ss:ID="s40">
				<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
		</Styles>
		<Worksheet ss:Name="Bill_Profit_Margin_Report">
		<Table ss:ExpandedColumnCount="10" x:FullColumns="1" x:FullRows="1">
			<Column ss:Width="35.25"/>
			<Column ss:Width="27.75"/>
			<Column ss:Width="53.25"/>
			<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
			<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
			<Column ss:AutoFitWidth="0" ss:Width="63.75" ss:Span="4"/>

			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
				<Cell ss:MergeAcross="9" ss:StyleID="s22"><Data ss:Type="String">Bill Profit Margin Report - With Additional Cost</Data></Cell>
			</Row>
			<cfoutput>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="9" ss:StyleID="s24"><Data ss:Type="String">Calculated by #costingmethod#</Data></Cell>
			</Row>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="9" ss:StyleID="s24"><Data ss:Type="String"></Data></Cell>
			</Row>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
				<Cell ss:MergeAcross="4" ss:StyleID="s35"><Data ss:Type="String">#wddxText#</Data></Cell>
				<Cell ss:StyleID="s37"/>
				<Cell ss:StyleID="s37"/>
				<Cell ss:StyleID="s37"/>
				<Cell ss:MergeAcross="1" ss:StyleID="s40"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
			</Row>
			<cfif form.periodfrom neq "" and form.periodto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="9" ss:StyleID="s24"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="9" ss:StyleID="s24"><Data ss:Type="String">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
					<Cell ss:MergeAcross="9" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
					<Cell ss:MergeAcross="9" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "CUSTOMER: #form.custfrom# - #form.custto#" output = "wddxText">
					<Cell ss:MergeAcross="9" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.projectfrom neq "" and form.projectto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "PROJECT: #form.projectfrom# - #form.projectto#" output = "wddxText">
					<Cell ss:MergeAcross="9" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
				<Cell ss:StyleID="s27"><Data ss:Type="String">Period</Data></Cell>
				<Cell ss:StyleID="s27"><Data ss:Type="String">Type</Data></Cell>
				<Cell ss:StyleID="s27"><Data ss:Type="String">Ref.No.</Data></Cell>
				<Cell ss:StyleID="s27"><Data ss:Type="String">Cust.No.</Data></Cell>
				<Cell ss:StyleID="s27"><Data ss:Type="String">Customer Name</Data></Cell>
				<Cell ss:StyleID="s27"><Data ss:Type="String">Sales</Data></Cell>
				<Cell ss:StyleID="s27"><Data ss:Type="String">Oth.Charges</Data></Cell>
				<Cell ss:StyleID="s27"><Data ss:Type="String">Cost</Data></Cell>
				<Cell ss:StyleID="s27"><Data ss:Type="String">Profit</Data></Cell>
				<Cell ss:StyleID="s27"><Data ss:Type="String">Margin</Data></Cell>
			</Row>

			<cfset totalsales = 0>
			<cfset totalcost = 0>
			<cfset totalprofit = 0>
			<cfset totalxcost = 0>

			<cfquery name="getsales" datasource="#dts#">
				select refno,type,fperiod,custno,sum(amt) as sumamt, sum(it_cos) as sumcost,name,
				sum(m_charge1+m_charge2+m_charge3+m_charge4+m_charge5+m_charge6+m_charge7) as sumxcost from ictran
				where (type = 'inv' or type = 'cs' or type = 'dn') and (void = '' or void is null)
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
				<cfif form.projectfrom neq "" and form.projectto neq "">
				and source >= '#form.projectfrom#' and source <= '#form.projectto#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				<cfif isdefined("form.sort") and form.sort eq "yes">
				group by refno,type order by refno
				<cfelse>
				group by refno order by wos_date
				</cfif>
			</cfquery>

			<cfloop query="getsales">
				<cfset profit = val(getsales.sumamt) - val(getsales.sumcost)>
				<cfset totalsales = totalsales + val(getsales.sumamt)>
				<cfset totalcost = totalcost + val(getsales.sumcost)>
				<cfset totalprofit = totalprofit + profit>
				<cfset totalxcost = totalxcost + val(getsales.sumxcost)>

				<Row ss:AutoFitHeight="0" ss:Height="12">
					<Cell ss:StyleID="s28"><Data ss:Type="Number">#getsales.fperiod#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="String">#getsales.type#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = #getsales.refno# output = "wddxText">
					<Cell ss:StyleID="s29"><Data ss:Type="String">#wddxText#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = #getsales.custno# output = "wddxText">
					<Cell ss:StyleID="s29"><Data ss:Type="String">#wddxText#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = #getsales.name# output = "wddxText">
					<Cell ss:StyleID="s29"><Data ss:Type="String">#wddxText#</Data></Cell>
					<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getsales.sumamt)#</Data></Cell>
					<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getsales.sumxcost)#</Data></Cell>
					<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getsales.sumcost)#</Data></Cell>
					<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(profit)#</Data></Cell>
					<cfif val(getsales.sumamt) neq 0 and profit neq 0 and val(getsales.sumamt) neq "">
						<Cell ss:StyleID="s31"><Data ss:Type="Number">#numberformat(profit / val(getsales.sumamt) * 100,"0.00")#</Data></Cell>
					<cfelse>
						<Cell ss:StyleID="s31"><Data ss:Type="Number">#numberformat(0,"0.00")#</Data></Cell>
					</cfif>
				</Row>
			</cfloop>
			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s32"/>
				<Cell ss:Index="6" ss:StyleID="s33"><Data ss:Type="Number">#numberformat(totalsales,",.__")#</Data></Cell>
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#numberformat(totalxcost,",.__")#</Data></Cell>
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#numberformat(totalcost,",.__")#</Data></Cell>
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#numberformat(totalprofit,",.__")#</Data></Cell>
				<cfif totalsales neq 0 and totalprofit neq 0 and totalsales neq "">
					<Cell ss:StyleID="s34"><Data ss:Type="Number">#numberformat(totalprofit / totalsales * 100,"0.00")#</Data></Cell>
				<cfelse>
					<Cell ss:StyleID="s34"><Data ss:Type="Number">#numberformat(0,"0.00")#</Data></Cell>
				</cfif>
			</Row>
			</cfoutput>
			<Row ss:AutoFitHeight="0" ss:Height="12"/>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Bill_Profit_Margin_Additional_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Bill_Profit_Margin_Additional_#huserid#.xls">
	</cfcase>
</cfswitch>