<cfsetting showdebugoutput="no">

<cfquery name="getdepositdetail" datasource="#dts#">
select * from deposit where depositno='#url.depositno#'
</cfquery>

<cfoutput>
<input type="hidden" name="hidcash" id="hidcash" value="#numberformat(getdepositdetail.cs_pm_cash,',_.__')#" maxlength="35" size="40"/>
<input type="hidden" name="hidcheq" id="hidcheq" value="#numberformat(getdepositdetail.cs_pm_cheq,',_.__')#" maxlength="35" size="40"/>
<input type="hidden" name="hidcrcd" id="hidcrcd" value="#numberformat(getdepositdetail.cs_pm_crcd,',_.__')#" maxlength="35" size="40"/>
<input type="hidden" name="hidcrc2" id="hidcrc2" value="#numberformat(getdepositdetail.cs_pm_crc2,',_.__')#" maxlength="35" size="40"/>
<input type="hidden" name="hiddbcd" id="hiddbcd" value="#numberformat(getdepositdetail.cs_pm_dbcd,',_.__')#" maxlength="35" size="40"/>
<input type="hidden" name="hidvouc" id="hidvouc" value="#numberformat(getdepositdetail.cs_pm_vouc,',_.__')#" maxlength="35" size="40"/>
<input type="hidden" name="hidcctype1" id="hidcctype1" value="#getdepositdetail.cctype1#" maxlength="35" size="40"/>
<input type="hidden" name="hidcctype2" id="hidcctype2" value="#getdepositdetail.cctype2#" maxlength="35" size="40"/>
<input type="hidden" name="hidchequeno" id="hidchequeno" value="#getdepositdetail.chequeno#" maxlength="35" size="40"/>

</cfoutput>
