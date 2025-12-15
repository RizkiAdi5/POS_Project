<cfset tran = "cs">
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

<cfquery name="getsalesperson" datasource="#dts#">
            SELECT agent, desp
            FROM icagent
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
SELECT * FROM gsetup
</cfquery>

<cfquery name="getitem" datasource="#dts#">
	SELECT itemno,photo
    FROM icitem;
</cfquery>

<cfquery name="getcate" datasource="#dts#">
	SELECT cate
    FROM iccate;
</cfquery>

<cfquery name="getnum" datasource="#dts#">
	SELECT COUNT(*) AS numItems
    FROM icitem;
</cfquery>

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

<cfset datenow=now()>
<cfif getGsetup.autonextdate lte timeformat(now(),'HH')>
<cfset datenow=dateadd('d',1,now())>
<cfelse>
<cfset datenow= DateFormat(Now(),"dd/mm/yyyy")>
</cfif>

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
	cfset nexttranno = "">
    <cfset tranarun_1 = "0">
</cfif>
<cfset nexttranno = tostring(nexttranno)>

<cfquery name="geteuqry" datasource="#dts#">
SELECT "Choose a Member" as eudesp, "" as driverno
union all
SELECT concat(driverno,' - ',name) as eudesp, driverno FROM driver
</cfquery>

<cfquery name="getlocation" datasource="#dts#">
select location from iclocation
</cfquery>

<!doctype html>
<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="-1">
	<meta http-equiv="pragma" content="no-cache">
    <title>Simple Interface</title>
    	<script type="text/javascript" src="/scripts/prototypenew.js" ></script>
    	<script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
        <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
        <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
        <link rel="stylesheet" type="text/css" href="../newpos/Interface.css" />
        <script type="text/javascript" src="../newpos/Interface.js"></script>
        <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
       <!--- <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>--->
        <script type="text/javascript" src="/latest/js/bootstrap-datepicker/bootstrap-datepicker.js"></script>

        <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap-datepicker/datepicker3.css">
        <style type="text/css">
        body {
	background-color: #FCF8F8;
}
        </style>
        <!---<link rel="stylesheet" href="/latest/css/select2/select2.css" />--->


</head>



<script type="text/javascript">
 window.onload = function () {
        if(document.getElementById('cashierinfo').value=='')
		{
			$.ajax({
							type:"POST",
							url:"/newpos/choosecashier.cfm",
							data: {},
							dataType:"html",
							cache:false,
							success: function(result){
							$('#fade').modal('show');
							$('#cPrice').html(result);
							},
							error: function(jqXHR,textStatus,errorThrown){
							},
							complete: function(){
							}
  						});
		}
        };

		function checkpassword()
	{
	if(document.getElementById('cashierlist').value == '' || document.getElementById('cashierpasswordhash').value == '')
	{
	alert("Pls Key in cashier and password");
	}
	else
	{
	if(document.getElementById('cashierpasswordhash').value == document.getElementById('hidcashierpassword').value)
    {
    	document.getElementById('cashierinfo').value=document.getElementById('cashierlist').value;
        $('#fade').modal('hide');
        document.getElementById('itemno').focus();

    }
    else
    {
    alert("Wrong cashier or password");
    }
	};
	}

	<cfoutput>
		function getItem2(){	
		var itemno=document.getElementById('searchitem').value;
		var category = document.getElementById('searchcate').value;
		$.ajax({
			type:"POST",
			url:"Interface1.cfm",
			data: {"itemno":itemno,"category":category},
			dataType:"html",
			cache:false,
			success: function(result){
			$('##itemlist').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){
			}
  		});	
	}

	<!---function getfocus4()
	{

	setTimeout("document.getElementById('price_bil1').select();",500);

	}--->

	<!---$(document).ready(function() {
			$("#allItem").select2({ width: '80%' });
});--->
	function addItemAdvance(itemno)
	{
	var expressservice=itemno;//itemno
	var tran = trim(document.getElementById('tran').value);//"hidden"
	var custno = trim(document.getElementById('custno').value);//hidden
	var refno = document.getElementById('refno').value;//refno
	var trancode = trim(document.getElementById('nextransac').value);//hidden
	var brem1 = document.getElementById('coltype').value;//location
	var driver = document.getElementById('driver').value;//member
	var ajaxurl = 'addproductsAjax.cfm?servicecode='+escape(expressservice)+'&tran='+escape(tran)+'&tranno='+refno+'&uuid=#URLEncodedFormat(uuid)#&custno='+escape(custno)+'&trancode='+escape(trancode)+'&brem1='+escape(brem1)+'&driver='+escape(driver);

	 new Ajax.Request(ajaxurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){
		<!---alert("#words[2090]#"); --->
		},

		onComplete: function(transport){
		<!---clearformadvance();--->
		calculatefooter();
		refreshlist();
        }
      })
		<!---
		 ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);
	clearformadvance();
	setTimeout('calculatefooter();',750);
	setTimeout('refreshlist();',750);--->

	}

	function refreshlist()
	{
	ajaxFunction(document.getElementById('itemlists'),'getBody.cfm?uuid=#URLEncodedFormat(uuid)#');
	ajaxFunction(document.getElementById('getqtytotal'),'getqtytotal.cfm?uuid=#URLEncodedFormat(uuid)#');
	}
	</cfoutput>

	function trim(strval)
	{
	return strval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
	}

	function addOption(selectbox,text,value )
	{
	var optn = document.createElement("OPTION");
	optn.text = text;
	optn.value = value;
	selectbox.options.add(optn);
	}

	function calculatefooter()
	{
	document.getElementById('gross').value = (document.getElementById('hidsubtotal').value*1).toFixed(2);
	<cfif getgsetup.wpitemtax eq "1">
	document.getElementById('taxamt').value = (document.getElementById('hidtaxtotal').value*1).toFixed(2);
	</cfif>
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

	function recalculateamt()
	{
	var ajaxurl = '/newpos/recalculateAjax.cfm?uuid=<cfoutput>#URLEncodedFormat(uuid)#</cfoutput>';
	new Ajax.Request(ajaxurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){
		alert("Error Update Item"); },

		onComplete: function(transport){
		calculatefooter();
        }
      })
	}

	function calcfoot()
	{
	var gross = document.getElementById('gross').value * 1;
	var disamt = document.getElementById('disamt_bil').value * 1;
	var net = document.getElementById('net');
	var taxamt = document.getElementById('taxamt').value * 1;
	var M_charge1 = document.getElementById('M_charge1').value * 1;
	var grand = document.getElementById('grand');
	var grand2 = document.getElementById('grand2');
	net.value = (gross-disamt).toFixed(2);

	<cfif getgsetup.wpitemtax eq "1">
	<!---Per Item Tax--->
	<cfif getgsetup.taxincluded eq "Y">
	var netb = ((net.value * 1) +(M_charge1 * 1));
	grand.value = netb.toFixed(2);
	grand2.value = netb.toFixed(2);
	<cfelse>
	var netb = ((net.value * 1) + (taxamt * 1)+(M_charge1 * 1));
	grand.value = netb.toFixed(2);
	grand2.value = netb.toFixed(2);
	</cfif>
	<cfelse>
	var taxincl = document.getElementById('taxincl').checked;
	<!---Per Bill Tax--->
	if(taxincl == true)
	{
	grand.value = ((net.value * 1)+(M_charge1 * 1)).toFixed(2);
	<cfif lcase(hcomid) eq 'tcds_i'>
	grand2.value = ((Math.ceil(((net.value * 1)+(M_charge1 * 1)).toFixed(2)* 2*10)/10).toFixed(1))
	grand2.value = (grand2.value/2).toFixed(2);
	grand2.value= grand2;
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
	grand2.value= grand2;
	<cfelse>
	grand2.value = netb.toFixed(2);
	</cfif>
	}
	</cfif>
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

	function caltax()
	{
	<cfif getgsetup.wpitemtax eq "1">
	<cfelse>
	var net = document.getElementById('net').value;
	var taxincl = document.getElementById('taxincl').checked;
	var taxper = document.getElementById('taxper').value;
	var taxamt = document.getElementById('taxamt');
	var grand = document.getElementById('grand');
	var grand2 = document.getElementById('grand2');
	var taxval = 0;
	var gross = document.getElementById('gross').value * 1;
	var disamt = document.getElementById('disamt_bil').value * 1;
	net = (gross-disamt).toFixed(2);
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
	grand2.value= grand2;
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
	grand2.value = net.toFixed(2);

	<cfelse>
	grand2.value = netb.toFixed(2);
	</cfif>

	}
	</cfif>
	}

	function changeprice(trancode, price_bil, btnname){
		<cfoutput>var uuid = "#URLEncodedFormat(uuid)#";</cfoutput>
		<!---ajaxFunction(document.getElementById('cPrice'),'changeprice.cfm?abc='+trancode);--->
		$.ajax({
			type:"POST",
			url:"/newpos/changeprice.cfm",
			data: {"trancode":trancode,"uuid":uuid,"price_bil":price_bil,"btnname":btnname},
			dataType:"html",
			cache:false,
			success: function(result){
			$('#cPrice').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){
			}
  		});
	}

	function changeqty(trancode, qty_bil, btnname){
		<cfoutput>var uuid = "#URLEncodedFormat(uuid)#";</cfoutput>

		$.ajax({
			type:"POST",
			url:"/newpos/changeqty.cfm",
			data: {"trancode":trancode,"uuid":uuid,"qty_bil":qty_bil,"btnname":btnname},
			dataType:"html",
			cache:false,
			success: function(result){
			$('#cPrice').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){
			}
  		});
	}

	function changediscount(trancode, disamt_bil, btnname){
		<cfoutput>var uuid = "#URLEncodedFormat(uuid)#";</cfoutput>

		$.ajax({
			type:"POST",
			url:"/newpos/changediscount.cfm",
			data: {"trancode":trancode,"uuid":uuid,"disamt_bil":disamt_bil,"btnname":btnname},
			dataType:"html",
			cache:false,
			success: function(result){
			$('#cPrice').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){
			}
  		});
	}

	function changeamt(trancode, amt_bil, btnname){
		<cfoutput>var uuid = "#URLEncodedFormat(uuid)#";</cfoutput>

		$.ajax({
			type:"POST",
			url:"/newpos/changeamt.cfm",
			data: {"trancode":trancode,"uuid":uuid,"amt_bil":amt_bil,"btnname":btnname},
			dataType:"html",
			cache:false,
			success: function(result){
			$('#cPrice').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){
			}
  		});
	}


function updateprice(uuid,trancode,price)
	{
	if((price*1)<(document.getElementById('minimumprice2').value*1))
	{
		alert("Price should not lower than minimum price: "+document.getElementById('minimumprice2').value);
	}
	else if((price*1)<(document.getElementById('sellingbelowcost').value*1))
	{
		$.ajax({
			type:"POST",
			url:"/newpos/belowcostpasswordcontrol.cfm",
			data: {},
			dataType:"html",
			cache:false,
			success: function(result){
			$('#cPrice').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){
			}
  		});
	}
	else
	{
    $.ajax({
			type:"POST",
			url:"/newpos/updateprice.cfm",
			data: {"trancode":trancode,"uuid":uuid,"price":price},
			dataType:"html",
			cache:false,
			success: function(result){
			//$('#ajaxFieldPro').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			alert("Error Update Price");
			},
			complete: function(){
			alert('Price update successfully!!');
			$('#fade').modal('hide');
			calculatefooter();
			refreshlist();
			recalculateamt();
			}
  		});
	}
	}

	function updateqty(uuid,trancode,qty)
	{
    $.ajax({
			type:"POST",
			url:"/newpos/updateqty.cfm",
			data: {"trancode":trancode,"uuid":uuid,"qty":qty},
			dataType:"html",
			cache:false,
			success: function(result){
			},
			error: function(jqXHR,textStatus,errorThrown){
			alert("Error Update Qty");
			},
			complete: function(){
			alert('Qty update successfully!!');
			$('#fade').modal('hide');
			calculatefooter();
			refreshlist();
			recalculateamt();
			}
  		});
	}

	function updatediscount(uuid,trancode,discount,disp1,disp2,disp3)
	{
    var urlloaditemdetail = '/newpos/changediscountprocess.cfm?trancode='+trancode+'&uuid='+uuid+'&disamt_bil1='+discount+'&disp1='+disp1+'&disp2='+disp2+'&disp3='+disp3;

	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){

        },
        onFailure: function(){
		alert("Error update discount!!"); },

		onComplete: function(transport){
		alert('Discount update successfully!!');
		$('#fade').modal('hide');
		calculatefooter();
		refreshlist();
		recalculateamt();
        }
      })
	}

	function updateamt(uuid,trancode,amt)
	{
    var urlloaditemdetail = '/newpos/updateamt.cfm?trancode='+trancode+'&uuid='+uuid+'&amt='+amt;

	  new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){

        },
        onFailure: function(){
		alert("Error update amount!!"); },

		onComplete: function(transport){
		alert('Amount update successfully!!');
		$('#fade').modal('hide');
		calculatefooter();
		refreshlist();
		recalculateamt();
        }
      })
	}

	function getDiscount(amt_bil)
	{
	var subtotal= amt_bil;
	var d1=document.getElementById("disp1").value;
	var d2=document.getElementById("disp2").value;
	var d3=document.getElementById("disp3").value;
	var ttld=document.getElementById("disamt_bil1").value;
	var totaldiscount=0;
	var temp=0;
	if((parseFloat(d1)+parseFloat(d2)+parseFloat(d3))!=0)
	{
		temp=(subtotal*d1/100).toFixed(2);
		totaldiscount=temp;
		temp=(subtotal-totaldiscount).toFixed(2);
		temp=(temp*d2/100).toFixed(2);
		totaldiscount=(parseFloat(totaldiscount)+parseFloat(temp)).toFixed(2);
		temp=(subtotal-totaldiscount).toFixed(2);
		temp=(temp*d3/100).toFixed(2);
		totaldiscount=(parseFloat(totaldiscount)+parseFloat(temp)).toFixed(2);

	}
	else
	{
		totaldiscount=0;
	}
	document.getElementById("disamt_bil1").value=totaldiscount;
	}


	function deleterow(rowno)
	{
		<cfoutput>
		var uuid = "#URLEncodedFormat(uuid)#";
		</cfoutput>
		var updateurl = 'deleterow.cfm?uuid='+uuid+'&trancode='+rowno;
		new Ajax.Request(updateurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){
		alert("Error Delete row!!"); },
		onComplete: function(transport){
		alert('Delete successfully!!');
		calculatefooter();
		refreshlist();
        }
      })

	}

	<!---function doSomethingWithSelectedText() {
    var selectedText = getSelectedText();
    if (selectedText) {
        document.getElementById('changehighlight').value='1'
    }
	else{document.getElementById('changehighlight').value='0'}
	}--->

	function gopay(payname,grandtotal, btnname)
	{

			if ((payname =='totalup6' || payname =='totalup7') && document.getElementById('rem9').value=='')
			{
			alert("Please Key in Remark.");
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
							$.ajax({
							type:"POST",
							url:"/newpos/" + payname + ".cfm",
							data: {"grandtotal":grandtotal,"btnname":btnname},
							dataType:"html",
							cache:false,
							success: function(result){
							$('#fade').modal('show');
							$('#cPrice').html(result);
							},
							error: function(jqXHR,textStatus,errorThrown){
								alert('Error paytype');
							},
							complete: function(){
							}
  						});
					}
			}
	}

	function canceltran()
	{

	var answer = confirm("Are you sure to cancel the Order?");

	if(answer)
	{
	window.location.href="Interface.cfm"+"?counter="+document.getElementById("counterinfo").value+"&cashier="+document.getElementById("cashierinfo").value;
	}
	}


	function ctrl7()
	{
		var uuid= document.getElementById("uuid").value;
		var counter= document.getElementById("counterinfo").value;
		var cashier= document.getElementById("cashierinfo").value;
		if(counter== null){
			counter="";
			}
		$.ajax({
			type:"POST",
			url:"/newpos/timemanchine.cfm",
			data: {"uuid":uuid,"counter":counter,"cashier":cashier},
			dataType:"html",
			cache:false,
			success: function(result){
				$('#fade').modal('show');
				$('#cPrice').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			alert("Error On Hold Transaction");
			},
			complete: function(){
			}
  		});

	}


	function ctrl1()
	{
	var answer = confirm("Are you sure to hold on the Order?");
	if(answer)
	{
	var onholdurl = '/newpos/onholdajax.cfm?uuid='+document.getElementById("uuid").value+'&cashier='+document.getElementById("cashierinfo").value;
	ajaxFunction(document.getElementById('onholdajax'),onholdurl);

	window.location.href="Interface.cfm?counter="+document.getElementById("counterinfo").value+'&cashier='+document.getElementById("cashierinfo").value;
	}
	}

	function revertback()
	{
	var answer = confirm("Are you sure you want to proceed revert?");
	if(answer)
	{
	var newuuid = document.getElementById('oldlist').value;
	window.location.href="Interface.cfm?uuid="+newuuid+"&counter="+document.getElementById("counterinfo").value+"&cashier="+document.getElementById("cashierinfo").value;
	}
	}

	function submitpay()
	{
		<cfif getgsetup.disablecounter eq 'Cashier'>

		var paytypeno = document.getElementById('paytype').value;

		if(document.getElementById('cashierinfo').value=='')
		{
			$.ajax({
							type:"POST",
							url:"/newpos/choosecashier.cfm",
							data: {},
							dataType:"html",
							cache:false,
							success: function(result){
							$('#fade').modal('show');
							$('#cPrice').html(result);
							},
							error: function(jqXHR,textStatus,errorThrown){
							},
							complete: function(){

							}
  						});
		}
		else
		{
		document.getElementById('sub_btn').disabled=true;
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
			for (i = 1; i < 6; i++) {
				if (document.getElementById('cctype15'+i).checked ==true) {
					document.getElementById('cctype').value=document.getElementById('cctype15'+i).value;
				}
			}

			for (i = 1; i < 6; i++) {
				if (document.getElementById('cctype25'+i).checked==true) {
					document.getElementById('cctype2').value=document.getElementById('cctype25'+i).value;
				}
			}
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
		document.invoicesheet.cash.value = (cashamt*1)-parseFloat(document.getElementById('change'+paytypeno).value);
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
		document.invoicesheet.submit();
		}

		<cfelseif getgsetup.compulsaryagent eq 'Y'>
		if(document.getElementById('agent').value=='')
		{
			$.ajax({
							type:"POST",
							url:"/newpos/chooseagent.cfm",
							data: {},
							dataType:"html",
							cache:false,
							success: function(result){
							$('#fade').modal('show');
							$('#cPrice').html(result);
							},
							error: function(jqXHR,textStatus,errorThrown){
							},
							complete: function(){
								document.getElementById('agent').focus();
							}
  						});
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
			for (i = 1; i < 6; i++) {
				if (document.getElementById('cctype15'+i).checked ==true) {
					document.getElementById('cctype').value=document.getElementById('cctype15'+i).value;
				}
			}

			for (i = 1; i < 6; i++) {
				if (document.getElementById('cctype25'+i).checked==true) {
					document.getElementById('cctype2').value=document.getElementById('cctype25'+i).value;
				}
			}
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
		document.invoicesheet.cash.value = (cashamt*1)-parseFloat(document.getElementById('change'+paytypeno).value);
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
			//document.getElementById('cctype').value=getCheckedValue(document.getElementById('cctype15'));
			//document.getElementById('cctype2').value=getCheckedValue(document.getElementById('cctype25'));

			for (i = 1; i < 6; i++) {
				if (document.getElementById('cctype15'+i).checked ==true) {
					document.getElementById('cctype').value=document.getElementById('cctype15'+i).value;
				}
			}

			for (i = 1; i < 6; i++) {
				if (document.getElementById('cctype25'+i).checked==true) {
					document.getElementById('cctype2').value=document.getElementById('cctype25'+i).value;
				}
			}
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
		document.invoicesheet.cash.value = (cashamt*1)-parseFloat(document.getElementById('change'+paytypeno).value);
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
		document.invoicesheet.submit();

		</cfif>
	}

	function calculatetotal(e,nextflow,upflow)
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
if(document.getElementById('change5').value*1 < 0){alert("Payment is not Enough.");return false;}
else if(((document.getElementById('voucheramt5').value*1)+(document.getElementById('cc15').value*1)+(document.getElementById('cc25').value*1)+(document.getElementById('cheq5').value*1)+(document.getElementById('dbc5').value*1)+(document.getElementById('depositamt5').value*1)) >document.getElementById('hidgt5').value*1 && document.getElementById('change5').value*1 !=0){alert("Voucher+Credit Card+Deposit+Net is Over Amount");return false;}
else if(document.getElementById('cheq5').value*1 >document.getElementById('accumpoints').value*1){alert("Points is Over.");return false;}
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

	function calculatetotal2()
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



	function findRefno(type)
	{
	$.ajax({
			type:"POST",
			url:"/newpos/findrefno.cfm",
			data: {"type":type},
			dataType:"html",
			cache:false,
			success: function(result){
				$('#fade').modal('show');
				$('#cPrice').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			alert("Error find receipt");
			},
			complete: function(){
			}
  		});
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

	var ajaxurl = '/newpos/exchangereceiptAjax.cfm?exchangerefno='+escape(exchangerefno)+'&uuid=#URLEncodedFormat(uuid)#'+'&driver='+escape(driver)+'&rem9='+escape(rem9)+'&tran='+escape(tran)+'&tranno='+refno+'&custno='+escape(custno);
	document.getElementById('rem41').value=exchangerefno;

	 new Ajax.Request(ajaxurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){
		alert("Error Add Item"); },

		onComplete: function(transport){
			$('##fade').modal('hide');
		<!---clearformadvance();--->
		refreshlist();
		calculatefooter();

        }
      })
	</cfoutput>
	}

</script>
<body>
<cfform name="invoicesheet" id="invoicesheet" action="process.cfm" method="post">
<cfoutput>
<cfset counter = "">
  <cfset cashier = "">
  <cfif isdefined('url.counter')>
  <cfset counter = url.counter>
  </cfif>

  <cfif isdefined('url.cashier')>
  <cfset cashier = url.cashier>
  </cfif>

  <cfif isdefined('form.counterchoose')>
  <cfset counter = form.counterchoose>
  </cfif>
  <cfif isdefined('form.cashierchoose')>
  <cfset cashier = form.cashierchoose>
  </cfif>
  <cfinput type="hidden" name="counterinfo" id="counterinfo" value="#counter#" style="border:none; background-color:transparent">
  <cfinput type="hidden" name="cashierinfo" id="cashierinfo" value="#cashier#" readonly="" style="border:none; background-color:transparent">
<div id="ajaxFieldPro" name="ajaxFieldPro" style="display:none"></div>
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
  <input type="hidden" name="tran" id="tran" value="CS">
  <input type="hidden" name="custno" id="custno" value="<cfif getgsetup.df_cs_cust eq "">3000/CS1<cfelse>#getgsetup.df_cs_cust#</cfif>">
  <input type="hidden" name="paytype" id="paytype" value="">
  <input type="hidden" name="uuid" id="uuid" value="#uuid#">
  <input type="hidden" name="rem9" id="rem9" value="#rem9#">
  <input type="hidden" style="font: large bolder; color:##000; " name="grand" id="grand" value="0.00" />
  <input type="hidden" name="main" id="main" value="">
<input type="hidden" name="hidtrancode" id="hidtrancode" value="">
<cfinput type="hidden" name="ptype" id="ptype" >
<input type="hidden" name="currentrow" id="currentrow" value="">
<input type="hidden" name="itemdesptrancode" id="itemdesptrancode" value="">
<input type="hidden" name="allownegative" id="allownegative" value="0">
<input type="hidden" name="refno2" id="refno2" value="">
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
  <cfinput type="hidden" name="currcode" id="currcode" size="10"  />
  <input type="hidden" name="currcodehid" id="currcodehid" value="">
  <cfinput type="hidden" name="currrate" id="currrate"  size="5" />
  <input type="hidden" name="rem41" id="rem41" value="">
  <div style="display:none"><input type="checkbox" name="reservebtn" id="reservebtn" value="1" onClick="if(document.getElementById('reservebtn').checked==true){document.getElementById('reservedetail').style.display='inline'}else{document.getElementById('reservedetail').style.display='none'}">Reserve</div>
 <cfset session.formName="transpage">
    <div id="container">
        <div class="col-sm-4" id="left">
            <div class="row">
                <div class="table-group">
            		<div class="row no-pad">
                 	<div class="col-sm-8">
							<input type="text" placeholder="Search Item..." id="searchitem" onBlur="getItem2();" class="form-control" />       
                     </div>  
                     <div class="col-sm-4">    
 							<select class="form-control" name="searchcate" id="searchcate" onChange="getItem2();" >
								<option value="">Search Category...</option> 
							<cfloop query="getcate">
								<option value="#getcate.cate#">#getcate.cate#</option>
							</cfloop>
							</select> 
                     </div>               
            	 </div>      
                </div>
            </div>
			<div class="row" >
            	<div id="itemlist" class="table-group" >
					<cfset k=0>
					<table class="table">
						<tbody >
        				<cfloop  query="getitem">
        				<cfif k eq 0>
  							<tr>
						<cfelseif k eq 4>
 							</tr>
        				<cfset k = 0>
        				</cfif>
                            <td style="width:25%; height:25%; text-align:center"><img onclick="addItemAdvance('#evaluate('getitem.itemno[#getitem.currentrow#]')#')" src="/images/#dts#/#evaluate('getitem.photo[#getitem.currentrow#]')#" width="100px" height="100px" alt="No picture is uploaded"/></td>
        				<cfset k = k+1>
        				</cfloop>
						</tbody>
					</table>
                </div>
			</div>
			<div class="row">
							<button class="bn btn-success" type="button" onClick="ctrl1();">On Hold</button>
			</div>
            <div class="row">
							<button class="bn btn-primary" type="button" onClick="ctrl7();">On Hold Transaction</button>
			</div>
		</div>
        <div class="col-sm-8" id="right">
    		<div class="row">
            	<div class="fdate col-sm-8" style="border: 1px solid black;">
					<div class="col-sm-4" >
							<div class="form-group">
								<label for="dateLabel" class=" control-label">Date:</label>
                                    <div class="input-group date">
                                        <input class="form-control input-sm" type="text" id="wos_date" name="wos_date" value="#datenow#" />
                                        <span class="input-group-addon min-padding calender-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
							</div>
							<div class="form-group">
								<label for="member">Member:</label>
                                <cfselect name="driver" id="driver" class="form-control" query="geteuqry" display="eudesp" value="driverno"/>
							</div>
					</div>
					<div class="col-sm-8" >
							<div class="form-group">
								<label for="refno" class="control-label">Ref No:</label>
                                <div class="row no-pad">
                                	<div class="col-sm-6" id="refnofield">
										<input class="form-control" type="text" id="refno" name="refno" required="yes" value="#nexttranno#" />
                                    </div>
                                    <div class="col-sm-6" id="location">
                                    	<cfif getgsetup.disablelocation eq "Y">
										<input type="text" class="form-control" name="coltype" id="coltype" value="#getgsetup.ddllocation#" readonly />
										<cfelse>
										<select class="form-control" name="coltype" id="coltype">
										<option value="">Location Test</option>
										<cfloop query="getlocation">
										<option value="#getlocation.location#" <cfif getgsetup.ddllocation eq getlocation.location>selected</cfif>>#getlocation.location#</option>
										</cfloop>
										</select>
										</cfif>
                                    </div>
								</div>
							</div>
							<div class="form-group">
								<label for="saleperson" >Sales Person:</label>
                                <div class="row no-pad">
                                	<div class="col-sm-12">
                                		<select name="agent" id="agent" class="form-control">
											<option value="">Choose a sales person</option>
											<cfloop query="getsalesperson">
											<option value="#getsalesperson.agent#">#getsalesperson.agent# - #getsalesperson.desp#</option>
											</cfloop>
										</select>
                                	</div>
                                </div>
							</div>
					</div>
           		</div>
                <div class="col-sm-4" id="totalpayAmt">
					<div class="form-group pull-right" >
						<label for="total" id="payAmt" class="col-sm-12 ">Total Pay Amount</label>
                        <input type="button" name="grand2" id="grand2" value="0.00" onClick="calculatefooter();" class="col-sm-12 " />
					</div>
           		</div>
            </div>
			<div class="row">
            	<div class="spacing col-sm-8" >
					<div class="col-sm-4" >
							<div class="form-group">
								<label for="gross">Gross</label>
								<input class="form-control" type="text" id="gross" name="gross" value="0.00"/>
							</div>
							<div class="form-group">
								<label for="net">Net</label>
								<input type="text" class="form-control" name="net" id="net" placeholder="0.00" value="">
							</div>
					</div>
					<div class="col-sm-8" >
							<div class="form-group">
								<div class="row no-pad">
									<div class="col-sm-8" id="disctext">
										<label for="disc" class="control-label">Disc</label>
										<div class="row no-pad">
											<div class="col-sm-8" id="disctext">
												<div class="row no-pad">
													<div class="col-sm-4" id="disc1text">
													<input class="col-sm-3 form-control" type="text" id="dispec1" name="dispec1"  placeholder="%" value="" onKeyUp="calcdisc();caltax();calcfoot();" /><input type="hidden" name="disbil1" id="disbil1"/>
													</div>
													<div class="col-sm-4" id="disc2text">
														<input type="text" class="col-sm-3 form-control" id="dispec2" name="dispec2" placeholder="%" value="" onKeyUp="calcdisc();caltax();calcfoot();" /><input type="hidden" name="disbil2" id="disbil2" />
													</div>
													<div class="col-sm-4" id="disc3text">
														<input class="col-sm-3 form-control" type="text" id="dispec3" name="dispec3" placeholder="%" value="" onKeyUp="calcdisc();caltax();calcfoot();" /><input type="hidden" name="disbil3" id="disbil3" />
													</div>
												</div>
											</div>
											<div class="col-sm-4" id="disc4text">
												<input type="text" class="col-sm-3 form-control" id="disamt_bil" name="disamt_bil" value="0.00"/>
											</div>
										</div>
									</div>
									<div class="col-sm-4" id="misctext">
										<label for="misc">Misc Charges</label>
										<input type="text" class="form-control" id="M_charge1" name="M_charge1" value="0.00" validate="float" onKeyUp="calcfoot();"/>
									</div>
								</div>
							</div>
                            <div class="form-group">
								<label for="tax" class="control-label">Tax</label>
								<div class="row no-pad">
											<div class="col-sm-8" id="checkboxtext">
                                            <cfif lcase(hcomid) eq "tcds_i">
                                            	<div class="col-sm-12" id="checkboxtext">
													<input type="checkbox" name="taxinclitem" id="taxinclitem" value="T" onClick="taxincludeditemfunc();" />
                                                </div>
											</cfif>
												<div class="row no-pad">
                                                <!---Not Per Item Tax--->
													<cfif getgsetup.wpitemtax neq "1">
														<div class="col-sm-2" id="checkboxtext">
															<input type="checkbox" name="taxincl" id="taxincl" value="T" onClick="caltax();calcfoot();" <cfif getgsetup.taxincluded eq "Y">checked </cfif> />
														</div>
														<div class="col-sm-5" id="taxcode">
															<select name="taxcode" class="form-control" id="taxcodediv" onChange="document.getElementById('taxper').value=this.options[this.selectedIndex].id;setTimeout('caltax();calcfoot();',500);">
															<cfloop query="taxrate">
															<option value="#taxrate.code#" id="#val(taxrate.rate1) * 100#" <cfif taxrate.code eq getdf.df_salestax>Selected</cfif>>#taxrate.code#</option>
															</cfloop>
															</select>
														</div>
														<div class="col-sm-5" id="taxperdiv">
															<cfinput type="text" class="form-control" name="taxper" id="taxper" value="#val(getdf.gst)#" size="8" onKeyUp="caltax();calcfoot();"  />
														</div>
													<cfelse>
													<input type="hidden" name="taxcode" id="taxcode" value="">
													<input type="hidden" name="taxper" id="taxper" value="0">
                                                    </cfif>
												</div>
											</div>
											<div class="col-sm-4" id="disc4text">
												<input class="form-control" type="text" id="taxamt" name="taxamt" value="0.00"/>
											</div>
								</div>
							</div>
				</div>
           		</div>
                <div class="col-sm-4">
				  <div class="form-group col-sm-5 col-sm-offset-7 pull-right" id="getqtytotal">
						<label for="totalitem" id="ttlItem">Total Item:</label>
						<label for="totalitemamonut" id="ttlItmAmt">0</label>
				  </div>
				  <button class="search btn btn-default pull-right" type="button" onClick="findRefno('CS');">Search Exchange Receipt</button>
           		</div>
            </div>

            <div class="row">
               <div class="table-group" id="itemlists">
					<table class="table" >
						<thead>
							<tr>
								<th>No.</th>
								<th>Item Code</th>
								<th>Artist</th>
								<th>Description</th>
								<th>QTY</th>
								<th>Price</th>
								<th>Discount</th>
								<th>Amount</th>
                                <th style="text-align:center">Action</th>
							</tr>
						</thead>
						<tbody>
							<tr height="330px">
								<td><label for="no" id="no" class="col-sm-12 "></label></td>
								<td><label for="itemCode" id="itemCode" class="col-sm-12 "></label></td>
								<td><label for="artist" id="artist" class="col-sm-12 "></label></td>
								<td><label for="desp" id="desp" class="col-sm-12 "></label></td>
								<td><label for="qty" id="qty" class="col-sm-12 "></label></td>
								<td><label for="price" id="price" class="col-sm-12 "></label></td>
								<td><label for="disc" id="disc" class="col-sm-12 "></label></td>
								<td><label for="amt" id="amt" class="col-sm-12 "></label></td>
                                <td><label for="action" id="action" class="col-sm-12 "></label></td>
							</tr>
						</tbody>
					</table>
				</div>
            </div>
            <div class="row">
            	<div class="row no-pad">
					<div class="col-sm-4" id="btn1text">
						<button id="btn1" class="bttn"  type="button" onClick="document.getElementById('paytype').value='0'; gopay('total',document.getElementById('grand').value,'paycash0') ">Cash</button>
					</div>
					<div class="col-sm-4" id="btn2text">
						<button class="bttn" id="btn2" type="button" onClick="document.getElementById('paytype').value='2'; gopay('total2',document.getElementById('grand').value, 'cc12')">Credit Card</button>
					</div>
                    <div class="col-sm-4" id="btn3text">
						<button class="bttn"  id="btn3" type="button" onClick="document.getElementById('paytype').value='1'; gopay('total1',document.getElementById('grand').value, 'dbc1')">Nets</button>
					</div>
				</div>
                 <div class="row no-pad">
					<div class="col-sm-4" id="btn4text">
							<button class="bttn" id="btn4" type="button" onClick="document.getElementById('paytype').value='5'; gopay('total5',document.getElementById('grand').value, 'depositamt5')">Multi Payment</button>
					</div>
					<div class="col-sm-4" id="btn5text">
						<button class="bttn" id="btn5" type="button" onClick="canceltran()">Cancel</button>
					</div>
                    <div class="col-sm-4" id="btn6text">
						<button class="bttn" id="btn6" type="button" onClick="window.close();" >Close Window</button>
					</div>
				</div>
			</div>
		</div>
    </div>
    <div id="window">
    	<div class="modal fade change"  id="fade" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        	<div class="modal-dialog modal-4g">
            	<div class="modal-admin">
                	<div id = "cPrice">
                    </div>
				</div>
			</div>
		</div>
    </div>
    </cfoutput>
    </cfform>
     <cfif isdefined('url.uuid')>
 <script type="text/javascript">
 refreshlist();
 recalculateamt();
 setTimeout('caltax();calcfoot();','1000');
 </script>
 </cfif>
</body>

</html>

