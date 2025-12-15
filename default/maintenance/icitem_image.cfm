<cfset thisPath = ExpandPath("/images/#dts#/*.*")>
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
	<cfif isdefined("form.picture")>
		<cftry>
			<cffile action="upload" 
				filefield="picture" 
				destination="#thisDirectory#\#form.picture_name#" 
				nameconflict="overwrite" 
				accept="image/*"
			>
		<cfcatch type="any">
        <script language="javascript" type="text/javascript">
		alert('File is not in image format');
		</script>
				<cfabort>
			</cfcatch>
		</cftry>
		
		<script language="javascript" type="text/javascript">
			window.opener.document.show_picture.location="icitem_image.cfm?pic2=#urlencodedformat(picture_name)#";
			window.close();
		</script>
	<cfelseif isdefined("url.pic2")>
		<img src="\images\#hcomid#\#url.pic2#" align="middle" width="150" height="150" onClick="parent.showpic(this)" >
	<cfelseif isdefined('url.pic3')>
		<img src="\images\#hcomid#\#url.pic3#" align="middle" width="150" height="150" onClick="parent.showpic(this)">
	</cfif>
</cfoutput>

<cfif isdefined('url.delete')>
<cfif FileExists("#HRootPath#\images\#hcomid#\#url.picture#")>
   <cffile action="delete"
	   file="#HRootPath#\images\#hcomid#\#url.picture#">
<cfelse>
   <p>Sorry, can't delete the file - it doesn't exist.</p>
</cfif>

</cfif>

</body>
</html>