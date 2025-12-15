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
				destination="#HRootPath#\billformat\#hcomid#\#form.picture_name#" 
				nameconflict="overwrite" 
				accept="image/*"
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
		window.opener.document.show_picture.location="icagent_image.cfm?pic2=#urlencodedformat(picture_name)#";
			window.close();
		</script>
	<cfelseif isdefined("url.pic2")>
		<img src="\billformat\#hcomid#\#url.pic2#" align="middle" width="150" height="150" onClick="parent.showpic(this)" >
	<cfelseif isdefined('url.pic3')>
		<img src="\billformat\#hcomid#\#url.pic3#" align="middle" width="150" height="150" onClick="parent.showpic(this)">
	</cfif>
</cfoutput>

<cfif isdefined('url.delete')>
<cfif FileExists("#HRootPath#\billformat\#hcomid#\#url.picture#")>
   <cffile action="delete"
	   file="#HRootPath#\billformat\#hcomid#\#url.picture#">
<cfelse>
   <p>Sorry, can't delete the file - it doesn't exist.</p>
</cfif>

</cfif>

</body>
</html>