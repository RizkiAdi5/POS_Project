<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>
<cfquery name="checkcustom" datasource="#dts#">
    select customcompany from dealer_menu
</cfquery>


<cfswitch expression="#form.result#">
	<cfcase value="EXCELDEFAULT">

	<cfparam name="i" default="1" type="numeric">

<cfquery name="getgsetup" datasource="#dts#">
	select lastaccyear,cost,filterall,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION 
	from gsetup
</cfquery>

<cfquery name="getitem" datasource="#dts#">
	select * from icitem where EDI_ID >= 0
	<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
	and itemno >= '#form.productfrom#' and itemno <= '#form.productto#'
  	</cfif>
	<cfif form.catefrom neq "" and form.cateto neq "">
	and category >= '#form.catefrom#' and category <= '#form.cateto#'
  	</cfif>
	<cfif form.sizeidfrom neq "" and form.sizeidto neq "">
	and sizeid >= '#form.sizeidfrom#' and sizeid <= '#form.sizeidto#'
  	</cfif>
	<cfif form.costcodefrom neq "" and form.costcodeto neq "">
	and costcode >= '#form.costcodefrom#' and costcode <= '#form.costcodeto#'
  	</cfif>
	<cfif form.coloridfrom neq "" and form.coloridto neq "">
	and colorid >= '#form.coloridfrom#' and colorid <= '#form.coloridto#'
  	</cfif>
	<cfif form.shelffrom neq "" and form.shelfto neq "">
	and shelf >= '#form.shelffrom#' and shelf <= '#form.shelfto#'
  	</cfif>
	<cfif form.groupfrom neq "" and form.groupto neq "">
	and wos_group >= '#form.groupfrom#' and wos_group <= '#form.groupto#'
  	</cfif>
    <cfif isdefined('form.cbdiscountinue')>
    and nonstkitem != 'T'
    </cfif>
	order by itemno
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	Select * from gsetup2
</cfquery>

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
			
			<Worksheet ss:Name="Product Listing">
				<cfoutput>
				<Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="11.25">
					<Column ss:Width="64.5"/>
					<Column ss:Width="60.25"/>
					<Column ss:Width="60.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
					<Column ss:Width="27.75"/>
					<Column ss:Width="47.25"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<cfset c="55">
						<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
						<cfset c=c+1>

		   
					<cfwddx action = "cfml2wddx" input = " Product Listing" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="#c#" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
					</Row>
			
					
						<cfwddx action = "cfml2wddx" input = "" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>

			
				
					
					<cfwddx action = "cfml2wddx" input = "" output = "wddxText">
			
					<Row ss:AutoFitHeight="0" ss:Height="20.0625">
						<Cell ss:MergeAcross="#c-1#" ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
					</Row>
				</cfoutput>
		
				<Row ss:AutoFitHeight="0" ss:Height="23.0625">
					<Cell ss:StyleID="s27"><Data ss:Type="String">No</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">#itemno#</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Description</Data></Cell>
                    <cfif isdefined("form.cbCate")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">#getgsetup.lcategory#</Data></Cell>
                    </cfif><cfif isdefined("form.cbSizeID")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">#getgsetup.lsize#</Data></Cell>
                    </cfif>
								<cfif isdefined("form.cbCostCode")>

                    <Cell ss:StyleID="s27"><Data ss:Type="String">#getgsetup.lrating#</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbColorID")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">#getgsetup.lmaterial#</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbGroup")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">#getgsetup.lgroup#</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbShelf")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">#getgsetup.lmodel#</Data></Cell>
                    </cfif>
                    	<cfif isdefined("form.cbMItemNo")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Product Code</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbBrand")>

					<Cell ss:StyleID="s27"><Data ss:Type="String">Brand</Data></Cell>
					</cfif>
                    <cfif isdefined("form.cbSupp")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Supplier</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbPacking")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Packing</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbMinimum")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Minimum Qty</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbMaximum")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">Maximum Qty</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbReorder")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Reorder Qty</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbfcurrcode")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Foreign Currency</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbfucost")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">Foreign unit cost</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbfprice")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Foreign Selling Price</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbQOH")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Quantity On Hand</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbQtyBF")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Qty B/F</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbUnit")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">unit</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbCost")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Cost Price</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbCostformula")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">Cost Code</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbPrice")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Selling Price</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbPrice2")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Selling Price 2</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbPrice3")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">M.U Price</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbPrice_Min")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">Min Selling Price</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbQty2")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Length</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbQty3")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">width</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbQty4")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">Thickness</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbQty5")>
          			<Cell ss:StyleID="s27"><Data ss:Type="String">Weight/Length</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbQty6")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Price Weight</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbcredate")>

					<Cell ss:StyleID="s27"><Data ss:Type="String">created data</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem1")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark1</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem2")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark2</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem3")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark3</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem4")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark4</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem5")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">remark5</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem6")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">remark6</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem7")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark7</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem8")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark8</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem9")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark9</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem10")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark10</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem11")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark11</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem12")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark12</Data></Cell>
                     </cfif>
					 <cfif isdefined("form.cbrem13")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark13</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem14")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark14</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem15")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark15</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem16")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark16</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem17")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">remark17</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem18")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">remark18</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem19")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark19</Data></Cell>
                    </cfif>
                     <cfif isdefined("form.cbrem20")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">remark20</Data></Cell>
                    </cfif>
				</Row>
				   
				<cfoutput query="getitem" >
								<cfif #qtybf# neq 0>
									<cfset itembal = #qtybf#>
								<cfelse>
									<cfset itembal = 0>
								</cfif>
                                
                                
								<cfquery name="getin" datasource="#dts#">
									select 
									sum(qty)as sumqty 
									from ictran 
									where type in ('RC','CN','OAI','TRIN') 
									and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#"> 
									and fperiod <> '99' 
									and (void = '' or void is null)
								</cfquery>

								<cfif getin.sumqty neq "">
									<cfset inqty = getin.sumqty>
								<cfelse>
									<cfset inqty = 0>
								</cfif>
                                
								<cfquery name="getout" datasource="#dts#">
									select 
									sum(qty)as sumqty 
									from ictran 
									where type in ('INV','DN','PR','CS','ISS','OAR','TROU') 
									and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#"> 
									
									and fperiod <> '99' 
									and (void = '' or void is null)
								</cfquery>

								<cfif getout.sumqty neq "">
									<cfset outqty = getout.sumqty>
								<cfelse>
									<cfset outqty = 0>
								</cfif>

								<cfquery name="getdo" datasource="#dts#">
									select 
									sum(qty)as sumqty 
									from ictran 
									where type='DO' 
									and (toinv='' or toinv is null)
									and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#"> 
									
									and fperiod <> '99' 
									and (void = '' or void is null)
								</cfquery>

								<cfif getdo.sumqty neq "">
									<cfset DOqty = getdo.sumqty>
								<cfelse>
									<cfset DOqty = 0>
								</cfif>
							
								<cfquery name="getpo" datasource="#dts#">
									select 
									ifnull(sum(qty),0) as sumqty 
									from ictran 
									where type='PO' 
									and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#"> 
									and fperiod <> '99' 
								
									and (void = '' or void is null) and (toinv='' or toinv is null)
								</cfquery>		
        <cfset locbalonhand = val(itembal) + val(inqty) - val(outqty) - val(doqty)>
        
					<cfwddx action = "cfml2wddx" input = "#i#" output = "wddxText">
					<cfwddx action = "cfml2wddx" input = "#itemno#" output = "wddxText2">
					<cfwddx action = "cfml2wddx" input = "#desp# #despa#" output = "wddxText3">
					<cfwddx action = "cfml2wddx" input = "#category#" output = "wddxText4">
                    <cfwddx action = "cfml2wddx" input = "#sizeid#" output = "wddxText5">
                    <cfwddx action = "cfml2wddx" input = "#costcode#" output = "wddxText6">
                    <cfwddx action = "cfml2wddx" input = "#colorid#" output = "wddxText7">
                    <cfwddx action = "cfml2wddx" input = "#wos_group#" output = "wddxText8">
                    <cfwddx action = "cfml2wddx" input = "#shelf#" output = "wddxText9">
                    <cfwddx action = "cfml2wddx" input = "#AITEMNO#" output = "wddxText10">
                    <cfwddx action = "cfml2wddx" input = "#brand#" output = "wddxText11">
                    <cfwddx action = "cfml2wddx" input = "#Supp#" output = "wddxText12">
                    <cfwddx action = "cfml2wddx" input = "#Packing#" output = "wddxText13">
                    <cfwddx action = "cfml2wddx" input = "#Minimum#" output = "wddxText14">
                    <cfwddx action = "cfml2wddx" input = "#Maximum#" output = "wddxText15">
                    <cfwddx action = "cfml2wddx" input = "#Reorder#" output = "wddxText16">
                    <cfwddx action = "cfml2wddx" input = "#fcurrcode#" output = "wddxText17">
                    <cfwddx action = "cfml2wddx" input = "#fucost#" output = "wddxText18">
                    <cfwddx action = "cfml2wddx" input = "#fprice#" output = "wddxText19">
                    <cfwddx action = "cfml2wddx" input = "#locbalonhand#" output = "wddxText20">
                    <cfwddx action = "cfml2wddx" input = "#qtybf#" output = "wddxText21">
                    <cfwddx action = "cfml2wddx" input = "#Unit#" output = "wddxText22">
                    <cfwddx action = "cfml2wddx" input = "#UCost#" output = "wddxText23">
                    <cfwddx action = "cfml2wddx" input = "#costformula#" output = "wddxText24">
                    <cfwddx action = "cfml2wddx" input = "#price#" output = "wddxText25">
                    <cfwddx action = "cfml2wddx" input = "#price2#" output = "wddxText26">
                    <cfwddx action = "cfml2wddx" input = "#price3#" output = "wddxText27">
                    <cfwddx action = "cfml2wddx" input = "#price_min#" output = "wddxText28">
                    <cfwddx action = "cfml2wddx" input = "#Qty2#" output = "wddxText29">
                    <cfwddx action = "cfml2wddx" input = "#Qty3#" output = "wddxText30">
                    <cfwddx action = "cfml2wddx" input = "#Qty4#" output = "wddxText31">
                    <cfwddx action = "cfml2wddx" input = "#Qty5#" output = "wddxText32">
                    <cfwddx action = "cfml2wddx" input = "#Qty6#" output = "wddxText33">
                    <cfwddx action = "cfml2wddx" input = "#dateformat(Created_on,'DD/MM/YYYY')#" output = "wddxText34">
                    <cfwddx action = "cfml2wddx" input = "#remark1#" output = "wddxText35">
                    <cfwddx action = "cfml2wddx" input = "#remark2#" output = "wddxText36">
                    <cfwddx action = "cfml2wddx" input = "#remark3#" output = "wddxText37">
                    <cfwddx action = "cfml2wddx" input = "#remark4#" output = "wddxText38">
                    <cfwddx action = "cfml2wddx" input = "#remark5#" output = "wddxText39">
                    <cfwddx action = "cfml2wddx" input = "#remark6#" output = "wddxText40">
                    <cfwddx action = "cfml2wddx" input = "#remark7#" output = "wddxText41">
                    <cfwddx action = "cfml2wddx" input = "#remark8#" output = "wddxText42">
                    <cfwddx action = "cfml2wddx" input = "#remark9#" output = "wddxText43">
                    <cfwddx action = "cfml2wddx" input = "#remark10#" output = "wddxText44">
                    <cfwddx action = "cfml2wddx" input = "#remark11#" output = "wddxText45">
                    <cfwddx action = "cfml2wddx" input = "#remark12#" output = "wddxText46">
                    <cfwddx action = "cfml2wddx" input = "#remark13#" output = "wddxText47">
                    <cfwddx action = "cfml2wddx" input = "#remark14#" output = "wddxText48">
                    <cfwddx action = "cfml2wddx" input = "#remark15#" output = "wddxText49">
                    <cfwddx action = "cfml2wddx" input = "#remark16#" output = "wddxText50">
                    <cfwddx action = "cfml2wddx" input = "#remark17#" output = "wddxText51">
                    <cfwddx action = "cfml2wddx" input = "#remark18#" output = "wddxText52">
                    <cfwddx action = "cfml2wddx" input = "#remark19#" output = "wddxText53">
                    <cfwddx action = "cfml2wddx" input = "#remark20#" output = "wddxText54">
					
					
					
						
					<Row ss:AutoFitHeight="0">
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText2#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText3#</Data></Cell>
                        <cfif isdefined("form.cbCate")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText4#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbSizeID")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText5#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbCostCode")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText6#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbColorID")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText7#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbGroup")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText8#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbShelf")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText9#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbMItemNo")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText10#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbBrand")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText11#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbSupp")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText12#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbPacking")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText13#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbMinimum")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText14#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbMaximum")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText15#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbReorder")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText16#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbfcurrcode")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText17#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbfucost")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText18#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbfprice")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText19#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbQOH")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText20#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbQtyBF")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText21#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbUnit")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText22#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbCost")>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#ucost#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbCostformula")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText24#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbPrice")>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#price#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbPrice2")>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#price2#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbPrice3")>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#price3#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbPrice_Min")>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#price_min#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbQty2")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText29#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbQty3")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText30#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbQty4")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText31#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbQty5")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText32#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbQty6")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText33#</Data></Cell>
                        </cfif>
                         <cfif isdefined("form.cbcredate")>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#wddxText34#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem1")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText35#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem2")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText36#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem3")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText37#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem4")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText38#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem5")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText39#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem6")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText40#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem7")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText41#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem8")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText42#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem9")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText43#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem10")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText44#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem11")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText45#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem12")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText46#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem13")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText47#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem14")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText48#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem15")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText49#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem16")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText50#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem17")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText51#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem18")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText52#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem19")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText53#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbrem20")>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText54#</Data></Cell>
                        </cfif>

					</Row>
				<cfset i = incrementvalue(i)>
	</cfoutput>
		
				<Row ss:AutoFitHeight="0" ss:Height="12"/>

			</Table>
		 	
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
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls">
	</cfcase>
   
    
	<cfcase value="HTML">
<html>
<head>
<title>Product Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="file:///C|/Users/PC01/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfparam name="i" default="1" type="numeric">
<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">

<cfquery name="getgsetup" datasource="#dts#">
	select lastaccyear,cost,filterall,lCATEGORY,lGROUP,lSIZE,lMATERIAL,lMODEL,lRATING,lAGENT,lDRIVER,lLOCATION 
	from gsetup
</cfquery>

<cfquery name="getitem" datasource="#dts#">
	select itemno,desp,despa
<cfif isdefined("form.cbQOH")>
,qtybf
</cfif>
<cfif isdefined("form.cbCate")>
,category
</cfif>
<cfif isdefined("form.cbSizeID")>
	,sizeid
</cfif>
<cfif isdefined("form.cbCostCode")>
	,costcode
</cfif>
<cfif isdefined("form.cbColorID")>
	,colorid
</cfif>
<cfif isdefined("form.cbGroup")>
	,wos_group
</cfif>
<cfif isdefined("form.cbShelf")>
	,shelf
</cfif>
<cfif isdefined("form.cbMItemNo")>
	,AITEMNO
</cfif>
<cfif isdefined("form.cbBrand")>
	,brand
</cfif>
<cfif isdefined("form.cbSupp")>
	,Supp
</cfif>
<cfif isdefined("form.cbPacking")>
	,Packing
</cfif>
<cfif isdefined("form.cbMinimum")>
	,Minimum
</cfif>
<cfif isdefined("form.cbMaximum")>
	,Maximum
</cfif>
<cfif isdefined("form.cbReorder")>
	,Reorder
</cfif>
<cfif isdefined("form.cbfcurrcode")>
	,fcurrcode
</cfif>
<cfif isdefined("form.cbfucost")>
	,fucost
</cfif>
<cfif isdefined("form.cbfprice")>
	,fprice
</cfif>
<cfif isdefined("form.cbQtyBF")>
	,qtybf
</cfif>
<cfif isdefined("form.cbUnit")>
	,Unit
</cfif>
<cfif isdefined("form.cbCost")>
	,UCost
</cfif>
<cfif isdefined("form.cbPrice")>
	,price
</cfif>
<cfif isdefined("form.cbPrice2")>
	,price2
</cfif>
<cfif isdefined("form.cbPrice3")>
	,price3
</cfif>
<cfif isdefined("form.cbPrice_Min")>
	,price_min
</cfif>
<cfif isdefined("form.cbcostformula")>
	,costformula
</cfif>
<cfif isdefined("form.cbQty2")>
	,Qty2
</cfif>
<cfif isdefined("form.cbQty3")>
	,Qty3
</cfif>
<cfif isdefined("form.cbQty4")>
	,Qty4
</cfif>
<cfif isdefined("form.cbQty5")>
	,Qty5
</cfif>
<cfif isdefined("form.cbQty6")>
	,Qty6
</cfif>
<cfif isdefined("form.cbrem1")>
	,remark1
</cfif>
<cfif isdefined("form.cbrem2")>
	,remark2
</cfif>
<cfif isdefined("form.cbrem3")>
	,remark3
</cfif>
<cfif isdefined("form.cbrem4")>
	,remark4
</cfif>
<cfif isdefined("form.cbrem5")>
	,remark5
</cfif>
<cfif isdefined("form.cbrem6")>
	,remark6
</cfif>
<cfif isdefined("form.cbrem7")>
	,remark7
</cfif>
<cfif isdefined("form.cbrem8")>
	,remark8
</cfif>
<cfif isdefined("form.cbrem9")>
	,remark9
</cfif>
<cfif isdefined("form.cbrem10")>
	,remark10
</cfif>
<cfif isdefined("form.cbrem11")>
	,remark11
</cfif>
<cfif isdefined("form.cbrem12")>
	,remark12
</cfif>
<cfif isdefined("form.cbrem13")>
	,remark13
</cfif>
<cfif isdefined("form.cbrem14")>
	,remark14
</cfif>
<cfif isdefined("form.cbrem15")>
	,remark15
</cfif>
<cfif isdefined("form.cbrem16")>
	,remark16
</cfif>
<cfif isdefined("form.cbrem17")>
	,remark17
</cfif>
<cfif isdefined("form.cbrem18")>
	,remark18
</cfif>
<cfif isdefined("form.cbrem19")>
	,remark19
</cfif>
<cfif isdefined("form.cbrem20")>
	,remark20
</cfif>
<cfif isdefined("form.cbcredate")>
	,Created_on
</cfif> from icitem where EDI_ID >= 0
	<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
	and itemno >= '#form.productfrom#' and itemno <= '#form.productto#'
  	</cfif>
	<cfif form.catefrom neq "" and form.cateto neq "">
	and category >= '#form.catefrom#' and category <= '#form.cateto#'
  	</cfif>
	<cfif form.sizeidfrom neq "" and form.sizeidto neq "">
	and sizeid >= '#form.sizeidfrom#' and sizeid <= '#form.sizeidto#'
  	</cfif>
	<cfif form.costcodefrom neq "" and form.costcodeto neq "">
	and costcode >= '#form.costcodefrom#' and costcode <= '#form.costcodeto#'
  	</cfif>
	<cfif form.coloridfrom neq "" and form.coloridto neq "">
	and colorid >= '#form.coloridfrom#' and colorid <= '#form.coloridto#'
  	</cfif>
	<cfif form.shelffrom neq "" and form.shelfto neq "">
	and shelf >= '#form.shelffrom#' and shelf <= '#form.shelfto#'
  	</cfif>
	<cfif form.groupfrom neq "" and form.groupto neq "">
	and wos_group >= '#form.groupfrom#' and wos_group <= '#form.groupto#'
  	</cfif>
    <cfif isdefined('form.cbdiscountinue')>
    and nonstkitem != 'T'
    </cfif>
	order by itemno
</cfquery>






<!--- Control The Decimal Point --->
<cfquery name="getgsetup2" datasource='#dts#'>
	Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
<cfset stDecl_UPrice = ".">

<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
	<cfset stDecl_UPrice = stDecl_UPrice & "_">
</cfloop>

<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>
<p align="center"><font color="##000000" size="3" face="Arial, Helvetica, sans-serif"><strong>Product Listing</strong></font></p>

<cfif getitem.recordCount neq 0>
	<cfif isdefined("form.skeypage")>
		<cfset noOfPage=round(getitem.recordcount/20)>

		<cfif getitem.recordcount mod 20 LT 20 and getitem.recordcount mod 20 neq 0>
        	<cfset noOfPage = noOfPage + 1>
      	</cfif>

		<cfif form.skeypage gt noofpage OR form.skeypage lt 1>
      		<cfabort>
      	</cfif>
    </cfif>

	<cfform action="file:///C|/Users/PC01/Documents/My Received Files/l_icitem.cfm" method="post">
	<cfoutput>
		<input type="hidden" name="productfrom" value="#form.productfrom#">
		<input type="hidden" name="productto" value="#form.productto#">
		<input type="hidden" name="Catefrom" value="#form.Catefrom#">
		<input type="hidden" name="Cateto" value="#form.Cateto#">
		<input type="hidden" name="sizeidfrom" value="#form.sizeidfrom#">
		<input type="hidden" name="sizeidto" value="#form.sizeidto#">
		<input type="hidden" name="Costcodefrom" value="#form.Costcodefrom#">
		<input type="hidden" name="Costcodeto" value="#form.Costcodeto#">
		<input type="hidden" name="coloridfrom" value="#form.coloridfrom#">
		<input type="hidden" name="coloridto" value="#form.coloridto#">
		<input type="hidden" name="shelffrom" value="#form.shelffrom#">
		<input type="hidden" name="shelfto" value="#form.shelfto#">
		<input type="hidden" name="groupfrom" value="#form.groupfrom#">
		<input type="hidden" name="groupto" value="#form.groupto#">

		<cfif isdefined("form.cbCate")>
			<input type="hidden" name="cbCate" value="#form.cbCate#">
		</cfif>
		<cfif isdefined("form.cbSizeID")>
          	<input type="hidden" name="cbSizeID" value="#form.cbSizeID#">
		</cfif>
		<cfif isdefined("form.cbCostCode")>
          	<input type="hidden" name="cbCostCode" value="#form.cbCostCode#">
		</cfif>
		<cfif isdefined("form.cbColorID")>
          	<input type="hidden" name="cbColorID" value="#form.cbColorID#">
		</cfif>
		<cfif isdefined("form.cbGroup")>
          	<input type="hidden" name="cbGroup" value="#form.cbGroup#">
		</cfif>
		<cfif isdefined("form.cbShelf")>
          	<input type="hidden" name="cbShelf" value="#form.cbShelf#">
		</cfif>
 		<cfif isdefined("form.cbMItemNo")>
          	<input type="hidden" name="cbMItemNo" value="#form.cbMItemNo#">
		</cfif>
 		<cfif isdefined("form.cbBrand")>
         	<input type="hidden" name="cbBrand" value="#form.cbBrand#">
		</cfif>
 		<cfif isdefined("form.cbSupp")>
          	<input type="hidden" name="cbSupp" value="#form.cbSupp#">
		</cfif>
 		<cfif isdefined("form.cbPacking")>
          	<input type="hidden" name="cbPacking" value="#form.cbPacking#">
		</cfif>
 		<cfif isdefined("form.cbMinimum")>
          	<input type="hidden" name="cbMinimum" value="#form.cbMinimum#">
		</cfif>
 		<cfif isdefined("form.cbMaximum")>
          	<input type="hidden" name="cbMaximum" value="#form.cbMaximum#">
		</cfif>
 		<cfif isdefined("form.cbReorder")>
          	<input type="hidden" name="cbReorder" value="#form.cbReorder#">
		</cfif>
         		<cfif isdefined("form.cbfcurrcode")>
          	<input type="hidden" name="cbfcurrcode" value="#form.cbfcurrcode#">
		</cfif>
         		<cfif isdefined("form.cbfucost")>
          	<input type="hidden" name="cbfucost" value="#form.cbfucost#">
		</cfif>
         		<cfif isdefined("form.cbfprice")>
          	<input type="hidden" name="cbfprice" value="#form.cbfprice#">
		</cfif>
 		<cfif isdefined("form.cbQtyBF")>
          	<input type="hidden" name="cbQtyBF" value="#form.cbQtyBF#">
		</cfif>
 		<cfif isdefined("form.cbUnit")>
          	<input type="hidden" name="cbUnit" value="#form.cbUnit#">
		</cfif>
 		<cfif isdefined("form.cbCost")>
          	<input type="hidden" name="cbCost" value="#form.cbCost#">
		</cfif>
 		<cfif isdefined("form.cbPrice")>
          	<input type="hidden" name="cbPrice" value="#form.cbPrice#">
		</cfif>
 		<cfif isdefined("form.cbPrice2")>
          	<input type="hidden" name="cbPrice2" value="#form.cbPrice2#">
		</cfif>
 		<cfif isdefined("form.cbPrice3")>
          	<input type="hidden" name="cbPrice3" value="#form.cbPrice3#">
		</cfif>
 		<cfif isdefined("form.cbPrice_Min")>
          	<input type="hidden" name="cbPrice_Min" value="#form.cbPrice_Min#">
		</cfif>
 		<cfif isdefined("form.cbQty2")>
          	<input type="hidden" name="cbQty2" value="#form.cbQty2#">
		</cfif>
 		<cfif isdefined("form.cbQty3")>
          	<input type="hidden" name="cbQty3" value="#form.cbQty3#">
		</cfif>
 		<cfif isdefined("form.cbQty4")>
          	<input type="hidden" name="cbQty4" value="#form.cbQty4#">
		</cfif>
 		<cfif isdefined("form.cbQty5")>
          	<input type="hidden" name="cbQty5" value="#form.cbQty5#">
		</cfif>
 		<cfif isdefined("form.cbQty6")>
          	<input type="hidden" name="cbQty6" value="#form.cbQty6#">
		</cfif>
        <cfif isdefined("form.cbcredate")>
          	<input type="hidden" name="cbcredate" value="#form.cbcredate#">
		</cfif>
         		<cfif isdefined("form.cbQOH")>
          	<input type="hidden" name="cbQOH" value="#form.cbQOH#">
		</cfif>
        	<cfif isdefined("form.cbcostformula")>
          	<input type="hidden" name="cbcostformula" value="#form.cbcostformula#">
		</cfif>
	</cfoutput>

		<cfset noOfPage=round(getitem.recordcount/20)>

		<cfif getitem.recordcount mod 20 LT 20 and getitem.recordcount mod 20 neq 0>
			<cfset noOfPage = noOfPage + 1>
		</cfif>

		<cfif isdefined("start")>
			<cfset start = start>
		</cfif>

		<cfif isdefined("form.skeypage")>
			<cfset start = form.skeypage * 20 + 1 - 20>

			<cfif form.skeypage eq "1">
				<cfset start = "1">
			</cfif>
		</cfif>

		<cfset prevTwenty = start -20>
		<cfset nextTwenty = start +20>
		<cfset page=round(nextTwenty/20)>
	</cfform>

	<table width="100%" border="0" class="" align="center">
		<tr>
			<td colspan="8"><hr></td>
		</tr>
	  	<tr>
    		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">No</font></strong></td>
        	<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Item No</font></strong></td>
        	<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Description</font></strong></td>
			<cfif isdefined("form.cbCate")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>#getgsetup.lCATEGORY#</cfoutput></font></strong></td>
			</cfif>
			<cfif isdefined("form.cbSizeID")>
        		<td><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>#getgsetup.lSIZE#</cfoutput></font></strong></td>
			</cfif>
			<cfif isdefined("form.cbCostCode")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>#getgsetup.lRATING#</cfoutput></font></strong></td>
			</cfif>
			<cfif isdefined("form.cbColorID")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>#getgsetup.lMATERIAL#</cfoutput></font></strong></td>
			</cfif>
			<cfif isdefined("form.cbGroup")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>#getgsetup.lGROUP#</cfoutput></font></strong></td>
			</cfif>
			<cfif isdefined("form.cbShelf")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>#getgsetup.lMODEL#</cfoutput></font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbMItemNo")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Product Code</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbBrand")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Brand</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbSupp")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Supplier</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbPacking")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Packing</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbMinimum")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Minimum Qty</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbMaximum")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Maximum Qty</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbReorder")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Reorder Qty</font></strong></td>
			</cfif>
             			<cfif isdefined("form.cbfcurrcode")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Foreign Currency</font></strong></td>
			</cfif>
             			<cfif isdefined("form.cbfucost")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Foreign Unit Cost</font></strong></td>
			</cfif>
             			<cfif isdefined("form.cbfprice")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Foreign Selling Price</font></strong></td>
			</cfif>
             			<cfif isdefined("form.cbQOH")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Quantity On Hand</font></strong></td>
			</cfif>

 			<cfif isdefined("form.cbQtyBF")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Qty B/F</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbUnit")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Unit</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbCost")>
        	  	<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Cost Price</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbCostformula")>
        	  	<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Cost Code</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbPrice")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Selling Price</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbPrice2")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Selling Price 2</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbPrice3")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">M. U. Price</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbPrice_Min")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Min. Selling Price</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbQty2")>
        	  	<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Length</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbQty3")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Width</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbQty4")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Thickness</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbQty5")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Weight / Length</font></strong></td>
			</cfif>
 			<cfif isdefined("form.cbQty6")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Price / Weight</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbcredate")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Created Date</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem1")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 1</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem2")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 2</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem3")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 3</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem4")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 4</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem5")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 5</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem6")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 6</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem7")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 7</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem8")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 8</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem9")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 9</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem10")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 10</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem11")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 11</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem12")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 12</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem13")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 13</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem14")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 14</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem15")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 15</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem16")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 16</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem17")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 17</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem18")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 18</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem19")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 19</font></strong></td>
			</cfif>
            <cfif isdefined("form.cbrem20")>
          		<td><strong><font size="2" face="Arial, Helvetica, sans-serif">Remark 20</font></strong></td>
			</cfif>
  		</tr>
  		<tr>
			<td colspan="8"><hr></td>
		</tr>
  		<cfset i = ((page - 1) * 20) + 1>

		<cfoutput query="getitem" startrow="#start#">
        
        
								<cfif isdefined("form.cbQOH")>
								<cfif #qtybf# neq 0>
									<cfset itembal = #qtybf#>
								<cfelse>
									<cfset itembal = 0>
								</cfif>
                                
                                
								<cfquery name="getin" datasource="#dts#">
									select 
									sum(qty)as sumqty 
									from ictran 
									where type in ('RC','CN','OAI','TRIN') 
									and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#"> 
									and fperiod <> '99' 
									and (void = '' or void is null)
								</cfquery>

								<cfif getin.sumqty neq "">
									<cfset inqty = getin.sumqty>
								<cfelse>
									<cfset inqty = 0>
								</cfif>
                                
								<cfquery name="getout" datasource="#dts#">
									select 
									sum(qty)as sumqty 
									from ictran 
									where type in ('INV','DN','PR','CS','ISS','OAR','TROU') 
									and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#"> 
									
									and fperiod <> '99' 
									and (void = '' or void is null)
								</cfquery>

								<cfif getout.sumqty neq "">
									<cfset outqty = getout.sumqty>
								<cfelse>
									<cfset outqty = 0>
								</cfif>

								<cfquery name="getdo" datasource="#dts#">
									select 
									sum(qty)as sumqty 
									from ictran 
									where type='DO' 
									and (toinv='' or toinv is null)
									and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#"> 
									
									and fperiod <> '99' 
									and (void = '' or void is null)
								</cfquery>

								<cfif getdo.sumqty neq "">
									<cfset DOqty = getdo.sumqty>
								<cfelse>
									<cfset DOqty = 0>
								</cfif>
							
								<cfquery name="getpo" datasource="#dts#">
									select 
									ifnull(sum(qty),0) as sumqty 
									from ictran 
									where type='PO' 
									and itemno=<cfqueryparam cfsqltype="cf_sql_char" value="#itemno#"> 
									and fperiod <> '99' 
								
									and (void = '' or void is null) and (toinv='' or toinv is null)
								</cfquery>		
        
        
        
        <cfset locbalonhand = val(itembal) + val(inqty) - val(outqty) - val(doqty)>
        </cfif>
  			<tr>
    			<td><div align="center">#i#</div></td>
   	 			<td><cfif getpin2.h1311 eq 'T'><a href="file:///C|/Users/PC01/Documents/My Received Files/icitem2.cfm?type=Edit&itemno=#itemno#">#itemno#</a><cfelse>#itemno#</cfif></td>
    			<td>#desp#<br>#despa#</td>
				<cfif isdefined("form.cbCate")>
      				<td>#category#</td>
				</cfif>
				<cfif isdefined("form.cbSizeID")>
				  	<td>#sizeid#</td>
				</cfif>
				<cfif isdefined("form.cbCostCode")>
				  	<td>#costcode#</td>
				</cfif>
				<cfif isdefined("form.cbColorID")>
				  	<td>#colorid#</td>
				</cfif>
				<cfif isdefined("form.cbGroup")>
				  	<td>#wos_group#</td>
				</cfif>
				<cfif isdefined("form.cbShelf")>
				  	<td>#shelf#</td>
				</cfif>
				<cfif isdefined("form.cbMItemNo")>
				  	<!--- <td>#MItemNo#</td> --->
				  	<td>#AITEMNO#</td>
				</cfif>
				<cfif isdefined("form.cbBrand")>
				  	<td>#brand#</td>
				</cfif>
				<cfif isdefined("form.cbSupp")>
				  	<td>#Supp#</td>
				</cfif>
				<cfif isdefined("form.cbPacking")>
				  	<td>#Packing#</td>
				</cfif>
				<cfif isdefined("form.cbMinimum")>
				  	<td>#Minimum#</td>
				</cfif>
				<cfif isdefined("form.cbMaximum")>
				  	<td>#Maximum#</td>
				</cfif>
				<cfif isdefined("form.cbReorder")>
				  	<td>#Reorder#</td>
				</cfif>
                				<cfif isdefined("form.cbfcurrcode")>
				  	<td>#fcurrcode#</td>
				</cfif>
                				<cfif isdefined("form.cbfucost")>
				  	<td>#fucost#</td>
				</cfif>
                				<cfif isdefined("form.cbfprice")>
				  	<td>#fprice#</td>
				</cfif>
                				<cfif isdefined("form.cbQOH")>
				  	<td>#locbalonhand#</td>
				</cfif>
				<cfif isdefined("form.cbQtyBF")>
				  	<td>#qtybf#</td>
				</cfif>
				<cfif isdefined("form.cbUnit")>
				  	<td>#Unit#</td>
				</cfif>
				<cfif isdefined("form.cbCost")>
				  	<td><div align="right">#NumberFormat(UCost, stDecl_UPrice)#</div></td>
				</cfif>
                <cfif isdefined("form.cbCostformula")>
				  	<td>#costformula#</div></td>
				</cfif>
				<cfif isdefined("form.cbPrice")>
				  	<td><div align="right">#NumberFormat(price, stDecl_UPrice)#</div></td>
				</cfif>
				<cfif isdefined("form.cbPrice2")>
				  	<td><div align="right">#NumberFormat(price2, stDecl_UPrice)#</div></td>
				</cfif>
				<cfif isdefined("form.cbPrice3")>
				  	<td><div align="right">#NumberFormat(price3, stDecl_UPrice)#</div></td>
				</cfif>
				<cfif isdefined("form.cbPrice_Min")>
				  	<td><div align="right">#NumberFormat(price_min, stDecl_UPrice)#</div></td>
				</cfif>
				<cfif isdefined("form.cbQty2")>
				  	<td>#Qty2#</td>
				</cfif>
				<cfif isdefined("form.cbQty3")>
				  	<td>#Qty3#</td>
				</cfif>
				<cfif isdefined("form.cbQty4")>
				  	<td>#Qty4#</td>
				</cfif>
				<cfif isdefined("form.cbQty5")>
				  	<td>#Qty5#</td>
				</cfif>
				<cfif isdefined("form.cbQty6")>
				  	<td>#Qty6#</td>
				</cfif>
                <cfif isdefined("form.cbcredate")>
				  	<td>#dateformat(Created_on,'DD/MM/YYYY')#</td>
				</cfif>
                <cfif isdefined("form.cbrem1")>
				  	<td>#remark1#</td>
				</cfif>
                <cfif isdefined("form.cbrem2")>
				  	<td>#remark2#</td>
				</cfif>
                <cfif isdefined("form.cbrem3")>
				  	<td>#remark3#</td>
				</cfif>
                <cfif isdefined("form.cbrem4")>
				  	<td>#remark4#</td>
				</cfif>
                <cfif isdefined("form.cbrem5")>
				  	<td>#remark5#</td>
				</cfif>
                <cfif isdefined("form.cbrem6")>
				  	<td>#remark6#</td>
				</cfif>
                <cfif isdefined("form.cbrem7")>
				  	<td>#remark7#</td>
				</cfif>
                <cfif isdefined("form.cbrem8")>
				  	<td>#remark8#</td>
				</cfif>
                <cfif isdefined("form.cbrem9")>
				  	<td>#remark9#</td>
				</cfif>
                <cfif isdefined("form.cbrem10")>
				  	<td>#remark10#</td>
				</cfif>
                <cfif isdefined("form.cbrem11")>
				  	<td>#remark11#</td>
				</cfif>
                <cfif isdefined("form.cbrem12")>
				  	<td>#remark12#</td>
				</cfif>
                <cfif isdefined("form.cbrem13")>
				  	<td>#remark13#</td>
				</cfif>
                <cfif isdefined("form.cbrem14")>
				  	<td>#remark14#</td>
				</cfif>
                <cfif isdefined("form.cbrem15")>
				  	<td>#remark15#</td>
				</cfif>
                <cfif isdefined("form.cbrem16")>
				  	<td>#remark16#</td>
				</cfif>
                <cfif isdefined("form.cbrem17")>
				  	<td>#remark17#</td>
				</cfif>
                <cfif isdefined("form.cbrem18")>
				  	<td>#remark18#</td>
				</cfif>
                <cfif isdefined("form.cbrem19")>
				  	<td>#remark19#</td>
				</cfif>
                <cfif isdefined("form.cbrem20")>
				  	<td>#remark20#</td>
				</cfif>
			</tr>
			<cfset i = incrementvalue(i)>
  		</cfoutput>
	</table>
<cfelse>
  	<h3><font size="2" face="Arial, Helvetica, sans-serif">No Records were found.</font></h3>
</cfif>

<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>
</cfcase>
</cfswitch>