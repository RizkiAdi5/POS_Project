<cfoutput>
<cfform name="changefreeqtyform" id="changefreeqtyform" method="post" action="updatefreeqtyprocess.cfm?uuid=#url.uuid#&trancode=#url.trancode#">
<table>
<tr>
<th>Free Quantity</th>
<td>
<cfinput type="text" name="freeqty1" id="freeqty1" value="" required="yes" message="Free Quantity is Required or not valid" validate="float" validateat="onsubmit"/>
</td>
</tr>
<tr>
<td colspan="2" align="center">
<input type="submit" name="sub_btn" id="sub_btn" value="Update" />
</td>
</tr>
</table>

</cfform>
</cfoutput>
