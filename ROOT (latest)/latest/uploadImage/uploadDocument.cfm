<script language='JavaScript'>
	function uploading_document(doc_name)
	{
		var new_doc_name1 = new String(doc_name);
		var new_doc_name2 = new_doc_name1.split(/[-,/,\\]/g);
		document.getElementById("document_name").value=new_doc_name2[new_doc_name2.length-1];

	}

		function addOption(doc_name){
		    window.opener.GetValueFromChild("Doc",doc_name);

<!---		  if(detection!=1){
			  var a=new Option(doc_name,doc_name);
			  window.opener.document.getElementById("document_available").options[window.opener.document.getElementById("document_available").length]=a;
		  }--->
		  return true;
		  window.close('/latest/uploadImage/uploadDocument.cfm');
	}

</script>

<form name="uploadDocumentForm" action="icitem_document.cfm" method="post" enctype="multipart/form-data" target="_self">
	<table class="data" align="center" width="500px">
		<tr>
        	<th height='20' colspan='8'>
            	<div align='center'>
                	<strong>Upload Document</strong>
                </div>
            </th>
      	</tr>
		<tr>
			<td align="center">
				<input type="file" id="doc" name="doc" size="50" onChange="uploading_document(this.value);" accept="application/msword,application/excel">
				<br/>
				<input type="text" name="document_name" id="document_name" size="50" value="">&nbsp;
                <input type="submit" name="Upload" value="Upload" onClick="javascript:return addOption(document.getElementById('document_name').value);">
			</td>
		</tr>
	</table>
</form>