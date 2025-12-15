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
		<title>Profit Margin By Customer Report</title>
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
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">TEAM: #form.teamfrom# - #form.teamto#</font></div></td>
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
			<tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">NO</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CUST NO</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">NAME</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SALES AMT</font></div></td>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FORIEGN CURRENCY SALES AMT</font></div></td>
                </cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">SALES COST</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">GROSS PROFIT</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">MARGIN (%)</font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>

			<cfset totalsales = 0>
			<cfset totalcost = 0>
			<cfset totalprofit = 0>

			<cfquery name="getsales" datasource="#dts#">
				select custno,name,sum(amt) as sumamt,sum(amt_bil) as sumamt_bil, sum(it_cos) as sumcost,(sum(amt) - sum(it_cos)) as profit, (((sum(amt) - sum(it_cos))/sum(amt))*100) as margin
				from ictran
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
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by custno order by custno
			</cfquery>

			<cfloop query="getsales">
				<cfset totalsales = totalsales + val(getsales.sumamt)>
				<cfset totalcost = totalcost + val(getsales.sumcost)>
				<cfset totalprofit = totalprofit + val(getsales.profit)>

				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsales.currentrow#.</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsales.custno#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getsales.name#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getsales.sumamt),stDecl_UPrice)#</font></div></td>
                    <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getsales.sumamt_bil),stDecl_UPrice)#</font></div></td>
                </cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getsales.sumcost),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getsales.profit),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getsales.margin),"0.00")#</font></div></td>
				</tr>
				<cfflush>
			</cfloop>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalsales,",.__")#</strong></font></div></td>
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
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s26">
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s27">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s28">
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s29">
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
		  	<Style ss:ID="s30">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
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
		   		<NumberFormat ss:Format="Fixed"/>
		  	</Style>
		  	<Style ss:ID="s36">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="Fixed"/>
		  	</Style>
		  	<Style ss:ID="s37">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="Fixed"/>
		  	</Style>
		  	<Style ss:ID="s38">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s40">
		   		<Alignment ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
		</Styles>
		<Worksheet ss:Name="Customer_Profit_Margin_Report">
  		<Table ss:ExpandedColumnCount="7" x:FullColumns="1" x:FullRows="1">
   			<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   			<Column ss:AutoFitWidth="0" ss:Width="213.75"/>
   			<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="3"/>
   			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    			<Cell ss:MergeAcross="5" ss:StyleID="s31"><Data ss:Type="String">Customer Profit Margin Report</Data></Cell>
   			</Row>
			<cfoutput>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
    			<Cell ss:MergeAcross="5" ss:StyleID="s32"><Data ss:Type="String">Calculated by #costingmethod#</Data></Cell>
   			</Row>
   			<cfif form.periodfrom neq "" and form.periodto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
    				<Cell ss:MergeAcross="5" ss:StyleID="s32"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
   				</Row>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
    				<Cell ss:MergeAcross="5" ss:StyleID="s32"><Data ss:Type="String">DATE: #form.datefrom# - #form.dateto#</Data></Cell>
   				</Row>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="5" ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
				<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="5" ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.custfrom neq "" and form.custto neq "">
				<cfwddx action = "cfml2wddx" input = "CUST NO: #form.custfrom# - #form.custto#" output = "wddxText">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="5" ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
    			<Cell ss:MergeAcross="4" ss:StyleID="s38"><Data ss:Type="String">#wddxText#</Data></Cell>
    			<Cell ss:StyleID="s40"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
   			</Row>
   			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    			<Cell ss:StyleID="s24"><Data ss:Type="String">Cust.No.</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Customer Name</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">Sales</Data></Cell>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <Cell ss:StyleID="s24"><Data ss:Type="String">Foreign Currency Sales</Data></Cell>
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
				select custno,name,sum(amt) as sumamt, sum(it_cos) as sumcost,sum(amt_bil) as sumamt_bil,(sum(amt) - sum(it_cos)) as profit, (((sum(amt) - sum(it_cos))/sum(amt))*100) as margin
				from ictran
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
				<cfif form.custfrom neq "" and form.custto neq "">
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
				group by custno order by custno
			</cfquery>

			<cfloop query="getsales">
				<cfset totalsales = totalsales + val(getsales.sumamt)>
                <cfset totalsales2 = totalsales2 + val(getsales.sumamt_bil)>
				<cfset totalcost = totalcost + val(getsales.sumcost)>
				<cfset totalprofit = totalprofit + val(getsales.profit)>

				<Row>
					<cfwddx action = "cfml2wddx" input = "#getsales.custno#" output = "wddxText">
					<Cell ss:StyleID="s27"><Data ss:Type="String">#wddxText#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getsales.name#" output = "wddxText">
					<Cell ss:StyleID="s27"><Data ss:Type="String">#wddxText#</Data></Cell>
					<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getsales.sumamt)#</Data></Cell>
                    <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                    <Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getsales.sumamt_bil)#</Data></Cell>
                    </cfif>
					<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getsales.sumcost)#</Data></Cell>
					<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getsales.profit)#</Data></Cell>
					<Cell ss:StyleID="s36"><Data ss:Type="Number">#val(getsales.margin)#</Data></Cell>
		   		</Row>
			</cfloop>

			<Row ss:Height="12">
				<Cell ss:StyleID="s28"/>
				<Cell ss:Index="3" ss:StyleID="s29"><Data ss:Type="Number">#totalsales#</Data></Cell>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <Cell ss:StyleID="s29"><Data ss:Type="Number">#totalsales2#</Data></Cell>
                </cfif>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#totalcost#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#totalprofit#</Data></Cell>
				<cfif totalsales neq 0 and totalprofit neq 0>
					<Cell ss:StyleID="s37"><Data ss:Type="Number">#NumberFormat(totalprofit / totalsales * 100,"0.00")#</Data></Cell>
				<cfelse>
					<Cell ss:StyleID="s37"><Data ss:Type="Number">0</Data></Cell>
				</cfif>
		   	</Row>
			</cfoutput>
		   	<Row ss:Height="12"/>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Customer_Profit_Margin_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Customer_Profit_Margin_#huserid#.xls">
	</cfcase>

	<cfcase value="EXCELWITHADDITIONALCOST">
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
  			<Style ss:ID="s26">
   				<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
   				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s28">
		   		<Alignment ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s29">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		  	</Style>
		  	<Style ss:ID="s30">
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>
		  	<Style ss:ID="s31">
		   		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  	</Style>
		  	<Style ss:ID="s32">
		   		<NumberFormat ss:Format="Fixed"/>
		  	</Style>
		  	<Style ss:ID="s36">
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s37">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s38">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="Fixed"/>
		  	</Style>
		 </Styles>
		 <Worksheet ss:Name="Customer_Profit_Margin_Report">
		 <Table ss:ExpandedColumnCount="8" x:FullColumns="1" x:FullRows="1">
		 	<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   			<Column ss:AutoFitWidth="0" ss:Width="213.75"/>
   			<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="4"/>
			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    			<Cell ss:MergeAcross="6" ss:StyleID="s22"><Data ss:Type="String">Customer Profit Margin Report - With Additional Cost</Data></Cell>
   			</Row>
			<cfoutput>
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
    			<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">Calculated by #costingmethod#</Data></Cell>
   			</Row>
		   	<cfif form.periodfrom neq "" and form.periodto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">DATE: #form.datefrom# - #form.dateto#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
				<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>
			<cfif form.custfrom neq "" and form.custto neq "">
				<cfwddx action = "cfml2wddx" input = "CUST NO: #form.custfrom# - #form.custto#" output = "wddxText">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
					<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
				</Row>
			</cfif>

			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
				<Cell ss:MergeAcross="5" ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
		   	</Row>

			<Row ss:AutoFitHeight="0" ss:Height="23.0625">
				<Cell ss:StyleID="s29"><Data ss:Type="String">Cust.No.</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="String">Customer Name</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="String">Sales</Data></Cell>
                <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <Cell ss:StyleID="s29"><Data ss:Type="String">Foriegn Currency Sales</Data></Cell>
                </cfif>
				<Cell ss:StyleID="s29"><Data ss:Type="String">Oth.Charges</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="String">Cost</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="String">Profit</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="String">Margin</Data></Cell>
		   	</Row>

			<cfset totalsales = 0>
            <cfset totalsales2 = 0>
			<cfset totalxcost = 0>
			<cfset totalcost = 0>
			<cfset totalprofit = 0>

			<cfquery name="getsales" datasource="#dts#">
				select custno,name,sum(amt) as sumamt,sum(amt_bil) as sumamt_bil, sum(it_cos) as sumcost,(sum(m_charge1+m_charge2+m_charge3+m_charge4+m_charge5+m_charge6+m_charge7)) as sumxcost,
				(sum(amt+m_charge1+m_charge2+m_charge3+m_charge4+m_charge5+m_charge6+m_charge7) - sum(it_cos)) as profit,
				(((sum(amt+m_charge1+m_charge2+m_charge3+m_charge4+m_charge5+m_charge6+m_charge7) - sum(it_cos))/sum(amt+m_charge1+m_charge2+m_charge3+m_charge4+m_charge5+m_charge6+m_charge7))*100) as margin
				from ictran
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
				<cfif form.custfrom neq "" and form.custto neq "">
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
				group by custno order by custno
			</cfquery>

			<cfloop query="getsales">
				<cfset totalsales = totalsales + val(getsales.sumamt)>
                <cfset totalsales2 = totalsales2 + val(getsales.sumamt_bil)>
				<cfset totalxcost = totalxcost + val(getsales.sumxcost)>
				<cfset totalcost = totalcost + val(getsales.sumcost)>
				<cfset totalprofit = totalprofit + val(getsales.profit)>

				<Row ss:AutoFitHeight="0" ss:Height="12">
					<cfwddx action = "cfml2wddx" input = "#getsales.custno#" output = "wddxText">
					<Cell ss:StyleID="s30"><Data ss:Type="String">#wddxText#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getsales.name#" output = "wddxText">
					<Cell ss:StyleID="s30"><Data ss:Type="String">#wddxText#</Data></Cell>
					<Cell ss:StyleID="s31"><Data ss:Type="Number">#val(getsales.sumamt)#</Data></Cell>
                    <cfif lcase(HcomID) eq "varz_i" or lcase(HcomID) eq "demo_i">
                <Cell ss:StyleID="s31"><Data ss:Type="Number">#val(getsales.sumamt_bil)#</Data></Cell>
                </cfif>
					<Cell ss:StyleID="s31"><Data ss:Type="Number">#val(getsales.sumxcost)#</Data></Cell>
					<Cell ss:StyleID="s31"><Data ss:Type="Number">#val(getsales.sumcost)#</Data></Cell>
					<Cell ss:StyleID="s31"><Data ss:Type="Number">#val(getsales.profit)#</Data></Cell>
					<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getsales.margin)#</Data></Cell>
				</Row>
			</cfloop>
			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s36"/>
				<Cell ss:Index="3" ss:StyleID="s37"><Data ss:Type="Number">#totalsales#</Data></Cell>
                <Cell ss:Index="3" ss:StyleID="s37"><Data ss:Type="Number">#totalsales2#</Data></Cell>
				<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalxcost#</Data></Cell>
				<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalcost#</Data></Cell>
				<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalprofit#</Data></Cell>
				<cfif totalsales neq 0 and totalprofit neq 0>
					<Cell ss:StyleID="s38"><Data ss:Type="Number">#numberformat(totalprofit / totalsales * 100,"0.00")#</Data></Cell>
				<cfelse>
					<Cell ss:StyleID="s38"><Data ss:Type="Number">0</Data></Cell>
				</cfif>
		   	</Row>
			</cfoutput>
		   	<Row ss:AutoFitHeight="0" ss:Height="12"/>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Customer_Xcost_Profit_Margin_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Customer_Xcost_Profit_Margin_#huserid#.xls">
	</cfcase>
</cfswitch>