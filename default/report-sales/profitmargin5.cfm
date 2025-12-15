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
		<title>Profit Margin By Bill Item Report</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href = "../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
		<style type="text/css" media="print">
			.noprint { display: none; }
		</style>
		<style>
			.bstyle1 {border-style:solid;border-color:black;border-width:1;border-right:none;}
			.bstyle2 {border-style:solid;border-color:black;border-width:1;border-left:none;border-right:none}
			.bstyle3 {border-style:solid;border-color:black;border-width:1;border-left:none}
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
			<cfif lcase(HcomID) eq "chemline_i" and trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
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
				<td colspan="3"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">PD</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">TYPE</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">REF NO</font></div></td>
				<td></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CUST NO</font></div></td>
                <cfif lcase(HcomID) eq "mphcranes_i"><td>Project Code</td></cfif>
				<td></td>
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

			<cfquery name="getartran" datasource="#dts#">
				select a.refno,a.currcode,a.type,a.wos_date,a.custno,a.name,a.source from artran a
				<cfif lcase(HcomID) eq "chemline_i" and trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
					,ictran b
				</cfif>
				where (a.type = 'inv' or a.type = 'cs' or a.type = 'dn' or a.type='cn') and (a.void = '' or a.void is null)
				<cfif lcase(HcomID) eq "chemline_i" and trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
					and a.type=b.type and a.refno=b.refno
					and b.wos_group >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.groupfrom#">
					and b.wos_group <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.groupto#">
				</cfif>
               
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
				<cfif lcase(HcomID) eq "chemline_i" and form.refnofrom neq "" and form.refnoto neq "">
					and a.refno between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refnofrom#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refnoto#">
				</cfif>
				<cfif isdefined("form.sort") and form.sort eq "yes">
					group by a.refno,a.type order by a.refno
				<cfelse>
					group by a.refno,a.type order by a.wos_date,a.trdatetime
				</cfif>
			</cfquery>

			<cfloop query="getartran">
				<cfquery name="getictran" datasource="#dts#">
					select type,itemno,desp,amt as amt,amt_bil as amt_bil,it_cos,sercost 
					from ictran 
					where refno = '#getartran.refno#' and type = '#getartran.type#'
                <cfif form.radio1 eq 'item'>
                and linecode !='SV'
                <cfelseif form.radio1 eq 'serv'>
                and linecode ='SV'
                <cfelse>
                </cfif>
					<cfif lcase(HcomID) eq "chemline_i" and trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
						and wos_group >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.groupfrom#">
						and wos_group <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.groupto#">
					</cfif>
				</cfquery>
				<tr>
					<td class="bstyle1"><div align="left"><font size="1" face="Times New Roman, Times, serif"><strong>#dateformat(getartran.wos_date,"dd/mm/yyyy")#</strong></font></div></td>
					<td class="bstyle2"><div align="left"><font size="1" face="Times New Roman, Times, serif"><strong>#getartran.type#</strong></font></div></td>
					<td class="bstyle3"><div align="left"><font size="1" face="Times New Roman, Times, serif"><strong>#getartran.refno#</strong></font></div></td>
					<td></td>
					<td class="bstyle1"><div align="left"><font size="1" face="Times New Roman, Times, serif"><strong>#getartran.custno#</strong></font></div></td>
                    <cfif lcase(HcomID) eq "mphcranes_i"><td class="bstyle1"><div align="left"><font size="1" face="Times New Roman, Times, serif"><strong>#getartran.source#</strong></font></div></td></cfif>
					<td class="bstyle2"><div align="left"><font size="1" face="Times New Roman, Times, serif"><strong>#getartran.name#</strong></font></div></td>
					<td class="bstyle2">&nbsp;</td>
					<td class="bstyle2">&nbsp;</td>
					<td class="bstyle2">&nbsp;</td>
                    <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                    <td class="bstyle2">&nbsp;</td>
                    <td class="bstyle2">&nbsp;</td>
                    </cfif>
					<td class="bstyle3">&nbsp;</td>
				</tr>
				<cfloop query="getictran">
                <cfif form.radio1 eq 'serv'>
                <cfset getictran.it_cos = getictran.sercost>
                </cfif>
				<cfif getictran.type eq "CN">
						<cfset getictran.amt=-val(getictran.amt)>
						<cfset getictran.it_cos=-val(getictran.it_cos)>
					</cfif>
					<cfset totalsales = totalsales + val(getictran.amt)>
                    <cfset totalsales2 = totalsales2 + val(getictran.amt_bil)>
					<cfset totalcost = totalcost + val(getictran.it_cos)>
					<cfset totalprofit = totalprofit + val(getictran.amt - getictran.it_cos)>
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
						<td><div align="left"><font size="1" face="Times New Roman, Times, serif">#getictran.itemno#</font></div></td>
						<td><div align="left"><font size="1" face="Times New Roman, Times, serif">#getictran.desp#</font></div></td>
						<td></td>
						<td></td>
                        <cfif lcase(HcomID) eq "mphcranes_i"><td></td></cfif>
						<td></td>
						<td></td>
						<td><div align="right"><font size="1" face="Times New Roman, Times, serif">#numberformat(val(getictran.amt),stDecl_UPrice)#</font></div></td>
                        <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                        <td><div align="right"><font size="1" face="Times New Roman, Times, serif">#numberformat(val(getictran.amt_bil),stDecl_UPrice)#</font></div></td>
                         <td><div align="right"><font size="1" face="Times New Roman, Times, serif">#getartran.currcode#</font></div></td>
                        </cfif>
						<td><div align="right"><font size="1" face="Times New Roman, Times, serif">#numberformat(val(getictran.it_cos),stDecl_UPrice)#</font></div></td>
						<td><div align="right"><font size="1" face="Times New Roman, Times, serif">#numberformat(val(getictran.amt-getictran.it_cos),stDecl_UPrice)#</font></div></td>
						<cfif val(getictran.amt) neq 0 and val(getictran.amt-getictran.it_cos) neq 0>
							<td><div align="right"><font size="1" face="Times New Roman, Times, serif">#numberformat((val(getictran.amt-getictran.it_cos)/val(getictran.amt))*100,"0.00")#</font></div></td>
						<cfelse>
							<td><div align="right"><font size="1" face="Times New Roman, Times, serif">0.00</font></div></td>
						</cfif>

					</tr>
				</cfloop>
			</cfloop>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
                <cfif lcase(HcomID) eq "mphcranes_i"><td></td></cfif>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalsales,",.__")#</strong></font></div></td>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalsales2,",.__")#</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong></strong></font></div></td>
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

		</cfoutput>
		<cfif getartran.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
		</cfif>
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
  			<Style ss:ID="s29">
   				<Borders>
    				<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   				</Borders>
   				<NumberFormat ss:Format="#,###,###,##0"/>
  			</Style>
		  	<Style ss:ID="s30">
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s31">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="@"/>
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
		  	<Style ss:ID="s35">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
		  	</Style>
  			<Style ss:ID="s36">
   				<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
	   			<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
  			</Style>
  			<Style ss:ID="s37">
   				<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
   				<Font ss:FontName="Verdana" x:Family="Swiss"/>
  			</Style>
  			<Style ss:ID="s42">
   				<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
   				<Borders>
    				<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   				</Borders>
   				<Font ss:FontName="Verdana" x:Family="Swiss"/>
  			</Style>
  			<Style ss:ID="s47">
   				<Alignment ss:Vertical="Center"/>
   				<Borders>
    				<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   				</Borders>
   				<Font ss:FontName="Verdana" x:Family="Swiss"/>
   				<NumberFormat ss:Format="Short Date"/>
  			</Style>
  			<Style ss:ID="s48">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="Fixed"/>
		  	</Style>
		  	<Style ss:ID="s49">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="Fixed"/>
		  	</Style>
		  	<Style ss:ID="s50">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		   		</Borders>
		   	<NumberFormat ss:Format="Fixed"/>
		</Style>
		</Styles>
		<Worksheet ss:Name="Bill_Item_Profit_Margin_Report">
		<Table ss:ExpandedColumnCount="11" x:FullColumns="1" x:FullRows="1">
   			<Column ss:Width="64.5"/>
   			<Column ss:Width="27.75"/>
   			<Column ss:Width="53.25"/>
   			<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
   			<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
   			<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="3"/>
   			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    			<Cell ss:MergeAcross="8" ss:StyleID="s36"><Data ss:Type="String">Bill Item Profit Margin Report</Data></Cell>
   			</Row>
   			<cfoutput>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
    			<Cell ss:MergeAcross="8" ss:StyleID="s37"><Data ss:Type="String">Calculated by #costingmethod#</Data></Cell>
   			</Row>

			<cfif form.periodfrom neq "" and form.periodto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="8" ss:StyleID="s37"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="8" ss:StyleID="s37"><Data ss:Type="String">DATE: #form.datefrom# - #form.dateto#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
					<Cell ss:MergeAcross="8" ss:StyleID="s37"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
					<Cell ss:MergeAcross="8" ss:StyleID="s37"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "CUSTOMER: #form.custfrom# - #form.custto#" output = "wddxText">
					<Cell ss:MergeAcross="8" ss:StyleID="s37"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.projectfrom neq "" and form.projectto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<cfwddx action = "cfml2wddx" input = "CUSTOMER: #form.projectfrom# - #form.projectto#" output = "wddxText">
					<Cell ss:MergeAcross="8" ss:StyleID="s37"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
    			<Cell ss:MergeAcross="7" ss:StyleID="s42"><Data ss:Type="String">#wddxText#</Data></Cell>
    			<Cell ss:StyleID="s42"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
   			</Row>
			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
				<Cell ss:StyleID="s24"><Data ss:Type="String">Period</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Type</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Ref.No.</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Item No.</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Item Description</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Sales</Data></Cell>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <Cell ss:StyleID="s24"><Data ss:Type="String">Foriegn Currency Sales</Data></Cell>
                <Cell ss:StyleID="s24"><Data ss:Type="String">Currcode</Data></Cell>
                </cfif>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Cost</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Profit</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Margin</Data></Cell>
			</Row>

			<cfset totalsales = 0>
			<cfset totalcost = 0>
			<cfset totalprofit = 0>

			<cfquery name="getartran" datasource="#dts#">
				select refno,currcode,type,wos_date,custno,name,fperiod from artran
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
				<cfif lcase(HcomID) eq "chemline_i" and form.refnofrom neq "" and form.refnoto neq "">
					and refno between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refnofrom#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.refnoto#">
				</cfif>
				<cfif isdefined("form.sort") and form.sort eq "yes">
					group by refno,type order by refno
				<cfelse>
					group by refno order by wos_date
				</cfif>
			</cfquery>

			<cfloop query="getartran">
				<cfset subsales = 0>
                <cfset subsales2 = 0>
				<cfset subcost = 0>
				<cfset subprofit = 0>
				<cfwddx action = "cfml2wddx" input = "Ref.No. :#getartran.type# #getartran.refno# {#dateformat(getartran.wos_date,'dd-mm-yyyy')#} #getartran.custno# #getartran.name#" output = "wddxText">

				<Row ss:AutoFitHeight="0" ss:Height="15">
    				<Cell ss:MergeAcross="8" ss:StyleID="s35"><Data ss:Type="String">#wddxText#</Data></Cell>
   				</Row>

				<cfquery name="getictran" datasource="#dts#">
					select itemno,desp,amt as amt,amt_bil as amt_bil,it_cos,sercost  from ictran where refno = '#getartran.refno#' and type = '#getartran.type#'
                     <cfif form.radio1 eq 'item'>
                and linecode !='SV'
                <cfelseif form.radio1 eq 'serv'>
                and linecode ='SV'
                <cfelse>
                </cfif>
				</cfquery>

				<cfloop query="getictran">
                <cfif form.radio1 eq 'serv'>
                <cfset getictran.it_cos = getictran.sercost>
                </cfif>
					<cfset subsales = subsales + val(getictran.amt)>
                    <cfset subsales2 = subsales2 + val(getictran.amt_bil)>
					<cfset subcost = subcost + val(getictran.it_cos)>
					<cfset subprofit = subprofit + val(getictran.amt - getictran.it_cos)>
					<cfset totalsales = totalsales + val(getictran.amt)>
					<cfset totalcost = totalcost + val(getictran.it_cos)>
					<cfset totalprofit = totalprofit + val(getictran.amt - getictran.it_cos)>
					<Row>
    					<Cell ss:StyleID="s29"><Data ss:Type="Number">#getartran.fperiod#</Data></Cell>
    					<Cell ss:StyleID="s31"><Data ss:Type="String">#getartran.type#</Data></Cell>
    					<Cell ss:StyleID="s31"><Data ss:Type="String">#getartran.refno#</Data></Cell>
						<cfwddx action = "cfml2wddx" input = "#getictran.itemno#" output = "wddxText">
    					<Cell ss:StyleID="s31"><Data ss:Type="String">#wddxText#</Data></Cell>
						<cfwddx action = "cfml2wddx" input = "#getictran.desp#" output = "wddxText">
    					<Cell ss:StyleID="s31"><Data ss:Type="String">#wddxText#</Data></Cell>
    					<Cell ss:StyleID="s33"><Data ss:Type="Number">#val(getictran.amt)#</Data></Cell>
                        <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#val(getictran.amt_bil)#</Data></Cell>
                        <Cell ss:StyleID="s31"><Data ss:Type="String">#getartran.currcode#</Data></Cell>
                        </cfif>
    					<Cell ss:StyleID="s33"><Data ss:Type="Number">#val(getictran.it_cos)#</Data></Cell>
    					<Cell ss:StyleID="s33"><Data ss:Type="Number">#val(getictran.amt - getictran.it_cos)#</Data></Cell>
						<cfif val(getictran.amt) neq 0 and val(getictran.amt-getictran.it_cos) neq 0>
							<Cell ss:StyleID="s48"><Data ss:Type="Number">#numberformat((val(getictran.amt-getictran.it_cos)/val(getictran.amt))*100,"0.00")#</Data></Cell>
						<cfelse>
							<Cell ss:StyleID="s48"><Data ss:Type="Number">0</Data></Cell>
						</cfif>
   					</Row>
				</cfloop>
				<Row ss:Height="12">
    				<Cell ss:StyleID="s30"/>
    				<Cell ss:Index="6" ss:StyleID="s32"><Data ss:Type="Number">#subsales#</Data></Cell>
                    <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                    <Cell ss:StyleID="s32"><Data ss:Type="Number">#subsales2#</Data></Cell>
                    <Cell ss:StyleID="s32"><Data ss:Type="Number"></Data></Cell>
                    </cfif>
    				<Cell ss:StyleID="s32"><Data ss:Type="Number">#subcost#</Data></Cell>
    				<Cell ss:StyleID="s32"><Data ss:Type="Number">#subprofit#</Data></Cell>
					<cfif subsales neq 0 and subprofit neq 0>
						<Cell ss:StyleID="s49"><Data ss:Type="Number">#numberformat(subprofit/subsales*100,"0.00")#</Data></Cell>
					<cfelse>
						<Cell ss:StyleID="s49"><Data ss:Type="Number">0</Data></Cell>
					</cfif>
   				</Row>
				<Row ss:Height="12"/>
			</cfloop>
			<Row ss:Height="12"/>
   			<Row ss:Height="12">
    			<Cell ss:StyleID="s30"><Data ss:Type="String">Grand Total</Data></Cell>
    			<Cell ss:Index="6" ss:StyleID="s32"><Data ss:Type="Number">#totalsales#</Data></Cell>
    			<Cell ss:StyleID="s32"><Data ss:Type="Number">#totalcost#</Data></Cell>
    			<Cell ss:StyleID="s32"><Data ss:Type="Number">#totalprofit#</Data></Cell>
				<cfif totalsales neq 0 and totalprofit neq 0>
					<Cell ss:StyleID="s50"><Data ss:Type="Number">#numberformat(totalprofit / totalsales * 100,"0.00")#</Data></Cell>
				<cfelse>
					<Cell ss:StyleID="s50"><Data ss:Type="Number">0</Data></Cell>
				</cfif>
   			</Row>
   			</cfoutput>
  		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Bill_Item_Profit_Margin_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Bill_Item_Profit_Margin_#huserid#.xls">
	</cfcase>
</cfswitch>