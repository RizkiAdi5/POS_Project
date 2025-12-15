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
	<cfinclude template="../menu - Copy/maintenance.cfm">
	
	<cfinclude template="../menu - Copy/transaction.cfm">
	
	<cfinclude template="../menu - Copy/print_bills.cfm">
	
	<cfinclude template="../menu - Copy/enquire.cfm">
	
	<cfinclude template="../menu - Copy/report.cfm">
	
	<cfinclude template="../menu - Copy/setup.cfm">
	
	<cfinclude template="../menu - Copy/crm.cfm">
	
	<cfinclude template="../menu - Copy/super_menu.cfm">
	
    
    <cfif lcase(hcomid) eq "kjcpl_i" or lcase(hcomid) eq "mlpl_i" or lcase(hcomid) eq "kjctrial_i">
    <cfinclude template="../menu - Copy/alertmessage.cfm">
	</cfif>
	<cfif lcase(hcomid) eq "avt_i">
		<a href="http://www.netiquette.com.sg" target="_blank">
			<img src="/images/wos.jpg" width="120" height="50" BORDER="0" ALIGN="LEFT" alt="Netiquette Software">
		</a>
	</cfif>
</div>
<div style="position:relative; width:120px; height:60px;">
  <a href="https://www.teamviewer.com/link/?url=505374&id=625664214" style="text-decoration:none;">
    <img src="https://www.teamviewer.com/link/?url=979936&id=625664214" alt="TeamViewer for Remote Support" title="TeamViewer for Remote Support" border="0" width="120" height="50"></a></div>	
<!---<cfinclude template="/chatbox.cfm">--->
<cfif Hlinkams eq "Y">
<span>Link Status:<img src="/images/led_green.gif" align="texttop"></span>
</cfif>
<!---<iframe src="testslave.cfm" align="left" frameborder="0" scrolling="auto" width="150"></iframe>
--->

</body>
</html>