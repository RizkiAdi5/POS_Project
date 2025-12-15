<cfquery name="getGSetup" datasource="#dts#">
  	select compro,compro2,compro3,compro4,compro5,compro6,compro7,gstno from gsetup 
</cfquery>

<cfquery name="getgeneral" datasource="#dts#">
	select lastaccyear,filterall from gsetup
</cfquery>
    
 <cfquery name="MyQuery" datasource="#dts#">
 select * from deposit where depositno='#url.depositno#'
</cfquery>

<!---
<cfreport template="printdeposit.cfr" format="PDF" query="MyQuery"><!--- or "FlashPaper" or "Excel" or "RTF" --->
	<cfreportparam name="compro" value="#getGSetup.compro#">
	<cfreportparam name="compro2" value="#getGSetup.compro2#">
	<cfreportparam name="compro3" value="#getGSetup.compro3#">
	<cfreportparam name="compro4" value="#getGSetup.compro4#">
	<cfreportparam name="compro5" value="#getGSetup.compro5#">
	<cfreportparam name="compro6" value="#getGSetup.compro6#">
	<cfreportparam name="compro7" value="#getGSetup.compro7#">
    <cfreportparam name="dts" value="#dts#">
    
</cfreport>--->
<cfoutput>
<table width="230px" style="font-size:12px; border-width:thin;" cellpadding="0" cellspacing="0" align="center">
<tr><td width="10%" colspan="2" align="right"><div style="font-size:20px"><strong>Official Receipt</strong></div></td></tr>
<tr><td colspan="2" align="left"><a style="cursor:pointer; font-size:20px" onClick="window.print()"><strong>#getgsetup.compro#</strong></a></td></tr>
<tr><td>Reference No:</td><td>#MyQuery.depositno#</td></tr>
<tr><td>Date :</td><td>#dateformat(MyQuery.wos_date,'DD-MM-YYYY')#</td></tr>

<tr><td>Description :</td><td>#MyQuery.desp#</td></tr>
<tr><td>For Reference No. :</td><td>#MyQuery.sono#</td></tr>
<tr><td colspan="2"><u><strong>Payment Break Down</strong></u></td></tr>
<tr><td width="15%">Cash</td><td align="right" width="15%">#LSNumberFormat(MyQuery.cs_pm_cash, ",_.__")#</td></tr>
<tr><td>Credit Card 1</td><td align="right">#LSNumberFormat(MyQuery.cs_pm_crcd, ",_.__")#</td></tr>
</td><td>Credit Card 2</td><td align="right">#LSNumberFormat(MyQuery.cs_pm_crc2, ",_.__")#</td></tr>
</td><td>Cheque</td><td align="right">#LSNumberFormat(MyQuery.cs_pm_cheq, ",_.__")#</td></tr>
</td><td>Debit Card</td><td align="right">#LSNumberFormat(MyQuery.cs_pm_dbcd, ",_.__")#</td></tr>
</td><td>Voucher</td><td align="right">#LSNumberFormat(MyQuery.cs_pm_vouc, ",_.__")#</td></tr>
</td><td colspan="2"><hr /></td></tr>
</td><td><strong>Payment Total</strong></td><td align="right">#LSNumberFormat(MyQuery.cs_pm_crcd+MyQuery.cs_pm_crc2+MyQuery.cs_pm_cash+MyQuery.cs_pm_cheq+MyQuery.cs_pm_dbcd+MyQuery.cs_pm_vouc, ",_.__")#</td></tr>
</td><td colspan="2"><hr /></td></tr>


</table>
</cfoutput>
	