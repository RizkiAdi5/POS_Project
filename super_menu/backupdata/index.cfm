<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/latest/css/maintenance/target.css">		
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
<title>Database</title>
</head>
<body class="container">

<font color="red" size="2.5">
<cfif isdefined("form.status")>
<cfoutput>#form.status#
</cfoutput>
</cfif>
</font>

<cfoutput>
	<form class="form-horizontal" role="form" action="process.cfm" method="post" onsubmit="if(confirm('Are you sure want to backup?')){ColdFusion.Window.show('processing');return true;} else {return false;}">
        <div class="page-header">
            <h3>Database</h3>
        </div>
        <div class="panel-group">
                    <div class="panel panel-default">
                        <div class="panel-heading" data-toggle="collapse" href="##mainInfoCollapse">
                            <h4 class="panel-title accordion-toggle">Back Up Data</h4>
                        </div>
                        <div id="mainInfoCollapse" class="panel-collapse collapse in">
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label for="compro" class="col-sm-4 control-label">Remark:</label>
                                            <div class="col-sm-4">
                                                <input type="text" name="remark" id="remark" />
                                            </div>
                                            <div class="pull-right col-sm-4">
												<input type="submit" value="Backup" name="save" class="btn btn-primary" />
											</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
         </div>
         <div class="panel panel-default">
                        <div class="panel-heading" data-toggle="collapse" href="##mainInfoCollapse2">
                            <h4 class="panel-title accordion-toggle">Repair Data</h4>
                        </div>
                        <div id="mainInfoCollapse2" class="panel-collapse collapse in">
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group">  
                                            <label for="compro" class="col-sm-4 control-label">Repair Data:</label>
                                        	<div class="pull-right col-sm-8">
												<input type="button" value="Repair" name="repair" class="btn btn-primary" onclick="location.href = '../../repairtable1.cfm';"  />
											</div>                                       
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
          </div>
            
	</form>
            
</cfoutput>
<cfwindow name="processing" width="300" height="300" initshow="false"  draggable="false" title="Processing....Please Wait" modal="true" resizable="false" >
<h1>Processing....Please Wait</h1>
<img src="/images/loading.gif" align="middle" />
</cfwindow>
</body>
</html>

<!---<form action="process.cfm" method="post" onsubmit="if(confirm('Are you sure want to backup?')){ColdFusion.Window.show('processing');return true;} else {return false;}">
Remarks:&nbsp;&nbsp;&nbsp;<input type="text" name="remark" id="remark" />
		&nbsp;&nbsp;&nbsp;<input type="submit" name="save" value="Backup" >
</form>--->