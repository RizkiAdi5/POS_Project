<cfparam name="invset" default="1">
<html>
<head>
<title>Update Main Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../stylesheet/stylesheet.css" rel="stylesheet" type="text/css">

<link href="/scripts/CalendarControl.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" src="/scripts/CalendarControl.js"></script>

<script type="text/javascript">

function searchRecord(){
	var t1=document.itemform.t1.value;
	var t2=document.itemform.t2.value;
	var invset=document.itemform.invset.value;
	var datefrom = document.itemform.datefrom.value;
	var dateto = document.itemform.dateto.value;
	
	document.getElementById('itemframe').src = 's_update2.cfm?t1=' + t1 + '&t2=' + t2 + '&invset=' + invset + '&datefrom=' + datefrom + '&dateto=' + dateto;
} 
</script>

</head>
<body>
<cfif url.t2 eq "INV">
	<h1>Update to Invoice</h1>
	<cfset ptype = "Customer">
	
	<cfif url.t1 eq "SO">
		<cfset type = "Sales Order">
	</cfif>
</cfif>
<hr>

<form name="itemform">
	<cfoutput>
	<input type="hidden" name="t1" value="#url.t1#">
	<input type="hidden" name="t2" value="#url.t2#">
	<input type="hidden" name="invset" value="#invset#">
	<input type="text" name="datefrom" value="#dateformat(now(),"dd/mm/yyyy")#" size="15">
	<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(datefrom);"> 
	To 
	<input type="text" name="dateto" value="#dateformat(now(),"dd/mm/yyyy")#" size="15">
	<img src="/images/cal.gif" width=17 height=15 border=0 onClick="showCalendarControl(dateto);">&nbsp;&nbsp;
	</cfoutput>
	<input type="button" value="Go" onclick="searchRecord();">
</form>
<cfoutput><iframe align="middle" scrolling="auto" frameborder="0" width="100%" height="700" src="s_update2.cfm?t1=#url.t1#&t2=#url.t2#&invset=#invset#" id="itemframe"></iframe></cfoutput>
</body>
</html>
