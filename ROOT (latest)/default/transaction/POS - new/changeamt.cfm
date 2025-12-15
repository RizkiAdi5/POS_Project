<cfquery name="getamt" datasource="#dts#">
SELECT amt_bil FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
</cfquery>
<cfoutput>
<!--- <form name="changepriceform" id="changepriceform" method="post" action="changepriceprocess.cfm?uuid=#url.uuid#&trancode=#url.trancode#"> --->
<table>
<tr height="30">
<td height="30" style="font-size:24px"><strong><div style="vertical-align:bottom">Amount</div></strong></td>
<td>
<input type="hidden" id="changehighlight" name="changehighlight" value="1" />
<input style="font: large bolder;" type="text" name="amt_bil1" id="amt_bil1" value="#numberformat(val(getamt.amt_bil),'.__')#" onmouseout="doSomethingWithSelectedText();" />
</td>
</tr>
<tr>
<td colspan="2" align="center" >
<input type="button" name="sub_btn" id="sub_btn" value="Update" onclick="updateamt('#url.uuid#','#url.trancode#',document.getElementById('amt_bil1').value);" />
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr><td colspan="2">

<table border="0" cellpadding="0" cellspacing="0" align="center" class="calbtn">
<tr>
<td><input type="button" name="amtbtn1" id="amtbtn1" value="1" style="height:50px; width:50px;" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtn1').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtn1').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="amtbtn2" id="amtbtn2" value="2" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtn2').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtn2').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="amtbtn3" id="amtbtn3" value="3" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtn3').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtn3').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="amtbtn4" id="amtbtn4" value="4" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtn4').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtn4').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="amtbtn5" id="amtbtn5" value="5" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtn5').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtn5').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="amtbtn6" id="amtbtn6" value="6" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtn6').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtn6').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="amtbtn7" id="amtbtn7" value="7" style="height:50px; width:50px"onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtn7').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtn7').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="amtbtn8" id="amtbtn8" value="8" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtn8').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtn8').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="amtbtn9" id="amtbtn9" value="9" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtn9').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtn9').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="amtbtnd" id="amtbtnd" value="." style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtnd').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtnd').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="amtbtn0" id="amtbtn0" value="0" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtn0').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtn0').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="amtbtnx" id="amtbtnx" value="x" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('amt_bil1').value=document.getElementById('amt_bil1').value+document.getElementById('amtbtnx').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('amt_bil1').value=document.getElementById('amtbtnx').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>


</table>

</td></tr>

</table>





<!--- </form> --->
</cfoutput>
