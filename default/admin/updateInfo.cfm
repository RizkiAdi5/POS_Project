
<cfset value = "">
<cfset tabchr = Chr(13) & Chr(10)> 

<cfquery name="getpreviousdata" datasource="#dts#">
    select #url.fieldname# as changefield from refnoset
    where type = '#url.type#'
    and counter = '#url.counter#'
</cfquery>



<cfquery name="update" datasource="#dts#">
    update refnoset 
    set #url.fieldname# = UPPER('#fieldvalue#')
    where type = '#url.type#'
    and counter = '#url.counter#'
</cfquery>




<!---
<script>
	window.close();
	window.opener.location="/default/admin/LastUsedNo.cfm";
</script>--->
	