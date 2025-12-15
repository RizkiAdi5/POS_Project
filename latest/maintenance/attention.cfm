<cfif IsDefined('url.attentionNo')>
	<cfset URLattentionNo = trim(urldecode(url.attentionNo))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Create Attention Profile">
		<cfset pageAction="Create">
        
		<cfset attentionNo = "">
        <cfset salutation = "">
        <cfset name = "">
        <cfset customerNo = "">
        <cfset c_phone = "">
        <cfset c_mobile = "">
        <cfset c_email = "">
		<cfset title = "">
		<cfset designation = "">
        
        <cfset add1 = "">
        <cfset add2 = "">
        <cfset add3 = "">
        <cfset add4 = "">
        <cfset city = "">
        <cfset state= "">
        <cfset postalCode = "">
        <cfset country = ""> 
        <cfset d_add1 = "">
        <cfset d_add2 = "">
        <cfset d_add3 = "">
        <cfset d_add4 = "">
        <cfset d_city = "">
        <cfset d_state = "">
        <cfset d_postalcode = "">
        <cfset d_country = "">
         
        <cfset business = "">
        <cfset assistant = "">
        <cfset assistantPhone = "">
        <cfset department = "">
        <cfset dob = "">
        <cfset contactGroup = "">
		<cfset commodity = "">
        <cfset customerCategory = "">
        <cfset description = "">

	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Attention Profile">
		<cfset pageAction="Update">
        
		<cfquery name="getAttention" datasource='#dts#'>
            SELECT * 
            FROM attention 
            WHERE attentionno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLattentionNo#">;
		</cfquery>
        
		<cfset attentionNo = getAttention.attentionno>
        <cfset salutation = getAttention.salutation>
        <cfset name = getAttention.name>
        <cfset customerNo = getAttention.customerno>
        <cfset c_phone = getAttention.c_phone>
        <cfset c_mobile = getAttention.c_mobile>
        <cfset c_email = getAttention.c_email>
        <cfset title = getAttention.title2>
        <cfset designation = getAttention.designation>
    
        <cfset add1 = getAttention.b_add1>
        <cfset add2 = getAttention.b_add2>
        <cfset add3 = getAttention.b_add3>
        <cfset add4 = getAttention.b_add4>
        <cfset city = getAttention.b_city>
        <cfset state = getAttention.b_state>
        <cfset postalCode = getAttention.b_postalcode>
        <cfset country = getAttention.b_country>
        
        <cfset d_add1 = getAttention.o_add1>
        <cfset d_add2 = getAttention.o_add2>
        <cfset d_add3 = getAttention.o_add3>
        <cfset d_add4 = getAttention.o_add4>
        <cfset d_city = getAttention.o_city>
        <cfset d_state = getAttention.o_state>
        <cfset d_postalcode = getAttention.o_postalcode>
        <cfset d_country = getAttention.o_country>
        
        <cfset business = getAttention.business>
        <cfset assistant = getAttention.assistant>
        <cfset assistantPhone = getAttention.asst_phone>
        <cfset department = getAttention.department>
        <cfset dob = getAttention.dob>
        <cfset contactGroup = getAttention.contactgroup>
		<cfset commodity = getAttention.commodity>
        <cfset customerCategory = getAttention.category>
        <cfset description = getAttention.description>
       
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Attention Profile">
		<cfset pageAction="Delete">   

        <cfquery name="getAttention" datasource='#dts#'>
            SELECT * 
            FROM attention 
            WHERE attentionNo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLattentionNo#">;
		</cfquery>
        
        <cfset attentionNo = getAttention.attentionno>
        <cfset salutation = getAttention.salutation>
		<cfset name = getAttention.name>	
        <cfset customerNo = getAttention.customerNo>
        <cfset c_phone = getAttention.c_phone>
        <cfset c_mobile = getAttention.c_mobile>
        <cfset c_email = getAttention.c_email>
        <cfset title = getAttention.title2>
        <cfset designation = getAttention.designation>
    
        <cfset add1 = getAttention.b_add1>
        <cfset add2 = getAttention.b_add2>
        <cfset add3 = getAttention.b_add3>
        <cfset add4 = getAttention.b_add4>
        <cfset city = getAttention.b_city>
        <cfset state = getAttention.b_state>
        <cfset postalCode = getAttention.b_postalcode>
        <cfset country = getAttention.b_country>
        
        <cfset d_add1 = getAttention.o_add1>
        <cfset d_add2 = getAttention.o_add2>
        <cfset d_add3 = getAttention.o_add3>
        <cfset d_add4 = getAttention.o_add4>
        <cfset d_city = getAttention.o_city>
        <cfset d_state = getAttention.o_state>
        <cfset d_postalcode = getAttention.o_postalcode>
        <cfset d_country = getAttention.o_country>
        
        <cfset business = getAttention.business>
        <cfset assistant = getAttention.assistant>
        <cfset assistantPhone = getAttention.asst_phone>
        <cfset department = getAttention.department>
        <cfset dob = getAttention.dob>
        <cfset contactGroup = getAttention.contactgroup>
		<cfset commodity = getAttention.commodity>
        <cfset customerCategory = getAttention.category>
        <cfset description = getAttention.description>
	</cfif>
</cfif>

<cfquery name="listBusiness" datasource="#dts#">
	SELECT business,desp 
	FROM business 
	ORDER BY business;
</cfquery>

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

</head>

<body class="container">
<cfoutput>
<div class="container">
    <div class="page-header">
        <h3>#pageTitle#</h3>
    </div>
	<form class="form-horizontal" role="form" action="/latest/maintenance/attentionProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('attentionNo').disabled=false";>
    
    	<div class="panel-group">
            <div class="panel panel-default">
                <div class="panel-heading" data-toggle="collapse" href="##mainCollapse">
                    <h4 class="panel-title accordion-toggle">Main Information</h4>
                </div>
                <div id="mainCollapse" class="panel-collapse collapse in">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-sm-6">								
                                <div class="form-group">
										<label for="attentionNo" class="col-sm-4 control-label">Attention No</label>
									  <div class="col-sm-8">			
											<input type="text" class="form-control input-sm" id="attentionNo" name="attentionNo" required="yes" maxlength="25" <cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLattentionNo#"  disabled="true"</cfif>/>										
									  </div>
								</div>
                                <div class="form-group">
                                	<label for="name" class="col-sm-4 control-label">Attention Name</label>
                                    <div class="col-sm-3">
										<select id="salutation" name="salutation" class="form-control input-sm">
											<cfloop list="Mr.,Mrs.,Ms.,Dr.,Prof.,Datuk.,Dato.,Tan Sri." index="i">
												<option value="#i#" <cfif #i# EQ salutation>selected</cfif>>#i#</option>
										    </cfloop>
									  	</select>	
                                    </div>   
                                    <div class="col-sm-5">    				
                                    	<input type="text" class="form-control input-sm" id="name" name="name" value="#name#" >									
                                  	</div>
								</div>
                                <div class="form-group">
                                    <label for="customerNo" class="col-sm-4 control-label">Customer No</label>
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
									<label for="c_phone" class="col-sm-4 control-label">Phone</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="c_phone" name="c_phone" value="#c_phone#" >									
									</div>
								</div>	    												 									
                                <div class="form-group">
									<label for="c_mobile" class="col-sm-4 control-label">Mobile</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="c_mobile" name="c_mobile" value="#c_mobile#" >									
									</div>
								</div>	 
                                <div class="form-group">
									<label for="c_email" class="col-sm-4 control-label">Email</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="c_email" name="c_email" value="#c_email#" >									
									</div>
								</div>                                                                 						
                            </div> 
                            <div class="col-sm-6">	
                            	<cfloop index="i" from="1" to="9">
                                	<div class="form-group"></div>
                                </cfloop>
                            	<div class="form-group">
                                    <label for="title" class="col-sm-4 control-label">Title</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="title" name="title" value="#title#" >									
									</div>
								</div>
                                <div class="form-group">
                                    <label for="designation" class="col-sm-4 control-label">Designation</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="designation" name="designation" value="#designation#" >									
									</div>
								</div>
                            </div> 
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="panel panel-default">
                <div class="panel-heading" data-toggle="collapse" href="##mailingInfoCollapse">
                    <h4 class="panel-title accordion-toggle">Mailing information</h4>
                </div>
                <div id="mailingInfoCollapse" class="panel-collapse collapse">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="add1" class="col-sm-4 control-label">Billing Address</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="add1" name="add1" value="#add1#" placeholder="Street Address" maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="add2" class="col-sm-4 control-label"></label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="add2" name="add2" value="#add2#" placeholder="Apt, Suite, Bldg." maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="add3" class="col-sm-4 control-label"></label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="add3" name="add3" value="#add3#" placeholder="Additional Address Information" maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="add4" class="col-sm-4 control-label"></label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="add4" name="add4" value="#add4#" placeholder="Additional Address Information" maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="city" class="col-sm-4 control-label">City</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="city" name="city" value="#city#" placeholder="City" maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="state" class="col-sm-4 control-label">State</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="state" name="state" value="#state#" placeholder="State" maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="country" class="col-sm-4 control-label">Country</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="country" name="country" value="#country#" placeholder="Country" maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="postalCode" class="col-sm-4 control-label">Postal Code</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="postalCode" name="postalCode" value="#postalCode#" placeholder="Postal Code" maxlength="35">
                                    </div>
                                </div>							
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="d_add1" class="col-sm-4 control-label">Delivery Address</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="d_add1" name="d_add1" value="#d_add1#" placeholder="Street Address" maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="d_add2" class="col-sm-4 control-label"></label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="d_add2" name="d_add2" value="#d_add2#" placeholder="Apt, Suite, Bldg." maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="d_add3" class="col-sm-4 control-label"></label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="d_add3" name="d_add3" value="#d_add3#" placeholder="Additional Address Information" maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="d_add4" class="col-sm-4 control-label"></label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="d_add4" name="d_add4" value="#d_add4#" placeholder="Additional Address Information" maxlength="35">
                                    </div>
                                </div>
								<div class="form-group">
                                    <label for="d_city" class="col-sm-4 control-label">City</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="d_city" name="d_city" value="#d_city#" placeholder="City" maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="d_state" class="col-sm-4 control-label">State</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="d_state" name="d_state" value="#d_state#" placeholder="State" maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="d_country" class="col-sm-4 control-label">Country</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="d_country" name="d_country" value="#d_country#" placeholder="Country" maxlength="35">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="d_postalcode" class="col-sm-4 control-label">Postal Code</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control input-sm" id="d_postalcode" name="d_postalcode" value="#d_postalcode#" placeholder="Postal Code" maxlength="35">
                                    </div>
                                </div>
                                </div>                                 
                            </div>
                        </div>
                    </div>
                </div>
            </div>
             
            
            <div class="panel panel-default">
                <div class="panel-heading" data-toggle="collapse" href="##otherCollapse">
                    <h4 class="panel-title accordion-toggle">Other Information</h4>
                </div>
                <div id="otherCollapse" class="panel-collapse collapse">
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="business" class="col-sm-4 control-label">Business Nature</label>
                                    <div class="col-sm-8">
                                        <select class="form-control input-sm" id="business" name="business">
                                            <option value="">Choose a Business Nature</option>
                                            <cfloop query="listBusiness">
                                                <option value="#listBusiness.business#" <cfif listBusiness.business eq business>selected</cfif>>#listBusiness.desp#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div> 
                                <div class="form-group">
									<label for="assistant" class="col-sm-4 control-label">Assistant</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="assistant" name="assistant" value="#assistant#" placeholder="Assistant" >									
									</div>
								</div>	
                                    
                                <div class="form-group">
									<label for="assistantPhone" class="col-sm-4 control-label">Assistant Phone</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="assistantPhone" name="assistantPhone" value="#assistantPhone#" placeholder="Assistant Phone" >									
									</div>
								</div>
                                <div class="form-group">
									<label for="department" class="col-sm-4 control-label">Department</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="department" name="department" value="#department#" >									
									</div>
								</div>
                            </div>
                            
                            <div class="col-sm-6">
								<div class="form-group">
									<label for="dob" class="col-sm-4 control-label">Date Of Birth</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="dob" name="dob" value="#dob#" placeholder="Date Of Birth" >									
									</div>
								</div> 
                              	<div class="form-group">
									<label for="contactGroup" class="col-sm-4 control-label">Contact Group</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="contactGroup" name="contactGroup" value="#contactGroup#" >									
									</div>
								</div> 
                                <div class="form-group">
									<label for="customerCategory" class="col-sm-4 control-label">Customer Category</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="customerCategory" name="customerCategory" value="#customerCategory#" >									
									</div>
								</div>
                                <div class="form-group">
									<label for="commodity" class="col-sm-4 control-label">Commodity</label>
									<div class="col-sm-8">
										<input type="text" class="form-control input-sm" id="commodity" name="commodity" value="#commodity#" >									
									</div>
								</div>      
                            </div>
                        </div>
                        <div class="row">
							<div class="col-sm-16">           
             					<div class="form-group">
									<label for="description" class="col-sm-2 control-label">Description</label>
									<div class="col-sm-8">
                                       	<textarea  class="form-control input-sm" id="description" name="description" rows="4">#description#</textarea>						        	
									</div>
								</div>	
							</div>
						</div>      
                    </div>
                </div>
            </div>
        
        <hr>
        <div class="pull-right">
            <button type="submit" class="btn btn-primary" id="submit">Submit</button>
            <button type="button" class="btn btn-default" onclick="window.location='/latest/maintenance/attentionProfile.cfm'" >Cancel</button>
        </div>
    </form>		
</div>
</cfoutput>
</body>
</html>

