 <cfajaximport tags="CFAJAXPROXY,CFDIV,CFWINDOW,CFMAP,CFMENU">
<cfset tran = "cs">
<cfsetting showdebugoutput="no">
<cfquery name="getgsetup" datasource="#dts#">
SELECT * FROM gsetup
</cfquery>

<cfset defaultfontsize = "#getgsetup.fontsize#px">

<cfquery name="getdealermenu" datasource="#dts#">
SELECT * FROM dealer_menu
</cfquery>

<cfquery name="getpayment" datasource="#dts#">
SELECT * FROM pospayment
</cfquery>

<cfquery name="getlast" datasource="#dts#">
SELECT uuid from ictrantemp group by uuid order by trdatetime desc limit 50 
</cfquery>
<cfquery name="emptytemp" datasource="#dts#">
Delete from ictrantemp where trdatetime < "#dateformat(dateadd('d','-14',now()),'YYYY-MM-DD')#" and onhold <> "Y" and uuid not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(getlast.uuid)#" list="yes" separator=",">)
</cfquery>


<cfquery name="getagentqry" datasource="#dts#">
            SELECT "Please select an agent" as agentdesp, "" as agent
            union all
            SELECT concat(agent,' - ',desp) as agentdesp, agent FROM icagent
            </cfquery>

<cfquery datasource="#dts#" name="getGeneralInfo">
			select lastUsedNo as tranno, refnoused as arun,refnocode,refnocode2,presuffixuse 
            from refnoset
			where type = 'CS'
			and counter = '1'
		</cfquery>
        
        <cfif getGeneralInfo.arun eq "1">
        <cfinvoke component="cfc.refno" method="processNum" oldNum="#getGeneralInfo.tranno#" returnvariable="newnextNum" />
        	<cfset actual_nexttranno = newnextNum>
            <cfif (getGeneralInfo.refnocode2 neq "" or getGeneralInfo.refnocode neq "") and getGeneralInfo.presuffixuse eq "1">
				<cfset nexttranno = "CS"&"-"&getGeneralInfo.refnocode&actual_nexttranno&getGeneralInfo.refnocode2>
            <cfelse>
            	<cfset nexttranno = "CS"&"-"&actual_nexttranno>
			</cfif>
            <cfset tranarun_1 = getGeneralInfo.arun>
		<cfelse>
			<cfset nexttranno = "">
            <cfset tranarun_1 = "0">
		</cfif>
        <cfset nexttranno = tostring(nexttranno)>

<html>
<head>
<script language="javascript" type="text/javascript" src="/scripts/collapse_expand_single_item.js"></script>
<script src="/SpryAssets/SpryCollapsiblePanel.js" type="text/javascript"></script>
<link href="/SpryAssets/SpryCollapsiblePanel.css" rel="stylesheet" type="text/css" />
	<title>POS Transaction</title>
	<link href="/stylesheet/stylesheetPOS.css" rel="stylesheet" type="text/css">
    <script type='text/javascript' src='/ajax/core/engine.js'></script>
	<script type='text/javascript' src='/ajax/core/util.js'></script>
	<script type='text/javascript' src='/ajax/core/settings.js'></script>
    <script type='text/javascript' src='/ajax/core/shortcut.js'></script>
    <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
    <link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>
    <script type="text/javascript" src="/scripts/prototypenew.js" ></script>
    <script type="text/javascript">
	function PopupCenter(pageURL, title,w,h) {
		var left = (screen.width/2)-(w/2);
		var top = (screen.height/2)-(h/2);
		var targetWin = window.open (pageURL, title, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width='+w+', height='+h+', top='+top+', left='+left);
	} 
	
	function memberdisc()
	{
		<cfoutput>
		if(trim(document.getElementById('driver').value)!='')
		{
		document.getElementById('dispec1').value='#val(getgsetup.memdisc)#';
		
		var updateurl = 'memberpointajax.cfm?member='+escape(document.getElementById('driver').value);
		
		ajaxFunction(document.getElementById('memberpointajaxfield'),updateurl);
		<!---new Ajax.Request(updateurl,
      	{
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('memberpointajaxfield').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Getting Member Point'); },		
		
		onComplete: function(transport){
        }
      	})--->
		
		}
		else
		{
			document.getElementById('dispec1').value=0;
		}
		</cfoutput>
		calcdisc();caltax();calcfoot();
	}

	
	function fillsearch(driverno,name,contact,add1,add2,add3)
	{
		document.getElementById('memberidsearch').value=unescape(driverno);
		document.getElementById('membernamesearch').value=unescape(name);
		document.getElementById('membertelsearch').value=unescape(contact);
		document.getElementById('memberadd1search').value=unescape(add1);
		document.getElementById('memberadd2search').value=unescape(add2);
		document.getElementById('memberadd3search').value=unescape(add3);
	}
	
	
function selectmemberlist(driverno){	
	for (var idx=0;idx<document.getElementById('driver').options.length;idx++) {
		if (driverno==document.getElementById('driver').options[idx].value) {
		document.getElementById('driver').options[idx].selected=true;
		}
	} 
}
	
	function getCheckedValue(radioObj) {
	if(!radioObj) return "";
	var radioLength = radioObj.length;
	
	if(radioLength == undefined)
	{
		if(radioObj.checked)
			return radioObj.value;
		else
			return "";
	}
	for(var i = 0; i < radioLength; i++) {
		if(radioObj[i].checked) {
			return radioObj[i].value;
		}
	}
	return "";
}

	
	function searchSel(fieldid,textid) {
  var input=document.getElementById(textid).value.toLowerCase();
  if(input != "")
  {
  var output=document.getElementById(fieldid).options;
  for(var i=0;i<output.length;i++) {
    if(output[i].text.toLowerCase().indexOf(input)>=0 && i != 0){
      output[i].selected=true;
	  break;
      }
    if(document.getElementById(textid).value==''){
      output[0].selected=true;
      }
  }
  }
  else{
	   var output=document.getElementById(fieldid).options;
	   output[0].selected=true;
  }
}
	function updaterow(rowno)
	{
		var varqtylist = 'qtylist'+rowno;
		var brem4 = 'brem4'+rowno;
		var uuid = document.getElementById('uuid').value;
		var qtylistdata = document.getElementById(varqtylist).value;
		var brem4data = document.getElementById(brem4).value;
		var updateurl = 'updaterow.cfm?uuid='+escape(uuid)+'&qty='+escape(qtylistdata)+'&trancode='+rowno+'&brem4='+escape(brem4data);
		
		
		<cfif lcase(hcomid) eq "just_i">
		document.getElementById('currentrow').value=rowno;
		
		if(qtylistdata <= -1 && document.getElementById('allownegative').value==0)
		{
		ColdFusion.Window.show('negativeqty');
		}
		else
		{
		updaterow2(updateurl);
		}
		<cfelse>
		updaterow2(updateurl);
		</cfif>
	}
	
	
	function updaterow2(updateurl)
	{
	new Ajax.Request(updateurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Update Item'); },		
		
		onComplete: function(transport){
		calculatefooter();
		refreshlist();
        }
      })
		
	}
	
	
	
	function updatebodydisclist()
	{
		var uuid = document.getElementById('uuid').value;
		var brem4data = document.getElementById('discountbody').value;
		var updateurl = 'updatediscountajax.cfm?uuid='+escape(uuid)+'&brem4='+escape(brem4data);
		
		new Ajax.Request(updateurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('updatebodydiscajax').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Update Discount'); },		
		
		onComplete: function(transport){
		refreshlist();
		calculatefooter3();
        }
      })
	}
	
	function deleterow(rowno)
	{

		var uuid = document.getElementById('uuid').value;

		var updateurl = 'deleterow.cfm?uuid='+escape(uuid)+'&trancode='+rowno;
		new Ajax.Request(updateurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Delete Item'); },		
		
		onComplete: function(transport){
		calculatefooter();
		refreshlist();
        }
      })
		
	}
	
	
	function gopay(payname)
	{
		
			if ((payname =='totalup6' || payname =='totalup7') && document.getElementById('rem9').value=='')
			{
			alert('Please Key in Remark.');
			}
			else
			{
			var itemcount = 0;
					try{
						itemcount = document.getElementById('hiditemcount').value * 1;
					}
					catch(err)
					{
					}
					if(itemcount != 0)
					{
						ColdFusion.Window.show(payname);
					}	
			}

		
		
	
	}
	
	function submitpay()
	{
		<cfif getgsetup.compulsaryagent eq 'Y'>
		if(document.getElementById('agent').value=='')
		{
			ColdFusion.Window.show('chooseagent');
		<!---var paytypeno = document.getElementById('paytype').value;
		if(paytypeno==0){
			ColdFusion.Window.hide('totalup');
		}
		else{
		ColdFusion.Window.hide('totalup'+paytypeno);
		}--->
		document.getElementById('agent').focus();
		}
		else
		{
		document.getElementById('sub_btn').disabled=true;
		var paytypeno = document.getElementById('paytype').value;
		var cashamt = parseFloat(document.getElementById('paycash'+paytypeno).value);
		if(document.getElementById('paycash'+paytypeno).value == ""){cashamt = 0;}
		var cc1amt = parseFloat(document.getElementById('cc1'+paytypeno).value);
		if(document.getElementById('cc1'+paytypeno).value == ""){cc1amt = 0;}
		var cc2amt = parseFloat(document.getElementById('cc2'+paytypeno).value);
		if(document.getElementById('cc2'+paytypeno).value == ""){cc2amt = 0;}
		var dbcamt = parseFloat(document.getElementById('dbc'+paytypeno).value);
		if(document.getElementById('dbc'+paytypeno).value == ""){dbcamt = 0;}
		var cheqamt = parseFloat(document.getElementById('cheq'+paytypeno).value);
		if(document.getElementById('cheq'+paytypeno).value == ""){cheqamt = 0;}
		var voucheramt = parseFloat(document.getElementById('voucheramt'+paytypeno).value);
		if(document.getElementById('voucheramt'+paytypeno).value == ""){voucheramt = 0;}
		var depositamt = parseFloat(document.getElementById('depositamt'+paytypeno).value);
		if(document.getElementById('depositamt'+paytypeno).value == ""){depositamt = 0;}
		var cashcamt = parseFloat(document.getElementById('cashc'+paytypeno).value);
		if(document.getElementById('cashc'+paytypeno).value == ""){cashcamt = 0;}
		if (paytypeno == 5)
		{
			document.getElementById('cctype').value=getCheckedValue(document.ccform5.cctype15);
			document.getElementById('cctype2').value=getCheckedValue(document.ccform5.cctype25);
			document.getElementById('checkno').value=document.getElementById('chequeno5').value;
			document.getElementById('realdeposit').value=document.getElementById('depositno').value;
			document.getElementById('realvoucherno').value=document.getElementById('voucherno').value;
			if (voucheramt > 0)
			{
				document.getElementById('realvouchertype').value=document.getElementById('vouchertype').value;
				
			}
		}
		if (paytypeno == 6)
		{
			document.getElementById('custno').value=document.getElementById('custno6').value;
			document.getElementById('tran').value='DO';
			document.getElementById('refno').value=document.getElementById('refnoinv').value;
			document.getElementById('cctype').value=getCheckedValue(document.ccform6.cctype16);
			document.getElementById('cctype2').value=getCheckedValue(document.ccform6.cctype26);
			document.getElementById('checkno').value=document.getElementById('chequeno6').value;
			document.getElementById('realdeposit').value=document.getElementById('depositno').value;
		}
		if (paytypeno == 7)
		{
			document.getElementById('custno').value=document.getElementById('custno7').value;
			document.getElementById('tran').value='SO';
			document.getElementById('refno').value=document.getElementById('refnoSO').value;
			document.getElementById('cctype').value=getCheckedValue(document.ccform7.cctype17);
			document.getElementById('cctype2').value=getCheckedValue(document.ccform7.cctype27);
			document.getElementById('checkno').value=document.getElementById('chequeno7').value;
			document.getElementById('realdeposit').value=document.getElementById('depositno7').value;
		}
		try{
		document.getElementById('cctype').value=getCheckedValue(document.ccform.cctype1);
		}
		catch(err)
		{
		}
		try{
		document.getElementById('checkno').value=document.getElementById('chequeno').value;
		}
		catch(err)
		{
		}
		if(document.getElementById('reservebtn').checked==false){
		document.invoicesheet.cash.value = cashamt-parseFloat(document.getElementById('change'+paytypeno).value);
		document.invoicesheet.changeamt1.value=parseFloat(document.getElementById('change'+paytypeno).value);
		}
		else
		{
		document.invoicesheet.cash.value = cashamt;
		document.invoicesheet.changeamt1.value=0;
		}
		document.invoicesheet.credit_card1.value=cc1amt;
		document.invoicesheet.credit_card2.value=cc2amt;
		document.invoicesheet.debit_card.value=dbcamt;
		document.invoicesheet.cheque.value=cheqamt;
		document.invoicesheet.voucher.value=voucheramt;
		document.invoicesheet.deposit.value=depositamt;
		document.invoicesheet.cashcamt.value=cashcamt;
		
		<!--- document.getElementById('rem9').value=document.getElementById('rem9desp'+paytypeno).value; --->
		document.invoicesheet.submit();	
			
		}
		
		
		<cfelse>
		document.getElementById('sub_btn').disabled=true;
		var paytypeno = document.getElementById('paytype').value;
		var cashamt = parseFloat(document.getElementById('paycash'+paytypeno).value);
		if(document.getElementById('paycash'+paytypeno).value == ""){cashamt = 0;}
		var cc1amt = parseFloat(document.getElementById('cc1'+paytypeno).value);
		if(document.getElementById('cc1'+paytypeno).value == ""){cc1amt = 0;}
		var cc2amt = parseFloat(document.getElementById('cc2'+paytypeno).value);
		if(document.getElementById('cc2'+paytypeno).value == ""){cc2amt = 0;}
		var dbcamt = parseFloat(document.getElementById('dbc'+paytypeno).value);
		if(document.getElementById('dbc'+paytypeno).value == ""){dbcamt = 0;}
		var cheqamt = parseFloat(document.getElementById('cheq'+paytypeno).value);
		if(document.getElementById('cheq'+paytypeno).value == ""){cheqamt = 0;}
		var voucheramt = parseFloat(document.getElementById('voucheramt'+paytypeno).value);
		if(document.getElementById('voucheramt'+paytypeno).value == ""){voucheramt = 0;}
		var depositamt = parseFloat(document.getElementById('depositamt'+paytypeno).value);
		if(document.getElementById('depositamt'+paytypeno).value == ""){depositamt = 0;}
		var cashcamt = parseFloat(document.getElementById('cashc'+paytypeno).value);
		if(document.getElementById('cashc'+paytypeno).value == ""){cashcamt = 0;}
		if (paytypeno == 5)
		{
			document.getElementById('cctype').value=getCheckedValue(document.ccform5.cctype15);
			document.getElementById('cctype2').value=getCheckedValue(document.ccform5.cctype25);
			document.getElementById('checkno').value=document.getElementById('chequeno5').value;
			document.getElementById('realdeposit').value=document.getElementById('depositno').value;
			document.getElementById('realvoucherno').value=document.getElementById('voucherno').value;
			if (voucheramt > 0)
			{
				document.getElementById('realvouchertype').value=document.getElementById('vouchertype').value;
			}
		}
		if (paytypeno == 6)
		{
			document.getElementById('custno').value=document.getElementById('custno6').value;
			document.getElementById('tran').value='DO';
			document.getElementById('refno').value=document.getElementById('refnoinv').value;
			document.getElementById('cctype').value=getCheckedValue(document.ccform6.cctype16);
			document.getElementById('cctype2').value=getCheckedValue(document.ccform6.cctype26);
			document.getElementById('checkno').value=document.getElementById('chequeno6').value;
			document.getElementById('realdeposit').value=document.getElementById('depositno').value;
		}
		if (paytypeno == 7)
		{
			document.getElementById('custno').value=document.getElementById('custno7').value;
			document.getElementById('tran').value='SO';
			document.getElementById('refno').value=document.getElementById('refnoSO').value;
			document.getElementById('cctype').value=getCheckedValue(document.ccform7.cctype17);
			document.getElementById('cctype2').value=getCheckedValue(document.ccform7.cctype27);
			document.getElementById('checkno').value=document.getElementById('chequeno7').value;
			document.getElementById('realdeposit').value=document.getElementById('depositno7').value;
		}
		try{
		document.getElementById('cctype').value=getCheckedValue(document.ccform.cctype1);
		}
		catch(err)
		{
		}
		try{
		document.getElementById('checkno').value=document.getElementById('chequeno').value;
		}
		catch(err)
		{
		}

		if(document.getElementById('reservebtn').checked==false){
		document.invoicesheet.cash.value = cashamt-parseFloat(document.getElementById('change'+paytypeno).value);
		document.invoicesheet.changeamt1.value=parseFloat(document.getElementById('change'+paytypeno).value);
		}
		else
		{
		document.invoicesheet.cash.value = cashamt;
		document.invoicesheet.changeamt1.value=0;
		}
		
		document.invoicesheet.credit_card1.value=cc1amt;
		document.invoicesheet.credit_card2.value=cc2amt;
		document.invoicesheet.debit_card.value=dbcamt;
		document.invoicesheet.cheque.value=cheqamt;
		document.invoicesheet.voucher.value=voucheramt;
		document.invoicesheet.deposit.value=depositamt;
		document.invoicesheet.cashcamt.value=cashcamt;

		<!--- document.getElementById('rem9').value=document.getElementById('rem9desp'+paytypeno).value; --->
		document.invoicesheet.submit();
		
		</cfif>
	}
	
	function addsinglevoucher()
	{
		
		var updateurl = 'singlevoucherajax.cfm?voucherno='+escape(document.getElementById('voucherno').value);
		<!---ajaxFunction(document.getElementById('voucherlist'),updateurl);--->
		
				new Ajax.Request(updateurl,
			  {
				method:'get',
				onSuccess: function(getdetailback){
				document.getElementById('getvoucherajax').innerHTML = getdetailback.responseText;
				},
				onFailure: function(){ 
				alert('Error adding voucher'); },		
				
				onComplete: function(transport){
					if ((document.getElementById('hidsinglevouc').value*1) <= (document.getElementById('hidgt5').value*1))
					{
					document.getElementById('voucheramt5').value = document.getElementById('hidsinglevouc').value;
					}
					else
					{
						document.getElementById('voucheramt5').value = document.getElementById('hidgt5').value;
					}
					calculatetotal2('voucherno','voucheramt5');
				}
			  })
	}
	
	function calculatetotal(e,nextflow,upflow)
	{
		var paytypeno = document.getElementById('paytype').value;
<!--- 		if(nextflow != "")
		{
		nextflow = nextflow +paytypeno;
		}
		if(upflow != ""){
		upflow = upflow + +paytypeno;
		} --->
		var gtamt = parseFloat(document.getElementById('hidgt'+paytypeno).value);
		var cashamt = parseFloat(document.getElementById('paycash'+paytypeno).value);
		if(document.getElementById('paycash'+paytypeno).value == ""){cashamt = 0;}
		var cc1amt = parseFloat(document.getElementById('cc1'+paytypeno).value);
		if(document.getElementById('cc1'+paytypeno).value == ""){cc1amt = 0;}
		var cc2amt = parseFloat(document.getElementById('cc2'+paytypeno).value);
		if(document.getElementById('cc2'+paytypeno).value == ""){cc2amt = 0;}
		var dbcamt = parseFloat(document.getElementById('dbc'+paytypeno).value);
		if(document.getElementById('dbc'+paytypeno).value == ""){dbcamt = 0;}
		var cheqamt = parseFloat(document.getElementById('cheq'+paytypeno).value);
		if(document.getElementById('cheq'+paytypeno).value == ""){cheqamt = 0;}
		var voucheramt = parseFloat(document.getElementById('voucheramt'+paytypeno).value);
		if(document.getElementById('voucheramt'+paytypeno).value == ""){voucheramt = 0;}
		var depositamt = parseFloat(document.getElementById('depositamt'+paytypeno).value);
		if(document.getElementById('depositamt'+paytypeno).value == ""){depositamt = 0;}
		var cashcamt = parseFloat(document.getElementById('cashc'+paytypeno).value);
		if(document.getElementById('cashc'+paytypeno).value == ""){cashcamt = 0;}
		var payamt = cashamt + cc1amt + cc2amt + dbcamt + cheqamt + voucheramt + depositamt + cashcamt;
		 if(e.keyCode==40 && nextflow != "" && paytypeno == '5'){
		document.getElementById(nextflow).focus();
		document.getElementById(nextflow).select();
		}
		else if(e.keyCode==13 && upflow != "" && paytypeno == '5' && nextflow == "voucherno"){
		addsinglevoucher();
		document.getElementById(upflow).focus();
		document.getElementById(upflow).select();
		}
		else if(e.keyCode==38 && upflow != "" && paytypeno == '5'){
		document.getElementById(upflow).focus();
		document.getElementById(upflow).select();
		}
		else if(e.keyCode==13 && paytypeno == '5'){
		if(document.getElementById('reservebtn').checked==false){
if(document.getElementById('change5').value*1 < 0){alert('Payment is not Enough');return false;}
else if(((document.getElementById('voucheramt5').value*1)+(document.getElementById('cc15').value*1)+(document.getElementById('cc25').value*1)+(document.getElementById('cheq5').value*1)+(document.getElementById('dbc5').value*1)+(document.getElementById('depositamt5').value*1)) >document.getElementById('hidgt5').value*1 && document.getElementById('change5').value*1 !=0){alert('Voucher+Credit Card+Deposit+Net is Over Amount');return false;}
else if(document.getElementById('cheq5').value*1 >document.getElementById('accumpoints').value*1){alert('Points is Over');return false;}
else{document.getElementById('sub_btn').disabled=true;submitpay();return false;}}else{submitpay();return false;}
		}
		else{
		document.getElementById('payamt'+paytypeno).value=payamt;
		document.getElementById('change'+paytypeno).value=(payamt-gtamt).toFixed(2);
		if(gtamt <= payamt)
		{
			document.getElementById('balanceamt'+paytypeno).value="0.00";
		}
		else
		{
			document.getElementById('balanceamt'+paytypeno).value=(gtamt-payamt).toFixed(2);
		}
		}
	}
	
	
	function calculatetotal2(nextflow,upflow)
	{
		var paytypeno = document.getElementById('paytype').value;

		var gtamt = parseFloat(document.getElementById('hidgt'+paytypeno).value);
		var cashamt = parseFloat(document.getElementById('paycash'+paytypeno).value);
		if(document.getElementById('paycash'+paytypeno).value == ""){cashamt = 0;}
		var cc1amt = parseFloat(document.getElementById('cc1'+paytypeno).value);
		if(document.getElementById('cc1'+paytypeno).value == ""){cc1amt = 0;}
		var cc2amt = parseFloat(document.getElementById('cc2'+paytypeno).value);
		if(document.getElementById('cc2'+paytypeno).value == ""){cc2amt = 0;}
		var dbcamt = parseFloat(document.getElementById('dbc'+paytypeno).value);
		if(document.getElementById('dbc'+paytypeno).value == ""){dbcamt = 0;}
		var cheqamt = parseFloat(document.getElementById('cheq'+paytypeno).value);
		if(document.getElementById('cheq'+paytypeno).value == ""){cheqamt = 0;}
		var voucheramt = parseFloat(document.getElementById('voucheramt'+paytypeno).value);
		if(document.getElementById('voucheramt'+paytypeno).value == ""){voucheramt = 0;}
		var depositamt = parseFloat(document.getElementById('depositamt'+paytypeno).value);
		if(document.getElementById('depositamt'+paytypeno).value == ""){depositamt = 0;}
		var cashcamt = parseFloat(document.getElementById('cashc'+paytypeno).value);
		if(document.getElementById('cashc'+paytypeno).value == ""){cashcamt = 0;}
		var payamt = cashamt + cc1amt + cc2amt + dbcamt + cheqamt + voucheramt + depositamt + cashcamt;
		
		document.getElementById('payamt'+paytypeno).value=payamt;
		document.getElementById('change'+paytypeno).value=(payamt-gtamt).toFixed(2);
		if(gtamt <= payamt)
		{
			document.getElementById('balanceamt'+paytypeno).value="0.00";
		}
		else
		{
			document.getElementById('balanceamt'+paytypeno).value=(gtamt-payamt).toFixed(2);
		}
	}
	
	<cfset uuid = createuuid()>
	<cfset driver = "">
	<cfset rem9 = "">
	<cfif isdefined('url.uuid')>
	<cfset uuid = url.uuid>
	<cfquery name='getdriverremark' datasource='#dts#'>
	select driver,rem9 from ictrantemp where uuid='#url.uuid#'
	</cfquery>
	<cfset driver = getdriverremark.driver>
	<cfset rem9 = getdriverremark.rem9>
	</cfif>
	
	var opt = 'Width=500px, Height=250px, Top=300px, left=400px, scrollbars=yes, status=no, resizable=1';
	<cfoutput>
	
	shortcut.add("#getpayment.sccancel#",function() {
	canceltran();
	});
	
	shortcut.add("#getpayment.scdeposit#",function() {
	window.open('/default/transaction/deposit/Deposittable2.cfm?type=Create&tran=1&sono='+document.getElementById('refno').value,'_blank');
	});
	
	shortcut.add("#getpayment.sccash#",function() {
	
	document.getElementById('paytype').value='0';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup');getfocus10();
	
	});
	
	shortcut.add("#getpayment.scnet#",function() {
	
	document.getElementById('paytype').value='1';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup1');getfocus11();
	
	});
	
	shortcut.add("#getpayment.sccreditcard#",function() {
	
	document.getElementById('paytype').value='2';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup2');getfocus12();
	
	});
	
	shortcut.add("#getpayment.sccheque#",function() {
	
	document.getElementById('paytype').value='3';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup3');getfocus13();
	
	});
	
	shortcut.add("#getpayment.sccashcard#",function() {
	
	document.getElementById('paytype').value='4';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup4');getfocus14();
	
	});
	
	shortcut.add("#getpayment.scmulti#",function() {
	
	document.getElementById('paytype').value='5';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup5');getfocus15();
	
	});
	
	shortcut.add("#getpayment.scclose#",function() {
	
	closetran();
	
	});
	
	shortcut.add("#getpayment.scsearch#",function() {
	
	ColdFusion.Window.show('searchitem');getfocus2();
	
	});
	
	shortcut.add("#getpayment.scfocus#",function() {
	
	document.getElementById('expressservicelist').focus();
	
	});
	
	</cfoutput>
	<!---
	function ctrl1()
	{
	var answer = confirm('Are you sure to hold on the Order?');
	if(answer)
	{
	var onholdurl = '/default/transaction/POS/onholdajax.cfm?uuid='+document.getElementById("uuid").value;
	ajaxFunction(document.getElementById('onholdajax'),onholdurl);
	
	window.location.href="index.cfm";
	}
	}
	
	function ctrl2()
	{
	window.open('cash.cfm?amt='+escape(document.getElementById("grand").value), '',opt);
	}
	
	function ctrl3()
	{
	window.open('creditcard.cfm?amt='+escape(document.getElementById("grand").value), '',opt);
	}
	
	function ctrl4()
	{
	window.open('multipayment.cfm?amt='+escape(document.getElementById("grand").value), '',opt);
	}

	function ctrl5()
	{
	window.open('net.cfm?amt='+escape(document.getElementById("grand").value), '',opt);
	}
	
	function ctrl7()
	{
	window.open('timemanchine.cfm?uuid='+escape(document.getElementById("uuid").value), '',opt);
	} --->
	
	function getdeposit(paytype)
	{
	<cfoutput>
	var depositurl = 'getdepositajax.cfm?depositno='+document.getElementById("depositno").value;
	ajaxFunction(document.getElementById('getdepositajax'),depositurl);
	</cfoutput>
	if (paytype == 5)
	{
	setTimeout("updatedeposit();",300);
	setTimeout("calculatetotal2('depositamt5','cheq5');",300);
	}
	else
	{
	setTimeout("updatedeposit2();",300);
	setTimeout("calculatetotal2('depositamt7','cheq7');",300);
	}
	
	<!---setTimeout("calculatetotal2();",300);--->
	
	
	
	}
	<!---
	function gettcdsvoucher()
	{
	<cfoutput>
	var depositurl = 'gettcdsvoucherajax.cfm?voucherno='+document.getElementById("voucherno").value;
	ajaxFunction(document.getElementById('getvoucherajax'),depositurl);
	</cfoutput>
	setTimeout("updatedeposit2();",300);
	setTimeout("calculatetotal2('depositamt7','cheq7');",300);
	
	}
	
	function updatedeposit()
	{
	document.getElementById('voucheramt5').value=((document.getElementById('hidcash').value*1)+(document.getElementById('hidcheq').value*1)+(document.getElementById('hidcrcd').value*1)+(document.getElementById('hidcrc2').value*1)+(document.getElementById('hiddbcd').value*1)+(document.getElementById('hidvouc').value*1)).toFixed(2);
	}--->
	
	
	function addnewdeposit(deposit){
			myoption = document.createElement("OPTION");
			myoption.text = deposit;
			myoption.value = deposit;
			document.getElementById("depositno").options.add(myoption);
			var indexvalue = document.getElementById("depositno").length-1;
			document.getElementById("depositno").selectedIndex=indexvalue;
			setTimeout("getdeposit();",200);
		}
	
	function updatedeposit()
	{
	
	<!---document.getElementById('paycash6').value=document.getElementById('hidcash').value;
	document.getElementById('cheq6').value=document.getElementById('hidcheq').value;
	document.getElementById('cc16').value=document.getElementById('hidcrcd').value;
	document.getElementById('cc26').value=document.getElementById('hidcrc2').value;
	document.getElementById('dbc6').value=document.getElementById('hiddbcd').value;
	document.getElementById('voucheramt6').value=document.getElementById('hidvouc').value;
	document.getElementById('chequeno6').value=document.getElementById('hidchequeno').value;
	document.getElementById('cctype16'+document.getElementById('hidcctype1').value).checked=true;
	document.getElementById('cctype26'+document.getElementById('hidcctype2').value).checked=true;--->
	document.getElementById('depositamt5').value=((document.getElementById('hidcash').value*1)+(document.getElementById('hidcheq').value*1)+(document.getElementById('hidcrcd').value*1)+(document.getElementById('hidcrc2').value*1)+(document.getElementById('hiddbcd').value*1)+(document.getElementById('hidvouc').value*1)).toFixed(2);
	}
	
	function updatedeposit2()
	{
	
	<!---document.getElementById('paycash6').value=document.getElementById('hidcash').value;
	document.getElementById('cheq6').value=document.getElementById('hidcheq').value;
	document.getElementById('cc16').value=document.getElementById('hidcrcd').value;
	document.getElementById('cc26').value=document.getElementById('hidcrc2').value;
	document.getElementById('dbc6').value=document.getElementById('hiddbcd').value;
	document.getElementById('voucheramt6').value=document.getElementById('hidvouc').value;
	document.getElementById('chequeno6').value=document.getElementById('hidchequeno').value;
	document.getElementById('cctype16'+document.getElementById('hidcctype1').value).checked=true;
	document.getElementById('cctype26'+document.getElementById('hidcctype2').value).checked=true;--->
	document.getElementById('depositamt6').value=((document.getElementById('hidcash').value*1)+(document.getElementById('hidcheq').value*1)+(document.getElementById('hidcrcd').value*1)+(document.getElementById('hidcrc2').value*1)+(document.getElementById('hiddbcd').value*1)+(document.getElementById('hidvouc').value*1)).toFixed(2);
	}
	
	function getSelectedText() {
    var text = "";
    if (typeof window.getSelection != "undefined") {
        text = window.getSelection().toString();
    } else if (typeof document.selection != "undefined" && document.selection.type == "Text") {
        text = document.selection.createRange().text;
    }
    return text;
	}

function doSomethingWithSelectedText() {
    var selectedText = getSelectedText();
    if (selectedText) {
        document.getElementById('changehighlight').value='1'
    }
	else{document.getElementById('changehighlight').value='0'}
	}
	
	
	function addmultiitem()
	{
	var itemlisting=document.getElementById('pickitemuuid').value;
	<cfoutput>
<!--- 	for (k=1;k<=200;k=k+1)
	{
	if (document.getElementById('additem_'+k) == null)
	{
	}
	else
	{	
	if (document.getElementById('additem_'+k).checked == true)
	{
	var itemlisting=itemlisting+"&servicecode"+k+"="+document.getElementById('additem_'+k).value;
	}
	}
	} --->

	var tran = trim(document.getElementById('tran').value);
	var refno = trim(document.getElementById('refno').value);
	var location = trim(document.getElementById('coltype').value);
	var trancode = trim(document.getElementById('nextransac').value);
	var custno = trim(document.getElementById('custno').value);
	var driver = trim(document.getElementById('driver').value);
	
	var ajaxurl2 = '/default/transaction/pos/addmultiproductsAjax.cfm?tran='+escape(tran)+'&tranno='+refno+'&uuid=#URLEncodedFormat(uuid)#&trancode='+escape(trancode)+'&custno='+escape(custno)+'&location='+escape(location)+'&itemlisting='+escape(itemlisting)+'&driver='+escape(driver);
	
	new Ajax.Request(ajaxurl2,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Add Item'); },		
		
		onComplete: function(transport){
		clearformadvance();
		setTimeout('calculatefooter();',500);
		refreshlist();
        }
      })
	
	</cfoutput>
	}
	
	function setunitprice()
	{
	setTimeout("document.getElementById('expprice').value=document.getElementById('priceforunit').value;",500);
	setTimeout("calamtadvance();",500);
	}
	
	function checkpassword()
	{
	if(document.getElementById('cashierlist').value == '' || document.getElementById('cashierpasswordhash').value == '')
	{
	alert('Pls Key in cashier and password');
	}
	else
	{
	if(document.getElementById('cashierpasswordhash').value == document.getElementById('hidcashierpassword').value)
    {
    	document.getElementById('cashierinfo').value=document.getElementById('cashierlist').value;
        ColdFusion.Window.hide('choosecashier');
        document.getElementById('expressservicelist').focus();
		<!---setTimeout("ColdFusion.Window.show('choosecounter');",500)--->
    }
    else
    {
    alert('Wrong cashier or password');
    }
	};
	}
	
	
	function checkpasswordnegativeqty()
	{
	if(document.getElementById('checkpasswordnegaqty').value == 'correct')
	{
	document.getElementById('allownegative').value=1;
	updaterow(document.getElementById('currentrow').value);
	ColdFusion.Window.hide('negativeqty');
	}
	else
	{
	alert('Wrong Password');
	}
	}
	
	function revertback()
	{
	var answer = confirm('Are you sure you want to proceed revert?')
	if(answer)
	{
	var newuuid = document.getElementById('oldlist').value;
	window.location.href="index.cfm?uuid="+newuuid+"&counter="+document.getElementById("counterinfo").value;
	}
	}
	var t1;
	var t2;
	
	function getfocus2()
	{
	t2 = setTimeout("document.getElementById('itemno1').focus();",1000);
	}
	function getfocus3()
	{
	t2 = setTimeout("document.getElementById('aitemno').focus();",1000);
	}
	
	function getfocus4()
	{

	setTimeout("document.getElementById('price_bil1').select();",500);

	}
	
	function getfocus5()
	{

	setTimeout("document.getElementById('qty_bil1').select();",500);

	}
	
	function getfocus6()
	{

	setTimeout("document.getElementById('brem41').select();",500);

	}
	
	function getfocus10()
	{
	setTimeout("document.getElementById('paycash0').focus();document.getElementById('paycash0').select();",500);
	}
	
	function getfocus11()
	{
	setTimeout("document.getElementById('dbc1').focus();document.getElementById('dbc1').select();",500);
	}
	
	function getfocus12()
	{
	setTimeout("document.getElementById('cctype1').focus();document.getElementById('cctype1').select();",500);
	}
	function getfocus13()
	{
	setTimeout("document.getElementById('chequeno').focus();document.getElementById('chequeno').select();",500);
	}
	function getfocus14()
	{
	setTimeout("document.getElementById('cashc4').focus();document.getElementById('cashc4').select();",500);
	}
	function getfocus15()
	{
	setTimeout("document.getElementById('paycash5').focus();document.getElementById('paycash5').select();",250);
	}
	
	
	
	
	function itemcheckbox(itembox)
	{
				
		 for (m=1;m<=160;m=m+1)
		{
		if (document.getElementById('btn'+m) == null)
		{
		}
		else
		{	
		document.getElementById('btn'+m).style.visibility='hidden';
		}
		}
		
		if (itembox.checked == true)
		{
			var actionpick = 'add';	
		}	  
		else 
		{	
		var actionpick = 'delete';		
		}
			var updateurl = 'pickitemlist.cfm?action='+actionpick+'&uuid='+escape(document.getElementById('pickitemuuid').value)+'&itemno='+escape(itembox.value);
				new Ajax.Request(updateurl,
			  {
				method:'get',
				onSuccess: function(getdetailback){
				document.getElementById('pickitemlist').innerHTML = trim(getdetailback.responseText);
				},
				onFailure: function(){ 
				alert('Error Pick Item'); },		
				
				onComplete: function(transport){
				}
			  })
				  
	
	
	}
	
	
	function nextIndex(e,thisid,id)
	{
	var itemno = document.getElementById('expressservicelist').value;
	var scancount=document.getElementById('scancount').value;
	if (thisid == 'expressservicelist' && itemno == '')
	{
		if(e.keyCode==40){
		document.getElementById('expqty').focus();
		document.getElementById('expqty').select();
		}
		if(e.keyCode==39){
		document.getElementById('coltype').focus();
		}
		if(e.keyCode==38){
		document.getElementById('eulist').focus();
		}
		<!---if(e.keyCode==13){
			var itemcount = 0;
			try{
				itemcount = document.getElementById('hiditemcount').value * 1;
			}
			catch(err)
			{
			}
			if(itemcount != 0)
			{
				document.getElementById('paytype').value='0';
				document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;
				setTimeout("document.getElementById('paycash0').focus();document.getElementById('paycash0').select();",500);
				ColdFusion.Window.show('totalup');
			}
		}--->
	}
	else if (thisid == 'eulist')
	{
		if(e.keyCode==13){
			searchSel('driver','eulist');
			document.getElementById(''+id+'').focus();
		}
		else
		{
			if(trim(document.getElementById('eulist').value) != ''){
			searchSel('driver','eulist');
			}
			else{
			document.getElementById('driver').options[0].selected=true;
			}
		}
	}
	
	else if (<cfif lcase(hcomid) eq "pohsiangpl_i">thisid == 'expprice'<cfelse>thisid == 'expqty' || thisid == 'expunit'</cfif>)
	{
		if(e.keyCode==13 && document.getElementById('btn_add').value == "Add" && itemno != ''){
			addItemAdvance();
		}
		else if(e.keyCode==13)
		{
			document.getElementById(''+id+'').focus();
		}
	}

	else if (thisid == 'expressservicelist' && document.getElementById('multiscan').checked==true && (scancount*1) < 4)
	{
	if(e.keyCode==13){
		document.getElementById('expressservicelist').focus();
		document.getElementById('scancount').value=(scancount*1)+1;
	}
	}
	
	
	else if (thisid == 'expressservicelist' && document.getElementById('multiscan').checked==true && (scancount*1) >= 4)
	{
		
		if(e.keyCode==13){
		document.getElementById(''+id+'').focus();
		document.getElementById('scancount').value=1;
		try{
		document.getElementById(''+id+'').select();
		}
		catch(err)
		{
		}
		}
		}
	<cfif getgsetup.hideqty eq 'Y'>	
	else if (thisid == 'expressservicelist')
	{
		if(e.keyCode==13 && itemno != '')
		{
		getitemdetail(itemno);
		<cfoutput>
		setTimeout('hideqtyadditem();',#getgsetup.additemdelay#);
		</cfoutput>
		}
	}
	</cfif>
	
	else
	{
	if(e.keyCode==13){
	document.getElementById(''+id+'').focus();
	try{
	document.getElementById(''+id+'').select();
	}
	catch(err)
	{
	}
	}
	}
	}
	
	function hideqtyadditem(){ 
	
	var itemno= document.getElementById('expressservicelist').value.replace(/^[\s]+/,'').replace(/[\s]+$/,'').replace(/[\s]{2,}/,' ');
	if(document.getElementById('btn_add').value == "Add" && itemno!= ''){
			addnewitem2();
		}
		else
		{
			document.getElementById('expressservicelist').focus();
		}
	}
		
	function selectOptionByValue(selObj, val){ 
    var A= selObj.options, L= A.length; 
    while(L){ 
        if (A[--L].value== val){ 
            selObj.selectedIndex= L; 
            L= 0; 
        } 
    } 
	}
		
	function selectOptionByValue(selObj, val){ 
    var A= selObj.options, L= A.length; 
    while(L){ 
        if (A[--L].value== val){ 
            selObj.selectedIndex= L; 
            L= 0; 
        } 
    } 
	} 
	function convertToEntities(valin) {
    var tstr = valin;
    var bstr = '';

    for (i=0; i<tstr.length; i++) {

        if (tstr.charCodeAt(i)>127) {
            bstr += '&#' + tstr.charCodeAt(i) + ';';
        } else {
            bstr += tstr.charAt(i);
        }
    }
    return bstr;
}
		
	function updateVal()
	{
	var validdesp = unescape(document.getElementById('desphid').value);
	var droplist = document.getElementById('expunit');
	
	  while (droplist.length > 0)
	  {
		  droplist.remove(droplist.length - 1);
	  }

	
	if (validdesp == "itemisnoexisted")
	{
	document.getElementById('btn_add').value = "Item No Existed";
	document.getElementById('btn_add').disabled = true; 
	alert('Item Not Found');
	document.getElementById('expressservicelist').value="";
	document.getElementById('expressservicelist').focus();
	}
	else
	{
	var commaSeparatedValueList = document.getElementById('unithid').value;
	var valueArray = commaSeparatedValueList.split(",");
	for(var i=0; i<valueArray.length; i++){
		var opt = document.createElement("option");
        document.getElementById("expunit").options.add(opt);  
        opt.text = valueArray[i];
        opt.value = valueArray[i];

	}
	try
	{
	document.getElementById('expressservicelist').value = unescape(decodeURI(document.getElementById('replaceitemno').value));
	}
	catch(err)
	{
	}
	document.getElementById('desp2').value = unescape(decodeURI(document.getElementById('desphid').value));
	document.getElementById('expunit').selectedIndex =0;
	document.getElementById('expprice').value = document.getElementById('pricehid').value;
	document.getElementById('costformula').value = document.getElementById('costformulaid').value;
	document.getElementById('btn_add').value = "Add";
	document.getElementById('btn_add').disabled = false; 
	}
	calamtadvance();
	
<!--- 	if(document.getElementById('btn_add').value == "Add")
	{
	addItemAdvance();
	} --->
	}
	<cfif getgsetup.expressdisc eq "1">
	function caldisamt()
	{
	var expqty = trim(document.getElementById('expqty').value);
	var expprice = trim(document.getElementById('expprice').value);
	var disamt1 = document.getElementById('expunitdis1').value;
	var disamt2 = document.getElementById('expunitdis2').value;
	var disamt3 = document.getElementById('expunitdis3').value;
	disamt1 = disamt1 * 0.01;
	disamt2 = disamt2 * 0.01;
	disamt3 = disamt3 * 0.01;
	var totaldiscount = ((((expqty * expprice) * disamt1)+ (((expqty * expprice)-(expqty * expprice) * disamt1))*disamt2)+(((expqty * expprice)-(((expqty * expprice)-(expqty * expprice) * disamt1))*disamt2))*disamt3);
	document.getElementById('expdis').value = totaldiscount.toFixed(2);
	}
	<cfelse>
	function caldisamt()
	{
	var qtydis = document.getElementById('expqtycount').value;
	var disamt = document.getElementById('expunitdis').value;
	qtydis = qtydis * 1;
	disamt = disamt * 1;
	var totaldiscount = qtydis * disamt;
	document.getElementById('expdis').value = totaldiscount.toFixed(2);
	}
	</cfif>
	function calamtadvance()
	{
	var expqty = trim(document.getElementById('expqty').value);
	var expprice = trim(document.getElementById('expprice').value);
	var expdis = trim(document.getElementById('expdis').value);
	expqty = expqty * 1;
	expprice = expprice * 1;
	expdis = expdis * 1;
	var itemamt = (expqty * expprice) - expdis;
	document.getElementById('expressamt').value =  itemamt.toFixed(2);
	
	}
	
	function changeitemdesp()
	{

	var itemdesptrancode = document.getElementById('itemdesptrancode').value;
	var itemdesp = document.getElementById('itemdesp1').value;
	var itemdespa = document.getElementById('itemdesp2').value;
<cfoutput>
	var itemdespurl = '/default/transaction/pos/itemdespprocess.cfm?uuid=#URLEncodedFormat(uuid)#&trancode='+escape(itemdesptrancode)+'&itemdesp='+escape(itemdesp)+'&itemdespa='+escape(itemdespa);
	ajaxFunction(document.getElementById('changedespajax'),itemdespurl);
	</cfoutput>
	}
	
	function trim(strval)
	{
	return strval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
	}
	
	function addItemAdvance()
	{
		
	<cfoutput>
	var expressservice=encodeURI(trim(document.getElementById('expressservicelist').value));
	var desp = encodeURI(document.getElementById('desp2').value);
	var expressamt = trim(document.getElementById('expressamt').value);
	var expqty = trim(document.getElementById('expqty').value);
	var expprice = trim(document.getElementById('expprice').value);
	var expunit = trim(document.getElementById('expunit').value);
	var expunitdis1 = trim(document.getElementById('expunitdis1').value);
	var expunitdis2 = trim(document.getElementById('expunitdis2').value);
	var expunitdis3 = trim(document.getElementById('expunitdis3').value);
	var expdis = trim(document.getElementById('expdis').value);
	var isservi = trim(document.getElementById('isservi').value);
	var tran = trim(document.getElementById('tran').value);
	var custno = trim(document.getElementById('custno').value);
	var refno = trim(document.getElementById('refno').value);
	var trancode = trim(document.getElementById('nextransac').value);
	var glacc = trim(document.getElementById('glacc').value);
	var brem1 = trim(document.getElementById('coltype').value);
	var driver = trim(document.getElementById('driver').value);
	var rem9 = trim(document.getElementById('rem9').value);
	
	var ajaxurl = '/default/transaction/POS/addproductsAjax.cfm?servicecode='+escape(expressservice)+'&desp='+escape(desp)+'&expressamt='+escape(expressamt)+'&expqty='+escape(expqty)+'&expprice='+escape(expprice)+'&unit='+escape(expunit)+'&dispec1='+escape(expunitdis1)+'&dispec2='+escape(expunitdis2)+'&dispec3='+escape(expunitdis3)+'&dis='+escape(expdis)+'&tran='+escape(tran)+'&tranno='+refno+'&uuid=#URLEncodedFormat(uuid)#&custno='+escape(custno)+'&isservi='+escape(isservi)+'&trancode='+escape(trancode)+'&glacc='+escape(glacc)+'&brem1='+escape(brem1)+'&driver='+escape(driver)+'&rem9='+escape(rem9);
	
	 new Ajax.Request(ajaxurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Add Item'); },		
		
		onComplete: function(transport){
		clearformadvance();
		calculatefooter();
		refreshlist();
        }
      })
	
	<!---ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
	clearformadvance();
	setTimeout('calculatefooter();',750);
	setTimeout('refreshlist();',750);--->
	</cfoutput>
	}
	
	
	function exchangereceipt(exchangerefno)
	{
		<cfoutput>
	var driver = trim(document.getElementById('driver').value);
	var rem9 = trim(document.getElementById('rem9').value);
	var tran = trim(document.getElementById('tran').value);
	var custno = trim(document.getElementById('custno').value);
	var refno = trim(document.getElementById('refno').value);
	var trancode = trim(document.getElementById('nextransac').value);
	
	var ajaxurl = '/default/transaction/POS/exchangereceiptAjax.cfm?exchangerefno='+escape(exchangerefno)+'&uuid=#URLEncodedFormat(uuid)#'+'&driver='+escape(driver)+'&rem9='+escape(rem9)+'&tran='+escape(tran)+'&tranno='+refno+'&custno='+escape(custno);
	document.getElementById('rem41').value=exchangerefno;
	
	 new Ajax.Request(ajaxurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Add Item'); },		
		
		onComplete: function(transport){
		clearformadvance();
		calculatefooter();
		refreshlist();
        }
      })
	
	<!---ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
	clearformadvance();
	setTimeout('calculatefooter();',750);
	setTimeout('refreshlist();',750);--->
	</cfoutput>
	}
	
	
	
	
	
	
	function clearformadvance()
	{
	document.getElementById('expressservicelist').value = '';
	document.getElementById('desp2').value = '';
	document.getElementById('expressamt').value = '0.00';
	document.getElementById('expqty').value = '1';
	document.getElementById('expprice').value = '0.00';
	document.getElementById('expunit').value = '';
	document.getElementById('expdis').value = '0.00';
	document.getElementById('expunitdis1').value = '0';
	document.getElementById('expunitdis2').value = '0';
	document.getElementById('expunitdis3').value = '0';
	<!--- $('#expressservicelist').select2('data',{id:"",text:"Choose an Item"});
	$('#expressservicelist').select2('open'); --->
	<cfif getgsetup.expressdisc neq "1">
	document.getElementById('expunitdis').value = '0.00';
	document.getElementById('expqtycount').value = '1';
	</cfif>
	}
	
	function refreshlist()
	{
	ajaxFunction(document.getElementById('itemlist'),'getBody.cfm?uuid='+document.getElementById('uuid').value);
	ajaxFunction(document.getElementById('getqtytotal'),'getqtytotal.cfm?uuid='+document.getElementById('uuid').value);
	}
	
	function getitemdetail(detailitemno)
	{
	if(document.getElementById('counterinfo').value=='')
	{
		<cfif getgsetup.compulsarycounter eq 'Y'>
		alert('Please Choose Counter')
		<cfelse>
		if(detailitemno.indexOf('*') != -1)
	{
	var thisitemno = detailitemno.split('*');
	document.getElementById('expressservicelist').value=thisitemno[1];
	document.getElementById('expqty').value=thisitemno[0];
	detailitemno=thisitemno[1];
	}
	if(trim(document.getElementById('expressservicelist').value) != "")
	{
    var urlloaditemdetail = '/default/transaction/POS/addItemAjax.cfm?itemno='+escape(encodeURI(detailitemno))+'&reftype='+document.getElementById('tran').value;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('itemDetail').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		 alert('Item Not Found'); },		
		
		onComplete: function(transport){
		 <!--- getlocationbal(detailitemno);--->
		
		 updateVal();
        }
      })
	}
		</cfif>
	}
	else
	{
	if(detailitemno.indexOf('*') != -1)
	{
	var thisitemno = detailitemno.split('*');
	document.getElementById('expressservicelist').value=thisitemno[1];
	document.getElementById('expqty').value=thisitemno[0];
	detailitemno=thisitemno[1];
	}
	if(trim(document.getElementById('expressservicelist').value) != "")
	{
    var urlloaditemdetail = '/default/transaction/POS/addItemAjax.cfm?itemno='+escape(encodeURI(detailitemno))+'&reftype='+document.getElementById('tran').value;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('itemDetail').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		 alert('Item Not Found'); },		
		
		onComplete: function(transport){
		 <!--- getlocationbal(detailitemno);--->
		
		 updateVal();
        }
      })
	}
	}
	}
	
	function getitemdetail2(detailitemno)
	{
	if(document.getElementById('counterinfo').value=='')
	{
		<cfif getgsetup.compulsarycounter eq 'Y'>
		alert('Please Choose Counter')
		<cfelse>
		if(detailitemno.indexOf('*') != -1)
	{
	var thisitemno = detailitemno.split('*');
	document.getElementById('expressservicelist').value=thisitemno[1];
	document.getElementById('expqty').value=thisitemno[0];
	detailitemno=thisitemno[1];
	}
	if(trim(document.getElementById('expressservicelist').value) != "")
	{
    var urlloaditemdetail = '/default/transaction/POS/addItemAjax.cfm?itemno='+escape(encodeURI(detailitemno))+'&reftype='+document.getElementById('tran').value;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('itemDetail').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		 alert('Item Not Found'); },		
		
		onComplete: function(transport){
		 <!--- getlocationbal(detailitemno);--->
		
		 updateVal();
		<cfif lcase(hcomid) eq "gamemartz_i">
		setTimeout('additembtn();',250);
		</cfif>
        }
      })
	}
		</cfif>
	}
	else
	{
	if(detailitemno.indexOf('*') != -1)
	{
	var thisitemno = detailitemno.split('*');
	document.getElementById('expressservicelist').value=thisitemno[1];
	document.getElementById('expqty').value=thisitemno[0];
	detailitemno=thisitemno[1];
	}
	if(trim(document.getElementById('expressservicelist').value) != "")
	{
    var urlloaditemdetail = '/default/transaction/POS/addItemAjax.cfm?itemno='+escape(encodeURI(detailitemno))+'&reftype='+document.getElementById('tran').value;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('itemDetail').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		 alert('Item Not Found'); },		
		
		onComplete: function(transport){
		 <!--- getlocationbal(detailitemno);--->
		
		 updateVal();
		<cfif lcase(hcomid) eq "gamemartz_i">
		setTimeout('additembtn();',250);
		</cfif>
        }
      })
	}
	}
	}
	
	function getlocationbal(itemnobal)
	{
	  var urlloaditembal = '/default/transaction/POS/balonhand.cfm?itemno='+encodeURI(itemnobal)+'&location='+escape(document.getElementById('locationfr').value);
	
	  new Ajax.Request(urlloaditembal,
      {
        method:'get',
        onSuccess: function(getbalback){
		document.getElementById('itembal').innerHTML = trim(getbalback.responseText);
        },
        onFailure: function(){ 
		alert('Item Not Found'); }
      })
	}
	
	function recalculateall()
	{
	<cfoutput>
    var urlload = '/default/transaction/POS/recalculateAjax.cfm?uuid=#URLEncodedFormat(uuid)#';
	</cfoutput>
    new Ajax.Request(urlload,
      {
        method:'get',
        onSuccess: function(flyback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(flyback.responseText);
		calculatefooter2();
        },
        onFailure: function(){ 
		alert('Item Not Found'); },		
		onComplete: function(transport){
		 invoicesheet.submit();
        }
      });
	}
	
	function validformfield()
	{
	var formvar = document.getElementById('invoicesheet');
	var answer = _CF_checkinvoicesheet(formvar);
	if (answer)
	{
	recalculateall();
	}
	else
	{
	}
	}
	
	function calculatefooter()
	{
	document.getElementById('gross').value = document.getElementById('hidsubtotal').value;
	var hiditemcount = document.getElementById('hiditemcount').value * 1;
	
	if (hiditemcount == 0)
	{
	<!--- document.getElementById('Submit').disabled = true; --->
	}
	else
	{
	document.getElementById('nextransac').options.length = 0;
	var droplistmenu = document.getElementById('nextransac');
	for (var i=hiditemcount+1; i > 0;--i){
	addOption(droplistmenu, i, i);
	}

	<!--- document.getElementById('Submit').disabled = false; --->
	}

	calcdisc();
	caltax();
	calcfoot();
	}
	
	function calculatefooter2()
	{
	document.getElementById('gross').value = document.getElementById('hidsubtotal').value;
	var hiditemcount = document.getElementById('hiditemcount').value * 1;
	if (hiditemcount == 0)
	{
	document.getElementById('Submit').disabled = true;
	}
	else
	{
	document.getElementById('nextransac').options.length = 0;
	var droplistmenu = document.getElementById('nextransac');
	for (var i=hiditemcount+1; i > 0;--i){
	addOption(droplistmenu, i, i);
	}

	document.getElementById('Submit').disabled = false;
	}
	if(document.getElementById('dispec1').value * 1 == 0 && document.getElementById('dispec2').value * 1 == 0 && document.getElementById('dispec2').value * 3 == 0)
	{
	calcdisc2();
	}
	else{
	calcdisc();
	}
	caltax();
	calcfoot();
	}
	
	function calculatefooter3()
	{
	document.getElementById('gross').value = document.getElementById('hidsubtotal2').value;
	var hiditemcount = document.getElementById('hiditemcount2').value * 1;
	if (hiditemcount == 0)
	{
	document.getElementById('Submit').disabled = true;
	}
	else
	{
	document.getElementById('nextransac').options.length = 0;
	var droplistmenu = document.getElementById('nextransac');
	for (var i=hiditemcount+1; i > 0;--i){
	addOption(droplistmenu, i, i);
	}

	document.getElementById('Submit').disabled = false;
	}
	calcdisc();
	caltax();
	calcfoot();
	}
	
	
	function addOption(selectbox,text,value )
	{
	var optn = document.createElement("OPTION");
	optn.text = text;
	optn.value = value;
	selectbox.options.add(optn);
	}
	function calcfoot()
	{
	var gross = document.getElementById('gross').value * 1;
	var disamt = document.getElementById('disamt_bil').value * 1;
	var taxincl = document.getElementById('taxincl').checked;
	var net = document.getElementById('net');
	var taxamt = document.getElementById('taxamt').value * 1;
	var M_charge1 = document.getElementById('M_charge1').value * 1;
	var grand = document.getElementById('grand');
	var grand2 = document.getElementById('grand2');
	net.value = (gross-disamt).toFixed(2);
	if(taxincl == true)
	{
	grand.value = ((net.value * 1)+(M_charge1 * 1)).toFixed(2);
	<cfif lcase(hcomid) eq 'tcds_i'>
	grand2.value = ((Math.ceil(((net.value * 1)+(M_charge1 * 1)).toFixed(2)* 2*10)/10).toFixed(1))
	grand2.value = (grand2.value/2).toFixed(2);
	<cfelse>
	grand2.value = ((net.value * 1)+(M_charge1 * 1)).toFixed(2);
	</cfif>
	}
	else
	{
	var netb = ((net.value * 1) + (taxamt * 1)+(M_charge1 * 1));
	grand.value = netb.toFixed(2);
	<cfif lcase(hcomid) eq 'tcds_i'>
	grand2.value = ((Math.ceil(netb* 2*10)/10).toFixed(1));
	grand2.value = (grand2.value/2).toFixed(2);
	<cfelse>
	grand2.value = netb.toFixed(2); 
	</cfif>
	
	}

	
	}
	
	function calcdisc()
	{
	var gross = document.getElementById('gross').value * 1;
	var dispec1 = document.getElementById('dispec1').value * 1;
	var dispec2 = document.getElementById('dispec2').value * 1;
	var dispec3 = document.getElementById('dispec3').value * 1;
	var disamt = document.getElementById('disamt_bil');
	var net = document.getElementById('net');
	var disval = 0;
	
	disval = gross - (gross * (dispec1/100));
	document.getElementById('disbil1').value = gross * (dispec1/100);
	disval = disval - (disval * (dispec2 /100));
	document.getElementById('disbil2').value =disval * (dispec2 /100);
	disval = disval - (disval * (dispec3 /100));
	document.getElementById('disbil3').value = disval * (dispec3 /100);
	net.value = disval.toFixed(2);
	disamtlas = gross - disval;
	disamt.value = disamtlas.toFixed(2);
	
	}
	
	function calcdisc2()
	{
	var gross = document.getElementById('gross').value * 1;
	var dispec1 = document.getElementById('dispec1').value * 1;
	var dispec2 = document.getElementById('dispec2').value * 1;
	var dispec3 = document.getElementById('dispec3').value * 1;
	var disamt = document.getElementById('disamt_bil');
	var net = document.getElementById('net');
	var disval = 0;
	
	disval = disamt;
	net.value = disval.toFixed(2);
	disamtlas = gross - disval;
	disamt.value = disamtlas.toFixed(2);
	
	}
	
	
	function caltax()
	{
	var net = document.getElementById('net').value;
	var taxincl = document.getElementById('taxincl').checked;
	var taxper = document.getElementById('taxper').value;
	var taxamt = document.getElementById('taxamt');
	var grand = document.getElementById('grand');
	var grand2 = document.getElementById('grand2');
	var taxval = 0;
	taxper = parseFloat(taxper);
	net = parseFloat(net);

	if (taxincl == true)
	{
	taxval = ((taxper/(100+taxper))*net).toFixed(2);
	taxamt.value = taxval;
	grand.value = net.toFixed(2);
	<cfif lcase(hcomid) eq 'tcds_i'>
	grand2.value = ((Math.ceil(net* 2*10)/10).toFixed(1));
	grand2.value = (grand2.value/2).toFixed(2);
	<cfelse>
	grand2.value = net.toFixed(2);
	</cfif>
	}
	else
	{
	taxval = ((taxper/100)*net).toFixed(2);
	taxamt.value = taxval;
	var netb = (net * 1) + (taxval * 1);
	grand.value = netb.toFixed(2);
	<cfif lcase(hcomid) eq 'tcds_i'>
	grand2.value = ((Math.ceil(netb* 2*10)/10).toFixed(1));
	grand2.value = (grand2.value/2).toFixed(2);
	<cfelse>
	grand2.value = netb.toFixed(2);
	</cfif>
	}

	}
	<cfoutput>
	function recalculateamt()
	{
	var ajaxurl = '/default/transaction/POS/recalculateAjax.cfm?uuid=#URLEncodedFormat(uuid)#';
	new Ajax.Request(ajaxurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Update Item'); },		
		
		onComplete: function(transport){
		calculatefooter();
        }
      })
	}
	function expand()
	{
	var psnow = document.getElementById('pagesize').value * 1;
	if (psnow == 7)
	{
	document.getElementById('pagesize').value = 20;
	}
	else
	{
	document.getElementById('pagesize').value = 7;
	}
	setTimeout('refreshlist();',750);
	}
	
	function additembtn()
	{
	if(document.getElementById('counterinfo').value=='')
	{
		<cfif getgsetup.compulsarycounter eq 'Y'>
		alert('Please Choose Counter')
		<cfelse>
		var itemno = document.getElementById('expressservicelist').value;
		<!---getitemdetail(itemno);--->
		<cfoutput>
		setTimeout('hideqtyadditem();',#getgsetup.additemdelay#);
		</cfoutput>
		</cfif>
	}
	else
	{
	var itemno = document.getElementById('expressservicelist').value;
		<!---getitemdetail(itemno);--->
		<cfoutput>
		setTimeout('hideqtyadditem();',#getgsetup.additemdelay#);
		</cfoutput>
	}
	}
	
	function addnewitem2()
	{
	if(document.getElementById('expressamt').value=='NaN')
	{
	alert('Error in Qty / Price / Discount / Amt');
	return false;
	}
	calamtadvance();
	if(document.invoicesheet.glacc.value == '' || document.invoicesheet.glacc.value.length == 8){
	<cfif getgsetup.PCBLTC eq "Y">
	try
	{
	var stkcost = document.getElementById('stkcost').value * 1;
	var stkprice = document.getElementById('expprice').value * 1;
	if (stkprice < stkcost)
	{
	ColdFusion.Window.show('stkcostcontrol');
	setTimeout("document.getElementById('passwordString').focus();",500);
	}
	else
	{
	addItemControl();
	}
	}
	catch(e)
	{
	addItemControl();
	}
	<cfelse>
	addItemControl();
	</cfif>
	}
	else{
	alert('Check GL account no');
	}
	}
	function addItemControl()
	{

	var itemno = document.getElementById('expressservicelist').value;
	var isservi = document.getElementById('isservi').value;
	var qtyser = document.getElementById('expqty').value;
	
	if (itemno == "")
	{
	alert("Please select item");
	}
	
	else if (isservi == "1" && (qtyser == "" || qtyser == 0))
	{
	<cfif getgsetup.ECAMTOTA eq "Y">
	ColdFusion.Window.show('serviceamount');
	setTimeout("document.getElementById('serviceamount').focus();",500);
	<cfelse>
	addItemAdvance();
	</cfif>
	}
	else
	{
	<cfif getgsetup.negstk eq "1">
	addItemAdvance();
	<cfelse>
	try
	{
	var trantype = document.getElementById('tran').value;
	var balstk = document.getElementById('balonhand').value * 1;
	var qtyneeded = document.getElementById('expqty').value * 1;
	var balance = balstk - qtyneeded;
	if (balance < 0 && trantype != "RC" && trantype != "CN" && trantype != "PO")
	{
	ColdFusion.Window.show('negativestock');
	setTimeout("document.getElementById('passwordString').focus();",500);
	}
	else
	{
	addItemAdvance();
	}
	}
	catch(e)
	{
	addItemAdvance();
	}
	</cfif>
	}
	}
	</cfoutput>
	function selectlist(varval,varattb){		
		for (var idx=0;idx<document.getElementById(varattb).options.length;idx++) 
		{
			if (varval==document.getElementById(varattb).options[idx].value) 
			{
				document.getElementById(varattb).options[idx].selected=true;
				
			}
		}
		}
		
		
	function updateprice(uuid,trancode,price)
	{
	if((price*1)<(document.getElementById('minimumprice2').value*1))
	{
		alert('price key in cannot be lower than minimum price :'+document.getElementById('minimumprice2').value);
	}
	else if((price*1)<(document.getElementById('sellingbelowcost').value*1))
	{
		ColdFusion.Window.show('belowcostpassword');
	}
	else
	{
    var urlloaditemdetail = '/default/transaction/POS/updateprice.cfm?trancode='+trancode+'&uuid='+uuid+'&price='+price;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		
        },
        onFailure: function(){ 
		alert('Error Update Price'); },		
		
		onComplete: function(transport){
		calculatefooter();
		refreshlist();
		recalculateamt();
		ColdFusion.Window.hide('changeprice');
        }
      })
	}
	}
	
	function updateprice2(e,uuid,trancode,price)
	{
	if(e.keyCode==13){
	if((price*1)<(document.getElementById('minimumprice2').value*1))
	{
		alert('price key in cannot be lower than minimum price :'+document.getElementById('minimumprice2').value);
	}
	else if((price*1)<(document.getElementById('sellingbelowcost').value*1))
	{
		ColdFusion.Window.show('belowcostpassword');
	}
	else
	{
    var urlloaditemdetail = '/default/transaction/POS/updateprice.cfm?trancode='+trancode+'&uuid='+uuid+'&price='+price;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		
        },
        onFailure: function(){ 
		alert('Error Update Price'); },		
		
		onComplete: function(transport){
		calculatefooter();
		refreshlist();
		recalculateamt();
		ColdFusion.Window.hide('changeprice');
        }
      })
	}
	}
	}
	
	function checkcostupdateprice()
	{
		var adminpass=document.getElementById('passwordString').value;

		 var urlloaditemdetail = '/default/transaction/POS/belowcostpasswordcontrolprocess.cfm?password='+adminpass;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
			document.getElementById('checkbelowcostfield').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Update Price'); },		
		
		onComplete: function(transport){
			updateignoreprice();
		}
      })
	}
	
	function updateignoreprice()
	{
		if(document.getElementById('comfirmpassword').value==1)
		{
		var uuid = document.getElementById('changepriceuuid').value;
		var trancode = document.getElementById('changepricetrancode').value;
		var price = document.getElementById('price_bil1').value;
		

    var urlloaditemdetail = '/default/transaction/POS/updateprice.cfm?trancode='+trancode+'&uuid='+uuid+'&price='+price;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		
        },
        onFailure: function(){ 
		alert('Error Update Price'); },		
		
		onComplete: function(transport){
		calculatefooter();
		refreshlist();
		recalculateamt();
		ColdFusion.Window.hide('belowcostpassword');
		ColdFusion.Window.hide('changeprice');
        }
      })
		}
		else
		{
			alert('Wrong Password')
		}
	}
	
	
	function updateqty(uuid,trancode,qty)
	{
    var urlloaditemdetail = '/default/transaction/POS/updateqty.cfm?trancode='+trancode+'&uuid='+uuid+'&qty='+qty;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		
        },
        onFailure: function(){ 
		alert('Error Update Qty'); },		
		
		onComplete: function(transport){
		calculatefooter();
		refreshlist();
		recalculateamt();
		ColdFusion.Window.hide('changeqty');
        }
      })
	}
	
	function updateqty2(e,uuid,trancode,qty)
	{
	if(e.keyCode==13){
    var urlloaditemdetail = '/default/transaction/POS/updateqty.cfm?trancode='+trancode+'&uuid='+uuid+'&qty='+qty;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		
        },
        onFailure: function(){ 
		alert('Error Update Qty'); },		
		
		onComplete: function(transport){
		calculatefooter();
		refreshlist();
		recalculateamt();
		ColdFusion.Window.hide('changeqty');
        }
      })
	}
	}
	
	function updatediscount(uuid,trancode,discount)
	{
    var urlloaditemdetail = '/default/transaction/POS/updatediscount.cfm?trancode='+trancode+'&uuid='+uuid+'&brem4='+discount;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		
        },
        onFailure: function(){ 
		alert('Error Update discount'); },		
		
		onComplete: function(transport){
		calculatefooter();
		refreshlist();
		recalculateamt();
		ColdFusion.Window.hide('changediscount');
        }
      })
	}
	
	function updatediscount2(e,uuid,trancode,discount)
	{
	if(e.keyCode==13){
    var urlloaditemdetail = '/default/transaction/POS/updatediscount.cfm?trancode='+trancode+'&uuid='+uuid+'&brem4='+discount;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		
        },
        onFailure: function(){ 
		alert('Error Update Discount'); },		
		
		onComplete: function(transport){
		calculatefooter();
		refreshlist();
		recalculateamt();
		ColdFusion.Window.hide('changediscount');
        }
      })
	}
	}
	
	
	function updateamt(uuid,trancode,amt)
	{
    var urlloaditemdetail = '/default/transaction/POS/updateamt.cfm?trancode='+trancode+'&uuid='+uuid+'&amt='+amt;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		
        },
        onFailure: function(){ 
		alert('Error Update Amount'); },		
		
		onComplete: function(transport){
		calculatefooter();
		refreshlist();
		recalculateamt();
		ColdFusion.Window.hide('changeamt');
        }
      })
	}
	
	
	function updatemember(membernamesearch,membertelsearch,memberadd1search,memberadd2search,memberadd3search,memberidsearch,deliverydate,deliverytime)
	{
    var urlloaditemdetail = '/default/transaction/POS/delprocess.cfm?membernamesearch='+membernamesearch+'&membertelsearch='+membertelsearch+'&memberadd1search='+memberadd1search+'&memberadd2search='+memberadd2search+'&memberadd3search='+memberadd3search+'&memberidsearch='+memberidsearch;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		
        },
        onFailure: function(){ 
		alert('Error Select Member'); },		
		
		onComplete: function(transport){
		document.getElementById('rem6').value=unescape(deliverydate);
		document.getElementById('rem7').value=unescape(deliverytime);
		selectmemberlist(memberidsearch);
		ColdFusion.Window.hide('neweu');
        }
      })
	}
	
		function createmember(membername,membertel,memberadd1,memberadd2,memberadd3,memberid,dob)
	{
		if(memberid == '')
		{
			alert('Member Id is Required');
		}
		else
		{
    var urlloaditemdetail = '/default/transaction/POS/neweuprocess.cfm?membername='+membername+'&membertel='+membertel+'&memberadd1='+memberadd1+'&memberadd2='+memberadd2+'&dob='+dob+'&memberadd3='+memberadd3+'&memberid='+memberid;
	
	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		
        },
        onFailure: function(){ 
		alert('Member Id Already Existed'); },		
		
		onComplete: function(transport){
		myoption = document.createElement("OPTION");
		myoption.text = memberid+" - "+membername;
		myoption.value = memberid;
		document.invoicesheet.driver.options.add(myoption);
		var indexvalue = document.getElementById("driver").length-1;
		document.getElementById("driver").selectedIndex=indexvalue;
		ColdFusion.Window.hide("neweu");
        }
      })
		}
	}
	var opt = 'Width=500px, Height=250px, Top=300px, left=400px, scrollbars=yes, status=no, resizable=1';
	
	function canceltran()
	{
	var answer = confirm('Are you sure to cancel the Order?');
	if(answer)
	{
	window.location.href="index.cfm";
	}
	}
	
	function closetran()
	{
	var answer = confirm('Are you sure to close the Order?');
	if(answer)
	{
	window.close();
	}
	}
	
	
	
	function ctrl1()
	{
	var answer = confirm('Are you sure to hold on the Order?');
	if(answer)
	{
	var onholdurl = '/default/transaction/POS/onholdajax.cfm?uuid='+document.getElementById("uuid").value+'&remark='+document.getElementById("rem9").value;
	ajaxFunction(document.getElementById('onholdajax'),onholdurl);
	
	window.location.href="index.cfm?counter="+document.getElementById("counterinfo").value;
	}
	}
	
	function ctrl7()
	{
	window.open('timemanchine.cfm?uuid='+escape(document.getElementById("uuid").value)+'&counter='+document.getElementById("counterinfo").value, '',opt);
	}
	
    </script>
    
    
</head>
<cfif isdefined('url.uuid')>
<body onLoad="document.getElementById('eulist').focus();">
<script type="text/javascript">

</script>
<cfelse>
<body <!--- onLoad='$("#expressservicelist").select2("open");' --->>
</cfif>

<cfform name="invoicesheet" id="invoicesheet" action="process.cfm" method="post">
<cfoutput>
<input type="hidden" name="main" id="main" value="">
<input type="hidden" name="hidtrancode" id="hidtrancode" value="">
<cfinput type="hidden" name="ptype" id="ptype" ><input type="hidden" name="uuid" id="uuid" value="#uuid#">
<input type="hidden" name="currentrow" id="currentrow" value="">
<input type="hidden" name="itemdesptrancode" id="itemdesptrancode" value="">
<input type="hidden" name="allownegative" id="allownegative" value="0">
<input type="hidden" name="refno2" id="refno2" value="">
<input type="hidden" name="paytype" id="paytype" value="">
  <cfinput type="hidden" name="cash" id="cash" value="0.00">
  <cfinput type="hidden" name="realdeposit" id="realdeposit" value="">
  <cfinput type="hidden" name="credit_card1" id="credit_card1" value="0.00">
  <cfinput type="hidden" name="credit_card2" id="credit_card2" value="0.00">
  <cfinput type="hidden" name="creditcardtype" id="creditcardtype" value="">
  <cfinput type="hidden" name="debit_card" id="debit_card" value="0.00">
  <cfinput type="hidden" name="cheque" id="cheque" value="0.00">
  <cfinput type="hidden" name="voucher" id="voucher" value="0.00">
  <cfinput type="hidden" name="deposit" id="deposit" value="0.00">
  <cfinput type="hidden" name="balance" id="balance" value="0.00">
  <cfinput type="hidden" name="changeamt1" id="changeamt1" value="0.00">
  <cfinput type="hidden" name="cashcamt" id="cashcamt" value="">
  <cfinput type="hidden" name="cctype" id="cctype" value="">
  <cfinput type="hidden" name="cctype2" id="cctype2" value="">
  <cfinput type="hidden" name="checkno" id="checkno" value="">
  <cfinput type="hidden" name="rem7" id="rem7" value="">
  <cfinput type="hidden" name="rem6" id="rem6" value="">
   <cfinput type="hidden" name="realvouchertype" id="realvouchertype" value="">
  <cfinput type="hidden" name="realvoucherno" id="realvoucherno" value="">
<cfset session.formName="transpage">

</cfoutput>

<cfoutput>
<!--- --->
<div id="onholdajax"></div><div id="changedespajax"></div>
<div id="itembal" style="display:none"></div><div id="itemDetail"  style="display:none"></div>
<div id="ajaxfieldgetunitprice"></div>
<div id="updatebodydiscajax"></div>
<!--- --->
<table width="100%" height="100%" >
<tr>
<td width="70%" height="100%">
<table width="100%" height="100%" >
<tr>
<td height="20%">
<table style="background-color:##C6C5CD;" width="100%" height="100%" >
<tr>
<td>
<font style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#"><strong>Date</strong></font><br>
<cfset datenow=now()>
<cfif getGsetup.autonextdate lte timeformat(now(),'HH')>
<cfset datenow=dateadd('d',1,now())>
<cfelse>
<cfset datenow=now()>
</cfif>
<input type="text" name="wos_date" id="wos_date" value="#dateformat(datenow,'DD/MM/YYYY')#" onKeyUp="nextIndex(event,'wos_date','expressservicelist');" readonly />
<cfif getgsetup.comboard eq 'Y'>
<cftry>
<div style="visibility:hidden">
<cfinvoke component="cfc.comboard" method="display" firstline="#getgsetup.displayset1#" secondlineleft="#getgsetup.displayset2#" secondlineright="#getgsetup.displayset3#" comchannel="#getgsetup.comboardport#" returnvariable="test"/></div>
<cfcatch></cfcatch></cftry>
</cfif>
</td>


<!---refno--->
<td style="background-color:##C6C5CD;">
<font style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#"><strong>Refno</strong></font><br>
<cfinput type="hidden" name="tran" id="tran" value="CS">
<input type="hidden" name="custno" id="custno" value="<cfif getgsetup.df_cs_cust eq "">3000/CS1<cfelse>#getgsetup.df_cs_cust#</cfif>">
<cfinput type="text" name="refno" id="refno" required="yes" onKeyUp="nextIndex(event,'refno','wos_date');" value="#nexttranno#" readonly>
<div id="reservedetail" style="display:none">
Name  : <input type="text" name="reservename" id="reservename" value="" maxlength="45"><br>
Phone :<input type="text" name="reservephone" id="reservephone" value="" maxlength="45"><br>
Email&nbsp; :<input type="text" name="reserveemail" id="reserveemail" value="" maxlength="45"></div>
</td>
</tr>

<tr>
<td>
<font style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#"><strong>Member</strong></font><br>
<input type="hidden" name="eulist" id="eulist" value="#driver#" onKeyUp="nextIndex(event,'eulist','expressservicelist');memberdisc();" onBlur="nextIndex(event,'eulist','expressservicelist');memberdisc();" >
<cfquery name="getdriverdef" datasource="#dts#">
   	 select ldriver from gsetup
</cfquery>
        
<cfquery name="geteuqry" datasource="#dts#">
SELECT "Choose an #getdriverdef.ldriver#" as eudesp, "" as DRIVERNO
union all 
SELECT concat(driverno,' - ',name) as eudesp, driverno FROM driver
</cfquery>
<cfselect name="driver" id="driver" query="geteuqry" display="eudesp" value="driverno" onChange="memberdisc()" />&nbsp;&nbsp;
<cfif lcase(hcomid) neq 'tcds_i'><a style="cursor:pointer" onClick="ColdFusion.Window.show('neweu')">New</a></cfif> <input type="hidden" name="driverhid" id="driverhid"> &nbsp;&nbsp;
<br>
<!--- <a style="cursor:pointer" onClick="document.getElementById('main').value='out';ColdFusion.Window.show('searchmember')">Search</a>  
 ---><input type="hidden" name="driverhid" id="driverhid"><div id="memberpointajaxfield"></div>

</td>

<td valign="bottom" <cfif getgsetup.hideagent eq 'Y'>style="visibility:hidden"</cfif>>
	<strong>Sales Person</strong><br>
	<cfif getgsetup.compulsaryagent eq 'Y'><cfselect name="agent" id="agent" query="getagentqry" required="yes" style="font: large bolder; color:##000" display="agentdesp" value="agent" /><cfelse><cfselect name="agent" id="agent" query="getagentqry" style="font: large bolder; color:##000" display="agentdesp" value="agent" /></cfif>
	<cfquery name="getnewtrancode" datasource="#dts#">
		select max(trancode) as newtrancode
		from ictrantemp
		where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
        </cfquery>
        <cfif getnewtrancode.recordcount eq 0>
            <cfset newtrancode=1>
        <cfelse>
            <cfset newtrancode = val(getnewtrancode.newtrancode)+1>
        </cfif>
        <cfquery name="newtranqy" datasource="#dts#">
        SELECT #newtrancode# as trancode
        union
        SELECT trancode FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#"> 
        ORDER BY trancode desc
        </cfquery>
  <cfselect style="display:none" name="nextransac" id="nextransac" query="newtranqy" display="trancode" value="trancode" />
  <input type="checkbox" style="display:none" name="activatebarcode" id="activatebarcode" value="Y" />
  <input type="hidden" name="pagesize" id="pagesize" value="7" />
  <cfinput type="hidden" name="glacc" id="glacc" maxlength="10" size="10" mask="9999/999" />
<input type="hidden" name="costformula" id="costformula" value="" readonly>
<div id="ajaxFieldPro" name="ajaxFieldPro" style="display:none"> </div>
<cfinput type="hidden" name="currcode" id="currcode" size="10"  /><input type="hidden" name="currcodehid" id="currcodehid" value="">&nbsp;<cfinput type="hidden" name="currrate" id="currrate" <!--- bind="cfc:custsupp.getcurrrate('#dts#',{currcode},'#target_currency#')" bindonload="yes" ---> size="5" />
</td>
</tr>
<tr>
<td><strong>Counter/Cashier</strong><br>
<cfset counter = "">
  <cfset cashier = "">
  <cfif isdefined('url.counter')>
  <cfset counter = url.counter>
  </cfif>
  <cfif isdefined('form.counterchoose')>
  <cfset counter = form.counterchoose>
  </cfif>
  <cfif isdefined('form.cashierchoose')>
  <cfset counter = form.cashierchoose>
  </cfif>
  <cfinput type="text" name="counterinfo" id="counterinfo" value="#counter#" style="border:none; background-color:transparent">
  <cfinput type="hidden" name="cashierinfo" id="cashierinfo" value="#cashier#" readonly="">
</td>
<td><strong>Location</strong><br>
<cfquery name="getlocation" datasource="#dts#">
select location from iclocation
</cfquery>
<cfif getgsetup.disablelocation eq "Y">
<input type="text" name="coltype" id="coltype" value="#getgsetup.ddllocation#" readonly onKeyUp="nextIndex(event,'coltype','expressservicelist');">
<cfelse>
<select name="coltype" id="coltype" onKeyUp="nextIndex(event,'coltype','expressservicelist');">
<option value="">Choose A Location</option> 
<cfloop query="getlocation">
<option value="#getlocation.location#" <cfif getgsetup.ddllocation eq getlocation.location>selected</cfif>>#getlocation.location#</option>
</cfloop>
</select>
</cfif>
</td>
</tr>


</table>
</td>
</tr>


<tr height="5%">
<td>
<!--- <cfinclude template="/selectitem/newselect.cfm"> --->
<table width="100%">
<tr>
<td width="40%">
Product        
<cfif getgsetup.hideqty eq 'Y'>
<cfinput type="text" name="expressservicelist" style="font: x-large bolder" id="expressservicelist" size="26"  onKeyUp="nextIndex(event,'expressservicelist','expressservicelist');" />
<cfelse>
<cfinput type="text" name="expressservicelist" style="font: x-large bolder" id="expressservicelist" size="26" onBlur="getitemdetail(this.value);" onKeyUp="nextIndex(event,'expressservicelist','expqty');" />
</cfif> 
<input type="checkbox" name="multiscan" id="multiscan" value="1" onClick="document.getElementById('expressservicelist').focus();"><input type="hidden" name="scancount" id="scancount" value="1">
<!--- <input type="button" id="searchitembtn" style="font: medium bolder" onClick="ColdFusion.Window.show('searchitem');getfocus2();" value="#getpayment.scsearch# Search" align="right" />
 ---></td>
<td width="30%">

<input type="hidden" name="desp2" id="desp2" size="40" onKeyUp="nextIndex(event,'desp','expqty');" >
Qty        <input type="text" style="font: x-large bolder" name="expqty" id="expqty" size="10" maxlength="10" value="1" onKeyUp="calamtadvance();nextIndex(event,'expqty','expprice');<cfif getgsetup.expressdisc neq "1">document.getElementById('expqtycount').value = this.value;</cfif>" >
<input name="btn_add" style="font: medium bolder" id="btn_add" type="button" value="Add" onClick="additembtn();"> 
<input type="hidden" name="expunit" id="expunit"  onKeyUp="nextIndex(event,'expunit','expprice');">
<input type="hidden" name="rem9" id="rem9" value="#rem9#">
</td>
<td width="30%">
<cfif getgsetup.setitemdiscount eq 'Y'>

  
  <cfquery name="getdiscount" datasource="#dts#">
  select * from discount order by discount
  </cfquery>
  <select name="discountbody">
  <option value="0%">Choose a discount</option>
  <cfloop query="getdiscount">
  <option value="#getdiscount.discount#%">#getdiscount.discount#%</option>
  </cfloop>
  </select>&nbsp;&nbsp;&nbsp;<input type="button" name="updatebodydisc" id="updatebodydisc" value="Update" onClick="updatebodydisclist();"></cfif>
</td>
</tr>
</table>

</td>
</tr>

<tr style="display:none">
  <th><font style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">Discount</font></th>
  <td colspan="2">
  <cfif getgsetup.expressdisc eq "1">
  <input type="<cfif getpin2.h1360 eq 'T'>text<cfelse>hidden</cfif>" name="expunitdis1" id="expunitdis1" size="5" value="0" onKeyUp="caldisamt();calamtadvance();nextIndex(event,'expunitdis1','expunitdis2')"  >
%&nbsp;&nbsp;
<input type="<cfif getpin2.h1360 eq 'T' >text<cfelse>hidden</cfif>" name="expunitdis2" id="expunitdis2" size="5" value="0" onKeyUp="caldisamt();calamtadvance();nextIndex(event,'expunitdis2','expunitdis3')" />
%&nbsp;&nbsp;
<input type="<cfif getpin2.h1360 eq 'T'>text<cfelse>hidden</cfif>" name="expunitdis3" id="expunitdis3" size="5" value="0" onKeyUp="caldisamt();calamtadvance();nextIndex(event,'expunitdis3','expdis')" />%
<cfelse>
<input type="hidden" name="expunitdis1" id="expunitdis1" size="5" value="0" />
<input type="hidden" name="expunitdis2" id="expunitdis2" size="5" value="0" />
<input type="hidden" name="expunitdis3" id="expunitdis3" size="5" value="0" />
<input type="<cfif getpin2.h1360 eq 'T'>text<cfelse>hidden</cfif>" name="expqtycount" id="expqtycount" size="3" value="1" onKeyUp="caldisamt();calamtadvance();nextIndex(event,'expqtycount','expunitdis')" >
&nbsp;&nbsp;
<input type="<cfif getpin2.h1360 eq 'T'>text<cfelse>hidden</cfif>" name="expunitdis" id="expunitdis" size="5" value="0.00" onKeyUp="caldisamt();calamtadvance();nextIndex(event,'expdis','btn_add')" />
&nbsp;&nbsp;
</cfif>
<input type="<cfif getpin2.h1360 eq 'T'>text<cfelse>hidden</cfif>" name="expdis" id="expdis" size="10" maxlength="10" value="0.00" onKeyUp="calamtadvance();nextIndex(event,'expdis','btn_add')" onBlur="calamtadvance();"></td>
</tr>
<tr style="display:none">
  <th><font style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">Price</font></th>
  <td colspan="2"><input type="<cfif getpin2.h1360 eq 'T'>text<cfelse>hidden</cfif>" name="expprice" id="expprice" size="15" maxlength="15" value="0.00" onKeyUp="calamtadvance();nextIndex(event,'expprice',<cfif getgsetup.expressdisc eq "1">'expunitdis1'<cfelse>'expqtycount'</cfif>)"  ></td>
</tr>


  
<tr style="display:none">
  <th><font style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#">Amount</font></th>
  <td colspan="3"><input type="<cfif getpin2.h1360 eq 'T'>text<cfelse>hidden</cfif>" name="expressamt" id="expressamt" size="10" value="0.00" readonly >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  </td>
</tr>

<tr height="70%">
<td colspan="4" >
<cfset datashow = "yes">
<cfif getpin2.h1360 neq 'T'>
<cfset datashow = "no">
</cfif>
<div id="itemlist" style="height:90%; overflow:auto; border:1px solid;">
<table width="100%" border="1">
<tr>
<td width="2%" style="height:24">No</td>
<td width="15%">Item</th>
<td width="20%">Desp</th>

<td width="10%">Qty</td>
<td width="8%">Price</td>
<td width="8%">Disc</td>
<td width="8%">Amt</td>
<td width="10%">Action</td>
</tr>

<cfquery name="getictrantemp" datasource="#dts#">
SELECT * FROM ictrantemp WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#"> order by trancode desc
</cfquery>
<cfloop query="getictrantemp">
<tr <cfif (getictrantemp.currentrow mod 2) eq 0>style="background-color:##33FFFF"</cfif> onMouseOut="javascript:this.style.backgroundColor='<cfif (getictrantemp.currentrow mod 2) eq 0>33FFFF</cfif>';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
<td nowrap><font style="font-size:14px">#getictrantemp.currentrow#</font></td>
<td nowrap><font style="font-size:14px">#getictrantemp.itemno#</font></td>

<td nowrap><font style="font-size:14px">#getictrantemp.desp#</font></td>

<td nowrap align="right"><input type="text" name="qtylist#getictrantemp.trancode#" id="qtylist#getictrantemp.trancode#" value="#val(getictrantemp.qty_bil)#" size="5" onBlur="updaterow('#getictrantemp.trancode#');" onKeyup="if(this.value != '#val(getictrantemp.qty_bil)#'){document.getElementById('updatebtn#getictrantemp.trancode#').style.display='block';}else{document.getElementById('updatebtn#getictrantemp.trancode#').style.display='none';}"></td>
<td nowrap align="right"><font style="font-size:14px"><a style="cursor:pointer" onClick="document.getElementById('hidtrancode').value='=0&trancode=#getictrantemp.trancode#&uuid='+document.getElementById('uuid').value;ColdFusion.Window.show('changeprice');">#numberformat(val(getictrantemp.price_bil),',.__')#</a></font></td>

<td nowrap align="right"><input type="text" name="brem4#getictrantemp.trancode#" id="brem4#getictrantemp.trancode#" value="#getictrantemp.brem4#" size="5" onBlur="updaterow('#getictrantemp.trancode#');" onKeyup="if(this.value != '#getictrantemp.brem4#'){document.getElementById('updatebtn#getictrantemp.trancode#').style.display='block';}else{document.getElementById('updatebtn#getictrantemp.trancode#').style.display='none';}"></td>
<td nowrap align="right"><font style="font-size:14px"><a style="cursor:pointer" onClick="document.getElementById('hidtrancode').value='=0&trancode=#getictrantemp.trancode#&uuid='+document.getElementById('uuid').value;ColdFusion.Window.show('changeamt');">#numberformat(val(getictrantemp.amt_bil),',.__')#</a></font></td>
<td nowrap><input type="button" name="deletebtn#getictrantemp.trancode#" id="deletebtn#getictrantemp.trancode#" onClick="if(confirm('Are You Sure You Want To Delete?')){deleterow('#getictrantemp.trancode#')}" value="DELETE"/>&nbsp;<img id="updatebtn#getictrantemp.trancode#" name="updatebtn#getictrantemp.trancode#" src="/images/tick.gif" width="15" height="15" style="cursor:pointer; display:none;"><!--- &nbsp;&nbsp;<input type="button" name="Updatebtn#getictrantemp.trancode#" id="updatebtn#getictrantemp.trancode#" onClick="updaterow('#getictrantemp.trancode#');" value="UPDATE" style="display:none"/> ---></td>
</tr>
</cfloop>
</table>
</div>

</td>
</tr>



</table>
</td>

<td width="30%" height="100%">
<table width="100%" height="100%" >
<div id="checkbelowcostfield"></div>
<tr>
<td colspan="100%" height="25%">
<div style="background:##7F7F7F; color:##FFF; margin-top:30px; height:98%; width:100%;">
<br>
<div align="center"><font size="+3"><strong>Total Pay Amount</strong></font></div>
<br><br>
<div align="right"><cfinput type="button" style="font-size:50px; color:##FFF; background-color:##7F7F7F; height:56; text-align:right;" name="grand2" id="grand2" value="0.00" onClick="calculatefooter();" />&nbsp;&nbsp;</div>
<cfinput type="hidden" style="font: large bolder; color:##000; background-color:##FFFF66;" name="grand" id="grand" value="0.00" onClick="calculatefooter();" />&nbsp;&nbsp;<br>

<input type="hidden" name="rem41" id="rem41" value="">
</div>
</td>
</tr>



<tr>
<td colspan="2" align="right" style="background:##FFF;">
<input type="button" id="searchitembtn" style="font: medium bolder" onClick="ColdFusion.Window.show('findRefno');" value="Search Exchanged Receipt" align="right" />&nbsp;&nbsp;
<input type="button" id="searchitembtn" style="font: medium bolder" onClick="ctrl1();" value="On Hold" align="right" />&nbsp;&nbsp;
<input type="button" id="searchitembtn" style="font: medium bolder" onClick="ctrl7();" value="On Hold Transactions" align="right" />
</tr>

<!--- --->
<tr height="10%">
<td><div id="getqtytotal" style="vertical-align:bottom;height:10%;">
<cfquery name="getsumictrantemp" datasource="#dts#">
SELECT sum(qty_bil)as sumqty FROM ictrantemp WHERE uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#"> order by trancode desc
</cfquery>
<font style="font:'Times New Roman', Times, serif; font-size:#defaultfontsize#"><strong>Total Qty : #getsumictrantemp.sumqty#</strong></font>
</div></td>
</tr>



<cfset inputtype = "text">
<tr height="20%">

<td colspan="10">
<table height="100%" width="100%" >
<tr height="20%">
<td width="100px"><strong>Gross</strong></td>
<td align="right"><cfinput style="text-align:right" size="10" type="text" name="gross" id="gross" readonly="yes" value="0.00"  /></td>
</tr>

<tr  height="20%" <cfif getgsetup.hidetotaldiscount eq 'Y'>style="display:none"</cfif>>
<td>
<strong>Discount</strong>
<br>
 <cfinput type="text" size="3" name="dispec1" id="dispec1" value="0" validate="float" <!--- validateat="onblur" ---> message="Please key in numeric value" onKeyUp="calcdisc();caltax();calcfoot();" />%<input type="hidden" name="disbil1" id="disbil1" />&nbsp;&nbsp;
  <cfinput type="text" size="3" name="dispec2" id="dispec2" value="0" validate="float" <!--- validateat="onblur" ---> message="Please key in numeric value" onKeyUp="calcdisc();caltax();calcfoot();"/>%<input type="hidden" name="disbil2" id="disbil2" />&nbsp;&nbsp;
  <cfinput type="text" size="3" name="dispec3" id="dispec3" value="0" validate="float" <!--- validateat="onblur" ---> message="Please key in numeric value" onKeyUp="calcdisc();caltax();calcfoot();"/>%<input type="hidden" name="disbil3" id="disbil3" />&nbsp;&nbsp;&nbsp;
</td> 
<td align="right"><cfinput style="text-align:right" type="text" size="10" name="disamt_bil" id="disamt_bil" value="0.00" validate="float" <!--- validateat="onblur" ---> message="Please key in numeric value" onKeyUp="caltax();calcfoot();" /></td>
</tr>


<tr>
<td>NET</td>
<td align="right"><cfinput style="text-align:right" size="10" type="text" name="net" id="net" value="0.00" readonly="yes" /></td>
</tr>
<tr>
<td>
<strong>Tax</strong>
<input type="checkbox" name="taxincl" id="taxincl" value="T" onClick="caltax();calcfoot();" <cfif getgsetup.taxincluded eq "Y">checked </cfif> />&nbsp;
  <cfquery name="getTaxCode" datasource="#dts#">
  SELECT "" as code, "" as rate1
  union all
  SELECT code,rate1 FROM #target_taxtable#
  </cfquery>
  <cfquery name="getdf" datasource="#dts#">
        SELECT df_salestax,df_purchasetax,gst FROM gsetup
        </cfquery>
        
        <cfquery name="taxrate" datasource="#dts#">
        SELECT code,rate1 FROM #target_taxtable#       
        WHERE tax_type <> "PT"
        </cfquery>
<select name="taxcode" id="taxcode" onChange="document.getElementById('taxper').value=this.options[this.selectedIndex].id;setTimeout('caltax();calcfoot();',500);">
<cfloop query="taxrate">
<option value="#taxrate.code#" id="#val(taxrate.rate1) * 100#" <cfif taxrate.code eq getdf.df_salestax>Selected</cfif>>#taxrate.code#</option>
</cfloop>
</select>
  
  &nbsp;&nbsp;<cfinput type="text" name="taxper" id="taxper" value="#val(getdf.gst)#" size="8" onKeyUp="caltax();calcfoot();"  />&nbsp;&nbsp;&nbsp;
  
</td>
<td align="right"><cfinput type="text"  style="text-align:right" name="taxamt" id="taxamt" value="0.00" size="10" onKeyUp="calcfoot();" />  </td>
</tr>
<tr>
<td><strong>Misc Charges</strong></td>
<td align="right"><cfinput style="text-align:right" size="10"  type="text" name="M_charge1" id="M_charge1" value="0.00" validate="float" onKeyUp="calcfoot();"/></td>
</tr>
</table>
</td>
</tr>

<tr>
<td colspan="100%" align="center" valign="top" height="50%">
<input name="pay_btn" style="font: large bolder;background-color:##FC3; color:##FFF; height:40; width:200;" id="btn_add" type="button" value="CASH" onClick="document.getElementById('paytype').value='0';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup');getfocus10();" size="15" />

<cfif getpayment.creditcard eq "Y">
&nbsp;&nbsp;&nbsp;<input name="pay_btn" style="font: large bolder;background-color:##C60; color:##FFF; color:##FFF; height:40; width:200;" id="btn_add" type="button" value="CREDIT CARD" onClick="document.getElementById('paytype').value='2';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup2');getfocus12();">
</cfif>
<cfif getpayment.deposit eq "Y">
<br><br><input name="adddeposit" style="font: large bolder;background-color:##6C0; color:##FFF; height:40; width:200;" id="adddeposit" type="button" value="Add Deposit" onClick="window.open('/default/transaction/deposit/Deposittable2.cfm?type=Create&tran=1&sono='+document.getElementById('refno').value,'_blank')"  />
</cfif>
<cfif getpayment.nets eq "Y">
&nbsp;&nbsp;&nbsp;<input name="pay_btn" style="font: large bolder;background-color:##F69; color:##FFF; height:40; width:200;" id="btn_add" type="button" value="NETS" onClick="document.getElementById('paytype').value='1';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup1');getfocus11();" >
</cfif>
<br><br><input name="pay_btn" style="font: large bolder;background-color:##0F0; color:##FFF; height:40; width:200;" id="btn_add" type="button" value="MULTI PAYMENT" onClick="document.getElementById('paytype').value='5';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup5');getfocus15();" size="15" />



<!--- <cfif getpayment.cheque eq "Y">
<input name="pay_btn" style="font: large bolder;background-color:##3C0" id="btn_add" type="button" value="CHEQUE" onClick="document.getElementById('paytype').value='3';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup3');getfocus13();" >&nbsp;&nbsp;&nbsp;
</cfif>
<cfif getpayment.cashcard eq "Y">
<input name="pay_btn" style="font: large bolder; background-color:##C40; color:##0F0" id="btn_add" type="button" value="CASH CARD" onClick="document.getElementById('paytype').value='4';document.getElementById('mod').value='=0&grandtotal='+document.getElementById('grand').value+'&uuid='+document.getElementById('uuid').value;gopay('totalup4');getfocus14();">&nbsp;&nbsp;&nbsp;
</cfif> --->
<!--- <input name="close" style="font: medium bolder;" id="close" type="button" value="CLOSE" onClick="closetran();" size="15" />&nbsp;&nbsp;&nbsp;
<input name="Minimize" style="font: medium bolder;" id="Minimize" type="button" value="Minimize" onClick="window.blur();window.opener.focus();" size="15" />
 --->
<!--- <input name="Others" style="font: large bolder;" id="Others" type="button" value="Others" onClick="ColdFusion.Window.show('otherwindow');" size="15" />
 --->

&nbsp;&nbsp;&nbsp;<input name="cancel" style="font: large bolder;; height:40; width:200; color:##FFF;" id="cancel" type="button" value="CANCEL" onClick="canceltran();" size="15" />

</td>
</tr>
</table>
</td>
</tr>

</table>


</cfoutput>
        <cfoutput>  
<cfinput type="hidden" name="mod" id="mod" value="&uuid=#uuid#">  
<cfinput type="hidden" name="reftype" id="reftype" value="CS">
</cfoutput>
</cfform>


<cfif getdealermenu.itemformat eq '2'>
<cfwindow  width="900" height="800" name="searchitem" refreshOnShow="true" x="100"
    y="100"
  modal="false" title="Search Item" initshow="false"
        source="/default/transaction/POS/searchitem2.cfm?{reftype}&itemno={expressservicelist}" />
<cfelse>
<cfwindow  width="1300" height="800" name="searchitem" refreshOnShow="true"  modal="false"  x="100"
    y="100" title="Search Item" initshow="false"
        source="/default/transaction/POS/searchitem.cfm?{reftype}&itemno={expressservicelist}" />
</cfif>

<cfwindow  width="600" height="500" name="neweu" refreshOnShow="true"  modal="false"  x="100"
    y="100" title="Create New Member" initshow="false"
        source="/default/transaction/POS/neweu.cfm" />
        
<!--- <cfwindow  width="600" height="400" name="changedaddr" refreshOnShow="true"  modal="false" title="Search Address" initshow="false"
        source="/default/transaction/POS/searchaddress.cfm" /> --->
<cfif getgsetup.negstk neq "1">
<cfwindow  width="300" height="300" name="negativestock" refreshOnShow="true"  modal="true" title="Negative Stock" initshow="false"
        source="negativestock.cfm" />
</cfif>

<cfif lcase(hcomid) eq "just_i">
<cfwindow  width="300" height="300" name="negativeqty" refreshOnShow="true"  modal="true" title="Negative Qty" initshow="false"
        source="negativeqty.cfm" />
</cfif>
<cfif getgsetup.ECAMTOTA eq "Y">
<cfwindow  width="300" height="300" name="serviceamount" refreshOnShow="true"  modal="true" title="Service Amount" initshow="false"
        source="serviceamount.cfm" />
</cfif>
<cfif getgsetup.PCBLTC eq "Y">
<cfwindow  width="300" height="300" name="stkcostcontrol" refreshOnShow="true"  modal="true" title="Stock Price Is Lower Than Cost" initshow="false"
        source="stkcostcontrol.cfm" />
</cfif>
<cfwindow width="700" height="550" name="itemdesp" refreshOnShow="true" modal="true" title="Change Item Description" initshow="false" source="itemdesp.cfm?uuid={uuid}&trancode={itemdesptrancode}" /> 

<!--- <cfwindow  width="300" height="300" name="timemanchine" refreshOnShow="true"  modal="true" title="Revert Back To Previous Entry" initshow="false"
        source="timemanchine.cfm?uuid=#uuid#" /> --->

        
<!--- <cfwindow  width="700" height="500" name="itembalance" refreshOnShow="true"  modal="false" title="Location Qty Balance" initshow="false"
        source="/default/transaction/itembal2.cfm?itemno={expressservicelist}&project=&job=&batchcode=" /> --->   
      
<cfwindow  width="700" height="300" minheight="700" minwidth="300" name="totalup" refreshOnShow="true"  modal="true" title="Total" initshow="false" source="total.cfm?{mod}" resizable="false" />   
<cfwindow  width="700" height="250" name="totalup1" refreshOnShow="true"  modal="true" title="Total" initshow="false" source="total1.cfm?{mod}&driverno={driver}" /> 
<cfwindow  width="700" height="250" name="totalup2" refreshOnShow="true"  modal="true" title="Total" initshow="false" source="total2.cfm?{mod}&driverno={driver}" /> 
<cfwindow  width="700" height="250" name="totalup3" refreshOnShow="true"  modal="true" title="Total" initshow="false" source="total3.cfm?{mod}&driverno={driver}" /> 
<cfwindow  width="700" height="250" name="totalup4" refreshOnShow="true"  modal="true" title="Total" initshow="false" source="total4.cfm?{mod}&driverno={driver}" /> 
<cfwindow  width="800" height="600" name="totalup5" refreshOnShow="true"  modal="true" title="Total" initshow="false" source="total5.cfm?{mod}&driverno={driver}" />  
<cfwindow  width="700" height="600" name="totalup6" refreshOnShow="true"  modal="true" title="Save as Invoice" initshow="false" source="total6.cfm?{mod}" /> 
<cfwindow  width="700" height="600" name="totalup7" refreshOnShow="true"  modal="true" title="Save as Sales Order" initshow="false" source="total7.cfm?{mod}" /> 
 
<cfwindow  width="500" height="700" name="changeprice" refreshOnShow="true"  modal="true" title="Edit Price" initshow="false" source="changeprice.cfm?{hidtrancode}" />  
<cfwindow  width="500" height="700" name="changeqty" refreshOnShow="true"  modal="true" title="Edit Qty" initshow="false" source="changeqty.cfm?{hidtrancode}" />  
<cfwindow  width="500" height="700" name="changediscount" refreshOnShow="true"  modal="true" title="Edit Discount" initshow="false" source="changediscount.cfm?{hidtrancode}" />  
<cfwindow  width="500" height="700" name="changeamt" refreshOnShow="true"  modal="true" title="Edit Amount" initshow="false" source="changeamt.cfm?{hidtrancode}" />  
<cfwindow  width="800" height="550" name="searchmember" refreshOnShow="true"  modal="true" title="Search Member" initshow="false" source="searchmember.cfm?{main}" />  

<cfwindow  width="800" height="550" name="belowcostpassword" refreshOnShow="true"  modal="true" title="Below Cost Password" initshow="false" source="belowcostpasswordcontrol.cfm" />  
<cfwindow  width="800" height="550" name="otherwindow" refreshOnShow="true"  modal="true" title="Others" initshow="false" source="otherwindow.cfm" />  

<cfwindow  width="800" height="800" name="printreceipt" refreshOnShow="true"  modal="true" title="Print Receipt" initshow="false" source="printreceiptrefno.cfm" /> 

<cfwindow  width="900" height="800" name="findRefno" refreshOnShow="true" x="100"
    y="100"
  modal="false" title="Search Receipt" initshow="false"
        source="/default/transaction/POS/findrefno.cfm?type=CS" />

<cfwindow  width="350" height="260" name="chooseagent" refreshOnShow="true"  modal="true" title="Choose Agent" initshow="false" source="chooseagent.cfm" />

<cfwindow  width="800" height="800" name="deleterefno" refreshOnShow="true"  modal="true" title="Delete Cash SAles" initshow="false" source="deleteRefno.cfm" /> 

 <cfif isdefined('url.uuid')>
 <script type="text/javascript">
 recalculateamt();
 setTimeout('caltax();calcfoot();','1000');
 </script>
 </cfif>
 <cfif isdefined('url.first')>
 <cfif getgsetup.disablecounter eq 'Cashier'>
 <cfwindow  width="350" height="260" name="choosecashier" refreshOnShow="true"  modal="true" title="Choose Cashier" initshow="true" source="choosecashier.cfm" />
 <cfwindow  width="350" height="260" name="choosecounter" refreshOnShow="true"  modal="true" title="Choose Counter" initshow="false" source="choosecounter.cfm" />
 <cfelseif getgsetup.disablecounter eq 'Disable'>
 <cfwindow  width="350" height="260" name="choosecashier" refreshOnShow="true"  modal="true" title="Choose Cashier" initshow="false" source="choosecashier.cfm" />
 <cfwindow  width="350" height="260" name="choosecounter" refreshOnShow="true"  modal="true" title="Choose Counter" initshow="false" source="choosecounter.cfm" />
 <cfelse>
 <cfif getgsetup.compulsarycounter eq 'Y'>
 <cfwindow  width="350" height="260" name="choosecounter" resizable="false" refreshOnShow="true"  modal="true" title="Choose Counter" initshow="true" source="choosecounter.cfm" />
 <cfelse>
 <cfwindow  width="350" height="260" name="choosecounter" refreshOnShow="true"  modal="true" title="Choose Counter" initshow="true" source="choosecounter.cfm" />
 </cfif>
 </cfif>
 </cfif>
 <div id="changepriceajax">
 </div>
 

<script type="text/javascript">
<cfif isdefined('url.first') eq false>
setTimeout("document.getElementById('<cfif isdefined('url.uuid')>eulist<cfelse>expressservicelist</cfif>').focus();",500);
</cfif>
var selectoption = document.getElementById('taxcode');
document.getElementById('taxper').value=selectoption.options[selectoption.selectedIndex].id;
</script>

