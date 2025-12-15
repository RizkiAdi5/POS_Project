<cfif IsDefined('url.wos_group')>
	<cfset URLwos_group = trim(urldecode(url.wos_group))>
</cfif>


<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle="Customer/Item Price">
		<cfset pageAction="Create">
        
		<cfquery name="getWos_Group" datasource='#dts#'>
            SELECT * 
            FROM icgroup 
            WHERE wos_group=<cfqueryparam cfsqltype="cf_sql_varchar" value="##">;
		</cfquery>
		
		<cfset group = "">
        <cfset desp = "">  
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle="Update Group Profile">
		<cfset pageAction="Update">
		
                 
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Group Profile">
		<cfset pageAction="Delete">   

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
    
    <cfinclude template="/latest/filter/filterCustomer.cfm">
    <cfinclude template="/latest/filter/filterItem.cfm">
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
    <script>
		$(document).ready(function(){
			$('#customer').change(function(){
				$('#panel2').fadeIn('slow');
			});
		});
		     $(document).ready(function(){
      var i=1;
     $("#add_row").click(function(){
      $('#addr'+i).html("<td>"+ (i+1) +"</td><td><input name='name"+i+"' type='text' placeholder='Name' class='form-control input-md'  /> </td><td><input  name='mail"+i+"' type='text' placeholder='Mail'  class='form-control input-md'></td><td><input  name='mobile"+i+"' type='text' placeholder='Mobile'  class='form-control input-md'></td>");

      $('#tab_logic').append('<tr id="addr'+(i+1)+'"></tr>');
      i++; 
  });
     $("#delete_row").click(function(){
    	 if(i>1){
		 $("#addr"+(i-1)).html('');
		 i--;
		 }
	 });

});
	</script>
    
</head>

<body class="container">
<cfoutput>
    <form class="form-horizontal" role="form" action="/latest/maintenance/groupProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('group').disabled=false";>
        <div class="page-header">
            <h3>#pageTitle#</h3>
        </div>
		<div class="panel-group">
			<div class="panel panel-default">
				<div class="panel-heading" data-toggle="collapse" href="##panel1Collapse">
					<h4 class="panel-title accordion-toggle">Select a Customer</h4>
				</div>
				<div id="panel1Collapse" class="panel-collapse collapse in">
					<div class="panel-body">
						<div class="row">
							<div class="col-sm-6">							
								<div class="form-group">
									<label for="group" class="col-sm-4 control-label">Customer</label>
									<div class="col-sm-8">			
										<input type="hidden" id="customer" name="customer" class="customerFilter" required="required" data-placeholder="#customer#"/>									
									</div>
								</div>		                                                                     						
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
        <!---
        <div id="panel2" class="panel2" style="display:none">  
            <div class="panel-group">
                <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" href="##panel2Collapse">
                        <h4 class="panel-title accordion-toggle">Select an Item</h4>
                    </div>
                    <div id="panel2Collapse" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-sm-6">							
                                    <div class="form-group">
                                        <label for="group" class="col-sm-4 control-label">Item</label>
                                        <div class="col-sm-8">			
                                            <input type="hidden" id="item" name="item" class="itemFilter" required="required" data-placeholder="#customer#"/>									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="altItemNo" class="col-sm-4 control-label">Alt Item No</label>
                                        <div class="col-sm-8">			
                                           <input type="text" class="form-control input-sm" id="altItemNo" name="altItemNo" value="" placeholder="Alternative Item No" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="description" class="col-sm-4 control-label">Description</label>
                                        <div class="col-sm-8">			
                                           <input type="text" class="form-control input-sm" id="description" name="description" value=""  placeholder="Description" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="recommendedPrice" class="col-sm-4 control-label">Recommended Price</label>
                                        <div class="col-sm-8">			
                                           <input type="text" class="form-control input-sm" id="recommendedPrice" name="recommendedPrice" value="" placeholder="Recommended Price" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="note" class="col-sm-4 control-label">Note</label>
                                        <div class="col-sm-8">			
                                           <input type="text" class="form-control input-sm" id="note" name="note" value="" placeholder="Note"/>
                                        </div>
                                    </div> 	
                                    <cfloop index="i" from="1" to="3">
                                        <div class="form-group">
                                            <label for="discount#i#" class="col-sm-4 control-label">Discount #i#</label>
                                            <div class="col-sm-8">			
                                               <input type="text" class="form-control input-sm" id="discount#i#" name="discount#i#" value=""  placeholder="Discount #i#"/>
                                            </div>
                                        </div>
                                   	</cfloop>                                                                 						
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>    
        </div>	 --->  	
            
	<div class="container">
		<div class="row clearfix">
            <div class="col-md-16 column">
                <table class="table table-bordered table-hover" id="tab_logic">
                    <thead>
                        <tr >
                            <th class="text-center">
                            	Item No
                            </th>
                            <th class="text-center">
                                Alt Item No
                            </th>
                            <th class="text-center">
                                Recommended Price
                            </th>
                            <th class="text-center">
                                Discount 1 (%)
                            </th>
                            <th class="text-center">
                                Discount 2 (%)
                            </th>
                            <th class="text-center">
                                Discount 3 (%)
                            </th>
                            <th class="text-center">
                                Note
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr id='addr0'>
                            <td>
                            1
                            </td>
                            <td>
                            <input type="text" name='name0'  placeholder='Name' class="form-control"/>
                            </td>
                            <td>
                            <input type="text" name='mail0' placeholder='Mail' class="form-control"/>
                            </td>
                            <td>
                            <input type="text" name='mobile0' placeholder='Mobile' class="form-control"/>
                            </td>
                        </tr>
                        <tr id='addr1'></tr>
                    </tbody>
                </table>
            </div>
		</div>
            <a id="add_row" class="btn btn-default pull-left">Add Row</a><a id='delete_row' class="pull-right btn btn-default">Delete Row</a>
        </div>

        <div class="pull-right">
            <input type="submit" value="#pageAction#" class="btn btn-primary"/>
            <input type="button" value="Cancel" onclick="window.location='/latest/maintenance/groupProfile.cfm'" class="btn btn-default" />
        </div>      
	</form>
</cfoutput>
</body>
</html>

