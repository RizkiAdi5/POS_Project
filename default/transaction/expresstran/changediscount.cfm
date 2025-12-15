<cfquery name="changediscountquery" datasource="#dts#">
SELECT brem4 FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
</cfquery>
<cfoutput>
<!--- <form name="changepriceform" id="changepriceform" method="post" action="changepriceprocess.cfm?uuid=#url.uuid#&trancode=#url.trancode#"> --->
<table>
<tr height="30">
<td height="30" style="font-size:24px"><strong><div style="vertical-align:bottom">Discount</div></strong></td>

<td>
<input type="hidden" id="changehighlight" name="changehighlight" value="1" />
<input type="text"  style="font: large bolder;" name="brem41" id="brem41" value="#changediscountquery.brem4#" onkeyup="updatediscount2(event,'#url.uuid#','#url.trancode#',document.getElementById('brem41').value);" onmouseout="doSomethingWithSelectedText();"/>
</td>
</tr>
<tr>
<td align="center" colspan="2">
<input type="button" name="sub_btn" id="sub_btn" value="Update" onclick="updatediscount('#url.uuid#','#url.trancode#',document.getElementById('brem41').value);" />
</td>
</tr>
</table>




<table border="0" cellpadding="0" cellspacing="0" align="center" class="calbtn">
<tr>
<td><input type="button" name="brem4btn1" id="brem4btn1" value="1" style="height:50px; width:50px;" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btn1').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btn1').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="brem4btn2" id="brem4btn2" value="2" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btn2').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btn2').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="brem4btn3" id="brem4btn3" value="3" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btn3').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btn3').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="brem4btn4" id="brem4btn4" value="4" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btn4').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btn4').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="brem4btn5" id="brem4btn5" value="5" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btn5').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btn5').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="brem4btn6" id="brem4btn6" value="6" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btn6').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btn6').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="brem4btn7" id="brem4btn7" value="7" style="height:50px; width:50px"onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btn7').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btn7').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="brem4btn8" id="brem4btn8" value="8" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btn8').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btn8').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="brem4btn9" id="brem4btn9" value="9" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btn9').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btn9').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="brem4btnd" id="brem4btnd" value="." style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btnd').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btnd').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="brem4btn0" id="brem4btn0" value="0" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btn0').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btn0').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="brem4btnx" id="brem4btnx" value="x" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('brem41').value=document.getElementById('brem41').value+document.getElementById('brem4btnx').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('brem41').value=document.getElementById('brem4btnx').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>


</table>


</td></tr>
</table>

<!--- </form> --->
</cfoutput>
