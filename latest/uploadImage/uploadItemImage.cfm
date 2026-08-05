<script language="JavaScript">

	function uploading_picture(pic_name)
	{
		var new_pic_name1 = new String(pic_name);
		var new_pic_name2 = new_pic_name1.split(/[-,/,\\]/g);
		document.getElementById("picture_name").value=new_pic_name2[new_pic_name2.length-1];

	}
</script>


<form name="uploadItemImage" action="icitem_image.cfm" method="post" enctype="multipart/form-data" target="_self">
	<table class="data" align="center" width="500px">
		<tr>
        	<th height='20' colspan='8'>
            	<div align='center'>
                	<strong>Upload Item's Image</strong>
                    <br />
                    <br />
                </div>
            </th>
      	</tr>
		<tr>
			<td align="center">
				<input type="file" id="picture" name="picture" size="50" onChange="uploading_picture(this.value);" accept="image/gif,image/jpeg,image/tiff,image/x-ms-bmp,image/x-photo-cd,image/x-png,image/x-portable-greymap,image/x-portable-pixmap,image/x-portablebitmap">
				<br/>
				<input type="text" id="picture_name" name="picture_name" size="50" value="">&nbsp;
				<input type="submit" name="Upload" value="Upload">
			</td>
		</tr>
	</table>
</form>
