<cfif Hlinkams eq "Y">
	<html>
	<head>
	<title>Check Slave Status</title>
	<link rel="stylesheet" href="/stylesheet/menu.css"/>
	<script language="Javascript">
		var speed = 30000;
	
		function reload() 
		{
			window.location.reload();
		}
	
		setTimeout("reload()", speed);
	</script>
	</head>
	
	<body>
	<cfquery name="get_slavestatus" datasource="#dts#">
		show slave status
	</cfquery>
	
	<cfif get_slavestatus.slave_io_running eq "Yes" and get_slavestatus.slave_sql_running eq "Yes">
		<span>Link Status:<img src="/images/led_green.gif" align="texttop"></span>
	<cfelse>
		<span>Link Status:<img src="/images/led_red.gif" align="texttop"></span>
	</cfif>
	
	</body>
	</html>
<cfelse>
	<html>
	<head>
	<title>Check Slave Status</title>
	<link rel="stylesheet" href="/stylesheet/menu.css"/>
	</head>
	<body>
	</body>
	</html>
</cfif>