<cfquery name="getCurrency" datasource='#dts#'>
    SELECT * 
    FROM #target_currency#;
</cfquery>

<cfquery name="currEdit" datasource='#dts#'>
	SELECT * 
    FROM #target_currencymonth#;
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
	SELECT period,LastAccYear 
    FROM gsetup;
</cfquery>
<cfset c_Period = getgsetup.Period>
<cfset realperiod=1>
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

<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>

<script>
	$(document).ready(function(){
		$('#currcode').change(function(){
			if($('#currcode').val() == ''){
				$('#showPeriod').fadeOut('slow');		
				$('#showDate').fadeOut('slow');	
			}
			else{
				$('#showPeriod').fadeIn('slow');
			}
		});
	});
	
	$(document).ready(function(){
		$('#periodFrom').change(function(){
			if($('#periodFrom').val() == ''){
				$('#showDate').fadeOut('slow');	
			}
			else{
				$('#showDate').fadeIn('slow');
				ajaxFunction(document.getElementById('showDate'),'editdayajax.cfm?period='+$('#periodFrom').val()+'&currcode='+$('#currcode').val())
			}
		});
	});
	<!--- $(window).unload(function(){
		$('#currcode').trigger("reset");
		$('#periodFrom').trigger("reset");
	}); --->
</script>

<cfoutput>
    <div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form id="myForm" name="myForm" class="form-horizontal" role="form" action="editDayCurrencyProcess.cfm">
					<div class="modal-header">
						<h4 id="formModalTitle" class="modal-title">#words[1861]#</h4>
					</div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">#words[785]#</label>
                            <div class="col-sm-6">
                                <select class="form-control input-sm" id="currcode" name="currcode">
                                    <option value="">#words[63]#</option>
                                        <cfloop query="getCurrency">
                                            <option value="#getCurrency.currcode#">#getCurrency.currcode# - #getCurrency.currency1# </option>
                                        </cfloop>
                                </select>
                            </div>
                        </div>
                        
                        <div id="showPeriod" class="showPeriod" style="display:none;">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Period</label>
                                <div class="col-sm-6">
                                    <select class="form-control input-sm" id="periodFrom" name="periodFrom" Onchange="tf_fperiodfromDesp.value = this.options[this.selectedIndex].title;">
                                        <option value="">Choose a Period</option>
                                          <cfloop index="fCurrMonth" from="1" to="#c_Period#">
                                              <cfset fccurr = DateAdd('m', fCurrMonth, "#getgsetup.LastAccYear#")>
                                              <cfset fdmont = DateFormat(fccurr,"mm")>
                                              <cfset fdmont2 = DateFormat(fccurr,"mmmm ''yyyy")>
                                              <option title="#fdmont2#" value="#NumberFormat(fCurrMonth,'00')#">#fCurrMonth# - #DateFormat(fccurr,"mmm'yyyy")#</option>
                                          </cfloop>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div id="showDate" class="showDate" style="display:none;">
                            <div class="form-group">
                            	<cfset periodValue = "##periodNo">
                                <cfset getMonth = DateAdd("M",1,getgsetup.lastAccYear)>
                                <cfset getYear = DateFormat(DateAdd("M",1,getgsetup.lastAccYear),'YYYY')>
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
                                            <cfset myval2 = numberformat(evaluate(myVal),'.____')>
                                        </cfif>
                                        <input type="text" name="#myVal#" id="#myVal#" value="#myval2#">
                                    </div>
                                </cfloop>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                    	<input type="submit" name="submit" value="Update" class="btn btn-default" />
<!--- 						<button id="submit" type="button" class="btn btn-default">Submit</button> --->
					</div>
                </form>
            </div>
        </div>
    </div>
</cfoutput>