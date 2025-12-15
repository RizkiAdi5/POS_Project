<cfif isdefined('url.refno') and isdefined('url.type')>
<cfset refno = urldecode(url.refno)>
<cfset type = url.type>
<html>
<head>
<title>Upload Document</title>
<link href="/scripts/uploadify.css" rel="stylesheet" type="text/css" media="screen" />
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/scripts/jquery-1.4.2.min.js"></script>
<script language="javascript" src="/scripts/swfobject.js"></script>
<script language="javascript" src="/scripts/jquery.uploadify.v2.1.0.min.js"></script>
<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
</head>
<body>
<cfoutput>
<h1>Upload Document #type#-#refno#</h1>
</cfoutput>
<table>
<tr>
<th>Browse Document</th>
<td><div id="uploadify"></div></td>
</tr>
</table>
<div id="uploadfilelist">
</div>
</body>
</html>
<script type="text/javascript">
ajaxFunction(document.getElementById('uploadfilelist'),'<cfoutput>uploadfilelist.cfm?refno=#url.refno#&type=#url.type#</cfoutput>');
</script>
<script language="javascript" type="text/javascript">
 
		$(document).ready(function() {
 
			
			$('#uploadify').uploadify({
			uploader: 'uploadify.swf',
				folder: '/download/<cfoutput>#dts#</cfoutput>/bill/<cfoutput>#type#/#refno#</cfoutput>',
				cancelImg: '/images/cancel.png',
				multi: true,
				auto: true,
				script: 'uploadify.cfm',
				displayData: 'percentage',
				simUploadLimit: 3,
				sizeLimit: 10000000,
				onError: function(event,queueID,fileObj,errorObj){alert('Upload Fail:'+errorObj.type+' : '+errorObj.info+', please contact system administrator');},
				onComplete: function(event, queueID, fileObj, response, data) {	
					var responsesplit = response.split('<');
					ajaxFunction(document.getElementById('uploadfilelist'),'<cfoutput>uploadfilelist.cfm?refno=#url.refno#&type=#url.type#</cfoutput>');
				}
			});
 
		});
 
	</script>
</cfif>