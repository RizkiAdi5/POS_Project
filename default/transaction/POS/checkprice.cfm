<cfprocessingdirective pageencoding="UTF-8">
<cfset words_id_list = "65, 1302, 2132, 120, 1096, 2071">
<cfinclude template="/latest/words.cfm">

<html>
<head>
	<!---<link href="/SpryAssets/SpryCollapsiblePanel.css" rel="stylesheet" type="text/css" />--->
	<title>#words[2132]#</title>
	<!---<link href="/stylesheet/stylesheetPOS.css" rel="stylesheet" type="text/css">--->
    <!---<script type="text/javascript" src="/scripts/prototypenew.js" ></script>--->
    <script type="text/javascript" src="/scripts/jquery/jquery-1.10.2.min.js"></script>
	<script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>

	<script type="text/javascript">
	<!---function getprice(){
	<!---


	setTimeout("document.getElementById('itema').value = document.getElementById('hiditemno').value;",500);--->

	var updateurl = 'item.cfm?itemno='+document.getElementById('itemno').value;

<!---	ajaxFunction(document.getElementById('AjaxFielda'),updateurl);--->
		new Ajax.Request(updateurl,
      {
        method:'get',
        onSuccess: function(getdetailback){
		document.getElementById('AjaxFielda').innerHTML = trim(getdetailback.responseText);

        },
        onFailure: function(){
		alert('Error Retrieve'); },

		onComplete: function(transport){
		document.getElementById('itema').value = document.getElementById('hiditemno').value;
		document.getElementById('desp').value = document.getElementById('hiddesp').value + " - " + document.getElementById('hiddespa').value  ;
		document.getElementById('price').value = document.getElementById('hidprice').value;
        }
      })
	}

	function trim(strval)
	{
	return strval.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
	}
	--->
	function getItem(e){
		if(e.keyCode==13){
		var itemno = document.getElementById("itemno").value;
		$.ajax({
			type:"POST",
			url:"item1.cfm",
			data: {"itemno":itemno},
			dataType:"html",
			cache:false,
			success: function(result){
			$('#itemlist').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){
				if(document.getElementById('itema').value==""){
				<cfoutput>
				//alert("#words[2071]#");
				</cfoutput>
				document.getElementById('itema').value =document.getElementById("itemno").value;
				document.getElementById('desp').value ="-";
				document.getElementById('price').value ="-";
				}
				refreshlist();
			}
  		});
		}
	}

	function getItem2(){
		var itemno = document.getElementById("itemno").value;
		if(document.getElementById("itemno").value != ""){
		$.ajax({
			type:"POST",
			url:"item1.cfm",
			data: {"itemno":itemno},
			dataType:"html",
			cache:false,
			success: function(result){
			$('#itemlist').html(result);
			},
			error: function(jqXHR,textStatus,errorThrown){
			},
			complete: function(){
			if(document.getElementById('itema').value==""){
				<cfoutput>
				alert("#words[2071]#");
				</cfoutput>
				document.getElementById('itema').value =document.getElementById("itemno").value;
				document.getElementById('desp').value ="-";
				document.getElementById('price').value ="-";
				}
				refreshlist();
			}
  		});
		}
	}
	function refreshlist(){
		document.getElementById("itemno").value="";
	}
	</script>
    <style>
	body{
		background: #FFB6A3;
		color: black;
		margin: 100 0 0 0;
		padding: 0 0 0 0;
		overflow:hidden;
	}
    table {
  		border-spacing: 0.5rem;
	}

	tr{
		height:70px;
		}

	td {
  		padding: 0.5rem;
		font-size:34px;
	}
	th{
		background: #FFB6A3;
  			font-size:43px;
 			font-weight:400;
  			text-align:left;
  			padding:20px;
		}

		h1{
		color:#3892B0;
		font-size:94px;
		text-align:center;
		margin: 50px;
		font-weight:100;
		}
		#itemlist{
			width:1600px;
			height:400px;
			overflow:none;
			margin: 0 0 0 0;
			padding:0;
		}
		.bttn{
	margin:8px;
	padding:10px;
	width:25%;
	height:70px;
	border: 1px solid #CCC !important;
	font-family: "Lucida Grande", Geneva, Verdana, Arial, Helvetica, sans-serif;
    font-size: 28px;
	font-weight: bolder;
	color: #FFF;
	background-color: #3EA2C4;

}
    </style>

</head>

	<cfoutput>
    <body>
         <img alt="Netiquette POS Logo" style="position:absolute; margin:1% 0 0 80%;" src="/latest/img/POS.png" height="72" width="312"/>
          		<h1 align="center">#words[2132]#</h1>
						<table width="70%" align="center" >
								<tr height="100px">
                                	<th>#words[1302]# </th>
                                    <td colspan="3" style="background-color: ##FF4719;">
                                    	<input type="text" name="itemno"  style="font-size:66px" id="itemno" size="43"  onBlur="getItem2();" onKeyUp="getItem(event);" autofocus>
                                    </td>
								</tr>
                                <tr>
                                <th></th>
                                </tr>
                                <tr >
                                <th rowspan="4" colspan="4" height="350px" style="padding:0; margin:0;">
                                <div id="itemlist">
                                <center>
                                <table width="100%">
                                <tr>
									<td width="30%">#words[120]#</td>
                                    <td>:</td>
                                    <td><input type="text" name="itema" id="itema" style="font-size:50px; background-color:transparent; border:none;" disabled value=""></td>
								</tr>
								<tr>
									 <td width="30%">#words[65]#</td>
                                     <td>:</td>
									 <td><input type="text" name="desp" size="50" id="desp" style="font-size:50px; background-color:transparent; border:none;" disabled value=""></td>
								</tr>
								<tr>
									 <td width="30%">#words[1096]#</td>
                                     <td>:</td>
                                     <td><input type="text" name="price" id="price" style="font-size:50px; background-color:transparent; border:none;" disabled value=""></td>
                                </tr>
                                <tr align="center"><td colspan="3"><input type="button" class="bttn" name="close" value="Close Window" onclick="window.close();"></td></tr>
                                </table>
                                </center>
                                </div>
                                </th>
                                </tr>
							</table>
             </body>
	</cfoutput>
</html>

