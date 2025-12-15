<cfif IsDefined('url.mItemNo')>
	<cfset URLmItemNo = trim(urldecode(url.mItemNo))>
</cfif>

<cfquery name="getCategory" datasource='#dts#'>
    SELECT * 
    FROM iccate;
</cfquery>

<cfquery name="getGroup" datasource='#dts#'>
    SELECT * 
    FROM icgroup;
</cfquery>

<cfquery name="getSize" datasource='#dts#'>
    SELECT * 
    FROM icsizeid;
</cfquery>

<cfquery name="getMaterial" datasource='#dts#'>
    SELECT * 
    FROM iccolorid;
</cfquery>

<cfquery name="getBrand" datasource='#dts#'>
    SELECT * 
    FROM brand;
</cfquery>

<cfquery name="getModel" datasource='#dts#'>
    SELECT * 
    FROM vehimodel;
</cfquery>

<cfquery name="getCurrency" datasource='#dts#'>
    SELECT * 
    FROM currency;
</cfquery>

<cfquery name="getUnitOfMeasurement" datasource='#dts#'>
    SELECT * 
    FROM unit;
</cfquery>

<!--- Control The Decimal Point --->
<cfquery name='getgsetup2' datasource='#dts#'>
  Select * from gsetup2
</cfquery>
<cfset iDecl_UPrice = getgsetup2.Decl_Uprice>
<cfset stDecl_UPrice = '.'>
<cfloop index='LoopCount' from='1' to='#iDecl_UPrice#'>
  <cfset stDecl_UPrice = stDecl_UPrice & '_'>
</cfloop>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create Matrix Profile">
		<cfset pageAction="Create">
        
        <cfset colorNo = "">
        <cfset matrixItemNo = "">
        <cfset alternateItemNo= "">
        <cfset desp = "">
        <cfset despa = "">
        <cfset comment = "">
        
        <cfset brand = "">
        <cfset supplier = "">
        <cfset category = "">
        <cfset group = "">
        <cfset photo = "">  
        <cfset size = "">
        <cfset material = "">
        <cfset model = "">
        
        
        <cfset unitOfMeasurement = "">
        <cfset unitCostPrice = "">
        <cfset unitSellingPrice1 = "">
        <cfset unitSellingPrice2 = "">
        <cfset unitSellingPrice3 = "">
        <cfset unitSellingPrice4 = ""> 
        <cfset muRatio = "">
        
        <cfset foreignCurrency = "">
        <cfset foreignUnitCost = "">
        <cfset foreignSellingPrice = "">
        
        <cfloop index="i" from="2" to="10">
        	<cfset 'foreignCurrency#i#' = "">
            <cfset 'foreignUnitCost#i#' = "">
            <cfset 'foreignSellingPrice#i#' = "">
        </cfloop>
        
        <cfloop index="i" from="1" to="30">
        	<cfset 'remark#i#' = "">
        </cfloop>
        
        <cfset foreignSellingPrice = "">       
         
        <cfloop index="i" from="1" to="20">
        	<cfset 'color#i#' = "">
            <cfset 'size#i#' = "">
        </cfloop>
        
        <cfset sizeColor = "">
         
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Matrix Profile">
		<cfset pageAction="Update">
        
		<cfquery name="getMatrix" datasource='#dts#'>
            SELECT * 
            FROM icmitem 
            WHERE mitemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLmItemNo#">;
		</cfquery>
        
        <cfset colorNo = getMatrix.colorno>
        <cfset matrixItemNo = getMatrix.mitemno>
        <cfset alternateItemNo= getMatrix.aitemno>
        <cfset desp = getMatrix.desp>
        <cfset despa = getMatrix.despa>
        <cfset comment = getMatrix.comment>
        
        <cfset brand = getMatrix.brand>
        <cfset supplier = getMatrix.supp>
        <cfset category = getMatrix.category>
        <cfset group = getMatrix.wos_group>
        <cfset photo = getMatrix.photo>  
        <cfset size = getMatrix.sizeid>
        <cfset material = getMatrix.colorid>
        <cfset model = getMatrix.shelf>
        
        
        <cfset unitOfMeasurement = getMatrix.unit>
        <cfset unitCostPrice = getMatrix.ucost>
        <cfset unitSellingPrice1 = getMatrix.price>
        <cfset unitSellingPrice2 = getMatrix.price2>
        <cfset unitSellingPrice3 = getMatrix.price3>
        <cfset unitSellingPrice4 = getMatrix.price4>
        <cfset muRatio = getMatrix.muratio>
        
        <cfset foreignCurrency = getMatrix.fcurrcode>
        <cfset foreignUnitCost = getMatrix.fucost>
        <cfset foreignSellingPrice = getMatrix.fprice>
        
        <cfloop index="i" from="2" to="10">
        	<cfset 'foreignCurrency#i#' = evaluate('getMatrix.fcurrcode#i#')>
            <cfset 'foreignUnitCost#i#' = evaluate('getMatrix.fucost#i#')>
            <cfset 'foreignSellingPrice#i#' = evaluate('getMatrix.fprice#i#')>
        </cfloop>      
        
        <cfloop index="i" from="1" to="30">
        	<cfset 'remark#i#' = evaluate('getMatrix.remark#i#')>
        </cfloop>       
         
        <cfloop index="i" from="1" to="20">
        	<cfset 'color#i#' = evaluate('getMatrix.color#i#')>
            <cfset 'size#i#' = evaluate('getMatrix.size#i#')>
        </cfloop>
                 
        <cfset sizeColor = "">
                 
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Matrix Profile">
		<cfset pageAction="Delete"> 
        
		<cfquery name="getMatrix" datasource='#dts#'>
            SELECT * 
            FROM icmitem 
            WHERE mitemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLmItemNo#">;
		</cfquery>
        
        <cfset colorNo = getMatrix.colorno>
        <cfset matrixItemNo = getMatrix.mitemno>
        <cfset alternateItemNo= getMatrix.aitemno>
        <cfset desp = getMatrix.desp>
        <cfset despa = getMatrix.despa>
        <cfset comment = getMatrix.comment>
        
        <cfset brand = getMatrix.brand>
        <cfset supplier = getMatrix.supp>
        <cfset category = getMatrix.category>
        <cfset group = getMatrix.wos_group>
        <cfset photo = getMatrix.photo>  
        <cfset size = getMatrix.sizeid>
        <cfset material = getMatrix.colorid>
        <cfset model = getMatrix.shelf>
        
        
        <cfset unitOfMeasurement = getMatrix.unit>
        <cfset unitCostPrice = getMatrix.ucost>
        <cfset unitSellingPrice1 = getMatrix.price>
        <cfset unitSellingPrice2 = getMatrix.price2>
        <cfset unitSellingPrice3 = getMatrix.price3>
        <cfset unitSellingPrice4 = getMatrix.price4>
        <cfset muRatio = getMatrix.muratio>
        
        <cfset foreignCurrency = getMatrix.fcurrcode>
        <cfset foreignUnitCost = getMatrix.fucost>
        <cfset foreignSellingPrice = getMatrix.fprice>
        
        <cfloop index="i" from="2" to="10">
        	<cfset 'foreignCurrency#i#' = evaluate('getMatrix.fcurrcode#i#')>
            <cfset 'foreignUnitCost#i#' = evaluate('getMatrix.fucost#i#')>
            <cfset 'foreignSellingPrice#i#' = evaluate('getMatrix.fprice#i#')>
        </cfloop>      
        
        <cfloop index="i" from="1" to="30">
        	<cfset 'remark#i#' = evaluate('getMatrix.remark#i#')>
        </cfloop>       
         
        <cfloop index="i" from="1" to="20">
        	<cfset 'color#i#' = evaluate('getMatrix.color#i#')>
            <cfset 'size#i#' = evaluate('getMatrix.size#i#')>
        </cfloop>          
		
        <cfset sizeColor = getMatrix.sizecolor>
        
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
    
    <cfinclude template="/latest/maintenance/filter/filterSupplier.cfm">
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
    <script>
	
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
		
		function change_picture(picture)
	{
		var encode_picture = encodeURI(picture);
		show_picture.location="/latest/uploadImage/icitem_image.cfm?pic3="+encode_picture;
	}
		
		function delete_picture(picture)
		{
		var answer =confirm("Are you sure want to delete picture "+picture);
		if (answer)
		{
			var encode_picture = encodeURI(picture);
			show_picture.location="/latest/uploadImage/icitem_image.cfm?delete=true&picture="+encode_picture;
			var elSel = document.getElementById('picture_available');
			  var i;
			  for (i = elSel.length - 1; i>=0; i--) {
				if (elSel.options[i].selected) {
				  elSel.remove(i);
				}
			  }
		}
		
		}
		
		function showpic(picname)
			{
			return hs.expand(picname)
			}
			
		function uploading_picture(pic_name)
		{
			var new_pic_name1 = new String(pic_name);
			var new_pic_name2 = new_pic_name1.split(/[-,/,\\]/g);
			document.getElementById("picture_name").value=new_pic_name2[new_pic_name2.length-1];
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
	</script>
</head>

<body class="container">
<cfoutput>
<form id="form" name="form" class="form-horizontal" role="form" action="/latest/maintenance/matrixProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('matrixItemNo').disabled=false";>
	<div class="page-header">
		<h3>#pageTitle#</h3>
	</div>
		<div class="panel-group">
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##mainInfoCollapse">
						<h4 class="panel-title accordion-toggle">Main Information</h4>
					</div>
					<div id="mainInfoCollapse" class="panel-collapse collapse in">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">		
                                	<div class="form-group">
										<label for="colorNo" class="col-sm-4 control-label">Color No</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="colorNo" name="colorNo" value="#colorNo#" placeholder="Color No">									
										</div>
									</div>					
									<div class="form-group">
										<label for="matrixItemNo" class="col-sm-4 control-label">Matrix Item No</label>
										<div class="col-sm-8">			
											<input type="text" class="form-control input-sm" id="matrixItemNo" name="matrixItemNo" placeholder="Matrix Item No" required="yes" maxlength="25" <cfif IsDefined('url.action') AND url.action NEQ 'create'>  value="#matrixItemNo#"  disabled="true"</cfif>/>										
										</div>
									</div>	
                                    <div class="form-group">
										<label for="alternateItemNo" class="col-sm-4 control-label">Alternate Item No</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="alternateItemNo" name="alternateItemNo" value="#alternateItemNo#" placeholder="Alternate Item No">									
										</div>
									</div>	
                                    <div class="form-group">
										<label for="desp" class="col-sm-4 control-label">Description</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="desp" name="desp" value="#desp#" placeholder="Description">									
                                            <input type="text" class="form-control input-sm" id="despa" name="despa" value="#despa#" placeholder="Description 2">									
										</div>
									</div>	  
                                    <div class="form-group">
										<label for="comment" class="col-sm-4 control-label">Comment</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="comment" name="comment" value="#comment#" placeholder="Comment">									
										</div>
									</div>                                                                  						
								</div>
							</div>
						</div>
					</div>
				</div>
                	
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##generalInfoCollapse">
						<h4 class="panel-title accordion-toggle">Product Information</h4>
					</div>
					<div id="generalInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">      
                                 	<div class="form-group">
										<label for="brand" class="col-sm-4 control-label">Brand</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" name="brand">
                                                <option value="">Select a Brand</option>
                                                <cfloop query="getBrand">
                                                	<option value="#getBrand.brand#">#getBrand.brand#</option>
                                                </cfloop>
                                            </select>									
										</div>
									</div>                
                                    <div class="form-group">
										<label for="supplier" class="col-sm-4 control-label">Supplier</label>
										<div class="col-sm-8">
											<input type="hidden" id="supplier" name="supplier" class="supplierFilter" value="#supplier#" />	
										</div>
									</div>	
                                    
                                    <div class="form-group">
										<label for="category" class="col-sm-4 control-label">Category</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" name="category">
                                                <option value="">Select a Category</option>
                                                <cfloop query="getCategory">
                                                	<option value="#getCategory.cate#">#getCategory.cate#</option>
                                                </cfloop>
                                            </select>	
										</div>
									</div>	
                                   	<div class="form-group">
										<label for="group" class="col-sm-4 control-label">Group</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" name="group">
                                                <option value="">Select a Group</option>
                                                <cfloop query="getGroup">
                                                	<option value="#getGroup.wos_group#" #IIF(wos_group eq wos_group,DE('selected'),DE(''))#>#getGroup.wos_group#</option>
                                                </cfloop>
                                            </select>	
										</div>
									</div> 
                                    <div class="form-group">
										<label for="photo" class="col-sm-4 control-label">Item's Image</label>
										<div class="col-sm-8">
											<cfdirectory action="list" directory="#HRootPath#\images\#hcomid#\" name="picture_list">
                                           <select name="picture_available" id="picture_available" onChange="javascript:change_picture(this.value);" class="form-control input-sm">
                                                <option value="">-</option>
                                                <cfloop query="picture_list">
                                                    <cfif picture_list.name neq "Thumbs.db">
                                                        <option value="#picture_list.name#" #iif((photo eq picture_list.name),DE("selected"),DE(""))#>#picture_list.name#</option>
                                                    </cfif>
                                                </cfloop>
                                            </select> 
                                            <div style="float:right; margin:25px;">	
                                            	<iframe id="show_picture" name="show_picture" frameborder="0" marginheight="0" marginwidth="0" align="middle" height="150" width="150" scrolling="no" src="/latest/uploadImage/icitem_image.cfm?pic3=#urlencodedformat(photo)#"></iframe>		
                                            </div>		
										</div>
									</div>	
								</div>
                                <div class="col-sm-6">                                   
                                  	<div class="form-group">
										<label for="size" class="col-sm-4 control-label">Size</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" name="size">
                                                <option value="">Select a Size</option>
                                                <cfloop query="getSize">
                                                	<option value="#getSize.sizeID#" #IIF(sizeID eq sizeID,DE('selected'),DE(''))#>#getSize.sizeID#</option>
                                                </cfloop>
                                            </select>	
										</div>
									</div>  
                                    <div class="form-group">
										<label for="material" class="col-sm-4 control-label">Material</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" name="material">
                                                <option value="">Select a Material</option>
                                                <cfloop query="getMaterial">
                                                	<option value="#getMaterial.colorid#" #IIF(colorid eq material,DE('selected'),DE(''))#>#getMaterial.colorid#</option>
                                                </cfloop>
                                            </select>	
										</div>
									</div> 
                                    <div class="form-group">
										<label for="model" class="col-sm-4 control-label">Model</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" name="model">
                                                <option value="">Select a Model</option>
                                                <cfloop query="getModel">
                                                	<option value="#getModel.model#" #IIF(model eq model,DE('selected'),DE(''))#>#getModel.model#</option>
                                                </cfloop>
                                            </select>	
										</div>
									</div>                  						
								</div>	
							</div>
						</div>
					</div>
				</div>
                
                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##productInfoCollapse">
						<h4 class="panel-title accordion-toggle">Unit Information</h4>
					</div>                    
					<div id="productInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
                            	<div class="col-sm-6">    
                                	<div class="form-group">
										<label for="unitSellingPrice1" class="col-sm-4 control-label">Unit Selling Price 1</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="unitSellingPrice1" name="unitSellingPrice1" value="#unitSellingPrice1#" placeholder="Unit Selling Price 1">	
										</div>
									</div>	
                                    <div class="form-group">
										<label for="unitSellingPrice2" class="col-sm-4 control-label">Unit Selling Price 2</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="unitSellingPrice2" name="unitSellingPrice2" value="#unitSellingPrice2#" placeholder="Unit Selling Price 2">	
										</div>
									</div>
                                    <div class="form-group">
										<label for="muRatio" class="col-sm-4 control-label">M.U Ratio</label>
                                        <div class="col-sm-2">
											<input type="text" class="form-control input-sm" id="muRatio" name="muRatio" value="#muRatio#" placeholder="M.U Ratio" onkeyup="calculateMUratio(#iDecl_UPrice#)">	
										</div>
										<div class="col-sm-6">
											<input type="text" class="form-control input-sm" id="unitSellingPrice3" name="unitSellingPrice3" value="#NumberFormat(unitSellingPrice3, stDecl_UPrice)#" placeholder="Unit Selling Price 3">	
										</div>
									</div>
                                    <div class="form-group">
										<label for="unitSellingPrice4" class="col-sm-4 control-label">Unit Selling Price 4</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="unitSellingPrice4" name="unitSellingPrice4" value="#unitSellingPrice4#" placeholder="Unit Selling Price 4">	
										</div>
									</div>	                        						
								</div>
								<div class="col-sm-6">                      
                                	<div class="form-group">
										<label for="unitOfMeasurement" class="col-sm-4 control-label">Unit of Measurement</label>
										<div class="col-sm-8">
											<select class="form-control input-sm" name="unitOfMeasurement">
                                                <option value="">Select an Unit of Measurement</option>
                                                <cfloop query="getUnitOfMeasurement">
                                                	<option value="#getUnitOfMeasurement.unit#" #IIF(unit eq unitOfMeasurement,DE('selected'),DE(''))#>#getUnitOfMeasurement.unit#</option>
                                                </cfloop>
                                            </select>	
										</div>
									</div>
                                    <div class="form-group">
										<label for="unitCostPrice" class="col-sm-4 control-label">Unit Cost Price</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="unitCostPrice" name="unitCostPrice" value="#unitCostPrice#" placeholder="Unit Cost Price">	
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
                
                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##foreignInfoCollapse">
						<h4 class="panel-title accordion-toggle">Foreign Currency, Unit Cost and Selling Price Information</h4>
					</div>                    
					<div id="foreignInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">                      	
                                    <div class="form-group">
									                                    
                                    	<cfloop index="i" from="1" to="10">
                                            <label for="foreignCurrency#i#" class="col-sm-4 control-label">Foreign Currency #i#</label>
                                            <div class="col-sm-8">
                                            	<select class="form-control input-sm" id="foreignCurrency#i#" name="foreignCurrency#i#" >
                                                	<cfloop query="getCurrency">
														<cfif i EQ 1>
                                                            <cfset foreignCurrencyValue = #foreignCurrency#>
                                                        <cfelse>
                                                            <cfset foreignCurrencyValue = evaluate('foreignCurrency#i#')>
                                                        </cfif>
                                                        <option value ="#foreignCurrencyValue#">#foreignCurrencyValue#</option>
                                                    </cfloop>
                                                </select> 
                                            </div>
                                        </cfloop>     
									</div>
								</div>
                                
                                <div class="col-sm-3">                      	
                                    <div class="form-group">                               
                                    	<cfloop index="i" from="1" to="10">
                                            <div class="col-sm-8">
                                            	<cfif i EQ 1>
                                                	<cfset foreignUnitCostValue = #foreignUnitCost#>
                                                <cfelse>
                                                	<cfset foreignUnitCostValue = evaluate('foreignUnitCost#i#')>
                                                </cfif>	
                                                <input type="text" class="form-control input-sm" id="foreignUnitCostValue#i#" name="foreignUnitCostValue#i#" value="#foreignUnitCostValue#" placeholder="Foreign Unit Cost #i#">	
                                            </div>
                                        </cfloop>     
									</div>
								</div>
                                
                                <div class="col-sm-3">                      	
                                    <div class="form-group">                               
                                    	<cfloop index="i" from="1" to="10">
                                            <div class="col-sm-8">
                                            	<cfif i EQ 1>
                                                	<cfset foreignSellingPriceValue = #foreignSellingPrice#>
                                                <cfelse>
                                                	<cfset foreignSellingPriceValue = evaluate('foreignSellingPrice#i#')>
                                                </cfif>	
                                                <input type="text" class="form-control input-sm" id="foreignSellingPriceValue#i#" name="foreignSellingPriceValue#i#" value="#foreignSellingPriceValue#" placeholder="Foreign Selling Price #i#">	
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
						<h4 class="panel-title accordion-toggle">Remark Information</h4>
					</div>
					<div id="remarksInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">      
                                 	<div class="form-group">                               
                                    	<cfloop index="i" from="1" to="15">
                                            <label for="remark#i#" class="col-sm-4 control-label">Remark #i#</label>
                                            <div class="col-sm-8">	
                                            	<cfset remarkValue = evaluate('remark#i#')>	
                                                <input type="text" class="form-control input-sm" id="remark#i#" name="remark#i#" value="#remarkValue#" placeholder="Remark #i#" maxlength="25">										
                                            </div>
                                        </cfloop>     
									</div>                      
								</div>
                                <div class="col-sm-6">      
                                 	<div class="form-group">                               
                                    	<cfloop index="i" from="16" to="30">
                                            <label for="remark#i#" class="col-sm-4 control-label">Remark #i#</label>
                                            <div class="col-sm-8">	
                                            	<cfset remarkValue = evaluate('remark#i#')>	
                                                <input type="text" class="form-control input-sm" id="remark#i#" name="remark#i#" value="#remarkValue#" placeholder="Remark #i#" maxlength="25">										
                                            </div>
                                        </cfloop>     
									</div>                      
								</div>	
							</div>
						</div>
					</div>
				</div>
                
                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##colorInfoCollapse">
						<h4 class="panel-title accordion-toggle">Color Information</h4>
					</div>
					<div id="colorInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">      
                                 	<div class="form-group">                               
                                    	<cfloop index="i" from="1" to="10">
                                            <label for="color#i#" class="col-sm-4 control-label">Color #i#</label>
                                            <div class="col-sm-8">	
                                            	<cfset colorValue = evaluate('color#i#')>	
                                                <input type="text" class="form-control input-sm" id="color#i#" name="color#i#" value="#colorValue#" placeholder="Color #i#" maxlength="25">										
                                            </div>
                                        </cfloop>     
									</div>                       
								</div>
                                <div class="col-sm-6">      
                                 	<div class="form-group">                               
                                    	<cfloop index="i" from="11" to="20">
                                            <label for="color#i#" class="col-sm-4 control-label">Color #i#</label>
                                            <div class="col-sm-8">	
                                            	<cfset colorValue = evaluate('color#i#')>	
                                                <input type="text" class="form-control input-sm" id="color#i#" name="color#i#" value="#colorValue#" placeholder="Color #i#" maxlength="25">										
                                            </div>
                                        </cfloop>     
									</div>                       
								</div>	
							</div>
						</div>
					</div>
				</div>
                
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##sizeInfoCollapse">
						<h4 class="panel-title accordion-toggle">Size Information</h4>
					</div>
					<div id="sizeInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">      
                                 	<div class="form-group">                               
                                    	<cfloop index="i" from="1" to="10">
                                            <label for="size#i#" class="col-sm-4 control-label">Size #i#</label>
                                            <div class="col-sm-8">	
                                            	<cfset sizeValue = evaluate('size#i#')>	
                                                <input type="text" class="form-control input-sm" id="size#i#" name="size#i#" value="#sizeValue#" placeholder="Size #i#" maxlength="25">										
                                            </div>
                                        </cfloop>     
									</div>                       
								</div>
                                <div class="col-sm-6">      
                                 	<div class="form-group">                               
                                    	<cfloop index="i" from="11" to="20">
                                            <label for="size#i#" class="col-sm-4 control-label">Size #i#</label>
                                            <div class="col-sm-8">	
                                            	<cfset sizeValue = evaluate('size#i#')>	
                                                <input type="text" class="form-control input-sm" id="size#i#" name="size#i#" value="#sizeValue#" placeholder="Size #i#" maxlength="25">										
                                            </div>
                                        </cfloop>     
									</div>                       
								</div>	
							</div>
						</div>
					</div>
				</div>
                
                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##otherInfoCollapse">
						<h4 class="panel-title accordion-toggle">Other Option(s)</h4>
					</div>
					<div id="otherInfoCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">                          
                                <div class="col-sm-6">      
                                 	<div class="form-group">                               
                                    	<label for="sizeAndColor" class="col-sm-4 control-label">Size and Color</label>
										<div class="col-sm-8">
											<div class="row">
												<div class="col-sm-7">
													<div class="radio">	
														<input type="radio" id="sizeColor" name="sizeColor" value="SC" <cfif sizeColor eq "SC">checked</cfif>>
													</div>													
												</div>
											</div>											
										</div>
                                        <label for="sizeOnly" class="col-sm-4 control-label">Size Only</label>
										<div class="col-sm-8">
											<div class="row">
												<div class="col-sm-7">
													<div class="radio">	
														<input type="radio" id="sizeColor" name="sizeColor" value="S" <cfif sizeColor eq "S">checked</cfif>>
													</div>													
												</div>
											</div>											
										</div>
                                        <label for="colorOnly" class="col-sm-4 control-label">Color Only</label>
										<div class="col-sm-8">
											<div class="row">
												<div class="col-sm-7">
													<div class="radio">	
														<input type="radio" id="sizeColor" name="sizeColor" value="C" <cfif sizeColor eq "C">checked</cfif>>
													</div>													
												</div>
											</div>											
										</div> 
									</div>                      
								</div>	
							</div>
						</div>
					</div>
				</div>
                
			</div>
            
            <div class="pull-right">
				<input type="submit" value="#pageAction#" class="btn btn-primary"/>
				<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/matrixProfile.cfm'" class="btn btn-default" />
			</div>
</form>
</cfoutput>
</body>
</html>

