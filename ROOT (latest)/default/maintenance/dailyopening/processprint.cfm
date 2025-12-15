<script type="text/javascript">
var ws = new ActiveXObject("WScript.Shell");
ws.Run('cmd.exe /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /y /n "Fax"','0');
</script>

<script type='text/javascript' src='/ajax/core/jquery.jqprint-0.3.js'></script>



<html>
<body>


<cfquery name="getbill" datasource="#dts#">
SELECT * FROM dailycounter where id='#url.id#'
</cfquery>

<cfoutput>

<table width="230px" style="font-size:12px; border-width:thin;" cellpadding="0" cellspacing="0" >
<tr><td colspan="3" align="center"><a style="cursor:pointer; font-size:20px" onClick="window.print()"><strong>**Pretty Cash **</strong></a></td><td widtd="10%" rowspan="100%">&nbsp;</td></tr>
<tr>
<td>&nbsp;</td>
</tr>
<tr>
<td>Transaction</td>
<td>:</td>
<td><cfif getbill.type eq 'cashin'>Cash In<cfelseif getbill.type eq 'cashout'>Cash Out<cfelse>Opening</cfif></td>
</tr>

<tr>
<td>Date</td>
<td>:</td>
<td>#dateformat(getbill.wos_date,'DD/MM/YYYY')#</td>
</tr>

<tr>
<td>Time</td>
<td>:</td>
<td>#timeformat(getbill.created_on,'HH:MM:SS')#</td>
</tr>

<tr>
<td>Till No</td>
<td>:</td>
<td>#getbill.id#</td>
</tr>

<tr>
<td>Description</td>
<td>:</td>
<td>#getbill.desp#</td>
</tr>

<tr>
<td>Amount</td>
<td>:</td>
<td>#numberformat(getbill.openning,',_.__')#</td>
</tr>

<tr>
<td>Authorised By</td>
<td>:</td>
<td>#getbill.created_by#</td>
</tr>

<tr>
<td>Carried Out By</td>
<td>:</td>
<td>#getbill.created_by#</td>
</tr>

<tr>
<td>Signed</td>
<td>:</td>
<td>________________</td>
</tr>

</table>





<script type="text/javascript">

this.print(false);

</script>


</cfoutput>
</body>
</html>
<!---

<cfheader name="Content-Disposition" value="inline; filename=test.txt">
<cfcontent type="application/msword" file="c:\railo\test.txt" deletefile="yes"> --->
