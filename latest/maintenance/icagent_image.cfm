<html>
<head>
<title>Item Image</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

</head>
<body>

<cfoutput>
	<cfif isdefined("form.photo")>
		<cftry>
			<cffile action="upload" 
				filefield="photo" 
				destination="#HRootPath#\billformat\#hcomid#\#form.photo_name#" 
				nameconflict="overwrite" 
				accept="image/gif,image/jpeg,image/pjpeg,image/png,image/x-png"
			>
        <script language="javascript" type="text/javascript">
		alert('File has been uploaded successfully');
		</script>  
		<cfcatch type="any">
        <script language="javascript" type="text/javascript">
		alert('File is not in image format');
		</script>
				<cfabort>
			</cfcatch>
		</cftry>
		
		<script language="javascript" type="text/javascript">
		window.opener.document.show_photo.location="icagent_image.cfm?pic2=#urlencodedformat(photo_name)#";
			window.close();
		</script>
	<cfelseif isdefined("url.pic2")>
		<img src="\billformat\#hcomid#\#url.pic2#" align="middle" width="150" height="150" onClick="parent.showpic(this)" >
	<cfelseif isdefined('url.pic3')>
		<img src="\billformat\#hcomid#\#url.pic3#" align="middle" width="150" height="150" onClick="parent.showpic(this)">
	</cfif>
</cfoutput>

<cfif isdefined('url.delete')>
<cfif FileExists("#HRootPath#\billformat\#hcomid#\#url.photo#")>
   <cffile action="delete"
	   file="#HRootPath#\billformat\#hcomid#\#url.photo#">
<cfelse>
   <p>Sorry, can't delete the file - it doesn't exist.</p>
</cfif>

</cfif>

</body>
</html>