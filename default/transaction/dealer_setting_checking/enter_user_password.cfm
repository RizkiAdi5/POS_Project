<html>
<head>
<title>Checking Password</title>
<link href="/stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<script type='text/javascript' src='../../../ajax/core/engine.js'></script>
<script type='text/javascript' src='../../../ajax/core/util.js'></script>
<script type='text/javascript' src='../../../ajax/core/settings.js'></script>

<script language="javascript">

	function check(){
		var password = document.check_password.password.value;
		if(password==''){
			document.getElementById('Check').disabled=true;
		}
		else{
			DWREngine._execute(_tranflocation, null, 'checkpassword', password, showresult);
		}	
	}
	
	function showresult(msg){
		if(msg != ''){
			alert(msg);
			document.getElementById('password').value='';
			document.getElementById('password').focus();
		}		
		else{
			document.getElementById('Check').disabled=false;
		}
	}

</script>
</head>

<body onLoad="javascript:document.getElementById('password').focus();">

<cfform name="check_password" action="" method="post">
	<table width="50%" align="center" class="data" border="0" cellpadding="1" cellspacing="0">
		<tr>
			<th>Credit Limit</th>
			<td><cfinput name="credit_limt" type="text" value="#numberformat(get_dealer_menu_info.credit_limit,',.00')#" disabled></td>
			<th>Outstanding</th>
			<td><cfinput name="credit_balance" type="text" value="#numberformat(get_dealer_menu_info.credit_balance,',.00')#" disabled></td>
		</tr>
		<tr>
			<td colspan="4"><div align="center"><b>Allow To Continue ?</b></div></td>
		</tr>
		<tr>
			<th colspan="2">Password</th>
			<td colspan="2"><input name="password" type="password" required="yes" message="Please Enter Security Code !" onblur="check();"></td>
		</tr>
		<tr>
			<td colspan="4" align="center">
				<input name="Check" type="submit" value="Check" disabled>
				<input name="Back" type="button" value="Back" onClick="javascript:history.back();history.back();">
			</td>
		</tr>
	</table>
	<cfloop list="#form.fieldnames#" index="a" delimiters=",">
		<cfinput name="#a#" type="hidden" value="#evaluate('form.#a#')#">
	</cfloop>
</cfform>

</body>
</html>