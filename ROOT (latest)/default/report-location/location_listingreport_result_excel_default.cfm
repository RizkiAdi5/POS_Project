<cfquery name="getgeneral" datasource="#dts#">
	select 
	compro,
	lastaccyear,
    singlelocation
	from gsetup;
</cfquery>

<cfquery name="getgsetup2" datasource="#dts#">
	select 
	repeat('0',decl_uprice) as decl_uprice
	from gsetup2;
</cfquery>

<cfset stDecl_UPrice = getgsetup2.Decl_UPrice>

<cfquery name="getlocation" datasource="#dts#">
	select 
	a.location,
	(select desp from iclocation where location=a.location) as desp
	from ictran as a,icitem as b 
	where a.type in 
	<cfif form.type eq "1">
	('INV','CS','DN','CN') 
	<cfelse>
	('RC','PR') 
	</cfif>
	and a.itemno=b.itemno
	and (a.void = '' or a.void is null) 
	<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
	and b.itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
	</cfif>
	<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
	and b.category between <cfqueryparam cfsqltype="cf_sql_char" value="#form.catefrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.cateto#">
	</cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
	and b.wos_group between <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupto#">
	</cfif>
     <cfif getgeneral.singlelocation eq 'Y'>
     <cfif form.locfrom neq "">
	and a.location =<cfqueryparam cfsqltype="cf_sql_char" value="#form.locfrom#">
	</cfif>
     <cfelse>
	<cfif form.locfrom neq "" and form.locto neq "">
	and a.location between <cfqueryparam cfsqltype="cf_sql_char" value="#form.locfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.locto#">
	</cfif>
    </cfif>
	<cfif form.agentfrom neq "" and form.agentto neq "">
	and a.agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
	</cfif>
	<cfif form.periodfrom neq "" and form.periodto neq "">
	and a.fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
	</cfif>
	<cfif form.datefrom neq "" and form.dateto neq "">
	and a.wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
	<cfelse>
	and a.wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
	</cfif>
	group by a.location 
	order by a.location;
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
	</Styles>
	<Worksheet ss:Name="ITEM-LOCATION SALES REPORT">
	
	<cfoutput>
	<cfif form.type eq "1">
		<Table ss:ExpandedColumnCount="7" x:FullColumns="1" x:FullRows="1">
		<Column ss:AutoFitWidth="0" ss:Width="93.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="80.5" ss:Span="4"/>

		<cfset ttinvamt = 0>
		<cfset ttcnamt = 0>
		<cfset ttdnamt = 0>
		<cfset ttcsamt = 0>
		<cfset ttnetamt = 0>
		
		
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:MergeAcross="6" ss:StyleID="s22"><Data ss:Type="String">ITEM LOCATION #TYPENAME# REPORT</Data></Cell>
		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s26"><Data ss:Type="String">#getgeneral.compro#</Data></Cell>
			<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:StyleID="s27"><Data ss:Type="String">LOCATION</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">DESCRIPTION</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">INV</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">CS</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">DN</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">CN</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">TOTAL</Data></Cell>
		</Row>

		<cfloop query="getlocation">
			<cfset sttinvamt = 0>
			<cfset sttcnamt = 0>
			<cfset sttdnamt = 0>
			<cfset sttcsamt = 0>
			<cfset sttnetamt = 0>

			<cfwddx action = "cfml2wddx" input = "Location: #getlocation.location#" output = "wddxText1">
			<cfwddx action = "cfml2wddx" input = "#getlocation.desp#" output = "wddxText2">

			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:MergeAcross="1" ss:StyleID="s34"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:MergeAcross="4" ss:StyleID="s34"><Data ss:Type="String">#wddxText2#</Data></Cell>
			</Row>

			<cfquery name="getitem" datasource="#dts#">
				select 
				aa.itemno,
				aa.desp,
				b.inv_amt,
				c.cs_amt,
				d.dn_amt,
				e.cn_amt 
					 
				from (ictran as a,icitem as aa)
				
				left join
				(
					select 
					itemno,
					sum(amt) as inv_amt 
					from ictran 
					where type='INV' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as b on a.itemno=b.itemno
				
				left join
				(
					select 
					itemno,
					sum(amt) as cs_amt 
					from ictran 
					where type='CS' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as c on a.itemno=c.itemno
				
				left join
				(
					select 
					itemno,
					sum(amt) as dn_amt 
					from ictran 
					where type='DN' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as d on a.itemno=d.itemno
				
				left join
				(
					select 
					itemno,
					sum(amt) as cn_amt 
					from ictran 
					where type='CN' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as e on a.itemno=e.itemno
				
				where a.type in ('INV','CS','DN','CN') 
				and a.location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
				and a.itemno=aa.itemno
				and (a.void = '' or a.void is null) 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
				</cfif>
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and aa.category between <cfqueryparam cfsqltype="cf_sql_char" value="#form.catefrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.cateto#">
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and aa.wos_group between <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupto#">
				</cfif>
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and a.agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and a.fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and a.wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
				<cfelse>
				and a.wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
				</cfif>
				group by a.itemno 
				order by a.itemno;
			</cfquery>
            
			<cfloop query="getitem">
				<cfset invamt = val(getitem.inv_amt)>
				<cfset csamt = val(getitem.cs_amt)>
				<cfset dnamt = val(getitem.dn_amt)>
				<cfset cnamt = val(getitem.cn_amt)>
				<cfset netamt = invamt + dnamt + csamt - cnamt>

				<cfwddx action = "cfml2wddx" input = "#getitem.currentrow#." output = "wddxText1">
				<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText2">
				<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText3">
				
				<Row ss:AutoFitHeight="0" ss:Height="12">
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
					<Cell ss:MergeAcross="4" ss:StyleID="s28"><Data ss:Type="String">#wddxText3#</Data></Cell>
				</Row>
				
				<Row ss:AutoFitHeight="0" ss:Height="12">
					<Cell ss:StyleID="s28"/>
					<Cell ss:StyleID="s28"/>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#invamt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#csamt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#dnamt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#cnamt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#netamt#</Data></Cell>
				</Row>

				<cfset sttinvamt = sttinvamt + invamt>
				<cfset sttdnamt = sttdnamt + dnamt>
				<cfset sttcnamt = sttcnamt + cnamt>
				<cfset sttcsamt = sttcsamt + csamt>
				<cfset sttnetamt = sttnetamt + netamt>
				<cfset ttinvamt = ttinvamt + invamt>
				<cfset ttdnamt = ttdnamt + dnamt>
				<cfset ttcnamt = ttcnamt + cnamt>
				<cfset ttcsamt = ttcsamt + csamt>
				<cfset ttnetamt = ttnetamt + netamt>
			</cfloop>
			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
			</Row>
			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s30"><Data ss:Type="String">SUB TOTAL:</Data></Cell>
				<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttinvamt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttcsamt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttdnamt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttcnamt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttnetamt#</Data></Cell>
			</Row>
		</cfloop>
		<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
		</Row>
		<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s32"><Data ss:Type="String">TOTAL:</Data></Cell>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttinvamt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttcsamt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttdnamt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttcnamt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttnetamt#</Data></Cell>
		</Row>
	</cfif>

	<cfif form.type eq "2">
		<Table ss:ExpandedColumnCount="6" x:FullColumns="1" x:FullRows="1">
		<Column ss:AutoFitWidth="0" ss:Width="75.5"/>
		<Column ss:AutoFitWidth="0" ss:Width="85.5"/>
		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="80.5" ss:Span="2"/>

		<cfset ttrcamt = 0>
		<cfset ttpramt = 0>
		<cfset ttnetamt = 0>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:MergeAcross="5" ss:StyleID="s22"><Data ss:Type="String">ITEM LOCATION #TYPENAME# REPORT</Data></Cell>
		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<Cell ss:MergeAcross="4" ss:StyleID="s26"><Data ss:Type="String">#getgeneral.compro#</Data></Cell>
			<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:MergeAcross="1" ss:StyleID="s27"><Data ss:Type="String">LOCATION</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">DESCRIPTION</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">RC</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">PR</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">TOTAL</Data></Cell>
		</Row>

		<cfloop query="getlocation">
			<cfset sttrcamt = 0>
			<cfset sttpramt = 0>
			<cfset sttnetamt = 0>

			<cfwddx action = "cfml2wddx" input = "Location: #getlocation.location#" output = "wddxText1">
			<cfwddx action = "cfml2wddx" input = "#getlocation.desp#" output = "wddxText2">

			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:MergeAcross="1" ss:StyleID="s34"><Data ss:Type="String">#wddxText1#</Data></Cell>
				<Cell ss:MergeAcross="3" ss:StyleID="s34"><Data ss:Type="String">#wddxText2#</Data></Cell>
			</Row>

			<cfquery name="getitem" datasource="#dts#">
				select 
				a.itemno,
				aa.desp,
				b.rc_amt,
				c.pr_amt
					 
				from ictran as a,icitem as aa 
				
				left join
				(
					select 
					itemno,
					sum(amt) as rc_amt 
					from ictran 
					where type='RC' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as b on a.itemno=b.itemno
				
				left join
				(
					select 
					itemno,
					sum(amt) as pr_amt 
					from ictran 
					where type='PR' 
					and location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
					and (void = '' or void is null)
					<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
					and itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
					</cfif>
					<cfif form.agentfrom neq "" and form.agentto neq "">
					and agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
					</cfif>
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
					<cfelse>
					and wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
					</cfif>
					group by location,itemno 
					order by location,itemno
				) as c on a.itemno=c.itemno
	
				where a.type in ('RC','PR') 
				and a.location=<cfqueryparam cfsqltype="cf_sql_char" value="#getlocation.location#">
				and a.itemno=aa.itemno
				and (a.void = '' or a.void is null) 
				<cfif trim(form.productfrom) neq "" and trim(form.productto) neq "">
				and a.itemno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.productfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.productto#">
				</cfif>
				<cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
				and aa.category between <cfqueryparam cfsqltype="cf_sql_char" value="#form.catefrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.cateto#">
				</cfif>
				<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
				and aa.wos_group between <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.groupto#">
				</cfif>
				<cfif form.agentfrom neq "" and form.agentto neq "">
				and a.agenno between <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.agentto#">
				</cfif>
				<cfif form.periodfrom neq "" and form.periodto neq "">
				and a.fperiod between <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodfrom#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.periodto#">
				</cfif>
				<cfif form.datefrom neq "" and form.dateto neq "">
				and a.wos_date between <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.datefrom,'yyyy-mm-dd')#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(form.dateto,'yyyy-mm-dd')#">
				<cfelse>
				and a.wos_date > <cfqueryparam cfsqltype="cf_sql_char" value="#lsdateformat(getgeneral.lastaccyear,'yyyy-mm-dd')#">
				</cfif>
				group by a.itemno 
				order by a.itemno;
			</cfquery>

			<cfloop query="getitem">
				<cfset rcamt = val(getitem.rc_amt)>
				<cfset pramt = val(getitem.pr_amt)>
				<cfset netamt = rcamt - pramt>

				<cfwddx action = "cfml2wddx" input = "#getitem.currentrow#." output = "wddxText1">
				<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText2">
				<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText3">

				<Row ss:AutoFitHeight="0" ss:Height="12">
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText1#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText2#</Data></Cell>
					<Cell ss:StyleID="s28"><Data ss:Type="String">#wddxText3#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#rcamt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#pramt#</Data></Cell>
					<Cell ss:StyleID="s29"><Data ss:Type="Number">#netamt#</Data></Cell>
				</Row>

				<cfset sttrcamt = sttrcamt + rcamt>
				<cfset sttpramt = sttpramt + pramt>
				<cfset sttnetamt = sttnetamt + netamt>
				<cfset ttrcamt = ttrcamt + rcamt>
				<cfset ttpramt = ttpramt + pramt>
				<cfset ttnetamt = ttnetamt + netamt>
			</cfloop>
			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
				<Cell ss:StyleID="s32"/>
			</Row>
			<Row ss:AutoFitHeight="0" ss:Height="12">
				<Cell ss:StyleID="s30"><Data ss:Type="String">SUB TOTAL:</Data></Cell>
				<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s30"/>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttrcamt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttpramt#</Data></Cell>
				<Cell ss:StyleID="s31"><Data ss:Type="Number">#sttnetamt#</Data></Cell>
			</Row>
		</cfloop>
		<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
		</Row>
		<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s32"><Data ss:Type="String">TOTAL:</Data></Cell>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s32"/>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttrcamt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttpramt#</Data></Cell>
			<Cell ss:StyleID="s33"><Data ss:Type="Number">#ttnetamt#</Data></Cell>
		</Row>
	</cfif>
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

<cfif form.type eq "1">
	<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\LocationR_ILS_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\LocationR_ILS_#huserid#.xls">
<cfelse>
	<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\LocationR_ILP_#huserid#.xls" output="#tostring(data)#">
	<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\LocationR_ILP_#huserid#.xls">
</cfif>