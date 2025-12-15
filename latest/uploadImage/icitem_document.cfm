<cfsetting showdebugoutput="no">
<cfset thisPath = ExpandPath("/document/#dts#/*.*")>
<cfset thisDirectory = GetDirectoryFromPath(thisPath)>
<cfif DirectoryExists(thisDirectory) eq 'NO'>
	<cfdirectory action="create" directory="#thisDirectory#">
</cfif>
<html>
<head>
<title>Document</title>
<link href="../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

</head>
<body>

<cfoutput>
	<cfif isdefined("form.doc")>
		<cftry>
			<cffile action="upload" 
				filefield="doc" 
				destination="#thisDirectory#\#form.document_name#" 
				nameconflict="overwrite" 
				accept="application/*">
		<cfcatch type="any">
        <script language="javascript" type="text/javascript">
		alert('Wrong file format');
		window.close();
		</script>
				<cfabort>
			</cfcatch>
		</cftry>
		
		<script language="javascript" type="text/javascript">
			window.close();
		</script>
	<!---<cfelseif isdefined("url.pic2")>
		<img src="\document\#hcomid#\#url.pic2#" align="middle" width="150" height="150" onClick="parent.showpic(this)" >
	<cfelseif isdefined('url.pic3')>
		<img src="\images\#hcomid#\#url.pic3#" align="middle" width="150" height="150" onClick="parent.showpic(this)">--->
	</cfif>
</cfoutput>

<cfif isdefined('url.delete')>
<cfif FileExists("#HRootPath#\document\#hcomid#\#url.document#")>
   <cffile action="delete"
	   file="#HRootPath#\document\#hcomid#\#url.document#">
<cfelse>
   <p>Sorry, can't delete the file - it doesn't exist.</p>
</cfif>

</cfif>

</body>
</html>