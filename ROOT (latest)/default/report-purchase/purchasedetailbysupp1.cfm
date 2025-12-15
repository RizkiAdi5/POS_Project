<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfquery name="getdisplaydetail" datasource="#dts#">
select * from displaysetup
</cfquery>

<cfquery name="getmodule" datasource="#dts#">
select * from modulecontrol
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
	<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
	<cfset stDecl_UPrice = "">

	<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		<cfset stDecl_UPrice = stDecl_UPrice & "0">
	</cfloop>

	<cfquery name="getgroup" datasource="#dts#">
		select a.custno, a.name from ictran a, icitem b
		where (type = 'RC' <cfif isdefined('form.includepr')>or type = 'PR'</cfif>) and b.itemno = a.itemno and (void = '' or void is null)
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and b.category >='#form.catefrom#' and b.category <='#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and b.wos_group >='#form.groupfrom#' and b.wos_group <='#form.groupto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and b.itemno >='#form.itemfrom#' and b.itemno <= '#form.itemto#'
		</cfif>
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and a.fperiod+0 >= '#form.periodfrom#' and a.fperiod+0 <= '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
		<cfelse>
		and a.wos_date > #getgeneral.lastaccyear#
		</cfif>
        <cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.custno >='#form.suppfrom#' and a.custno <= '#form.suppto#'
				</cfif>
        and a.custno<>'assm/999'
        <cfif form.projectfrom neq "" and form.projectto neq "">
					and a.source between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectto#">
				</cfif>
        <cfif form.jobfrom neq "" and form.jobto neq "">
					and a.job between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobto#">
				</cfif>
		group by a.custno order by a.custno
	</cfquery>

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
	<NumberFormat ss:Format="@"/>
	</Style>
	<Style ss:ID="s29">
	<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
	</Style>
	<Style ss:ID="s30">
	<Borders>
	<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	</Borders>
	<NumberFormat ss:Format="@"/>
	</Style>
	<Style ss:ID="s31">
	<Borders>
	<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
	</Borders>
	<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
	</Style>
	<Style ss:ID="s32">
	<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
	</Style>
	<Style ss:ID="s33">
	<Borders>
	<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
	</Borders>
	<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
	</Style>
	<Style ss:ID="s34">
	<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
	<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
	</Style>
	<Style ss:ID="s35">
	<NumberFormat ss:Format="0"/>
	</Style>
	<Style ss:ID="s36">
	<Borders>
	<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
	</Borders>
	<NumberFormat ss:Format="0"/>
	</Style>
	<Style ss:ID="s37">
	<Borders>
	<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
	</Borders>
	<NumberFormat ss:Format="0"/>
	</Style>
	</Styles>
	<Worksheet ss:Name="PURCHASE REPORT DETAIL">
	<cfoutput>
	<Table ss:ExpandedColumnCount="15" x:FullColumns="1" x:FullRows="1">
	<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
	<Column ss:AutoFitWidth="0" ss:Width="80.5" ss:Span="4"/>

	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s22"><Data ss:Type="String">PURCHASE REPORT DETAIL(BY SUPPLIER)</Data></Cell>
	</Row>

	<cfif isdefined("form.periodfrom") and form.periodfrom neq "" and form.periodto neq "">
		<cfwddx action = "cfml2wddx" input = "PERIOD: #form.periodfrom# - #form.periodto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif isdefined("form.datefrom") and form.datefrom neq "" and form.dateto neq "">
		<cfwddx action = "cfml2wddx" input = "DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif isdefined("form.catefrom") and trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		<cfwddx action = "cfml2wddx" input = "CATEGORY: #form.catefrom# - #form.cateto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif isdefined("form.groupfrom") and trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		<cfwddx action = "cfml2wddx" input = "GROUP: #form.groupfrom# - #form.groupto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>
	<cfif isdefined("form.itemfrom") and trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		<cfwddx action = "cfml2wddx" input = "ITEM NO: #form.itemfrom# - #form.itemto#" output = "wddxText">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="6" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
		</Row>
	</cfif>

	<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="5" ss:StyleID="s26"><Data ss:Type="String"><cfif getgeneral.compro neq "">#getgeneral.compro# </cfif></Data></Cell>
		<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
	</Row>

	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
   		<Cell ss:StyleID="s27"><Data ss:Type="String">Supplier No.</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">Item No.</Data></Cell>
       
        
        
		
        <Cell ss:StyleID="s27"><Data ss:Type="String">ITEM DESP</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">REF NO</Data></Cell>
        <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
        <Cell ss:StyleID="s27"><Data ss:Type="String">Vendor’s Inv/PI No.</Data></Cell>
        <Cell ss:StyleID="s27"><Data ss:Type="String">PO No.</Data></Cell>
        </cfif>
        <cfif getmodule.auto eq '1'>
        <Cell ss:StyleID="s27"><Data ss:Type="String">TERMS</Data></Cell>
        <Cell ss:StyleID="s27"><Data ss:Type="String">INV / DO No</Data></Cell>
            </cfif>
        
		<Cell ss:StyleID="s27"><Data ss:Type="String">DATE</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">QTY</Data></Cell>
        <cfif lcase(hcomid) eq"vsolutionspteltd_i">
        <Cell ss:StyleID="s27"><Data ss:Type="String">FOREIGN CURRENCY</Data></Cell>
        <Cell ss:StyleID="s27"><Data ss:Type="String">FOREIGN CURRENCY UNIT PRICE</Data></Cell>
        <Cell ss:StyleID="s27"><Data ss:Type="String">FOREIGN CURRENCY AMOUNT</Data></Cell>
       
		</cfif>
        <Cell ss:StyleID="s27"><Data ss:Type="String">UNIT PRICE</Data></Cell>
      
		<Cell ss:StyleID="s27"><Data ss:Type="String">AMOUNT</Data></Cell>
         <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
         <Cell ss:StyleID="s27"><Data ss:Type="String">FORIEGN PRICE</Data></Cell>
         <Cell ss:StyleID="s27"><Data ss:Type="String">FORIEGN AMOUNT</Data></Cell>
         </cfif>
	</Row>

	<cfset totalqty = 0>
		<cfset totalamt = 0>

		<cfloop query="getgroup">
        <cfset subqty = 0>
		<cfset subamt = 0>
		<Row ss:AutoFitHeight="0" ss:Height="12">

				<cfwddx action = "cfml2wddx" input = "Supplier No: #getgroup.custno#" output = "wddxText1">
				<cfwddx action = "cfml2wddx" input = "#getgroup.name#" output = "wddxText2">
				<Cell ss:StyleID="s34"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:StyleID="s34"><Data ss:Type="String">#wddxText2#</Data></Cell>
                
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
			<Cell ss:StyleID="s29"/>
		</Row>

		<cfquery name="getitem" datasource="#dts#">
				select * from ictran
				where (type = 'RC' <cfif isdefined('form.includepr')>or type = 'PR'</cfif>) 
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
                <cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
				</cfif>
				and custno='#getgroup.custno#' and (void = '' or void is null)
                <cfif form.projectfrom neq "" and form.projectto neq "">
					and source between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectto#">
				</cfif>
                <cfif form.jobfrom neq "" and form.jobto neq "">
					and job between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobto#">
				</cfif>
			</cfquery>

		<cfloop query="getitem">
			<cfif type eq 'RC'>
				<cfset subqty = subqty + val(getitem.qty)>
                <cfelseif type eq 'PR'>
                <cfset subqty = subqty - val(getitem.qty)>
                </cfif>
                <cfif type eq 'RC'>
				<cfset subamt = subamt + val(getitem.amt)>
                <cfelseif type eq 'PR'>
                <cfset subamt = subamt - val(getitem.amt)>
                </cfif>

			<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText1">
			<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText2">
			<cfwddx action = "cfml2wddx" input = "#getitem.refno#" output = "wddxText3">
			<cfwddx action = "cfml2wddx" input = "#dateformat(wos_date,'DD-MM-YYYY')#" output = "wddxText4">
            <cfquery name="getrefno2" datasource="#dts#">
                    select refno2,pono,term,dono from artran where refno='#getitem.refno#' and type='#getitem.type#'
                    </cfquery>
            <cfwddx action = "cfml2wddx" input = "#getrefno2.refno2#" output = "wddxText5">
            <cfwddx action = "cfml2wddx" input = "#getrefno2.pono#" output = "wddxText6">
            <cfwddx action = "cfml2wddx" input = "#getrefno2.term#" output = "wddxText7">
            <cfwddx action = "cfml2wddx" input = "#getrefno2.dono#" output = "wddxText8">
          
                     <cfquery name="getcurrencycode" datasource="#dts#">
    select currcode from #target_apvend# where custno='#getgroup.custno#'
    </cfquery>
            <cfwddx action = "cfml2wddx" input = "#getcurrencycode.currcode#" output = "wddxText7">
           
			<Row ss:AutoFitHeight="0" ss:Height="12">
            	<Cell ss:StyleID="s28"><Data ss:Type="String"></Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText3#</Data></Cell>
                <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
                <Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText5#</Data></Cell>
                <Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText6#</Data></Cell>
                </cfif>
                <cfif getmodule.auto eq '1'>
        <Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText7#</Data></Cell>
                <Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText8#</Data></Cell>
            </cfif>
                
				<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText4#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#getitem.qty#</Data></Cell>
                    <cfif lcase(hcomid) eq"vsolutionspteltd_i">
                    <Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText7#</Data></Cell>
                    
                    <Cell ss:StyleID="s29"><Data ss:Type="Number">#getitem.price#</Data></Cell>
                    <Cell ss:StyleID="s29"><Data ss:Type="Number">#getitem.amt_bil#</Data></Cell>
                    
                    </cfif>
				
                <cfif lcase(hcomid) eq "vsolutionspteltd_i">
                <cfif getitem.qty neq '0'>
                <Cell ss:StyleID="s29"><Data ss:Type="Number">#getitem.amt/getitem.qty#</Data></Cell>
                </cfif>
                <cfelse>
                <Cell ss:StyleID="s29"><Data ss:Type="Number">#getitem.price#</Data></Cell>
                </cfif>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#getitem.amt#</Data></Cell>
                <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
                <Cell ss:StyleID="s29"><Data ss:Type="Number">#getitem.price_bil#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="Number">#getitem.amt_bil#</Data></Cell>
                </cfif>
			</Row>
		</cfloop>

		<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s30"><Data ss:Type="String">SUB-TOTAL</Data></Cell>
			<Cell ss:StyleID="s30"/>
            <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
            <Cell ss:StyleID="s30"/>
             <Cell ss:StyleID="s30"/>
            </cfif>
            <cfif getmodule.auto eq '1'>
       		<Cell ss:StyleID="s30"/>
            <Cell ss:StyleID="s30"/>
            </cfif>
            
			<Cell ss:StyleID="s30"/>
            <Cell ss:StyleID="s30"/>
            <Cell ss:StyleID="s30"/>
			<Cell ss:StyleID="s36"><Data ss:Type="Number">#subqty#</Data></Cell>
			<Cell ss:StyleID="s30"/>
            <Cell ss:StyleID="s30"/>
            <Cell ss:StyleID="s30"/>
            <Cell ss:StyleID="s30"/>
			<Cell ss:StyleID="s31"><Data ss:Type="Number">#subamt#</Data></Cell>
		</Row>
		<Row ss:AutoFitHeight="0" ss:Height="12"/>
	</cfloop>
	<Row ss:AutoFitHeight="0" ss:Height="12">
		<Cell ss:StyleID="s32"><Data ss:Type="String">TOTAL</Data></Cell>
		<Cell ss:StyleID="s32"/>
        <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
            <Cell ss:StyleID="s30"/>
            <Cell ss:StyleID="s30"/>
            </cfif>
        <cfif getmodule.auto eq '1'>
       		<Cell ss:StyleID="s30"/>
            <Cell ss:StyleID="s30"/>
            </cfif>
		<Cell ss:StyleID="s32"/>
        <Cell ss:StyleID="s30"/>
        <Cell ss:StyleID="s30"/>
		<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalqty#</Data></Cell>
		<Cell ss:StyleID="s30"/>
		<Cell ss:StyleID="s33"><Data ss:Type="Number">#totalamt#</Data></Cell>
	</Row>
    </Table>
	</cfoutput>
	<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
	<Unsynced/>
	<Print>
	<ValidPrinterInfo/>
	<HorizontalResolution>600</HorizontalResolution>
	<VerticalResolution>600</VerticalResolution>
	</Print>
	<Selected/>
	<Panes>
	<Pane>
	<Number>3</Number>
	<ActiveRow>12</ActiveRow>
	<ActiveCol>1</ActiveCol>
	</Pane>
	</Panes>
	<ProtectObjects>False</ProtectObjects>
	<ProtectScenarios>False</ProtectScenarios>
	</WorksheetOptions>
	</Worksheet>
	</Workbook>
	</cfxml>

	<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\ProductR_PP_Type_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\ProductR_PP_Type_#huserid#.xls">
	</cfcase>

	<cfcase value="HTML">
    <html>
	<head>
	<title>Product Purchase Report By Supplier</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
	</head>
	<body>
	<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
	<cfset stDecl_UPrice = ",___.">

	<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
		<cfset stDecl_UPrice = stDecl_UPrice & "_">
	</cfloop>
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="9"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>PUCHASE REPORT DETAIL (BY SUPPLIER)</strong></font></div></td>
		</tr>
		<cfif isdefined("form.periodfrom") and form.periodfrom neq "" and form.periodto neq "">
			<tr>
				<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
			</tr>
		</cfif>
		<cfif isdefined("form.datefrom") and form.datefrom neq "" and form.dateto neq "">
			<tr>
				<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #form.datefrom# - #form.dateto#</font></div></td>
			</tr>
		</cfif>
		<cfif isdefined("form.catefrom") and trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			<tr>
			  <td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATEGORY: #form.catefrom# - #form.cateto#</font></div></td>
			</tr>
		</cfif>
		<cfif isdefined("form.groupfrom") and trim(form.groupfrom )neq "" and trim(form.groupto) neq "">
			<tr>
			  <td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
			</tr>
		</cfif>
		<cfif isdefined("form.itemfrom") and trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			<tr>
			  <td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM NO: #form.itemfrom# - #form.itemto#</font></div></td>
			</tr>
		</cfif>
        <cfif trim(form.projectfrom) neq "" and trim(form.projectto) neq "">
			<tr>
			  <td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">PROJECT: #form.projectfrom# - #form.projectto#</font></div></td>
			</tr>
		</cfif>
        <cfif trim(form.jobfrom) neq "" and trim(form.jobto) neq "">
			<tr>
			  <td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">JOB: #form.jobfrom# - #form.jobto#</font></div></td>
			</tr>
		</cfif>
		<tr>
			<td colspan="3"><font size="2" face="Times New Roman, Times, serif">
			  #getgeneral.compro#
			</font></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="1"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
		<tr>
			<td><font size="2" face="Times New Roman, Times, serif">A/C NAME</font></td>
			<td><font size="2" face="Times New Roman, Times, serif">ITEM NO</font></td>
             <cfif getdisplaydetail.report_aitemno eq 'Y'>
            <td><font size="2" face="Times New Roman, Times, serif">PRODUCT CODE</font></td>
            </cfif>
			<td><font size="2" face="Times New Roman, Times, serif">ITEM DESCRIPTION</font></td>
            <td><font size="2" face="Times New Roman, Times, serif">REF NO</font></td>
            <td><font size="2" face="Times New Roman, Times, serif">REF NO2</font></td>
            <cfif getmodule.auto eq '1'>
            <td><font size="2" face="Times New Roman, Times, serif">TERMS</font></td>
            <td><font size="2" face="Times New Roman, Times, serif">INV / DO No</font></td>
            </cfif>
            <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
            <td><font size="2" face="Times New Roman, Times, serif">Vendor’s Inv/PI No.</font></td>
            <td><font size="2" face="Times New Roman, Times, serif">PO No.</font></td>
            </cfif>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY</font></div></td>
            <cfif lcase(hcomid) eq "vsolutionspteltd_i">
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOREIGN CURRENCY</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOREIGN UNIT PRICE</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">FOREIGN AMT</font></div></td>
            
            
            </cfif>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">UNIT PRICE</font></div></td>
            
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">AMOUNT</font></div></td>
            <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Foriegn Price</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Foriegn Amt</font></div></td>
            </cfif>
            <cfif lcase(hcomid) eq "bnbm_i" or lcase(hcomid) eq "bnbp_i">
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Currrate</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Foriegn Price</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Foriegn Amt</font></div></td>
            </cfif>
		</tr>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>

		<cfset totalqty = 0>
		<cfset totalamt = 0>
		<cfquery name="getgroup" datasource="#dts#">
		select a.custno, a.name from ictran a, icitem b
		where (type = 'RC' <cfif isdefined('form.includepr')>or type = 'PR'</cfif>) and b.itemno = a.itemno and (void = '' or void is null)
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and b.category >='#form.catefrom#' and b.category <='#form.cateto#'
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and b.wos_group >='#form.groupfrom#' and b.wos_group <='#form.groupto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and b.itemno >='#form.itemfrom#' and b.itemno <= '#form.itemto#'
		</cfif>
		<cfif form.periodfrom neq "" and form.periodto neq "">
		and a.fperiod+0 >= '#form.periodfrom#' and a.fperiod+0 <= '#form.periodto#'
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
		<cfelse>
		and a.wos_date > #getgeneral.lastaccyear#
		</cfif>
        <cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.custno >='#form.suppfrom#' and a.custno <= '#form.suppto#'
				</cfif>
        and a.custno<>'assm/999'
        <cfif form.projectfrom neq "" and form.projectto neq "">
					and a.source between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectto#">
				</cfif>
        <cfif form.jobfrom neq "" and form.jobto neq "">
					and a.job between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobto#">
				</cfif>
		group by a.custno order by a.custno
	</cfquery>
		<cfloop query="getgroup">
        <cfset subqty = 0>
		<cfset subamt = 0>
			<tr>
				
					<td><font size="2" face="Times New Roman, Times, serif"><strong><u><a href='l_purchasereportCUST.cfm?custno=#urlencodedformat(getgroup.custno)#'>SUPPLIER NO: #getgroup.custno#</a></u></strong></font></td>
                    <cfquery name="getcustname" datasource="#dts#">
                    select name from #target_apvend# where custno='#getgroup.custno#'
                    </cfquery>
					<td><font size="2" face="Times New Roman, Times, serif"><strong><u>#getcustname.name#</u></strong></font></td>
			</tr>
			<cfquery name="getitem" datasource="#dts#">
				select * from ictran
				where (type = 'RC' <cfif isdefined('form.includepr')>or type = 'PR'</cfif>) 
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
				</cfif>
                <cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and category >='#form.catefrom#' and category <='#form.cateto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
                <cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
				</cfif>
                <cfif form.projectfrom neq "" and form.projectto neq "">
					and source between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectto#">
				</cfif>
                <cfif form.jobfrom neq "" and form.jobto neq "">
					and job between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobto#">
				</cfif>
				and custno='#getgroup.custno#' and (void = '' or void is null)
                order by refno,type
			</cfquery>
            
            <cfloop query="getitem">
				<cfif type eq 'RC'>
				<cfset subqty = subqty + val(getitem.qty)>
                <cfelseif type eq 'PR'>
                <cfset subqty = subqty - val(getitem.qty)>
                </cfif>
                <cfif type eq 'RC'>
				<cfset subamt = subamt + val(getitem.amt)>
                <cfelseif type eq 'PR'>
                <cfset subamt = subamt - val(getitem.amt)>
                </cfif>
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
               		<td><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td>
					<td><font size="2" face="Times New Roman, Times, serif"><a href='l_purchasereportITEM.cfm?itemno=#urlencodedformat(getitem.itemno)#'>#getitem.itemno#</font></a></td>
                     <cfif getdisplaydetail.report_aitemno eq 'Y'>
                    <cfquery name="getaitemno" datasource="#dts#">
                    select aitemno from icitem where itemno='#getitem.itemno#'
                    </cfquery>
                    <td><font size="2" face="Times New Roman, Times, serif">#getaitemno.aitemno#</font></td>
                    </cfif>
					<td><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></td>
					<td><font size="2" face="Times New Roman, Times, serif"><a href='/billformat/#dts#/transactionformat.cfm?tran=#getitem.type#&nexttranno=#getitem.refno#'>#getitem.refno#</font></a></td>
                    <td><font size="2" face="Times New Roman, Times, serif">#getitem.refno2#</font></td>
                    <cfif getmodule.auto eq '1'>
                    <cfquery name="getrefno2" datasource="#dts#">
                    select term,dono from artran where refno='#getitem.refno#' and type='#getitem.type#'
                    </cfquery>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getrefno2.term#</font></div></td>
                    <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getrefno2.dono#</font></div></td>            		</cfif>
                    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
                    <cfquery name="getrefno2" datasource="#dts#">
                    select refno2,pono from artran where refno='#getitem.refno#' and type='#getitem.type#'
                    </cfquery>
                    <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getrefno2.refno2#</font></div></td>
                    <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getrefno2.PONO#</font></div></td>
                    </cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(wos_date,'dd-mm-yyyy')#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif type eq 'PR'>-</cfif>#numberformat(qty,"0")# #unit#</font></div></td>
                    <cfif lcase(hcomid) eq"vsolutionspteltd_i">
                     <cfquery name="getcurrencycode" datasource="#dts#">
    select currcode from #target_apvend# where custno='#getgroup.custno#'
    </cfquery>
                    <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getcurrencycode.currcode#</font></div></td>
                    <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(price_bil,stDecl_UPrice)#</font></div></td>
                    <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(amt_bil,stDecl_UPrice)#</font></div></td>
                    
                    </cfif>
					
                    <cfif lcase(hcomid) eq "vsolutionspteltd_i">
                    <cfif qty neq '0'>
                    <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(amt/qty,stDecl_UPrice)#</font></div></td>
                    </cfif>
                    <cfelse>
                    <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(price,stDecl_UPrice)#</font></div></td>
                    
                    </cfif>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif type eq 'PR'>-</cfif>#numberformat(amt,stDecl_UPrice)#</font></div></td>
                    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(price_bil,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif type eq 'PR'>-</cfif>#numberformat(amt_bil,stDecl_UPrice)#</font></div></td>
                </cfif>
                <cfif lcase(hcomid) eq "bnbm_i" or lcase(hcomid) eq "bnbp_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#currrate#</font></div></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(price_bil,stDecl_UPrice)#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif type eq 'PR'>-</cfif>#numberformat(amt_bil,stDecl_UPrice)#</font></div></td>
            </cfif>
				</tr>
                

			</cfloop>
            <cfif trim(form.catefrom) eq "" and trim(form.cateto) eq "" and trim(form.itemfrom) eq "" and trim(form.itemto) eq "">
            <cfquery name="getbill" datasource="#dts#">
            select ifnull(b.discount,0)-ifnull(c.discount,0) as discount,ifnull(b.tax,0)-ifnull(c.tax,0) as tax,ifnull(b.net,0)-ifnull(c.net,0) as net from artran as a
            left join
            (select sum(discount) as discount,sum(tax) as tax,sum(grand) as grand,sum(net) as net,custno from artran
             where (type = 'RC') 
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
                <cfif form.projectfrom neq "" and form.projectto neq "">
					and source between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectto#">
				</cfif>
                <cfif form.jobfrom neq "" and form.jobto neq "">
					and job between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobto#">
				</cfif>
				and custno='#getgroup.custno#' and (void = '' or void is null)
            )as b on a.custno=b.custno
            
            left join
            (select sum(discount) as discount,sum(tax) as tax,sum(grand) as grand,sum(net) as net,custno from artran
             where (type = 'PR') 
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and fperiod+0 >= '#form.periodfrom#' and fperiod+0 <= '#form.periodto#'
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and wos_date >= '#ndatefrom#' and wos_date <= '#ndateto#'
				<cfelse>
				and wos_date > #getgeneral.lastaccyear#
				</cfif>
                <cfif form.projectfrom neq "" and form.projectto neq "">
					and source between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.projectto#">
				</cfif>
                <cfif form.jobfrom neq "" and form.jobto neq "">
					and job between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobfrom#">
					and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.jobto#">
				</cfif>
				and custno='#getgroup.custno#' and (void = '' or void is null)
            )as c on a.custno=c.custno
            
            
            where (a.type = 'RC' <cfif isdefined('form.includepr')>or a.type = 'PR'</cfif>)
				and a.custno='#getgroup.custno#'
            
            </cfquery>
            <cfset totalqty = totalqty + subqty>
			<cfset totalamt = totalamt + getbill.net>
            <cfelse>
            <cfset totalqty = totalqty + subqty>
			<cfset totalamt = totalamt + subamt>
            </cfif>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
            <cfif trim(form.catefrom) eq "" and trim(form.cateto) eq "" and trim(form.itemfrom) eq "" and trim(form.itemto) eq "">
            <tr>
				<td colspan="1"></td>
                <td></td>
               
				<td><font size="2" face="Times New Roman, Times, serif">DISCOUNT</font></td>
				<td colspan="2"></td>
                <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
                <td></td>
                <td></td>
                </cfif>
                <cfif getmodule.auto eq '1'>
                <td></td>
                <td></td>
                </cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
                <cfif lcase(hcomid) eq "vsolutionspteltd_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
                </cfif>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
                
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getbill.discount,stDecl_UPrice)#</font></div></td>
			</tr>
            </cfif>
			<tr>
				<td colspan="1"></td>
                <td></td>
               
				<td><font size="2" face="Times New Roman, Times, serif">SUB-TOTAL</font></td>
				<td colspan="2"></td>
                <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
                <td></td>
                <td></td>
                </cfif>
                <cfif getmodule.auto eq '1'>
                <td></td>
                <td></td>
                </cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(subqty,"0")#</font></div></td>
                <cfif lcase(hcomid) eq "vsolutionspteltd_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
                </cfif>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
                
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><cfif trim(form.catefrom) eq "" and trim(form.cateto) eq "" and trim(form.itemfrom) eq "" and trim(form.itemto) eq "">#numberformat(getbill.net,stDecl_UPrice)#<cfelse>#numberformat(subamt,stDecl_UPrice)#</cfif></font></div></td>
			</tr>

		</cfloop>
		<tr>
			<td colspan="100%"><hr></td>
		</tr>
		<tr>
			<td colspan="1"></td>
            <td></td>

			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
			<td colspan="2"></td>
            <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i">
                <td></td>
                <td></td>
                </cfif>
                <cfif getmodule.auto eq '1'>
                <td></td>
                <td></td>
                </cfif>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalqty,"0")#</strong></font></div></td>
            <cfif lcase(hcomid) eq "vsolutionspteltd_i">
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
                </cfif>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></div></td>
            
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalamt,",.__")#</strong></font></div></td>
		</tr>
	  </table>

	<cfif getgroup.recordcount eq 0>
		<h3>Sorry, No records were found.</h3>
		<cfabort>
	</cfif>
	</cfoutput>
	<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()"><u>Print</u></a></font></div>
	<p><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
	</body>
	</html>
	</cfcase>
</cfswitch>
