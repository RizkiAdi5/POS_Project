<cfswitch expression="#form.result#">
<cfcase value="HTML">
<html>
<head>
<title>Promotion Item Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfparam name="i" default="1" type="numeric">

<cfset newdate = createdate('#form.year1#','#form.month1#','#form.day1#') >
<cfset newdate2 = createdate('#form.year2#','#form.month2#','#form.day2#') >

<cfset newdate3 = dateformat(newdate,'YYYY-MM-DD') >
<cfset newdate4 = dateformat(newdate2,'YYYY-MM-DD')>

<cfquery name="getpromotion" datasource="#dts#">
  select a.itemno,a.desp,b.* from promoitem as a
  left join
  (
  select * from promotion) as b on a.promoid=b.promoid
  where 0=0
    <cfif form.pricedistype neq "">
  		and b.type = '#form.pricedistype#'
   </cfif>
  <cfif form.groupfrom neq "" and form.groupto neq "">
	and b.promoid >= '#form.groupfrom#' and b.promoid <= '#form.groupto#'
  </cfif>
    <cfif newdate3 neq "" and newdate4 neq "">
	and b.periodfrom >= '#newdate3#' and b.periodto <= '#newdate4#'
  </cfif>
  order by b.promoid
</cfquery>


<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>
<div align="center"><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong><cfoutput>Promotion Item</cfoutput> Listing</strong></font></div>
  	<cfif form.groupfrom neq "" and form.groupto neq "">
<div align="center"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif"><cfoutput>Promotion ID #form.groupfrom# - #form.groupto#</cfoutput></font></div>
</cfif>
	<cfif form.pricedistype neq "" >
<div align="center"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif"><cfoutput>Promotion type #form.pricedistype#</cfoutput></font></div>
</cfif>
    <cfif newdate3 neq "" and newdate4 neq "">
<div align="center"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif"><cfoutput>Period #newdate3# - #newdate4#</cfoutput></font></div>
</cfif>



  <cfif #getpromotion.recordCount# neq 0>
    <cfif isdefined("form.skeypage")>
      <cfset noOfPage=round(#getPersonal.recordcount#/20)>
      <cfif #getPersonal.recordcount# mod 20 LT 20 and #getPersonal.recordcount# mod 20 neq 0>
        <cfset noOfPage=#noOfPage#+1>
      </cfif>
      <cfif form.skeypage gt noofpage OR form.skeypage lt 1>
        <cfabort>
      </cfif>
    </cfif>
    <cfform action="l_vehicles.cfm" method="post">
      <cfoutput>
        <input type="hidden" name="groupfrom" value="#form.groupfrom#">
        <input type="hidden" name="groupto" value="#form.groupto#">

      </cfoutput>

    </cfform>
    <table width="100%" border="0" class="" align="center">
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      <tr>
         <td align="center" width="2%"><strong><font size="2" face="Arial, Helvetica, sans-serif">No</font></strong></td>
        <td align="center" width="7%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Promotion ID</font></strong></td>
        <td align="center" width="7%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Promotion Type</font></strong></td>
        <td align="center" width="12%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Item Code</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Description</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Period From</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Period To</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Price Amount</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Range From</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Range To</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Discount By</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Price Discount Type</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Buy Discount Type</font></strong></td>


      </tr>
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      <cfoutput>

      <cfloop query="getpromotion" startrow="1">

        <tr>
          <td align="center" width="2%"><div align="left">#i#</div></td>
          <td align="center" width="7%">#promoid#</td>
          <td align="center" width="7%">#type#</td>
          <td align="center" width="15%">#itemno#</td>
          <td align="center" width="25%">#desp#</td>
          <td align="center" width="9%">#dateformat(periodfrom,'DD-MM-YYYY')#</td>
          <td align="center" width="9%">#dateformat(periodto,'DD-MM-YYYY')#</td>
          <td align="center" width="9%">#lsnumberformat(val(priceamt),',_.__')#</td>
          <td align="center" width="9%">#rangefrom#</td>
          <td align="center" width="9%">#rangeto#</td>
          <td align="center" width="9%">#discby#</td>
          <td align="center" width="9%">#pricedistype#</td>
          <td align="center" width="9%">#buydistype#</td>

        </tr>
           <cfset i = incrementvalue(#i#)>
        </cfloop>

        <!----<cfloop query="getpromotionitem">
        <tr>
          <td align="center" width="2%"><div align="left"></div></td>
          <td>&nbsp;</td>
          <td align="left" width="9%" colspan="7">#itemno# - #desp#</td>


        </tr>


        </cfloop>--->
        <tr>
        <td colspan="100%"><br></td>
        </tr>


        <!--- <cfset i = incrementvalue(#i#)> --->

      </cfoutput>
    </table>
    <br>
    <div align="right">
      <!---       <cfif #start# neq 1>
        <cfoutput><a href="l_icitem.cfm">Previous</a> ||</cfoutput>
      </cfif>
      <cfif #page# neq #noOfPage#>
        <cfoutput> <a href="l_icitem.cfm">Next</a> ||</cfoutput>
      </cfif> --->
    </div>
    <cfelse>
    <h3><font size="2" face="Arial, Helvetica, sans-serif">No Records were found.</font></h3>
  </cfif>
  <cfif getpromotion.recordCount gt 0><cfelse>
  <strong><font size="2" face="Arial, Helvetica, sans-serif">No Records were found.
  </font> </strong>
</cfif>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>


</body>
</html>
</cfcase>
<cfcase value="EXCELDEFAULT">
<cfparam name="i" default="1" type="numeric">

<cfset newdate = createdate('#form.year1#','#form.month1#','#form.day1#') >
<cfset newdate2 = createdate('#form.year2#','#form.month2#','#form.day2#') >

<cfset newdate3 = dateformat(newdate,'YYYY-MM-DD') >
<cfset newdate4 = dateformat(newdate2,'YYYY-MM-DD')>

<cfquery name="getpromotion" datasource="#dts#">
  select a.itemno,a.desp,b.* from promoitem as a
  left join
  (
  select * from promotion) as b on a.promoid=b.promoid
  where 0=0
    <cfif form.pricedistype neq "">
  		and b.type = '#form.pricedistype#'
   </cfif>
  <cfif form.groupfrom neq "" and form.groupto neq "">
	and b.promoid >= '#form.groupfrom#' and b.promoid <= '#form.groupto#'
  </cfif>
    <cfif newdate3 neq "" and newdate4 neq "">
	and b.periodfrom >= '#newdate3#' and b.periodto <= '#newdate4#'
  </cfif>
  order by b.promoid
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
                <Style ss:ID="s50">
				<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   			<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
		   			<Borders>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   			</Borders>
		  		</Style>
                <Style ss:ID="s51">
				<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>
				<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		   			<Borders>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   			</Borders>
		  		</Style>
                <Style ss:ID="s52">
		   			<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>
		   			<Borders>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   			</Borders>
		  		</Style>
                 <Style ss:ID="s53">
		   			<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>
		  		</Style>

                <Style ss:ID="s55">
		   			<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>
					<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		   			<Borders>
						<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>

		   			</Borders>
		  		</Style>

             <Style ss:ID="s56">
		   			<Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
					<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9"/>

		  		</Style>

		 	</Styles>

			<Worksheet ss:Name="Promotion Item Listing">
				<cfoutput>
				<Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="11.25">
					<Column ss:Width="150.5"/>
					<Column ss:Width="300.25"/>
					<Column ss:Width="150.75"/>

					<Column ss:AutoFitWidth="0" ss:Width="150.75"/>
					<Column ss:Width="150.75"/>
					<Column ss:Width="80.25"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="100.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<cfset c="12">
                    <cfset d="8">
						<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
						<cfset c=c+1>
                         <cfset d=d-0>
                         </cfoutput>
                         <cfoutput>
<Row ss:AutoFitHeight="0" ss:Height="23.0625">
<cfwddx action = "cfml2wddx" input = "#dateformat(now(),"DD/MM/YY")#" output = "wddxText">
			<Cell ss:StyleID="s22"><Data ss:Type="String">Print Date: #wddxText#</Data></Cell>
            </Row>
            <Row ss:AutoFitHeight="0" ss:Height="23.0625">
	<cfwddx action = "cfml2wddx" input = "Promotion Item Listing" output = "wddxText">
<Cell ss:MergeAcross="#d#" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
</Row>

<cfif form.groupfrom neq "" and form.groupto neq "">
<Row ss:AutoFitHeight="0" ss:Height="23.0625">
<cfwddx action = "cfml2wddx" input = "#form.pricedistype#" output = "wddxText">
<Cell ss:MergeAcross="#d#"ss:StyleID="s22"><Data ss:Type="String">Promotion ID #wddxText#</Data></Cell>
</Row>
</cfif>


<cfif form.pricedistype neq "" >
<Row ss:AutoFitHeight="0" ss:Height="23.0625">
<cfwddx action = "cfml2wddx" input = "#form.pricedistype#" output = "wddxText">
<Cell ss:MergeAcross="#d#" ss:StyleID="s22"><Data ss:Type="String">Promotion type#wddxText#</Data></Cell>
</Row>
</cfif>


<cfif newdate3 neq "" and newdate4 neq "">
<Row ss:AutoFitHeight="0" ss:Height="23.0625">
<cfwddx action = "cfml2wddx" input = "#newdate3# - #newdate4#" output = "wddxText">
<Cell  ss:MergeAcross="#d#" ss:StyleID="s22"><Data ss:Type="String">Period #wddxText#</Data></Cell>
   </Row>
</cfif>

    </cfoutput>
    <!--- <cfif #getpromotion.recordCount# neq 0>
    <cfif isdefined("form.skeypage")>
      <cfset noOfPage=round(#getPersonal.recordcount#/20)>
      <cfif #getPersonal.recordcount# mod 20 LT 20 and #getPersonal.recordcount# mod 20 neq 0>
        <cfset noOfPage=#noOfPage#+1>
      </cfif>
      <cfif form.skeypage gt noofpage OR form.skeypage lt 1>
        <cfabort>
      </cfif>
    </cfif>
    <cfform action="l_vehicles.cfm" method="post">
      <cfoutput>
        <input type="hidden" name="groupfrom" value="#form.groupfrom#">
        <input type="hidden" name="groupto" value="#form.groupto#">

      </cfoutput>

    </cfform>--->

                         <Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:StyleID="s50"><Data ss:Type="String">No</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Promotion ID</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Promotion Type</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Item Code</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Description</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Period From</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Period To</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Price Amount</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Range From</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Range To</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Discount By</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Price Discount Type</Data></Cell>
            <Cell ss:StyleID="s50"><Data ss:Type="String">Buy Discount Type</Data></Cell>
	</Row>

<cfoutput>
 <cfloop query="getpromotion" startrow="1">
  <Row ss:AutoFitHeight="0" ss:Height="23.0625">
 <cfwddx action = "cfml2wddx" input = "#LSNumberFormat(i, ",")#" output = "wddxText">
<cfwddx action = "cfml2wddx" input = "#LSNumberFormat(promoid, ",")#" output = "wddxText2">
<cfwddx action = "cfml2wddx" input = "#type#" output = "wddxText3">
<cfwddx action = "cfml2wddx" input = "#itemno#" output = "wddxText4">
<cfwddx action = "cfml2wddx" input = "#desp#" output = "wddxText5">
<cfwddx action = "cfml2wddx" input = "#dateformat(periodfrom,'DD-MM-YYYY')#" output = "wddxText6">
<cfwddx action = "cfml2wddx" input = "#dateformat(periodto,'DD-MM-YYYY')#" output = "wddxText7">
<cfwddx action = "cfml2wddx" input = "#lsnumberformat(val(priceamt),',_.__')#" output = "wddxText8">
<cfwddx action = "cfml2wddx" input = "#rangefrom#" output = "wddxText9">
<cfwddx action = "cfml2wddx" input = "#rangeto#" output = "wddxText10">
<cfwddx action = "cfml2wddx" input = "#discby#" output = "wddxText11">
<cfwddx action = "cfml2wddx" input = "#pricedistype#" output = "wddxText12">
<cfwddx action = "cfml2wddx" input = "#buydistype#" output = "wddxText13">
<Cell  ss:StyleID="s56"><Data ss:Type="String">#wddxText#</Data></Cell>
<Cell  ss:StyleID="s56"><Data ss:Type="String">#wddxText2#</Data></Cell>
<Cell ss:StyleID="s56"><Data ss:Type="String">#wddxText3#</Data></Cell>
<Cell  ss:StyleID="s56"><Data ss:Type="String">#wddxText4#</Data></Cell>
<Cell  ss:StyleID="s56"><Data ss:Type="String">#wddxText5#</Data></Cell>
<Cell  ss:StyleID="s56"><Data ss:Type="String">#wddxText6#</Data></Cell>
<Cell  ss:StyleID="s56"><Data ss:Type="String">#wddxText7#</Data></Cell>
<Cell  ss:StyleID="s56"><Data ss:Type="String">#wddxText8#</Data></Cell>
<Cell  ss:StyleID="s56"><Data ss:Type="String">#wddxText9#</Data></Cell>
<Cell ss:StyleID="s56"><Data ss:Type="String">#wddxText10#</Data></Cell>
<Cell  ss:StyleID="s56"><Data ss:Type="String">#wddxText11#</Data></Cell>
<Cell  ss:StyleID="s56"><Data ss:Type="String">#wddxText12#</Data></Cell>
<Cell  ss:StyleID="s56"><Data ss:Type="String">#wddxText13#</Data></Cell>
  <cfset i = incrementvalue(#i#)>
  </Row>

 </cfloop>
</cfoutput>
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
		<cfheader name="Content-Disposition" value="attachment; filename=#dts#_BL_#huserid#.xls">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls">
	</cfcase></cfswitch>
