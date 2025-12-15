<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "23, 8, 16, 549, 561, 7, 40, 45, 300, 48, 7, 83, 536, 144, 567, 562, 125,1499">
<cfinclude template="/latest/words.cfm">

<cfif IsDefined('url.driverno')>
	<cfset URLdriverno = trim(urldecode(url.driverno))>
</cfif>

<cfquery name="getTeam" datasource="#dts#">
  SELECT team,desp 
  FROm icteam;
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
	select * from gsetup
</cfquery>

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create End User Profile">
		<cfset pageAction="Create">
        
		<cfset driverNo = "">
        <cfset name = "">
        <cfset name2 = "">
        <cfset attention = "">
        <cfset customerNo = "">
        <cfset add1 = "">   
        <cfset add2 = "">
        <cfset add3 = "">
        <cfset department = "">
        <cfset contact = "">  
        <cfset phone = "">
        <cfset hp = "">
        <cfset email = "">
        <cfset fax = "">
        <cfset d_add1 = "">
        <cfset d_add2 = "">
        <cfset d_add3 = "">
        <cfset d_add4 = "">
        <cfset d_attn = "">
        <cfset d_contact = "">
        <cfset remark = "">
        <cfset commission = "0.00">
        <cfset discontinueDriver = "">
        <cfset photo = "">
        <cfset icno="">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update End User Profile">
		<cfset pageAction="Update">
		<cfquery name="getDriver" datasource='#dts#'>
            SELECT * 
            FROM driver
            WHERE driverno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLdriverno#">;
		</cfquery>
		
		
        <cfset driverNo = getDriver.driverno>
        <cfset name = getDriver.name>
        <cfset name2 = getDriver.name2>
        <cfset attention = getDriver.attn>
        <cfset customerNo = getDriver.customerno>
        <cfset add1 = getDriver.add1>
        <cfset add2 = getDriver.add2>
        <cfset add3 = getDriver.add3>
        <cfset department = getDriver.dept>
        <cfset contact = getDriver.contact>
        <cfset phone = getDriver.phone>
 		<cfset hp = getDriver.phonea>
        <cfset email = getDriver.e_mail>
        <cfset fax = getDriver.fax>
        <cfset d_add1 = getDriver.dadd1>
        <cfset d_add2 = getDriver.dadd2>
        <cfset d_add3 = getDriver.dadd3>
        <cfset d_add4 = getDriver.dadd4>
        <cfset d_attn = getDriver.dattn>
        <cfset d_contact = getDriver.dcontact>
        <cfset remark = getDriver.remarks>
        <cfset commission  = getDriver.commission1 >
        <cfset discontinueDriver = getDriver.discontinuedriver> 
        <cfset photo = getDriver.photo>
        <cfset icno = getDriver.icno>
          
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete End User Profile">
		<cfset pageAction="Delete">   
        
		<cfquery name="getDriver" datasource='#dts#'>
            SELECT * 
            FROM driver 
            WHERE driverno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLdriverno#">;
		</cfquery>
        
        <cfset driverNo = getDriver.driverno>
        <cfset name = getDriver.name>
        <cfset name2 = getDriver.name2>
        <cfset attention = getDriver.attn>
        <cfset customerNo = getDriver.customerno>
        <cfset add1 = getDriver.add1>
        <cfset add2 = getDriver.add2>
        <cfset add3 = getDriver.add3>
        <cfset department = getDriver.dept>
        <cfset contact = getDriver.contact>
        <cfset phone = getDriver.phone>
 		<cfset hp = getDriver.phonea>
        <cfset email = getDriver.e_mail>
        <cfset fax = getDriver.fax>
        <cfset d_add1 = getDriver.dadd1>
        <cfset d_add2 = getDriver.dadd2>
        <cfset d_add3 = getDriver.dadd3>
        <cfset d_add4 = getDriver.dadd4>
        <cfset d_attn = getDriver.dattn>
        <cfset d_contact = getDriver.dcontact>
        <cfset remark = getDriver.remarks>
        <cfset commission  = getDriver.commission1 >
        <cfset discontinueDriver = getDriver.discontinuedriver> 
        <cfset photo = getDriver.photo>
        <cfset icno = getDriver.icno>
		
       
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
    
    <cfinclude template="filterCustomer.cfm">
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
    
    <script language="JavaScript">
	
		function add_option(pic_name)
		{
			var agree = confirm("Are You Sure ?");
			if (agree==true)
			{
				var detection=0;
				var totaloption=document.getElementById("photo_available").length-1;
	
				for(var i=0;i<=totaloption;++i)
				{
					if(document.getElementById("photo_available").options[i].value==pic_name)
					{
						detection=1;
						break;
					}
				}
				
				if(detection!=1)
				{
					var a=new Option(pic_name,pic_name);
					document.getElementById("photo_available").options[document.getElementById("photo_available").length]=a;
				}
				document.getElementById("photo_available").value=pic_name;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		function change_photo(photo)
		{
			var encode_photo = encodeURI(photo);
			show_photo.location="icagent_image.cfm?pic3="+encode_photo;
		}
		
		function delete_photo(photo)
		{
		var answer =confirm("Are you sure want to delete photo "+photo);
		if (answer)
		{
			var encode_photo = encodeURI(photo);
			show_photo.location="icagent_image.cfm?delete=true&photo="+encode_photo;
			var elSel = document.getElementById('photo_available');
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
			
		function uploading_photo(pic_name)
		{
			var new_pic_name1 = new String(pic_name);
			var new_pic_name2 = new_pic_name1.split(/[-,/,\\]/g);
			document.getElementById("photo_name").value=new_pic_name2[new_pic_name2.length-1];
		}
	</script>
</head>

<body class="container">
<cfoutput>
<form class="form-horizontal" role="form" name="form1" id="form1" action="/latest/maintenance/driverProcess.cfm?action=#url.action#" method="post">
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
										<label for="driverNo" class="col-sm-4 control-label">#words[1499]#</label>
										<div class="col-sm-8">			
											<input type="text" class="form-control input-sm" id="driverNo" name="driverNo" maxlength="25" required="yes" <cfif IsDefined("url.action") AND url.action NEQ "create"> value="#driverNo#" disabled="true"</cfif>/>										
										</div>
									</div>	
                                     
                                    <div class="form-group">
										<label for="name" class="col-sm-4 control-label">#words[23]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="name" name="name" value="#name#" placeholder="#words[23]#">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="name2" class="col-sm-4 control-label"> </label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="name2" name="name2" value="#name2#">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="name2" class="col-sm-4 control-label">IC No</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="icno" name="icno" value="#icno#">									
										</div>
									</div>

                                    <div class="form-group">
										<label for="attention" class="col-sm-4 control-label">#words[8]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="attention" name="attention" value="#attention#">									
										</div>
									</div>
 
                                    <div class="form-group">
										<label for="customerNo" class="col-sm-4 control-label">#words[16]#</label>
										<div class="col-sm-8">
										<cfif customerno neq ''>
                                            <cfset displayValue = customerno>   
                                        <cfelse>
                                            <cfset displayValue = "Choose a Customer No">
                                        </cfif>
                                        <input type="hidden" id="customerNo" name="customerNo" class="customerNo" data-placeholder="#displayValue#" />									
										</div>
									</div> 

                                    <div class="form-group">
										<label for="discontinueDriver" class="col-sm-4 control-label">Discontinue</label>
										<div class="col-sm-8">
											<div class="row">
												<div class="col-sm-7">
													<div class="checkbox">	
														<input type="checkbox" value="0" id="discontinueDriver" name="discontinueDriver" <cfif discontinuedriver eq 'Y'>checked</cfif>>
													</div>													
												</div>
                                    		</div>											
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="sign" class="col-sm-4 control-label">Change Signature</label>
										<div class="col-sm-8">
											<cfdirectory action="list" directory="#HRootPath#\billformat\#hcomid#\" name="photo_list">
                                            <select name="photo_available" id="photo_available" class="form-control input-sm" onChange="javascript:change_photo(this.value);">
                                                <option value="">#words[549]#</option>
                                                <cfloop query="photo_list">
                                                    <cfif photo_list.name neq "Thumbs.db" and (right(photo_list.name,3) eq "jpg" or right(photo_list.name,3) eq "png" or right(photo_list.name,3) eq "bmp")>
                                                        <option value="#photo_list.name#" #iif((photo eq photo_list.name),DE("selected"),DE(""))#>#photo_list.name#</option>
                                                    </cfif>
                                                </cfloop>
                                            </select>
                                            <div style="float:right; margin:25px;">	
                                            	<iframe id="show_photo" name="show_photo" frameborder="0" marginheight="0" marginwidth="0" align="middle" height="150" width="150" scrolling="no" src="/latest/uploadImage/icagent_image.cfm?pic3=#urlencodedformat(photo)#"></iframe>		
                                            </div>		
										</div>
									</div>	                                                                     						
								</div>
							</div> 
						</div>
					</div>
				</div>     
                
                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##secondPanel">
						<h4 class="panel-title accordion-toggle">#words[561]#</h4>
					</div>
					<div id="secondPanel" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">                               
                                	<div class="form-group">
										<label for="add1" class="col-sm-4 control-label">#words[562]#</label>
                                        <div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="add1" name="add1" value="#add1#" >	
                                        </div>  
                                    </div>     
                                     <div class="form-group">
										<label for="add2" class="col-sm-4 control-label"> </label>
                                        <div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="add2" name="add2" value="#add2#" >	
                                        </div>  
                                    </div> 
                                    <div class="form-group">
										<label for="add3" class="col-sm-4 control-label"> </label>
                                        <div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="add3" name="add3" value="#add3#" >	
                                        </div>  
                                    </div> 
                                    <div class="form-group">
										<label for="contact" class="col-sm-4 control-label">#words[7]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="contact" name="contact" value="#contact#" >									
										</div>
									</div>
                                    <div class="form-group">
										<label for="phone" class="col-sm-4 control-label">#words[40]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="phone" name="phone" value="#phone#" >									
										</div>
									</div>                 
                                    <div class="form-group">
										<label for="hp" class="col-sm-4 control-label">Handphone</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="hp" name="hp" value="#hp#" >									
										</div>
									</div>
                                    <div class="form-group">
										<label for="email" class="col-sm-4 control-label">#words[45]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="email" name="email" value="#email#" >									
										</div>
									</div>
                                    <div class="form-group">
										<label for="fax" class="col-sm-4 control-label">#words[300]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="fax" name="fax" value="#fax#" >									
										</div>
									</div>	                          						
								</div>
                                <div class="col-sm-6">  
                                	<div class="form-group">
										<label for="d_add1" class="col-sm-4 control-label">#words[48]#</label>
                                        <div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="d_add1" name="d_add1" value="#d_add1#" >	
                                        </div>  
                                    </div>     
                            	 	<div class="form-group">
										<label for="d_add2" class="col-sm-4 control-label"> </label>
                                        <div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="d_add2" name="d_add2" value="#d_add2#" >	
                                        </div>  
                                    </div> 
                            	 	<div class="form-group">
										<label for="d_add3" class="col-sm-4 control-label"> </label>
                                        <div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="d_add3" name="d_add3" value="#d_add3#" >	
                                        </div>  
                                    </div>      
                             		<div class="form-group">
										<label for="d_add4" class="col-sm-4 control-label"> </label>
                                        <div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="d_add4" name="d_add4" value="#d_add4#" >	
                                        </div>  
                                    </div>       
                                    <div class="form-group">
										<label for="d_attn" class="col-sm-4 control-label">#words[8]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="d_attn" name="d_attn" value="#d_attn#" >									
										</div>
									</div>   
                                    <div class="form-group">
										<label for="d_contact" class="col-sm-4 control-label">#words[7]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="d_contact" name="d_contact" value="#d_contact#" placeholder="Delivery Contact" />									
										</div>
									</div>
                                </div>
							</div>
						</div>
					</div>  
                    
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##thirdPanel">
						<h4 class="panel-title accordion-toggle">#words[83]#</h4>
					</div>
					<div id="thirdPanel" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">                               
                                	<div class="form-group">
										<label for="remark" class="col-sm-4 control-label">#words[536]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="remark" name="remark" value="#remark#" placeholder="#words[536]#" />									
										</div>
									</div>                
                                    <div class="form-group">
										<label for="commission" class="col-sm-4 control-label">#words[144]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="commission" name="commission" value="#commission#" placeholder="#words[144]# %" />									
										</div>
									</div>		                             						
								</div>
                                <div class="col-sm-6">                               
                                	<div class="form-group">
										<label for="department" class="col-sm-4 control-label">#words[567]#</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="department" name="department" value="#department#" >									
										</div>
									</div>		                             						
								</div>
							</div>
						</div>
					</div>
				</div>     
</form>           

<form name="upload_photo" id="upload_photo" action="icagent_image.cfm" method="post" enctype="multipart/form-data" target="_blank" >
                <div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##fourthPanel">
						<h4 class="panel-title accordion-toggle">Upload Photo</h4>
					</div>
					<div id="fourthPanel" class="panel-collapse collapse">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">                               
                                	<div class="form-group">
										<label class="col-sm-4 control-label"></label>
										<div class="col-sm-8">			
											<input type="file" name="photo"  id="photo" size="50" onChange="javascript:uploading_photo(this.value);" accept="image/gif,image/jpeg,image/tiff,image/x-ms-bmp,image/x-photo-cd,image/x-png,image/x-portable-greymap,image/x-portable-pixmap,image/x-portablebitmap">										
										</div>
									</div>
                                    <div class="form-group">
										<label class="col-sm-4 control-label"></label>
										<div class="col-sm-8">			
											<input type="text" name="photo_name" id="photo_name" size="50" value="">&nbsp;
				<input type="submit" name="Upload" value="Upload" onClick="javascript:return add_option(document.getElementById('photo_name').value);">	
										</div>
									</div>	                             						
								</div>
							</div>
						</div>
					</div>
				</div>
</form>  
			
         
            <div class="pull-right">
				<input type="button" value="#pageAction#" class="btn btn-primary" onclick="document.getElementById('driverNo').disabled=false;document.getElementById('form1').submit();"/>
				
			</div>
</cfoutput>
</body>
</html>