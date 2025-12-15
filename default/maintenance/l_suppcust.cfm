<cfswitch expression="#form.result#">
	<cfcase value="EXCELDEFAULT">


<cfparam name="i" default="1" type="numeric">
<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">
<cfparam name="form.counter" default="5">

<cfset target_table = iif(url.type eq "customer",DE(target_arcust),DE(target_apvend))>

<cfif isdefined("url.type")>
  <cfset typeNo="customer" & "No">
  <cfset link = url.type &".cfm">

<cfquery name="getgeneral" datasource="#dts#">
select agentlistuserid,compro from gsetup
</cfquery>

  <cfquery datasource='#dts#' name="getPersonal">
	Select * from #target_table#
	where 0=0
    <cfif url.type eq "Customer" and getpin2.h1t00 eq 'T'>
<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agent)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
                     <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                     <cfelse>
					<cfif Huserloc neq "All_loc">
					and (created_by in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
                    </cfif>
                    </cfif>
    <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
	  and custno >= '#form.custfrom#' and custno <= '#form.custto#'
    </cfif>
	<cfif form.agentfrom neq "" and form.agentto neq "">
	  and agent >= '#form.agentfrom#' and agent <= '#form.agentto#'
    </cfif>
	<cfif form.areafrom neq "" and form.areato neq "">
	  and area >= '#form.areafrom#' and area <= '#form.areato#'
    </cfif>
	<cfif form.businessfrom neq "" and form.businessto neq "">
	  and business >= '#form.businessfrom#' and business <= '#form.businessto#'
    </cfif>
    <cfif isdefined('form.badstatus')>
    and status<>'B'
    </cfif>
    order by custno
  </cfquery>
  <cfset type = url.type>
</cfif>

<!--- Control The Decimal Point --->
<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = #getgsetup2.Decl_UPrice#>
<cfset stDecl_UPrice = ".">
<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
  <cfset stDecl_UPrice = #stDecl_UPrice# & "_">
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
					<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="183.75"/>
					<Column ss:Width="60.25"/>
					<Column ss:Width="60.25"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
					<Column ss:AutoFitWidth="0" ss:Width="63.75"/>
					<cfset c="30">
						<Column ss:AutoFitWidth="0" ss:Width="75.75"/>
						<cfset c=c+1>

		   
					<cfwddx action = "cfml2wddx" input = "#url.type# Listing Report" output = "wddxText">
					<Row ss:AutoFitHeight="0" ss:Height="23.0625">
						<Cell ss:MergeAcross="#c#" ss:StyleID="s22"><Data ss:Type="String">#wddxText#</Data></Cell>
					</Row>
			
					
						<cfwddx action = "cfml2wddx" input = "" output = "wddxText">
						<Row ss:AutoFitHeight="0" ss:Height="20.0625">
							<Cell ss:MergeAcross="#c#" ss:StyleID="s24"><Data ss:Type="String">#wddxText#</Data></Cell>
						</Row>

			
				
					
					<cfwddx action = "cfml2wddx" input = "#getgeneral.compro#" output = "wddxText">
			
					<Row ss:AutoFitHeight="0" ss:Height="20.0625">
						<Cell ss:MergeAcross="#c-1#" ss:StyleID="s26"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s26"><Data ss:Type="String">#dateformat(now(),"dd/mm/yyyy")#</Data></Cell>
					</Row>
				</cfoutput>

				<Row ss:AutoFitHeight="0" ss:Height="23.0625">
					<Cell ss:StyleID="s27"><Data ss:Type="String">No</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String"><cfoutput>#type# No</cfoutput></Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Name</Data></Cell>
                    <cfif HcomID eq "supervalu_i">
					<Cell ss:StyleID="s27"><Data ss:Type="String">Gst No</Data></Cell>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Company UEN</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbAddress")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Address</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbdadd")>
                    <Cell ss:StyleID="s27"><Data ss:Type="String">Delivery Address</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbAttn")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Attention</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbcountry")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Country</Data></Cell>
                    </cfif>
                    <cfif isdefined("form.cbpostal")>
					<Cell ss:StyleID="s27"><Data ss:Type="String">Postal Code</Data></Cell>
                    </cfif>
					

		
		<cfif isdefined("form.cbArea")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Area</Data></Cell>
		</cfif>
		<cfif isdefined("form.cbBusiness")>
         <Cell ss:StyleID="s27"><Data ss:Type="String">Business</Data></Cell>
		</cfif>
		<cfif isdefined("form.cbContact")>
         <Cell ss:StyleID="s27"><Data ss:Type="String">Contact</Data></Cell>
		</cfif>
		<cfif isdefined("form.cbPhone")>
         <Cell ss:StyleID="s27"><Data ss:Type="String">Telephone</Data></Cell>
		</cfif>
		<cfif isdefined("form.cbPhone2")>
         <Cell ss:StyleID="s27"><Data ss:Type="String">Telephone 2</Data></Cell>
		</cfif>
		<cfif isdefined("form.cbFax")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Fax</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbEmail")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Email</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbAgent")>
         <Cell ss:StyleID="s27"><Data ss:Type="String">Agent</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbTerms")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Terms</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbCLimit")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Credit Limit</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbCurrCode")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Currency Code</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbCurr")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Currency</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbCurrDollar")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Currency Dollar</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbCurrCents")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Currency Cents</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbDate")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Date</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbInvLimit")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Invoice Limit</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbDPCate")>
         <Cell ss:StyleID="s27"><Data ss:Type="String">Discount Percentage Category</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbDPL1")>
         <Cell ss:StyleID="s27"><Data ss:Type="String">Discount Percentage Level 1</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbDPL2")>
           <Cell ss:StyleID="s27"><Data ss:Type="String">Discount Percentage Level 2</Data></Cell>
		</cfif>
 		<cfif isdefined("form.cbDPL3")>
           <Cell ss:StyleID="s27"><Data ss:Type="String">Discount Percentage Level 3</Data></Cell>
		</cfif>
        <cfif url.type eq "customer">
        <cfif isdefined("form.cbnormalrate")>
           <Cell ss:StyleID="s27"><Data ss:Type="String">Normal Rate</Data></Cell>
		</cfif>
        <cfif isdefined("form.cbofferrate")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Offer Rate</Data></Cell>
		</cfif>
        <cfif isdefined("form.cbotherrate")>
          <Cell ss:StyleID="s27"><Data ss:Type="String">Other Rate</Data></Cell>
		</cfif>
        </cfif>
        
				</Row>
                
			<cfoutput>
            <cfloop query="getPersonal">
					<cfwddx action = "cfml2wddx" input = "#custno#" output = "wddxText">
					<cfwddx action = "cfml2wddx" input = "#Name# #Name2#" output = "wddxText2">
					<cfwddx action = "cfml2wddx" input = "#gstno#" output = "wddxText3">
                    <cfwddx action = "cfml2wddx" input = "#comuen#" output = "wddxText4">
                    <cfwddx action = "cfml2wddx" input = "#Add1# #Add2# #Add3# #Add4#" output = "wddxText5">
                    <cfwddx action = "cfml2wddx" input = "#daddr1# #daddr2# #daddr3# #daddr4#" output = "wddxText6">
                    <cfwddx action = "cfml2wddx" input = "#Attn#" output = "wddxText7">
                    <cfwddx action = "cfml2wddx" input = "#Area#" output = "wddxText8">
                    <cfwddx action = "cfml2wddx" input = "#Business#" output = "wddxText9">
                    <cfwddx action = "cfml2wddx" input = "#Contact#" output = "wddxText10">
                    <cfwddx action = "cfml2wddx" input = "#Phone#" output = "wddxText11">
                    <cfwddx action = "cfml2wddx" input = "#Phonea#" output = "wddxText12">
                    <cfwddx action = "cfml2wddx" input = "#Fax#" output = "wddxText13">
                    <cfwddx action = "cfml2wddx" input = "#E_mail#" output = "wddxText14">
                    <cfwddx action = "cfml2wddx" input = "#Agent#" output = "wddxText15">
                    <cfwddx action = "cfml2wddx" input = "#Term#" output = "wddxText16">
                    <cfwddx action = "cfml2wddx" input = "#CurrCode#" output = "wddxText17">
                    <cfwddx action = "cfml2wddx" input = "#Currency#" output = "wddxText18">
                    <cfwddx action = "cfml2wddx" input = "#Currency1#" output = "wddxText19">
                    <cfwddx action = "cfml2wddx" input = "#Currency2#" output = "wddxText20">
                    <cfwddx action = "cfml2wddx" input = "#Dispec_Cat#" output = "wddxText21">
                     <cfwddx action = "cfml2wddx" input = "#country#" output = "wddxText22">
                     <cfwddx action = "cfml2wddx" input = "#postalcode#" output = "wddxText23">

					<Row ss:AutoFitHeight="0">

						<Cell ss:StyleID="s32"><Data ss:Type="String">#i#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText#</Data></Cell>
						<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText2#</Data></Cell>
                         <cfif HcomID eq "supervalu_i">
       					<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText3#</Data></Cell>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText4#</Data></Cell>
        				</cfif>
						<cfif isdefined("form.cbAddress")>
      					<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText5#</Data></Cell>
						</cfif>
    					<cfif isdefined("form.cbdadd")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText6#</Data></Cell>
						</cfif>
                        <cfif isdefined("form.cbAttn")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText7#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbcountry")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText22#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbpostal")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText23#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbArea")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText8#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbBusiness")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText9#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbContact")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText10#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbPhone")>
                    	<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText11#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbPhone2")>
                    	<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText12#</Data></Cell>
                        </cfif>
						<cfif isdefined("form.cbFax")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText13#</Data></Cell>
						</cfif>
                        <cfif isdefined("form.cbEmail")>
                    	<Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText14#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbAgent")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText15#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbTerms")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText16#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbCLimit")>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#NumberFormat(CrLimit, '_.__')#</Data></Cell> 
                        </cfif>
                        <cfif isdefined("form.cbCurrCode")>
                          <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText17#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbCurr")>
                        <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText18#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbCurrDollar")>
                         <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText19#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbCurrCents")>
                         <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText20#</Data></Cell>
                        </cfif>
						<cfif isdefined("form.cbDate")>
                           <Cell ss:StyleID="s32"><Data ss:Type="String">#dateformat(date,'DD-MM-YYYY')#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbInvLimit")>
                         <Cell ss:StyleID="s33"><Data ss:Type="Number">#NumberFormat(InvLimit, '_.__')#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbDPCate")>
                          <Cell ss:StyleID="s32"><Data ss:Type="String">#wddxText21#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbDPL1")>
                         <Cell ss:StyleID="s33"><Data ss:Type="Number">#NumberFormat(Dispec1, '_.__')#</Data></Cell> 
                        </cfif>
                        <cfif isdefined("form.cbDPL2")>
                         <Cell ss:StyleID="s33"><Data ss:Type="Number">#NumberFormat(Dispec2, '_.__')#</Data></Cell> 
                        </cfif>
                        <cfif isdefined("form.cbDPL3")>
                         <Cell ss:StyleID="s33"><Data ss:Type="Number">#NumberFormat(Dispec3, '_.__')#</Data></Cell> 
                        </cfif>
                        <cfif url.type eq "customer">
                        <cfif isdefined("form.cbnormalrate")>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#normal_rate#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbofferrate")>
                         <Cell ss:StyleID="s33"><Data ss:Type="Number">#offer_rate#</Data></Cell>
                        </cfif>
                        <cfif isdefined("form.cbotherrate")>
                        <Cell ss:StyleID="s33"><Data ss:Type="Number">#others_rate#</Data></Cell>

                        </cfif>
						</cfif>
					</Row>
                    <cfset i=i+1>
				</cfloop>
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

<cfcase value="HTML">
<html>
<head>
<title><cfoutput>#type#</cfoutput> Listing</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../stylesheet/reportprint.css" rel="stylesheet" type="text/css">
<style type="text/css" media="print">
	.noprint { display: none; }
</style>
</head>

<cfparam name="i" default="1" type="numeric">
<cfparam name="start" default="1">
<cfparam name="page" default="1">
<cfparam name="prevTwenty" default="0">
<cfparam name="nextTwenty" default="0">
<cfparam name="form.counter" default="5">

<cfset target_table = iif(url.type eq "customer",DE(target_arcust),DE(target_apvend))>

<cfif isdefined("url.type")>
  <cfset typeNo="customer" & "No">
  <cfset link = url.type &".cfm">

<cfquery name="getgeneral" datasource="#dts#">
select agentlistuserid from gsetup
</cfquery>

  <cfquery datasource='#dts#' name="getPersonal">
	Select * from #target_table#
	where 0=0
    <cfif url.type eq "Customer" and getpin2.h1t00 eq 'T'>
<cfif getgeneral.agentlistuserid eq "Y">and ucase(agent) in (SELECT agent FROM icagent WHERE agentlist like "%#ucase(huserid)#%")
					<cfelse>
           			and (ucase(userid)='#ucase(huserid)#' or ucase(agent)='#ucase(huserid)#')  
					</cfif>
					<cfelse>
                     <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i">
                     <cfelse>
					<cfif Huserloc neq "All_loc">
					and (created_by in (select userid from main.users where userDept = '#dts#' and location='#Huserloc#'))
					</cfif>
                    </cfif>
                    </cfif>
    <cfif trim(form.custfrom) neq "" and trim(form.custto) neq "">
	  and custno >= '#form.custfrom#' and custno <= '#form.custto#'
    </cfif>
	<cfif form.agentfrom neq "" and form.agentto neq "">
	  and agent >= '#form.agentfrom#' and agent <= '#form.agentto#'
    </cfif>
	<cfif form.areafrom neq "" and form.areato neq "">
	  and area >= '#form.areafrom#' and area <= '#form.areato#'
    </cfif>
    <cfif isdefined('form.badstatus')>
    and status<>'B'
    </cfif>
	<cfif form.businessfrom neq "" and form.businessto neq "">
	  and business >= '#form.businessfrom#' and business <= '#form.businessto#'
    </cfif>
    order by custno
  </cfquery>
  <cfset type = url.type>
<!--- <cfelse>
  <cfset typeNo = #url.type# & "No">

  <cfquery datasource='#dts#' name="getPersonel">
	Select * from #type#
    <cfif form.custfrom neq "" and form.custto neq "">
	  and Customerno >= '#form.custfrom#' and customerno <= '#form.custto#'
    </cfif>

	<cfif url.type eq 'Customer' and husergrpid neq "admin"and husergrpid neq 'super'>
	  where agent = '#huserid#'
	</cfif>
    order by customerno
  </cfquery> --->
</cfif>

<!--- Control The Decimal Point --->
<cfquery name="getgsetup2" datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = #getgsetup2.Decl_UPrice#>
<cfset stDecl_UPrice = ".">
<cfloop index="LoopCount" from="1" to="#iDecl_UPrice#">
  <cfset stDecl_UPrice = #stDecl_UPrice# & "_">
</cfloop>

<body>
<font color="#000000" size="1" face="Arial, Helvetica, sans-serif">Print Date: <cfoutput>#dateformat(now(),"DD/MM/YY")#</cfoutput></font>

  <p align="center"><font color="##000000" size="3" face="Arial, Helvetica, sans-serif"><strong><cfoutput>#url.type# Listing</cfoutput></strong></font></p>

  <cfif #getPersonal.recordCount# neq 0>
    <cfif isdefined("form.skeypage")>
      <cfset noOfPage=round(#getPersonal.recordcount#/20)>
      <cfif #getPersonal.recordcount# mod 20 LT 20 and #getPersonal.recordcount# mod 20 neq 0>
        <cfset noOfPage=#noOfPage#+1>
      </cfif>
      <cfif form.skeypage gt noofpage OR form.skeypage lt 1>
      <cfabort>
      </cfif>
    </cfif>

	<cfform action="l_suppcust.cfm?Type=#Type#" method="post">
 	  <cfoutput>
		<input type="hidden" name="custfrom" value="#form.custfrom#">
		<input type="hidden" name="custto" value="#form.custto#">

		<cfif isdefined("form.cbAddress")>
          <input type="hidden" name="cbAddress" value="#form.cbAddress#">
		</cfif>
		<cfif isdefined("form.cbAgent")>
          <input type="hidden" name="cbAgent" value="#form.cbAgent#">
		</cfif>
		<cfif isdefined("form.cbDate")>
          <input type="hidden" name="cbDate" value="#form.cbDate#">
		</cfif>
		<cfif isdefined("form.cbArea")>
          <input type="hidden" name="cbArea" value="#form.cbArea#">
		</cfif>
		<cfif isdefined("form.cbBusiness")>
          <input type="hidden" name="cbBusiness" value="#form.cbBusiness#">
		</cfif>
		<cfif isdefined("form.cbAttn")>
          <input type="hidden" name="cbAttn" value="#form.cbAttn#">
		</cfif>
		<cfif isdefined("form.cbTerms")>
          <input type="hidden" name="cbTerms" value="#form.cbTerms#">
		</cfif>
		<cfif isdefined("form.cbInvLimit")>
          <input type="hidden" name="cbInvLimit" value="#form.cbInvLimit#">
		</cfif>
 		<cfif isdefined("form.cbContact")>
          <input type="hidden" name="cbContact" value="#form.cbContact#">
		</cfif>
 		<cfif isdefined("form.cbCLimit")>
          <input type="hidden" name="cbCLimit" value="#form.cbCLimit#">
		</cfif>
 		<cfif isdefined("form.cbDPCate")>
          <input type="hidden" name="cbDPCate" value="#form.cbDPCate#">
		</cfif>
 		<cfif isdefined("form.cbPhone")>
          <input type="hidden" name="cbPhone" value="#form.cbPhone#">
		</cfif>
 		<cfif isdefined("form.cbCurrCode")>
          <input type="hidden" name="cbCurrCode" value="#form.cbCurrCode#">
		</cfif>
 		<cfif isdefined("form.cbDPL1")>

          <input type="hidden" name="cbDPL1" value="#form.cbDPL1#">
		</cfif>
 		<cfif isdefined("form.cbPhone2")>
          <input type="hidden" name="cbPhone2" value="#form.cbPhone2#">
		</cfif>
 		<cfif isdefined("form.cbCurr")>
          <input type="hidden" name="cbCurr" value="#form.cbCurr#">
		</cfif>
 		<cfif isdefined("form.cbDPL2")>
          <input type="hidden" name="cbDPL2" value="#form.cbDPL2#">
		</cfif>
 		<cfif isdefined("form.cbFax")>
          <input type="hidden" name="cbFax" value="#form.cbFax#">
		</cfif>
 		<cfif isdefined("form.cbCurrDollar")>
          <input type="hidden" name="cbCurrDollar" value="#form.cbCurrDollar#">
		</cfif>
 		<cfif isdefined("form.cbDPL3")>
          <input type="hidden" name="cbDPL3" value="#form.cbDPL3#">
		</cfif>
 		<cfif isdefined("form.cbEmail")>
          <input type="hidden" name="cbEmail" value="#form.cbEmail#">
		</cfif>
 		<cfif isdefined("form.cbCurrCents")>
          <input type="hidden" name="cbCurrCents" value="#form.cbCurrCents#">
		</cfif>
        <cfif isdefined("form.cbdadd")>
          <input type="hidden" name="cbdadd" value="#form.cbdadd#">
		</cfif>
	  </cfoutput>

<!--- 	  <h5>
	    <div align="left">
		  <a href="../Maintenance/pdfformat.cfm?Type=#type#"><font size="2"><strong>&lt;Print All Listing&gt;</strong></font></a>
		</div>
	  </h5> --->


		<cfset noOfPage=round(#getPersonal.recordcount#/20)>

		<cfif #getPersonal.recordcount# mod 20 LT 20 and #getPersonal.recordcount# mod 20 neq 0>
		  <cfset noOfPage=#noOfPage#+1>
		</cfif>

		<cfif isdefined("start")>
		  <cfset start=#start#>
		</cfif>

		<cfif isdefined("form.skeypage")>
		  <cfset start = #form.skeypage# * 20 + 1 - 20>
		  <cfif form.skeypage eq "1">
		    <cfset start = "1">
		  </cfif>
	    </cfif>

		<cfset prevTwenty=#start# -20>
		<cfset nextTwenty=#start# +20>
		<cfset page=round(#nextTwenty#/20)>

<!---  		<cfif #start# neq 1>
		  <cfoutput>|| <a href="l_icitem.cfm">Previous</a> ||</cfoutput>
		</cfif>

		<cfif #page# neq #noOfPage#>
		  <cfoutput> <a href="l_icitem.cfm">Next</a> ||</cfoutput>
		</cfif> --->
  	</cfform>

	<table width="100%" border="0" class="" align="center">
  	  <tr><td colspan="100%"><hr></td></tr>
	  <tr>
    	<td><strong><font size="2" face="Arial, Helvetica, sans-serif">No</font></strong></td>
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif"><cfoutput>#type# No</cfoutput></font></strong></td>
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Name</font></strong></td>
        <cfif HcomID eq "supervalu_i">
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Gst No</font></strong></td>
        <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Company UEN</font></strong></td>
        </cfif>
		<cfif isdefined("form.cbAddress")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Address</font></strong></td>
		</cfif>
        <cfif isdefined("form.cbdadd")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Delivery Address</font></strong></td>
		</cfif>
         <cfif isdefined("form.cbpostal")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Postal Code</font></strong></td>
		</cfif>
        <cfif isdefined("form.cbcountry")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Country</font></strong></td>
		</cfif>
		<cfif isdefined("form.cbAttn")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Attention</font></strong></td>
		</cfif>
		<cfif isdefined("form.cbArea")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Area</font></strong></td>
		</cfif>
		<cfif isdefined("form.cbBusiness")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Business</font></strong></td>
		</cfif>
		<cfif isdefined("form.cbContact")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Contact</font></strong></td>
		</cfif>
		<cfif isdefined("form.cbPhone")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Telephone</font></strong></td>
		</cfif>
		<cfif isdefined("form.cbPhone2")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Telephone 2</font></strong></td>
		</cfif>
		<cfif isdefined("form.cbFax")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Fax</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbEmail")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Email</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbAgent")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Agent</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbTerms")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Terms</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbCLimit")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Credit Limit</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbCurrCode")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Currency Code</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbCurr")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Currency</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbCurrDollar")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Currency Dollar</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbCurrCents")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Currency Cents</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbDate")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Date</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbInvLimit")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Invoice Limit</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbDPCate")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Discount Percentage Category</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbDPL1")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Discount Percentage Level 1</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbDPL2")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Discount Percentage Level 2</font></strong></td>
		</cfif>
 		<cfif isdefined("form.cbDPL3")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Discount Percentage Level 3</font></strong></td>
		</cfif>
        <cfif url.type eq "customer">
        <cfif isdefined("form.cbnormalrate")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Normal Rate</font></strong></td>
		</cfif>
        <cfif isdefined("form.cbofferrate")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Offer Rate</font></strong></td>
		</cfif>
        <cfif isdefined("form.cbotherrate")>
          <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Other Rate</font></strong></td>
		</cfif>
        </cfif>
  </tr>
  <tr><td colspan="100%"><hr></td></tr>
  <cfset i = ((#page# - 1) * 20) + 1>
  <cfoutput query="getPersonal" startrow="#start#">
  <tr>
    <td><div align="center">#i#</div></td>
    <td><cfif getpin2.h1211 eq 'T' and type eq 'Customer'><a href="#link#?type=Edit&custNo=#custno#">#custno#</a><cfelseif getpin2.h1111 eq 'T' and type eq 'Supplier'><a href="#link#?type=Edit&custNo=#custno#">#custno#</a><cfelse>#custno#</cfif></td>
    <td>#Name#<br>#Name2#</td>
    <cfif HcomID eq "supervalu_i">
        <td>#gstno#</td>
        <td>#comuen#</td>
        </cfif>
	<cfif isdefined("form.cbAddress")>
      <td>#Add1#<br>#Add2#<br>#Add3#<br>#Add4#</td>
	</cfif>
    <cfif isdefined("form.cbdadd")>
      <td>#daddr1#<br>#daddr2#<br>#daddr3#<br>#daddr4#</td>
	</cfif>
    <cfif isdefined("form.cbpostal")>
      <td>#postalcode#</td>
	</cfif>
    <cfif isdefined("form.cbcountry")>
      <td>#country#</td>
	</cfif>
	<cfif isdefined("form.cbAttn")>
      <td>#Attn#</td>
	</cfif>
	<cfif isdefined("form.cbArea")>
      <td>#Area#</td>
	</cfif>
	<cfif isdefined("form.cbBusiness")>
      <td>#Business#</td>
	</cfif>
	<cfif isdefined("form.cbContact")>
      <td>#Contact#</td>
	</cfif>
	<cfif isdefined("form.cbPhone")>
      <td>#Phone#</td>
	</cfif>
	<cfif isdefined("form.cbPhone2")>
      <td>#PhoneA#</td>
	</cfif>
	<cfif isdefined("form.cbFax")>
      <td>#Fax#</td>
	</cfif>
	<cfif isdefined("form.cbEmail")>
      <td>#E_mail#</td>
	</cfif>
	<cfif isdefined("form.cbAgent")>
      <td>#Agent#</td>
	</cfif>
	<cfif isdefined("form.cbTerms")>
      <td>#Term#</td>
	</cfif>
	<cfif isdefined("form.cbCLimit")>
      <td><div align="right">#NumberFormat(CrLimit, '_.__')#</div></td>
	</cfif>
	<cfif isdefined("form.cbCurrCode")>
      <td>#CurrCode#</td>
	</cfif>
	<cfif isdefined("form.cbCurr")>
      <td>#Currency#</td>
	</cfif>
	<cfif isdefined("form.cbCurrDollar")>
      <td>#Currency1#</td>
	</cfif>
	<cfif isdefined("form.cbCurrCents")>
      <td>#Currency2#</td>
	</cfif>
	<cfif isdefined("form.cbDate")>
      <td><div align="center">#dateformat(date,'DD-MM-YYYY')#</div></td>
	</cfif>
	<cfif isdefined("form.cbInvLimit")>
      <td><div align="right">#NumberFormat(InvLimit, '_.__')#</div></td>
	</cfif>
	<cfif isdefined("form.cbDPCate")>
      <td><div align="center">#Dispec_Cat#</div></td>
	</cfif>
	<cfif isdefined("form.cbDPL1")>
      <td><div align="right">#NumberFormat(Dispec1, '_.__')#</div></td>
	</cfif>
	<cfif isdefined("form.cbDPL2")>
      <td><div align="right">#NumberFormat(Dispec2, '_.__')#</div></td>
	</cfif>
	<cfif isdefined("form.cbDPL3")>
      <td><div align="right">#NumberFormat(Dispec3, '_.__')#</div></td>
	</cfif>
    <cfif url.type eq "customer">
    <cfif isdefined("form.cbnormalrate")>
      <td><div align="right">#normal_rate#</div></td>
	</cfif>
    <cfif isdefined("form.cbofferrate")>
      <td><div align="right">#offer_rate#</div></td>
	</cfif>
    <cfif isdefined("form.cbotherrate")>
      <td><div align="right">#others_rate#</div></td>
	</cfif>
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

<div align="right"><font size="1" face="Arial, Helvetica, sans-serif"><a href="javascript:print()" class="noprint"><u>Print</u></a></font></div>
<p class="noprint">Please print in Landscape format. Go to File - Page Setup,
  select "Landscape".</p>

</body>
</html>
</cfcase>
</cfswitch>

