<cfif IsDefined("form.submit")>
	<cffile 
		action="upload" 
		destination="#ExpandPath( "/" )#billformat\#dts#\companylogo.jpg" 
		filefield="logo" 
		accept="image/jpeg" 
		nameconflict="overwrite">
	<script type="text/javascript">
		top.frames['topFrame'].document.location.reload(true);
		alert('Company logo was uploaded succeassfully.');
	</script>
</cfif>
<cfquery name="getGsetup" datasource="#dts#">
	SELECT compro,period,lastaccyear 
    FROM gsetup;
</cfquery>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Upload Company Logo</title>
<link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
<!--[if lt IE 9]>
	<script type="text/javascript" src="/latest/js/html5shiv/html5shiv.js"></script>
	<script type="text/javascript" src="/latest/js/respond/respond.min.js"></script>
<![endif]-->
<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
<script type="text/javascript">
function validate(){
	var errorMsg='';
	if($('#logo')[0].files.length==0){
		errorMsg=errorMsg+'Please upload your Company Logo.';
	}else{
		if($('#logo')[0].files[0].type!='image/jpeg'){
			errorMsg=errorMsg+'Only JPEG image format is allowed.\n';
		}
		if($('#logo')[0].files[0].size>500*1024){
			errorMsg=errorMsg+'Only file with file size less than 500KB is allowed.\n';
		}
	}
	if(errorMsg!=''){
		alert(errorMsg);
		return false;
	}else{
		return true;
	}
}
</script>
</head>
<body>
<cfoutput>
	<div class="container">
		<div class="page-header">
			<h1>Upload Company Logo</h1>
			<span class="lead text-muted">Only JPEG image file with file size less than 500KB is allowed.</span>
		</div>
		<div class="row">
			<form role="form" id="form" class="container" action="/latest/body/uploadLogo.cfm" method="post" enctype="multipart/form-data" onSubmit="return validate();">
				<div class="form-group row">
					<div class="col-sm-12">
						<label for="logo">Upload Company Logo</label>
						<input type="file" class="form-control" id="logo" name="logo" placeholder="Upload your company logo" accept="image/jpeg" required="required" />
					</div>
				</div>
				<hr />
				<button type="submit" id="submit" name="submit" class="btn btn-default pull-right">Submit</button>
			</form>
		</div>
	</div>
</cfoutput>
</body>
</html>