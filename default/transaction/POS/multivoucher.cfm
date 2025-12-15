<script type='text/javascript' src='/ajax/core/engine.js'></script>
	<script type='text/javascript' src='/ajax/core/util.js'></script>
	<script type='text/javascript' src='/ajax/core/settings.js'></script>
    <script type='text/javascript' src='/ajax/core/shortcut.js'></script>
    <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
    <script type="text/javascript" src="/scripts/prototypenew.js" ></script>

<script type="text/javascript">
function addmultivoucherfunc(e,multivoucherno)
	{
		if(e.keyCode==13 && multivoucherno != ''){
		var updateurl = 'multivoucherajax.cfm?uuid='+escape(document.getElementById('voucheruuid').value)+'&voucherno='+escape(multivoucherno);
		<!---ajaxFunction(document.getElementById('voucherlist'),updateurl);--->
		
				new Ajax.Request(updateurl,
			  {
				method:'get',
				onSuccess: function(getdetailback){
				document.getElementById('voucherlist').innerHTML = getdetailback.responseText;
				},
				onFailure: function(){ 
				alert('Error adding voucher'); },		
				
				onComplete: function(transport){
					
				}
			  })
		}
	}
	
</script>
<cfoutput>
<input type="hidden" name="voucheruuid" id="voucheruuid" value="#createuuid()#" />
<div id="voucherlist">
<table width="250">
<tr>
<th>No</th>
<th>Voucher No</th>
<th>Amount</th>
</tr>
<tr>
<td></td>
<td><input type="text" name="multivoucherno" id="multivoucherno" value="" onkeyup="addmultivoucherfunc(event,this.value);"/></td>
<td><input type="hidden" name="totalvoucherlist" id="totalvoucherlist" value="" /><input type="hidden" name="totalvoucheramt" id="totalvoucheramt" value="0" /></td>
</tr>
</table>
</div>
</cfoutput>
<table width="250">
<tr>
<td align="center">
<input type="button" name="acceptvoucher" id="acceptvoucher" value="Save" onclick="window.opener.document.getElementById('voucherno').value=document.getElementById('totalvoucherlist').value;
if ((document.getElementById('totalvoucheramt').value*1) <= (window.opener.document.getElementById('hidgt5').value*1))
					{
					window.opener.document.getElementById('voucheramt5').value=document.getElementById('totalvoucheramt').value;
					}
					else
					{
						window.opener.document.getElementById('voucheramt5').value=window.opener.document.getElementById('hidgt5').value;
					}

window.opener.calculatetotal(event,'acceptvoucher','voucheramt5');window.close();" />
</td></tr>
</table>