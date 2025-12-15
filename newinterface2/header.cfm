<cfsetting enablecfoutputonly="no"> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Testing</title>
<link rel="shortcut icon"
 href="/IMS.ico" />
<link rel="stylesheet" type="text/css" href="css1.css" />
</head>

<body class="netiquette">
<cfquery name="getgeneral" datasource="#dts#">
		select * from gsetup
	</cfquery>
    <cfquery name="getlanguage" datasource="main">
        select * from menulang
</cfquery>
<cfset date1 = dateadd('d',1,getgeneral.lastaccyear)>
    <cfset date2 = dateadd('m',getgeneral.period,getgeneral.lastaccyear)>
<cfset menutitle=StructNew()>
<cfloop query="getlanguage">
<cfif getgeneral.dflanguage eq 'english'>
<cfset menutitle['#getlanguage.no#']=getlanguage.eng>
<cfelseif getgeneral.dflanguage eq 'sim_ch'>
<cfset menutitle['#getlanguage.no#']=getlanguage.sim_ch>
<cfelseif getgeneral.dflanguage eq 'tra_ch'>
<cfset menutitle['#getlanguage.no#']=getlanguage.tra_ch>
</cfif>
</cfloop>
<div class="header" style="height:130px; width:100%">


    <div class="company_logo" style="width:18%; text-align:center; height:70%">
    <a onclick="window.open('/changetable.cfm')" onMouseOver="this.style.cursor='hand';">
    <img style="text-align:center; margin-top:5%" width="90%" src="Netiqutte-01.png" />
    </a>
    </div>


        <div class="header_title"><cfoutput>#getgeneral.compro# &nbsp;&nbsp;
        (Company ID : #listgetat(dts,'1','_')#)<br />
		<cfoutput><small><font style="font-weight:bolder;">Welcome, #HUserName#. </font><br />
		<font size="-4" style="letter-spacing:0px">Login On: #DayOfWeekAsString(DayOfWeek(Session.loginTime))#,
		#DateFormat(Session.loginTime, "dd-mm-yyyy")#, #TimeFormat(Session.loginTime, "HH:MM:SS")#&nbsp;
		(IP Add:#cgi.REMOTE_ADDR#)&nbsp; &nbsp;Account Year #dateformat(date1,'DD-MM-YYYY')# to #dateformat(date2,'DD-MM-YYYY')#</small></cfoutput></cfoutput></font>
		</div>
        <div class="header_corner" style="float:right">
        <div class="block">
        <table width="100%">
        <tr style="	background: #828282;
		background: -moz-linear-gradient(top, #828282 0%, #4D4D4D 100%);
    	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#828282), color-stop(100%,#4D4D4D));
    	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#828282', endColorstr='#4D4D4D',GradientType=0 );">
    	<td width="14%"><a href="/newBody2.cfm" target="mainFrame">HOME</a></td>
        <td width="28%" nowrap="nowrap"><a href="/contact.cfm" target="mainFrame">CONTACT US</a></td>
        <td width="24%"><a href="/feedback/feedback.cfm" target="mainFrame">FEEDBACK</a></td>
        <td width="14%"><a href="/ext/docs/" target="mainFrame">HELP</a></td>
         <td width="20%"><a href="/logout.cfm" target="_parent">LOGOUT</a></td></tr>
         </table>
         <table align="right">
         <tr style="border:0px; background-color:transparent; margin-right:0">
         <td style=" text-align:right;-webkit-column-span:all; column-span:all;float:right; border:0px; background-color:transparent; margin:0px 0px 0 0;">
         <img src="imslogo2.png" />
         </td></tr>
        </table>
        </div>
        </div>
     

<div class="menu">
<table align="left" style="margin-left:30px; float:left">
<cfif getpin2.h1000 eq "T"><td><a style="width:125px" href="/menunew2/maintenance.cfm" target="leftFrame"><img src="maintenance2.ico" style="float:left; vertical-align:middle; border:none" /><cfoutput>#menutitle[1]#</cfoutput></a></td></cfif>
<cfif getpin2.h2000 eq "T">
<td><a style="width:130px" href="/menunew2/transaction.cfm" target="leftFrame"><img src="transaction.ico" style="float:left; vertical-align:middle; border:none" /><cfoutput>#menutitle[41]#</cfoutput></a></td></cfif>
<cfif getpin2.h3000 eq "T"><td><a href="/menunew2/enquire.cfm" target="leftFrame"><img src="enquire.ico" style="float:left; vertical-align:middle; border:none" /><cfoutput>#menutitle[78]#</cfoutput></a></td></cfif>
<cfif getpin2.h4000 eq "T">
<td><a href="/menunew2/report.cfm" target="leftFrame"><img src="report.ico" style="float:left; vertical-align:middle; border:none" /><cfoutput>#menutitle[88]#</cfoutput></a></td></cfif>
<cfif getpin2.h5000 eq "T">
<td><a style="width:135px" href="/menunew2/setup.cfm" target="leftFrame"><img src="setup.ico" style="float:left; vertical-align:middle; border:none" /><cfoutput>#menutitle[104]#</cfoutput></a></td></cfif>
<cfif husergrpid eq "Super">
<td><a href="/menunew2/super_menu.cfm" target="leftFrame">Super Menu</a></td></cfif>
</table>
</div>
</div>


</body>
</html>
