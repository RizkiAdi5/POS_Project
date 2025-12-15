<!---
Add New Bill Type Follow As Below:
1)Set bill = add Code and Name
2)Set ajax (functions/copyf.cfm)
--->
	<cfparam name="invType" default="">
	<cfparam name="billnoList" default="">
	<cfset bill = "RC,Receive,PR,Purchase Return,DO,Delivery Order,INV,Invoice,CN,Credit Note,CS,Cash Sales,DN,Debit Note,"
				& "ISS,Issue,TR,Transfer,PO,Purchase Order,SO,Sales Order,QUO,Quotation,SAM,Sample">
				
	<!---cfquery name="getGSetup" datasource="#dts#">
	SELECT invno,invno_2,invno_3,invno_4,invno_5,invno_6,invoneset FROM gsetup
	</cfquery--->

    <cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear,filterall from gsetup
</cfquery>
	<cfquery name="getGSetup" datasource="#dts#">
		SELECT invno,invno_2,invno_3,invno_4,invno_5,invno_6,
    	invoneset,rc_oneset,pr_oneset,do_oneset,cs_oneset,cn_oneset,dn_oneset,iss_oneset,
		po_oneset,so_oneset,quo_oneset,assm_oneset,tr_oneset,oai_oneset,oar_oneset,sam_oneset  
    	FROM gsetup
	</cfquery>
	
	<!---cfoutput query="getGSetup">
		<cfset invType=listappend(invType,"invno,Set 1 - #invno#")>
		<cfif invno_2 neq "">
			<cfset invType=listappend(invType,",invno_2,Set 2 - #invno_2#")>
		</cfif>
		<cfif invno_3 neq "">
			<cfset invType=listappend(invType,",invno_3,Set 3 - #invno_3#")>
		</cfif>
		<cfif invno_4 neq "">
			<cfset invType=listappend(invType,",invno_4,Set 4 - #invno_4#")>
		</cfif>
		<cfif invno_5 neq "">
			<cfset invType=listappend(invType,",invno_5,Set 5 - #invno_5#")>
		</cfif>
		<cfif invno_6 neq "">
			<cfset invType=listappend(invType,",invno_6,Set 6 - #invno_6#")>
		</cfif>
	</cfoutput--->
	
	<cfinvoke component="CFC.Period" method="getCurrentPeriod" dts="#dts#" returnvariable="cfcPeriod"/>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
	<link href="../../scripts/CalendarControl.css" rel="stylesheet" type="text/css">
</head>

<script type='text/javascript' src='../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../ajax/core/settings.js'></script>
<script src="../../scripts/CalendarControl.js" language="javascript"></script>

<script language="javascript">
<!---cfoutput query="getGSetup">var oneInv=#getGSetup.invoneset#;</cfoutput--->
<cfoutput query="getGSetup">
	var oneInv=#getGSetup.invoneset#;
	var oneRc=#getGSetup.rc_oneset#;
	var onePr=#getGSetup.pr_oneset#;
	var oneDo=#getGSetup.do_oneset#;
	var oneCs=#getGSetup.cs_oneset#;
	var oneCn=#getGSetup.cn_oneset#;
	var oneDn=#getGSetup.dn_oneset#;
	var oneIss=#getGSetup.iss_oneset#;
	var onePo=#getGSetup.po_oneset#;
	var oneSo=#getGSetup.so_oneset#;
	var oneQuo=#getGSetup.quo_oneset#;
	var oneAssm=#getGSetup.assm_oneset#;
	var oneTr=#getGSetup.tr_oneset#;
	var oneOai=#getGSetup.oai_oneset#;
	var oneOar=#getGSetup.oar_oneset#;
	var oneSam=#getGSetup.sam_oneset#;
</cfoutput>
<!--- (1) Refno Refresh Start --->
function getRefno(inputRefno,invDbField,invStatus){
	DWREngine._execute(_copyflocation, null, 'refnolookup', inputRefno, invDbField, invStatus, getRefnoResult);
}
function getRefnoResult(refnoArray){
	DWRUtil.removeAllOptions("ff_refnofrom");
	DWRUtil.removeAllOptions("ff_refnoto");
	DWRUtil.addOptions("ff_refnofrom", refnoArray,"KEY", "VALUE");
	DWRUtil.addOptions("ff_refnoto", refnoArray,"KEY", "VALUE");
}
<!--- (1) Refno Refresh End --->
<!--- (3) Customer/Supplier Refresh Start --->
function getCustomer(type){
	if(type !=""){
		if(type=="RC" || type=="PR" || type=="PO"){
			document.getElementById("L1").innerHTML="Supp.No. From";
			document.getElementById("L2").innerHTML="Supp.No. To";
			DWREngine._execute(_copyflocation, null, 'customerlookup', "SUPP", getCustomerResult);
		}else{
			document.getElementById("L1").innerHTML="Cust.No. From";
			document.getElementById("L2").innerHTML="Cust.No. To";
			DWREngine._execute(_copyflocation, null, 'customerlookup', "CUST", getCustomerResult);
		}
	}
}
function getCustomerResult(customerArray){
	DWRUtil.removeAllOptions("ft_nofrom");
	DWRUtil.removeAllOptions("ft_noto");
	DWRUtil.addOptions("ft_nofrom", customerArray,"KEY", "VALUE");
	DWRUtil.addOptions("ft_noto", customerArray,"KEY", "VALUE");
}
<!--- (3) Customer/Supplier Refresh End --->
<!--- (2) Copy TO (Refno No From) Start --->
//function getLastNum(type){getArunStatus(type);}

function getLastNum(type){getArunStatus(type,'1');}

<!--- Check Tran Type Running Refno Status Start --->
//function getArunStatus(type){
	//if(type=="INV" && oneInv!="1"){
		//DWREngine._execute(_copyflocation, null, 'arunlookup', type, document.copy1.ft_invtype.value, getARunResult);
	//}else if(type!=""){
		//DWREngine._execute(_copyflocation, null, 'arunlookup', type, oneInv, getARunResult);
	//}
//}

function getArunStatus(type,count){
	if(type == 'INV'){
		var typeoneset = oneInv;
	}else if(type == 'RC'){
		var typeoneset = oneRc;
	}else if(type == 'PR'){
		var typeoneset = onePr;
	}else if(type == 'DO'){
		var typeoneset = oneDo;
	}else if(type == 'CS'){
		var typeoneset = oneCs;
	}else if(type == 'CN'){
		var typeoneset = oneCn;
	}else if(type == 'DN'){
		var typeoneset = oneDn;
	}else if(type == 'ISS'){
		var typeoneset = oneIss;
	}else if(type == 'PO'){
		var typeoneset = onePo;
	}else if(type == 'SO'){
		var typeoneset = oneSo;
	}else if(type == 'QUO'){
		var typeoneset = oneQuo;
	}else if(type == 'ASSM'){
		var typeoneset = oneAssm;
	}else if(type == 'TR'){
		var typeoneset = oneTr;
	}else if(type == 'OAI'){
		var typeoneset = oneOai;
	}else if(type == 'OAR'){
		var typeoneset = oneOar;
	}else if(type == 'SAM'){
		var typeoneset = oneSam;
	}
	if(typeoneset !="1"){
		DWREngine._execute(_copyflocation, null, 'arunlookup', type, count, getARunResult);
	}else if(type!=""){
		DWREngine._execute(_copyflocation, null, 'arunlookup', type, '1', getARunResult);
	}
}

//function getARunResult(arunObject){
	//if(arunObject.ARUNSTATUS=="1"){
		//if(arunObject.TYPE=="INV" && oneInv!="1"){
			//DWREngine._execute(_copyflocation, null, 'lastNumlookup', arunObject.ONEINV, getLastNumResult);
		//}else{
			//DWREngine._execute(_copyflocation, null, 'lastNumlookup', arunObject.TYPE, getLastNumResult);
		//}
		//document.getElementById("ft_refnofrom").readOnly=true;
		//document.getElementById("ft_refnofrom").style.backgroundColor="#FFFF99";
	//}else if(arunObject.ARUNSTATUS=="0"){
		//document.getElementById("ft_refnofrom").value="";
		//document.getElementById("ft_refnofrom").readOnly=false;
		//document.getElementById("ft_refnofrom").style.backgroundColor="";
	//}
//}

function getARunResult(arunObject){
	if(arunObject.ARUNSTATUS=="1"){
		if(arunObject.TYPE == 'INV'){
			var typeoneset = oneInv;
		}else if(arunObject.TYPE == 'RC'){
			var typeoneset = oneRc;
		}else if(arunObject.TYPE == 'PR'){
			var typeoneset = onePr;
		}else if(arunObject.TYPE == 'DO'){
			var typeoneset = oneDo;
		}else if(arunObject.TYPE == 'CS'){
			var typeoneset = oneCs;
		}else if(arunObject.TYPE == 'CN'){
			var typeoneset = oneCn;
		}else if(arunObject.TYPE == 'DN'){
			var typeoneset = oneDn;
		}else if(arunObject.TYPE == 'ISS'){
			var typeoneset = oneIss;
		}else if(arunObject.TYPE == 'PO'){
			var typeoneset = onePo;
		}else if(arunObject.TYPE == 'SO'){
			var typeoneset = oneSo;
		}else if(arunObject.TYPE == 'QUO'){
			var typeoneset = oneQuo;
		}else if(arunObject.TYPE == 'ASSM'){
			var typeoneset = oneAssm;
		}else if(arunObject.TYPE == 'TR'){
			var typeoneset = oneTr;
		}else if(arunObject.TYPE == 'OAI'){
			var typeoneset = oneOai;
		}else if(arunObject.TYPE == 'OAR'){
			var typeoneset = oneOar;
		}else if(arunObject.TYPE == 'SAM'){
			var typeoneset = oneSam;
		}
		if(typeoneset !="1"){
			DWREngine._execute(_copyflocation, null, 'lastNumlookup', arunObject.TYPE, arunObject.COUNTER, getLastNumResult);
		}else{
			DWREngine._execute(_copyflocation, null, 'lastNumlookup', arunObject.TYPE, arunObject.COUNTER, getLastNumResult);
		}
		document.getElementById("ft_refnofrom").readOnly=true;
		document.getElementById("ft_refnofrom").style.backgroundColor="#FFFF99";
	}else if(arunObject.ARUNSTATUS=="0"){
		document.getElementById("ft_refnofrom").value="";
		document.getElementById("ft_refnofrom").readOnly=false;
		document.getElementById("ft_refnofrom").style.backgroundColor="";
		document.getElementById("ft_actualrefno").value="";
	}
}

<!--- Check Tran Type Running Refno Status End --->
function getLastNumResult(numObject){
	DWRUtil.setValue("ft_refnofrom", numObject.LASTNUM);
	DWRUtil.setValue("ft_actualrefno", numObject.ACTUALNO);
}
<!--- (2) Copy TO (Refno No From) End --->
<!--- Multiple Inv changes event Start --->
function getRefnoRefresh(){getRefno("INV",document.copy1.ff_invtype.value,oneInv);}

//function getRefnoFtRefresh(){getArunStatus("INV");}

function getRefnoFtRefresh(){
	var type = document.copy1.ft_type.value;
	var count = document.copy1.ft_invtype.value;
	document.copy1.counter.value = document.copy1.ft_invtype.value;
	getArunStatus(type,count);
}

<!--- Multiple Inv changes event End --->
function checkExist(id){
	var type=document.copy1.ft.value;
	if(type!=""){
		DWREngine._execute(_copyflocation, null,'checkRefnolookup',type,document.getElementById("ft_refnofrom").value,id,checkRefnoResult);
	}
}
function checkRefnoResult(statusObject){
	if(statusObject.EXIST=="yes"){
		alert("This Refno have been used. Please try others.");
		document.getElementById(statusObject.ID).value="";
	}
}
function init(){
	DWRUtil.useLoadingMessage();
	DWREngine._errorHandler =  errorHandler;
	change('invf','none');
	change('invt','none');
	refresh_from();
	refresh_to();
}
function refresh_from(){
	var value_f =document.copy1.ff.value;
	getRefno(value_f,"invno",oneInv);
	changeType("ff_type",value_f);//multiple inv
	usrCtrl();
}
function refresh_to(){
	var value_t = document.copy1.ft.value;
	getCustomer(value_t);
	changeType("ft_type",value_t);//multiple inv
	changeSize(value_t);
	getLastNum(value_t);
}
//function changeType(ID,VALUE){//for multiple inv
	//document.getElementById(ID).value = VALUE;

	//if(oneInv==0){
		//if(VALUE.match("INV")=="INV"){
			//if(ID.match("ft")=="ft"){change('invt','block');}
			//else{change('invf','block');}
		//}else{
			//if(ID.match("ft")=="ft"){change('invt','none');}
			//else{change('invf','none');}
		//}
	//}
//}

function changeType(ID,VALUE){//for multiple inv
	document.getElementById(ID).value = VALUE;
	if(ID == 'ft_type'){
		if(VALUE == 'INV'){
			var typeoneset = oneInv;
		}else if(VALUE == 'RC'){
			var typeoneset = oneRc;
		}else if(VALUE == 'PR'){
			var typeoneset = onePr;
		}else if(VALUE == 'DO'){
			var typeoneset = oneDo;
		}else if(VALUE == 'CS'){
			var typeoneset = oneCs;
		}else if(VALUE == 'CN'){
			var typeoneset = oneCn;
		}else if(VALUE == 'DN'){
			var typeoneset = oneDn;
		}else if(VALUE == 'ISS'){
			var typeoneset = oneIss;
		}else if(VALUE == 'PO'){
			var typeoneset = onePo;
		}else if(VALUE == 'SO'){
			var typeoneset = oneSo;
		}else if(VALUE == 'QUO'){
			var typeoneset = oneQuo;
		}else if(VALUE == 'ASSM'){
			var typeoneset = oneAssm;
		}else if(VALUE == 'TR'){
			var typeoneset = oneTr;
		}else if(VALUE == 'OAI'){
			var typeoneset = oneOai;
		}else if(VALUE == 'OAR'){
			var typeoneset = oneOar;
		}else if(VALUE == 'SAM'){
			var typeoneset = oneSam;
		}
		
		if(typeoneset == 0){
			DWREngine._execute(_copyflocation, null, 'refnosetlookup', typeoneset, VALUE, getRefnosetResult);
		}else{
			change('invt','none');
		}
	}
}

function getRefnosetResult(a){
	change('invt','block');
	DWRUtil.removeAllOptions("ft_invtype");
	DWRUtil.addOptions("ft_invtype", a,"KEY", "VALUE");
}

function usrCtrl(){
	var getR_f=document.copy1.ff_refnofrom.value;
	var getR_t=document.copy1.ff_refnoto.value;
	var getC_f=document.copy1.ft_nofrom;
	var getC_t=document.copy1.ft_noto;
	getC_f.disabled=false;
	getC_t.disabled=false;
	
	if(getR_f !="" && getR_t !=""){
		if(getR_f != getR_t){
			getC_f.disabled=true;
			getC_t.disabled=true;
		}
	}
}
function changeSize(TYPE){
	var from = document.copy1.ft_refnofrom;
	var to = document.copy1.ft_refnoto;
	if(TYPE == "SO" || TYPE == "PO" || TYPE == "QUO"){
		from.size="25";
		from.maxLength="25";
		to.size="25";
		to.maxLength="25";
		to.value="zzzzzzzzzzzzzzzzzzzzzzzz";
	}else{
		from.size="9";
		from.maxLength="20";
		to.size="9";
		to.maxLength="20";
		to.value="zzzzzzzz";
	}
}
function checkLen(){
	var TYPE = document.copy1.ft.value;
	if (TYPE != ""){
		var data = document.copy1.ft_refnofrom.value;
		len = data.length;
		
		if(TYPE == "SO" || TYPE == "PO" || TYPE == "QUO"){
			if(len > 23){
				alert("Max Value : 24");
				data = data.slice(0,24);
				document.copy1.ft_refnofrom.value = data;
				return false;
			}
		}else{
			if(len > 19){
				alert("Max Value : 8");
				data = data.slice(0,20);
				document.copy1.ft_refnofrom.value = data;
				return false;
			}
		}
	}
	return true;
}
function validation(){
	//bill selection
	var temp1 = document.copy1.ff;
	var temp2 = document.copy1.ft;
	//refno no. (from)
	var temp3 = document.copy1.ff_refnofrom;
	var temp4 = document.copy1.ff_refnoto;
	//refno no. (to)
	var temp5 = document.copy1.ft_refnofrom;
	//customer/supplier
	var temp6 = document.copy1.ft_nofrom;
	var temp7 = document.copy1.ft_noto;
	var temp8 = document.copy1.f_cdate;

	if(temp1.value==""){
		alert("Please select one.");
		temp1.focus();
		return false;
	}else if(temp2.value == ""){
		alert("Please select one.");
		temp2.focus();
		return false;
	}else if(temp3.value.match("--")){
		alert("Please select one.");
		temp3.focus();
		return false;
	}else if(temp4.value.match("--")){
		alert("Please select one.");
		temp4.focus();
		return false;
	}else if(temp5.value == ""){
		alert("Please fill in.");
		temp5.focus();
		return false;
	}else if(temp5.value=="EMPTY" || temp5.value=="ERROR"){
		alert("ERROR: Please check the last used ref.no number.");
		temp5.focus();
		return false;
	}
	if(!temp6.disabled){
		if(temp6.value.match("-")){
		alert("Please fill in.");
		temp6.focus();
		return false;
		}else if(temp7.value.match("-")){
		alert("Please fill in.");
		temp7.focus();
		return false;
		}
	}
	if(temp8.value == ""){
		alert("Please fill in.");
		temp8.focus();
		return false;
	}
	if(temp1.value=="INV"){
		if(document.copy1.ff_invtype.value=="-"){
		alert("Please fill in.");
		document.copy1.ff_invtype.focus();
		return false;
		}
	}if(temp2.value=="INV"){
		if(document.copy1.ft_invtype.value=="-"){
		alert("Please fill in.");
		document.copy1.ft_invtype.focus();
		return false;
		}
	}
	return true;
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


// begin: customer search
function getCust(type,option){
	if(type == 'ft_nofrom'){
		var inputtext = document.copy1.searchcustfr.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getCustResult);
		
	}
	else{
		var inputtext = document.copy1.searchcustto.value;
		DWREngine._execute(_reportflocation, null, 'supplierlookup', inputtext, option, getCustResult2);
	}
}

function getCustResult(custArray){
	DWRUtil.removeAllOptions("ft_nofrom");
	DWRUtil.addOptions("ft_nofrom", custArray,"KEY", "VALUE");
}

function getCustResult2(custArray){
	DWRUtil.removeAllOptions("ft_noto");
	DWRUtil.addOptions("ft_noto", custArray,"KEY", "VALUE");
}
// end: customer search

</script>

<body onLoad="init()">
	<h1 align="center">Copy Bills</h1>
	<cfoutput>
	<form name="copy1" action="copyprocess.cfm" method="post" onSubmit="return validation();">
	<input type="hidden" id="counter" name="counter" value="1">
	<table width="70%" border="0" cellspacing="0" cellpadding="2" class="data" align="center">
	<cfif isdefined("url.errorMessage")>
	<tr><td colspan="4"><h3><cfoutput>#url.errorMessage#</cfoutput></h3>Click <a href="copy.cfm">here</a> to refresh.</td></tr>
	<tr><td colspan="4"><hr></td></tr>
	</cfif>
	<tr>
		<td colspan="2" align="right" width="50%">
		<fieldset style="border:1px ridge ##ff00ff; padding: 0.5em;">
		<legend style="color: ##ff0000;">From</legend>
			<select id="ff" name="ff" size="#listlen(bill)/2#" onChange="refresh_from()">
			<cfloop from="1" to="#listlen(bill)#" index="i" step="+2"><option value="#listgetat(bill,i)#">#listgetat(bill,i+1)#</option>
			</cfloop>
			</select>
		</fieldset>
		</td>
		<td colspan="2" width="50%">
		<fieldset style="border:1px ridge ##ff00ff; padding: 0.5em;">
		<legend style="color: ##ff0000;">To</legend>
			<select name="ft" size="#listlen(bill)/2#" onChange="refresh_to()">
			<cfloop from="1" to="#listlen(bill)#" index="i" step="+2"><option value="#listgetat(bill,i)#">#listgetat(bill,i+1)#</option>
			</cfloop>
			</select>
		</fieldset>
		</td>
	</tr>
	<tr><td colspan="4"><hr></td></tr>
	<tr><td colspan="4"><b>From</b></td></tr>
	<tr>
		<td width="20%">Type</td>
		<td colspan="3"><input style="background-color:##FFFF99" id="ff_type" type="text" name="ff_type" size="3" readonly="yes">&nbsp;
		<div id="invf">
		<select id="ff_invtype" name="ff_invtype" onChange="getRefnoRefresh()">
		<cfloop from="1" to="#listlen(invtype)#" index="i" step="+2"><option value="#listgetat(invtype,i)#">#listgetat(invtype,i+1)#</option>
		</cfloop>
		</select>
		</div>
		</td>
	</tr>
	<tr>
		<td>Ref.No. From</td>
		<td colspan="3">
			<select id="ff_refnofrom" name="ff_refnofrom" onChange="usrCtrl()">
			<option value="--">Please Select One</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>Ref.No. To</td>
		<td colspan="3">
			<select id="ff_refnoto" name="ff_refnoto" onChange="usrCtrl()">
			<option value="--">Please Select One</option>
			</select>
		</td>
	</tr>
	<tr><td colspan="4"><hr></td></tr>
	<tr><td colspan="4"><b>To</b></td></tr>
	<tr>
		<td>Type</td>
		<td colspan="3">
			<input style="background-color:##FFFF99" id="ft_type" type="text" name="ft_type" size="3" readonly="yes">
			&nbsp;
			<div id="invt">
			<select id="ft_invtype" name="ft_invtype" onChange="getRefnoFtRefresh()">
			
			</select>
			</div>
		</td>
	</tr>
	<tr>
		<td>Ref.No. From</td>
		<td colspan="3">
			<input id="ft_refnofrom" type="text" name="ft_refnofrom" size="9" onKeyUp="checkExist(this.id);">
			<input id="ft_actualrefno" type="hidden" name="ft_actualrefno">
		</td> 
	</tr>
	<tr>
		<td>Ref.No. To</td>
		<td colspan="3">
			<input style="background-color:##FFFF99" type="text" name="ft_refnoto" value="zzzzzzzz" size="9" readonly="yes">
		</td>
	</tr>
	<tr><td colspan="4"><hr></td></tr>
	<tr>
		<td><label id="L1" >Cust.No. From</label></td>
		<td colspan="3">
			<select id="ft_nofrom" name="ft_nofrom">
			<option value="-">Please Select One</option>
			</select>
			<cfif getgeneral.filterall eq "1">
				<input type="text" name="searchcustfr" id="searchcustfr" onKeyUp="getCust('ft_nofrom','Customer');">
			</cfif>
		</td>
	</tr>
	<tr>
		<td><label id="L2" >Cust.No. To</label></td>
		<td colspan="3">
			<select id="ft_noto" name="ft_noto">
			<option value="-">Please Select One</option>
			</select>
			<cfif getgeneral.filterall eq "1">
				<input type="text" name="searchcustto" id="searchcustto" onKeyUp="getCust('ft_noto','Customer');">
			</cfif>
		</td>
	</tr>
	<tr>
		<td>Date</td>
		<td colspan="3"><input style="background-color:##FFFF99" type="text" name="f_cdate" size="10" value="#dateformat(now(),"dd/mm/yyyy")#" maxlength="10"> 
		<img src="../../images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(f_cdate);">(DD/MM/YYYY)
		</td>
	</tr>
	<tr>
		<td>Period</td>
		<td colspan="3"><input style="background-color:##FFFF99" type="text" name="f_period" size="2" value="#cfcPeriod#" readonly></td>
	</tr>
	<tr><td colspan="4"><hr></td></tr>
	<tr>
		<td></td>
		<td colspan="3" align="right">
		<input type="submit" name="submit" value="Submit">
		</td>
	</tr>
	</table>
	</form>
	</cfoutput>
</body>
</html>