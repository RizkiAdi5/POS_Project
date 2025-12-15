<cfinclude template="../../CFC/convert_single_double_quote_script.cfm">
<html>
<head>
<title>Product Page</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>
<script type="text/javascript" src="/scripts/jscripts/tiny_mce/tiny_mce.js"></script>
<script type="text/javascript" src="/scripts/highslide/highslide.js"></script>
<link rel="stylesheet" type="text/css" href="/scripts/highslide/highslide.css" />
<script type="text/javascript">
//<![CDATA[
hs.registerOverlay({
	html: '<div class="closebutton" onclick="return hs.close(this)" title="Close"></div>',
	position: 'top right',
	fade: 2 // fading the semi-transparent overlay looks bad in IE
});


hs.graphicsDir = '/scripts/highslide/graphics/';
hs.wrapperClassName = 'borderless';
//]]>
</script>

<script type="text/javascript">
		function showpic(picname)
		{
		return hs.expand(picname)
		}
		function insertSymbol1(sym)
			{
			var textexist = document.getElementById('desp').value;
			var symboladd = document.getElementById(sym).value;
			document.getElementById('desp').value = textexist + symboladd;
			}
			function insertSymbol2(sym)
			{
			var textexist = document.getElementById('despa').value;
			var symboladd = document.getElementById(sym).value;
			document.getElementById('despa').value = textexist + symboladd;
			}
			
	function texteditor(mcetype)
	{
			
		if (mcetype == "MCE1")
		{
		var elem = "desp";
		}
		else
		{
		var elem = "despa";
		}
		document.getElementById(mcetype).style.visibility = "hidden";
		tinyMCE.init({
    mode : "exact",
	elements : elem,
    theme : "advanced",
    theme_advanced_buttons1 : "fontselect,fontsizeselect,formatselect,bold,italic,underline,strikethrough,separator,sub,sup,separator,cut,copy,paste,undo,redo",
    theme_advanced_buttons2 : "justifyleft,justifycenter,justifyright,justifyfull,separator,numlist,bullist,outdent,indent,separator,forecolor,backcolor,separator,hr,link,unlink,table,code,separator,charmap",
    theme_advanced_buttons3 : "",
    theme_advanced_fonts : "Arial=arial,helvetica,sans-serif,Courier New=courier new,courier,monospace,Georgia=georgia,times new roman,times,serif,Tahoma=tahoma,arial,helvetica,sans-serif,Times=times new roman,times,serif,Verdana=verdana,arial,helvetica,sans-serif",
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_statusbar_location : "bottom",
    plugins : 'safari,asciimath,asciisvg,table,inlinepopups',
   
        
    content_css : "/stylesheet/content.css",
	forced_root_block : false,
   force_br_newlines : true,
   force_p_newlines : false

});
			
		}

	</script>

<script language="javascript" type="text/javascript" src="../../scripts/collapse_expand_single_item.js"></script>
<script language='JavaScript'>
function imposeMaxLength(Object, MaxLen)
{
  return (Object.value.length <= MaxLen);
}


	function validate()
	{
		if(document.CustomerForm.itemno.value=='')
		{
			alert("Your Item's No. cannot be blank.");
			document.CustomerForm.itemno.focus();
			return false;
		}
		
		if(document.CustomerForm.com_id.value == 'mhsl_i' || document.CustomerForm.com_id.value == 'mpt_i' || document.CustomerForm.com_id.value == 'mhca_i'){
			if(document.CustomerForm.desp.value == ''){
				alert("Your Item's Description cannot be blank.");
				document.CustomerForm.desp.focus();
				return false;
			}
			else if(document.CustomerForm.CATEGORY.value == ''){
				alert("Your Item's Category cannot be blank.");
				document.CustomerForm.CATEGORY.focus();
				return false;
			}
			else if(document.CustomerForm.WOS_GROUP.value == ''){
				alert("Your Item's Group cannot be blank.");
				document.CustomerForm.WOS_GROUP.focus();
				return false;
			}
			else if(document.CustomerForm.UNIT.value == ''){
				alert("Your Item's Unit of Measurement cannot be blank.");
				document.CustomerForm.UNIT.focus();
				return false;
			}
		}else{
			
			if(document.CustomerForm.WOS_GROUP.value == '')
			{
				a=document.CustomerForm.graded1.checked;
				if(a==true)
				{			
					alert("A Graded Item Must Assign A Group !");
					document.CustomerForm.WOS_GROUP.focus();
					return false;
				}
			}
		}
		if(document.CustomerForm.com_id.value == 'glenn_i'){
			if(document.CustomerForm.UNIT.value == ''){
				alert("Your Item's Unit of Measurement cannot be blank.");
				document.CustomerForm.UNIT.focus();
				return false;
			}else if(document.CustomerForm.PRICE.value == ''){
				alert("Your Item's Unit Selling Price cannot be blank.");
				document.CustomerForm.PRICE.focus();
				return false;
			}
			else if(document.CustomerForm.SALEC.value == ''){
				alert("Your Item's Credit Sales cannot be blank.");
				document.CustomerForm.SALEC.focus();
				return false;
			}
		}
		
		return true;
	}
	function change_picture(picture)
	{
		var encode_picture = encodeURI(picture);
		show_picture.location="icitem_image.cfm?pic3="+encode_picture;
	}
	function delete_picture(picture)
	{
	var answer =confirm("Are you sure wan to delete picture "+picture);
	if (answer)
	{
		var encode_picture = encodeURI(picture);
		show_picture.location="icitem_image.cfm?delete=true&picture="+encode_picture;
		var elSel = document.getElementById('picture_available');
		  var i;
		  for (i = elSel.length - 1; i>=0; i--) {
			if (elSel.options[i].selected) {
			  elSel.remove(i);
			}
		  }
	}
	
	}
	
	function uploading_picture(pic_name)
	{
		var new_pic_name1 = new String(pic_name);
		var new_pic_name2 = new_pic_name1.split(/[-,/,\\]/g);
		document.getElementById("picture_name").value=new_pic_name2[new_pic_name2.length-1];
	}
	function add_option(pic_name)
	{
		var agree = confirm("Are You Sure ?");
		if (agree==true)
		{
			var detection=0;
			var totaloption=document.getElementById("picture_available").length-1;

			for(var i=0;i<=totaloption;++i)
			{
				if(document.getElementById("picture_available").options[i].value==pic_name)
				{
					detection=1;
					break;
				}
			}
			
			if(detection!=1)
			{
				var a=new Option(pic_name,pic_name);
				document.getElementById("picture_available").options[document.getElementById("picture_available").length]=a;
			}
			document.getElementById("picture_available").value=pic_name;
			return true;
		}
		else
		{
			return false;
		}
	}
	
	function calculate_price3(fixnum){
		if(isNaN(document.CustomerForm.MURATIO.value)){
			alert("The value is not a number. Please try again");
		}
		else{
			if(document.CustomerForm.UCOST.value == ''){
				var costprice = 0;
			}
			else{
				var costprice = document.CustomerForm.UCOST.value;
			}
			var price3 = document.CustomerForm.MURATIO.value * document.CustomerForm.UCOST.value;
			price3 = price3.toFixed(fixnum);
			document.CustomerForm.PRICE3.value = price3;
		}
	}
	
	function getSupp(type,option){
		var inputtext = document.CustomerForm.searchsupp.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getSuppResult);	
	}
	
	function getSuppResult(suppArray){
		DWRUtil.removeAllOptions("supp");
		DWRUtil.addOptions("supp", suppArray,"KEY", "VALUE");
	}
	

</script>
</head>

<cfquery name='getgsetup' datasource='#dts#'>
  Select * from gsetup
</cfquery>

<cfquery name='getlastbarcodeno' datasource='#dts#'>
  Select lastusedno from refnoset where type='BARC' and counter='1'
</cfquery>

<cfif getlastbarcodeno.recordcount eq 0>
	<cfquery name="addbarcrunningno" datasource="#dts#">
		insert into refnoset (type,lastusedno,counter) values ('BARC','00000001',1);
	</cfquery>
    
    <cfquery name='getlastbarcodeno' datasource='#dts#'>
 		 Select lastusedno from refnoset where type='BARC' and counter='1'
	</cfquery>
</cfif>

		<cftry>
        <cfinvoke component="cfc.IncrementValue" method="getIncreament" input="#getlastbarcodeno.lastusedno#" returnvariable="barcoderunno"/>
		<cfcatch>
		<cfinvoke component="cfc.refno" method="processNum" oldNum="#getlastbarcodeno.lastusedno#" returnvariable="barcoderunno" />	
		</cfcatch>
        </cftry>
        
        <cfquery name="checkexistbarcode" datasource="#dts#">
            select barcode from icitem where barcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#barcoderunno#">
        </cfquery>
		<cfif checkexistbarcode.recordcount neq 0>
        
        <cfset refnocheck = 0>
        <cfset barcode1 = checkexistbarcode.barcode>
        <cfloop condition="refnocheck eq 0">
        <cftry>
        <cfinvoke component="cfc.IncrementValue" method="getIncreament" input="#barcode1#" returnvariable="barcoderunno"/>
		<cfcatch>
		<cfinvoke component="cfc.refno" method="processNum" oldNum="#barcode1#" returnvariable="barcoderunno" />	
		</cfcatch>
        </cftry>
        <cfquery name="checkexistence" datasource="#dts#">
       	select barcode from icitem where barcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#barcoderunno#">
        </cfquery>
        <cfif checkexistence.recordcount eq 0>
        <cfset refnocheck = 1>
        <cfelse>
        <cfset barcode1 = barcoderunno>
		</cfif>
        </cfloop>
        
        </cfif>
        
        

<!--- Control The Decimal Point --->
<cfquery name='getgsetup2' datasource='#dts#'>
  Select * from gsetup2
</cfquery>

<cfset iDecl_UPrice = getgsetup2.Decl_Uprice>
<cfset stDecl_UPrice = '.'>

<cfloop index='LoopCount' from='1' to='#iDecl_UPrice#'>
  <cfset stDecl_UPrice = stDecl_UPrice & '_'>
</cfloop>

<!--- Add On 09-03-2010 --->
<cfquery name="getbrand" datasource="#dts#">
	select brand,desp from brand order by brand
</cfquery>

<body>
<cfoutput>
	<cfif url.type eq 'Edit'>
		<cfquery datasource='#dts#' name='getitem'>
			Select * from icitem where itemno='#url.itemno#'
	  	</cfquery>
		
		<cfset edi_id=getitem.edi_id>
	  	<cfset ItemNo=getitem.itemno>
	  	<cfset desp=getitem.desp>
	  	<cfset despa=getitem.despa>
        <cfset comment=getitem.comment>
	  	<cfset AITEMNO=getitem.AITEMNO>
	  	<cfset xbrand=getitem.BRAND>
	  	<cfset xCATEGORY=getitem.CATEGORY>
	  	<cfset xSUPP=getitem.SUPP>
	  	<cfset MINIMUM=getitem.MINIMUM>
	  	<cfset xSIZEID=getitem.SIZEID>
	  	<cfset PACKING=getitem.PACKING>
	  	<cfset MAXIMUM=getitem.MAXIMUM>
	  	<cfset xCOSTCODE=getitem.COSTCODE>
	  	<cfset REORDER=getitem.REORDER>
	  	<cfset xCOLORID=getitem.COLORID>
	  	<cfset xshelf=getitem.shelf>
        <cfset taxcode = getitem.taxcode>
	  	<cfset xWOS_GROUP=getitem.WOS_GROUP>
		<CFSET xUNIT=getitem.UNIT>
	  	<CFSET WQFORMULA=getitem.WQFORMULA>
	  	<CFSET WPFORMULA=getitem.WPFORMULA>
	  	<CFSET QTYBF=getitem.QTYBF>
	  	<CFSET UCOST=getitem.UCOST>
	  	<CFSET PRICE=getitem.PRICE>
	  	<CFSET PRICE2=getitem.PRICE2>
	  	<CFSET PRICE3=getitem.PRICE3>
        <CFSET PRICE4=getitem.PRICE4>
        <CFSET PRICE5=getitem.PRICE5>
        <CFSET PRICE6=getitem.PRICE6>
	  	<CFSET PRICE_MIN=getitem.PRICE_MIN>
	  	<cfset graded=getitem.graded>
	  	<CFSET MURATIO=getitem.MURATIO>
	  	<CFSET QTY2=getitem.QTY2>
	  	<CFSET QTY3=getitem.QTY3>
	  	<CFSET QTY4=getitem.QTY4>
	  	<CFSET QTY5=getitem.QTY5>
	  	<CFSET QTY6=getitem.QTY6>
	  	<CFSET SALEC=getitem.SALEC>
	  	<CFSET SALECSC=getitem.SALECSC>
	  	<CFSET SALECNC=getitem.SALECNC>
	  	<CFSET PURC=getitem.PURC>
	  	<CFSET PURPREC=getitem.PURPREC>
	  	<CFSET WSERIALNO=getitem.WSERIALNO>
		<cfset nonstkitem = getitem.nonstkitem>
	  	<CFSET REMARK1=getitem.REMARK1>
	  	<CFSET REMARK2=getitem.REMARK2>
	  	<CFSET REMARK3=getitem.REMARK3>
	  	<CFSET REMARK4=getitem.REMARK4>
	  	<CFSET REMARK5=getitem.REMARK5>
	  	<CFSET REMARK6=getitem.REMARK6>
	  	<CFSET REMARK7=getitem.REMARK7>
	  	<CFSET REMARK8=getitem.REMARK8>
	  	<CFSET REMARK9=getitem.REMARK9>
	  	<CFSET REMARK10=getitem.REMARK10>
	  	<CFSET REMARK11=getitem.REMARK11>
	  	<CFSET REMARK12=getitem.REMARK12>
	  	<CFSET REMARK13=getitem.REMARK13>
	  	<CFSET REMARK14=getitem.REMARK14>
	  	<CFSET REMARK15=getitem.REMARK15>
		<CFSET REMARK16=getitem.REMARK16>
		<CFSET REMARK17=getitem.REMARK17>
		<CFSET REMARK18=getitem.REMARK18>
		<CFSET REMARK19=getitem.REMARK19>
		<CFSET REMARK20=getitem.REMARK20>
		<CFSET REMARK21=getitem.REMARK21>
		<CFSET REMARK22=getitem.REMARK22>
		<CFSET REMARK23=getitem.REMARK23>
		<CFSET REMARK24=getitem.REMARK24>
		<CFSET REMARK25=getitem.REMARK25>
		<CFSET REMARK26=getitem.REMARK26>
		<CFSET REMARK27=getitem.REMARK27>
		<CFSET REMARK28=getitem.REMARK28>
		<CFSET REMARK29=getitem.REMARK29>
		<CFSET REMARK30=getitem.REMARK30>
		<!--- ADD ON 260908, 2ND UNIT --->
		<cfset UNIT2 = getitem.UNIT2>
		<cfset FACTOR1 = getitem.FACTOR1>
		<cfset FACTOR2 = getitem.FACTOR2>
		<cfset PRICEU2 = getitem.PRICEU2>
		<!--- ADD ON 260908, 2ND UNIT --->
		<cfset photo = getitem.photo>
	  	<cfset mode='Edit'>
	  	<cfset title='Edit Item'>
	  	<cfset button='Edit'>
        <cfset fucost = getitem.fucost>
		<cfset fprice = getitem.fprice>
        <cfset custprice_rate = getitem.custprice_rate>
        <cfset fcurrcode = getitem.fcurrcode>
        <cfset barcode = getitem.barcode>
        <cfset comm = getitem.commlvl>
        <cfset costformula = getitem.costformula>
        <cfset created_on = getitem.created_on>
        <cfset itemtype = getitem.itemtype>
	</cfif>

	<cfif url.type eq 'Delete'>
		<cfquery datasource='#dts#' name='getitem'>
			Select * from icitem where itemno='#url.itemno#'
	  	</cfquery>
		
		<cfset edi_id=getitem.edi_id>
	  	<cfset ItemNo=getitem.itemno>
	  	<cfset desp=getitem.desp>
	  	<cfset despa=getitem.despa>
        <cfset comment=getitem.comment>
	  	<cfset AITEMNO=getitem.AITEMNO>
	  	<cfset xbrand=getitem.BRAND>
	  	<cfset xCATEGORY=getitem.CATEGORY>
	  	<cfset xSUPP=getitem.SUPP>
	  	<cfset MINIMUM=getitem.MINIMUM>
	  	<cfset xSIZEID=getitem.SIZEID>
	  	<cfset PACKING=getitem.PACKING>
	  	<cfset MAXIMUM=getitem.MAXIMUM>
	  	<cfset xCOSTCODE=getitem.COSTCODE>
	  	<cfset REORDER=getitem.REORDER>
	  	<cfset xCOLORID=getitem.COLORID>
	  	<cfset xshelf=getitem.shelf>
        <cfset taxcode = getitem.taxcode>
	  	<cfset xWOS_GROUP=getitem.WOS_GROUP>
		<CFSET xUNIT=getitem.UNIT>
	  	<CFSET WQFORMULA=getitem.WQFORMULA>
	  	<CFSET WPFORMULA=getitem.WPFORMULA>
	  	<CFSET QTYBF=getitem.QTYBF>
	  	<CFSET UCOST=getitem.UCOST>
	  	<CFSET PRICE=getitem.PRICE>
	  	<CFSET PRICE2=getitem.PRICE2>
	  	<CFSET PRICE3=getitem.PRICE3>
        <CFSET PRICE4=getitem.PRICE4>
        <CFSET PRICE5=getitem.PRICE5>
        <CFSET PRICE6=getitem.PRICE6>
	  	<CFSET PRICE_MIN=getitem.PRICE_MIN>
	  	<cfset graded=getitem.graded>
	  	<CFSET MURATIO=getitem.MURATIO>
	  	<CFSET QTY2=getitem.QTY2>
	  	<CFSET QTY3=getitem.QTY3>
	  	<CFSET QTY4=getitem.QTY4>
	  	<CFSET QTY5=getitem.QTY5>
	  	<CFSET QTY6=getitem.QTY6>
	  	<CFSET SALEC=getitem.SALEC>
	  	<CFSET SALECSC=getitem.SALECSC>
	  	<CFSET SALECNC=getitem.SALECNC>
	  	<CFSET PURC=getitem.PURC>
	  	<CFSET PURPREC=getitem.PURPREC>
	  	<CFSET WSERIALNO=getitem.WSERIALNO>
		<cfset nonstkitem = getitem.nonstkitem>
	  	<CFSET REMARK1=getitem.REMARK1>
	  	<CFSET REMARK2=getitem.REMARK2>
	  	<CFSET REMARK3=getitem.REMARK3>
	  	<CFSET REMARK4=getitem.REMARK4>
	  	<CFSET REMARK5=getitem.REMARK5>
	  	<CFSET REMARK6=getitem.REMARK6>
	  	<CFSET REMARK7=getitem.REMARK7>
	  	<CFSET REMARK8=getitem.REMARK8>
	  	<CFSET REMARK9=getitem.REMARK9>
	  	<CFSET REMARK10=getitem.REMARK10>
	  	<CFSET REMARK11=getitem.REMARK11>
	  	<CFSET REMARK12=getitem.REMARK12>
	  	<CFSET REMARK13=getitem.REMARK13>
	  	<CFSET REMARK14=getitem.REMARK14>
	  	<CFSET REMARK15=getitem.REMARK15>
		<CFSET REMARK16=getitem.REMARK16>
		<CFSET REMARK17=getitem.REMARK17>
		<CFSET REMARK18=getitem.REMARK18>
		<CFSET REMARK19=getitem.REMARK19>
		<CFSET REMARK20=getitem.REMARK20>
		<CFSET REMARK21=getitem.REMARK21>
		<CFSET REMARK22=getitem.REMARK22>
		<CFSET REMARK23=getitem.REMARK23>
		<CFSET REMARK24=getitem.REMARK24>
		<CFSET REMARK25=getitem.REMARK25>
		<CFSET REMARK26=getitem.REMARK26>
		<CFSET REMARK27=getitem.REMARK27>
		<CFSET REMARK28=getitem.REMARK28>
		<CFSET REMARK29=getitem.REMARK29>
		<CFSET REMARK30=getitem.REMARK30>
		<!--- ADD ON 260908, 2ND UNIT --->
		<cfset UNIT2 = getitem.UNIT2>
		<cfset FACTOR1 = getitem.FACTOR1>
		<cfset FACTOR2 = getitem.FACTOR2>
		<cfset PRICEU2 = getitem.PRICEU2>
		<!--- ADD ON 260908, 2ND UNIT --->
		<cfset photo = getitem.photo>
		<cfset mode='Delete'>
	  	<cfset title='Delete Item'>
	  	<cfset button='Delete'>
        <cfset fucost = getitem.fucost>
		<cfset fprice = getitem.fprice>
        <cfset custprice_rate = getitem.custprice_rate>
        <cfset fcurrcode = getitem.fcurrcode>
        <cfset barcode = getitem.barcode>
        <cfset comm = getitem.commlvl>
        <cfset costformula = getitem.costformula>
        <cfset created_on = getitem.created_on>
        <cfset itemtype = getitem.itemtype>
	</cfif>
			
    <cfif url.type eq 'Create'>
    	<cfset edi_id=''>
      	<cfset ItemNo=''>
	  	<cfset desp=''>
	  	<cfset despa=''>
        <cfset comment=''>
	  	<cfset AITEMNO=''>
	  	<cfset xbrand=''>
	  	<cfset xCATEGORY=''>
	  	<cfset xSUPP=''>
	  	<cfset MINIMUM=''>
	  	<cfset xSIZEID=''>
	  	<cfset PACKING=''>
	  	<cfset MAXIMUM=''>
	  	<cfset xCOSTCODE=''>
	  	<cfset REORDER=''>
	  	<cfset xCOLORID=''>
	  	<cfset xshelf=''>
        <cfset taxcode=''>
	  	<cfset xWOS_GROUP=''>
	  	<CFSET xUNIT=''>
	  	<CFSET WQFORMULA=''>
	  	<CFSET WPFORMULA=''>
	  	<CFSET QTYBF=''>
	  	<CFSET UCOST=''>
	  	<CFSET PRICE=''>
	  	<CFSET PRICE2=''>
	  	<CFSET PRICE3=''>
        <CFSET PRICE4=''>
        <CFSET PRICE5=''>
        <CFSET PRICE6=''>
	  	<CFSET PRICE_MIN=''>
	  	<cfset graded = '0'>
	  	<CFSET MURATIO=''>
	  	<CFSET QTY2=''>
	  	<CFSET QTY3=''>
	  	<CFSET QTY4=''>
	  	<CFSET QTY5=''>
	  	<CFSET QTY6=''>
	  	<CFSET SALEC=''>
	  	<CFSET SALECSC=''>
	  	<CFSET SALECnC=''>
	  	<CFSET PURC=''>
	  	<CFSET PURPREC=''>
	  	<CFSET WSERIALNO=''>
		<cfset nonstkitem = "">
	  	<CFSET REMARK1=''>
	  	<CFSET REMARK2=''>
	  	<CFSET REMARK3=''>
	  	<CFSET REMARK4=''>
	  	<CFSET REMARK5=''>
	  	<CFSET REMARK6=''>
	  	<CFSET REMARK7=''>
	  	<CFSET REMARK8=''>
	  	<CFSET REMARK9=''>
	  	<CFSET REMARK10=''>
	  	<CFSET REMARK11=''>
	  	<CFSET REMARK12=''>
	  	<CFSET REMARK13=''>
	  	<CFSET REMARK14=''>
	  	<CFSET REMARK15=''>
		<CFSET REMARK16=''>
		<CFSET REMARK17=''>
		<CFSET REMARK18=''>
		<CFSET REMARK19=''>
		<CFSET REMARK20=''>
		<CFSET REMARK21=''>
		<CFSET REMARK22=''>
		<CFSET REMARK23=''>
		<CFSET REMARK24=''>
		<CFSET REMARK25=''>
		<CFSET REMARK26=''>
		<CFSET REMARK27=''>
		<CFSET REMARK28=''>
		<CFSET REMARK29=''>
		<CFSET REMARK30=''>
		<!--- ADD ON 260908, 2ND UNIT --->
		<cfset UNIT2 = ''>
		<cfset FACTOR1 = 1>
		<cfset FACTOR2 = 1>
		<cfset PRICEU2 = 0>
		<!--- ADD ON 260908, 2ND UNIT --->
		<cfset photo = "">
        <cfset fucost = 0>
		<cfset fprice = 0>
        <cfset custprice_rate = ''>
        <cfset fcurrcode = "">
        <cfset barcode = "">
	  	<cfset mode='Create'>
	  	<cfset title='Create Item'>
	  	<cfset button='Create'>
        <cfset comm = "">
        <cfset costformula = "">
        <cfset created_on = "">
        <cfset itemtype = "">
	</cfif>

	<h1>#title#</h1>
	
    <h4>
		<cfif getpin2.h1310 eq 'T'>
			<a href="icitem2.cfm?type=Create">Creating a New Item</a>
		</cfif>
		<cfif getpin2.h1320 eq 'T'>
			|| <a href="icitem.cfm?">List all Item</a> 
		</cfif>
		<cfif getpin2.h1330 eq 'T'>
			|| <a href="s_icitem.cfm?type=icitem">Search For Item</a> 
		</cfif>
		<cfif getpin2.h1340 eq 'T'>
			|| <a href="p_icitem.cfm">Item Listing</a> 
		</cfif>
			|| <a href="icitem_setting.cfm">More Setting</a> 
		<cfif getpin2.h1350 eq 'T'>|| <a href="printbarcode_filter.cfm">Print Barcode</a></cfif>
        <cfif getpin2.h1311 eq 'T' and getpin2.h13D0 eq 'T'>
		||<a href="edititemexpress.cfm">Edit Item Express</a> 
	</cfif>
    <cfif getpin2.h1311 eq 'T'>
    <cfquery name="checkitemnum" datasource="#dts#">
    select itemno from icitem
    </cfquery>
    <cfif checkitemnum.recordcount lt 400>
    ||<a href="edititemexpress2.cfm">Edit Item Express 2</a> 
    </cfif>
    </cfif>
	</h4>
  </cfoutput>

<cfform name='CustomerForm' action='icitemprocess.cfm' method='post' onsubmit='return validate();'>
  <cfoutput>
    <input type='hidden' name='mode' value='#mode#'>
    <input type='hidden' name='edi_id' value='#edi_id#'>
	<input type='hidden' name='com_id' value='#lcase(HcomID)#'>
    <cfif isdefined('url.express')>
    <input type='hidden' name='express' value='1'>
    </cfif>
    <cfif isdefined('url.ovasexpress')>
    <input type='hidden' name='ovasexpress' value='1'>
    </cfif>
  </cfoutput>
  <h1 align='center'>Item File Maintenance</h1>
  <table align='center' class='data' width='779' cellspacing="0">
    <cfoutput>
      <tr>
        <td width='126'><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Stock Code<cfelse>Itemno</cfif> :</td>
        <td colspan='7'>
          <cfif mode eq 'Delete' or mode eq 'Edit'>
            <input type='text' size='60' name='itemno' value='#convertquote(url.itemno)#' readonly>
            <cfelse>
				<cfif lcase(hcomid) eq "ovas_i" or lcase(hcomid) eq "demo_i">
					<input type='text' size='60' name='itemno' value='#itemno#'>
				<cfelse>
					<input type='text' size='60' name='itemno' value='#itemno#' maxlength='54'>
				</cfif>          
          </cfif>
          
          <!--- These variables could be set dynamically --->
<cfset theImage="images.jpg">

<!--- The theItem string has an ampersand, so you must URL-encode it. --->
<!--- <cftooltip sourceForTooltip="tiptext.cfm">
    <cfoutput> 
        <img src="#theImage#" height="20" width="20" />
    </cfoutput>
</cftooltip>  --->
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Created On : #dateformat(created_on,'DD/MM/YYYY')#
        </td>


      </tr>
      <tr>
        <td>Description :</td>
        <td colspan='7'>
        <textarea id="desp" name="desp" cols="100" rows="1" style="overflow:auto" onKeyPress="return imposeMaxLength(this, <cfif lcase(HcomID) eq "hl_i">
        35
		<cfelse>
        #getgsetup.desplimit#
		</cfif>);" >#convertquote(desp)#</textarea>&nbsp;&nbsp;<input type="button" name="MCE1" id="MCE1" value="MCE" onClick="texteditor('MCE1');">&nbsp;&nbsp;<input type="button" name="SYMBOLbtn1" id="SYMBOLbtn1" value="SYMBOL" onClick="javascript:ColdFusion.Window.show('findSymbol1');">
        <!--- <input type='text' size='100' name='desp' value='#convertquote(desp)#' maxlength='60' onClick="onselect()"> ---></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan='7'>
        <textarea id="despa" name="despa" cols="100" rows="1" style="overflow:auto" onKeyPress="return imposeMaxLength(this, <cfif lcase(HcomID) eq "hl_i">
        35
		<cfelse>
        70
		</cfif>);" >#convertquote(despa)#</textarea>&nbsp;&nbsp;<input type="button" name="MCE2" id="MCE2" value="MCE" onClick="texteditor('MCE2');">&nbsp;&nbsp;<input type="button" name="SYMBOLbtn2" id="SYMBOLbtn2" value="SYMBOL" onClick="javascript:ColdFusion.Window.show('findSymbol2');">
        <!--- <input type='text' size='100' name='despa' value='#convertquote(despa)#' maxlength='70'> ---></td>
      </tr>
      <tr>
      <td>Comment :</td>
      <td><textarea name='comment' id="comment" tabindex="3" cols='60' rows='5'>#convertquote(comment)#</textarea></td>
      </tr>
      <tr>
        <td><cfif (lcase(HcomID) eq "ideal_i" or lcase(HcomID) eq "idealb_i")>Vendor's Code<cfelse>Product Code</cfif> :</td>
        <td colspan='7'><input type='text' size='60' name='AITEMNO' value='#AITEMNO#' maxlength='20'></td>
      </tr>
      <tr>
        <td>Bar Code :</td>
        <td colspan='7'><input type='text' size='60' name='barcode' value='#barcode#' maxlength='20'>
        <input type="button" name="generatebarcode" id="generatebarcode" value="Generate" onClick="document.getElementById('barcode').value='#barcoderunno#'">
        </td>
      </tr>
      <tr>
        <td height='22'>Brand :</td>
        <td colspan='7'>
			<select name="BRAND" id="BRAND">
            	<option value="">-</option>
            	<cfloop query="getbrand">
              		<option value="#brand#" <cfif getbrand.brand eq xbrand>selected</cfif>>#getbrand.brand# - #getbrand.desp#</option>
            	</cfloop>
          	</select>
          	<!--- <input type='text' size='100' name='BRAND' value='#convertquote(BRAND)#' maxlength='40'></td> --->
      </tr>
    </cfoutput>
    <tr>
      <td colspan='8'><hr></td>
    </tr>
    <tr>
      <th height='20' colspan='8'>
        <div align='center'><strong>General Information</strong></div></th>
    </tr>
    <!--- Value Type => Category --->
    <cfquery name='getcate' datasource='#dts#'>
    select * from iccate order by cate
    </cfquery>
    <!--- Size => SizeID --->
    <cfquery name='getsizeid' datasource='#dts#'>
    select * from icsizeid order by sizeid
    </cfquery>
    <!--- Rating => CostCode --->
    <cfquery name='getcostcode' datasource='#dts#'>
    select * from iccostcode order by costcode
    </cfquery>
    <!--- Material => ColorID --->
    <cfquery name='getcolorid' datasource='#dts#'>
    select * from iccolorid order by colorid
    </cfquery>
    <!--- Manufacturer => shelf --->
    <cfquery name='getshelf' datasource='#dts#'>
    select * from icshelf order by shelf
    </cfquery>
    <!--- Model => Group --->
    <cfquery name='getgroup' datasource='#dts#'>
    select wos_group,desp from icgroup
    <cfif Hitemgroup neq ''>
    where wos_group='#Hitemgroup#'
    </cfif>
    order by wos_group
    </cfquery>
    <!--- unit --->
    <cfquery name='getUnit' datasource='#dts#'>
    select * from Unit order by unit
    </cfquery>
    <!--- Supplier --->
    <cfquery name='getsupp' datasource='#dts#'>
    select custno,name,currcode from #target_apvend# where (status<>'B' or status is null) order by custno
    </cfquery>
    <tr>
      <td><cfif getpin2.h13C0 eq 'T'>Supplier :</cfif></td>
      <td colspan='4'>
       <cfif getpin2.h13C0 eq 'T'> <select name='supp'>
          <option value=''>-</option>
          <cfoutput query='getsupp'>
            <option value='#custno#'<cfif custno eq xsupp>selected</cfif>>#custno# - #getsupp.name#<cfif trim(getsupp.currcode) neq ""> - #getsupp.currcode#</cfif></option>
          </cfoutput>
        </select>
		<cfif getgsetup.filterall eq "1">
			<input type="text" name="searchsupp" onKeyUp="getSupp('supp', 'Supplier');">
		</cfif>
        <cfelse>
        <input type="hidden" name="supp" id="supp" value="#xsupp#">
        </cfif>
      </td>
    </tr>
    <tr> <cfoutput>
        <td>#getgsetup.lcategory# :</td>
      </cfoutput>
        <td colspan="3">
          <select name='CATEGORY'>
            <option value=''>-</option>
            <cfoutput query='getcate'>
              <option value='#cate#'<cfif cate eq xcategory>selected</cfif>>#cate# - #desp#</option>
            </cfoutput>
          </select>
        </td>
		<cfoutput>
        <td rowspan="6" colspan="2">
			<iframe id="show_picture" name="show_picture" frameborder="1" marginheight="0" marginwidth="0" align="middle" height="150" width="150" scrolling="no" src="icitem_image.cfm?pic3=#urlencodedformat(photo)#"></iframe><br/>Click Picture To Show Original Size
		</td>
    </tr>
    <tr>
        <td>#getgsetup.lsize# :</td>
    	</cfoutput>
        <td width='148'>
          <select name='SIZEID'>
            <option value=''>-</option>
            <cfoutput query='getsizeid'>
              <option value='#sizeid#'<cfif sizeid eq xsizeid>selected</cfif>>#sizeid# - #desp#</option>
            </cfoutput>
          </select>
        </td>
        <td colspan='-1'>Packing :</td>
        <td colspan='-1'><input type='text' size='14' name='PACKING' value='#PACKING#' maxlength='20'/></td>
    </tr>
    <tr><cfoutput>
        <td>#getgsetup.lrating# :</td>
      </cfoutput>
        <td width='148'>
          <select name='COSTCODE'>
            <option value=''>-</option>
            <cfoutput query='getcostcode'>
              <option value='#costcode#'<cfif costcode eq xcostcode>selected</cfif>>#costcode# - #desp#</option>
            </cfoutput>
          </select>
        </td>
        <td width='100' colspan='-1'>Minimum :</td>
        <td width='151' colspan='-1'><input type='text' size='14' name='MINIMUM' value='#MINIMUM#' maxlength='14'/></td>
    </tr>
    <tr><cfoutput>
        <td>#getgsetup.lmaterial# :</td>
      </cfoutput>
        <td width='148'>
          <select name='COLORID'>
            <option value=''>-</option>
            <cfoutput query='getcolorid'>
              <option value='#colorid#'<cfif colorid eq xcolorid>selected</cfif>>#colorid# - #desp#</option>
            </cfoutput>
          </select>
        </td>
        <td colspan='-1'>Maximum :</td>
        <td colspan='-1'><input type='text' size='14' name='MAXIMUM' value='#MAXIMUM#' maxlength='14'/></td>
    </tr>
    <tr><cfoutput>
        <td>#getgsetup.lgroup# :</td>
      </cfoutput>
        <td width='148'>
          <select name='WOS_GROUP'>
            <option value=''>-</option>
            <cfoutput query='getgroup'>
              <option value='#wos_group#'<cfif wos_group eq xwos_group>selected</cfif>>#wos_group# - #desp#</option>
            </cfoutput>
          </select>
        </td>
        <td colspan='-1'>Reorder :</td>
        <td colspan='-1'><input type='text' size='14' name='REORDER' value='#REORDER#' maxlength='14'/></td>
    </tr>
    <tr><cfoutput>
        <td>#getgsetup.lmodel# :</td>
      </cfoutput>
        <td width='148'>
          <select name='shelf'>
            <option value=''>-</option>
            <cfoutput query='getshelf'>
              <option value='#shelf#'<cfif shelf eq xshelf>selected</cfif>>#shelf# - #desp#</option>
            </cfoutput>
          </select>
        </td>
        <td>Defaulted Tax:</td>
        <cfquery name="gettax" datasource="#dts#">
        select "" as code,"Choose a tax" as code2 
        union all
        select code,code as code2 from #target_taxtable# where (tax_type = "ST" or tax_type = "T")
        </cfquery>
        <td><cfselect name="taxcode" id="taxcode" query="gettax" display="code2" value="code" selected="#taxcode#" /></td>
        <td colspan='1'></td>
    </tr>
    <tr>
      	<td colspan='1'></td>
	  	<td colspan='3'></td>
    </tr>
	<tr>
		<td>Change Picture :</td>
		<cfdirectory action="list" directory="#HRootPath#\images\#hcomid#\" name="picture_list">
		<td>
			<select name="picture_available" id="picture_available" onChange="javascript:change_picture(this.value);">
				<option value="">-</option>
				<cfoutput query="picture_list">
					<cfif picture_list.name neq "Thumbs.db">
						<option value="#picture_list.name#" #iif((photo eq picture_list.name),DE("selected"),DE(""))#>#picture_list.name#</option>
					</cfif>
				</cfoutput>
			</select>&nbsp;&nbsp;<img name="img1" src="/images/delete.ico" height="15" width="15" onMouseOver="this.style.cursor='hand'" onClick="delete_picture(document.getElementById('picture_available').value);" />
		</td>
        <td>Item Type</td>
        <td>
        <select name="itemtype" id="itemtype">
        <option value="">Choose an Itemtype</option>
		<option value="S" <cfif itemtype eq "S">selected </cfif>>Sales Item</option>
        <option value="P" <cfif itemtype eq "P">selected </cfif>>Purchases Item</option>
        <option value="SV" <cfif itemtype eq "SV">selected </cfif>>Service Item</option>
        </select></td>
	</tr>
    <tr>
    <td>Cost Code</td>
    <td><input type="text" id="costformula" name="costformula" value="#costformula#" readonly /></td>
    </tr>
    <tr>
      <td colspan='8'><hr></td>
    </tr>
    <tr>
      <th colspan='8'><div align='center'><strong>Product Details</strong></div></th>
    </tr>
    <tr align="left">
      <td nowrap>Unit of Measurement :</td>
      <td>
        <select name='UNIT'>
          <option value=''>-</option>
          <cfoutput query='getUnit'>
            <option value='#Unit#'<cfif Unit eq xUNIT>selected</cfif>>#Unit# - #desp#</option>
          </cfoutput>
        </select>
      </td>
      <cfoutput>
        <td nowrap>Qty Formula :</td>
        <td nowrap><input name='WQFORMULA' type='checkbox' value='1' <cfif #WQFORMULA# eq 1>checked</cfif>></td>
        <td nowrap> U.P Formula :</td>
        <td nowrap><input name='WPFORMULA' type='checkbox' value='1' <cfif #WPFORMULA# eq 1>checked</cfif>></td>
    </cfoutput> </tr>
    <cfoutput>
      <tr>
      <cfif getpin2.h1360 neq 'T'>
      <td nowrap>&nbsp;</td>
      <td nowrap><input name='UCOST' type='hidden' value='#NumberFormat(UCOST, stDecl_UPrice)#' size='17' maxlength='17'>&nbsp;&nbsp;</td>
	  <cfelse>
        <td nowrap>Unit Cost Price :</td>
        <td nowrap><input name='UCOST' type='text' value='#NumberFormat(UCOST, stDecl_UPrice)#' size='17' maxlength='17'></td>
        </cfif>
        <td nowrap>Serial No. :</td>
        <td nowrap><input name='wserialno' type='checkbox' value='T'<cfif #wserialno# eq "T">checked</cfif>></td>
		<td nowrap> Related Item :</td>
        <td nowrap><input name="relitem" type="checkbox" value="1" onClick="javascript:ColdFusion.Window.show('relitem');"></td>
        <td colspan='-1'>&nbsp;</td>
        <td colspan='-1'>&nbsp;</td>
      </tr>
    </cfoutput>
    <tr>
    <cfif getpin2.h1360 neq 'T'>
    <cfif getpin2.h1361 neq 'T'>
    <td height='22'>&nbsp;</td>
      <td><input name='PRICE' type='hidden' id='PRICE' value='#NumberFormat(PRICE, stDecl_UPrice)#' size='17' maxlength='17'/>&nbsp;&nbsp;<input name='FPRICE' type='hidden' id='FPRICE' value='#NumberFormat(FPRICE, stDecl_UPrice)#' size='17' maxlength='17'/></td>
      <cfelse>
      <td height='22'>Unit Selling Price :</td>
      <td><input name='PRICE' type='text' id='PRICE' value='#NumberFormat(PRICE, stDecl_UPrice)#' size='17' maxlength='17'/> <cfoutput><cfif url.type eq 'Edit'><input type="button" name="button" value="Price Record" onClick="window.open('/default/maintenance/icitemhistran/historypricerecord.cfm?itemno=#url.itemno#')"/></cfif></cfoutput></td>
      </cfif>
    <cfelse>
      <td height='22'>Unit Selling Price :</td>
      <td><input name='PRICE' type='text' id='PRICE' value='#NumberFormat(PRICE, stDecl_UPrice)#' size='17' maxlength='17'/> <cfoutput><cfif url.type eq 'Edit'><input type="button" name="button" value="Price Record" onClick="window.open('/default/maintenance/icitemhistran/historypricerecord.cfm?itemno=#url.itemno#')"/></cfif></cfoutput></td>
      </cfif>
      <td nowrap>Non Graded :</td>
      <td nowrap><input name='graded' id="graded2" type='radio' value='N' <cfif graded eq "N" or graded eq ''>checked<cfelse>checked</cfif>></td>
      <td nowrap>Qty B/F :</td>
      <td nowrap><cfoutput>
          <input name='QTYBF' type='text' value='#QTYBF#' size='10' maxlength='10'>
      </cfoutput></td>
      <td colspan='-1'>&nbsp;</td>
      <td colspan='-1'>&nbsp;</td>
    </tr>
    <tr>
    <cfif getpin2.h1360 neq 'T'>
    <cfif getpin2.h1361 neq 'T'>
    <cfif getpin2.h1361 neq 'T'>
    <td height='22'></td>
      <td><input name='PRICE2' type='hidden' value='#NumberFormat(PRICE2, stDecl_UPrice)#' size='17' maxlength='17'/></td>
      <cfelse>
      <td height='22'>Unit Selling Price 2 :</td>
      <td><input name='PRICE2' type='text' value='#NumberFormat(PRICE2, stDecl_UPrice)#' size='17' maxlength='17'/></td>
      </cfif>
      <cfelse>
      <td height='22'>Unit Selling Price 2 :</td>
      <td><input name='PRICE2' type='text' value='#NumberFormat(PRICE2, stDecl_UPrice)#' size='17' maxlength='17'/></td>
      </cfif>
	<cfelse>
      <td height='22'>Unit Selling Price 2 :</td>
      <td><input name='PRICE2' type='text' value='#NumberFormat(PRICE2, stDecl_UPrice)#' size='17' maxlength='17'/></td>
      </cfif>
      <td nowrap>Graded :</td>
      <td nowrap><input name='graded' id="graded1" type='radio' value='Y' <cfif graded eq "Y">checked</cfif>></td>
       <td nowrap>Commission Level :</td>
      <td nowrap>
      <cfquery name="getcomm" datasource="#dts#">
      SELECT "Choose a Commission Level" as commname
      union all
      SELECT commname FROM commission
      </cfquery>
      <cfselect name="comm" id="comm" query="getcomm" value="commname" display="commname" selected="#comm#" />
      </td>
      <!--- <td nowrap>Graded 2 :</td>
      	<td nowrap><input name='graded' type='radio' value='Y' <cfif #graded# eq 2>checked</cfif>></td> --->
    </tr>
    <cfoutput>
      <tr>
      <cfif getpin2.h1360 neq 'T'>
      <cfif getpin2.h1361 neq 'T'>
      <td nowrap>
            <input name='MURATIO' type='hidden' value='#MURATIO#' size='5' maxlength='5' onKeyUp="calculate_price3('#iDecl_UPrice#');"></td>
        <td><input name='PRICE3' type='hidden' value='#NumberFormat(PRICE3, stDecl_UPrice)#' size='17' maxlength='17'></td>
        <cfelse>
        <td nowrap>M.U Ratio :
            <input name='MURATIO' type='text' value='#MURATIO#' size='5' maxlength='5' onKeyUp="calculate_price3('#iDecl_UPrice#');"></td>
        <td><input name='PRICE3' type='text' value='#NumberFormat(PRICE3, stDecl_UPrice)#' size='17' maxlength='17'></td>
        </cfif>
	  <cfelse>
        <td nowrap>M.U Ratio :
            <input name='MURATIO' type='text' value='#MURATIO#' size='5' maxlength='5' onKeyUp="calculate_price3('#iDecl_UPrice#');"></td>
        <td><input name='PRICE3' type='text' value='#NumberFormat(PRICE3, stDecl_UPrice)#' size='17' maxlength='17'></td>
        </cfif>
        <td nowrap>Length :</td>
        <td nowrap><input name='QTY2' type='text' value='#QTY2#' size='8' maxlength='8'/></td>
        <td nowrap>Credit Sales :</td>
        <td nowrap><input name='SALEC' type='text' value='#SALEC#' size='8' maxlength='8'/></td>
      </tr>
      <cfif getpin2.h1360 neq 'T'>
      <cfif getpin2.h1361 neq 'T'>
      <input name='PRICE4' type='hidden' value='#NumberFormat(PRICE4, stDecl_UPrice)#' size='17' maxlength='17'>
      <input name='PRICE5' type='hidden' value='#NumberFormat(PRICE5, stDecl_UPrice)#' size='17' maxlength='17'>
      <input name='PRICE6' type='hidden' value='#NumberFormat(PRICE6, stDecl_UPrice)#' size='17' maxlength='17'>
      <cfelse>
      <tr>
      <td nowrap>Unit Selling Price 4 :
            </td>
        <td><input name='PRICE4' type='text' value='#NumberFormat(PRICE4, stDecl_UPrice)#' size='17' maxlength='17'></td>
      </tr>
      <tr>
      
      <td nowrap>Unit Selling Price 5 :
            </td>
        <td><input name='PRICE5' type='text' value='#NumberFormat(PRICE5, stDecl_UPrice)#' size='17' maxlength='17'></td>
      </tr>
      <tr>
      
      <td nowrap>Unit Selling Price 6 :
            </td>
        <td><input name='PRICE6' type='text' value='#NumberFormat(PRICE6, stDecl_UPrice)#' size='17' maxlength='17'></td>
      </tr>
      </cfif>
      <cfelse>
      <tr>
      <td nowrap>Unit Selling Price 4 :
            </td>
        <td><input name='PRICE4' type='text' value='#NumberFormat(PRICE4, stDecl_UPrice)#' size='17' maxlength='17'></td>
      </tr>
      <tr>
      
      <td nowrap>Unit Selling Price 5 :
            </td>
        <td><input name='PRICE5' type='text' value='#NumberFormat(PRICE5, stDecl_UPrice)#' size='17' maxlength='17'></td>
      </tr>
      <tr>
      
      <td nowrap>Unit Selling Price 6 :
            </td>
        <td><input name='PRICE6' type='text' value='#NumberFormat(PRICE6, stDecl_UPrice)#' size='17' maxlength='17'></td>
      </tr>
      
      </cfif>
      <tr>
      <cfif getpin2.h1360 neq 'T'>
      <td></td>
        <td>
          <cfif getgsetup.gpricemin eq 1>
            <input name='PRICE_MIN' type='hidden' value='#NumberFormat(PRICE_MIN, stDecl_UPrice)#' size='17' maxlength='17'/>
		  <cfelse>
		  	<input type="hidden" name="PRICE_MIN" id="PRICE_MIN" value="#val(PRICE_MIN)#">
          </cfif>
        </td>
	  <cfelse>
        <td><cfif getgsetup.gpricemin eq 1>
            Min. Selling Price :
        </cfif></td>
        <td>
          <cfif getgsetup.gpricemin eq 1>
            <input name='PRICE_MIN' type='text' value='#NumberFormat(PRICE_MIN, stDecl_UPrice)#' size='17' maxlength='17'/>
		  <cfelse>
		  	<input type="hidden" name="PRICE_MIN" id="PRICE_MIN" value="#val(PRICE_MIN)#">
          </cfif>
        </td>
        </cfif>
        <td nowrap>Width :</td>
        <td nowrap><input name='QTY3' type='text' value='#QTY3#' size='8' maxlength='8'></td>
        <td nowrap>Cash Sales :</td>
        <td nowrap><input name='SALECSC' type='text' value='#SALECSC#' size='8' maxlength='8'></td>
      </tr>
    </cfoutput> 
	<cfoutput>
      <tr>
      
        <td nowrap>Discontinue Item :</td>
        <td nowrap><input name='nonstkitem' type='checkbox' value='T' <cfif nonstkitem eq 'T'>checked</cfif>></td>
        <td nowrap>Thickness :</td>
        <td nowrap><input name='QTY4' type='text' value='#QTY4#' size='8' maxlength='8'></td>
        <td nowrap>Sales Return :</td>
        <td nowrap><input name='SALECNC' type='text' value='#SALECNC#' size='8' maxlength='8'></td>
      </tr>
      <cfquery name="getcurr" datasource="#dts#">
      SELECT "" as currcode,"Choose a Currency" as currdesp
      union all
      SELECT currcode,concat(currcode,' - ',currency1) as currdesp FROM #target_currency# WHERE currcode <> "#getgsetup.bcurr#"
      </cfquery>
      <tr>
        <td>Foreign Currency :</td>
        <td><cfselect name="fcurrcode" id="fcurrcode" query="getcurr" value="currcode" display="currdesp" selected="#fcurrcode#" /></td>
        <td nowrap>Weight / Length :</td>
        <td nowrap><input name='QTY5' type='text' value='#QTY5#' size='8' maxlength='8'></td>
        <td nowrap>Purchase :</td>
        <td nowrap><input name='PURC' type='text' value='#PURC#' size='8' maxlength='8'></td>
      </tr>
      <tr>
        <td>Foreign Unit Cost</td>
        <cfif getpin2.h1360 neq 'T'>
      <td nowrap><input name='FUCOST' type='hidden' value='#NumberFormat(FUCOST, stDecl_UPrice)#' size='17' maxlength='17'></td>
	  <cfelse>
        <td nowrap><input name='FUCOST' type='text' value='#NumberFormat(FUCOST, stDecl_UPrice)#' size='17' maxlength='17'></td>
        </cfif>
        <td nowrap>Price / Weight :</td>
        <td nowrap><input name='QTY6' type='text' value='#QTY6#' size='8' maxlength='8'></td>
        <td nowrap>Purchase Return :</td>
        <td nowrap><input name='PURPREC' type='text' value='#PURPREC#' size='8' maxlength='8'></td>
      </tr>
      <tr>
        <td>Foreign Selling Price</td>
         <cfif getpin2.h1360 neq 'T'>
         <cfif getpin2.h1361 neq 'T'>
      <td nowrap><input name='FPRICE' type='hidden' value='#NumberFormat(FPRICE, stDecl_UPrice)#' size='17' maxlength='17'></td>
      <cfelse>
      <td nowrap><input name='FPRICE' type='text' value='#NumberFormat(FPRICE, stDecl_UPrice)#' size='17' maxlength='17'></td>
      </cfif>
	  <cfelse>
        <td nowrap><input name='FPRICE' type='text' value='#NumberFormat(FPRICE, stDecl_UPrice)#' size='17' maxlength='17'></td>
        </cfif>
      </tr>
      <tr>
       <td>Normal</td>
       <td nowrap><input name='custprice_rate' type='radio' value='normal'<cfif custprice_rate eq "normal"> checked</cfif>></td>
      </tr>

      <tr>
      <td>Offer</td>
       <td nowrap><input name='custprice_rate' type='radio' value='offer' <cfif custprice_rate eq "offer">  checked</cfif>></td>
      </tr>
      
      <tr>
      <td>Others</td>
       <td nowrap><input name='custprice_rate' type='radio' value='others' <cfif custprice_rate eq "others">  checked</cfif>></td>
      </tr>
       
      <tr>
        <td colspan="7" align="right"><cfif getpin2.h1312 neq 'T'><input name='submit' type='submit' value='#button#'></cfif></td>
      </tr>
		<!--- ADD ON 260908, 2ND UOM --->
		<tr>
			<td colspan='100%'><hr></td>
      	</tr>
      	<tr>
        	<th height='20' colspan='100%' onClick="javascript:shoh('r3');"><div align='center'><strong>2nd Unit&nbsp;<img src="../../images/u.gif" name="imgr3" align="center"></strong></div></th>
      	</tr>
		<tr>
        	<td colspan="7">
          		<table style="display:none" id="r3" align="center" width="50%">
					<tr>
						<td>Unit of Measure</td>
						<td>Factor 1</td>
						<td>Factor 2</td>
						<td>Unit Price</td>
					</tr>
					<tr>
						<td>
							<select name='unit2'>
         		 				<option value=''>-</option>
          						<cfloop query='getUnit'>
            						<option value='#Unit#'<cfif Unit eq UNIT2>selected</cfif>>#Unit# - #desp#</option>
          						</cfloop>
        					</select>
						</td>
						<td><input name='FACTOR1' type='text' id='FACTOR1' value='#NumberFormat(FACTOR1, stDecl_UPrice)#' size='17' maxlength='17'/></td>
						<td><input name='FACTOR2' type='text' id='FACTOR2' value='#NumberFormat(FACTOR2, stDecl_UPrice)#' size='17' maxlength='17'/></td>
						<td><input name='PRICEU2' type='text' id='PRICEU2' value='#NumberFormat(PRICEU2, stDecl_UPrice)#' size='17' maxlength='17'/></td>
					</tr>
					
					<cfloop from="3" to="6" index="i">
						<cfif url.type eq 'Create'>
							<cfset SecondUnit = "">
							<cfset factora = 1>
							<cfset factorb = 1>
							<cfset Price2ndUnit = 0>
						<cfelse>
							<cfset SecondUnit = Evaluate("getitem.UNIT#i#")>
							<cfset factora = Evaluate("getitem.FACTORU#i#_A")>
							<cfset factorb = Evaluate("getitem.FACTORU#i#_B")>
							<cfset Price2ndUnit = Evaluate("getitem.PRICEU#i#")>
						</cfif>
						<tr>
							<td>
								<select name='unit#i#'>
         		 					<option value=''>-</option>
          							<cfloop query='getUnit'>
            							<option value='#Unit#'<cfif Unit eq SecondUnit>selected</cfif>>#Unit# - #desp#</option>
          							</cfloop>
        						</select>
							</td>
							<td><input name='FACTORU#i#_A' type='text' id='FACTORU#i#_A' value='#NumberFormat(factora, stDecl_UPrice)#' size='17' maxlength='17'/></td>
							<td><input name='FACTORU#i#_B' type='text' id='FACTORU#i#_B' value='#NumberFormat(factorb, stDecl_UPrice)#' size='17' maxlength='17'/></td>
							<td><input name='PRICEU#i#' type='text' id='PRICEU#i#' value='#NumberFormat(Price2ndUnit, stDecl_UPrice)#' size='17' maxlength='17'/></td>
						</tr>
					</cfloop>
				</table>
			</td>
		</tr>
		<!--- ADD ON 260908, 2ND UOM --->
      	<tr>
        	<td colspan='8'><hr></td>
      	</tr>
      	<tr>
        	<th height='20' colspan='8' onClick="javascript:shoh('r1');"><div align='center'><strong><cfif lcase(hcomid) eq "kingston_i">
            Other Suppliers
			<cfelse>
            Remarks
			</cfif><img src="../../images/u.gif" name="imgr1" align="center"></strong></div></th>
      	</tr>
      	<tr>
        <cfif lcase(hcomid) eq "kingston_i">
        <td colspan="7">
          		<table style="display:none" id="r1" align="center" width="85%">
                <cfloop from="1" to="30" index="i">
                	<tr>
              			<td height='22'>Other Supplier #i# :</td>
              			<td>
                        <select name='Remark#i#'>
          <option value=''>-</option>
          <cfloop query='getsupp'>
            <option value='#custno#'<cfif custno eq "#evaluate('Remark#i#')#">selected</cfif>>#custno# - #getsupp.name#<cfif trim(getsupp.currcode) neq ""> - #getsupp.currcode#</cfif></option>
          </cfloop>
        </select>
                        </td>
            		</tr>
                </cfloop> 
                </table>
                </td>
        <cfelse>
        	<td colspan="7">
          		<table style="display:none" id="r1" align="center" width="85%">
            		<tr>
              			<td width='25%' nowrap height='22'>
						<!--- <cfif lcase(hcomid) eq "ecraft_i" or lcase(hcomid) eq "ovas_i">
							Foreign Currency Price 1 --->
						<cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">
							Fixed / Variable
						<cfelse>
							Remark 1
						</cfif> :
						</td>
              			<td width='75%'>
							<cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">
								<select name="Remark1">
									<option value="F" <cfif Remark1 eq "F">selected</cfif>>Fixed</option>
									<option value="V" <cfif Remark1 eq "V">selected</cfif>>Variable</option>
								</select>
							<cfelse>
								<input name='Remark1' type='text' value='#Remark1#' size='100' maxlength='100' onClick="select();">
							</cfif>						
						</td>
            		</tr>
            		<tr>
              			<td height='22'><cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">Type of Service<cfelse>Remark 2</cfif> :</td>
              			<td>
							<cfif lcase(hcomid) eq "glenn_i" or lcase(hcomid) eq "glenndemo_i">
								<select name="Remark2">
									<option value="">Please Select One</option>
									<option value="PT" <cfif Remark2 eq "PT">selected</cfif>>PORT TARIFF</option>
									<option value="PS" <cfif Remark2 eq "PS">selected</cfif>>PORT SERVICE</option>
									<option value="OP" <cfif Remark2 eq "OP">selected</cfif>>OPEN PURCHASES</option>
									<option value="CS" <cfif Remark2 eq "CS">selected</cfif>>COMMERCIAL SEGMENT</option>
									<option value="CH" <cfif Remark2 eq "CH">selected</cfif>>CHARTER HIRE</option>
									<option value="SC" <cfif Remark2 eq "SC">selected</cfif>>SCRAP SALES</option>
									<option value="OI" <cfif Remark2 eq "OI">selected</cfif>>OTHER INCOME</option>
								</select>
							<cfelse>
								<input name='Remark2' type='text' value='#Remark2#' size='100' maxlength='100' onClick="select();">
							</cfif>
						</td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 3 :</td>
              			<td><input name='Remark3' type='text' value='#Remark3#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 4 :</td>
              			<td><input name='Remark4' type='text' value='#Remark4#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 5 :</td>
              			<td><input name='Remark5' type='text' value='#Remark5#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 6 :</td>
              			<td><input name='Remark6' type='text' value='#Remark6#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 7 :</td>
              			<td><input name='Remark7' type='text' value='#Remark7#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 8 :</td>
              			<td><input name='Remark8' type='text' value='#Remark8#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 9 :</td>
              			<td><input name='Remark9' type='text' value='#Remark9#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td nowrap height='22'>Remark 10 :</td>
              			<td><input name='Remark10' type='text' value='#Remark10#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
            			<td height='22'>Remark 11 :</td>
              			<td><input name='Remark11' type='text' value='#Remark11#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 12 :</td>
              			<td><input name='Remark12' type='text' value='#Remark12#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='26'>Remark 13 :</td>
              			<td><input name='Remark13' type='text' value='#Remark13#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 14 :</td>
              			<td><input name='Remark14' type='text' value='#Remark14#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 15 :</td>
              			<td><input name='Remark15' type='text' value='#Remark15#' size='100' maxlength='50' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 16 :</td>
              			<td><input name='Remark16' type='text' value='#Remark16#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 17 :</td>
              			<td><input name='Remark17' type='text' value='#Remark17#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 18 :</td>
              			<td><input name='Remark18' type='text' value='#Remark18#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 19 :</td>
              			<td><input name='Remark19' type='text' value='#Remark19#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 20 :</td>
              			<td><input name='Remark20' type='text' value='#Remark20#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 21 :</td>
              			<td><input name='Remark21' type='text' value='#Remark21#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 22 :</td>
              			<td><input name='Remark22' type='text' value='#Remark22#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 23 :</td>
              			<td><input name='Remark23' type='text' value='#Remark23#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 24 :</td>
              			<td><input name='Remark24' type='text' value='#Remark24#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 25 :</td>
              			<td><input name='Remark25' type='text' value='#Remark25#' size='100' maxlength='100' onClick="select();"></td>
           			</tr>
            		<tr>
              			<td height='22'>Remark 26 :</td>
            			<td><input name='Remark26' type='text' value='#Remark26#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 27 :</td>
              			<td><input name='Remark27' type='text' value='#Remark27#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 28 :</td>
              			<td><input name='Remark28' type='text' value='#Remark28#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 29 :</td>
              			<td><input name='Remark29' type='text' value='#Remark29#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
            		<tr>
              			<td height='22'>Remark 30 :</td>
              			<td><input name='Remark30' type='text' value='#Remark30#' size='100' maxlength='100' onClick="select();"></td>
            		</tr>
        		</table>
			</td>
            </cfif>
      </tr>
    </cfoutput>
  </table>
</cfform>

<form name="upload_picture" action="icitem_image.cfm" method="post" enctype="multipart/form-data" target="_blank">
	<table class="data" align="center" width="779">
		<tr>
        	<th height='20' colspan='8' onClick="javascript:shoh('r2');"><div align='center'><strong>Upload Item Photo<img src="../../images/d.gif" name="imgr2" align="center"></strong></div></th>
      	</tr>
		<tr id="r2">
			<td align="center">
				<input type="file" name="picture" size="50" onChange="javascript:uploading_picture(this.value);" accept="image/gif,image/jpeg,image/tiff,image/x-ms-bmp,image/x-photo-cd,image/x-png,image/x-portable-greymap,image/x-portable-pixmap,image/x-portablebitmap">
				<br/>
				<input type="text" name="picture_name" size="50" value="">&nbsp;
				<input type="submit" name="Upload" value="Upload" onClick="javascript:return add_option(document.getElementById('picture_name').value);">
			</td>
		</tr>
	</table>
</form>
<cfwindow x="20" y="100" width="250" height="250" name="findSymbol1" refreshOnShow="true"
        title="ADD SYMBOL" initshow="false"
        source="/default/maintenance/symbol/maintenanceSymbolAjax.cfm?id=1" />
<cfwindow x="20" y="100" width="250" height="250" name="findSymbol2" refreshOnShow="true"
        title="ADD SYMBOL" initshow="false"
        source="/default/maintenance/symbol/maintenanceSymbolAjax.cfm?id=2" />
</body>
</html>