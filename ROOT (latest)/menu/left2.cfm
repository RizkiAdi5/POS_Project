<html>
<head>
<title>Menu</title>
<link rel="stylesheet" href="/stylesheet/menu.css"/>
<script type="text/javascript" src="/scripts/prototypenew.js" ></script>
<script type="text/javascript">
<!--
function popup(url) 
{
 params  = 'width='+screen.width;
 params += ', height='+screen.height;
 params += ', top=0, left=0, status=yes,menubar=no , location = no'
 params += ', fullscreen=yes,scrollbars=yes';

 newwin=window.open(url,'expressbill', params);
 if (window.focus) {newwin.focus()}
 return false;
}
// -->
</script>

<script language="javascript" type="text/javascript" src="/scripts/change_left_menu.js"></script>
</head>

<cfquery name="getgeneral" datasource="#dts#">
	select * from gsetup
</cfquery>

<body>

<div id="masterdiv">
	<cfinclude template="maintenance.cfm">
	
	<cfinclude template="transaction.cfm">
	
	<cfinclude template="print_bills.cfm">
	
	<cfinclude template="enquire.cfm">
	
	<cfinclude template="report.cfm">
	
	<cfinclude template="setup.cfm">
	
	<cfinclude template="crm.cfm">
	
	<cfinclude template="super_menu.cfm">
	
    
</div>

<iframe src="testslave.cfm" align="left" frameborder="0" scrolling="auto" width="150"></iframe>



</body>
</html>