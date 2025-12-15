<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">

<cfquery datasource="#dts#" name="getGeneralInfo">
	select 
	invoneset,texteditor,negstk,gst,deductso,
	brem1,brem2,brem3,brem4,bcurr,
	xqty1,xqty2,xqty3,xqty4,xqty5,xqty6,xqty7,
    qtyformula,priceformula,wpitemtax,wpitemtax1,projectbybill,lPROJECT,lJOB,prozero,prodisprice,commenttext,commentlimit,displaycostcode,quobatch,jobbyitem,itemdiscmethod,lbatch,asvoucher,itempriceprior,remainloc,showservicepart,df_purchasetaxzero,df_salestaxzero,histpriceinv,proavailqty,df_qty,disclimit,locationwithqty,editamount
	from gsetup;
</cfquery>

<!--- ADD ON 30-07-2009 --->
<cfset wpitemtax="">
<cfif getGeneralInfo.wpitemtax eq "1">
	<cfif getGeneralInfo.wpitemtax1 neq "">
    	<cfif ListFindNoCase(getgeneralinfo.wpitemtax1, tran, ",") neq 0>
			<cfset wpitemtax = "Y">
        </cfif>
	<cfelse>
    	<cfset wpitemtax="Y">
	</cfif>
</cfif>

<!--- SEARCH BATCH ITEMS --->
<cfinclude template = "transaction4_search_batch_item.cfm">
<!--- SEARCH BATCH ITEMS --->

<cfparam name = "Submit" default = "">
<cfparam name = "alcreate" default = "0">

<cfparam name = "isservice" default = "0">
<cfif isdefined('url.service')>
<cfif url.service eq "SV">
<cfset isservice = "1">
</cfif>
</cfif>
<!--- SELECT BATCH ITEMS --->
<cfinclude template = "transaction4_select_batch_item.cfm">
<!--- SELECT BATCH ITEMS --->

<!--- SELECT GRADE ITEMS --->
<cfinclude template = "transaction4_select_grade_item.cfm">
<!--- SELECT GRADE ITEMS --->

<!--- DEFINED TRANSACTION TYPE --->
<cfinclude template = "transaction4_defined_transaction_type.cfm">
<!--- DEFINED TRANSACTION TYPE --->

<cfif submit eq "Search Comment">
	<!--- SEARCH COMMENT --->
	<cfinclude template = "transaction4_search_comment.cfm">
	<!--- SEARCH COMMENT --->
<cfelseif submit neq "">
	<!--- Go To TransactionProcess and Insert or Update Items --->
	<cfinclude template = "transaction4_insert_update_item.cfm">
	<!--- Go To TransactionProcess and Insert or Update Items --->
</cfif>

<!--- REMARK ON 30-07-2009 AND REPLACE WITH THE TOP ONE --->
<!--- <cfquery datasource="#dts#" name="getGeneralInfo">
	select 
	invoneset,
	texteditor,
	negstk,
	brem1,
	brem2,
	brem3,
	brem4,
	bcurr,
	xqty1,xqty2,xqty3,xqty4,xqty5,xqty6,xqty7,qtyformula,priceformula 
	from gsetup;
</cfquery> --->

<!--- Control The Decimal Point --->
<cfquery name="getgsetup2" datasource="#dts#">
	select 
	concat('.',repeat('_',Decl_Uprice)) as Decl_Uprice,
	Decl_Uprice as Decl_Uprice1, DECL_DISCOUNT as DECL_DISCOUNT1,
	concat('.',repeat('_',Decl_Discount)) as Decl_Discount
	from gsetup2
</cfquery>

<cfset stDecl_UPrice = getgsetup2.Decl_Uprice>
<cfset stDecl_Discount = getgsetup2.Decl_Discount>
<!--- Control The Decimal Point --->

<html>
<head>
<title>Transaction 4</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
<script type="text/javascript" src="/scripts/jscripts/tiny_mce/tiny_mce.js"></script>

<script type="text/javascript">
	function texteditor()
	{
		document.getElementById('MCE').style.visibility = "hidden";
		tinyMCE.init({
    mode : "textareas",
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

<script language="javascript" type="text/javascript">
	<cfoutput>
	var fixnum=#getgsetup2.Decl_UPrice1#;
	var fixnumdisc=#getgsetup2.DECL_DISCOUNT1#;
	var bcurr='#getgeneralinfo.bcurr#';
	var gstvalue='#val(getgeneralinfo.gst)#';
	</cfoutput>
	
	function transaction_body_onload()
	{
		<cfif (hcomid eq "pnp_i" or hcomid eq "wp_i")>
			<!--- INSERT TRANSACTION DEFAULT QTY SETTING --->
			<cfinclude template="transaction_body_setting_checking/default_quantity_setting.cfm">
			<!--- INSERT TRANSACTION DEFAULT QTY SETTING --->
		</cfif>
	}
	
	function getbalqty(location){
		var itemno = document.form1.items.value;
		DWREngine._execute(_tranflocation, null, 'getbalqty', escape(itemno), location, showbalqty);
		<cfif tran eq "SO">
		DWREngine._execute(_tranflocation, null, 'getavailqty', escape(itemno), location, showavailqty);
		setTimeout('getavailqty()',2000);
		
		</cfif>
	}
	
	function getavailqty(){
		document.form1.reserveqty2.value=document.form1.balance.value-document.form1.reserveqty.value;
		
	}
	
	function showavailqty(qtyObject){
		DWRUtil.setValue("reserveqty", qtyObject.AVAILONHAND);
		//document.getElementById("balance").value=qtyObject.AVAILONHAND;
	}
	
	function showbalqty(qtyObject){
		DWRUtil.setValue("balance", qtyObject.BALONHAND);
		//document.getElementById("balance").value=qtyObject.BALONHAND;
	}
	
	//For Ecraft only, Add On 081008
	function getprice(location){
		var itemno = document.form1.items.value;
		var type = document.form1.tran.value;
		var refno3 = document.form1.refno3.value;
		var currrate = document.form1.currrate.value;
		var custno = document.form1.custno.value;
		var readperiod = document.form1.readperiod.value;
		
		DWREngine._execute(_tranflocation, null, 'getprice', escape(itemno), location, type, refno3, currrate, bcurr, custno, readperiod, showprice);
	}
	
	function showprice(priceObject){	
		//alert(priceObject.PRICE);
		var uprice = parseFloat(priceObject.PRICE).toFixed(fixnum);
		DWRUtil.setValue("price", uprice);
	}//For Ecraft only, Add On 081008
	
	function AssignGrade(){
		var itemno = document.form1.items.value;
		var location = document.form1.location.value;
		var tran = document.form1.tran.value;
		var refno = document.form1.nexttranno.value;
		var trancode = document.form1.itemcounter.value;
		var opt = 'fullscreen=yes, scrollbars=yes, status=no';
		//window.showModalDialog('dsp_gradeitem.cfm?itemno=' + escape(itemno), '',opt);
		window.open('dsp_gradeitem.cfm?itemno=' + escape(itemno) + '&location=' + location + '&type=' + tran + '&refno=' + refno + '&trancode=' + trancode, '',opt);
		
	}
	
	
	function convertToEntities(valin) {
    var tstr = valin;
    var bstr = '';

    for (i=0; i<tstr.length; i++) {

        if (tstr.charCodeAt(i)>127) {
            bstr += '&#' + tstr.charCodeAt(i) + ';';
        } else {
            bstr += tstr.charAt(i);
        }
    }
    return bstr;
}	
	function changeUnit(){
		var itemno = document.form1.items.value;
		var tran = document.form1.tran.value;
		var refno = document.form1.nexttranno.value;
		//var opt = 'dialogWidth:500px; dialogHeight:300px; center:yes; scroll:no; status:no';
		var opt = 'Width=400px, Height=300px, Top=200px, left=400px scrollbars=no, status=no';
		<cfoutput>window.open('dsp_changeunit.cfm?itemno=' + encodeURI(itemno) + '&type=' + tran + '&refno=' + refno + '&refno3=#refno3#&currrate=#currrate#&bcurr=#getgeneralinfo.bcurr#&stDecl_UPrice=#stDecl_UPrice#', '',opt);</cfoutput>
	}
	
	function multiLocation(){
		var itemno = document.form1.items.value;
		var tran = document.form1.tran.value;
		var refno = document.form1.nexttranno.value;
		var graded = document.form1.graded.value;
		var price_bil = document.form1.price.value;
		var opt = 'Width=600px, Height=400px, Top=200px, left=300px, scrollbars=yes, status=no';
		<cfoutput>
			window.open('dsp_multilocation.cfm?itemno=' + escape(itemno) + '&type=' + tran + '&refno=' + refno + '&graded=' + graded 
			+ '&price_bil=' + price_bil + '&refno3=#refno3#&currrate=#currrate#&bcurr=#getgeneralinfo.bcurr#&stDecl_UPrice=#stDecl_UPrice#', '',opt);
		</cfoutput>
	}
	
	function changeTitleDesp(){
		var titleid = document.form1.title_id.options[document.form1.title_id.selectedIndex].value;
		DWREngine._execute(_tranflocation, null, 'getTitleDesp', escape(titleid), showTitleDesp);
	}
	
	function showTitleDesp(titleObject){
		DWRUtil.setValue("title_desp", titleObject.TITLEDESP);
	}
	
	function selectBatch(){
		var itemno = document.form1.items.value;
		var location = document.form1.location.value;
		var tran = document.form1.tran.value;
		var refno = document.form1.nexttranno.value;
		var trancode = document.form1.itemcounter.value;
		var price_bil = document.form1.price.value;
		var qty_bil = document.form1.qty.value;
		var factor1 = document.form1.factor1.value;
		var factor2 = document.form1.factor2.value;
		var opt = 'Width=800px, Height=550px, scrollbars=yes, status=no';
		window.open('dsp_batch.cfm?itemno='+escape(itemno)+'&location='+location+'&type='+tran+'&refno='+refno+'&trancode='+trancode+'&price='+price_bil+'&qty='+qty_bil+'&factor1='+factor1+'&factor2='+factor2, '',opt);
		
	}
	
	function calculateFormula(formulatype){
		var itemno = document.form1.items.value;
		var tran = document.form1.tran.value;
		var refno = document.form1.nexttranno.value;
		var trancode = document.form1.itemcounter.value;
		var price_bil = document.form1.price.value;
		var qty_bil = document.form1.qty.value;
		var opt = 'Width=400px, Height=350px, Top=200px, left=400px scrollbars=no, status=no';
		<cfoutput>window.open('dsp_formula.cfm?itemno=' + escape(itemno) + '&type=' + tran + '&refno=' + refno + '&formulatype=' + formulatype + '&price=' + price_bil + '&qty=' + qty_bil + '&itemcount=' + trancode + '&refno3=#refno3#&currrate=#currrate#&bcurr=#getgeneralinfo.bcurr#&stDecl_UPrice=#stDecl_UPrice#', 'mywindow1',opt);</cfoutput>
	}
	
	function calculateAmt(percent){
		var tran = document.form1.tran.value;
		var refno = document.form1.nexttranno.value;
		var trancode = document.form1.itemcounter.value;
		DWREngine._execute(_tranflocation, null, 'calculateAmt', tran, refno,percent,trancode, showAmt);
	}
	
	function showAmt(thisObject){
		DWRUtil.setValue("price", thisObject.ITEMAMT);
		DWRUtil.setValue("amt", thisObject.ITEMAMT);
		DWRUtil.setValue("qty", "1");
	}
</script>

<script language="javascript" type="text/javascript" src="/scripts/transaction_bodypart_calculation.js"></script>

<cfif getGeneralInfo.texteditor eq "1">
<!--- TinyMCE --->
<script type="text/javascript" src="../../tiny_mce/tiny_mce.js"></script>
<script type="text/javascript">
	tinyMCE.init({
		// General options
		mode : "textareas",
		theme : "advanced",
		plugins : "safari,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",

		// Theme options
		theme_advanced_buttons1 : "newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,styleselect,formatselect,fontselect,fontsizeselect",
		theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
		theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
		theme_advanced_buttons4 : "insertlayer,moveforward,movebackward,absolute,|,styleprops,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,pagebreak",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_statusbar_location : "bottom",
		theme_advanced_resizing : true,

		// Example content CSS (should be your site CSS)
		content_css : "css/content.css",

		// Drop lists for link/image/media/template dialogs
		template_external_list_url : "lists/template_list.js",
		external_link_list_url : "lists/link_list.js",
		external_image_list_url : "lists/image_list.js",
		media_external_list_url : "lists/media_list.js",
		
		// Replace values for the template plugin
		template_replace_values : {
			username : "Some User",
			staffid : "dddd"
		}
	});
</script>
<!--- /TinyMCE --->
</cfif>
</head>

<cfparam name = "refnohis1" default="">
<cfparam name = "refnohis2" default="">
<cfparam name = "refnohis3" default="">
<cfparam name = "refnohis4" default="">
<cfparam name = "refnohis5" default="">
<cfparam name = "pricehis1" default="">
<cfparam name = "pricehis2" default="">
<cfparam name = "pricehis3" default="">
<cfparam name = "pricehis4" default="">
<cfparam name = "pricehis5" default="">
<cfparam name = "qtyhis1" default="">
<cfparam name = "qtyhis2" default="">
<cfparam name = "qtyhis3" default="">
<cfparam name = "qtyhis4" default="">
<cfparam name = "qtyhis5" default="">
<cfparam name = "disc1" 	default="">
<cfparam name = "disc2" 	default="">
<cfparam name = "disc3" 	default="">
<cfparam name = "disc4" 	default="">
<cfparam name = "disc5" 	default="">
<cfparam name = "date1" 	default="">
<cfparam name = "date2" 	default="">
<cfparam name = "date3" 	default="">
<cfparam name = "date4" 	default="">
<cfparam name = "date5" 	default="">
<cfparam name = "itembal" 	default="0">
<cfparam name = "inqty" 	default="0">
<cfparam name = "outqty" 	default="0">
<cfparam name = "doqty" 	default="0">
<cfparam name = "balonhand" default="0">

<!--- <cfquery datasource="#dts#" name="getGeneralInfo">
	select 
	invoneset,
	negstk,
	brem1,
	brem2,
	brem3,
	brem4,
	bcurr 
	from gsetup;
</cfquery> --->

<cfquery datasource="#dts#" name="getlocation">
	select 
	location,
	desp 
	from iclocation 
    where 0=0
    <cfif (lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "viva_i" or lcase(hcomid) eq "kjctrial_i") and (HUserGrpID neq 'Cust Svr' and HUserGrpID neq 'Van Sales')>
    <cfelse>
    <cfif Huserloc neq "All_loc">
	and location='#Huserloc#'
	</cfif>
    </cfif>
	order by location;
</cfquery>

<!--- URL.TYPE1 DELETE --->
<cfinclude template="transaction4_delete.cfm">
<!--- URL.TYPE1 DELETE --->

<!--- URL.TYPE1 EDIT --->
<cfinclude template="transaction4_edit.cfm">
<!--- URL.TYPE1 EDIT --->

<!--- URL.TYPE1 ADD --->
<cfinclude template="transaction4_add.cfm">
<!--- URL.TYPE1 ADD --->

<cfif getpricehis.recordcount gt 0>
	<cfloop query="getpricehis">
		<cfswitch expression="#getpricehis.currentrow#">
			<cfcase value="1">
            	<cfset refnohis1 = getpricehis.refno>
				<cfset pricehis1 = getpricehis.price>
				<cfset qtyhis1 = getpricehis.qty>
				<cfset date1 = dateformat(getpricehis.wos_date,"dd/mm/yyyy")>
				<cfset disc1 = getpricehis.dispec1 & " + " & getpricehis.dispec2 & " + " & getpricehis.dispec3>
			</cfcase>
			<cfcase value="2">
            	<cfset refnohis2 = getpricehis.refno>
				<cfset pricehis2 = getpricehis.price>
				<cfset qtyhis2 = getpricehis.qty>
				<cfset date2 = dateformat(getpricehis.wos_date,"dd/mm/yyyy")>
				<cfset disc2 = getpricehis.dispec1 & " + " & getpricehis.dispec2 & " + " & getpricehis.dispec3>
			</cfcase>
			<cfcase value="3">
            	<cfset refnohis3 = getpricehis.refno>
				<cfset pricehis3 = getpricehis.price>
				<cfset qtyhis3 = getpricehis.qty>
				<cfset date3 = dateformat(getpricehis.wos_date,"dd/mm/yyyy")>
				<cfset disc3 = getpricehis.dispec1 & " + " & getpricehis.dispec2 & " + " & getpricehis.dispec3>
			</cfcase>
			<cfcase value="4">
            	<cfset refnohis4 = getpricehis.refno>
				<cfset pricehis4 = getpricehis.price>
				<cfset qtyhis4 = getpricehis.qty>
				<cfset date4 = dateformat(getpricehis.wos_date,"dd/mm/yyyy")>
				<cfset disc4 = getpricehis.dispec1 & " + " & getpricehis.dispec2 & " + " & getpricehis.dispec3>
			</cfcase>
			<cfcase value="5">
            	<cfset refnohis5 = getpricehis.refno>
				<cfset pricehis5 = getpricehis.price>
				<cfset qtyhis5 = getpricehis.qty>
				<cfset date5 = dateformat(getpricehis.wos_date,"dd/mm/yyyy")>
				<cfset disc5 = getpricehis.dispec1 & " + " & getpricehis.dispec2 & " + " & getpricehis.dispec3>
			</cfcase>
		</cfswitch>
	</cfloop>
</cfif>

<!--- CHECK SERVICE --->
<cfinclude template="transaction4_check_service.cfm">
<!--- CHECK SERVICE --->
<cfif lcase(hcomid) neq 'ideal_i'>
<cfif tran eq "PR" or tran eq "DO" or tran eq "INV" or tran eq "CS" or tran eq "DN" or tran eq "ISS" or tran eq "OAR">
  	<cfif balonhand lte 0 and mode eq "Add" and isservice neq "1" and getGeneralInfo.negstk eq "0">
    <cfif lcase(hcomid) eq 'ballysa_i' or lcase(hcomid) eq 'gucci_i' or lcase(hcomid) eq 'guccicapetown_i'>
		<h3>
		<font color="FF0000">Negative or Zero Stock, The quantity on hand is <cfoutput>#balonhand#</cfoutput>.</font>
		<br><br>
		<font color="FF0000">Please click Back to continue.</font>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" name="back" id="back1" value="Back" onClick="javascript:history.back()">
		</h3>
		<cfabort>
    </cfif>
	</cfif>
    <cfif isservice neq "1">
    <cfif balonhand lte 0 and mode eq "Add" and isservice neq "1" and getGeneralInfo.prozero eq "1">
    <script type="text/javascript">
	alert("This item stock quantity is equal or less than zero");
    </script>
    <cfelseif balonhand lt minimumqty and mode eq "Add" and isservice neq "1" and getGeneralInfo.prozero eq "1">
    <script type="text/javascript">
	alert("This item stock quantity is less than minimum quantity");
    </script>
    </cfif>
    </cfif>

</cfif>
<cfelse>
<cfif tran eq "PR" or tran eq "DO" or tran eq "CS" or tran eq "DN" or tran eq "ISS" or tran eq "OAR">
  	<cfif balonhand lte 0 and mode eq "Add" and isservice neq "1" and getGeneralInfo.negstk eq "0">
		<h3>
		<font color="FF0000">Negative or Zero Stock, The quantity on hand is <cfoutput>#balonhand#</cfoutput>.</font>
		<br><br>
		<font color="FF0000">Please click Back to continue.</font>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" name="back" id="back1" value="Back" onClick="javascript:history.back()">
		</h3>
		<cfabort>
	</cfif>
    <cfif isservice neq "1">
    <cfif balonhand lte 0 and mode eq "Add" and isservice neq "1" and getGeneralInfo.prozero eq "1">
    <script type="text/javascript">
	alert("This item stock quantity is equal or less than zero");
    </script>
    <cfelseif balonhand lt minimumqty and mode eq "Add" and isservice neq "1" and getGeneralInfo.prozero eq "1">
    <script type="text/javascript">
	alert("This item stock quantity is less than minimum quantity");
    </script>
    </cfif>
    </cfif>
</cfif>
</cfif>

<!--- Remark on 230908 --->
<!--- Control The Decimal Point --->
<!--- <cfquery name="getgsetup2" datasource="#dts#">
	select 
	concat('.',repeat('_',Decl_Uprice)) as Decl_Uprice,
	concat('.',repeat('_',Decl_Discount)) as Decl_Discount
	from gsetup2
</cfquery>

<cfset stDecl_UPrice = getgsetup2.Decl_Uprice>
<cfset stDecl_Discount = getgsetup2.Decl_Discount> --->
<!--- Control The Decimal Point --->

<body onLoad="javascript:transaction_body_onload();">

<cfoutput>
	<h4>
	<cfif alcreate eq 1>
		<cfif getgeneralinfo.invoneset neq "1" and tran eq "INV">
			<a href="transaction0.cfm?tran=#URLEncodedFormat(tran)#">Create New #tranname#</a>
		<cfelse>
			<a href="transaction1.cfm?ttype=create&tran=#URLEncodedFormat(tran)#&nexttranno=&bcode=&dcode=&first=0">Create New #tranname#</a>
		</cfif> ||
	</cfif>
	<a href="transaction.cfm?tran=#URLEncodedFormat(tran)#">List all #tranname#</a> ||
	<a href="stransaction.cfm?tran=#URLEncodedFormat(tran)#&searchtype=&searchstr=">Search For #tranname#</a>
	</h4>
</cfoutput>

<!--- BODY PART --->
<cfinclude template="transaction4_body_part.cfm">
<!--- BODY PART --->

<!---JAVA SCRIPT DATA VALIDATION --->
<cfinclude template="transaction4_data_validation.cfm">
<!---JAVA SCRIPT DATA VALIDATION --->
<cfif lcase(hcomid) eq "taftc_i" or lcase(hcomid) eq "ugateway_i">
<script type="text/javascript">
checkqty();
</script>
</cfif>
</body>
</html>