<cfquery name="getGSetup" datasource="#dts#">
  	select compro,compro2,compro3,compro4,compro5,compro6,compro7,gstno from gsetup 
</cfquery>

<cfif form.datefrom neq "" and form.dateto neq "">
	<cfset date1 = createDate(ListGetAt(form.datefrom,3,"/"),ListGetAt(form.datefrom,2,"/"),ListGetAt(form.datefrom,1,"/"))>
	<cfset date2 = createDate(ListGetAt(form.dateto,3,"/"),ListGetAt(form.dateto,2,"/"),ListGetAt(form.dateto,1,"/"))>
    <cfelse>
    <cfset date1=''>
    <cfset date2=''>
</cfif>

<cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear,filterall from gsetup
</cfquery>

<cfoutput>
<cfset periodfrom = "">
<cfset periodto = "">
<cfset startfrom = val(form.periodfrom)-1>
<cfset periodfrom = #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE(numberformat(startfrom,'00')),DE(form.periodfrom)),getgeneral.lastaccyear),'mmm yyyy')#>
<cfset periodto = #dateformat(dateadd('m',iif(year(dateadd("d",1,getgeneral.lastaccyear)) eq year(getgeneral.lastaccyear) and month(dateadd("d",1,getgeneral.lastaccyear)) eq month(getgeneral.lastaccyear),DE(numberformat(startfrom,'00')),DE(form.periodto)),getgeneral.lastaccyear),'mmm yyyy')#>




</cfoutput>


<cfswitch expression="#form.result#">
	<cfcase value="PDF">
    
    <cfquery name="MyQuery" datasource="#dts#">
 SELECT * FROM (
select itemno,a.desp,a.brem1,a.brem2,a.amt,price,grand,tax,discount,taxp1,a.wos_date,a.refno,qty,a.custno,c.name,c.name2,c.add1,add2,add3,add4,phone,c.term,(qty*factor1/factor2) as qty2 from ictran as a left join artran as b on a.refno = b.refno left join #target_arcust# as c on a.custno=c.custno where a.type = "INV" and (a.void = "" or a.void is null) and a.fperiod between '#form.periodfrom#' and '#form.periodto#' 

<cfif form.datefrom neq "" and form.dateto neq "">
		and a.wos_date between #date1# and #date2#
	<cfelse>
		and a.wos_date > #getgeneral.lastaccyear#
	</cfif>
    <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
		and a.custno between '#form.custfrom#' and '#form.custto#'
	</cfif>
    <cfif trim(form.agentfrom) neq "" and trim(form.agentto) neq "">
		and b.agenno between '#form.agentfrom#' and '#form.agentto#'
	</cfif>
    <cfif form.teamfrom neq "" and form.teamto neq "">
				and b.agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
    <cfif trim(form.areafrom) neq "" and trim(form.areato) neq "">
		and b.area between '#form.areafrom#' and '#form.areato#'
	</cfif>
    
    <cfif trim(form.termfrom) neq "" and trim(form.termto) neq "">
    <cfif isdefined("form.checkbox2")>
    and a.custno in (select custno from #target_arcust# where term between '#form.termfrom#' and '#form.termto#')
    <cfelse>
		and b.term between '#form.termfrom#' and '#form.termto#'
        </cfif>
	</cfif>
    

) as aa  
LEFT JOIN
(select sum(grand) as totalgrand,refno,custno from artran where 

type = "INV" and (void = "" or void is null) and fperiod between '#form.periodfrom#' and '#form.periodto#'
<cfif form.datefrom neq "" and form.dateto neq "">
		and wos_date between #date1# and #date2#
	<cfelse>
		and wos_date > #getgeneral.lastaccyear#
	</cfif>
    <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
		and custno between '#form.custfrom#' and '#form.custto#'
	</cfif>
      <cfif trim(form.agentfrom) neq "" and trim(form.agentto) neq "">
		and agenno between '#form.agentfrom#' and '#form.agentto#'
	</cfif>
    <cfif form.teamfrom neq "" and form.teamto neq "">
				and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
				</cfif>
    <cfif trim(form.areafrom) neq "" and trim(form.areato) neq "">
		and area between '#form.areafrom#' and '#form.areato#'
	</cfif>
    <cfif trim(form.termfrom) neq "" and trim(form.termto) neq "">
    <cfif isdefined("form.checkbox2")>
    and custno in (select custno from #target_arcust# where term between '#form.termfrom#' and '#form.termto#')
    <cfelse>
		and term between '#form.termfrom#' and '#form.termto#'
        </cfif>
	</cfif>
    group by custno) as bb
on aa.custno = bb.custno
order by aa.custno,aa.wos_date
   
</cfquery>

<cfset reportname = "StatementAccount.cfr">

<cfif lcase(HcomID) eq "hfi_i">

<cfif isdefined("form.checkbox")>
<cfset reportname = "HFIStatementAccount.cfr">
<cfelse>
<cfset reportname = "HFIStatementAccount1.cfr">
</cfif>

</cfif>

<cfreport template="#reportname#" format="PDF" query="MyQuery" report="StatementAccount.cfr"><!--- or "FlashPaper" or "Excel" or "RTF" --->
	<cfreportparam name="compro" value="#getGSetup.compro#">
	<cfreportparam name="compro2" value="#getGSetup.compro2#">
	<cfreportparam name="compro3" value="#getGSetup.compro3#">
	<cfreportparam name="compro4" value="#getGSetup.compro4#">
	<cfreportparam name="compro5" value="#getGSetup.compro5#">
	<cfreportparam name="compro6" value="#getGSetup.compro6#">
	<cfreportparam name="compro7" value="#getGSetup.compro7#">
    <cfreportparam name="periodfrom" value="#periodfrom#">
    <cfreportparam name="periodto" value="#periodto#">
    <cfreportparam name="datefrom" value="#date1#">
    <cfreportparam name="dateto" value="#date2#">
    <cfreportparam name="dts" value="#dts#">
    <cfreportparam name="custfrom" value="#form.custfrom#">
    <cfreportparam name="custto" value="#form.custto#">
    <cfreportparam name="gstno" value="#getGSetup.gstno#">
    
</cfreport>
</cfcase>

	<cfcase value="EXCELDEFAULT">
	
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
			
			<Worksheet ss:Name="Bills Listing">
				<Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="11.25">
					<Column ss:Width="64.5"/>
					<Column ss:Width="60.25"/>
                    <Column ss:AutoFitWidth="0" ss:Width="183.75"/>
					<Column ss:Width="60.75"/>
					<Column ss:Width="27.75"/>
					<Column ss:Width="47.25"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<cfset c="9">
						<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
						<cfset c=c+1>
					<cfquery name="getcustomer" datasource="#dts#">
                    select custno from artran where fperiod between '#form.periodfrom#' and '#form.periodto#' 
                    <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
                            and custno between '#form.custfrom#' and '#form.custto#'
                        </cfif>
                        <cfif form.datefrom neq "" and form.dateto neq "">
                            and wos_date between #date1# and #date2#
                        <cfelse>
                            and wos_date > #getgeneral.lastaccyear#
                        </cfif>
                        group by custno
                    </cfquery>
		   			
                    <cfloop query="getcustomer">
                    <cfquery name="MyQuery" datasource="#dts#">
                     SELECT * FROM (
                    select itemno,a.desp,a.brem1,a.brem2,a.amt,price,grand,tax,discount,taxp1,a.wos_date,a.refno,qty,a.custno,c.name,c.name2,c.add1,add2,add3,add4,phone,c.term,(qty*factor1/factor2) as qty2 from ictran as a left join artran as b on a.refno = b.refno left join #target_arcust# as c on a.custno=c.custno where a.type = "INV" and (a.void = "" or a.void is null) and a.fperiod between '#form.periodfrom#' and '#form.periodto#' 
                    
                    <cfif form.datefrom neq "" and form.dateto neq "">
                            and a.wos_date between #date1# and #date2#
                        <cfelse>
                            and a.wos_date > #getgeneral.lastaccyear#
                        </cfif>

                            and a.custno = '#getcustomer.custno#'

                        <cfif trim(form.agentfrom) neq "" and trim(form.agentto) neq "">
                            and b.agenno between '#form.agentfrom#' and '#form.agentto#'
                        </cfif>
                        <cfif form.teamfrom neq "" and form.teamto neq "">
                                    and b.agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
                                    </cfif>
                        <cfif trim(form.areafrom) neq "" and trim(form.areato) neq "">
                            and b.area between '#form.areafrom#' and '#form.areato#'
                        </cfif>
                        
                        <cfif trim(form.termfrom) neq "" and trim(form.termto) neq "">
                        <cfif isdefined("form.checkbox2")>
                        and a.custno in (select custno from #target_arcust# where term between '#form.termfrom#' and '#form.termto#')
                        <cfelse>
                            and b.term between '#form.termfrom#' and '#form.termto#'
                            </cfif>
                        </cfif>
                        
                    
                    ) as aa  
                    LEFT JOIN
                    (select sum(grand) as totalgrand,refno,custno from artran where 
                    
                    type = "INV" and (void = "" or void is null) and fperiod between '#form.periodfrom#' and '#form.periodto#'
                    <cfif form.datefrom neq "" and form.dateto neq "">
                            and wos_date between #date1# and #date2#
                        <cfelse>
                            and wos_date > #getgeneral.lastaccyear#
                        </cfif>

                            and custno = '#getcustomer.custno#'

                          <cfif trim(form.agentfrom) neq "" and trim(form.agentto) neq "">
                            and agenno between '#form.agentfrom#' and '#form.agentto#'
                        </cfif>
                        <cfif form.teamfrom neq "" and form.teamto neq "">
                                    and agenno in(select agent from icagent where team >= '#form.teamfrom#' and team <= '#form.teamto#')
                                    </cfif>
                        <cfif trim(form.areafrom) neq "" and trim(form.areato) neq "">
                            and area between '#form.areafrom#' and '#form.areato#'
                        </cfif>
                        <cfif trim(form.termfrom) neq "" and trim(form.termto) neq "">
                        <cfif isdefined("form.checkbox2")>
                        and custno in (select custno from #target_arcust# where term between '#form.termfrom#' and '#form.termto#')
                        <cfelse>
                            and term between '#form.termfrom#' and '#form.termto#'
                            </cfif>
                        </cfif>
                        group by custno) as bb
                    on aa.custno = bb.custno
                    order by aa.custno,aa.wos_date
                       
                    </cfquery>
                    
                    <cfoutput>
					<cfwddx action = "cfml2wddx" input = "#getGSetup.compro#" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="#c#" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
					</Row>
                    
                    <cfwddx action = "cfml2wddx" input = "#getGSetup.compro2# #getGSetup.compro3#" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="#c#" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
					</Row>
                    
                     <cfwddx action = "cfml2wddx" input = "#getGSetup.compro4# #getGSetup.compro5#" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="#c#" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
					</Row>
                    
                     <cfwddx action = "cfml2wddx" input = "Business Registration & GST No :  #getGSetup.gstno#" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="#c#" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
					</Row>
			
					
						<cfwddx action = "cfml2wddx" input = "Customer Name : #MyQuery.name# #MyQuery.name2#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="4" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
                            <Cell ss:MergeAcross="3" ss:StyleID="s24"><Data ss:Type="String">Statement Of Account</Data></Cell>
						</Row>
                        <cfwddx action = "cfml2wddx" input = "#MyQuery.add1# #MyQuery.add2#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="4" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
                            <Cell ss:MergeAcross="3" ss:StyleID="s24"><Data ss:Type="String">Date :</Data></Cell>
						</Row>
                        <cfwddx action = "cfml2wddx" input = "#MyQuery.add3# #MyQuery.add4#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="4" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
                            <Cell ss:MergeAcross="3" ss:StyleID="s24"><Data ss:Type="String"></Data></Cell>
						</Row>
                        <cfwddx action = "cfml2wddx" input = "Tel : #MyQuery.phone#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="4" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
                            <Cell ss:MergeAcross="3" ss:StyleID="s24"><Data ss:Type="String"></Data></Cell>
						</Row>
                        
                        <cfwddx action = "cfml2wddx" input = "#MyQuery.custno#" output = "wddxText">
                        <cfwddx action = "cfml2wddx" input = "Term :  #MyQuery.term#" output = "wddxText2">
                        <cfwddx action = "cfml2wddx" input = "Month :  #form.periodfrom# To #form.periodto#" output = "wddxText3">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="2" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
                            <Cell ss:MergeAcross="2" ss:StyleID="s24"><Data ss:Type="String">#wddxText2#</Data></Cell>
                            <Cell ss:MergeAcross="3" ss:StyleID="s24"><Data ss:Type="String">#wddxText3#</Data></Cell>
						</Row>
				</cfoutput>
		
				<Row ss:AutoFitHeight="0" ss:Height="23.0625">
					<Cell ss:StyleID="s27"><Data ss:Type="String">Delivery Date</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Invoice No</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Item Description</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Packing</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Qty/Kg</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">2nd Unit</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">Unit Price</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">GST @ 7%</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Total Sales</Data></Cell>
					
				</Row>
				   
				
					
					<cfloop query="Myquery">
					<cfoutput>
					<cfwddx action = "cfml2wddx" input = "#dateformat(wos_date,'DD/MM/YYYY')#" output = "wddxText">
					<cfwddx action = "cfml2wddx" input = "#refno#" output = "wddxText2">
					<cfwddx action = "cfml2wddx" input = "#desp#" output = "wddxText3">
                    <cfwddx action = "cfml2wddx" input = "#brem1# #brem2#" output = "wddxText4">
                    
					<Row ss:AutoFitHeight="0">
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText2#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText3#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText4#</Data></Cell>
						
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#qty#</Data></Cell>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#qty2#</Data></Cell>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#price#</Data></Cell>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#tax#</Data></Cell>
                        <cfset amt1=amt*1.07>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#amt1#</Data></Cell>
	
					
					</Row>
                    </cfoutput>
				</cfloop>
				
		
				<Row ss:AutoFitHeight="0" ss:Height="12"/>
				
				<cfoutput>
				<Row ss:AutoFitHeight="0" ss:Height="12">
					<Cell ss:StyleID="s38" ss:MergeAcross="7"><Data ss:Type="String">TOTAL AMOUNT DUE SGD :</Data></Cell>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#myquery.totalgrand#</Data></Cell>
					
				</Row>
				</cfoutput>
				</cfloop>
                
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
    
</cfswitch>