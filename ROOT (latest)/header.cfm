<html>
<head>
<title>Web Order System</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> 
<STYLE>
{
	scrollbar-base-color: #FFFFFF
}
#foldheader 
{
	FONT-WEIGHT: bold; LIST-STYLE-IMAGE:  url(/Images/fold.jpg); CURSOR: hand
}

#foldinglist 
{
	FONT-WEIGHT: normal; LIST-STYLE-IMAGE:  url(/Images/list.gif); MARGIN-LEFT: 5px; TEXT-INDENT: 5px; MARGIN-RIGHT: 2px; TEXT-ALIGN: left
}

body{
	background-repeat: repeat;
	background-color: #C0CFE2;
	filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr='#FFFFFF', startColorstr='#C0CFE2', gradientType='0');
	
}

h6 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	line-height: 15px;
	color: #3366FF;
}

</STYLE>
<STYLE fprolloverstyle>A:hover {
	FONT-WEIGHT: bold; COLOR: #00b8f4; FONT-FAMILY: Tahoma; 
}
</STYLE>

<script type="text/javascript">
function alertUser(msg) {
alert(msg);
}
</script>

<SCRIPT language=JavaScript1.2>
	<!--
	var head="display:''"
	img1=new Image()
	img1.src="Images/fold.jpg"
	img2=new Image()
	img2.src="Images/open.jpg"

	function change()
	{
   		if(!document.all)
      		return
   		if (event.srcElement.id=="foldheader") 
   		{
      		var srcIndex = event.srcElement.sourceIndex
      		var nested = document.all[srcIndex+1]
      		if (nested.style.display=="none") 
	  		{
        	 	nested.style.display=''
         		event.srcElement.style.listStyleImage="url(Images/open.jpg)"
      		}
      		else 
	  		{
        		nested.style.display="none"
         		event.srcElement.style.listStyleImage="url(Images/fold.jpg)"
      		}
   		}
	}
	document.onclick=change
	//-->
	function MM_preloadImages() 
	{ //v3.0
  		var d=document; 
		if(d.images)
		{ 
			if(!d.MM_p) d.MM_p=new Array();
    			var i,j=d.MM_p.length,a=MM_preloadImages.arguments; 
				for(i=0; i<a.length; i++)
    				if (a[i].indexOf("#")!=0)
					{ 
						d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];
					}
		}
	}

	function MM_swapImgRestore() 
	{ //v3.0
  		var i,x,a=document.MM_sr; 
		for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) 
			x.src=x.oSrc;
	}

	function MM_findObj(n, d) 
	{ //v4.01
  		var p,i,x;  if(!d) d=document; 
		if((p=n.indexOf("?"))>0&&parent.frames.length) 
		{
			d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);
		}
  		if(!(x=d[n])&&d.all) 
			x=d.all[n]; 
			for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  				for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  					if(!x && d.getElementById) x=d.getElementById(n); return x;
	}

	function MM_swapImage()
	{ //v3.0
  		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
//-->
</SCRIPT>
</head>

	<cfquery name="getgeneral" datasource="#dts#">
		select * from gsetup
	</cfquery>

	<cfset date1 = dateadd('d',1,getgeneral.lastaccyear)>
    <cfset date2 = dateadd('m',getgeneral.period,getgeneral.lastaccyear)>
    
    <cfif getgeneral.lastlogin neq dateformat(now(),'yyyy-mm-dd') and dateformat(now(),'yyyy-mm-dd') gt date2>

    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="alertUser('Kindly Do Year End')">

    <cfelse>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</cfif>
<cfquery name="updatelastlogin" datasource="#dts#">
		update gsetup set lastlogin =<cfqueryparam cfsqltype="cf_sql_varchar" value="#dateformat(now(),'yyyy-mm-dd')#">
	</cfquery>
	<!--DWLayoutTable-->
	<cfif lcase(HcomID) eq "avt_i">
		<img src="billformat/AVT/logo.png" width="250" height="83" BORDER="0" ALIGN="LEFT" alt="Web Order System">
    <cfelseif lcase(HcomID) eq "fiatech_i">
        <img src="/images/fiatech_logo.jpg" width="198" height="62" BORDER="0" ALIGN="LEFT" alt="Web Order System">
    <cfelseif lcase(HcomID) eq "simplysiti_i">
        <img src="/images/simplysiti_i/simplysiti2.png" width="198" height="62" BORDER="0" ALIGN="LEFT" alt="Web Order System">
	<cfelse>
    <a href="changetable.cfm" target="_blank">
	    <img src="images/netiquette_logo.png" width="198" height="62" BORDER="0" ALIGN="LEFT" alt="Web Order System">
    </a>
	</cfif>
	<cfif getgeneral.menutype eq "H">
    <div align="right" style="float:right;">
    <cfinclude template="/chatbox.cfm">

</div>
	</cfif>
	<h6><div align="left">Welcome, <cfoutput>#HUserName#.Login On: #DayOfWeekAsString(DayOfWeek(Session.loginTime))#,  #DateFormat(Session.loginTime, "dd-mm-yyyy")#, #TimeFormat(Session.loginTime, "HH:MM:SS")#, IP Add: #cgi.REMOTE_ADDR#</cfoutput>
	
    <font face="Times New Roman, Times, serif" size="2" color="##3300FF"><cfoutput>Account Year #dateformat(date1,'DD-MM-YYYY')# to #dateformat(date2,'DD-MM-YYYY')#</cfoutput></font>
    
    <br><cfoutput><font face="Times New Roman, Times, serif" size="3" color="##3300FF">#getgeneral.compro# &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Company ID : #listgetat(dts,'1','_')#</font></cfoutput></div> 
    
	
    
	<cfif getgeneral.menutype eq "V">
	<div align="right">
		<a href="../newBody.cfm" target="mainFrame" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('homeBtn','','images/header/home2.png',1)"><img src="images/header/home.png" alt="Main Page" name="homeBtn" border="0"></a>
		<a href="../contact.cfm" target="mainFrame" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('contactBtn','','images/header/contactus2.png',1)"><cfif lcase(hcomid) neq "simplysiti_i"> <img src="images/header/contactus.png" alt="Contact Us!" name="contactBtn" border="0"></a></cfif>
         <a href="/feedback/feedback.cfm" target="mainFrame" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('feedbackBtn','','images/header/feedback.png',1)"><img src="images/header/feedback.png" alt="Feedback" name="feedbackBtn" border="0" width="100" height="23"></a>
		<a href="/ext/docs/" target="mainFrame" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('helpBtn','','images/header/help2.png',1)"><img src="images/header/help.png" alt="Help" name="helpBtn" border="0"></a>
		<a href="../logout.cfm" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('logoutBtn','','images/header/logout2.png',1)" target="_parent"><img src="images/header/logout.png" alt="Logging Off" name="logoutBtn" border="0"></a> 
  	</div>
	</cfif>
	</h6>
	<br>
</body>
</html>
<cfquery name="getgsetup" datasource="#dts#">
select * from gsetup
</cfquery>
<cfif getgsetup.autooutstandingreport eq 'Y'>
<script language="JavaScript">
window.open('default/enquires/outreport1.cfm?type=6&submit=1');
</script>
</cfif>