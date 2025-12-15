<!---DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd"--->
<cfquery name="getgeneral" datasource="#dts#">
	select * from gsetup
</cfquery>

<cfif getgeneral.interface eq 'old'>
<html>
<head>
<title>Inventory Management System</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<base target="mainFrame">

<cfif getgeneral.menutype eq "V">
	<cfif HUserGrpID eq 'muser'>
		<cflocation url="home2.cfm">
	<cfelse>

	<body style="overflow:hidden;margin:0;padding:0;border:0">
	<iframe name="ifr" id="ifr" style="position:absolute;width:100%;height:100%;left:0px;top:0px" src="frameset2.cfm"></iframe>
	</cfif>
<cfelseif getgeneral.menutype eq "H">
	<body style="overflow:hidden;margin:0;padding:0;border:0" onload="Pop_Go();">
	
	<cfif HUserGrpID eq 'muser'>
		<cflocation url="home2.cfm">
	<cfelse>
		<iframe name="ifr" id="ifr" style="position:absolute;width:100%;height:100%;left:0px;top:0px" src="frameset.cfm"></iframe>
	</cfif>

	<!--- Scripts for the 7.00 HV Pop menu --->
	<script type='text/javascript'>
		function Pop_Go(){return}
		function PopMenu(a,b){return}
		function OutMenu(a){return}
	</script>
	
	<cfinclude template="dropdownmenu/exmplmenu2super_var.cfm">
	
	<script type='text/javascript' src='dropdownmenu/menu5_com.js'></script>
	<cfsetting showdebugoutput="no">
	</body>	
</cfif>

<cfquery name="check" datasource="main">
	select * from startupwarning
	where (comid='#dts#' or comid='all')
	limit 1
</cfquery>
<cfif check.recordcount neq 0 and (check.message neq "" or check.details neq "")>
	<cfinclude template="startupwarning.cfm">
</cfif>
</html>

<cfelse>

<script type='text/javascript'>
		function Pop_Go(){return}
		function PopMenu(a,b){return}
		function OutMenu(a){return}
	</script>
    <cfinclude template="dropdownmenu/exmplmenu2super_var.cfm">
	
	<script type='text/javascript' src='dropdownmenu/menu5_com.js'></script>
	<cfsetting showdebugoutput="no">
<html>
<head>
<title>Inventory Management System</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
</head>
<link rel="shortcut icon" href="/IMS.ico" />

<frameset id="frameset1" cols="218px,*" border="0">
    <frame frameborder="no" id="leftFrame" name="leftFrame" noresize="noresize" scrolling="no" src="/latest/side/sidemenu.cfm" />
    <frameset id="frameset2" rows="68px,*" border="0">
        <frame frameborder="no" id="topFrame" name="topFrame" noresize="noresize" scrolling="no" src="/latest/header/header.cfm" />
        <frame frameborder="no" id="mainFrame" name="mainFrame" noresize="noresize" scrolling="yes" src="/latest/body/overview.cfm" />
    </frameset>
</frameset>

<noframes>Sorry, please use browser with support frameset while using this system.</noframes>
</html>
</cfif>