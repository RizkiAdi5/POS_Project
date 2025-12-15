<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "515,95,547,98,125,29,65,144,7,45,516,517,518,519,548,520,549,550,521,96,551,523">
<cfinclude template="/latest/words.cfm">
<cfif IsDefined('url.agent')>
	<cfset URLagent = trim(urldecode(url.agent))>
</cfif>

<cfquery name="getUserID" datasource="main">
    SELECT userID 
    FROM users 
    WHERE userbranch='#dts#' 
    AND usergrpid <> "SUPER" 
    ORDER BY usergrpid;
</cfquery>
<cfset agentlist = valuelist(getUserID.userid,",")>

<cfquery name="getTeam" datasource="#dts#">
  SELECT team,desp 
  FROm icteam;
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
  SELECT lagent
  FROm gsetup;
</cfquery>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="#words[515]#">
		<cfset pageAction="#words[95]#">
		<cfset agent = "">
        <cfset desp = "">
        <cfset commision = "">
        <cfset contact = "">
        <cfset email = "">
        <cfset designation = "">   
        <cfset discontinueAgent = "">
        <cfset teamValue = "">
        <cfset agentID = "">
        <cfset photo = "">  
        <cfset agentlistID = "">
        
         <cfquery name="getAgentID" datasource="main">
            SELECT userID 
            FROM users 
            WHERE userbranch='#dts#' 
            AND userID NOT IN (SELECT agentID 
                               FROM #target_icagent# 
                               WHERE agentID !='' 
                               AND agentID IS NOT NULL 
                               AND agent !='#agent#') 
            AND usergrpid <> "SUPER" 
            ORDER BY userID;
        </cfquery>
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="#words[547]#">
		<cfset pageAction="#words[98]#">
		<cfquery name="getAgent" datasource='#dts#'>
            SELECT * 
            FROM #target_icagent# 
            WHERE agent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLagent#">;
		</cfquery>
		
		<cfset agent = getAgent.agent>
        <cfset desp = getAgent.desp>
        <cfset commision = getAgent.commsion1>
        <cfset contact = getAgent.hp>
        <cfset email = getAgent.email>
        <cfset designation = getAgent.designation>   
        <cfset discontinueAgent = getAgent.discontinueagent>
        <cfset teamValue = getAgent.team>
        <cfset agentID = getAgent.agentID>
        <cfset photo = getAgent.photo>
        <cfset agentlistID = getAgent.agentlist>
        
        <cfquery name="getAgentID" datasource="main">
            SELECT userID 
            FROM users 
            WHERE userbranch='#dts#' 
            AND userID NOT IN (SELECT agentID 
                               FROM #target_icagent# 
                               WHERE agentID !='' 
                               AND agentID IS NOT NULL 
                               AND agent !='#agent#') 
            AND usergrpid <> "SUPER" 
            ORDER BY userID;
        </cfquery>
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Agent Profile">
		<cfset pageAction="Delete">   
        
        <cfquery name="getAgent" datasource='#dts#'>
            SELECT * 
            FROM #target_icagent# 
            WHERE agent=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLagent#">;
		</cfquery>
		
		<cfset agent = getAgent.agent>
        <cfset desp = getAgent.desp>
        <cfset commision = getAgent.commsion1>
        <cfset contact = getAgent.hp>
        <cfset email = getAgent.email>
        <cfset designation = getAgent.designation>   
        <cfset discontinueAgent = getAgent.discontinueagent>
        <cfset teamValue = getAgent.team>
        <cfset agentID = getAgent.agentID>
        <cfset photo = getAgent.photo>  
        <cfset agentlistID = getAgent.agentlist>  
        
        <cfquery name="getAgentID" datasource="main">
            SELECT userID 
            FROM users 
            WHERE userbranch='#dts#' 
            AND userID NOT IN (SELECT agentID 
                               FROM #target_icagent# 
                               WHERE agentID !='' 
                               AND agentID IS NOT NULL 
                               AND agent !='#agent#') 
            AND usergrpid <> "SUPER" 
            ORDER BY userID;
        </cfquery>         
	</cfif>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
    
    <link rel="stylesheet" type="text/css" href="/latest/css/maintenance/target.css">
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.css">
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
    
    <script language="JavaScript">
	
		function add_option(pic_name)
		{
			var agree = confirm("Are You Sure ?");
			if (agree==true)
			{
				var detection=0;
				var totaloption=document.getElementById("picture_available").length-1;
	
				for(var i=0;i<=totaloption;++i)
				{
					if(document.getElementById("picture_available").options[i].value==pic_name)
					{
						detection=1;
						break;
					}
				}
				
				if(detection!=1)
				{
					var a=new Option(pic_name,pic_name);
					document.getElementById("picture_available").options[document.getElementById("picture_available").length]=a;
				}
				document.getElementById("picture_available").value=pic_name;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		function change_picture(picture)
		{
			var encode_picture = encodeURI(picture);
			show_picture.location="/latest/uploadImage/icagent_image.cfm?pic3="+encode_picture;
		}
		
		function delete_picture(picture)
		{
		var answer =confirm("Are you sure want to delete picture "+picture);
		if (answer)
		{
			var encode_picture = encodeURI(picture);
			show_picture.location="/latest/uploadImage/icagent_image.cfm?delete=true&picture="+encode_picture;
			var elSel = document.getElementById('picture_available');
			  var i;
			  for (i = elSel.length - 1; i>=0; i--) {
				if (elSel.options[i].selected) {
				  elSel.remove(i);
				}
			  }
		}
		
		}
		
		function showpic(picname)
			{
			return hs.expand(picname)
			}
			
		function uploading_picture(pic_name)
		{
			var new_pic_name1 = new String(pic_name);
			var new_pic_name2 = new_pic_name1.split(/[-,/,\\]/g);
			document.getElementById("picture_name").value=new_pic_name2[new_pic_name2.length-1];
		}


	</script>
</head>

<body class="container">
<cfoutput>
<form name="form1" id="form1" class="form-horizontal" role="form" action="/latest/maintenance/agentProcess.cfm?action=#url.action#" method="post">
	<div class="page-header">
		<h3>#pageTitle#</h3>
	</div>
		<div class="panel-group">
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##firstPanel">
						<h4 class="panel-title accordion-toggle">#words[125]#</h4>
					</div>
					<div id="firstPanel" class="panel-collapse collapse in">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">							
									<div class="form-group">
										<label for="agent" class="col-sm-4 control-label"><!---#getgsetup.lagent#---> #words[29]#</label>
										<div class="col-sm-8">			
											<input type="text" class="form-control input-sm" id="agent" name="agent" placeholder="#words[29]#" required="yes" maxlength="20" <cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLagent#"  disabled="true"</cfif>/>												
										</div>
									</div>	
                                    <div class="form-group">
										<label for="desp" class="col-sm-4 control-label"><cfif lcase(hcomid) eq "keminates_i">Facebook<cfelse>#words[65]#</cfif></label>
										<div class="col-sm-8">
                                        <cfif lcase(hcomid) eq "keminates_i">
                                        	<input type="text" class="form-control input-sm" id="desp" name="desp" value="#desp#" placeholder="Facebook" required="yes" maxlength="40">	
                                        <cfelse>
											<input type="text" class="form-control input-sm" id="desp" name="desp" value="#desp#" placeholder="#words[65]#" maxlength="40">									
										</cfif>
                                        </div>
									</div>
                                    <div class="form-group">
										<label for="commision" class="col-sm-4 control-label">#words[144]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="commision" name="commision" value="#commision#" placeholder="#words[144]#">									
										</div>
									</div>
                                    <div class="form-group">
										<label for="contact" class="col-sm-4 control-label">#words[7]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="contact" name="contact" value="#contact#" placeholder="#words[7]#">									
										</div>
									</div>
                                    <div class="form-group">
										<label for="email" class="col-sm-4 control-label">#words[45]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="email" name="email" value="#email#" placeholder="#words[45]#">									
                                        </div>
									</div>
                                    <div class="form-group">
										<label for="designation" class="col-sm-4 control-label">#words[516]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="designation" name="designation" value="#designation#" placeholder="#words[516]#">
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="teamValue" class="col-sm-4 control-label">#words[517]#</label>
										<div class="col-sm-8">
											<select name="teamValue" id="teamValue" class="form-control input-sm">
                                                <option value="">#words[518]#</option>
                                                <cfloop query="getTeam">
                                                	<option value="#getTeam.team#" #IIF(team eq teamValue,DE('selected'),DE(''))#>#getTeam.team#</option>
                                                </cfloop>
                                            </select>									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="agentID" class="col-sm-4 control-label"><!---#getgsetup.lagent# ID---> #words[519]#</label>
										<div class="col-sm-8">
											<select name="agentID" id="agentID" class="form-control input-sm">
                                                <option value="">#words[548]#</option>
                                                <cfloop query="getAgentID">
                                                	<option value="#getAgentID.userid#" #IIF(userid eq agentID,DE('selected'),DE(''))#>#getAgentID.userid#</option>
                                                </cfloop>
                                            </select>									
										</div>
									</div>

                                    <div class="form-group">
										<label for="sign" class="col-sm-4 control-label">#words[520]#</label>
										<div class="col-sm-8">
											<cfdirectory action="list" directory="#HRootPath#\billformat\#hcomid#\" name="picture_list">
                                            <select name="picture_available" id="picture_available" class="form-control input-sm" onChange="javascript:change_picture(this.value);">
                                                <option value="">#words[549]#</option>
                                                <cfloop query="picture_list">
                                                    <cfif picture_list.name neq "Thumbs.db" and (right(picture_list.name,3) eq "jpg" or right(picture_list.name,3) eq "png" or right(picture_list.name,3) eq "bmp")>
                                                        <option value="#picture_list.name#" #iif((photo eq picture_list.name),DE("selected"),DE(""))#>#picture_list.name#</option>
                                                    </cfif>
                                                </cfloop>
                                            </select>
                                            <div style="float:right; margin:25px;">	
                                            	<iframe id="show_picture" name="show_picture" frameborder="0" marginheight="0" marginwidth="0" align="middle" height="150" width="150" scrolling="no" src="/latest/uploadImage/icagent_image.cfm?pic3=#urlencodedformat(photo)#"></iframe>		
                                            </div>		
										</div>
									</div>	 
                                    
                                    <cfif IsDefined('url.action') AND url.action NEQ "create">
                                        <div class="form-group">
                                            <label for="discontinueAgent" class="col-sm-4 control-label"><!---Discontinue #getgsetup.lagent#---> #words[550]#</label>
                                            <div class="col-sm-8">
                                                <div class="row">
                                                    <div class="col-sm-7">
                                                        <div class="checkbox">	
                                                            <input type="checkbox" value="0" id="discontinueAgent" name="discontinueAgent" <cfif discontinueAgent eq 'Y'>checked</cfif>>
                                                        </div>													
                                                    </div>
                                                </div>											
                                            </div>
                                        </div>   
                                    </cfif>                                                                 						
								</div>
							</div> 
						</div>
					</div>
				</div>
                	
                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##secondPanel">
						<h4 class="panel-title accordion-toggle"><!---View/Select #getgsetup.lagent#---> #words[521]#</h4>
					</div>
					<div id="secondPanel" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">                               
                                	<table cellpadding="5">
										<cfset j=1>
                                        <cfloop index="i" list="#agentlist#" delimiters="," >
                                            
                                            <cfif j%4 eq 1>
                                                <tr>
                                            </cfif>
                                            
                                            <td nowrap="nowrap" align="left">
                                                <cfquery name="getUserGroup" datasource="main">
                                                    SELECT usergrpid 
                                                    FROM users 
                                                    WHERE userbranch='#dts#' 
                                                    AND usergrpid <> "SUPER" 
                                                    AND userID="#i#";
                                                </cfquery>
                                                                    
                                                <div class="form-group">
                                                    <div class="col-sm-8">	
                                                         <input type="checkbox" name="agentlist" id="agentlist" value="#i#" <cfif ListFindNoCase('#agentlistID#','#i#',',') neq 0>checked</cfif>  /> #i# - #getUserGroup.usergrpid#										
                                                    </div>
                                                </div>
                                            </td>
                                            
                                            <cfif j%4 eq 0>
                                                </tr>
                                            </cfif>
                                            
                                            <cfset j = j+1>                                      
                                        </cfloop>
                                    </table>                              						
								</div>
							</div>
						</div>
					</div>
				</div>

				<input type="submit" value="#pageAction#" class="btn btn-primary" onclick="document.getElementById('agent').disabled=false;"/>
				<input type="button" value="#words[96]#" onclick="window.location='/latest/maintenance/agentProfile.cfm'" class="btn btn-default" />
                <br />
</form>           
<br />
<br />
<form name="upload_picture" id="upload_picture" action="/latest/uploadImage/icagent_image.cfm" method="post" enctype="multipart/form-data" target="_blank" >
                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##thirdPanel">
						<h4 class="panel-title accordion-toggle"><!---Upload #getgsetup.lagent#'s Signature (Image)---> #words[551]#</h4>
					</div>
					<div id="thirdPanel" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">                               
                                	<div class="form-group">
										<label class="col-sm-4 control-label"></label>
										<div class="col-sm-8">			
											<input type="file" name="picture"  id="picture" size="50" onChange="javascript:uploading_picture(this.value);" accept="image/gif,image/jpeg,image/tiff,image/x-ms-bmp,image/x-photo-cd,image/x-png,image/x-portable-greymap,image/x-portable-pixmap,image/x-portablebitmap">										
										</div>
									</div>
                                    <div class="form-group">
										<label class="col-sm-4 control-label"></label>
										<div class="col-sm-8">			
											<input type="text" name="picture_name" id="picture_name" size="50" value="">&nbsp;
				<input type="submit" name="Upload" value="#words[523]#" onClick="javascript:return add_option(document.getElementById('picture_name').value);">	
										</div>
									</div>	                             						
								</div>
							</div>
						</div>
					</div>
				</div>
</form>  
			</div>
         
            
</cfoutput>
</body>
</html>