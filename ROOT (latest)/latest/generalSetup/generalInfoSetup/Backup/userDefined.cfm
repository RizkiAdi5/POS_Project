<cfquery name="getGsetup" datasource='#dts#'>
    SELECT * 
    FROM gsetup;
</cfquery>
	
<cfquery name="getExtraRemark" datasource="#dts#">
	SELECT * 
	FROM extraremark;
</cfquery>

<cfquery name="getUserDefault" datasource="#dts#">
	SELECT * 
	FROM userdefault;
</cfquery>

<cfset pageTitle="Update User Defined">
<cfset pageAction="Update">

<cfset INVdesp = getUserDefault.inv_desp>
<cfset DOdesp = getUserDefault.do_desp>
<cfset SOdesp = getUserDefault.so_desp>
<cfset QUOdesp = getUserDefault.quo_desp>
<cfset CSdesp = getUserDefault.cs_desp>
<cfset CNdesp = getUserDefault.cn_desp>
<cfset DNdesp = getUserDefault.dn_desp>
<cfset POdesp = getUserDefault.po_desp>
<cfset RQdesp = getUserDefault.rq_desp>
<cfset PRdesp = getUserDefault.pr_desp>
<cfset RCdesp = getUserDefault.rc_desp>


<cfset refNo2 = "">
<cfset desp = "">

<cfloop index="i" from="5" to="11"> 
    <cfset 'headerRemark#i#' = evaluate('getGsetup.rem#i#')>
</cfloop>

<cfloop index="i" from="30" to="49">  
    <cfset 'headerRemark#i#' = evaluate('getExtraRemark.rem#i#')>
</cfloop>

<cfloop index="i" from="0" to="11">  
    <cfset 'remark#i#' = evaluate('getExtraRemark.trrem#i#')>
</cfloop>

<cfloop index="i" from="1" to="4">  
    <cfset 'bodyRemark#i#' = evaluate('getGsetup.brem#i#')>
</cfloop>

<cfloop index="i" from="1" to="7">  
    <cfset 'miscCharge#i#' = evaluate('getGsetup.misccharge#i#')>
</cfloop>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
    <link rel="stylesheet" type="text/css" href="/latest/css/maintenance/target.css">
    <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.css">
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
</head>

<body class="container">
<cfoutput>
    <form class="form-horizontal" role="form" action="/latest/generalSetup/generalInformationSetup/userDefinedProcess.cfm" method="post">
        <div class="page-header">
            <h3>#pageTitle#</h3>
        </div>
            <div class="panel-group">
                <!---
                <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" href="##panel1Collapse">
                      <h4 class="panel-title accordion-toggle">Maintenance Profile(s)</h4>
                    </div>
                    <div id="panel1Collapse" class="panel-collapse collapse in">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-sm-6">							
                                    <div class="form-group">
                                        <label for="lcategory" class="col-sm-4 control-label">Category Layer</label>
                                        <div class="col-sm-8">			
                                            <input type="text" class="form-control input-sm" id="lcategory" name="lcategory" placeholder="Category" required="yes" maxlength="25" <cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLwos_group#"  disabled="true"</cfif>/>										
                                        </div>
                                    </div>	   
                                    <div class="form-group">
                                        <label for="lgroup" class="col-sm-4 control-label">Group Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="lgroup" name="lgroup" value="#lgroup#" placeholder="Group">									
                                        </div>
                                    </div>	   
                                    <div class="form-group">
                                        <label for="Lbrand" class="col-sm-4 control-label">Brand Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="Lbrand" name="Lbrand" value="#Lbrand#" placeholder="Brand">									
                                        </div>
                                    </div>	                                    
                                    <div class="form-group">
                                        <label for="lmaterial" class="col-sm-4 control-label">Material Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="lmaterial" name="lmaterial" value="#lmaterial#" placeholder="Material">									
                                        </div>
                                    </div>	
                                    <div class="form-group">
                                        <label for="lmodel" class="col-sm-4 control-label">Model Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="lmodel" name="lmodel" value="#lmodel#" placeholder="Model">									
                                        </div>
                                    </div>	 
                                    <div class="form-group">
                                        <label for="lrating" class="col-sm-4 control-label">Rating Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="lrating" name="lrating" value="#lrating#" placeholder="Rating">									
                                        </div>
                                    </div>	
                                    <div class="form-group">
                                        <label for="lsize" class="col-sm-4 control-label">Size Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="lsize" name="lsize" value="#lsize#" placeholder="Size">									
                                        </div>
                                    </div>	
                                    <div class="form-group">
                                        <label for="lagent" class="col-sm-4 control-label">Agent Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="lagent" name="lagent" value="#lagent#" placeholder="Agent">									
                                        </div>
                                    </div>	 
                                    <div class="form-group">
                                        <label for="lteam" class="col-sm-4 control-label">Team Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="lteam" name="lteam" value="#lteam#" placeholder="Team">									
                                        </div>
                                    </div>	
                                    <div class="form-group">
                                        <label for="ldriver" class="col-sm-4 control-label">End User Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="ldriver" name="ldriver" value="#ldriver#" placeholder="End User">									
                                        </div>
                                    </div>	
                                    
                                    
                                    <div class="form-group">
                                        <label for="llocation" class="col-sm-4 control-label">Location Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="llocation" name="llocation" value="#llocation#" placeholder="Location">									
                                        </div>
                                    </div>	
                                    <div class="form-group">
                                        <label for="lproject" class="col-sm-4 control-label">Project Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="lproject" name="lproject" value="#lproject#" placeholder="Project">									
                                        </div>
                                    </div>	
                                    <div class="form-group">
                                        <label for="ljob" class="col-sm-4 control-label">Job Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="ljob" name="ljob" value="#ljob#" placeholder="Job">									
                                        </div>
                                    </div>	
                                    <div class="form-group">
                                        <label for="litemno" class="col-sm-4 control-label">Item Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="litemno" name="litemno" value="#litemno#" placeholder="Item">									
                                        </div>
                                    </div>	 
                                    <div class="form-group">
                                        <label for="laitemno" class="col-sm-4 control-label">Product Code Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="laitemno" name="laitemno" value="#laitemno#" placeholder="Product Code">									
                                        </div>
                                    </div>	 
                                    <div class="form-group">
                                        <label for="lbarcode" class="col-sm-4 control-label">Bar Code Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="lbarcode" name="lbarcode" value="#lbarcode#" placeholder="Bar Code">									
                                        </div>
                                    </div>	    
                                    <div class="form-group">
                                        <label for="lbatch" class="col-sm-4 control-label">Batch Layer</label>
                                        <div class="col-sm-8">
                                              <input type="text" class="form-control input-sm" id="lbatch" name="lbatch" value="#lbatch#" placeholder="Batch">									
                                        </div>
                                    </div>	        
                                    <div class="form-group">
                                        <label for="lterm" class="col-sm-4 control-label">Term Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="lterm" name="lterm" value="#lterm#" placeholder="Term">									
                                        </div>
                                    </div>	
                                    <div class="form-group">
                                        <label for="lserial" class="col-sm-4 control-label">Serial No Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="lserial" name="lserial" value="#lserial#" placeholder="Serial">									
                                        </div>
                                    </div>	                              
                                    <div class="form-group">
                                        <label for="bodyso" class="col-sm-4 control-label">SO Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="bodyso" name="bodyso" value="#bodyso#" placeholder="SO">									
                                        </div>
                                    </div>	
                                    <div class="form-group">
                                        <label for="bodypo" class="col-sm-4 control-label">PO Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="bodypo" name="bodypo" value="#bodypo#" placeholder="PO/SO">									
                                        </div>
                                    </div>	                                
                                    <div class="form-group">
                                        <label for="bodydo" class="col-sm-4 control-label">DO Layer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="bodydo" name="bodydo" value="#bodydo#" placeholder="Description">									
                                        </div>
                                    </div>                                    						
                                </div>
                            </div>
                        </div>
                    </div>
                </div>          
                <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" href="##panel3Collapse">
                        <h4 class="panel-title accordion-toggle">Transaction Menu</h4>
                    </div>
                    <div id="panel3Collapse" class="panel-collapse collapse in">    
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label for="purchaseOrder" class="col-sm-4 control-label">Purchase Order</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="purchaseOrder" name="purchaseOrder" value="#purchaseOrder#" placeholder="Purchase Order">									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="purchaseReceive" class="col-sm-4 control-label">Purchase Receive</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="purchaseReceive" name="purchaseReceive" value="#purchaseReceive#" placeholder="Purchase Receive">									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="purchaseReturn" class="col-sm-4 control-label">Purchase Return</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="purchaseReturn" name="purchaseReturn" value="#purchaseReturn#" placeholder="Purchase Return">									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="purchaseRequisition" class="col-sm-4 control-label">Purchase Requisition</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="purchaseRequisition" name="purchaseRequisition" value="#purchaseRequisition#" placeholder="Purchase Requisition">									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="quotation" class="col-sm-4 control-label">Quotation</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="quotation" name="quotation" value="#quotation#" placeholder="Quotation">									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="salesOrder" class="col-sm-4 control-label">Sales Order</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="salesOrder" name="salesOrder" value="#salesOrder#" placeholder="Sales Order">									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="deliveryOrder" class="col-sm-4 control-label">Delivery Order</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="deliveryOrder" name="deliveryOrder" value="#deliveryOrder#" placeholder="Delivery Order">									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="invoice" class="col-sm-4 control-label">Invoice</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="invoice" name="invoice" value="#invoice#" placeholder="Invoice">									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="cashSales" class="col-sm-4 control-label">Cash Sales</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="cashSales" name="cashSales" value="#cashSales#" placeholder="Cash Sales">									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="creditNote" class="col-sm-4 control-label">Credit Note</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="creditNote" name="creditNote" value="#creditNote#" placeholder="Credit Note">									
                                        </div>
                                    </div>   
                                    <div class="form-group">
                                        <label for="depositProfile" class="col-sm-4 control-label">Deposit Profile</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="depositProfile" name="depositProfile" value="#depositProfile#" placeholder="Deposit Profile">									
                                        </div>
                                    </div> 
                                    <div class="form-group">
                                        <label for="itemAssembly" class="col-sm-4 control-label">Item Assembly</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="itemAssembly" name="itemAssembly" value="#itemAssembly#" placeholder="Item Assembly">									
                                        </div>
                                    </div> 
                                    <div class="form-group">
                                        <label for="issue" class="col-sm-4 control-label">Issue</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="issue" name="issue" value="#issue#" placeholder="Issue">									
                                        </div>
                                    </div> 
                                    <div class="form-group">
                                        <label for="adjustmentIncrease" class="col-sm-4 control-label">Adjustment Increase</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="adjustmentIncrease" name="adjustmentIncrease" value="#adjustmentIncrease#" placeholder="Adjustment Increase">									
                                        </div>
                                    </div> 
                                    <div class="form-group">
                                        <label for="adjustmentReduce" class="col-sm-4 control-label">Adjustment Reduce</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="adjustmentReduce" name="adjustmentReduce" value="#adjustmentReduce#" placeholder="Adjustment Reduce">									
                                        </div>
                                    </div> 
                                    <div class="form-group">
                                        <label for="assemblyDisassembly" class="col-sm-4 control-label">Assembly/Disassembly</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="assemblyDisassembly" name="assemblyDisassembly" value="#assemblyDisassembly#" placeholder="Assembly/Disassembly">									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="transfer" class="col-sm-4 control-label">Transfer</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="transfer" name="transfer" value="#transfer#" placeholder="Transfer">									
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="consignmentIn" class="col-sm-4 control-label">Consignment In</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="consignmentIn" name="consignmentIn" value="#consignmentIn#" placeholder="Consignment In">									
                                        </div>
                                    </div> 
                                    <div class="form-group">
                                        <label for="consignmentOut" class="col-sm-4 control-label">Consignment Out</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="consignmentOut" name="consignmentOut" value="#consignmentOut#" placeholder="Consignment Out">									
                                        </div>
                                    </div>                   
                                </div>
                            </div>
                        </div>
                    </div>
                </div>  
                <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" href="##panel2Collapse">
                        <h4 class="panel-title accordion-toggle">Customer Profile Remark(s)</h4>
                    </div>
                    <div id="panel2Collapse" class="panel-collapse collapse in">    
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-sm-6">
                                    <cfloop index="1" from="1" to="4">
                                        <div class="form-group">
                                            <label for="customerRemark#i#" class="col-sm-4 control-label">Remark #i#</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="customerRemark#i#" name="customerRemark#i#" value="evaluate('customerRemark#i#')" placeholder="Remark #i#">									
                                            </div>
                                        </div>                        
                                    </cfloop>
                                </div>
                            </div>
                        </div>
                    </div>
                </div> 						
                ---> 
    
                <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" href="##panel4Collapse">
                        <h4 class="panel-title accordion-toggle">Transaction Description</h4>
                    </div>
                    <div id="panel4Collapse" class="panel-collapse collapse in">    
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label for="desp" class="col-sm-4 control-label">Invoice Description</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="INVdesp" name="InvDesp" value="#InvDesp#" placeholder="Invoice Description">									
                                        </div>
                                    </div>                                  
                                    <div class="form-group">
                                        <label for="do_desp" class="col-sm-4 control-label">Delivery Order Description</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="DOdesp" name="DOdesp" value="#DOdesp#" placeholder="Delivery Order Description">									
                                        </div>
                                    </div>                                  
                                    <div class="form-group">
                                        <label for="so_desp" class="col-sm-4 control-label">Sales Order Description</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="SOdesp" name="SOdesp" value="#SOdesp#" placeholder="Sales Order Description">									
                                        </div>
                                    </div>                                  
                                    <div class="form-group">
                                        <label for="quo_desp" class="col-sm-4 control-label">Quotation Description</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="QUOdesp" name="QUOdesp" value="#QUOdesp#" placeholder="Quotation Description">									
                                        </div>
                                    </div>                                  
                                    <div class="form-group">
                                        <label for="cs_desp" class="col-sm-4 control-label">Cash Sales Description</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="CSdesp" name="CSdesp" value="#CSdesp#" placeholder="Cash Sales Description">									
                                        </div>
                                    </div>                                  
                                    <div class="form-group">
                                        <label for="cn_desp" class="col-sm-4 control-label">Credit Note Description</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="CNdesp" name="CNdesp" value="#CNdesp#" placeholder="Credit Note Description">									
                                        </div>
                                    </div>                                  
                                    <div class="form-group">
                                        <label for="dn_desp" class="col-sm-4 control-label">Debit Note Description</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="DNdesp" name="DNdesp" value="#DNdesp#" placeholder="Debit Note Description">									
                                        </div>
                                    </div>                                  
                                    <div class="form-group">
                                        <label for="po_desp" class="col-sm-4 control-label">Purchase Order Description</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="POdesp" name="POdesp" value="#POdesp#" placeholder="Purchase Order Description">									
                                        </div>
                                    </div>                                  
                                    <div class="form-group">
                                        <label for="rq_desp" class="col-sm-4 control-label">Purchase Requisition Description</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="RQdesp" name="RQdesp" value="#RQdesp#" placeholder="Purchase Requisition Description">									
                                        </div>
                                    </div>                                  
                                    <div class="form-group">
                                        <label for="pr_desp" class="col-sm-4 control-label">Purchase Return Description</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="PRdesp" name="PRdesp" value="#PRdesp#" placeholder="Purchase Return <strong></strong>">									
                                        </div>
                                    </div>                                  
                                    <div class="form-group">
                                        <label for="rc_desp" class="col-sm-4 control-label">Purchase Receive Description </label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="RCdesp" name="RCdesp" value="#RCdesp#" placeholder="Purchase Receive Description">									
                                        </div>
                                    </div>                   
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
    
                <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" href="##panel5Collapse">
                        <h4 class="panel-title accordion-toggle">Transaction Header</h4>
                    </div>
                    <div id="panel5Collapse" class="panel-collapse collapse in">    
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label for="refNo2" class="col-sm-4 control-label">Ref No 2</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="refNo2" name="refNo2" value="#refNo2#" placeholder="Reference Number 2">									
                                        </div>
                                    </div>   
                                    <div class="form-group">
                                        <label for="desp" class="col-sm-4 control-label">Description</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control input-sm" id="desp" name="desp" value="#desp#" placeholder="Description">									
                                        </div>
                                    </div> 
                                    <cfloop index="i" from="5" to="11">                                                                
                                        <div class="form-group">
                                            <label for="headerRemark#i#" class="col-sm-4 control-label">Header Remark #i#</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="headerRemark#i#" name="headerRemark#i#" value="#evaluate('headerRemark#i#')#" placeholder="Header Remark #i#">									
                                            </div>
                                        </div>
                                    </cfloop>
                                    <cfloop index="i" from="30" to="49">                                                                
                                        <div class="form-group">
                                            <label for="headerRemark#i#" class="col-sm-4 control-label">Header Remark #i#</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="headerRemark#i#" name="headerRemark#i#" value="#evaluate('headerRemark#i#')#" placeholder="Header Remark #i#">									
                                            </div>
                                        </div>
                                    </cfloop> 
                                    <cfloop index="i" from="0" to="11">                                                                
                                        <div class="form-group">
                                            <label for="remark#i#" class="col-sm-4 control-label">Remark #i#</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="remark#i#" name="remark#i#" value="#evaluate('remark#i#')#" placeholder="Remark #i#">									
                                            </div>
                                        </div>
                                    </cfloop>                 
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" href="##panel6Collapse">
                        <h4 class="panel-title accordion-toggle">Transaction Body</h4>
                    </div>
                    <div id="panel6Collapse" class="panel-collapse collapse in">    
                        <div class="panel-body">
                            <div class="row">
                                <cfloop index="i" from="1" to="4">  
                                    <div class="col-sm-6">    
                                        <div class="form-group">
                                            <label for="bodyRemark#i#" class="col-sm-4 control-label">Body Remark #i#</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="bodyRemark#i#" name="bodyRemark#i#" value="#evaluate('bodyRemark#i#')#" placeholder="Body Remark #i#">									
                                            </div>
                                        </div>                                                
                                	</div>
                                </cfloop>  
                            </div>
                        </div>
                    </div>
                </div> 
                         
                <div class="panel panel-default">
                    <div class="panel-heading" data-toggle="collapse" href="##panel7Collapse">
                        <h4 class="panel-title accordion-toggle">Transaction Footer</h4>
                    </div>
                    <div id="panel7Collapse" class="panel-collapse collapse in">    
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-sm-6"> 
                                    <cfloop index="i" from="1" to="7">          
                                        <div class="form-group">
                                            <label for="miscCharge#i#" class="col-sm-4 control-label">Misc. Charges #i#</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control input-sm" id="miscCharge#i#" name="miscCharge#i#" value="#evaluate('miscCharge#i#')#" placeholder="Misc. Charges #i#">									
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
                <input type="button" value="Reset" onclick="window.location='/latest/maintenance/groupProfile.cfm'" class="btn btn-default" />
            </div>
    </form>
</cfoutput>
</body>
</html>

