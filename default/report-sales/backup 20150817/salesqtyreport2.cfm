<cfquery name="getgeneral" datasource="#dts#">
	select compro,lastaccyear,agentlistuserid from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>




<cfif isdefined("form.datefrom")>
    
    <cfset date7day =DateAdd("d", -7, form.datefrom)>
    
    <cfset dd = dateformat(form.datefrom, "DD")>
	<cfif dd greater than '12'>
    	<cfset date7day =DateAdd("d", -7, form.datefrom)>
		<cfset ndate7day = dateformat(date7day,"YYYYMMDD")>
        
	<cfelse>
    	<cfset date7day =DateAdd("m", -7, form.datefrom)>
		<cfset ndate7day = dateformat(date7day,"YYYYDDMM")>
        
	</cfif>
    
	<cfset dd = dateformat(form.datefrom, "DD")>
	<cfif dd greater than '12'>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYMMDD")>
	<cfelse>
		<cfset ndatefrom = dateformat(form.datefrom,"YYYYDDMM")>
	</cfif>

	
</cfif>

<cfquery name="gettodaysolditem" datasource="#dts#">
select itemno from ictran
			where type='CS' and (void = '' or void is null)
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			location >='#form.locfrom#' and location <= '#form.locto#'
			</cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
			
			<cfif form.datefrom neq "" >
			and wos_date = '#ndatefrom#' 
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno
</cfquery>


<cfset todaysolditemlist=valuelist(gettodaysolditem.itemno)>

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
	 	<Worksheet ss:Name="Cash_Sales_Report">
	 	<cfoutput>
		<Table ss:ExpandedColumnCount="18" x:FullColumns="1" x:FullRows="1">
		<Column ss:Width="64.5"/>
		<Column ss:Width="47.25"/>
		<Column ss:Width="54.75"/>
		<Column ss:Width="60.75"/>
		<Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="5"/>
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
			<Cell ss:MergeAcross="8" ss:StyleID="s22"><Data ss:Type="String">Daily Sales Qty Report</Data></Cell>
		</Row>
	  
		<cfif form.datefrom neq "" >
			<cfwddx action = "cfml2wddx" input = "DATE: #dateformat(form.datefrom,"dd/mm/yyyy")#" output = "wddxText">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
	   		</Row>
		</cfif>
        <cfif form.locfrom neq "" and form.locto neq "">
			<cfwddx action = "cfml2wddx" input = "LOCATION: #form.locfrom# - #form.locto#" output = "wddxText">
			<Row ss:AutoFitHeight="0" ss:Height="20.0625">
				<Cell ss:MergeAcross="8" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
	   		</Row>
		</cfif>
		
		<Row ss:AutoFitHeight="0" ss:Height="20.0625">
			<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
			<Cell ss:MergeAcross="7" ss:StyleID="s40"><Data ss:Type="String">#wddxText#</Data></Cell>
			<Cell ss:StyleID="s42"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
		</Row>
		<Row ss:AutoFitHeight="0" ss:Height="23.0625">
        <Cell ss:StyleID="s27"><Data ss:Type="String">Item No</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Description</Data></Cell>
            <Cell ss:StyleID="s27"><Data ss:Type="String">Last 7 Day Sales Qty</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Last 7 Day Purchase Qty</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">Today Sales Qty</Data></Cell>
			<Cell ss:StyleID="s27"><Data ss:Type="String">On Hand Qty</Data></Cell>
			
		</Row>

		<cfquery name="getcategory" datasource="#dts#">
        	select category
            from icitem
            where 0=0
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
            <cfif isdefined('form.showallitem')>
            <cfelse>
            and itemno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#todaysolditemlist#">)
            </cfif>
            group by category
             order by category
		</cfquery>

		

			<cfset totalsales = 0>
            <cfset totallastsales = 0>
            <cfset totallastpurchase = 0>
            <cfset totalonhand = 0>
			
			<cfloop query="getcategory">
            <cfquery name="getitem" datasource="#dts#">
        	select a.itemno,a.desp,
            ifnull(b.sumtotalin,0) as qtyin,
    		ifnull(c.sumtotalout,0) as qtyout,
			ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) as balance,
            ifnull(d.qty,0) as todaysales,
            ifnull(e.qty,0) as lastsales,
            ifnull(f.qty,0) as lastpurchase
            
            from icitem as a
            left join 
            (
                select itemno,sum(qty) as sumtotalin 
                from ictran 
                where type in ('RC','CN','OAI','TRIN') 
                <cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
                and fperiod<>'99'
                and (void = '' or void is null)
                group by itemno
            ) as b on a.itemno=b.itemno
            
            left join 
            (
                select itemno,sum(qty) as sumtotalout 
                from ictran 
                where type in ('INV','DO','DN','CS','OAR','PR','ISS','TROU'<cfif lcase(HcomID) eq "remo_i">,'SO'</cfif>) 
                <cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
                and fperiod<>'99'
                and (void = '' or void is null)
                and toinv='' 
                group by itemno
            ) as c on a.itemno=c.itemno
            
            left join
            (
			select sum(qty) as qty,itemno from ictran
			where type='CS' and (void = '' or void is null)
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			location >='#form.locfrom#' and location <= '#form.locto#'
			</cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
			
			and wos_date = '#ndatefrom#' 
			group by itemno
            )as d on a.itemno=d.itemno
            
            
            left join
            (
			select sum(qty) as qty,itemno from ictran
			where type='CS' and (void = '' or void is null)
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			location >='#form.locfrom#' and location <= '#form.locto#'
			</cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
			
			<cfif form.datefrom neq "" >
			and wos_date >= '#ndate7day#'  and wos_date < '#ndatefrom#' 
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno
            )as e on a.itemno=e.itemno
            
            left join
            (
			select sum(qty) as qty,itemno from ictran
			where type in ('RC','CN','OAI','TRIN')  and (void = '' or void is null)
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			location >='#form.locfrom#' and location <= '#form.locto#'
			</cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
			
			<cfif form.datefrom neq "" >
			and wos_date >= '#ndate7day#'  and wos_date < '#ndatefrom#' 
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno
            )as f on a.itemno=f.itemno
            
            
            where 0=0
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and a.itemno >='#form.itemfrom#' and a.itemno <= '#form.itemto#'
			</cfif>
            <cfif isdefined('form.showallitem')>
            <cfelse>
            and a.itemno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#todaysolditemlist#">)
            and a.category="#getcategory.category#"
            </cfif>
             order by <cfif lcase(hcomid) eq "gamemartz_i">a.desp<cfelse>a.itemno</cfif>
			</cfquery>
            <!---
            <cfwddx action = "cfml2wddx" input = "#getcategory.category#" output = "wddxText">
				<Row ss:AutoFitHeight="0">
                	<Cell ss:StyleID="s31"><Data ss:Type="String">#wddxText#</Data></Cell>
			   	</Row>--->
            
            <cfloop query="getitem">
            
            <cfwddx action = "cfml2wddx" input = "#getitem.itemno#" output = "wddxText">
            <cfwddx action = "cfml2wddx" input = "#getitem.desp#" output = "wddxText2">
				<Row ss:AutoFitHeight="0">
                	<Cell ss:StyleID="s31"><Data ss:Type="String">#wddxText#</Data></Cell>
					<Cell ss:StyleID="s31"><Data ss:Type="String">#wddxText2#</Data></Cell>
                    <Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getitem.lastsales)#</Data></Cell>
					<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getitem.lastpurchase)#</Data></Cell>
					<Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getitem.todaysales)#</Data></Cell>
                    <Cell ss:StyleID="s32"><Data ss:Type="Number">#val(getitem.balance)#</Data></Cell>
			   	</Row>
                
                <cfset totalsales = totalsales+val(getitem.todaysales)>
				<cfset totallastsales = totallastsales+val(getitem.lastsales)>
                <cfset totallastpurchase = totallastpurchase+val(getitem.lastpurchase)>
                <cfset totalonhand = totalonhand+val(getitem.balance)>
                
			</cfloop>

            </cfloop>
		<Row ss:AutoFitHeight="0" ss:Height="12"/>
	   	<Row ss:AutoFitHeight="0" ss:Height="12">
        	<Cell ss:StyleID="s36"><Data ss:Type="String"></Data></Cell>
			<Cell ss:StyleID="s36"><Data ss:Type="String">Total:</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalsales#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totallastsales#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totallastpurchase#</Data></Cell>
			<Cell ss:StyleID="s37"><Data ss:Type="Number">#totalonhand#</Data></Cell>
            
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

		<cfquery name="getcategory" datasource="#dts#">
        	select category
            from icitem
            where 0=0
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
            <cfif isdefined('form.showallitem')>
            <cfelse>
            and itemno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#todaysolditemlist#">)
            </cfif>
            group by category
             order by category
		</cfquery>

		<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="100%"><div align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Daily Sales Qty Report</strong></font></div></td>
			</tr>
			<cfif form.datefrom neq "">
				<tr>
					<td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">DATE: #dateformat(form.datefrom,"dd/mm/yyyy")#</font></div></td>
				</tr>
			</cfif>
			
			
            <cfif form.locfrom neq "" and form.locto neq "">
				<tr>
				  <td colspan="100%"><div align="center"><font size="2" face="Times New Roman, Times, serif">Location: #form.locfrom# - #form.locto#</font></div></td>
				</tr>
			</cfif>
			<tr>
				<td colspan="4"><font size="2" face="Times New Roman, Times, serif">#ndate7day# -#ndatefrom# -#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="4"><div align="right"><font size="2" face="Times New Roman, Times, serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
            	<td><font size="2" face="Times New Roman, Times, serif">Item No</font></td>
				<td><font size="2" face="Times New Roman, Times, serif">Description</font></td>
                <td><font size="2" face="Times New Roman, Times, serif"><div align="right">Last 7 Day Sales Qty</div></font></td>
				<td><div align="right"><font size="2" face="Times New Roman, Times, serif">Last 7 Day Purchase Qty</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">Today Sales Qty</font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif">On Hand Qty</font></div></td> 
			</tr>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			
            <cfset totalsales = 0>
            <cfset totallastsales = 0>
            <cfset totallastpurchase = 0>
            <cfset totalonhand = 0>

			<cfloop query="getcategory">
            
            <cfquery name="getitem" datasource="#dts#">
        	select a.itemno,a.desp,
            ifnull(b.sumtotalin,0) as qtyin,
    		ifnull(c.sumtotalout,0) as qtyout,
			ifnull(ifnull(a.qtybf,0)+ifnull(b.sumtotalin,0)-ifnull(c.sumtotalout,0),0) as balance,
            ifnull(d.qty,0) as todaysales,
            ifnull(e.qty,0) as lastsales,
            ifnull(f.qty,0) as lastpurchase
            
            from icitem as a
            left join 
            (
                select itemno,sum(qty) as sumtotalin 
                from ictran 
                where type in ('RC','CN','OAI','TRIN') 
                <cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
                and fperiod<>'99'
                and (void = '' or void is null)
                group by itemno
            ) as b on a.itemno=b.itemno
            
            left join 
            (
                select itemno,sum(qty) as sumtotalout 
                from ictran 
                where type in ('INV','DO','DN','CS','OAR','PR','ISS','TROU'<cfif lcase(HcomID) eq "remo_i">,'SO'</cfif>) 
                <cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
                and fperiod<>'99'
                and (void = '' or void is null)
                and toinv='' 
                group by itemno
            ) as c on a.itemno=c.itemno
            
            left join
            (
			select sum(qty) as qty,itemno from ictran
			where type='CS' and (void = '' or void is null)
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			location >='#form.locfrom#' and location <= '#form.locto#'
			</cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
			and wos_date = '#ndatefrom#' 
			group by itemno
            )as d on a.itemno=d.itemno
            
            
            left join
            (
			select sum(qty) as qty,itemno from ictran
			where type='CS' and (void = '' or void is null)
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			location >='#form.locfrom#' and location <= '#form.locto#'
			</cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
			
			<cfif form.datefrom neq "" >
			and wos_date >= '#ndate7day#'  and wos_date < '#ndatefrom#' 
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno
            )as e on a.itemno=e.itemno
            
            left join
            (
			select sum(qty) as qty,itemno from ictran
			where type in ('RC','CN','OAI','TRIN')  and (void = '' or void is null)
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and itemno >='#form.itemfrom#' and itemno <= '#form.itemto#'
			</cfif>
            <cfif form.locfrom neq "" and form.locto neq "">
			location >='#form.locfrom#' and location <= '#form.locto#'
			</cfif>
            <cfif form.userfrom neq "" and form.userto neq "">
			and userid >='#form.userfrom#' and userid <= '#form.userto#'
			</cfif>
			
			<cfif form.datefrom neq "" >
			and wos_date >= '#ndate7day#'  and wos_date < '#ndatefrom#' 
			<cfelse>
			and wos_date > #getgeneral.lastaccyear#
			</cfif>
			group by itemno
            )as f on a.itemno=f.itemno
            
            
            where 0=0
			<cfif form.itemfrom neq "" and form.itemto neq "">
			and a.itemno >='#form.itemfrom#' and a.itemno <= '#form.itemto#'
			</cfif>
            <cfif isdefined('form.showallitem')>
            <cfelse>
            and a.itemno in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#todaysolditemlist#">)
            and a.category="#getcategory.category#"
            </cfif>
             order by <cfif lcase(hcomid) eq "gamemartz_i">a.desp<cfelse>a.itemno</cfif>
			</cfquery>
            <!---
            <tr>
				<td colspan="100%"><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong><u>#getcategory.category#</u></strong></font></div></td>
                              
			</tr>--->
            
			<cfloop query="getitem">
                
                
					<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
						<td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.itemno#</font></div></td>
                        <td><div align="left"><font size="2" face="Times New Roman, Times, serif">#getitem.desp#</font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.lastsales#</font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.lastpurchase#</font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.todaysales#</font></div></td>
                        <td><div align="right"><font size="2" face="Times New Roman, Times, serif">#getitem.balance#</font></div></td>
								
								<cfset totalsales = totalsales+val(getitem.lastsales)>
								<cfset totallastsales = totallastsales+val(getitem.lastpurchase)>
                                <cfset totallastpurchase = totallastpurchase+val(getitem.todaysales)>
                                <cfset totalonhand = totalonhand+val(getitem.balance)>
                              
					</tr>
				</cfloop>
			<cfflush>

            </cfloop>
			<tr>
				<td colspan="100%"><hr></td>
			</tr>
			<tr>
            <td></td>
				<td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>TOTAL:</strong></font></div></td>
                <td><div align="left"><font size="2" face="Times New Roman, Times, serif"><strong>#totalsales#</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#totallastsales#</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#totallastpurchase#</strong></font></div></td>
                <td><div align="right"><font size="2" face="Times New Roman, Times, serif"><strong>#totalonhand#</strong></font></div></td>
                
			</tr>
		  </table>
		</cfoutput>

		<cfif getcategory.recordcount eq 0>
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