<cffunction name="RemoveRecord_In" output="true" returntype="string">
	<cfset statusMsg="">
	<cfquery name="getLocation" datasource="#dts#">
		select serialno, location from iserial where type='#form.tran#' and refno='#form.nexttranno#' and 
		itemno='#form.itemno#' and trancode='#form.itemcount#'
	</cfquery>
	<cfif getLocation.recordcount gt 0>
		<cfif getLocation.location[1] neq form.location>
			<cfquery name="getOldRecord" datasource="#dts#">
				select type,refno,serialno from iserial where itemno='#form.itemno#' and location='#getLocation.location[1]#' and sign=-1 
				and serialno in ('#valuelist(getLocation.serialno,"','")#')
			</cfquery>
			<cfif getOldRecord.recordcount gt 0>
				<cfquery name="deleteRecord" datasource="#dts#">
					delete from iserial where itemno='#form.itemno#' and location='#getLocation.location[1]#' and sign=-1 and 
					serialno in ('#valuelist(getOldRecord.serialno,"','")#')
				</cfquery>
				<cfset statusMsg="Location has been Change. Below serial No have been removed.">
				<cfloop query="getOldRecord">
					<cfset statusMsg=listappend(statusMsg,"Type: #type#,Refno: #refno#,Serial No: #serialno#")>
				</cfloop>
			</cfif>
			<cftry>
				<cfquery name="updateRecord" datasource="#dts#">
					update iserial set location='#form.location#' 
					where type='#form.tran#' and refno='#form.nexttranno#' and itemno='#form.itemno#' and 
					trancode='#form.itemcount#' and location='#getLocation.location#'
				</cfquery>
				<cfset statusMsg=listappend(statusMsg,"Successfully Change Location.")>
				<cfcatch type="database">
					<cfset statusMsg=listappend(statusMsg,"Failed to Change Location.Please check with Administrator.")>
				</cfcatch>
			</cftry>
		</cfif>
	</cfif>
	<cfreturn statusMsg>
</cffunction>
<cffunction name="RemoveRecord_Out" output="false">
	<cfquery name="getLocation" datasource="#dts#">
		select location from iserial where type='#form.tran#' and refno='#form.nexttranno#' and 
		itemno='#form.itemno#' and trancode='#form.itemcount#' limit 1
	</cfquery>
	<cfif getLocation.recordcount gt 0>
		<cfif getLocation.location neq form.location>
			<cfquery name="deleteRecord" datasource="#dts#">
				delete from iserial where type='#form.tran#' and refno='#form.nexttranno#' and 
				itemno='#form.itemno#' and trancode='#form.itemcount#'
			</cfquery>
		</cfif>
	</cfif>
</cffunction>
<cfinclude template = "../../CFC/convert_single_double_quote_script.cfm">
<cfif type neq "Delete">
	<cfif tran eq "RC" or tran eq "CN" or tran eq "OAI"><cfset sign=1><cfelse><cfset sign=-1></cfif>
	<cfif sign eq 1>
		<cfinvoke method="removeRecord_In" returnvariable="statusMsg"/>
		<cfif statusMsg neq ""><cflog file="tran_serial" text="record msg : #statusMsg# (#HcomID#-#HUserID#)"></cfif>
	<cfelse>
		<cfinvoke method="removeRecord_Out"/>
	</cfif>
		<cfquery name="getgsetup" datasource="#dts#">
    select serialnorun from gsetup
    </cfquery>
	<html>
	<head>
		<title>Add / Delete Serial Page</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
		<script type='text/javascript' src='../../ajax/core/engine.js'></script>
		<script type='text/javascript' src='../../ajax/core/util.js'></script>
		<script type='text/javascript' src='../../ajax/core/settings.js'></script>
		<script language="javascript" type="text/javascript">
			var getCRow = function(team) { return team.CROW };
			var getSerialno = function(team) { return team.SERIALNO };
			var getAct = function(team) { return team.ACT };
			<cfoutput>
			var type='#form.tran#';
			var refno='#form.nexttranno#';
			
			var trancode='#form.itemcount#';
			var qty='#form.qty#';
			var newqty = '#form.qty#';
			var custno='#form.custno#';
			var period='#form.readperiod#';
			var date='#form.nDateCreate#';
			var agenno='#form.agenno#';
			var location='#form.location#';
			var currrate='#form.currrate#';
			var price='#form.price#';
			var sign='#sign#';
			</cfoutput>
			
			<!--- Get ALL Related Serial in Table Form Start --->
			function getSerialTable(){
				var itemno= document.serialForm.itemno.value;
				DWREngine._execute(_tranflocation, null, 'getSerialnoTableList',type,refno,escape(itemno),trancode,location,getSerialTableResult);
			}
			function getSerialTableResult(teams){
				DWRUtil.removeAllRows("serialnoBody");
				DWRUtil.addRows("serialnoBody", teams, [ getCRow, getSerialno, getAct ])
			}
			<!--- Get ALL Related Serial in Table Form End --->
			<!--- Get Added Serialno Select List Start --->
			function getAddedSerialnoSelect(){
				var itemno= document.serialForm.itemno.value;
				DWREngine._execute(_tranflocation, null, 'addedserialnolookup',escape(itemno),getAddedSerialnoSelectResult);
			}
			function getAddedSerialnoSelectResult(serialnoArray){
				DWRUtil.removeAllOptions("added_serialno");
				DWRUtil.addOptions("added_serialno", serialnoArray,"KEY", "VALUE");
			}
			<!--- Get Added Serialno Select List End --->
			<!--- Get Serialno Select List Start --->
			function getSerialnoSelect(){
				var itemno= document.serialForm.itemno.value;
				DWREngine._execute(_tranflocation, null, 'serialnolookup',escape(itemno),location,getSerialnoSelectResult);
			}
			function getSerialnoSelectResult(serialnoArray){
				DWRUtil.removeAllOptions("select_serialno");
				DWRUtil.addOptions("select_serialno", serialnoArray,"KEY", "VALUE");
				<cfif getgsetup.serialnorun eq 'Y' and form.tran eq "INV" or form.tran eq "DO">
				DWRUtil.removeAllOptions("autoserialnoto");
				DWRUtil.addOptions("autoserialnoto", serialnoArray,"KEY", "VALUE");
				DWRUtil.removeAllOptions("autoserialnofrom");
				DWRUtil.addOptions("autoserialnofrom", serialnoArray,"KEY", "VALUE");
				</cfif>
			}
			<!--- Get Serialno Select List End --->
			<!--- Display/Add Serial Control Start --->
			function exceptStatus(){
				var itemno= document.serialForm.itemno.value;
				DWREngine._execute(_tranflocation, null, 'exceptlookup', type, refno,escape(itemno),trancode,qty,location,getResult);
			}
			function getResult(result){
				if(result>0){
					<cfif sign eq -1>
					change('stock_in','block');change('stock_out','none');getSerialnoSelect();<cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">document.serialForm.serialnoselect.value="";document.serialForm.serialnoselect.focus();<cfelse>document.serialForm.select_serialno.focus();</cfif>
					<cfelse>
					change('stock_in','none');change('stock_out','block');getAddedSerialnoSelect();document.serialForm.text_serialno.focus();
					</cfif>
				}else{
					change('stock_in','none');change('stock_out','none');<cfif sign eq 1>getAddedSerialnoSelect();</cfif>
				}document.getElementById("balQty").innerHTML=result;
				newqty=result * 1;
			}
			<!--- Display/Add Serial Control End --->
			<!--- Add/Delete Serial no Start --->
			function trim (str) {
				var	str = str.replace(/^\s\s*/, ''),
					ws = /\s/,
					i = str.length;
				while (ws.test(str.charAt(--i)));
				return str.slice(0, i + 1);
			}


			function addNewSerialno(){
				var itemno= document.serialForm.itemno.value;
				<cfif sign eq -1>
				var serialno=document.serialForm.select_serialno;
				<cfelse>
				var serialno=document.serialForm.text_serialno;
				</cfif>
				<cfif (lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i") and sign neq "-1">
				var getserialnostring = document.serialForm.text_serialno.value;
				var mySplitResult = getserialnostring.split("    ");
				document.serialForm.text_serialno.value = trim(mySplitResult[0]);
				</cfif>
				<cfif (lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i") and sign eq "-1">
				var getserialnostring = document.serialForm.serialnoselect.value;
				var mySplitResult = getserialnostring.split("    ");
				var spliresult = trim(mySplitResult[0]);
				for (var idx=0;idx<serialno.options.length;idx++) 
				{
					if (spliresult==trim(serialno.options[idx].value)) 
					{
						serialno.options[idx].selected=true;
						
					}
				}
				</cfif>
				
				<cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">
				try{
				if(trim(mySplitResult[1]).toLowerCase() != trim(itemno).toLowerCase())
				{
				alert('The barcode not matching the itemno');
				<cfif sign eq -1>
				document.serialForm.serialnoselect.value = "";
				document.serialForm.serialnoselect.focus();
				<cfelse>
				document.serialForm.text_serialno.value = "";
				document.serialForm.text_serialno.focus();
				</cfif>
				
				return false;
				}
				}
				catch(err)
				{
				}
				</cfif>
				if(serialno.value.search(/{no}/)!=-1 || serialno.value==''){serialno.focus();alert("Please make sure you have select/key-in Serial No.");}
				else if(serialno.value.search(/,/)!=-1){serialno.focus();alert("',' is not allow.");}
				else{DWREngine._execute(_tranflocation, null, 'addNewSerialno',
						type,refno,trancode,custno,period,date,escape(itemno),serialno.value,agenno,location,currrate,sign,price,SerialnoStatus);}
			}
			
			function addNewSerialno2(){
				var itemno= document.serialForm.itemno.value;
				var serialnofr=document.serialForm.runningnumfr;
				var serialnoto=document.serialForm.runningnumto;
				var prefix=document.serialForm.prefix.value;
				var endfix=document.serialForm.endfix.value;
				var seriallen=document.serialForm.runningnumfr;

				if(serialnofr.value=='' || serialnoto.value=='')
				{alert("Please make sure you have select/key-in Serial No.");}
				else if(serialnofr.value.search(/,/)!=-1 || serialnoto.value.search(/,/)!=-1){alert("',' is not allow.");}
				else{DWREngine._execute(_tranflocation, null, 'addNewSerialno2',
						type,refno,trancode,custno,period,date,qty,seriallen.value.length,escape(itemno),serialnofr.value,serialnoto.value,prefix,endfix,agenno,location,currrate,sign,price,SerialnoStatus);}
			}
			
			function addNewSerialno3(){
				var itemno= document.serialForm.itemno.value;
				var serialnofr=document.serialForm.autoserialnofrom;
				var serialnoto=document.serialForm.autoserialnoto;

				if(serialnofr.value=='-' || serialnoto.value=='-')
				{alert("Please make sure you have select/key-in Serial No.");}
				else if(serialnofr.value.search(/,/)!=-1 || serialnoto.value.search(/,/)!=-1){alert("',' is not allow.");}
				else{
				DWREngine._execute(_tranflocation, null, 'addNewSerialno3',
						type,refno,trancode,custno,period,date,newqty,escape(itemno),serialnofr.value,serialnoto.value,agenno,location,currrate,sign,price,SerialnoStatus);}
			}
			
			function deleteSerialno(serialno){
				var itemno= document.serialForm.itemno.value;
				DWREngine._execute(_tranflocation, null, 'deleteSerialno',type,refno,trancode,escape(itemno),serialno,sign,SerialnoStatus);
			}
			function SerialnoStatus(status){
				if(status.search(/success/i)!=-1){
					exceptStatus();getSerialTable();
					if(status.search(/insert/i)!=-1){document.serialForm.text_serialno.value='';}
					else{exceptStatus();}
				}//alert(status);
			}
			<!--- Add/Delete Serial no End --->
			function init(){
				DWRUtil.useLoadingMessage();
				DWREngine._errorHandler=errorHandler;
				exceptStatus();
				getSerialTable();
			}
			function change(layer_ref,state){ 
			if (document.all){ //IS IE 4 or 5 (or 6 beta) 
			eval( "document.all." + layer_ref + ".style.display = state"); 
			} 
			if (document.layers) { //IS NETSCAPE 4 or below 
			document.layers[layer_ref].display = state; 
			} 
			if (document.getElementById &&!document.all) { 
			hza = document.getElementById(layer_ref); 
			hza.style.display = state; 
			} 
		} 
		function handleEnter(event){
			var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
			if(keyCode==13){addNewSerialno();return false;}
			return true;
		}
		</script>
	</head>

    
	<body onLoad="init()">
		<h1>Serial No Selection Screen</h1>
		<br>
		<cfform name="serialForm">
			<cfoutput><input type="hidden" name="itemno" value="#convertquote(form.itemno)#"></cfoutput>
		<table class="data">
		<tr>
			<th>Reference No</th>
			<th>Customer No</th>
			<th>Itemno</th>
			<th>Total Qty</th>
			<th>Qty To Be Select</th>
			<cfif sign eq 1><th>Added Serial No. List</th></cfif>
		</tr>
		<cfoutput>
		<tr>
			<td>#form.nexttranno#</td>
			<td>#form.custno#</td>
			<td>#form.itemno#</td>
			<td align="center">#form.qty#</td>
			<td align="center"><label id="balQty"></label></td>
			<cfif sign eq 1><td><select name="added_serialno"></select></td></cfif>
		</tr>
		</cfoutput>
		</table>
		<br>
        <cfif getgsetup.serialnorun eq 'Y' and form.tran eq "INV" or form.tran eq "DO" or form.tran eq "CN" or form.tran eq "DN">
        <table class="data">
            <tr>
              <th rowspan="2" width="100px">Serial No</th>     
              <th>Running Number From :</th>
              <td><select name="autoserialnofrom" id="autoserialnofrom" onChange="document.getElementById('serialcount').value=document.getElementById('autoserialnoto').selectedIndex-document.getElementById('autoserialnofrom').selectedIndex+1"></select></td>
            </tr>
            <tr>
              <th>Running Number To :</th>
              <td><select name="autoserialnoto" id="autoserialnoto" onChange="document.getElementById('serialcount').value=document.getElementById('autoserialnoto').selectedIndex-document.getElementById('autoserialnofrom').selectedIndex+1"></select></td>
            </tr>
            <tr>
              <th>No Serial Selected</th>
              <td><input type="text" name="serialcount" id="serialcount" size="5" /></td>
              <td><input type="button" name="add_text3" value="Range Add" onClick="addNewSerialno3()"></td>
            </tr>
          </table>
		</cfif>
        <cfif getgsetup.serialnorun eq 'Y' and form.tran eq 'RC'>
          <table class="data">
            <tr>
              <th rowspan="4" width="100px">Serial No</th>
              <th width="150px">Prefix :</th>
              <td><input type="text" name="prefix" id="prefix" value="" size="5" /></td>
            </tr>
            <tr>
              <th>Running Number From :</th>
              <td><cfinput type="text" name="runningnumfr" id="runningnumfr" value="" size="10" /></td>
            </tr>
            <tr>
              <th>Running Number To :</th>
              <td><cfinput type="text" name="runningnumto" id="runningnumto" value="" size="10" /></td>
            </tr>
            <tr>
              <th>End Fix :</th>
              <td><input type="text" name="endfix" id="endfix" size="5" /></td>
              <td><input type="button" name="add_text2" value="Add" onClick="addNewSerialno2()"></td>
            </tr>
          </table>
        </cfif>
		<table class="data">
		<tr>
			<th width="50">No</th>
			<th>Serial No</th>
			<th width="70">Action</th>
		</tr>
		<tbody id="serialnoBody"></tbody>
		<tr id="stock_in">
			<td>New</td>
			<td align="right">
            <select name="select_serialno" id="select_serialno" onkeypress="return handleEnter(event)"></select>
            <cfif lcase(hcomid) eq "dental_i" or lcase(hcomid) eq "dental10_i" or lcase(hcomid) eq "mfss_i" or lcase(hcomid) eq "hcss_i">
            <input type="text" name="serialnoselect" id="serialnoselect" value="" onKeyPress="return handleEnter(event)">
			</cfif>
            </td>
			<td><input type="button" name="add" value="Add" onClick="addNewSerialno()"></td>
		</tr>
		<tr id="stock_out">
			<td>New</td>
			<td align="right"><input type="text" name="text_serialno" maxlength="<cfif lcase(hcomid) neq "dental_i" or lcase(hcomid) neq "dental10_i" or lcase(hcomid) neq "mfss_i" or lcase(hcomid) neq "hcss_i">100<cfelse>100</cfif>" size="30" onKeyPress="return handleEnter(event)"></td>
			<td><input type="button" name="add_text" value="Add" onClick="addNewSerialno()"></td>
		</tr>
		</table>
		</cfform>
		
		<cfif form.tran neq "OAI" and form.tran neq "OAR" and form.tran neq "ISS">
			<cfoutput>
			<form name="done" action="../transaction/transaction3.cfm?complete=complete" method="post">
				<input type="hidden" name="tran" value="#form.tran#">
				<input type="hidden" name="currrate" value="#form.currrate#">
				<input type="hidden" name="agenno" value="#form.agenno#">
				<input type="hidden" name="nexttranno" value="#form.nexttranno#">
				<input type="hidden" name="custno" value="#form.custno#">
				<input type="hidden" name="readperiod" value="#form.readperiod#">
				<input type="hidden" name="nDateCreate" value="#form.nDateCreate#">
				<input type="hidden" name="invoicedate" value="#form.invoicedate#">
				
				<input type="hidden" name="refno3" value="#form.refno3#">
				<input type="hidden" name="status" value="#form.status#">
				<input type="hidden" name="type" value="#form.type#">
				<input type="hidden" name="hmode" value="#form.hmode#">
				<cfif isdefined("form.updunitcost")><input type='hidden' name='updunitcost' value='#form.updunitcost#'></cfif>
				<input type="submit" name="Submit2" value="Finish">
			</form>
			</cfoutput>
		<cfelse>
			<cfoutput>
			<form name="done" action="../transaction/iss3.cfm?complete=complete" method="post">
				<input type="hidden" name="tran" value="#form.tran#">
				<input type="hidden" name="agenno" value="#form.agenno#">
				<input type="hidden" name="nexttranno" value="#form.nexttranno#">
				<input type="hidden" name="custno" value="#form.custno#">
				<input type="hidden" name="readperiod" value="#form.readperiod#">
				<input type="hidden" name="nDateCreate" value="#form.nDateCreate#">
				<input type="hidden" name="invoicedate" value="#form.invoicedate#">
				
				<input type="hidden" name="type" value="Inprogress">
				<input type="hidden" name="status" value="#status#">
				<input type="hidden" name="name" value="#form.name#">
				<!--- Add on 260808 --->
				<input type="hidden" name="hmode" value="#form.hmode#">
				<input type="submit" name="Submit2" value="Finish">
			</form>
			</cfoutput>
		</cfif>
	</body>
	</html>
<cfelse>
	<cfquery name="getUnwantedRecord" datasource="#dts#">
		select serialno from iserial 
		where type='form.tran' and itemno='#form.itemno#' and refno='#form.nexttranno#' and trancode='#form.itemcount#'
	</cfquery>
	<cfif getUnwantedRecord.recordcount gt 0>
		<cfquery name="deleteRecord" datasource="#dts#">
			delete from iserial where itemno='#form.itemno#' and 
			serialno in ('#valuelist(getUnwantedRecord.serialno,"','")#')
		</cfquery>
		<cflog file="tran_serial" text="deleted Serial : #valuelist(getUnwantedRecord.serialno)# (#HcomID#-#HUserID#)">
	</cfif>
		
	<cfif form.tran neq "OAI" and form.tran neq "OAR" and form.tran neq "ISS">
		<cfoutput>
		<form name="done" action="../transaction/transaction3.cfm?complete=complete" method="post">
			<input type="hidden" name="tran" value="#form.tran#">
			<input type="hidden" name="currrate" value="#form.currrate#">
			<input type="hidden" name="agenno" value="#form.agenno#">
			<input type="hidden" name="nexttranno" value="#form.nexttranno#">
			<input type="hidden" name="custno" value="#form.custno#">
			<input type="hidden" name="readperiod" value="#form.readperiod#">
			<input type="hidden" name="nDateCreate" value="#form.nDateCreate#">
			<input type="hidden" name="invoicedate" value="#form.invoicedate#">
			
			<input type="hidden" name="refno3" value="#form.refno3#">
			<input type="hidden" name="status" value="#form.status#">
			<input type="hidden" name="type" value="#form.type#">
			<input type="hidden" name="hmode" value="#form.hmode#">
			<cfif isdefined("form.updunitcost")><input type='hidden' name='updunitcost' value='#form.updunitcost#'></cfif>
		</form>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<form name="done" action="../transaction/iss3.cfm?complete=complete" method="post">
			<input type="hidden" name="tran" value="#form.tran#">
			<input type="hidden" name="currrate" value="#form.currrate#">
			<input type="hidden" name="agenno" value="#form.agenno#">
			<input type="hidden" name="nexttranno" value="#form.nexttranno#">
			<input type="hidden" name="custno" value="#form.custno#">
			<input type="hidden" name="readperiod" value="#form.readperiod#">
			<input type="hidden" name="nDateCreate" value="#form.nDateCreate#">
			<input type="hidden" name="invoicedate" value="#form.invoicedate#">
			
			<input type="hidden" name="type" value="Inprogress">
			<input type="hidden" name="status" value="#status#">
			<input type="hidden" name="name" value="#form.name#">
			<!--- Add on 260808 --->
			<input type="hidden" name="hmode" value="#form.hmode#">
			<input type="submit" name="Submit2" value="Finish">
		</form>
		</cfoutput>
	</cfif>
	<script>done.submit();</script>
</cfif>
