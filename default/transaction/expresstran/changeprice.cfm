<cfquery name="getprice" datasource="#dts#">
SELECT price_bil,itemno FROM ictrantemp where uuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uuid#">
and trancode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.trancode#">
</cfquery>

<cfquery name="getminimumprice" datasource="#dts#">
SELECT price2,ucost FROM icitem where itemno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getprice.itemno#">
</cfquery>

<cfquery name="getgsetup" datasource="#dts#">
select gpricemin from gsetup
</cfquery>

<cfquery name="getdealermenu" datasource="#dts#">
select selling_below_cost from dealer_menu
</cfquery>


<cfoutput>
<!--- <form name="changepriceform" id="changepriceform" method="post" action="changepriceprocess.cfm?uuid=#url.uuid#&trancode=#url.trancode#"> --->
<table>
<tr height="30">
<td height="30" style="font-size:24px"><strong><div style="vertical-align:bottom">Price</div></strong></td>
<td>
<cfif getgsetup.gpricemin eq '1'>
<input type="hidden" name="minimumprice2" id="minimumprice2" value="#numberformat(val(getminimumprice.price2),'.__')#"/>
<cfelse>
<input type="hidden" name="minimumprice2" id="minimumprice2" value="0"/>
</cfif>

<cfif getdealermenu.selling_below_cost eq 'Y'>
<input type="hidden" name="sellingbelowcost" id="sellingbelowcost" value="#numberformat(val(getminimumprice.ucost),'.__')#"/>
<cfelse>
<input type="hidden" name="sellingbelowcost" id="sellingbelowcost" value="0"/>
</cfif>

<input type="hidden" id="changepriceuuid" name="changepriceuuid" value="#url.uuid#" />
<input type="hidden" id="changepricetrancode" name="changepricetrancode" value="#url.trancode#" />

<input type="hidden" id="changehighlight" name="changehighlight" value="1" />

<input style="font: large bolder;" type="text" name="price_bil1" id="price_bil1" value="#numberformat(val(getprice.price_bil),'.__')#" onkeyup="updateprice2(event,'#url.uuid#','#url.trancode#',document.getElementById('price_bil1').value);" onmouseout="doSomethingWithSelectedText();"/>
</td>
</tr>
<tr>
<td align="center" colspan="2">
<input type="button" name="sub_btn" id="sub_btn" value="Update" onclick="updateprice('#url.uuid#','#url.trancode#',document.getElementById('price_bil1').value);" />
</td>
</tr>
<tr><td>&nbsp;</td></tr>

<tr><td colspan="2">


<table border="0" cellpadding="0" cellspacing="0" align="center" class="calbtn">
<tr>
<td><input type="button" name="pricebtn1" id="pricebtn1" value="1" style="height:50px; width:50px;" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtn1').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtn1').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="pricebtn2" id="pricebtn2" value="2" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtn2').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtn2').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="pricebtn3" id="pricebtn3" value="3" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtn3').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtn3').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="pricebtn4" id="pricebtn4" value="4" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtn4').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtn4').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="pricebtn5" id="pricebtn5" value="5" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtn5').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtn5').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="pricebtn6" id="pricebtn6" value="6" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtn6').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtn6').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="pricebtn7" id="pricebtn7" value="7" style="height:50px; width:50px"onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtn7').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtn7').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="pricebtn8" id="pricebtn8" value="8" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtn8').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtn8').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="pricebtn9" id="pricebtn9" value="9" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtn9').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtn9').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>

<tr>
<td><input type="button" name="pricebtnd" id="pricebtnd" value="." style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtnd').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtnd').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="pricebtn0" id="pricebtn0" value="0" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtn0').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtn0').value;document.getElementById('changehighlight').value='0';}" /></td>

<td><input type="button" name="pricebtnx" id="pricebtnx" value="x" style="height:50px; width:50px" onclick="if(document.getElementById('changehighlight').value==0){document.getElementById('price_bil1').value=document.getElementById('price_bil1').value+document.getElementById('pricebtnx').value;document.getElementById('changehighlight').value='0'}else{document.getElementById('price_bil1').value=document.getElementById('pricebtnx').value;document.getElementById('changehighlight').value='0';}" /></td>

</tr>


</table>


</td></tr>
</table>


<!--- </form> --->
</cfoutput>
