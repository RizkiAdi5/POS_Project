<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "434,95,435,98,125,154,65,400,401,402,403,404,405,406,407,408,409,410,411,412,413
,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,96">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.sizeid')>
	<cfset URLsizeid = trim(urldecode(url.sizeid))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[434]#">
		<cfset pageAction="#words[95]#">
		<cfset size = "">
        <cfset desp = "">    
       	<cfloop index="i" from="1" to="30">
        	<cfset 'size#i#' = "">
        </cfloop> 
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[435]#">
		<cfset pageAction="#words[98]#">
		<cfquery name="getSize" datasource='#dts#'>
            SELECT * 
            FROM icsizeid 
            WHERE sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLsizeid#">;
		</cfquery>
		
		<cfset size = getSize.sizeid>
        <cfset desp = getSize.desp>
        
        <cfloop index="i" from="1" to="30">
        	<cfset 'size#i#' = evaluate('getSize.size#i#')>
        </cfloop>     
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Size Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getSize" datasource='#dts#'>
            SELECT * 
            FROM icsizeid 
            WHERE sizeid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLsizeid#">;
		</cfquery>
		
		<cfset size = getSize.sizeid>
        <cfset desp = getSize.desp>  
        
        <cfloop index="i" from="1" to="30">
        	<cfset 'size#i#' = evaluate('getSize.size#i#')>
        </cfloop>           
	</cfif>
    
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
        
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
    
    <link rel="stylesheet" type="text/css" href="/latest/css/maintenance/target.css">
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.css">
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
    
</head>

<body class="container">
<cfoutput>
<form class="form-horizontal" role="form" action="/latest/maintenance/sizeProcess.cfm?action=#url.action#&menuID=#url.menuID#" method="post" onsubmit="document.getElementById('size').disabled=false";>
	<div class="page-header">
		<h3>#pageTitle#</h3>
	</div>
		<div class="panel-group">
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##basicCollapse">
						<h4 class="panel-title accordion-toggle">#words[125]#</h4>
					</div>
					<div id="basicCollapse" class="panel-collapse collapse in">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">							
									<div class="form-group">
										<label for="size" class="col-sm-4 control-label">#words[154]#</label>
										<div class="col-sm-8">			
											<input type="text" class="form-control input-sm" id="size" name="size" placeholder="#words[154]#" maxlength="25" <cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLsizeid#"  disabled="true"</cfif>/>										
										</div>
									</div>	
                                    
                                    <div class="form-group">
										<label for="desp" class="col-sm-4 control-label">#words[65]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="desp" name="desp" value="#desp#" placeholder="#words[65]#">									
										</div>
									</div>	                                                                     						
								</div>
							</div>
						</div>
					</div>
				</div>
                	
                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##contactCollapse">
						<h4 class="panel-title accordion-toggle">#words[400]#</h4>
					</div>
					<div id="contactCollapse" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
                                
                                	<cfloop index = "i" from = "1" to = "30">							
                                        <div class="form-group">
                                            <label for="size#i#" class="col-sm-4 control-label">#words[i+400]#</label>
                                            <div class="col-sm-8">	
                                            	<cfset sizevalue = evaluate('size#i#')>	
                                                <input type="text" class="form-control input-sm" id="size#i#" name="size#i#" value="#sizevalue#" placeholder="#words[i+400]#" maxlength="25">										
                                            </div>
                                        </div>                                    
                                    </cfloop>                              						
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
            
            <div class="pull-right">
				<input type="submit" value="#pageAction#" class="btn btn-primary"/>
				<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/sizeProfile.cfm?menuID=#url.menuID#'" class="btn btn-default" />
			</div>
</form>
</cfoutput>
</body>
</html>