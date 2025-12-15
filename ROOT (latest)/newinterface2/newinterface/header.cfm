<cfsetting enablecfoutputonly="no"> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Testing</title>
<link rel="shortcut icon"
 href="http://ams3.netiquette.com.sg/aMS.ico" />
<link rel="stylesheet" type="text/css" href="css1.css" />

<SCRIPT language= "JavaScript1.2">

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</SCRIPT>
<script language="JavaScript">

function forcelogout() {
		 alert('Logging Out AMS System');
		 var win = self.open("logout.cfm");
    	
}
</script>


</head>

<body class="openerp">
<cfquery datasource="#dts#" name="getgsetup">
select * from gsetup
</cfquery>

<cfset date1 = dateadd('d',1,getgsetup.lastaccyear)>
<cfset date2 = dateadd('m',getgsetup.period,getgsetup.lastaccyear)>
<cfquery name="getgeneral" datasource="#dts#">
		select * from gsetup
	</cfquery>
    <cfquery name="getlanguage" datasource="#main#">
        select * from menu
</cfquery>

<cfset menutitle=StructNew()>
<cfloop query="getlanguage">
<cfif getgeneral.dflanguage eq 'english'>
<cfset menutitle['#getlanguage.menu_id#']=getlanguage.menu_name>
<cfelseif getgeneral.dflanguage eq 'sim_ch'>
<cfset menutitle['#getlanguage.menu_id#']=getlanguage.sim_ch>
<cfelseif getgeneral.dflanguage eq 'tra_ch'>
<cfset menutitle['#getlanguage.menu_id#']=getlanguage.tra_ch>
</cfif>
</cfloop>
<table width="100%" class="header">
<tr>
<td class="company_logo" ></td>
<td class="header_title"><cfoutput>#getgeneral.compro# &nbsp;&nbsp;
        (Company ID : #listgetat(dts,'1','_')#)</cfoutput><br />
		<cfoutput><small><font style="font-weight:bolder;">Welcome, #HUserName#. </font><br />
		<font size="-4" style="letter-spacing:0px">Login On: #DayOfWeekAsString(DayOfWeek(Session.loginTime))#,
		#DateFormat(Session.loginTime, "dd-mm-yyyy")#, #TimeFormat(Session.loginTime, "HH:MM:SS")#&nbsp;
		(IP Add:#cgi.REMOTE_ADDR#)</font></small></cfoutput></td>
        <td class="header_corner" align="right" style="vertical-align:top">
        <table class="block" align="right" width="100%">
        <tr style="	background: #828282;
		background: -moz-linear-gradsient(top, #828282 0%, #4D4D4D 100%);
    	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#828282), color-stop(100%,#4D4D4D));
    	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#828282', endColorstr='#4D4D4D',GradientType=0 );">
    	<td align="center"><a href="/newBody.cfm" target="mainFrame">HOME</a></td>
        <td align="center" nowrap="nowrap"><a href="/contact.cfm" target="mainFrame">CONTACT US</a></td>
        <td align="center"><a href="/feedback/feedback.cfm" target="mainFrame">FEEDBACK</a></td>
        <td align="center"><a href="/ext/docs/" target="mainFrame">HELP</a></td>
         <td align="center"><a href="/logout.cfm" target="_parent">LOGOUT</a></td></tr>
         <tr align="right" style="text-align:right">
       <td align="right" colspan="5" style="-webkit-column-span:all; /* Chrome */
column-span:all;text-align:right;border:0px none">

         <img style="float:right; text-align:right" src="amslogo.png" />
         </td></tr></table></td>
</tr>

     
        

<tr align="left" style="width:100%;">

<td class="menu" style="float:left; padding-left:22%" align="left">
<cfquery datasource="#main#" name="getmenu1">
 SELECT * FROM menu as a left join #dts#.userpin as b on a.menu_id = b.menu_id
 where a.menu_level= '1'
<cfif husergrpid eq "super">
 and pin0='T'
<cfelseif husergrpid eq "admin">
 and pin1='T'
<cfelseif husergrpid eq "guser">
 and pin2='T'
<cfelseif husergrpid eq "luser">
 and pin3='T'
<cfelseif husergrpid eq "muser">
 and pin4='T'
<cfelseif husergrpid eq "suser">
 and pin5='T'
</cfif>
order by a.menu_order
</cfquery>
<table align="left">
<cfloop query="getmenu1">
<td><a href="<cfoutput>#getmenu1.menu_url#</cfoutput>" target="leftFrame">
<cfoutput>#menutitle['#getmenu1.menu_id#']#</cfoutput></a></td>
</cfloop>
</table>


</td>
</tr>
</table>

</body>
</html>
