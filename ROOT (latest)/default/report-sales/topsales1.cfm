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

<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfswitch expression="#form.result#">
	<cfcase value="HTML">
		<html>
		<head>
		<title>Top Sales Report By Customer</title>
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

		<body>
		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="11"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>TOP SALES REPORT BY CUSTOMER</strong></font></div></td>
			</tr>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			<tr>
				<td colspan="11"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
			</tr>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
				</tr>
			</cfif>
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="2" face="Times New Roman, Times, serif">CUST_NO: #form.custfrom# - #form.custto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
				</tr>
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="2" face="Times New Roman, Times, serif">TEAM: #form.teamfrom# - #form.teamto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="2" face="Times New Roman, Times, serif">AREA: #form.areafrom# - #form.areato#</font></div></td>
				</tr>
			</cfif>

			<cfswitch expression="#form.qtysold#">
				<cfcase value="yes">
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
						<td><font size="2" face="Times New Roman, Times, serif">NO.</font></td>
						<td><font size="2" face="Times New Roman, Times, serif">CUST NO.</font></td>
						<td><font size="2" face="Times New Roman, Times, serif">NAME</font></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">AGENT</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">AGENT NAME</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY SOLD</font></div></td>
					</tr>
					<tr>
						<td colspan="6"><hr></td>
					</tr>

					<cfquery name="getcustomername" datasource="#dts#">
						select a.custno,a.name,a.agent,(select desp from icagent where agent=a.agent) as agentdesp,b.sumqty
						from #target_arcust# as a
						left join
						(select custno,sum(qty)as sumqty from ictran where (type='INV' or type='CS' or type='DN') and (void = '' or void is null)
						<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
						and custno between '#form.custfrom#' and '#form.custto#'
						</cfif>
						<cfif form.periodfrom neq "" and form.periodto neq "">
						and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
						</cfif>
						<cfif ndatefrom neq "" and ndateto neq "">
						and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
						<cfelse>
						and wos_date > #getgeneral.lastaccyear#
						</cfif>
						group by custno) as b on a.custno=b.custno

						where a.custno <> ''
						<cfif isdefined("form.include0")>
						and ifnull(b.sumqty,0)>=0
						<cfelse>
						and ifnull(b.sumqty,0)>0
						</cfif>
						<cfif form.areafrom neq "" and form.areato neq "">
						and a.area >='#form.areafrom#' and a.area <='#form.areato#'
						</cfif>
						<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
						and a.custno between '#form.custfrom#' and '#form.custto#'
						</cfif>
						<cfif form.agentfrom neq "" and form.agentto neq "">
						and a.agent >='#form.agentfrom#' and a.agent <= '#form.agentto#'
						</cfif>
                        <cfif form.teamfrom neq "" and form.teamto neq "">
				and a.agent in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
						group by a.custno order by b.sumqty desc
						<cfif form.rangeto neq "">
							limit #form.rangeto#
						</cfif>
					</cfquery>

					<cfset totalqty = 0>

					<cfloop query="getcustomername">
						<cfset totalqty = totalqty + val(getcustomername.sumqty)>
						<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
							<td><font size="2" face="Times New Roman, Times, serif">#getcustomername.currentrow#.</font></td>
							<td><font size="2" face="Times New Roman, Times, serif">#getcustomername.custno#</font></td>
							<td><font size="2" face="Times New Roman, Times, serif">#getcustomername.name#</font></td>
							<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getcustomername.agent#</font></div></td>
							<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getcustomername.agentdesp#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcustomername.sumqty),"0")#</font></div></td>
						</tr>
					</cfloop>
					<tr>
						<td colspan="6"><hr></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalqty,"0")#</strong></font></div></td>
					</tr>
				</cfcase>

				<cfdefaultcase>
					<tr>
						<td colspan="4"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
					</tr>
					<tr>
						<td colspan="11"><hr></td>
					</tr>
					<tr>
						<td><font size="2" face="Times New Roman, Times, serif">NO.</font></td>
						<td><font size="2" face="Times New Roman, Times, serif">CUST NO.</font></td>
						<td><font size="2" face="Times New Roman, Times, serif">NAME</font></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">AGENT</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY SOLD</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">INV</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">DN</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CS</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CN</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">NET</font></div></td>
					</tr>
					<tr>
						<td colspan="11"><hr></td>
					</tr>
					<cfquery name="getcustomername" datasource="#dts#">
						select a.custno,a.name,a.agent,(select desp from icagent where agent=a.agent) as agentdesp,b.sumqty,
						c.suminvamt,d.sumcsamt,e.sumdnamt,f.sumcnamt,(ifnull(c.suminvamt,0)+ifnull(d.sumcsamt,0)+ifnull(e.sumdnamt,0)) as total,
						(ifnull(c.suminvamt,0)+ifnull(d.sumcsamt,0)+ifnull(e.sumdnamt,0)-ifnull(f.sumcnamt,0)) as net
						from #target_arcust# as a
						left join
						(select custno,sum(qty)as sumqty from ictran where (type='INV' or type='CS' or type='DN') and (void = '' or void is null)
						<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
						and custno between '#form.custfrom#' and '#form.custto#'
						</cfif>
						<cfif form.periodfrom neq "" and form.periodto neq "">
						and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
						</cfif>
						<cfif ndatefrom neq "" and ndateto neq "">
						and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
						<cfelse>
						and wos_date > #getgeneral.lastaccyear#
						</cfif>
						group by custno) as b on a.custno=b.custno

						left join
						(select custno,sum(amt)as suminvamt from ictran where type='INV' and (void = '' or void is null)
						<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
						and custno between '#form.custfrom#' and '#form.custto#'
						</cfif>
						<cfif form.periodfrom neq "" and form.periodto neq "">
						and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
						</cfif>
						<cfif ndatefrom neq "" and ndateto neq "">
						and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
						<cfelse>
						and wos_date > #getgeneral.lastaccyear#
						</cfif>
						group by custno) as c on a.custno=c.custno

						left join
						(select custno,sum(amt)as sumcsamt from ictran where type='CS' and (void = '' or void is null)
						<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
						and custno between '#form.custfrom#' and '#form.custto#'
						</cfif>
						<cfif form.periodfrom neq "" and form.periodto neq "">
						and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
						</cfif>
						<cfif ndatefrom neq "" and ndateto neq "">
						and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
						<cfelse>
						and wos_date > #getgeneral.lastaccyear#
						</cfif>
						group by custno) as d on a.custno=d.custno

						left join
						(select custno,sum(amt)as sumdnamt from ictran where type='DN' and (void = '' or void is null)
						<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
						and custno between '#form.custfrom#' and '#form.custto#'
						</cfif>
						<cfif form.periodfrom neq "" and form.periodto neq "">
						and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
						</cfif>
						<cfif ndatefrom neq "" and ndateto neq "">
						and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
						<cfelse>
						and wos_date > #getgeneral.lastaccyear#
						</cfif>
						group by custno) as e on a.custno=e.custno

						left join
						(select custno,sum(amt)as sumcnamt from ictran where type='CN' and (void = '' or void is null)
						<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
						and custno between '#form.custfrom#' and '#form.custto#'
						</cfif>
						<cfif form.periodfrom neq "" and form.periodto neq "">
						and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
						</cfif>
						<cfif ndatefrom neq "" and ndateto neq "">
						and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
						<cfelse>
						and wos_date > #getgeneral.lastaccyear#
						</cfif>
						group by custno) as f on a.custno=f.custno

						where a.custno <> ''
						<cfif isdefined("form.include0")>
						and ifnull(b.sumqty,0)>=0 and (ifnull(c.suminvamt,0)+ifnull(d.sumcsamt,0)+ifnull(e.sumdnamt,0))>=0
						<cfelse>
						and ifnull(b.sumqty,0)>0 or (ifnull(c.suminvamt,0)+ifnull(d.sumcsamt,0)+ifnull(e.sumdnamt,0))>0
						</cfif>
						<cfif form.areafrom neq "" and form.areato neq "">
						and a.area >='#form.areafrom#' and a.area <='#form.areato#'
						</cfif>
						<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
						and a.custno >='#form.custfrom#' and a.custno <= '#form.custto#'
						</cfif>
						<cfif form.agentfrom neq "" and form.agentto neq "">
						and a.agent >='#form.agentfrom#' and a.agent <= '#form.agentto#'
						</cfif>
                        <cfif form.teamfrom neq "" and form.teamto neq "">
				and a.agent in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
						group by a.custno order by net desc
						<cfif form.rangeto neq "">
							limit #form.rangeto#
						</cfif>
					</cfquery>

					<cfset totalinv = 0>
					<cfset totaldn = 0>
					<cfset totalcs = 0>
					<cfset totalcn = 0>
					<cfset totalamt = 0>
					<cfset totalqty = 0>
					<cfset totalnet = 0>

					<cfloop query="getcustomername">
						<cfset totalinv = totalinv + val(getcustomername.suminvamt)>
						<cfset totaldn = totaldn + val(getcustomername.sumdnamt)>
						<cfset totalcs = totalcs + val(getcustomername.sumcsamt)>
						<cfset totalcn = totalcn + val(getcustomername.sumcnamt)>
						<cfset totalamt = totalamt + val(getcustomername.total)>
						<cfset totalqty = totalqty + val(getcustomername.sumqty)>
						<cfset totalnet = totalnet + val(getcustomername.net)>
						<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
							<td><font size="2" face="Times New Roman, Times, serif">#getcustomername.currentrow#.</font></td>
							<td><font size="2" face="Times New Roman, Times, serif">#getcustomername.custno#</font></td>
							<td><font size="2" face="Times New Roman, Times, serif">#getcustomername.name#</font></td>
							<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getcustomername.agent#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcustomername.sumqty),"0")#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcustomername.suminvamt),stDecl_UPrice)#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcustomername.sumdnamt),stDecl_UPrice)#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcustomername.sumcsamt),stDecl_UPrice)#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcustomername.total),stDecl_UPrice)#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcustomername.sumcnamt),stDecl_UPrice)#</font></div></td>
							<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcustomername.net),stDecl_UPrice)#</font></div></td>
						</tr>
					</cfloop>
					<tr>
						<td colspan="11"><hr></td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalqty,"0")#</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalinv,",.__")#</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaldn,",.__")#</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcs,",.__")#</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalamt,",.__")#</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcn,",.__")#</strong></font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalnet,",.__")#</strong></font></div></td>
					</tr>
				</cfdefaultcase>
			</cfswitch>
		</cfoutput>
		</table>

		<cfif getcustomername.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
		</cfif>

		<br>
		<br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
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

			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>

		  	<Style ss:ID="s26">
		   		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
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
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s30">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s31">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s32">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s34">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s36">
		   		<Alignment ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		</Styles>
		<Worksheet ss:Name="Top_Sales_Report_By - Customer">
  		<Table ss:ExpandedColumnCount="9" x:FullColumns="1" x:FullRows="1">
		<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="4"/>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:MergeAcross="7" ss:StyleID="s31"><Data ss:Type="String">Top Sales Report - By Customer</Data></Cell>
   		</Row>
		<cfoutput>
		<cfif form.periodfrom neq "" and form.periodto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s32"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s32"><Data ss:Type="String">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</Data></Cell>
			</Row>
		</cfif>
		<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "CUSTOMER: #form.custfrom# - #form.custto#" output = "wddxText">
				<Cell ss:MergeAcross="8" ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.agentfrom neq "" and form.agentto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
				<Cell ss:MergeAcross="8" ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
				<Cell ss:MergeAcross="8" ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>

		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
    		<Cell ss:MergeAcross="7" ss:StyleID="s34"><Data ss:Type="String">#wddxText#</Data></Cell>
    		<Cell ss:StyleID="s36"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
   		</Row>

   		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Cust No.</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">Customer Name</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">Business</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">QTY</Data></Cell>
			<cfif form.qtysold eq "no">
				<Cell ss:StyleID="s24"><Data ss:Type="String">INV</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">DN</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">CS</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">CN</Data></Cell>
				<Cell ss:StyleID="s24"><Data ss:Type="String">NET</Data></Cell>
			</cfif>
   		</Row>

		<cfquery name="getcustomername" datasource="#dts#">
			select a.custno,a.name,a.business,b.sumqty,
			c.suminvamt,d.sumcsamt,e.sumdnamt,f.sumcnamt,(ifnull(c.suminvamt,0)+ifnull(d.sumcsamt,0)+ifnull(e.sumdnamt,0)) as total,
			(ifnull(c.suminvamt,0)+ifnull(d.sumcsamt,0)+ifnull(e.sumdnamt,0)-ifnull(f.sumcnamt,0)) as net
			from #target_arcust# as a
			left join
			(select custno,sum(qty)as sumqty from ictran where (type='INV' or type='CS' or type='DN') and (void = '' or void is null)
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			and custno between '#form.custfrom#' and '#form.custto#'
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
			</cfif>
			<cfif ndatefrom neq "" and ndateto neq "">
			and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by custno) as b on a.custno=b.custno

			left join
			(select custno,sum(amt)as suminvamt from ictran where type='INV' and (void = '' or void is null)
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			and custno between '#form.custfrom#' and '#form.custto#'
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
			</cfif>
			<cfif ndatefrom neq "" and ndateto neq "">
			and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by custno) as c on a.custno=c.custno

			left join
			(select custno,sum(amt)as sumcsamt from ictran where type='CS' and (void = '' or void is null)
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			and custno between '#form.custfrom#' and '#form.custto#'
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
			</cfif>
			<cfif ndatefrom neq "" and ndateto neq "">
			and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by custno) as d on a.custno=d.custno

			left join
			(select custno,sum(amt)as sumdnamt from ictran where type='DN' and (void = '' or void is null)
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			and custno between '#form.custfrom#' and '#form.custto#'
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
			</cfif>
			<cfif ndatefrom neq "" and ndateto neq "">
			and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by custno) as e on a.custno=e.custno

			left join
			(select custno,sum(amt)as sumcnamt from ictran where type='CN' and (void = '' or void is null)
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			and custno between '#form.custfrom#' and '#form.custto#'
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
			</cfif>
			<cfif ndatefrom neq "" and ndateto neq "">
			and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by custno) as f on a.custno=f.custno

			where a.custno <> ''
			<cfif isdefined("form.include0")>
			and ifnull(b.sumqty,0)>=0 and (ifnull(c.suminvamt,0)+ifnull(d.sumcsamt,0)+ifnull(e.sumdnamt,0))>=0
			<cfelse>
			and ifnull(b.sumqty,0)>0 or (ifnull(c.suminvamt,0)+ifnull(d.sumcsamt,0)+ifnull(e.sumdnamt,0))>0
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
			and a.area >='#form.areafrom#' and a.area <='#form.areato#'
			</cfif>
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			and a.custno between '#form.custfrom#' and '#form.custto#'
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and a.agent >='#form.agentfrom#' and a.agent <= '#form.agentto#'
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
				and a.agent in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
			group by a.custno order by 
			<cfif form.qtysold eq "no">
				net desc
			<cfelse>
				b.sumqty desc
			</cfif>
			
			<cfif form.rangeto neq "">
				limit #form.rangeto#
			</cfif>
		</cfquery>

		<cfset totalinv = 0>
		<cfset totaldn = 0>
		<cfset totalcs = 0>
		<cfset totalcn = 0>
		<cfset totalamt = 0>
		<cfset totalqty = 0>
		<cfset totalnet = 0>

		<cfloop query="getcustomername">
			<cfset totalinv = totalinv + val(getcustomername.suminvamt)>
			<cfset totaldn = totaldn + val(getcustomername.sumdnamt)>
			<cfset totalcs = totalcs + val(getcustomername.sumcsamt)>
			<cfset totalcn = totalcn + val(getcustomername.sumcnamt)>
			<cfset totalamt = totalamt + val(getcustomername.total)>
			<cfset totalqty = totalqty + val(getcustomername.sumqty)>
			<cfset totalnet = totalnet + val(getcustomername.net)>
			<Row ss:Height="12">
				<cfwddx action = "cfml2wddx" input = "#getcustomername.custno#" output = "wddxText">
				<Cell ss:StyleID="s25"><Data ss:Type="String">#wddxText#</Data></Cell>
				<cfwddx action = "cfml2wddx" input = "#getcustomername.name#" output = "wddxText">
				<Cell ss:StyleID="s25"><Data ss:Type="String">#wddxText#</Data></Cell>
				<cfwddx action = "cfml2wddx" input = "#getcustomername.business#" output = "wddxText">
				<Cell ss:StyleID="s25"><Data ss:Type="String">#wddxText#</Data></Cell>
				<Cell ss:StyleID="s26"><Data ss:Type="Number">#val(getcustomername.sumqty)#</Data></Cell>
				<cfif form.qtysold eq "no">
					<Cell ss:StyleID="s26"><Data ss:Type="Number">#val(getcustomername.suminvamt)#</Data></Cell>
					<Cell ss:StyleID="s26"><Data ss:Type="Number">#val(getcustomername.sumdnamt)#</Data></Cell>
					<Cell ss:StyleID="s26"><Data ss:Type="Number">#val(getcustomername.sumcsamt)#</Data></Cell>
					<Cell ss:StyleID="s26"><Data ss:Type="Number">#val(getcustomername.sumcnamt)#</Data></Cell>
					<Cell ss:StyleID="s26"><Data ss:Type="Number">#val(getcustomername.net)#</Data></Cell>
				</cfif>
			</Row>
		</cfloop>
		<Row ss:Height="12">
			<Cell ss:StyleID="s28"/>
			<Cell ss:Index="4" ss:StyleID="s29"><Data ss:Type="Number">#totalqty#</Data></Cell>
			<cfif form.qtysold eq "no">
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#totalinv#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#totaldn#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#totalcs#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#totalcn#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#totalnet#</Data></Cell>
			</cfif>
		</Row>
   		</cfoutput>
   		<Row ss:Height="12"/>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Customer_Sales_Report_By-Type_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Customer_Sales_Report_By-Type_#huserid#.xls">
	</cfcase>
</cfswitch>