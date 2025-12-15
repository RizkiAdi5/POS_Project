<cfsetting requesttimeout="3600">

<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfset startperiod = val(form.periodto) + 10>
<cfset calperiod = (val(form.periodto)-6) + 10>

<cfquery name="getgeneral" datasource="#dts#">
	select cost,compro,lastaccyear 
	from gsetup;
</cfquery>

<cfswitch expression="#getgeneral.cost#">
	<cfcase value="FIXED">
		<cfset costingmethod = "Fixed Cost Method">
	</cfcase>
	<cfcase value="MONTH">
		<cfset costingmethod = "Month Average Method">
	</cfcase>
	<cfcase value="MOVING">
		<cfset costingmethod = "Moving Average Method">
	</cfcase>
	<cfcase value="FIFO">
		<cfset costingmethod = "First In First Out Method">
	</cfcase>
	<cfdefaultcase>
		<cfset costingmethod = "Last In First Out Method">
	</cfdefaultcase>
</cfswitch>

<cfquery name="getgsetup2" datasource='#dts#'>
  	select * 
	from gsetup2;
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
<cfset stDecl_UPrice = ",.">
<cfset iDecl_TPrice = getgsetup2.Decl_UPrice>
<cfset stDecl_TPrice = ",.">

<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
  	<cfset stDecl_UPrice = stDecl_UPrice & "_">
</cfloop>
<cfloop index="LoopCount" from="1" to="#iDecl_TPrice#">
  	<cfset stDecl_TPrice = stDecl_TPrice & "_">
</cfloop>
    
<cfquery name="getgroup" datasource="#dts#">
	select a.wos_group,(select z.desp from icgroup z where a.wos_group=z.wos_group) as desp from icitem a
	where a.itemno <>''
	<cfif isdefined("form.include0") and form.include0 eq "yes">
	<cfelse>
	and (a.qtybf<cfloop index="a" from="11" to="#startperiod#">+a.qin#a#-a.qout#a#</cfloop>) > 0
	</cfif>
	<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
	and a.category between '#form.catefrom#' and '#form.cateto#'
	</cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
	and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
	</cfif>
	<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
	and a.itemno between '#form.itemfrom#' and '#form.itemto#'
	</cfif>
	<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
	and a.supp between '#form.suppfrom#' and '#form.suppto#'
	</cfif>
	group by a.wos_group order by a.wos_group
</cfquery>

<cfswitch expression="#form.result#">
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
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s28">
   <NumberFormat ss:Format="@"/>
  </Style>
  <Style ss:ID="s29">
   <NumberFormat ss:Format="#,###,###,##0"/>
  </Style>
   <Style ss:ID="s30">
    <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
   <Font ss:FontName="Verdana" x:Family="Swiss"/>
  </Style>
  <Style ss:ID="s31">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="@"/>
  </Style>
  <Style ss:ID="s32">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="#,###,###,##0"/>
  </Style>
  <Style ss:ID="s34">
   <Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
  </Style>
  <Style ss:ID="s35">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
   </Borders>
   <NumberFormat ss:Format="#,###,###,##0"/>
  </Style>
 </Styles>
 <Worksheet ss:Name="Stock Aging">
  <cfoutput>
  <Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="11.25">
	<Column ss:AutoFitWidth="0" ss:Width="53.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="193.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="53.75"/>
   <Column ss:AutoFitWidth="0" ss:Width="63.75" ss:Span="8"/>
   
	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:MergeAcross="10" ss:StyleID="s22"><Data ss:Type="String">Stock Aging Report</Data></Cell>
	</Row>
   	<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
	<cfwddx action = "cfml2wddx" input = "CATE: #form.catefrom# - #form.cateto#" output = "wddxText">
	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    	<Cell ss:MergeAcross="10" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
   	</Row>
	</cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
	<cfwddx action = "cfml2wddx" input = "GROUP: #form.groupfrom# - #form.groupto#" output = "wddxText">
	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    	<Cell ss:MergeAcross="10" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
   	</Row>
	</cfif>
	<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
	<cfwddx action = "cfml2wddx" input = "ITEM.NO. #form.itemfrom# - #form.itemto#" output = "wddxText">
	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    	<Cell ss:MergeAcross="10" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
   	</Row>
	</cfif>
	<cfif form.suppfrom neq "" and form.suppto neq "">
	<cfwddx action = "cfml2wddx" input = "SUPP.NO.: #form.suppfrom# - #form.suppto#" output = "wddxText">
	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    	<Cell ss:MergeAcross="10" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
   	</Row>
	</cfif>
	<cfif form.periodto neq "">
	<cfwddx action = "cfml2wddx" input = "PERIOD TO: #form.periodto#" output = "wddxText">
	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    	<Cell ss:MergeAcross="10" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
   	</Row>
	</cfif>
	
	<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="9" ss:StyleID="s26"><Data ss:Type="String">#getgeneral.compro#</Data></Cell>
		<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
	</Row>
   
	<Row ss:AutoFitHeight="0" ss:Height="20.0625">
		<Cell ss:MergeAcross="1" ss:StyleID="s30"><Data ss:Type="String">ITEM</Data></Cell>
		<cfif isdefined("form.includeCategory") and form.includeCategory eq "yes">
			<Cell ss:StyleID="s30"><Data ss:Type="String"></Data></Cell>
		</cfif>		
		<Cell ss:StyleID="s30"><Data ss:Type="String">UNIT</Data></Cell>
		<Cell ss:MergeAcross="7" ss:StyleID="s30"><Data ss:Type="String">MONTH</Data></Cell>
	</Row>
	<!--- ADD ON 030608, FOR THE 12 COLUMN VIEW --->
	<cfif form.view eq "view12">
		<cfset maxcounter = 12>
	<cfelse>
		<cfset maxcounter = 6>
	</cfif>
	<Row ss:AutoFitHeight="0" ss:Height="23.0625">
		<Cell ss:StyleID="s27"><Data ss:Type="String">NO.</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">DESCRIPTION</Data></Cell>
		<cfif isdefined("form.includeCategory") and form.includeCategory eq "yes">
			<Cell ss:StyleID="s27"><Data ss:Type="String">CATEGORY</Data></Cell>
		</cfif>
		<Cell ss:StyleID="s27"><Data ss:Type="String">MEASURE</Data></Cell>
		<cfif maxcounter eq "12">
			<Cell ss:StyleID="s27"><Data ss:Type="String">12 Mths</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">11 Mths</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">10 Mths</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">9 Mths</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">8 Mths</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">7 Mth</Data></Cell>
		</cfif>
		<Cell ss:StyleID="s27"><Data ss:Type="String">6 Mths</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">5 Mths</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">4 Mths</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">3 Mths</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">2 Mths</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">1 Mth</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">Current</Data></Cell>
		<Cell ss:StyleID="s27"><Data ss:Type="String">On Hand</Data></Cell>
	</Row>
   	
	<cfloop query="getgroup">
		<cfwddx action = "cfml2wddx" input = "GROUP: #getgroup.wos_group#" output = "wddxText">
		<cfwddx action = "cfml2wddx" input = "#getgroup.desp#" output = "wddxText2">
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
			<Cell ss:MergeAcross="9" ss:StyleID="s26"><Data ss:Type="String">#wddxText2#</Data></Cell>
		</Row>
		
		<cfquery name="create" datasource="#dts#">
			create table temp_item as
			select a.itemno, a.desp, a.category, a.unit, a.ucost,(a.qtybf<cfloop index="a" from="11" to="#startperiod#">+a.qin#a#-a.qout#a#</cfloop>) as qbalance
			from icitem a
			where a.itemno <>'' and wos_group='#getgroup.wos_group#'
			<cfif isdefined("form.include0") and form.include0 eq "yes">
			<cfelse>
				and (a.qtybf<cfloop index="a" from="11" to="#startperiod#">+a.qin#a#-a.qout#a#</cfloop>) > 0
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and a.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
				and a.itemno between '#form.itemfrom#' and '#form.itemto#'
			</cfif>
			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
				and a.supp between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
		</cfquery>
		<cfquery name="alter" datasource="#dts#">
			alter table temp_item add column totqtyout double(17,7) default 0, add column balqty0 double(17,7) default 0,
			add column balqty1 double(17,7) default 0, add column balqty2 double(17,7) default 0, add column balqty3 double(17,7) default 0,
			add column balqty4 double(17,7) default 0, add column balqty5 double(17,7) default 0, add column balqty6 double(17,7) default 0,
			add column balqty7 double(17,7) default 0, add column balqty8 double(17,7) default 0, add column balqty9 double(17,7) default 0,
			add column balqty10 double(17,7) default 0, add column balqty11 double(17,7) default 0, add column balqty12 double(17,7) default 0
		</cfquery>
		<cfquery name="update" datasource="#dts#">
			update temp_item t,icitem i
			set totqtyout = <cfloop index="a" from="11" to="#startperiod#">+i.qout#a#</cfloop>,
			balqty#maxcounter# = i.qtybf
			where t.itemno = i.itemno
		</cfquery>
		<cfset counter = 0>
		<cfloop from="#startperiod#" to="11" index="a" step="-1">
			<cfif counter LT maxcounter>
				<cfquery name="update" datasource="#dts#">
					update temp_item t,icitem i
					set balqty#counter# = i.qin#a#
					where t.itemno = i.itemno
				</cfquery>
			<cfelse>
					<cfquery name="update" datasource="#dts#">
					update temp_item t,icitem i
					set balqty#maxcounter# = balqty#maxcounter# + i.qin#a#
					where t.itemno = i.itemno
				</cfquery>
			</cfif>
			<cfset counter = counter + 1>
		</cfloop>
			
		<cfquery name="getitem" datasource="#dts#">
			select * from temp_item t
		</cfquery>
		
		<cfloop query="getitem">
		<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText">
		<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText2">
			<cfset thisbalqty = -(getitem.totqtyout)>
			<cfif maxcounter eq "12">
				<cfif getitem.balqty12 GT 0>
					<cfset thisbalqty = getitem.balqty12 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal12 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal12 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty12 + thisbalqty>
					<cfset thisbal12 = 0>
				</cfif>
				<cfif getitem.balqty11 GT 0>
					<cfset thisbalqty = getitem.balqty11 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal11 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal11 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty11 + thisbalqty>
					<cfset thisbal11 = 0>
				</cfif>
				<cfif getitem.balqty10 GT 0>
					<cfset thisbalqty = getitem.balqty10 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal10 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal10 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty10 + thisbalqty>
					<cfset thisbal10 = 0>
				</cfif>
				<cfif getitem.balqty9 GT 0>
					<cfset thisbalqty = getitem.balqty9 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal9 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal9 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty9 + thisbalqty>
					<cfset thisbal9 = 0>
				</cfif>
				<cfif getitem.balqty8 GT 0>
					<cfset thisbalqty = getitem.balqty8 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal8 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal8 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty8 + thisbalqty>
					<cfset thisbal8 = 0>
				</cfif>
				<cfif getitem.balqty7 GT 0>
					<cfset thisbalqty = getitem.balqty7 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal7 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal7 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty7 + thisbalqty>
					<cfset thisbal7 = 0>
				</cfif>
			</cfif>
				<cfif getitem.balqty6 GT 0>
					<cfset thisbalqty = getitem.balqty6 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal6 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal6 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty6 + thisbalqty>
					<cfset thisbal6 = 0>
				</cfif>
				<cfif getitem.balqty5 GT 0>
					<cfset thisbalqty = getitem.balqty5 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal5 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal5 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty5 + thisbalqty>
					<cfset thisbal5 = 0>
				</cfif>
				<cfif getitem.balqty4 GT 0>
					<cfset thisbalqty = getitem.balqty4 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal4 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal4 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty4 + thisbalqty>
					<cfset thisbal4 = 0>
				</cfif>
				<cfif getitem.balqty3 GT 0>
					<cfset thisbalqty = getitem.balqty3 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal3 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal3 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty3 + thisbalqty>
					<cfset thisbal3 = 0>
				</cfif>
				<cfif getitem.balqty2 GT 0>
					<cfset thisbalqty = getitem.balqty2 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal2 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal2 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty2 + thisbalqty>
					<cfset thisbal2 = 0>
				</cfif>
				<cfif getitem.balqty1 GT 0>
					<cfset thisbalqty = getitem.balqty1 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal1 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal1 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty1 + thisbalqty>
					<cfset thisbal1 = 0>
				</cfif>
				<cfif getitem.balqty0 GT 0>
					<cfset thisbalqty = getitem.balqty0 + thisbalqty>
					<cfif thisbalqty GTE 0>
						<cfset thisbal0 = thisbalqty>
						<cfset thisbalqty = 0>
					<cfelse>
						<cfset thisbal0 = 0>
					</cfif>
				<cfelse>
					<cfset thisbalqty = getitem.balqty0 + thisbalqty>
					<cfset thisbal0 = 0>
				</cfif>
				<cfif thisbalqty LT 0>
					<cfif maxcounter eq "12">
						<cfset thisbal12 = thisbalqty>
					<cfelse>
						<cfset thisbal6 = thisbalqty>
					</cfif>
				</cfif>
					
					
			<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText#</Data></Cell>
			<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
			<cfif isdefined("form.includeCategory") and form.includeCategory eq "yes">
				<Cell ss:StyleID="s28"><Data ss:Type="String">#getitem.category#</Data></Cell>
			</cfif>
			<Cell ss:StyleID="s28"><Data ss:Type="String">#getitem.unit#</Data></Cell>
			<cfif maxcounter eq "12">	<!--- ADD ON 030608, FOR THE 12 COLUMN VIEW --->
				<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal12#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal11#</Data></Cell>
				
				<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal10#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal9#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal8#</Data></Cell>
				<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal7#</Data></Cell>
			</cfif>
			<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal6#</Data></Cell>
			<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal5#</Data></Cell>
			<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal4#</Data></Cell>
			<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal3#</Data></Cell>
			<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal2#</Data></Cell>
			<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal1#</Data></Cell>
			<Cell ss:StyleID="s29"><Data ss:Type="String">#thisbal0#</Data></Cell>
			<Cell ss:StyleID="s29"><Data ss:Type="String">#getitem.qbalance#</Data></Cell>
		</Row>
		</cfloop>
		
		<Row ss:AutoFitHeight="0" ss:Height="12"/>
		<cfquery name="drop" datasource="#dts#">
			drop table temp_item
		</cfquery>
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

	<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#_IL_SA_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#_IL_SA_#huserid#.xls">
	</cfcase>
	
	<cfcase value="HTML">
	<html>
	<head>
		<title>Stock Aging Report</title>
		<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
	</head>
	
	<body>
    
<cfif getgeneral.cost neq "FIFO" and getgeneral.cost neq "LIFO">
	<table width="100%" border="0" align="center" cellspacing="0">
		<!--- ADD ON 030608, FOR THE 12 COLUMN VIEW OR 6 COLUMN VIEW --->
		<cfif form.view eq "view12">
			<cfset maxcounter = 12>
		<cfelse>
			<cfset maxcounter = 6>
		</cfif>
		<cfoutput>
		<tr>
			<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Stock Aging Report</strong></font></div></td>
            
		</tr>
        <tr>
        <td colspan="100%"><div align="center"><font face="Times New Roman, Times, serif">Calculated by <cfoutput>#costingmethod#</cfoutput></font></div></td>
        </tr>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATE: #form.catefrom# - #form.cateto#</font></div></td>
			</tr>
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
			</tr>
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM.NO. #form.itemfrom# - #form.itemto#</font></div></td>
			</tr>
		</cfif>
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">SUPP.NO.: #form.suppfrom# - #form.suppto#</font></div></td>
			</tr>
		</cfif>
		<cfif form.periodto neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD TO: #form.periodto#</font></div></td>
			</tr>
		</cfif>
		<tr>
			<td colspan="2"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
			<cfif maxcounter eq "12"><td colspan="26"><cfelse><td colspan="14"></td></cfif>
			<td colspan="1"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		</cfoutput>
		<tr>
			<td colspan="100%"><hr/></td>
		</tr>
		<tr>
			<td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">ITEM</font></div></td>
			<cfif isdefined("form.includeCategory") and form.includeCategory eq "yes">
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
			</cfif>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">UNIT</font></div></td>
			  
			  
			 <cfif maxcounter eq "12">
				<cfif lcase(hcomid) eq "mhca_i"><td colspan="26"><cfelse><td colspan="13"></cfif>
			<cfelse>
				<cfif lcase(hcomid) eq "mhca_i"><td colspan="14"><cfelse><td colspan="7"></cfif>
			</cfif>
			
				<div align="center"><font size="2" face="Times New Roman, Times, serif">
				<--------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MONTH&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------->
				</font></div>
                Qty
			</td>
		
       </tr>
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">NO.</font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DESCRIPTION</font></div></td>
			<cfif isdefined("form.includeCategory") and form.includeCategory eq "yes">
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CATEGORY</font></div></td>
			</cfif>
			
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">MEASURE</font></div></td>
			<cfif maxcounter eq "12">
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">12</font></div></td>
				<td></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">11</font></div></td>
				<td></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">10</font></div></td>
				<td></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">9</font></div></td>
				<td></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">8</font></div></td>
				<td></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">7</font></div></td>
                 <td></td>
			</cfif>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">6</font></div></td>
            <td></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">5</font></div></td>
            <td></td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">4</font></div></td>
			<td></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">3</font></div></td>
			<td></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">2</font></div></td>
			<td></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">1</font></div></td>
			<td></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">0</font></div></td>
			<td></td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY ON HAND</font></div></td>
		</tr>
		<tr>
			<td colspan="100%"><hr/></td>
		</tr>
	
		<cfoutput>
		<cfloop query="getgroup">
			<tr>
				<td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong><u>GROUP: #getgroup.wos_group#</u></strong></font></div></td>
				<td colspan="5"><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong><u>#getgroup.desp#</u></strong></font></div></td>
	
			</tr>
			<!--- REPLACE THE PREVIOUS QUERY ON 280508 --->
			<cfquery name="create" datasource="#dts#">
				create table temp_item as
				select a.itemno, a.desp, a.ucost, a.category, a.unit,b.lastin,c.lastout,d.qin,e.qout,f.rcamt,f.rcqty,g.pramt,g.prqty,h.movqin,i.movqout,(a.qtybf<cfloop index="a" from="11" to="#startperiod#">+a.qin#a#-a.qout#a#</cfloop>) as qbalance
                <cfswitch expression="#getgeneral.cost#">
			<cfcase value="FIXED">
			</cfcase>
			<cfcase value="MONTH">,((((ifnull(a.qtybf,0))*ifnull(a.avcost,0))+ifnull(f.rcamt,0)-ifnull(g.pramt,0))/((ifnull(a.qtybf,0))+ifnull(f.rcqty,0)-ifnull(g.prqty,0))) as unitcost
			</cfcase>
			<cfcase value="MOVING">			,((((ifnull(a.qtybf,0))+ifnull(h.movqin,0)-ifnull(i.movqout,0))*ifnull(a.avcost2,0)+ifnull(f.rcamt,0)-ifnull(g.pramt,0))/((ifnull(a.qtybf,0))+ifnull(h.movqin,0)-ifnull(i.movqout,0)+ifnull(f.rcqty,0)-ifnull(g.prqty,0))) as unitcost
			
			</cfcase>
		</cfswitch>
        
                from icitem as a

		left join
		(
			select sum(qty) as lastin,itemno 
			from ictran
			where type in ('RC','CN','OAI','TRIN') and (void = '' or void is null)
			<cfif form.periodto neq "">
			and fperiod+0 < '1'
			</cfif> 
			group by itemno
		) as b on a.itemno=b.itemno

		left join
		(
			select sum(qty) as lastout,itemno 
			from ictran
			where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') and (void = '' or void is null) and toinv=''
			<cfif form.periodto neq "">
			and fperiod+0 < '1'
			</cfif> 
			group by itemno
		) as c on a.itemno=c.itemno

		left join
		(
			select sum(qty) as qin,itemno 
			from ictran
			where type in ('RC','CN','OAI','TRIN') and (void = '' or void is null)
			<cfif form.periodto neq "">
			and fperiod+0 between '1' and '#form.periodto#'
			</cfif> 
			group by itemno
		) as d on a.itemno=d.itemno

		left join
		(
			select sum(qty) as qout,itemno 
			from ictran
			where type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') and (void = '' or void is null) and toinv=''
			<cfif form.periodto neq "">
			and fperiod+0 between '1' and '#form.periodto#'
			</cfif> 
			group by itemno
		) as e on a.itemno=e.itemno

		left join
		(
			select sum(qty) as rcqty,sum(amt) as rcamt,itemno 
			from ictran
			where type='RC' and (void = '' or void is null)
			<cfif  form.periodto neq "">
			and fperiod+0 <= '#form.periodto#'
			</cfif> 
			group by itemno
		) as f on a.itemno=f.itemno

		left join
		(
			select sum(qty) as prqty,sum(amt) as pramt,itemno 
			from ictran
			where type='PR' and (void = '' or void is null)
			<cfif form.periodto neq "">
			and fperiod+0 <= '#form.periodto#'
			</cfif> 
			group by itemno
		) as g on a.itemno=g.itemno

		left join
		(
			select sum(qty) as movqin,itemno 
			from ictran
			where type='CN' and wos_date=(select max(wos_date) from ictran where type='RC' and (void = '' or void is null))	and (void = '' or void is null)
			<cfif form.periodto neq "">
			and fperiod+0 <= '#form.periodto#'
			</cfif> 
			group by itemno
		) as h on a.itemno=h.itemno

		left join
		(
			select sum(qty) as movqout,itemno 
			from ictran
			where type in ('CN','INV') and wos_date=(select max(wos_date) from ictran where type='RC' and (void = '' or void is null)) and (void = '' or void is null)
			<cfif form.periodto neq "">
			and fperiod+0 <= '#form.periodto#'
			</cfif> 
			group by itemno
		) as i on a.itemno=i.itemno

		left join
		(	
			select (ifnull(bb.sumqty,0)-ifnull(cc.sumqty,0)) as pqty,ifnull(bb.sumqty,0) as pin,ifnull(cc.sumqty,0) as pout,aa.itemno 
			from icitem as aa
			left join
			(
				select sum(qty) as sumqty,itemno 
				from ictran
				where (void = '' or void is null) and type in ('RC','CN','OAI','TRIN') and fperiod='99' 
				group by itemno
			) as bb on aa.itemno=bb.itemno

			left join
			(
				select sum(qty) as sumqty, itemno 
				from ictran
				where (void = '' or void is null) and type in ('INV','PR','CS','DN','ISS','OAR','TROU','DO') and fperiod='99' and toinv='' 
				group by itemno
			) as cc on aa.itemno=cc.itemno

			<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
			and aa.supp between '#form.suppfrom#' and '#form.suppto#'
			</cfif>
			<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			and aa.itemno between '#form.itemfrom#' and '#form.itemto#'
			</cfif>
			<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			and aa.category between '#form.catefrom#' and '#form.cateto#'
			</cfif>
			<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
			and aa.wos_group between '#form.groupfrom#' and '#form.groupto#'
			</cfif>
			group by aa.itemno
		) as j on a.itemno = j.itemno

        
				where a.itemno <>'' and wos_group='#getgroup.wos_group#'
				
		<cfif isdefined("form.include0") and form.include0 eq "yes">
        
		<cfelse>
       
        and (a.qtybf<cfloop index="a" from="11" to="#startperiod#">+a.qin#a#-a.qout#a#</cfloop>) > 0
				</cfif>
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
					and a.category between '#form.catefrom#' and '#form.cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
					and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
				<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
					and a.itemno between '#form.itemfrom#' and '#form.itemto#'
				</cfif>
				<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
					and a.supp between '#form.suppfrom#' and '#form.suppto#'
				</cfif>
                
			</cfquery>
			<cfquery name="alter" datasource="#dts#">
				alter table temp_item add column totqtyout double(17,7) default 0, add column balqty0 double(17,7) default 0,
				add column balqty1 double(17,7) default 0, add column balqty2 double(17,7) default 0, add column balqty3 double(17,7) default 0,
				add column balqty4 double(17,7) default 0, add column balqty5 double(17,7) default 0, add column balqty6 double(17,7) default 0,
				add column balqty7 double(17,7) default 0, add column balqty8 double(17,7) default 0, add column balqty9 double(17,7) default 0,
				add column balqty10 double(17,7) default 0, add column balqty11 double(17,7) default 0, add column balqty12 double(17,7) default 0
 
			</cfquery>
			
			<cfquery name="update" datasource="#dts#">
				update temp_item t,icitem i
				set totqtyout = <cfloop index="a" from="11" to="#startperiod#">+i.qout#a#</cfloop>,
				balqty#maxcounter# = i.qtybf
				where t.itemno = i.itemno
			</cfquery>
		
				<cfset counter = 0>
				<!---cfset maxcounter = 6--->
				<cfloop from="#startperiod#" to="11" index="a" step="-1">
					<cfif counter LT maxcounter>
						<cfquery name="update" datasource="#dts#">
							update temp_item t,icitem i
							set balqty#counter# = i.qin#a#
							where t.itemno = i.itemno
						</cfquery>
					<cfelse>
						<cfquery name="update" datasource="#dts#">
							update temp_item t,icitem i
							set balqty#maxcounter# = balqty#maxcounter# + i.qin#a#
							where t.itemno = i.itemno
						</cfquery>
					</cfif>
					<cfset counter = counter + 1>
				</cfloop>
			<!---/cfif--->
			
			<cfquery name="getitem" datasource="#dts#">
				select * from temp_item t
			</cfquery>
   
			<cfloop query="getitem">
				   
				<cfset thisbalqty = -(getitem.totqtyout)>
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<td width="5%"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></div></td>
					<cfif isdefined("form.includeCategory") and form.includeCategory eq "yes">
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.category#</font></div></td>
					</cfif>
					<td width="5%"><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.unit#</font></div></td>
                    
            <cfswitch expression="#getgeneral.cost#">
			<cfcase value="FIXED">
				<cfset unicost = val(getitem.ucost)  >
			</cfcase>
			<cfcase value="MONTH,MOVING" delimiters=",">
				<cfset unicost = val(getitem.unitcost) >
			</cfcase>

		</cfswitch>
					<cfif maxcounter eq "12">
						<cfif getitem.balqty12 GT 0>
							<cfset thisbalqty = getitem.balqty12 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal12 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal12 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty12 + thisbalqty>
							<cfset thisbal12 = 0>
						</cfif>
						<cfif getitem.balqty11 GT 0>
							<cfset thisbalqty = getitem.balqty11 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal11 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal11 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty11 + thisbalqty>
							<cfset thisbal11 = 0>
						</cfif>
						<cfif getitem.balqty10 GT 0>
							<cfset thisbalqty = getitem.balqty10 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal10 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal10 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty10 + thisbalqty>
							<cfset thisbal10 = 0>
						</cfif>
						<cfif getitem.balqty9 GT 0>
							<cfset thisbalqty = getitem.balqty9 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal9 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal9 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty9 + thisbalqty>
							<cfset thisbal9 = 0>
						</cfif>
						<cfif getitem.balqty8 GT 0>
							<cfset thisbalqty = getitem.balqty8 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal8 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal8 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty8 + thisbalqty>
							<cfset thisbal8 = 0>
						</cfif>
						<cfif getitem.balqty7 GT 0>
							<cfset thisbalqty = getitem.balqty7 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal7 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal7 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty7 + thisbalqty>
							<cfset thisbal7 = 0>
						</cfif>
					</cfif>
					<cfif getitem.balqty6 GT 0>
						<cfset thisbalqty = getitem.balqty6 + thisbalqty>
                        
						<cfif thisbalqty GTE 0>
							<cfset thisbal6 = thisbalqty>
							<cfset thisbalqty = 0>
                            
						<cfelse>
							<cfset thisbal6 = 0>
                          
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty6 + thisbalqty>
						<cfset thisbal6 = 0>
					</cfif>
					<cfif getitem.balqty5 GT 0>
						<cfset thisbalqty = getitem.balqty5 + thisbalqty>
                        
						<cfif thisbalqty GTE 0>
							<cfset thisbal5 = thisbalqty>
							<cfset thisbalqty = 0>
                          
						<cfelse>
							<cfset thisbal5 = 0>
                             
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty5 + thisbalqty>
						<cfset thisbal5 = 0>
                       
					</cfif>
					<cfif getitem.balqty4 GT 0>
						<cfset thisbalqty = getitem.balqty4 + thisbalqty>
                       
						<cfif thisbalqty GTE 0>
							<cfset thisbal4 = thisbalqty>
							<cfset thisbalqty = 0>
                            
						<cfelse>
							<cfset thisbal4 = 0>
                          
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty4 + thisbalqty>
						<cfset thisbal4 = 0>
                        
					</cfif>
                    
					<cfif getitem.balqty3 GT 0>
						<cfset thisbalqty = getitem.balqty3 + thisbalqty>
                        
						<cfif thisbalqty GTE 0>
							<cfset thisbal3 = thisbalqty>
							<cfset thisbalqty = 0>
                            
						<cfelse>
							<cfset thisbal3 = 0> 
							
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty3 + thisbalqty>
						<cfset thisbal3 = 0>
                        
					</cfif>
                    
					<cfif getitem.balqty2 GT 0>
						<cfset thisbalqty = getitem.balqty2 + thisbalqty>
                        
						<cfif thisbalqty GTE 0>
							<cfset thisbal2 = thisbalqty>
							<cfset thisbalqty = 0>
                             
						<cfelse>
							<cfset thisbal2 = 0>
                             
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty2 + thisbalqty>
						<cfset thisbal2 = 0>
                        
					</cfif>
					<cfif getitem.balqty1 GT 0>
						<cfset thisbalqty = getitem.balqty1 + thisbalqty>
                      
						<cfif thisbalqty GTE 0>
							<cfset thisbal1 = thisbalqty>
							<cfset thisbalqty = 0>
                             
						<cfelse>
							<cfset thisbal1 = 0>
                             
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty1 + thisbalqty>
						<cfset thisbal1 = 0>
                       
					</cfif>
					<cfif getitem.balqty0 GT 0>
						<cfset thisbalqty = getitem.balqty0 + thisbalqty>
                       
						<cfif thisbalqty GTE 0>
							<cfset thisbal0 = thisbalqty>
							<cfset thisbalqty = 0>
                            
						<cfelse>
							<cfset thisbal0 = 0>
                           
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty0 + thisbalqty>
						<cfset thisbal0 = 0>
                        
					</cfif>
					<cfif thisbalqty LT 0>
						<cfif maxcounter eq "12">
							<cfset thisbal12 = thisbalqty>
						<cfelse>
							<cfset thisbal6 = thisbalqty>
						</cfif>
					</cfif>
                    <cfif lcase(hcomid) eq "mhca_i">
					<cfif maxcounter eq "12">
						<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal12#</font></div></td> 
						<cfset stkbalance12 = thisbal12 * unicost>
						<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance12),stDecl_UPrice)#</font></div></td>
						<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal11#</font></div></td>
                         <cfset stkbalance11 = thisbal11 * unicost>
						<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance11),stDecl_UPrice)#</font></div></td>
						<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal10#</font></div></td>
                         <cfset stkbalance10 = thisbal10 * unicost>
						<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance10),stDecl_UPrice)#</font></div></td>
						<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal9#</font></div></td>
                         <cfset stkbalance9 = thisbal9 * unicost>
						<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance9),stDecl_UPrice)#</font></div></td>
						<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal8#</font></div></td>
                         <cfset stkbalance8 = thisbal8 * unicost>
						<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance8),stDecl_UPrice)#</font></div></td>
						<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal7#</font></div></td>
                         <cfset stkbalance7 = thisbal7 * unicost>
						<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance7),stDecl_UPrice)#</font></div></td>
					</cfif>
					<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal6#</font></div></td>
                    <cfset stkbalance6 = thisbal6 * unicost>
					<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance6),stDecl_UPrice)#</font></div></td>
					<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal5#</font></div></td><cfset stkbalance5 = #thisbal5# * unicost>
					<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance5),stDecl_UPrice)#</font></div></td>
					<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal4#</font></div></td><cfset stkbalance4 = #thisbal4# * unicost>
					<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance4),stDecl_UPrice)#</font></div></td>
					<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal3#</font></div></td><cfset stkbalance3 = #thisbal3# * unicost>
					<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance3),stDecl_UPrice)#</font></div></td>
					<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal2#</font></div></td><cfset stkbalance2 = #thisbal2# * unicost>
					<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance2),stDecl_UPrice)#</font></div></td>
					<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal1#</font></div></td><cfset stkbalance1 = #thisbal1# * unicost>
					<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance1),stDecl_UPrice)#</font></div></td>
					<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal0#</font></div></td><cfset stkbalance0 = #thisbal0# * unicost>
					<td width="7%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(val(stkbalance0),stDecl_UPrice)#</font></div></td>
					<td width="3%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.qbalance#</font></div></td>
				</tr>
                <cfelse>
                	<cfif maxcounter eq "12">
						<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal12#</font></div></td>
						<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal11#</font></div></td>
				
						<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal10#</font></div></td>
						<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal9#</font></div></td>
						<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal8#</font></div></td>
						<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal7#</font></div></td>
					</cfif>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal6#</font></div></td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal5#</font></div></td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal4#</font></div></td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal3#</font></div></td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal2#</font></div></td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal1#</font></div></td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal0#</font></div></td>
					<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.qbalance#</font></div></td>
				</tr>
                
                </cfif>
			</cfloop>
			
			<tr><td><br/></td></tr>
			
			<cfquery name="drop" datasource="#dts#">
				drop table temp_item
			</cfquery>
		</cfloop>
		</cfoutput>
	</table>
        
<cfelseif getgeneral.cost eq "FIFO">
	<table width="100%" border="0" align="center" cellspacing="0">
		<!--- ADD ON 030608, FOR THE 12 COLUMN VIEW OR 6 COLUMN VIEW --->
		<cfif form.view eq "view12">
			<cfset maxcounter = 12>
		<cfelse>
			<cfset maxcounter = 6>
		</cfif>
		<cfoutput>
		<tr>
			<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Stock Aging Report</strong></font></div></td>
            
		</tr>
        <tr>
        <td colspan="100%"><div align="center"><font face="Times New Roman, Times, serif">Calculated by <cfoutput>#costingmethod#</cfoutput></font></div></td>
        </tr>
		<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">CATE: #form.catefrom# - #form.cateto#</font></div></td>
			</tr>
		</cfif>
		<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">GROUP: #form.groupfrom# - #form.groupto#</font></div></td>
			</tr>
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">ITEM.NO. #form.itemfrom# - #form.itemto#</font></div></td>
			</tr>
		</cfif>
		<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">SUPP.NO.: #form.suppfrom# - #form.suppto#</font></div></td>
			</tr>
		</cfif>
		<cfif form.periodto neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD TO: #form.periodto#</font></div></td>
			</tr>
		</cfif>
		<tr>
			<td colspan="2"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
			<cfif maxcounter eq "12"><td colspan="26"><cfelse><td colspan="14"></td></cfif>
			<td colspan="1"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
		</tr>
		</cfoutput>
		<tr>
			<td colspan="100%"><hr/></td>
		</tr>
		<tr>
			<td colspan="2"><div align="left"><font size="2" face="Times New Roman, Times, serif">ITEM</font></div></td>
			<cfif isdefined("form.includeCategory") and form.includeCategory eq "yes">
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"></font></div></td>
			</cfif>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">UNIT</font></div></td>
			  
			  
			 <cfif maxcounter eq "12">
				<cfif lcase(hcomid) eq "mhca_i"><td colspan="26"><cfelse><td colspan="13"></cfif>
			<cfelse>
				<cfif lcase(hcomid) eq "mhca_i"><td colspan="14"><cfelse><td colspan="7"></cfif>
			</cfif>
			
				<div align="center"><font size="2" face="Times New Roman, Times, serif">
				<--------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MONTH&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------->
				</font></div>
                Qty
			</td>
		
       </tr>
		<tr>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">NO.</font></div></td>
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DESCRIPTION</font></div></td>
			<cfif isdefined("form.includeCategory") and form.includeCategory eq "yes">
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CATEGORY</font></div></td>
			</cfif>
			
			<td><div align="left"><font size="2" face="Times New Roman, Times, serif">MEASURE</font></div></td>
			<cfif maxcounter eq "12">
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">12</font></div></td>
				<td>&nbsp;</td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">11</font></div></td>
				<td>&nbsp;</td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">10</font></div></td>
				<td>&nbsp;</td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">9</font></div></td>
				<td>&nbsp;</td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">8</font></div></td>
				<td>&nbsp;</td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">7</font></div></td>
                 <td>&nbsp;</td>
			</cfif>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">6</font></div></td>
            <td>&nbsp;</td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">5</font></div></td>
            <td>&nbsp;</td>
			<td><div align="right"><font size="2" face="Times New Roman, Times, serif">4</font></div></td>
			<td>&nbsp;</td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">3</font></div></td>
			<td>&nbsp;</td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">2</font></div></td>
			<td>&nbsp;</td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">1</font></div></td>
			<td>&nbsp;</td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">0</font></div></td>
			<td>&nbsp;</td>
            <td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY ON HAND</font></div></td>
		</tr>
		<tr>
			<td colspan="100%"><hr/></td>
		</tr>
	
		<cfoutput>
		<cfloop query="getgroup">
			<tr>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong><u>GROUP: #getgroup.wos_group#</u></strong></font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong><u>#getgroup.desp#</u></strong></font></div></td>
	
			</tr>
			<!--- REPLACE THE PREVIOUS QUERY ON 280508 --->
			<cfquery name="create" datasource="#dts#">
				create table temp_item as
				select a.itemno, a.desp, a.category, a.unit,(a.qtybf<cfloop index="a" from="11" to="#startperiod#">+a.qin#a#-a.qout#a#</cfloop>) as qbalance
				from icitem a
				where a.itemno <>'' and wos_group='#getgroup.wos_group#'
				<cfif isdefined("form.include0") and form.include0 eq "yes">
				<cfelse>
					and (a.qtybf<cfloop index="a" from="11" to="#startperiod#">+a.qin#a#-a.qout#a#</cfloop>) > 0
				</cfif>
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
					and a.category between '#form.catefrom#' and '#form.cateto#'
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
					and a.wos_group between '#form.groupfrom#' and '#form.groupto#'
				</cfif>
				<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
					and a.itemno between '#form.itemfrom#' and '#form.itemto#'
				</cfif>
				<cfif trim(form.suppfrom) neq "" and trim(form.suppto) neq "">
					and a.supp between '#form.suppfrom#' and '#form.suppto#'
				</cfif>
			</cfquery>
			<cfquery name="alter" datasource="#dts#">
				alter table temp_item add column totqtyout double(17,7) default 0, add column balqty0 double(17,7) default 0,
				add column balqty1 double(17,7) default 0, add column balqty2 double(17,7) default 0, add column balqty3 double(17,7) default 0,
				add column balqty4 double(17,7) default 0, add column balqty5 double(17,7) default 0, add column balqty6 double(17,7) default 0,
				add column balqty7 double(17,7) default 0, add column balqty8 double(17,7) default 0, add column balqty9 double(17,7) default 0,
				add column balqty10 double(17,7) default 0, add column balqty11 double(17,7) default 0, add column balqty12 double(17,7) default 0
			</cfquery>
			
			<cfquery name="update" datasource="#dts#">
				update temp_item t,icitem i
				set totqtyout = <cfloop index="a" from="11" to="#startperiod#">+i.qout#a#</cfloop>,
				balqty#maxcounter# = i.qtybf
				where t.itemno = i.itemno
			</cfquery>

				<cfset counter = 0>
			
				<cfloop from="#startperiod#" to="11" index="a" step="-1">
					<cfif counter LT maxcounter>
						<cfquery name="update" datasource="#dts#">
							update temp_item t,icitem i
							set balqty#counter# = i.qin#a#
							where t.itemno = i.itemno
						</cfquery>
					<cfelse>
						<cfquery name="update" datasource="#dts#">
							update temp_item t,icitem i
							set balqty#maxcounter# = balqty#maxcounter# + i.qin#a#
							where t.itemno = i.itemno
						</cfquery>
					</cfif>
					<cfset counter = counter + 1>
				</cfloop>
			<!---/cfif--->
			
			<cfquery name="getitem" datasource="#dts#">
				select * from temp_item t
			</cfquery>
			
			<cfloop query="getitem">
            
         
				<cfset thisbalqty = -(getitem.totqtyout)>
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></div></td>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></div></td>
					<cfif isdefined("form.includeCategory") and form.includeCategory eq "yes">
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.category#</font></div></td>
					</cfif>
					<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.unit#</font></div></td>
					<cfif maxcounter eq "12">
						<cfif getitem.balqty12 GT 0>
							<cfset thisbalqty = getitem.balqty12 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal12 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal12 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty12 + thisbalqty>
							<cfset thisbal12 = 0>
						</cfif>
						<cfif getitem.balqty11 GT 0>
							<cfset thisbalqty = getitem.balqty11 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal11 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal11 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty11 + thisbalqty>
							<cfset thisbal11 = 0>
						</cfif>
						<cfif getitem.balqty10 GT 0>
							<cfset thisbalqty = getitem.balqty10 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal10 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal10 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty10 + thisbalqty>
							<cfset thisbal10 = 0>
						</cfif>
						<cfif getitem.balqty9 GT 0>
							<cfset thisbalqty = getitem.balqty9 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal9 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal9 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty9 + thisbalqty>
							<cfset thisbal9 = 0>
						</cfif>
						<cfif getitem.balqty8 GT 0>
							<cfset thisbalqty = getitem.balqty8 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal8 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal8 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty8 + thisbalqty>
							<cfset thisbal8 = 0>
						</cfif>
						<cfif getitem.balqty7 GT 0>
							<cfset thisbalqty = getitem.balqty7 + thisbalqty>
							<cfif thisbalqty GTE 0>
								<cfset thisbal7 = thisbalqty>
								<cfset thisbalqty = 0>
							<cfelse>
								<cfset thisbal7 = 0>
							</cfif>
						<cfelse>
							<cfset thisbalqty = getitem.balqty7 + thisbalqty>
							<cfset thisbal7 = 0>
						</cfif>
					</cfif>
					<cfif getitem.balqty6 GT 0>
						<cfset thisbalqty = getitem.balqty6 + thisbalqty>
						<cfif thisbalqty GTE 0>
							<cfset thisbal6 = thisbalqty>
							<cfset thisbalqty = 0>
						<cfelse>
							<cfset thisbal6 = 0>
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty6 + thisbalqty>
						<cfset thisbal6 = 0>
					</cfif>
					<cfif getitem.balqty5 GT 0>
						<cfset thisbalqty = getitem.balqty5 + thisbalqty>
						<cfif thisbalqty GTE 0>
							<cfset thisbal5 = thisbalqty>
							<cfset thisbalqty = 0>
						<cfelse>
							<cfset thisbal5 = 0>
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty5 + thisbalqty>
						<cfset thisbal5 = 0>
					</cfif>
					<cfif getitem.balqty4 GT 0>
						<cfset thisbalqty = getitem.balqty4 + thisbalqty>
						<cfif thisbalqty GTE 0>
							<cfset thisbal4 = thisbalqty>
							<cfset thisbalqty = 0>
						<cfelse>
							<cfset thisbal4 = 0>
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty4 + thisbalqty>
						<cfset thisbal4 = 0>
					</cfif>
					<cfif getitem.balqty3 GT 0>
						<cfset thisbalqty = getitem.balqty3 + thisbalqty>
						<cfif thisbalqty GTE 0>
							<cfset thisbal3 = thisbalqty>
							<cfset thisbalqty = 0>
						<cfelse>
							<cfset thisbal3 = 0>
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty3 + thisbalqty>
						<cfset thisbal3 = 0>
					</cfif>
					<cfif getitem.balqty2 GT 0>
						<cfset thisbalqty = getitem.balqty2 + thisbalqty>
						<cfif thisbalqty GTE 0>
							<cfset thisbal2 = thisbalqty>
							<cfset thisbalqty = 0>
						<cfelse>
							<cfset thisbal2 = 0>
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty2 + thisbalqty>
						<cfset thisbal2 = 0>
					</cfif>
					<cfif getitem.balqty1 GT 0>
						<cfset thisbalqty = getitem.balqty1 + thisbalqty>
						<cfif thisbalqty GTE 0>
							<cfset thisbal1 = thisbalqty>
							<cfset thisbalqty = 0>
						<cfelse>
							<cfset thisbal1 = 0>
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty1 + thisbalqty>
						<cfset thisbal1 = 0>
					</cfif>
					<cfif getitem.balqty0 GT 0>
						<cfset thisbalqty = getitem.balqty0 + thisbalqty>
						<cfif thisbalqty GTE 0>
							<cfset thisbal0 = thisbalqty>
							<cfset thisbalqty = 0>
						<cfelse>
							<cfset thisbal0 = 0>
						</cfif>
					<cfelse>
						<cfset thisbalqty = getitem.balqty0 + thisbalqty>
						<cfset thisbal0 = 0>
					</cfif>
					<cfif thisbalqty LT 0>
						<cfif maxcounter eq "12">
							<cfset thisbal12 = thisbalqty>
						<cfelse>
							<cfset thisbal6 = thisbalqty>
						</cfif>
					</cfif>
					<cfif maxcounter eq "12">
						<td width="5%">#form.periodto#<div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal12#</font></div></td>
                        <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-12" itemno="#getitem.itemno#" itemqty="#thisbal12#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
						<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal11#</font></div></td>
                        <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-11" itemno="#getitem.itemno#" itemqty="#thisbal11#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
						<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal10#</font></div></td>
                        <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-10" itemno="#getitem.itemno#" itemqty="#thisbal10#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
						<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal9#</font></div></td>
                        <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-9" itemno="#getitem.itemno#" itemqty="#thisbal9#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
						<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal8#</font></div></td>
                        <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-8" itemno="#getitem.itemno#" itemqty="#thisbal8#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
						<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal7#</font></div></td>
                        <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-7" itemno="#getitem.itemno#" itemqty="#thisbal7#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
					</cfif>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal6#</font></div></td>
                    <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-6" itemno="#getitem.itemno#" itemqty="#thisbal6#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal5#</font></div></td>
                    <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-5" itemno="#getitem.itemno#" itemqty="#thisbal5#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal4#</font></div></td>
                    <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-4" itemno="#getitem.itemno#" itemqty="#thisbal4#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal3#</font></div></td>
                    <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-3" itemno="#getitem.itemno#" itemqty="#thisbal3#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal2#</font></div></td>
                    <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-2" itemno="#getitem.itemno#" itemqty="#thisbal2#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal1#</font></div></td>
                    <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="-1" itemno="#getitem.itemno#" itemqty="#thisbal1#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#thisbal0#</font></div></td>
                    <td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">
                        <cfinvoke component="CFC.fifoValue" method="fifovalue" dts = "#dts#" period="0" itemno="#getitem.itemno#" itemqty="#thisbal0#" monthp="#form.periodto#" returnvariable="myResult" >
                        #numberformat(myResult,'.__')#</font></div>
                        </td>
					<td width="5%"><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.qbalance#</font></div></td>
				</tr>
			</cfloop>
			
			<tr><td><br/></td></tr>
			
			<cfquery name="drop" datasource="#dts#">
				drop table temp_item
			</cfquery>
		</cfloop>
		</cfoutput>
	</table>
</cfif>
        
	<cfif getgroup.recordcount eq 0>
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
