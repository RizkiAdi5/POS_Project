<cfset thisPath = ExpandPath("/billformat/#dts#/*.*")>
<cfset thisDirectory = GetDirectoryFromPath(thisPath)>
<cfif DirectoryExists(thisDirectory) eq 'NO'>
	<cfdirectory action="create" directory="#thisDirectory#">
</cfif>
<html>
<head>
<title>Item Image</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

</head>
<body>

<cfoutput>
	<cfif isdefined("form.formatlogo")>
		<cftry>
			<cffile action="upload" 
				filefield="formatlogo" 
				destination="#thisDirectory#\companyLogo.jpg" 
				nameconflict="overwrite" 
				accept="image/gif,image/jpeg,image/pjpeg,image/png,image/x-png"
			>
		<cfcatch type="any">
        <script language="javascript" type="text/javascript">
		alert('File is not in image format');
		</script>
				<cfabort>
			</cfcatch>
		</cftry>
		
		<script language="javascript" type="text/javascript">
			window.opener.location.reload();
			window.close();
		</script>
        </cfif>
</cfoutput>

</body>
</html>