<cfquery name="getCurrency" datasource='#dts#'>
    SELECT * FROM #target_currency# where currcode='#url.currcode#'
</cfquery>

<cfquery name="currEdit" datasource='#dts#'>
	SELECT * 
    FROM #target_currencymonth# 
    WHERE currcode='#url.currcode#' 
    AND fperiod='#NumberFormat(url.period,'00')#';
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
	SELECT period,LastAccYear 
    FROM gsetup;
</cfquery>
<cfset c_Period = getgsetup.Period>
<cfset realperiod=val(url.period)>
<cfset currcode='#getCurrency.currcode#'>
<cfset currency='#getCurrency.Currency#'>
<cfset CurrDollar='#getCurrency.Currency1#'>
<cfset CurrCent='#getCurrency.Currency2#'>

<cfif currEdit.recordcount neq 0>
    <cfloop index="i" from="1" to="31">
        <cfif evaluate('currEdit.currD#i#') EQ 0>
            <cfset 'currD#i#' = ''>
        <cfelse>
            <cfset 'currD#i#' = evaluate('currEdit.currD#i#')>
        </cfif>  
    </cfloop>				
<cfelse>
	<cfloop index="i" from="1" to="31">
    	<cfset 'currD#i#' = evaluate('getCurrency.CURRP#realperiod#')>
    </cfloop>
</cfif>	

<cfoutput>
    <div class="form-group">
        <cfset periodValue = "##periodNo">
        <cfset getMonth = DateAdd("M",#url.period#,getgsetup.lastAccYear)>
        <cfset getYear = DateFormat(DateAdd("M",#url.period#,getgsetup.lastAccYear),'YYYY')>
        <input type="hidden" name="dayofmonth" value="#DaysInMonth(getMonth)#">
        <cfloop index="mon" from="1" to="#DaysInMonth(getMonth)#">	
            <div class="col-sm-6">
                <label class="col-sm-4 control-label">
                    #NumberFormat(mon,'00')##DateFormat(getMonth,'/mm/')##getYear# 
                    <cfset thisdate ="#NumberFormat(mon,'00')#"&"#DateFormat(getMonth,'/mm/')##getYear#">
                </label>
                <cfset myVal = "currD" & mon>
                <cfif evaluate(myVal) eq ''>
                    <cfset myval2 = ''>
                <cfelse>
                    <cfset myval2 = NumberFormat(evaluate(myVal),'.____')>
                </cfif>
                <input type="text" name="#myVal#" id="#myVal#" value="#myval2#">
			</div>  
        </cfloop>
    </div>             
</cfoutput>