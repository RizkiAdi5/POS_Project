
<cfquery name="getvoucher" datasource="#dtssync#">
	select * from voucher where (used='' or used is null) and DATEDIFF(now(),created_on)<=365 and voucherno=<cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDECODE(url.voucherno)#">
</cfquery>

<cfoutput>
<cfif getvoucher.recordcount neq 0>
<input type="hidden" name="hidsinglevouc" id="hidsinglevouc" value="#val(getvoucher.value)#" />

<cfelse>
<h3>Voucher No Not Found</h3>
<input type="hidden" name="hidsinglevouc" id="hidsinglevouc" value="0" />
</cfif>

</cfoutput>
