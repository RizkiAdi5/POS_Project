<cfif #url.cid# EQ #dts#>

<cfdirectory
    action="list"
    directory="C:\NEWSYSTEM\IMS\images\#dts#"
    name="Files"
    recurse = "yes"
    filter="*.jpg|*.png|*.jpeg" />

	<cfif #files.recordCount# NEQ 0>
		<cfzip
    	action="zip"
    	source="C:\NEWSYSTEM\IMS\images\#dts#"
    	file="C:\NEWSYSTEM\IMS\images\#dts#images.zip"
		prefix="images/#dts#"
    	overwrite="true"
    />

	<cfheader name="Content-Disposition" value="attachment; filename=#dts#images.zip">
    <cfcontent type="application/zip" file="C:\NEWSYSTEM\IMS\images\#dts#images.zip">
	window.close();
	<cfelse>
	<script type='text/javascript'>
		alert("There is no item images from ims. Please upload image into ims system.");
		window.close();
	</script>
	</cfif>
</cfif>