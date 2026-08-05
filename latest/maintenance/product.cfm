<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "124,95,271,98,125,120,65,126,127,121,128,129,130,319,320,321,131,132,133,134,135,136,137,138,139,
140,141,122,123,142,143,144,145,146,147,148,149,150,151,152,153,154,155,104,156,157,158,159,160,161,162,163,164,165,166,167,
168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,195,196,197,198,
199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,
229,230,231,232,233,234,235,236,237,238,239,240,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,
339,340,341,342,343,344,345,346,347,348,349,350,351,244,91,92,93,94,245,246,247,248,249,250,251,252,253,254,255,256,
257,258,259,260,261,262,263,264,265,266,267,268,269,270,96">
<cfinclude template="/latest/words.cfm">

<cfif IsDefined('url.itemno')>
	<cfset URLitemNo = trim(urldecode(url.itemno))>
</cfif>

<cfquery name="getTax" datasource="#dts#">
	SELECT code,code AS code2
    FROM #target_taxtable#
    WHERE (tax_type = "ST" OR tax_type = "T");
</cfquery>

<cfquery name="getCategory" datasource="#dts#">
    SELECT *
    FROM iccate;
</cfquery>

<cfquery name="getBrand" datasource="#dts#">
    SELECT *
    FROM brand;
</cfquery>

<cfquery name="getGroup" datasource="#dts#">
    SELECT *
    FROM icgroup;
</cfquery>

<cfquery name="getCommission" datasource="#dts#">
    SELECT commname
    FROM commission;
</cfquery>

<cfquery name="getMaterial" datasource='#dts#'>
    SELECT *
    FROM iccolorid;
</cfquery>

<cfquery name="getRating" datasource='#dts#'>
    SELECT *
    FROM iccostcode;
</cfquery>

<cfquery name="getSize" datasource='#dts#'>
    SELECT *
    FROM icsizeid;
</cfquery>

<cfquery name="getModel" datasource='#dts#'>
    SELECT *
    FROM vehimodel;
</cfquery>

<cfquery name="getCurrency" datasource='#dts#'>
    SELECT currcode
    FROM #target_currency#;
</cfquery>

<cfquery name="getUnitOfMeasurement" datasource='#dts#'>
    SELECT *
    FROM unit;
</cfquery>

<!--- Control The Decimal Point --->
<cfquery name='getgsetup2' datasource='#dts#'>
  SELECT *
  FROM gsetup2;
</cfquery>
<cfset iDecl_UPrice = getgsetup2.Decl_Uprice>
<cfset stDecl_UPrice = '.'>
<cfloop index='LoopCount' from='1' to='#iDecl_UPrice#'>
  <cfset stDecl_UPrice = stDecl_UPrice & '_'>
</cfloop>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[124]#">
		<cfset pageAction="#words[95]#">

        <!--- Panel 1--->
        <cfset itemNo = "">
        <cfset desp = "">
        <cfset despa= "">
        <cfset comment = "">
        <cfset productCode = "">
        <cfset barCode = "">
        <cfset defaultTax = "">
        <cfset itemType = "">
        <cfset photo = "">
        <cfset document = "">

        <!--- E-Menu tags (FnB panel) — defaults match icitem's own column defaults --->
        <cfset fnb_sort_ord = 0>
        <cfset fnb_promo_price = "">
        <cfset fnb_is_avail = "T">
        <cfset fnb_is_feat = "F">
        <cfset fnb_for_dine = "T">
        <cfset fnb_for_take = "T">
        <cfset fnb_for_deliv = "T">
        <cfset fnb_is_veg = "F">
        <cfset fnb_is_halal = "F">
        <cfset fnb_is_spicy = "F">
        <cfset fnb_spice_lvl = 0>
        <cfset fnb_allergens = "">
        <cfset fnb_calories = "">
        <cfset fnb_prep_time = "">

        <!--- Panel 2--->
        <cfset brandValue = "">
        <cfset commission = "">
        <cfset category = "">
        <cfset group = "">
        <cfset material = "">
        <cfset modelValue = "">
        <cfset rating = "">
        <cfset size = "">
        <cfset costFormula = "">
        <cfset supplier = "">
        <cfset quantityFormula = "">
        <cfset unitPriceFormula = "">
        <cfset serialNo = "">
        <cfset relatedItem = "">
        <cfset packing = "">
        <cfset reorder = "">
        <cfset minimum = "">
        <cfset maximum = "">
        <cfset qtyBF = "">
        <cfset quantity2 = "">
        <cfset quantity3 = "">
        <cfset quantity4 = "">
        <cfset quantity5 = "">
        <cfset quantity6 = "">
        <cfset grade = "">
        <cfset nonGraded = "">
        <cfset nonstkitem = "">

        <!--- Panel 3--->
        <cfset salec = "">
		<cfset salecsc = "">
        <cfset salecnc = "">
        <cfset purc = "">
        <cfset purprc = "">
		<cfset displayDefaultValue = "Choose a GL Account">
        <cfset stock = "">

        <!--- Panel 4--->
        <cfloop index="i" from="1" to="6">
        	<cfset 'unitSellingPrice#i#' = "">
		</cfloop>
        <cfset muRatio = "">
        <cfset unitOfMeasurement = "">
        <cfset unitCostPrice = "">
        <cfset minSellingPrice = "">
        <cfset normalOfferOthersValue = "">
        <cfset normal= "">
        <cfset offer = "">
        <cfset others = "">


        <!--- Panel 5--->
        <cfset unitOfMeasurement2 = "">
        <cfset firstUnit2 = "">
        <cfset secondUnit2 = "">
        <cfset sellingPrice2 = "">
        <cfloop index="i" from="3" to="6">
        	<cfset 'unitOfMeasurement#i#' = "">
            <cfset 'firstUnit#i#' = "">
            <cfset 'secondUnit#i#' = "">
            <cfset 'sellingPrice#i#' = "">
        </cfloop>

        <cfloop index="i" from="1" to="10">
        	<cfset 'packingName#i#' = "">
            <cfset 'packingQuantity#i#' = "">
            <cfset 'freeQty#i#' = "">
        </cfloop>

        <!--- Panel 7--->
        <cfloop index="i" from="1" to="10">
        	<cfset 'foreignCurrency#i#' = "">
            <cfset 'foreignUnitCost#i#' = "">
            <cfset 'foreignSellingPrice#i#' = "">
            <cfset 'foreignMinSellingPrice#i#' = "">
        </cfloop>

        <!--- Panel 8--->
        <cfloop index="i" from="1" to="30">
        	<cfset 'remark#i#' = "">
        </cfloop>

	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[271]#">
		<cfset pageAction="#words[98]#">

		<cfquery name="getProduct" datasource='#dts#'>
            SELECT *
            FROM icitem
            WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemNo#">;
		</cfquery>

        <!--- Panel 1--->
        <cfset itemNo = getProduct.itemno>
        <cfset desp = getProduct.desp>
        <cfset despa= getProduct.despa>
        <cfset comment = getProduct.comment>
        <cfset productCode = getProduct.aitemno>
        <cfset barCode = getProduct.barcode>
        <cfset defaultTax = getProduct.taxcode>
        <cfset itemType = getProduct.itemtype>
        <cfset photo = getProduct.photo>
        <cfset document = getProduct.document>

        <!--- E-Menu tags (FnB panel) --->
        <cfset fnb_sort_ord = getProduct.sort_ord>
        <cfset fnb_promo_price = ""><cfif isNumeric(getProduct.promo_price) AND val(getProduct.promo_price) gt 0><cfset fnb_promo_price = getProduct.promo_price></cfif>
        <cfset fnb_is_avail = getProduct.is_avail>
        <cfset fnb_is_feat = getProduct.is_feat>
        <cfset fnb_for_dine = getProduct.for_dine>
        <cfset fnb_for_take = getProduct.for_take>
        <cfset fnb_for_deliv = getProduct.for_deliv>
        <cfset fnb_is_veg = getProduct.is_veg>
        <cfset fnb_is_halal = getProduct.is_halal>
        <cfset fnb_is_spicy = getProduct.is_spicy>
        <cfset fnb_spice_lvl = val(getProduct.spice_lvl)>
        <cfset fnb_allergens = ""><cfif NOT isNull(getProduct.allergens)><cfset fnb_allergens = getProduct.allergens></cfif>
        <cfset fnb_calories = ""><cfif NOT isNull(getProduct.calories)><cfset fnb_calories = getProduct.calories></cfif>
        <cfset fnb_prep_time = ""><cfif NOT isNull(getProduct.prep_time)><cfset fnb_prep_time = getProduct.prep_time></cfif>

        <!--- Panel 2--->
        <cfset brandValue = getProduct.brand>
        <cfset commission = getProduct.commlvl>
        <cfset category = getProduct.category>
        <cfset group = getProduct.wos_group>
        <cfset material = getProduct.colorid>
        <cfset modelValue = getProduct.shelf>
        <cfset costFormula = getProduct.costformula>
        <cfset rating = getProduct.costcode>
        <cfset size = getProduct.sizeid>
        <cfset supplier = getProduct.supp>
        <cfset quantityFormula = getProduct.wqformula>
        <cfset unitPriceFormula = getProduct.wpformula>
        <cfset serialNo = getProduct.wserialno>
        <cfset relatedItem = "">
        <cfset packing = getProduct.packing>
        <cfset reorder = getProduct.reorder>
        <cfset minimum = getProduct.minimum>
        <cfset maximum = getProduct.maximum>
        <cfset qtyBF = getProduct.qtybf>
        <cfloop index="i" from="2" to="6">
        	<cfset 'quantity#i#' = evaluate('getProduct.qty#i#')>
        </cfloop>

        <cfset grade = getProduct.graded>
        <cfset nonstkitem = getProduct.nonstkitem>

        <!--- Panel 3--->
        <cfset salec = getProduct.salec>
		<cfset salecsc = getProduct.salecsc>
        <cfset salecnc = getProduct.salecnc>
        <cfset purc = getProduct.purc>
        <cfset purprc = getProduct.purprec>
		<cfset displayDefaultValue = "Choose a GL Account">
        <cfset stock = getProduct.stock>

        <!--- Panel 4--->
        <cfloop index="i" from="1" to="6">
        	<cfif i EQ 1>
            	<cfset 'unitSellingPrice#i#' = getProduct.price>
            <cfelse>
        		<cfset 'unitSellingPrice#i#' = evaluate('getProduct.price#i#')>
            </cfif>
		</cfloop>
        <cfset muRatio = getProduct.muratio>
        <cfset unitOfMeasurement = getProduct.unit>
        <cfset unitCostPrice = getProduct.ucost>
        <cfset minSellingPrice = getProduct.price_min>
        <cfset normalOfferOthersValue= getProduct.custprice_rate>

        <!--- Panel 5--->
        <cfset unitOfMeasurement2 = getProduct.unit2>
        <cfset firstUnit2 = getProduct.factor1>
        <cfset secondUnit2 = getProduct.factor2>
        <cfset sellingPrice2 = getProduct.priceu2>
        <cfloop index="i" from="3" to="6">
        	<cfset 'unitOfMeasurement#i#' = evaluate('getProduct.unit#i#')>
            <cfset 'firstUnit#i#' = evaluate('getProduct.factoru#i#_a')>
            <cfset 'secondUnit#i#' = evaluate('getProduct.factoru#i#_b')>
            <cfset 'sellingPrice#i#' = evaluate('getProduct.priceu#i#')>
        </cfloop>


        <cfloop index="i" from="1" to="10">
        	<cfset 'packingName#i#' = evaluate('getProduct.packingdesp#i#')>
            <cfset 'packingQuantity#i#' = evaluate('getProduct.packingqty#i#')>
            <cfset 'freeQty#i#' = evaluate('getProduct.packingfreeqty#i#')>
        </cfloop>

        <!--- Panel 7--->
        <cfset foreignCurrency1 = getProduct.fcurrcode>
        <cfset foreignUnitCost1 = getProduct.fucost>
        <cfset foreignSellingPrice1 = getProduct.fprice>
        <cfset foreignMinSellingPrice1 = getProduct.fprice_min>
        <cfloop index="i" from="2" to="10">
        	<cfset 'foreignCurrency#i#' = evaluate('getProduct.fcurrcode#i#')>
            <cfset 'foreignUnitCost#i#' = evaluate('getProduct.fucost#i#')>
            <cfset 'foreignSellingPrice#i#' = evaluate('getProduct.fprice#i#')>
            <cfset 'foreignMinSellingPrice#i#' = evaluate('getProduct.fprice#i#_min')>
        </cfloop>

        <!--- Panel 8--->
        <cfloop index="i" from="1" to="30">
        	<cfset 'remark#i#' = evaluate('getProduct.remark#i#')>
        </cfloop>
	</cfif>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->

    <link rel="stylesheet" type="text/css" href="/latest/css/maintenance/target.css">
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.css">
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js" type="text/javascript"></script>
  	<script src="/latest/js/priceFormat/jquery.maskMoney.js" type="text/javascript"></script>

    <cfinclude template="/latest/maintenance/filter/filterBrand.cfm">
    <cfinclude template="/latest/maintenance/filter/filterCategory.cfm">
    <cfinclude template="/latest/maintenance/filter/filterGroup.cfm">
   	<cfinclude template="/latest/maintenance/filter/filterSupplier.cfm">
    <cfinclude template="/latest/maintenance/filter/filterGL.cfm">

    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
    <script language="JavaScript">
		    function GetValueFromChild(type,type_name)
    		{

    	  var detection=0;
    	  if(type=="Img"){
		  	  var s = document.getElementById("picture_available");
		  }else{
		  	  var s = document.getElementById("document_available");
		  }
		  var totaloption=(s.length)-1;

		  for(var i=0;i<=totaloption;++i){
			  if(s.options[i].value==type_name){
				  detection=1;
				  break;
			  }
		  }
		  if(detection!=1){
		    var optn = document.createElement("OPTION");
		  	  optn.text = type_name;
		  	  optn.value = type_name;
		  	  //window.opener.document.getElementById("picture_available").options.add(optn);

		  	  s.options[s.options.length] = new Option(type_name,type_name);
		  	  for(var i=0;i<=totaloption;++i){
			  	if(s.options[i].value==type_name){
				  detection=1;
				  break;
			  	}
		  	  }
		  }
		  s.value = type_name;
    	}


		function calculateMUratio(fixnum){

			if(isNaN(document.getElementById('muRatio').value)){
				alert("Your input is not a number! Please try again!");
			}
			else{
				if( document.getElementById('unitCostPrice').value == ''){
					var costprice = 0;
				}
				else{
					var costprice =  document.getElementById('unitCostPrice').value;
				}
				var price3 = document.getElementById('muRatio').value  * document.getElementById('unitCostPrice').value;
				price3 = price3.toFixed(fixnum);
				document.getElementById('unitSellingPrice3').value = price3;
			}
		}

		function setPendingItemImage(base64, mime){
			document.getElementById('pendingImgBase64').value = base64;
			document.getElementById('pendingImgMime').value = mime;
			document.getElementById('clearImage').value = '0';
			var img = document.getElementById('itemImgPreview');
			img.src = 'data:' + mime + ';base64,' + base64;
			img.style.display = '';
		}

		function removeItemImage(){
			document.getElementById('pendingImgBase64').value = '';
			document.getElementById('pendingImgMime').value = '';
			document.getElementById('clearImage').value = '1';
			var img = document.getElementById('itemImgPreview');
			img.removeAttribute('src');
			img.style.display = 'none';
		}

		function downloadDocument(){

			if(document.getElementById('document_available').value == ''){
				alert('Please choose a document!');
			}
			else{
				<cfoutput>
					window.open('/document/#hcomid#/'+document.getElementById('document_available').value)
				</cfoutput>
			}
		}

		<!---$(function() {
			<!---Panel 4 --->
			$('#unitSellingPrice1').maskMoney();
			$('#unitSellingPrice2').maskMoney();
			$('#unitSellingPrice3').maskMoney();
			$('#unitSellingPrice4').maskMoney();
			$('#unitSellingPrice5').maskMoney();
			$('#unitSellingPrice6').maskMoney();
			$('#unitCostPrice').maskMoney();
			$('#minSellingPrice').maskMoney();
			<!---Panel 5 --->
			$('#sellingPrice2').maskMoney();
			$('#sellingPrice3').maskMoney();
			$('#sellingPrice4').maskMoney();
			$('#sellingPrice5').maskMoney();
			$('#sellingPrice6').maskMoney();
			<!---Panel 7 --->
			$('#foreignUnitCost1').maskMoney();
			$('#foreignUnitCost2').maskMoney();
			$('#foreignUnitCost3').maskMoney();
			$('#foreignUnitCost4').maskMoney();
			$('#foreignUnitCost5').maskMoney();
			$('#foreignUnitCost6').maskMoney();
			$('#foreignUnitCost7').maskMoney();
			$('#foreignUnitCost8').maskMoney();
			$('#foreignUnitCost9').maskMoney();
			$('#foreignUnitCost10').maskMoney();
			$('#foreignSellingPrice1').maskMoney();
			$('#foreignSellingPrice2').maskMoney();
			$('#foreignSellingPrice3').maskMoney();
			$('#foreignSellingPrice4').maskMoney();
			$('#foreignSellingPrice5').maskMoney();
			$('#foreignSellingPrice6').maskMoney();
			$('#foreignSellingPrice7').maskMoney();
			$('#foreignSellingPrice8').maskMoney();
			$('#foreignSellingPrice9').maskMoney();
			$('#foreignSellingPrice10').maskMoney();
			$('#foreignMinSellingPrice1').maskMoney();
			$('#foreignMinSellingPrice2').maskMoney();
			$('#foreignMinSellingPrice3').maskMoney();
			$('#foreignMinSellingPrice4').maskMoney();
			$('#foreignMinSellingPrice5').maskMoney();
			$('#foreignMinSellingPrice6').maskMoney();
			$('#foreignMinSellingPrice7').maskMoney();
			$('#foreignMinSellingPrice8').maskMoney();
			$('#foreignMinSellingPrice9').maskMoney();
			$('#foreignMinSellingPrice10').maskMoney();
		})--->
	</script>
</head>

<body class="container">
<cfoutput>
<form id="form" name="form" class="form-horizontal" role="form" action="/latest/maintenance/productProcess.cfm?action=#url.action#&menuID=#url.menuID#" method="post" onsubmit="document.getElementById('itemNo').disabled=false;">
	<div class="page-header">
		<h3>#pageTitle#</h3>
	</div>
		<div class="panel-group">
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##panel1Collapse">
						<h4 class="panel-title accordion-toggle">#words[125]#</h4>
					</div>
                    <div id="panel1Collapse" class="panel-collapse collapse in">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
                                 	<div class="form-group">
										<label for="itemNo" class="col-sm-4 control-label">#words[120]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="itemNo" name="itemNo"  placeholder="#words[120]#" required="yes" <cfif IsDefined("url.action") AND url.action NEQ "create"> value="#itemNo#" disabled="true"</cfif>>
										</div>
									</div>
                                    <div class="form-group">
										<label for="desp" class="col-sm-4 control-label">#words[65]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="desp" name="desp" value="#desp#" placeholder="#words[65]#">
                                            <input type="text" class="form-control input-sm" id="desp" name="despa" value="#despa#" placeholder="#words[126]#">
										</div>
									</div>
                                     <div class="form-group">
										<label for="comment" class="col-sm-4 control-label">#words[127]#</label>
										<div class="col-sm-8">
                                        	<textarea id="comment" name="comment" rows="3" cols="50" placeholder="#words[127]#">#comment#</textarea>

										</div>
									</div>
                                    <div class="form-group">
										<label for="productCode" class="col-sm-4 control-label">#words[121]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="productCode" name="productCode" value="#productCode#" placeholder="#words[121]#">
										</div>
									</div>
                                    <div class="form-group">
										<label for="barCode" class="col-sm-4 control-label">#words[128]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="barCode" name="barCode" value="#barCode#" placeholder="#words[128]#">
										</div>
									</div>
                                    <div class="form-group">
										<label for="itemType" class="col-sm-4 control-label">#words[129]#</label>
										<div class="col-sm-8">
											<select name="itemtype" id="itemtype" class="form-control input-sm">
                                            	<option value="">#words[130]#</option>
                                              	<option value="S" <cfif itemtype EQ "S">selected </cfif>>#words[319]#</option>
                                              	<option value="P" <cfif itemtype EQ "P">selected </cfif>>#words[320]#</option>
                                              	<option value="SV" <cfif itemtype EQ "SV">selected </cfif>>#words[321]#</option>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label for="defaultTax" class="col-sm-4 control-label">#words[131]#</label>
										<div class="col-sm-8">
											<select name="defaultTax" id="defaultTax" class="form-control input-sm">
                                            	<option value="">#words[132]#</option>
                                              	<cfloop query="getTax">
                                                	<option value="#code#" <cfif getTax.code EQ defaultTax>selected</cfif>>#code#</option>
                                                </cfloop>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label for="itemNo" class="col-sm-4 control-label">#words[133]#</label>
										<div class="col-sm-8">
											<img id="itemImgPreview"
												src="<cfif len(trim(itemNo))>/latest/Waiter/MenuImage.cfm?id=#urlencodedformat(itemNo)#</cfif>"
												align="middle" width="150" height="150"
												style="<cfif NOT len(trim(itemNo))>display:none;</cfif>"
												onerror="this.style.display='none';"
												onload="this.style.display='';">
											<input type="hidden" id="pendingImgBase64" name="pendingImgBase64" value="">
											<input type="hidden" id="pendingImgMime" name="pendingImgMime" value="">
											<input type="hidden" id="clearImage" name="clearImage" value="0">
										</div>
                                        <div style="margin-top:-5px; margin-left: 500px;">
                                            <button type="button" class="btn btn-default" onclick="window.open('/latest/uploadImage/uploadItemImage.cfm','Upload Item Image','height=200,width=500');">
                                                <span class="glyphicon glyphicon-plus"></span> #words[135]#
                                            </button>
                                            <button type="button" class="btn btn-default" onclick="removeItemImage();">Remove</button>
                                        </div>

									</div>

                                    <div class="form-group">
                                    	<cfdirectory action="list" directory="#HRootPath#\document\#hcomid#\" name="document_list">
										<label for="itemNo" class="col-sm-4 control-label">#words[136]#</label>
										<div class="col-sm-8">
											<select name="document_available" id="document_available" class="form-control input-sm">
          										<option value="">#words[137]#</option>
                                                <cfloop query="document_list">
                                                    <option value="#document_list.name#" #iif((document eq document_list.name),DE("selected"),DE(""))#>#document_list.name#</option>
                                                </cfloop>
                                            </select>
										</div>
                                        <div style="margin-top:-2px; margin-left: 500px;">
                                            <button type="button" class="btn btn-default" onclick="window.open('/latest/uploadImage/uploadDocument.cfm','Upload Document','height=200,width=500');">
                                                <span class="glyphicon glyphicon-plus"></span> #words[138]#
                                            </button>
                                        </div>
                                        <div style="margin-top:-34px; margin-left: 750px;">
                                            <button type="button" class="btn btn-default" onclick="downloadDocument();">
                                                <span class="glyphicon glyphicon-plus"></span> #words[139]#
                                            </button>
                                        </div>
									</div>

                                    <div class="form-group">
										<label for="nonstkitem" class="col-sm-4 control-label">#words[140]#</label>
										<div class="col-sm-8">
											<input type="checkbox" id="nonstkitem" name="nonstkitem" <cfif nonstkitem EQ "T">checked</cfif>/>
										</div>
									</div>

            					</div>
            				</div>
                		</div>
                	</div>
				</div>

				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##emenuTagsCollapse">
						<h4 class="panel-title accordion-toggle">E-Menu — Availability &amp; Tags</h4>
					</div>
					<div id="emenuTagsCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="col-sm-4 control-label">Show in E-Menu</label>
										<div class="col-sm-8">
											<input type="checkbox" name="fnb_is_avail" <cfif fnb_is_avail EQ "T">checked</cfif>/>
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Featured</label>
										<div class="col-sm-8">
											<input type="checkbox" name="fnb_is_feat" <cfif fnb_is_feat EQ "T">checked</cfif>/>
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Available for Dine-in</label>
										<div class="col-sm-8">
											<input type="checkbox" name="fnb_for_dine" <cfif fnb_for_dine EQ "T">checked</cfif>/>
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Available for Takeaway</label>
										<div class="col-sm-8">
											<input type="checkbox" name="fnb_for_take" <cfif fnb_for_take EQ "T">checked</cfif>/>
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Available for Delivery</label>
										<div class="col-sm-8">
											<input type="checkbox" name="fnb_for_deliv" <cfif fnb_for_deliv EQ "T">checked</cfif>/>
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Display order</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" name="fnb_sort_ord" value="#fnb_sort_ord#" placeholder="0">
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Promo price</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" name="fnb_promo_price" value="#fnb_promo_price#" placeholder="Optional">
										</div>
									</div>
								</div>
								<div class="col-sm-6">
									<div class="form-group">
										<label class="col-sm-4 control-label">Vegetarian</label>
										<div class="col-sm-8">
											<input type="checkbox" name="fnb_is_veg" <cfif fnb_is_veg EQ "T">checked</cfif>/>
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Halal</label>
										<div class="col-sm-8">
											<input type="checkbox" name="fnb_is_halal" <cfif fnb_is_halal EQ "T">checked</cfif>/>
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Spicy</label>
										<div class="col-sm-8">
											<input type="checkbox" name="fnb_is_spicy" <cfif fnb_is_spicy EQ "T">checked</cfif>/>
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Spice level</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" name="fnb_spice_lvl">
												<option value="0" <cfif fnb_spice_lvl EQ 0>selected</cfif>>0 - None</option>
												<option value="1" <cfif fnb_spice_lvl EQ 1>selected</cfif>>1 - Mild</option>
												<option value="2" <cfif fnb_spice_lvl EQ 2>selected</cfif>>2 - Medium</option>
												<option value="3" <cfif fnb_spice_lvl EQ 3>selected</cfif>>3 - Hot</option>
												<option value="4" <cfif fnb_spice_lvl EQ 4>selected</cfif>>4 - Extra hot</option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Allergens</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" name="fnb_allergens" value="#fnb_allergens#" placeholder="e.g. Peanuts, Shellfish, Dairy" maxlength="200">
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Calories</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" name="fnb_calories" value="#fnb_calories#" placeholder="kcal">
										</div>
									</div>
									<div class="form-group">
										<label class="col-sm-4 control-label">Prep time</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" name="fnb_prep_time" value="#fnb_prep_time#" placeholder="minutes">
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##generalInfoCollapse">
						<h4 class="panel-title accordion-toggle">#words[141]#</h4>
					</div>
					<div id="generalInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
                                 	<div class="form-group">
										<label for="brand" class="col-sm-4 control-label">#words[122]#</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" id="brand" name="brand">
                                                <option value="">#words[142]#</option>
                                                <cfloop query="getBrand">
                                                    <option value="#getBrand.brand#" <cfif IsDefined('getBrand.brand') AND getBrand.brand EQ brandValue>selected</cfif>>#getBrand.brand#</option>
                                                </cfloop>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label for="category" class="col-sm-4 control-label">#words[123]#</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" id="category" name="category">
                                                <option value="">#words[143]#</option>
                                                <cfloop query="getCategory">
                                                    <option value="#getCategory.cate#" <cfif IsDefined('getCategory.cate') AND getCategory.cate EQ category>selected</cfif>>#getCategory.cate#</option>
                                                </cfloop>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label for="commision" class="col-sm-4 control-label">#words[144]#</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" id="commission" name="commission">
                                                <option value="">#words[145]#</option>
                                                <cfloop query="getCommission">
                                                    <option value="#getCommission.commname#" <cfif IsDefined('getCommission.commname') AND getCommission.commname EQ commission>selected</cfif>>#getCommission.commname#</option>
                                                </cfloop>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label for="group" class="col-sm-4 control-label">#words[146]#</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" id="group" name="group">
                                                <cfif hitemgroup eq '' or getGroup.recordcount eq 0>
                                                <option value="">#words[147]#</option>
                                                </cfif>
                                                <cfloop query="getGroup">
                                                    <option value="#getGroup.wos_group#" <cfif IsDefined('getGroup.wos_group') AND getGroup.wos_group EQ group>selected</cfif>>#getGroup.wos_group#</option>
                                                </cfloop>
                                            </select>
										</div>
									</div>
                                   	<div class="form-group">
										<label for="material" class="col-sm-4 control-label">#words[148]#</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" id="material" name="material">
                                                <option value="">#words[149]#</option>
                                                <cfloop query="getMaterial">
                                                    <option value="#getMaterial.colorid#" <cfif IsDefined('getMaterial.colorid') AND getMaterial.colorid EQ material>selected</cfif>>#getMaterial.colorid#</option>
                                                </cfloop>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label for="material" class="col-sm-4 control-label">#words[150]#</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" id="model" name="model">
                                                <option value="">#words[151]#</option>
                                                <cfloop query="getModel">
                                                    <option value="#getModel.model#" <cfif IsDefined('getModel.model') AND getModel.model EQ modelValue>selected</cfif>>#getModel.model#</option>
                                                </cfloop>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label for="rating" class="col-sm-4 control-label">#words[152]#</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" id="rating" name="rating">
                                                <option value="">#words[153]#</option>
                                                <cfloop query="getRating">
                                                    <option value="#getRating.costcode#" <cfif IsDefined('getRating.costcode') AND getRating.costcode EQ rating>selected</cfif>>#getRating.costcode#</option>
                                                </cfloop>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
										<label for="size" class="col-sm-4 control-label">#words[154]#</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" id="size" name="size">
                                                <option value="">#words[155]#</option>
                                                <cfloop query="getSize">
                                                    <option value="#getSize.sizeid#" <cfif IsDefined('getSize.sizeid') AND getSize.sizeid EQ size>selected</cfif>>#getSize.sizeid#</option>
                                                </cfloop>
                                            </select>
										</div>
									</div>
                                    <div class="form-group">
                                        <label for="supplier" class="col-sm-4 control-label">#words[104]#</label>
                                        <div class="col-sm-8">
                                            <input type="hidden" id="supplier" name="supplier" class="supplierFilter" value="#supplier#" placeholder="#words[156]#" />
                                        </div>
                                    </div>
                                    <div class="form-group">
										<label for="qtyFormula" class="col-sm-4 control-label">#words[157]#</label>
										<div class="col-sm-8">
											<input type="checkbox" id="quantityFormula" name="quantityFormula" <cfif quantityFormula EQ 1>checked</cfif>/>
										</div>
									</div>
                                    <div class="form-group">
										<label for="unitPriceFormula" class="col-sm-4 control-label">#words[158]#</label>
										<div class="col-sm-8">
											<input type="checkbox" id="unitPriceFormula" name="unitPriceFormula" <cfif unitPriceFormula EQ 1>checked</cfif>/>
										</div>
									</div>
                                    <div class="form-group">
										<label for="serialNo" class="col-sm-4 control-label">#words[159]#</label>
										<div class="col-sm-8">
											<input type="checkbox" id="serialNo" name="serialNo" value="T" <cfif serialNo EQ "T">checked</cfif>/>
										</div>
									</div>
								</div>
                                <div class="col-sm-6">
                                	<div class="form-group">
										<label for="packing" class="col-sm-4 control-label">#words[160]#</label>
										<div class="col-sm-8">
												<input type="text" class="form-control input-sm" id="packing" name="packing" value="#packing#" placeholder="#words[161]#" maxlength="20">
										</div>
									</div>
                                    <div class="form-group">
										<label for="reorder" class="col-sm-4 control-label">#words[162]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="reorder" name="reorder" value="#reorder#" placeholder="#words[163]#" maxlength="20">
										</div>
									</div>
                                    <div class="form-group">
										<label for="minimum" class="col-sm-4 control-label">#words[164]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="minimum" name="minimum" value="#minimum#" placeholder="#words[165]#" maxlength="20">
										</div>
									</div>
                                    <div class="form-group">
										<label for="maximum" class="col-sm-4 control-label">#words[166]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="maximum" name="maximum" value="#maximum#" placeholder="#words[167]#" maxlength="20">
										</div>
									</div>
                                    <div class="form-group">
										<label for="qtyBF" class="col-sm-4 control-label">#words[168]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="qtyBF" name="qtyBF" value="#qtyBF#" placeholder="#words[169]#" maxlength="20">
										</div>
									</div>
                                    <div class="form-group">
										<label for="quantity2" class="col-sm-4 control-label">#words[170]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="quantity2" name="quantity2" value="#quantity2#" placeholder="#words[171]#" maxlength="20">
										</div>
									</div>
                                    <div class="form-group">
										<label for="quantity3" class="col-sm-4 control-label">#words[172]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="quantity3" name="quantity3" value="#quantity3#" placeholder="#words[173]#" maxlength="20">
										</div>
									</div>
                                    <div class="form-group">
										<label for="quantity4" class="col-sm-4 control-label">#words[174]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="quantity4" name="quantity4" value="#quantity4#" placeholder="#words[175]#" maxlength="20">
										</div>
									</div>
                                    <div class="form-group">
										<label for="quantity5" class="col-sm-4 control-label">#words[176]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="quantity5" name="quantity5" value="#quantity5#" placeholder="#words[177]#" maxlength="20">
										</div>
									</div>
                                    <div class="form-group">
										<label for="quantity6" class="col-sm-4 control-label">#words[178]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="quantity6" name="quantity6" value="#quantity6#" placeholder="#words[179]#" maxlength="20">
										</div>
									</div>
                                    <div class="form-group">
										<label for="graded" class="col-sm-4 control-label">#words[180]#</label>
										<div class="col-sm-8">
											<input type="radio" id="grade" name="grade" value="Y" <cfif grade EQ "Y">checked</cfif>>
										</div>
									</div>
                                    <div class="form-group">
										<label for="nonGraded" class="col-sm-4 control-label">#words[181]#</label>
										<div class="col-sm-8">
											<input type="radio" id="grade" name="grade" value="" <cfif grade EQ "" OR url.action EQ 'create' >checked</cfif>>
										</div>
									</div>
                                </div>
							</div>
						</div>
					</div>
				</div>

                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##productInfoCollapse">
						<h4 class="panel-title accordion-toggle">#words[190]#</h4>
					</div>
					<div id="productInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
                                <div class="col-sm-6">
                                	<div class="form-group">
										<label for="unitSellingPrice1" class="col-sm-4 control-label">#words[191]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="unitSellingPrice1" name="unitSellingPrice1" value="#NumberFormat(unitSellingPrice1,stDecl_UPrice)#" placeholder="#words[191]#">
										</div>
									</div>
                                    <div class="form-group">
										<label for="unitSellingPrice2" class="col-sm-4 control-label">#words[192]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="unitSellingPrice2" name="unitSellingPrice2" value="#NumberFormat(unitSellingPrice2,stDecl_UPrice)#" placeholder="#words[192]#">
										</div>
									</div>
                                    <div class="form-group">
										<label for="muRatio" class="col-sm-4 control-label">#words[193]#</label>
                                        <div class="col-sm-2">
											<input type="text" class="form-control input-sm" id="muRatio" name="muRatio" value="#muRatio#" placeholder="#words[193]#" onkeyup="calculateMUratio(#iDecl_UPrice#)">
										</div>
										<div class="col-sm-6">
											<input type="text" class="form-control input-sm" id="unitSellingPrice3" name="unitSellingPrice3" value="#NumberFormat(unitSellingPrice3,stDecl_UPrice)#" placeholder="#words[195]#">
										</div>
									</div>
                                    <div class="form-group">
										<label for="unitSellingPrice4" class="col-sm-4 control-label">#words[196]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="unitSellingPrice4" name="unitSellingPrice4" value="#NumberFormat(unitSellingPrice4,stDecl_UPrice)#" placeholder="#words[196]#">
										</div>
									</div>
                                    <div class="form-group">
										<label for="unitSellingPrice5" class="col-sm-4 control-label">#words[197]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="unitSellingPrice5" name="unitSellingPrice5" value="#NumberFormat(unitSellingPrice5,stDecl_UPrice)#" placeholder="#words[197]#">
										</div>
									</div>
                                    <div class="form-group">
										<label for="unitSellingPrice6" class="col-sm-4 control-label">#words[198]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="unitSellingPrice6" name="unitSellingPrice6" value="#NumberFormat(unitSellingPrice6,stDecl_UPrice)#" placeholder="#words[198]#">
										</div>
									</div>
								</div>
                                <div class="col-sm-6">
                                	<div class="form-group">
										<label for="unitOfMeasurement" class="col-sm-4 control-label">#words[199]#</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" name="unitOfMeasurement">
                                                <option value="">#words[200]#</option>
                                                <cfloop query="getUnitOfMeasurement">
                                                	<option value="#getUnitOfMeasurement.unit#" #IIF(unit eq unitOfMeasurement,DE('selected'),DE(''))#>#getUnitOfMeasurement.unit#</option>
                                                </cfloop>
                                            </select>
										</div>
									</div>
                                    <cfif getUserPin2.H10103_3e EQ 'T'>
                                        <div class="form-group">
                                            <label for="unitCostPrice" class="col-sm-4 control-label">#words[201]#</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="unitCostPrice" name="unitCostPrice" value="#NumberFormat(unitCostPrice,stDecl_UPrice)#" placeholder="#words[201]#">
                                            </div>
                                        </div>
										<div class="form-group">
                                        <label for="supplier" class="col-sm-4 control-label">#words[202]#</label>
                                        <div class="col-sm-8">
                                        	 <input type="text" class="form-control input-sm" id="costFormula" name="costFormula" value="#costFormula#" readonly bind="cfc:costformula.getcostformula('#dts#',{unitCostPrice})">
                                    </div>
                                    <cfelse>
                                    <input type="hidden" id="unitCostPrice" name="unitCostPrice" value="#NumberFormat(unitCostPrice,stDecl_UPrice)#">
                                    <cfinput type="hidden" id="costFormula" name="costFormula" value="#costFormula#">
                                    </cfif>
                                    <div class="form-group">
										<label for="minSellingPrice" class="col-sm-4 control-label">#words[203]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="minSellingPrice" name="minSellingPrice" value="#NumberFormat(minSellingPrice,stDecl_UPrice)#" placeholder="#words[203]#">
										</div>
									</div>
                                    <div class="form-group">
										<label for="normal" class="col-sm-4 control-label">#words[204]#</label>
										<div class="col-sm-8">
											<input type="radio" id="normalOfferOthers" name="normalOfferOthers" value="normal" <cfif normalOfferOthersValue EQ "normal">checked</cfif>>
										</div>
									</div>
                                    <div class="form-group">
										<label for="offer" class="col-sm-4 control-label">#words[205]#</label>
										<div class="col-sm-8">
											<input type="radio" id="normalOfferOthers" name="normalOfferOthers" value="offer" <cfif normalOfferOthersValue EQ "offer">checked</cfif>>
										</div>
									</div>
                                    <div class="form-group">
										<label for="others" class="col-sm-4 control-label">#words[206]#</label>
										<div class="col-sm-8">
											<input type="radio" id="normalOfferOthers" name="normalOfferOthers" value="others" <cfif normalOfferOthersValue EQ "others">checked</cfif>>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

                 <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##panel5InfoCollapse">
						<h4 class="panel-title accordion-toggle">#words[207]#</h4>
					</div>
					<div id="panel5InfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-4">
                                	<div class="form-group">
                                    	<cfloop index="i" from="2" to="6">
                                            <label for="unitOfMeasurement#i#" class="col-sm-4 control-label">#words[i+206]#</label>
                                            <div class="col-sm-8">
                                                <select class="form-control input-sm" name="unitOfMeasurement#i#">
                                                    <option value="">#words[200]#</option>
                                                   	<cfif i EQ 2>
                                                    	<cfset value = unitOfMeasurement2>
                                                    <cfelse>
                                                    	<cfset value = evaluate('unitOfMeasurement#i#')>
                                                    </cfif>
                                                    <cfloop query="getUnitOfMeasurement">
                                                        <option value="#getUnitOfMeasurement.unit#" <cfif getUnitOfMeasurement.unit EQ value>selected</cfif>>#getUnitOfMeasurement.unit#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </cfloop>
									</div>
								</div>

                                <div class="col-sm-2">
                                    <div class="form-group">
                                    	<cfloop index="i" from="2" to="6">
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="firstUnit#i#" name="firstUnit#i#" value="#evaluate('firstUnit#i#')#" placeholder="#words[213]#">
                                            </div>
                                        </cfloop>
									</div>
								</div>

                                <div class="col-sm-2">
                                    <div class="form-group">
                                    	<cfloop index="i" from="2" to="6">
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="secondUnit#i#" name="secondUnit#i#" value="#evaluate('secondUnit#i#')#" placeholder="#words[214]#">
                                            </div>
                                        </cfloop>
									</div>
								</div>

                                <div class="col-sm-3">
                                    <div class="form-group">
                                    	<cfloop index="i" from="2" to="6">
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="sellingPrice#i#" name="sellingPrice#i#" value="#NumberFormat(evaluate('sellingPrice#i#'),',_.__')#" placeholder="#words[215]#">
                                            </div>
                                        </cfloop>
									</div>
								</div>

							</div>
						</div>
					</div>
				</div>

                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##panel6InfoCollapse">
						<h4 class="panel-title accordion-toggle">#words[216]#</h4>
					</div>
					<div id="panel6InfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
                                	<div class="form-group">
                                    	<cfloop index="i" from="1" to="10">
                                            <label for="packingName#i#" class="col-sm-4 control-label">#words[i+216]#</label>
                                            <div class="col-sm-8">
                                            	 <input type="text" class="form-control input-sm" id="packingName#i#" name="packingName#i#" value="#evaluate('packingName#i#')#" placeholder="#words[i+216]#">
                                            </div>
                                        </cfloop>
									</div>
								</div>

                                <div class="col-sm-3">
                                    <div class="form-group">
                                    	<cfloop index="i" from="1" to="10">
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="packingQuantity#i#" name="packingQuantity#i#" value="#evaluate('packingQuantity#i#')#" placeholder="#words[227]#">
                                            </div>
                                        </cfloop>
									</div>
								</div>

                                <div class="col-sm-3">
                                    <div class="form-group">
                                    	<cfloop index="i" from="1" to="10">
                                            <div class="col-sm-8">
                                            	<input type="text" class="form-control input-sm" id="freeQty#i#" name="freeQty#i#" value="#evaluate('freeQty#i#')#" placeholder="#words[228]#">
                                            </div>
                                        </cfloop>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##foreignInfoCollapse">
						<h4 class="panel-title accordion-toggle">#words[229]#</h4>
					</div>
					<div id="foreignInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
                                    <div class="form-group">
                                    	<cfloop index="i" from="1" to="10">
                                            <label for="foreignCurrency#i#" class="col-sm-4 control-label">#words[i+229]#</label>
                                            <div class="col-sm-8">
                                            	<select class="form-control input-sm" id="foreignCurrency#i#" name="foreignCurrency#i#" >
                                                	<option value="">#words[240]#</option>
                                                	<cfloop query="getCurrency">
                                                        <option value = "#getCurrency.currcode#" <cfif getCurrency.currcode EQ #evaluate('foreignCurrency#i#')#>selected</cfif>>#getCurrency.currcode#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </cfloop>
									</div>
								</div>

                                <div class="col-sm-2">
                                    <div class="form-group">
                                    	<cfloop index="i" from="1" to="10">
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="foreignUnitCost#i#" name="foreignUnitCost#i#" value="#evaluate('foreignUnitCost#i#')#" placeholder="#words[i+321]#">
                                            </div>
                                        </cfloop>
									</div>
								</div>

                                <div class="col-sm-2">
                                    <div class="form-group">
                                    	<cfloop index="i" from="1" to="10">
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="foreignSellingPrice#i#" name="foreignSellingPrice#i#" value="#evaluate('foreignSellingPrice#i#')#" placeholder="#words[i+331]#">
                                            </div>
                                        </cfloop>
									</div>
								</div>

                                <div class="col-sm-2">
                                    <div class="form-group">
                                    	<cfloop index="i" from="1" to="10">
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="foreignMinSellingPrice#i#" name="foreignMinSellingPrice#i#" value="#evaluate('foreignMinSellingPrice#i#')#" placeholder="#words[i+341]#">
                                            </div>
                                        </cfloop>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##remarksInfoCollapse">
						<h4 class="panel-title accordion-toggle">#words[244]#</h4>
					</div>
					<div id="remarksInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
                                 	<div class="form-group">
                                    	<cfloop index="i" from="1" to="15">
                                            <label for="remark#i#" class="col-sm-4 control-label"><cfif i lt 5>#words[i+90]#<cfelse>#words[i+240]#</cfif></label>
                                            <div class="col-sm-8">
                                            	<cfset remarkValue = evaluate('remark#i#')>
                                                <input type="text" class="form-control input-sm" id="remark#i#" name="remark#i#" value="#remarkValue#" placeholder="<cfif i lt 5>#words[i+90]#<cfelse>#words[i+240]#</cfif>" maxlength="25">
                                            </div>
                                        </cfloop>
									</div>
								</div>
                                <div class="col-sm-6">
                                 	<div class="form-group">
                                    	<cfloop index="i" from="16" to="30">
                                            <label for="remark#i#" class="col-sm-4 control-label">#words[i+240]#</label>
                                            <div class="col-sm-8">
                                            	<cfset remarkValue = evaluate('remark#i#')>
                                                <input type="text" class="form-control input-sm" id="remark#i#" name="remark#i#" value="#remarkValue#" placeholder="#words[i+240]#" maxlength="25">
                                            </div>
                                        </cfloop>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

            <div class="pull-right">
				<input type="submit" value="#pageAction#" class="btn btn-primary"/>
				<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/productProfile.cfm?menuID=#url.menuID#'" class="btn btn-default" />
            </div>

</form>

</cfoutput>
</body>
</html>