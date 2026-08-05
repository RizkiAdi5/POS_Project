<html>
<head>
<title>Item Image</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

</head>
<body>

<cfoutput>
<cfif isdefined("form.picture")>
	<!--- Uploaded file only ever touches the OS temp dir (never the webroot) long enough to
	      read its bytes; it's deleted immediately and the image lives from here on only as
	      base64 handed back to product.cfm, which submits it into icitem.img_bytes/img_type. --->
	<cftry>
		<cfset tempDir = GetTempDirectory()>
		<cffile action="upload"
			filefield="picture"
			destination="#tempDir#"
			nameconflict="makeunique"
			accept="image/gif,image/jpeg,image/pjpeg,image/png,image/x-png"
			result="uploadResult"
		>
		<cfset tempFilePath = uploadResult.serverDirectory & "/" & uploadResult.serverFile>
		<cfset imgBytes = fileReadBinary(tempFilePath)>
		<cftry>
			<cffile action="delete" file="#tempFilePath#">
			<cfcatch type="any"></cfcatch>
		</cftry>
		<cfset imgExt = lCase(uploadResult.serverFileExt)>
		<cfset imgMime = "image/jpeg">
		<cfif imgExt eq "png"><cfset imgMime = "image/png"></cfif>
		<cfif imgExt eq "gif"><cfset imgMime = "image/gif"></cfif>
		<cfif imgExt eq "webp"><cfset imgMime = "image/webp"></cfif>
		<cfset imgBase64 = toBase64(imgBytes)>
	<cfcatch type="any">
        <script language="javascript" type="text/javascript">
		alert('File is not in image format');
		</script>
				<cfabort>
			</cfcatch>
		</cftry>

		<script language="javascript" type="text/javascript">
			window.opener.setPendingItemImage("#imgBase64#", "#imgMime#");
			window.close();
		</script>
	</cfif>
</cfoutput>

</body>
</html>
