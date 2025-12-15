<cfsetting showdebugoutput="no">

	<cfquery name="getcustno" datasource="#dts#">
    	select substr(custno,6) as custno1,name from #target_apvend# where substr(custno,6) like "#url.suffix#%" and substr(custno,1,4) = "#url.prefix#"  ORDER BY created_on DESC limit 5
    </cfquery>
    

<cfoutput>
<cfif getCustno.recordcount neq 0 and len(url.suffix) neq 3 >
Lastest Five Used Supplier Numbers
</cfif>
<cfloop query="getcustno">
<br />#getcustno.custno1# - #getcustno.name#
</cfloop>
<cfif getCustno.recordcount eq 0 and len(url.suffix) eq 3 >
<br /> <font color="##FF0000">This Supplier Number Available</font>
<input type="hidden" name="cust_noApproval" id="cust_noApproval" value="1"  />
<cfelseif getCustno.recordcount eq 0>
<br /> No result Found
<input type="hidden" name="cust_noApproval" id="cust_noApproval" value="1"  />
<cfelseif getCustno.recordcount neq 0 and len(url.suffix) eq 3>
<br /><font color="##FF0000">This Supplier Number is Not Available</font>
<input type="hidden" name="cust_noApproval" id="cust_noApproval" value="0"  />
</cfif>
</cfoutput>