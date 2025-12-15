<cfif isdefined("form.searchbatch") and form.searchbatch eq "Search #getGeneralInfo.lbatch# Item">
	<cfform name="done" action="selectbatch.cfm">		
		<cfif type1 eq "Edit">
			<cfinput type="hidden" name="bmode" value="search">
		<cfelse>
			<cfinput type="hidden" name="bmode" value="search">
		</cfif>
		<cfif isdefined("enterbatch1")>
			<cfinput type="hidden" name="enterbatch1" value="#listfirst(enterbatch1)#">
		</cfif>
		<cfinput type="hidden" name="comment" value="#form.comment#">
		<cfinput type="hidden" name="oldqty" value="#listfirst(oldqty)#">
		<cfinput type="hidden" name="oldlocation" value="#listfirst(oldlocation)#">
		<cfinput type="hidden" name="items" value="#listfirst(items)#">
		<cfinput type="hidden" name="hmode" value="#listfirst(hmode)#">
		<cfinput type="hidden" name="tran" value="#listfirst(tran)#">
		<cfinput type="hidden" name="type1" value="#listfirst(type1)#">
		<cfinput type="hidden" name="nexttranno" value="#listfirst(nexttranno)#">
		<cfinput type="hidden" name="itemcount" value="#listfirst(itemcount)#">
		<cfinput type="hidden" name="service" value="#listfirst(service)#">
		<cfinput type="hidden" name="agenno" value="#listfirst(agenno)#">
		<cfinput type="hidden" name="currrate" value="#listfirst(currrate)#">
		<cfinput type="hidden" name="refno3" value="#listfirst(refno3)#">
		<cfinput type="hidden" name="location" value="#listfirst(location)#">
		<cfinput type="hidden" name="oldenterbatch" value="#listfirst(enterbatch)#">		
		<cfinput type="hidden" name="mc1bil" value="#listfirst(mc1bil)#">
		<cfinput type="hidden" name="mc2bil" value="#listfirst(mc2bil)#">
		<cfinput type="hidden" name="sodate" value="#listfirst(sodate)#">
		<cfinput type="hidden" name="dodate" value="#listfirst(dodate)#">
		<cfinput type="hidden" name="expdate" value="#listfirst(expdate)#">
        <cfinput type="hidden" name="manudate" value="#listfirst(manudate)#">
		<cfinput type="hidden" name="batchqty" value="#listfirst(batchqty)#">
		<cfinput type="hidden" name="defective" value="#listfirst(defective)#">
		<cfinput type="hidden" name="newtrancode" value="#newtrancode#">
		<cfinput type="hidden" name="multilocation" value="#listfirst(multilocation)#">
		<cfinput type="hidden" name="nDateCreate" value="#listfirst(nDateCreate)#">
	</cfform>
	<script language="javascript" type="text/javascript">
		done.submit();
	</script>
</cfif>