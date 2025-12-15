<cfquery name="getGsetup" datasource="#dts#">
  Select * from GSetup g
</cfquery>

<cfquery datasource='#dts#' name="getartran">
	select * from artran where refno='#refno#' and type = "#tran#"
</cfquery>

<cfif getartran.posted eq "P">
	<h3>Transaction already posted.</h3>
	<cfabort>
</cfif>
<cfif getGsetup.enableedit neq 'Y'>
<cfif getartran.toinv neq ''>
	<h3>Not Allowed to Edit.</h3>
	<cfabort>
</cfif>
</cfif>

<cfif getartran.fperiod eq '99' and getgsetup.allowedityearend neq "Y" >
	<h3>Not Allowed to Edit. Transaction already year-ended.</h3>
	<cfabort>
<cfelseif getartran.fperiod eq '99' and getgsetup.allowedityearend  eq "Y" and tran neq "SO" and tran neq "PO" and tran neq "QUO" and tran neq "SAM">
<h3>Not Allowed to Edit. Transaction already year-ended.</h3>
	<cfabort>
</cfif>

<cfif getGsetup.periodalfr neq "01">
	<cfloop from="1" to="#val(getGsetup.periodalfr)-1#" index="a">
		<cfif val(getartran.fperiod) eq val(a)>
			<h3>Period Allowed from <cfoutput>#getGsetup.periodalfr# to 18.</cfoutput></h3>
			<cfabort>
		</cfif>
	</cfloop>
</cfif>
	
<html>
<head>
	<title></title>
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	
	<script type='text/javascript' src='../../ajax/core/engine.js'></script>
	<script type='text/javascript' src='../../ajax/core/util.js'></script>
	<script type='text/javascript' src='../../ajax/core/settings.js'></script>
	
	<script language="javascript" type="text/javascript">
		<cfoutput>
		var tran='#tran#';
		var refno='#refno#';
		var revStyle='#getGsetup.revStyle#';
		var parentpage='#parentpage#';
		</cfoutput>
		
		function closeChild(yesno){
			if(yesno=='no'){
				if(parentpage=='no'){
					<cfoutput>window.opener.location.href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(getartran.custno)#&first=0";</cfoutput>
				}else{
					<cfoutput>window.opener.parent.location.href="tran_edit2.cfm?tran=#tran#&ttype=Edit&refno=#refno#&custno=#URLEncodedFormat(getartran.custno)#&first=0";</cfoutput>
				}
				
				self.close();
			}else{
				document.invoicesheet.btnyes.disabled=true;
				document.invoicesheet.btnno.disabled=true;
				DWREngine._execute(_tranflocation, null, 'generateQuoRev', tran, refno, revStyle, showResult);
			}
		}
		
		function showResult(resultObject){
			//alert(resultObject.ERROR);
			if(parentpage=='no'){
				<cfoutput>window.opener.location.href="tran_edit2.cfm?tran="+resultObject.TRAN+"&ttype=Edit&refno="+resultObject.REFNO+"&custno=#URLEncodedFormat(getartran.custno)#&first=0";</cfoutput>
			}else{
				<cfoutput>window.opener.parent.location.href="tran_edit2.cfm?tran="+resultObject.TRAN+"&ttype=Edit&refno="+resultObject.REFNO+"&custno=#URLEncodedFormat(getartran.custno)#&first=0";</cfoutput>
			}
			
			self.close();
		}
	</script>
</head>
<body>

<form name="invoicesheet" action="" method="post">
	<div align="center">
	  	<h3>Generate a Revision?</h3>
		<input type="button" name="btnyes" value="Yes" onClick="closeChild('yes');">&nbsp;<input type="button" name="btnno" value="No" onClick="closeChild('no');">
	</div>
</form>
</body>
</html>