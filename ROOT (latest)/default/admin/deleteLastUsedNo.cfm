<cfquery name="delete" datasource="#dts#">
    DELETE FROM refnoset
    WHERE type = '#url.type#'
    AND counter = '#url.counter#'
</cfquery>
<!---
<script>
	window.close();
	window.opener.location="/default/admin/LastUsedNo.cfm";
</script>
	--->