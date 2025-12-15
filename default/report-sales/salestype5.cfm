<cfif getpin2.h4G00 eq "T">
<script language="JavaScript"> 
var popup="Sorry, right-click is disabled.";
 function noway(go) { if 
(document.all) { if (event.button == 2) { alert(popup); return false; } } if (document.layers) 
{ if (go.which == 3) { alert(popup); return false; } } } if (document.layers) 
{ document.captureEvents(Event.MOUSEDOWN); } document.onmousedown=noway;
</script>
</cfif>

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
		<title>End User Sales By Type Report</title>
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

		<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>
		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="8"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# SALES BY TYPE REPORT</strong></font></div></td>
			</tr>
			<cfif form.userfrom neq "" and form.userto neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">END USER: #form.userfrom# - #form.userto#</font></div></td>
				</tr>
			</cfif>
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
			<tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="1"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>

			<tr>
				<td colspan="8"><hr></td>
			</tr>
			<tr>
				<td><font size="2" face="Times New Roman, Times, serif">END USER</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">NAME</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">INV</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CS</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">DN</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CN</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">NET</font></div></td>
			</tr>
			<tr>
				<td colspan="8"><hr></td>
			</tr>

			<cfquery name="getenduser" datasource="#dts#">
				select van,(select name from driver where driverno=artran.van) as name from artran
				where (void = '' or void is null)
				<cfif form.userfrom neq "" and form.userto neq "">
				and van >='#form.userfrom#' and van <='#form.userto#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif ndatefrom neq "" and ndateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by van order by van
			</cfquery>

			<cfset totalinv= 0>
			<cfset totalcs= 0>
			<cfset totaldn= 0>
			<cfset totalamt= 0>
			<cfset totalcn= 0>
			<cfset netamt= 0>

			<cfloop query="getenduser">
				<cfset subinvamt = 0>
				<cfset subcsamt = 0>
				<cfset subdnamt = 0>
				<cfset subtotal = 0>
				<cfset subcnamt = 0>
				<cfset subnetamt = 0>

				<tr>
					<cfif getenduser.van eq "">
						<td><font size="2" face="Times New Roman, Times, serif"><u><strong>DRIVER NO: No - Driver</strong></u></font></td>
						<td><font size="2" face="Times New Roman, Times, serif"><u><strong>No - Driver</strong></u></font></td>
					<cfelse>
						<td><font size="2" face="Times New Roman, Times, serif"><u><strong>DRIVER NO: #getenduser.van#</strong></u></font></td>
						<td><font size="2" face="Times New Roman, Times, serif"><u><strong>#getenduser.name#</strong></u></font></td>
					</cfif>
				</tr>

				<cfquery name="getcust" datasource="#dts#">
					select a.custno,a.name,b.suminvamt,c.sumcsamt,d.sumdnamt,e.sumcnamt,(ifnull(b.suminvamt,0)+ifnull(c.sumcsamt,0)+ifnull(d.sumdnamt,0)) as total,
					(ifnull(b.suminvamt,0)+ifnull(c.sumcsamt,0)+ifnull(d.sumdnamt,0)-ifnull(e.sumcnamt,0)) as net
					from artran as a
					left join
					(select custno,sum(net)as suminvamt from artran where type = 'INV'
					and (void = '' or void is null) and van = '#getenduser.van#'
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					<cfif ndatefrom neq "" and ndateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
					group by custno) as b on a.custno=b.custno

					left join
					(select custno,sum(net)as sumcsamt from artran where type = 'CS'
					and (void = '' or void is null) and van = '#getenduser.van#'
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					<cfif ndatefrom neq "" and ndateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
					group by custno) as c on a.custno=c.custno

					left join
					(select custno,sum(net)as sumdnamt from artran where type = 'DN'
					and (void = '' or void is null) and van = '#getenduser.van#'
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					<cfif ndatefrom neq "" and ndateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
					group by custno) as d on a.custno=d.custno

					left join
					(select custno,sum(net)as sumcnamt from artran where type = 'CN'
					and (void = '' or void is null) and van = '#getenduser.van#'
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					<cfif ndatefrom neq "" and ndateto neq "">
					and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
					group by custno) as e on a.custno=e.custno

					where van = '#getenduser.van#'
					group by a.custno
				</cfquery>

				<cfloop query="getcust">
					<cfset totalinv= totalinv + val(getcust.suminvamt)>
					<cfset totalcs= totalcs + val(getcust.sumcsamt)>
					<cfset totaldn= totaldn + val(getcust.sumdnamt)>
					<cfset totalamt= totalamt + val(getcust.total)>
					<cfset totalcn= totalcn + val(getcust.sumcnamt)>
					<cfset netamt= netamt + val(getcust.net)>
					<cfset subinvamt = subinvamt + val(getcust.suminvamt)>
					<cfset subcsamt = subcsamt + val(getcust.sumcsamt)>
					<cfset subdnamt = subdnamt + val(getcust.sumdnamt)>
					<cfset subtotal = subtotal + val(getcust.total)>
					<cfset subcnamt = subcnamt + val(getcust.sumcnamt)>
					<cfset subnetamt = subnetamt + val(getcust.net)>

					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
						<td><font size="2" face="Times New Roman, Times, serif">#getcust.custno#</font></td>
						<td><font size="2" face="Times New Roman, Times, serif">#getcust.name#</font></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcust.suminvamt),stDecl_UPrice)#</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcust.sumcsamt),stDecl_UPrice)#</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcust.sumdnamt),stDecl_UPrice)#</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcust.total),stDecl_UPrice)#</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcust.sumcnamt),stDecl_UPrice)#</font></div></td>
						<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getcust.net),stDecl_UPrice)#</font></div></td>
					</tr>
				</cfloop>
				<tr>
					<td colspan="8"><hr></td>
				</tr>
				<tr>
					<td></td>
					<td><font size="2" face="Times New Roman, Times, serif">SUB-TOTAL:</font></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subinvamt,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subcsamt,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subdnamt,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subtotal,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subcnamt,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subnetamt,stDecl_UPrice)#</font></div></td>
				</tr>
			</cfloop>
			<tr>
				<td colspan="8"><hr></td>
			</tr>
			<tr>
				<td></td>
				<td><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalinv,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcs,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaldn,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalamt,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcn,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(netamt,",.__")#</strong></font></div></td>
			</tr>
		</table>

		</cfoutput>
		<cfif getenduser.recordcount eq 0>
			<h3>Sorry, No records were found.</h3>
		</cfif>

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
		  	<Style ss:ID="s26">
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s27">
		   		<NumberFormat ss:Format="#,###,###,##0"/>
		  	</Style>

			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>

		  	<Style ss:ID="s28">
		   		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  	</Style>
		  	<Style ss:ID="s29">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s30">
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s31">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0"/>
		  	</Style>
		  	<Style ss:ID="s32">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0"/>
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
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s36">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
		  	</Style>
		  	<Style ss:ID="s37">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s38">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s41">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s43">
		   		<Alignment ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		</Styles>
		<Worksheet ss:Name="Product_Sales_Report_By-Type">
  		<Table ss:ExpandedColumnCount="8" x:FullColumns="1" x:FullRows="1">
   		<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="4"/>
   		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:MergeAcross="6" ss:StyleID="s37"><Data ss:Type="String">End User Sales Report - By Type</Data></Cell>
   		</Row>
		<cfoutput>
		<cfif form.userfrom neq "" and form.userto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "END USER: #form.userfrom# - #form.userto#" output = "wddxText">
				<Cell ss:MergeAcross="6" ss:StyleID="s38"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.periodfrom neq "" and form.periodto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="6" ss:StyleID="s38"><Data ss:Type="String">PERIOD: #form.periodfrom# - #form.periodto#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="6" ss:StyleID="s38"><Data ss:Type="String">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</Data></Cell>
			</Row>
		</cfif>

		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
    		<Cell ss:MergeAcross="5" ss:StyleID="s41"><Data ss:Type="String">#wddxText#</Data></Cell>
    		<Cell ss:StyleID="s43"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
   		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:StyleID="s24"><Data ss:Type="String">END USER</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">NAME</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">INV</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">DN</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">CS</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">CN</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">NET</Data></Cell>
   		</Row>

		<cfquery name="getenduser" datasource="#dts#">
			select van,(select name from driver where driverno=artran.van) as vandesp from artran
			where (void = '' or void is null)
			<cfif form.userfrom neq "" and form.userto neq "">
			and van >='#form.userfrom#' and van <='#form.userto#'
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
			</cfif>
			<cfif ndatefrom neq "" and ndateto neq "">
			and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by van order by van
		</cfquery>

		<cfset totalinv= 0>
		<cfset totalcs= 0>
		<cfset totaldn= 0>
		<cfset totalamt= 0>
		<cfset totalcn= 0>
		<cfset netamt= 0>

		<cfloop query="getenduser">
			<cfset subinvamt = 0>
			<cfset subcsamt = 0>
			<cfset subdnamt = 0>
			<cfset subtotal = 0>
			<cfset subcnamt = 0>
			<cfset subnetamt = 0>

			<Row ss:AutoFitHeight="0" ss:Height="15">
				<cfif getenduser.van eq "">
					<Cell ss:MergeAcross="6" ss:StyleID="s36"><Data ss:Type="String">END USER: No - Driver</Data></Cell>
				<cfelse>
					<cfwddx action = "cfml2wddx" input = "END USER: #getenduser.van# - #getenduser.name#" output = "wddxText">
					<Cell ss:MergeAcross="6" ss:StyleID="s36"><Data ss:Type="String">#wddxText#</Data></Cell>
				</cfif>
   			</Row>

			<cfquery name="getcust" datasource="#dts#">
				select a.custno,a.name,b.suminvamt,c.sumcsamt,d.sumdnamt,e.sumcnamt,(ifnull(b.suminvamt,0)+ifnull(c.sumcsamt,0)+ifnull(d.sumdnamt,0)) as total,
				(ifnull(b.suminvamt,0)+ifnull(c.sumcsamt,0)+ifnull(d.sumdnamt,0)-ifnull(e.sumcnamt,0)) as net
				from artran as a
				left join
				(select custno,sum(net)as suminvamt from artran where type = 'INV'
				and (void = '' or void is null) and van = '#getenduser.van#'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif ndatefrom neq "" and ndateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by custno) as b on a.custno=b.custno

				left join
				(select custno,sum(net)as sumcsamt from artran where type = 'CS'
				and (void = '' or void is null) and van = '#getenduser.van#'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif ndatefrom neq "" and ndateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by custno) as c on a.custno=c.custno

				left join
				(select custno,sum(net)as sumdnamt from artran where type = 'DN'
				and (void = '' or void is null) and van = '#getenduser.van#'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif ndatefrom neq "" and ndateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by custno) as d on a.custno=d.custno

				left join
				(select custno,sum(net)as sumcnamt from artran where type = 'CN'
				and (void = '' or void is null) and van = '#getenduser.van#'
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif ndatefrom neq "" and ndateto neq "">
				and wos_date >='#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by custno) as e on a.custno=e.custno

				where van = '#getenduser.van#'
				group by a.custno
			</cfquery>

			<cfloop query="getcust">
				<cfset totalinv= totalinv + val(getcust.suminvamt)>
				<cfset totalcs= totalcs + val(getcust.sumcsamt)>
				<cfset totaldn= totaldn + val(getcust.sumdnamt)>
				<cfset totalamt= totalamt + val(getcust.total)>
				<cfset totalcn= totalcn + val(getcust.sumcnamt)>
				<cfset netamt= netamt + val(getcust.net)>
				<cfset subinvamt = subinvamt + val(getcust.suminvamt)>
				<cfset subcsamt = subcsamt + val(getcust.sumcsamt)>
				<cfset subdnamt = subdnamt + val(getcust.sumdnamt)>
				<cfset subtotal = subtotal + val(getcust.total)>
				<cfset subcnamt = subcnamt + val(getcust.sumcnamt)>
				<cfset subnetamt = subnetamt + val(getcust.net)>
				<Row>
					<cfwddx action = "cfml2wddx" input = "#getcust.custno#" output = "wddxText">
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getcust.name#" output = "wddxText">
					<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="Number">#val(getcust.suminvamt)#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="Number">#val(getcust.sumdnamt)#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="Number">#val(getcust.sumcsamt)#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="Number">#val(getcust.sumcnamt)#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="Number">#val(getcust.net)#</Data></Cell>
				</Row>
			</cfloop>
			<Row ss:Height="12">
    			<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s33" ss:Index="3"><Data ss:Type="Number">#subinvamt#</Data></Cell>
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#subdnamt#</Data></Cell>
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#subcsamt#</Data></Cell>
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#subcnamt#</Data></Cell>
				<Cell ss:StyleID="s33"><Data ss:Type="Number">#subnetamt#</Data></Cell>
   			</Row>
			<Row ss:Height="12"/>
		</cfloop>
		<Row ss:Height="12">
    		<Cell ss:StyleID="s30"><Data ss:Type="String">Grand Total</Data></Cell>
			<Cell ss:StyleID="s33" ss:Index="3"><Data ss:Type="Number">#totalinv#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#totaldn#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalcs#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalcn#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#netamt#</Data></Cell>
   		</Row>
		<Row ss:Height="12"/>
		</cfoutput>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\End_User_Sales_Report_By-Type_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\End_User_Sales_Report_By-Type_#huserid#.xls">
	</cfcase>
</cfswitch>