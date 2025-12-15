<cfset refno = urldecode(url.refno)>
<cfset type = url.type>

<cfxml variable="data">
			<?xml version="1.0"?>
			<?mso-application progid="Excel.Sheet"?>
			<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">
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
		  		<Style ss:ID="s30">
		   			<NumberFormat ss:Format="dd-mm-yy;@"/>
		  		</Style>
		  		<Style ss:ID="s31">
		  			<Alignment ss:Horizontal="Right" ss:Vertical="Center"/>
		   			<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  		</Style>
		  		<Style ss:ID="s32">
		  	 		<NumberFormat ss:Format="@"/>
		  		</Style>
		  		<Style ss:ID="s33">
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>00</cfoutput>"/>
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
		   			<NumberFormat ss:Format="#,###,###,##0"/>
		  		</Style>
		  		<Style ss:ID="s36">
		   			<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   			</Borders>
		   			<NumberFormat ss:Format="@"/>
		  		</Style>
		  		<Style ss:ID="s37">
		   			<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   			</Borders>
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>00</cfoutput>"/>
		  		</Style>
		  		<Style ss:ID="s38">
		   			<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  		</Style>
		  		<Style ss:ID="s39">
		   			<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		   			</Borders>
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>00</cfoutput>"/>
		  		</Style>
		  		<Style ss:ID="s41">
		   			<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   			<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
		  		</Style>
		 	</Styles>

			<Worksheet ss:Name="itembody">
				<cfoutput>
				<Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="11.25">
					<Column ss:Width="64.5"/>
					<Column ss:Width="60.25"/>
					<Column ss:Width="60.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<cfset c="12">
						<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
						<cfset c=c+1>
				<Row ss:AutoFitHeight="0" ss:Height="23.0625">
					<Cell ss:StyleID="s27"><Data ss:Type="String">item no</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">description</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">comment</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark 1</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark 2</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark 3</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">remark 4</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">location</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">qty</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">price</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">disc 1 %</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">disc 2 %</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">disc 3 %</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">GST Code</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">GST %</Data></Cell>

				</Row>


			<cfquery name="getcust" datasource="#dts#">
            select * from ictran where refno='#refno#' and type='#type#'
            </cfquery>

			<cfloop query="getcust">

				<cfoutput>
					<cfwddx action = "cfml2wddx" input = "#itemno#" output = "wddxText">
					<cfwddx action = "cfml2wddx" input = "#desp#" output = "wddxText2">
					<cfwddx action = "cfml2wddx" input = "#tostring(comment)#" output = "wddxText3">
                    <cfwddx action = "cfml2wddx" input = "#brem1#" output = "wddxText4">
                    <cfwddx action = "cfml2wddx" input = "#brem2#" output = "wddxText5">
                    <cfwddx action = "cfml2wddx" input = "#brem3#" output = "wddxText6">
                    <cfwddx action = "cfml2wddx" input = "#brem4#" output = "wddxText7">
                    <cfwddx action = "cfml2wddx" input = "#location#" output = "wddxText8">
                    <cfwddx action = "cfml2wddx" input = "#note_a#" output = "wddxText9">
					<Row ss:AutoFitHeight="0">
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText2#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText3#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText4#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText5#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText6#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText7#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText8#</Data></Cell>

						<Cell ss:StyleID="s33"><Data ss:Type="Number">#qty_bil#</Data></Cell>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#price_bil#</Data></Cell>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#dispec1#</Data></Cell>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#dispec2#</Data></Cell>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#dispec3#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText9#</Data></Cell>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#taxpec1#</Data></Cell>
					</Row>
				</cfoutput>
                </cfloop>
				<Row ss:AutoFitHeight="0" ss:Height="12"/>

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

		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls" output="#tostring(data)#" charset="utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=Excel_Report_#dts#_BL_#huserid#.xls">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls">