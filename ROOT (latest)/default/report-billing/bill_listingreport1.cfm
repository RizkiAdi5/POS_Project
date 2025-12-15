<cfif getpin2.h4G00 eq "T">
<script language="JavaScript"> 
var popup="Sorry, right-click is disabled.";
 function noway(go) { if 
(document.all) { if (event.button == 2) { alert(popup); return false; } } if (document.layers) 
{ if (go.which == 3) { alert(popup); return false; } } } if (document.layers) 
{ document.captureEvents(Event.MOUSEDOWN); } document.onmousedown=noway;
</script>
</cfif>
<cfquery name="getgeneral" datasource="#dts#">
	select * from gsetup
</cfquery>

<cfquery name="getgsetup2" datasource='#dts#'>
	select * from gsetup2
</cfquery>

<cfparam name="ndatefrom" default="">
<cfparam name="ndateto" default="">
<cfparam name="totalamt" default="0">
<cfparam name="totaldisc" default="0">
<cfparam name="totalnet" default="0">
<cfparam name="totaltax" default="0">
<cfparam name="totalgrand" default="0">
<cfparam name="totalfcamt" default="0">
<cfset tranname=''>
<cfif url.trancode eq 'INV'>
<cfset tranname = getgeneral.linv>
<cfelseif url.trancode eq 'CS'>
<cfset tranname = getgeneral.lCS>
<cfelseif url.trancode eq 'DO'>
<cfset tranname = getgeneral.lDO>
<cfelseif url.trancode eq 'PO'>
<cfset tranname = getgeneral.lPO>
<cfelseif url.trancode eq 'SO'>
<cfset tranname = getgeneral.lSO>
<cfelseif url.trancode eq 'QUO'>
<cfset tranname = getgeneral.lQUO>
<cfelseif url.trancode eq 'DN'>
<cfset tranname = getgeneral.lDN>
<cfelseif url.trancode eq 'CN'>
<cfset tranname = getgeneral.lCN>
<cfelseif url.trancode eq 'SAM'>
<cfset tranname = getgeneral.lSAM>
<cfelseif url.trancode eq 'RC'>
<cfset tranname = getgeneral.lRC>
<cfelseif url.trancode eq 'PR'>
<cfset tranname = getgeneral.lPR>
<cfelseif url.trancode eq 'TR'>
<cfset tranname = 'Transfer'>
<cfelseif url.trancode eq 'ISS'>
<cfset tranname = 'Issue'>
<cfelseif url.trancode eq 'OAI'>
<cfset tranname = 'Adjustment Increase'>
<cfelseif url.trancode eq 'OAR'>
<cfset tranname = 'Adjustment Reduce'>

</cfif>
<cfset title1 = iif(form.title eq "Customer",DE(target_arcust),DE(target_apvend))>	
	
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

<cfif isdefined('form.cbdetail') and form.result eq 'HTML'>

<cfquery datasource="#dts#" name="gettran">
	select 
	a.*
	from artran as a<cfif (form.locationfrom neq "" and form.locationto neq "") or url.trancode eq "TR" or (form.groupfrom neq "" and form.groupto neq "")>, ictran as b </cfif><cfif url.trancode eq "TR">, ictran as c</cfif>
	where 
	a.type='#url.trancode#' 
	and (a.void='' or a.void is null)
	<cfif (form.locationfrom neq "" and form.locationto neq "") or url.trancode eq "TR" or (form.groupfrom neq "" and form.groupto neq "")>
		<cfif url.trancode neq "TR">
			and a.type=b.type 
		<cfelse>
			and b.type ='TROU'
            and c.type ='TRIN'
		</cfif>
		and a.refno=b.refno
        <cfif url.trancode eq "TR">and a.refno=c.refno</cfif>
	</cfif>	
	<cfif url.trancode eq "CS" and lcase(Hcomid) eq "ovas_i" and isdefined("form.refnoprefix") and form.refnoprefix neq "">
		and a.refno like '#form.refnoprefix#%'
	</cfif>
	<cfif ndatefrom neq "" and ndateto neq "">
		and a.wos_date between '#ndatefrom#' and '#ndateto#'
	<cfelse>
    <cfif lcase(hcomid) neq "taftc_i">
		and a.wos_date > #getgeneral.lastaccyear#
    </cfif>
	</cfif>
	<cfif form.agentfrom neq "" and form.agentto neq "">
		and a.agenno between '#form.agentfrom#' and '#form.agentto#'
	</cfif>
	<cfif trim(form.getfrom) neq "" and trim(form.getto) neq "">
		and a.custno between '#form.getfrom#' and '#form.getto#'
	</cfif>
	<cfif form.periodfrom neq "" and form.periodto neq "">
		and a.fperiod between '#form.periodfrom#' and '#form.periodto#' 
	</cfif>
	<cfif form.billfrom neq "" and form.billto neq "">
		and a.refno between '#form.billfrom#' and '#form.billto#' and a.refno <> '99'
	</cfif>
    <cfif form.userfrom neq "" and form.userto neq "">
		and a.van >='#form.userfrom#' and a.van <='#form.userto#'
		</cfif>
	<cfif form.locationfrom neq "" and form.locationto neq "">
		and b.location between '#form.locationfrom#' and '#form.locationto#'
	</cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and b.wos_group between '#form.groupfrom#' and '#form.groupto#'
	</cfif>

    <cfif form.Daddressfrom neq "" and form.Daddressto neq "">
			and a.rem1 between "#form.Daddressfrom#" and "#form.Daddressto#"
	</cfif> 
    <cfif form.projectfrom neq "" and form.projectto neq "">
			and a.source between "#form.projectfrom#" and "#form.projectto#"
	</cfif> 
	<cfif form.jobfrom neq "" and form.jobto neq "">
    and a.job between "#form.jobfrom#" and "#form.jobto#"
    </cfif>
    <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(a.agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(a.agenno)='#ucase(huserid)#')  
			</cfif>
		<cfelse>
        <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i") and (HUserGrpID neq 'Cust Svr' and HUserGrpID neq 'Van Sales')>
        <cfelse>
			<cfif Huserloc neq "All_loc">
				and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
        </cfif>
		</cfif>
        <cfif url.trancode eq "TR">
    <cfif form.trfrom neq "" and form.trto neq "">
    and b.location = "#form.trfrom#" and c.location ="#form.trto#"
    </cfif>
    </cfif>
    group by a.refno
	order by a.custno,a.refno
</cfquery>

<cfelseif form.result eq 'PDF'>

<cfquery datasource="#dts#" name="gettran">
	select 
	a.*,d.custno,d.add1,d.add2,d.add3,d.add4,d.name2
	from artran as a<cfif (form.locationfrom neq "" and form.locationto neq "") or url.trancode eq "TR" or (form.groupfrom neq "" and form.groupto neq "")>, ictran as b </cfif><cfif url.trancode eq "TR">, ictran as c</cfif>,<cfif form.title eq 'Customer'>#target_arcust# as d<cfelse>#target_apvend# as d</cfif>
	where 
    d.custno=a.custno and
	a.type='#url.trancode#' 
	and (a.void='' or a.void is null)
	<cfif (form.locationfrom neq "" and form.locationto neq "") or url.trancode eq "TR" or (form.groupfrom neq "" and form.groupto neq "")>
		<cfif url.trancode neq "TR">
			and a.type=b.type 
		<cfelse>
			and b.type ='TROU'
            and c.type ='TRIN'
		</cfif>
		and a.refno=b.refno
        <cfif url.trancode eq "TR">and a.refno=c.refno</cfif>
	</cfif>	
	<cfif url.trancode eq "CS" and lcase(Hcomid) eq "ovas_i" and isdefined("form.refnoprefix") and form.refnoprefix neq "">
		and a.refno like '#form.refnoprefix#%'
	</cfif>
	<cfif ndatefrom neq "" and ndateto neq "">
		and a.wos_date between '#ndatefrom#' and '#ndateto#'
	<cfelse>
    <cfif lcase(hcomid) neq "taftc_i">
		and a.wos_date > #getgeneral.lastaccyear#
    </cfif>
		
	</cfif>
	<cfif form.agentfrom neq "" and form.agentto neq "">
		and a.agenno between '#form.agentfrom#' and '#form.agentto#'
	</cfif>
	<cfif trim(form.getfrom) neq "" and trim(form.getto) neq "">
		and a.custno between '#form.getfrom#' and '#form.getto#'
	</cfif>
	<cfif form.periodfrom neq "" and form.periodto neq "">
		and a.fperiod between '#form.periodfrom#' and '#form.periodto#' 
	</cfif>
	<cfif form.billfrom neq "" and form.billto neq "">
		and a.refno between '#form.billfrom#' and '#form.billto#' and a.refno <> '99'
	</cfif>
    <cfif form.userfrom neq "" and form.userto neq "">
		and a.van >='#form.userfrom#' and a.van <='#form.userto#'
		</cfif>
	<cfif form.locationfrom neq "" and form.locationto neq "">
		and b.location between '#form.locationfrom#' and '#form.locationto#'
	</cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and b.wos_group between '#form.groupfrom#' and '#form.groupto#'
	</cfif>

    <cfif form.Daddressfrom neq "" and form.Daddressto neq "">
			and a.rem1 between "#form.Daddressfrom#" and "#form.Daddressto#"
	</cfif> 
    <cfif form.projectfrom neq "" and form.projectto neq "">
			and a.source between "#form.projectfrom#" and "#form.projectto#"
	</cfif> 
	<cfif form.jobfrom neq "" and form.jobto neq "">
    and a.job between "#form.jobfrom#" and "#form.jobto#"
    </cfif>
    <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(a.agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(a.agenno)='#ucase(huserid)#')  
			</cfif>
		<cfelse>
        <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i") and (HUserGrpID neq 'Cust Svr' and HUserGrpID neq 'Van Sales')>
        <cfelse>
			<cfif Huserloc neq "All_loc">
				and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
        </cfif>
		</cfif>
        <cfif url.trancode eq "TR">
    <cfif form.trfrom neq "" and form.trto neq "">
    and b.location = "#form.trfrom#" and c.location ="#form.trto#"
    </cfif>
    </cfif>
	group by a.type,a.refno
	order by a.refno
</cfquery>


<cfelse>

<cfquery datasource="#dts#" name="gettran">
	select 
	a.*
	from artran as a<cfif (form.locationfrom neq "" and form.locationto neq "") or url.trancode eq "TR" or (form.groupfrom neq "" and form.groupto neq "")>, ictran as b </cfif><cfif url.trancode eq "TR">, ictran as c</cfif>
	where 
	a.type='#url.trancode#' 
	and (a.void='' or a.void is null)
	<cfif (form.locationfrom neq "" and form.locationto neq "") or url.trancode eq "TR" or (form.groupfrom neq "" and form.groupto neq "")>
		<cfif url.trancode neq "TR">
			and a.type=b.type 
		<cfelse>
			and b.type ='TROU'
            and c.type ='TRIN'
		</cfif>
		and a.refno=b.refno
        <cfif url.trancode eq "TR">and a.refno=c.refno</cfif>
	</cfif>	
	<cfif url.trancode eq "CS" and lcase(Hcomid) eq "ovas_i" and isdefined("form.refnoprefix") and form.refnoprefix neq "">
		and a.refno like '#form.refnoprefix#%'
	</cfif>
	<cfif ndatefrom neq "" and ndateto neq "">
		and a.wos_date between '#ndatefrom#' and '#ndateto#'
	<cfelse>
		<cfif lcase(hcomid) neq "taftc_i">
		and a.wos_date > #getgeneral.lastaccyear#
    </cfif>
	</cfif>
	<cfif form.agentfrom neq "" and form.agentto neq "">
		and a.agenno between '#form.agentfrom#' and '#form.agentto#'
	</cfif>
	<cfif trim(form.getfrom) neq "" and trim(form.getto) neq "">
		and a.custno between '#form.getfrom#' and '#form.getto#'
	</cfif>
	<cfif form.periodfrom neq "" and form.periodto neq "">
		and a.fperiod between '#form.periodfrom#' and '#form.periodto#' 
	</cfif>
	<cfif form.billfrom neq "" and form.billto neq "">
		and a.refno between '#form.billfrom#' and '#form.billto#' and a.refno <> '99'
	</cfif>
    <cfif form.userfrom neq "" and form.userto neq "">
		and a.van >='#form.userfrom#' and a.van <='#form.userto#'
		</cfif>
	<cfif form.locationfrom neq "" and form.locationto neq "">
		and b.location between '#form.locationfrom#' and '#form.locationto#'
	</cfif>
	<cfif trim(form.groupfrom) neq "" and trim(form.groupto) neq "">
		and b.wos_group between '#form.groupfrom#' and '#form.groupto#'
	</cfif>

    <cfif form.Daddressfrom neq "" and form.Daddressto neq "">
			and a.rem1 between "#form.Daddressfrom#" and "#form.Daddressto#"
	</cfif> 
    <cfif form.projectfrom neq "" and form.projectto neq "">
			and a.source between "#form.projectfrom#" and "#form.projectto#"
	</cfif> 
	<cfif form.jobfrom neq "" and form.jobto neq "">
    and a.job between "#form.jobfrom#" and "#form.jobto#"
    </cfif>
    <cfif url.alown eq 1>
			<cfif getgeneral.agentlistuserid eq "Y">and ucase(a.agenno) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
			<cfelse>
            and (ucase(userid)='#ucase(huserid)#' or ucase(a.agenno)='#ucase(huserid)#')  
			</cfif>
		<cfelse>
        <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i") and (HUserGrpID neq 'Cust Svr' and HUserGrpID neq 'Van Sales')>
        <cfelse>
			<cfif Huserloc neq "All_loc">
				and (userid in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
			</cfif>
        </cfif>
		</cfif>
        <cfif url.trancode eq "TR">
    <cfif form.trfrom neq "" and form.trto neq "">
    and b.location = "#form.trfrom#" and c.location ="#form.trto#"
    </cfif>
    </cfif>
	group by a.type,a.refno
	order by a.refno
</cfquery>


</cfif>
<cfswitch expression="#form.result#">
	<cfcase value="EXCELDEFAULT">
		<cfset iDecl_UPrice=getgsetup2.Decl_UPrice>
		<cfset stDecl_UPrice="">
		<cfset stDecl_UPrice2 = ",.">
		
		<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
			<cfset stDecl_UPrice=stDecl_UPrice&"0">
			<cfset stDecl_UPrice2 = stDecl_UPrice2 & "_">
		</cfloop>
	
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
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
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
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  		</Style>
		  		<Style ss:ID="s38">
		   			<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1"/>
		  		</Style>
		  		<Style ss:ID="s39">
		   			<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>
		   			</Borders>
		   			<NumberFormat ss:Format="#,###,###,##0.<cfoutput>#trim(stDecl_UPrice)#</cfoutput>"/>
		  		</Style>
		  		<Style ss:ID="s41">
		   			<Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
		   			<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="9" ss:Bold="1" ss:Underline="Single"/>
		  		</Style>
		 	</Styles>
			
			<Worksheet ss:Name="Bills Listing">
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
					<cfset c="9">
					<cfif lcase(HcomID) eq "topsteel_i" or lcase(Hcomid) eq "topsteelhol_i">
						<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
						<cfset c=c+1>
					</cfif>
		   
					<cfwddx action = "cfml2wddx" input = "#url.type# Listing Report" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="#c#" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
					</Row>
			
					<cfif form.billfrom neq "" and form.billto neq "">
						<cfwddx action = "cfml2wddx" input = "Ref No From #form.billfrom# To #form.billto#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
			
					<cfif ndatefrom neq "" and ndateto neq "">
						<cfwddx action = "cfml2wddx" input = "#form.datefrom# - #form.dateto#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
			
					<cfif form.periodfrom neq "" and form.periodto neq "">
						<cfwddx action = "cfml2wddx" input = "Period From #form.periodfrom# To #form.periodto#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
			
					<cfif form.agentfrom neq "" and form.agentto neq "">
						<cfwddx action = "cfml2wddx" input = "#getgeneral.lAGENT# From #form.agentfrom# To #form.agentto#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
					
					<cfif form.locationfrom neq "" and form.locationto neq "">
						<cfwddx action = "cfml2wddx" input = "Location From #form.locationfrom# To #form.locationto#" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>
					</cfif>
					
					<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
			
					<Row ss:AutoFitHeight="0" ss:Height="20.0625">
						<Cell ss:MergeAcross="#c-1#" ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
					</Row>
				</cfoutput>
		
				<Row ss:AutoFitHeight="0" ss:Height="23.0625">
					<Cell ss:StyleID="s27"><Data ss:Type="String">Refno</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Date</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Cust./Supp.</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Name</Data></Cell>
                    <cfif isdefined('form.checkbox1')>
                	<Cell ss:StyleID="s27"><Data ss:Type="String">Ref No 2</Data></Cell>
                </cfif>
                <cfif isdefined('form.checkbox2')>
                <Cell ss:StyleID="s27"><Data ss:Type="String">Status</Data></Cell>
                </cfif>
               <cfif isdefined('form.checkbox3')>
               <Cell ss:StyleID="s27"><Data ss:Type="String">PO/SO NO</Data></Cell>
                <cfif isdefined('form.checkbox4')>
                <Cell ss:StyleID="s27"><Data ss:Type="String">DO NO</Data></Cell>
                </cfif>
                </cfif>
                    
					<Cell ss:StyleID="s27"><Data ss:Type="String">Amount</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Discount</Data></Cell>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">Net</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Tax</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Grand Local</Data></Cell>
					<cfif lcase(HcomID) eq "mhca_i"><Cell ss:StyleID="s27"><Data ss:Type="String">Currency Rate</Data></Cell></cfif>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Grand Foreign</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">
						<cfif url.trancode eq "CS" and lcase(Hcomid) eq "ovas_i">
							Agent
						<cfelse>
							Created By
						</cfif>
					</Data></Cell>
					<cfif lcase(HcomID) eq "topsteel_i" or lcase(Hcomid) eq "topsteelhol_i">
						<Cell ss:StyleID="s27"><Data ss:Type="String">Agent</Data></Cell>
					</cfif>
				</Row>
				   
				<cfoutput query="gettran">
					<cfif currrate neq "">
						<cfset xcurrrate = currrate>
					<cfelse>
						<cfset xcurrrate = 1>
					</cfif>
					
					<cfquery datasource="#dts#" name="getcust">
						Select name, currcode from #title1# where custno='#custno#'
					</cfquery>
					
					<cfwddx action = "cfml2wddx" input = "#gettran.refno#" output = "wddxText">
					<cfwddx action = "cfml2wddx" input = "#custno#" output = "wddxText2">
					<cfwddx action = "cfml2wddx" input = "#name#" output = "wddxText3">
					<cfif url.trancode eq "CS" and lcase(Hcomid) eq "ovas_i">
						<cfwddx action = "cfml2wddx" input = "#agenno#" output = "wddxText4">
					<cfelse>
						<cfwddx action = "cfml2wddx" input = "#userid#" output = "wddxText4">
					</cfif>
					<cfif lcase(HcomID) eq "topsteel_i" or lcase(Hcomid) eq "topsteelhol_i">
						<cfwddx action = "cfml2wddx" input = "#agenno#" output = "wddxText5">
					</cfif>
                    <cfwddx action = "cfml2wddx" input = "#gettran.refno2#" output = "wddxText6">
                    <cfwddx action = "cfml2wddx" input = "#gettran.PONO#" output = "wddxText7">
                    <cfwddx action = "cfml2wddx" input = "#gettran.DONO#" output = "wddxText8">
                    
					
					<cfif url.trancode neq "TR">
						<cfset xamt = val(gettran.invgross)>
						<cfset xdisc = val(gettran.discount)>
                        <cfif gettran.taxincl eq 'T'>
                        <cfset xnet = val(gettran.net)-val(gettran.tax)>
                        <cfelse>
                        <cfset xnet = val(gettran.net)>
                        </cfif>
						<cfset xtax = val(gettran.tax)>
						<cfset xgrand = val(gettran.grand)>
					<cfelse>
						<cfset xamt = val(gettran.invgross) / 2>
						<cfset xdisc = val(gettran.discount) / 2>
                        <cfset xnet = val(gettran.net) / 2>
						<cfset xtax = val(gettran.tax) / 2>
						<cfset xgrand = val(gettran.grand) / 2>
					</cfif>
					
						
					<Row ss:AutoFitHeight="0">
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#dateformat(wos_date,"dd-mm-yy")#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText2#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText3#</Data></Cell>
                        
						<cfif isdefined('form.checkbox1')>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText6#</Data></Cell>
                </cfif>
                 <cfif isdefined('form.checkbox2')>
                <Cell ss:StyleID="s32"><Data ss:Type="String"><cfif toinv neq ''>Y</cfif>
			<cfif posted neq ''>P</cfif>
			<cfif void neq ''><font color="red"><strong>Void</strong></font></cfif></Data></Cell>
                </cfif>


						<cfif isdefined('form.checkbox3')>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText7#</Data></Cell>
                    <cfif isdefined('form.checkbox4')>
                    <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText8#</Data></Cell>
                    </cfif>
                    </cfif>
						
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#numberformat(xamt,",.__")#</Data></Cell>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#numberformat(xdisc,",.__")#</Data></Cell>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#numberformat(xnet,",.__")#</Data></Cell>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#numberformat(xtax,",.__")#</Data></Cell>
						<Cell ss:StyleID="s33"><Data ss:Type="Number">#numberformat(xgrand,",.__")#</Data></Cell>
						<cfif lcase(HcomID) eq "mhca_i"><Cell ss:StyleID="s33"><Data ss:Type="Number">#numberformat(xcurrrate,",.______")#</Data></Cell></cfif>
						
						<cfif xcurrrate eq "1">
							<Cell ss:StyleID="s31"><Data ss:Type="String">-</Data></Cell>
						<cfelse>
							<cfif gettran.grand_bil neq "">
								<cfif url.trancode neq "TR">
									<cfset xfcamt = val(gettran.grand_bil)>
								<cfelse>
									<cfset xfcamt = val(gettran.grand_bil) / 2>
								</cfif>
								
							</cfif>
							<cfwddx action = "cfml2wddx" input = "#getcust.currcode# #numberformat(xfcamt,stDecl_UPrice2)#" output = "wddxText3">
							<Cell ss:StyleID="s31"><Data ss:Type="String">#wddxText3#</Data></Cell>
							<cfset totalfcamt = totalfcamt + xfcamt>
						</cfif>
						
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText4#</Data></Cell>
						<cfif lcase(HcomID) eq "topsteel_i" or lcase(Hcomid) eq "topsteelhol_i">
							<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText5#</Data></Cell>
						</cfif>
					</Row>
					<cfset totalamt = totalamt + numberformat(xamt,".__")>				
				<cfset totaldisc = totaldisc + numberformat(xdisc,".__")>
                <cfset totalnet = totalnet + numberformat(xnet,".__")>
				<cfset totaltax = totaltax + numberformat(xtax,".__")>
				<cfset totalgrand = totalgrand + numberformat(xgrand,".__")>
				</cfoutput>
		
				<Row ss:AutoFitHeight="0" ss:Height="12"/>
				
				<cfoutput>
				<Row ss:AutoFitHeight="0" ss:Height="12">
					<Cell ss:StyleID="s38"><Data ss:Type="String">Grand Total</Data></Cell>
                    <Cell ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
                    <Cell ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
                    <Cell ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
                    <cfif isdefined('form.checkbox1')>
                    <Cell ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
                    </cfif>
                    <cfif isdefined('form.checkbox2')>
                    <Cell ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
                    </cfif>
                    <cfif isdefined('form.checkbox3')>
                    <Cell ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
                    </cfif>
                    <cfif isdefined('form.checkbox4')>
                    <Cell ss:StyleID="s38"><Data ss:Type="String"></Data></Cell>
                    </cfif>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(totalamt,",.__")#</Data></Cell>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(totaldisc,",.__")#</Data></Cell>
                    <Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(totalnet,",.__")#</Data></Cell>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(totaltax,",.__")#</Data></Cell>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(totalgrand,",.__")#</Data></Cell>
					<cfif lcase(HcomID) eq "mhca_i"><Cell ss:StyleID="s39"></Cell></cfif>
					<Cell ss:StyleID="s39"><Data ss:Type="Number">#numberformat(totalfcamt,",.__")#</Data></Cell>
					<Cell ss:StyleID="s38"/>
					<cfif lcase(HcomID) eq "topsteel_i" or lcase(Hcomid) eq "topsteelhol_i"><Cell ss:StyleID="s38"/></cfif>
				</Row>
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

		<cffile action="write" nameconflict="overwrite" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls" output="#tostring(data)#">
		<cfcontent type="application/vnd.ms-excel" deletefile="yes" file="#HRootPath#\Excel_Report\#dts#_BL_#huserid#.xls">
	</cfcase>

<!--- PDF report---->

	<cfcase value="PDF">
    
	<cfreport template="reportbilling.cfr" format="PDF" query="gettran" report="reportbilling.cfr"><!--- or "FlashPaper" or "Excel" or "RTF" --->
	<cfreportparam name="compro" value="#getgeneral.compro#">
	<cfreportparam name="compro2" value="#getgeneral.compro2#">
	<cfreportparam name="compro3" value="#getgeneral.compro3#">
	<cfreportparam name="compro4" value="#getgeneral.compro4#">
	<cfreportparam name="compro5" value="#getgeneral.compro5#">
	<cfreportparam name="compro6" value="#getgeneral.compro6#">
	<cfreportparam name="compro7" value="#getgeneral.compro7#">
    <cfreportparam name="title" value="#title#">
    <cfreportparam name="periodfrom" value="#periodfrom#">
    <cfreportparam name="periodto" value="#periodto#">
    <cfreportparam name="datefrom" value="#ndatefrom#">
    <cfreportparam name="dateto" value="#ndateto#">
    <cfreportparam name="dts" value="#dts#">
    <cfreportparam name="custfrom" value="#form.getfrom#">
    <cfreportparam name="custto" value="#form.getto#">
    <cfreportparam name="gstno" value="#getgeneral.gstno#">
    <cfreportparam name="tranname" value="#tranname#">
    
    
</cfreport>

	</cfcase>

<!---- End PDF report --->



	<cfcase value="HTML">
		<cfset iDecl_UPrice = getgsetup2.Decl_UPrice>
		<cfset stDecl_UPrice = ",.">
		
		<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
			<cfset stDecl_UPrice = stDecl_UPrice & "_">
		</cfloop>
		
		
        <cfif isdefined('form.cbdetail')>
        
        <html>
        
		<head>
			<title>View Bill Listing Report</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href = "../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
			<style type="text/css" media="print">
				.noprint { display: none; }
			</style>
		</head>

		<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>
		
		<table align="center" cellpadding="3" cellspacing="0" width="100%">
		<cfoutput>
			<tr>
				<td colspan="11"><div align="center"><font size="3" face="Arial, Helvetica, sans-serif"><strong>#url.type# Listing Report</strong></font></div></td>
			</tr>
			<cfif form.billfrom neq "" and form.billto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Ref No From #form.billfrom# To #form.billto#</font></div></td>
				</tr>
			</cfif>
			<cfif ndatefrom neq "" and ndateto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">#form.datefrom# - #form.dateto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Period From #form.periodfrom# To #form.periodto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">#getgeneral.lAGENT# From #form.agentfrom# To #form.agentto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.locationfrom neq "" and form.locationto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Location From #form.locationfrom# To #form.locationto#</font></div></td>
				</tr>
			</cfif>
             <cfif form.projectfrom neq "" and form.projectto neq "">
			<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Project From #form.projectfrom# To #form.projectto#</font></div></td>
				</tr>
	</cfif> 
	<cfif form.jobfrom neq "" and form.jobto neq "">
    <tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Job From #form.Jobfrom# To #form.Jobto#</font></div></td>
				</tr>

    </cfif>
    <cfif form.userfrom neq "" and form.userto neq "">
	 <tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">#getgeneral.lDriver# From #form.userfrom# To #form.userto#</font></div></td>
				</tr>
		</cfif>
        <cfif form.Daddressfrom neq "" and form.Daddressto neq "">
	 <tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Delivery Address Code From #form.Daddressfrom# To #form.Daddressto#</font></div></td>
				</tr>
		</cfif>
        
        
			<tr>
				<td colspan="4"><font size="1.5" face="Arial, Helvetica, sans-serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="5"><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
		</cfoutput>
			<tr>
				<td colspan="<cfif lcase(HcomID) eq "mphcranes_i" or trancode eq "RC" or trancode eq "INV">15<cfelse><cfif url.trancode neq "TR"><cfif isdefined('form.checkbox1')>12
                <cfelse>11</cfif><cfelse>13</cfif></cfif>"><hr></td>
			</tr>
			<tr>
				<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Account No.<br>Invoice No.</strong></font></div></td>
				<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Account Name.<br>Date</strong></font></div></td>
                <cfif isdefined('form.checkbox3')>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>PO/SO NO</strong></font></div></td>
                
                <cfif isdefined('form.checkbox4')>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>DO NO</strong></font></div></td>
                </cfif>
                </cfif>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Product No</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Product Name</strong></font></div></td>
                <cfif isdefined('form.cbdetail') and form.result eq 'HTML'>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Location</strong></font></div></td>
                </cfif>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Qty</strong></font></div></td>
                <td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>GST</strong></font></div></td>
                <td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Price</strong></font></div></td>
                <td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Disc %</strong></font></div></td>
                 <td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Amount</strong></font></div></td>
			</tr>
			<tr>
				<td colspan="<cfif lcase(HcomID) eq "mphcranes_i" or trancode eq "RC" or trancode eq "INV">15<cfelse><cfif url.trancode neq "TR"><cfif isdefined('form.checkbox1')>12
                <cfelse>11</cfif><cfelse>13</cfif></cfif>"><hr></td>
			</tr>
			<cfset count=1>
			<cfoutput query="gettran">
				<cfif currrate neq "">
					<cfset xcurrrate = currrate>
				<cfelse>
					<cfset xcurrrate = 1>
				</cfif>
		
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
               
					<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">
                    #gettran.custno#</font></div></td>
					<cfquery datasource="#dts#" name="getcust">
						Select name, currcode from #title1# where custno='#custno#'
					</cfquery>
					<td colspan="3" nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#name#</font></div></td>
				</tr>
                
                <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
               
					<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">
                    #gettran.refno#</font></div></td>
					<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#dateformat(gettran.wos_date,'dd-mm-yyyy')#</font></div></td>
                     <cfif isdefined('form.checkbox3')>
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#gettran.PONO#</font></div></td>
                   
                    
                    <cfif isdefined('form.checkbox4')>
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#gettran.DONO#</font></div></td>
                   
                    </cfif>
                    </cfif>
				</tr>
                <cfquery name="getbodydetail" datasource="#dts#">
                select * from ictran where refno='#gettran.refno#' and type='#gettran.type#'
                </cfquery>
				<cfloop query="getbodydetail">
                
                <tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
               <cfif isdefined('form.checkbox3')>
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"></font></div></td>
                   
                    
                    <cfif isdefined('form.checkbox4')>
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"></font></div></td>
                    </cfif></cfif>
				<td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">
                    </font></div></td>
                <td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">
                    </font></div></td>
                    <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i")>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#getbodydetail.itemno#</font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#getbodydetail.desp#</font></div></td>
                <cfelse>
				<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#getbodydetail.itemno#</font></div></td>
                
                <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#getbodydetail.desp#</font></div></td>
                </cfif>
                <cfif isdefined('form.cbdetail') and form.result eq 'HTML'>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#getbodydetail.location#</font></div></td>
                </cfif>
                <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#getbodydetail.qty#</font></div></td>
                <td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(getbodydetail.taxpec1,'.__')#</font></div></td>
                 <td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">
                 #numberformat(getbodydetail.price,',_.__')#</font></div></td>
                  <td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(getbodydetail.dispec1,'.__')#</font></div></td>
                  <td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(getbodydetail.amt,',_.__')#</font></div></td>
				</tr>
                </cfloop>
                <tr>
                <td colspan="6">
                <cfif isdefined('form.checkbox3')>
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"></font></div></td>
                   
                    
                    <cfif isdefined('form.checkbox4')>
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"></font></div></td>
                    </cfif></cfif>
                 <cfif isdefined('form.cbdetail') and form.result eq 'HTML'>
                 
                 <td></td>
                 </cfif>
                <td colspan="2"><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">Total Discount</font></div></td>
                <td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(gettran.discount,',_.__')#</font></div></td>
                </tr>
                
                <tr>
                <td colspan="10">
                 <cfif isdefined('form.cbdetail') and form.result eq 'HTML'>
                 <td></td>
                 </cfif>
                <td nowrap><hr></td>
                </tr>
                
                <tr>
                <td colspan="10">
                 <cfif isdefined('form.cbdetail') and form.result eq 'HTML'>
                 <td></td>
                 </cfif>
                <td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(gettran.net_bil,',_.__')#</font></div></td>
                </tr>
                
                <tr>
                <td colspan="8">
                <cfif isdefined('form.cbdetail') and form.result eq 'HTML'>
                 <td></td>
                 </cfif>
                <td colspan="2"><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">GST</font></div></td>
                <td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(gettran.tax,',_.__')#</font></div></td>
                </tr>
                <tr>
                <td colspan="10">
                <cfif isdefined('form.cbdetail') and form.result eq 'HTML'>
                 <td></td>
                 </cfif>
                <td nowrap><hr></td>
                </tr>
                 <tr>
                <td colspan="10">
                <cfif isdefined('form.cbdetail') and form.result eq 'HTML'>
                 <td></td>
                 </cfif>
                <td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><b>#numberformat(gettran.grand_bil,',_.__')#</b></font></div></td>
                </tr>
                <tr>
                <td colspan="10">
                <cfif isdefined('form.cbdetail') and form.result eq 'HTML'>
                 <td></td>
                 </cfif>
                <td nowrap><hr></td>
                </tr>
                 <tr>
                <tr><td></td></tr>
			</cfoutput>
			
		</table>
		
		<br><br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>
		</html>
        
        <cfelse>
        
        <html>
		<head>
			<title>View Bill Listing Report</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href = "../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
			<style type="text/css" media="print">
				.noprint { display: none; }
			</style>
		</head>

		<body <cfif getpin2.h4G00 eq "T">onBeforePrint="document.body.style.display = 'none';" onAfterPrint="document.body.style.display = '';"</cfif>>
		
		<table align="center" cellpadding="3" cellspacing="0" width="100%">
		<cfoutput>
			<tr>
				<td colspan="11"><div align="center"><font size="3" face="Arial, Helvetica, sans-serif"><strong>#url.type# Listing Report</strong></font></div></td>
			</tr>
			<cfif form.billfrom neq "" and form.billto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Ref No From #form.billfrom# To #form.billto#</font></div></td>
				</tr>
			</cfif>
			<cfif ndatefrom neq "" and ndateto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">#form.datefrom# - #form.dateto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.periodfrom neq "" and form.periodto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Period From #form.periodfrom# To #form.periodto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.agentfrom neq "" and form.agentto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">#getgeneral.lAGENT# From #form.agentfrom# To #form.agentto#</font></div></td>
				</tr>
			</cfif>
			<cfif form.locationfrom neq "" and form.locationto neq "">
				<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Location From #form.locationfrom# To #form.locationto#</font></div></td>
				</tr>
			</cfif>
             <cfif form.projectfrom neq "" and form.projectto neq "">
			<tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Project From #form.projectfrom# To #form.projectto#</font></div></td>
				</tr>
	</cfif> 
	<cfif form.jobfrom neq "" and form.jobto neq "">
    <tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Job From #form.Jobfrom# To #form.Jobto#</font></div></td>
				</tr>

    </cfif>
    <cfif form.userfrom neq "" and form.userto neq "">
	 <tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">#getgeneral.lDriver# From #form.userfrom# To #form.userto#</font></div></td>
				</tr>
		</cfif>
        <cfif form.Daddressfrom neq "" and form.Daddressto neq "">
	 <tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Delivery Address Code From #form.Daddressfrom# To #form.Daddressto#</font></div></td>
				</tr>
		</cfif>
        <cfif form.getfrom neq "" and form.getto neq "">
	 <tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Customer From #form.getfrom# To #form.getto#</font></div></td>
				</tr>
		</cfif>
        <cfif form.getfrom eq form.getto>
        <cfif form.title eq "Customer">
        <cfquery name="getcustadd" datasource="#dts#">
        select * from #target_arcust# where custno='#form.getfrom#'
        </cfquery>
        <cfelse>
        <cfquery name="getcustadd" datasource="#dts#">
        select * from #target_apvend# where custno='#form.getfrom#'
        </cfquery>
        </cfif>
	 <tr>
					<td colspan="11"><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">Address : #getcustadd.add1# #getcustadd.add2# #getcustadd.add3# #getcustadd.add4#</font></div></td>
				</tr>
		</cfif>
			<tr>
				<td colspan="4"><font size="1.5" face="Arial, Helvetica, sans-serif">#getgeneral.compro#</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="5"><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#dateformat(now(),"dd/mm/yyyy")#</font></div></td>
			</tr>
		</cfoutput>
			<tr>
				<td colspan="<cfif lcase(HcomID) eq "mphcranes_i" or trancode eq "RC" or trancode eq "INV">15<cfelse><cfif url.trancode neq "TR"><cfif isdefined('form.checkbox1')>12
                <cfelse>11</cfif><cfelse>13</cfif></cfif>"><hr></td>
			</tr>
			<tr>
            	<cfif lcase(HcomID) eq "winbells_i">
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>No</strong></font></div></td>
                </cfif>
				<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Refno</strong></font></div></td>
                <cfif isdefined('form.checkbox1')>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Refno 2</strong></font></div></td>
                </cfif>
                <cfif isdefined('form.checkbox2')>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Status</strong></font></div></td>
                </cfif>
                <cfif lcase(HcomID) eq "mphcranes_i">
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Project No</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong><cfif url.trancode eq 'INV'>Service Report No.<cfelse>Refno 2</cfif></strong></font></div></td>
                </cfif>
                
                <cfif isdefined('form.checkbox3')>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>PO/SO NO</strong></font></div></td>
                
                <cfif isdefined('form.checkbox4')>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>DO NO</strong></font></div></td>
                </cfif>
                </cfif>
				<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Date</strong></font></div></td>
				<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Cust No</strong></font></div></td>
				<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Name</strong></font></div></td>
                <cfif lcase(HcomID) eq "pengwang_i" or lcase(HcomID) eq "pingwang_i" or lcase(HcomID) eq "huanhong_i" or lcase(HcomID) eq "prawn_i">
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Salesman</strong></font></div></td>
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Driver</strong></font></div></td>
                </cfif>
                <cfif url.trancode eq "TR">
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Transfer From</strong></font></div></td>
				<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Transfer To</strong></font></div></td>
				</cfif>
				<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Amount</strong></font></div></td>
				<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Discount</strong></font></div></td>
                <td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>NET</strong></font></div></td>
				<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Tax</strong></font></div></td>
				<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Grand Local</strong></font></div></td>
				<cfif lcase(HcomID) eq "mhca_i" or lcase(HcomID) eq "bestform_i"><td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Currency Rate</strong></font></div></td></cfif>
                <cfif lcase(HcomID) eq "bestform_i"><td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Currency Code</strong></font></div></td></cfif>
				<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Grand Foreign</strong></font></div></td>
				<td><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>
					<cfif url.trancode eq "CS" and lcase(Hcomid) eq "ovas_i">
						Agent
					<cfelse>
						Created By
					</cfif>
					</strong></font></div>
				</td>
				<cfif lcase(Hcomid) eq "topsteel_i" or lcase(Hcomid) eq "topsteelhol_i">
					<td><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Agent</strong></font></div></td>
				</cfif>
			</tr>
			<tr>
				<td colspan="<cfif lcase(HcomID) eq "mphcranes_i" or trancode eq "RC" or trancode eq "INV">15<cfelse><cfif url.trancode neq "TR"><cfif isdefined('form.checkbox1')>12
                <cfelse>11</cfif><cfelse>13</cfif></cfif>"><hr></td>
			</tr>
			<cfset count=1>
			<cfoutput query="gettran">
				<cfif currrate neq "">
					<cfset xcurrrate = currrate>
				<cfelse>
					<cfset xcurrrate = 1>
				</cfif>
		
				<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
                <cfif lcase(HcomID) eq "winbells_i">
                <td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#count#</strong></font></div></td>
                </cfif>
					<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">
					<cfif url.trancode eq "rc" or url.trancode eq "DO" or url.trancode eq "INV" or url.trancode eq "CS" or url.trancode eq "QUO" or url.trancode eq "PO" or url.trancode eq "CN" or url.trancode eq "DN" or url.trancode eq "PR" or url.trancode eq "SAM">
                    <a href="bill_listingreport2.cfm?type=#url.trancode#&refno=#gettran.refno#">#gettran.refno#</a>
					<cfelse>
                    #gettran.refno#
					</cfif></font></div></td>
                     <cfif isdefined('form.checkbox1')>
                <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#gettran.refno2#</font></div></td>
                </cfif>
                 <cfif isdefined('form.checkbox2')>
                <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">
                <cfif toinv neq ''>Y</cfif>
			<cfif posted neq ''>P</cfif>
			<cfif void neq ''><font color="red"><strong>Void</strong></font></cfif>
                </font></div></td>
                </cfif>
                    <cfif lcase(HcomID) eq "mphcranes_i">
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#source#</font></div></td>
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif"><cfif url.trancode eq 'INV'>#rem6#<cfelse>#refno2#</cfif></font></div></td>
                    </cfif>
                    
                    <cfif isdefined('form.checkbox3')>
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#gettran.PONO#</font></div></td>
                   
                    
                    <cfif isdefined('form.checkbox4')>
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#gettran.DONO#</font></div></td>
                   
                    </cfif>
                    </cfif>
					<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#dateformat(wos_date,"dd-mm-yy")#</font></div></td>
					<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#custno#</font></div></td>
					<cfquery datasource="#dts#" name="getcust">
						Select name, currcode from #title1# where custno='#custno#'
					</cfquery>
					<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#name#</font></div></td>
                    <cfif lcase(HcomID) eq "pengwang_i" or lcase(HcomID) eq "pingwang_i" or lcase(HcomID) eq "huanhong_i" or lcase(HcomID) eq "prawn_i">
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#agenno#</font></div></td>
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#van#</font></div></td>
                    </cfif>
		
					<cfif url.trancode neq "TR">
						<cfset xamt = val(gettran.invgross)>
						<cfset xdisc = val(gettran.discount)>
                        <cfif gettran.taxincl eq 'T'>
                        <cfset xnet = val(gettran.net)-val(gettran.tax)>
                        <cfelse>
                        <cfset xnet = val(gettran.net)>
                        </cfif>
						<cfset xtax = val(gettran.tax)>
						<cfset xgrand = val(gettran.grand)>
						<cfset xcurrrate = val(gettran.currrate)>
					<cfelse>
						<cfset xamt = val(gettran.invgross) / 2>
						<cfset xdisc = val(gettran.discount) / 2>
                        <cfset xnet = val(gettran.net) / 2>
						<cfset xtax = val(gettran.tax) / 2>
						<cfset xgrand = val(gettran.grand) / 2>
						<cfset xcurrrate = val(gettran.currrate)>
					</cfif>	
					<cfif url.trancode eq "TR">
                    <td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#rem1#</font></div></td>
					<td nowrap><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#rem2#</font></div></td>
					</cfif>
					
					<td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(xamt,",.__")#</font></div></td>
					<td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(xdisc,",.__")#</font></div></td>
                    <td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(xnet,",.__")#</font></div></td>
					<td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(xtax,",.__")#</font></div></td>
					<td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(xgrand,",.__")#</font></div></td>
					<cfif lcase(HcomID) eq "mhca_i" or lcase(HcomID) eq "bestform_i"><td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#numberformat(xcurrrate,",.______")#</font></div></td></cfif>
                    <cfif lcase(HcomID) eq "bestform_i"><td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#currcode#</font></div></td></cfif>
		
					<cfif xcurrrate eq "1">
                    
                    <cfif lcase(HcomID) eq "powernas_i">
                            <cfquery name="getictranqty4" datasource="#dts#">
                            select qty4 from ictran where refno='#gettran.refno#' and type='#gettran.type#'
                            </cfquery>
                            <cfset xfcamt = val(gettran.grand_bil/getictranqty4.qty4)>
                        <td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">SGD #numberformat(xfcamt,stDecl_UPrice)#</font></div></td>
                            <cfelse>
						<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">-</font></div></td>
                        </cfif>
					<cfelse>
						<cfif gettran.grand_bil neq "">
							<cfif url.trancode neq "TR">
                            <cfif lcase(HcomID) eq "powernas_i">
                            <cfquery name="getictranqty4" datasource="#dts#">
                            select qty4 from ictran where refno='#gettran.refno#' and type='#gettran.type#'
                            </cfquery>
                            <cfset xfcamt = val(gettran.grand_bil/getictranqty4.qty4)>
                            <cfelse>
								<cfset xfcamt = val(gettran.grand_bil)>
                            </cfif>
							<cfelse>
								<cfset xfcamt = val(gettran.grand_bil) / 2>
							</cfif>
						</cfif>
						<td nowrap><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif">#getcust.currcode# #numberformat(xfcamt,stDecl_UPrice)#</font></div></td>
						<cfset totalfcamt = totalfcamt + xfcamt>
					</cfif>
					<td><div align="center"><font size="1.5" face="Arial, Helvetica, sans-serif">
						<cfif url.trancode eq "CS" and lcase(Hcomid) eq "ovas_i">
							#agenno#
						<cfelse>
							#userid#
						</cfif>
						</font></div>
					</td>
					<cfif lcase(Hcomid) eq "topsteel_i" or lcase(Hcomid) eq "topsteelhol_i">
						<td><div align="left"><font size="1.5" face="Arial, Helvetica, sans-serif">#agenno#</font></div></td>
					</cfif>
				</tr>
				<cfset totalamt = totalamt + numberformat(xamt,".__")>				
				<cfset totaldisc = totaldisc + numberformat(xdisc,".__")>
                <cfset totalnet = totalnet + numberformat(xnet,".__")>
				<cfset totaltax = totaltax + numberformat(xtax,".__")>
				<cfset totalgrand = totalgrand + numberformat(xgrand,".__")>
                <cfset count=count+1>
			</cfoutput>
			<tr>
				<td colspan="<cfif lcase(HcomID) eq "mphcranes_i" or trancode eq "RC" or trancode eq "INV">15<cfelse><cfif url.trancode neq "TR"><cfif isdefined('form.checkbox1')>12
                <cfelse>11</cfif><cfelse>13</cfif></cfif>"><hr></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
                   <cfif isdefined('form.checkbox1')>
                <td></td>
                <cfif isdefined('form.checkbox2')>
                <td></td>
                </cfif>
                </cfif>
				<td></td>
                <cfif url.trancode eq "TR"><td></td>
				<td></td></cfif>
                <cfif lcase(HcomID) eq "mphcranes_i"><td></td><td></td></cfif>
				<cfoutput>
				<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>Total:</strong></font></div></td>
				<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#numberformat(totalamt,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#numberformat(totaldisc,",.__")#</strong></font></div></td>
                <td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#numberformat(totalnet,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#numberformat(totaltax,",.__")#</strong></font></div></td>
				<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#numberformat(totalgrand,",.__")#</strong></font></div></td>
				<cfif lcase(HcomID) eq "mhca_i"><td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"></font></div></td></cfif>
				<td><div align="right"><font size="1.5" face="Arial, Helvetica, sans-serif"><strong>#numberformat(totalfcamt,",.__")#</strong></font></div></td>
				</cfoutput>
				<td></td>
				<cfif lcase(Hcomid) eq "topsteel_i" or lcase(Hcomid) eq "topsteelhol_i"><td></td></cfif>
			</tr>
		</table>
		
		<br><br>
		<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
		<p class="noprint"><font size="2">Please print in Landscape format. Go to File - Page Setup, select "Landscape".</font></p>
		</body>
		</html>
        </cfif>
	</cfcase>
</cfswitch>