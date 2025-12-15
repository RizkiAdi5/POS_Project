
<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "65, 1302, 120, 1096">
<cfinclude template="/latest/words.cfm">

<cfquery name="getitem" datasource="#dts#">
	SELECT itemno,desp,despa,price 
    FROM icitem
    WHERE itemno="#itemno#";
</cfquery>


<cfoutput>
<center>
<table  width="100%">
<tr>							
	<td width="30%">#words[120]#</td>
    <td>:</td>
	<td><input type="text" name="itema" id="itema" style="font-size:55px; color:black; background-color:transparent; border:none;" disabled value="#getitem.itemno#"></td>
</tr>
<tr>
	<td width="30%">#words[65]#</td>
    <td>:</td>
	<td><input type="text" name="desp" id="desp" style="font-size:55px; color:black; background-color:transparent; border:none;" disabled value="#getitem.desp#  #getitem.despa#"></td>
</tr>
<tr>									
	<td width="30%">#words[1096]#</td>
    <td>:</td>
    <td><input type="text" name="price" id="price" style="font-size:55px; color:black; background-color:transparent; border:none;" disabled value="#getitem.price#"></td>
</tr>	
<tr><td></td></tr>
 <tr align="center"><td colspan="3"><input type="button" class="bttn" name="close" value="Close Window" onclick="window.close();"></td></tr>
</table>
</center>
</cfoutput>
