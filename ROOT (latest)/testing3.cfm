<html> 
<head> 
    <title>Progress Bar</title> 
     <meta charset="utf-8">
  	 <meta name="viewport" content="width=device-width, initial-scale=1">
     <script type="text/javascript" src="/latest/js/bootstrap/bootstrap.min.js"></script>
     <script type="text/javascript" src="/latest/js/jquery/jquery-1.10.2.min.js"></script>
     <script language="javascript" type="text/javascript" src="/scripts/ajax.js"></script>
     <link rel="stylesheet" type="text/css" href="/latest/css/bootstrap/bootstrap.min.css" />
     <script>
	 
	window.setInterval(function () {
		var pcent= 20;
    $.ajax({
						type:"POST",
						url:"testing1.cfm",
						data: {"pcent":pcent},
						dataType:"html",
						cache:false,
						success: function(result){
							$('#abcd').html(result);
						},
						error: function(jqXHR,textStatus,errorThrown){
						},
						complete: function(){
						}
					});
	}, 3000);
     </script>   
</head> 
 
<body> 
<h1>POS sync Completed:</h1> 

<cfflush interval=10000> 

<div class="container">
  <h2>Progress Bar With Label</h2>
  <div class="progress" id="abcd">
 
    <div id="progressbardiv" class="progress-bar" role="progressbar" aria-valuenow="#i#" aria-valuemin="0" aria-valuemax="100" style="width: #i#%">
                 #i#          
    </div>
  </div>
</div>

</body> 
</html>