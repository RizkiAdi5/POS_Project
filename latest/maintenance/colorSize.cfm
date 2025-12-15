<cfif IsDefined('url.colorNo')>
	<cfset URLcolorNo = trim(urldecode(url.colorNo))>
</cfif>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create ColorSize Profile">
		<cfset pageAction="Create">

		<cfset colorNo = "">
        <cfset colorID = "">    
        <cfset desp = "">   
       	<cfloop index="i" from="1" to="20">
        	<cfset 'size#i#' = "">
        </cfloop> 
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update ColorSize Profile">
		<cfset pageAction="Update">
        
		<cfquery name="getColorSize" datasource='#dts#'>
            SELECT * 
            FROM iccolor2 
            WHERE colorno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcolorNo#">;
		</cfquery>
		
        <cfset colorNo = getColorSize.colorno>
		<cfset colorID = getColorSize.colorid2>
        <cfset desp = getColorSize.desp>
        <cfloop index="i" from="1" to="20">
        	<cfset 'size#i#' = evaluate('getColorSize.size#i#')>
        </cfloop>     
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete ColorSize Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getColorSize" datasource='#dts#'>
            SELECT * 
            FROM iccolor2 
            WHERE colorno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLcolorNo#">;
		</cfquery>
        
       	<cfset colorNo = getColorSize.colorno>
		<cfset colorID = getColorSize.colorid2>
        <cfset desp = getColorSize.desp>
        <cfloop index="i" from="1" to="20">
        	<cfset 'size#i#' = evaluate('getColorSize.size#i#')>
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
<form class="form-horizontal" role="form" action="/latest/maintenance/colorSizeProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('colorNo').disabled=false";>
	<div class="page-header">
		<h3>#pageTitle#</h3>
	</div>
		<div class="panel-group">
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##basicCollapse">
						<h4 class="panel-title accordion-toggle">Main Information</h4>
					</div>
					<div id="basicCollapse" class="panel-collapse collapse in">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">							
									<div class="form-group">
										<label for="colorNo" class="col-sm-4 control-label">Color No</label>
										<div class="col-sm-8">			
											<input type="text" class="form-control input-sm" id="colorNo" name="colorNo" required="yes" placeholder="Color No" maxlength="10" <cfif IsDefined("url.action") AND url.action NEQ "create">value="#URLcolorNo#" disabled="true"</cfif>/>										
										</div>
									</div>	
                                    
                                    <div class="form-group">
										<label for="colorID" class="col-sm-4 control-label">Color ID</label>
										<div class="col-sm-8">			
											<input type="text" class="form-control input-sm" id="colorID" name="colorID" placeholder="Color ID" maxlength="10"/>										
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="desp" class="col-sm-4 control-label">Description</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="desp" name="desp" value="#desp#" placeholder="Description" maxlength="40">									
										</div>
									</div>	                                                                     						
								</div>
							</div>
						</div>
					</div>
				</div>
                	
                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##contactCollapse">
						<h4 class="panel-title accordion-toggle">Other Information</h4>
					</div>
					<div id="contactCollapse" class="panel-collapse collapse in">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">
                                
                                	<cfloop index = "i" from = "1" to = "20">							
                                        <div class="form-group">
                                            <label for="size#i#" class="col-sm-4 control-label">Size #i#</label>
                                            <div class="col-sm-8">	
                                            	<cfset sizeValue = evaluate('size#i#')>	
                                                <input type="text" class="form-control input-sm" id="size#i#" name="size#i#" value="#sizeValue#" placeholder="Size #i#" maxlength="10">										
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
				<input type="button" value="Cancel" onclick="window.location='/latest/maintenance/colorSizeProfile.cfm'" class="btn btn-default" />
			</div>
</form>
</cfoutput>
</body>
</html>