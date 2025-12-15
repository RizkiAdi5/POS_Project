<cfsetting showdebugoutput="no">
<cfquery datasource="#dts#" name="getmodule">
	select * from modulecontrol
</cfquery>

<cfquery datasource="#dts#" name="getgsetup">
	select bcurr,ASACTP
    from gsetup
</cfquery>


<cfquery name="getdealer_menu" datasource="#dts#">
	select custSuppSortBy,productSortBy,transactionSortBy from dealer_menu limit 1
</cfquery>

<cfif url.type eq 'SAM'>
    <cfquery name="getInfo" datasource="#dts#">
		select custno,name,name2,add1,add2,add3,add4,ngst_cust,taxcode,attn,phone,fax,term,agent,contact,currcode,phonea,e_mail,taxincl_cust,country,postalcode,daddr1,daddr2,daddr3,daddr4,dattn,dphone,dfax,d_country,d_postalcode,end_user,dispec1,dispec2,dispec3,country,d_country,gstno,phonea from #target_apvend#
		where custno = '#url.custno#'
        union all
        select custno,name,name2,add1,add2,add3,add4,ngst_cust,taxcode,attn,phone,fax,term,agent,contact,currcode,phonea,e_mail,taxincl_cust,country,postalcode,daddr1,daddr2,daddr3,daddr4,dattn,dphone,dfax,d_country,d_postalcode,end_user,dispec1,dispec2,dispec3,country,d_country,gstno,phonea from #target_arcust#
		where custno = '#url.custno#'
	</cfquery>
    <cfelse>
	<cfquery name="getInfo" datasource="#dts#">
		select * from #url.tablename#
		where custno = '#url.custno#'
	</cfquery>
    </cfif>
<cfoutput>
<input type="hidden" name="hidb_name" id="hidb_name" value="#getInfo.name#" />
<input type="hidden" name="hidb_name2" id="hidb_name2" value="#getInfo.name2#" />
<input type="hidden" name="hidb_add1" id="hidb_add1" value="#getInfo.add1#" />
<input type="hidden" name="hidb_add2" id="hidb_add2" value="#getInfo.add2#" />
<input type="hidden" name="hidb_add3" id="hidb_add3" value="#getInfo.add3#" />
<input type="hidden" name="hidb_add4" id="hidb_add4" value="#getInfo.add4#" />
<input type="hidden" name="hidb_add5" id="hidb_add5" value="#getInfo.country# #getInfo.postalcode#" />
<input type="hidden" name="hidb_attn" id="hidb_attn" value="#getInfo.attn#" />
<input type="hidden" name="hidb_phone" id="hidb_phone" value="#getInfo.phone#" />
<input type="hidden" name="hidb_phonea" id="hidb_phonea" value="#getInfo.phonea#" />
<input type="hidden" name="hidngst_cust" id="hidngst_cust" value="#getInfo.ngst_cust#" />
<input type="hidden" name="hidtaxcode" id="hidtaxcode" value="#getInfo.taxcode#" />
<input type="hidden" name="hidb_fax" id="hidb_fax" value="#getInfo.fax#" />
<input type="hidden" name="hidterm" id="hidterm" value="#getInfo.term#" />
<input type="hidden" name="hidagent" id="hidagent" value="#getInfo.agent#" />

<input type="hidden" name="hiddispec1" id="hiddispec1" value="#getInfo.dispec1#" />
<input type="hidden" name="hiddispec2" id="hiddispec2" value="#getInfo.dispec2#" />
<input type="hidden" name="hiddispec3" id="hiddispec3" value="#getInfo.dispec3#" />
<cfif trim(getInfo.currcode) NEQ ''>
	<input type="hidden" name="hidcurrcode" id="hidcurrcode" value="#getInfo.currcode#" />
<cfelse>
	<input type="hidden" name="hidcurrcode" id="hidcurrcode" value="#getgsetup.bcurr#" />
</cfif>
<input type="hidden" name="hidphonea" id="hidphonea" value="#getInfo.phonea#" />
<input type="hidden" name="hide_mail" id="hide_mail" value="#getInfo.e_mail#" />
<input type="hidden" name="hidtaxincl_cust" id="hidtaxincl_cust" value="#getInfo.taxincl_cust#" />

<input type="hidden" name="hidd_name" id="hidd_name" value="#getInfo.name#" />
<input type="hidden" name="hidd_name2" id="hidd_name2" value="#getInfo.name2#" />

<input type="hidden" name="hidd_add1" id="hidd_add1" value="#getInfo.daddr1#" />
<input type="hidden" name="hidd_add2" id="hidd_add2" value="#getInfo.daddr2#" />
<input type="hidden" name="hidd_add3" id="hidd_add3" value="#getInfo.daddr3#" />
<input type="hidden" name="hidd_add4" id="hidd_add4" value="#getInfo.daddr4#" />
<input type="hidden" name="hidd_add5" id="hidd_add5" value="#getInfo.country# #getInfo.postalcode#" />
<input type="hidden" name="hidd_attn" id="hidd_attn" value="#getInfo.dattn#" />
<input type="hidden" name="hidd_phone" id="hidd_phone" value="#getInfo.dphone#" />
<input type="hidden" name="hidd_fax" id="hidd_fax" value="#getInfo.dfax#" />
<input type="hidden" name="hidcontact" id="hidcontact" value="#getInfo.contact#" />
<input type="hidden" name="hidpostalcode" id="hidpostalcode" value="#getInfo.postalcode#" />

<input type="hidden" name="hidgstno" id="hidgstno" value="#getInfo.gstno#" />
<input type="hidden" name="hidgstno" id="hidgstno" value="#getInfo.gstno#" />

<input type="hidden" name="hidcountry" id="hidcountry" value="#getInfo.country#" />
<input type="hidden" name="hidd_country" id="hidd_country" value="#getInfo.d_country#" />

<cfif getgsetup.ASACTP eq "Y">
<input type="hidden" name="hidDCode" id="hidDCode" value="Profile" />
<cfelse>
<input type="hidden" name="hidDCode" id="hidDCode" value="" />
</cfif>
 <cfquery name="getcurrrate" datasource="#dts#">
    SELECT currrate FROM #target_currency# where currcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getInfo.currcode#" >
    </cfquery>

    <cfif getcurrrate.currrate neq "">
    <input type="hidden" name="hidcurrrate" id="hidcurrrate" value="#getcurrrate.currrate#" />
    <cfelse>
    <input type="hidden" name="hidDCode" id="hidcurrrate" value="1" />
	</cfif>


</cfoutput>
