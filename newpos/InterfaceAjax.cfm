<cfsetting showdebugoutput="no">
<cfinclude template = "/CFC/convert_single_double_quote_script.cfm">
<cfif IsDefined("form.action")>
	<cfif HlinkAMS EQ 'Y'>
    	<cfset dts2 = replace(LCASE(dts),'_i','_a','ALL')> 
    <cfelse>
    	<cfset dts2 = dts>
    </cfif>
    
	<cfset action=form.action>
    
	<cfif action EQ "">
	
	<!--- getTargetDetail [START] --->
	<cfelseif action EQ "getTargetDetail">
		<cfset targetTable=form.targetTable>
		<cfset custno=form.custno>
        <cfquery name="getgsetup" datasource="#dts#">
			SELECT ctycode
			FROM gsetup;
		</cfquery>
		<cfquery name="getTargetDetail" datasource="#dts2#">
			SELECT  name,name2,add1,add2,add3,add4,country,postalCode,attn,phone,phonea,fax,e_mail,
            		daddr1,daddr2,daddr3,daddr4,d_country,d_postalCode,dattn,dphone,contact,dfax,d_email,
                    currcode,term,agent,end_user
			FROM #targetTable#
			WHERE custno="#custno#";
		</cfquery>
		<cfset target={
			NAME="#getTargetDetail.name#",
			NAME2="#getTargetDetail.name2#",
			ADD1="#getTargetDetail.add1#",
			ADD2="#getTargetDetail.add2#",
			ADD3="#getTargetDetail.add3#",
			ADD4="#getTargetDetail.add4#",
			COUNTRY="#getTargetDetail.country#",
			POSTALCODE="#getTargetDetail.postalCode#",
			ATTN="#getTargetDetail.attn#",
			PHONE="#getTargetDetail.phone#",
			HP="#getTargetDetail.phonea#",
			FAX="#getTargetDetail.fax#",
			EMAIL="#getTargetDetail.e_mail#",
			DADDR1="#getTargetDetail.daddr1#",
			DADDR2="#getTargetDetail.daddr2#",
			DADDR3="#getTargetDetail.daddr3#",
			DADDR4="#getTargetDetail.daddr4#",
			DCOUNTRY="#getTargetDetail.d_country#",
			DPOSTALCODE="#getTargetDetail.d_postalCode#",
			DATTN="#getTargetDetail.dattn#",
			DPHONE="#getTargetDetail.dphone#",
			DHP="#getTargetDetail.contact#",
			DFAX="#getTargetDetail.dfax#",
			DEMAIL="#getTargetDetail.d_email#",
			TERM="#getTargetDetail.term#",
			CURRCODE="#getTargetDetail.currcode#",
			AGENT="#getTargetDetail.agent#",
			ENDUSER="#getTargetDetail.end_user#"
		}>
		<cfset target=SerializeJSON(target)>
		<cfset target=cleanXmlString(target)>
		<cfoutput>#target#</cfoutput>
	<!--- getTargetDetail [END] --->
    
    <!--- getCurrencyRate [START] --->
	<cfelseif action EQ "getCurrencyRate">
		<cfset currcode=form.currcode>
        <cfset wos_date = CreateDate(right(URLDecode(form.wos_date),4),mid(URLDecode(form.wos_date),4,2),left(URLDecode(form.wos_date),2))>
        <cfinvoke 
        		component="cfc.Period" 
                method="getCurrentPeriod" 
                dts="#dts#" 
                inputDate="#DateFormat(wos_date,'yyyy-mm-dd')#" 
                returnvariable="fperiod"/>    
        <cfset fperiodTemp = NumberFormat(fperiod,'0')>
		<cfset currentPeriod = fperiod>
		
        <cfif fperiodTemp EQ '99'>
        	<cfset fperiodTemp = '1'>
            <cfset currentPeriod = '99'>
        </cfif>
        
        <cfquery name="getCurrency" datasource="#dts2#">
            SELECT currcode<cfloop index="i" from="1" to="18">,currp#i#</cfloop>
            FROM #target_currency# 
            WHERE currcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">;
        </cfquery>
        <cfquery name="getDayCurrency" datasource="#dts2#">
            SELECT * 
            FROM #target_currencymonth# 
            WHERE currcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">
            AND fperiod='#NumberFormat(fperiod,'00')#';
        </cfquery>
        
        <cfif getDayCurrency.recordCount NEQ 0>
            <cfset currencyRate = val(evaluate('getDayCurrency.CurrD#Day(wos_date)#'))>
        <cfelse>
            <cfset currencyRate = val(evaluate('getCurrency.CurrP#fperiodTemp#'))>
        </cfif>
        
        <cfif currencyRate EQ 0>
            <cfset currencyRate = 1>	
        </cfif>

		<cfset currencyInfo={
			CURRENCYRATE="#currencyRate#",
			CURRENTPERIOD="#currentPeriod#"
		}>
		<cfset currencyInfo=SerializeJSON(currencyInfo)>
		<cfset currencyInfo=cleanXmlString(currencyInfo)>
		<cfoutput>#currencyInfo#</cfoutput>
	<!--- getCurrencyRate [END] --->

    <!--- getINVdate [START] --->
	<cfelseif action EQ "getINVdate">
		<cfset invoice_number=trim(URLDecode(form.invoice_number))>
		<cfquery name="getINVdate" datasource="#dts#">
			SELECT refno,wos_date
			FROM artran 
			WHERE refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_number#">
			AND type='INV';
		</cfquery>

		<cfset INVinfo={
			REFNO="#getINVdate.refno#",
			DATE="#DateFormat(getINVdate.wos_date,'dd/mm/yyyy')#"
		}>
		<cfset INVinfo=SerializeJSON(INVinfo)>
		<cfset INVinfo=cleanXmlString(INVinfo)>
		<cfoutput>#INVinfo#</cfoutput>
	<!--- getINVdate [END] --->
	        
	<!--- getItemInfo [START] --->
	<cfelseif action EQ "getItemInfo">
		<cfset itemPriceType=form.itemPriceType>
		<cfset itemno_input=trim(URLDecode(form.itemno_input))>

		<cfquery name="getItemInfo" datasource="#dts#">
			SELECT itemno,desp,despa,comment,#itemPriceType# AS itemprice,unit,'' AS lineCode
			FROM icitem 
			WHERE (nonstkitem != 'T' OR nonstkitem IS NULL)
			AND itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno_input#">;
		</cfquery>
        
        <cfif getItemInfo.recordcount EQ 0>
        	<cfif itemPriceType EQ 'price'>
            	<cfset tempItemPriceType = 'serprice'>
            <cfelse>
            	<cfset tempItemPriceType = 'sercost'>
            </cfif> 
            <cfquery name="getItemInfo" datasource="#dts#">
                SELECT servi AS itemno,desp,despa,'' AS comment,#tempItemPriceType# AS itemprice,'' AS unit,'SV' AS lineCode
                FROM icservi
                WHERE servi=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno_input#">;
            </cfquery>
        </cfif>
        
		<cfset item={
			ITEMNO="#getItemInfo.itemno#",
			DESP="#getItemInfo.desp#",
			DESPA="#getItemInfo.despa#",
			COMMENT="#getItemInfo.comment#",
			ITEMPRICE="#getItemInfo.itemprice#",
			UNIT="#getItemInfo.unit#",
			LINECODE="#getItemInfo.lineCode#"
		}>
		<cfset item=SerializeJSON(item)>
		<cfset item=cleanXmlString(item)>
		<cfoutput>#item#</cfoutput>
	<!--- getItemInfo [END] --->
    
    <!--- getSecondUnitOfMeasurement [START] --->
	<cfelseif action EQ "getSecondUnitOfMeasurement">
    	<cfset uuid = trim(form.uuid)>
		<cfset trancode = trim(form.trancode)>
		<cfset itemno_input=trim(URLDecode(form.itemno_input))>
        <cfset qty_input=trim(form.qty_input)>
        <cfset unitOfMeasurment_input=trim(form.unitOfMeasurement_input)>

		<cfquery name="getSecondUnitOfMeasurement" datasource="#dts#">
			SELECT  unit,price, 
            		unit2,factor1,factor2,priceU2,
                    unit3,factorU3_a,factorU3_b,priceU3,
                    unit4,factorU4_a,factorU4_b,priceU4,
                    unit5,factorU5_a,factorU5_b,priceU5,
                    unit6,factorU6_a,factorU6_b,priceU6    
            FROM icitem 
            WHERE itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno_input#">;	
		</cfquery>
        
        <cfset qtyReal = 1>
		<cfset factor1 = 1>
        <cfset factor2 = 1>
        <cfset price = val(getSecondUnitOfMeasurement.price)>
        <cfset unit = getSecondUnitOfMeasurement.unit>  
                
        <cfloop index="i" from="2" to="6">
        	<cfif unitOfMeasurment_input EQ "#evaluate('getSecondUnitOfMeasurement.unit#i#')#">
            	<cfif i EQ 2>
					<cfset qtyReal = (val(qty_input) * val(getSecondUnitOfMeasurement.factor1)) / val(getSecondUnitOfMeasurement.factor2)>
                    <cfset factor1 = val(getSecondUnitOfMeasurement.factor1)>
                	<cfset factor2 = val(getSecondUnitOfMeasurement.factor2)>
                <cfelse>
                	<cfset qtyReal = (val(qty_input) * val(evaluate('getSecondUnitOfMeasurement.factorU#i#_a'))) / val(evaluate('getSecondUnitOfMeasurement.factorU#i#_b'))>
                    <cfset factor1 = val(evaluate('getSecondUnitOfMeasurement.factorU#i#_a'))>
                	<cfset factor2 = val(evaluate('getSecondUnitOfMeasurement.factorU#i#_b'))>
                </cfif>
                <cfset price = val(evaluate('getSecondUnitOfMeasurement.priceU#i#'))>
            </cfif>	
        </cfloop>       
        
        <cfquery name="updateSecondUnitOfMeasurement" datasource="#dts#">
			UPDATE ictrantemp
            SET 
            	qty = <cfqueryparam cfsqltype="cf_sql_double" value="#val(qtyReal)#">,
                qty_bil = <cfqueryparam cfsqltype="cf_sql_double" value="#val(qty_input)#">,
                unit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unit#">,
                unit_bil = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unitOfMeasurment_input#">,
                price_bil = <cfqueryparam cfsqltype="cf_sql_double" value="#val(price)#">,
                factor1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#factor1#">,
                factor2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#factor2#">
            WHERE itemno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno_input#">
			AND trancode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">
            AND uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">;  
		</cfquery>
        
		<cfset secondUnitOfMeasurement={
			ITEMNO="#itemno_input#",
			DEFAULTUNIT="#getSecondUnitOfMeasurement.unit#",
			PRICE="#price#",
			FACTOR_1="#factor1#",
			FACTOR_2="#factor2#"
		}>
        
		<cfset secondUnitOfMeasurement=SerializeJSON(secondUnitOfMeasurement)>
		<cfset secondUnitOfMeasurement=cleanXmlString(secondUnitOfMeasurement)>
		<cfoutput>#secondUnitOfMeasurement#</cfoutput>
	<!--- getSecondUnitOfMeasurement [END] --->
    
    <!--- getLast5Price [START] --->
    <cfelseif action EQ "getLast5Prices">
		<cfset itemno=form.itemno>
		<cfquery name="getLast5Prices" datasource="#dts#">
            SELECT itemno,refno,wos_date,price_bil 
            FROM ictran 
            WHERE itemno="#itemno#" 
            ORDER BY wos_date DESC 
            LIMIT 5;
        </cfquery>
		<cfoutput>
        	<cfif getLast5Prices.recordCount NEQ 0> 
                <div id="popover_content_wrapper"> 
                    <cfloop query="getLast5Prices">
                        <div class="group">
                            <div class="rowLeft">
                                <div class="leftTop">#UCASE(getLast5Prices.refno)#</div>
                                <div class="leftBottom">#DateFormat(getLast5Prices.wos_date,"DD/MM/YYYY")#</div>
                            </div>
                            <div class="rowRight">
                                <div class="rightTop">Price</div>
                                <div class="rightBottom">#getLast5Prices.price_bil#</div>
                            </div>
                        </div> 
                    </cfloop>
                </div>
            <cfelse>
                <div id="popover_content_wrapper">
                	No Previous History                    
                </div>    
            </cfif>
		</cfoutput>
	<!--- getItemInfo [END] --->
        
    <!--- updateItem [START] --->
	<cfelseif action EQ "updateItem">
    	<cfset type = trim(form.type)>
    	<cfset uuid = trim(form.uuid)>
		<cfset trancode = trim(form.trancode)>
        <cfset linecode = trim(form.linecode)>
		<cfset itemno_input = trim(URLDecode(form.itemno_input))>
		<cfset desp_input = trim(URLDecode(form.desp_input))>
        <cfset despa_input = trim(URLDecode(form.despa_input))>
        <cfset comment_input = trim(URLDecode(form.comment_input))>
        <cfset location_input = trim(URLDecode(form.location_input))>
		<cfset qty_input = trim(form.qty_input)>
        <cfset unitOfMeasurement_input = trim(URLDecode(form.unitOfMeasurement_input))>
        <cfset factor1_input = trim(form.factor1_input)>
        <cfset factor2_input = trim(form.factor2_input)>
		<cfset price_input = trim(form.price_input)>
		<cfset dispec1_input = trim(form.dispec1_input)>
        <cfset itemTaxCode_input = trim(form.itemTaxCode_input)>
        <cfset taxpec1_input = trim(form.taxpec1_input)>
        <cfset taxAmtBil_input = trim(form.taxAmtBil_input)>
        <cfset amt1_bil = val(form.price_input)*val(form.qty_input)> 		
        <cfset disamt_bil = (val(form.dispec1_input)/100)*val(amt1_bil)>
        <cfset amt_input = val(amt1_bil) - val(disamt_bil)>
        
		<cfquery name="getLastTrancode" datasource="#dts#">
			SELECT MAX(trancode) AS LastTrancode
			FROM ictrantemp
			WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">;
		</cfquery>
		<cfif trancode GT getLastTrancode.LastTrancode>
			<cfquery name="insertItem" datasource="#dts#">
				INSERT INTO ictrantemp (
                                         type,uuid,trancode,itemcount,linecode,itemno,desp,despa,comment,location,
                                         qty,qty_bil,unit,unit_bil,factor1,factor2,price_bil,                                   
                                         dispec1,disamt_bil,
                                         note_a,taxpec1,taxAmt_bil,
                                         amt_bil,amt1_bil,userID)
				VALUES
				(
                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#linecode#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno_input#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#desp_input#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#despa_input#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#comment_input#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#location_input#">,
					<cfqueryparam cfsqltype="cf_sql_double" value="#val(qty_input)#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#val(qty_input)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#unitOfMeasurement_input#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#unitOfMeasurement_input#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#factor1_input#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#factor2_input#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#val(price_input)#">, 
					<cfqueryparam cfsqltype="cf_sql_double" value="#val(dispec1_input)#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#val(disamt_bil)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#itemTaxCode_input#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#taxpec1_input#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#val(taxAmtBil_input)#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#val(amt_input)#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#val(amt1_bil)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#HuserID#">
				)
			</cfquery>
		<cfelse>
			<cfquery name="updateItem" datasource="#dts#">
				UPDATE ictrantemp
				SET
                
					desp=<cfqueryparam cfsqltype="cf_sql_varchar" value="#desp_input#">,
                    despa=<cfqueryparam cfsqltype="cf_sql_varchar" value="#despa_input#">,
                    comment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#comment_input#">,
                    location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#location_input#">,
					qty=<cfqueryparam cfsqltype="cf_sql_double" value="#val(qty_input)#">,
                    qty_bil=<cfqueryparam cfsqltype="cf_sql_double" value="#val(qty_input)#">,
                    unit=<cfqueryparam cfsqltype="cf_sql_varchar" value="#unitOfMeasurement_input#">,
                    unit_bil=<cfqueryparam cfsqltype="cf_sql_varchar" value="#unitOfMeasurement_input#">,
                    factor1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#factor1_input#">,
                    factor2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#factor2_input#">,
                    price_bil=<cfqueryparam cfsqltype="cf_sql_double" value="#val(price_input)#">,
					dispec1=<cfqueryparam cfsqltype="cf_sql_double" value="#val(dispec1_input)#">,
                    disamt_bil=<cfqueryparam cfsqltype="cf_sql_double" value="#disamt_bil#">,
                    note_a=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemTaxCode_input#">,
                    taxpec1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxpec1_input#">,
                    taxAmt_bil=<cfqueryparam cfsqltype="cf_sql_double" value="#val(taxAmtBil_input)#">,
                    amt_bil=<cfqueryparam cfsqltype="cf_sql_double" value="#val(amt_input)#">,
                    amt1_bil=<cfqueryparam cfsqltype="cf_sql_double" value="#val(amt1_bil)#">	
                    
				WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
				AND trancode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">;
			</cfquery>
		</cfif>
	<!--- updateItem [END] --->
    
	<!--- getTotalTrancode [START] --->
	<cfelseif action EQ "getTotalTrancode">
    	<cfset uuid=form.uuid>
        
		<cfquery name="getTotalTrancode" datasource="#dts#">
			SELECT COUNT(trancode) AS total
			FROM ictrantemp 
            WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">;
		</cfquery>
        
		<cfset totalTrancode={
			TRANCODEID="#getTotalTrancode.total#",
			TRANCODE="#getTotalTrancode.total#"
		}>
		<cfset totalTrancode=SerializeJSON(totalTrancode)>
		<cfoutput>#totalTrancode#</cfoutput>
	<!--- getTotalTrancode [END] --->
    
    <!--- updateTrancode [START] --->
	<cfelseif action EQ "updateTrancode">
    	<cfset tempList = ''>   
		<cfset uuid=form.uuid>
        <cfset currentTrancode=form.currentTrancode>
		<cfset newTrancode=form.newTrancode>
        
		<cfquery name="getTrancodeList" datasource="#dts#">
            SELECT trancode 
            FROM ictrantemp 
            WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">;
        </cfquery>
        
        <cfset itemCountList = ValueList(getTrancodeList.trancode,',')>
        
        <cfif newTrancode LT currentTrancode>
            <cfloop index="i" from="1" to="#ListLen(itemCountList)#"> 
                <cfif ListGetAt(itemCountList,i) NEQ newTrancode>
                    <cfif i LTE currentTrancode AND i GT newTrancode>
                        <cfset tempList = ListAppend(#tempList#,#i#-1,',')>
                    <cfelse>
                        <cfset tempList = ListAppend(#tempList#,#i#,',')>
                    </cfif>
                 <cfelse>
                    <cfset tempList = ListAppend(#tempList#,#currentTrancode#,',')>
                </cfif>
            </cfloop>
            <cfquery name="getReadjustedTrancode" datasource="#dts#">
                SELECT * FROM (
                    SELECT trancode 
                    FROM ictrantemp
                    WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
                    AND trancode < '#newTrancode#'
                    ORDER BY trancode ) AS a
                UNION ALL
                    SELECT * FROM (
                        SELECT trancode 
                        FROM ictrantemp
                        WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
                        AND trancode = '#currentTrancode#'
                        ORDER BY trancode) AS b
                UNION ALL
                    SELECT * FROM (
                        SELECT trancode
                        FROM ictrantemp
                        WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
                        AND trancode < '#currentTrancode#' 
                        AND trancode >= '#newTrancode#' 
                        ORDER BY trancode ) AS c
            </cfquery>
        <cfelseif newTrancode GT currentTrancode>
            <cfloop index="i" from="1" to="#ListLen(itemCountList)#"> 
                <cfif ListGetAt(itemCountList,i) EQ newTrancode>
                    <cfset tempList = ListAppend(#tempList#,#currentTrancode#,',')>
                 <cfelse>
                     <cfif i LTE currentTrancode AND i GTE currentTrancode>
                        <cfset tempList = ListAppend(#tempList#,#newTrancode#,',')>
                    <cfelse>
                        <cfset tempList = ListAppend(#tempList#,#i#,',')>
                    </cfif>
                </cfif>
            </cfloop> 
            <cfquery name="getReadjustedTrancode" datasource="#dts#">
                SELECT * FROM (
                    SELECT trancode 
                    FROM ictrantemp
                    WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
                    AND trancode < '#currentTrancode#' 
                    ORDER BY trancode ) AS a
                UNION ALL
                    SELECT * FROM (
                        SELECT trancode 
                        FROM ictrantemp
                        WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
                        AND trancode <= '#newTrancode#'
                        AND trancode >  '#currentTrancode#'
                        ORDER BY trancode) AS b
                UNION ALL
                    SELECT * FROM (
                        SELECT trancode
                        FROM ictrantemp
                        WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
                        AND trancode = '#currentTrancode#' 
                        ORDER BY trancode ) AS c
			</cfquery> 
        </cfif>
        <cfset counter =1>
        <cfloop query="getReadjustedTrancode">
            <cfquery name="updateItemCount" datasource="#dts#">
                UPDATE ictrantemp 
                SET 
                    itemcount = '#counter#' 
                WHERE trancode = '#getReadjustedTrancode.trancode#'
                AND uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">;
            </cfquery>
             <cfset counter = counter+1>  
        </cfloop>
        <cfquery name="updateTrancode" datasource="#dts#">
            UPDATE ictrantemp 
            SET 
                trancode = itemcount
            WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">;
        </cfquery>
        <cfquery name="getLocation" datasource="#dts#">
            SELECT location
            FROM iclocation;
        </cfquery>
        <cfquery name="getUnitOfMeasurement" datasource="#dts#">
            SELECT unit
            FROM unit;
        </cfquery>
        <cfquery name="getTax" datasource="#dts#">
            SELECT code,rate1
            FROM #target_taxtable#;
        </cfquery>
		<cfquery name="getItemList" datasource="#dts#">
        	SELECT trancode,linecode,itemno,desp,location,qty_bil,unit_bil,factor1,factor2,price_bil,dispec1,note_a,taxpec1,taxAmt_bil,amt_bil
            FROM ictrantemp
            WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
            ORDER BY trancode;
        </cfquery>
		<cfoutput>
        	<cfloop query="getItemList">
            	<cfset trancode=getItemList.trancode>
                <tr id="#trancode#" class="edit_tr last_edit_tr">
                    <td class="td_one">
                        <label for="recordCountLabel" id="recordCount_#trancode#" class="recordCount">
                            <abbr title="" class="reshuffleTitle">#trancode#</abbr>
                        </label>
                    </td>
                    <td>
                    	<input type="text" id="itemno_label_#trancode#" name="itemno_label_#trancode#" class="form-control input-sm itemno_label" value="#getItemList.itemno#" disabled="true"/>
                        <input type="hidden" id="lineCode_label_#trancode#" name="lineCode_label_#trancode#" class="form-control input-sm" value="#getItemList.linecode#"/>
                    </td>
                    <td>
                        <div class="input-group">
                            <input type="text" id="desp_input_#trancode#" name="desp_input_#trancode#" class="form-control input-sm desp_input" value="#getItemList.desp#"/>
                            <span class="input-group-addon glyphiconA glyphicon-plus editItemDescription" id="editItemDescription_#trancode#" data-toggle="modal" data-target="##myItemDescription">
                            </span>
                        </div>
                    </td>
                    <td class="td_four">
                        <select id="location_input_#trancode#" name="location_input_#trancode#" class="form-control input-sm location_input">
                            <option value="">Location</option>
                            <cfloop query="getLocation">
                                <option value="#getLocation.location#" <cfif getLocation.location EQ getItemList.location>selected</cfif>>#getLocation.location#</option>
                            </cfloop>
                        </select>
                    </td>
                    <td>
                        <div class="row no-pad">
                            <div class="col-sm-4">
                                <input type="text" id="qty_input_#trancode#" name="qty_input_#trancode#" class="form-control input-sm qty_input textAlignRight" value="#getItemList.qty_bil#" />
                            </div>
                            <div class="col-sm-8">
                                <select id="unitOfMeasurement_input_#trancode#" name="unitOfMeasurement_input_#trancode#" class="form-control input-sm unitOfMeasurement_input">
                                	<option value="">U.O.M</option>
                                    <cfloop query="getUnitOfMeasurement">
                                        <option value="#getUnitOfMeasurement.unit#" <cfif getUnitOfMeasurement.unit EQ getItemList.unit_bil>selected</cfif>>#getUnitOfMeasurement.unit#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="row no-pad">
                            <div class="col-sm-6">
                                <input type="text" id="factor1_#trancode#" name="factor1_#trancode#" class="form-control input-sm collapse factor1 textAlignRight" value="#getItemList.factor1#"/>
                            </div>
                            <div class="col-sm-6">
                                <input type="text" id="factor2_#trancode#" name="factor2_#trancode#" class="form-control input-sm collapse factor2 textAlignRight" value="#getItemList.factor2#"/>
                            </div>
                        </div>                        
                    </td>
                    <td>
                        <input type="text" id="price_input_#trancode#" name="price_input_#trancode#" class="form-control input-sm price_input textAlignRight priceHistory" value="#getItemList.price_bil#" />
                    </td>
                    <td>
                        <div class="input-group">
                            <input type="text" id="dispec1_input_#trancode#" name="dispec1_input_#trancode#" class="form-control input-sm dispec1_input textAlignRight" value="#getItemList.dispec1#" />
                            <span class="input-group-addon" id="discount">%</span>
                        </div>
                    </td>
                    <td class="itemTaxTD">
                        <select id="itemTaxCode_input_#trancode#" name="itemTaxCode_input_#trancode#" class="form-control input-sm itemTaxCode">
                            <cfloop query="getTax">
                                <option value="#getTax.code#" <cfif getTax.code EQ getItemList.note_a>selected</cfif>>#getTax.code#</option>
                            </cfloop>
                        </select>
                        <input type="hidden" id="taxpec1_input_#trancode#" name="taxpec1_input_#trancode#" class="form-control input-sm taxpec1_input textAlignRight" disabled="true" value="#getItemList.taxpec1#"/>
                        <input type="hidden" id="taxAmtBil_input_#trancode#" name="taxAmtBil_input_#trancode#" class="form-control input-sm taxAmtBil_input textAlignRight" disabled="true" value="#getItemList.taxAmt_bil#"/>
                    </td>
                    <td>
                        <input type="text" id="amt_input_#trancode#" name="amt_input_#trancode#" class="form-control input-sm amt_input textAlignRight" value="#getItemList.amt_bil#" disabled="true"/>
                    </td>
                    <td class="td_ten">
                        <span class="glyphicon glyphicon-trash delete_item" id="#trancode#"></span>
                    </td>
                </tr>
			</cfloop>
        </cfoutput>
    <!--- updateTrancode [END] --->

    <!--- deleteItem [START] --->
	<cfelseif action EQ "deleteItem">
    
		<cfset uuid=form.uuid>
		<cfset trancode=form.trancode>
		<cftry>
            <cfquery name="deleteRow" datasource="#dts#">
                DELETE FROM ictrantemp
                WHERE trancode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">
                AND uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">;
            </cfquery>
            <cfquery name="checkitemExist" datasource="#dts#">
                SELECT trancode 
                FROM ictrantemp  
                WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
                ORDER BY trancode;
            </cfquery>
            <cfif checkitemExist.recordcount GT 0>
                <cfset itemcountlist = ValueList(checkitemExist.trancode,',')>
                <cfloop index="i" from="1" to="#ListLen(itemcountlist)#">
                    <cfif ListGetAt(itemcountlist,i) NEQ i>
                        <cfquery name="updateTrancode" datasource="#dts#">
                            UPDATE ictrantemp 
                            SET
                                trancode='#i#',
                                itemcount='#i#'
                            WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
                            AND trancode='#ListGetAt(itemcountlist,i)#';
                        </cfquery>
                    </cfif>
                </cfloop>
            </cfif>
            <cfquery name="getLocation" datasource="#dts#">
                SELECT location
                FROM iclocation;
            </cfquery>
            <cfquery name="getUnitOfMeasurement" datasource="#dts#">
                SELECT unit
                FROM unit;
            </cfquery>
            <cfquery name="getTax" datasource="#dts#">
                SELECT code,rate1
                FROM #target_taxtable#;
            </cfquery>      
            <cfquery name="getItemList" datasource="#dts#">
                SELECT trancode,linecode,itemno,desp,location,qty_bil,unit_bil,factor1,factor2,price_bil,dispec1,note_a,taxpec1,taxamt_bil,amt_bil
                FROM ictrantemp
                WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
                ORDER BY trancode ASC;
            </cfquery>
            <cfoutput>
                <cfloop query="getItemList">
                    <cfset trancode=getItemList.trancode>
                    <tr id="#trancode#" class="edit_tr last_edit_tr">
                        <td class="td_one">
                            <label for="recordCountLabel" id="recordCount_#trancode#" class="recordCount">
                            <abbr title="" class="reshuffleTitle">#trancode#</abbr>
                        </label>
                        </td>
                        <td>
                            <input type="text" id="itemno_label_#trancode#" name="itemno_label_#trancode#" class="form-control input-sm itemno_label" value="#getItemList.itemno#" disabled="true"/>
                            <input type="hidden" id="lineCode_label_#trancode#" name="lineCode_label_#trancode#" class="form-control input-sm" value="#getItemList.linecode#"/>
                        </td>
                        <td>
                            <div class="input-group">
                                <input type="text" id="desp_input_#trancode#" name="desp_input_#trancode#" class="form-control input-sm desp_input" value="#getItemList.desp#"/>
                                <span class="input-group-addon glyphiconA glyphicon-plus editItemDescription" id="editItemDescription_#trancode#" data-toggle="modal" data-target="##myItemDescription">
                                </span>
                            </div>
                        </td>
                        <td class="td_four">
                            <select id="location_input_#trancode#" name="location_input_#trancode#" class="form-control input-sm location_input">
                                <option value="">Location</option>
                                <cfloop query="getLocation">
                                    <option value="#getLocation.location#" <cfif getLocation.location EQ getItemList.location>selected</cfif>>#getLocation.location#</option>
                                </cfloop>
                            </select>
                        </td>
                        <td>
                            <div class="row no-pad">
                                <div class="col-sm-4">
                                    <input type="text" id="qty_input_#trancode#" name="qty_input_#trancode#" class="form-control input-sm qty_input textAlignRight" value="#getItemList.qty_bil#" />
                                </div>
                                <div class="col-sm-8">
                                    <select id="unitOfMeasurement_input_#trancode#" name="unitOfMeasurement_input_#trancode#" class="form-control input-sm unitOfMeasurement_input">
                                    	<option value="">U.O.M</option>
                                        <cfloop query="getUnitOfMeasurement">
                                            <option value="#getUnitOfMeasurement.unit#" <cfif getUnitOfMeasurement.unit EQ getItemList.unit_bil>selected</cfif>>#getUnitOfMeasurement.unit#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                            <div class="row no-pad">
                                <div class="col-sm-6">
                                    <input type="text" id="factor1_#trancode#" name="factor1_#trancode#" class="form-control input-sm collapse factor1 textAlignRight" value="#getItemList.factor1#"/>
                                </div>
                                <div class="col-sm-6">
                                    <input type="text" id="factor2_#trancode#" name="factor2_#trancode#" class="form-control input-sm collapse factor2 textAlignRight" value="#getItemList.factor2#"/>
                                </div>
                            </div>
                        </td>
                        <td>
                            <input type="text" id="price_input_#trancode#" name="price_input_#trancode#" class="form-control input-sm price_input textAlignRight priceHistory" value="#getItemList.price_bil#" />
                        </td>
                        <td>
                            <div class="input-group">
                                <input type="text" id="dispec1_input_#trancode#" name="dispec1_input_#trancode#" class="form-control input-sm dispec1_input textAlignRight" value="#getItemList.dispec1#" />
                                <span class="input-group-addon" id="discount">%</span>
                            </div>
                        </td>
                        <td class="itemTaxTD">
                            <select id="itemTaxCode_input_#trancode#" name="itemTaxCode_input_#trancode#" class="form-control input-sm itemTaxCode">
                                <cfloop query="getTax">
                                    <option value="#getTax.code#" <cfif getTax.code EQ getItemList.note_a>selected</cfif>>#getTax.code#</option>
                                </cfloop>
                            </select>
                            <input type="hidden" id="taxpec1_input_#trancode#" name="taxpec1_input_#trancode#" class="form-control input-sm taxpec1_input textAlignRight" value="#getItemList.taxpec1#" disabled="true"/>
                            <input type="hidden" id="taxAmtBil_input_#trancode#" name="taxAmtBil_input_#trancode#" class="form-control input-sm taxAmtBil_input textAlignRight" value="#getItemList.taxamt_bil#" disabled="true"/>
                        </td>
                        <td>
                            <input type="text" id="amt_input_#trancode#" name="amt_input_#trancode#" class="form-control input-sm amt_input textAlignRight" value="#getItemList.amt_bil#" disabled="true"/>
                        </td>
                        <td class="td_ten">
                            <span class="glyphicon glyphicon-trash delete_item" id="#trancode#"></span> 
                        </td>
                    </tr>
                </cfloop>
                <cfset trancode = trancode+1>
                <tr id="#trancode#" class="edit_tr last_edit_tr">
                    <td class="td_one">
                        <label for="recordCountLabel" id="recordCount_#trancode#" class="recordCount">
                            <abbr title="" class="reshuffleTitle">#trancode#</abbr>
                        </label>
                    </td>
                    <td>
                        <input type="text" id="itemno_label_#trancode#" name="itemno_label_#trancode#" class="form-control input-sm itemno_label" disabled="true"/>
                        <input type="hidden" id="itemno_input_#trancode#" name="itemno_input_#trancode#" class="editbox itemno_input addline" data-placeholder="Choose an item" />
                        <input type="hidden" id="lineCode_label_#trancode#" name="lineCode_label_#trancode#" class="form-control input-sm"/>
                    </td>
                    <td>
                        <div class="input-group">
                            <input type="text" id="desp_input_#trancode#" name="desp_input_#trancode#" class="form-control input-sm desp_input"/>
                            <span class="input-group-addon glyphiconA glyphicon-plus editItemDescription" id="editItemDescription_#trancode#" data-toggle="modal" data-target="##myItemDescription">
                            </span>
                        </div>
                    </td>
                    <td class="td_four">
                        <select id="location_input_#trancode#" name="location_input_#trancode#" class="form-control input-sm location_input">
                            <option value="">Location</option>
                            <cfloop query="getLocation">
                                <option value="#getLocation.location#">#getLocation.location#</option>
                            </cfloop>
                        </select>
                    </td>
                    <td>
                        <div class="row no-pad">
                            <div class="col-sm-4">
                                <input type="text" id="qty_input_#trancode#" name="qty_input_#trancode#" class="form-control input-sm qty_input textAlignRight" />
                            </div>
                            <div class="col-sm-8">
                                <select id="unitOfMeasurement_input_#trancode#" name="unitOfMeasurement_input_#trancode#" class="form-control input-sm unitOfMeasurement_input">
                                	<option value="">U.O.M</option>
                                    <cfloop query="getUnitOfMeasurement">
                                        <option value="#getUnitOfMeasurement.unit#">#getUnitOfMeasurement.unit#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="row no-pad">
                            <div class="col-sm-6">
                                <input type="text" id="factor1_#trancode#" name="factor1_#trancode#" class="form-control input-sm collapse factor1 textAlignRight"/>
                            </div>
                            <div class="col-sm-6">
                                <input type="text" id="factor2_#trancode#" name="factor2_#trancode#" class="form-control input-sm collapse factor2 textAlignRight"/>
                            </div>
                        </div>
                    </td>
                    <td>
                        <input type="text" id="price_input_#trancode#" name="price_input_#trancode#" class="form-control input-sm price_input textAlignRight priceHistory" />
                    </td>
                    <td>
                        <div class="input-group">
                            <input type="text" id="dispec1_input_#trancode#" name="dispec1_input_#trancode#" class="form-control input-sm dispec1_input textAlignRight" />
                            <span class="input-group-addon" id="discount">%</span>
                        </div>
                    </td>
                    <td class="itemTaxTD">
                        <select id="itemTaxCode_input_#trancode#" name="itemTaxCode_input_#trancode#" class="form-control input-sm itemTaxCode">
                            <cfloop query="getTax">
                                <option value="#getTax.code#" <!---<cfif getTax.code EQ defaultTaxCode>selected</cfif>--->>#getTax.code#</option>
                            </cfloop>
                        </select>
                        <input type="hidden" id="taxpec1_input_#trancode#" name="taxpec1_input_#trancode#" class="form-control input-sm taxpec1_input textAlignRight" disabled="true"/>
                        <input type="hidden" id="taxAmtBil_input_#trancode#" name="taxAmtBil_input_#trancode#" class="form-control input-sm taxAmtBil_input textAlignRight" disabled="true"/>
                    </td>
                    <td>
                        <input type="text" id="amt_input_#trancode#" name="amt_input_#trancode#" class="form-control input-sm amt_input textAlignRight" disabled="true"/>
                    </td>
                    <td class="td_ten">
                        <span class="glyphicon glyphicon-trash delete_item" id="#trancode#"></span> 
                    </td>
                </tr> 
            </cfoutput>
        <cfcatch>   	 
        </cfcatch>
		</cftry>            
	<!--- deleteItem [END] --->
    
    <!--- getTaxRate [START] --->
	<cfelseif action EQ "getTaxRate">
    
		<cfset taxcode=form.taxCode>
        	
		<cfquery name="getTaxRate" datasource="#dts2#">
			SELECT code,rate1
			FROM taxtable
			WHERE code=<cfqueryparam cfsqltype="cf_sql_varchar" value="#taxcode#">;
		</cfquery>
        <cfset tax={
			TAXCODE="#getTaxRate.code#",
			TAXRATE="#getTaxRate.rate1#"
		}>
		<cfset tax=SerializeJSON(tax)>
		<cfset tax=cleanXmlString(tax)>
		<cfoutput>#tax#</cfoutput>
	<!--- getTaxRate [END] --->
    
    <!--- getReferenceNo [START] --->
	<cfelseif action EQ "getReferenceNo">
    
		<cfset RefNoCounter = trim(form.RefNoCounter)>
        <cfset RefType = trim(form.RefType)>	

        <cfquery name="getRefNoSet" datasource="#dts#" >
            SELECT lastUsedNo, refnoused
            FROM refnoset
            WHERE type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#RefType#">
            AND counter=<cfqueryparam cfsqltype="cf_sql_varchar" value="#RefNoCounter#">;
        </cfquery>
        
       <cfinvoke component="cfc.refno" method="processNum" oldNum="#getRefNoSet.lastUsedNo#" returnvariable="refno" />

        <cfset refNo={
			REFNO="#refno#",
			REFNOUSED="#getRefNoSet.refNoUsed#"
		}>
		<cfset refNo=SerializeJSON(refNo)>
		<cfset refNo=cleanXmlString(refNo)>
		<cfoutput>#refNo#</cfoutput>
	<!--- getReferenceNo [END] --->
    
    <!--- checkTargetCustno [START] --->
	<cfelseif action EQ "checkTargetCustno">
    
		<cfset targetTable = trim(form.targetTable)>
		<cfset custno = trim(form.custno)>
        	
		<cfquery name="checkTargetCustno" datasource="#dts2#">
			SELECT COUNT(custno) AS custNoCount
			FROM #targetTable#
			WHERE custno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">
		</cfquery>
		<cfoutput>#checkTargetCustno.custNoCount#</cfoutput>
	<!--- checkTargetCustno [END] --->
    
    <!--- insertTarget [START] --->
	<cfelseif action EQ "insertTarget">
		<cfset target=form.target>
		<cfset targetTable=form.targetTable> 
		<cfset custno=form.custno>
		<cfset name=form.name>
		<cfset name2=form.name2> 
        <cfset attn=form.attn>
        <cfset add1=form.add1>
		<cfset add2=form.add2>
		<cfset add3=form.add3>
		<cfset add4=form.add4>
        <cfset country=form.country>
		<cfset postalcode=form.postalcode>
        <cfset phone=form.phone>
		<cfset hp=form.hp>
        <cfset fax=form.fax>
        <cfset email=form.email>
        <cfset d_attn=form.d_attn>
        <cfset d_add1=form.d_add1>
		<cfset d_add2=form.d_add2>
		<cfset d_add3=form.d_add3>
		<cfset d_add4=form.d_add4>
        <cfset d_country=form.d_country>
		<cfset d_postalcode=form.d_postalcode>
        <cfset d_phone=form.d_phone>
		<cfset d_hp=form.d_hp>
        <cfset d_fax=form.d_fax>
        <cfset d_email=form.d_email>

		<cfquery name="insertTarget" datasource="#dts2#">
			INSERT INTO #targetTable# (
                                        custno,name,name2,
                                        attn,add1,add2,add3,add4,country,postalcode,
                                        dattn,daddr1,daddr2,daddr3,daddr4,d_country,d_postalcode,
                                        created_by,created_on )
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#name2#">,
                
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attn#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#add1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#add2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#add3#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#add4#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#country#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#postalcode#">,
                
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_attn#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add3#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add4#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#d_country#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#d_postalcode#">,
                "#getAuthUser()#",
				NOW()
			)
		</cfquery>
	<!--- insertTarget [END] --->
    
    <!--- getItemDescription [START] --->
	<cfelseif action EQ "getItemDescription">
    	<cfset uuid = trim(form.uuid)>
        <cfset trancode = trim(form.trancode)>
        <cfset itemno = trim(URLDecode(form.itemno_label))>
      
		<cfquery name="getIcitem" datasource="#dts#">
			SELECT uuid,itemno,trancode,despa,comment,brem1,brem2,brem3,brem4
			FROM ictrantemp
			WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
            AND itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
            AND trancode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">;
		</cfquery>
        <cfset itemDesp={
			UNIQUEID="#getIcitem.uuid#",
			ITEMNO="#getIcitem.itemno#",
			TRANCODE="#getIcitem.trancode#",
			DESPA="#getIcitem.despa#",
			COMMENT="#toString(getIcitem.comment)#",
			BREM1="#getIcitem.brem1#",
			BREM2="#getIcitem.brem2#",
			BREM3="#getIcitem.brem3#",
			BREM4="#getIcitem.brem4#"
		}>
        <cfset itemDesp=SerializeJSON(itemDesp)>
		<cfset itemDesp=cleanXmlString(itemDesp)>
		<cfoutput>#itemDesp#</cfoutput>
	<!--- getItemDescription [END] --->
    
    <!--- updateItemDescription [START] --->
	<cfelseif action EQ "updateItemDescription">
    	<cfset uuid = trim(form.uuid_value)>
        <cfset trancode = trim(form.trancode_value)>
    	<cfset itemno = trim(URLDecode(form.itemno_value))>
        <cfset despa = trim(URLDecode(form.despa_input))>
        <cfset comment = trim(URLDecode(form.comment_input))>
        <cfset brem1 = trim(URLDecode(form.brem1_input))>
        <cfset brem2 = trim(URLDecode(form.brem2_input))>
        <cfset brem3 = trim(URLDecode(form.brem3_input))>
        <cfset brem4 = trim(URLDecode(form.brem4_input))>

		<cfquery name="updateItemDescription" datasource="#dts#">
            UPDATE ictrantemp
            SET
                despa=<cfqueryparam cfsqltype="cf_sql_varchar" value="#despa#">,
                comment=<cfqueryparam cfsqltype="cf_sql_varchar" value="#comment#">,
                brem1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#brem1#">,
                brem2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#brem2#">,
                brem3=<cfqueryparam cfsqltype="cf_sql_varchar" value="#brem3#">,
                brem4=<cfqueryparam cfsqltype="cf_sql_varchar" value="#brem4#">
  
            WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
            AND itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#itemno#">
            AND trancode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trancode#">;
        </cfquery>
	<!--- updateItemDescription [END] --->
    
    
    <!--- createTransaction [START] --->
	<cfelseif action EQ "createTransaction">
    	<cfset adjustmentValue = 0.000001>
        <cfset discountDecimalPoint = trim(form.discountDecimalPoint)>
        <cfset priceDecimalPoint = trim(form.priceDecimalPoint)>
        <cfset totalDecimalPoint = trim(form.totalDecimalPoint)>
        <cfset transactionAction = trim(form.transactionAction)>
    	<cfset uuid = trim(form.uuid)>
		<cfset type = trim(form.type)>
        <cfset custno = trim(form.custno)>     
        <cfset name = trim(URLDecode(form.name))>
        <cfset name2 = trim(URLDecode(form.name2))> 
        <cfset add1 = trim(URLDecode(form.add1))>
        <cfset add2 = trim(URLDecode(form.add2))>
        <cfset add3 = trim(URLDecode(form.add3))>
        <cfset add4 = trim(URLDecode(form.add4))>
        <cfset country = trim(URLDecode(form.country))>
        <cfset postalcode = trim(URLDecode(form.postalcode))>
        <cfset attn = trim(URLDecode(form.attn))>    
        <cfset phone = trim(URLDecode(form.phone))>
        <cfset hp = trim(URLDecode(form.hp))>
        <cfset fax = trim(URLDecode(form.fax))>
        <cfset email = trim(URLDecode(form.email))>
        <cfset d_name = trim(URLDecode(form.d_name))>
        <cfset d_name2 = trim(URLDecode(form.d_name2))>
        <cfset d_add1 = trim(URLDecode(form.d_add1))>
        <cfset d_add2 = trim(URLDecode(form.d_add2))>
        <cfset d_add3 = trim(URLDecode(form.d_add3))>
        <cfset d_add4 = trim(URLDecode(form.d_add4))>
        <cfset d_country = trim(URLDecode(form.d_country))>
        <cfset d_postalcode = trim(URLDecode(form.d_postalcode))>
        <cfset d_attn = trim(URLDecode(form.d_attn))>    
        <cfset d_phone = trim(URLDecode(form.d_phone))>
        <cfset d_hp = trim(URLDecode(form.d_hp))>
        <cfset d_fax = trim(URLDecode(form.d_fax))>
        <cfset d_email = trim(URLDecode(form.d_email))>
        <cfset refno = trim(URLDecode(form.refno))>
        <cfset refnoset = trim(URLDecode(form.refnoset))>
        <cfset wos_dateTemp = CreateDate(right(URLDecode(form.wos_date),4),mid(URLDecode(form.wos_date),4,2),left(URLDecode(form.wos_date),2))>
        <Cfset wos_date = DateFormat(wos_dateTemp,"yyyy-mm-dd")>
        <cfset currcode = trim(URLDecode(form.currcode))>
        <cfset currencyRate = trim(form.currencyRate)>
        <cfset term = trim(URLDecode(form.term))> 
        <cfset desp = trim(URLDecode(form.desp))>       
        <cfset refno2 = trim(URLDecode(form.refno2))>
        <cfset pono = trim(URLDecode(form.pono))>
        <cfset quono = trim(URLDecode(form.quono))>
        <cfset sono = trim(URLDecode(form.sono))>
        <cfset dono = trim(URLDecode(form.dono))>
		<cfset project = trim(URLDecode(form.project))>
        <cfset job = trim(URLDecode(form.job))>
        <cfset agent = trim(URLDecode(form.agent))>
        <cfset driver = trim(URLDecode(form.driver))>
        <cfset remark5 = trim(URLDecode(form.remark5))>
        <cfset remark6 = trim(URLDecode(form.remark6))>
        <cfset remark7 = trim(URLDecode(form.remark7))>
        <cfset remark8 = trim(URLDecode(form.remark8))>
        <cfset remark9 = trim(URLDecode(form.remark9))>
        <cfset remark10 = trim(URLDecode(form.remark10))>
        <cfset remark11 = trim(URLDecode(form.remark11))> 
        <!--- START: Kastam Diraja Malaysia Required Fields ---> 
        <cfset INVno = trim(URLDecode(form.INVno))>
        <cfset reason = trim(URLDecode(form.reason))>  
        <!--- END: Kastam Diraja Malaysia Required Fields --->
        <cfset termCondition = trim(URLDecode(form.termCondition))>
        <cfset disp1_bil = trim(form.disp1_bil)>
        <cfset disp2_bil = trim(form.disp2_bil)>
        <cfset disp3_bil = trim(form.disp3_bil)>
        <cfset discount_bil = trim(form.discount_bil)>
        <cfset gross_bil = trim(form.gross_bil)>
        <cfset net_bil = trim(form.net_bil)>
        <cfset taxCode = trim(form.taxCode)>
        <cfset taxp1_bil = trim(form.taxp1_bil)>
        <cfset tax_bil = trim(form.tax_bil)>
        <cfset grand_bil = trim(form.grand_bil)>
        <cfset billTaxIncluded = trim(form.billTaxIncluded)>
        <cfif type EQ "RC" or type EQ "PR" or type EQ "PO" or type EQ "CN">
			<cfset credit_bil = grand_bil>
            <cfset debit_bil = 0>
        <cfelse>
            <cfset debit_bil = grand_bil>
            <cfset credit_bil = 0>
        </cfif>
        <cfset dateNow = DateFormat(NOW(),"yyyy-mm-dd")>
        <cfset tempDate = CreateDate(right(URLDecode(form.wos_date),4),mid(URLDecode(form.wos_date),4,2),left(URLDecode(form.wos_date),2))>
        <cfinvoke 
        		component="cfc.Period" 
                method="getCurrentPeriod" 
                dts="#dts#" 
                inputDate="#DateFormat(tempDate,'yyyy-mm-dd')#" 
                returnvariable="fperiod"/>
                
        <cfset decimalConverter = ".">
        <cfloop index="LoopCount" from="1" to="#discountDecimalPoint#">
            <cfset discountDecimalPointConverted = decimalConverter & "_">
        </cfloop>
        <cfloop index="LoopCount" from="1" to="#priceDecimalPoint#">
            <cfset priceDecimalPointConverted = decimalConverter & "_">
        </cfloop>
        <cfloop index="LoopCount" from="1" to="#totalDecimalPoint#">
            <cfset totalDecimalPointConverted = decimalConverter & "_">
        </cfloop>
        
        <!--- Action: Create--->
        <cfif transactionAction EQ 'Create'>
            <cfquery name="checkExistReferenceNo" datasource="#dts#">
                SELECT refno 
                FROM artran 
                WHERE type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#"> 
                AND refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">;
            </cfquery>
            
            <cfif checkExistReferenceNo.recordCount NEQ 0>
                <cfquery name="getRefNoSet" datasource="#dts#" >
                    SELECT lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse
                    FROM refnoset
                    WHERE type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
                    AND counter=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refnoset#">;
                </cfquery>
                
                <cfif getRefNoSet.arun EQ "1">
                        <cfset refnocheck = 0>
                        <cfset refno1 = checkExistReferenceNo.refno>
                    <cfloop condition="refnocheck EQ 0">
                        <cftry>
                            <cfinvoke component="cfc.IncrementValue" method="getIncreament" input="#refno1#" returnvariable="refno"/>
                        <cfcatch>
                            <cfinvoke component="cfc.refno" method="processNum" oldNum="#refno1#" returnvariable="refno" />	
                        </cfcatch>
                        </cftry>
                        
                        <cfquery name="checkexistence" datasource="#dts#">
                            SELECT refno 
                            FROM artran 
                            WHERE refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#"> 
                            AND type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">;
                        </cfquery>
                        
                        <cfif checkexistence.recordcount EQ 0>
                            <cfset refnocheck = 1>
                        <cfelse>
                            <cfset refno1 = refno>
                        </cfif>
                    </cfloop>
                <cfelse>
                    <h3>The refno existed. Please enter new refno. <a href="##" onClick="history.go(-1);">Back</a></h3>
                    <cfabort />
                </cfif>
            </cfif>
		</cfif><!---END IF Create--->	

		<cfif transactionAction EQ 'Update'>
            <cfquery name="deleteIctran" datasource="#dts#">
                DELETE FROM ictran
                WHERE refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
                AND type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">;		
            </cfquery>
        </cfif>
                
        <cfquery name="updateIctrantemp" datasource="#dts#">
            UPDATE ictrantemp 
            SET
                type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
                custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
                refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
                wos_date = '#wos_date#',
                fperiod = '#fperiod#',
                currrate = '#currencyRate#',
                price = ROUND((price_bil * #val(currencyRate)#)+#adjustmentValue#,#priceDecimalPoint#),
                disamt = ROUND((disamt_bil * #val(currencyRate)#)+#adjustmentValue#,#discountDecimalPoint#),
                amt = ROUND((amt_bil * #val(currencyRate)#)+#adjustmentValue#,#totalDecimalPoint#),
                amt1 = ROUND((amt1_bil * #val(currencyRate)#)+#adjustmentValue#,#totalDecimalPoint#)
            WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">;		
        </cfquery>
        
        <cfquery name="insertIctran" datasource="#dts#">
            INSERT INTO ictran( type,refno,trancode,itemcount,linecode,custno,fperiod,wos_date,itemno,desp,despa,comment,brem1,brem2,brem3,brem4,
                                location,qty,qty_bil,unit,unit_bil,factor1,factor2,price,price_bil,                                   
                                dispec1,disamt,disamt_bil,
                                note_a,taxpec1,taxamt_bil,
                                amt,amt_bil,amt1,amt1_bil,currrate,
                                userID
                               )     
            SELECT type,refno,trancode,itemcount,linecode,custno,fperiod,wos_date,itemno,desp,despa,comment,brem1,brem2,brem3,brem4,
                   location,qty,qty_bil,unit,unit_bil,factor1,factor2,price,price_bil,                                   
                   dispec1,disamt,disamt_bil,
                   note_a,taxpec1,taxamt_bil,
                   amt,amt_bil,amt1,amt1_bil,currrate,
                   userID
            FROM ictrantemp
            WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">;	                                           
        </cfquery>

        <cfset discount= NumberFormat(val(discount_bil) * val(currencyRate),#discountDecimalPointConverted#)> 
        <cfset net= NumberFormat(val(net_bil) * val(currencyRate),#totalDecimalPointConverted#)>       
        <cfset tax=  NumberFormat(val(tax_bil) * val(currencyRate),#totalDecimalPointConverted#)>
        <cfset grand= NumberFormat(val(grand_bil) * val(currencyRate),#totalDecimalPointConverted#)>    
        <cfset gross= NumberFormat(val(gross_bil) * val(currencyRate),#totalDecimalPointConverted#)>
        
        <cfif transactionAction EQ 'Create'>
            <cfquery name="insertArtran" datasource="#dts#">
                INSERT INTO artran (
                                    type,custno,name,
                                    frem0,frem1,frem2,frem3,frem4,frem5,country,postalcode,rem2,rem4,phonea,frem6,e_mail,
                                    frem7,frem8,comm0,comm1,comm2,comm3,d_country,d_postalcode,rem3,rem12,d_phone2,comm4,d_email,
                                    refno,wos_date,fperiod,currcode,currrate,term,
                                    desp,refno2,pono,quono,sono,dono,
                                    source,job,agenno,van,
                                    <cfloop index="i" from="5" to="11">rem#i#,</cfloop>rem48,rem49,termsCondition,
                                    disp1,disp2,disp3,disc_bil,
                                    invgross,gross_bil,net,net_bil,
                                    taxincl,note,taxp1,tax,tax_bil,
                                    grand,grand_bil,debitamt,debit_bil,creditamt,credit_bil,cs_pm_debt,
                                    created_by,userID,created_on,trdatetime )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#name2#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#add1#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#add2#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#add3#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#add4#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#country#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#postalcode#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attn#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#phone#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#hp#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#fax#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_name2#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add1#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add2#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add3#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add4#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_country#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_postalcode#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_attn#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_phone#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_hp#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_fax#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_email#">,
    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(wos_date,'YYYY-MM-DD')#">,
                    '#fperiod#',
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#currencyRate#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#term#">, 
                    
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#desp#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#refno2#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#pono#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#quono#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#sono#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#dono#">,
                     
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#project#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#job#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#agent#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">,
                    
                    <cfloop index="i" from="5" to="11">
                        <cfset remarkValue = evaluate('remark#i#')>	
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(remarkValue)#">,
                    </cfloop> 
                    <!--- START: Kastam Diraja Malaysia Required Fields ---> 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#reason#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#INVno#">,
                    <!--- END: Kastam Diraja Malaysia Required Fields ---> 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#termCondition#">,
                    
                    <cfqueryparam cfsqltype="cf_sql_double" value="#disp1_bil#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#disp2_bil#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#disp3_bil#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#discount_bil#">,
                    
                    <cfqueryparam cfsqltype="cf_sql_double" value="#gross#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#gross_bil#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#net#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#net_bil#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#billTaxIncluded#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#taxCode#">, 
                    <cfqueryparam cfsqltype="cf_sql_double" value="#taxp1_bil#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#tax#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#tax_bil#">,
                    
                    <cfqueryparam cfsqltype="cf_sql_double" value="#grand#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#grand_bil#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#grand#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#debit_bil#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#grand#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#credit_bil#">,
                    <cfqueryparam cfsqltype="cf_sql_double" value="#grand_bil#">,
                    '#HuserID#',
                    '#HuserID#',
                    '#dateNow#',
                    '#dateNow#'
                 )    
            </cfquery>
        <cfelseif transactionAction EQ 'Update'>
            <cfquery name="updateArtran" datasource="#dts#">
                UPDATE artran 
                SET				
                    custno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#custno#">,
                    name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
                    
                    frem0 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
                    frem1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name2#">,
                    frem2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#add1#">,
                    frem3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#add2#">,
                    frem4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#add3#">,
                    frem5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#add4#">,
                    country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#country#">,
                    postalcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#postalcode#">,
                    rem2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attn#">,
                    rem4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#phone#">,
                    phonea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hp#">,
                    frem6 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fax#">,
                    e_mail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#email#">,
                    
                    frem7 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_name#">,
                    frem8 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_name2#">,
                    comm0 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add1#">,
                    comm1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add2#">,
                    comm2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add3#">,
                    comm3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_add4#">,
                    d_country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_country#">,
                    d_postalcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_postalcode#">,
                    rem3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_attn#">,
                    rem12 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_phone#">,
                    d_phone2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_hp#">,
                    comm4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_fax#">,
                    d_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_email#">,
    
                    wos_date = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(wos_date,'YYYY-MM-DD')#">,
                    currcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#currcode#">,
                    currrate = <cfqueryparam cfsqltype="cf_sql_double" value="#currencyRate#">,
                    term = <cfqueryparam cfsqltype="cf_sql_varchar" value="#term#">, 
                    
                    refno2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#refno2#">,
                    pono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pono#">,
                    quono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#quono#">,
                    sono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sono#">,
                    dono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dono#">,
                    
                    source = <cfqueryparam cfsqltype="cf_sql_varchar" value="#project#">,
                    job = <cfqueryparam cfsqltype="cf_sql_varchar" value="#job#">,
                    agenno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#agent#">,
                    van = <cfqueryparam cfsqltype="cf_sql_varchar" value="#driver#">,
                    
                    <cfloop index="i" from="5" to="11">
                        <cfset remarkValue = evaluate('remark#i#')>	
                        rem#i# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(remarkValue)#">,
                    </cfloop> 
                    termsCondition = <cfqueryparam cfsqltype="cf_sql_varchar" value="#termCondition#">,
                    
                    disp1 = <cfqueryparam cfsqltype="cf_sql_double" value="#disp1_bil#">,
                    disp2 = <cfqueryparam cfsqltype="cf_sql_double" value="#disp2_bil#">,
                    disp3 = <cfqueryparam cfsqltype="cf_sql_double" value="#disp3_bil#">,
                    disc_bil = <cfqueryparam cfsqltype="cf_sql_double" value="#discount_bil#">,
                    
                    invgross = <cfqueryparam cfsqltype="cf_sql_double" value="#gross#">,
                    gross_bil = <cfqueryparam cfsqltype="cf_sql_double" value="#gross_bil#">,
                    net = <cfqueryparam cfsqltype="cf_sql_double" value="#net#">,
                    net_bil = <cfqueryparam cfsqltype="cf_sql_double" value="#net_bil#">,
                    taxincl = 'F',
                    note = <cfqueryparam cfsqltype="cf_sql_varchar" value="#taxCode#">, 
                    taxp1 = <cfqueryparam cfsqltype="cf_sql_double" value="#taxp1_bil#">,
                    tax = <cfqueryparam cfsqltype="cf_sql_double" value="#tax#">,
                    tax_bil = <cfqueryparam cfsqltype="cf_sql_double" value="#tax_bil#">,
                    
                    grand = <cfqueryparam cfsqltype="cf_sql_double" value="#grand#">,
                    grand_bil = <cfqueryparam cfsqltype="cf_sql_double" value="#grand_bil#">,
                    debitamt = <cfqueryparam cfsqltype="cf_sql_double" value="#grand#">,
                    debit_bil = <cfqueryparam cfsqltype="cf_sql_double" value="#debit_bil#">,
                    creditamt = <cfqueryparam cfsqltype="cf_sql_double" value="#grand#">,
                    credit_bil = <cfqueryparam cfsqltype="cf_sql_double" value="#credit_bil#">,
                    cs_pm_debt = <cfqueryparam cfsqltype="cf_sql_double" value="#grand_bil#">
                    
                WHERE refno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
                AND type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">;    
            </cfquery>
        </cfif>
        
        <cfquery name="deleteIctran" datasource="#dts#">
            DELETE FROM ictrantemp
            WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
            AND type=<cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">;	
        </cfquery>
        
        <cfquery name="getGsetup" datasource="#dts#">
            SELECT wpitemtax 
            FROM gsetup;
        </cfquery>
        
        <cfif getGsetup.wpitemtax NEQ "1" AND val(gross_bil) NEQ 0>
			<cfif form.billTaxIncluded EQ "T">
               <cfquery name="updateictrantax" datasource="#dts#">
                    UPDATE ictran 
                    SET 
                    	note_a='#taxCode#',
                    	TAXPEC1='#taxp1_bil#',
                    	TAXAMT_BIL=round((AMT_BIL/#val(net)+val(discount_bil)#)*#val(tax_bil)#,5),
                    	TAXAMT=round((AMT/#val(net)+val(discount)#)*#val(tax)#,5)
                    WHERE type='#type#' 
                    AND refno='#refno#';
                </cfquery>
			<cfelse>
                <cfquery name="updateictrantax" datasource="#dts#">
                    UPDATE ictran 
                    SET 
                    	note_a = '#taxCode#',
                    	TAXPEC1 = '#taxp1_bil#',
                    	TAXAMT_BIL = ROUND((AMT_BIL/#val(gross_bil)#)*#val(tax_bil)#,5),
                    	TAXAMT = ROUND((AMT/#val(gross)#)*#val(tax)#,5)
                    WHERE type = '#type#' 
                    AND refno = '#refno#';
                </cfquery>
            </cfif>
        <cfelseif getGsetup.wpitemtax EQ "1">
        	<cfquery name="updateictrantax" datasource="#dts#">
                UPDATE ictran 
                SET 
                    TAXAMT = ROUND(TAXAMT_BIL*currrate,5)
                WHERE type = '#type#' 
                AND refno = '#refno#';
            </cfquery>
        </cfif>
        
        <!---Action: Create--->
        <cfif transactionAction EQ 'Create'>
            <cfquery name="getGeneralInfo" datasource="#dts#">
                SELECT lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse 
                FROM refnoset
                WHERE type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
                AND counter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#refnoset#">;
            </cfquery>
            <cfif getGeneralInfo.refnocode NEQ "" AND getGeneralInfo.presuffixuse EQ "1" and getGeneralInfo.arun EQ "1">
                <cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />
            <cfelse>
                <cfset newnextnum = refno>
            </cfif>
            <cfquery name="updaterefno" datasource="#dts#">
                UPDATE refnoset 
                SET lastUsedNo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newnextnum#">
                WHERE type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
                AND counter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#refnoset#">;
            </cfquery>
        </cfif>    
        <!--- END Create--->
	<!--- createTransaction [END] --->

    <!--- getBillDetails [START] --->
	<cfelseif action EQ "getBillDetails">
		<cfset type=form.type>	
        <cfset refno=form.refno>	
		<cfquery name="getLocation" datasource="#dts#">
            SELECT location
            FROM iclocation;
        </cfquery>
        <cfquery name="getUnitOfMeasurement" datasource="#dts#">
            SELECT unit
            FROM unit;
        </cfquery>
        <cfquery name="getTax" datasource="#dts#">
            SELECT code,rate1
            FROM #target_taxtable#;
        </cfquery>
		<cfquery name="getItemList" datasource="#dts#">
			SELECT	trancode,linecode,itemno,desp,despa,comment,brem1,brem2,brem3,brem4,
                   	location,qty,qty_bil,unit,unit_bil,factor1,factor2,price,price_bil,                                   
                   	dispec1,disamt,disamt_bil,
                   	note_a,taxpec1,taxamt_bil,
                   	amt,amt_bil,amt1,amt1_bil
			FROM ictran
			WHERE type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#type#">
            AND refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#refno#">
            ORDER BY trancode ;
		</cfquery>
		<cfoutput>
        	<cfset trancode=getItemList.trancode>
            <input type="hidden" id="totalTrancode" name="totalTrancode" value="#getItemList.recordCount#" />
        	<cfloop query="getItemList">
                <tr id="#getItemList.trancode#" class="edit_tr last_edit_tr">
                    <td class="td_one">
                        <label for="recordCountLabel" id="recordCount_#trancode#" class="recordCount">
                            <abbr title="" class="reshuffleTitle">#trancode#</abbr>
                        </label>
                    </td>
                    <td>
                    	<input type="text" id="itemno_label_#trancode#" name="itemno_label_#trancode#" class="form-control input-sm itemno_label" value="#convertquote(getItemList.itemno)#" disabled="true"/>
                        <input type="hidden" id="lineCode_label_#trancode#" name="lineCode_label_#trancode#" class="form-control input-sm" value="#getItemList.linecode#"/>
                    </td>
                    <td>
                        <div class="input-group">
                            <input type="text" id="desp_input_#trancode#" name="desp_input_#trancode#" class="form-control input-sm desp_input" value="#convertquote(getItemList.desp)#"/>
                            <span class="input-group-addon glyphiconA glyphicon-plus editItemDescription" id="editItemDescription_#trancode#" data-toggle="modal" data-target="##myItemDescription">
                            </span>
                        </div>
                    </td>
                    <td class="td_four">
                        <select id="location_input_#trancode#" name="location_input_#trancode#" class="form-control input-sm location_input">
                            <option value="">Location</option>
                            <cfloop query="getLocation">
                                <option value="#getLocation.location#" <cfif getLocation.location EQ getItemList.location>selected</cfif>>#getLocation.location#</option>
                            </cfloop>
                        </select>
                    </td>
                    <td>
                        <div class="row no-pad">
                            <div class="col-sm-4">
                                <input type="text" id="qty_input_#trancode#" name="qty_input_#trancode#" class="form-control input-sm qty_input textAlignRight" value="#getItemList.qty_bil#" />
                            </div>
                            <div class="col-sm-8">
                                <select id="unitOfMeasurement_input_#trancode#" name="unitOfMeasurement_input_#trancode#" class="form-control input-sm unitOfMeasurement_input">
                                	<option value="">U.O.M</option>
                                    <cfloop query="getUnitOfMeasurement">
                                        <option value="#getUnitOfMeasurement.unit#" <cfif getUnitOfMeasurement.unit EQ getItemList.unit_bil>selected</cfif>>#getUnitOfMeasurement.unit#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="row no-pad">
                            <div class="col-sm-6">
                                <input type="text" id="factor1_#trancode#" name="factor1_#trancode#" class="form-control input-sm collapse factor1 textAlignRight" value="#getItemList.factor1#"/>
                            </div>
                            <div class="col-sm-6">
                                <input type="text" id="factor2_#trancode#" name="factor2_#trancode#" class="form-control input-sm collapse factor2 textAlignRight" value="#getItemList.factor2#"/>
                            </div>
                        </div>
                    </td>
                    <td>
                        <input type="text" id="price_input_#trancode#" name="price_input_#trancode#" class="form-control input-sm price_input textAlignRight priceHistory" value="#getItemList.price_bil#" />
                    </td>
                    <td>
                        <div class="input-group">
                            <input type="text" id="dispec1_input_#trancode#" name="dispec1_input_#trancode#" class="form-control input-sm dispec1_input textAlignRight" value="#getItemList.dispec1#" />
                            <span class="input-group-addon" id="discount">%</span>
                        </div>
                    </td>
                    <td class="itemTaxTD">
                        <select id="itemTaxCode_input_#trancode#" name="itemTaxCode_input_#trancode#" class="form-control input-sm itemTaxCode">
                            <cfloop query="getTax">
                                <option value="#getTax.code#" <cfif getTax.code EQ getItemList.note_a>selected</cfif>>#getTax.code#</option>
                            </cfloop>
                        </select>
                        <input type="hidden" id="taxpec1_input_#trancode#" name="taxpec1_input_#trancode#" class="form-control input-sm taxpec1_input textAlignRight" disabled="true" value="#getItemList.taxpec1#"/>
                        <input type="hidden" id="taxAmtBil_input_#trancode#" name="taxAmtBil_input_#trancode#" class="form-control input-sm taxAmtBil_input textAlignRight" disabled="true" value="#getItemList.taxAmt_bil#"/>
                    </td>
                    <td>
                        <input type="text" id="amt_input_#trancode#" name="amt_input_#trancode#" class="form-control input-sm amt_input textAlignRight" value="#getItemList.amt_bil#" disabled="true"/>
                    </td>
                    <td class="td_ten">
                        <span class="glyphicon glyphicon-trash delete_item" id="#trancode#"></span>
                    </td>
                </tr>
			</cfloop>
        </cfoutput>
	<!--- getBillDetails [END] --->
    </cfif>
</cfif>

<!--- cleanXmlString [START] --->
<cffunction name="cleanXmlString" access="public" returntype="any" output="false" hint="Replace non-valid XML characters">
    <cfargument name="dirty" type="string" required="true" hint="Input string">
    <cfset var cleaned = "" />
    <cfset var patterns = "" />
    <cfset var replaces = "" />
    <cfset patterns = chr(8216) & "," & chr(8217) & "," & chr(8220) & "," & chr(8221) & "," & chr(8212) & "," & chr(8213) & "," & chr(8230) />
    <cfset patterns = patterns & "," & chr(1) & "," & chr(2) & "," & chr(3) & "," & chr(4) & "," & chr(5) & "," & chr(6) & "," & chr(7) & "," & chr(8) />
    <cfset patterns = patterns & "," & chr(14) & "," & chr(15) & "," & chr(16) & "," & chr(17) & "," & chr(18) & "," & chr(19) />
    <cfset patterns = patterns & "," & chr(20) & "," & chr(21) & "," & chr(22) & "," & chr(23) & "," & chr(24) & "," & chr(25) />
    <cfset patterns = patterns & "," & chr(26) & "," & chr(27) & "," & chr(28) & "," & chr(29) & "," & chr(30) & "," & chr(31) />
	<cfset replaces = replaces & "',',"","",--,--,..." />
    <cfset replaces = replaces & ",-, , , , , , , " />
    <cfset replaces = replaces & ", , , , , , " />
    <cfset replaces = replaces & ", , , , , , " />
    <cfset replaces = replaces & ", , , , , , " />
	<cfset cleaned = ReplaceList(arguments.dirty, patterns, replaces) />
	<cfreturn cleaned />
</cffunction>
<!--- cleanXmlString [END] --->