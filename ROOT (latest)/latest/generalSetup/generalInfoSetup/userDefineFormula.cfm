
<cfset pageTitle="User Defined - Formula">
<cfquery name="getGsetup" datasource='#dts#'>
	SELECT * 
	FROM gsetup 
	WHERE companyid = 'IMS';
</cfquery>

	<cfset quantityFormula = getGsetup.qtyformula>
    <cfset priceFormula = getGsetup.priceformula>
    <cfset Define_1 = getGsetup.xqty1>
    <cfset Define_2 = getGsetup.xqty2>
    <cfset Define_3 = getGsetup.xqty3>
    <cfset Define_4 = getGsetup.xqty4>
    <cfset Define_5 = getGsetup.xqty5>
    <cfset Define_6 = getGsetup.xqty6>
    <cfset Define_7 = getGsetup.xqty7>

    <cfset value1 = replace(getGsetup.qtyformula,'xqty1','Define_1','all')>
    <cfset value2 = replace(value1,'xqty2','Define_2','all')>
    <cfset value3 = replace(value2,'xqty3','Define_3','all')>
    <cfset value4 = replace(value3,'xqty4','Define_4','all')>
    <cfset value5 = replace(value4,'xqty5','Define_5','all')>
    <cfset value6 = replace(value5,'xqty6','Define_6','all')>
    <cfset value7 = replace(value6,'xqty7','Define_7','all')>
    
    <cfset value11 = replace(getGsetup.priceformula,'xqty1','Define_1','all')>
    <cfset value12 = replace(value11,'xqty2','Define_2','all')>
    <cfset value13 = replace(value12,'xqty3','Define_3','all')>
    <cfset value14 = replace(value13,'xqty4','Define_4','all')>
    <cfset value15 = replace(value14,'xqty5','Define_5','all')>
    <cfset value16 = replace(value15,'xqty6','Define_6','all')>
    <cfset value17 = replace(value16,'xqty7','Define_7','all')>


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
    
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
    <script type="text/javascript">
		
		function verify(fieldname,s){
			
			var word_list = s.split(/\W/);
				
			for(i=0;i<word_list.length;i++){
				if(word_list[i].search(/\D/)!='-1'){
					if(word_list[i]!='Define_1' && word_list[i] !='Define_2' && word_list[i] !='Define_3' && word_list[i] !='Define_4' && word_list[i] !='Define_5' && word_list[i] !='Define_6' && word_list[i] !='Define_7' && word_list[i] !='xfactor1' && word_list[i] !='xfactor2' && word_list[i] !='round' && word_list[i] !='int' && word_list[i] !='iif'){
						alert('Variable '+word_list[i]+' is not found!');
						document.getElementById(fieldname).focus();
						break;
					}
				}			
			}
		}
	
	</script>
</head>

<body class="container">
<cfoutput>
<form class="form-horizontal" role="form" action="/latest/generalSetup/generalInfoSetup/userDefineFormulaProcess.cfm" method="post">
	<div class="page-header">
		<h3>#pageTitle#</h3>
	</div>
		<div class="panel-group">
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##firstCollapse">
						<h4 class="panel-title accordion-toggle">Formulae</h4>
					</div>
					<div id="firstCollapse" class="panel-collapse collapse in">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">							
									<div class="form-group">
										<label for="quantityFormula" class="col-sm-4 control-label">Quantity Formula</label>
                                        <div class="col-sm-8">
                                       		<input type="text" class="form-control input-sm" id="quantityFormula" name="quantityFormula" value="#value7#" placeholder="Formula for Quantity" onBlur="verify('qtyformula',this.value);" />
										</div>	
									</div>	
                                    
                                    <div class="form-group">
										<label for="priceFormula" class="col-sm-4 control-label">Price Formula</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="priceFormula" name="priceFormula" value="#value17#" placeholder="Formula for Price" onBlur="verify('qtyformula',this.value);" />									
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
                	
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##secondCollapse">
						<h4 class="panel-title accordion-toggle">User Define</h4>
					</div>
					<div id="secondCollapse" class="panel-collapse collapse in">
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-6">                      
                                 <div class="form-group">
										<label for="Define_1" class="col-sm-4 control-label">Define_1</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="Define_1" name="Define_1" value="#Define_1#" placeholder="Define 1">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="Define_2" class="col-sm-4 control-label">Define_2</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="Define_2" name="Define_2" value="#Define_2#" placeholder="Define 2">									
										</div>
									</div>
                                    
                                    <div class="form-group">
                                    <label for="Define_3" class="col-sm-4 control-label">Define_3</label>
                                      <div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="Define_3" name="Define_3" value="#Define_3#" placeholder="Define 3">									
									  </div>
								  </div>
                                    
                                    <div class="form-group">
										<label for="Define_4" class="col-sm-4 control-label">Define_4</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="Define_4" name="Define_4" value="#Define_4#" placeholder="Define 4">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="Define_5" class="col-sm-4 control-label">Define_5</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="Define_5" name="Define_5" value="#Define_5#" placeholder="Define 5">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="Define_6" class="col-sm-4 control-label">Define_6</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="Define_6" name="Define_6" value="#Define_6#" placeholder="Define 6">									
										</div>
									</div>
                                    
                                    <div class="form-group">
										<label for="Define_7" class="col-sm-4 control-label">Define_7</label>
										<div class="col-sm-8">
											<input type="text" class="form-control input-sm" id="Define_7" name="Define_7" value="#Define_7#" placeholder="Define 7">									
										</div>
									</div>

							  </div>
							</div>
						</div>
					</div>
				</div>
                
               
            
            <div class="pull-right">
				<input type="submit" value="Save" class="btn btn-primary"/>
				<input type="reset" value="Reset" class="btn btn-primary"/>
			</div>
</form>
</cfoutput>
</body>
</html>

