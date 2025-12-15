<cfif IsDefined('url.packcode')>
	<cfset URLpackageCode = trim(urldecode(url.packcode))>
</cfif>		

<cfif IsDefined("url.action")>
	<cfif url.action EQ "create">
		<cfset pageTitle = "Create Package Profile">
		<cfset pageAction = "Create">
        
		<cfset packcode = "">
        <cfset desp = "">
		<cfset despa = "">
        <cfset grossamt = "">
        <cfset itemNo = "">
        <cfset itemDesp = "">
        <cfset quantity = "">
        <cfset price = "">
        <cfset discount1 = "">
        <cfset discount2 = "">
        <cfset discount3 = "">
        <cfset discountAmount = "">
        <cfset amount = "">
        
	<cfelseif url.action EQ "update">
		<cfset pageTitle = "Update Package Profile">
		<cfset pageAction = "Update">
		<cfquery name="getPackage" datasource='#dts#'>
            SELECT * 
            FROM package 
            WHERE packcode=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLpackageCode#">;
		</cfquery>
        
		<cfset packcode = getPackage.packcode>
        <cfset desp = getPackage.packdesp>
        <cfset grossamt = getPackage.grossamt>
        <!---
        <cfset itemNo = getPackage.>
        <cfset itemDesp = getPackage.>
        <cfset quantity = getPackage.>
        <cfset price = getPackage.>
        <cfset discount1 = getPackage.>
        <cfset discount2 = getPackage.>
        <cfset discount3 = getPackage.>
        <cfset discountAmount = getPackage.>
        <cfset amount = getPackage.>
		--->
                        
    <cfelseif url.action EQ "delete">
    	<cfset pageTitle="Delete Category Profile">
		<cfset pageAction="Delete">   
        
     
	</cfif>
    
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><cfoutput>#pageTitle#</cfoutput></title>
    <link rel="stylesheet" href="/latest/css/form.css" />
    <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
    <!--[if (gte IE 6)&(lte IE 8)]>
        <script type="text/javascript" src="/latest/js/selectivizr/selectivizr-min.js"></script>
        <noscript><link rel="stylesheet" href="" /></noscript>
    <![endif]-->
    
	<cfinclude template="filterItem.cfm">
    <link rel="stylesheet" href="/latest/css/select2/select2.css" />
    <script type="text/javascript" src="/latest/js/select2/select2.min.js"></script>
    
    <script type="text/javascript">
	
		function getitemdetail(detailitemno){
	
			if(detailitemno.indexOf('*') != -1){
				var thisitemno = detailitemno.split('*');
				document.getElementById('itemNo').value=thisitemno[1];
				document.getElementById('qty_bil').value=thisitemno[0];
				detailitemno=thisitemno[1];
			}
			
			if(trim(document.getElementById('itemNo').value) != ""){
				var urlloaditemdetail = 'addItemAjax.cfm?itemno='+escape(encodeURI(detailitemno));
				new Ajax.Request(urlloaditemdetail,
				{
					method:'get',
					onSuccess: function(getdetailback){
						document.getElementById('itemDetailfield').innerHTML = trim(getdetailback.responseText);
					},
					onFailure: function(){ 
						alert('Item Not Found'); },				
						onComplete: function(transport){
							updateVal();
						}
					}
				)
			}
		}
	
		function updaterow(rowno){
			
			var varcoltype = 'coltypelist'+rowno;
			var varqtylist = 'qtylist'+rowno;
			var packcode = document.getElementById('packcode').value;
			var coltypedata = document.getElementById(varcoltype).value;
			var qtylistdata = document.getElementById(varqtylist).value;
			var updateurl = 'updaterow.cfm?packcode='+escape(packcode)+'&coltype='+escape(coltypedata)+'&qty='+escape(qtylistdata)+'&trancode='+rowno;
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
				}
			)	
		}
		
		function deleterow(rowno){
	
			var packcode = document.getElementById('packcode').value;
			var updateurl = 'deleterow.cfm?packcode='+escape(packcode)+'&trancode='+rowno;
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
				}
			)	
		}
		
		var opt = 'Width=500px, Height=250px, Top=300px, left=400px, scrollbars=yes, status=no, resizable=1';
		
		var t1;
		var t2;
	
		function getfocus(){	
			t1 = setTimeout("document.getElementById('custno1').focus();",750);
		}
		function getfocus2(){
			t2 = setTimeout("document.getElementById('itemno1').focus();",1000);
		}
		function getfocus3(){
			t2 = setTimeout("document.getElementById('aitemno').focus();",1000);
		}
		
		function getfocus4(){
			setTimeout("document.getElementById('price_bil1').focus();",1000);
		}
		
		function getfocus5(){
			setTimeout("selectcopy();",2000);
		}
			
		function updateVal(){
			var validdesp = unescape(document.getElementById('desphid').value);
			
			if (validdesp == "itemisnoexisted"){
				document.getElementById('btn_add').value = "Item No Existed";
				document.getElementById('btn_add').disabled = true; 
				alert('Item Not Found');
			}
			else{
				try{
					document.getElementById('itemno').value = unescape(decodeURI(document.getElementById('replaceitemno').value));
				}
				catch(err){
				}
				document.getElementById('itemdesp').value = unescape(decodeURI(document.getElementById('desphid').value));
				document.getElementById('price_bil').value = document.getElementById('pricehid').value;
				document.getElementById('btn_add').value = "Add";
				document.getElementById('btn_add').disabled = false; 
			}
			
			calamtadvance();
		
			if(document.getElementById('btn_add').value == "Add"){
			}
		}
		function caldisamt(){
			
			var qty_bil = trim(document.getElementById('qty_bil').value);
			var expprice = trim(document.getElementById('price_bil').value);
			var disamt1 = document.getElementById('disamt1').value;
			var disamt2 = document.getElementById('disamt2').value;
			var disamt3 = document.getElementById('disamt3').value;
			
			disamt1 = disamt1 * 0.01;
			disamt2 = disamt2 * 0.01;
			disamt3 = disamt3 * 0.01;
			var totaldiscount = ((((qty_bil * expprice) * disamt1)+ 
							    (((qty_bil * expprice)-(qty_bil * expprice) * disamt1))*disamt2)+
								(((qty_bil * expprice)-(((qty_bil * expprice)-(qty_bil * expprice) * disamt1))*disamt2))*disamt3);
								
			document.getElementById('discountAmount').value = totaldiscount.toFixed(2);
		}
		
		function calamtadvance(){
			
			var qty_bil = trim(document.getElementById('qty_bil').value);
			var expprice = trim(document.getElementById('price_bil').value);
			var expdis = trim(document.getElementById('discountAmount').value);
			
			qty_bil = qty_bil * 1;
			expprice = expprice * 1;
			expdis = expdis * 1;
			var itemamt = (qty_bil * expprice) - expdis;
			document.getElementById('amount').value =  itemamt.toFixed(2);
		}
		
		function trim(strval){
			return strval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
		}
	<cfoutput>		
		function addItemAdvance(){
			
			document.getElementById('packcode').readOnly=true;
			var itemno=encodeURI(trim(document.getElementById('itemno').value));
			var desp = encodeURI(document.getElementById('desp').value);
			var itemdesp = encodeURI(document.getElementById('itemdesp').value);
			var itemdespa = encodeURI(document.getElementById('itemdespa').value);
			var amt_bil = trim(document.getElementById('amt_bil').value);
			var qty_bil = trim(document.getElementById('qty_bil').value);
			var price_bil = trim(document.getElementById('price_bil').value);
			var packcode = trim(document.getElementById('packcode').value);
			var dispec1 = trim(document.getElementById('dispec1').value);
			var dispec2 = trim(document.getElementById('dispec2').value);
			var dispec3 = trim(document.getElementById('dispec3').value);
			var disamt_bil = trim(document.getElementById('disamt_bil').value);
			var ajaxurl = 'addproductsAjax.cfm?itemno='+escape(itemno)+'&desp='+escape(desp)+'&itemdesp='+escape(itemdesp)+'&itemdespa='+escape(itemdespa)+'&amt_bil='+escape(amt_bil)+'&qty_bil='+escape(qty_bil)+'&price_bil='+escape(price_bil)+'&packcode='+escape(packcode)+'&dispec1='+escape(dispec1)+'&dispec2='+escape(dispec2)+'&dispec3='+escape(dispec3)+'&disamt_bil='+escape(disamt_bil);
	
			 new Ajax.Request(ajaxurl,
			 {
				method:'get',
				onSuccess: function(getdetailback){
					document.getElementById('ajaxFieldPro').innerHTML = trim(getdetailback.responseText);
				},
				onFailure: function(){ 
					alert('Error Add Item'); 
				},		
				
				onComplete: function(transport){
					document.getElementById('grossamt').value=document.getElementById('hidsubtotal').value;
					clearformadvance();
					refreshlist();
				}
			  })
		}
	</cfoutput>	
	
		function clearformadvance(){
			
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
		}
		
	
		
		function refreshlist(){
			ajaxFunction(document.getElementById('itemlist'),'getBody.cfm?packcode='+document.getElementById('packcode').value);
		}
		
		
		function getlocationbal(itemnobal){
			
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
	
		
		function validformfield(){
			var formvar = document.getElementById('invoicesheet');
			var answer = _CF_checkinvoicesheet(formvar);
			
			if (answer){
				recalculateall();
			}
			else{
			}
		}
		
		function addOption(selectbox,text,value ){
			var optn = document.createElement("OPTION");
			optn.text = text;
			optn.value = value;
			selectbox.options.add(optn);
		}
	
		function addnewitem2(){
			
			if(document.getElementById('amt_bil').value=='NaN'){
				alert('Error in Qty / Price / Discount / Amt');
				return false;
			}
			
			calamtadvance();
			if(trim(document.getElementById('packcode').value) != ''){
				addItemControl();
			}
			else{
				alert('Please key in package Code');
			}
		}
		
		function addItemControl(){
			var itemno = document.getElementById('itemno').value;
			var qtyser = document.getElementById('qty_bil').value;
		
			if (itemno == ""){
				alert("Please select item");
			}
			else{
				addItemAdvance();
			}
		}
	</script> 
</head>

<body class="container">
<cfoutput>
    <form class="formContainer form2Button" action="/latest/maintenance/packageProcess.cfm?action=#url.action#" method="post" onsubmit="document.getElementById('packcode').disabled=false";>
        <div>#pageTitle#</div>
        <div>
            <table>
                <tr>
                    <th><label for="packageCode">Package Code</label></th>
                    <td>
                        <input type="text" id="packcode" name="packcode" required="required" maxlength="25"
                            <cfif IsDefined("url.action") AND url.action NEQ "create">  value="#URLpackageCode#" disabled="true"</cfif>/>
                    </td>
                </tr>
                <tr>
                    <th><label for="packageDesp">Description</label></th>
                    <td>
                        <input type="text" id="desp" name="desp" value="#desp#" placeholder="Description for Package"/>                
                    </td>
                </tr> 
                <tr>
                    <th><label for="grossamt">Total Amount</label></th>
                    <td>
                        <input type="text" id="grossamt" name="grossamt" value="#grossamt#" placeholder="Total Amount"/>                   
                    </td>
                </tr>
                <tr>
                    <th><label for="itemNo">Item No</label></th>
                    <td>
                    	<input type="hidden" id="itemNo" name="itemNo" class="itemNo" data-placeholder="Choose an Item No" onBlur="getitemdetail(this.value);" />	                       	<div id="itemDetailfield"></div>
        				<div id="ajaxFieldPro"></div>
                    </td>
                </tr>
                <tr>
                    <th><label for="itemDesp">Description</label></th>
                    <td>
                        <input type="text" id="itemdesp" name="itemDesp" value="" placeholder="Description for Item" />              
                    </td>
                </tr>
                <tr>
                    <th><label for=""></label></th>
                    <td>
                        <input type="text" id="itemdespa" name="itemdespa" value="" placeholder="Description 2 for Item"/>                   
                    </td>
                </tr>
                <tr>
                    <th><label for="quantity">Quantity</label></th>
                    <td>
                        <input type="text" id="qty_bil" name="qty_bil" value="" placeholder="Quantity"/>                     
                    </td>
                </tr>
                <tr>
                    <th><label for="price">Price</label></th>
                    <td>
                        <input type="text" id="price_bil" name="price_bil" value="" placeholder="Price"/>                     
                    </td>
                </tr>
                <tr>
                    <th><label for="discount">Discount</label></th>
                    <td>
                        <span>
                            <input type="text" id="dispec1" name="dispec1" value="0" size="10" onKeyUp="caldisamt();calamtadvance();nextIndex('expunitdis1','expunitdis2')" placeholder="Discount 1"/>%
                            <input type="text" id="dispec2" name="dispec2" value="0" size="10" onKeyUp="caldisamt();calamtadvance();nextIndex('expunitdis2','expunitdis3')" placeholder="Discount 1"/>%
                            <input type="text" id="dispec3" name="dispec3" value="0" size="10" onKeyUp="caldisamt();calamtadvance();nextIndex('expunitdis3','expdis')" placeholder="Discount 1"/>%   
                            <input type="text" id="disamt_bil" name="disamt_bil" value="0.00" size="13" onKeyUp="calamtadvance();" onBlur="calamtadvance();" placeholder="Discount Amount" readonly="yes"/>
                        </span>               
                    </td>
                </tr>
                <tr>
                    <th></th>
                    <td>
                    	<input type="button" id="btn_add" name="btn_add" value="Add" onClick="addnewitem2();">                   
                    </td>
                </tr>
                
                
                <!---
                <tr>
                    <th><label for="partNo">Part No</label></th>
                    <td>
                        <span>
                            <input type="text" id="partNo" name="partNo" value="##" placeholder="Part No"/>%
                        </span>               
                    </td>
                </tr>
                <tr>
                    <th><label for="bodyRemark2">Body Remark 2</label></th>
                    <td>
                        <span>
                            <input type="text" id="bodyRemark2" name="bodyRemark2" value="##" placeholder="Body Remark 2"/>%
                        </span>               
                    </td>
                </tr> --->
                <tr style="border-style:dotted solid;">
                    <td colspan="100%">
                        <div  id="itemlist" style="height:238px;width:1000px; overflow:scroll;">
                            <table width="100%">
                            	<tr style="border-style:dotted solid;">
                                        <th width="2%" style="text-align:center;">No</th>
                                        <th width="15%" >Item Code</th>
                                        <th width="30%" >Description</th>
                                        <th nowrap ></th>
                                        <th width="10%" >Quantity</th>
                                        <th width="8%" >Price</th>
                                        <th width="8%" >Discount</th>
                                        <th width="8%" >Amount</th>
                                        <th width="10%" >Action</th>
                                </tr>
                                <cfquery name="getictrantemp" datasource="#dts#">
                                    SELECT * 
                                    FROM packdet 
                                    WHERE packcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#packcode#"> 
                                    ORDER BY trancode DESC;
                                </cfquery>


                                <cfloop query="getictrantemp">
                                    <tr>
                                    	
                                        <td nowrap >#getictrantemp.currentrow#</td>
                                        <td nowrap >#getictrantemp.itemno#</td>
                                        <td nowrap >#getictrantemp.desp#</td>
                                        <td nowrap ></td>
                                        <td nowrap >#val(getictrantemp.qty_bil)#</td>
                                        <td nowrap >#numberformat(val(getictrantemp.price_bil),',.__')#</td>
                                        <td nowrap >#numberformat(val(getictrantemp.disamt_bil),',.__')#</td>
                                        <td nowrap >#numberformat(val(getictrantemp.amt_bil),',.__')#</td>
                                        <td nowrap >
                                            <button id="deletebtn#getictrantemp.trancode#" name="deletebtn#getictrantemp.trancode#" onClick="if(confirm('Are You Sure You Want To Remove?')){deleterow('#getictrantemp.trancode#')}" style="height:30px; width:65px;">Remove</button>
                                          
                                        </td>
									</tr>
                                </cfloop>
                                <cfquery name="getsumictrantemp" datasource="#dts#">
                                    SELECT sum(qty_bil) AS sumqty 
                                    FROM packdet 
                                    WHERE packcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#packcode#"> 
                                    ORDER BY trancode DESC;
                                </cfquery>
                            </table>
                        </div>
                    </td> 
                </tr>
          </table>
        </div>
        <div>
            <input type="submit" value="#pageAction#" />
            <input type="button" value="Cancel" onclick="window.location='/latest/maintenance/packageProfile.cfm'" />
        </div>
    </form>
</cfoutput>
</body>
</html>