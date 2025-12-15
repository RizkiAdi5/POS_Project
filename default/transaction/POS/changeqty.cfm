<cfquery name="changeqtyquery" datasource="#dts#">
SELECT qty_bil FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
</cfquery>


<cfoutput>
<!--- <form name="changepriceform" id="changepriceform" method="post" action="changepriceprocess.cfm?uuid=#url.uuid#&trancode=#url.trancode#"> --->
<table>
<tr height="30">
<td height="30" style="font-size:24px"><strong><div style="vertical-align:bottom">Qty</div></strong></td>
<td >
<input type="hidden" id="changehighlight" name="changehighlight" value="1" />
<input type="text" style="font: large bolder;" name="qty_bil1" id="qty_bil1" value="#numberformat(val(changeqtyquery.qty_bil),'.__')#" onkeyup="updateqty2(event,'#url.uuid#','#url.trancode#',document.getElementById('qty_bil1').value);" onmouseout="doSomethingWithSelectedText();"/>
</td>
</tr>
<tr>
<td align="center" colspan="2">
<input type="button" name="sub_btn" id="sub_btn" value="Update" onclick="updateqty('#url.uuid#','#url.trancode#',document.getElementById('qty_bil1').value);" />
</td>
</tr>

<tr><td>&nbsp;</td></tr>

<tr><td colspan="2">


<table border="0" cellpadding="0" cellspacing="0" align="center" class="calbtn">
<tr>
<td><input type="button" name="qtybtn1" id="qtybtn1" value="1" style="height:100px; width:100px;" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtn1').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtn1').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="qtybtn2" id="qtybtn2" value="2" style="height:100px; width:100px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtn2').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtn2').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="qtybtn3" id="qtybtn3" value="3" style="height:100px; width:100px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtn3').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtn3').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="qtybtn4" id="qtybtn4" value="4" style="height:100px; width:100px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtn4').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtn4').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="qtybtn5" id="qtybtn5" value="5" style="height:100px; width:100px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtn5').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtn5').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="qtybtn6" id="qtybtn6" value="6" style="height:100px; width:100px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtn6').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtn6').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="qtybtn7" id="qtybtn7" value="7" style="height:100px; width:100px"onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtn7').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtn7').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="qtybtn8" id="qtybtn8" value="8" style="height:100px; width:100px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtn8').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtn8').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="qtybtn9" id="qtybtn9" value="9" style="height:100px; width:100px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtn9').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtn9').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="qtybtnd" id="qtybtnd" value="." style="height:100px; width:100px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtnd').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtnd').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="qtybtn0" id="qtybtn0" value="0" style="height:100px; width:100px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtn0').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtn0').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="qtybtnx" id="qtybtnx" value="x" style="height:100px; width:100px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('qty_bil1').value=document.getElementById('qty_bil1').value+document.getElementById('qtybtnx').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('qty_bil1').value=document.getElementById('qtybtnx').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>


</table>


</td></tr>


</table>



<!--- </form> --->
</cfoutput>
