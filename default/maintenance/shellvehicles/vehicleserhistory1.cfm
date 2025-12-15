<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,agentlistuserid from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	Select * from gsetup2
</cfquery>

<!---<cfif isdefined("form.datefrom") and isdefined("form.dateto")>
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
</cfif>--->

<!---<cfswitch expression="#form.result#">
	<cfcase value="EXCELDEFAULT">
	
    
    
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
	<Font ss:FontName="Verdana" x:Family="Swiss"/>
	</Style>
	<Style ss:ID="s28">
	<NumberFormat ss:Format="@"/>
	</Style>
	<Style ss:ID="s29">

	</Style>
	<Style ss:ID="s30">
	<Borders>
	<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	</Borders>
	<NumberFormat ss:Format="@"/>
	</Style>
	<Style ss:ID="s31">
	<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
	<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9"/>

	</Style>
	<Style ss:ID="s32">
	<Borders>
	<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
	<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
	</Borders>
	<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
	<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
	</Style>
	<Style ss:ID="s33">
	<Borders>
	<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
	</Borders>
	
	</Style>
	<Style ss:ID="s34">
	<Borders>
	<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
	</Borders>
	<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
	<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
	</Style>
	<Style ss:ID="s35">
	<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
	<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
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
	<Worksheet ss:Name="Vehicle Service History Report">
	<cfoutput>
    <cfset rowcom = 8>
    <cfset comcom = 6>
	<Table ss:ExpandedColumnCount="20" x:FullColumns="1" x:FullRows="1">
					<Column ss:Width="40"/>
					<Column ss:Width="60.75"/>
					<Column ss:Width="60.75"/>
					<Column ss:Width="60.75"/>
					<Column ss:Width="60.75"/>
	<cfwddx action = "cfml2wddx" input = "Vehicle Service History Report" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="#rowcom#" ss:StyleID="s22"><Data ss:Type="String">Printed by : #wddxText#</Data></Cell>
					</Row>
					
                    <cfwddx action = "cfml2wddx" input = "#HUserID#" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="20.0625">
						<Cell ss:MergeAcross="#rowcom#" ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
                     </Row>
                    
                     <cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
                     <Row ss:AutoFitHeight="0" ss:Height="20.0625">
						<Cell ss:MergeAcross="#rowcom#" ss:StyleID="s26"><Data ss:Type="String">Date Printed : #dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
					</Row>
                    
                    <cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="20.0625">
						<Cell ss:MergeAcross="#rowcom#" ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
                     </Row>

<cfquery name="getvehicle" datasource="#dts#">
		select 
		*
		from vehicles as a
		
		left join 
		( 
			select 
            rem5,
            refno,
            type,
            wos_date,
            sono,
            custno,
            rem9 from artran 
			where type in ('INV') 
			and (void = '' or void is null)
			<cfif trim(form.vehiclefrom) neq "">
			and rem5 = '#form.vehiclefrom#'
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and wos_date between '#ndatefrom#' and '#ndateto#'
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif> 
			group by rem5 
			order by rem5
		) as b on a.entryno=b.rem5

		where
		a.entryno=b.rem5
		<cfif form.datefrom neq "" and form.dateto neq "">
		and b.wos_date between '#ndatefrom#' and '#ndateto#'
		<cfelse>
		and b.wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by a.entryno 
		order by a.entryno;
	</cfquery>


			<cfloop query="getvehicle">
				<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="0" ss:StyleID="s35"><Data ss:Type="String">Vehicle No. : </Data></Cell>
                <Cell ss:MergeAcross="2" ss:StyleID="s26"><Data ss:Type="String">#entryno#</Data></Cell>
                <Cell ss:StyleID="s35"><Data ss:Type="String">Chassis No. : </Data></Cell>
                <Cell ss:MergeAcross="2" ss:StyleID="s26"><Data ss:Type="String">#chasisno#</Data></Cell>
                </Row>
                
                <Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:StyleID="s35"><Data ss:Type="String">Customer No. : </Data></Cell>
                <Cell ss:MergeAcross="2" ss:StyleID="s26"><Data ss:Type="String">#custcode#</Data></Cell>
                <Cell ss:StyleID="s35"><Data ss:Type="String">Make : </Data></Cell>
                <Cell ss:MergeAcross="2" ss:StyleID="s26"><Data ss:Type="String">#make#</Data></Cell>
                </Row>
                
                <Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:StyleID="s35"><Data ss:Type="String">Customer Name : </Data></Cell>
                <Cell ss:MergeAcross="2" ss:StyleID="s26"><Data ss:Type="String">#custname#</Data></Cell>
                <Cell ss:StyleID="s35"><Data ss:Type="String">Model : </Data></Cell>
                <Cell ss:MergeAcross="2" ss:StyleID="s26"><Data ss:Type="String">#model#</Data></Cell>
                </Row>
                
                <Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:StyleID="s35"><Data ss:Type="String">Customer Phone No. : </Data></Cell>
                <Cell ss:MergeAcross="2" ss:StyleID="s26"><Data ss:Type="String">#phone#</Data></Cell>
                <Cell ss:StyleID="s35"><Data ss:Type="String">Owner : </Data></Cell>
                <Cell ss:MergeAcross="2" ss:StyleID="s26"><Data ss:Type="String">#contactperson#</Data></Cell>
                </Row>


            <cfquery name="getservdate" datasource="#dts#">
				select 
                rem5,
                refno,
                type,
                wos_date,
                sono,
                rem9 
                from artran as a
				
				where type='INV'
				and (void = '' or void is null)  

				and a.rem5 = '#getvehicle.entryno#'
                
				<cfif form.datefrom neq "" and form.dateto neq "">
				and a.wos_date between '#ndatefrom#' and '#ndateto#'
				<cfelse>
				and a.wos_date > #getgeneral.lastaccyear# 
				</cfif>
				order by a.wos_date;
			</cfquery>

			<cfloop query="getservdate">

			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:StyleID="s35"><Data ss:Type="String">Date :</Data></Cell>
                <Cell ss:MergeAcross="0" ss:StyleID="s26"><Data ss:Type="String">#dateformat(wos_date,"dd/mm/yyyy")#</Data></Cell>
                <Cell ss:StyleID="s35"><Data ss:Type="String">Reference No. : </Data></Cell>
                <Cell ss:StyleID="s26"><Data ss:Type="String">#refno#</Data></Cell>
                <Cell ss:StyleID="s35"><Data ss:Type="String">Job Sheet/DO No. : </Data></Cell>
                <Cell ss:StyleID="s26"><Data ss:Type="String">#sono#</Data></Cell>
                <Cell ss:StyleID="s35"><Data ss:Type="String">Mileage : </Data></Cell>
                <Cell ss:StyleID="s26"><Data ss:Type="String">#rem9#</Data></Cell>
                </Row>
                
                <cfquery name="getitem" datasource="#dts#">
				select  
                itemno,
                type,
                desp,
                agenno,
                qty,
                refno,
                amt
                from ictran as a
				
                where a.type='INV'
                and a.refno='#getservdate.refno#'
                and (a.void = '' or a.void is null)
                order by a.itemno;
                </cfquery>
                
                <Row>
                <Cell ss:StyleID="s34"><Data ss:Type="String">Item No.</Data></Cell>
                <Cell ss:MergeAcross="2" ss:StyleID="s34"><Data ss:Type="String">Description</Data></Cell>
                <Cell ss:StyleID="s34"><Data ss:Type="String">Mech. No.</Data></Cell>
                <Cell ss:StyleID="s34"><Data ss:Type="String">Quantity</Data></Cell>
                <Cell ss:StyleID="s34"><Data ss:Type="String">Amount</Data></Cell>
                </Row>
                
                <cfloop query="getitem">
                <Row>
                <Cell ss:StyleID="s26"><Data ss:Type="String">#itemno#</Data></Cell>
                <Cell ss:MergeAcross="2" ss:StyleID="s26"><Data ss:Type="String">#desp#</Data></Cell>
                <Cell ss:StyleID="s26"><Data ss:Type="String">#agenno#</Data></Cell>
                <Cell ss:StyleID="s26"><Data ss:Type="String">#qty#</Data></Cell>
                <Cell ss:StyleID="s26"><Data ss:Type="String">#amt#</Data></Cell>
                </Row>
                
          </cfloop>
          <Row><Cell></Cell></Row> 
		</cfloop>
        <Row><Cell></Cell></Row>
	</cfloop>
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

	<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\ItemSaleRType_CP_Sales_#huserid#.xls" output="#tostring(data)#" >
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\ItemSaleRType_CP_Sales_#huserid#.xls">
<!---
	<cffile action="write" nameconflict="overwrite" file="C:\Inetpub\wwwroot\WOS\Excel_Report\#dts#\ItemSaleRType_CP_Sales_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="C:\Inetpub\wwwroot\WOS\Excel_Report\#dts#\ItemSaleRType_CP_Sales_#huserid#.xls">
--->
	</cfcase>--->
    
	<!---<cfcase value="HTML">--->
	<html>
	<head>
	<title>Vehicle Service History Report</title>
	<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
	</head>

	<body>


	<cfquery name="getvehicle" datasource="#dts#">
		select 
		*
		from vehicles as a
		
		left join 
		( 
			select 
            rem5,
            refno,
            type,
            <!---wos_date,--->
            sono,
            custno,
            rem9 from artran 
			where type in ('INV') 
			and (void = '' or void is null)
			<!---<cfif trim(form.vehiclefrom) neq "">--->
			and rem5 = '#url.entryno#'
			<!---</cfif>--->
			
			<!---and wos_date > #getgeneral.lastaccyear#--->
		
			group by rem5 
			order by rem5
		) as b on a.entryno=b.rem5 

		where
		a.entryno=b.rem5
		<!---<cfif form.datefrom neq "" and form.dateto neq "">
		and b.wos_date between '#ndatefrom#' and '#ndateto#'
		<cfelse>
		and b.wos_date > #getgeneral.lastaccyear#
		</cfif>--->
		group by a.entryno 
		order by a.entryno;
	</cfquery>
	
	<cfoutput>
    <cfset columncount = "100%">
    <cfset rowcom = 7>
    <cfset comcom = 3>

	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="100%"><div align="left"><font size="3" face="Times New Roman, Times, serif"><strong>Vehicle Service History Report</strong></font></div></td>
		</tr>
        		<tr>
			<td colspan="100%"><font size="2" face="Times New Roman, Times, serif">Printed by : #HUserID#</font></td></tr>
		<!---<tr><td colspan="100%"><div align="left"><font size="2" face="Times New Roman, Times, serif">Date printed : #dateformat(now(),"dd/mm/yyyy")#</font></div></td></tr>--->
        <tr>
			<td colspan="100%"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
		</tr>
		<tr>
			<td colspan="#columncount#"><hr></td>
		</tr>
        
        <cfloop query="getvehicle">
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Vehicle No :</strong></font></div></td>
			<td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.entryno#</font></div></td>
            <td colspan="2"></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Chassis No. :</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.chasisno#</font></div></td>
            </tr>
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Customer No. :</strong></font></div></td>
            <cfquery name="getcustname" datasource="#dts#">
            select name from #target_arcust# where custno='#getvehicle.custcode#'
            </cfquery>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.custcode#</font></div></td>
            <td colspan="2"></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Make :</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.make#</font></div></td>
            </tr>
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Customer Name :</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.custname#</font></div></td>
            <td colspan="2"></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Model :</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.model#</font></div></td>
            </tr>
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Customer Phone No.</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.contact#</font></div></td>
            <td colspan="2"></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Owner :</strong></font></div></td>
            <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getvehicle.contactperson#</font></div></td>
            </tr>
            
		<tr>
			<td colspan="#columncount#"><hr></td>
		</tr>
        
			<cfquery name="getservdate" datasource="#dts#">
				select 
                rem5,
                refno,
                type,
                wos_date,
                sono,
                rem9 
                from artran as a
				
				where type='INV'
				and (void = '' or void is null)  

				and a.rem5 = '#url.entryno#'
                
				
				<!---and a.wos_date > #getgeneral.lastaccyear# --->
		
				order by a.wos_date;
			</cfquery>

			<cfloop query="getservdate">
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Date :</strong></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getservdate.wos_date,"dd/mm/yyyy")#</font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Reference No. :</strong></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getservdate.refno#</font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Job Sheet/DO.No. :</strong></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getservdate.sono#</font></div></td>
				 <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Mileage :</strong></font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getservdate.rem9#</font></div></td>
                 </tr>
				 
            
            <cfquery name="getitem" datasource="#dts#">
				select  
                itemno,
                type,
                desp,
                despa,
                comment,
                agenno,
                qty,
                refno,
                amt
                from ictran as a
				
                where a.type='INV'
                and a.refno='#getservdate.refno#'
                and (a.void = '' or a.void is null)
                order by a.itemno;
                </cfquery>
            
            <tr>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Item No.</strong></font></div></td>
             <td colspan="3"><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Description</strong></font></div></td>
              <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Mech. No.</strong></font></div></td>
               <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Quantity</strong></font></div></td>
                <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>Amount</strong></font></div></td>
            </tr>
            
            <cfloop query="getitem">
            
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></div></td>
            <td colspan="3"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.desp#<br>#getitem.despa#<br>#tostring(getitem.comment)#</font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.agenno#</font></div></td>
            <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.qty#</font></div></td>
             <td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.amt#</font></div></td>
                 </tr>
                 
				 <cfflush>
			</cfloop>
            <tr>
				<td colspan="#columncount#"><hr></td>
			</tr>
            <cfflush>
			</cfloop>
            <tr>
				<td colspan="#columncount#"><hr></td>
			</tr>
            <tr><td>&nbsp;</td></tr>
            <tr><td>&nbsp;</td></tr>
            <tr><td>&nbsp;</td></tr>
            <tr><td>&nbsp;</td></tr>
			<cfflush>
		</cfloop>
		
	  </table>
	</cfoutput>

	<br>
	<br>
	<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
	<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
	</body>
	</html>
	<!---</cfcase>---->
<!---</cfswitch>--->