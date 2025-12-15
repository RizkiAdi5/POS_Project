<cfcomponent>
	<cffunction name="update_icitem_qtyactual">
		<cfargument name="dts" required="yes" type="any">
		<cfargument name="form" required="yes" type="struct">
        <cfargument name="huserid" required="yes" type="any">
		<cfparam name="tranoai" default="">
		<cfparam name="tranoar" default="">
		<cfparam name="oaisql" default="">
		<cfparam name="oarsql" default="">
		<cfparam name="oaitotal" default=0>
		<cfparam name="oartotal" default=0>
		
		<cfquery name="get_running_no" datasource="#arguments.dts#">
			select lastusedno as oaino,(select lastusedno as oaino from refnoset where counter = "1" and type = "OAR") as oarno from refnoset where counter = "1" and type = "OAI"   
		</cfquery>
		
		 <cfset refnocheck = 0>
		<cfset refno1 = get_running_no.oaino>
        <cfloop condition="refnocheck eq 0">
        <cftry>
        <cfinvoke component="cfc.incrementValue" method="getIncreament" returnvariable="nexttranno1">
			<cfinvokeargument name="input" value="#refno1#">
		</cfinvoke>
		<cfcatch>
		<cfinvoke component="cfc.refno" method="processNum" oldNum="#get_running_no.oaino#" returnvariable="nexttranno1" />	
		</cfcatch>
        </cftry>
        <cfquery name="checkexistence" datasource="#dts#">
        SELECT refno FROM artran WHERE 
        refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nexttranno1#"> and type = 'OAI'
        </cfquery>
        <cfif checkexistence.recordcount eq 0>
        <cfset refnocheck = 1>
        <cfelse>
        <cfset refno1 = nexttranno1>
		</cfif>
        </cfloop>
        
		
		<cfset refnocheck2 = 0>
		<cfset refno2 = get_running_no.oarno>
        <cfloop condition="refnocheck2 eq 0">
        <cftry>
       <cfinvoke component="cfc.incrementValue" method="getIncreament" returnvariable="nexttranno2">
			<cfinvokeargument name="input" value="#refno2#">
		</cfinvoke>
		<cfcatch>
		<cfinvoke component="cfc.refno" method="processNum" oldNum="#get_running_no.oarno#" returnvariable="nexttranno2" />	
		</cfcatch>
        </cftry>
        <cfquery name="checkexistence" datasource="#dts#">
        SELECT refno FROM artran WHERE 
        refno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nexttranno2#"> and type = 'OAR'
        </cfquery>
        <cfif checkexistence.recordcount eq 0>
        <cfset refnocheck2 = 1>
        <cfelse>
        <cfset refno2 = nexttranno2>
		</cfif>
        </cfloop>
		
        <cfquery name="getlocadj" datasource="#dts#">
        select * from locadj where uuid='#form.uuid#' and refno='#form.refno#'
        </cfquery>
        
        <cfset a=1>
        
        
			<cfloop query="getlocadj">
				<cfquery name="update_icitem" datasource="#arguments.dts#">
					update icitem set 
					qtyactual='#val(getlocadj.qtyactual)#'
					
					<cfif val(getlocadj.qtyonhand) lt val(getlocadj.qtyactual)>
						,qin#val(getlocadj.period)+10#=(qin#val(getlocadj.period)+10#+#abs(val(getlocadj.qtydiff))#)
						<cfset tranoai = "y">
						<cfset oaiqty = abs(getlocadj.qtydiff)>
						<cfset oaicost = getlocadj.ucost>
						<cfset oaisubtotal = oaiqty * oaicost>
						<cfset oaitotal = oaitotal + oaisubtotal>
						<cfset oaisql= oaisql&"("&chr(34)&"OAI"&chr(34)&","&chr(34)&nexttranno1&chr(34)&","&chr(34)&a&chr(34)&","&chr(34)&getlocadj.period&chr(34)&","&chr(34)&lsdateformat(getlocadj.date,"yyyy-mm-dd")&chr(34)&","&chr(34)&"1"&chr(34)&","&chr(34)&a&chr(34)&","&chr(34)&jsstringformat(getlocadj.itemno)&chr(34)&","&chr(34)&jsstringformat(getlocadj.desp)&chr(34)&","&chr(34)&jsstringformat(getlocadj.unit)&chr(34)&","&chr(34)&oaiqty&chr(34)&","&chr(34)&oaicost&chr(34)&","&chr(34)&oaisubtotal&chr(34)&","&chr(34)&oaisubtotal&chr(34)&","&chr(34)&oaiqty&chr(34)&","&chr(34)&oaicost&chr(34)&","&chr(34)&oaisubtotal&chr(34)&","&chr(34)&oaisubtotal&chr(34)&","&chr(34)&"ADJUSTMENT"&chr(34)&")"&iif(a neq getlocadj.recordcount,DE(","),DE(""))>
					<cfelseif val(getlocadj.qtyonhand) gt val(getlocadj.qtyactual)>
						,qout#val(getlocadj.period)+10#=(qout#val(getlocadj.period)+10#+#abs(val(getlocadj.qtydiff))#)
						<cfset tranoar = "y">
						<cfset oarqty = abs(getlocadj.qtydiff)>
						<cfset oarcost = getlocadj.ucost>
						<cfset oarsubtotal = oarqty * oarcost>
						<cfset oartotal = oartotal + oarsubtotal>
						<cfset oarsql= oarsql&"("&chr(34)&"OAR"&chr(34)&","&chr(34)&nexttranno2&chr(34)&","&chr(34)&a&chr(34)&","&chr(34)&getlocadj.period&chr(34)&","&chr(34)&lsdateformat(getlocadj.date,"yyyy-mm-dd")&chr(34)&","&chr(34)&"1"&chr(34)&","&chr(34)&a&chr(34)&","&chr(34)&jsstringformat(getlocadj.itemno)&chr(34)&","&chr(34)&jsstringformat(getlocadj.desp)&chr(34)&","&chr(34)&jsstringformat(getlocadj.unit)&chr(34)&","&chr(34)&oarqty&chr(34)&","&chr(34)&oarcost&chr(34)&","&chr(34)&oarsubtotal&chr(34)&","&chr(34)&oarsubtotal&chr(34)&","&chr(34)&oarqty&chr(34)&","&chr(34)&oarcost&chr(34)&","&chr(34)&oarsubtotal&chr(34)&","&chr(34)&oarsubtotal&chr(34)&","&chr(34)&"ADJUSTMENT"&chr(34)&")"&iif(a neq getlocadj.recordcount,DE(","),DE(""))>
					</cfif> 
					where itemno='#jsstringformat(getlocadj.itemno)#';
				</cfquery>
                <cfset a=a+1>
			</cfloop>



			<cfif tranoai eq "y">
				<cfquery name="update_oai_running_no" datasource="#arguments.dts#">
					update refnoset set
					lastusedno='#nexttranno1#'
                    WHERE type = "OAI" and counter = "1";
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
                        userid,
                        custno,
                        trdatetime
					)
					values
					(
						'OAI',
						'#nexttranno1#',
						'1',
						'#getlocadj.period#',
						'#lsdateformat(getlocadj.date,"yyyy-mm-dd")#',
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
                        '#arguments.huserid#',
                        '#arguments.huserid#',
                        now()
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
						name
					) 
					values 
					#oaisql#;
				</cfquery>
                <cfquery name="update_ictran" datasource="#arguments.dts#">
                update ictran set trdatetime=now() where type='OAI' and refno='#nexttranno1#'
                </cfquery>
			</cfif>
			
			<cfif tranoar eq "y">
				<cfquery name="update_oar_running_no" datasource="#arguments.dts#">
					update refnoset SET
					lastusedno='#nexttranno2#'
                    WHERE type = "OAR" and counter = "1"
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
						name,
                        userid,
                        custno,
                        trdatetime
					)
					values
					(
						'OAR',
						'#nexttranno2#',
						'1',
						'#getlocadj.period#',
						'#lsdateformat(getlocadj.date,"yyyy-mm-dd")#',
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
						'ADJUSTMENT',
                        '#arguments.huserid#',
                        '#arguments.huserid#',
                        now()
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
						name
					) 
					values 
					#oarsql#;
				</cfquery>
                <cfquery name="update_ictran" datasource="#arguments.dts#">
                update ictran set trdatetime=now() where type='OAR' and refno='#nexttranno2#'
                </cfquery>
			</cfif>
	</cffunction>
</cfcomponent>