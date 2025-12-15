<cfif form.result eq "HTML">
<html>
<head>
<title>Customer - Item Transacted Price Enquiry</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<body>
<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
<cfset stDecl_UPrice = ",___.">

<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
  <cfset stDecl_UPrice = stDecl_UPrice & "_">
</cfloop>

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

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2" on>
	<tr> 
		<td colspan="13"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Customer - Item Transacted Price Enquiry</strong></font></div></td>
	</tr>
	<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
		<tr>
			<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">CUST: #form.custfrom# - #form.custto#</font></div></td>
		</tr>
	</cfif>
    <cfif trim(form.agentfrom) neq "" and trim(form.agentto) neq "">
		<tr>
			<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">AGENT: #form.agentfrom# - #form.agentto#</font></div></td>
		</tr>
	</cfif>
    
    <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
		<tr>
			<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">BRAND: #form.brandfrom# - #form.brandto#</font></div></td>
		</tr>
	</cfif>
	<cfif form.datefrom neq "" and form.dateto neq "">
		<tr> 
      		<td colspan="13"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#</font></div></td>
    	</tr>
	</cfif>
	<tr> 
		<td colspan="2"><font size="2" face="Times New Roman, Times, serif">#getgeneral.compro#</font></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td colspan="5"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
	</tr>
	<tr> 
		<td colspan="100%"><hr></td>
	</tr>
	<tr> 
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">TYPE</font></div></td>
	  	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">REF NO</font></div></td>
	  	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">DATE</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CUST NO</font></div></td>
	 	<td><div align="left"><font size="2" face="Times New Roman, Times, serif">NAME</font></div></td>
        <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">AGENT</font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">REMARK</font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">NAME</font></div></td>
        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">ADDRESS</font></div></td>
                </cfif>
        
	 	<td><div align="right"><font size="2" face="Times New Roman, Times, serif">QTY</font></div></td>
		<td><div align="left"><font size="2" face="Times New Roman, Times, serif">CURRENCY</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">F.PRICE</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">PRICE</font></div></td>
		<td><div align="right"><font size="2" face="Times New Roman, Times, serif">AMOUNT</font></div></td>
    </tr>
    <tr> 
      	<td colspan="100%"><hr></td>
    </tr>
		
	<cfquery name="getitem" datasource="#dts#">
		select itemno as itemno, desp as desp from ictran
		where <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">(type='CN' or type='INV' or type='DN')<cfelse>type='INV'</cfif>  and (void='' or void is null)
        <cfif isdefined('form.service')>
        <cfelse>
        and (linecode='' or linecode is null)
        </cfif>
		<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
		and custno between '#form.custfrom#' and '#form.custto#'
		</cfif>
		<cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
		and itemno between '#form.itemfrom#' and '#form.itemto#'
		</cfif>
        <cfif trim(form.agentfrom) neq "" and trim(form.agentto) neq "">
                and agenno between '#form.agentfrom#' and '#form.agentto#'
        </cfif>
        <cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
		and category between '#form.catefrom#' and '#form.cateto#'
		</cfif>
        <cfif trim(form.brandfrom) neq "" and trim(form.brandto) neq "">
		and itemno in (select itemno from icitem where brand between '#form.brandfrom#' and '#form.brandto#')
		</cfif>
		<cfif form.datefrom neq "" and form.dateto neq "">
		and wos_date between '#ndatefrom#' and '#ndateto#'
		<cfelse>
		and wos_date > #getgeneral.lastaccyear#
		</cfif>
		group by itemno order by itemno
	</cfquery>
		
	<cfloop query="getitem">
		<tr> 
			<td colspan="3"><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getitem.itemno#</u></b></div></font></td>
			<td colspan="3"><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u>#getitem.desp#</u></b></div></font></td>
		</tr>
			
		<cfquery name="getcust" datasource="#dts#">
			select a.type,a.refno,a.custno,a.name,a.wos_date,a.price,a.price_bil,b.agenno,a.unit,a.qty,b.currcode,b.comm2,b.frem7,b.frem8,b.currrate,a.amt,b.rem11
			from ictran a,artran b 
			where a.type=b.type
			and a.refno=b.refno 
			and <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">(a.type='CN' or a.type='INV'  or a.type='DN')<cfelse>a.type='INV'</cfif>
			and a.itemno='#getitem.itemno#' and (a.void='' or a.void is null)
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			and a.custno between '#form.custfrom#' and '#form.custto#'
			</cfif>
            <cfif trim(form.agentfrom) neq "" and trim(form.agentto) neq "">
                and b.agenno between '#form.agentfrom#' and '#form.agentto#'
                </cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and a.wos_date between '#ndatefrom#' and '#ndateto#'
			<cfelse>
			and a.wos_date > #getgeneral.lastaccyear#
			</cfif>
			order by a.refno,a.wos_date
		</cfquery>
			
		<cfloop query="getcust">
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getcust.type#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getcust.refno#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#dateformat(getcust.wos_date,"dd-mm-yyyy")#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getcust.custno#</font></div></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getcust.name#</font></div></td>
                <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getcust.agenno#</font></div></td>
                <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getcust.rem11#</font></div></td>
                
                <cfquery name="getname" datasource="#dts#">
                select * from #target_arcust# where custno='#getcust.custno#'
                </cfquery>
                   <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getcust.frem7# #getcust.frem8#</font></div></td>
                
                <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getcust.comm2# </font></div></td>
                
                
               
                
               
                </cfif>
                 
                
              
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.qty,"0")#</font></div></td>
				<td><div align="center"><font size="2" face="Times New Roman, Times, serif">#getcust.currcode#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.price_bil,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.price,stDecl_UPrice)#</font></div></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">#numberformat(getcust.amt,stDecl_UPrice)#</font></div></td>
			</tr>
		</cfloop>
		<tr><td><br></td></tr>
		<cfflush>
	</cfloop>
</table>
</cfoutput>

<cfif getitem.recordcount eq 0>
	<h4 style="color:red">Sorry, No records were found.</h4>
</cfif> 

<br>
<br>
<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
</body>
</html>
<cfelse>

<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
<cfset stDecl_UPrice = ",___.">

<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
  <cfset stDecl_UPrice = stDecl_UPrice & "_">
</cfloop>

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
			
			<Worksheet ss:Name="Item Transacted Price">
				<cfoutput>
				<Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="11.25">
					<Column ss:Width="64.5"/>
					<Column ss:Width="100.25"/>
					<Column ss:Width="90.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="83.75"/>
					<Column ss:Width="187.75"/>
					<Column ss:Width="47.25"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<cfset c="11">
						<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
						<cfset c=c+1>

		   
					<cfwddx action = "cfml2wddx" input = "Customer - Item Transacted Price Enquiry 
" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="#c#" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
					</Row>
			
					
                    <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
        			<cfwddx action = "cfml2wddx" input = "CUST: #form.custfrom# - #form.custto#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
						<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
					<cfif form.datefrom neq "" and form.dateto neq "">
                        <cfwddx action = "cfml2wddx" input = "DATE: #dateformat(form.datefrom,"dd/mm/yyyy")# - #dateformat(form.dateto,"dd/mm/yyyy")#" output = "wddxText">
                        <Row ss:AutoFitHeight="0" ss:Height="20.0625">
                        <Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
                       </Row>
                    </cfif>
                    
						

			
				
					
					<cfwddx action = "cfml2wddx" input = "" output = "wddxText">
			
					<Row ss:AutoFitHeight="0" ss:Height="20.0625">
						<Cell ss:MergeAcross="#c-1#" ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
					</Row>
				</cfoutput>
		
				<Row ss:AutoFitHeight="0" ss:Height="23.0625">
                	<Cell ss:StyleID="s27"><Data ss:Type="String">TYPE</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">REF NO</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">DATE</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">CUST NO</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">NAME</Data></Cell>
                    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                    <Cell ss:StyleID="s27"><Data ss:Type="String">AGENT</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">REMARK</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">NAME</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">ADDRESS</Data></Cell>
                    </cfif>
					<Cell ss:StyleID="s27"><Data ss:Type="String">QTY</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">CURRENCY</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">F.PRICE</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">PRICE</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">AMOUNT Local</Data></Cell>
					
				</Row>
                
                <cfquery name="getitem" datasource="#dts#">
                select a.itemno as itemno, a.desp as desp from icitem a,ictran b 
                where <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">(b.type='CN' or b.type='INV' or type='DN')<cfelse>b.type='INV'</cfif> and a.itemno=b.itemno and (b.void='' or b.void is null)
                <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
                and b.custno between '#form.custfrom#' and '#form.custto#'
                </cfif>
                <cfif trim(form.itemfrom) neq "" and trim(form.itemto) neq "">
                and b.itemno between '#form.itemfrom#' and '#form.itemto#'
                </cfif>
                <cfif trim(form.catefrom) neq "" and trim(form.cateto) neq "">
                and b.category between '#form.catefrom#' and '#form.cateto#'
                </cfif>
                <cfif trim(form.agentfrom) neq "" and trim(form.agentto) neq "">
                and b.agenno between '#form.agentfrom#' and '#form.agentto#'
                </cfif>
                <cfif form.datefrom neq "" and form.dateto neq "">
                and b.wos_date between '#ndatefrom#' and '#ndateto#'
                <cfelse>
                and b.wos_date > #getgeneral.lastaccyear#
                </cfif>
                group by itemno order by itemno
            </cfquery>
		
	<cfloop query="getitem">
    
    
    <cfquery name="getcust" datasource="#dts#">
			select a.type,a.refno,a.custno,a.name,a.wos_date,a.price,a.price_bil,a.unit,a.qty,b.currcode,b.currrate,a.amt,b.rem11,b.frem7,b.com2,b.frem8,b.agenno
			from ictran a,artran b 
			where a.type=b.type
			and a.refno=b.refno 
			and <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">(a.type='CN' or a.type='INV' or a.type='DN')<cfelse>a.type='INV'</cfif>
			and a.itemno='#getitem.itemno#' and (a.void='' or a.void is null)
			<cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
			and a.custno between '#form.custfrom#' and '#form.custto#'
			</cfif>
            <cfif trim(form.agentfrom) neq "" and trim(form.agentto) neq "">
                and b.agenno between '#form.agentfrom#' and '#form.agentto#'
            </cfif>
			<cfif form.datefrom neq "" and form.dateto neq "">
			and a.wos_date between '#ndatefrom#' and '#ndateto#'
			<cfelse>
			and a.wos_date > #getgeneral.lastaccyear#
			</cfif>
			order by a.refno,a.wos_date
		</cfquery>
        
        <tr> 
			<td colspan="3"><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u></u></b></div></font></td>
			<td colspan="3"><font size="2" face="Times New Roman, Times, serif"><div align="left"><b><u></u></b></div></font></td>
		</tr>
        <cfoutput>
			<cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText">
					<cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText2">
					<Row ss:AutoFitHeight="0">
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText2#</Data></Cell>
	
					
					</Row>
                   
        </cfoutput>
        
		<cfloop query="getcust">
        <cfoutput>
        
        		 <cfquery name="getname" datasource="#dts#">
                select * from #target_arcust# where custno='#getcust.custno#'
                </cfquery>
                <cfwddx action = "cfml2wddx" input = "#getcust.type#" output = "wddxText1">
                <cfwddx action = "cfml2wddx" input = "#getcust.refno#" output = "wddxText2">
                <cfwddx action = "cfml2wddx" input = "#dateformat(getcust.wos_date,"dd-mm-yyyy")#" output = "wddxText3">
                <cfwddx action = "cfml2wddx" input = "#getcust.custno#" output = "wddxText4">
                <cfwddx action = "cfml2wddx" input = "#getcust.name#" output = "wddxText5">
                <cfwddx action = "cfml2wddx" input = "#getcust.currcode#" output = "wddxText6">
				<cfwddx action = "cfml2wddx" input = "#getcust.rem11#" output = "wddxText7">
                <cfwddx action = "cfml2wddx" input = "#getcust.agenno#" output = "wddxText8">
                
                <cfwddx action = "cfml2wddx" input = "#getcust.frem7#" output = "wddxText9">
                <cfwddx action = "cfml2wddx" input = "#getcust.comm2#" output = "wddxText10">
             
					<Row ss:AutoFitHeight="0">
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText1#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText2#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText3#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText4#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText5#</Data></Cell>
                        <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText8#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText7#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText9#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText10#</Data></Cell>
 
                          </cfif>
                        
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#getcust.qty#</Data></Cell>

						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText6#</Data></Cell>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#getcust.price_bil#</Data></Cell>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#getcust.price#</Data></Cell>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#getcust.amt#</Data></Cell>

                        </Row>
		</cfoutput>
		</cfloop>
		<Row ss:AutoFitHeight="0" ss:Height="12"/>
    
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


</cfif>