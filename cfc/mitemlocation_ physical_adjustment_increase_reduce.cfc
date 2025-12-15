<cfcomponent>
	<cffunction name="update_icitem_qtyactual">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
		<cfparam name="tranoai" default="">
		<cfparam name="tranoar" default="">
		<cfparam name="oaisql" default="">
		<cfparam name="oarsql" default="">
		<cfparam name="oaitotal" default=0>
		<cfparam name="oartotal" default=0>
		
		<cfquery name="get_running_no" datasource="#arguments.dts#">
			select oaino,oaino2,oaicode,oarno,oarno2,oarcode 
			from gsetup;
		</cfquery>
		
		<cfinvoke component="cfc.incrementValue" method="getIncreament" returnvariable="nexttranno1">
			<cfinvokeargument name="input" value="#get_running_no.oaino#">
		</cfinvoke>
		
		<cfinvoke component="cfc.incrementValue" method="getIncreament" returnvariable="nexttranno2">
			<cfinvokeargument name="input" value="#get_running_no.oarno#">
		</cfinvoke>
		
		<cfif form.update_actual_qty eq "yes">
			<cfloop index="a" from="1" to="#form.totalitem#">
            <cfquery name="checkexist" datasource="#arguments.dts#">
            select * from locqdbf where itemno='#jsstringformat(evaluate("form.itemno#a#"))#' and location='#jsstringformat(evaluate("form.location#a#"))#'
            </cfquery>
            <cfif checkexist.recordcount eq 0>
            <cfquery name="insertlocqdbf" datasource="#arguments.dts#">
            insert into locqdbf (itemno,location,locqfield,locqactual,locqtran,lminimum,lreorder,qty_bal,val_bal,price,wos_group,category,shelf,supp) values ('#jsstringformat(evaluate("form.itemno#a#"))#','#jsstringformat(evaluate("form.location#a#"))#',0,0,0,0,0,0,0,0,'','','','')
            </cfquery>
            </cfif>
				<cfquery name="update_icitem" datasource="#arguments.dts#">
					update icitem,locqdbf set 
					locqdbf.locqactual='#evaluate("form.actualqty#a#")#'
					
					<cfif val(evaluate("form.balance#a#")) lt val(evaluate("form.actualqty#a#"))>
						,icitem.qin#val(form.period)+10#=(icitem.qin#val(form.period)+10#+#abs(evaluate("form.adjqty#a#"))#)
						<cfset tranoai = "y">
						<cfset oaiqty = abs(evaluate("form.adjqty#a#"))>
						<cfset oaicost = evaluate("form.ucost#a#")>
						<cfset oaisubtotal = oaiqty * oaicost>
						<cfset oaitotal = oaitotal + oaisubtotal>
						<cfset oaisql= oaisql&"("&chr(34)&"OAI"&chr(34)&","&chr(34)&nexttranno1&chr(34)&","&chr(34)&a&chr(34)&","&chr(34)&form.period&chr(34)&","&chr(34)&lsdateformat(form.target_date,"yyyy-mm-dd")&chr(34)&","&chr(34)&"1"&chr(34)&","&chr(34)&a&chr(34)&","&chr(34)&jsstringformat(evaluate("form.itemno#a#"))&chr(34)&","&chr(34)&jsstringformat(evaluate("form.desp#a#"))&chr(34)&","&chr(34)&jsstringformat(evaluate("form.unit#a#"))&chr(34)&","&chr(34)&oaiqty&chr(34)&","&chr(34)&oaicost&chr(34)&","&chr(34)&oaisubtotal&chr(34)&","&chr(34)&oaisubtotal&chr(34)&","&chr(34)&oaiqty&chr(34)&","&chr(34)&oaicost&chr(34)&","&chr(34)&oaisubtotal&chr(34)&","&chr(34)&oaisubtotal&chr(34)&","&chr(34)&"ADJUSTMENT"&chr(34)&","&chr(34)&jsstringformat(evaluate("form.location#a#"))&chr(34)&")"&iif(a neq form.totalitem,DE(","),DE(""))>
					<cfelseif val(evaluate("form.balance#a#")) gt val(evaluate("form.actualqty#a#"))>
						,icitem.qout#val(form.period)+10#=(icitem.qout#val(form.period)+10#+#abs(evaluate("form.adjqty#a#"))#)
						<cfset tranoar = "y">
						<cfset oarqty = abs(evaluate("form.adjqty#a#"))>
						<cfset oarcost = evaluate("form.ucost#a#")>
						<cfset oarsubtotal = oarqty * oarcost>
						<cfset oartotal = oartotal + oarsubtotal>
						<cfset oarsql= oarsql&"("&chr(34)&"OAR"&chr(34)&","&chr(34)&nexttranno2&chr(34)&","&chr(34)&a&chr(34)&","&chr(34)&form.period&chr(34)&","&chr(34)&lsdateformat(form.target_date,"yyyy-mm-dd")&chr(34)&","&chr(34)&"1"&chr(34)&","&chr(34)&a&chr(34)&","&chr(34)&jsstringformat(evaluate("form.itemno#a#"))&chr(34)&","&chr(34)&jsstringformat(evaluate("form.desp#a#"))&chr(34)&","&chr(34)&jsstringformat(evaluate("form.unit#a#"))&chr(34)&","&chr(34)&oarqty&chr(34)&","&chr(34)&oarcost&chr(34)&","&chr(34)&oarsubtotal&chr(34)&","&chr(34)&oarsubtotal&chr(34)&","&chr(34)&oarqty&chr(34)&","&chr(34)&oarcost&chr(34)&","&chr(34)&oarsubtotal&chr(34)&","&chr(34)&oarsubtotal&chr(34)&","&chr(34)&"ADJUSTMENT"&chr(34)&","&chr(34)&jsstringformat(evaluate("form.location#a#"))&chr(34)&")"&iif(a neq form.totalitem,DE(","),DE(""))>
					</cfif> 
					where locqdbf.itemno='#jsstringformat(evaluate("form.itemno#a#"))#'
					and locqdbf.itemno=icitem.itemno
					and locqdbf.location='#jsstringformat(evaluate("form.location#a#"))#';
				</cfquery>
			</cfloop>
		</cfif>

		<cfif form.update_actual_qty eq "yes" and form.generate_adjustment_transaction eq "yes">
			<cfif tranoai eq "y">
				<cfquery name="update_oai_running_no" datasource="#arguments.dts#">
					update gsetup set
					oaino='#nexttranno1#'
				</cfquery>
				
				<cfif right(oaisql,1) eq ",">
					<cfset oaisql = removechars(oaisql,len(oaisql),1)>
				<cfelse>
					<cfset oaisql = oaisql>
				</cfif>
				
				<!--- <cfset oaisql = iif((right(oaisql,1) eq ","),DE(removechars(oaisql,len(oaisql),1)),DE(oaisql))> --->
				
				<cfquery name="insert_oai_into_artran" datasource="#arguments.dts#">
					insert ignore into artran 
					(
						type,
						refno,
						trancode,
						fperiod,
						wos_date,
						desp,
						currrate,
						gross_bil,
						net_bil,
						grand_bil,
						credit_bil,
						invgross,
						net,
						grand,
						creditamt,
						currrate2,
						name,
                        created_on,
                        created_by,
                        userid
					)
					values
					(
						'OAI',
						'#nexttranno1#',
						'1',
						'#form.period#',
						'#lsdateformat(form.target_date,"yyyy-mm-dd")#',
						'ADJUSTMENT',
						'1',
						'#oaitotal#',
						'#oaitotal#',
						'#oaitotal#',
						'#oaitotal#',
						'#oaitotal#',
						'#oaitotal#',
						'#oaitotal#',
						'#oaitotal#',
						'1',
						'ADJUSTMENT',
                        now(),
                        '#form.huserid#',
                        '#form.huserid#'
					);
				</cfquery>
				
				<cfquery name="insert_oai_into_ictran" datasource="#arguments.dts#">
					insert ignore into ictran 
					(
						type,
						refno,
						trancode,
						fperiod,
						wos_date,
						currrate,
						itemcount,
						itemno,
						desp,
						unit,
						qty_bil,
						price_bil,
						amt1_bil,
						amt_bil,
						qty,
						price,
						amt1,
						amt,
						name,
						location
					) 
					values 
					#oaisql#;
				</cfquery>
			</cfif>
			
			<cfif tranoar eq "y">
				<cfquery name="update_oar_running_no" datasource="#arguments.dts#">
					update gsetup set
					oarno='#nexttranno2#'
				</cfquery>
				
				<cfif right(oarsql,1) eq ",">
					<cfset oarsql = removechars(oarsql,len(oarsql),1)>
				<cfelse>
					<cfset oarsql = oarsql>
				</cfif>
				
				<!--- <cfset oarsql = iif((right(oarsql,1) eq ","),DE(removechars(oarsql,len(oarsql),1)),DE(oarsql))> --->
				
				<cfquery name="insert_oar_into_artran" datasource="#arguments.dts#">
					insert ignore into artran 
					(
						type,
						refno,
						trancode,
						fperiod,
						wos_date,
						desp,
						currrate,
						gross_bil,
						net_bil,
						grand_bil,
						debit_bil,
						invgross,
						net,
						grand,
						debitamt,
						currrate2,
						name
					)
					values
					(
						'OAR',
						'#nexttranno2#',
						'1',
						'#form.period#',
						'#lsdateformat(form.target_date,"yyyy-mm-dd")#',
						'ADJUSTMENT',
						'1',
						'#oartotal#',
						'#oartotal#',
						'#oartotal#',
						'#oartotal#',
						'#oartotal#',
						'#oartotal#',
						'#oartotal#',
						'#oartotal#',
						'1',
						'ADJUSTMENT'
					);
				</cfquery>
				
				<cfquery name="insert_oar_into_ictran" datasource="#arguments.dts#">
					insert ignore into ictran 
					(
						type,
						refno,
						trancode,
						fperiod,
						wos_date,
						currrate,
						itemcount,
						itemno,
						desp,
						unit,
						qty_bil,
						price_bil,
						amt1_bil,
						amt_bil,
						qty,
						price,
						amt1,
						amt,
						name,
						location
					) 
					values 
					#oarsql#;
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>