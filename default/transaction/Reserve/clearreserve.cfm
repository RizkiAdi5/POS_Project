<cfquery name="recalculateictran" datasource="#dts#">
Update reserve set status='Clear' where reserveno='#url.reserveno#'
</cfquery>

<cfquery name="updateamt" datasource="#dts#">
Update reservedet set status='Clear' where reserveno='#url.reserveno#'
</cfquery>


<script type="text/javascript">
    alert('Order Cleared');
	window.close();
	window.opener.location="s_Reservetable.cfm?type=icReserve.cfm";
</script>