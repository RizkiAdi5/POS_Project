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
		<title>Brand Sales By Type Report</title>
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

		<cfoutput>
		<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="9"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# SALES BY TYPE REPORT</strong></font></div></td>
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
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATE: #form.catefrom# - #form.cateto#</font></div></td>
				</tr>
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
				</tr>
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">TEAM: #form.teamfrom# - #form.teamto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">AREA: #form.areafrom# - #form.areato#</font></div></td>
				</tr>
			</cfif>
			<cfif form.userfrom neq "" and form.userto neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">END USER: #form.userfrom# - #form.userto#</font></div></td>
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
				<td colspan="9"><hr></td>
			</tr>
			<tr>
				<td><font size="2" face="Times New Roman, Times, serif">GROUP</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">GROUP DESCRIPTION</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">INV</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CS</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">DN</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CN</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">NET</font></div></td>
			</tr>
			<tr>
				<td colspan="9"><hr></td>
			</tr>

			<cfquery name="getbrand" datasource="#dts#">
				select a.brand,b.desp,a.itemno,sum(c.suminvamt) as suminvamt,sum(d.sumcsamt) as sumcsamt,sum(e.sumdnamt) as sumdnamt,sum(f.sumcnamt) as sumcnamt from icitem as a
				left join
				(select brand,desp from brand) as b on a.brand=b.brand
                
                left join
				(select itemno,sum(amt) as suminvamt from ictran where type='INV'
				<cfif form.areafrom neq "" and form.areato neq "">
				and area >='#form.areafrom#' and area <= '#form.areato#'
				</cfif>
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
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				group by itemno) as c on a.itemno=c.itemno

				left join
				(select itemno,sum(amt) as sumcsamt from ictran where type='CS'
				<cfif form.areafrom neq "" and form.areato neq "">
				and area >='#form.areafrom#' and area <= '#form.areato#'
				</cfif>
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
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				group by itemno) as d on a.itemno=d.itemno

				left join
				(select itemno,sum(amt) as sumdnamt from ictran where type='DN'
				<cfif form.areafrom neq "" and form.areato neq "">
				and area >='#form.areafrom#' and area <= '#form.areato#'
				</cfif>
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
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				group by itemno) as e on a.itemno=e.itemno

				left join
				(select itemno,sum(amt) as sumcnamt from ictran where type='CN'
				<cfif form.areafrom neq "" and form.areato neq "">
				and area >='#form.areafrom#' and area <= '#form.areato#'
				</cfif>
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
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				group by itemno) as f on a.itemno=f.itemno
                
                
                
				where 1=1
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category >='#form.catefrom#' and a.category <='#form.cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group >='#form.groupfrom#' and a.wos_group <='#form.groupto#'
				</cfif>
                <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
				and a.brand >='#form.brandfrom#' and a.wos_group <='#form.brandto#'
				</cfif>
				group by a.brand order by a.brand
			</cfquery>

			<cfset totalinv = 0>
			<cfset totalcs = 0>
			<cfset totaldn = 0>
			<cfset totalcn = 0>
			<cfset totalamt = 0>
			<cfset netamt = 0>

			<cfloop query="getbrand">
            
				<cfset totalinv = totalinv + val(getbrand.suminvamt)>
				<cfset totalcs = totalcs + val(getbrand.sumcsamt)>
				<cfset totaldn = totaldn + val(getbrand.sumdnamt)>
				<cfset totalcn = totalcn + val(getbrand.sumcnamt)>
				<cfset totalamt = totalamt + val(getbrand.suminvamt)+ val(getbrand.sumcsamt)+ val(getbrand.sumdnamt)>
				<cfset netamt = netamt + val(getbrand.suminvamt)+ val(getbrand.sumcsamt)+ val(getbrand.sumdnamt)-val(getbrand.sumcnamt)>
               
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<cfif getbrand.brand eq "">
						<td><font size="2" face="Times New Roman, Times, serif">No - Brand</font></td>
						<td><font size="2" face="Times New Roman, Times, serif">No - Brand</font></td>
					<cfelse>
						<td><font size="2" face="Times New Roman, Times, serif">#getbrand.brand#</font></td>
						<td><font size="2" face="Times New Roman, Times, serif">#getbrand.desp#</font></td>
					</cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getbrand.suminvamt),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getbrand.sumcsamt),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getbrand.sumdnamt),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getbrand.suminvamt)+ val(getbrand.sumcsamt)+ val(getbrand.sumdnamt),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getbrand.sumcnamt),stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getbrand.suminvamt)+ val(getbrand.sumcsamt)+ val(getbrand.sumdnamt)-val(getbrand.sumcnamt),stDecl_UPrice)#</font></div></td>
				</tr>
			</cfloop>
			<tr>
				<td colspan="9"><hr></td>
			</tr>
			<tr>
				<td align="right">&nbsp;</td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalinv,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcs,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaldn,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalamt,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcn,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(netamt,",.__")#</strong></font></div></td>
			</tr>
		</table>

		</cfoutput>
		<cfif getbrand.recordcount eq 0>
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
		  	<Style ss:ID="s27">
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

			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>

		  	<Style ss:ID="s30">
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
		<Worksheet ss:Name="Group_Sales_Report - By Type">
  		<Table ss:ExpandedColumnCount="7" x:FullColumns="1" x:FullRows="1">
   		<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="123.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="4"/>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:MergeAcross="6" ss:StyleID="s31"><Data ss:Type="String">Group Sales Report - By Type</Data></Cell>
   		</Row>
		<cfoutput>
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
		<cfif form.agentfrom neq "" and form.agentto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
				<Cell ss:MergeAcross="6" ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
				<Cell ss:MergeAcross="6" ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
			</Row>
		</cfif>

		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<cfwddx action = "cfml2wddx" input = "CATEGORY: #form.catefrom# - #form.cateto#" output = "wddxText">
    		<Cell ss:MergeAcross="5" ss:StyleID="s34"><Data ss:Type="String">#wddxText#</Data></Cell>
    		<Cell ss:StyleID="s36"><Data ss:Type="String">aa</Data></Cell>
   		</Row>

   		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Group</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Description</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">INV</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">DN</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">CS</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">CN</Data></Cell>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">NET</Data></Cell>
   		</Row>

		<cfquery name="getbrand" datasource="#dts#">
				select a.brand,b.desp,a.itemno,sum(c.suminvamt) as suminvamt,sum(d.sumcsamt) as sumcsamt,sum(e.sumdnamt) as sumdnamt,sum(f.sumcnamt) as sumcnamt from icitem as a
				left join
				(select brand,desp from brand) as b on a.brand=b.brand
                
                left join
				(select itemno,sum(amt) as suminvamt from ictran where type='INV'
				<cfif form.areafrom neq "" and form.areato neq "">
				and area >='#form.areafrom#' and area <= '#form.areato#'
				</cfif>
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
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				group by itemno) as c on a.itemno=c.itemno

				left join
				(select itemno,sum(amt) as sumcsamt from ictran where type='CS'
				<cfif form.areafrom neq "" and form.areato neq "">
				and area >='#form.areafrom#' and area <= '#form.areato#'
				</cfif>
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
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				group by itemno) as d on a.itemno=d.itemno

				left join
				(select itemno,sum(amt) as sumdnamt from ictran where type='DN'
				<cfif form.areafrom neq "" and form.areato neq "">
				and area >='#form.areafrom#' and area <= '#form.areato#'
				</cfif>
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
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				group by itemno) as e on a.itemno=e.itemno

				left join
				(select itemno,sum(amt) as sumcnamt from ictran where type='CN'
				<cfif form.areafrom neq "" and form.areato neq "">
				and area >='#form.areafrom#' and area <= '#form.areato#'
				</cfif>
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
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
				</cfif>
                <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
				group by itemno) as f on a.itemno=f.itemno
                
                
                
				where 1=1
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category >='#form.catefrom#' and a.category <='#form.cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group >='#form.groupfrom#' and a.wos_group <='#form.groupto#'
				</cfif>
                <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
				and a.brand >='#form.brandfrom#' and a.wos_group <='#form.brandto#'
				</cfif>
				group by a.brand order by a.brand
			</cfquery>

		<cfset totalinv = 0>
		<cfset totalcs = 0>
		<cfset totaldn = 0>
		<cfset totalcn = 0>
		<cfset totalamt = 0>
		<cfset netamt = 0>

		<cfloop query="getbrand">
        
       
             
			<cfset totalinv = totalinv + val(getbrand.suminvamt)>
				<cfset totalcs = totalcs + val(getbrand.sumcsamt)>
				<cfset totaldn = totaldn + val(getbrand.sumdnamt)>
				<cfset totalcn = totalcn + val(getbrand.sumcnamt)>
				<cfset totalamt = totalamt + val(getbrand.suminvamt)+ val(getbrand.sumcsamt)+ val(getbrand.sumdnamt)>
				<cfset netamt = netamt + val(getbrand.suminvamt)+ val(getbrand.sumcsamt)+ val(getbrand.sumdnamt)-val(getbrand.sumcnamt)>

			<Row ss:Height="12">
				<cfif getbrand.brand eq "">
					<Cell ss:StyleID="s27"><Data ss:Type="String">No - Brand</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">No - Brand</Data></Cell>
				<cfelse>
					<cfwddx action = "cfml2wddx" input = "#getbrand.brand#" output = "wddxText">
					<Cell ss:StyleID="s27"><Data ss:Type="String">#wddxText#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getbrand.desp#" output = "wddxText">
					<Cell ss:StyleID="s27"><Data ss:Type="String">#wddxText#</Data></Cell>
				</cfif>
				<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getbrand.suminvamt)#</Data></Cell>
				<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getbrand.sumdnamt)#</Data></Cell>
				<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getbrand.sumcsamt)#</Data></Cell>
				<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getbrand.sumcnamt)#</Data></Cell>
				<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getbrand.suminvamt)+ val(getbrand.sumcsamt)+ val(getbrand.sumdnamt)-val(getbrand.sumcnamt)#</Data></Cell>
			</Row>
		</cfloop>
		<Row ss:Height="12">
    		<Cell ss:StyleID="s28"/>
    		<Cell ss:Index="3" ss:StyleID="s29"><Data ss:Type="Number">#totalinv#</Data></Cell>
    		<Cell ss:StyleID="s29"><Data ss:Type="Number">#totaldn#</Data></Cell>
    		<Cell ss:StyleID="s29"><Data ss:Type="Number">#totalcs#</Data></Cell>
    		<Cell ss:StyleID="s29"><Data ss:Type="Number">#totalcn#</Data></Cell>
    		<Cell ss:StyleID="s29"><Data ss:Type="Number">#netamt#</Data></Cell>
   		</Row>
		</cfoutput>
   		<Row ss:Height="12"/>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Group_Sales_Report_By-Type_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Group_Sales_Report_By-Type_#huserid#.xls">
	</cfcase>
</cfswitch>