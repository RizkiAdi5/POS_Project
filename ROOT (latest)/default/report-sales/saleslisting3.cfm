<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,agentlistuserid from gsetup
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
		<cfxml variable="data">
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
		  	<Style ss:ID="s29">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
		  	</Style>
		  	<Style ss:ID="s30">
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s31">
		   		<NumberFormat ss:Format="@"/>
		  	</Style>

			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>

		  	<Style ss:ID="s32">
		   		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  	</Style>
		  	<Style ss:ID="s33">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s34">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="dd/mm/yyyy;@"/>
		  	</Style>
		  	<Style ss:ID="s35">
			   <Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
			   </Borders>
			   <NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s36">
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s37">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s39">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
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
	 	</Styles>
	 	<Worksheet ss:Name="Agent_Sales_Listing_Report">
	 	<cfoutput>
		<Table ss:ExpandedColumnCount="10" x:FullColumns="1" x:FullRows="1">
		<Column ss:Width="64.5"/>
		<Column ss:Width="47.25"/>
		<Column ss:Width="54.75"/>
		<Column ss:Width="60.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="5"/>
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:MergeAcross="8" ss:StyleID="s22"><Data ss:Type="String">Agent Sales Listing Report</Data></Cell>
		</Row>
	   <cfif form.periodfrom neq "" and form.periodto neq "">
	   		<cfwddx action = "cfml2wddx" input = "PERIOD: #form.periodfrom# - #form.periodto#" output = "wddxText">
	   		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
	   		</Row>
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
			<cfwddx action = "cfml2wddx" input = "DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#" output = "wddxText">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
	   		</Row>
		</cfif>
		<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
		 	<cfwddx action = "cfml2wddx" input = "CUST_NO: #form.custfrom# - #form.custto#" output = "wddxText">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
	   		</Row>
		</cfif>
		<cfif form.agentfrom neq "" and form.agentto neq "">
			<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
	   		</Row>
		</cfif>
		<cfif form.areafrom neq "" and form.areato neq "">
			<cfwddx action = "cfml2wddx" input = "AREA: #form.areafrom# - #form.areato#" output = "wddxText">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
	   		</Row>
		</cfif>
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
			<Cell ss:MergeAcross="7" ss:StyleID="s40"><Data ss:Type="String">#wddxText#</Data></Cell>
			<Cell ss:StyleID="s42"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
		</Row>
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:StyleID="s27"><Data ss:Type="String">Ref.No.</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Cust.No.</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Date</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">INV</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">DN</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">CS</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Total</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">CN</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Net</Data></Cell>
		</Row>

		<cfset totalinv = 0>
		<cfset totalcs = 0>
		<cfset totaldn = 0>
		<cfset totalcn = 0>
		<cfset total = 0>

		<cfquery name="getagent" datasource="#dts#">
			select agenno,(select a.desp from icagent as a where a.agent=agenno)as agentdesp from artran
			where (type = 'INV' or type = 'DN' or type = 'CN' or type = 'CS') and (void = '' or void is null)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
			and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
			and area >='#form.areafrom#' and area <='#form.areato#'
			</cfif>
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			and custno >='#form.custfrom#' and custno <= '#form.custto#'
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

		<cfloop query="getagent">
			<cfset subinv = 0>
			<cfset subcs = 0>
			<cfset subdn = 0>
			<cfset subcn = 0>
			<cfset subtotal = 0>

			<cfwddx action = "cfml2wddx" input = "AGENT: #getagent.agenno#" output = "wddxText1">
			<cfwddx action = "cfml2wddx" input = "#getagent.agentdesp#" output = "wddxText2">
			<Row ss:AutoFitHeight="0">
				<Cell ss:StyleID="s30"><Data ss:Type="String"><cfif getagent.agenno eq "">AGENT: No - Agent<cfelse>#wddxText1#</cfif></Data></Cell>
				<Cell ss:StyleID="s30"><Data ss:Type="String"><cfif getagent.agenno eq "">No - Agent<cfelse>#wddxText2#</cfif></Data></Cell>
				<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s31"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
			</Row>
			<cfquery name="getdata" datasource="#dts#">
				select refno,wos_date,net,type,custno,name from artran
				where (type = 'INV' or type = 'DN' or type = 'CN' or type = 'CS') and agenno = '#getagent.agenno#' and (void = '' or void is null)
				<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				and custno >='#form.custfrom#' and custno <= '#form.custto#'
				</cfif>
				<cfif form.areafrom neq "" and form.areato neq "">
				and area >='#form.areafrom#' and area <='#form.areato#'
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
				group by refno order by wos_date
			</cfquery>

			<cfloop query="getdata">
				<cfset inv = 0>
				<cfset dn = 0>
				<cfset cs = 0>
				<cfset cn = 0>
				<cfset amt = 0>

				<Row ss:AutoFitHeight="0">
					<Cell ss:StyleID="s30"><Data ss:Type="String">#getdata.refno#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getdata.custno# - #getdata.name#" output = "wddxText">
					<Cell ss:StyleID="s30"><Data ss:Type="String">#wddxText#</Data></Cell>
					<Cell ss:StyleID="s31"><Data ss:Type="String">#dateformat(getdata.wos_date,"dd-mm-yyyy")#</Data></Cell>
					<cfswitch expression="#getdata.type#">
						<cfcase value="INV">
							<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.net)#</Data></Cell>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<cfset inv = inv + val(getdata.net)>
							<cfset subinv = subinv + val(getdata.net)>
							<cfset totalinv = totalinv + val(getdata.net)>
						</cfcase>
						<cfcase value="DN">
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.net)#</Data></Cell>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<cfset dn = dn + val(getdata.net)>
							<cfset subdn = subdn + val(getdata.net)>
							<cfset totaldn = totaldn + val(getdata.net)>
						</cfcase>
						<cfcase value="CS">
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.net)#</Data></Cell>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<cfset cs = cs + val(getdata.net)>
							<cfset subcs = subcs + val(getdata.net)>
							<cfset totalcs = totalcs + val(getdata.net)>
						</cfcase>
						<cfcase value="CN">
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"/>
							<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.net)#</Data></Cell>
							<Cell ss:StyleID="s32"/>
							<cfset cn = cn + val(getdata.net)>
							<cfset subcn = subcn + val(getdata.net)>
							<cfset totalcn = totalcn + val(getdata.net)>
						</cfcase>
					</cfswitch>
			   	</Row>
			</cfloop>
			<cfset subtotal = subtotal + subinv + subdn + subcs>
			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s36"/>
				<Cell ss:Index="4" ss:StyleID="s37"><Data ss:Type="Number">#subinv#</Data></Cell>
				<Cell ss:StyleID="s37"><Data ss:Type="Number">#subdn#</Data></Cell>
				<Cell ss:StyleID="s37"><Data ss:Type="Number">#subcs#</Data></Cell>
				<Cell ss:StyleID="s37"><Data ss:Type="Number">#subtotal#</Data></Cell>
				<Cell ss:StyleID="s37"><Data ss:Type="Number">#subcn#</Data></Cell>
				<cfset subtotal = subtotal - subcn>
				<Cell ss:StyleID="s37"><Data ss:Type="Number">#subtotal#</Data></Cell>
			</Row>
			<Row ss:AutoFitHeight="0" ss:Height="12"/>
		</cfloop>

		<cfset total = total + totalinv + totaldn + totalcs>
		<Row ss:AutoFitHeight="0" ss:Height="12"/>
	   	<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s36"><Data ss:Type="String">Grand Total</Data></Cell>
			<Cell ss:Index="4" ss:StyleID="s37"><Data ss:Type="Number">#totalinv#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totaldn#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalcs#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#total#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalcn#</Data></Cell>
			<cfset total = total - totalcn>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#total#</Data></Cell>
	   	</Row>
	   	<Row ss:AutoFitHeight="0" ss:Height="12"/>
	  	</Table>
	  	</cfoutput>
	 	</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Agent_Sales_List_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Agent_Sales_List_#huserid#.xls">
	</cfcase>

	<cfcase value="HTML">
		<html>
		<head>
		<title>Sales Listing By Agent Report</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
		<style type="text/css" media="print">
			.noprint { display: none; }
		</style>
		</head>

		<body>
		<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
		<cfset stDecl_UPrice = ",___.">

		<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		  <cfset stDecl_UPrice = stDecl_UPrice & "_">
		</cfloop>

		<cfquery name="getagent" datasource="#dts#">
			select agenno,(select a.desp from icagent as a where a.agent=agenno)as agentdesp from artran
			where (type = 'INV' or type = 'DN' or type = 'CN' or type = 'CS') and (void = '' or void is null)
			<cfif form.agentfrom neq "" and form.agentto neq "">
			and agenno >='#form.agentfrom#' and agenno <= '#form.agentto#'
			</cfif>
            <cfif form.teamfrom neq "" and form.teamto neq "">
			and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
			</cfif>
            <cfif url.alown eq 1>
					<cfif getgeneral.agentlistuserid eq "Y">and ucase(agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agenno)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
					<cfif Huserloc neq "All_loc">
					and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
					</cfif>
			<cfif form.areafrom neq "" and form.areato neq "">
			and area >='#form.areafrom#' and area <='#form.areato#'
			</cfif>
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			and custno >='#form.custfrom#' and custno <= '#form.custto#'
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

		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="9"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# REPORT</strong></font></div></td>
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
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
				<tr>
				  <td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">CUST_NO: #form.custfrom# - #form.custto#</font></div></td>
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
			<tr>
				<td colspan="2"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
			<tr>
				<td colspan="9"><hr></td>
			</tr>
			<tr>
				<td><font size="2" face="Times New Roman, Times, serif">REF NO.</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">CUST NO</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">DATE</font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">INV</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">DN</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CS</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">CN</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">NET</font></div></td>
			</tr>
			<tr>
				<td colspan="9"><hr></td>
			</tr>

			<cfset totalinv = 0>
			<cfset totalcs = 0>
			<cfset totaldn = 0>
			<cfset totalcn = 0>
			<cfset total = 0>

			<cfloop query="getagent">
				<cfset subinv = 0>
				<cfset subcs = 0>
				<cfset subdn = 0>
				<cfset subcn = 0>
				<cfset subtotal = 0>

				<td><font size="2" face="Times New Roman, Times, serif"><strong><u><cfif getagent.agenno eq "">AGENT: No - Agent<cfelse>AGENT: #getagent.agenno#</cfif></u></strong></font></td>
				<td><font size="2" face="Times New Roman, Times, serif"><strong><u><cfif getagent.agenno eq "">No - Agent<cfelse>#getagent.agentdesp#</cfif></u></strong></font></td>

				<cfquery name="getdata" datasource="#dts#">
					select refno,wos_date,net,custno,type,name,taxincl,tax from artran
					where (type = 'INV' or type = 'DN' or type = 'CN' or type = 'CS') and agenno = '#getagent.agenno#' and (void = '' or void is null)
					<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
					and custno >='#form.custfrom#' and custno <= '#form.custto#'
					</cfif>
					<cfif form.areafrom neq "" and form.areato neq "">
					and area >='#form.areafrom#' and area <='#form.areato#'
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod >= '#form.periodfrom#' and fperiod <= '#form.periodto#'
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
					<cfelse>
					and wos_date > #getgeneral.lastaccyear#
					</cfif>
					group by refno order by wos_date
				</cfquery>

				<cfloop query="getdata">
					<cfset inv = 0>
					<cfset dn = 0>
					<cfset cs = 0>
					<cfset cn = 0>
					<cfset amt = 0>
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdata.refno#</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdata.custno# - #getdata.name#</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getdata.wos_date,"dd-mm-yyyy")#</font></div></td>
                          <cfif isdefined('form.excludetax') and getdata.taxincl eq "T">
                                <cfset getdata.net = numberformat(val(getdata.net),replace(stDecl_UPrice,',','','ALL')) -  numberformat(val(getdata.tax),replace(stDecl_UPrice,',','','ALL'))>
                           </cfif>
					  	<cfswitch expression="#getdata.type#">
							<cfcase value="INV">
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">
                              
								#numberformat(val(getdata.net),stDecl_UPrice)#
                                </font></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<cfset inv = inv + val(getdata.net)>
								<cfset subinv = subinv + val(getdata.net)>
								<cfset totalinv = totalinv + val(getdata.net)>
							</cfcase>
							<cfcase value="DN">
								<td><div align="right"></div></td>
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getdata.net),stDecl_UPrice)#</font></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<cfset dn = dn + val(getdata.net)>
								<cfset subdn = subdn + val(getdata.net)>
								<cfset totaldn = totaldn + val(getdata.net)>
							</cfcase>
							<cfcase value="CS">
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getdata.net),stDecl_UPrice)#</font></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<cfset cs = cs + val(getdata.net)>
								<cfset subcs = subcs + val(getdata.net)>
								<cfset totalcs = totalcs + val(getdata.net)>
							</cfcase>
							<cfcase value="CN">
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"></div></td>
								<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(getdata.net),stDecl_UPrice)#</font></div></td>
								<td><div align="right"></div></td>
								<cfset cn = cn + val(getdata.net)>
								<cfset subcn = subcn + val(getdata.net)>
								<cfset totalcn = totalcn + val(getdata.net)>
							</cfcase>
						</cfswitch>
					</tr>
				</cfloop>
				<cfset subtotal = subtotal + subinv + subdn + subcs>
				<tr>
					<td colspan="9"><hr></td>
				</tr>
				<tr>
					<td><div align="left"></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">SUB_TOTAL:</strong></font></div></td>
					<td><div align="left"></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subinv,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subdn,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subcs,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subtotal,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subcn,stDecl_UPrice)#</font></div></td>
					<cfset subtotal = subtotal - subcn>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subtotal,stDecl_UPrice)#</font></div></td>
				</tr>
				<tr><td><br></td></tr>
			</cfloop>
			<cfflush>
			<cfset total = total + totalinv + totaldn + totalcs>
			<tr>
				<td colspan="9"><hr></td>
			</tr>
			<tr>
				<td><div align="left"></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
				<td><div align="left"></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalinv,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaldn,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcs,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(total,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcn,",.__")#</strong></font></div></td>
				<cfset total = total - totalcn>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(total,",.__")#</strong></font></div></td>
			</tr>
		  </table>
		</cfoutput>

		<cfif getagent.recordcount eq 0>
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