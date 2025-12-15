<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "1864, 1865, 1866, 125, 785, 63, 64, 1867, 1862, 1868, 1863, 1869, 1870, 1871, 1872, 1874, 1875, 1876, 1877, 1878, 1879, 1880, 1881, 1882, 1883, 1884, 1885, 1886, 1887, 1888, 1889, 1890, 1891">
<cfinclude template="/latest/words.cfm">

<cfif IsDefined('url.currcode')>
	<cfset URLcurrcode = trim(urldecode(url.currcode))>
</cfif>

<cfquery name="listCurrency" datasource="#dts#">
    SELECT * 
    FROM main.currency;
</cfquery>

<cfquery name="getGsetup" datasource="#dts#">
	SELECT lastaccyear
	FROM gsetup;
</cfquery>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[1864]#">
		<cfset pageAction="Create">
        <cfset currencyCode = "">
		<cfset currencySymbol = "">
  		<cfset currencyDesp = "">
		<cfset currency2 = "">
        <cfset currRate = "">
        <cfloop index="i" from="1" to="18">
			<cfset 'currP#i#' = "1.000">
        </cfloop>
     	
	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[1865]#">
		<cfset pageAction="Update">
		<cfquery name="getCurrency" datasource='#dts#'>
            SELECT * 
            FROM #target_currency# 
            WHERE currcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcurrcode#">;
		</cfquery>
        
        <cfset currencyCode = getCurrency.currcode>
		<cfset currencySymbol = getCurrency.currency>
		<cfset currencyDesp = getCurrency.currency1>
		<cfset currency2 = getCurrency.currency2>
		<cfset currRate = getCurrency.currRate>
        
        <cfloop index="i" from="1" to="18">
			<cfset 'currP#i#' = evaluate('getCurrency.currP#i#')>
        </cfloop>
         
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="#words[1866]#">
		<cfset pageAction="Delete">   
       <cfquery name="getCurrency" datasource='#dts#'>
            SELECT * 
            FROM #target_currency# 
            WHERE currcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcurrcode#">;
		</cfquery>
        
        <cfset currencyCode = getCurrency.currcode>
		<cfset currencySymbol = getCurrency.currency>
		<cfset currencyDesp = getCurrency.currency1>
		<cfset currency2 = getCurrency.currency2>
		<cfset currRate = getCurrency.currRate>
		
        <cfloop index="i" from="1" to="18">
        	<cfset 'currP#i#' = evaluate('getCurrency.currP#i#')>
        </cfloop>  
                   
	</cfif> 
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="/latest/css/maintenance/target.css">
    <!--[if lt IE 9]>
        <script type="text/javascript" src="/latest/js/html5shiv/html5shiv.js"></script>
        <script type="text/javascript" src="/latest/js/respond/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
    <script>
		$(document).ready(function(e) {	
			$('#currcode').on('change',function(e){
				var selected=$(this).find('option:selected');
				$('#currency').val(selected.data('symbol'));
				$('#currency1').val(selected.data('description'));
			});
		});	
	</script>
</head>

<body class="container">
<cfoutput>
<form class="form-horizontal" role="form" action="/latest/generalSetup/currencyTax/currencyProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('currcode').disabled=false";>
	<div class="page-header">
		<h3>#pageTitle#</h3>
	</div>
		<div class="panel-group">
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##mainInfoCollapse">
						<h4 class="panel-title accordion-toggle">#words[125]#</h4>
					</div>
					<div id="mainInfoCollapse" class="panel-collapse collapse in">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">	
									<div class="form-group">
                                        <label for="currcode" class="col-sm-4 control-label">#words[785]#</label>
                                        <div class="col-sm-4">
                                            <select class="form-control input-sm" id="currcode" name="currcode" <cfif url.action NEQ 'create'>disabled="true"</cfif>>
                                                <option value="">#words[63]#</option>
                                                    <cfloop query="listCurrency">
                                                    <option value="#listCurrency.currcode#" data-symbol="#listCurrency.currency#" data-description="#listCurrency.currency1#" <cfif listCurrency.currcode EQ currencyCode>selected</cfif>>#listCurrency.currcode# - #listCurrency.currency1# </option>
                                                	</cfloop>
                                            </select>
                                        </div>  
                                    </div>	
                                    <div class="form-group">
										<label for="currency" class="col-sm-4 control-label">#words[64]#</label>
										<div class="col-sm-4">
                                            <input type="text" class="form-control input-sm" id="currency" name="currency" value="#currencySymbol#" placeholder="#words[1867]#">
                                        </div>
									</div>
                                    <div class="form-group">
                                        <label for="currency1" class="col-sm-4 control-label">#words[1862]#</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="currency1" name="currency1" value="#currencyDesp#" placeholder="#words[1868]#">
                                        </div>
                                    </div>	
									<div class="form-group">
										<label for="currency2" class="col-sm-4 control-label">#words[1863]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currency2" name="currency2" value="#currency2#" placeholder="#words[1869]#">									
										</div>
									</div>	
									<div class="form-group">
										<label for="desp" class="col-sm-4 control-label">#words[1870]# :</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currRate" name="currRate" value="#currRate#" placeholder="#words[1871]#">									
										</div>
									</div>		                                                                     						
								</div>
							</div>
						</div>
					</div>
				</div>
                	
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##categoryInfoCollapse">
						<h4 class="panel-title accordion-toggle">#words[1872]#</h4>
					</div>
					<div id="categoryInfoCollapse" class="panel-collapse collapse in">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">                      
                                 <div class="form-group">
										<label for="currP01" class="col-sm-4 control-label">
                                        #words[1874]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("00"),DE("01")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP1" name="currP1" value="#currP1#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP02" class="col-sm-4 control-label">
                                        #words[1875]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("01"),DE("02")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP2" name="currP2" value="#currP2#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP03" class="col-sm-4 control-label">
                                        #words[1876]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("02"),DE("03")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP3" name="currP3" value="#currP3#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP04" class="col-sm-4 control-label">
                                        #words[1877]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("03"),DE("04")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP4" name="currP4" value="#currP4#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP05" class="col-sm-4 control-label">
                                        #words[1878]# -#DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("04"),DE("05")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP5" name="currP5" value="#currP5#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP06" class="col-sm-4 control-label">
                                        #words[1879]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("05"),DE("06")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP6" name="currP6" value="#currP6#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP07" class="col-sm-4 control-label">
                                        #words[1880]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("06"),DE("07")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP7" name="currP7" value="#currP7#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP08" class="col-sm-4 control-label">
                                        #words[1881]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("07"),DE("08")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP8" name="currP8" value="#currP8#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP09" class="col-sm-4 control-label">#words[1882]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("08"),DE("09")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP9" name="currP9" value="#currP9#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP10" class="col-sm-4 control-label">
                                        #words[1883]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("09"),DE("10")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP10" name="currP10" value="#currP10#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP11" class="col-sm-4 control-label">
                                        #words[1884]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("10"),DE("11")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP11" name="currP11" value="#currP11#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP12" class="col-sm-4 control-label">
                                        #words[1885]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("11"),DE("12")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP12" name="currP12" value="#currP12#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP13" class="col-sm-4 control-label">
                                        #words[1886]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("12"),DE("13")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP13" name="currP13" value="#currP13#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP14" class="col-sm-4 control-label">
                                        #words[1887]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("13"),DE("14")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP14" name="currP14" value="#currP14#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP15" class="col-sm-4 control-label">
                                        #words[1888]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("14"),DE("15")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP15" name="currP15" value="#currP15#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP16" class="col-sm-4 control-label">
                                        #words[1889]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("15"),DE("16")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP16" name="currP16" value="#currP16#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP17" class="col-sm-4 control-label">
                                        #words[1890]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("16"),DE("17")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP17" name="currP17" value="#currP17#" placeholder="1.0000000000">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="currP18" class="col-sm-4 control-label">
                                        #words[1891]# - #DateFormat(DateAdd('m',IIF(year(DateAdd("d",1,getGsetup.lastaccyear)) EQ year(getGsetup.lastaccyear) AND month(DateAdd("d",1,getGsetup.lastaccyear)) EQ month(getGsetup.lastaccyear),DE("17"),DE("18")),getGsetup.lastaccyear),'mmm yyyy')#
                                        </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="currP18" name="currP18" value="#currP18#" placeholder="1.0000000000">									
										</div>
									</div>
     						
								</div>
							</div>
						</div>
					</div>
				</div>
                
               
            
            <div class="pull-right">
				<input type="submit" value="#pageAction#" class="btn btn-primary"/>
			</div>
</form>
</cfoutput>
</body>
</html>

