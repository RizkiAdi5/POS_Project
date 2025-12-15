<cfparam name="listperiod" default="0">
<cfparam name="listDateHeader" default="">
<cfparam name="rowTotal" default="0">
<cfparam name="total" default="0">

<cfquery name="getgeneral" datasource="#dts#">
	select compro from gsetup
</cfquery>

<cfquery name="getperiod" datasource="#dts#">
	select lastaccyear from gsetup
</cfquery>

<cfif isdefined("form.period")>
	<cfset indexFrom=(period-1)*2+1>
	<cfset indexTo=indexFrom+5>

	<cfswitch expression="#period#">
		<cfcase value="1">
			<cfset listperiod=1>
			<cfset dispPeriod="PERIOD 1 - 6">
			<cfset totalField=9>
            <cfset indexFrom=1>
			<cfset indexTo=6>
		</cfcase>
		<cfcase value="2">
			<cfset listperiod=7>
			<cfset dispPeriod="PERIOD 7 - 12">
            <cfset indexFrom=7>
			<cfset indexTo=12>
			<cfset totalField=9>
		</cfcase>
		<cfcase value="3">
		<cfset listperiod=13>
		<cfset dispPeriod="PERIOD 13 - 18">
		<cfset indexFrom=13>
		<cfset indexTo=18>
        <cfset totalField=9>
        </cfcase>
		<cfdefaultcase>
			<cfset dispPeriod="ONE YEAR">
			<cfset indexFrom=1>
			<cfset indexTo=18>
			<cfset totalField=21>
		</cfdefaultcase>
	</cfswitch>
</cfif>

<cfloop from="#indexFrom#" to="#indexTo#" index="i">
	<cfset reportmonth=month(getperiod.lastaccyear)+i>
	<cfif (reportmonth mod 12) eq 0><cfset reportmonth=12>
	<cfelse><cfset reportmonth=(reportmonth mod 12)>
	</cfif>
	<cfset listDateHeader=listappend(listDateHeader,dateformat(createdate(2002,reportmonth,1),"mmm"))>
</cfloop>

<cfinvoke component="reportpurchase" method="getVendorMonthContent" returnvariable="cfcContent">
	<cfinvokeargument name="dts" value="#dts#">
	<cfinvokeargument name="periodDate" value="#getperiod.lastaccyear#">
	<cfinvokeargument name="suppFrom" value="#trim(form.suppfrom)#">
	<cfinvokeargument name="suppTo" value="#trim(form.suppto)#">
	<cfinvokeargument name="period" value="#form.period#">
	<cfinvokeargument name="indexFrom" value="#indexFrom#">
	<cfinvokeargument name="indexTo" value="#indexTo#">
</cfinvoke>

<cfquery dbtype="query" name="subTotalContent">
	select sum(sumamt#indexFrom#) as temp<cfloop from="#indexFrom#" to="#indexTo#" index="i">,sum(sumamt#i#) as ttl#i#</cfloop>
	from cfcContent
</cfquery>

<cfswitch expression="#form.result#">
	<cfcase value="EXCELDEFAULT">
		<cfquery name="getgsetup2" datasource='#dts#'>
			select Decl_UPrice from gsetup2
		</cfquery>
	
		<cfset iDecl_UPrice=getgsetup2.Decl_UPrice>
		<cfset stDecl_UPrice="">
		
		<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
			<cfset stDecl_UPrice=stDecl_UPrice&"0">
		</cfloop>

		<cfxml variable="data">
		<?xml version="1.0"?>
		<?mso-application progid="Excel.Sheet"?>
		<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
		xmlns:o="urn:schemas-microsoft-com:office:office"
		xmlns:x="urn:schemas-microsoft-com:office:excel"
		xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
		xmlns:html="http://www.w3.org/TR/REC-html40">
		<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
		<Author>Netiquette Technology</Author>
		<LastAuthor>Netiquette Technology</LastAuthor>
		<Company>Netiquette Technology</Company>
		</DocumentProperties>
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
		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		</Style>
		<Style ss:ID="s27">
		<Borders>
		<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		</Borders>
		<NumberFormat ss:Format="@"/>
		</Style>
		<Style ss:ID="s28">
		<Borders>
		<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		</Borders>
		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		</Style>
		<Style ss:ID="s29">
		<Borders>
		<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		</Borders>
		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
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
		<Style ss:ID="s36">
		<Alignment ss:Vertical="Center"/>
		<Borders>
		<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		</Borders>
		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		</Style>
		<Style ss:ID="s38">
		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		<Borders>
		<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		</Borders>
		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		</Style>
		</Styles>
		<Worksheet ss:Name="Vendor Supply Report">
		<cfoutput>
		<Table  x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="11.25">
		<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="#totalField#"/>
		
		<cfwddx action = "cfml2wddx" input = "#trantype# REPORT (By Month)" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:MergeAcross="#(totalField-1)#" ss:StyleID="s31"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
		
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:MergeAcross="#(totalField-1)#" ss:StyleID="s32"><Data ss:Type="String">#dispPeriod#</Data></Cell>
		</Row>
		
		<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="#(totalField-2)#" ss:StyleID="s38"><Data ss:Type="String">#wddxText#</Data></Cell>
			<Cell ss:StyleID="s36"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
		</Row>
		
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:StyleID="s24"><Data ss:Type="String">VEND NO.</Data></Cell>
			<Cell ss:StyleID="s24"><Data ss:Type="String">NAME</Data></Cell>
			<cfloop from="1" to="#listlen(listDateHeader)#" index="i">
			<Cell ss:StyleID="s24"><Data ss:Type="String">#listgetat(listDateHeader,i)#</Data></Cell>
			</cfloop>
			<Cell ss:StyleID="s24"><Data ss:Type="String">Total</Data></Cell>
		</Row>
		
		<cfloop query="cfcContent">
			<cfset rowTotal=0>
			<cfwddx action = "cfml2wddx" input = "#custno#" output = "wddxText">
			<cfwddx action = "cfml2wddx" input = "#name#" output = "wddxText2">
			<Row ss:Height="12">
				<Cell ss:StyleID="s25"><Data ss:Type="String">#wddxText#</Data></Cell>
				<Cell ss:StyleID="s25"><Data ss:Type="String">#wddxText2#</Data></Cell>
				<cfloop from="#indexFrom#" to="#indexTo#" index="i"><cfset temp1=evaluate("sumamt#i#")><cfset rowTotal=rowTotal+temp1>
				<Cell ss:StyleID="s26"><Data ss:Type="Number">#temp1#</Data></Cell>
				</cfloop>
				<Cell ss:StyleID="s26"><Data ss:Type="Number">#rowTotal#</Data></Cell>
			</Row>
		</cfloop>
		<cfif cfcContent.recordcount gt 0>
		<Row ss:Height="12">
			<Cell ss:StyleID="s28"/>
			<Cell ss:StyleID="s28"><Data ss:Type="String">Total</Data></Cell>
			<cfloop from="#indexFrom#" to="#indexTo#" index="i"><cfset total=total+evaluate("subTotalContent.ttl#i#")>
			<Cell ss:StyleID="s29"><Data ss:Type="Number">#evaluate("subTotalContent.ttl#i#")#</Data></Cell>
			</cfloop>
			<Cell ss:StyleID="s29"><Data ss:Type="Number">#total#</Data></Cell>
		</Row>
		</cfif>
		<Row ss:Height="12"/>
		</Table>
		</cfoutput>
		<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
		<Unsynced/>
		<Print>
		<ValidPrinterInfo/>
		<Scale>60</Scale>
		<HorizontalResolution>600</HorizontalResolution>
		<VerticalResolution>600</VerticalResolution>
		</Print>
		<Selected/>
		<Panes>
		<Pane>
		<Number>3</Number>
		<ActiveRow>20</ActiveRow>
		<ActiveCol>3</ActiveCol>
		</Pane>
		</Panes>
		<ProtectObjects>False</ProtectObjects>
		<ProtectScenarios>False</ProtectScenarios>
		</WorksheetOptions>
		</Worksheet>
		</Workbook>
		</cfxml>
	
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#_PR_VSM_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#_PR_VSM_#huserid#.xls">
	</cfcase>

	<cfcase value="HTML">
		<html>
		<head>
			<title>Purchase Report By Month</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
			<style type="text/css" media="print">
				.noprint { display: none; }
			</style>
		</head>
		
		<body>
		<cfif cfcContent.recordcount eq 0><h3>Sorry, No records were found.</h3><cfabort></cfif>
		
		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="9"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# REPORT (By Month)</strong></font></div></td>
		</tr>
		<tr>
			<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">#dispPeriod#</font></div></td>
		</tr>
		<tr>
			<td colspan="4"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		<tr><td colspan="21"><hr></td></tr>
		<tr>
			<td><font size="2" face="Times New Roman, Times, serif">VEND NO.</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">NAME</font></td>
			<cfloop from="1" to="#listlen(listDateHeader)#" index="i">
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#listgetat(listDateHeader,i)#</font></div></td>
			</cfloop>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
		</tr>
		<tr><td colspan="21"><hr></td></tr>
	
		<cfloop query="cfcContent">
			<cfset rowTotal=0>
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><font size="2" face="Times New Roman, Times, serif">#custno#</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">#name#</font></td>
				<cfloop from="#indexFrom#" to="#indexTo#" index="i"><cfset temp1=evaluate("sumamt#i#")><cfset rowTotal = rowTotal + temp1>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(temp1,"(0.00)")#</font></div></td>
				</cfloop>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(rowTotal,"(0.00)")#</font></div></td>
			</tr>
		</cfloop>
		<tr><td colspan="22"><hr></td></tr>
		<tr>
			<td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
			<cfloop from="#indexFrom#" to="#indexTo#" index="i"><cfset total=total+evaluate("subTotalContent.ttl#i#")>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(evaluate("subTotalContent.ttl#i#"),"(0.00)")#</font></div></td>
			</cfloop>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(total,"(0.00)")#</font></div></td>
		</tr>
		</table>
		</cfoutput>
		<br>
		<br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>
		</html>
	</cfcase>
</cfswitch>

<!---
<html>
<head>
<title>Purchase Report By Month</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfparam name="listperiod" default="0">
<cfparam name="vtotal" default="0">
<cfparam name="htotal" default="0">
<cfparam name="subtotal" default="0">
<cfset monthtotal = arraynew(2)>

<cfif isdefined("form.period") and period eq "1">
   	<cfset listperiod=1>
<cfelseif isdefined("form.period") and period eq "2">
  	<cfset listperiod=7>
<cfelseif isdefined("form.period") and period eq "3">
  	<cfset listperiod=13>
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select compro from gsetup
</cfquery>

<cfquery name="getperiod" datasource="#dts#">
	select lastaccyear from gsetup
</cfquery>

<cfset perioddate = getperiod.lastaccyear>

<cfquery name="getdata" datasource="#dts#">
      select * from ictran where wos_date > #perioddate# and
	  (type = 'rc' or type = 'pr')
	<cfif isdefined("form.suppfrom") and #form.suppfrom# neq "" and #form.suppto# neq "">
		and custno >= '#form.suppfrom#' and custno <= '#form.suppto#'
	</cfif>
	<cfif isdefined("form.period") and #period# eq "1">
      and fperiod >= 1 and fperiod <= 6
	<cfelseif isdefined("form.period") and #period# eq "2">
	  and fperiod >= 7 and fperiod <= 12
	<cfelseif isdefined("form.period") and #period# eq "3">
	  and fperiod >= 13 and fperiod <= 18
    <cfelse>
	  and fperiod >= 1 and fperiod <= 18
    </cfif>
      group by custno order by custno
</cfquery>

<cfquery name="getgroup" datasource="#dts#">
	  select * from ictran where wos_date > #perioddate# and
	  (type = 'rc' or type = 'pr')
	<cfif isdefined("form.suppfrom") and #form.suppfrom# neq "" and #form.suppto# neq "">
		and custno >= '#form.suppfrom#' and custno <= '#form.suppto#'
	</cfif>
	<cfif isdefined("form.period") and #period# eq "1">
      and fperiod >= 1 and fperiod <= 6
	<cfelseif isdefined("form.period") and #period# eq "2">
	  and fperiod >= 7 and fperiod <= 12
	<cfelseif isdefined("form.period") and #period# eq "3">
	  and fperiod >= 13 and fperiod <= 18
    <cfelse>
	  and fperiod >= 1 and fperiod <= 18
    </cfif>
      group by custno order by custno
</cfquery>

<body>
<cfif getgroup.recordcount eq 0>
	<h3>Sorry, No records were found.</h3>
	<cfabort>
</cfif>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="9"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>#trantype# REPORT (By Month)</strong></font></div></td>
	</tr>
    <tr>
      	<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">
	  	<cfif isdefined("form.period") and period eq "1">
      	PERIOD 1 - 6
		<cfelseif isdefined("form.period") and period eq "2">
	  	PERIOD 7 - 12
		<cfelseif isdefined("form.period") and period eq "3">
	  	PERIOD 13 - 18
    	<cfelse>
	  	ONE YEAR
    	</cfif>
	  	</font></div>
	  	</td>
    </tr>
    <tr>
      	<td colspan="4"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td>&nbsp;</td>
      	<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
    </tr>
    <tr>
      	<td colspan="21"><hr></td>
    </tr>
    <tr>
      	<td><font size="2" face="Times New Roman, Times, serif">VEND NO.</font></td>
	  	<td><font size="2" face="Times New Roman, Times, serif">NAME</font></td>

      	<cfif isdefined("form.period") and period eq "1">
			<cfloop index="l" from="1" to="6">
				<cfset reportmonth = month(getperiod.lastaccyear) + l>

				<cfif reportmonth gt 12>
					<cfset reportmonth1 = reportmonth mod 12>

					<cfif reportmonth1 eq 0>
						<cfset reportmonth = 12>
					<cfelse>
						<cfset reportmonth = reportmonth1>
					</cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(createdate(2002,reportmonth,1),"mmm")#</font></div></td>
				<cfelse>
					<cfset reportmonth1 = reportmonth mod 12>

					<cfif reportmonth1 eq 0>
						<cfset reportmonth = 12>
					<cfelse>
						<cfset reportmonth = reportmonth1>
					</cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(createdate(2002,reportmonth,1),"mmm")#</font></div></td>
				</cfif>
			</cfloop>
		<cfelseif isdefined("form.period") and period eq "2">
			<cfloop index="l" from="7" to="12">
				<cfset reportmonth = month(getperiod.lastaccyear) + l>

				<cfif reportmonth gt 12>
					<cfset reportmonth1 = reportmonth mod 12>

					<cfif reportmonth1 eq 0>
						<cfset reportmonth = 12>
					<cfelse>
						<cfset reportmonth = reportmonth1>
					</cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(createdate(2002,reportmonth,1),"mmm")#</font></div></td>
				<cfelse>
					<cfset reportmonth1 = reportmonth mod 12>

					<cfif reportmonth1 eq 0>
						<cfset reportmonth = 12>
					<cfelse>
						<cfset reportmonth = reportmonth1>
					</cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(createdate(2002,reportmonth,1),"mmm")#</font></div></td>
				</cfif>
			</cfloop>
		<cfelseif isdefined("form.period") and period eq "3">
			<cfloop index="l" from="13" to="18">
				<cfset reportmonth = month(getperiod.lastaccyear) + l>

				<cfif reportmonth gt 12>
					<cfset reportmonth1 = reportmonth mod 12>

					<cfif reportmonth1 eq 0>
						<cfset reportmonth = 12>
					<cfelse>
						<cfset reportmonth = reportmonth1>
					</cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(createdate(2002,reportmonth,1),"mmm")#</font></div></td>
				<cfelse>
					<cfset reportmonth1 = reportmonth mod 12>

					<cfif reportmonth1 eq 0>
						<cfset reportmonth = 12>
					<cfelse>
						<cfset reportmonth = reportmonth1>
					</cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(createdate(2002,reportmonth,1),"mmm")#</font></div></td>
				</cfif>
			</cfloop>
    	<cfelse>
			<cfloop index="l" from="1" to="18">
				<cfset reportmonth = month(getperiod.lastaccyear) + l>

				<cfif reportmonth gt 12>
					<cfset reportmonth1 = reportmonth mod 12>

					<cfif reportmonth1 eq 0>
						<cfset reportmonth = 12>
					<cfelse>
						<cfset reportmonth = reportmonth1>
					</cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(createdate(2002,reportmonth,1),"mmm")#</font></div></td>
				<cfelse>
					<cfset reportmonth1 = reportmonth mod 12>

					<cfif reportmonth1 eq 0>
						<cfset reportmonth = 12>
					<cfelse>
						<cfset reportmonth = reportmonth1>
					</cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(createdate(2002,reportmonth,1),"mmm")#</font></div></td>
				</cfif>
    		</cfloop>
		</cfif>
	  <td><div align="right"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>
    </tr>
    <tr>
      <td colspan="21"><hr></td>
    </tr>

<cfloop query="getgroup">
	<cfset norow = getgroup.recordcount>

	<cfquery dbtype="query" name="getitem">
		select * from getdata where custno = '#getgroup.custno#'
	</cfquery>

	<cfloop query="getitem">
		<cfset subtotal = 0>
		<cfset submonthtotal = 0>
		<cfset m = arraynew(2)>

		<cfloop index="i" from="1" to="18">
			<cfquery name="getrc" datasource="#dts#">
        		select sum(amt)as sumamt,sum(qty)as sumqty from ictran where
  				(type = 'rc')
        		and custno = '#getitem.custno#' and wos_date > #perioddate#
				and fperiod = #i#
      			group by itemno
        	</cfquery>

			<cfif val(getrc.sumamt) eq "" or val(getrc.sumamt) eq 0>
				<cfset m[i][1] = 0>
				<cfset m[i][2] = 0>
				<cfset m[i][3] = 0>
				<cfset m[i][4] = 0>
			<cfelse>
				<cfset m[i][1] = val(getrc.sumamt)>
				<cfset m[i][2] = val(getrc.sumqty)>
			</cfif>

			<cfquery name="getpr" datasource="#dts#">
        		select sum(amt)as sumamt,sum(qty)as sumqty from ictran where
  				(type = 'pr')
        		and custno = '#getitem.custno#' and wos_date > #perioddate#
				and fperiod = #i#
      			group by itemno
       		</cfquery>

			<cfif getpr.sumamt eq "" or getpr.sumamt eq 0>
				<cfset m[i][3] = 0>
				<cfset m[i][4] = 0>
				<cfset m[i][1] = m[i][1] - m[i][3]>
				<cfset m[i][2] = m[i][2] - m[i][4]>
			<cfelse>
				<cfset m[i][3] = val(getpr.sumamt)>
				<cfset m[i][4] = val(getpr.sumqty)>
				<cfset m[i][1] = m[i][1] - m[i][3]>
				<cfset m[i][2] = m[i][2] - m[i][4]>
            </cfif>
		</cfloop>
		<tr>
          <td><font size="2" face="Times New Roman, Times, serif">#custno#</font></td>
          <td><font size="2" face="Times New Roman, Times, serif">#name#</font></td>

		  <cfif listperiod eq 1>
				<cfloop index="j" from="1" to="6">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(m[j][1],"(0.00)")#</font></div></td>
					<cfset subtotal = subtotal + m[j][1]>
					<cfset monthtotal[getgroup.currentrow][j] = m[j][1]>
				</cfloop>
		  <cfelseif listperiod eq 7>
		  		<cfloop index="j" from="7" to="12">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(m[j][1],"(0.00)")#</font></div></td>
					<cfset subtotal = subtotal + m[j][1]>
					<cfset monthtotal[getgroup.currentrow][j] = m[j][1]>
				</cfloop>
		  <cfelseif listperiod eq 13>
		  		<cfloop index="j" from="13" to="18">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(m[j][1],"(0.00)")#</font></div></td>
					<cfset subtotal = subtotal + m[j][1]>
					<cfset monthtotal[getgroup.currentrow][j] = m[j][1]>
				</cfloop>
		  <cfelse>
		  		<cfloop index="j" from="1" to="18">
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(m[j][1],"(0.00)")#</font></div></td>
					<cfset subtotal = subtotal + m[j][1]>
					<cfset monthtotal[getgroup.currentrow][j] = m[j][1]>
				</cfloop>
		  </cfif>
		  	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subtotal,"(0.00)")#</font></div></td>
		</tr>
      </cfloop>
	  <cfset vtotal = vtotal + subtotal>
</cfloop>
	<tr>
      <td colspan="22"><hr></td>
    </tr>
    <tr>
	<td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
    <td><div align="left"><font size="2" face="Times New Roman, Times, serif">TOTAL</font></div></td>

	<cfif listperiod eq 1>
		<cfloop index="q" from="1" to="6">
			<cfset no = q>
			<cfset totalh = 0>
			<cfloop  index="s" from="1" to="#arraylen(monthtotal)#">
				<cfset no1 = s>
				<cfset totalh = totalh + monthtotal[s][no]>
			</cfloop>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(totalh,"(0.00)")#</font></div></td>
		</cfloop>
	<cfelseif listperiod eq 7>
		<cfloop index="q" from="7" to="12">
			<cfset no = q>
			<cfset totalh = 0>
			<cfloop  index="s" from="1" to="#arraylen(monthtotal)#">
				<cfset no1 = s>
				<cfset totalh = totalh + monthtotal[s][no]>
			</cfloop>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(totalh,"(0.00)")#</font></div></td>
		</cfloop>
	<cfelseif listperiod eq 13>
		<cfloop index="q" from="13" to="18">
			<cfset no = q>
			<cfset totalh = 0>
			<cfloop  index="s" from="1" to="#arraylen(monthtotal)#">
				<cfset no1 = s>
				<cfset totalh = totalh + monthtotal[s][no]>
			</cfloop>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(totalh,"(0.00)")#</font></div></td>
		</cfloop>
	<cfelse>
		<cfloop index="q" from="1" to="18">
			<cfset no = q>
			<cfset totalh = 0>
			<cfloop  index="s" from="1" to="#arraylen(monthtotal)#">
				<cfset no1 = s>
				<cfset totalh = totalh + monthtotal[s][no]>
			</cfloop>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(totalh,"(0.00)")#</font></div></td>
		</cfloop>
	</cfif>
	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(vtotal,"(0.00)")#</font></div></td>
	</tr>
</table>
</cfoutput>
<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>
--->