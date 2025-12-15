
<cfoutput>

<cfquery name="getitemdesp" datasource="#dts#">
select desp,despa,comment,gltradac,price,itemno from ictrantemp where uuid='#url.uuid#' and trancode='#url.trancode#'
</cfquery>
<table width="570px" >
<tr>
<th colspan="100%"><div align="center">Item Detail</div></th>
</tr>

<tr>
<td width="250px"  height="30px">Description</td>
<td width="20px" style="font-size:16px;">:</td>
<td width="300px" align="left" style="font-size:16px;">

<input type="text" name="itemdespa" id="itemdespa" value="#getitemdesp.desp#" maxlength="60" size="60" onKeyUp="nextIndex(event,'itemdesp','itemdesp2');" />

<input type="hidden" name="itemdespuuid" id="itemdespuuid" value="#url.uuid#" maxlength="60" size="60" />
<input type="hidden" name="itemdesptrancodenew" id="itemdesptrancodenew" value="#url.trancode#" maxlength="60" size="60" />
</td>
</tr>
<tr>
<td width="250px" style="font-size:16px;" height="30px"></td>
<td width="20px" style="font-size:16px;"></td>
<td width="300px" align="left" style="font-size:16px;"><input type="text" name="itemdesp2" id="itemdesp2" value="#getitemdesp.despa#" maxlength="60" size="60" onKeyUp="nextIndex(event,'itemdesp2','itemcomment');" /></td>
</tr>
<tr>
<td style="font-size:16px; color:##000;">Comment</td>
<td style="font-size:16px;">:</td>
<td style="font-size:16px;" align="left">
<textarea name='itemcomment' id="itemcomment" tabindex="3" cols='60' rows='5'>#tostring(getitemdesp.comment)#</textarea>
</td>
</tr>

<tr>
<td align="center" colspan="3"><input type="button" name="itemdespbtn" id="itemdespbtn" value="Accept"  onclick="updatedesp('#url.uuid#','#url.trancode#',document.getElementById('itemdespa').value,document.getElementById('itemdesp2').value,document.getElementById('itemcomment').value);"/></td>
</tr>
</table>

</cfoutput>