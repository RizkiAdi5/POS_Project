<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,agentlistuserid from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfquery name="getmodule" datasource="#dts#">
	select * 
	from modulecontrol;
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
		<cfxml variable="data">
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
		  	<Style ss:ID="s22">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s24">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s27">
		   		<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		  	</Style>
		  	<Style ss:ID="s29">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
		  	</Style>
		  	<Style ss:ID="s30">
		   		<NumberFormat ss:Format="@"/>
		  	</Style>
		  	<Style ss:ID="s31">
		   		<NumberFormat ss:Format="@"/>
		  	</Style>

			<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
			<cfset stDecl_UPrice = "">

			<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
				<cfset stDecl_UPrice = stDecl_UPrice & "0">
			</cfloop>

		  	<Style ss:ID="s32">
		   		<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  	</Style>
		  	<Style ss:ID="s33">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<NumberFormat ss:Format="@"/>
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
			   <NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s36">
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  	</Style>
		  	<Style ss:ID="s37">
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		   		</Borders>
		   		<NumberFormat ss:Format="#,###,###,##0.00"/>
		  	</Style>
		  	<Style ss:ID="s39">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
		  	</Style>
		  	<Style ss:ID="s40">
		   		<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
		  	<Style ss:ID="s42">
		   		<Alignment ss:Vertical="Center"/>
		   		<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
		   		</Borders>
		   		<Font ss:FontName="Verdana" x:Family="Swiss"/>
		  	</Style>
	 	</Styles>
	 	<Worksheet ss:Name="Cash_Sales_Report_By_User">
	 	<cfoutput>
		<Table ss:ExpandedColumnCount="20" x:FullColumns="1" x:FullRows="1">
		<Column ss:Width="64.5"/>
		<Column ss:Width="47.25"/>
		<Column ss:Width="54.75"/>
		<Column ss:Width="60.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="5"/>
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:MergeAcross="8" ss:StyleID="s22"><Data ss:Type="String">Cash Sales Report By User</Data></Cell>
		</Row>
	   <cfif form.periodfrom neq "" and form.periodto neq "">
	   		<cfwddx action = "cfml2wddx" input = "PERIOD: #form.periodfrom# - #form.periodto#" output = "wddxText">
	   		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
	   		</Row>
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
			<cfwddx action = "cfml2wddx" input = "DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#" output = "wddxText">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
	   		</Row>
		</cfif>
		
		<cfif form.agentfrom neq "" and form.agentto neq "">
			<cfwddx action = "cfml2wddx" input = "AGENT: #form.agentfrom# - #form.agentto#" output = "wddxText">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
	   		</Row>
		</cfif>
		
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
            <cfwddx action = "cfml2wddx" input = "#dateformat(now(),'dd/mm/yyyy')#" output = "wddxText2">
			<Cell ss:MergeAcross="7" ss:StyleID="s40"><Data ss:Type="String">#wddxText#</Data></Cell>
			<Cell ss:StyleID="s42"><Data ss:Type="String">#wddxText2#</Data></Cell>
		</Row>
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
        <Cell ss:StyleID="s27"><Data ss:Type="String">Date</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Ref.No.</Data></Cell>
            <cfif getmodule.auto eq "1">
            <Cell ss:StyleID="s27"><Data ss:Type="String">VEHICLE NO</Data></Cell>
            </cfif>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Sales</Data></Cell>
            
			<Cell ss:StyleID="s27"><Data ss:Type="String">Discount</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Tax</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Grand</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Cash</Data></Cell>
            <Cell ss:StyleID="s27"><Data ss:Type="String">Net</Data></Cell>
            <Cell ss:StyleID="s27"><Data ss:Type="String">Cash Card</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Credit Card</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Cheque</Data></Cell>
            <Cell ss:StyleID="s27"><Data ss:Type="String">Voucher</Data></Cell>
            <Cell ss:StyleID="s27"><Data ss:Type="String">Deposit</Data></Cell>
            <Cell ss:StyleID="s27"><Data ss:Type="String">Over Paid/Unpaid</Data></Cell>
            
		</Row>

		<cfset totalsales = 0>
            <cfset totaldiscount = 0>
            <cfset totaltax = 0>
            <cfset totalgrand = 0>
			<cfset totalcash = 0>
            <cfset totalnet = 0>
            <cfset totalcashcd = 0>
			<cfset totalcrcd = 0>
			<cfset totalcheque = 0>
			<cfset totalvoucher = 0>
			<cfset totaldeposit = 0>
            <cfset totaldebt = 0>

			<cfquery name="getdata" datasource="#dts#">
					select a.* from artran a,ictran b
					where a.type=b.type and a.refno=b.refno and
                    a.type in ('INV','CN') and (a.void = '' or a.void is null)
                    
					<cfif form.agentfrom neq "" and form.agentto neq "">
                    and a.agenno >='#form.agentfrom#' and a.agenno <= '#form.agentto#'
                    </cfif>

                    <cfif url.alown eq 1>
                    <cfif getgeneral.agentlistuserid eq "Y">and ucase(a.agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
                    <cfelse>
                    and (ucase(a.userid)='#ucase(huserid)#' or ucase(a.agenno)='#ucase(huserid)#')  
                    </cfif>
                    <cfelse>
                    <cfif Huserloc neq "All_loc">
                    and (a.userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
                    </cfif>
                    </cfif>
                    
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and a.fperiod >= '#form.periodfrom#' and a.fperiod <= '#form.periodto#'
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
					<cfelse>
					and a.wos_date > #getgeneral.lastaccyear#
					</cfif>
                    <cfif form.locationfrom neq "" and form.locationto neq "">
					and b.location >= '#form.locationfrom#' and b.location <= '#form.locationto#'
					</cfif>			
                    		group by a.refno order by a.wos_date
				</cfquery>
                 <cfquery name="getgroup" datasource="#dts#">
		select a.refno,a.type,a.custno, a.name from ictran a, icitem b
		where (type = 'INV' or type = 'CS') and b.itemno = a.itemno and (void = '' or void is null)
	        <cfif trim(form.locationfrom) neq "" and trim(form.locationto) neq "">
				and location >='#form.locationfrom#' and custno <= '#form.locationto#'
				</cfif>
		group by a.type,a.refno order by a.type,a.refno
	</cfquery>

			<cfloop query="getdata">
			<cfwddx action = "cfml2wddx" input = "#dateformat(getdata.wos_date,'dd-mm-yyyy')#" output = "wddxText">
            <cfwddx action = "cfml2wddx" input = "#getdata.refno#" output = "wddxText2">
            <cfwddx action = "cfml2wddx" input = "#getdata.rem5#" output = "wddxText3">
				<Row ss:AutoFitHeight="0">
                	<Cell ss:StyleID="s31"><Data ss:Type="String">#wddxText#</Data></Cell>
					<Cell ss:StyleID="s30"><Data ss:Type="String">#wddxText2#</Data></Cell>
                    <cfif getmodule.auto eq "1">
                    <Cell ss:StyleID="s30"><Data ss:Type="String">#wddxText3#</Data></Cell>
                    </cfif>
					<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.invgross)#</Data></Cell>
					<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.discount)#</Data></Cell>
					<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.tax)#</Data></Cell>
					<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.grand)#</Data></Cell>
					<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.CS_PM_cash)#</Data></Cell>
                    <Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.CS_PM_dbcd)#</Data></Cell>
                    <Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.CS_PM_cashcd)#</Data></Cell>
					<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.CS_PM_crcd)+val(getdata.CS_PM_crc2)#</Data></Cell>
                    <Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.CS_PM_cheq)#</Data></Cell>
                    <Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.CS_PM_vouc)#</Data></Cell>
                    <Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.deposit)#</Data></Cell>
                    <Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getdata.CS_PM_debt)#</Data></Cell>
                                
								<cfif type eq 'CN'>
                                
                               
                                
                                <cfset totaldebt = totaldebt - val(getdata.CS_PM_debt)>
                                
								<cfset totalsales = totalsales - val(getdata.invgross)>
                               
								<cfset totaldiscount = totaldiscount - val(getdata.discount)>
                                
								<cfset totaltax = totaltax - val(getdata.tax)>
                                

								<cfset totalgrand = totalgrand - val(getdata.grand)>

								<cfset totalcash = totalcash - val(getdata.CS_PM_cash)>

								<cfset totalcashcd = totalcashcd - val(getdata.CS_PM_cashcd)>

								<cfset totalnet = totalnet - val(getdata.CS_PM_dbcd)>

								<cfset totalcrcd = totalcrcd - val(getdata.CS_PM_crcd) - val(getdata.CS_PM_crc2)>

								<cfset totalcheque = totalcheque - val(getdata.CS_PM_cheq)>

								<cfset totalvoucher = totalvoucher - val(getdata.CS_PM_vouc)>

								<cfset totaldeposit = totaldeposit - val(getdata.deposit)>
                                
                                <cfelse>
                                
                                <cfset totaldebt = totaldebt + val(getdata.CS_PM_debt)>
                                
								<cfset totalsales = totalsales + val(getdata.invgross)>
                               
								<cfset totaldiscount = totaldiscount + val(getdata.discount)>
                                
								<cfset totaltax = totaltax + val(getdata.tax)>
                                

								<cfset totalgrand = totalgrand + val(getdata.grand)>

								<cfset totalcash = totalcash + val(getdata.CS_PM_cash)>

								<cfset totalcashcd = totalcashcd + val(getdata.CS_PM_cashcd)>

								<cfset totalnet = totalnet + val(getdata.CS_PM_dbcd)>

								<cfset totalcrcd = totalcrcd + val(getdata.CS_PM_crcd) + val(getdata.CS_PM_crc2)>

								<cfset totalcheque = totalcheque + val(getdata.CS_PM_cheq)>

								<cfset totalvoucher = totalvoucher + val(getdata.CS_PM_vouc)>

								<cfset totaldeposit = totaldeposit + val(getdata.deposit)>
								</cfif>

			   	</Row>
			</cfloop>

		<Row ss:AutoFitHeight="0" ss:Height="12"/>
	   	<Row ss:AutoFitHeight="0" ss:Height="12">
			<Cell ss:StyleID="s36"><Data ss:Type="String">Grand Total</Data></Cell>
			<Cell ss:Index="4" ss:StyleID="s37"><Data ss:Type="Number">#totalsales#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totaldiscount#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totaltax#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalgrand#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalcash#</Data></Cell>
            <Cell ss:StyleID="s37"><Data ss:Type="Number">#totalnet#</Data></Cell>
            <Cell ss:StyleID="s37"><Data ss:Type="Number">#totalcashcd#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalcrcd#</Data></Cell>
            <Cell ss:StyleID="s37"><Data ss:Type="Number">#totalcheque#</Data></Cell>
            <Cell ss:StyleID="s37"><Data ss:Type="Number">#totalvoucher#</Data></Cell>
            <Cell ss:StyleID="s37"><Data ss:Type="Number">#totaldeposit#</Data></Cell>
            <Cell ss:StyleID="s37"><Data ss:Type="Number">#totaldebt#</Data></Cell>
            
	   	</Row>
	   	<Row ss:AutoFitHeight="0" ss:Height="12"/>
	  	</Table>
	  	</cfoutput>
	 	</Worksheet>
		</Workbook>
		</cfxml>
		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#\Agent_Sales_List_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#\Agent_Sales_List_#huserid#.xls">
	</cfcase>

	<cfcase value="HTML">
		<html>
		<head>
		<title>Cash Sales Report By User</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
		<style type="text/css" media="print">
			.noprint { display: none; }
		</style>
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
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Sales Report Pay Detail</strong></font></div></td>
			</tr>
			<cfif form.periodfrom neq "" and form.periodto neq "">
			<tr>
				<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">PERIOD: #form.periodfrom# - #form.periodto#</font></div></td>
			</tr>
			</cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
				</tr>
			</cfif>
			
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<tr>
				  <td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
				</tr>
			</cfif>
            <cfif form.locationfrom neq "" and form.locationto neq "">
				<tr>
				  <td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">LOCATION: #form.locationfrom# - #form.locationto#</font></div></td>
				</tr>
			</cfif>
			<tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
            	<td><font size="2" face="Times New Roman, Times, serif">DATE</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">REF NO.</font></td>
                <cfif getmodule.auto eq "1">
                <td><font size="2" face="Times New Roman, Times, serif">VEHICLE NO</font></td>
                </cfif>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Sales</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Discount</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Tax</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Grand</font></div></td>
				
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Cash</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Net</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Cash Card</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Credit Card</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Cheque</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Voucher</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Deposit</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Over Paid/Unpaid</font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			
            <cfset totalsales = 0>
            <cfset totaldiscount = 0>
            <cfset totaltax = 0>
            <cfset totalgrand = 0>
			<cfset totalcash = 0>
            <cfset totalnet = 0>
            <cfset totalcashcd = 0>
			<cfset totalcrcd = 0>
			<cfset totalcheque = 0>
			<cfset totalvoucher = 0>
			<cfset totaldeposit = 0>
            <cfset totaldebt = 0>
                
				<cfquery name="getdata" datasource="#dts#">
					select a.* from artran a,ictran b
					where 
                    a.type=b.type and a.refno=b.refno and 
                    a.type in ('INV','CN') and (a.void = '' or a.void is null)
                    
					<cfif form.agentfrom neq "" and form.agentto neq "">
                    and a.agenno >='#form.agentfrom#' and a.agenno <= '#form.agentto#'
                    </cfif>

                    <cfif url.alown eq 1>
                    <cfif getgeneral.agentlistuserid eq "Y">and ucase(a.agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
                    <cfelse>
                    and (ucase(a.userid)='#ucase(huserid)#' or ucase(a.agenno)='#ucase(huserid)#')  
                    </cfif>
                    <cfelse>
                    <cfif Huserloc neq "All_loc">
                    and (a.userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
                    </cfif>
                    </cfif>
                    
					<cfif form.periodfrom neq "" and form.periodto neq "">
					and a.fperiod >= '#form.periodfrom#' and a.fperiod <= '#form.periodto#'
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
					and a.wos_date >= '#ndatefrom#' and a.wos_date <= '#ndateto#'
					<cfelse>
					and a.wos_date > #getgeneral.lastaccyear#
					</cfif>
                     <cfif trim(form.locationfrom) neq "" and trim(form.locationto) neq "">
				and b.location >='#form.locationfrom#' and b.location <= '#form.locationto#'
				</cfif>
					group by a.refno order by a.wos_date
				</cfquery>
      

				<cfloop query="getdata">
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
                    <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getdata.wos_date,"dd-mm-yyyy")#</font></div></td>
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdata.refno#</font></div></td>
                        <cfif getmodule.auto eq "1">
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getdata.rem5#</font></div></td>
                        </cfif>
								<td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.invgross),',_.__')#</div></td>
								<td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.discount),',_.__')#</div></td>
								<td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.tax),',_.__')#</div></td>
								<td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.grand),',_.__')#</div></td>
								<td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.CS_PM_cash),',_.__')#</div></td>
                                <td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.CS_PM_dbcd),',_.__')#</div></td>
                                <td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.CS_PM_cashcd),',_.__')#</div></td>
                                <td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.CS_PM_crcd+val(CS_PM_crc2)),',_.__')#</div></td>
                                <td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.CS_PM_cheq),',_.__')#</div></td>
                                <td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.CS_PM_vouc),',_.__')#</div></td>
                                <td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.deposit),',_.__')#</div></td>
                                <td><div align="right"><cfif type eq 'CN'>-</cfif>#numberformat(val(getdata.CS_PM_debt),',_.__')#</div></td>
                                
                                <cfif type eq 'CN'>
                                
                                
                                <cfset totaldebt = totaldebt - val(getdata.CS_PM_debt)>
                                
								<cfset totalsales = totalsales - val(getdata.invgross)>
                               
								<cfset totaldiscount = totaldiscount - val(getdata.discount)>
                                
								<cfset totaltax = totaltax - val(getdata.tax)>
                                

								<cfset totalgrand = totalgrand - val(getdata.grand)>

								<cfset totalcash = totalcash - val(getdata.CS_PM_cash)>

								<cfset totalcashcd = totalcashcd - val(getdata.CS_PM_cashcd)>

								<cfset totalnet = totalnet - val(getdata.CS_PM_dbcd)>

								<cfset totalcrcd = totalcrcd - val(getdata.CS_PM_crcd) - val(getdata.CS_PM_crc2)>

								<cfset totalcheque = totalcheque - val(getdata.CS_PM_cheq)>

								<cfset totalvoucher = totalvoucher - val(getdata.CS_PM_vouc)>

								<cfset totaldeposit = totaldeposit - val(getdata.deposit)>
                                
                                <cfelse>
                                
                                <cfset totaldebt = totaldebt + val(getdata.CS_PM_debt)>
                                
								<cfset totalsales = totalsales + val(getdata.invgross)>
                               
								<cfset totaldiscount = totaldiscount + val(getdata.discount)>
                                
								<cfset totaltax = totaltax + val(getdata.tax)>
                                

								<cfset totalgrand = totalgrand + val(getdata.grand)>

								<cfset totalcash = totalcash + val(getdata.CS_PM_cash)>

								<cfset totalcashcd = totalcashcd + val(getdata.CS_PM_cashcd)>

								<cfset totalnet = totalnet + val(getdata.CS_PM_dbcd)>

								<cfset totalcrcd = totalcrcd + val(getdata.CS_PM_crcd) + val(getdata.CS_PM_crc2)>

								<cfset totalcheque = totalcheque + val(getdata.CS_PM_cheq)>

								<cfset totalvoucher = totalvoucher + val(getdata.CS_PM_vouc)>

								<cfset totaldeposit = totaldeposit + val(getdata.deposit)>
								</cfif>
					</tr>
				</cfloop>

			<cfflush>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
				<td><div align="left"></div></td>
                <td><div align="left"></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalsales,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaldiscount,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaltax,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalgrand,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcash,",.__")#</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalnet,",.__")#</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcashcd,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcrcd,",.__")#</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalcheque,",.__")#</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totalvoucher,",.__")#</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaldeposit,",.__")#</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#numberformat(totaldebt,",.__")#</strong></font></div></td>
			</tr>
		  </table>
		</cfoutput>

		<cfif getdata.recordcount eq 0>
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