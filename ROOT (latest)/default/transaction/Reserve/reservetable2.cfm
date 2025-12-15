<html>
<head>
	<title>Maintenance Reserve</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
    <script type='text/javascript' src='/ajax/core/engine.js'></script>
	<script type='text/javascript' src='/ajax/core/util.js'></script>
	<script type='text/javascript' src='/ajax/core/settings.js'></script>
    <script type='text/javascript' src='/ajax/core/shortcut.js'></script>
    <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
    <link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>
    <script type="text/javascript" src="/scripts/prototypenew.js" ></script>

<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>

<cfquery name="getlocation" datasource="#dts#">
select * from iclocation
</cfquery>

<script type="text/javascript">

	function nextIndex(e,thisid,id)
	{
		if(e.keyCode==13){
		document.getElementById(''+id+'').focus();
		}
	}

	function getitemdetail(detailitemno)
	{
	if(detailitemno.indexOf('*') != -1)
	{
	var thisitemno = detailitemno.split('*');
	document.getElementById('itemno').value=thisitemno[1];
	document.getElementById('qty_bil').value=thisitemno[0];
	detailitemno=thisitemno[1];
	}
	if(trim(document.getElementById('itemno').value) != "")
	{
    var urlloaditemdetail = 'addItemAjax.cfm?itemno='+escape(encodeURI(detailitemno));
	<!---alert('1');
	ajaxFunction(document.getElementById('itemDetailfield'),urlloaditemdetail);
	alert('2');--->
	 new Ajax.Request(urlloaditemdetail,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('itemDetailfield').innerHTML = trim(getdetailback.responseText);
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
	
	function updaterow(rowno)
	{
		var varcoltype = 'coltypelist'+rowno;
		var varqtylist = 'qtylist'+rowno;
		var reserveno = document.getElementById('reserveno').value;
		var coltypedata = document.getElementById(varcoltype).value;
		var qtylistdata = document.getElementById(varqtylist).value;
		var updateurl = 'updaterow.cfm?reserveno='+escape(reserveno)+'&coltype='+escape(coltypedata)+'&qty='+escape(qtylistdata)+'&trancode='+rowno;
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
	
	function addmultiitem()
	{
	var itemlisting=document.getElementById('pickitemuuid').value;
	<cfoutput>

	var reserveno = trim(document.getElementById('reserveno').value);
	
	var ajaxurl2 = '/default/transaction/reserve/addmultiproductsAjax.cfm?reserveno='+escape(reserveno)+'&itemlisting='+escape(itemlisting);
	<!---ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl2);--->
	
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
		refreshlist();
		
        }
      })
	
	</cfoutput>
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
	
	
	function deleterow(rowno)
	{

		var reserveno = document.getElementById('reserveno').value;

		var updateurl = 'deleterow.cfm?reserveno='+escape(reserveno)+'&trancode='+rowno;
		<!---ajaxFunction(document.getElementById('ajaxFieldPro'),updateurl);--->
		new Ajax.Request(updateurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Delete Item'); },		
		
		onComplete: function(transport){
		document.getElementById('grossamt').value=document.getElementById('hidsubtotal').value;
		refreshlist();
        }
      })
		
	}
	
	var opt = 'Width=500px, Height=250px, Top=300px, left=400px, scrollbars=yes, status=no, resizable=1';
	
	var t1;
	var t2;

	function getfocus()
	{	
	t1 = setTimeout("document.getElementById('custno1').focus();",750);
	}
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

	setTimeout("document.getElementById('price_bil1').focus();",1000);

	}
	
	function getfocus5()
	{

	setTimeout("selectcopy();",2000);

	}
		
	function updateVal()
	{
	var validdesp = unescape(document.getElementById('desphid').value);
	
	if (validdesp == "itemisnoexisted")
	{
	document.getElementById('btn_add').value = "Item No Existed";
	document.getElementById('btn_add').disabled = true; 
	alert('Item Not Found');
	}
	else
	{
	try
	{
	document.getElementById('itemno').value = unescape(decodeURI(document.getElementById('replaceitemno').value));
	}
	catch(err)
	{
	}
	document.getElementById('itemdesp').value = unescape(decodeURI(document.getElementById('desphid').value));
	document.getElementById('price_bil').value = document.getElementById('pricehid').value;
	document.getElementById('btn_add').value = "Add";
	document.getElementById('btn_add').disabled = false; 
	}
	calamtadvance();
	
	if(document.getElementById('btn_add').value == "Add")
	{
	
	}
	}
	
	function caldisamt()
	{
	var qty_bil = trim(document.getElementById('qty_bil').value);
	var expprice = trim(document.getElementById('price_bil').value);
	var disamt1 = document.getElementById('dispec1').value;
	var disamt2 = document.getElementById('dispec2').value;
	var disamt3 = document.getElementById('dispec3').value;
	disamt1 = disamt1 * 0.01;
	disamt2 = disamt2 * 0.01;
	disamt3 = disamt3 * 0.01;
	var totaldiscount = ((((qty_bil * expprice) * disamt1)+ (((qty_bil * expprice)-(qty_bil * expprice) * disamt1))*disamt2)+(((qty_bil * expprice)-(((qty_bil * expprice)-(qty_bil * expprice) * disamt1))*disamt2))*disamt3);
	document.getElementById('disamt_bil').value = totaldiscount.toFixed(2);
	}
	
	function calamtadvance()
	{
	var qty_bil = trim(document.getElementById('qty_bil').value);
	var expprice = trim(document.getElementById('price_bil').value);
	var expdis = trim(document.getElementById('disamt_bil').value);
	qty_bil = qty_bil * 1;
	expprice = expprice * 1;
	expdis = expdis * 1;
	var itemamt = (qty_bil * expprice) - expdis;
	document.getElementById('amt_bil').value =  itemamt.toFixed(2);
	}
	
	function trim(strval)
	{
	return strval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
	}
	
	
	function addItemAdvance()
	{
	document.getElementById('reserveno').readOnly=true;
	<cfoutput>
	var itemno=encodeURI(trim(document.getElementById('itemno').value));
	var name = encodeURI(document.getElementById('name').value);
	var phone = encodeURI(document.getElementById('phone').value);
	var email = encodeURI(document.getElementById('email').value);
	var note = encodeURI(document.getElementById('note').value);
	var location = encodeURI(document.getElementById('location').value);
	
	var itemdesp = encodeURI(document.getElementById('itemdesp').value);
	var itemdespa = encodeURI(document.getElementById('itemdespa').value);
	var amt_bil = trim(document.getElementById('amt_bil').value);
	var qty_bil = trim(document.getElementById('qty_bil').value);
	var price_bil = trim(document.getElementById('price_bil').value);
	var reserveno = trim(document.getElementById('reserveno').value);
	var dispec1 = trim(document.getElementById('dispec1').value);
	var dispec2 = trim(document.getElementById('dispec2').value);
	var dispec3 = trim(document.getElementById('dispec3').value);
	var disamt_bil = trim(document.getElementById('disamt_bil').value);
	var ajaxurl = 'addproductsAjax.cfm?itemno='+escape(itemno)+'&name='+escape(name)+'&phone='+escape(phone)+'&email='+escape(email)+'&note='+escape(note)+'&location='+escape(location)+'&itemdesp='+escape(itemdesp)+'&itemdespa='+escape(itemdespa)+'&amt_bil='+escape(amt_bil)+'&qty_bil='+escape(qty_bil)+'&price_bil='+escape(price_bil)+'&reserveno='+escape(reserveno)+'&dispec1='+escape(dispec1)+'&dispec2='+escape(dispec2)+'&dispec3='+escape(dispec3)+'&disamt_bil='+escape(disamt_bil);
	
	<!---ajaxFunction(document.getElementById('ajaxFieldPro'),ajaxurl);--->
	
	 new Ajax.Request(ajaxurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
        },
        onFailure: function(){ 
		alert('Error Add Item'); },		
		
		onComplete: function(transport){
		document.getElementById('grossamt').value=document.getElementById('hidsubtotal').value;
		clearformadvance();
		refreshlist();
        }
      })

	</cfoutput>
	}
	
	function clearformadvance()
	{
		
	document.getElementById('itemno').value = '';
	document.getElementById('itemdesp').value = '';
	document.getElementById('itemdespa').value = '';
	document.getElementById('qty_bil').value = '1';
	document.getElementById('price_bil').value = '0.00';
	document.getElementById('amt_bil').value = '';
	document.getElementById('disamt_bil').value = '0.00';
	document.getElementById('dispec1').value = '0';
	document.getElementById('dispec2').value = '0';
	document.getElementById('dispec3').value = '0';
	document.getElementById('itemno').focus();
	<!---<cfif getgsetup.expressdisc neq "1">
	document.getElementById('qty_bilcount').value = '1';
	</cfif>--->
	}
	

	
	function refreshlist()
	{
	ajaxFunction(document.getElementById('itemlist'),'getBody.cfm?reserveno='+document.getElementById('reserveno').value);
	}

	function getlocationbal(itemnobal)
	{
	  var urlloaditembal = 'balonhand.cfm?itemno='+encodeURI(itemnobal)+'&location='+escape(document.getElementById('locationfr').value);
	
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
	
	<!---function recalculateall()
	{
	<cfoutput>
    var urlload = 'recalculateAjax.cfm?uuid=#URLEncodedFormat(uuid)#';
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
	}--->
	
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

	
	function validate()
	{
	reservesheet.submit();
	}
	
	function addOption(selectbox,text,value )
	{
	var optn = document.createElement("OPTION");
	optn.text = text;
	optn.value = value;
	selectbox.options.add(optn);
	}

	<!---
	
	function recalculateamt()
	{
	var ajaxurl = 'recalculateAjax.cfm?uuid=#URLEncodedFormat(uuid)#';
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
	}--->
	<cfoutput>
	function addnewitem2()
	{
	if(document.getElementById('amt_bil').value=='NaN')
	{
	alert('Error in Qty / Price / Discount / Amt');
	return false;
	}
	calamtadvance();
	if(trim(document.getElementById('reserveno').value) != ''){
	addItemControl();
	}
	else{
	alert('Please key in Reserve Code');
	}
	}
	
	function addItemControl()
	{
	var itemno = document.getElementById('itemno').value;
	var qtyser = document.getElementById('qty_bil').value;
	
	if (itemno == "")
	{
	alert("Please select item");
	}
	else
	{
	addItemAdvance();
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
	
    </script>


</head>

<body>
<cfoutput>
<cfset status1=''>
<cfset xlocation=getgsetup.ddllocation>

	<cfswitch expression="#url.type#">
		<cfcase value="Edit,Delete" delimiters=",">
			<cfquery name="getReserve" datasource="#dts#">
				select * from Reserve where reserveno = '#url.reserveno#'
			</cfquery>
            <cfset status1=getReserve.status>
		</cfcase>
        
	</cfswitch>

	<cfswitch expression="#url.type#">
		<cfcase value="Edit">
         <cfset reserveno='#url.reserveno#'>
			<cfset mode="Edit">
			<cfset title="Edit Reserve">
			<cfset button="Edit">
		</cfcase>
		<cfcase value="Delete">
         <cfset reserveno='#url.reserveno#'>
			<cfset mode="Delete">
			<cfset title="Delete Reserve">
			<cfset button="Delete">
		</cfcase>
		<cfcase value="Create">
        <cfquery name="getReserve" datasource="#dts#">
				select reserveno from Reserve where reserveno like '#getgsetup.ddllocation#%' order by reserveno desc
		</cfquery>
        <cfif getReserve.recordcount eq 0>
        <cfset reserveno=getgsetup.ddllocation&'00000001'>
        <cfelse>
        <cfset reserveno=getgsetup.ddllocation&numberformat(val(right(getReserve.reserveno,8))+1,'00000000')>
        </cfif>
			<cfset mode="Create">
			<cfset title="Create Reserve">
			<cfset button="Create">
		</cfcase>
	</cfswitch>

	<cfform name="reservesheet" id="reservesheet" action="reservetableprocess.cfm" method="post">
    	<input type="hidden" id="mode" name="mode" value="#mode#">
		<cfif isdefined('url.express')>
        <input type="hidden" id="express" name="express" value="1">
        <cfelse>
        <input type="hidden" id="express" name="express" value="">
        </cfif>
		<h1 align="center">Reserve Transaction</h1>

		<table align="center" class="data" width="800">
      		<tr>
        		<td width="100">Reserve :</td>
        		<td>
				<cfif mode eq "Delete" or mode eq "Edit">
            		<cfinput type="text" size="12" name="reserveno" id="reserveno" value="#getReserve.reserveno#" readonly onKeyUp="nextIndex(event,'reserveno','name')">
            	<cfelse>
            		<cfinput type="text" size="12" name="reserveno" id="reserveno" value="#reserveno#" required="yes" readonly maxlength="12" onKeyUp="nextIndex(event,'reserveno','name')">
          		</cfif>
				</td>
      		</tr>
            <tr>
        		<td>Location :</td>
        		<td>
                <cfif mode eq "Delete" or mode eq "Edit">
                <cfinput type="text" size="12" name="location" id="location" value="#getReserve.location#" readonly onKeyUp="nextIndex(event,'location','name')">
                <cfelse>
				<select name="location" id="location">
                <option value="">Choose a Location</option>
                <cfloop query="getlocation">
                <option value="#getlocation.location#" <cfif getlocation.location eq xlocation>selected</cfif>>#getlocation.location#</option>
                </cfloop>
                </select>
                </cfif>
				</td>
      		</tr>
      		<tr>
        		<td>Name:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="40" name="name" id="name" required="no" value="#getReserve.name#" maxlength="40" onKeyUp="nextIndex(event,'name','phone')">
					<cfelse>
						<cfinput type="text" size="40" name="name" id="name" required="no" maxlength="40" onKeyUp="nextIndex(event,'name','phone')">
					</cfif>
				</td>
      		</tr>
            <tr>
        		<td>Phone:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="40" name="phone" id="phone" required="no" value="#getReserve.phone#" maxlength="40" onKeyUp="nextIndex(event,'phone','email')">
					<cfelse>
						<cfinput type="text" size="40" name="phone" id="phone" required="no" maxlength="40" onKeyUp="nextIndex(event,'phone','email')">
					</cfif>
				</td>
      		</tr>
            <tr>
        		<td>E-mail:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="40" name="email" id="email" required="no" value="#getReserve.email#" maxlength="40" onKeyUp="nextIndex(event,'email','note')">
					<cfelse>
						<cfinput type="text" size="40" name="email" id="email" required="no" maxlength="40" onKeyUp="nextIndex(event,'email','note')">
					</cfif>
				</td>
      		</tr>
            <tr>
        		<td>Note:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
                <textarea name="note" id="note" cols="60" onKeyUp="nextIndex(event,'note','itemno')">#getReserve.note#</textarea>
					<cfelse>
                    <textarea name="note" id="note" cols="60" onKeyUp="nextIndex(event,'note','itemno')"></textarea>
					</cfif>
				</td>
      		</tr>
            <tr>
        		<td>Status:</td>
        		<td>
				<select name="status" id="status">
                <option value="">In Process</option>
                <option value="Cancel" <cfif status1 eq 'Cancel'>selected</cfif>>Cancel</option>
                <option value="Clear" <cfif status1 eq 'Clear'>selected</cfif>>Clear</option>
                </select>
				</td>
      		</tr>
            
            <tr>
        		<td>Total Amount:</td>
        		<td><cfif mode eq "Delete" or mode eq "Edit">
						<cfinput type="text" size="40" name="grossamt" required="no" value="#getReserve.grossamt#" maxlength="40" readonly>
					<cfelse>
						<cfinput type="text" size="40" name="grossamt" required="no" maxlength="40" readonly>
					</cfif>
				</td>
      		</tr>
            <tr>
            <td colspan="100%"><hr></td>
            </tr>
            <tr>
            <td>Item No</td>
            <td><cfinput type="text" name="itemno" id="itemno" size="26" onBlur="this.value = this.value.split('___', 1);getitemdetail(this.value);" onKeyUp="nextIndex(event,'itemno','itemdesp')" >
<input type="button" id="searchitembtn" onClick="ColdFusion.Window.show('searchitem');getfocus2();" value="Search" align="right" /><div id="itemDetailfield"></div><div id="ajaxFieldPro"></div></td>
            </tr>
            <tr>
            <td>Description</td>
            <td><cfinput type="text" name="itemdesp" id="itemdesp" value="" size="70" maxlength="100" onKeyUp="nextIndex(event,'itemdesp','itemdespa')"></td>
            </tr>
            <tr>
            <td></td>
            <td><cfinput type="text" name="itemdespa" id="itemdespa" value="" size="70" maxlength="100" onKeyUp="nextIndex(event,'itemdespa','qty_bil')"></td>
            </tr>
            <tr>
            <td>Quantity</td>
            <td><cfinput type="text" name="qty_bil" id="qty_bil" value="1" onKeyUp="calamtadvance();nextIndex(event,'qty_bil','price_bil')"></td>
            </tr>
            <tr>
            <td>Price</td>
            <td><cfinput type="text" name="price_bil" id="price_bil" value="0.00" onKeyUp="calamtadvance();nextIndex(event,'price_bil','amt_bil')" ></td>
            </tr>
            <tr>
            <td>Discount</td>
            <td>
           <input type="text" name="dispec1" id="dispec1" size="5" value="0" onKeyUp="caldisamt();calamtadvance();nextIndex(event,'expunitdis1','expunitdis2')"  >
%&nbsp;&nbsp;
<input type="text" name="dispec2" id="dispec2" size="5" value="0" onKeyUp="caldisamt();calamtadvance();nextIndex(event,'expunitdis2','expunitdis3')" />
%&nbsp;&nbsp;
<input type="text" name="dispec3" id="dispec3" size="5" value="0" onKeyUp="caldisamt();calamtadvance();nextIndex(event,'expunitdis3','expdis')" />%
			&nbsp;&nbsp;
            <input type="text" name="disamt_bil" id="disamt_bil" size="10" maxlength="10" value="0.00" onKeyUp="calamtadvance();nextIndex(event,'disamt_bil','amt_bil')" onBlur="calamtadvance();">
			</td>
            </tr>
            <tr>
            <td>Amount</td>
            <td><cfinput type="text" name="amt_bil" id="amt_bil" value="" readonly="yes" onKeyUp="nextIndex(event,'amt_bil','btn_add')"></td>
            
            </tr>
            <tr><td align="center" colspan="100%"><input name="btn_add" style="font: medium bolder" id="btn_add" type="button" value="Add" onClick="addnewitem2();"></td></tr>
            <!---
            <tr>
            <td>Tax</td>
            <td>
            <cfquery name="getTaxCode" datasource="#dts#">
  			SELECT "" as code, "" as rate1
 			union all
  			SELECT code,rate1 FROM #target_taxtable#
  			</cfquery>
  			<cfselect name="taxcode" id="taxcode" bind="CFC:tax.getTaxQry('#dts#','#target_taxtable#','INV')" value="code" display="code" onChange="setTimeout('caltax()',500);" bindonload="yes"/>&nbsp;&nbsp;<cfinput type="#inputtype#" name="taxper" id="taxper" value="0" size="8" bind="CFC:tax.getTax('#dts#','#target_taxtable#',{taxcode})" onKeyUp="caltax()" bindonload="yes"  />&nbsp;&nbsp;&nbsp;
  <cfinput type="#inputtype#" name="taxamt" id="taxamt" value="0.00" size="10" onKeyUp="calcfoot();" />  
            </td>
            </tr>--->
            
            <tr>
			<td colspan="4" height="200">
            <div id="itemlist" style="height:238px; overflow:scroll;">
			<table width="100%">
			<tr>
			<th width="2%">No</th>
			<th width="15%">Item Code</th>
			<th width="30%">Description</th>
			<th width="10%">Quantity</th>
			<th width="8%">Price</th>
			<th width="8%">Discount</th>
			<th width="8%">Amount</th>
			<th width="10%">Action</th>
			</tr>
<cfquery name="getictrantemp" datasource="#dts#">
SELECT * FROM reservedet WHERE reserveno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#reserveno#"> order by trancode desc
</cfquery>
<cfloop query="getictrantemp">
<tr <cfif (getictrantemp.currentrow mod 2) eq 0>style="background-color:##33FFFF"</cfif> onMouseOut="javascript:this.style.backgroundColor='<cfif (getictrantemp.currentrow mod 2) eq 0>33FFFF</cfif>';" onMouseOver="javascript:this.style.backgroundColor='99FF00';">
<td nowrap>#getictrantemp.currentrow#</td>
<td nowrap>#getictrantemp.itemno#</td>
<td nowrap>#getictrantemp.desp#</td>
<td nowrap>
</td>
<td nowrap align="right">#val(getictrantemp.qty_bil)#</td>
<td nowrap align="right">#numberformat(val(getictrantemp.price_bil),',.__')#</td>
<td nowrap align="right">#numberformat(val(getictrantemp.disamt_bil),',.__')#</td>
<td nowrap align="right">#numberformat(val(getictrantemp.amt_bil),',.__')#</td>
<td nowrap><input type="button" name="deletebtn#getictrantemp.trancode#" id="deletebtn#getictrantemp.trancode#" onClick="if(confirm('Are You Sure You Want To Delete?')){deleterow('#getictrantemp.trancode#')}" value="DELETE"/>&nbsp;<img id="updatebtn#getictrantemp.trancode#" name="updatebtn#getictrantemp.trancode#" src="/images/tick.gif" width="15" height="15" style="cursor:pointer; display:none;"><!--- &nbsp;&nbsp;<input type="button" name="Updatebtn#getictrantemp.trancode#" id="updatebtn#getictrantemp.trancode#" onClick="updaterow('#getictrantemp.trancode#');" value="UPDATE" style="display:none"/> ---></td>
</tr>
</cfloop>
<cfquery name="getsumictrantemp" datasource="#dts#">
SELECT sum(qty_bil)as sumqty FROM reservedet WHERE reserveno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#reserveno#"> order by trancode desc
</cfquery>
</table>
</div>
</td>
</tr>
            
      		<tr>
        		<td></td>
        		<td align="center"><cfinput type="button" name="submit123" id="submit123" value="#button#" onClick="validate();"></td>
      		</tr>
		</table>
	</cfform>
    </cfoutput>
</body>

</html>



<cfwindow  width="1000" height="800" name="searchitem" refreshOnShow="true"  modal="false"  x="100"
    y="100" title="Search Item" initshow="false"
        source="/default/transaction/reserve/searchitem.cfm?reftype=&itemno={itemno}" />