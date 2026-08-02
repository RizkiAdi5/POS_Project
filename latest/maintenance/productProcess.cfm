<cfif IsDefined('url.itemno')>
	<cfset URLitemNo = trim(urldecode(url.itemno))>
</cfif>
<cfif IsDefined('url.menuID')>
	<cfset URLmenuID = url.menuID>
</cfif>

<cfquery name='getGsetup' datasource='#dts#'>
  SELECT capall,autolocbf
  FROM gsetup
</cfquery>

<cfoutput>
<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfquery name="checkExist" datasource="#dts#">
			SELECT itemno
            FROM icitem
			WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.itemno)#">;
		</cfquery>
		<cfif checkExist.recordcount>
			<script type="text/javascript">
				alert('This #trim(form.itemno)# already exist!');
				window.open('/latest/maintenance/product.cfm?action=create&menuID=#URLmenuID#','_self');
			</script>
		<cfelse>
			<cftry>
				<cfquery name="createProduct" datasource="#dts#">
					INSERT INTO icitem (itemno,desp,despa,comment,aitemno,barcode,taxcode,itemtype,nonstkitem,photo,document,brand,category,wos_group,colorid,shelf,costcode,sizeid,costformula,
										supp,wqformula,wpformula,wserialno,packing,reorder,minimum,maximum,qtybf,<cfloop index="i" from="2" to="6">qty#i#,</cfloop>graded,
                                        price,<cfloop index="i" from="2" to="6">price#i#,</cfloop>muratio,unit,ucost,price_min,<cfif IsDefined ('form.normalOfferOthers')>custprice_rate,</cfif>
                                        unit2,factor1,factor2,priceu2,<cfloop index="i" from="3" to="6">unit#i#,factoru#i#_a,factoru#i#_b,priceu#i#,</cfloop>
                                        <cfloop index="i" from="1" to="10">packingdesp#i#,packingqty#i#,packingfreeqty#i#,</cfloop>
                                        fcurrcode,fucost,fprice,fprice_min,<cfloop index="i" from="2" to="10">fcurrcode#i#,fucost#i#,fprice#i#,fprice#i#_min,</cfloop>
                                        <cfloop index="i" from="1" to="30">remark#i#,</cfloop>
                                        sort_ord,promo_price,is_avail,is_feat,for_dine,for_take,for_deliv,is_veg,is_halal,is_spicy,spice_lvl,allergens,calories,prep_time
                                        )
					VALUES
					(
                    	<!---Panel 1 --->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.itemNo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.despa)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.comment)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.productCode)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.barCode)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.defaultTax)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.itemType)#">,
                        <cfif IsDefined('form.nonstkitem')>
                        	'T'
                        <cfelse>
                        	'F'
                        </cfif>,
                        '#picture_available#',
						'#document_available#',
                        <!---Panel 2 --->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.brand)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.category)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.group)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.material)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.model)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.rating)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.size)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.costFormula)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.supplier)#">,
                        <cfif IsDefined('form.quantityFormula')>
                        	'1'
                        <cfelse>
                        	'0'
                        </cfif>,
                        <cfif IsDefined('form.unitPriceFormula')>
                        	'1'
                        <cfelse>
                        	'0'
                        </cfif>,
                        <cfif IsDefined('form.serialNo')>
                        	'T'
                        <cfelse>
                        	'F'
                        </cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.packing)#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.reorder))#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.minimum))#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.maximum))#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.qtyBF))#">,
                        <cfloop index="i" from="2" to="6">
                        	<cfqueryparam cfsqltype="cf_sql_double" value="#val(evaluate('form.quantity#i#'))#">,
                        </cfloop>
						<cfif form.grade neq "">
                    		'Y',
						<cfelse>
							'',
                    	</cfif>

                        <!---Panel 3--->
                        <!---Panel 4--->
                        <cfloop index="i" from="1" to="6">
							<cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(evaluate('form.unitSellingPrice#i#')))#">,
                        </cfloop>
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.muRatio))#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.unitOfMeasurement)#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.unitCostPrice))#">,
                        <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(form.minSellingPrice))#">,
                        <cfif IsDefined ('form.normalOfferOthers')>
                    		'#form.normalOfferOthers#',
                    	</cfif>

                        <!---Panel 5--->
                        <cfloop index="i" from="2" to="6">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(evaluate('form.unitOfMeasurement#i#'))#">,
                            <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(evaluate('form.firstUnit#i#')))#">,
                            <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(evaluate('form.secondUnit#i#')))#">,
                            <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(evaluate('form.sellingPrice#i#')))#">,
                        </cfloop>

                        <!---Panel 6--->
                        <cfloop index="i" from="1" to="10">
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(evaluate('form.packingName#i#'))#">,
                            <cfqueryparam cfsqltype="cf_sql_double" value="#val(evaluate('form.packingQuantity#i#'))#">,
                            <cfqueryparam cfsqltype="cf_sql_double" value="#val(evaluate('form.freeQty#i#'))#">,
                        </cfloop>

                        <!---Panel 7--->
                        <cfloop index="i" from="1" to="10">
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(evaluate('form.foreignCurrency#i#'))#">,
                            <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(evaluate('form.foreignUnitCost#i#')))#">,
                            <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(evaluate('form.foreignSellingPrice#i#')))#">,
                            <cfqueryparam cfsqltype="cf_sql_double" value="#val(trim(evaluate('form.foreignMinSellingPrice#i#')))#">,
                        </cfloop>
                        <!---Panel 8--->
                        <cfloop index="i" from="1" to="30">
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(evaluate('form.remark#i#'))#">,
                        </cfloop>
                        <!---FnB Panel (not yet exposed on this form — fall back to icitem's own column defaults when absent) --->
                        <cfif IsDefined('form.fnb_sort_ord')><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.fnb_sort_ord)#"><cfelse>0</cfif>,
                        <cfif IsDefined('form.fnb_promo_price') AND len(trim(form.fnb_promo_price)) AND val(replace(form.fnb_promo_price,',','','all')) GT 0><cfqueryparam cfsqltype="cf_sql_decimal" value="#val(replace(form.fnb_promo_price,',','','all'))#"><cfelse>NULL</cfif>,
                        <cfif IsDefined('form.fnb_is_avail')>'T'<cfelseif IsDefined('form.fnb_sort_ord')>'F'<cfelse>'T'</cfif>,
                        <cfif IsDefined('form.fnb_is_feat')>'T'<cfelse>'F'</cfif>,
                        <cfif IsDefined('form.fnb_for_dine')>'T'<cfelseif IsDefined('form.fnb_sort_ord')>'F'<cfelse>'T'</cfif>,
                        <cfif IsDefined('form.fnb_for_take')>'T'<cfelseif IsDefined('form.fnb_sort_ord')>'F'<cfelse>'T'</cfif>,
                        <cfif IsDefined('form.fnb_for_deliv')>'T'<cfelseif IsDefined('form.fnb_sort_ord')>'F'<cfelse>'T'</cfif>,
                        <cfif IsDefined('form.fnb_is_veg')>'T'<cfelse>'F'</cfif>,
                        <cfif IsDefined('form.fnb_is_halal')>'T'<cfelse>'F'</cfif>,
                        <cfif IsDefined('form.fnb_is_spicy')>'T'<cfelse>'F'</cfif>,
                        <cfif IsDefined('form.fnb_spice_lvl')><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.fnb_spice_lvl)#"><cfelse>0</cfif>,
                        <cfif IsDefined('form.fnb_allergens')><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fnb_allergens)#"><cfelse>NULL</cfif>,
                        <cfif IsDefined('form.fnb_calories') AND len(trim(form.fnb_calories))><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.fnb_calories)#"><cfelse>NULL</cfif>,
                        <cfif IsDefined('form.fnb_prep_time') AND len(trim(form.fnb_prep_time))><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.fnb_prep_time)#"><cfelse>NULL</cfif>
					)
				</cfquery>

				<cfif form.grade EQ "Y">
					<cfquery name="insert_ITEMGRD" datasource="#dts#">
                    INSERT INTO itemgrd (itemno)
                    VALUES (
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.itemNo)#">
                            )
                	</cfquery>
				</cfif>

				<cfif getGsetup.autolocbf EQ "Y">
                    <cfquery name="getLocation" datasource="#dts#">
                        SELECT *
                        FROM iclocation;
                    </cfquery>
                    <cfloop query="getLocation">
                        <cfquery name="insert_LOCQDBF" datasource="#dts#">
                            INSERT INTO locqdbf (itemno,location)
                            VALUES (
                            			'#trim(itemno)#',
                                        '#getlocation.location#'
                                   )
                        </cfquery>
                    </cfloop>
                </cfif>

				<cfcatch type="any">
					<script type="text/javascript">
						alert('Failed to create #trim(form.itemno)#!\nError Message: #cfcatch.message#');
						window.open('/latest/maintenance/product.cfm?action=create&menuID=#URLmenuID#','_self');
					</script>
				</cfcatch>
			</cftry>
			<script type="text/javascript">
				alert('#trim(form.itemno)# has been created successfully!');
				window.open('/latest/maintenance/productProfile.cfm?menuID=#URLmenuID#','_self');
			</script>
		</cfif>
	<cfelseif url.action EQ "update">
		<cftry>
			<!--- FnB Panel is not exposed on this form yet — preserve whatever Menu Maintenance already set instead of resetting it --->
			<cfquery name="qExistingFnb" datasource="#dts#">
				SELECT sort_ord, promo_price, is_avail, is_feat, for_dine, for_take, for_deliv, is_veg, is_halal, is_spicy, spice_lvl, allergens, calories, prep_time
				FROM icitem
				WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.itemno)#">
			</cfquery>
			<cfquery name="updateProduct" datasource="#dts#">
				UPDATE icitem
				SET
					<!---Panel 1 --->
                    desp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.desp)#">,
                    despa = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.despa)#">,
                    comment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.comment)#">,
                    aitemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.productCode)#">,

                    barcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.barCode)#">,
                    taxcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.defaultTax)#">,
                    itemtype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.itemType)#">,
                    <cfif IsDefined('form.nonstkitem')>
                        nonstkitem = 'T'
                    <cfelse>
                        nonstkitem = 'F'
                    </cfif>,
                    photo = '#picture_available#',
                    document = '#document_available#',
                    <!---Panel 2 --->
                    brand = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.brand)#">,
                    category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.category)#">,
                    wos_group = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.group)#">,
                    colorid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.material)#">,
                    shelf = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.model)#">,
                    costcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.rating)#">,
                    sizeid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.size)#">,
                    costformula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.costFormula)#">,
                    supp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.supplier)#">,
                    <cfif IsDefined('form.quantityFormula')>
                        wqformula = '1'
                    <cfelse>
                        wqformula = '0'
                    </cfif>,
                    <cfif IsDefined('form.unitPriceFormula')>
                        wpformula = '1'
                    <cfelse>
                        wpformula = '0'
                    </cfif>,
                    <cfif IsDefined('form.serialNo')>
                        wserialno = 'T'
                    <cfelse>
                        wserialno = 'F'
                    </cfif>,
                    packing = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.packing)#">,
                    reorder = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.reorder)#">,
                    minimum = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.minimum)#">,
                    maximum = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.maximum)#">,
                    qtybf = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.qtyBF)#">,
                    <cfloop index="i" from="2" to="6">
                        qty#i# = <cfqueryparam cfsqltype="cf_sql_double" value="#val(evaluate('form.quantity#i#'))#">,
                    </cfloop>

						graded = '#form.grade#',

                    <!---Panel 3--->
                    <!---Panel 4--->
                    <cfloop index="i" from="1" to="6">
                    	<cfif i EQ 1>
                        	price = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(evaluate('form.unitSellingPrice#i#'),',','','all'))#">,
                        <cfelse>
                        	price#i# = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(evaluate('form.unitSellingPrice#i#'),',','','all'))#">,
                        </cfif>
                    </cfloop>
                    muratio = <cfqueryparam cfsqltype="cf_sql_double" value="#val(form.muRatio)#">,
                    unit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.unitOfMeasurement)#">,
                    ucost = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(form.unitCostPrice,',','','all'))#">,
                    price_min = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(form.minSellingPrice,',','','all'))#">,

                    <cfif IsDefined ('form.normalOfferOthers')>
                    	custprice_rate = '#form.normalOfferOthers#',
                    </cfif>

                    <!---Panel 5--->
               		unit2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(evaluate('form.unitOfMeasurement2'))#">,
                    factor1 = <cfqueryparam cfsqltype="cf_sql_double" value="#val(evaluate('form.firstUnit2'))#">,
                    factor2 = <cfqueryparam cfsqltype="cf_sql_double" value="#val(evaluate('form.secondUnit2'))#">,
                    priceu2 = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(form.sellingPrice2,',','','all'))#">,

                    <cfloop index="i" from="3" to="6">
                        unit#i# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(evaluate('form.unitOfMeasurement#i#'))#">,
                        factoru#i#_a = <cfqueryparam cfsqltype="cf_sql_double" value="#val(evaluate('form.firstUnit#i#'))#">,
                        factoru#i#_b = <cfqueryparam cfsqltype="cf_sql_double" value="#val(evaluate('form.secondUnit#i#'))#">,
                        priceu#i# = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(evaluate('form.sellingPrice#i#'),',','','all'))#">,
                    </cfloop>

                    <!---Panel 6--->
                    <cfloop index="i" from="1" to="10">
                    	packingdesp#i# =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(evaluate('form.packingName#i#'))#">,
                        packingqty#i# = <cfqueryparam cfsqltype="cf_sql_double" value="#val(evaluate('form.packingQuantity#i#'))#">,
                        packingfreeqty#i# = <cfqueryparam cfsqltype="cf_sql_double" value="#val(evaluate('form.freeQty#i#'))#">,
                    </cfloop>

                    <!---Panel 7--->
                    fcurrcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(evaluate('form.foreignCurrency1'))#">,
                    fucost = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(form.foreignUnitCost1,',','','all'))#">,
                    fprice = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(form.foreignSellingPrice1,',','','all'))#">,
                    fprice_min = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(form.foreignMinSellingPrice1,',','','all'))#">,
                    <cfloop index="i" from="2" to="10">
                        fcurrcode#i# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(evaluate('form.foreignCurrency#i#'))#">,
                        fucost#i# = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(evaluate('form.foreignUnitCost#i#'),',','','all'))#">,
                        fprice#i# = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(evaluate('form.foreignSellingPrice#i#'),',','','all'))#">,
                        fprice#i#_min = <cfqueryparam cfsqltype="cf_sql_double" value="#val(replace(evaluate('form.foreignMinSellingPrice#i#'),',','','all'))#">,
                    </cfloop>

                    <!---Panel 8--->
                    <cfloop index="i" from="1" to="30">
                        remark#i# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(evaluate('form.remark#i#'))#">,
                    </cfloop>
                    <!---FnB Panel (not yet exposed on this form — keep Menu Maintenance's existing values when absent) --->
                    sort_ord = <cfif IsDefined('form.fnb_sort_ord')><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.fnb_sort_ord)#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#val(qExistingFnb.sort_ord)#"></cfif>,
                    promo_price = <cfif IsDefined('form.fnb_sort_ord')><cfif len(trim(form.fnb_promo_price)) AND val(replace(form.fnb_promo_price,',','','all')) GT 0><cfqueryparam cfsqltype="cf_sql_decimal" value="#val(replace(form.fnb_promo_price,',','','all'))#"><cfelse>NULL</cfif><cfelseif val(qExistingFnb.promo_price) GT 0><cfqueryparam cfsqltype="cf_sql_decimal" value="#val(qExistingFnb.promo_price)#"><cfelse>NULL</cfif>,
                    is_avail = <cfif IsDefined('form.fnb_sort_ord')><cfif IsDefined('form.fnb_is_avail')>'T'<cfelse>'F'</cfif><cfelse><cfqueryparam cfsqltype="cf_sql_char" value="#qExistingFnb.is_avail#"></cfif>,
                    is_feat = <cfif IsDefined('form.fnb_sort_ord')><cfif IsDefined('form.fnb_is_feat')>'T'<cfelse>'F'</cfif><cfelse><cfqueryparam cfsqltype="cf_sql_char" value="#qExistingFnb.is_feat#"></cfif>,
                    for_dine = <cfif IsDefined('form.fnb_sort_ord')><cfif IsDefined('form.fnb_for_dine')>'T'<cfelse>'F'</cfif><cfelse><cfqueryparam cfsqltype="cf_sql_char" value="#qExistingFnb.for_dine#"></cfif>,
                    for_take = <cfif IsDefined('form.fnb_sort_ord')><cfif IsDefined('form.fnb_for_take')>'T'<cfelse>'F'</cfif><cfelse><cfqueryparam cfsqltype="cf_sql_char" value="#qExistingFnb.for_take#"></cfif>,
                    for_deliv = <cfif IsDefined('form.fnb_sort_ord')><cfif IsDefined('form.fnb_for_deliv')>'T'<cfelse>'F'</cfif><cfelse><cfqueryparam cfsqltype="cf_sql_char" value="#qExistingFnb.for_deliv#"></cfif>,
                    is_veg = <cfif IsDefined('form.fnb_sort_ord')><cfif IsDefined('form.fnb_is_veg')>'T'<cfelse>'F'</cfif><cfelse><cfqueryparam cfsqltype="cf_sql_char" value="#qExistingFnb.is_veg#"></cfif>,
                    is_halal = <cfif IsDefined('form.fnb_sort_ord')><cfif IsDefined('form.fnb_is_halal')>'T'<cfelse>'F'</cfif><cfelse><cfqueryparam cfsqltype="cf_sql_char" value="#qExistingFnb.is_halal#"></cfif>,
                    is_spicy = <cfif IsDefined('form.fnb_sort_ord')><cfif IsDefined('form.fnb_is_spicy')>'T'<cfelse>'F'</cfif><cfelse><cfqueryparam cfsqltype="cf_sql_char" value="#qExistingFnb.is_spicy#"></cfif>,
                    spice_lvl = <cfif IsDefined('form.fnb_spice_lvl')><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.fnb_spice_lvl)#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#val(qExistingFnb.spice_lvl)#"></cfif>,
                    allergens = <cfif IsDefined('form.fnb_allergens')><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fnb_allergens)#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#qExistingFnb.allergens#"></cfif>,
                    calories = <cfif IsDefined('form.fnb_calories')><cfif len(trim(form.fnb_calories))><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.fnb_calories)#"><cfelse>NULL</cfif><cfelseif len(trim(qExistingFnb.calories))><cfqueryparam cfsqltype="cf_sql_integer" value="#val(qExistingFnb.calories)#"><cfelse>NULL</cfif>,
                    prep_time = <cfif IsDefined('form.fnb_prep_time')><cfif len(trim(form.fnb_prep_time))><cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.fnb_prep_time)#"><cfelse>NULL</cfif><cfelseif len(trim(qExistingFnb.prep_time))><cfqueryparam cfsqltype="cf_sql_integer" value="#val(qExistingFnb.prep_time)#"><cfelse>NULL</cfif>
				WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.itemno)#">;
			</cfquery>
            <cfif IsDefined('form.grade') AND form.grade EQ "Y">
            	<cfquery name="insert_ITEMGRD" datasource="#dts#">
                    INSERT INTO itemgrd (itemno)
                    VALUES (
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.itemNo)#">
                            )
                </cfquery>
            </cfif>

            <cfquery name="update_ICTRAN" datasource="#dts#">
            	UPDATE ictran
                SET
                	linecode = <cfif form.itemType EQ "SV">"SV"<cfelse>""</cfif>
                WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.itemno)#">
            </cfquery>
            <!--- <cfif getGsetup.capall EQ 'Y'>
                <cfquery name="update_UPPERCASE" datasource="#dts#">
                    UPDATE icitem
                    SET
                    	itemno = UCASE(itemno),
                        desp = UCASE(desp),
                        despa = UCASE(despa),
                        comment = UCASE(comment),
                        aitemno = UCASE(aitemno),
                        barcode = UCASE(barcode)
                	where itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.itemno)#">
                </cfquery>
            </cfif> --->
		<cfcatch type="any">
			<script type="text/javascript">
				alert('Failed to update #trim(form.itemno)#!\nError Message: #cfcatch.message#');
				window.open('/latest/maintenance/product.cfm?action=update&menuID=#URLmenuID#&itemno=#form.itemno#','_self');
			</script>
		</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Updated #trim(form.itemno)# successfully!');
			window.open('/latest/maintenance/productProfile.cfm?menuID=#URLmenuID#','_self');
		</script>
	<cfelseif url.action EQ "delete">
    	<cftry>
        	<cfquery name="checkTransactionExist" datasource="#dts#">
				SELECT itemno,refno,type
                FROM ictran
                WHERE itemno = '#URLitemNo#'
                LIMIT 1;
			</cfquery>
           	<cfquery name="checkTransactionExist2" datasource="#dts#">
				SELECT ifnull(sum(locqfield),0) AS qty
                FROM locqdbf
                WHERE itemno = '#URLitemNo#';
			</cfquery>
            <cfif checkTransactionExist.recordcount GT 0 OR val(checkTransactionExist2.qty) GT 0>
                <script type="text/javascript">
					window.open('/latest/maintenance/productProfile.cfm?menuID=#URLmenuID#&itemno=#URLitemNo#&message=usedInTransaction','_self');
				</script>
                <cfabort>
			</cfif>
        	<cfcatch type="any">
            	<script type="text/javascript">
					alert('Failed to delete #URLcustno#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/productProfile.cfm?menuID=#URLmenuID#','_self');
				</script>
            </cfcatch>
        </cftry>
		<cftry>
        	<cfquery name="auditTrail_Deleted" datasource="#dts#">
            INSERT INTO deleted_icitem (`EDI_ID`,`ITEMNO`,`AITEMNO`,`MITEMNO`,`SHORTCODE`,`DESP`,`DESPA`,`BRAND`,`CATEGORY`,`WOS_GROUP`,
            							`SHELF`,`SUPP`,`PACKING`,`WEIGHT`,`COSTCODE`,`UNIT`,`UCOST`,`PRICE`,`PRICE2`,`PRICE3`,
                                        `PRICE_MIN`,`MINIMUM`,`MAXIMUM`,`REORDER`,`UNIT2`,`COLORID`,`SIZEID`,`FACTOR1`,`FACTOR2`,`PRICEU2`,
                                        `UNIT3`,`FACTORU3_A`,`FACTORU3_B`,`PRICEU3`,`UNIT4`,`FACTORU4_A`,`FACTORU4_B`,`PRICEU4`,`UNIT5`,`FACTORU5_A`,
                                        `FACTORU5_B`,`PRICEU5`,`UNIT6`,`FACTORU6_A`,`FACTORU6_B`,`PRICEU6`,`DISPEC_A1`,`DISPEC_A2`,`DISPEC_A3`,`DISPEC_B1`,
                                        `DISPEC_B2`,`DISPEC_B3`,`DISPEC_C1`,`DISPEC_C2`,`DISPEC_C3`,`PRICE_CATA`,`PRICE_CATB`,`PRICE_CATC`,`COST_CATA`,`COST_CATB`,`COST_CATC`,
                                        `QTY2`,`QTY3`,`QTY4`,`QTY5`,`QTY6`,`WQFORMULA`,`WPFORMULA`,`GRADED`,`MURATIO`,`QTYBF`,`QTYNET`,`QTYACTUAL`,`AVCOST`,`AVCOST2`,`BOM_COST`,
                                        `TQ_OBAL`,`TQ_IN`,`TQ_OUT`,`TQ_CBAL`,`T_UCOST`,`T_STKV`,`TQ_INV`,`TQ_CS`,`TQ_CN`,`TQ_DN`,
                                        `TQ_RC`,`TQ_PR`,`TQ_ISS`,`TQ_OAI`,`TQ_OAR`,`TA_INV`,`TA_CS`,`TA_CN`,`TA_DN`,`TA_RC`,
                                        `TA_PR`,`TA_ISS`,`TA_OAI`,`TA_OAR`,`QIN11`,`QIN12`,`QIN13`,`QIN14`,`QIN15`,`QIN16`,
                                        `QIN17`,`QIN18`,`QIN19`,`QIN20`,`QIN21`,`QIN22`,`QIN23`,`QIN24`,`QIN25`,`QIN26`,
                                        `QIN27`,`QIN28`,`QOUT11`,`QOUT12`,`QOUT13`,`QOUT14`,`QOUT15`,`QOUT16`,`QOUT17`,`QOUT18`,
                                        `QOUT19`,`QOUT20`,`QOUT21`,`QOUT22`,`QOUT23`,`QOUT24`,`QOUT25`,`QOUT26`,`QOUT27`,`QOUT28`,
                                        `SALEC`,`SALECSC`,`SALECNC`,`PURC`,`PURPREC`,`TEMPFIG`,`TEMPFIG1`,`CT_RATING`,`POINT`,`QCPOINT`,`AWARD1`,
                                        `AWARD2`,`AWARD3`,`AWARD4`,`AWARD5`,`AWARD6`,`AWARD7`,`AWARD8`,`REMARK1`,`REMARK2`,`REMARK3`,
                                        `REMARK4`,`REMARK5`,`REMARK6`,`REMARK7`,`REMARK8`,`REMARK9`,`REMARK10`,`REMARK11`,`REMARK12`,`REMARK13`,
                                        `REMARK14`,`REMARK15`,`REMARK16`,`REMARK17`,`REMARK18`,`REMARK19`,`REMARK20`,`REMARK21`,`REMARK22`,`REMARK23`,
                                        `REMARK24`,`REMARK25`,`REMARK26`,`REMARK27`,`REMARK28`,`REMARK29`,`REMARK30`,`COMMRATE1`,`COMMRATE2`,`COMMRATE3`,
                                        `COMMRATE4`,`WOS_DATE`,`QTYDEC`,`TEMP_QTY`,`QTY`,`PHOTO`,`COMPEC_A`,`COMPEC_B`,`COMPEC_C`,`WOS_TIME`,
                                        `EXPIRED`,`WSERIALNO`,`PROMOTOR`,`TAXABLE`,`TAXPERC1`,`TAXPERC2`,`NONSTKITEM`,`GRAPHIC`,`PRODCODE`,`BRK_TO`,
                                        `COLOR`,`SIZE`,`qtybf_actual`, 	`CREATED_BY`,`CREATED_ON`,`UPDATED_BY`,`UPDATED_ON`,`DELETED_BY`,`DELETED_ON`)

            SELECT  a.EDI_ID,a.ITEMNO,a.AITEMNO,a.MITEMNO,a.SHORTCODE,a.DESP,a.DESPA,a.BRAND,a.CATEGORY,a.WOS_GROUP,
                    a.SHELF,a.SUPP,a.PACKING,a.WEIGHT,a.COSTCODE,a.UNIT,a.UCOST,a.PRICE,a.PRICE2,a.PRICE3,
                    a.PRICE_MIN,a.MINIMUM,a.MAXIMUM,a.REORDER,a.UNIT2,a.COLORID,a.SIZEID,a.FACTOR1,a.FACTOR2,a.PRICEU2,
                    a.UNIT3,a.FACTORU3_A,a.FACTORU3_B,a.PRICEU3,a.UNIT4,a.FACTORU4_A,a.FACTORU4_B,a.PRICEU4,a.UNIT5,a.FACTORU5_A,
                    a.FACTORU5_B,a.PRICEU5,a.UNIT6,a.FACTORU6_A,a.FACTORU6_B,a.PRICEU6,a.DISPEC_A1,a.DISPEC_A2,a.DISPEC_A3,a.DISPEC_B1,
                    a.DISPEC_B2,a.DISPEC_B3,a.DISPEC_C1,a.DISPEC_C2,a.DISPEC_C3,a.PRICE_CATA,a.PRICE_CATB,a.PRICE_CATC,a.COST_CATA,a.COST_CATB,a.COST_CATC,
                    a.QTY2,a.QTY3,a.QTY4,a.QTY5,a.QTY6,a.WQFORMULA,a.WPFORMULA,a.GRADED,a.MURATIO,a.QTYBF,a.QTYNET,a.QTYACTUAL,a.AVCOST,a.AVCOST2,a.BOM_COST,
                    a.TQ_OBAL,a.TQ_IN,a.TQ_OUT,a.TQ_CBAL,a.T_UCOST,a.T_STKV,a.TQ_INV,a.TQ_CS,a.TQ_CN,a.TQ_DN,
                    a.TQ_RC,a.TQ_PR,a.TQ_ISS,a.TQ_OAI,a.TQ_OAR,a.TA_INV,a.TA_CS,a.TA_CN,a.TA_DN,a.TA_RC,
                    a.TA_PR,a.TA_ISS,a.TA_OAI,a.TA_OAR,a.QIN11,a.QIN12,a.QIN13,a.QIN14,a.QIN15,a.QIN16,
                    a.QIN17,a.QIN18,a.QIN19,a.QIN20,a.QIN21,a.QIN22,a.QIN23,a.QIN24,a.QIN25,a.QIN26,
                    a.QIN27,a.QIN28,a.QOUT11,a.QOUT12,a.QOUT13,a.QOUT14,a.QOUT15,a.QOUT16,a.QOUT17,a.QOUT18,
                    a.QOUT19,a.QOUT20,a.QOUT21,a.QOUT22,a.QOUT23,a.QOUT24,a.QOUT25,a.QOUT26,a.QOUT27,a.QOUT28,
                    a.SALEC,a.SALECSC,a.SALECNC,a.PURC,a.PURPREC,a.TEMPFIG,a.TEMPFIG1,a.CT_RATING,a.POINT,a.QCPOINT,a.AWARD1,
                    a.AWARD2,a.AWARD3,a.AWARD4,a.AWARD5,a.AWARD6,a.AWARD7,a.AWARD8,a.REMARK1,a.REMARK2,a.REMARK3,
                    a.REMARK4,a.REMARK5,a.REMARK6,a.REMARK7,a.REMARK8,a.REMARK9,a.REMARK10,a.REMARK11,a.REMARK12,a.REMARK13,
                    a.REMARK14,a.REMARK15,a.REMARK16,a.REMARK17,a.REMARK18,a.REMARK19,a.REMARK20,a.REMARK21,a.REMARK22,a.REMARK23,
                    a.REMARK24,a.REMARK25,a.REMARK26,a.REMARK27,a.REMARK28,a.REMARK29,a.REMARK30,a.COMMRATE1,a.COMMRATE2,a.COMMRATE3,
                    a.COMMRATE4,a.WOS_DATE,a.QTYDEC,a.TEMP_QTY,a.QTY,a.PHOTO,a.COMPEC_A,a.COMPEC_B,a.COMPEC_C,a.WOS_TIME,
                    a.EXPIRED,a.WSERIALNO,a.PROMOTOR,a.TAXABLE,a.TAXPERC1,a.TAXPERC2,a.NONSTKITEM,a.GRAPHIC,a.PRODCODE,a.BRK_TO,
                    a.COLOR,a.SIZE,a.qtybf_actual, a.CREATED_BY,a.CREATED_ON,a.UPDATED_BY,a.UPDATED_ON,<cfqueryparam cfsqltype="cf_sql_varchar" value="#huserid#">,NOW()
            FROM icitem AS a
            WHERE a.itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemNo#">
            </cfquery>

            <cfquery name="deleteItemGrade" datasource='#dts#'>
				DELETE FROM itemgrd
                WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemNo#">
			</cfquery>
			<cfquery name="delete_LOGRDOB" datasource='#dts#'>
				DELETE FROM logrdob
                WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemNo#">
			</cfquery>
			<cfquery name="deleterelateditem1" datasource='#dts#'>
				DELETE FROM relitem
                WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemNo#">
			</cfquery>
			<cfquery name="deleterelateditem1" datasource='#dts#'>
				DELETE FROM relitem
                WHERE relitemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemNo#">
			</cfquery>
            <cfquery name="deletePrice" datasource="#dts#">
            	DELETE FROM icl3p
                WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemNo#">
            </cfquery>
            <cfquery name="deletePrice2" datasource="#dts#">
            	DELETE FROM icl3p2
                WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemNo#">
            </cfquery>
			<cfquery name="deleteCategory" datasource="#dts#">
				DELETE FROM icitem
				WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLitemno#">
			</cfquery>
			<cfcatch type="any">
				<script type="text/javascript">
					alert('Failed to delete #URLitemno#!\nError Message: #cfcatch.message#');
					window.open('/latest/maintenance/productProfile.cfm?menuID=#URLmenuID#','_self');
				</script>
			</cfcatch>
		</cftry>
		<script type="text/javascript">
			alert('Deleted #URLitemno# successfully!');
			window.open('/latest/maintenance/productProfile.cfm?menuID=#URLmenuID#','_self');
		</script>
	<cfelseif url.action EQ "print">

		<cfquery name="getGsetup" datasource="#dts#">
			SELECT compro
            FROM gsetup;
		</cfquery>

		<cfquery name="printProduct" datasource="#dts#">
			SELECT itemno,aitemno,desp,despa,price
			FROM icitem
			ORDER BY itemno;
		</cfquery>
        <cfoutput>
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <title>#url.pageTitle# Listing</title>
            <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
            <!--[if lt IE 9]>
                <script type="text/javascript" src="/latest/js/html5shiv/html5shiv.js"></script>
                <script type="text/javascript" src="/latest/js/respond/respond.min.js"></script>
            <![endif]-->
            <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
		</head>
		<body>
            <div class="container">
                <div class="page-header">
                    <h1 class="text">#url.pageTitle# Listing</h1>
                    <p class="lead">Company: #getGsetup.compro#</p>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ITEM NO</th>
                                <th>PRODUCT CODE</th>
                                <th>DESCRIPTION</th>
                                <th>PRICE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop query="printProduct">
                                <tr>
                                    <td>#itemno#</td>
                                    <td>#aitemno#</td>
                                    <td>#desp#-#despa#</td>
                                    <td>#price#</td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                </div>
                <div class="panel-footer">
                    <p>Printed at #DateFormat(Now(),'DD-MM-YYYY')#, #TimeFormat(Now(),'HH:MM:SS')#</p>
                </div>
            </div>
		</body>
		</html>
        </cfoutput>
	<cfelse>
		<script type="text/javascript">
			window.open('/latest/maintenance/productProfile.cfm','_self');
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript">
		window.open('/latest/maintenance/productProfile.cfm','_self');
	</script>
</cfif>
</cfoutput>