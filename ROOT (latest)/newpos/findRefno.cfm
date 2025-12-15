 <link rel="stylesheet" type="text/css" href="../newpos/table.css" />

<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "68, 1303, 1087, 2064, 10,1276, 965">
<cfinclude template="/latest/words.cfm">
<cfoutput>
<script type="text/javascript" src="/scripts/ajax.js"></script>
<cfset ptype = type >

	<cfquery name="getcustsupp" datasource="#dts#">
   		select refno,name,van,rem41 from artran where type='#ptype#' limit 15
	</cfquery>
 <center>
<table class="table-style-three">
	<tbody>
	<tr>
		<td><font style="text-transform:uppercase;font-weight: bold;">#type# #words[68]#</font></td>
		<td><input type="text" name="custno1" id="custno1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFieldTrade'),'findRefnoAjax.cfm?type=#type#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value);"  /></td>
	</tr>
	<tr>
		<td>#words[1303]#:</td>
		<td><input type="text" name="custname1" id="custname1" onblur="document.getElementById('loading').style.visibility='visible';ajaxFunction1(document.getElementById('ajaxFieldTrade'),'findRefnoAjax.cfm?type=#type#&custno='+document.getElementById('custno1').value+'&custname='+document.getElementById('custname1').value);" /></td>
	</tr>
		<tr>
		<td colspan="2" align="center"><input type="button" name="Searchbtn" value="#words[1276]#" ></td>
	</tr>
	</tbody>
</table>
</center>

<div id="loading" style="visibility:hidden">
    <div class="loading-indicator">
    Loading....
	</div>
</div>
	
<div id="ajaxFieldTrade">
<center>
<table class="table-style-three">
	<tbody>
	<tr>
		<th><font style="text-transform:uppercase">#words[1087]# #type#</font></th>
		<th>#words[1303]#</th>
		<th>#words[2064]#</th>
		<th>#words[10]#</th>		
	</tr>
	<cfloop query="getcustsupp" >
	<tr>
		<td>#getcustsupp.refno#</td>
		<td>#getcustsupp.van#</td>
		<td>#getcustsupp.rem41#</td>
		<td> <a onMouseOver="JavaScript:this.style.cursor='hand';" onClick="exchangereceipt('#getcustsupp.refno#');"><u>#words[965]#</u></a></td>
	</tr>
	</cfloop>
	</tbody>
</table>
</center>
</div>
    </cfoutput>