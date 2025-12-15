<cfoutput>
    <cftry>
    	<cfquery name="getCurrency" datasource="#dts#" >
            SELECT * 
            FROM #target_currencymonth# 
            WHERE currcode='#trim(url.currcode)#' 
            AND fperiod='#trim(url.periodFrom)#';
        </cfquery>
        
        <cfif getCurrency.recordcount eq 0>
            <cfquery name="insertDayCurrency" datasource='#dts#'>
                INSERT INTO #target_currencymonth# 
                SET 
                    currcode = '#trim(url.currcode)#',
                    fperiod='#trim(url.periodFrom)#';
            </cfquery> 
        </cfif>
        
        <cfquery name="updateDayCurrency" datasource='#dts#'>
			UPDATE #target_currencymonth# 
            SET 
            	<cfloop index="mon" from="1" to="#dayofmonth#">
					<cfset myVal = "url.currD" & mon>
                	<cfset xmyVal = "url.Rem" & mon>
                		currD#mon#='#val(evaluate(myVal))#' 
                	<cfif mon EQ dayofmonth>
                	<cfelse>
                		,
                	</cfif>	
				</cfloop>
			WHERE currcode='#url.currcode#' 
            AND fperiod='#url.periodFrom#';
		</cfquery>
        
    <cfcatch type="any">
        <script type="text/javascript">
            alert('Failed to update !\nError Message: #cfcatch.message#');
            window.open('/latest/generalSetup/currencyTax/editDayCurrency.cfm','_self');
        </script>
    </cfcatch>
    </cftry>
    <script type="text/javascript">
        alert('Updated successfully!');
        window.open('/latest/generalSetup/currencyTax/currencyProfile.cfm','_self');
    </script>	

</cfoutput>