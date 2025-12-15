<cffunction name="RemoveRecord_In" output="true" returntype="string">
	<cfset statusMsg="">
	<cfquery name="getLocation" datasource="#dts#">
		select serialno, location from iserial where type='#url.tran#' and refno='#url.nexttranno#' and 
		itemno='#url.itemno#' and trancode='#url.itemcount#'
	</cfquery>
	<cfif getLocation.recordcount gt 0>
		<cfif getLocation.location[1] neq url.location>
			<cfquery name="getOldRecord" datasource="#dts#">
				select type,refno,serialno from iserial where itemno='#url.itemno#' and location='#getLocation.location[1]#' and sign=-1 
				and serialno in ('#valuelist(getLocation.serialno,"','")#')
			</cfquery>
			<cfif getOldRecord.recordcount gt 0>
				<cfquery name="deleteRecord" datasource="#dts#">
					delete from iserial where itemno='#url.itemno#' and location='#getLocation.location[1]#' and sign=-1 and 
					serialno in ('#valuelist(getOldRecord.serialno,"','")#')
				</cfquery>
				<cfset statusMsg="Location has been Change. Below serial No have been removed.">
				<cfloop query="getOldRecord">
					<cfset statusMsg=listappend(statusMsg,"Type: #type#,Refno: #refno#,Serial No: #serialno#")>
				</cfloop>
			</cfif>
			<cftry>
				<cfquery name="updateRecord" datasource="#dts#">
					update iserial set location=<cfqueryparam cfsqltype="cf_sql_char" value="#url.location#"> 
					where type='#url.tran#' and refno='#url.nexttranno#' and itemno='#url.itemno#' and 
					trancode='#url.itemcount#' and location='#getLocation.location#'
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
		select location from iserial where type='#url.tran#' and refno='#url.nexttranno#' and 
		itemno='#url.itemno#' and trancode='#url.itemcount#' limit 1
	</cfquery>
	<cfif getLocation.recordcount gt 0>
		<cfif getLocation.location neq url.location>
			<cfquery name="deleteRecord" datasource="#dts#">
				delete from iserial where type='#url.tran#' and refno='#url.nexttranno#' and 
				itemno='#url.itemno#' and trancode='#url.itemcount#'
			</cfquery>
		</cfif>
	</cfif>
</cffunction>
<cfinclude template = "/CFC/convert_single_double_quote_script.cfm">

<cfset url.itemno=urldecode(url.itemno)>
<cfset url.location=urldecode(url.location)>

	<cfif url.tran eq "RC" or url.tran eq "CN" or url.tran eq "OAI"><cfset sign=1><cfelse><cfset sign=-1></cfif>
	<cfif sign eq 1>
		<cfinvoke method="removeRecord_In" returnvariable="statusMsg"/>
		<cfif statusMsg neq ""><cflog file="tran_serial" text="record msg : #statusMsg# (#HcomID#-#HUserID#)"></cfif>
	<cfelse>
		<cfinvoke method="removeRecord_Out"/>
	</cfif>
		<cfquery name="getgsetup" datasource="#dts#">
    select * from gsetup
    </cfquery>
	<html>
	<head>
		<title>Add / Delete Serial Page</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
		<script type='text/javascript' src='/ajax/core/engine.js'></script>
		<script type='text/javascript' src='/ajax/core/util.js'></script>
		<script type='text/javascript' src='/ajax/core/settings.js'></script>
        <script type="text/javascript" src="/scripts/prototypenew.js" ></script>
        <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
        <script language="javascript" type="text/javascript">
		function PopupCenter(pageURL, title,w,h) {
			var left = (screen.width/2)-(w/2);
			var top = (screen.height/2)-(h/2);
			var targetWin = window.open (pageURL, title, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left);
		} 
	
		</script>
        
		<script language="javascript" type="text/javascript">
			<cfoutput>
			var type='#url.tran#';
			var refno='#url.nexttranno#';
			
			var trancode='#url.itemcount#';
			var qty='#url.qty#';
			var newqty = '#url.qty#';
			var custno='#url.custno#';
			var period='00';
			var date='0000-00-00';
			var agenno='';
			var batchcode='';
			var xlocation='#url.location#';
			var currrate='1';
			var price='#url.price#';
			var sign='#sign#';
			var uuid='#uuid#';
			</cfoutput>
			
			function validateserial(){
			if ((document.getElementById('totalitemqty').value*1) < (document.getElementById('totaladdedserial').value*1))
			{
				alert('Serial Qty more than Item Qty!');
				return false;
			}
			return true;
			}
			
			function getResult(){
				var itemno= document.serialForm.itemno.value;

				var ajaxurl = 'addedserialajax.cfm?itemno='+escape(encodeURIComponent(itemno))+'&refno='+escape(refno)+'&type='+escape(type)+'&trancode='+escape(trancode)+'&custno='+escape(custno)+'&period='+escape(period)+'&qty='+escape(qty)+'&agenno='+escape(agenno)+'&location='+escape(xlocation)+'&currrate='+escape(currrate)+'&sign='+escape(sign)+'&price='+escape(price)+'&batchcode='+escape(batchcode)+'&uuid='+escape(uuid);


				new Ajax.Request(ajaxurl,
					{
					  method:'get',
					  onSuccess: function(getdetailback){
					  document.getElementById('addedserialnolist').innerHTML = trim(getdetailback.responseText);
					  },
					  onFailure: function(){ 
					  alert('Error'); },		
					  
					  onComplete: function(transport){
	
						<cfif sign eq '1'>

						setTimeout("document.getElementById('text_serialno').focus();",500);
						<cfelse>
						document.getElementById('select_serialno').focus();
						</cfif>

					  }
					})

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
				
				if(serialno.value.search(/{no}/)!=-1 || serialno.value==''){serialno.focus();alert("Please make sure you have select/key-in Serial No.");}
				else if(serialno.value.search(/,/)!=-1){serialno.focus();alert("',' is not allow.");}
				else{
				var ajaxurl = 'serialnoaddnewajax.cfm?proces=Create&itemno='+escape(encodeURIComponent(itemno))+'&serialno='+escape(serialno.value)+'&date='+escape(date)+'&refno='+escape(refno)+'&type='+escape(type)+'&trancode='+escape(trancode)+'&custno='+escape(custno)+'&period='+escape(period)+'&qty='+escape(qty)+'&agenno='+escape(agenno)+'&location='+escape(xlocation)+'&currrate='+escape(currrate)+'&sign='+escape(sign)+'&price='+escape(price)+'&uuid='+escape(uuid);
				
				new Ajax.Request(ajaxurl,
					{
					  method:'get',
					  onSuccess: function(getdetailback){
					  document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
					  },
					  onFailure: function(){ 
					  alert('Error Add/Delete Serial'); },		
					  
					  onComplete: function(transport){
					  getResult();
					  }
					})
				  
				  <!---ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
				  setTimeout('getResult();',750);--->
					
					}
			}
			
			function addNewSerialno2(){
				var itemno= document.serialForm.itemno.value;
				var serialnofr=document.serialForm.runningnumfr;
				var serialnoto=document.serialForm.runningnumto;
				var prefix=document.serialForm.prefix.value;
				var endfix=document.serialForm.endfix.value;
				var seriallen=document.serialForm.runningnumfr.value.length;

				if(serialnofr.value=='' || serialnoto.value=='')
				{alert("Please make sure you have select/key-in Serial No.");}
				else if(serialnofr.value.search(/,/)!=-1 || serialnoto.value.search(/,/)!=-1){alert("',' is not allow.");}
				else{
					var ajaxurl = 'serialnoaddnew2ajax.cfm?itemno='+escape(encodeURIComponent(itemno))+'&date='+escape(date)+'&refno='+escape(refno)+'&type='+escape(type)+'&trancode='+escape(trancode)+'&custno='+escape(custno)+'&period='+escape(period)+'&qty='+escape(qty)+'&agenno='+escape(agenno)+'&location='+escape(xlocation)+'&currrate='+escape(currrate)+'&sign='+escape(sign)+'&price='+escape(price)+'&serialnofr='+escape(serialnofr.value)+'&serialnoto='+escape(serialnoto.value)+'&prefix='+escape(prefix)+'&endfix='+escape(endfix)+'&seriallen='+escape(seriallen)+'&uuid='+escape(uuid);

					new Ajax.Request(ajaxurl,
					{
					  method:'get',
					  onSuccess: function(getdetailback){
					  document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
					  },
					  onFailure: function(){ 
					  alert('Error Add/Delete Serial'); },		
					  
					  onComplete: function(transport){
					  getResult();
					  }
					})
					<!---
					ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
				  setTimeout('getResult();',750);--->
				  
					<!---DWREngine._execute(_tranflocation, null, 'addNewSerialno2',
						type,refno,trancode,custno,period,date,qty,seriallen.value.length,escape(itemno),serialnofr.value,serialnoto.value,prefix,endfix,agenno,location,currrate,sign,price,SerialnoStatus
						--->
						}
			}
			
			function addNewSerialno3(){
				var itemno= document.serialForm.itemno.value;
				var serialnofr=document.serialForm.autoserialnofrom;
				var serialnoto=document.serialForm.autoserialnoto;

				if(serialnofr.value=='-' || serialnoto.value=='-')
				{alert("Please make sure you have select/key-in Serial No.");}
				else if(serialnofr.value.search(/,/)!=-1 || serialnoto.value.search(/,/)!=-1){alert("',' is not allow.");}
				else{
				
				var ajaxurl = 'serialnoaddnew3ajax.cfm?itemno='+escape(encodeURIComponent(itemno))+'&date='+escape(date)+'&refno='+escape(refno)+'&type='+escape(type)+'&trancode='+escape(trancode)+'&custno='+escape(custno)+'&period='+escape(period)+'&qty='+escape(qty)+'&agenno='+escape(agenno)+'&location='+escape(xlocation)+'&currrate='+escape(currrate)+'&sign='+escape(sign)+'&price='+escape(price)+'&serialnofr='+escape(serialnofr.value)+'&serialnoto='+escape(serialnoto.value)+'&uuid='+escape(uuid);
<!---
					new Ajax.Request(ajaxurl,
					{
					  method:'get',
					  onSuccess: function(getdetailback){
					  document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
					  },
					  onFailure: function(){ 
					  alert('Error Add/Delete Serial'); },		
					  
					  onComplete: function(transport){
					  getResult();
					  }
					})
					--->
					ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
				  setTimeout('getResult();',750);
				
				}
			}
			
			function deleteSerialno(serialno){
				
				var itemno= document.serialForm.itemno.value;
				var ajaxurl = 'serialnoaddnewajax.cfm?proces=Delete&itemno='+escape(encodeURIComponent(itemno))+'&serialno='+escape(serialno)+'&date='+escape(date)+'&refno='+escape(refno)+'&type='+escape(type)+'&trancode='+escape(trancode)+'&custno='+escape(custno)+'&period='+escape(period)+'&qty='+escape(qty)+'&agenno='+escape(agenno)+'&location='+escape(xlocation)+'&currrate='+escape(currrate)+'&sign='+escape(sign)+'&price='+escape(price)+'&uuid='+escape(uuid);

				   new Ajax.Request(ajaxurl,
					{
					  method:'get',
					  onSuccess: function(getdetailback){
					  document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
					  },
					  onFailure: function(){ 
					  alert('Error Add/Delete Serial'); },		
					  
					  onComplete: function(transport){
					  getResult();
					  }
					})
				  
				  <!---ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
				  setTimeout('getResult();',750);--->
			}
			
			
			function changectg(serialno,ctgno){
				var itemno= document.serialForm.itemno.value;
				var ajaxurl = 'changectg.cfm?itemno='+escape(encodeURIComponent(itemno))+'&serialno='+escape(serialno)+'&date='+escape(date)+'&refno='+escape(refno)+'&type='+escape(type)+'&trancode='+escape(trancode)+'&custno='+escape(custno)+'&period='+escape(period)+'&qty='+escape(qty)+'&agenno='+escape(agenno)+'&location='+escape(xlocation)+'&currrate='+escape(currrate)+'&sign='+escape(sign)+'&price='+escape(price)+'&ctgno='+escape(ctgno);

				   new Ajax.Request(ajaxurl,
					{
					  method:'get',
					  onSuccess: function(getdetailback){
					  document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
					  },
					  onFailure: function(){ 
					  alert('Error Changing ASA Roll'); },		
					  
					  onComplete: function(transport){
					  getResult();
					  }
					})
				  
				  <!---ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
				  setTimeout('getResult();',750);--->
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
	
    	<cfquery name="getremainingserialno" datasource="#dts#">
        select * from iserialtemp where type='#url.tran#' and refno='#url.nexttranno#' and trancode='#url.itemcount#' and itemno='#itemno#' and uuid='#uuid#' order by serialno
        </cfquery>
        <!---
        <cfif lcase(hcomid) eq "asaiki_i" and tran eq 'SAM'> 
        <cfset ctgnolist=valuelist(getremainingserialno.ctgno)>
        </cfif>--->
        
        <cfquery name="getaddedserialno" datasource="#dts#">
        select * from (
		Select serialno,sum(sign) as sign
		from iserial 
		where itemno='#itemno#'
        and (void is null or void='')
        group by serialno
		order by serialno) as a
        where a.sign=1
        order by a.serialno
        </cfquery>
        
       
        
        <cfquery name="getaddedserialno2" datasource="#dts#">
        select * from (
		Select serialno,sum(sign) as sign
		from iserial 
		where itemno='#url.itemno#'
        and location=<cfqueryparam cfsqltype="cf_sql_char" value="#url.location#"> and type<>'SAM'
        and (void is null or void='')
        group by serialno
		order by serialno) as a
        where a.sign=1
        and serialno not in (select serialno from iserialtemp where uuid="#uuid#")
        order by a.serialno
        </cfquery>
        
    
    
	<body>
    
		<h1>Serial No Selection Screen</h1>
		<cfform name="serialForm">
        
			<cfoutput>
            <input type="hidden" name="itemno" id="itemno" value="#convertquote(url.itemno)#">

			</cfoutput>
        <div id="ajaxFieldPro"></div>
        <cfif getgsetup.serialnorun eq 'Y' and url.tran eq "INV" or url.tran eq "DO" or url.tran eq "DN" or url.tran eq "ISS" or url.tran eq "SAM">
        <cfoutput>
        <table class="data">
            <tr>
              <th rowspan="2" width="100px">Serial No</th>     
              <th>Running Number From :</th>
              <td><select name="autoserialnofrom" id="autoserialnofrom" onChange="document.getElementById('serialcount').value=document.getElementById('autoserialnoto').selectedIndex-document.getElementById('autoserialnofrom').selectedIndex+1">
              	<cfloop query="getaddedserialno2">
            	<option value="#getaddedserialno2.serialno#">#getaddedserialno2.serialno#</option>
            	</cfloop>
              </select></td>
            </tr>
            <tr>
              <th>Running Number To :</th>
              <td><select name="autoserialnoto" id="autoserialnoto" onChange="document.getElementById('serialcount').value=document.getElementById('autoserialnoto').selectedIndex-document.getElementById('autoserialnofrom').selectedIndex+1">
              <cfloop query="getaddedserialno2">
              <option value="#getaddedserialno2.serialno#">#getaddedserialno2.serialno#</option>
              </cfloop>
              </select></td>
            </tr>
            <tr>
              <th>Serial No Selected</th>
              <td><input type="text" name="serialcount" id="serialcount" size="5" /></td>
              <td><input type="button" name="add_text3" value="Range Add" onClick="addNewSerialno3()"></td>
            </tr>
          </table>
        </cfoutput>
		</cfif>
        <cfif getgsetup.serialnorun eq 'Y' and (url.tran eq 'RC' or url.tran eq "OAI" or url.tran eq "CN")>
          <table class="data">
            <tr>
              <th rowspan="4" width="100px">Serial No</th>
              <th width="150px">Prefix :</th>
              <td>
              <cfif lcase(hcomid) eq "asaiki_i">
              <cfquery name="getasaikibatchcode" datasource="#dts#">
              select batchcode from ictran where type="RC" and refno="#url.nexttranno#" and trancode="#url.itemcount#"
              </cfquery>
              <cfoutput>
              <input type="text" name="prefix" id="prefix" value="#getasaikibatchcode.batchcode#-" size="10" />
              </cfoutput>
              <cfelse>
              <input type="text" name="prefix" id="prefix" value="" size="5" />
              </cfif></td>
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
        <div id="addedserialnolist">
		<table class="data">
		<tr>
			<th width="50">No</th>
			<th><cfoutput>Serial No</cfoutput></th>
			<th width="70">Action</th>
		</tr>
        <cfoutput>
        <input type="hidden" name="totaladdedserial" id="totaladdedserial" value="#getremainingserialno.recordcount#" />
		<cfif getremainingserialno.recordcount neq 0>
        <cfloop query="getremainingserialno">
        <tr>
        <td>#getremainingserialno.currentrow#</td>
        <td>#getremainingserialno.serialno#</td>
        <td><input type="button" name="delete" value="delete" onClick="deleteSerialno('#getremainingserialno.serialno#')"></td>
        </tr>
        </cfloop>
        </cfif>
        </cfoutput>
        <cfif getremainingserialno.recordcount lt qty>
        <cfif sign eq '-1'>
        <cfoutput>
		<tr>
			<td>New</td>
			<td align="right">
            
            <select name="select_serialno" id="select_serialno" onkeypress="return handleEnter(event)">
            <cfloop query="getaddedserialno2">
            <option value="#getaddedserialno2.serialno#">#getaddedserialno2.serialno#</option>
            </cfloop>
            </select>
            </td>
			<td><input type="button" name="add" value="Add" onClick="addNewSerialno()"></td>
		</tr>
        </cfoutput>
        </cfif>
        <cfif sign eq '1'>
		<tr>
			<td>New</td>
			<td align="right"><input type="text" name="text_serialno" id="text_serialno" maxlength="100" size="30" onKeyPress="return handleEnter(event)"></td>
			<td><input type="button" name="add_text" value="Add" onClick="addNewSerialno()"></td>
		</tr>
        </cfif>
        </cfif>
		</table>
        </div>
		</cfform>
        
        
        <script language="javascript" type="text/javascript">
	
			<cfif sign eq '1'>
						document.getElementById('text_serialno').focus();
						document.getElementById('text_serialno').focus();
			<cfelse>
						document.getElementById('select_serialno').focus();
			</cfif>
		</script>
        
			<cfoutput>
			<div align="center"><input type="button" name="Submit2" id="Submit2" value="Finish" onClick="window.close()"></div>
			</cfoutput>
	</body>
	</html>
