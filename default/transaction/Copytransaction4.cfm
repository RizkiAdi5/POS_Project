<cfparam name='Submit' default=''>
<cfparam name="alcreate" default="0">
<cfparam name="isservice" default="0">

<cfif #tran# eq 'RC'>
  <cfset tran = 'RC'>
  <cfset tranname = 'Purchase Receive'>
  <cfset trancode = 'rcno'>
  <cfset tranarun = 'rcarun'>
  <cfif getpin2.h2102 eq 'T'>
  	<cfset alcreate = 1>
  </cfif>
</cfif>
<cfif #tran# eq 'PR'>
  <cfset tran = 'PR'>
  <cfset tranname = 'Purchase Return'>
  <cfset trancode = 'prno'>
  <cfset tranarun = 'prarun'>
  <cfif getpin2.h2201 eq 'T'>
 	<cfset alcreate = 1>
  </cfif>
</cfif>
<cfif #tran# eq 'DO'>
	<cfset tran = 'DO'>
	<cfset tranname = 'Delivery Order'>
	<cfset trancode = 'dono'>
    <cfset tranarun = 'doarun'>
	<cfif getpin2.h2301 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>
<cfif #tran# eq 'INV'>
  <cfset tran = 'INV'>
  <cfset tranname = 'Invoice'>
  <cfset trancode = 'invno'>
  <cfset tranarun = 'invarun'>
  <cfif getpin2.h2401 eq 'T'>
  	<cfset alcreate = 1>
  </cfif>
</cfif>
<cfif #tran# eq 'CS'>
  <cfset tran = 'CS'>
  <cfset tranname = 'Cash Sales'>
  <cfset trancode = 'csno'>
  <cfset tranarun = 'csarun'>
  <cfif getpin2.h2501 eq 'T'>
  	<cfset alcreate = 1>
  </cfif>
</cfif>
<cfif #tran# eq 'CN'>
  <cfset tran = 'CN'>
  <cfset tranname = 'Credit Note'>
  <cfset trancode = 'cnno'>
  <cfset tranarun = 'cnarun'>
  <cfif getpin2.h2601 eq 'T'>
  	<cfset alcreate = 1>
  </cfif>
</cfif>
<cfif #tran# eq 'DN'>
  <cfset tran = 'DN'>
  <cfset tranname = 'Debit Note'>
  <cfset trancode = 'dnno'>
  <cfset tranarun = 'dnarun'>
  <cfif getpin2.h2701 eq 'T'>
  	<cfset alcreate = 1>
  </cfif>
</cfif>
<cfif #tran# eq 'PO'>
  <cfset tran = 'PO'>
  <cfset tranname = 'Purchase Order'>
  <cfset trancode = 'pono'>
  <cfset tranarun = 'poarun'>
  <cfif getpin2.h2861 eq 'T'>
  	<cfset alcreate = 1>
  </cfif>
</cfif>
<cfif #tran# eq 'QUO'>
  <cfset tran = 'QUO'>
  <cfset tranname = 'Quotation'>
  <cfset trancode = 'quono'>
  <cfset tranarun = 'quoarun'>
  <cfif getpin2.h2871 eq 'T'>
  	<cfset alcreate = 1>
  </cfif>
</cfif>
<cfif #tran# eq 'SO'>
  <cfset tran = 'SO'>
  <cfset tranname = 'Sales Order'>
  <cfset trancode = 'sono'>
  <cfset tranarun = 'soarun'>
  <cfif getpin2.h2881 eq 'T'>
 	<cfset alcreate = 1>
  </cfif>
</cfif>
<cfif #tran# eq "SAM">
	<cfset tran = "SAM">
	<cfset tranname = "Sample">	
	<cfset trancode = "samno">
	<cfset tranarun = "samarun">
	<cfif getpin2.h2851 eq 'T'>
  		<cfset alcreate = 1>
  	</cfif>
</cfif>

<cfif submit eq "Search Comment">
	<cfquery name="inserttemp" datasource="#dts#">
		insert into commentemp(type,refno,itemno,userid,comment)
		values('#tran#','#nexttranno#','#itemno#','#huserid#',
		
		<cfset CommentLen = #len(tostring(comment))#>
		<cfset xComment = #tostring(comment)#>
		<cfset SingleQ = ''>
		<cfset DoubleQ = ''>
		
		<cfloop index = "Count" from = "1" to = "#CommentLen#">
		  <cfif mid(#xComment#,#Count#,1) eq "'">
			<cfset SingleQ = 'Y'>
		  <cfelseif mid(#xComment#,#Count#,1) eq '"'>
			<cfset DoubleQ = 'Y'>
		  </cfif>
		</cfloop>					
		
		<cfif SingleQ eq 'Y' and DoubleQ eq ''>
		  <!--- Found ' in the comment --->
		  "#form.comment#")
		<cfelseif SingleQ eq '' and DoubleQ eq 'Y'>
		  <!--- Found " in the comment --->
		  '#form.comment#')
		<cfelseif SingleQ eq '' and DoubleQ eq ''>					 
		  '#form.comment#')					
		<cfelse>
		  <h3>Error. You cannot key in both ' and " in the comment.</h3>
		  <cfabort>
		</cfif>		
	</cfquery>
	<cfoutput><form name='form1' method='post' action='trancmentsearch.cfm?tran=#tran#&stype=#tranname#&type1=#type1#&nexttranno=#nexttranno#&itemno=#itemno#&service=#service#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#<cfif type1 neq "Add">&itemcount=#itemcount#</cfif>'>
		
	</form></cfoutput>
	<script>
		form1.submit();
	</script>
	<cfabort>
<cfelseif submit neq "">
	<cfoutput><form name='form1' method='post' action='transactionprocess.cfm?nDateCreate=#nDateCreate#' onsubmit='return validate()'>
	  
	 	<input type='hidden' name='tran' value='#tran#'>
    	<input name='type' value='Inprogress' type='hidden'>
		<input name='agenno' value='#agenno#' type='hidden'>
		<cfif IsDefined('FORM.UpdUnitCost')>
	  	<input type='hidden' name='UpdUnitCost' value='#UpdUnitCost#'>
		</cfif>
	  <input type='hidden' name='location' value='#location#'>
	  <input type='hidden' name='taxpec1' value='#taxpec1#'>
	  <input type='hidden' name='dispec1' value='#dispec1#'>
	  <input type='hidden' name='dispec2' value='#dispec2#'>
	  <input type='hidden' name='dispec3' value='#dispec3#'>
	  <input type='hidden' name='brem4' value='#brem4#'>
	  <input type='hidden' name='brem3' value='#brem3#'>
	  <cfif isdefined("form.requestdate")>
	  	<input type='hidden' name='requestdate' value='#requestdate#'>
	  </cfif>
	  <cfif isdefined("form.crequestdate")>
	  <input type='hidden' name='crequestdate' value='#crequestdate#'>
	  </cfif>
	  <input type='hidden' name='gltradac' value='#gltradac#'>
	  <input type='hidden' name='price' value='#price#'>
	  <input type='hidden' name='qty' value='#qty#'>
	  <input type='hidden' name='unit' value='#unit#'>
	  <input type='hidden' name='service' value='#service#'>
	  <input type='hidden' name='sv_part' value='#sv_part#'>
	  <input type='hidden' name='sercost' value='#sercost#'>	  
	  <input type='hidden' name='desp' value='#desp#'>
	  <input type='hidden' name='despa' value='#despa#'>	  
	  <input type='hidden' name='currrate' value='#currrate#'>
      <input type='hidden' name='refno3' value='#refno3#'>
      <input type='hidden' name='mode' value='#mode#'>
      <input type='hidden' name='nexttranno' value='#nexttranno#'>
	  <input type='hidden' name='custno' value='#custno#'>
      <input type='hidden' name='readperiod' value='#readperiod#'>
      <!--- <input type='hidden' name='nDateCreate' value='#ndatecreate#'> --->
	  <input type='hidden' name='invoicedate' value='#form.invoicedate#'>
	  <input type='hidden' name='itemno' value='#itemno#'>
	    <cfset CommentLen = #len(tostring(form.comment))#>
		<cfset xComment = #tostring(form.comment)#>
		<cfset SingleQ = ''>
		<cfset DoubleQ = ''>
		
		<cfloop index = "Count" from = "1" to = "#CommentLen#">
		  <cfif mid(#xComment#,#Count#,1) eq "'">
			<cfset SingleQ = 'Y'>
		  <cfelseif mid(#xComment#,#Count#,1) eq '"'>
			<cfset DoubleQ = 'Y'>
		  </cfif>
		</cfloop>					
		
		<cfif SingleQ eq 'Y' and DoubleQ eq ''>
		  <!--- Found ' in the comment --->
		  <input type='hidden' name='comment' value="#form.comment#">
		<cfelseif SingleQ eq '' and DoubleQ eq 'Y'>
		  <!--- Found " in the comment --->
		  <input type='hidden' name='comment' value='#form.comment#'>
		<cfelseif SingleQ eq '' and DoubleQ eq ''>					 
		  <input type='hidden' name='comment' value='#form.comment#'>					
		<cfelse>
		  <h3>Error. You cannot key in both ' and " in the comment.</h3>
		  <cfabort>
		</cfif>
	  
	  <cfif type1 neq "Add"><input type='hidden' name='itemcount' value='#itemcount#'></cfif>
	</form>
	</cfoutput>
	<script>
		form1.submit();
	</script>
	<cfabort>
</cfif>

<html>
<head>
<title>Standard Add Item Screen</title>
<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
</head>



<cfparam name='pricehis1' default=''>
<cfparam name='pricehis2' default=''>
<cfparam name='pricehis3' default=''>
<cfparam name='disc1' default=''>
<cfparam name='disc2' default=''>
<cfparam name='disc3' default=''>
<cfparam name='date1' default=''>
<cfparam name='date2' default=''>
<cfparam name='date3' default=''>
<cfparam name='itembal' default='0'>
<!--- <cfset RCqty = 0>
<cfset PRqty = 0>
<cfset DOqty = 0>
<cfset invqty = 0>
<cfset CNqty = 0>
<cfset DNqty = 0> --->
<cfparam name='RCqty' default='0'>
<cfparam name='PRqty' default='0'>
<cfparam name='DOqty' default='0'>
<cfparam name='invqty' default='0'>
<cfparam name='CNqty' default='0'>
<cfparam name='DNqty' default='0'> 
<cfparam name='CSqty' default='0'> 
<cfparam name='ISSqty' default='0'> 
<cfparam name='OAIqty' default='0'> 
<cfparam name='OARqty' default='0'>
<cfparam name='balonhand' default='0'>


<cfquery datasource='#dts#' name='getGeneralInfo'>
	Select invoneset, negstk,brem1,brem2,brem3,brem4 from gsetup
</cfquery>

<cfquery datasource='#dts#' name='getlocation'>
	select location from iclocation
</cfquery>
<cfquery name='getAllItem' datasource='#dts#'>
	select itemno, desp from icitem order by itemno
</cfquery>

<cfoutput>
	<cfif #url.type1# eq 'Delete'>
		<cfquery datasource='#dts#' name='getitem'>
			select * from ictran where itemno= '#url.itemno#' and refno = '#nexttranno#' and type = '#tran#' and itemcount = '#itemcount#'
		</cfquery>
		<cfquery datasource='#dts#' name='getpricehis'>
			select * from ictran where itemno= '#url.itemno#' order by wos_date desc
		</cfquery>	
		
		<cfquery name='getitembal' datasource='#dts#'>
			select qtybf,minimum from icitem where itemno = '#url.itemno#'
		</cfquery>
		<cfif getitembal.recordcount eq 0>
			<cfset isservice = 1>
		</cfif>
		<Cfset itemno = '#url.itemno#'>
		<cfset ItemOrService = "Item">
<!--- 		<Cfset service = '#url.service#'> --->
		<!--- <cfquery datasource='#dts#' name='getHis'>
			select * from icitem where itemno= '#url.itemno#'
		</cfquery> --->
		
		<!--- <cfset refno=#getitem.refno#>
		<cfset wos_type=#getitem.type#>
		<cfset custno=#getitem.custno#>
		<cfset readperiod=#getitem.fperiod#>
		<cfset nDateCreate=#getitem.wos_date#>
		<cfset currrate=#getitem.currrate#>
		<cfset itemcnt=#getitem.itemcount#>
		<cfset itemno=#getitem.itemno#> --->
		<cfset desp=#getitem.desp#>
		<cfset despa=#getitem.despa#>
		<cfset xlocation=#getitem.location#>
		<cfset qty=#getitem.qty#>
		<cfset price=#getitem.price_bil#>
		<cfset unit=#getitem.unit#>
		<cfset Brem1=#getitem.BREM1#>
		<cfset Brem2=#getitem.BREM2#> 
		<cfset Brem3=#getitem.BREM3#>
		<cfset Brem4=#getitem.BREM4#> 
		<cfset dono=#getitem.dono#>
		<cfset gst_item=#getitem.gst_item#>
		<!--- <cfset totalup=#getitem.totalup#>
		<cfset pur_price=#getitem.pur_price#>
		<cfset qty_ret=#getitem.qty_ret#>
		<cfset Batch=#getitem.batchcode#>
		<cfset name=#getitem.name#>
		<cfset del_by=#getitem.del_by#>
		<cfset generated=#getitem.generated#>
		<cfset toinv=#getitem.toinv#>
		<cfset sono=#getitem.sono#>
		<cfset mc1_bil=#getitem.mc1_bil#>
		<cfset mc2_bil=#getitem.mc2_bil#>
		<cfset userid=#getitem.userid#>
		<cfset damt=#getitem.damt#> --->
		<cfset dispec1=#getitem.dispec1#>
		<cfset dispec2=#getitem.dispec2#>
		<cfset dispec3=#getitem.dispec3#>
		<cfset taxpec1=#getitem.taxpec1#>
		<cfset gltradac=#getitem.gltradac#>
		<cfset oldbill=#getitem.oldbill#>
		<cfset wos_grouop=#getitem.wos_group#>
		<cfset category=#getitem.category#>
		<cfset area=#getitem.area#>
		<cfset shelf=#getitem.shelf#>
		<!--- <cfset temp=#getitem.temp#>
		<cfset temp1=#getitem.temp1#>
		<cfset totalgroup=#getitem.totalgroup#>
		<cfset mark=#getitem.mark#>
		<cfset type_seq=#getitem.type_seq#>
		<cfset promoter=#getitem.promoter#>
		<cfset tableno=#getitem.tableno#>
		<cfset member=#getitem.member#>
		<cfset tourgroup=#getitem.tourgroup#>
		<cfset trdatetime=#getitem.trdatetime#>--->
		<cfset comment=ToString(#getitem.comment#)> 
		<cfset xsv_part=#getitem.sv_part#>
		<cfset sercost=#getitem.sercost#>
		
		<!--- <cfset pricehis1=#getHis.pricehis1#>
		<cfset pricehis1=#getHis.pricehis1#> --->
		
		<cfset mode='Delete'>
		<cfset button='Delete'>
		
	</cfif>
	
		<cfif #url.type1# eq 'Edit'>
					
		<cfquery datasource='#dts#' name='getitem'>
			select * from ictran where itemno= '#url.itemno#' and refno = '#nexttranno#' and type = '#tran#' and itemcount = '#itemcount#'
		</cfquery>
		<cfquery datasource='#dts#' name='getpricehis'>
			select * from ictran where itemno= '#url.itemno#' order by wos_date desc
		</cfquery>
		
		<cfquery name='getitembal' datasource='#dts#'>
			select qtybf,minimum from icitem where itemno = '#url.itemno#'
		</cfquery>
		<cfif getitembal.recordcount eq 0>
			<cfset isservice = 1>
		</cfif>
		<Cfset itemno = '#url.itemno#'>
		<cfset ItemOrService = "Item">
<!--- 		<Cfset service = '#url.servi#'> --->

		<!--- <cfquery datasource='#dts#' name='getHis'>
			select * from icitem where itemno= '#url.itemno#'
		</cfquery> --->
		
		<cfoutput>
		<!--- <cfset refno=#getitem.refno#>
		<cfset wos_type=#getitem.type#>
		<cfset custno=#getitem.custno#>
		<cfset readperiod=#getitem.fperiod#>
		<cfset nDateCreate=#getitem.wos_date#>
		<cfset currrate=#getitem.currrate#>
		<cfset itemcnt=#getitem.itemcount#>
		<cfset itemno=#getitem.itemno#> --->
		<cfset desp=#getitem.desp#>
		<cfset despa=#getitem.despa#>
		<cfset xlocation=#getitem.location#>
		<cfset qty=#getitem.qty#>
		<cfset price=#getitem.price_bil#>
		<cfset unit=#getitem.unit#>
		<cfset Brem1=#getitem.brem1#>
		<cfset Brem2=#getitem.brem2#> 
		<cfset Brem3=#getitem.BREM3#>
		<cfset Brem4=#getitem.BREM4#>
		<!--- <cfset Brem3=#getitem.BREM3#>
		<cfset Brem4=#getitem.BREM4#> --->
		<cfset dono=#getitem.dono#>
		<cfset gst_item=#getitem.gst_item#>
		<!--- <cfset totalup=#getitem.totalup#>
		<cfset pur_price=#getitem.pur_price#>
		<cfset qty_ret=#getitem.qty_ret#>
		<cfset Batch=#getitem.batchcode#>
		<cfset name=#getitem.name#>
		<cfset del_by=#getitem.del_by#>
		<cfset generated=#getitem.generated#>
		<cfset toinv=#getitem.toinv#>
		<cfset sono=#getitem.sono#>
		<cfset mc1_bil=#getitem.mc1_bil#>
		<cfset mc2_bil=#getitem.mc2_bil#>
		<cfset userid=#getitem.userid#> --->
		<!--- <cfset damt=#getitem.damt#> --->
		<cfset dispec1=#getitem.dispec1#>
		<cfset dispec2=#getitem.dispec2#>
		<cfset dispec3=#getitem.dispec3#>
		<cfset taxpec1=#getitem.taxpec1#>
		<cfset gltradac=#getitem.gltradac#>
		<!--- <cfset oldbill=#getitem.oldbill#> --->
		<cfset wos_grouop=#getitem.wos_group#>
		<cfset category=#getitem.category#>
		<!--- <cfset area=#getitem.area#>
		<cfset shelf=#getitem.shelf#>
		<cfset temp=#getitem.temp#>
		<cfset temp1=#getitem.temp1#>
		<cfset totalgroup=#getitem.totalgroup#>
		<cfset mark=#getitem.mark#>
		<cfset type_seq=#getitem.type_seq#>
		<cfset promoter=#getitem.promoter#>
		<cfset tableno=#getitem.tableno#>
		<cfset member=#getitem.member#>
		<cfset tourgroup=#getitem.tourgroup#>
		<cfset trdatetime=#getitem.trdatetime#> --->
		<cfif isdefined('url.code')>
			<cfquery name='getcomment' datasource='#dts#'>
				select * from comments where code = '#url.code#'
			</cfquery>
			<cfquery name="gettempcomment" datasource="#dts#">
				select comment from commentemp where type = '#tran#' and refno='#nexttranno#' and itemno='#itemno#' and userid='#huserid#'
			</cfquery>
			<cfif tostring(gettempcomment.comment) eq "">
				<cfset comment=ToString(getcomment.details)>
			<cfelse>
				<cfset comment=tostring(gettempcomment.comment)&chr(13)&chr(13)&ToString(getcomment.details)>
			</cfif>
			
			<cfquery name="deltempcomment" datasource="#dts#">
				delete from commentemp where type = '#tran#' and refno='#nexttranno#' and itemno='#itemno#' and userid='#huserid#'
			</cfquery>
		<cfelse>
			<cfset comment=ToString(getitem.comment)>
		</cfif>		
		
		<!--- <cfif isdefined('url.code')>
			<cfquery name='getcomment' datasource='#dts#'>
				select * from comments where code = '#url.code#'
			</cfquery>
			
			<cfif isdefined('url.ap')>
				<cfset comment=ToString(#getitem.comment#)&chr(13)&chr(13)&(ToString(#getcomment.details#))>
			<cfelse>
				<cfset comment=ToString(#getcomment.details#)>
			</cfif>
		<cfelse>
			<cfset comment=ToString(#getitem.comment#)>
		</cfif> --->
		
		<cfset xsv_part=#getitem.sv_part#>
		<cfset sercost=#getitem.sercost#>
		
		
		<!--- <cfset pricehis1=#getHis.pricehis1#> --->
		
		<cfset mode='Edit'>
		<cfset button='Edit'>
		</cfoutput>
	</cfif>
	
	
	
	<cfif #url.type1# eq 'Add'>
		<cfquery datasource='#dts#' name='getartran'>
      		select * from artran where refno= '#nexttranno#' and type = '#tran#' 
      	</cfquery>
		<!--- <cfquery datasource='#dts#' name='checkitemExist'>
			select * from ictran where refno = '#nexttranno#' and itemno = '#itemno#' and type = '#tran#'
		</cfquery>
		
		<!--- <cfoutput>#form.newinvoice# #form.itemno#</cfoutput> --->
	
		<cfif checkitemExist.recordcount GT 0>
				<div align='center'><h3>You have added this item before.</h3>
				<input type='button' name='back' value='back' onClick='javascript:history.back()'></div>
				<cfabort>
		</cfif>  --->
	
		<cfquery datasource='#dts#' name='getpricehis'>
			select * from ictran where itemno= '#itemno#' order by wos_date desc
		</cfquery>
		
		<cfquery name='getitembal' datasource='#dts#'>
			select qtybf,minimum from icitem where itemno = '#itemno#'
		</cfquery>
		
		<cfset itemno = #itemno#>
		<cfset ItemOrService = "Item">

  		<cfquery datasource='#dts#' name='getproductdetails'>
  			Select * from icitem where itemno = '#itemno#'
		</cfquery>
		

		<cfif #getproductdetails.recordcount# eq 0>
 		  <cfif isdefined("form.service")>
  			<cfset itemno = #form.service#>		  		
		  <cfelse>
    		<cfset itemno = #url.service#>
  		  </cfif>
		  <cfset isservice = 1>
  		  <cfset price = 0> 
		  <cfset dispec1='0'>
		  <cfset dispec2='0'>
		  <cfset dispec3='0'> 
		  <cfquery datasource='#dts#' name='getproductdetails'>
			Select * from icservi where servi = '#itemno#'
   		  </cfquery>  		
		<cfelse>
			
			<cfif tran eq 'RC' or tran eq 'PO' or tran eq 'PR'>
				<cfquery name="getrecommendprice" datasource="#dts#">
					select * from icl3p where itemno = '#itemno#' and custno = '#getartran.custno#'
				</cfquery>
				<cfif getrecommendprice.recordcount gt 0>
					<cfset price = getrecommendprice.price>
					<cfset dispec1=getrecommendprice.dispec>
					<cfset dispec2=getrecommendprice.dispec2>
					<cfset dispec3=getrecommendprice.dispec3>
				<cfelse>
					<cfset price = getproductdetails.ucost>
					<cfset dispec1='0'>
					<cfset dispec2='0'>
					<cfset dispec3='0'>
				</cfif>
				
			<cfelse>
				<cfquery name="getrecommendprice" datasource="#dts#">
					select * from icl3p2 where itemno = '#itemno#' and custno = '#getartran.custno#'
				</cfquery>
				<cfif getrecommendprice.recordcount gt 0>
					<cfset price = getrecommendprice.price>
					<cfset dispec1=getrecommendprice.dispec>
					<cfset dispec2=getrecommendprice.dispec2>
					<cfset dispec3=getrecommendprice.dispec3>
				<cfelse>
					<cfset price = getproductdetails.price>
					<cfset dispec1='0'>
					<cfset dispec2='0'>
					<cfset dispec3='0'>
				</cfif>				
			</cfif>
			
		</cfif>		
		
		<cfset ItemOrService = "Service">
			
		<cfquery datasource='#dts#' name='getUOM'>
		  select unit from icitem where itemno = '#itemno#'
		</cfquery>

		
		<!--- <cfset refno=''>
		<cfset wos_type=''>
		<cfset currrate=''>
		<cfset itemcnt=''>
		<cfset itemno=''> --->
		<cfset desp=''>
		<cfset despa=''>
		<cfset xlocation=''>
		<cfset qty='0'>
		
		<!--- <cfset price=#getproductdetails.price#> --->
<!--- 		<cfif #getproductdetails.recordcount# eq 0>
 		  <cfset unit=''>
		<cfelse>
		  <cfset unit=#getUOM.unit#>
		</cfif> --->
		<cfset unit=#getUOM.unit#>
		<cfset Brem1=''>
		<cfset Brem2=''> 
		<cfset Brem3=''> 
		<cfset Brem4=''> 
	<!---	<cfset price2=''>
		<cfset Brem3=''>
		<cfset Brem4=''> --->
		<cfset dono=''>
		<cfset gst_item=''>
		<cfset totalup=''>
		<!--- <cfset pur_price=''>
		<cfset qty_ret=''>
		<cfset Batch=''>
		<cfset name=''>
		<cfset del_by=''>
		<cfset generated=''>
		<cfset toinv=''>
		<cfset sono=''>
		<cfset mc1_bil=''>
		<cfset mc2_bil=''>
		<cfset userid=''> --->
		<!--- <cfset damt=''> --->
		
		<cfset taxpec1='0'>
		<cfset gltradac=''>
		<!--- <cfset oldbill=''> --->
		<cfset wos_grouop=''>
		<cfset category=''>
		<cfset area=''>
		<cfset shelf=''>
		<cfset xsv_part = ''>
		<cfset sercost = 0>
		<!--- <cfset temp=''>
		<cfset temp1=''>
		<cfset totalgroup=''>
		<cfset mark=''>
		<cfset type_seq=''>
		<cfset promoter=''>
		<cfset tableno=''>
		<cfset member=''>
		<cfset tourgroup=''>
		<cfset trdatetime=''>--->
		<cfif isdefined('url.code')>
			<cfquery name='getcomment' datasource='#dts#'>
				select * from comments where code = '#url.code#'
			</cfquery>
			<cfquery name="gettempcomment" datasource="#dts#">
				select comment from commentemp where type = '#tran#' and refno='#nexttranno#' and itemno='#itemno#' and userid='#huserid#'
			</cfquery>
			<cfif tostring(gettempcomment.comment) eq "">
				<cfset comment=ToString(#getcomment.details#)>
			<cfelse>
				<cfset comment=tostring(#gettempcomment.comment#)&chr(13)&chr(13)&ToString(#getcomment.details#)>
			</cfif>
			<cfquery name="deltempcomment" datasource="#dts#">
				delete from commentemp where type = '#tran#' and refno='#nexttranno#' and itemno='#itemno#' and userid='#huserid#'
			</cfquery>
		<cfelse>
			<cfset comment=''> 
		</cfif>
		
		<!--- <cfset pricehis1=#getproductdetails.pricehis1#> --->
	
		<cfset mode='Add'>
		<cfset button='Add'>
	
	</cfif>
	
	<cfif getpricehis.recordcount gt 0>
			<cfloop query='getpricehis' startrow='1' endrow='1'>
				<cfset pricehis1 = #numberformat(price,'____.__')#>
				<cfset date1 = #dateformat(wos_date,'dd/mm/yyyy')#>
				<cfset disc1 = #dispec1# & ' + ' & #dispec2# & ' + ' & #dispec3#>
			</cfloop>
			<cfloop query='getpricehis' startrow='2' endrow='2'>
				<cfset pricehis2 = #numberformat(price,'____.__')#>
				<cfset date2 = #dateformat(wos_date,'dd/mm/yyyy')#>
				<cfset disc2 = #dispec1# & ' + ' & #dispec2# & ' + ' & #dispec3#>
			</cfloop>
			<cfloop query='getpricehis' startrow='3' endrow='3'>
				<cfset pricehis3 = #numberformat(price,'____.__')#>
				<cfset date3 = #dateformat(wos_date,'dd/mm/yyyy')#>
				<cfset disc3 = #dispec1# & ' + ' & #dispec2# & ' + ' & #dispec3#>
			</cfloop>		
	</cfif>
	
	<cfif isservice neq 1>
	<cfif getitembal.qtybf neq ''>
		<cfset itembal = #getitembal.qtybf#>	
	</cfif> 
	
	<cfquery name='getrc' datasource='#dts#'>
		select sum(qty)as sumqty from ictran where type ='RC' and itemno = '#itemno#'
	</cfquery>
	<cfif getrc.recordcount gt 0>
		<cfif getrc.sumqty neq ''>
			<cfset RCqty = #getrc.sumqty#>
		</cfif>
	</cfif>
	<cfquery name='getpr' datasource='#dts#'>
		select sum(qty)as sumqty from ictran where type = 'PR' and itemno = '#itemno#'
	</cfquery>
	<cfif getpr.recordcount gt 0>
		<cfif getpr.sumqty neq ''>
			<cfset PRqty = #getpr.sumqty#>
		</cfif>
	</cfif>
	<cfquery name='getdo' datasource='#dts#'>
		select sum(qty)as sumqty from ictran where type = 'DO' and toinv = '' and itemno = '#itemno#'
	</cfquery>
	<cfif getdo.recordcount gt 0>
		<cfif getdo.sumqty neq ''>
			<cfset DOqty = #getdo.sumqty#>
		</cfif>
	</cfif>

	<cfquery name='getinv' datasource='#dts#'>
		select sum(qty)as sumqty from ictran where type = 'INV' and itemno = '#itemno#'
	</cfquery>
	<!--- <Cfoutput>#getinv.sumqty#</Cfoutput> --->
	<cfif getinv.recordcount gt 0>
		<cfif getinv.sumqty neq ''>
			<cfset INVqty = #getinv.sumqty#>
		</cfif>
		
	</cfif>
	<cfquery name='getcn' datasource='#dts#'>
		select sum(qty)as sumqty from ictran where type = 'CN' and itemno = '#itemno#'
	</cfquery>
	<cfif getcn.recordcount gt 0>
		<cfif getcn.sumqty neq ''>
			<cfset CNqty = #getcn.sumqty#>
		</cfif>
	</cfif>
	<cfquery name='getdn' datasource='#dts#'>
		select sum(qty)as sumqty from ictran where type = 'DN' and itemno = '#itemno#'
	</cfquery>
	<cfif getdn.recordcount gt 0>
		<cfif getdn.sumqty neq ''>
			<cfset DNqty = #getdn.sumqty#>
		</cfif>		
	</cfif>
	
	<cfquery name='getcs' datasource='#dts#'>
		select sum(qty)as sumqty from ictran where type = 'CS' and itemno = '#itemno#'
	</cfquery>
	<cfif getcs.recordcount gt 0>
		<cfif getcs.sumqty neq ''>
			<cfset CSqty = #getcs.sumqty#>
		</cfif>		
	</cfif>
	
	<cfquery name='getiss' datasource='#dts#'>
		select sum(qty)as sumqty from ictran where type = 'ISS' and itemno = '#itemno#'
	</cfquery>
	<cfif getiss.recordcount gt 0>
		<cfif getiss.sumqty neq ''>
			<cfset ISSqty = #getiss.sumqty#>
		</cfif>		
	</cfif>
	
	<cfquery name='getoai' datasource='#dts#'>
		select sum(qty)as sumqty from ictran where type = 'OAI' and itemno = '#itemno#'
	</cfquery>
	<cfif getoai.recordcount gt 0>
		<cfif getoai.sumqty neq ''>
			<cfset OAIqty = #getoai.sumqty#>
		</cfif>		
	</cfif>
	
	<cfquery name='getoar' datasource='#dts#'>
		select sum(qty)as sumqty from ictran where type = 'OAR' and itemno = '#itemno#'
	</cfquery>
	<cfif getoar.recordcount gt 0>
		<cfif getoar.sumqty neq ''>
			<cfset OARqty = #getoar.sumqty#>
		</cfif>		
	</cfif>
	
	<cfset balonhand = #itembal# + #rcqty# + #oaiqty# - #oarqty# - #prqty# - #doqty# - #invqty# + #cnqty# - #dnqty# - #csqty# - #issqty#>  
	</cfif>
	
	<cfif #tran# eq 'PR' or #tran# eq 'DO' or #tran# eq 'INV' or #tran# eq 'CS' or #tran# eq 'DN' or #tran# eq 'ISS' or #tran# eq 'OAR'>
	  <cfif #balonhand# lte 0 and mode eq 'Add' and #ItemOrService# eq "Item" and #getGeneralInfo.negstk# eq "0">
	    <cfoutput><h3>
	      <font color="##FF0000">Negative or Zero Stock, The quantity on hand is #balonhand#.</font>
		  <br>
		  <br>
		  <font color="##FF0000">Please click Back to continue.</font>
		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <input type='button' name='back2' value='Back' onClick='javascript:history.back()'> 
	    </h3></cfoutput> 
	    <cfabort>
	  </cfif>
	</cfif>
		
</cfoutput>

<!--- Control The Decimal Point --->
<cfquery name='getgsetup2' datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = #getgsetup2.Decl_Uprice#>
<cfset stDecl_UPrice = '.'>
<cfloop index='LoopCount' from='1' to='#iDecl_UPrice#'>
  <cfset stDecl_UPrice = #stDecl_UPrice# & '_'>
</cfloop>

<cfset iDecl_Discount = #getgsetup2.Decl_Discount#>
<cfset stDecl_Discount = '.'>
<cfloop index='LoopCount' from='1' to='#iDecl_Discount#'>
  <cfset stDecl_Discount = #stDecl_Discount# & '_'>
</cfloop>

<body>
<!--- <cfoutput>item #itembal#</cfoutput> <cfoutput>rc #rcqty#</cfoutput><cfoutput> pr #prqty#</cfoutput><cfoutput> do #doqty#</cfoutput><cfoutput> inv #invqty#</cfoutput><cfoutput> cn #cnqty#</cfoutput><cfoutput> dn #dnqty#</cfoutput> --->
<cfoutput>
	<h4>
		<!--- <a href='transaction1.cfm?ttype=create&tran=#tran#&nexttranno=&bcode=&dcode=&first=0'>Create New #tranname#</a> ||  --->
		<cfif alcreate eq 1><cfif getgeneralinfo.invoneset neq '1' and tran eq 'INV'>
		  <a href='transaction0.cfm?tran=#tran#'>Create New #tranname#</a>
		<cfelse>
		  <a href='transaction1.cfm?ttype=create&tran=#tran#&nexttranno=&bcode=&dcode=&first=0'>Create New #tranname#</a>
		</cfif> ||</cfif> 
		<a href='transaction.cfm?tran=#tran#'>List all #tranname#</a> || 
		<a href='stransaction.cfm?tran=#tran#'>Search For #tranname#</a>
		<!---<cfif tran eq 'SO' and hcomid eq 'MSD'>
		|| <a href='transaction_report.cfm?type=10'>#tranname# Reports</a> 
		</cfif>--->
	</h4>
</cfoutput>

	<!--- <form action="trancmentsearch.cfm?tran=#tran#&stype=#tranname#&type1=#url.type1#&nexttranno=#nexttranno#&itemno=#itemno#&service=#service#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#" method="post"> --->
<cfoutput>

<cfif submit eq "">
	<form name='form1' method='post' action='' onsubmit='return validate()'>
</cfif>
    <cfif service neq "">
	<input type='hidden' name="service" value="#service#">
	<cfelse>
	<input type='hidden' name="service" value="">
	</cfif>
    <input type='hidden' name='tran' value='#tran#'>
    <input name='type' value='Inprogress' type='hidden'>
	<input name='agenno' value='#agenno#' type='hidden'>
	<cfif IsDefined('FORM.UpdUnitCost')>
	  <input type='hidden' name='UpdUnitCost' value='UpdCost'>
	</cfif>
  
    <cfif mode eq 'Add'>
      <input type='hidden' name='currrate' value='#currrate#'>
      <input type='hidden' name='refno3' value='#refno3#'>
      <input type='hidden' name='mode' value='ADD'>
      <input type='hidden' name='nexttranno' value='#nexttranno#'>
      <cfquery datasource='#dts#' name='getartran'>
      select * from artran where refno= '#nexttranno#' and type = '#tran#' 
      </cfquery>
      <!--- <cfset dd=dateformat('#now()#', 'DD')>
   		<cfif dd greater than '12'>
      		<cfset nDateNow=dateformat('#now()#','YYYYMMDD')>
     	<cfelse>
     		<cfset nDateNow=dateformat('#now()#','YYYYDDMM')>
    	</cfif> --->
      <input type='hidden' name='custno' value='#getartran.custno#'>
      <input type='hidden' name='readperiod' value='#getartran.fperiod#'>
      <input type='hidden' name='nDateCreate' value='#getartran.wos_date#'>
      <!--- <input type='hidden' name='nDateNow' value='#nDateNow#'>--->
      <input type='hidden' name='invoicedate' value="#dateformat(getartran.wos_date,"dd/mm/yyyy")#">
      <cfelseif mode eq 'Edit'>
	  <input type='hidden' name='itemcount' value='#itemcount#'>	
      <input type ='hidden' name='mode' value='Edit'>
      <input type='hidden' name='nexttranno' value='#nexttranno#'>
      <cfquery datasource='#dts#' name='getartran'>
      select * from artran where refno= '#nexttranno#' and type = '#tran#' 
      </cfquery>
      <!--- 		<cfset dd=dateformat('#now()#', 'DD')>
   		<cfif dd greater than '12'>
      		<cfset nDateNow=dateformat('#now()#','YYYYMMDD')>
     	<cfelse>
     		<cfset nDateNow=dateformat('#now()#','YYYYDDMM')>
    	</cfif> --->
      <input type='hidden' name='currrate' value='#currrate#'>
      <input type='hidden' name='refno3' value='#refno3#'>
      <input type='hidden' name='custno' value='#getartran.custno#'>
      <input type='hidden' name='readperiod' value='#getartran.fperiod#'>
      <input type='hidden' name='nDateCreate' value='#getartran.wos_date#'>
      <!--- <input type='hidden' name='nDateNow' value='#nDateNow#'>--->
      <input type='hidden' name='invoicedate' value="#dateformat(getartran.wos_date,"dd/mm/yyyy")#">
      <cfelse>
      <input type='hidden' name='mode' value='Delete'>
      <input type='hidden' name='nexttranno' value='#nexttranno#'>
	  <input type='hidden' name='itemcount' value='#itemcount#'>
      <cfquery datasource='#dts#' name='getartran'>
      select * from artran where refno= '#nexttranno#' and type = '#tran#' 
      </cfquery>
      <!--- <cfset dd=dateformat('#now()#', 'DD')>
		<cfif dd greater than '12'>
			<cfset nDateNow=dateformat('#now()#','YYYYMMDD')>
		<cfelse>
			<cfset nDateNow=dateformat('#now()#','YYYYDDMM')>
		</cfif> --->
      <input type='hidden' name='currrate' value='#currrate#'>
      <input type='hidden' name='refno3' value='#refno3#'>
      <input type='hidden' name='custno' value='#getartran.custno#'>
      <input type='hidden' name='readperiod' value='#getartran.fperiod#'>
      <input type='hidden' name='nDateCreate' value='#getartran.wos_date#'>
      <!--- <input type='hidden' name='nDateNow' value='#nDateNow#'>--->
      <input type='hidden' name='invoicedate' value="#dateformat(getartran.wos_date,"dd/mm/yyyy")#">
    </cfif>
    <table align='center' class='data' width='75%' cellspacing="0">
      <tr> 
        <th colspan='6'>#tranname# Body</th>
      </tr>
      <tr> 
        <th>Item Code</th>
        <td colspan='3'> <cfif mode eq 'Delete' or mode eq 'Edit'>
            #url.itemno# 
            <input type='hidden' name='itemno' value='#url.itemno#'>
            <cfelse>
            #itemno# 
            <input type='hidden' name='itemno' value='#itemno#'>
          </cfif> </td>
        <th>Balance on Hand</th>
        <td><input name='balance' type='text' size='10' maxlength='10' value='#balonhand#' readonly></td>
      </tr>
      <tr> 
        <th rowspan='2'>Description</th>
        <td colspan='5' nowrap> <cfif mode eq 'Delete' or mode eq 'Edit'>
            <!--- #desp# --->
            <input name='desp' type='text' value='#desp#' size='60' maxlength='60'>
            <cfelse>
            <input name='desp' type='text' value='#getproductdetails.desp#' size='60' maxlength='60'>
          </cfif></td>
      </tr>
      <tr> 
        <td colspan='5' nowrap> <cfif mode eq 'Delete' or mode eq 'Edit'>
            <input name='despa' type='text' value='#despa#' size='60' maxlength='70'>
            <cfelse>
            <input type='text' name='despa' value='#getproductdetails.despa#' size='60' maxlength='70'>
          </cfif> </td>
      </tr>
      <tr> 
        <th>Comment</th>
        <td colspan='3'> <textarea name='comment' cols='70' rows='5' id='comment'>#comment#</textarea> 
        </td>
        <td colspan='2'> <cfif type1 neq "delete">
            <input type="submit" name="Submit" value="Search Comment">
          </cfif> 
          <!--- onclick="window.location='trancmentsearch.cfm?comment=#comment#&tran=#tran#&stype=#tranname#&type1=#url.type1#&nexttranno=#nexttranno#&itemno=#itemno#&service=#service#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#'; return true;" --->
          <!--- <cfif #url.type1# eq 'Add'>
			<a href='trancmentsearch.cfm?comment=#comment#&tran=#tran#&stype=#tranname#&type1=#url.type1#&nexttranno=#nexttranno#&itemno=#itemno#&service=#service#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#'>SEARCH 
            COMMENT</a> 
            <cfelseif #url.type1# eq 'Edit'>
            <a href='trancmentsearch.cfm?tran=#tran#&stype=#tranname#&type1=#url.type1#&nexttranno=#nexttranno#&itemno=#itemno#&service=#service#&itemcount=#itemcount#&ndatecreate=#ndatecreate#&currrate=#currrate#&refno3=#refno3#&agenno=#agenno#'>SEARCH 
            COMMENT</a> </cfif> --->
          <br> <br> <br> <br> <input type='Button' name='Copy' value='Copy Item Remark' onClick='JavaScript:CopyItemRemark()'> 
        </td>
      </tr>
      <cfif getitembal.recordcount eq 0>
        <tr> 
          <th>Service Part</th>
          <td colspan='5'><select name='sv_part'>
              <option value=''>Choose an Part</option>
              <cfloop query='getAllItem'>
                <!---           <option value='#getlocation.location#'<cfif #xlocation# eq #getlocation.location#>Selected </cfif>>#location#</option> --->
                <option value='#getAllItem.Itemno#'<cfif #xsv_part# eq #getAllItem.Itemno#>Selected </cfif>>#getAllItem.itemno# 
                - #getAllItem.desp#</option>
                <!---                 <option value='#getAllItem.Itemno#'>#getAllItem.itemno# - #getAllItem.desp#</option> --->
              </cfloop>
            </select></td>
        </tr>
        <tr> 
          <th>Service Cost</th>
          <td colspan='5'><input type='text' name='sercost' maxlength='14' value='#numberformat(sercost,'_.__')#' size='14'></td>
        </tr>
        <cfelse>
        <input type='hidden' name='sv_part' maxlength='14' value='' size='14'>
        <input type='hidden' name='sercost' maxlength='14' value='' size='14'>
      </cfif>
      <tr> 
        <th rowspan="2">Unit of Measurement</th>
        <td colspan='3' nowrap> <cfif getitembal.recordcount eq 0>
            <input type='text' name='unit' maxlength='12' value='#unit#' size='20'>
            <cfelse>
            <input type='text' name='unit' maxlength='12' value='#unit#' size='20' readonly>
          </cfif> </td>
        <th nowrap>Qty</th>
        <td> 
          <!--- <cfinput name='qty' type='text' id='qty' size='10' maxlength='10' value='#qty#' required='yes' message='Please key in the quantity.' validate='integer'> --->
          <!--- Use to check the Qty cannot more the qty balance on hand --->
          <cfif #getGeneralInfo.negstk# eq "0">
            <cfif #tran# eq 'PR' or #tran# eq 'DO' or #tran# eq 'INV' or #tran# eq 'CS' or #tran# eq 'DN' or #tran# eq 'ISS' or #tran# eq 'OAR'>
              <input type='hidden' name='CompareQty' value='Y'>
              <input type='hidden' name='minimum' value='#getitembal.minimum#'>
              <cfelse>
              <input type='hidden' name='CompareQty' value='N'>
            </cfif>
            <cfelse>
            <!--- Negative Stock is allow, so no need to check. --->
            <input type='hidden' name='CompareQty' value='N'>
          </cfif> <input name='qty' type='text' size='10' maxlength='10' value='#qty#'> 
        </td>
      </tr>
      <tr> 
        <td colspan='3' nowrap></td>
        <th>Price</th>
        <td><input name='price' type='text' size='10' maxlength='10' value='#numberformat(price,stDecl_UPrice)#'<cfif lcase(hcomid) eq "gel_i" and husergrpid neq "Admin" and husergrpid neq "Super">readonly</cfif>></td>
      </tr>
      <tr> 
        <th>Location</th>
        <td> <select name='location'>
            <option value=''>Choose a Location</option>
            <cfloop query='getlocation'>
              <option value='#getlocation.location#'<cfif #xlocation# eq #getlocation.location#>Selected </cfif>>#location#</option>
            </cfloop>
          </select> </td>
        <th nowrap>GL A/C</th>
        <td><input name='gltradac' type='text' value='#gltradac#' size='10' maxlength='8'></td>
        <th>Disc (%)</th>
        <td> <input name='dispec1' type='text' value='#numberformat(dispec1,stDecl_Discount)#' validate='float' size='10' maxlength='7' required='yes' message='Please input a value for Discount 1(%)(0-100).' <cfif lcase(hcomid) eq "gel_i" and husergrpid neq "Admin" and husergrpid neq "Super">readonly</cfif>> 
        </td>
      </tr>
      <tr> 
        <th nowrap>#getgeneralinfo.brem1#</th>
        <td nowrap> <input type='text' name='requestdate' maxlength='40' value='#brem1#' size='20'>
        </td>
        <th nowrap>#getgeneralinfo.brem2#</th>
        <td nowrap> <input type='text' name='crequestdate' maxlength='40' value='#brem2#' size='20'>
        </td>
        <td></td>
        <td> <input name='dispec2' type='text' value='#numberformat(dispec2,stDecl_Discount)#' validate='float' size='10' maxlength='7' required='yes' message='Please input a value for Discount 2(%)(0-100).' <cfif lcase(hcomid) eq "gel_i" and husergrpid neq "Admin" and husergrpid neq "Super">readonly</cfif>></tr>
      <tr> 
        <th>#getgeneralinfo.brem3#</th>
        <td><input type='text' name='brem3' maxlength='40' value='#brem3#' size='20'></td>
        <th nowrap>#getgeneralinfo.brem4#</th>
        <td><input type='text' name='brem4' maxlength='40' value='#brem4#' size='20'></td>
        <td>&nbsp;</td>
        <td> <input name='dispec3' type='text' value='#numberformat(dispec3,stDecl_Discount)#' validate='float' size='10' maxlength='7' required='yes' message='Please input a value for Discount 3(%)(0-100).' <cfif lcase(hcomid) eq "gel_i" and husergrpid neq "Admin" and husergrpid neq "Super">readonly</cfif>> 
      </tr>
      <tr> 
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <th>Tax (%)</th>
        <td><input name='taxpec1' type='text' value='#taxpec1#' size='10' maxlength='5' <cfif lcase(hcomid) eq "gel_i" and husergrpid neq "Admin" and husergrpid neq "Super">readonly</cfif>></td>
      </tr>
      <tr> 
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td nowrap align="right"> <input type='button' name='back' value='back' onClick='javascript:history.back()'> 
          <input type='submit' name='Submit' value='  #mode#  '> 
        </td>
      </tr>
      <cfif #url.type1# eq 'Add' and isservice neq 1>
        <cfif getrecommendprice.recordcount gt 0>
		<tr> 
          <th colspan="6">Recommended Price (#refno3#)</th>
        </tr>
        <tr> 
          <td colspan="2"><strong>Recommended 
            Price</strong> - #numberformat(getrecommendprice.price,",.____")#</td>
          <td colspan="2"><strong>Disc 
            1</strong> - #decimalformat(getrecommendprice.dispec)#%<br> <strong>Disc 2</strong> - #decimalformat(getrecommendprice.dispec2)#%<br> <strong>Disc 3</strong> - #decimalformat(getrecommendprice.dispec3)#%</td>
          <td colspan="2"><strong>Net 
            Price</strong> - #numberformat(getrecommendprice.netprice,",.____")#</td>
        </tr>
		</cfif>
      </cfif>
      <cfif getitembal.recordcount neq 0>
        <tr> 
          <th colspan='6'>Last 3 Price / Discount History</th>
        </tr>
        <tr> 
          <td><strong>Date</strong></td>
          <td><strong>Price</strong></td>
          <td><strong>Discount 
            %</strong></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>#date1#</td>
          <td>#NumberFormat(pricehis1,stDecl_UPrice)#</td>
          <td>#disc1#</td>
          <td></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>#date2#</td>
          <td>#NumberFormat(pricehis2,stDecl_UPrice)# 
            <!--- <cfif mode eq 'Delete' or mode eq 'Edit'>
   		   	   #numberformat(gethis.pricehis2,'____.__')#
  	  		  <cfelse>
	  	 	   #numberformat(getproductdetails.pricehis2,'____.__')#
	  		  </cfif> --->
          </td>
          <td>#disc2#</td>
          <td><!--- #currrate# ---></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>#date3#</td>
          <td>#NumberFormat(pricehis3,stDecl_UPrice)#</td>          
          <td>#disc3#</td>
          <td></td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </cfif>
    </table>
  </form>
</cfoutput> 
<script type="text/javascript">
function validate() {
  if(document.form1.qty.value == '') {
	alert ("Empty Quantity!" + '\n\n' + "Please key in the quantity.");
	document.form1.qty.focus();
	return false;
  }

  if(isNaN(document.form1.qty.value)) {
	alert ("Please key in quantity in numeric.");
	document.form1.qty.focus();
	return false;
  }
  
  var xCompareQty = document.form1.CompareQty.value;
  
  if(xCompareQty=='Y') {
    var aQty = document.form1.qty.value;
    var aQOH = document.form1.balance.value;
	var aMin = document.form1.minimum.value;
 
    if((parseFloat(aQOH) - parseFloat(aQty)) < parseFloat(aMin)) {
		if (parseFloat(aMin) == '0')
		{
			var xConfirm=confirm("The quantity is more than Balance On Hand!" + '\n\n' + "Do you want to proceed?");
		}
		else
		{
			var xConfirm=confirm("Stock below minimum level!" + '\n\n' + "Do you want to proceed?");
		}		
	  
      	if (xConfirm==true) {
	   	 	return true;
     	}
     	else 
		{
	   	 	document.form1.qty.focus();
	   	 	return false;
      	}
    }
  }
  return true;
}

function ChkQty() {
//  if(document.form1.qty.value == '') {
//	alert ("Empty Quantity!" + '\n\n' + "Please key in the quantity.");
//	document.form1.qty.focus();
//	return false;
//  }

//  if(isNaN(document.form1.qty.value)) {
//	alert ("Please quantity in numeric.");
//	document.form1.qty.focus();
//	return false;
//  }
  
//  var aQty = document.form1.qty.value;
//  var aQOH = document.form1.balance.value;
 
//  if(parseFloat(aQty) > parseFloat(aQOH)) {
//	var xConfirm=confirm("The quantity is more then Balance On Hand!" + '\n\n' + "Do you want to proceed?");
//    if (xConfirm==true) {
//	  return true;
//    }
//    else {
//	  document.form1.qty.focus();
//	  return false;
//    }
//  }
  return true;
}

function CopyItemRemark() {
  <cfoutput>
    <cfquery name='getItemRemark' datasource='#dts#'>
      Select remark1,remark2,remark3,remark4,remark5,remark6,remark7,remark8,remark9,remark10,
	  remark11,remark12,remark13,remark14,remark15,remark16,remark17,remark18,remark19,remark20,
	  remark21,remark22,remark23,remark24,remark25,remark26,remark27,remark28,remark29,remark30
	  from icitem where itemno = '#itemno#'
    </cfquery>

    <cfset NewLine = JSStringFormat (chr(13))>

	<cfif #getItemRemark.remark1# neq ''>
       document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark1#';
    </cfif>

	<cfif #getItemRemark.remark2# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark2#';
	</cfif>

	<cfif #getItemRemark.remark3# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark3#';
    </cfif>

	<cfif #getItemRemark.remark4# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark4#';
    </cfif>

	<cfif #getItemRemark.remark5# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark5#';
    </cfif>

	<cfif #getItemRemark.remark6# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark6#';
    </cfif>

	<cfif #getItemRemark.remark7# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark7#';
    </cfif>

	<cfif #getItemRemark.remark8# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark8#';
    </cfif>

	<cfif #getItemRemark.remark9# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark9#';
    </cfif>

	<cfif #getItemRemark.remark10# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark10#';
    </cfif>

	<cfif #getItemRemark.remark11# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark11#';
    </cfif>

	<cfif #getItemRemark.remark12# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark12#';
    </cfif>

	<cfif #getItemRemark.remark13# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark13#';
    </cfif>

	<cfif #getItemRemark.remark14# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark14#';
    </cfif>

	<cfif #getItemRemark.remark15# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark15#';
    </cfif>

	<cfif #getItemRemark.remark16# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark16#';
    </cfif>

	<cfif #getItemRemark.remark17# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark17#';
    </cfif>

	<cfif #getItemRemark.remark18# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark18#';
    </cfif>

	<cfif #getItemRemark.remark19# neq ''>
      document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark19#';
    </cfif>

	<cfif #getItemRemark.remark20# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark20#';
	</cfif>

	<cfif #getItemRemark.remark21# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark21#';
	</cfif>

	<cfif #getItemRemark.remark22# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark22#';
	</cfif>

	<cfif #getItemRemark.remark23# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark23#';
	</cfif>

	<cfif #getItemRemark.remark24# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark24#';
	</cfif>

	<cfif #getItemRemark.remark25# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark25#';
	</cfif>

	<cfif #getItemRemark.remark26# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark26#';
	</cfif>

	<cfif #getItemRemark.remark27# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark27#';
	</cfif>

	<cfif #getItemRemark.remark28# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark28#';
	</cfif>

	<cfif #getItemRemark.remark29# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark29#';
	</cfif>

	<cfif #getItemRemark.remark30# neq ''>
	  document.form1.comment.value = document.form1.comment.value + '#NewLine#' + '#getItemRemark.remark30#';
	</cfif>
  </cfoutput>
  return true;
}
</script> 
</body>
</html>
