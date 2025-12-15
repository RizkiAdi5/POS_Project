<cfif not len(getAuthUser())>
	<cfoutput>
        <script type="text/javascript">
        </script>
    </cfoutput>
</cfif>

<cfset targetTitle="Ticket">

<!---2/8/2012--->
<cfquery name="getmemID" datasource="#dts#">
select id from security where username = '#getauthuser()#'
</cfquery>

<cfquery name="getRole" datasource="#dts#">
select role from securitylink where securityid = '#getmemID.id#'
</cfquery>

<cfquery name="getroleID" datasource="#dts#">
SELECT id FROM role where role = '#getRole.role#'
</cfquery>

<cfquery name="getUser" datasource="#dts#">
select * from udefine2 where levelid = '#getroleID.id#'
</cfquery>
<!---2/8/2012--->
<cfquery name="getclient" datasource="#dts#">
select TicClientID, TicClientCode, TicClientName, ClientSource from tic_client_mstr where ticclientstatus = 'Active'
</cfquery>

<cfquery name="getSys" datasource="#dts#">
select SysID, SysCode, SysName from tic_system
</cfquery>

<cfquery name="getTicType" datasource="#dts#">
select TicTypeID, TicTypeCode, TicTypeDesc from tic_type where status = 'Active'
</cfquery>

<cfquery name="getSource" datasource="#dts#">
select SourceID, SourceCode, SourceDesc from tic_svrsource where status = 'Active'
</cfquery>

<cfquery name="getmaxatt" datasource="#dts#">
select settingvalue from tic_setting where settingcode = 'MAXATTACH'
</cfquery>

<cfquery name="getAllUser" datasource="#dts#">
	select sec.username, firstname, lastname
	from net_c.security sec, net_c.member mem
	where sec.memberid = mem.id
	and sec.id >= 22
</cfquery>



<cfif action eq "Create">
	<cfset eTicNo = "">
	<cfset eTicID = "">
	<cfset eTicNo = "">
	<cfset eTicDate = dateformat(Now(),"dd/mm/yyyy")>
	<cfset eTicStatus = "NEW">
	<cfset eTicServerity = "">
	<cfset eTargetDate = "">
	<cfset eTicType = "">
	<cfset eClientCode = "">
	<cfset eClientName = "">
	<cfset eClientSource = "">
	<cfset eSS = "">
	<cfset eSysCode = "">
	<cfset eContactNo = "">
	<cfset eCemail = "">
	<cfset eAemail = "">
	<cfset eFName = "">
	<cfset eSubject = "">
	<cfset ePD = "">
	<cfset eDSR = "">
	<cfset eSSR = "">
	<cfset eDSR_showFlag = "N">
	<cfset eSSR_showFlag = "N">
	<cfset eSowner = "">
	<cfset eCreatedBy = getauthuser()>
	<cfset eCreatedDateTime = dateformat(now(),"dd/mm/yyyy") & " " & timeformat(now(),"HH:mm:ss")>
	<cfset eUpdatedBy = "">
	<cfset eUpdatedDateTime = "">
	<cfset actionpage = "ticket_addprocess.cfm?type=add">

	<cfset eTicServerity_editFlag = "Y">
	<cfset eTicType_editFlag = "Y">
	<cfset eClientCode_editFlag = "Y">
	<cfset eSysCode_editFlag = "Y">
	<cfset eCemail_editFlag = "Y">
	<cfset eAemail_editFlag = "Y">
	<cfset eFName_editFlag = "Y">
	<cfset eSubject_editFlag = "Y">
	<cfset ePD_editFlag = "Y">
	<cfset eAtt_editFlag = "Y">
	<cfset eSowner_editFlag = "1">
	<cfset eContactNo_editFlag = "Y">

	<cfset MainButton = "Create">

<cfelseif action eq "Edit">

	<cfquery name="getMstrInfo" datasource="#dts#">
	select *
	from tic_mstr
	where TicID = '#URLTicID#'
	</cfquery>

	<cfquery name="getTType" datasource="#dts#">
	select TicTypeCode
	from tic_type
	where TicTypeID =  '#getMstrInfo.TicTypeID#'
	</cfquery>

	<cfquery name="getCLI" datasource="#dts#">
	select TicClientCode,TicClientName, ClientSource
	from tic_client_mstr
	where TicClientID = '#getMstrInfo.TicClientID#'
	</cfquery>

	<cfquery name="getCLISS" datasource="#dts#">
	select ServerSource
	from tic_client_dtl
	where TicClientID = '#getMstrInfo.TicClientID#'
	AND sysid = '#getMstrInfo.SysID#'
	</cfquery>

	<cfquery name="getSysCode" datasource="#dts#">
	select SysCode, SysName
	from tic_system
	where SysID = '#getMstrInfo.SysID#'
	</cfquery>

	<cfquery name="getSys" datasource="#dts#">
	select ts.SysCode, ts.SysName
	from tic_client_dtl cd, tic_system ts
	where cd.sysid = ts.sysid
	and cd.TicClientID = '#getMstrInfo.TicClientID#'
	</cfquery>

	<cfset eTicID = getMstrInfo.TicID>
	<cfset eTicNo = getMstrInfo.TicNo>
	<cfset eTicDate = dateformat(getMstrInfo.TicDate,"dd/mm/yyyy")>
	<cfset eTicStatus = getMstrInfo.TicStatus>
	<cfset eTargetDate = dateformat(getMstrInfo.TargetResDate,"dd/mm/yyyy")>
	<cfset eTicServerity = getMstrInfo.TicServ>
	<cfset eTicType = getTType.TicTypeCode>
	<cfset eClientCode = getCLI.TicClientCode>
	<cfset eClientName = getCLI.TicClientName>
	<cfset eClientSource = getCLI.ClientSource>
	<cfset eSS = getCLISS.ServerSource>
	<cfset eSysCode = getSysCode.SysCode>
	<cfset eContactNo = getMstrInfo.contactno>
	<cfset eCemail = getMstrInfo.CEmail>
	<cfset eAemail = getMstrInfo.AEmail>
	<cfset eFName = getMstrInfo.FName>
	<cfset eSubject = getMstrInfo.Subject>
	<cfset ePD = getMstrInfo.ProblemDesc>
	<cfset eDSR = getMstrInfo.dSignoffRemarks>
	<cfset eSSR = getMstrInfo.sSignoffRemarks>
	<cfset eSowner = getMstrInfo.SupportOwner>
	<cfset eCreatedBy = getMstrInfo.CreatedBy>
	<cfset eCreatedDateTime = dateformat(getMstrInfo.CreatedDateTime,"dd/mm/yyyy") & " " & timeformat(getMstrInfo.CreatedDateTime,"HH:mm:ss")>
	<cfset eUpdatedBy = getMstrInfo.UpdatedBy>
	<cfset eUpdatedDateTime = dateformat(getMstrInfo.UpdatedDateTime,"dd/mm/yyyy") & " " & timeformat(getMstrInfo.UpdatedDateTime,"HH:mm:ss")>
	<cfset actionpage = "ticket_editprocess.cfm?type=edit&eTicID=#eTicID#&eTicNo=#eTicNo#">
	<cfset eSowner_editFlag = "2">

	<cfif getMstrInfo.TicStatus eq "NEW">

		<cfset eTicServerity_editFlag = "Y">
		<cfset eTicType_editFlag = "Y">
		<cfset eClientCode_editFlag = "Y">
		<cfset eSysCode_editFlag = "Y">
		<cfset eCemail_editFlag = "Y">
		<cfset eAemail_editFlag = "Y">
		<cfset eFName_editFlag = "Y">
		<cfset eSubject_editFlag = "Y">
		<cfset ePD_editFlag = "Y">
		<cfset eDSR_showFlag = "N">
		<cfset eSSR_showFlag = "N">
		<cfset eAtt_editFlag = "Y">
		<cfset eContactNo_editFlag = "Y">
		<cfset MainButton = "Save">
		<cfset KIVButton = "KIV">
		<cfset CancelButton = "Cancel">
		<cfset ConfirmButton = "Save & Confirm">

	<cfelseif getMstrInfo.TicStatus eq "KIV" or getMstrInfo.TicStatus eq "CANCELLED" or getMstrInfo.TicStatus eq "RESOLVED" or getMstrInfo.TicStatus eq "COMPLETED" or getMstrInfo.TicStatus eq "CLOSED">

		<cfset eTicServerity_editFlag = "N">
		<cfset eTicType_editFlag = "N">
		<cfset eClientCode_editFlag = "N">
		<cfset eSysCode_editFlag = "N">
		<cfset eCemail_editFlag = "N">
		<cfset eAemail_editFlag = "N">
		<cfset eFName_editFlag = "N">
		<cfset eSubject_editFlag = "N">
		<cfset ePD_editFlag = "N">
		<cfset eAtt_editFlag = "N">
		<cfset eDSR_showFlag = "N">
		<cfset eSSR_showFlag = "N">
		<cfset eContactNo_editFlag = "N">
		<cfif getMstrInfo.TicStatus eq "KIV">
		<cfset CancelButton = "Cancel">
		</cfif>

		<cfif getMstrInfo.TicStatus eq "RESOLVED" or getMstrInfo.TicStatus eq "COMPLETED" or getMstrInfo.TicStatus eq "CLOSED">
		<cfset eDSR_showFlag = "Y">
		</cfif>

		<cfif getMstrInfo.TicStatus eq "COMPLETED" or getMstrInfo.TicStatus eq "CLOSED">
		<cfset eSSR_showFlag = "Y">
		<cfset eSowner_editFlag = "3">
		</cfif>

	<cfelseif getMstrInfo.TicStatus eq "CONFIRMED" or getMstrInfo.TicStatus eq "ASSIGNED">

		<cfset eTicServerity_editFlag = "Y">
		<cfset eTicType_editFlag = "Y">
		<cfset eClientCode_editFlag = "N">
		<cfset eSysCode_editFlag = "N">
		<cfset eCemail_editFlag = "Y">
		<cfset eAemail_editFlag = "Y">
		<cfset eFName_editFlag = "N">
		<cfset eSubject_editFlag = "N">
		<cfset ePD_editFlag = "Y">
		<cfset eAtt_editFlag = "Y">
		<cfset eDSR_showFlag = "N">
		<cfset eSSR_showFlag = "N">
		<cfset eContactNo_editFlag = "Y">
		<cfset MainButton = "Save">

		<cfif getMstrInfo.TicStatus eq "CONFIRMED">
		<cfset CancelButton = "Cancel">
		</cfif>

	</cfif>

	<cfif getMstrInfo.TicStatus eq "CONFIRMED" and (eSowner eq getauthuser())>
		<cfset EsignoffButton = "Express Signoff">
	</cfif>



</cfif>




<html>
<head>
<title><cfoutput>#action# #targetTitle#</cfoutput></title>

<cfoutput>
	<link rel="stylesheet" type="text/css" href="/menulist/css/bootstrap/bootstrap.css">
	<link rel="stylesheet" type="text/css" href="/menulist/css/bootstrap-datepicker/datepicker3.css">
    <link rel="stylesheet" type="text/css" href="/menulist/css/maintenance/target.css">
    <link rel="stylesheet" href="/menulist/css/select2/select2.css" />
    <script type="text/javascript" src="/menulist/js/jquery/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="/menulist/js/bootstrap/bootstrap.min.js"></script>
	<script type="text/javascript" src="/menulist/js/bootstrap-datepicker/bootstrap-datepicker.js"></script>
    <script type="text/javascript" src="/menulist/js/select2/select2.min.js"></script>
    <script type="text/javascript" src="/menulist/js/bootstrap-filestyle/bootstrap-filestyle.min.js"></script>
    <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
	 <link rel="stylesheet" type="text/css" href="/stylesheet/ticket.css">
</cfoutput>
</head>
<style type="text/css">
.modal-dialog {
  position: relative;
  width: auto;
  max-width: 600px;
  margin: 10px;
}
.modal-2g {
  max-width: 900px;
}

</style>
<script>
$(document).ready(function() {
	$('.input-group.date').datepicker({
		format: "dd/mm/yyyy",
		todayBtn: "linked",
		autoclose: true,
		todayHighlight: true
	});

	$("#eTicServerity").select2({ width: '80%' });
	$("#eTicType").select2({ width: '80%' });
	<cfif eSysCode_editFlag eq "Y">
	$("#eClientCode").select2({ width: '80%' });
	</cfif>
	$("#eSysCode").select2({ width: '80%' });
	$("#eSowner").select2({ width: '35%' });
	$("#eFName").width('450px');
	$("#eAemail").width('450px');
	$("#eCemail").width('450px');
	$("#eSubject").width('450px');
	$("#eContactNo").width('450px');

	var elements = document.getElementsByTagName("input");
	for (var ii=0; ii < elements.length; ii++) {
	  if (elements[ii].type == "text") {
	    $(elements[ii]).height('10px');
	   }
	}




});

function AjaxSys(eClientCode){

	$.ajax({
			type:"POST",
			url:"ajaxUpdate/sysAjax.cfm",
			data: {"eClientCode":eClientCode},
			dataType:"html",
			cache:false,
			success: function(result){
				$('#sysdiv').html(result);
				$("#eSysCode").select2({ width: '80%' });
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){

			}
		});

	}

	function AjaxClientName(eClientCode){

	$.ajax({
			type:"POST",
			url:"ajaxUpdate/ClientNameAjax.cfm",
			data: {"eClientCode":eClientCode},
			dataType:"html",
			cache:false,
			success: function(result){
				$('#ClientNamediv').html(result);
				document.getElementById("SSdiv").innerText = '';
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){

			}
		});

	}

	function AjaxSS(eSys){

	var eClientCode = document.getElementById("eClientCode").value;

	$.ajax({
			type:"POST",
			url:"ajaxUpdate/ssAjax.cfm",
			data: {"eClientCode":eClientCode,"eSys":eSys},
			dataType:"html",
			cache:false,
			success: function(result){
				$('#SSdiv').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){

			}
		});

	}

	function AjaxCemail(){

	var eClientCode = document.getElementById("eClientCode").value;
	var eSysCode = document.getElementById("eSysCode").value;

	$.ajax({
			type:"POST",
			url:"ajaxUpdate/cEmailAjax.cfm",
			data: {"eClientCode":eClientCode,"eSysCode":eSysCode},
			dataType:"html",
			cache:false,
			success: function(result){
				$('#cemaildiv').html(result);
				$("#eCemail").height('10px');
				$("#eCemail").width('450px');

			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){

			}
		});

	}

var _validFileExtensions = [".jpg", ".jpeg", ".gif", ".png", ".pdf", ".doc", ".docx", ".xls", ".xlsx"];

function ValidateFileExt(oForm) {

    var arrInputs = oForm.getElementsByTagName("input");
    for (var i = 0; i < arrInputs.length; i++) {
        var oInput = arrInputs[i];
        if (oInput.type == "file") {
            var sFileName = oInput.value;
            if (sFileName.length > 0) {
                var blnValid = false;
                for (var j = 0; j < _validFileExtensions.length; j++) {
                    var sCurExtension = _validFileExtensions[j];
                    if (sFileName.substr(sFileName.length - sCurExtension.length, sCurExtension.length).toLowerCase() == sCurExtension.toLowerCase()) {
                        blnValid = true;
                        break;
                    }
                }

                if (!blnValid) {
                    alert("Sorry, " + sFileName + " is invalid, allowed extensions are: " + _validFileExtensions.join(", "));
                    return false;
                }
            }
        }
    }


	if(AddEditForm.actionClick.value == 'Cancel'){
		if(confirm('Are you sure you want to Cancel this Ticket?')){
			 return true;
		}
		else{
			return false;
		}

	}

	if(AddEditForm.actionClick.value == 'KIV'){
		if(confirm('Are you sure you want to KIV this Ticket?')){
			 return true;
		}
		else{
			return false;
		}

	}

	if(AddEditForm.actionClick.value == 'Confirm'){
		if(confirm('Are you sure you want to Confirm this Ticket?')){
			 return true;
		}
		else{
			return false;
		}

	}

	if(AddEditForm.actionClick.value == 'Esignoff'){
		if(confirm('Are you sure you want to Express Signoff this Ticket?')){
			 return true;
		}
		else{
			return false;
		}

	}


}

function DeleteFile(fileid,filename,ticid,maxatt) {

	if(confirm('Are you sure you want to delete this attachment?')){
		$.ajax({
					type:"POST",
					url:"ajaxUpdate/deleteFileAjax.cfm",
					data: {"fileid":fileid,"filename":filename,"ticid":ticid,"maxatt":maxatt},
					dataType:"html",
					cache:false,
					success: function(result){
						$('#attTable').html(result);
						var elements = document.getElementsByTagName("input");
							for (var ii=0; ii < elements.length; ii++) {
							  if (elements[ii].type == "text") {
							    $(elements[ii]).height('10px');
							   }
							}

					},
					error: function(jqXHR,textStatus,errorThrown){
					},
					complete: function(){
						alert('Attachment deleted successfully!');
					}
				});

	}

}

function updateAct(act){

			AddEditForm.actionClick.value = act;

}

<cfif isDefined("eTicID") and eTicID neq "">
function getContactData(){


	var eClientCode = document.getElementById("eClientCode").value;
	var eTicID = document.getElementById("eTicID").value;

	$.ajax({
			type:"POST",
			url:"ajaxUpdate/contactAjax.cfm",
			data: {"eClientCode":eClientCode,"eTicID":eTicID},
			dataType:"html",
			cache:false,
			success: function(result){
				$('#ContactDiv').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){

			}
		});


}
<cfelse>
function getContactData(){


	var eClientCode = document.getElementById("eClientCode").value;

	$.ajax({
			type:"POST",
			url:"ajaxUpdate/contactAjax.cfm",
			data: {"eClientCode":eClientCode},
			dataType:"html",
			cache:false,
			success: function(result){
				$('#ContactDiv').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){

			}
		});


}
</cfif>

function getTicInfo(ticid){

	$.ajax({
			type:"POST",
			url:"ajaxUpdate/TicAjax.cfm",
			data: {"ticid":ticid},
			dataType:"html",
			cache:false,
			success: function(result){
				$('#OutstandingdtlDiv').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){

			}
		});


}


function getOutStandingData(){


	var eClientCode = document.getElementById("eClientCode").value;

	$.ajax({
			type:"POST",
			url:"ajaxUpdate/outStandingAjax.cfm",
			data: {"eClientCode":eClientCode},
			dataType:"html",
			cache:false,
			success: function(result){
				$('#OustandingDiv').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){

			}
		});


}


</script>

<cfoutput>
<body>
	<form id="AddEditForm" name="AddEditForm" method="POST" action="#actionpage#" enctype="multipart/form-data" onsubmit="return(ValidateFileExt(this));">
		<div class="container">
			<div class="page-header">
	            <h3>#action# Ticket</h3>
	            <h4><center>
		            <cfif isDefined("SuccessMsg")><img src="/images/success.png" width="30px" height="30px">#SuccessMsg#</cfif>
		            <cfif isDefined("ErrMsg")><br><img src="/images/error.png" width="30px" height="30px">#ErrMsg#</cfif>
				</center></h4>
			</div>
			<div class="panel-group">
				<div class="panel panel-default">
					<div class="panel-heading" data-toggle="collapse" href="##basicCollapse">
						<h4 class="panel-title accordion-toggle">Basic Information</h4>
					</div>
					<div id="basicCollapse" class="panel-collapse collapse in">
						<div class="panel-body">
							<center>
							<table border=1 cellspacing="0" width="95%">
								<tr class="csstitle">
									<td width="100%" colspan="4"><span class="cssTitleText">Ticket Information</span></td>
								</tr>
								<tr class="cssline1">
									<td class="cssLabel" width="25%">Ticket No</td>
									<td class="cssText" width="25%"><cfif eTicNo neq "">
																		#eTicNo#<input type="hidden" name="eTicID" id="eTicID" value="#eTicID#">
																	<cfelse>
																		<b><i>&lt;System Generated&gt;</i></b>
																	</cfif>
									</td>
									<td class="cssLabel" width="25%">Ticket Date</td>
									<td class="cssText" width="25%">#eTicDate#</td>
								</tr>
								<tr class="cssline2">
									<td class="cssLabel">Ticket Status</td>
									<td class="cssText">#eTicStatus#</td>
									<td class="cssLabel">Target Date</td>
									<td class="cssText">#eTargetDate#</td>
								</tr>
								<tr class="cssline1">
									<td class="cssLabel">Ticket Severity <cfif eTicServerity_editFlag eq "Y"><font color="red">*</font></cfif></td>

									<cfif eTicServerity_editFlag eq "Y">
									<td class="cssText"><div class="contenedor-select2"><select id="eTicServerity" name="eTicServerity" required>
														<option value="">Please select Ticket Severity</option>
														<option value="Critical" <cfif eTicServerity eq "Critical">selected</cfif>>Critical</option>
														<option value="High" <cfif eTicServerity eq "High">selected</cfif>>High</option>
														<option value="Medium" <cfif eTicServerity eq "Medium">selected</cfif>>Medium</option>
														<option value="Low" <cfif eTicServerity eq "Low">selected</cfif>>Low</option>
														</select></div>
									</td>
									<cfelse>
									<td class="cssText">
									#eTicServerity#
									</td>
									</cfif>
									<td class="cssLabel">Ticket Type <cfif eTicType_editFlag eq "Y"><font color="red">*</font></cfif></td>
									<cfif eTicType_editFlag eq "Y">
									<td class="cssText"><div class="contenedor-select2"><select name="eTicType" id="eTicType" required>
														<option value="">Please select Ticket Type</option>
														<cfloop query="getTicType">
																<option value="#getTicType.TicTypeCode#" <cfif eTicType eq getTicType.TicTypeCode>selected</cfif>>#getTicType.TicTypeCode# - #getTicType.TicTypeDesc#</option>
														</cfloop>
														</select></div>
									</td>
									<cfelse>

									<cfquery name="getTicTypeDesc" datasource="#dts#">
									select TicTypeID, TicTypeCode, TicTypeDesc
									from tic_type
									where TicTypeCode = '#eTicType#'
									</cfquery>
									<td class="cssText">
									#getTicTypeDesc.TicTypeCode# - #getTicTypeDesc.TicTypeDesc#
									</td>
									</cfif>
								</tr>
								<tr class="cssline2">
									<td class="cssLabel">Client Code <cfif eClientCode_editFlag eq "Y"><font color="red">*</font></cfif></td>
									<cfif eClientCode_editFlag eq "Y">
									<td class="cssText"><div class="contenedor-select2"><select name="eClientCode" id="eClientCode" onChange="AjaxClientName(this.value);AjaxSys(this.value);" required>
														<option value="">Please select Client Code</option>
														<cfloop query="getclient">
																<option value="#getclient.TicClientCode#" <cfif eClientCode eq getclient.TicClientCode>selected</cfif>>#getclient.TicClientCode# - #getclient.TicClientName# [#getclient.clientsource#]</option>
														</cfloop>
														</select></div>
									</td>
									<cfelse>
									<td class="cssText">#eClientCode# [#eClientSource#]<input type="hidden" name="eClientCode" id="eClientCode" value="#eClientCode#"></td>
									</cfif>
									<td class="cssLabel">Client Name</td>
									<td class="cssText"><div id="ClientNamediv">#eClientName#</div></td>
								</tr>


								<tr class="cssline1">
									<td class="cssLabel">System <cfif eSysCode_editFlag eq "Y"><font color="red">*</font></cfif></td>
									<cfif eSysCode_editFlag eq "Y">
									<td class="cssText">
										<div id="sysdiv">
										<select name="eSysCode" id="eSysCode"  onChange="AjaxCemail();AjaxSS(this.value);" >
											<option value="">Please select System</option>
											<cfif action eq "Edit">
											<cfloop query="getSys">
											<option value="#getSys.SysCode#" <cfif eSysCode eq getSys.SysCode>selected</cfif>>#getSys.SysCode# - #getSys.SysName#</option>
											</cfloop>
											</cfif>
										</select>
										</div>
									</td>
									<cfelse>
									<td class="cssText">
									#getSysCode.SysCode# - #getSysCode.SysName#
									</td>
									</cfif>
									<td class="cssLabel">Server Source</td>
									<td class="cssText"><div id="SSdiv">#eSS#</div></td>
								</tr>
								</div>
								<tr class="cssline2">
									<td class="cssLabel" width="25%">Contact No</td>
									<cfif eContactNo_editFlag eq "Y">
										<td class="cssText" colspan="3">
											<input class="form-control input-sm" type="text" value="#eContactNo#" id="eContactNo" name="eContactNo" maxlength="100" autocomplete="off">
										</td>
									<cfelse>
										<td class="cssText" colspan="3">
										#eContactNo#
										</td>
									</cfif>
								</tr>
								<tr class="cssline1">
									<td class="cssLabel" width="25%">Client Email</td>
									<cfif eCemail_editFlag eq "Y">
									<td class="cssText" colspan="3">
										<div id="cemaildiv"><input class="form-control input-sm" type="text" value="#eCemail#" id="eCemail" name="eCemail" maxlength="500" autocomplete="off" validate="email" pattern="^[A-Za-z0-9\._%-]+@[A-Za-z0-9\.-]+\.[A-Za-z]{2,4}(?:[;][A-Za-z0-9\._%-]+@[A-Za-z0-9\.-]+\.[A-Za-z]{2,4}?)*"></div>
									</td>
									<cfelse>
									<td class="cssText" colspan="3">
									#eCemail#
									</td>
									</cfif>

								</tr>
								<tr class="cssline2">

									<td class="cssLabel" width="25%">Additional Email</td>
									<cfif eAemail_editFlag eq "Y">
									<td class="cssText" colspan="3">
										<input class="form-control input-sm" type="text" value="#eAemail#" id="eAemail" name="eAemail" maxlength="500" autocomplete="off" validate="email" pattern="^[A-Za-z0-9\._%-]+@[A-Za-z0-9\.-]+\.[A-Za-z]{2,4}(?:[;][A-Za-z0-9\._%-]+@[A-Za-z0-9\.-]+\.[A-Za-z]{2,4}?)*">
									</td>
									<cfelse>
									<td class="cssText" colspan="3">#eAemail#</td>
									</cfif>

								</tr>
								<tr class="cssline1">
									<td class="cssLabel" width="25%">Function Name <cfif eFName_editFlag eq "Y"><font color="red">*</font></cfif></td>
									<cfif eFName_editFlag eq "Y">
									<td class="cssText" colspan="3"><input class="form-control input-sm" type="text" value="#htmlEditFormat(eFName)#" id="eFName" name="eFName" maxlength="100" autocomplete="off" required></td>
									<cfelse>
									<td class="cssText" colspan="3">#eFName#</td>
									</cfif>

								</tr>
								<tr class="cssline2">
									<td class="cssLabel" width="25%">Subject <cfif eSubject_editFlag eq "Y"><font color="red">*</font></cfif></td>
									<cfif eSubject_editFlag eq "Y">
									<td class="cssText" colspan="3"><input class="form-control input-sm" type="text" value="#htmlEditFormat(eSubject)#" id="eSubject" name="eSubject" maxlength="100" autocomplete="off" required></td>
									<cfelse>
									<td class="cssText" colspan="3">#eSubject#</td>
									</cfif>
								</tr>
								<tr class="cssline1">
									<td class="cssLabel" width="25%">Problem Description <cfif ePD_editFlag eq "Y"><font color="red">*</font></cfif></td>
									<td class="cssText" colspan="3"><textarea name="ePD" rows="8" cols="80" required <cfif ePD_editFlag eq "N">readonly</cfif>>#toString(ePD)#</textarea></td>
								</tr>
								<cfif eDSR_showFlag eq "Y">
								<tr class="cssline2">
									<td class="cssLabel" width="25%">Developer Signoff Remarks</td>
									<td class="cssText" colspan="3"><textarea name="eDSR" rows="8" cols="80" readonly>#toString(eDSR)#</textarea></td>
								</tr>
								</cfif>
								<cfif eSSR_showFlag eq "Y">
								<tr class="cssline1">
									<td class="cssLabel" width="25%">Support Signoff Remarks</td>
									<td class="cssText" colspan="3"><textarea name="eSSR" rows="8" cols="80" readonly>#toString(eSSR)#</textarea></td>
								</tr>
								</cfif>
								<tr class="cssline2">
									<td class="cssLabel">Support Owner <cfif eSowner_editFlag neq "3"><font color="red">*</font></cfif></td>
									<cfif eSowner_editFlag eq "1">
									<td class="cssText" colspan="3"><div class="contenedor-select2"><select name="eSowner" id="eSowner" required>
														<option value="">Please select Support Owner</option>
														<option value="S">Self</option>
														<option value="P">Assign Support Owner by Pool Sequence</option>
														</select></div>
									</td>

									<cfelseif eSowner_editFlag eq "2">
									<td class="cssText" colspan="3"><div class="contenedor-select2"><select name="eSowner" id="eSowner" required>
														<option value="">Please select Support Owner</option>
														<cfloop query="getAllUser">
																<option value="#getAllUser.username#" <cfif eSowner eq getAllUser.username>selected</cfif>>#getAllUser.Username# - #getAllUser.firstname#</option>
														</cfloop>
														</select></div>
									</td>
									<cfelse>
									<td class="cssText" colspan="3">#eSowner#</td>
									</cfif>
								</tr>
								<tr class="cssline1">
									<td class="cssLabel">Created By</td>
									<td class="cssText">#eCreatedBy#</td>
									<td class="cssLabel">Created Date/Time</td>
									<td class="cssText">#eCreatedDateTime#</td>
								</tr>
								<tr class="cssline2">
									<td class="cssLabel">Last Updated By</td>
									<td class="cssText">#eUpdatedBy#</td>
									<td class="cssLabel">Last Updated Date/Time</td>
									<td class="cssText">#eUpdatedDateTime#</td>
								</tr>
								</table>

								<table cellspacing="0" width="95%">
									<tr><td>
								<div class="pull-right">
								<button type="button" class="btn btn-default" data-toggle="modal" data-target=".bs-example-modal-3g" onClick="getOutStandingData()">&nbsp;&nbsp;&nbsp;Outstanding Ticket&nbsp;&nbsp;&nbsp;</button>
								<button type="button" class="btn btn-default" data-toggle="modal" data-target=".bs-example-modal-2g" onClick="getContactData()">&nbsp;&nbsp;&nbsp;View Contact Details&nbsp;&nbsp;&nbsp;</button>
								<button type="button" class="btn btn-default" data-toggle="modal" data-target=".bs-example-modal-lg">&nbsp;&nbsp;&nbsp;View Audit Trail&nbsp;&nbsp;&nbsp;</button>
								</div></td>
								</tr>
								</table>


								<div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        							<div class="modal-dialog modal-2g">
            							<div class="modal-content">
											<cfinclude template="/ticket/transaction/ticket/auditT.cfm">
										</div>
									</div>
								</div>

								<div class="modal fade bs-example-modal-2g" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        							<div class="modal-dialog modal-lg">
            							<div class="modal-content" id="ContactDiv">
										</div>
									</div>
								</div>

								<div class="modal fade bs-example-modal-3g" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        							<div class="modal-dialog modal-2g">
            							<div class="modal-content" id="OustandingDiv">
										</div>
									</div>
								</div>

								<div class="modal fade bs-example-modal-4g" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        							<div class="modal-dialog modal-2g">
            							<div class="modal-content" id="OutstandingdtlDiv">
										</div>
									</div>
								</div>

								<div class="modal fade bs-example-modal-5g" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        							<div class="modal-dialog modal-2g">
            							<div class="modal-content" id="ExpressSODiv">
								<br>
								<table border=1 cellspacing="0" width="95%">
									<tr class="csstitle">
										<td colspan="4"><span class="cssTitleText">Express Signoff</span></td>
									</tr>
									<tr class="cssline1">
										<td class="cssLabel" width="25%">Express Signoff Remarks <font color="red">* <br><br>(This Remarks will send to Customer via email)</font></td>
										<td class="cssText" colspan="3"><textarea name="eESOR" rows="8" cols="80"></textarea></td>
									</tr>
								</table>
								<br><cfif isDefined("EsignoffButton")>
								<button type="submit" class="btn btn-primary" id="submit" onClick="updateAct('Esignoff');">#EsignoffButton#</button>
								</cfif>
								<br><br>
										</div>
									</div>
								</div>

								<br><br>
								<div id ="attTable">
								<table border=1 cellspacing="0" width="95%">
								<tr class="csstitle">
									<td width="5%"><span class="cssTitleText">No</span></td>
									<td width="40%"><span class="cssTitleText">Attachment Description</span></td>
									<td width="40%"><span class="cssTitleText">Attachment</span></td>
									<td width="15%"><span class="cssTitleText">Action</span></td>

								</tr>
								<cfif action eq "Create">
									<cfloop index="i" from="1" to="#getmaxatt.settingvalue#">
										<cfif i mod 2>
											<cfset useclass = "cssline1">
										<cfelse>
											<cfset useclass = "cssline2">
										</cfif>
										<tr class="#useclass#">
											<td>#i#</td>
											<td><input class="form-control input-sm" type="text"  id="e_AttDesc_#i#" name="e_AttDesc_#i#" maxlength="100"></td>
											<td><input type="file" id="e_Att_#i#" name="e_Att_#i#"></td>
											<td align="center">&nbsp;</td>
										</tr>
									</cfloop>
								<cfelse>

									<cfquery name="getAtt" datasource="#dts#">
										select TicAttID,TicAttFileName, TicAttDesc, attsrc
										from tic_mstr_att
										where TicID = '#getMstrInfo.TicID#'
										order by TicAttFileName
									</cfquery>

										<cfloop query="getAtt">

											<cfif getAtt.currentrow mod 2>
												<cfset useclass = "cssline1">
											<cfelse>
												<cfset useclass = "cssline2">
											</cfif>


											<cfif eAtt_editFlag eq "Y">
											<tr class="#useclass#">
												<td>#getAtt.currentrow#<input type="hidden" name="eAttachmentID_#getAtt.currentrow#" value="#getAtt.TicAttID#"></td>
												<td><input class="form-control input-sm" type="text" autocomplete="off" value="#getAtt.TicAttDesc#" id="e_AttDesc_#getAtt.currentrow#" name="e_AttDesc_#getAtt.currentrow#" maxlength="100"></td>
												<td><a href=/ticket/transaction/ticket/getAttach.cfm?Att=#getAtt.TicAttFileName#>#getAtt.TicAttFileName#</a></td>
												<td align="center"><img src="/images/error.png" width="20px" height="20px" onClick="DeleteFile('#getAtt.TicAttID#','#getAtt.TicAttFileName#','#getMstrInfo.TicID#','#getMstrInfo.maxattachfile#');"></td>
											</tr>
											<cfelse>
											<tr class="#useclass#">
												<td>#getAtt.currentrow#</td>
												<td><input class="form-control input-sm" type="text" autocomplete="off" value="#getAtt.TicAttDesc#" id="e_AttDesc_#getAtt.currentrow#" name="e_AttDesc_#getAtt.currentrow#" maxlength="100" disabled></td>
												<td><a href=/ticket/transaction/ticket/getAttach.cfm?Att=#getAtt.TicAttFileName#>#getAtt.TicAttFileName#</a></td>
												<td align="center"><cfif getAtt.attsrc eq "S">(Email Attachment)</cfif></td>
											</tr>
											</cfif>

										</cfloop>


									<cfloop index="i" from="#getAtt.recordcount+1#" to="#getMstrInfo.maxattachfile#">
										   <cfif i mod 2>
												<cfset useclass = "cssline1">
											<cfelse>
												<cfset useclass = "cssline2">
											</cfif>
										<tr class="#useclass#">
											<td>#i#</td>
											<td><input class="form-control input-sm" type="text" autocomplete="off" id="e_AttDesc_#i#" name="e_AttDesc_#i#" maxlength="100" <cfif eAtt_editFlag eq "N">disabled</cfif>></td>
											<td><cfif eAtt_editFlag eq "Y"><input type="file" id="e_Att_#i#" name="e_Att_#i#"></cfif></td>
											<td align="center">&nbsp;</td>
										</tr>
									</cfloop>
								</cfif>
								</table>
								</div>
							</center>

						</div>
					</div>
					</div>
				</div>
				<hr>
				<div class="pull-right">
					<cfif action eq "Edit">
						<cfset AuthControl = "Confirm">
						<cfset AuthSysID = getMstrInfo.SysID>
						<cfinclude template ="/ticket/transaction/ticket/checkActionAuth.cfm">
					</cfif>


				<input type="hidden" name="actionClick">
				<cfif action eq "Create">
				<input type="hidden" name="totalAtt" value="#getmaxatt.settingvalue#">
				<cfelse>
				<input type="hidden" name="totalAtt" value="#getMstrInfo.maxattachfile#">
				</cfif>
				<cfif isDefined("EsignoffButton")>
				<button type="button" class="btn btn-primary" data-toggle="modal" data-target=".bs-example-modal-5g">&nbsp;&nbsp;&nbsp;Express Signoff&nbsp;&nbsp;&nbsp;</button>
				</cfif>
				<cfif isDefined("KIVButton")><button type="submit" class="btn btn-primary" id="submit" onClick="updateAct('KIV');">#KIVButton#</button></cfif>
				<cfif isDefined("CancelButton")><button type="submit" class="btn btn-primary" id="submit" onClick="updateAct('Cancel');">#CancelButton#</button></cfif>
				<cfif isDefined("MainButton")><button type="submit" class="btn btn-primary" id="submit" onClick="updateAct('Save');">#MainButton#</button></cfif>
				<cfif isDefined("ConfirmButton") and Authpower eq 1><button type="submit" class="btn btn-primary" id="submit" onClick="updateAct('Confirm');">#ConfirmButton#</button></cfif>
				<button type="button" class="btn btn-default" onClick="window.location='/ticket/transaction/ticket/ticket.cfm'">&nbsp;&nbsp;&nbsp;Exit&nbsp;&nbsp;&nbsp;</button>

		</div>
		</div>
		</form>
</body>


</cfoutput>
</html>