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

<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfparam name="i" default="1" type="numeric">
<cfquery name="getVehicles" datasource="#dts#">
  select * from vehicles 
  where 0=0
  <cfif form.groupfrom neq "" and form.groupto neq "">
	and carno >= '#form.groupfrom#' and carno <= '#form.groupto#'
  </cfif>
    <cfif form.groupfrom2 neq "" and form.groupto2 neq "">
	and custcode >= '#form.groupfrom2#' and custcode <= '#form.groupto2#'
  </cfif>
  order by #form.trantype#
</cfquery>

<cfswitch expression="HTML">
	<cfcase value="HTML">
		<html>
		<head>
		<title>Vehicle History Report</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
		<style type="text/css" media="print">
			.noprint { display: none; }
		</style>
		</head>

		<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
		<cfset stDecl_UPrice = ",___.">

		<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
			<cfset stDecl_UPrice = stDecl_UPrice & "_">
		</cfloop>

		<body>

		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<cfoutput>
            <tr>
				<td colspan="9"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong> Vehicle report by #form.trantype#</strong></font></div></td>
			</tr>
			<cfif form.groupfrom neq "" and form.groupto neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">Vehicle No: #form.groupfrom# - #form.groupto#</font></div></td>
				</tr>
			</cfif>
					<cfif form.groupfrom2 neq "" and form.groupto2 neq "">
				<tr>
					<td colspan="9"><div align="center"><font size="2" face="Times New Roman, Times, serif">Customer No: #form.groupfrom2# - #form.groupto2#</font></div></td>
				</tr>
			</cfif>
        
			<tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
			  <td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="2"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
            			</cfoutput>
</table>

  <cfif #getVehicles.recordCount# neq 0>
    <cfif isdefined("form.skeypage")>
      <cfset noOfPage=round(#getPersonal.recordcount#/20)>
      <cfif #getPersonal.recordcount# mod 20 LT 20 and #getPersonal.recordcount# mod 20 neq 0>
        <cfset noOfPage=#noOfPage#+1>
      </cfif>
      <cfif form.skeypage gt noofpage OR form.skeypage lt 1>
        <cfabort>
      </cfif>
    </cfif>
    <cfform action="vehiclesreport2.cfm" method="post">
      <cfoutput>
        <input type="hidden" name="groupfrom" value="#form.groupfrom#">
        <input type="hidden" name="groupto" value="#form.groupto#">
        <cfif isdefined("form.cbmodel")>
          <input type="hidden" name="cbmodel" value="#form.cbmodel#">
        </cfif>
        <cfif isdefined("form.cbcustname")>
          <input type="hidden" name="cbcustname" value="#form.cbcustname#">
        </cfif>
        <cfif isdefined("form.cbcustic")>
          <input type="hidden" name="cbcustic" value="#form.cbcustic#">
        </cfif>
        <cfif isdefined("form.cbgender")>
          <input type="hidden" name="cbgender" value="#form.cbgender#">
        </cfif>
        <cfif isdefined("form.cbmarstatus")>
          <input type="hidden" name="cbmarstatus" value="#form.cbmarstatus#">
        </cfif>
        <cfif isdefined("form.cbcustadd")>
          <input type="hidden" name="cbAttn" value="#form.cbcustadd#">
        </cfif>
        <cfif isdefined("form.cbdob")>
          <input type="hidden" name="cbdob" value="#form.cbdob#">
        </cfif>
        <cfif isdefined("form.cbNCD")>
          <input type="hidden" name="cbNCD" value="#form.cbNCD#">
        </cfif>
        <cfif isdefined("form.cbcom")>
          <input type="hidden" name="cbcom" value="#form.cbcom#">
        </cfif>
        <cfif isdefined("form.cbscheme")>
          <input type="hidden" name="cbscheme" value="#form.cbscheme#">
        </cfif>
        <cfif isdefined("form.cbmake")>
          <input type="hidden" name="cbmake" value="#form.cbmake#">
        </cfif>
        <cfif isdefined("form.cbchasisno")>
          <input type="hidden" name="cbchasisno" value="#form.cbchasisno#">
        </cfif>
        <cfif isdefined("form.cbyearmade")>
          <input type="hidden" name="cbyearmade" value="#form.cbyearmade#">
        </cfif>
        <cfif isdefined("form.cboriregdate")>
          <input type="hidden" name="cboriregdate" value="#form.cboriregdate#">
        </cfif>
        <cfif isdefined("form.cbcapacity")>
          <input type="hidden" name="cbcapacity" value="#form.cbcapacity#">
        </cfif>
        <cfif isdefined("form.cbcoveragetype")>
          <input type="hidden" name="cbcoveragetype" value="#form.cbcoveragetype#">
        </cfif>
        <cfif isdefined("form.cbsuminsured")>
          <input type="hidden" name="cbsuminsured" value="#form.cbsuminsured#">
        </cfif>
        <cfif isdefined("form.cbinsurance")>
          <input type="hidden" name="cbinsurance" value="#form.cbinsurance#">
        </cfif>
        <cfif isdefined("form.cbpremium")>
          <input type="hidden" name="cbpremium" value="#form.cbpremium#">
        </cfif>
        <cfif isdefined("form.cbfinancecom")>
          <input type="hidden" name="cbfinancecom" value="#form.cbfinancecom#">
        </cfif>
        <cfif isdefined("form.cbcommission")>
          <input type="hidden" name="cbcommission" value="#form.cbcommission#">
        </cfif>
        <cfif isdefined("form.cbcontract")>
          <input type="hidden" name="cbcontract" value="#form.cbcontract#">
        </cfif>
                <cfif isdefined("form.cbpayment")>
          <input type="hidden" name="cbpayment" value="#form.cbpayment#">
        </cfif>
                <cfif isdefined("form.cbcustrefer")>
          <input type="hidden" name="cbcustrefer" value="#form.cbcustrefer#">
        </cfif>
         <cfif isdefined("form.cbinexpdate")>
          <input type="hidden" name="cbinexpdate" value="#form.cbinexpdate#">
        </cfif>
      </cfoutput>
   
    </cfform>
    <table width="100%" border="0" class="" align="center">
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      <tr>
         <td align="center" width="2%"><strong><font size="2" face="Arial, Helvetica, sans-serif">No</font></strong></td>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>Vehicle No</cfoutput></font></strong></td>
<td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>Customer Code</cfoutput></font></strong></td>
                        <cfif isdefined("form.cbmodel")>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Model</font></strong></td>
        </cfif>
            <cfif isdefined("form.cbcustname")>
        <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">custname</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbcustic")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Customer IC</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbgender")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Gender</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbmarstatus")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Martial status</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbcustadd")>
          <td align="center" width="17%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Address</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbdob")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Date of Birth</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbNCD")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">NCD</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbcom")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Certificate of Merit</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbscheme")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Vehicle Scheme</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbmake")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Vehicle Make</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbchasisno")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Chasis No</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbyearmade")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Year of manufacture</font></strong></td>
        </cfif>
        <cfif isdefined("form.cboriregdate")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Original Reg Date</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbcapacity")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Capacity</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbcoveragetype")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Coverage type</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbsuminsured")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Sum Insured</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbinsurance")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Insurance</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbpremium")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Premium</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbfinancecom")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Finance</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbcommision")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Commision</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbcontract")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Contact</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbpayment")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Payment</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbcustrefer")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Refered By</font></strong></td>
        </cfif>
        <cfif isdefined("form.cbinexpdate")>
          <td align="center" width="9%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Insurance Expire Date</font></strong></td>
        </cfif>
      </tr>
      <tr>
        <td colspan="100%"><hr></td>
      </tr>
      
      <cfoutput query="getvehicles" startrow="1">
        <tr>
          <td align="center" width="2%"><div align="left">#i#</div></td>
          <td align="center" width="9%">#carno#</td>
          <td align="center" width="9%">#custcode#</td>
          <cfif isdefined("form.cbmodel")>
            <td align="center" width="9%">#model#</td>
          </cfif>
          <cfif isdefined("form.cbcustname")>
            <td align="center" width="9%">#custname#</td>
          </cfif>
          <cfif isdefined("form.cbcustic")>
            <td align="center" width="9%">#custic#</td>
          </cfif>
          <cfif isdefined("form.cbgender")>
            <td align="center" width="9%">#gender#</td>
          </cfif>
          <cfif isdefined("form.cbmarstatus")>
            <td align="center" width="9%">#marstatus#</td>
          </cfif>
          <cfif isdefined("form.cbcustadd")>
            <td align="center" width="17%">#custadd#</td>
          </cfif>
          <cfif isdefined("form.cbdob")>
            <td align="center" width="9%">#dateformat(dob,'DD-MM-YYYY')#</td>
          </cfif>
          <cfif isdefined("form.cbNCD")>
            <td align="center" width="9%">#NCD#</td>
          </cfif>
          <cfif isdefined("form.cbcom")>
            <td align="center" width="9%">#com#</td>
          </cfif>
          <cfif isdefined("form.cbscheme")>
            <td align="center" width="9%">#scheme#</td>
          </cfif>
          <cfif isdefined("form.cbmake")>
            <td align="center" width="9%">#make#</td>
          </cfif>
          <cfif isdefined("form.cbchasisno")>
            <td align="center" width="9%">#chasisno#</td>
          </cfif>
          <cfif isdefined("form.cbyearmade")>
            <td align="center" width="9%">#yearmade#</td>
          </cfif>
          <cfif isdefined("form.cboriregdate")>
            <td align="center" width="9%">#dateformat(oriregdate,'DD-MM-YYYY')#</td>
          </cfif>
          <cfif isdefined("form.cbcapacity")>
            <td align="center" width="9%">#capacity#</td>
          </cfif>
          <cfif isdefined("form.cbcoveragetype")>
            <td align="center" width="9%">#coveragetype#</td>
          </cfif>
          <cfif isdefined("form.cbsuminsured")>
            <td align="center" width="9%">#suminsured#</td>
          </cfif>
          <cfif isdefined("form.cbinsurance")>
            <td align="center" width="9%"><div align="center">#insurance#</div></td>
          </cfif>
          <cfif isdefined("form.cbpremium")>
            <td align="center" width="9%"><div align="right">#premium#</div></td>
          </cfif>
          <cfif isdefined("form.cbfinancecom")>
            <td align="center" width="9%"><div align="center">#financecom#</div></td>
          </cfif>
          <cfif isdefined("form.cbcommission")>
            <td align="center" width="9%"><div align="right">#commission#</div></td>
          </cfif>
          <cfif isdefined("form.cbcontract")>
            <td align="center" width="9%"><div align="right">#contract#</div></td>
          </cfif>
                    <cfif isdefined("form.cbpayment")>
            <td align="center" width="9%"><div align="right">#payment#</div></td>
          </cfif>
                    <cfif isdefined("form.cbcustrefer")>
            <td align="center" width="9%"><div align="right">#custrefer#</div></td>
          </cfif>
           <cfif isdefined("form.cbinexpdate")>
            <td align="center" width="9%"><div align="right">#dateformat(inexpdate,'DD-MM-YYYY')#</div></td>
          </cfif>
        </tr>
        <!--- <cfset i = incrementvalue(#i#)> --->
        <cfset i = incrementvalue(#i#)>
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

	
		<br>
		<br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>

        
		</html>
	</cfcase>

	<cfcase value="EXCELDEFAULT">


		<cfxml variable="data">
		<?mso-application progid="Excel.Sheet"?>
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
		  	<Style ss:ID="s24">
		  		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		  	</Style>
		  	<Style ss:ID="s27">
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s28">
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s29">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>

			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>

		  	<Style ss:ID="s30">
		   		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  	</Style>
		  	<Style ss:ID="s31">
		  	 	<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s32">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s34">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s36">
		   		<Alignment ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		</Styles>
		<Worksheet ss:Name="Top_Sales_Report - By Agent">
  		<Table ss:ExpandedColumnCount="7" x:FullColumns="1" x:FullRows="1">
   		<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
   		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="4"/>
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
    		<Cell ss:MergeAcross="6" ss:StyleID="s31"><Data ss:Type="String">Top Sales Report - By Agent</Data></Cell>
   		</Row>
		<cfoutput>
   		<cfif form.groupfrom neq "" and form.groupto neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="6" ss:StyleID="s32"><Data ss:Type="String">Vehicle Number: #form.groupfrom# - #form.groupto#</Data></Cell>
			</Row>
		</cfif>
		<cfif form.groupfrom2 neq "" and form.groupto2 neq "">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="6" ss:StyleID="s32"><Data ss:Type="String">Customer Code: #form.groupfrom2# - #form.groupto2#</Data></Cell>
			</Row>
		</cfif>

   		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
   	 		<Cell ss:MergeAcross="5" ss:StyleID="s34"><Data ss:Type="String">#wddxText#</Data></Cell>
    		<Cell ss:StyleID="s36"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
   		</Row>

		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
        <Cell ss:StyleID="s24"><Data ss:Type="String">Vehicles No</Data></Cell>
        <Cell ss:StyleID="s24"><Data ss:Type="String">Customer CODE</Data></Cell>
                               <cfif isdefined("form.cbmodel")>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Model</Data></Cell></cfif>
            <cfif isdefined("form.cbcustname")>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Customer Name</Data></Cell>
                    </cfif>
                            <cfif isdefined("form.cbcustic")>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Customer IC</Data></Cell></cfif>
                    <cfif isdefined("form.cbgender")>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Gender</Data></Cell></cfif>
                    <cfif isdefined("form.cbmarstatus")>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Martial Status</Data></Cell></cfif>
                    <cfif isdefined("form.cbcustadd")>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Customer Address</Data></Cell></cfif>
                   <cfif isdefined("form.cbdob")>
    		<Cell ss:StyleID="s24"><Data ss:Type="String">Date Of Birth</Data></Cell></cfif>
                    <cfif isdefined("form.cbNCD")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">NCD</Data></Cell></cfif>
                    <cfif isdefined("form.cbcom")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">COM</Data></Cell></cfif>
                    <cfif isdefined("form.cbscheme")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Scheme</Data></Cell></cfif>
                    <cfif isdefined("form.cbmake")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Make</Data></Cell></cfif>
                    <cfif isdefined("form.cbchasisno")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Chasis No</Data></Cell></cfif>
                    <cfif isdefined("form.cbyearmade")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Year Of Manufacture</Data></Cell></cfif>
                    <cfif isdefined("form.cboriregdate")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Original Registration date</Data></Cell></cfif>
                    <cfif isdefined("form.cbcapacity")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Capacity</Data></Cell></cfif>
                    <cfif isdefined("form.cbcoveragetype")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Coverage Type</Data></Cell></cfif>
                    <cfif isdefined("form.cbsuminsured")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Sum insured</Data></Cell></cfif>
                    <cfif isdefined("form.cbinsurance")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Insurance</Data></Cell></cfif>
                    <cfif isdefined("form.cbpremium")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Premium</Data></Cell></cfif>
                    <cfif isdefined("form.cbfinancecom")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Finance</Data></Cell></cfif>
                    <cfif isdefined("form.cbcommision")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Commision</Data></Cell></cfif>
                    <cfif isdefined("form.cbcontract")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Contract</Data></Cell></cfif>
                    <cfif isdefined("form.cbpayment")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Payment</Data></Cell></cfif>
                    <cfif isdefined("form.cbcustrefer")>
                    <Cell ss:StyleID="s24"><Data ss:Type="String">Customer Reference</Data></Cell></cfif>
   		</Row>
</cfoutput>
<cfparam name="i" default="1" type="numeric">
<cfquery name="getVehicles" datasource="#dts#">
  select * from vehicles 
  where 0=0
  <cfif form.groupfrom neq "" and form.groupto neq "">
	and carno >= '#form.groupfrom#' and carno <= '#form.groupto#'
  </cfif>
    <cfif form.groupfrom2 neq "" and form.groupto2 neq "">
	and custcode >= '#form.groupfrom2#' and custcode <= '#form.groupto2#'
  </cfif>
  order by #form.trantype#
</cfquery>

      <cfoutput query="getvehicles" startrow="1">

			<Row ss:Height="12">
				<cfif getVehicles.carno eq "">
					<Cell ss:StyleID="s27"><Data ss:Type="String">No - Carno</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">No - Carno</Data></Cell>
				<cfelse>
					<cfwddx action = "cfml2wddx" input = "#getVehicles.carno#" output = "wddxText">
					<Cell ss:StyleID="s27"><Data ss:Type="String">#wddxText#</Data></Cell>
					<cfwddx action = "cfml2wddx" input = "#getVehicles.custcode#" output = "wddxText">
					<Cell ss:StyleID="s27"><Data ss:Type="String">#wddxText#</Data></Cell>
				</cfif>
				<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getVehicles.carno)#</Data></Cell>
				<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getVehicles.custcode)#</Data></Cell>
				<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getVehicles.custcode)#</Data></Cell>
				<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getVehicles.custcode)#</Data></Cell>
				<Cell ss:StyleID="s30"><Data ss:Type="Number">#val(getVehicles.custcode)#</Data></Cell>
                
			</Row>
            
   		</cfoutput>
		<Row ss:Height="12"/>
		</Table>
		</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Agent_Sales_Report_By-Type_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Agent_Sales_Report_By-Type_#huserid#.xls">
	</cfcase>
</cfswitch>