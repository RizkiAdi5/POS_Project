<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Add Bill Format</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script type='text/javascript' src='/ajax/core/engine.js'></script>
<script type='text/javascript' src='/ajax/core/util.js'></script>
<script type='text/javascript' src='/ajax/core/settings.js'></script>

<cfset oldlocale = SetLocale("English (UK)")>
<cfset thisPath = ExpandPath("/billformat/#dts#/*.*")>
<cfset thisDirectory = GetDirectoryFromPath(thisPath)>
<cfset allBillList="NONTAX,TAXINV,DO,PLIST,CN,PR,RC,CS,CN,DN,PO,QUO,SO,SAM">

<cfif isDefined("form.uploadfile")>
	<cfset newDirectory = "Backup">
	<cfset BackupDirectory = thisDirectory&"#newDirectory#\">
	<!--- Check to see if the Directory exists. --->
	<cfif DirectoryExists(BackupDirectory) eq 'NO'>
	   <!--- If FALSE, create the directory. --->
	   <cfdirectory action = "create" directory = "#BackupDirectory#">
	   <cfoutput><p>Backup directory has been created.</p></cfoutput>
	</cfif>

	<cffile action = "upload" fileField = "uploadfile" destination = "#thisDirectory#" nameconflict="makeunique"> 
	<cflog file="uploadFormatActivity" type="information" 
		text="File:#cffile.clientfile# Uploaded on #now()# From (#HcomID#-#HUserID#)">  
	 
	<cfif cffile.fileexisted eq 'YES'>
 		<cfset newFile = "#thisDirectory#" & "#cffile.serverfile#">
		<cfset orgFile = "#thisDirectory#" & "#cffile.clientfile#">

		<cffile action="move" source="#orgFile#" destination="#BackupDirectory#" attributes="Archive">	  
		<cffile action = "rename" source = "#newfile#" destination = "#orgFile#">
		<cflocation url="addbillformat.cfm?s='#cffile.clientfile# has been backup to #BackupDirectory#'" addtoken="no">
	</cfif>
	
	<cflocation url="addbillformat.cfm" addtoken="no">
</cfif>


<script type="text/javascript">

function updateBill(){
	var tran=document.form.type.value;
	var displayname=document.form.displayname.value;
	var filename=document.form.filename.value;//document.getElementById("filename").value;
	var counter=document.form.counter.value;//document.getElementById("counter").value;
	var action_type=document.form.action_type.value;//document.getElementById("action_type").value;
	var doption=document.form.doption.value;//document.getElementById("doption").value;
	
	if(action_type =='addnew'){
		DWREngine._execute(_maintenanceflocation, null, 'addBillformat', tran, escape(displayname),escape(filename),doption, showResult);
	}
	else if(action_type =='edit'){
		DWREngine._execute(_maintenanceflocation, null, 'editBillformat', tran, escape(displayname),escape(filename),counter,doption, showResult);
	}
	else{
		DWREngine._execute(_maintenanceflocation, null, 'deleteBillformat', tran, escape(displayname),escape(filename),counter, showResult);
	}
}

function showResult(status){
	//document.getElementById("displayname").value='';
	//document.getElementById("filename").value=''
	//document.getElementById("counter").value='';
	//document.getElementById("action_type").value='addnew';
	if(status!=''){
		alert(status);
	}
	else{
		window.location.reload();
	}
	
}

function deleteAction(type,counter){
	if (confirm("Are you sure you want to Delete?")) {
		document.form.action_type.value='delete';//document.getElementById("action_type").value='delete';
		document.getElementById("typecol").innerHTML='<input name="type" value="" type="text" readonly>';
		document.form.type.value=type;//document.getElementById("type").value=type;
		document.form.counter.value=counter;//document.getElementById("counter").value=counter;
		updateBill();
	}	
}

function updateAction(type,counter,displayname,filename,doption){
	document.form.action_type.value='edit';//document.getElementById("action_type").value='edit';
	document.getElementById("typecol").innerHTML='<input name="type" value="" type="text" readonly>';
	document.form.type.value=type;//document.getElementById("type").value=type;
	document.form.counter.value=counter;//document.getElementById("counter").value=counter;
	document.form.displayname.value=displayname;//document.getElementById("displayname").value=displayname;
	document.form.filename.value=filename;//document.getElementById("filename").value=filename;
	document.form.doption.value=doption;//document.getElementById("doption").value=doption;
}

</script>

</head>
<cftry>
	<cfquery name="getformat" datasource="#dts#">
		select * from customized_format
		order by type,counter
	</cfquery>
<cfcatch type="any">
	Please Check With the System Administrator.
	<cfabort>
</cfcatch>
</cftry>

<body>
<cfoutput>
	<h2>CFRs files in #dts#</h2>
	
	<cfquery name="getrefnotype" datasource="#dts#">
		select type as refnotype 
		from refnoset
		where type not in ('CUST','SUPP')
		group by type 
	</cfquery>
	<form name="form">
		<input type="hidden" name="action_type" value="addnew">
		<table width="60%" class="data">
			<tr>
				<th>Type</th>
				<th>Display Name</th>
				<th>File Name</th>
				<th><div align="center">Counter</div></th>
				<th><div align="center">Display Option</div></th>
				<th><div align="center">Action</div></th>
			</tr>
			<tr>
				<td id="typecol">
					<select name="type">
						<cfloop query="getrefnotype">
							<cfif getrefnotype.refnotype eq "INV">
								<cfset refnoname = "Invoice">
							<cfelseif getrefnotype.refnotype eq "RC">
								<cfset refnoname = "Purchase Receive">
							<cfelseif getrefnotype.refnotype eq "PR">
								<cfset refnoname = "Purchase Return">
							<cfelseif getrefnotype.refnotype eq "DO">
								<cfset refnoname = "Delivery Order">
							<cfelseif getrefnotype.refnotype eq "CS">
								<cfset refnoname = "Cash Sales">
							<cfelseif getrefnotype.refnotype eq "CN">
								<cfset refnoname = "Credit Note">
							<cfelseif getrefnotype.refnotype eq "DN">
								<cfset refnoname = "Debit Note">
							<cfelseif getrefnotype.refnotype eq "ISS">
								<cfset refnoname = "Issue">
							<cfelseif getrefnotype.refnotype eq "PO">
								<cfset refnoname = "Purchase Order">
							<cfelseif getrefnotype.refnotype eq "SO">
								<cfset refnoname = "Sales Order">
							<cfelseif getrefnotype.refnotype eq "QUO">
								<cfset refnoname = "Quotation">
							<cfelseif getrefnotype.refnotype eq "ASSM">
								<cfset refnoname = "Assembly">
							<cfelseif getrefnotype.refnotype eq "TR">
								<cfset refnoname = "Transfer">
							<cfelseif getrefnotype.refnotype eq "OAI">
								<cfset refnoname = "Adjustment Increase">
							<cfelseif getrefnotype.refnotype eq "OAR">
								<cfset refnoname = "Adjustment Reduce">
							<cfelseif getrefnotype.refnotype eq "SAM">
								<cfset refnoname = "Sample">
							<cfelseif getrefnotype.refnotype eq "CT">
								<cfset refnoname = "Consignment Note">
							</cfif>
							<cfoutput><option value="#getrefnotype.refnotype#">#refnoname#</option></cfoutput>
						</cfloop>
					</select>
				</td>
				<td><input type="text" name="displayname"></td>
				<td><input type="text" name="filename"></td>
				<td><input type="text" name="counter" size="5" readonly></td>
				<td><input type="text" name="doption" size="5"></td>
				<td><input type="button" value="Save" onclick="updateBill();"></td>
			</tr>
		</table>
	</form>
	
	<table width="60%" class="data">
		<tr>
			<th>Type</th>
			<th>Display Name</th>
			<th>File Name (.CFR)</th>
			<th><div align="center">Counter</div></th>
			<th><div align="center">Display Option</div></th>
			<th><div align="center">Action</div></th>
		</tr>
		<cfloop query="getformat">
			<tr onMouseOut="javascript:this.style.backgroundColor='';" onMouseOver="javascript:this.style.backgroundColor='e6e6fa';">
				<td>#getformat.type#</td>
				<td>#getformat.display_name#</td>
				<td><a href='download.cfm?d=#dts#&f=#getformat.file_name#.cfr'>#getformat.file_name#</a></td>
				<td><div align="center">#getformat.counter#</div></td>
				<td><div align="center">#getformat.d_option#</div></td>
				<td><div align="center">
				<img src="../../../images/userdefinedmenu/iedit.gif" alt="Edit" style="cursor: hand;" onclick="updateAction('#getformat.type#','#getformat.counter#','#getformat.display_name#','#getformat.file_name#','#getformat.d_option#');">
				<img src="../../../images/userdefinedmenu/idelete.gif" alt="Delete" style="cursor: hand;" onclick="deleteAction('#getformat.type#','#getformat.counter#');">
				</div></td>		  
			</tr>
		</cfloop>
	</table>	
    
    <form name="uploadform" action="addbillformat.cfm" method="POST" enctype="multipart/form-data">
	<input type="file" name="uploadfile">
	<input type="submit" name="uploadsubmit" value="Upload">
</form>
</cfoutput>
<br>
	
</body>
</html>
